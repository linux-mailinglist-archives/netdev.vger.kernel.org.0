Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A16330CD31
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhBBUkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhBBUks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:40:48 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B74C061573;
        Tue,  2 Feb 2021 12:40:06 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j11so2832921wmi.3;
        Tue, 02 Feb 2021 12:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VRNaTwygjoG94Shw3fbvKOdrUfqMLPpUXM7Pp/gF9pI=;
        b=bjjo4p+lNXiQo6YU2auC75u72ORxvMqw5aYLhzxWUTwIOHC9cE0qy+luqjkqQi0K73
         L2mxbmU96c7SHhHv4YRbgHLb5bgHT98yXgUGQl3GILOaU9kcm3iRL1wj5ReK2L5IWHvm
         MT6Zjc+cyXhZcslOP6eQMur+VmCngF2Ui3HhA2aUBd5qkqU7FNMXfmXAnG8JlFI2Mrb/
         tp+1fx4mng5CqtTRDVWMNy/nvUMl1XBFJwEILZ8xIGpgOmgRJAyvFf+P+Xos8o4X3M51
         jSHm0hY1AQ73tBdib7XzDybpmYXJVjyHkzE6bYfaDkiTB4q+1tgtSxbV6owtu/itrt7z
         5U5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VRNaTwygjoG94Shw3fbvKOdrUfqMLPpUXM7Pp/gF9pI=;
        b=RmhLGyFG8EPhtqgvp1m4B/S0AZlzk/xnFyB1ZT+0D1qF3LZTVmTMmWsiHpwbCFdNKS
         Fd0ry8SFT2+Uji/VXjAd7tqOhjOqbz8pZBi8X9gXOFEVzkJHZ1s629oNpQcx79Gy4gZc
         H/+O6WRweubxtjJeJ0mR6SuhAtv3w5vrNvUSJl9VuM15lwJ9KLRcxcI/zeD31kBbY6zS
         Wx8k8i2sk0H8d9BXtpP3jXdUB9sOKRO7j5GV1jth90SSQ5rWZtRMKQ9Mfi8gRLc0dNdO
         ZgJm/2BPnYTjRXxo8ttnzeMH8NBaUt+BMEzFMg4fWiYj89jZ1wynXhPur4nDa+gCIwGJ
         8Y3A==
X-Gm-Message-State: AOAM533muKILmg/ZEn+uQrVaBajGehvqJq7R0sBmkZXO6ud3QTYqFsX7
        6QN9pv7/uBFIELyPQFvp8lR2IIRVCY4=
X-Google-Smtp-Source: ABdhPJxR5dT7yR9//xUi7XSoyjsW7rOCWKDZWKA4CByoFhGH+36Z84GlniRFPaeAf56r5T/C2RUN5Q==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr5255054wma.29.1612298405165;
        Tue, 02 Feb 2021 12:40:05 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e? (p200300ea8f1fad00e887ce1a5d1da96e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e])
        by smtp.googlemail.com with ESMTPSA id e11sm34110798wrt.35.2021.02.02.12.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:40:04 -0800 (PST)
Subject: [PATCH net-next 1/4] PCI/VPD: Remove Chelsio T3 quirk
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Message-ID: <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
Date:   Tue, 2 Feb 2021 21:35:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgb3 driver doesn't use the PCI core code for VPD access, it has its own
implementation. Therefore we don't need a quirk for it in the core code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 7915d10f9..db86fe226 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -628,22 +628,17 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
 {
 	int chip = (dev->device & 0xf000) >> 12;
 	int func = (dev->device & 0x0f00) >>  8;
-	int prod = (dev->device & 0x00ff) >>  0;
 
 	/*
-	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
-	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
-	 * later based adapter, the special VPD is at offset 0x400 for the
-	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
-	 * Capabilities).  The PCI VPD Access core routines will normally
+	 * If this is a T4 or later based adapter, the special VPD is at offset
+	 * 0x400 for the Physical Functions (the SR-IOV Virtual Functions have
+	 * no VPD Capabilities). The PCI VPD Access core routines will normally
 	 * compute the size of the VPD by parsing the VPD Data Structure at
 	 * offset 0x000.  This will result in silent failures when attempting
 	 * to accesses these other VPD areas which are beyond those computed
 	 * limits.
 	 */
-	if (chip == 0x0 && prod >= 0x20)
-		pci_set_vpd_size(dev, 8192);
-	else if (chip >= 0x4 && func < 0x8)
+	if (chip >= 0x4 && func < 0x8)
 		pci_set_vpd_size(dev, 2048);
 }
 
-- 
2.30.0


