Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD7A37FFD1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 23:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhEMVac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 17:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhEMVac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 17:30:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3588C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 14:29:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so498523wmh.4
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 14:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MK+we4NaA6AsI0ClY3e5zzwaUuZHr8bmJlzjgwEDJOI=;
        b=MQu92t6YfXG45tkt0iirHS98Hdntzk0sZz3F+5id2UKqN76a7PMNmMqgdAdedEfDCT
         wX7pMoQrOl27VQyoKCF6fpJ00ZdcWtagKzn9vi0ZanFOZUk+5Cyhzo+hwxo5z5nyx5gI
         q2negUkQwwzCb7POgI0wEd0ffoNMr+BrSIi8W+iKx1IJsVy2VlrMgogKUR3pJUaQf8w7
         LWL+0r0Qt6WHKlF2rxfp1LujI6VIxHIlnwulEU2cv/RkbdsI4pt6ZKaW+W7WwYOKozPs
         51V6zuyTduRA0SduAE2KngfDh0/T2/Baad0dKhuRRGyHO4n1JaIEVhuKwONOXgbHiYe6
         9yKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MK+we4NaA6AsI0ClY3e5zzwaUuZHr8bmJlzjgwEDJOI=;
        b=GYnhYapV38Rem+htGEd7f0ViUJc0iiiofz/eUGmYUVuY7DC6CVzS7IZTWkl/HUa3oj
         rrFHTiUp7pOQ7HCJvvGmMI3I9YPzrpHdzIx9s1iCuuqOAzrL3rMAqq1xQ6YcbZdKio9X
         hCfn9Z7QDwmcZdQlweOj6LotlIR5lKSRpENtu+6B2h4BJQyKf6yR2cxB+cVvEwYkiHPL
         6fZB9TbdVCT3adNyOe0nR+6y3ZTd5pqvx26C6H5t97jw38y6z28tfY6Z05yahp1tSRyE
         4eVRifGBeMgBzbTGCal68NJQqsF0td87x8XGvo4Ef/ZYqMllbq88YLYrJUX2W9s2Synz
         An/w==
X-Gm-Message-State: AOAM530bwOEof2KNM6LBUH7UpNs+EiYuxn0AZUORWzFzWyqg0wxO4bv+
        4LKFc9uQwGCI7IhqSnMehY3qQsxTu5/hRQ==
X-Google-Smtp-Source: ABdhPJw4lizeD0ehLyEtsZtj27euZOg636jKJ+64er8WAn6vSoL+CM0znvCF/O7HPo9AdGiMvaP0Xw==
X-Received: by 2002:a05:600c:3596:: with SMTP id p22mr5947231wmq.34.1620941359304;
        Thu, 13 May 2021 14:29:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:dc15:2d50:47c3:384f? (p200300ea8f384600dc152d5047c3384f.dip0.t-ipconnect.de. [2003:ea:8f38:4600:dc15:2d50:47c3:384f])
        by smtp.googlemail.com with ESMTPSA id p10sm4041508wrr.58.2021.05.13.14.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 14:29:18 -0700 (PDT)
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] sfc: don't use netif_info et al before net_device is
 registered
Message-ID: <b6773ec4-82ac-51f8-0531-f1d6b30dc9a6@gmail.com>
Date:   Thu, 13 May 2021 23:29:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using netif_info() before the net_device is registered results in ugly
messages like the following:
sfc 0000:01:00.1 (unnamed net_device) (uninitialized): Solarflare NIC detected
Therefore use pci_info() et al until net_device is registered.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/sfc/efx.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c746ca723..4fd9903ff 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -722,8 +722,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 	efx->state = STATE_READY;
 	smp_mb(); /* ensure we change state before checking reset_pending */
 	if (efx->reset_pending) {
-		netif_err(efx, probe, efx->net_dev,
-			  "aborting probe due to scheduled reset\n");
+		pci_err(efx->pci_dev, "aborting probe due to scheduled reset\n");
 		rc = -EIO;
 		goto fail_locked;
 	}
@@ -990,8 +989,7 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	rc = efx->type->init(efx);
 	up_write(&efx->filter_sem);
 	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "failed to initialise NIC\n");
+		pci_err(efx->pci_dev, "failed to initialise NIC\n");
 		goto fail3;
 	}
 
@@ -1038,8 +1036,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (efx->type->sriov_init) {
 		rc = efx->type->sriov_init(efx);
 		if (rc)
-			netif_err(efx, probe, efx->net_dev,
-				  "SR-IOV can't be enabled rc %d\n", rc);
+			pci_err(efx->pci_dev, "SR-IOV can't be enabled rc %d\n",
+				rc);
 	}
 
 	/* Determine netdevice features */
@@ -1106,8 +1104,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail1;
 
-	netif_info(efx, probe, efx->net_dev,
-		   "Solarflare NIC detected\n");
+	pci_info(pci_dev, "Solarflare NIC detected\n");
 
 	if (!efx->type->is_vf)
 		efx_probe_vpd_strings(efx);
-- 
2.31.1

