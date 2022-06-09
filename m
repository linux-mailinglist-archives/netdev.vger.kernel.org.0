Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E89544DA7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbiFIN2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbiFIN2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:28:09 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B0E43AE7
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:28:06 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w20so16334733lfa.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CA1vcPqBgIxBCQLD168Th5vuI9AxY5IDAMreZAed/SE=;
        b=KCvWAKNMcqgLDDADqLLijIylHwdi8A9s2Rk0ugCRt0sUpyjm2oam8a0qH9tUr4Fce3
         YBg+9USaHfz4uPma9YC6UUed9Hh8FFtRRBiBJR//6I/1i0Oeie+S7d7NWtQwolDTAhHa
         woEfJkpVfAbiq8mc4LN1WyBnDuvdJ78QafPuaW/b/Hprp982c9HZ4hvwfn0vIEPVB3V8
         po426tbKLYAH9cDYVG0w6Mza9GvCKY3bTBK3hAfyjphb3zQ087TOigV96ND2oVqRJ/yO
         pEH2j0rOPwrS6C3vJ3b0yqQnavqpNcW31axKJeOIVag1usezcLexlNomFdi3EMQKGQmY
         ieCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CA1vcPqBgIxBCQLD168Th5vuI9AxY5IDAMreZAed/SE=;
        b=6zkRfVETPIGyodenXCCIjnCyQbqQ8ph6STtwCGf4WZpCbSJJRWmcfmm/NteX6wis73
         XFg6YPZ3nXEQ/DzmkExC5HTc2DPN7k3vJvFWtqECFFFOajkwbAPQxX19wkmGq+Awsi5n
         /mcGTDYbfHbgbozB5TfyxnjYd/+z4p8mYCnnJIk7g/m5dsEnJi8i5oMHNkGiajMsIGJc
         c9im4bdlbudUvw+UdS8KL5ULQ01U0GtZl8fNKmyLGSFtkiy/7uvuVPTU2aufQK3MrTUA
         rKeqdNhVm74XRGDwR7I2kcrLmjHia9sgJLDiHoFNN+8tlcTmpEOS5HSXJ+ZN7/b51ugh
         hnvA==
X-Gm-Message-State: AOAM530PrggP8FRopV5JcsBfZ67XdR47Vu1sYdzBkOgsA3Tl1cnhof/O
        Tyfge8W4j73Zv8xCU9I0Hcs=
X-Google-Smtp-Source: ABdhPJxWa9Qtih6An3k/ErVJUZsdwyXkk4Ec/z4VZiJuXxP/+aTdhMcTbLSok3ctz2mDlskz8hddZw==
X-Received: by 2002:a05:6512:3a81:b0:44a:616f:f75b with SMTP id q1-20020a0565123a8100b0044a616ff75bmr24379599lfu.2.1654781284432;
        Thu, 09 Jun 2022 06:28:04 -0700 (PDT)
Received: from extra.gateflow.net ([46.109.159.121])
        by smtp.gmail.com with ESMTPSA id 1-20020a05651c12c100b0025550585f8bsm3712106lje.31.2022.06.09.06.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 06:28:03 -0700 (PDT)
From:   Anton Makarov <antonmakarov11235@gmail.com>
X-Google-Original-From: Anton Makarov <anton.makarov11235@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        david.lebrun@uclouvain.be, kuba@kernel.org
Cc:     Anton Makarov <anton.makarov11235@gmail.com>
Subject: [net-next v2 1/1] net: seg6: Add support for SRv6 Headend Reduced Encapsulation
Date:   Thu,  9 Jun 2022 16:27:50 +0300
Message-Id: <20220609132750.4917-1-anton.makarov11235@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
v2: 1) Fixed sparse warnings
    2) memset now uses sizeof() instead of hardcoded value
    3) Removed EXPORT_SYMBOL_GPL
---
 include/net/seg6.h                 |  2 +
 include/uapi/linux/seg6_iptunnel.h |  2 +
 net/ipv6/seg6_iptunnel.c           | 94 +++++++++++++++++++++++++++++-
 3 files changed, 96 insertions(+), 2 deletions(-)

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
index d64855010948..e70c0401715e 100644
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
 
@@ -195,6 +197,80 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
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
+	memset(skb->cb, 0, sizeof(skb->cb));
+	IP6CB(skb)->iif = skb->skb_iif;
+
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
+			     flowlabel);
+		hdr->hop_limit = inner_hdr6->hop_limit;
+	} else if (skb->protocol == htons(ETH_P_IP)) {
+		ip6_flow_hdr(hdr, (unsigned int) inner_hdr4->tos, flowlabel);
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
+
 /* insert an SRH within an IPv6 packet, just after the IPv6 header */
 int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 {
@@ -265,6 +341,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 			return err;
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 		if (err)
 			return err;
@@ -276,7 +353,11 @@ static int seg6_do_srh(struct sk_buff *skb)
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
 
@@ -285,6 +366,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		if (!skb_mac_header_was_set(skb))
 			return -EINVAL;
 
@@ -294,7 +376,11 @@ static int seg6_do_srh(struct sk_buff *skb)
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
 
@@ -514,6 +600,10 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
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

