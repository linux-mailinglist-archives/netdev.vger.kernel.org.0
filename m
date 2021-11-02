Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B229442537
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhKBBj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhKBBj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:39:58 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887DFC061714;
        Mon,  1 Nov 2021 18:37:24 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q187so18768576pgq.2;
        Mon, 01 Nov 2021 18:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5JDyS5CAKwG5Y6+tDdMQwQqLQjUNY4N1DKo4QMNkQbs=;
        b=jufqpSQBUpcOd5DwrW9/5JDvhzI+N4eJ52XBWps5nmuQ1F8cxKrRNMH71FgXY19aFA
         a+/CI5z3VcszpyZmgxR9ty4zBDYuKATagX5o89mVPM937XeMfLq2JPbmlrbGvg1cgwlL
         jqiBf+rurgfW3fwG3LRSKCHlVN6fZiws7/21GtpYs/27xSPt/LeTfN+UgLJhi67q+Lhw
         K4UJ5VSHLC4W4DMFd+TpCNr8/Io1AaiOqgVFYxiRybs7GrA1s7Pt8Wsob48qBLnN8j81
         suYNNcolwgLrUwfw+x6OrSKcz9ApuNErCj45GjNmDg3skrreHKAK3CIFifKo7PGjtFfr
         76cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JDyS5CAKwG5Y6+tDdMQwQqLQjUNY4N1DKo4QMNkQbs=;
        b=6wFpJ4rhEv7dxV1OL29r1U1BWohBmnmGWLtNIEBdmBtIglaqWTvw8NUpM1fh9Mh3OC
         GS9TpFpg8/oTYL5r5DvRvRHP7kzQoxzLFjrBU3H+1if1u0Vpvtp2A2suHHDg7XCgxOJT
         jCziZIFmIBAQod4hczrFQI6aBhfGWObMu0/PZXPGjEmM8XN2aIwm3ljK4RotbUsaWleJ
         FF2UMKZDrv3tDK7iOlVZ65MXdOUTSUlIddHKVVVmNMK2P1I/O7Ax+u98BGu5p+66SSWf
         bJMifN9yoTYY+b86GWe91Xt5j4plUQUvpbAwXI+2xEdjGYF/j6lSFFrSnKko4nysLnM3
         wz8A==
X-Gm-Message-State: AOAM532T+HeoVXB8b6mqmnzV3PVH/cv0l/9/oz0NcPcz9aUPwHQHA0VD
        xg9c5n/d5GZCm+qhGw6qxg/aOWf3SHM=
X-Google-Smtp-Source: ABdhPJyzw0J9ALoG9USSIE4SiMKLlCjxPo46PEi4AtN5CLuFG/LJvnbf9WxS4wVl/VY1U+F50zzwAQ==
X-Received: by 2002:a63:7f0f:: with SMTP id a15mr25137653pgd.9.1635817043945;
        Mon, 01 Nov 2021 18:37:23 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm16867209pfm.58.2021.11.01.18.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 18:37:23 -0700 (PDT)
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
Subject: [PATCHv2 net 4/5] kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
Date:   Tue,  2 Nov 2021 09:36:35 +0800
Message-Id: <20211102013636.177411-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102013636.177411-1-liuhangbin@gmail.com>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the
vrf_strict_mode_test.sh test will miss as it is not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 8735e6eaa438 ("selftests: add selftest for the VRF strict mode")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8a6264da5276..7328bede35f0 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -31,6 +31,7 @@ TEST_PROGS += gre_gso.sh
 TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
+TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.31.1

