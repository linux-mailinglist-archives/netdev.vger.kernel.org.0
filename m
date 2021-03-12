Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4EF33828C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCLAre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhCLArM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:47:12 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E67C061760
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:47:11 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p21so14754125pgl.12
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eT5U+pvsCw+KEs7/mMJrKZWJ1TeJVme2/LfExwRjCHo=;
        b=ZKBNCjZ/Hokd9Ij6edwyLOMsvWIqsbCLbOwgSEUcpmRVptaOtAHxr9PhiMdzsHnAMT
         12VY1vGAlI3ODOVzszWv/c/yjenT8R1+LNAwc20vw4rGNWlpvOmt1qEt6ALgNmPe3ZVj
         t2/ifqCj93WWVuAAAZPFf8uZtyaKrGhuvjMF+snJ5QMm1+JkklE+U60Kt2kZHd4y5qZh
         hzkwP3g6TnLPZJeupYq3KUEfZ9nYKW6E0vFjcihrkra6Mr4fpfPlVUMwTcB11GpZhF7R
         762UJ0es9LkhK3lPcfOqlYkLnIplQB7MtJOLpC+jYJ47HpQTWhZwLmI35QUx++BDkVPU
         8ubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eT5U+pvsCw+KEs7/mMJrKZWJ1TeJVme2/LfExwRjCHo=;
        b=Y4/IV9Y8yTQ7yLm/GD/8o/DZSi/+yjE4hhb67UdcYBp4n0Lx/UhfYFCRpZywjd4wKt
         4EGWmy/izvoM45G6y3oL3akJhqFDB4MsuxsEfhWNEA4QdkJcyBOoHhDArZXSxmX4U0JK
         0ipqs1xq8SVtOm/xmtt3fgxJ6V0KH40qRSwvD2FjAhJPd6Dzh7TzK0Fhypskm8O26LNv
         1sxXKYDQqm86+MwiPD7cUpDLnr0xmH0bhH+6Qx3arF9xvw112RdEvmF9XVi6ao6bOdN3
         TK1ifPQXkpgZqmJoTVj/ojogwEtInJc6uGPBnkhW1ivfCMC+J2xlxCzuaa2CKu99vKsx
         J8xA==
X-Gm-Message-State: AOAM532nyktUrfiDBxGRM/hVTLQ2/GjwVHNeTQIVhAc0kHWr1akhpZt4
        C5JqnWDMYEPjodRKyi3lVg0=
X-Google-Smtp-Source: ABdhPJzCQeFMu8E4lbHzWCDjH0gT1pVWJXMAMTllB20eQDqbbASfFHF+iOHEssu2b17ylFFEXQYWPQ==
X-Received: by 2002:a62:ab0e:0:b029:1f6:2620:d6a8 with SMTP id p14-20020a62ab0e0000b02901f62620d6a8mr9638523pff.13.1615510031466;
        Thu, 11 Mar 2021 16:47:11 -0800 (PST)
Received: from localhost.localdomain ([2600:8801:131a:4600:ddb7:d473:4421:2c9f])
        by smtp.googlemail.com with ESMTPSA id j4sm3353484pfa.131.2021.03.11.16.47.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Mar 2021 16:47:11 -0800 (PST)
From:   ishaangandhi <ishaangandhi@gmail.com>
To:     davem@davemloft.net
Cc:     ishaangandhi@gmail.com, netdev@vger.kernel.org, willemb@google.com
Subject: [PATCH] icmp: support rfc 5837
Date:   Thu, 11 Mar 2021 16:47:06 -0800
Message-Id: <20210312004706.33046-1-ishaangandhi@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ishaan Gandhi <ishaangandhi@gmail.com>

This patch identifies the interface a packet arrived on when sending
ICMP time exceeded, destination unreachable, and parameter problem
messages, in accordance with RFC 5837.

It was tested by pinging a machine with a ttl of 1, and observing the
response in Wireshark.

Signed-off-by: Ishaan Gandhi <ishaangandhi@gmail.com>

---
 include/uapi/linux/icmp.h |  21 ++++++
 net/ipv4/icmp.c           | 137 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..5e5a75abe0a4 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -118,4 +118,25 @@ struct icmp_extobj_hdr {
 	__u8		class_type;
 };
 
+/* RFC 5837 Bitmasks */
+#define ICMP_5837_MTU_CTYPE			(1 << 0)
+#define ICMP_5837_NAME_CTYPE		(1 << 1)
+#define ICMP_5837_IP_ADDR_CTYPE		(1 << 2)
+#define ICMP_5837_IF_INDEX_CTYPE	(1 << 3)
+
+#define ICMP_5837_ARRIVAL_ROLE_CTYPE	(0 << 6)
+#define ICMP_5837_SUB_IP_ROLE_CTYPE		(1 << 6)
+#define ICMP_5837_FORWARD_ROLE_CTYPE	(2 << 6)
+#define ICMP_5837_NEXT_HOP_ROLE_CTYPE	(3 << 6)
+
+#define ICMP_5837_MIN_ORIG_LEN 128
+#define ICMP_5837_MAX_NAME_LEN 63
+
+/* RFC 5837 Interface IP Address sub-object */
+struct interface_ipv4_addr_sub_obj {
+	__be16 afi;
+	__be16 reserved;
+	__be32 addr;
+};
+
 #endif /* _UAPI_LINUX_ICMP_H */
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 793aebf07c2a..3abae84a6e9e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -555,6 +555,139 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	return ERR_PTR(err);
 }
 
+/*  Appends interface identification object to ICMP packet to identify
+ *  the interface on which the original datagram arrived, per RFC 5837.
+ *
+ *  Should only be called on the following messages
+ *  - ICMPv4 Time Exceeded
+ *  - ICMPv4 Destination Unreachable
+ *  - ICMPv4 Parameter Problem
+ */
+
+void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
+				     struct icmphdr *icmph)
+{
+	unsigned int ext_len, if_index, orig_len, offset, extra_space_needed,
+		     word_aligned_orig_len, mtu, name_len, name_subobj_len;
+	struct interface_ipv4_addr_sub_obj ip_addr;
+	struct icmp_extobj_hdr *iio_hdr;
+	struct icmp_ext_hdr *ext_hdr;
+	struct net_device *dev;
+	void *subobj_offset;
+	char *name, ctype;
+
+	skb_linearize(skb);
+	if_index = inet_iif(skb);
+	orig_len = skb->len - skb_network_offset(skb);
+	word_aligned_orig_len = (orig_len + 3) & ~0x03;
+
+	// Original datagram length is measured in 32-bit words
+	icmph->un.reserved[1] = word_aligned_orig_len / 4;
+	ctype = ICMP_5837_ARRIVAL_ROLE_CTYPE;
+
+	ext_len = sizeof(struct icmp_ext_hdr) + sizeof(struct icmp_extobj_hdr);
+
+	// Always add if_index to the IIO
+	ext_len += 4;
+	ctype |= ICMP_5837_IF_INDEX_CTYPE;
+
+	dev = dev_get_by_index(net, if_index);
+	// Try to append IP address, name, and MTU
+	if (dev) {
+		ip_addr.addr = inet_select_addr(dev, 0, RT_SCOPE_UNIVERSE);
+		if (ip_addr.addr) {
+			ip_addr.afi = htons(1);
+			ip_addr.reserved = 0;
+			ctype |= ICMP_5837_IP_ADDR_CTYPE;
+			ext_len += 8;
+		}
+
+		name = dev->name;
+		if (name) {
+			name_len = strlen(name);
+			name_subobj_len = min_t(unsigned int, name_len, ICMP_5837_MAX_NAME_LEN) + 1;
+			name_subobj_len = (name_subobj_len + 3) & ~0x03;
+			ctype |= ICMP_5837_NAME_CTYPE;
+			ext_len += name_subobj_len;
+		}
+
+		mtu = dev->mtu;
+		if (mtu) {
+			ctype |= ICMP_5837_MTU_CTYPE;
+			ext_len += 4;
+		}
+	}
+
+	if (word_aligned_orig_len + ext_len > room) {
+		offset = room - ext_len;
+		extra_space_needed = room - orig_len;
+	} else if (orig_len < ICMP_5837_MIN_ORIG_LEN) {
+		// Original packet must be zero padded to 128 bytes
+		offset = ICMP_5837_MIN_ORIG_LEN;
+		extra_space_needed = offset + ext_len - orig_len;
+	} else {
+		// There is enough room to just add to the end of the packet
+		offset = word_aligned_orig_len;
+		extra_space_needed = ext_len;
+	}
+
+	if (skb_tailroom(skb) < extra_space_needed) {
+		if (pskb_expand_head(skb, 0, extra_space_needed - skb_tailroom(skb), GFP_ATOMIC))
+			return;
+	}
+
+	// Zero-pad from the end of the original message to the beginning of the header
+	if (orig_len < ICMP_5837_MIN_ORIG_LEN) {
+		// Original packet must be zero padded to 128 bytes
+		memset(skb_network_header(skb) + orig_len, 0, ICMP_5837_MIN_ORIG_LEN - orig_len);
+	} else {
+		// Just zero-pad so the original packet is aligned on a 4 byte boundary
+		memset(skb_network_header(skb) + orig_len, 0, word_aligned_orig_len - orig_len);
+	}
+
+	skb_put(skb, extra_space_needed);
+	ext_hdr = (struct icmp_ext_hdr *)(skb_network_header(skb) + offset);
+	iio_hdr = (struct icmp_extobj_hdr *)(ext_hdr + 1);
+	subobj_offset = (void *)(iio_hdr + 1);
+
+	ext_hdr->reserved1 = 0;
+	ext_hdr->reserved2 = 0;
+	ext_hdr->version = 2;
+	ext_hdr->checksum = 0;
+
+	iio_hdr->length = htons(ext_len - 4);
+	iio_hdr->class_num = 2;
+	iio_hdr->class_type = ctype;
+
+	*(__be32 *)subobj_offset = htonl(if_index);
+	subobj_offset += sizeof(__be32);
+
+	if (ip_addr.addr) {
+		*(struct interface_ipv4_addr_sub_obj *)subobj_offset = ip_addr;
+		subobj_offset += sizeof(ip_addr);
+	}
+
+	if (name) {
+		*(__u8 *)subobj_offset = name_subobj_len;
+		subobj_offset += sizeof(__u8);
+		if (name_len >= ICMP_5837_MAX_NAME_LEN) {
+			memcpy(subobj_offset, name, ICMP_5837_MAX_NAME_LEN);
+		} else {
+			memcpy(subobj_offset, name, name_len);
+			memset(subobj_offset + name_len, 0, name_subobj_len - name_len - 1);
+		}
+		subobj_offset += name_subobj_len - sizeof(__u8);
+	}
+
+	if (mtu) {
+		*(__be32 *)subobj_offset = htonl(mtu);
+		subobj_offset += sizeof(__be32);
+	}
+
+	ext_hdr->checksum =
+		csum_fold(skb_checksum(skb, skb_network_offset(skb) + offset, ext_len, 0));
+}
+
 /*
  *	Send an ICMP message in response to a situation
  *
@@ -731,6 +864,10 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
+	if (type == ICMP_DEST_UNREACH || type == ICMP_TIME_EXCEEDED ||
+	    type == ICMP_PARAMETERPROB) {
+		icmp_identify_arrival_interface(skb_in, net, room, &icmp_param.data.icmph);
+	}
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
 	if (icmp_param.data_len > room)
-- 
2.25.1

