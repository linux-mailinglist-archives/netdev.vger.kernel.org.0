Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264F02B0ED2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgKLUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgKLUJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 15:09:51 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76CC0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 12:09:51 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id i13so5132187pgm.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 12:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MVLSS8HPdDnbBl9RWXiGBoIgCQcE3Pg+Hs5tlG/jhj8=;
        b=nC/m2xDs/Tu21OYF4O+DPHWIoNfV0ihYGWNDzJcPGIbYfm0AHVxxmZbX06hl+VkUQm
         SWxa0Fh7W+gp7w2HOQpgX/6v4B1fyN/iGLRg5SX5ddAkB72rY9e4vJWLo3hxRy3f8R3i
         cvuU+NsUJU9vSqOr+7Bpd+i4mH3ae1TT1eGPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MVLSS8HPdDnbBl9RWXiGBoIgCQcE3Pg+Hs5tlG/jhj8=;
        b=BFudVobClsK4HB4EQlT7719Sw0AjeOOP/i2Iytrs6A1H7TXhs/QdrBuQYHpnP78uJO
         FTHADIN73ermiOz8XehEcf8e3Lojs8w0cID127n7VsQOoAHGU1js8ABSxbEnGp8fMqwh
         TQtF3PMzrk86L6st4T6f6rEKh2utdbizAyj1QsCN9xi24weF3TwIr8BScvp5dvkZnwyo
         dkIWCyHgkUlO7d2XxdDyEeRV8mkUURCDQIS3b5UjUWQNA2XqJGFNzIYzasnGSo5/x5aT
         17vRbScwUSTQ+Y5hn+vMjSlF5J4EBvzz6FwGzDi0FSa1Fb8LL1njWyPopoAeL9Uz42xl
         uf7w==
X-Gm-Message-State: AOAM531edlhlNAh+LVMiaYzulQvb9EAg3cf0bFpJDZYy4azpWPESC/+Y
        PhRHQlbRLPgHFQdv5PTrNPt30Q==
X-Google-Smtp-Source: ABdhPJwxX8rLDWm74xvYqVKwE2NYNrD1rXlUb9Qxr1RnLidy+DS7kzxi8+hbzN7HLONgbFgBysz5VA==
X-Received: by 2002:aa7:9601:0:b029:18a:e777:dac1 with SMTP id q1-20020aa796010000b029018ae777dac1mr1154792pfg.4.1605211791112;
        Thu, 12 Nov 2020 12:09:51 -0800 (PST)
Received: from kuabhs-cdev.c.googlers.com.com (152.33.83.34.bc.googleusercontent.com. [34.83.33.152])
        by smtp.gmail.com with ESMTPSA id gc17sm7590260pjb.47.2020.11.12.12.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 12:09:50 -0800 (PST)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@codeaurora.org, pillair@codeaurora.org
Cc:     dianders@chromium.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Abhishek Kumar <kuabhs@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 1/1] ath10k: add option for chip-id based BDF selection
Date:   Thu, 12 Nov 2020 20:09:06 +0000
Message-Id: <20201112200856.v2.1.Ia526132a366886e3b5cf72433d0d58bb7bb1be0f@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112200906.991086-1-kuabhs@chromium.org>
References: <20201112200906.991086-1-kuabhs@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some devices difference in chip-id should be enough to pick
the right BDF. Add another support for chip-id based BDF selection.
With this new option, ath10k supports 2 fallback options.

The board name with chip-id as option looks as follows
board name 'bus=snoc,qmi-board-id=ff,qmi-chip-id=320'

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
Tested-on: QCA6174 HW3.2 WLAN.RM.4.4.1-00157-QCARMSWPZ-1
Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

(no changes since v1)

 drivers/net/wireless/ath/ath10k/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d73ad60b571c..fa9e676b26d9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1419,12 +1419,13 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 }
 
 static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
-					 size_t name_len, bool with_variant)
+					 size_t name_len,
+					 bool with_additional_params)
 {
 	/* strlen(',variant=') + strlen(ar->id.bdf_ext) */
 	char variant[9 + ATH10K_SMBIOS_BDF_EXT_STR_LENGTH] = { 0 };
 
-	if (with_variant && ar->id.bdf_ext[0] != '\0')
+	if (with_additional_params && ar->id.bdf_ext[0] != '\0')
 		scnprintf(variant, sizeof(variant), ",variant=%s",
 			  ar->id.bdf_ext);
 
@@ -1438,12 +1439,17 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 	}
 
 	if (ar->id.qmi_ids_valid) {
-		if (with_variant && ar->id.bdf_ext[0] != '\0')
+		if (with_additional_params && ar->id.bdf_ext[0] != '\0')
 			scnprintf(name, name_len,
 				  "bus=%s,qmi-board-id=%x,qmi-chip-id=%x%s",
 				  ath10k_bus_str(ar->hif.bus),
 				  ar->id.qmi_board_id, ar->id.qmi_chip_id,
 				  variant);
+		else if (with_additional_params)
+			scnprintf(name, name_len,
+				  "bus=%s,qmi-board-id=%x,qmi-chip-id=%x",
+				  ath10k_bus_str(ar->hif.bus),
+				  ar->id.qmi_board_id, ar->id.qmi_chip_id);
 		else
 			scnprintf(name, name_len,
 				  "bus=%s,qmi-board-id=%x",
-- 
2.29.2.222.g5d2a92d10f8-goog

