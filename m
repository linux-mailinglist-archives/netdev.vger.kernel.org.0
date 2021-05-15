Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBE7381885
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 13:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhEOLyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 07:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhEOLyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 07:54:47 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97661C061573
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 04:53:31 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n2so1743530wrm.0
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 04:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=W9ciK+JlkmVJsV3DXXgYdQeafGCRps605Nye3qlL4rE=;
        b=FA2PgdyCzFj7IWYFm3ISj2xuX8t5CYmqG/4EPcCRzMeSs3hnPwJgqeqWxL2fGTGUCw
         +naWOcOmHnFjiJWLZFyK3gD1D/58kU8QBUwCY1fWAW/7DKjqEzKmqSzk/5z6xHNB4lgw
         FgadZBbyVdq40Gp4xxSMvS4JHUiS4Ao3gTaT5Ns0di2ucc1+dwnSlffDKZLyC49gSbP6
         npasaygO3v4HqN8xwu70JhKJKUCAXy3ZBMzG6LT+5J/s+cD5HD1WTRuS/PrrJo9iXcBj
         Nbm1Or9uMaGvJw/2/y+uR/7vfcSg82wjCxH0W0sgf3GQBifbOthHfIVCIIfDVVX2mWlX
         Qo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=W9ciK+JlkmVJsV3DXXgYdQeafGCRps605Nye3qlL4rE=;
        b=m1AykX5wvQFNUFkcgmObmIHsijcCdgDuw7zb7Kddt3WtBFVxkD/N5J2/tf6bhhpYR/
         mBHVR9JYbIslTN8FZpoCTFJ6J3xfjiR1kmKc6LWiJ6i2NVkzi3RV/7IKSO6rwTfNIWS4
         Z0cVjfBR0WqIiVUN2xn5AAuZWkgGPrQbH1GRa6At1jA+lrTYYg9vznuzcslgpl+KTU00
         CHpMhpBUb9KW6Q25uLkyF3sAxIDpaP/14GyyVVsO+NBy/I+qF2qurmt89HsnsIwpgzT2
         zxnDNxnVr5HM6E8PH3DznlIy7RG0tEMgr3PLRYZz/477LhflTEBuEUSgFAPQhtZ1bak3
         V4Pg==
X-Gm-Message-State: AOAM533p1+ReXrEn9UI/oDWlzP54mu+JPEVFa5PFhB28qHmsPyLLq0ZS
        0sYYpERnufdHSjVuX8lewDwfo+NlWQEuVQ==
X-Google-Smtp-Source: ABdhPJwiy9T60xXawZpxa2uI9TfBX0X8aNlxJLHlHpA9L+dQAr2e+gQ2mcID/bxLMY22y7g2d3YZAg==
X-Received: by 2002:a5d:6885:: with SMTP id h5mr64178823wru.229.1621079610149;
        Sat, 15 May 2021 04:53:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:906a:5a1e:5ed0:bde6? (p200300ea8f384600906a5a1e5ed0bde6.dip0.t-ipconnect.de. [2003:ea:8f38:4600:906a:5a1e:5ed0:bde6])
        by smtp.googlemail.com with ESMTPSA id f1sm10541230wrr.63.2021.05.15.04.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 04:53:29 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: use KBUILD_MODNAME instead of own module name
 definition
Message-ID: <6f77db90-f26e-a590-bb10-a0ee80c32294@gmail.com>
Date:   Sat, 15 May 2021 13:53:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove own module name definition and use KBUILD_MODNAME instead.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2c89cde7d..1663e0486 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -34,8 +34,6 @@
 #include "r8169.h"
 #include "r8169_firmware.h"
 
-#define MODULENAME "r8169"
-
 #define FIRMWARE_8168D_1	"rtl_nic/rtl8168d-1.fw"
 #define FIRMWARE_8168D_2	"rtl_nic/rtl8168d-2.fw"
 #define FIRMWARE_8168E_1	"rtl_nic/rtl8168e-1.fw"
@@ -1454,7 +1452,7 @@ static void rtl8169_get_drvinfo(struct net_device *dev,
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct rtl_fw *rtl_fw = tp->rtl_fw;
 
-	strlcpy(info->driver, MODULENAME, sizeof(info->driver));
+	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	strlcpy(info->bus_info, pci_name(tp->pci_dev), sizeof(info->bus_info));
 	BUILD_BUG_ON(sizeof(info->fw_version) < sizeof(rtl_fw->version));
 	if (rtl_fw)
@@ -5305,7 +5303,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	rc = pcim_iomap_regions(pdev, BIT(region), MODULENAME);
+	rc = pcim_iomap_regions(pdev, BIT(region), KBUILD_MODNAME);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "cannot remap MMIO, aborting\n");
 		return rc;
@@ -5440,7 +5438,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 }
 
 static struct pci_driver rtl8169_pci_driver = {
-	.name		= MODULENAME,
+	.name		= KBUILD_MODNAME,
 	.id_table	= rtl8169_pci_tbl,
 	.probe		= rtl_init_one,
 	.remove		= rtl_remove_one,
-- 
2.31.1

