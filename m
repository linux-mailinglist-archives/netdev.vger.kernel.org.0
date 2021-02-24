Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E44324241
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhBXQiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbhBXQgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 11:36:05 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9116EC061574;
        Wed, 24 Feb 2021 08:35:23 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id w7so2322915wmb.5;
        Wed, 24 Feb 2021 08:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MVmZumu1MFGQXdL/ioPLeL2JHnOHtr9yLNDGu09SiDU=;
        b=pw5L1f3RLGOqplHvTDu852ma9AAsisWzlTmcgXbJQ9pIv9lusTz/QpJvx+qwUYTNPe
         Ns0ArGEg+i6MnThU+83EDMrQjAqN9I2AEKhlek+LzJBWrT4fhWPE0TN6ZwUG7n1a9Ejo
         7RxFMYA5HO9HGGphWYvK/akpLOnJnbCsr804MD9LoLiO4eReezhPeVIkAYyOgIB9Qr4n
         fGmlRT+tnUVBvNAMBYI0Y/jp0UznSOGAhzRRDSr8ucR/EpgxaXN+YonRZoYLNWCNX2y/
         7y3Ftf3S0HldrxUL/0/kQYWqxKhgzkwA9D0lXIWKHJPox2ZQR38wKnDEJcPO0Ji3+pWs
         PsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MVmZumu1MFGQXdL/ioPLeL2JHnOHtr9yLNDGu09SiDU=;
        b=sbkwX2cLAkSYKH3TrjUGSapouJLL9fOtXDaJlMPSSJo41t69I1x8yf7KdvxTlqutQj
         TBqfnAGgpgfQr8D0LG6WX6LRGq0Wdz3q0HyTMdA0PbErMQnZGhfCAsRuP4o9aJMMbq0o
         5BBMyUdKZIKvCwVSuRVVccfLWC7Tgmb7XNV3jLnuu+Gx42aFZuyIEwmX8+xb3FDEFV7r
         t7up4hdTY2HzUFMQMRFIho5M+EcXovWqnB/41nDjqn3VyT/SnAMJG8hesbLrsemUJhE1
         XxlFfQ4uOlXU3hdVMQXTi9JAeXXVmwQdmNJ9nzRCRgOpa+sLXHSt5n1Q9YevfnoBY8re
         lEsQ==
X-Gm-Message-State: AOAM533c6nnV1A5sOHu5LjYzUG2V0rvreX5HFyyE43jIilnn8YtGoBZR
        aXLdC6i7smpWUm52/nT6rZKN/2NEY09NDg==
X-Google-Smtp-Source: ABdhPJwxS6v9BlqfcuCI1OW0dTrLpo1LCDLoI+Wdi08TD4ObG9RfSSYhOGjwHPRBFqERRT677UvLkw==
X-Received: by 2002:a05:600c:17d1:: with SMTP id y17mr4526397wmo.164.1614184522411;
        Wed, 24 Feb 2021 08:35:22 -0800 (PST)
Received: from little.cd.corp (82-209-154-112.cust.bredband2.com. [82.209.154.112])
        by smtp.gmail.com with ESMTPSA id 36sm5259254wrj.97.2021.02.24.08.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 08:35:21 -0800 (PST)
From:   Marcus Folkesson <marcus.folkesson@gmail.com>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] wilc1000: write value to WILC_INTR2_ENABLE register
Date:   Wed, 24 Feb 2021 17:37:06 +0100
Message-Id: <20210224163706.519658-1-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Write the value instead of reading it twice.

Fixes: 5e63a598441a ("staging: wilc1000: added 'wilc_' prefix for function in wilc_sdio.c file")

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 351ff909ab1c..e14b9fc2c67a 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -947,7 +947,7 @@ static int wilc_sdio_sync_ext(struct wilc *wilc, int nint)
 			for (i = 0; (i < 3) && (nint > 0); i++, nint--)
 				reg |= BIT(i);
 
-			ret = wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			ret = wilc_sdio_write_reg(wilc, WILC_INTR2_ENABLE, reg);
 			if (ret) {
 				dev_err(&func->dev,
 					"Failed write reg (%08x)...\n",
-- 
2.30.0

