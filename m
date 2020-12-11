Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9412D6F19
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 05:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395337AbgLKEWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 23:22:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60993 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395318AbgLKEWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 23:22:24 -0500
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1knZw6-0001Ii-Lw
        for netdev@vger.kernel.org; Fri, 11 Dec 2020 04:21:42 +0000
Received: by mail-pf1-f198.google.com with SMTP id e68so5541234pfe.4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 20:21:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tPXZ+7QAQmRj9Gg0uL9q/qwGUoI81azIs/Hz+gXLnNo=;
        b=oU9TUGyPzW0YIUv6BZxpXC+aCizcPGBG4fzbDPy2xYmM/nsqs74mqKuQlblNHIFius
         lLaAlVJ5ufj8JhC7Vti38+jHMRv7cvcaTjpPwOTcsy2ihPYiNOn62mRirCo2b5BIH0Fg
         MDzKOpozN8D/aqw1PzamyNFpxE/3+PK5TJzLvLCWqBJij/LdztuqIrASVtW2FDsO1jBI
         2DDKcNxXLGaufkCjv5KHu7QUYESnmg7YWxofReM3Po4+mLhS5KYNv09vH4k47j2OuoJF
         zE2cVLoGOQGyyqfLOVRmYMGQmgptBapKHwHg5eXe+ayQzqaBUu1LxTU2NjUdlsdNFcM/
         sWNg==
X-Gm-Message-State: AOAM533EhmT9UkRWdiDEFu3I/xmkoiahHLmrvaopwkneuMQNBoRPygcR
        /kYUlLLNgAlCopOhR7WvC+qORDPijdUDf1VDiWV2C8EqJ0riJlfg4unGOoJZ5Kb5yX9NQReNnos
        x/mppmxXLy/mPV/vf3rIrYfRlZQexx8gR
X-Received: by 2002:a17:902:223:b029:da:af1e:b112 with SMTP id 32-20020a1709020223b02900daaf1eb112mr9425933plc.83.1607660501005;
        Thu, 10 Dec 2020 20:21:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJype2EWauSJ/rx0SVVALS+cwITbpDlYYVLnWabUpk/ByumEOCyFR74u9czeUWiq9nZo/Apb0g==
X-Received: by 2002:a17:902:223:b029:da:af1e:b112 with SMTP id 32-20020a1709020223b02900daaf1eb112mr9425912plc.83.1607660500584;
        Thu, 10 Dec 2020 20:21:40 -0800 (PST)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id f33sm7936424pgl.83.2020.12.10.20.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 20:21:39 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, po-hsu.lin@canonical.com, kuba@kernel.org,
        shuah@kernel.org
Subject: [PATCH] selftests: test_vxlan_under_vrf: mute uncessary error message
Date:   Fri, 11 Dec 2020 12:21:30 +0800
Message-Id: <20201211042130.16202-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cleanup function in this script that tries to delete hv-1 / hv-2
vm-1 / vm-2 netns will generate some uncessary error messages:

Cannot remove namespace file "/run/netns/hv-2": No such file or directory
Cannot remove namespace file "/run/netns/vm-1": No such file or directory
Cannot remove namespace file "/run/netns/vm-2": No such file or directory

Redirect it to /dev/null like other commands in the cleanup function
to reduce confusion.
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/test_vxlan_under_vrf.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/test_vxlan_under_vrf.sh b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
index 09f9ed9..534c8b7 100755
--- a/tools/testing/selftests/net/test_vxlan_under_vrf.sh
+++ b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
@@ -50,7 +50,7 @@ cleanup() {
     ip link del veth-tap 2>/dev/null || true
 
     for ns in hv-1 hv-2 vm-1 vm-2; do
-        ip netns del $ns || true
+        ip netns del $ns 2>/dev/null || true
     done
 }
 
-- 
2.7.4

