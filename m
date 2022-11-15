Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C466A629BFE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKOOYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiKOOYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:24:17 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798612C65E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:24:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id k15so14265862pfg.2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2K07bPIauEntQ1IovrpOmisEsq39QRfZ1lzQo6wRmw=;
        b=eElP0bvhn7adx9d6po91FVmrhTk4k0JGpQHd77im7T6s+7I6Wv5ipzMoAbPERTKedg
         64mvKiErJPh3hlgKo1RkAhhll6RKtERtioER6Miq2BNqpcu067JWKv7aHd8Z5ADo3Nsr
         CIbqMIyhC473Xugec5VlBvHi0d1ZLvTUK0dCbYUUU2cGBE29lvfZGEkg24ypuidR2rQb
         w4/IV1vH8c11DbLoy89PE5EC/p7gB3xPfbxevKKE68QGvARk8HNFUhrlQb+lvSvytsyZ
         yvtbkc61c6qi0W7pP8RDMvK5ZUIZBvaE9sdrlFxUBNcYGVic5iSSV2ObUfTciYsXtLIt
         C8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2K07bPIauEntQ1IovrpOmisEsq39QRfZ1lzQo6wRmw=;
        b=3cPCnczgGGWCQ/0EdvbXrPf0EE1vqmMXHQqDAPR9yO3LlTf3WM0NABRhoq9Rwg6q8m
         nmjYa/E0XJFTdlsUA1ab7CkjQfSAGKy16UVfmgwhFmzN32A0vqQqCo7xLsrHgsfahy1C
         LTc5B9puGQ1BioG6zo6DetRZb2eQl5ibBjb/BMpxB+c3isLJKrRey2c/DJLYSO8lziYg
         HIKRHygmOkIcCderpPC+mz/t20I+7MPEWmSNFgLB2SXE37PW08jGLaO0oJgAR9LMwwCP
         breNTa9az2kiCOvfJCanieupoW5YEoPnNzIbY0tOpLDVarV8yvMaqePVflERMjK+DItz
         MS1w==
X-Gm-Message-State: ANoB5pkCK6JFYyotg/duR/gNQM6/VsTxfS3FzE2iPPELtDtcolQdq6Ho
        kkQiwENCq+9e4WnBYHzsfSgmgQALKEmoHQ==
X-Google-Smtp-Source: AA0mqf7buR1vyVlPvZjTYp2if4qRf5w/0Bi3Yai4DVDT1znnSsx0yamA/JNc8zCi5md51c3E8QPKdQ==
X-Received: by 2002:aa7:8f0d:0:b0:56b:d738:9b with SMTP id x13-20020aa78f0d000000b0056bd738009bmr18503924pfr.61.1668522254626;
        Tue, 15 Nov 2022 06:24:14 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m15-20020a656a0f000000b0045dc85c4a5fsm7777570pgu.44.2022.11.15.06.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 06:24:13 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCHv3 net] net: use struct_group to copy ip/ipv6 header addresses
Date:   Tue, 15 Nov 2022 22:24:00 +0800
Message-Id: <20221115142400.1204786-1-liuhangbin@gmail.com>
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

kernel test robot reported warnings when build bonding module with
make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/bonding/:

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

This is because we try to copy the whole ip/ip6 address to the flow_key,
while we only point the to ip/ip6 saddr. Note that since these are UAPI
headers, __struct_group() is used to avoid the compiler warnings.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c3f8324188fa ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: use __struct_group as struct iphdr/ipv6hdr is defined in uapi
v2: use struct_group() instaed of memcpy twice.
---
 include/net/ip.h          | 2 +-
 include/net/ipv6.h        | 2 +-
 include/uapi/linux/ip.h   | 6 ++++--
 include/uapi/linux/ipv6.h | 6 ++++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 038097c2a152..144bdfbb25af 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -563,7 +563,7 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v4addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v4addrs.src) +
 			      sizeof(flow->addrs.v4addrs.src));
-	memcpy(&flow->addrs.v4addrs, &iph->saddr, sizeof(flow->addrs.v4addrs));
+	memcpy(&flow->addrs.v4addrs, &iph->addrs, sizeof(flow->addrs.v4addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 37943ba3a73c..d383c895592a 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -897,7 +897,7 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v6addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v6addrs.src) +
 		     sizeof(flow->addrs.v6addrs.src));
-	memcpy(&flow->addrs.v6addrs, &iph->saddr, sizeof(flow->addrs.v6addrs));
+	memcpy(&flow->addrs.v6addrs, &iph->addrs, sizeof(flow->addrs.v6addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index 961ec16a26b8..874a92349bf5 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,10 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		__be32	saddr;
+		__be32	daddr;
+	);
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 03cdbe798fe3..81f4243bebb1 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,10 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		struct	in6_addr	saddr;
+		struct	in6_addr	daddr;
+	);
 };
 
 
-- 
2.38.1

