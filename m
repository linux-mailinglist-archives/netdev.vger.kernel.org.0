Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA3215742
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgGFMam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:30:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59931 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729016AbgGFMal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594038639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wXWAdqNpNpJ8PzmXu+LnUcnHfb9Qo0xXxjNDy2nWeNs=;
        b=P2CVz14e9TDBHG5lg+6Xd/eqWu66tVVi0EgFPORiGatISnXyAglDfV6YamzWeITONsCYzO
        t3spEIiywC/KBVIXgFRBq+Tievg6wokWXESVPrMYzaDVRkRn6yYowsQSsubf0uGJvvB4bp
        w8HP1lam7r6QE7A+oSEHclKxtU0t8b8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-NqUnxRxINe-3tKCB1x3PPQ-1; Mon, 06 Jul 2020 08:30:37 -0400
X-MC-Unique: NqUnxRxINe-3tKCB1x3PPQ-1
Received: by mail-il1-f200.google.com with SMTP id q9so2727973ilt.15
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wXWAdqNpNpJ8PzmXu+LnUcnHfb9Qo0xXxjNDy2nWeNs=;
        b=bbw6p/WvSwtHDpy/FEjRJC46noa5C16P8DE1omV8IAa3odw0buvwpNDoH3kxbxMf/3
         pioTxCV1mT8JycslN4KIGDhk5jtbPQdpT1Mx/z+tyo+v0s+Mhpu3SUsWcaWZpNZESnn4
         bFCMBh7E4pmgss1DISiBLTzaxxflyj+iC99xNKrDo3MVmZuL0PiUXV3OACnXsQdfGotG
         3QphvxyQDKAu87g2TE5Rj+9Ofz+tSLnBzfydZZnmVa/gKhwuoPgNcWY84tuj40EmRcXJ
         vkFcsDjYH2m5KH3mIAVVd1Z7aEl+CBx+UvXvUwvURDksJoV/kMwgQu8Xt5aEXCyTU83Q
         6jNQ==
X-Gm-Message-State: AOAM532NbnxFE4h37H76Y2DV2gemxMGqJQ5mT3zqdSUVJAnhHrSX5K8H
        7HbMqsyE58e10lIpqLraPgjrLb70NxrBVTVu6zQnIXOF//AmG5/JDKEFj901r2QOvYMEAj5l/f0
        czG4iLC+HuWJrCtkz
X-Received: by 2002:a92:d9c4:: with SMTP id n4mr13321185ilq.280.1594038637287;
        Mon, 06 Jul 2020 05:30:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3xF55IVY4TMVryG+hd/owtJ6QxxvTlfa8bAab9hAsQJBUZzelZQCb4KQXHAJv57LXdauSGg==
X-Received: by 2002:a92:d9c4:: with SMTP id n4mr13321160ilq.280.1594038636982;
        Mon, 06 Jul 2020 05:30:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m16sm9955840ili.26.2020.07.06.05.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 05:30:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1C70C1804EA; Mon,  6 Jul 2020 14:30:34 +0200 (CEST)
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
Subject: [PATCH net] vlan: consolidate VLAN parsing code and limit max parsing depth
Date:   Mon,  6 Jul 2020 14:29:51 +0200
Message-Id: <20200706122951.48142-1-toke@redhat.com>
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
limiting the VLAN tag parsing to an arbitrarily-chosen, but hopefully
conservative, max depth of 32 tags. As part of this, switch over
__vlan_get_protocol() to use skb_header_pointer() instead of
pskb_may_pull(), to avoid the possible side effects of the latter and keep
the skb pointer 'const' through all the parsing functions.

Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/if_vlan.h | 57 ++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 427a5b8597c2..855d16192e6a 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -25,6 +25,8 @@
 #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
 #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
 
+#define VLAN_MAX_DEPTH	32		/* Max. number of nested VLAN tags parsed */
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

