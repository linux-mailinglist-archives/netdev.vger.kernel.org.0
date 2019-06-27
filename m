Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5892C58C9F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfF0VM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:12:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44992 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfF0VM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:12:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so2186971wrl.11
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TAoUX57gTM5CTvJG9+3ULxoQA8JyOoloey9APZWjyns=;
        b=pswUDGdyBDddEgfyjpuo8JLbJM4q0MN/GMGj4VwgiR8BUoRUoOcZd+r1FGV9q9VhaE
         Q7OTKNLxfUaQGMEs3vlnpKahz97tMldkvDUcGQQLKR5/8nzPauiJOR0J7d56oHW52jdY
         LVKASji+9686G4Roy+xUaCQ+VlaO8JnL45LhspuhWMvjNOzvgk4POchxEhB96X/5E5KR
         Ep41+mPH+09u1xB6taGle2bWxmfdYQj9VAxHUaDL8n5WCCSXJUJ2dXgjvUhF1qKO5DBg
         hnQr0fxg1Bq+Ewnm6ZG4W27veRt6YAitEsW/6Nyok44BqUDyBmStahvZy5OnIATpRGt+
         mkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TAoUX57gTM5CTvJG9+3ULxoQA8JyOoloey9APZWjyns=;
        b=Ju4GcDZ1O+2yTCJhqlZKdRXQ/QIN/W3elwRkvEhYabIm3lojdwNqZUefOMUOitxFCo
         XNMUQY0K0i4nyW/hzyRdh6egm3AOhGK0+6dUbwFdxSYca4wju7ewkI+NGf6wMDrljeHo
         mcqOXVC+20aEi9EhKZ6nZHtATwMNfOb0lizLrs+S3rqB67gUb5EESkAmkt1UD/30rx6Z
         NyL6j0U308Jbrq8YGyLynVLp1cpPwIPNf3F5a0sQRPynntzj2FzraiEqtno9qY7IgMy4
         tuNdKsylgU12Bj8bA1YnBUJLWX9ndN0xO9y7jX52TxTQCCuPzhrxlkQ1qVB2qjez6hhq
         jk1Q==
X-Gm-Message-State: APjAAAVycPqivBciZmYs7NGTlVV+WwsN+SVGWbtFeeSpVWx6zPAAg6WQ
        AM3o7viOQzFkfggKk581yqRfau/Y
X-Google-Smtp-Source: APXvYqzTKul/zASWSyN6bxF1DKjbSSqehWL73BzP10gfS3+tx/6H7hQ3Q+y4kV5LN5RIcA7GtTaz6g==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr5084166wrl.130.1561669974176;
        Thu, 27 Jun 2019 14:12:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:3d9e:1690:cd42:495c? (p200300EA8BF3BD003D9E1690CD42495C.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:3d9e:1690:cd42:495c])
        by smtp.googlemail.com with ESMTPSA id c1sm634932wrh.1.2019.06.27.14.12.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:12:53 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: consider that 32 Bit DMA is the default
Message-ID: <eabad258-68de-49b9-91d7-7c853ea4f150@gmail.com>
Date:   Thu, 27 Jun 2019 23:12:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/DMA-API-HOWTO.txt states:
By default, the kernel assumes that your device can address 32-bits of
DMA addressing. For a 64-bit capable device, this needs to be increased,
and for a device with limitations, it needs to be decreased.

Therefore we don't need the 32 Bit DMA fallback configuration and can
remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b4df66bef..1b5f125e1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6724,15 +6724,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd);
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
-	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
+	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
 		dev->features |= NETIF_F_HIGHDMA;
-	} else {
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (rc < 0) {
-			dev_err(&pdev->dev, "DMA configuration failed\n");
-			return rc;
-		}
-	}
 
 	rtl_init_rxcfg(tp);
 
-- 
2.22.0

