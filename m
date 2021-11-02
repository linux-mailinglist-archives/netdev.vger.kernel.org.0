Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11219442530
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBBjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBBjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:39:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F82BC061714;
        Mon,  1 Nov 2021 18:37:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u11so1251642plf.3;
        Mon, 01 Nov 2021 18:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lR2rA3syRfYqNnvx4W87XPNX8FptLg6EEYcLwPJf6yQ=;
        b=VRGmjuj7Vh50zEX9X2ID+0fRLJhFm/6bg5YASg3cPNWc76wFeBxg466DJ6vD218gNU
         n4NyoyMLYteYRdMAYr7lDVFN7WGsE6F0hndAztjTGdWkn9wYZxpeRUXpQuCZ+Gp7/wFW
         46YiGjvxERkvXk0Ogv4YmFBt/djTunP+AXJKVnYCKu7tGB+coG9rkIKjA1N5H0FB20iT
         9mWsN/1Ek8Gy/A+swE6devn5hh4NkgbBPL2pt6sNl8aDGeNAG8GgbWAHDuwy38/VbaCH
         X/pqgcAvti5tsfFH4N4OR3q4RFhge6s3g0TkYA9X5pP5KpzXKABVhdPMkcj2S4LjwSTl
         ZNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lR2rA3syRfYqNnvx4W87XPNX8FptLg6EEYcLwPJf6yQ=;
        b=Qsh6LgA9CpDqoPhQIDQVRlGFbfKkjjelGCha3hbgOOrTZcNiGk3wWXkGFI7EEcl2Gz
         8z857NgM06mvw/6x8XiH8hNYs7mTOgK+AcJ9H2EMCIfCFk6+xgtW4BqG47kjuofzvcKG
         ePcT5GVaNkw/l4CKteQG7lbVKPlrD35XbsNYrUo5Gjpe6Ve+oFpDs/TJqq6FkHohJfpX
         7kNeE3BFFiP3Wz+6ndAEoLjQmlSZQYjTGDbH3/4LnAoD0AtyITusEtG7CQLzQoi7BXXg
         wxpTSJZ1xdYuPhKxkMMwuSf+MZaGgBejZRpBxbu+Kql6Z9Vk9jKZFoT9dnaCVpPKS+sE
         Pw7g==
X-Gm-Message-State: AOAM532E4MXt6NGyOI83JJZ18ykjYZc1q0MzOvQ/ZxcRBFECaKpJgSZi
        x7xzqmjEu9J6GXRw00QsHcHzJfY4z4E=
X-Google-Smtp-Source: ABdhPJwCXzPRNu+wJ8CcJ6jAcRhKPTvSt2vnoclNbdogl/3IeJwCgudWq/EJnF+NmwMuec5RWnGprA==
X-Received: by 2002:a17:90a:7645:: with SMTP id s5mr2903958pjl.125.1635817031701;
        Mon, 01 Nov 2021 18:37:11 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm16867209pfm.58.2021.11.01.18.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 18:37:11 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 1/5] kselftests/net: add missed icmp.sh test to Makefile
Date:   Tue,  2 Nov 2021 09:36:32 +0800
Message-Id: <20211102013636.177411-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102013636.177411-1-liuhangbin@gmail.com>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the icmp.sh test will
miss as it is not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 7e9838b7915e ("selftests/net: Add icmp.sh for testing ICMP dummy address responses")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 492b273743b4..9b1c2dfe1253 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -12,7 +12,7 @@ TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_a
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
 TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
-TEST_PROGS += altnames.sh icmp_redirect.sh ip6_gre_headroom.sh
+TEST_PROGS += altnames.sh icmp.sh icmp_redirect.sh ip6_gre_headroom.sh
 TEST_PROGS += route_localnet.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS += txtimestamp.sh
-- 
2.31.1

