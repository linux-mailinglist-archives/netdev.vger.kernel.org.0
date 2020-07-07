Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE58B216B00
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 13:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgGGLDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 07:03:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51616 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbgGGLDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 07:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594119827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/RIN1Em334z8LIVvelBPnmQNOQzrxSshKtghYOZh9Fo=;
        b=bKb3DzC9D3azGk/d2kVEciOW7N7mODDHTJqQgi5EZT9URqyO98hhCdg6RjIspikGsCPEYA
        k799OZm/N6bmXfn0EdIUrq5vGAtV5iommtvGN229Zw5Zyd9G9eXUrEDH22/uZZE0j7PPPE
        dPnQPjVgxbODWEHs8N6Tt2wYLwNOsI0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-ff98fzMwM5K_ALbZlX4eEQ-1; Tue, 07 Jul 2020 07:03:45 -0400
X-MC-Unique: ff98fzMwM5K_ALbZlX4eEQ-1
Received: by mail-pg1-f198.google.com with SMTP id s8so14450663pgs.9
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 04:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/RIN1Em334z8LIVvelBPnmQNOQzrxSshKtghYOZh9Fo=;
        b=Wfgs+hcy0p2VhboFl+7fCJ3Qy3GlSkVLRC1lLh1INbF13hXZqQczA053M9WfKiWEoa
         FdbtqGbnwn2DyL8ALAtRR76lwb1d9PUC2x/8jxFiGj11GQCcDhWoRY8/APgcHtNBOEBs
         oNu9OtwnU6OJnyFPl4ybF5P2qClG5v7uLYSASlOxuB0ZkIG7J1qEp2oGqssOabBhoRzb
         hGFjYuN33GguzoW6MZ9AOVFEDX5AVkSjZmhUy8OCmQ/X5iKcK1pyhuOrJdVXOCupTl0k
         i6xorngby17XhQG1exNfm7Zkx+lAJ7zwoLzzuv40RmWzP4Hvbn3+1qYy1cUhCpuEkufq
         x6+g==
X-Gm-Message-State: AOAM5328cxsMzuY/MZ2E67cOCpD9I/ld947u03zCcGnGdLamtK3xd2fw
        TeDnrgBw7zkxisbmicYZOfWgBADEmGtWSMYSnPLQv8uQg6UQGHF4E6SDGPexNq/ptSznrV6aW1c
        K4ZeagbwdVZofP+zT
X-Received: by 2002:a17:902:a981:: with SMTP id bh1mr35954913plb.280.1594119824748;
        Tue, 07 Jul 2020 04:03:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGMMeyvnujKsOJqn50a7El3vmNL/HiMAtNDmgqDLt6YU6KJAiQK/2UZNvQK5WOuX0gv/H0hg==
X-Received: by 2002:a17:902:a981:: with SMTP id bh1mr35954889plb.280.1594119824462;
        Tue, 07 Jul 2020 04:03:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ng12sm2288553pjb.15.2020.07.07.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 04:03:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A25601804ED; Tue,  7 Jul 2020 13:03:38 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net v2] vlan: consolidate VLAN parsing code and limit max parsing depth
Date:   Tue,  7 Jul 2020 13:03:25 +0200
Message-Id: <20200707110325.86731-1-toke@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki pointed out that we now have two very similar functions to extract
the L3 protocol number in the presence of VLAN tags. And Daniel pointed out
that the unbounded parsing loop makes it possible for maliciously crafted
packets to loop through potentially hundreds of tags.

Fix both of these issues by consolidating the two parsing functions and
limiting the VLAN tag parsing to a max depth of 8 tags. As part of this,
switch over __vlan_get_protocol() to use skb_header_pointer() instead of
pskb_may_pull(), to avoid the possible side effects of the latter and keep
the skb pointer 'const' through all the parsing functions.

v2:
- Use limit of 8 tags instead of 32 (matching XMIT_RECURSION_LIMIT)

Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/if_vlan.h | 57 ++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 427a5b8597c2..41a518336673 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -25,6 +25,8 @@
 #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
 #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
 
+#define VLAN_MAX_DEPTH	8		/* Max. number of nested VLAN tags parsed */
+
 /*
  * 	struct vlan_hdr - vlan header
  * 	@h_vlan_TCI: priority and VLAN ID
@@ -308,34 +310,6 @@ static inline bool eth_type_vlan(__be16 ethertype)
 	}
 }
 
-/* A getter for the SKB protocol field which will handle VLAN tags consistently
- * whether VLAN acceleration is enabled or not.
- */
-static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
-{
-	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
-	__be16 proto = skb->protocol;
-
-	if (!skip_vlan)
-		/* VLAN acceleration strips the VLAN header from the skb and
-		 * moves it to skb->vlan_proto
-		 */
-		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
-
-	while (eth_type_vlan(proto)) {
-		struct vlan_hdr vhdr, *vh;
-
-		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
-		if (!vh)
-			break;
-
-		proto = vh->h_vlan_encapsulated_proto;
-		offset += sizeof(vhdr);
-	}
-
-	return proto;
-}
-
 static inline bool vlan_hw_offload_capable(netdev_features_t features,
 					   __be16 proto)
 {
@@ -605,10 +579,10 @@ static inline int vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
  * Returns the EtherType of the packet, regardless of whether it is
  * vlan encapsulated (normal or hardware accelerated) or not.
  */
-static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
+static inline __be16 __vlan_get_protocol(const struct sk_buff *skb, __be16 type,
 					 int *depth)
 {
-	unsigned int vlan_depth = skb->mac_len;
+	unsigned int vlan_depth = skb->mac_len, parse_depth = VLAN_MAX_DEPTH;
 
 	/* if type is 802.1Q/AD then the header should already be
 	 * present at mac_len - VLAN_HLEN (if mac_len > 0), or at
@@ -623,13 +597,12 @@ static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
 			vlan_depth = ETH_HLEN;
 		}
 		do {
-			struct vlan_hdr *vh;
+			struct vlan_hdr vhdr, *vh;
 
-			if (unlikely(!pskb_may_pull(skb,
-						    vlan_depth + VLAN_HLEN)))
+			vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
+			if (unlikely(!vh || !--parse_depth))
 				return 0;
 
-			vh = (struct vlan_hdr *)(skb->data + vlan_depth);
 			type = vh->h_vlan_encapsulated_proto;
 			vlan_depth += VLAN_HLEN;
 		} while (eth_type_vlan(type));
@@ -648,11 +621,25 @@ static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
  * Returns the EtherType of the packet, regardless of whether it is
  * vlan encapsulated (normal or hardware accelerated) or not.
  */
-static inline __be16 vlan_get_protocol(struct sk_buff *skb)
+static inline __be16 vlan_get_protocol(const struct sk_buff *skb)
 {
 	return __vlan_get_protocol(skb, skb->protocol, NULL);
 }
 
+/* A getter for the SKB protocol field which will handle VLAN tags consistently
+ * whether VLAN acceleration is enabled or not.
+ */
+static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
+{
+	if (!skip_vlan)
+		/* VLAN acceleration strips the VLAN header from the skb and
+		 * moves it to skb->vlan_proto
+		 */
+		return skb_vlan_tag_present(skb) ? skb->vlan_proto : skb->protocol;
+
+	return vlan_get_protocol(skb);
+}
+
 static inline void vlan_set_encap_proto(struct sk_buff *skb,
 					struct vlan_hdr *vhdr)
 {
-- 
2.27.0

