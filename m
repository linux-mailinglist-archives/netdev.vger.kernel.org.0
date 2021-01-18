Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D419D2FA606
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406566AbhARQYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406137AbhARQTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:14 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA04C0613D3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:50 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a10so7830452ejg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aBvytynoR2nWY3pb9gU+Iox7k865l4KhgzD//IU/MaI=;
        b=lP+gOJpohnv9jFwB+EdebfgBpyWMFo20Zfpjwsfdq2lipv35jqL1XSJp8ttSSj1CZ/
         /3tikX8j1c7vtJqa0sl7rmoeq3Na9RvlD6G6SgUBBNCa0WWFOTE4QSnxN1VaVcM4P2GY
         C+AuTj8aFz/ZoQEGvW86FrtNUhki5/jwpq4I0cKPaRftYtA/NjikttW5eQYUJWnu8nl/
         Lcp21LJcwrHt9iZFbRa5HU8IAjFmyu6sH+ZCD1tusfCGfCMQcYtqwbythWsxCpmQ4OmH
         u8MTunENXG6c2Z7ts8sHa8cb6f6AsRWfLKMuyRKRp8dWqKjj28uqrz3BOUcQPiVKduTR
         /erg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBvytynoR2nWY3pb9gU+Iox7k865l4KhgzD//IU/MaI=;
        b=YW97PIclPFdpi925xV4gYocT4LGmH/EZxq8qmH1tECvfw7AjyRnems+/ePpc1LwMsW
         18WwvFTB80FL4SWH5xkP5hJ7pwMofOTQ/izw4gPrBZlst6KdX4DF5jNstUTlps8JZWcp
         JOf0xMdu8kwL5UW/3OuFNFQ9ErdX82uwXvjyWX9kfRzNoMY8t5Dmb/d+WH5ndG/vQbIe
         YTy4FsyO4+O/f69YsUzoB+AjnjyoRQ5/9bIuRFEvt4FSYXyhLeHd4LhbBTmMCTxtXDDe
         MwFLgcDGSjLo2dIhASBwDtD6FyLFv9CFboTEa6IJ61XdyX8cC2EHE8AmgvwyWlkGcFPd
         EiNg==
X-Gm-Message-State: AOAM533Y0iI9WeoFZvrDNVDTVT5A9/l9bkSX4jSH9SPmYnCsbsDrrXlp
        EpyPwiPh38wywxAlhRVXr7E=
X-Google-Smtp-Source: ABdhPJzDvwRR20l/8JsgbvazvgEKcWqoUZGm6v5Q48mxCF/JNLgzaOam2ETcl0xisZ6GFXQkK1N44g==
X-Received: by 2002:a17:906:a951:: with SMTP id hh17mr323727ejb.388.1610986669627;
        Mon, 18 Jan 2021 08:17:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 06/15] net: mscc: ocelot: only drain extraction queue on error
Date:   Mon, 18 Jan 2021 18:17:22 +0200
Message-Id: <20210118161731.2837700-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It appears that the intention of this snippet of code is to not exit
ocelot_xtr_irq_handler() while in the middle of extracting a frame.
The problem in extracting it word by word is that future extraction
attempts are really easy to get desynchronized, since the IRQ handler
assumes that the first 16 bytes are the IFH, which give further
information about the frame, such as frame length.

But during normal operation, "err" will not be 0, but 4, set from here:

		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
			if (err != 4)
				break;
		}

		if (err != 4)
			break;

In that case, draining the extraction queue is a no-op. So explicitly
make this code execute only on negative err.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 917243c4a19d..d4cf6eeff3c9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -701,7 +701,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err)
+	if (err < 0)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
 
-- 
2.25.1

