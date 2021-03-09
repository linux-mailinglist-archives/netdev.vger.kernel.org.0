Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265323325BE
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 13:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhCIMtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 07:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhCIMs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 07:48:56 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38632C06175F
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 04:48:56 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id z9so12068119iln.1
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 04:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+wb+u/7a6kg9MtdFGlRH2/NSAh7RkwKkpqOHuLRQ5E=;
        b=C+vX5n8Oot6G96fJwnTkOoS03gD4wvAvfOT9CuF2Es6Qar83XkIyQ1X6Salg6zXNGa
         /C/IOeNm7xddjzaF/NaYtonxtJ688z77ZpLk207CDXMWOouJ0EbObkktbg6F0KaehWD5
         7TXBRrNdPWIYFtaYsuBEmHvAF6QRbEk+k5BcyWdEKjgqIsTFe1d4zxywCv8rg6tbepWv
         4T0LQqpRoVtsLkesNa01NXuWqkdc9rsCyjdFQUUPSNmtgB9NlALMCg+pVKQs73librYa
         suoUJ9HSwJg/AE6CUVwrMsg1jApJ7n5NCFfrNjW8I7BavpF6YL/C2dcSds99tzELJj5t
         vgHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+wb+u/7a6kg9MtdFGlRH2/NSAh7RkwKkpqOHuLRQ5E=;
        b=DfQtGJkisdJZXc3EvPYCYIiep1vl/Vd6W5Zwew+gW9TpV9uJz+qxH/M1jyWwLycW7/
         WAGi6N/AMjfy6IAX0l/jsAHz6854SyzXcIleonZhANLLLd+WGhiZKnMN4SLHV0P3Pf8C
         CaD434W+W7VzrXS51hBGpyE9+VAdp+BXlfi340tijUyKDpaeIkE8SUXi8m2MMr2ivv+A
         X/rBk76AdR4lyESGUSdXOEyDQOdHTyeQm7KpP1RxZE/nQRVRubIFrzV6kvUbt2Li733D
         MfetFHmZrj1bmNNywPuNP6+C9CeRREKP6XPQTfHE11/p0JbjIvLGn67XxuCtLZEUYUE9
         mCpw==
X-Gm-Message-State: AOAM530iLkMN7Bqn5EgInpi/rgtzhsuRiffUICs+iQ4k68cPVDjh1qOy
        kufPj2wRCdNQqI4JIi5+o8qPLA==
X-Google-Smtp-Source: ABdhPJwTtViqYoy1MO20pBpy8ohycvyIe1qxY5DFLpU1tgqul+4HP7ojvTdHvNO0/oqy8SAR+ci4Cw==
X-Received: by 2002:a92:d5d2:: with SMTP id d18mr6464368ilq.50.1615294135594;
        Tue, 09 Mar 2021 04:48:55 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7810009ioo.24.2021.03.09.04.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 04:48:55 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/6] net: qualcomm: rmnet: use field masks instead of C bit-fields
Date:   Tue,  9 Mar 2021 06:48:46 -0600
Message-Id: <20210309124848.238327-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210309124848.238327-1-elder@linaro.org>
References: <20210309124848.238327-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual layout of bits defined in C bit-fields (e.g. int foo : 3)
is implementation-defined.  Structures defined in <linux/if_rmnet.h>
address this by specifying all bit-fields twice, to cover two
possible layouts.

I think this pattern is repetitive and noisy, and I find the whole
notion of compiler "bitfield endianness" to be non-intuitive.

Stop using C bit-fields for the command/data flag and the pad length
fields in the rmnet_map structure, and define a single-byte flags
field instead.  Define a mask for the single bit "command" flag
encoded in the flags field.  Define a field mask for the encoded pad
length, and access it using functions defined in <linux/bitfield.h>.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v3: Use BIT(x) and don't use u8_get_bits() for the command flag

 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  5 ++--
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  4 +++-
 include/linux/if_rmnet.h                      | 23 ++++++++-----------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 2a6b2a609884c..28d355b094683 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -4,6 +4,7 @@
  * RMNET Data ingress/egress handler
  */
 
+#include <linux/bitfield.h>
 #include <linux/netdevice.h>
 #include <linux/netdev_features.h>
 #include <linux/if_arp.h>
@@ -61,7 +62,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	u16 len, pad;
 	u8 mux_id;
 
-	if (map_header->cd_bit) {
+	if (map_header->flags & MAP_CMD_FLAG) {
 		/* Packet contains a MAP command (not data) */
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
@@ -70,7 +71,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	}
 
 	mux_id = map_header->mux_id;
-	pad = map_header->pad_len;
+	pad = u8_get_bits(map_header->flags, MAP_PAD_LEN_FMASK);
 	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index fd55269c2ce3c..3291f252d81b0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -4,6 +4,7 @@
  * RMNET Data MAP protocol
  */
 
+#include <linux/bitfield.h>
 #include <linux/netdevice.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -299,7 +300,8 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 
 done:
 	map_header->pkt_len = htons(map_datalen + padding);
-	map_header->pad_len = padding & 0x3F;
+	/* This is a data packet, so the CMD bit is 0 */
+	map_header->flags = u8_encode_bits(padding, MAP_PAD_LEN_FMASK);
 
 	return map_header;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 8c7845baf3837..22ccc89bb5d8e 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -6,21 +6,18 @@
 #define _LINUX_IF_RMNET_H_
 
 struct rmnet_map_header {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u8  pad_len:6;
-	u8  reserved_bit:1;
-	u8  cd_bit:1;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u8  cd_bit:1;
-	u8  reserved_bit:1;
-	u8  pad_len:6;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
-	u8  mux_id;
-	__be16 pkt_len;
+	u8 flags;			/* MAP_*_FMASK */
+	u8 mux_id;
+	__be16 pkt_len;			/* Length of packet, including pad */
 }  __aligned(1);
 
+/* rmnet_map_header flags field:
+ *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
+ *  PAD_LEN:	number of pad bytes following packet data
+ */
+#define MAP_CMD_FLAG			BIT(7)
+#define MAP_PAD_LEN_FMASK		GENMASK(5, 0)
+
 struct rmnet_map_dl_csum_trailer {
 	u8  reserved1;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.27.0

