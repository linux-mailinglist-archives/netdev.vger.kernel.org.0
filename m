Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB67F5786CA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiGRPyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiGRPyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:54:40 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFE56465
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:54:39 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h17so17760403wrx.0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hjg6zXcEQgOffoS5EbAyXFRdrHTBt8cuUBdNpDQuLu8=;
        b=PZksptx3+NBk5ZyL6GQ+yxZxy9duMMDrFpXIL9zZRaT0/bytPnl7QjqsRsKqHcMlow
         YSl89MFIZ7mhtufhlAsHmCC9UJOc7r321CaVIC9fZ5UDd3/x0821/aB/R6JjqMKERvrt
         +tfbYR0mxpuP8yBEBosG49MP4Y0kW93KB//R+lL7etBCE+6Msu2wTxqcmxwLBNp2zF80
         6urk+WvTrA8MT06hP8DAmRlarb1GgW5M3+Y255VbVXSPsyjiacBtayH5OwzBMLOqTl6+
         vlOiUFcyK2SH1g0QYElzgKKB0DeQRN+3FaWuCeSBs+lKeryMtr9HPXVNQ5gPBauS3s/k
         gWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hjg6zXcEQgOffoS5EbAyXFRdrHTBt8cuUBdNpDQuLu8=;
        b=7YfTHvmMqohz3ecSJIriDDcEbVJp8ZxjeKc8BTG39X/1s7Js46TA5WznLF2HOEuMOV
         It2BIsiU555iShgjBf4G70eJUp9WScQDWQkCfmy13uaCh3SdbIqCZt4slINiZinVM5me
         NwcKBXpx/x6Yh8SSeRNW4Q9EKBivEd+rSN2vJMGcGhgnkKdFWZK9RmuVpxHhHq08TJR9
         yVUSlhD8cJbJDypWTc+QnboBCKcC8MAB11eY6As7ygR31ofFHvDx+E0JJRGvI/0iuKoC
         o71T1VMrqvxFirauX5Ejc7RPw4Tj9wSbEohuVBd+Sl/9pln11j09XmGecRo+ejWrNSVS
         xohg==
X-Gm-Message-State: AJIora+kANjsKAASCCEo6P7BtUkfxQ4t+1Hlkro/S70qnYOxPPwSSL+t
        VdoeEkQzP2jrBtHoW4XKcLBa
X-Google-Smtp-Source: AGRyM1tVUB88glHB+N94rkUZ9NVX49f78EhwHmz1TqKArqTmnqYKPeAiPOHDHkonueXQF3LHjvOxbA==
X-Received: by 2002:adf:f1d0:0:b0:21d:9c0d:9b5 with SMTP id z16-20020adff1d0000000b0021d9c0d09b5mr22670127wro.689.1658159678091;
        Mon, 18 Jul 2022 08:54:38 -0700 (PDT)
Received: from Mem (2a01cb088160fc006422ad4f4c265774.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:6422:ad4f:4c26:5774])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c264700b003a31c4f6f74sm3873962wmy.32.2022.07.18.08.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 08:54:37 -0700 (PDT)
Date:   Mon, 18 Jul 2022 17:54:36 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf v2 2/5] vxlan: Use ip_tunnel_key flow flags in route
 lookups
Message-ID: <0e0e26155df4e63def5e863b725d10c95d850995.1658159533.git.paul@isovalent.com>
References: <cover.1658159533.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658159533.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ip_tunnel_key field with the flow flags in the IPv4 route
lookups for the encapsulated packet. This will be used by the
bpf_skb_set_tunnel_key helper in a subsequent commit.

Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 drivers/net/vxlan/vxlan_core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 265d4a0245e7..6991bf7c1cf0 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2243,7 +2243,7 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 				      struct vxlan_sock *sock4,
 				      struct sk_buff *skb, int oif, u8 tos,
 				      __be32 daddr, __be32 *saddr, __be16 dport, __be16 sport,
-				      struct dst_cache *dst_cache,
+				      __u8 flow_flags, struct dst_cache *dst_cache,
 				      const struct ip_tunnel_info *info)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
@@ -2270,6 +2270,7 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 	fl4.saddr = *saddr;
 	fl4.fl4_dport = dport;
 	fl4.fl4_sport = sport;
+	fl4.flowi4_flags = flow_flags;
 
 	rt = ip_route_output_key(vxlan->net, &fl4);
 	if (!IS_ERR(rt)) {
@@ -2459,7 +2460,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
-	__u8 tos, ttl;
+	__u8 tos, ttl, flow_flags = 0;
 	int ifindex;
 	int err;
 	u32 flags = vxlan->cfg.flags;
@@ -2525,6 +2526,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 		dst = &remote_ip;
 		dst_port = info->key.tp_dst ? : vxlan->cfg.dst_port;
+		flow_flags = info->key.flow_flags;
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
@@ -2555,7 +2557,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		rt = vxlan_get_route(vxlan, dev, sock4, skb, ifindex, tos,
 				     dst->sin.sin_addr.s_addr,
 				     &local_ip.sin.sin_addr.s_addr,
-				     dst_port, src_port,
+				     dst_port, src_port, flow_flags,
 				     dst_cache, info);
 		if (IS_ERR(rt)) {
 			err = PTR_ERR(rt);
@@ -3061,7 +3063,8 @@ static int vxlan_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		rt = vxlan_get_route(vxlan, dev, sock4, skb, 0, info->key.tos,
 				     info->key.u.ipv4.dst,
 				     &info->key.u.ipv4.src, dport, sport,
-				     &info->dst_cache, info);
+				     info->key.flow_flags, &info->dst_cache,
+				     info);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 		ip_rt_put(rt);
-- 
2.25.1

