Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D014F9E00
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbiDHUKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiDHUKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 744F7192A1
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649448522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JHH0skGeaxmrPL3jop/zKLhN1YXYoj1K6NBWdRFD5kk=;
        b=d8kVf0Jjs6LEpVhMC/9rvxCVsv/oC8pi76B1GuShWKFziEL5uBm9J6GSz2aA3u/aM8RqMx
        a3O3/9vtc7OnJYzQTy1B5MnaWrFyhiPeYzf91XNv2qzwx7+q3JXZit0Km5SKbdDlLhJw22
        bkbBlE+iRE/+a68Zo8wk5gT7xxhrKxU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-vtBgo02PPh2nd3Fsc5KNhw-1; Fri, 08 Apr 2022 16:08:41 -0400
X-MC-Unique: vtBgo02PPh2nd3Fsc5KNhw-1
Received: by mail-wr1-f71.google.com with SMTP id g4-20020adfa484000000b002061151874eso2437979wrb.21
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:08:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JHH0skGeaxmrPL3jop/zKLhN1YXYoj1K6NBWdRFD5kk=;
        b=uO87fLTkJY4/WayHj36TLr6BJ5fF9ajpuCCKlRD1bL4e1Kc37ZW8po4MjPtAiG91n+
         /A9djhDRFRfEaFvwbpfxQsbY5H6ylJ1hvbTNxnAujLreXcrNlplGQy2qHUZ8MIueekHF
         YExC9xzDJadTHtS3TlM/nTuyoPWGQSTr11KKLaKi6bQELfWpq0oyGIN9waAiyWWI+mAd
         S8kURI4TtwXwlwMmgZrbAFwXief0eY7OXA2vXzSm5Fo1lTVCwHgbzdQ262sJd2Dpumj0
         +10H6Cw1zvObnWaRAokCKzCOjTK3rgEPbVftPak38Vm5wOuitl/04OquhD1a1nFtdMEY
         +oKQ==
X-Gm-Message-State: AOAM530bDkcOT8Mm+C7Nq5tSqcJmxXcFdB0fjiDe7bvZ7nLWWGgq8cZN
        4L1FdCyiTsAr0K9canXvryd+Jbe4CNBOL9Aibij6I+J1n/xPDEZz6Qdd5LKSDFAMgfzDsc6uP4E
        7veLULAXByRNqaJGl
X-Received: by 2002:a05:600c:3588:b0:38c:6d7f:6fd8 with SMTP id p8-20020a05600c358800b0038c6d7f6fd8mr18238032wmq.25.1649448519639;
        Fri, 08 Apr 2022 13:08:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6Cz0tly2boKt2ElziLMaDdvNQhmbBVshEKhtofnX4gFjKRV3BOSMoknD0I4Dy7JEB+0JAww==
X-Received: by 2002:a05:600c:3588:b0:38c:6d7f:6fd8 with SMTP id p8-20020a05600c358800b0038c6d7f6fd8mr18238015wmq.25.1649448519445;
        Fri, 08 Apr 2022 13:08:39 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id r12-20020adfdc8c000000b002060878f735sm16724628wrj.65.2022.04.08.13.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 13:08:39 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:08:37 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 1/5] ipv4: Use dscp_t in struct fib_rt_info
Message-ID: <027027eb31686b0ea43aaf6e533a5912ca400f21.1649445279.git.gnault@redhat.com>
References: <cover.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the tos field of struct fib_rt_info.
This ensures ECN bits are ignored and makes it compatible with the
fa_dscp field of struct fib_alias.

This also allows sparse to flag potential incorrect uses of DSCP and
ECN bits.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c   | 7 ++++---
 drivers/net/netdevsim/fib.c                             | 5 +++--
 include/net/ip_fib.h                                    | 2 +-
 net/ipv4/fib_semantics.c                                | 4 ++--
 net/ipv4/fib_trie.c                                     | 6 +++---
 net/ipv4/route.c                                        | 4 ++--
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 6c5618cf4f08..99d60c9ae54d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/inetdevice.h>
+#include <net/inet_dscp.h>
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 
@@ -132,7 +133,7 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 	fri.tb_id = fc->key.kern_tb_id;
 	fri.dst = fc->key.addr.u.ipv4;
 	fri.dst_len = fc->key.prefix_len;
-	fri.tos = fc->kern_tos;
+	fri.dscp = inet_dsfield_to_dscp(fc->kern_tos);
 	fri.type = fc->kern_type;
 	/* flags begin */
 	fri.offload = offload;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 79fd486e29e3..596516ba73c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -21,6 +21,7 @@
 #include <net/netevent.h>
 #include <net/neighbour.h>
 #include <net/arp.h>
+#include <net/inet_dscp.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/nexthop.h>
@@ -5620,7 +5621,7 @@ mlxsw_sp_fib4_offload_failed_flag_set(struct mlxsw_sp *mlxsw_sp,
 	fri.tb_id = fen_info->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = fen_info->dst_len;
-	fri.tos = fen_info->tos;
+	fri.dscp = inet_dsfield_to_dscp(fen_info->tos);
 	fri.type = fen_info->type;
 	fri.offload = false;
 	fri.trap = false;
@@ -5645,7 +5646,7 @@ mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 	fri.tb_id = fib4_entry->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
-	fri.tos = fib4_entry->tos;
+	fri.dscp = inet_dsfield_to_dscp(fib4_entry->tos);
 	fri.type = fib4_entry->type;
 	fri.offload = should_offload;
 	fri.trap = !should_offload;
@@ -5668,7 +5669,7 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fri.tb_id = fib4_entry->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
-	fri.tos = fib4_entry->tos;
+	fri.dscp = inet_dsfield_to_dscp(fib4_entry->tos);
 	fri.type = fib4_entry->type;
 	fri.offload = false;
 	fri.trap = false;
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 378ee779061c..31e73709aac5 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
 #include <net/fib_notifier.h>
+#include <net/inet_dscp.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/fib_rules.h>
@@ -322,7 +323,7 @@ nsim_fib4_rt_offload_failed_flag_set(struct net *net,
 	fri.tb_id = fen_info->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = fen_info->dst_len;
-	fri.tos = fen_info->tos;
+	fri.dscp = inet_dsfield_to_dscp(fen_info->tos);
 	fri.type = fen_info->type;
 	fri.offload = false;
 	fri.trap = false;
@@ -342,7 +343,7 @@ static void nsim_fib4_rt_hw_flags_set(struct net *net,
 	fri.tb_id = fib4_rt->common.key.tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
-	fri.tos = fib4_rt->tos;
+	fri.dscp = inet_dsfield_to_dscp(fib4_rt->tos);
 	fri.type = fib4_rt->type;
 	fri.offload = false;
 	fri.trap = trap;
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 6a82bcb8813b..f08ba531ac08 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -212,7 +212,7 @@ struct fib_rt_info {
 	u32			tb_id;
 	__be32			dst;
 	int			dst_len;
-	u8			tos;
+	dscp_t			dscp;
 	u8			type;
 	u8			offload:1,
 				trap:1,
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ccb62038f6a4..a57ba23571c9 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -524,7 +524,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.tb_id = tb_id;
 	fri.dst = key;
 	fri.dst_len = dst_len;
-	fri.tos = inet_dscp_to_dsfield(fa->fa_dscp);
+	fri.dscp = fa->fa_dscp;
 	fri.type = fa->fa_type;
 	fri.offload = READ_ONCE(fa->offload);
 	fri.trap = READ_ONCE(fa->trap);
@@ -1781,7 +1781,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 	rtm->rtm_family = AF_INET;
 	rtm->rtm_dst_len = fri->dst_len;
 	rtm->rtm_src_len = 0;
-	rtm->rtm_tos = fri->tos;
+	rtm->rtm_tos = inet_dscp_to_dsfield(fri->dscp);
 	if (tb_id < 256)
 		rtm->rtm_table = tb_id;
 	else
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index fb0e49c36c2e..e96f02f0ab93 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1032,8 +1032,8 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
 		if (fa->fa_slen == slen && fa->tb_id == fri->tb_id &&
-		    fa->fa_dscp == inet_dsfield_to_dscp(fri->tos) &&
-		    fa->fa_info == fri->fi && fa->fa_type == fri->type)
+		    fa->fa_dscp == fri->dscp && fa->fa_info == fri->fi &&
+		    fa->fa_type == fri->type)
 			return fa;
 	}
 
@@ -2305,7 +2305,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.tb_id = tb->tb_id;
 				fri.dst = xkey;
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
-				fri.tos = inet_dscp_to_dsfield(fa->fa_dscp);
+				fri.dscp = fa->fa_dscp;
 				fri.type = fa->fa_type;
 				fri.offload = READ_ONCE(fa->offload);
 				fri.trap = READ_ONCE(fa->trap);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 98c6f3429593..80f96170876c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3394,7 +3394,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		fri.tb_id = table_id;
 		fri.dst = res.prefix;
 		fri.dst_len = res.prefixlen;
-		fri.tos = fl4.flowi4_tos;
+		fri.dscp = inet_dsfield_to_dscp(fl4.flowi4_tos);
 		fri.type = rt->rt_type;
 		fri.offload = 0;
 		fri.trap = 0;
@@ -3407,7 +3407,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 				if (fa->fa_slen == slen &&
 				    fa->tb_id == fri.tb_id &&
-				    fa->fa_dscp == inet_dsfield_to_dscp(fri.tos) &&
+				    fa->fa_dscp == fri.dscp &&
 				    fa->fa_info == res.fi &&
 				    fa->fa_type == fri.type) {
 					fri.offload = READ_ONCE(fa->offload);
-- 
2.21.3

