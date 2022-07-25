Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674CC5800C1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiGYOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiGYOcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:32:03 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A5CE32
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:02 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b26so16254522wrc.2
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/kAJxldbrmsnL1tLj1jaIBuGNwFFERk4HzZ6Ldyv2Nk=;
        b=jcF7mq68LW3Zo55ZInonw3SxO28xxzG6Nk3iAk2CwXITIkKG3s4Tq70ULDSFzZjOgj
         uJ93S3Kt4aNbUaPBTYKpx7hb2EcYr/bDw7DFmMaNWeh4IbaF6zGfrmtwB6FOZR2UxJhK
         dgX+abQ6SP/mGfyo/01yXloU+YzxknvHzDuQoVEKz43k+OZ1vtBkCk8mxdfrtaPYlR8t
         WM0n9eIlBpB/TPlKJEnEWqDlTfXVTePtD2dNaygBTI6sh3rA2W/RdnpWg20HmtGsGK8X
         VMEzQAiXZJn84R1g6dzV1oMcMJGFVrgJDKldBa7YK95Eu4BsYAzevzj3Zf9pmagXTE5+
         YU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/kAJxldbrmsnL1tLj1jaIBuGNwFFERk4HzZ6Ldyv2Nk=;
        b=A2HQNZIGTkUUBlmaVI+oUbY4QQj6pSSB+gTif5LPPy0mFGwUa1BWKZhuO+DuxNeqt6
         QTSmhC0jBoC84zN2vpm0zX4ZqdYvFn0obBiUKfL+NyQG83Xt7mS4HrGXiMex4xka5att
         qB92ufSkR4cewDkiSs2SpKEw5TofkKhmuVDrUSKDRvPsGUhB8s7JEDg2rNFR6yttf6ZC
         b78AoxXv+n7SclIzaIR2nDhxGphzs1H/sh/qWUJ4q5D8mzr9ufTgzCj07shusUY5iP36
         Ik2CI2/Py1H4guW5fXx4Dg1hAx6epeth8Kk+uoq0HxzR6hBXiSWS+XW0+9YKc8eBpPtY
         I/Sw==
X-Gm-Message-State: AJIora/UBeX/PmfuXEWgi5JKsNv1sINtuE67K0F/D54iGfPRte/5hsow
        I+8DSyTNucpBab5RuPpE9e6P
X-Google-Smtp-Source: AGRyM1tNTpI0TL5iWQyrhR4IyCetObr6eYaKTaSYBV4jG7xGS+smroXkJ9VPt0jBJAuVgTh/KNi2kQ==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr7695910wry.206.1658759521203;
        Mon, 25 Jul 2022 07:32:01 -0700 (PDT)
Received: from Mem (pop.92-184-116-22.mobile.abo.orange.fr. [92.184.116.22])
        by smtp.gmail.com with ESMTPSA id c4-20020adffb04000000b0021db7b0162esm8172529wrr.105.2022.07.25.07.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:32:00 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:31:58 +0200
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
Subject: [PATCH bpf-next v3 2/5] vxlan: Use ip_tunnel_key flow flags in route
 lookups
Message-ID: <1ffc95c3d60182fd5ec0cf6602083f8f68afe98f.1658759380.git.paul@isovalent.com>
References: <cover.1658759380.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658759380.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ip_tunnel_key field with the flow flags in the IPv4 route
lookups for the encapsulated packet. This will be used by the
bpf_skb_set_tunnel_key helper in a subsequent commit.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 drivers/net/vxlan/vxlan_core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 8b0710b576c2..90811ab851fd 100644
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

