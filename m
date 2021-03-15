Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850BF33B4AC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCONfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhCONfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:35:04 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD673C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:04 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id y20so15012917iot.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5ukPamWfSMWajj2pGN9CHr8brD2zi1Azop7dU5O7zI=;
        b=cTyJVvPKlSorpCZKc4vJ0k+XaRwOm0r5EzNKlRugLWtCGEDT8UFduPyDw2SyfKWji+
         rxJctXOfR3KNPC09pdvyBSkQZciR1Y3xUjEO1tSaqoeT1tR5Wl7MXU5pycpNbLDmkKpZ
         JHooao4mD3pO69VOzVJ8Pvxe4cvBTYgOc1WNVs2PGCWSqyb/PoJwb0H6pBv1NYEb3I4I
         goLGJbBToaChIIWNNJScEjBMC8/ymJS4WyOVDVv1dGMwx95mo/LLDYa+Ndw0mhkgwhyy
         agkYCxHAfOt1+fzep4rtj7YqB9tHSet6EgRaeWiB+N5uSPukS5RQTDYKrrPM4yV2Bj5d
         q5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5ukPamWfSMWajj2pGN9CHr8brD2zi1Azop7dU5O7zI=;
        b=K1bSxTf9F91ugOiR1VrwETOHZwBfaTxKn3fgxFrCzsIDTotz3JpzZYEanvTvJejpcN
         1d8urlNCyzx7ozqZZASTd+J9zrf8/sJ7oUY918ya9QolFDsdOcw6E3ErHsZ/GnE16o23
         9Ay9Qenmnw+I15G0yj6KnOJ9W9nDfLT/c7QNcw70caA7NasjystBBBAgMKOuitQjBy7M
         Fo6AreFsPY2IekuuIjO4EZZw308/2sA62b6zaHWE8KbsYFAxiOLstV1HskileF0GyXNp
         sgM4wtIZGmnZupMzdKnRu9ij9WbQ9wXQxrnvabAB5tyc0DtlDJEAFm2Ddg22IKexuRYc
         97rw==
X-Gm-Message-State: AOAM533HH2he8BlimcDRuGuQkdJeeH/RVYHrWs6yeENMGkbkpAd6SsUv
        WT0B7k2wJuFSGWnICwUrlRSbuw==
X-Google-Smtp-Source: ABdhPJxXHCoXoQOib5OlTu9B3z3aF/tiXUlzagO0rvXp3CMDUbCyC3L7Ypkfw1wj6gcHzLaq1ErTJA==
X-Received: by 2002:a02:3c01:: with SMTP id m1mr9259223jaa.87.1615815304301;
        Mon, 15 Mar 2021 06:35:04 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7127672ioo.24.2021.03.15.06.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 06:35:04 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 5/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
Date:   Mon, 15 Mar 2021 08:34:54 -0500
Message-Id: <20210315133455.1576188-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315133455.1576188-1-elder@linaro.org>
References: <20210315133455.1576188-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_dl_csum_trailer
structure with a single one-byte field, using constant field masks
to encode or get at embedded values.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
v3: - Use BIT(x) and don't use u8_get_bits() for the checksum valid flag

 .../ethernet/qualcomm/rmnet/rmnet_map_data.c    |  2 +-
 include/linux/if_rmnet.h                        | 17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3c3307949db00..3df23365497c4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -365,7 +365,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 
 	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
 
-	if (!csum_trailer->valid) {
+	if (!(csum_trailer->flags & MAP_CSUM_DL_VALID_FLAG)) {
 		priv->stats.csum_valid_unset++;
 		return -EINVAL;
 	}
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index a02f0a3df1d9a..941997df9e088 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -19,21 +19,18 @@ struct rmnet_map_header {
 #define MAP_CMD_FLAG			BIT(7)
 
 struct rmnet_map_dl_csum_trailer {
-	u8  reserved1;
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u8  valid:1;
-	u8  reserved2:7;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u8  reserved2:7;
-	u8  valid:1;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
+	u8 reserved1;
+	u8 flags;			/* MAP_CSUM_DL_VALID_FLAG */
 	__be16 csum_start_offset;
 	__be16 csum_length;
 	__be16 csum_value;
 } __aligned(1);
 
+/* rmnet_map_dl_csum_trailer flags field:
+ *  VALID:	1 = checksum and length valid; 0 = ignore them
+ */
+#define MAP_CSUM_DL_VALID_FLAG		BIT(0)
+
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.27.0

