Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01B22FF4C1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhAUStR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbhAUIqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:46:55 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BFCC0613C1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:45:58 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id i7so922747pgc.8
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=d2blpBkYNzJ/F4Vj0Wdef50NzhPRGTYyrfkCeYf6UwI=;
        b=Hj/hKfqv0DePbXsG9/RqSIcRZ1txPdZWz+6wB34f+4VenA/BJk5OEdUVJd/u/YVcWr
         KoQgkUHXimF+Dc0NtIFeUsWwXiaYI3aEgXmce083VJVk9e6s0kyL395jdnpA6FJD5NBG
         h72FDuu2WCpMwbE5Ig0qu8gApoY5Shx+EvAubxEcF3gtZsv67dQdtwgMZDjRQDt2t88C
         25nsV6wjyqlROGrTqWCgpoa1xU8uz6r0x1i/CojLl/MGUjYfm72mU7obbvnFPfznPQXv
         0cNbnSG8omOxa9ssAYRnKzsXQEpNgK7wuxEztimg/xZEdkkusW1SwuFq30UL8yOa3cJv
         AZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=d2blpBkYNzJ/F4Vj0Wdef50NzhPRGTYyrfkCeYf6UwI=;
        b=n3U3exwpuWY/rg4MZ83uNj8JoAseN+S7I64CmSJMsOLafgdV6m2kp+Tgnyyqbp5tyP
         4K2nrQCFOxUQB/xxxkpj9HbGJ3/YuQa3MpbnUD3Mk04EsO5uNrSGFQvBOYqu4iVzo1vN
         7k+X5MssXft5N999xgpAEuIo709rcLLLqPod7M3QlmBmVF0hYE2aoHrRCWv5ob5FjNla
         EofQcAmbkw0zbP8RU1ilAwqCGutz8x1VEki3yZdNHZW3jf1Pm16K99kDfMUnAXm1H8Xt
         v9/tigjXiB0FFel9suuBQeT6AG7iK+j46Jfv8oadfmNA/72OaRebAaeBM+qJks9YueBf
         HgJg==
X-Gm-Message-State: AOAM531YcU3bjywL931nFDsWcA+wBQeE9XPMQSsmRF8pK6w7mfOosk7Y
        TsyHX+rnr8d1R9BB/65w1mKdmSvwwiQ=
X-Google-Smtp-Source: ABdhPJwd2qsz8gheFRiV9/jCqIrtRYu0h54UglaexWZS0qq/dxB//wLAKUYUXowGhX9OCqc4Qxn+cA==
X-Received: by 2002:a63:914b:: with SMTP id l72mr1140698pge.411.1611218757157;
        Thu, 21 Jan 2021 00:45:57 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mw15sm4867858pjb.34.2021.01.21.00.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Jan 2021 00:45:56 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 1/3] net: rename csum_not_inet to csum_type
Date:   Thu, 21 Jan 2021 16:45:36 +0800
Message-Id: <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to rename csum_not_inet to csum_type, as later
more csum type would be introduced in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/skbuff.h | 19 +++++++++++--------
 net/core/dev.c         |  2 +-
 net/sched/act_csum.c   |  2 +-
 net/sctp/offload.c     |  2 +-
 net/sctp/output.c      |  2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 186dad2..67b0a01 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -169,7 +169,7 @@
  *   skb_csum_hwoffload_help() can be called to resolve CHECKSUM_PARTIAL based
  *   on network device checksumming capabilities: if a packet does not match
  *   them, skb_checksum_help or skb_crc32c_help (depending on the value of
- *   csum_not_inet, see item D.) is called to resolve the checksum.
+ *   csum_type, see item D.) is called to resolve the checksum.
  *
  * CHECKSUM_NONE:
  *
@@ -190,12 +190,12 @@
  *   NETIF_F_SCTP_CRC - This feature indicates that a device is capable of
  *     offloading the SCTP CRC in a packet. To perform this offload the stack
  *     will set csum_start and csum_offset accordingly, set ip_summed to
- *     CHECKSUM_PARTIAL and set csum_not_inet to 1, to provide an indication in
- *     the skbuff that the CHECKSUM_PARTIAL refers to CRC32c.
+ *     CHECKSUM_PARTIAL and set csum_type to CSUM_T_SCTP_CRC, to provide an
+ *     indication in the skbuff that the CHECKSUM_PARTIAL refers to CRC32c.
  *     A driver that supports both IP checksum offload and SCTP CRC32c offload
  *     must verify which offload is configured for a packet by testing the
- *     value of skb->csum_not_inet; skb_crc32c_csum_help is provided to resolve
- *     CHECKSUM_PARTIAL on skbs where csum_not_inet is set to 1.
+ *     value of skb->csum_type; skb_crc32c_csum_help is provided to resolve
+ *     CHECKSUM_PARTIAL on skbs where csum_type is set to CSUM_T_SCTP_CRC.
  *
  *   NETIF_F_FCOE_CRC - This feature indicates that a device is capable of
  *     offloading the FCOE CRC in a packet. To perform this offload the stack
@@ -222,6 +222,9 @@
 #define CHECKSUM_COMPLETE	2
 #define CHECKSUM_PARTIAL	3
 
+#define CSUM_T_INET		0
+#define CSUM_T_SCTP_CRC		1
+
 /* Maximum value in skb->csum_level */
 #define SKB_MAX_CSUM_LEVEL	3
 
@@ -677,7 +680,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@encapsulation: indicates the inner headers in the skbuff are valid
  *	@encap_hdr_csum: software checksum is needed
  *	@csum_valid: checksum is already valid
- *	@csum_not_inet: use CRC32c to resolve CHECKSUM_PARTIAL
+ *	@csum_type: do the checksum offload according to this type
  *	@csum_complete_sw: checksum was completed by software
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
@@ -836,7 +839,7 @@ struct sk_buff {
 	__u8			vlan_present:1;
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
-	__u8			csum_not_inet:1;
+	__u8			csum_type:1;
 	__u8			dst_pending_confirm:1;
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
@@ -4623,7 +4626,7 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 
 static inline bool skb_csum_is_sctp(struct sk_buff *skb)
 {
-	return skb->csum_not_inet;
+	return skb->csum_type == CSUM_T_SCTP_CRC;
 }
 
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index d9ce02e..3241de2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3279,7 +3279,7 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 						  crc32c_csum_stub));
 	*(__le32 *)(skb->data + offset) = crc32c_csum;
 	skb->ip_summed = CHECKSUM_NONE;
-	skb->csum_not_inet = 0;
+	skb->csum_type = 0;
 out:
 	return ret;
 }
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 4fa4fcb..9fabb6e 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -376,7 +376,7 @@ static int tcf_csum_sctp(struct sk_buff *skb, unsigned int ihl,
 	sctph->checksum = sctp_compute_cksum(skb,
 					     skb_network_offset(skb) + ihl);
 	skb->ip_summed = CHECKSUM_NONE;
-	skb->csum_not_inet = 0;
+	skb->csum_type = 0;
 
 	return 1;
 }
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index eb874e3..372f373 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -26,7 +26,7 @@
 static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 {
 	skb->ip_summed = CHECKSUM_NONE;
-	skb->csum_not_inet = 0;
+	skb->csum_type = 0;
 	/* csum and csum_start in GSO CB may be needed to do the UDP
 	 * checksum when it's a UDP tunneling packet.
 	 */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 6614c9f..a8cf0191 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -523,7 +523,7 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 	} else {
 chksum:
 		head->ip_summed = CHECKSUM_PARTIAL;
-		head->csum_not_inet = 1;
+		head->csum_type = CSUM_T_SCTP_CRC;
 		head->csum_start = skb_transport_header(head) - head->head;
 		head->csum_offset = offsetof(struct sctphdr, checksum);
 	}
-- 
2.1.0

