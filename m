Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB8120CA24
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgF1Txw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgF1Txr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:47 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6F4C03E979;
        Sun, 28 Jun 2020 12:53:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i14so14511919ejr.9;
        Sun, 28 Jun 2020 12:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lytj8JREnMITA3Qx/LJdVYiI5LTDssfwED1xOl5FxoM=;
        b=s5sJzU+WEEpr1/XqsXUOXsZ9DleB4kE2Itb7EK9Sfi0VoP/AqFQGI+MLcqPnlR65MT
         UJhYLCBCsgOHo1CfSN4DablGz78ThZgMvlq4sJceEM4kqx7lnE8eA9ixrBdVnPa4ZDO/
         u12VYqMCP6Cmh0/ntMEzxo12eBiAfRrgOktn3JHB3M82qnIovlpkcNv0f5GQwphsoINY
         1IrgAEuaMlJgrLXQCUivQTQ3QC47ObIOqo4ZLJKRQCapLEt43KxdqFzqaPz8tonp1Wy6
         doCl3XS1oe7IorGTSnMGHkVVDA6vzPBAopIVuJYNhBtWGV2XidswvWOm5uRMquxQiVvE
         73Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lytj8JREnMITA3Qx/LJdVYiI5LTDssfwED1xOl5FxoM=;
        b=jgRncCqEDk9FuqT3GDS6xQzuwLAWQEVnw/TgHcPmqnPOl+DgvLlXMfhhvo75VNwj7Q
         9bEFAW/7B8wqc07I7rW7CGYLdcnxGMjYZw9e0B3/jrn1yYExJ7SZD7vyWqlYc3oPmUin
         +aAaltarHZax5IZ2nxpVpTxHQxxjPFgZfSFfk9fuo0Tv4OBwB9aMzaw6fA2MrBZY6hgE
         fID1fprh9Zc6groc/Tz5QWCBPgjDFsYfXHPxQ0iHlQflpfUdbhsDMJLGcS7XMc9io55t
         jaiOCBf/QpiGOGp8Cj4w8GScBpDQ/QIMjk+6pi7dxtfDU3aFLm6PugDpPXDsZacu1Mn9
         OUsA==
X-Gm-Message-State: AOAM532lnodzoVIrGwPDlOHHRyHua1A2s2DqFZjuqqGDXPse6F6gaWhg
        mAyfBmr2JuneRivIhCIFcDQ=
X-Google-Smtp-Source: ABdhPJyFGjpjxauvlOMVPeyy9QgZWnFiQZg1zetVmwhixDKXtyZ7aTWen5+dnV6Ij3PL3Tb51BHdlw==
X-Received: by 2002:a17:907:72ca:: with SMTP id du10mr11055838ejc.78.1593374025363;
        Sun, 28 Jun 2020 12:53:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:44 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 03/15] caif: fix cfspi_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:25 +0200
Message-Id: <20200628195337.75889-4-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too and
returning NETDEV_TX_OK instead of 0 accordingly.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/caif/caif_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index 63f2548f5b1b..7d5899626130 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -488,7 +488,7 @@ static void cfspi_xfer_done_cb(struct cfspi_ifc *ifc)
 	complete(&cfspi->comp);
 }
 
-static int cfspi_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t cfspi_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct cfspi *cfspi = NULL;
 	unsigned long flags;
@@ -514,7 +514,7 @@ static int cfspi_xmit(struct sk_buff *skb, struct net_device *dev)
 		cfspi->cfdev.flowctrl(cfspi->ndev, 0);
 	}
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 int cfspi_rxfrm(struct cfspi *cfspi, u8 *buf, size_t len)
-- 
2.27.0

