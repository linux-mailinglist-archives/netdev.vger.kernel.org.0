Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4851E627728
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiKNIMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiKNIMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:12:21 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C765F19C37
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:12:19 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 130so9613116pgc.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UnN0c0KrsoTxcRuQT5q2k4pBNNHhjJ12uIRQl9glSoY=;
        b=OX5VSkjalPkPSsqzmC9FMci4dtKudaaCD3JoBV0aXzA4YkGsQfwKjORUV6LOjZG3Mr
         EbcLP2tL+aGEuGdzob2mZX+Pjr2WN3sqbhozBJKm0oMyvdlXhfr//EEjfpqkp577QTTK
         /ymKfwCtHgetBBMm7ZQSawOXH5czFSny7ynX0Cyp0QymAqYZgGNgXr9NMq5bxONsDzZH
         dKLmQfNMniY2R39KURWyYlNhYh39WeRgEDgVyJW4HwhLkju0kxDGkpY+5FgDSrkTMwFw
         cKZbNpjwkYyebzctpN2i7gleuzqsg4p24Te5HN3bjO9AXPTpCtBi4XzhJHA3/tmcoIMR
         HXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UnN0c0KrsoTxcRuQT5q2k4pBNNHhjJ12uIRQl9glSoY=;
        b=uSKg9hc7B1kvzlCBqpc0ksT8ibTy4CxD5aBdrWCqBAYvV6JcDnvBG2VSrZieguWQ+3
         6n2rMKW3mJO4A/DjD8TQq3d8b+8ETgFyiMXjKhoP8BWGIxtw7egKqwGk5mpkRWvSaQyy
         4zGZfBqZHlghc+YAb3Gz8hlH9LUjWqRjKzKTxAOaOCL3f2DTZ3iG1fztTr+4X98drb9s
         erzNUZBjZfiDbv1x+VHbwhMH7R4HvN1X+7UraYPJOKMITzEnv2BaoIs8rqq4ei71eejs
         DxUU5JNaWM0/DwpTFChqumYa+yS/x2CbZGsKJT2azYMfsIzT51wCrsJNALlocdMIv8Ok
         lJFQ==
X-Gm-Message-State: ANoB5pkDHawJPk1kXY9FHEb7g1eRvIN+V87BRj4gVkY6MIrf3qDG+cmf
        IUmtHJbQ63SvX8xJA9v7by9UBH5K7WH7fA==
X-Google-Smtp-Source: AA0mqf7Mbi5fA7iniWptV1e0oDVSThRRyuCdugXEcWnFGm/maJ62Wno29IOM1KUSGuT5fDBTYsA7xA==
X-Received: by 2002:a63:e343:0:b0:46f:ed91:6664 with SMTP id o3-20020a63e343000000b0046fed916664mr10781301pgj.558.1668413538470;
        Mon, 14 Nov 2022 00:12:18 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902a3c300b0017a018221e2sm6681620plb.70.2022.11.14.00.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 00:12:17 -0800 (PST)
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
Subject: [PATCHv2 net] net: use struct_group to copy addresses
Date:   Mon, 14 Nov 2022 16:12:10 +0800
Message-Id: <20221114081210.1033795-1-liuhangbin@gmail.com>
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

kernel test robot reported a warning when build bonding module with
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
while we only point the to ip/ip6 saddr. Fix this by using struct_group()
to avoid the compiler warnings/errors.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c3f8324188fa ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

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
index 961ec16a26b8..6f7e833a00f7 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,10 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	struct_group(addrs,
+		__be32	saddr;
+		__be32	daddr;
+	);
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 03cdbe798fe3..3a3a80496c7c 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,10 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	struct_group(addrs,
+		struct	in6_addr	saddr;
+		struct	in6_addr	daddr;
+	);
 };
 
 
-- 
2.38.1

