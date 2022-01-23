Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E22449744A
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiAWS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbiAWS17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:27:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5B7C06173B;
        Sun, 23 Jan 2022 10:27:58 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u15so9596406wrt.3;
        Sun, 23 Jan 2022 10:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zs+Ru6Mn/aNGA0jG9ohfyPTr3hgPfmsPwOklIHXUa6Q=;
        b=JPP8ya6apK/bg8jA690kk96yiK345f1FDwfn03ffTbuNbNM6QGLZK/ociIFlsJrZRy
         mBIdHt5wMjuRMX5IjN+hRI6RZNexxhPivjtvencHb+F6dxLC0sOi8u2qvMony70IYp4u
         gV+9+HkqIkMPP7ndw/niullq0bB/bXIsYlLS5moFovgdnCP07S461BmstqtKltZdWwLv
         MQuh5P/H0rxkydM6qKbqPsoeGyIHGVnP1GShX4zBLAge7ahDe1wx2QKSJQnQ5WcIJQki
         nMZp6kEBLWT6H3/eBCvPtqD8RrncwWHuHiPvNZiJd6hWbA5V2zSqljFyS5Cdmy7ZM8qD
         hkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zs+Ru6Mn/aNGA0jG9ohfyPTr3hgPfmsPwOklIHXUa6Q=;
        b=mQsUgsSgYTwAK6wdZOeUfGtkXw1KQVGv2TJCnKVIHdJSY9dKvML42Bbu/EqfBpr3EM
         hubMip06maUmmcPhT2YqfBfKP9jFF6Tt0AFItK/SmECjhmSlzp68sto1V1mNceqqcdvM
         JoSxEEAQmvIU3dgnwuaUHUaGWTGwfV3whJCKn7jzgCPWvO06HErpHpKg6l1YehIteLFJ
         0p200jAZq1VEfpT6YvMqhawWmGV22MaKFLQTQ9t0ABA6sb3vTrx6ysxDGCYQyceqrEEF
         OnQ66ioNeiqNxRQqpyTIUYRN/5o/nr24UifwAgHySk6+tqMgDPPIpVZ8FQARDt/nm6D+
         tG/Q==
X-Gm-Message-State: AOAM532uC7gvElMcIBoIAz7K3JwGLgtkUzoc/PE+nsfyS8WOyl3L1HdP
        z1NNs8J+PIe50zaXJWUZXMo=
X-Google-Smtp-Source: ABdhPJy/5Y7TIcgbVGiniCcW7SKe56C6PWUYuKG2FeJLIw/Y4IepBcKHZQ19eblblmUh0G2Hd5TB8g==
X-Received: by 2002:a5d:64e1:: with SMTP id g1mr11135108wri.22.1642962477501;
        Sun, 23 Jan 2022 10:27:57 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id i3sm11769254wru.33.2022.01.23.10.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:27:56 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] carl9170: remove redundant assignment to variable tx_params
Date:   Sun, 23 Jan 2022 18:27:55 +0000
Message-Id: <20220123182755.112146-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable tx_params is being assigned a value that is never read, it
is being re-assigned a couple of statements later with a different
value. The assignment is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/carl9170/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 49f7ee1c912b..f392a2ac7e14 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1909,8 +1909,6 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	tx_streams = hweight8(ar->eeprom.tx_mask);
 
 	if (rx_streams != tx_streams) {
-		tx_params = IEEE80211_HT_MCS_TX_RX_DIFF;
-
 		WARN_ON(!(tx_streams >= 1 && tx_streams <=
 			IEEE80211_HT_MCS_TX_MAX_STREAMS));
 
-- 
2.33.1

