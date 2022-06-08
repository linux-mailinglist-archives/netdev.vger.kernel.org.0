Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5887F542F2A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiFHL1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiFHL1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:27:03 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E171FBF101
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 04:27:01 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id y32so32739691lfa.6
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 04:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2ONoospc3ZQNgnh+gWOpWLbb0lokYbJX+4sKWAZmo8=;
        b=iGLqCYyDk4W1FC7IyTXCRtnRWZmR5U7tMjGPoS/3uegO9vLpmlKRUSAC8+3MC5hFJY
         or3vJ9l5WDMNJmqMBvpVSZvOX+3Rg5kxXFu503HUyOn/iQ+Aa3K/ZFcroWq4Vk1lKrjG
         KU9tPHMKzkDL3jbnngVvbhPHrp0/YMZnbopUbTJVNUowlrTa3FyvaKfwAVUQImGya9wh
         MLo8U9TqTdbt30uXLwi1r8ZJVt7Fl/aWqfZBolPEbyL17FY4tmGkwAnGURxXZN/qts4y
         0vrb5oi4pmvIQWqL9tV7etJ1b3z0EaX4YWWi2e7y0j86WdeNick6PHNkYxpYTSXzzRsK
         GRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2ONoospc3ZQNgnh+gWOpWLbb0lokYbJX+4sKWAZmo8=;
        b=RLlonXrElmrj/5Rhy9C9tuCqNxWS3mLjS7Ze5uomk6aGm5fnPsZPtxN9l478QhTEyq
         6fsQQnkpZ7CPIIkZsuhSH+eg8G7Jv50vTA8rRvR66mUR7uVe3NL9nsNH1SEa+Osf9fRq
         X5AplP4y3Zh2vsNmMhmz+e0sPPVLQ4EcPfcnGa4su6nAte0Ifu0JBmZIwTreFCgyrU7Y
         ishbbiTar5VNn44CodpmFBp0NjyQcY//7cqklLKxo0wPc/dagzCPbDj2/Sa49p9t6mMM
         pQN2bzKkxsuWutiVfv2u46v6PJ8e0x3DwENCpSLXSugAjASU2PKoqT0bKYPB62IJyAcK
         5P3Q==
X-Gm-Message-State: AOAM530VX5GydyED+IQVFUBXuXcayo/ERBUsMzJGEiBzowD2A/8LohZg
        eu7nkEsmRj8ST4scvQzc+Lo=
X-Google-Smtp-Source: ABdhPJyN33Bvhf0U7IT1DGwPT6mzZ3axkUNo3cpfovOjyXzk2wg1moD8kYjSto4oiuO4eAfCtpUxeg==
X-Received: by 2002:a05:6512:3118:b0:479:216f:4e36 with SMTP id n24-20020a056512311800b00479216f4e36mr13774805lfb.568.1654687620130;
        Wed, 08 Jun 2022 04:27:00 -0700 (PDT)
Received: from extra.gateflow.net ([46.109.159.121])
        by smtp.gmail.com with ESMTPSA id v20-20020a056512349400b00478f3bb79d6sm3675678lfr.194.2022.06.08.04.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 04:26:59 -0700 (PDT)
From:   Anton Makarov <antonmakarov11235@gmail.com>
X-Google-Original-From: Anton Makarov <anton.makarov11235@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        david.lebrun@uclouvain.be, kuba@kernel.org
Cc:     Anton Makarov <anton.makarov11235@gmail.com>
Subject: [net-next 1/1] net: seg6: Add support for SRv6 Headend Reduced Encapsulation
Date:   Wed,  8 Jun 2022 14:26:46 +0300
Message-Id: <20220608112646.9331-1-anton.makarov11235@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SRv6 Headend H.Encaps.Red and H.Encaps.L2.Red behaviors are implemented
accordingly to RFC 8986. The H.Encaps.Red is an optimization of
The H.Encaps behavior. The H.Encaps.L2.Red is an optimization of
the H.Encaps.L2 behavior. Both new behaviors reduce the length of
the SRH by excluding the first SID in the SRH of the pushed IPv6 header.
The first SID is only placed in the Destination Address field
of the pushed IPv6 header.

The push of the SRH is omitted when the SRv6 Policy only contains
one segment.

Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
---
 include/net/seg6.h                 |  2 +
 include/uapi/linux/seg6_iptunnel.h |  2 +
 net/ipv6/seg6_iptunnel.c           | 95 +++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index af668f17b398..8d0ce782f830 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -62,6 +62,8 @@ extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
 extern void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
+extern int seg6_do_srh_encap_red(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
+			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
 extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 			       u32 tbl_id);
diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index eb815e0d0ac3..a9fa777f16de 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -35,6 +35,8 @@ enum {
 	SEG6_IPTUN_MODE_INLINE,
 	SEG6_IPTUN_MODE_ENCAP,
 	SEG6_IPTUN_MODE_L2ENCAP,
+	SEG6_IPTUN_MODE_ENCAP_RED,
+	SEG6_IPTUN_MODE_L2ENCAP_RED,
 };
 
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index d64855010948..430975b03597 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -36,9 +36,11 @@ static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 	case SEG6_IPTUN_MODE_INLINE:
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		head = sizeof(struct ipv6hdr);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		return 0;
 	}
 
@@ -195,6 +197,81 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 }
 EXPORT_SYMBOL_GPL(seg6_do_srh_encap);
 
+/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
+int seg6_do_srh_encap_red(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct net *net = dev_net(dst->dev);
+	struct ipv6hdr *hdr, *inner_hdr6;
+	struct iphdr *inner_hdr4;
+	struct ipv6_sr_hdr *isrh;
+	int hdrlen = 0, tot_len, err;
+	__be32 flowlabel = 0;
+
+	if (osrh->first_segment > 0)
+		hdrlen = (osrh->hdrlen - 1) << 3;
+
+	tot_len = hdrlen + sizeof(struct ipv6hdr);
+
+	err = skb_cow_head(skb, tot_len + skb->mac_len);
+	if (unlikely(err))
+		return err;
+
+	inner_hdr6 = ipv6_hdr(skb);
+	inner_hdr4 = ip_hdr(skb);
+	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr6);
+
+	skb_push(skb, tot_len);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	hdr = ipv6_hdr(skb);
+
+	memset(skb->cb, 0, 48);
+	IP6CB(skb)->iif = skb->skb_iif;
+
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
+			     flowlabel);
+		hdr->hop_limit = inner_hdr6->hop_limit;
+	} else if (skb->protocol == htons(ETH_P_IP)) {
+		ip6_flow_hdr(hdr, ip6_tclass(inner_hdr4->tos), flowlabel);
+		hdr->hop_limit = inner_hdr4->ttl;
+	}
+
+	skb->protocol = htons(ETH_P_IPV6);
+
+	hdr->daddr = osrh->segments[osrh->first_segment];
+	hdr->version = 6;
+
+	if (osrh->first_segment > 0) {
+		hdr->nexthdr = NEXTHDR_ROUTING;
+
+		isrh = (void *)hdr + sizeof(struct ipv6hdr);
+		memcpy(isrh, osrh, hdrlen);
+
+		isrh->nexthdr = proto;
+		isrh->first_segment--;
+		isrh->hdrlen -= 2;
+	} else {
+		hdr->nexthdr = proto;
+	}
+
+	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
+
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (osrh->first_segment > 0 && sr_has_hmac(isrh)) {
+		err = seg6_push_hmac(net, &hdr->saddr, isrh);
+		if (unlikely(err))
+			return err;
+	}
+#endif
+
+	skb_postpush_rcsum(skb, hdr, tot_len);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(seg6_do_srh_encap_red);
+
 /* insert an SRH within an IPv6 packet, just after the IPv6 header */
 int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 {
@@ -265,6 +342,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 			return err;
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 		if (err)
 			return err;
@@ -276,7 +354,11 @@ static int seg6_do_srh(struct sk_buff *skb)
 		else
 			return -EINVAL;
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+		if (tinfo->mode == SEG6_IPTUN_MODE_ENCAP)
+			err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+		else
+			err = seg6_do_srh_encap_red(skb, tinfo->srh, proto);
+
 		if (err)
 			return err;
 
@@ -285,6 +367,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		if (!skb_mac_header_was_set(skb))
 			return -EINVAL;
 
@@ -294,7 +377,11 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb_mac_header_rebuild(skb);
 		skb_push(skb, skb->mac_len);
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
+		if (tinfo->mode == SEG6_IPTUN_MODE_L2ENCAP)
+			err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
+		else
+			err = seg6_do_srh_encap_red(skb, tinfo->srh, IPPROTO_ETHERNET);
+
 		if (err)
 			return err;
 
@@ -514,6 +601,10 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
 		break;
+	case SEG6_IPTUN_MODE_ENCAP_RED:
+		break;
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1

