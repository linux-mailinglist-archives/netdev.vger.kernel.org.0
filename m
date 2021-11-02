Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3A442535
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhKBBjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhKBBjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:39:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E05EC061714;
        Mon,  1 Nov 2021 18:37:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b13so2093532plg.2;
        Mon, 01 Nov 2021 18:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1n2x0oKAPYz3pWFJUDMqbyMzMmahNoyv8knA3ovY2+0=;
        b=SiBv18g07D1Lo7xOk1Y0/PnqCF1HCFw3ku/LHJ/Cy1SLM7QzuCfvLixjGx4PhyFI1Q
         RObva8Xf4jVjJfbyTatk9Tjm2TSz/DrISdSN+3VihMYPpcHa1c6tmm3Gyx0ciUrBJJZh
         y7jmEZthtGoRDYM0Ld+w6x6J4nkJh+WuhoZUH2NupPrZ4x1ZeQYCu41u+zVpAYd4OTg1
         w86IcHSn6irvsZ+k01IrIPI5TPsZMMWJE2hgBHmRQX/oF4YXEbwVT9sll/J5VReGiCGH
         CYbInfP82M5lRGKCmwbVZK5QcpYd3Ljkh6RbHOzby4kiHWKpaSb2sbCvGMOrgUdKL1NQ
         vyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1n2x0oKAPYz3pWFJUDMqbyMzMmahNoyv8knA3ovY2+0=;
        b=TSX3RaSkSfU4//H7CGtPpehD5F8wSHhVdl5NrJQL8rCfTevsqyvDAoP2jYswulK62M
         yljyFz4LjN5iYUR3YpNUasS0hPMv/s2XCIc3YyKkzN1nTVUJtsN9krAk7wTWurWb2WAG
         LsMIM70iijs3dJanUT2BH52A3viqlRVAot/nLOMstYQbCfKVdAWsWMNsQRgqbOruj0Eh
         ZskJJFUhCMbzGYpFNgT0ZYCD21xxDuwJoGaV0hRqj2Tjfo9JDJWlKUbGqNsznyc3t/Pj
         61wTjcNAkkt2/qPMi2VQvpOH2Arru5RqskFGO1NbRx4iEC2aTf/LYlJVB6v2yfQfnxuz
         i8/w==
X-Gm-Message-State: AOAM53254w15G1QbNR5K3U/CxGUN8/nDNceJmH/0Hy8ect5kM4YeHit8
        jfvhL2CTuUVo7fOMSEmY0lNJpWLcXQ0=
X-Google-Smtp-Source: ABdhPJymLYDW5kA1pE3mqFVtcJGNI3lfoDH/RdBc2cp1T3gKVz0G0g7esM2TLkuGmZUx73cwhzIAdw==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr3046827pjl.150.1635817039837;
        Mon, 01 Nov 2021 18:37:19 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm16867209pfm.58.2021.11.01.18.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 18:37:19 -0700 (PDT)
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
Subject: [PATCHv2 net 3/5] kselftests/net: add missed SRv6 tests
Date:   Tue,  2 Nov 2021 09:36:34 +0800
Message-Id: <20211102013636.177411-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102013636.177411-1-liuhangbin@gmail.com>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the SRv6 tests are
missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 03a0b567a03d ("selftests: seg6: add selftest for SRv6 End.DT46 Behavior")
Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Fixes: 2bc035538e16 ("selftests: add selftest for the SRv6 End.DT6 (VRF) behavior")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 63ee01c1437b..8a6264da5276 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,6 +28,9 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
+TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.31.1

