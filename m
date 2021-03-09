Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E833325C0
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 13:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhCIMtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 07:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhCIMs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 07:48:58 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372BCC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 04:48:58 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id i18so12006150ilq.13
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 04:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q3mPtnM0Ocz/MEgmITiZnxbVwwxPG5ePxZNKL9aLA68=;
        b=d7LTi/33dD8m4z+rN9ePkqIrT23bJ6Q6jSOHVxMY9a+LM9O5+DyTXzkvNBpwxKI9gS
         fJLe6s3rSu6ftV0QoACv+Fob1XIpmD2MPbF4Y+HWGv2vCqTb36hW4IFCNNwaJ1aHAstT
         hOOdGUPG9RiuXOIARSGH++/o/51lioHGdZgbgt0OfUA+IpIRMnX+NRSVth1Ymicbuykx
         C347PQbDekgDc87jdRpthFj6yHKdM0S0H55SGlN6SB4Uv8mOpV7p/z1S+gLm5NPVUqcP
         p94zAKs8rX4BKhZaPWrh4BIg0AX47g72taQn+LmCDrtZVhxvBdMZ93KEhCks45vOENRS
         V0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q3mPtnM0Ocz/MEgmITiZnxbVwwxPG5ePxZNKL9aLA68=;
        b=h1E/l+pxI/nW2TJ2OhYBVfW5CMxaxDjxvGCH2gyZhfFh/d61r2u0udfGf/wIfAn7qR
         d/dvYJXT93ijhRIOZMzsoTKw1dG6YUGgRrQb45k0/cf3XNjI024IF5C18FIystAiNc/2
         9tTNFbG6a54ItJDy8j7V/+K/J7Om6yUdkU+M06j38Pc9I6AxPFj53jTB1ip87amQdm7b
         Qs6WifQi42QM6nrXsAztdq2o9l2weTdf2VnuCnbn2CnjbK79zlNo8vZfzDq26y0DQhXr
         fQeAm0z1uT0gaLSpYrGvW/6JxKZZUw09fMogYFHJtfsbUow4rAQf23KtZR65W1OX6kXX
         9RUQ==
X-Gm-Message-State: AOAM532BRpajeYwBA3wPz3CCIrWodcFaAnx7CDDQKBm/ihm+rQKt4hRW
        Spml25fPmwGdNT2cUvULwt+lhg==
X-Google-Smtp-Source: ABdhPJwLr1jwZNQUk53DCdwdg9YblBOo55wDY8oAO2vo4FzD6AbDi0qMM0BLIkLe2o3jO+qlsJpIOw==
X-Received: by 2002:a05:6e02:12cc:: with SMTP id i12mr24159277ilm.113.1615294137701;
        Tue, 09 Mar 2021 04:48:57 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7810009ioo.24.2021.03.09.04.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 04:48:57 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3 6/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
Date:   Tue,  9 Mar 2021 06:48:48 -0600
Message-Id: <20210309124848.238327-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210309124848.238327-1-elder@linaro.org>
References: <20210309124848.238327-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_ul_csum_header
structure with a single two-byte (big endian) structure member,
and use bit or field masks to encode or get values within it.

Previously rmnet_map_ipv4_ul_csum_header() would update C bit-field
values in host byte order, then forcibly fix their byte order using
a combination of byte swap operations and types.

Instead, just compute the value that needs to go into the new
structure member and save it with a simple byte-order conversion.

Make similar simplifications in rmnet_map_ipv6_ul_csum_header().

Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
zeroes every field in the upload checksum header.  Replace that with
a single memset() operation.

Signed-off-by: Alex Elder <elder@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
---
v3: Use BIT(x) and don't use u16_get_bits() for single-bit flags
v2: Fixed to use u16_encode_bits() instead of be16_encode_bits().

 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 34 ++++++-------------
 include/linux/if_rmnet.h                      | 21 ++++++------
 2 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 72dbbe2c27bd7..1ddc3440c8b48 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -198,23 +198,19 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct iphdr *ip4h = iphdr;
 	u16 offset;
+	u16 val;
 
 	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
 	ul_header->csum_start_offset = htons(offset);
 
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
+	val = MAP_CSUM_UL_ENABLED_FLAG;
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= MAP_CSUM_UL_UDP_FLAG;
+	val |= u16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -241,24 +237,19 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct ipv6hdr *ip6h = ip6hdr;
 	u16 offset;
+	u16 val;
 
 	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
 	ul_header->csum_start_offset = htons(offset);
 
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
-
+	val = MAP_CSUM_UL_ENABLED_FLAG;
 	if (ip6h->nexthdr == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= MAP_CSUM_UL_UDP_FLAG;
+	val |= u16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -425,10 +416,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	}
 
 sw_csum:
-	ul_header->csum_start_offset = 0;
-	ul_header->csum_insert_offset = 0;
-	ul_header->csum_enabled = 0;
-	ul_header->udp_ind = 0;
+	memset(ul_header, 0, sizeof(*ul_header));
 
 	priv->stats.csum_sw++;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index a848bb2e0dad0..141754d0078cc 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -33,17 +33,16 @@ struct rmnet_map_dl_csum_trailer {
 
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u16 csum_insert_offset:14;
-	u16 udp_ind:1;
-	u16 csum_enabled:1;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u16 csum_enabled:1;
-	u16 udp_ind:1;
-	u16 csum_insert_offset:14;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
+	__be16 csum_info;		/* MAP_CSUM_UL_*_FMASK */
 } __aligned(1);
 
+/* csum_info field:
+ *  OFFSET:	where (offset in bytes) to insert computed checksum
+ *  UDP:	1 = UDP checksum (zero checkum means no checksum)
+ *  ENABLED:	1 = checksum computation requested
+ */
+#define MAP_CSUM_UL_OFFSET_FMASK	GENMASK(13, 0)
+#define MAP_CSUM_UL_UDP_FLAG		BIT(14)
+#define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
+
 #endif /* !(_LINUX_IF_RMNET_H_) */
-- 
2.27.0

