Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C7450A7A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKORJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhKORI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:08:56 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA43C061714
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:00 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id q17so14953094plr.11
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pfP9vUZBirI4dWZuual+0XhMYrQ7HMJWYqAetf68E8E=;
        b=PD7pz50DyqzNb7gxVw1oGvX1rqbpag1zWJdVfNrx2/2ZABdh2fqD2x3K3qp4i9mla4
         OFQxVoD2sIYjGPtVyPxwU+LVqY66PsyeMO0VXlpWiHP/9C0QDgi9mEQTz22qf4TTWy3X
         hutrw4rN8rxUZUPaLsnhHlXDnG79bGorZhO+zathi7CITI7MmoVDxsvlj7O0zlDBF4Sk
         aLQXMiYfHiPdlG5pEhLRLv36xRU58PFqxvuwSo+mKNQdHPULoX02EV7AcRmLZo8wiell
         UtMocpC9PQYSNEtU/CM+7VATzK1AasqVbsWfLwdvgvSWR9A8WB8kiZ9dZUIifNtd9+zB
         dzoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pfP9vUZBirI4dWZuual+0XhMYrQ7HMJWYqAetf68E8E=;
        b=WSs1R3c/Lja2sPaaUvvfdmr3mBoLqTfBLTIQWeE2Iw/dJMFgcW5T/85/wZwfgyl/Tc
         Ki19+Kj6unv+Gbts2zhnQgyWzAkp0+0LPlihxyLJrrxPK+L2xjff54fpG4xqYz2bYREQ
         KWqoVB6vGan9bKhoNszP45TM2P5VqIxzEkAC8TTFASBtvwpaKRNokEghN0SAqTHT7/sn
         Kq7HftMeDvbSeqDGlj4jgMX9sPiCMeG74YHbmxRMDKwaq5qIeRTcbMPnK9hUkYksrOBT
         lHP28FjhvE7vLHYfK2YRBRbUoiWPEpbFj4RHywn/vCOlB4lAbYfuTJXefAN9HyiYbZlU
         o8Ww==
X-Gm-Message-State: AOAM531B9/I4EFGD0ZE29oDIFK6KFoqLnRX8ReQvbyKgsVakTfALuvoA
        30hQIeUm9usA45qhU5PvP9z81aeVQTo=
X-Google-Smtp-Source: ABdhPJxx9ACAZo8qnHFXS5HGcPxhNYGjU3ItGpdeSFvaqgsorJMUTRPlcxdJoJrJYeYd52gkrJ9rFA==
X-Received: by 2002:a17:90b:33cf:: with SMTP id lk15mr25750pjb.85.1636995959918;
        Mon, 15 Nov 2021 09:05:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id y28sm15971845pfa.208.2021.11.15.09.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:05:59 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] net: move gro definitions to include/net/gro.h
Date:   Mon, 15 Nov 2021 09:05:51 -0800
Message-Id: <20211115170554.3645322-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115170554.3645322-1-eric.dumazet@gmail.com>
References: <20211115170554.3645322-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

include/linux/netdevice.h became too big, move gro stuff
into include/net/gro.h

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
 drivers/net/geneve.c                          |   1 +
 drivers/net/vxlan.c                           |   1 +
 include/linux/netdevice.h                     | 348 ---------------
 include/net/gro.h                             | 396 +++++++++++++++++-
 include/net/ip.h                              |   8 -
 include/net/ip6_checksum.h                    |   8 -
 include/net/udp.h                             |  24 --
 net/core/skbuff.c                             |   1 +
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/esp4_offload.c                       |   1 +
 net/ipv4/fou.c                                |   1 +
 net/ipv4/gre_offload.c                        |   1 +
 net/ipv4/tcp_offload.c                        |   1 +
 net/ipv4/udp_offload.c                        |   1 +
 net/ipv6/esp6_offload.c                       |   1 +
 net/ipv6/tcpv6_offload.c                      |   1 +
 net/ipv6/udp_offload.c                        |   1 +
 22 files changed, 411 insertions(+), 390 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e8e8c2d593c558f15a9282c424ed23db7a256e71..54a2334dee56336a611a2410dc43a78eea83467b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -25,6 +25,7 @@
 #include <linux/ip.h>
 #include <linux/crash_dump.h>
 #include <net/tcp.h>
+#include <net/gro.h>
 #include <net/ipv6.h>
 #include <net/ip6_checksum.h>
 #include <linux/prefetch.h>
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c04ea83188e22d36e23c8262331aad26a4c1dc86..c057b1df86a9c9103ee8a682cb87ab92def5eed4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -37,6 +37,7 @@
 #include <linux/if_bridge.h>
 #include <linux/rtc.h>
 #include <linux/bpf.h>
+#include <net/gro.h>
 #include <net/ip.h>
 #include <net/tcp.h>
 #include <net/udp.h>
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9ccebbaa0d696e748636a508053aa957c43841ae..13835a37b3a2fd13d557750fb3943172fc2eb700 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -17,6 +17,7 @@
 #include <linux/skbuff.h>
 #include <linux/sctp.h>
 #include <net/gre.h>
+#include <net/gro.h>
 #include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
 #include <net/tcp.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 96967b0a24418c5aa4018f5396a4a73f731a0c37..e384f6458c063b36faae8cf81910476c10fbd88b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -37,6 +37,7 @@
 #include <net/ip6_checksum.h>
 #include <net/page_pool.h>
 #include <net/inet_ecn.h>
+#include <net/gro.h>
 #include <net/udp.h>
 #include <net/tcp.h>
 #include "en.h"
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 065e9004598ee8f37e4669f48b5239a39426d62b..e113fbd56e869dee0ef7dc087d28907747a038b1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -10,6 +10,7 @@
 #include <linux/bpf_trace.h>
 #include <net/udp_tunnel.h>
 #include <linux/ip.h>
+#include <net/gro.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/if_ether.h>
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1ab94b5f9bbf4a4402ddf0ea6e5b49004b1ff6f2..9d26d1b965d221c7eefbce47fc5e504b7f35cff6 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -17,6 +17,7 @@
 #include <net/gro_cells.h>
 #include <net/rtnetlink.h>
 #include <net/geneve.h>
+#include <net/gro.h>
 #include <net/protocol.h>
 
 #define GENEVE_NETDEV_VER	"0.6"
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 141635a35c28a236f33c180dc2868c64338eccb1..563f86de0e0dce0ab994b5d8ec7cf59133c8dd38 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -17,6 +17,7 @@
 #include <linux/ethtool.h>
 #include <net/arp.h>
 #include <net/ndisc.h>
+#include <net/gro.h>
 #include <net/ipv6_stubs.h>
 #include <net/ip.h>
 #include <net/icmp.h>
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a56dbd51fecd166d572a9e586e3e4..d95c9839ce90d611f4b729c7c54e277446259c7a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2520,109 +2520,6 @@ static inline void netif_napi_del(struct napi_struct *napi)
 	synchronize_net();
 }
 
-struct napi_gro_cb {
-	/* Virtual address of skb_shinfo(skb)->frags[0].page + offset. */
-	void	*frag0;
-
-	/* Length of frag0. */
-	unsigned int frag0_len;
-
-	/* This indicates where we are processing relative to skb->data. */
-	int	data_offset;
-
-	/* This is non-zero if the packet cannot be merged with the new skb. */
-	u16	flush;
-
-	/* Save the IP ID here and check when we get to the transport layer */
-	u16	flush_id;
-
-	/* Number of segments aggregated. */
-	u16	count;
-
-	/* Start offset for remote checksum offload */
-	u16	gro_remcsum_start;
-
-	/* jiffies when first packet was created/queued */
-	unsigned long age;
-
-	/* Used in ipv6_gro_receive() and foo-over-udp */
-	u16	proto;
-
-	/* This is non-zero if the packet may be of the same flow. */
-	u8	same_flow:1;
-
-	/* Used in tunnel GRO receive */
-	u8	encap_mark:1;
-
-	/* GRO checksum is valid */
-	u8	csum_valid:1;
-
-	/* Number of checksums via CHECKSUM_UNNECESSARY */
-	u8	csum_cnt:3;
-
-	/* Free the skb? */
-	u8	free:2;
-#define NAPI_GRO_FREE		  1
-#define NAPI_GRO_FREE_STOLEN_HEAD 2
-
-	/* Used in foo-over-udp, set in udp[46]_gro_receive */
-	u8	is_ipv6:1;
-
-	/* Used in GRE, set in fou/gue_gro_receive */
-	u8	is_fou:1;
-
-	/* Used to determine if flush_id can be ignored */
-	u8	is_atomic:1;
-
-	/* Number of gro_receive callbacks this packet already went through */
-	u8 recursion_counter:4;
-
-	/* GRO is done by frag_list pointer chaining. */
-	u8	is_flist:1;
-
-	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
-	__wsum	csum;
-
-	/* used in skb_gro_receive() slow path */
-	struct sk_buff *last;
-};
-
-#define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
-
-#define GRO_RECURSION_LIMIT 15
-static inline int gro_recursion_inc_test(struct sk_buff *skb)
-{
-	return ++NAPI_GRO_CB(skb)->recursion_counter == GRO_RECURSION_LIMIT;
-}
-
-typedef struct sk_buff *(*gro_receive_t)(struct list_head *, struct sk_buff *);
-static inline struct sk_buff *call_gro_receive(gro_receive_t cb,
-					       struct list_head *head,
-					       struct sk_buff *skb)
-{
-	if (unlikely(gro_recursion_inc_test(skb))) {
-		NAPI_GRO_CB(skb)->flush |= 1;
-		return NULL;
-	}
-
-	return cb(head, skb);
-}
-
-typedef struct sk_buff *(*gro_receive_sk_t)(struct sock *, struct list_head *,
-					    struct sk_buff *);
-static inline struct sk_buff *call_gro_receive_sk(gro_receive_sk_t cb,
-						  struct sock *sk,
-						  struct list_head *head,
-						  struct sk_buff *skb)
-{
-	if (unlikely(gro_recursion_inc_test(skb))) {
-		NAPI_GRO_CB(skb)->flush |= 1;
-		return NULL;
-	}
-
-	return cb(sk, head, skb);
-}
-
 struct packet_type {
 	__be16			type;	/* This is really htons(ether_type). */
 	bool			ignore_outgoing;
@@ -3008,251 +2905,6 @@ int dev_restart(struct net_device *dev);
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
 int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb);
 
-static inline unsigned int skb_gro_offset(const struct sk_buff *skb)
-{
-	return NAPI_GRO_CB(skb)->data_offset;
-}
-
-static inline unsigned int skb_gro_len(const struct sk_buff *skb)
-{
-	return skb->len - NAPI_GRO_CB(skb)->data_offset;
-}
-
-static inline void skb_gro_pull(struct sk_buff *skb, unsigned int len)
-{
-	NAPI_GRO_CB(skb)->data_offset += len;
-}
-
-static inline void *skb_gro_header_fast(struct sk_buff *skb,
-					unsigned int offset)
-{
-	return NAPI_GRO_CB(skb)->frag0 + offset;
-}
-
-static inline int skb_gro_header_hard(struct sk_buff *skb, unsigned int hlen)
-{
-	return NAPI_GRO_CB(skb)->frag0_len < hlen;
-}
-
-static inline void skb_gro_frag0_invalidate(struct sk_buff *skb)
-{
-	NAPI_GRO_CB(skb)->frag0 = NULL;
-	NAPI_GRO_CB(skb)->frag0_len = 0;
-}
-
-static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
-					unsigned int offset)
-{
-	if (!pskb_may_pull(skb, hlen))
-		return NULL;
-
-	skb_gro_frag0_invalidate(skb);
-	return skb->data + offset;
-}
-
-static inline void *skb_gro_network_header(struct sk_buff *skb)
-{
-	return (NAPI_GRO_CB(skb)->frag0 ?: skb->data) +
-	       skb_network_offset(skb);
-}
-
-static inline void skb_gro_postpull_rcsum(struct sk_buff *skb,
-					const void *start, unsigned int len)
-{
-	if (NAPI_GRO_CB(skb)->csum_valid)
-		NAPI_GRO_CB(skb)->csum = csum_sub(NAPI_GRO_CB(skb)->csum,
-						  csum_partial(start, len, 0));
-}
-
-/* GRO checksum functions. These are logical equivalents of the normal
- * checksum functions (in skbuff.h) except that they operate on the GRO
- * offsets and fields in sk_buff.
- */
-
-__sum16 __skb_gro_checksum_complete(struct sk_buff *skb);
-
-static inline bool skb_at_gro_remcsum_start(struct sk_buff *skb)
-{
-	return (NAPI_GRO_CB(skb)->gro_remcsum_start == skb_gro_offset(skb));
-}
-
-static inline bool __skb_gro_checksum_validate_needed(struct sk_buff *skb,
-						      bool zero_okay,
-						      __sum16 check)
-{
-	return ((skb->ip_summed != CHECKSUM_PARTIAL ||
-		skb_checksum_start_offset(skb) <
-		 skb_gro_offset(skb)) &&
-		!skb_at_gro_remcsum_start(skb) &&
-		NAPI_GRO_CB(skb)->csum_cnt == 0 &&
-		(!zero_okay || check));
-}
-
-static inline __sum16 __skb_gro_checksum_validate_complete(struct sk_buff *skb,
-							   __wsum psum)
-{
-	if (NAPI_GRO_CB(skb)->csum_valid &&
-	    !csum_fold(csum_add(psum, NAPI_GRO_CB(skb)->csum)))
-		return 0;
-
-	NAPI_GRO_CB(skb)->csum = psum;
-
-	return __skb_gro_checksum_complete(skb);
-}
-
-static inline void skb_gro_incr_csum_unnecessary(struct sk_buff *skb)
-{
-	if (NAPI_GRO_CB(skb)->csum_cnt > 0) {
-		/* Consume a checksum from CHECKSUM_UNNECESSARY */
-		NAPI_GRO_CB(skb)->csum_cnt--;
-	} else {
-		/* Update skb for CHECKSUM_UNNECESSARY and csum_level when we
-		 * verified a new top level checksum or an encapsulated one
-		 * during GRO. This saves work if we fallback to normal path.
-		 */
-		__skb_incr_checksum_unnecessary(skb);
-	}
-}
-
-#define __skb_gro_checksum_validate(skb, proto, zero_okay, check,	\
-				    compute_pseudo)			\
-({									\
-	__sum16 __ret = 0;						\
-	if (__skb_gro_checksum_validate_needed(skb, zero_okay, check))	\
-		__ret = __skb_gro_checksum_validate_complete(skb,	\
-				compute_pseudo(skb, proto));		\
-	if (!__ret)							\
-		skb_gro_incr_csum_unnecessary(skb);			\
-	__ret;								\
-})
-
-#define skb_gro_checksum_validate(skb, proto, compute_pseudo)		\
-	__skb_gro_checksum_validate(skb, proto, false, 0, compute_pseudo)
-
-#define skb_gro_checksum_validate_zero_check(skb, proto, check,		\
-					     compute_pseudo)		\
-	__skb_gro_checksum_validate(skb, proto, true, check, compute_pseudo)
-
-#define skb_gro_checksum_simple_validate(skb)				\
-	__skb_gro_checksum_validate(skb, 0, false, 0, null_compute_pseudo)
-
-static inline bool __skb_gro_checksum_convert_check(struct sk_buff *skb)
-{
-	return (NAPI_GRO_CB(skb)->csum_cnt == 0 &&
-		!NAPI_GRO_CB(skb)->csum_valid);
-}
-
-static inline void __skb_gro_checksum_convert(struct sk_buff *skb,
-					      __wsum pseudo)
-{
-	NAPI_GRO_CB(skb)->csum = ~pseudo;
-	NAPI_GRO_CB(skb)->csum_valid = 1;
-}
-
-#define skb_gro_checksum_try_convert(skb, proto, compute_pseudo)	\
-do {									\
-	if (__skb_gro_checksum_convert_check(skb))			\
-		__skb_gro_checksum_convert(skb, 			\
-					   compute_pseudo(skb, proto));	\
-} while (0)
-
-struct gro_remcsum {
-	int offset;
-	__wsum delta;
-};
-
-static inline void skb_gro_remcsum_init(struct gro_remcsum *grc)
-{
-	grc->offset = 0;
-	grc->delta = 0;
-}
-
-static inline void *skb_gro_remcsum_process(struct sk_buff *skb, void *ptr,
-					    unsigned int off, size_t hdrlen,
-					    int start, int offset,
-					    struct gro_remcsum *grc,
-					    bool nopartial)
-{
-	__wsum delta;
-	size_t plen = hdrlen + max_t(size_t, offset + sizeof(u16), start);
-
-	BUG_ON(!NAPI_GRO_CB(skb)->csum_valid);
-
-	if (!nopartial) {
-		NAPI_GRO_CB(skb)->gro_remcsum_start = off + hdrlen + start;
-		return ptr;
-	}
-
-	ptr = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, off + plen)) {
-		ptr = skb_gro_header_slow(skb, off + plen, off);
-		if (!ptr)
-			return NULL;
-	}
-
-	delta = remcsum_adjust(ptr + hdrlen, NAPI_GRO_CB(skb)->csum,
-			       start, offset);
-
-	/* Adjust skb->csum since we changed the packet */
-	NAPI_GRO_CB(skb)->csum = csum_add(NAPI_GRO_CB(skb)->csum, delta);
-
-	grc->offset = off + hdrlen + offset;
-	grc->delta = delta;
-
-	return ptr;
-}
-
-static inline void skb_gro_remcsum_cleanup(struct sk_buff *skb,
-					   struct gro_remcsum *grc)
-{
-	void *ptr;
-	size_t plen = grc->offset + sizeof(u16);
-
-	if (!grc->delta)
-		return;
-
-	ptr = skb_gro_header_fast(skb, grc->offset);
-	if (skb_gro_header_hard(skb, grc->offset + sizeof(u16))) {
-		ptr = skb_gro_header_slow(skb, plen, grc->offset);
-		if (!ptr)
-			return;
-	}
-
-	remcsum_unadjust((__sum16 *)ptr, grc->delta);
-}
-
-#ifdef CONFIG_XFRM_OFFLOAD
-static inline void skb_gro_flush_final(struct sk_buff *skb, struct sk_buff *pp, int flush)
-{
-	if (PTR_ERR(pp) != -EINPROGRESS)
-		NAPI_GRO_CB(skb)->flush |= flush;
-}
-static inline void skb_gro_flush_final_remcsum(struct sk_buff *skb,
-					       struct sk_buff *pp,
-					       int flush,
-					       struct gro_remcsum *grc)
-{
-	if (PTR_ERR(pp) != -EINPROGRESS) {
-		NAPI_GRO_CB(skb)->flush |= flush;
-		skb_gro_remcsum_cleanup(skb, grc);
-		skb->remcsum_offload = 0;
-	}
-}
-#else
-static inline void skb_gro_flush_final(struct sk_buff *skb, struct sk_buff *pp, int flush)
-{
-	NAPI_GRO_CB(skb)->flush |= flush;
-}
-static inline void skb_gro_flush_final_remcsum(struct sk_buff *skb,
-					       struct sk_buff *pp,
-					       int flush,
-					       struct gro_remcsum *grc)
-{
-	NAPI_GRO_CB(skb)->flush |= flush;
-	skb_gro_remcsum_cleanup(skb, grc);
-	skb->remcsum_offload = 0;
-}
-#endif
 
 static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 				  unsigned short type,
diff --git a/include/net/gro.h b/include/net/gro.h
index 01edaf3fdda05940a0d6d165373c2eadbb2843f5..1ffbe74b2e35eb2f24343da1765633ba7e74ab67 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -4,9 +4,367 @@
 #define _NET_IPV6_GRO_H
 
 #include <linux/indirect_call_wrapper.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/skbuff.h>
+#include <net/udp.h>
 
-struct list_head;
-struct sk_buff;
+struct napi_gro_cb {
+	/* Virtual address of skb_shinfo(skb)->frags[0].page + offset. */
+	void	*frag0;
+
+	/* Length of frag0. */
+	unsigned int frag0_len;
+
+	/* This indicates where we are processing relative to skb->data. */
+	int	data_offset;
+
+	/* This is non-zero if the packet cannot be merged with the new skb. */
+	u16	flush;
+
+	/* Save the IP ID here and check when we get to the transport layer */
+	u16	flush_id;
+
+	/* Number of segments aggregated. */
+	u16	count;
+
+	/* Start offset for remote checksum offload */
+	u16	gro_remcsum_start;
+
+	/* jiffies when first packet was created/queued */
+	unsigned long age;
+
+	/* Used in ipv6_gro_receive() and foo-over-udp */
+	u16	proto;
+
+	/* This is non-zero if the packet may be of the same flow. */
+	u8	same_flow:1;
+
+	/* Used in tunnel GRO receive */
+	u8	encap_mark:1;
+
+	/* GRO checksum is valid */
+	u8	csum_valid:1;
+
+	/* Number of checksums via CHECKSUM_UNNECESSARY */
+	u8	csum_cnt:3;
+
+	/* Free the skb? */
+	u8	free:2;
+#define NAPI_GRO_FREE		  1
+#define NAPI_GRO_FREE_STOLEN_HEAD 2
+
+	/* Used in foo-over-udp, set in udp[46]_gro_receive */
+	u8	is_ipv6:1;
+
+	/* Used in GRE, set in fou/gue_gro_receive */
+	u8	is_fou:1;
+
+	/* Used to determine if flush_id can be ignored */
+	u8	is_atomic:1;
+
+	/* Number of gro_receive callbacks this packet already went through */
+	u8 recursion_counter:4;
+
+	/* GRO is done by frag_list pointer chaining. */
+	u8	is_flist:1;
+
+	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
+	__wsum	csum;
+
+	/* used in skb_gro_receive() slow path */
+	struct sk_buff *last;
+};
+
+#define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
+
+#define GRO_RECURSION_LIMIT 15
+static inline int gro_recursion_inc_test(struct sk_buff *skb)
+{
+	return ++NAPI_GRO_CB(skb)->recursion_counter == GRO_RECURSION_LIMIT;
+}
+
+typedef struct sk_buff *(*gro_receive_t)(struct list_head *, struct sk_buff *);
+static inline struct sk_buff *call_gro_receive(gro_receive_t cb,
+					       struct list_head *head,
+					       struct sk_buff *skb)
+{
+	if (unlikely(gro_recursion_inc_test(skb))) {
+		NAPI_GRO_CB(skb)->flush |= 1;
+		return NULL;
+	}
+
+	return cb(head, skb);
+}
+
+typedef struct sk_buff *(*gro_receive_sk_t)(struct sock *, struct list_head *,
+					    struct sk_buff *);
+static inline struct sk_buff *call_gro_receive_sk(gro_receive_sk_t cb,
+						  struct sock *sk,
+						  struct list_head *head,
+						  struct sk_buff *skb)
+{
+	if (unlikely(gro_recursion_inc_test(skb))) {
+		NAPI_GRO_CB(skb)->flush |= 1;
+		return NULL;
+	}
+
+	return cb(sk, head, skb);
+}
+
+static inline unsigned int skb_gro_offset(const struct sk_buff *skb)
+{
+	return NAPI_GRO_CB(skb)->data_offset;
+}
+
+static inline unsigned int skb_gro_len(const struct sk_buff *skb)
+{
+	return skb->len - NAPI_GRO_CB(skb)->data_offset;
+}
+
+static inline void skb_gro_pull(struct sk_buff *skb, unsigned int len)
+{
+	NAPI_GRO_CB(skb)->data_offset += len;
+}
+
+static inline void *skb_gro_header_fast(struct sk_buff *skb,
+					unsigned int offset)
+{
+	return NAPI_GRO_CB(skb)->frag0 + offset;
+}
+
+static inline int skb_gro_header_hard(struct sk_buff *skb, unsigned int hlen)
+{
+	return NAPI_GRO_CB(skb)->frag0_len < hlen;
+}
+
+static inline void skb_gro_frag0_invalidate(struct sk_buff *skb)
+{
+	NAPI_GRO_CB(skb)->frag0 = NULL;
+	NAPI_GRO_CB(skb)->frag0_len = 0;
+}
+
+static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
+					unsigned int offset)
+{
+	if (!pskb_may_pull(skb, hlen))
+		return NULL;
+
+	skb_gro_frag0_invalidate(skb);
+	return skb->data + offset;
+}
+
+static inline void *skb_gro_network_header(struct sk_buff *skb)
+{
+	return (NAPI_GRO_CB(skb)->frag0 ?: skb->data) +
+	       skb_network_offset(skb);
+}
+
+static inline __wsum inet_gro_compute_pseudo(struct sk_buff *skb, int proto)
+{
+	const struct iphdr *iph = skb_gro_network_header(skb);
+
+	return csum_tcpudp_nofold(iph->saddr, iph->daddr,
+				  skb_gro_len(skb), proto, 0);
+}
+
+static inline void skb_gro_postpull_rcsum(struct sk_buff *skb,
+					const void *start, unsigned int len)
+{
+	if (NAPI_GRO_CB(skb)->csum_valid)
+		NAPI_GRO_CB(skb)->csum = csum_sub(NAPI_GRO_CB(skb)->csum,
+						  csum_partial(start, len, 0));
+}
+
+/* GRO checksum functions. These are logical equivalents of the normal
+ * checksum functions (in skbuff.h) except that they operate on the GRO
+ * offsets and fields in sk_buff.
+ */
+
+__sum16 __skb_gro_checksum_complete(struct sk_buff *skb);
+
+static inline bool skb_at_gro_remcsum_start(struct sk_buff *skb)
+{
+	return (NAPI_GRO_CB(skb)->gro_remcsum_start == skb_gro_offset(skb));
+}
+
+static inline bool __skb_gro_checksum_validate_needed(struct sk_buff *skb,
+						      bool zero_okay,
+						      __sum16 check)
+{
+	return ((skb->ip_summed != CHECKSUM_PARTIAL ||
+		skb_checksum_start_offset(skb) <
+		 skb_gro_offset(skb)) &&
+		!skb_at_gro_remcsum_start(skb) &&
+		NAPI_GRO_CB(skb)->csum_cnt == 0 &&
+		(!zero_okay || check));
+}
+
+static inline __sum16 __skb_gro_checksum_validate_complete(struct sk_buff *skb,
+							   __wsum psum)
+{
+	if (NAPI_GRO_CB(skb)->csum_valid &&
+	    !csum_fold(csum_add(psum, NAPI_GRO_CB(skb)->csum)))
+		return 0;
+
+	NAPI_GRO_CB(skb)->csum = psum;
+
+	return __skb_gro_checksum_complete(skb);
+}
+
+static inline void skb_gro_incr_csum_unnecessary(struct sk_buff *skb)
+{
+	if (NAPI_GRO_CB(skb)->csum_cnt > 0) {
+		/* Consume a checksum from CHECKSUM_UNNECESSARY */
+		NAPI_GRO_CB(skb)->csum_cnt--;
+	} else {
+		/* Update skb for CHECKSUM_UNNECESSARY and csum_level when we
+		 * verified a new top level checksum or an encapsulated one
+		 * during GRO. This saves work if we fallback to normal path.
+		 */
+		__skb_incr_checksum_unnecessary(skb);
+	}
+}
+
+#define __skb_gro_checksum_validate(skb, proto, zero_okay, check,	\
+				    compute_pseudo)			\
+({									\
+	__sum16 __ret = 0;						\
+	if (__skb_gro_checksum_validate_needed(skb, zero_okay, check))	\
+		__ret = __skb_gro_checksum_validate_complete(skb,	\
+				compute_pseudo(skb, proto));		\
+	if (!__ret)							\
+		skb_gro_incr_csum_unnecessary(skb);			\
+	__ret;								\
+})
+
+#define skb_gro_checksum_validate(skb, proto, compute_pseudo)		\
+	__skb_gro_checksum_validate(skb, proto, false, 0, compute_pseudo)
+
+#define skb_gro_checksum_validate_zero_check(skb, proto, check,		\
+					     compute_pseudo)		\
+	__skb_gro_checksum_validate(skb, proto, true, check, compute_pseudo)
+
+#define skb_gro_checksum_simple_validate(skb)				\
+	__skb_gro_checksum_validate(skb, 0, false, 0, null_compute_pseudo)
+
+static inline bool __skb_gro_checksum_convert_check(struct sk_buff *skb)
+{
+	return (NAPI_GRO_CB(skb)->csum_cnt == 0 &&
+		!NAPI_GRO_CB(skb)->csum_valid);
+}
+
+static inline void __skb_gro_checksum_convert(struct sk_buff *skb,
+					      __wsum pseudo)
+{
+	NAPI_GRO_CB(skb)->csum = ~pseudo;
+	NAPI_GRO_CB(skb)->csum_valid = 1;
+}
+
+#define skb_gro_checksum_try_convert(skb, proto, compute_pseudo)	\
+do {									\
+	if (__skb_gro_checksum_convert_check(skb))			\
+		__skb_gro_checksum_convert(skb, 			\
+					   compute_pseudo(skb, proto));	\
+} while (0)
+
+struct gro_remcsum {
+	int offset;
+	__wsum delta;
+};
+
+static inline void skb_gro_remcsum_init(struct gro_remcsum *grc)
+{
+	grc->offset = 0;
+	grc->delta = 0;
+}
+
+static inline void *skb_gro_remcsum_process(struct sk_buff *skb, void *ptr,
+					    unsigned int off, size_t hdrlen,
+					    int start, int offset,
+					    struct gro_remcsum *grc,
+					    bool nopartial)
+{
+	__wsum delta;
+	size_t plen = hdrlen + max_t(size_t, offset + sizeof(u16), start);
+
+	BUG_ON(!NAPI_GRO_CB(skb)->csum_valid);
+
+	if (!nopartial) {
+		NAPI_GRO_CB(skb)->gro_remcsum_start = off + hdrlen + start;
+		return ptr;
+	}
+
+	ptr = skb_gro_header_fast(skb, off);
+	if (skb_gro_header_hard(skb, off + plen)) {
+		ptr = skb_gro_header_slow(skb, off + plen, off);
+		if (!ptr)
+			return NULL;
+	}
+
+	delta = remcsum_adjust(ptr + hdrlen, NAPI_GRO_CB(skb)->csum,
+			       start, offset);
+
+	/* Adjust skb->csum since we changed the packet */
+	NAPI_GRO_CB(skb)->csum = csum_add(NAPI_GRO_CB(skb)->csum, delta);
+
+	grc->offset = off + hdrlen + offset;
+	grc->delta = delta;
+
+	return ptr;
+}
+
+static inline void skb_gro_remcsum_cleanup(struct sk_buff *skb,
+					   struct gro_remcsum *grc)
+{
+	void *ptr;
+	size_t plen = grc->offset + sizeof(u16);
+
+	if (!grc->delta)
+		return;
+
+	ptr = skb_gro_header_fast(skb, grc->offset);
+	if (skb_gro_header_hard(skb, grc->offset + sizeof(u16))) {
+		ptr = skb_gro_header_slow(skb, plen, grc->offset);
+		if (!ptr)
+			return;
+	}
+
+	remcsum_unadjust((__sum16 *)ptr, grc->delta);
+}
+
+#ifdef CONFIG_XFRM_OFFLOAD
+static inline void skb_gro_flush_final(struct sk_buff *skb, struct sk_buff *pp, int flush)
+{
+	if (PTR_ERR(pp) != -EINPROGRESS)
+		NAPI_GRO_CB(skb)->flush |= flush;
+}
+static inline void skb_gro_flush_final_remcsum(struct sk_buff *skb,
+					       struct sk_buff *pp,
+					       int flush,
+					       struct gro_remcsum *grc)
+{
+	if (PTR_ERR(pp) != -EINPROGRESS) {
+		NAPI_GRO_CB(skb)->flush |= flush;
+		skb_gro_remcsum_cleanup(skb, grc);
+		skb->remcsum_offload = 0;
+	}
+}
+#else
+static inline void skb_gro_flush_final(struct sk_buff *skb, struct sk_buff *pp, int flush)
+{
+	NAPI_GRO_CB(skb)->flush |= flush;
+}
+static inline void skb_gro_flush_final_remcsum(struct sk_buff *skb,
+					       struct sk_buff *pp,
+					       int flush,
+					       struct gro_remcsum *grc)
+{
+	NAPI_GRO_CB(skb)->flush |= flush;
+	skb_gro_remcsum_cleanup(skb, grc);
+	skb->remcsum_offload = 0;
+}
+#endif
 
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct list_head *,
 							   struct sk_buff *));
@@ -15,6 +373,14 @@ INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_head *,
 							   struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
 
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int udp4_gro_complete(struct sk_buff *, int));
+
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp6_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
+
 #define indirect_call_gro_receive_inet(cb, f2, f1, head, skb)	\
 ({								\
 	unlikely(gro_recursion_inc_test(skb)) ?			\
@@ -22,4 +388,30 @@ INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
 		INDIRECT_CALL_INET(cb, f2, f1, head, skb);	\
 })
 
+struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
+				struct udphdr *uh, struct sock *sk);
+int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
+
+static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
+{
+	struct udphdr *uh;
+	unsigned int hlen, off;
+
+	off  = skb_gro_offset(skb);
+	hlen = off + sizeof(*uh);
+	uh   = skb_gro_header_fast(skb, off);
+	if (skb_gro_header_hard(skb, hlen))
+		uh = skb_gro_header_slow(skb, hlen, off);
+
+	return uh;
+}
+
+static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
+{
+	const struct ipv6hdr *iph = skb_gro_network_header(skb);
+
+	return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
+					    skb_gro_len(skb), proto, 0));
+}
+
 #endif /* _NET_IPV6_GRO_H */
diff --git a/include/net/ip.h b/include/net/ip.h
index b71e88507c4a0907011c41e1ed0148eb873b5186..7d1088888c10c973a3f99802aaab566d0f07afbb 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -568,14 +568,6 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
-static inline __wsum inet_gro_compute_pseudo(struct sk_buff *skb, int proto)
-{
-	const struct iphdr *iph = skb_gro_network_header(skb);
-
-	return csum_tcpudp_nofold(iph->saddr, iph->daddr,
-				  skb_gro_len(skb), proto, 0);
-}
-
 /*
  *	Map a multicast IP onto multicast MAC for type ethernet.
  */
diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index b3f4eaa88672a2e64ec3fbb3e77a60fe383e59d9..a279e8ac730900fa473590f0c347e589c30a3274 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -43,14 +43,6 @@ static inline __wsum ip6_compute_pseudo(struct sk_buff *skb, int proto)
 					    skb->len, proto, 0));
 }
 
-static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
-{
-	const struct ipv6hdr *iph = skb_gro_network_header(skb);
-
-	return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
-					    skb_gro_len(skb), proto, 0));
-}
-
 static __inline__ __sum16 tcp_v6_check(int len,
 				   const struct in6_addr *saddr,
 				   const struct in6_addr *daddr,
diff --git a/include/net/udp.h b/include/net/udp.h
index 909ecf447e0fb2abaedf4d8954d2824c746fb251..f1c2a88c9005a86bc6e3dc35bdd0e8f7d3b3fe4a 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -167,36 +167,12 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
 typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
 				     __be16 dport);
 
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
-							   struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(int udp4_gro_complete(struct sk_buff *, int));
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp6_gro_receive(struct list_head *,
-							   struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
 
-struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
-				struct udphdr *uh, struct sock *sk);
-int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
-
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 				  netdev_features_t features, bool is_ipv6);
 
-static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
-{
-	struct udphdr *uh;
-	unsigned int hlen, off;
-
-	off  = skb_gro_offset(skb);
-	hlen = off + sizeof(*uh);
-	uh   = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen))
-		uh = skb_gro_header_slow(skb, hlen, off);
-
-	return uh;
-}
-
 /* hash routines shared between UDPv4/6 and UDP-Litev4/6 */
 static inline int udp_lib_hash(struct sock *sk)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba2f38246f07e5ba5a4f97922b4be33bdb8ad6d6..1c4f2a2e52550eef6eb6002314813983abb2e266 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -64,6 +64,7 @@
 
 #include <net/protocol.h>
 #include <net/dst.h>
+#include <net/gro.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 0189e3cd4a7df2dc2ea7121182ee290e0164df90..6d52b6491255b3452eb70373a36a602488e5f381 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -99,6 +99,7 @@
 #include <net/route.h>
 #include <net/ip_fib.h>
 #include <net/inet_connection_sock.h>
+#include <net/gro.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/udplite.h>
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8e4e9aa12130dfdd2bcb52442fe688d03ddf4fae..d87f02a6e9346ad0dddcd1177664079140c468d8 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -16,6 +16,7 @@
 #include <crypto/authenc.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <net/gro.h>
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 8fcbc6258ec527f3069f7a525d33929c0ffa1bdf..b56d6b40c0a26f3b70226937779e355b504b79bd 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <net/genetlink.h>
+#include <net/gro.h>
 #include <net/gue.h>
 #include <net/fou.h>
 #include <net/ip.h>
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 1121a9d5fed921abddd0d04cbef9b406b6b86ab5..740298dac7d32f7bef1d69214d65c665c18b649c 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <net/protocol.h>
 #include <net/gre.h>
+#include <net/gro.h>
 
 static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index fc61cd3fea652b04ea1fe62972510dc0fd66a6da..30abde86db45e560680669ddfb533bcf12deacb0 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -8,6 +8,7 @@
 
 #include <linux/indirect_call_wrapper.h>
 #include <linux/skbuff.h>
+#include <net/gro.h>
 #include <net/tcp.h>
 #include <net/protocol.h>
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 86d32a1e62ac969fae1879c8cb5f992c1b026987..7fbf9975e8c0e9f0aa6a707bb63b55628ca6add8 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/skbuff.h>
+#include <net/gro.h>
 #include <net/udp.h>
 #include <net/protocol.h>
 #include <net/inet_common.h>
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index a349d479807764f0ec32789b1676def4259d08a0..ba5e81cd569c8a0128d00c0e6e4eb0dadabb246d 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -16,6 +16,7 @@
 #include <crypto/authenc.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <net/gro.h>
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 1796856bc24f55c6d9b35b9aa2fbf3892f16dd9b..39db5a2268550b54da126e59ea6b6f6c0fc24b1c 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -7,6 +7,7 @@
  */
 #include <linux/indirect_call_wrapper.h>
 #include <linux/skbuff.h>
+#include <net/gro.h>
 #include <net/protocol.h>
 #include <net/tcp.h>
 #include <net/ip6_checksum.h>
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index b3d9ed96e5ea56bf75b8cc10a28027c961a296e9..50a8a65fad2324d124bcd26eaa93b1ffb9cccc7f 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -13,6 +13,7 @@
 #include <net/udp.h>
 #include <net/ip6_checksum.h>
 #include "ip6_offload.h"
+#include <net/gro.h>
 
 static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 					 netdev_features_t features)
-- 
2.34.0.rc1.387.gb447b232ab-goog

