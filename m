Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88F622219
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKICo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiKICoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:44:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3B053EDA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:44:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so582261pjc.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 18:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R+TLVR8oJsIU+dcp5PhKhIj1kndw2JITBLVeI53xJFA=;
        b=buzQBJFxch8BUIYQQeFd8GaaF/DMorqM6auJaIxTvX8E492wQPj/CNAhxywY5uqsW1
         hR/0I6XN3yW2uSS3Y3kToFrIwF6rhdn2YIgiOz1Sp5IBfDtURm+aWec2dc1wqSK5UcP5
         CHobCciY8zMfbam1jSww7919K2VJoSSoefu2uU29yVW5HW3CUopwdIP0kNeatbOkXtYR
         GBe4ieBzxOIDTUwwhSUcb7c5LfIKRppClB4rKPhzLrZ7kcSfU7LJCATu14pMdkqVt9CP
         aQCaaRbtKlMmeW8nl0qTFC3pHqh1/qK3oVkFz5D99ZXIRfFHZUsr7g3rtq+IzLzT1uPt
         Z4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+TLVR8oJsIU+dcp5PhKhIj1kndw2JITBLVeI53xJFA=;
        b=th+xJ+b6IVDM9qq+5a5QB12DrT2Yg62hcVGmeAFWtgYa8nTJcl4vUJahhfuS7II5vW
         a3K0cIuQulw8LJTitK98UMgacinaLaR6q5Y+hb7hNk+zDq9GTHBz2p6X3eAMPQdZo/d4
         p2V/SxftInlcB0w48K1oL1pZWisiVvJwYkYU/v1Im2PZBt3zzGU5YbOeYwZtsWFegqvl
         Tp/VqcW+C5MyGLALS1L9X0D0YWDO1TAeYmIY0bjxiFFvt9sa1N43cfX889bEwZEtyQTm
         lGgJyWGrXFazRRstR80tkw86SDyOIpFUCrt1WSrkF1JVQsgRHFo417dfPBD//PLdSGhv
         ZaIw==
X-Gm-Message-State: ACrzQf2T4C+Jr7xbZomVbkMo73W6NXw2QrRYJ9q03Gnve9uAI9QHiwbQ
        27TIpMcbTlB7fSvOR2hfa2oHP9WW6tvDiw==
X-Google-Smtp-Source: AMsMyM45N/xHwcAASQQa95nhWx7aaXY8ingBD45BmvNtnC+shtJl/z3Yr89uLSm4WqcIngc0t3WycA==
X-Received: by 2002:a17:902:654c:b0:188:612b:2cc2 with SMTP id d12-20020a170902654c00b00188612b2cc2mr28391263pln.50.1667961854208;
        Tue, 08 Nov 2022 18:44:14 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b00186efc56ab9sm7630227plk.221.2022.11.08.18.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:44:13 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] net: fix the address copy size to flow_keys
Date:   Wed,  9 Nov 2022 10:44:06 +0800
Message-Id: <20221109024406.316322-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported a warning when build bonding module:

                 from ../drivers/net/bonding/bond_main.c:35:
In function ‘fortify_memcpy_chk’,
    inlined from ‘iph_to_flow_copy_v4addrs’ at ../include/net/ip.h:566:2,
    inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3984:3:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function ‘fortify_memcpy_chk’,
    inlined from ‘iph_to_flow_copy_v6addrs’ at ../include/net/ipv6.h:900:2,
    inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3994:3:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is because we try to memcpy the whole ip/ip6 address to the flow_key,
while we only point the to ip/ip6 saddr. It is efficient since we only need
to do copy once for both saddr and daddr. But to fix the build warning,
let's break the memcpy to 2 parts. This may affect bonding's performance
slightly, but shouldn't too much.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c3f8324188fa ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/ip.h   | 3 ++-
 include/net/ipv6.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 038097c2a152..8ab4cea47ceb 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -563,7 +563,8 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v4addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v4addrs.src) +
 			      sizeof(flow->addrs.v4addrs.src));
-	memcpy(&flow->addrs.v4addrs, &iph->saddr, sizeof(flow->addrs.v4addrs));
+	memcpy(&flow->addrs.v4addrs.src, &iph->saddr, sizeof(flow->addrs.v4addrs.src));
+	memcpy(&flow->addrs.v4addrs.dst, &iph->daddr, sizeof(flow->addrs.v4addrs.dst));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 37943ba3a73c..f6ff7d30ca49 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -897,7 +897,8 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v6addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v6addrs.src) +
 		     sizeof(flow->addrs.v6addrs.src));
-	memcpy(&flow->addrs.v6addrs, &iph->saddr, sizeof(flow->addrs.v6addrs));
+	memcpy(&flow->addrs.v6addrs.src, &iph->saddr, sizeof(flow->addrs.v6addrs.src));
+	memcpy(&flow->addrs.v6addrs.dst, &iph->daddr, sizeof(flow->addrs.v6addrs.dst));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
-- 
2.38.1

