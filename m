Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C44C2D6F3A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 05:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405348AbgLKEZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 23:25:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32810 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405321AbgLKEZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 23:25:10 -0500
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1knZym-0001Qx-FY
        for netdev@vger.kernel.org; Fri, 11 Dec 2020 04:24:28 +0000
Received: by mail-pj1-f69.google.com with SMTP id m7so199056pjr.0
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 20:24:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tPXZ+7QAQmRj9Gg0uL9q/qwGUoI81azIs/Hz+gXLnNo=;
        b=eA1YME5SWR4pndqcWbyQSTqajc5FsudRxbZQAuosB6tRoYVyZtzbRuOxOvAkV/07cn
         yapQqqEHBvooAEzvLLmJ3ZFlyoZZHcmPE/xKVx7ReOdTCVRtxR80ul68y8sjF4cBZyTH
         G6eC/1IBOv4N5EQMxYi1CGs6MrDT0W+TcOZb29NZhnammdPRrKrydw00XnZyZAvDxFqX
         T7kNemZPOnVPbo9fokddCAPcXu1y/rChbCQ2+fAqFPOXsnGiZDakOiHVAZmFuOvhsH2I
         e8HOqrevoX1cQFasdf5TG7+iHeo03V9egSwhb8zE3zdonxvwu8pwHOXcvJZmrzrza6rT
         iXEg==
X-Gm-Message-State: AOAM5315svNnIPqFFxu5Nfxs4vspD0ZaTc4yjzAH5lskCI9CzDKbK0Aw
        s2RWrBJdl8F5uzKNDeLcgzoSXx/nP5I+FkC/WJZOZqA8vzPO3+d2/IyWOuxcTIdL+nP+9h/9Wmm
        fAVqswc5L33406it/6fVxr+ONRNjtysz8
X-Received: by 2002:a63:eb4b:: with SMTP id b11mr9849639pgk.351.1607660666845;
        Thu, 10 Dec 2020 20:24:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyITTeGHkWP6edOaQgLt1ofgM+1Ufy7TeSzXSBK85/VCt82D1wcKgDJYTgmykOnGtzogKj/Sg==
X-Received: by 2002:a63:eb4b:: with SMTP id b11mr9849621pgk.351.1607660666556;
        Thu, 10 Dec 2020 20:24:26 -0800 (PST)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id m26sm8241810pfo.123.2020.12.10.20.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 20:24:25 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, po-hsu.lin@canonical.com, kuba@kernel.org,
        shuah@kernel.org
Subject: [PATCHv2] selftests: test_vxlan_under_vrf: mute unnecessary error message
Date:   Fri, 11 Dec 2020 12:24:20 +0800
Message-Id: <20201211042420.16411-1-po-hsu.lin@canonical.com>
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

