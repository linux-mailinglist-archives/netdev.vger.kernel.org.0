Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B313F0B74
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbhHRTH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhHRTHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9F7C061764;
        Wed, 18 Aug 2021 12:07:11 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g138so2254630wmg.4;
        Wed, 18 Aug 2021 12:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2jGrYvV1Qk7AhZwzusm0nC2EVomIYB2AkGTE+vbDl6E=;
        b=EyhEQgWoJQtpEqWJeBziOG2Ezn36KdEJxfhsPZTIsHKZTf+erohmnEyILlvyf71oKp
         tz1RDN3VAsOwbbnutt7FDzbprEQ4qqYg2jps9ooyaq+VOH3dpExIkY7qs9GAFPdqQnLX
         FpbHr/I2Gka20cfL+6KenJzfil4QbCCFO7zlfvhlXaP+UCtbQXdxVHY0Hprv8QnLD3WG
         oL+Of1+hebDnV7Wr38ze3oqtOC4YoY0xEbJqYvIvPAQBtfuzQPxxIPswqn/O1wcIMgw1
         pWAu0U1AFoXP5ZnQAJWNDTaorIzRTWAz8QZ+kzHy+jjhPi9BpcphoS+NfvSgr6XOsuot
         sdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2jGrYvV1Qk7AhZwzusm0nC2EVomIYB2AkGTE+vbDl6E=;
        b=LnUe88bWJXF5Q1QL2yzBQDGo0arbOzhZasMEM4ART+poxpbLx5NKC6t+8Jc9uP0tRG
         dm5PWiYgSjgB4xS4f8IZ6s9C0zoKU+eNStT0JMt6julhzkfp01R75ekWqPiqMrAxqU4/
         9u3cJL2f7Jm0tKR41wvRHL6+L1nmF3xsdfPaVgz+ccuz4Caq1AgLNHprytxjo84R0vxX
         sPy1iLWDzadKYk7tW0rzPze33Iexv2SCfIpXuvLddvXGcz3mfM43R5zizH0rzXD1dhD3
         rOJSwivYFBxHYpECBKc+mp2J1UZMz5CsrxnYUSmvPWC6rUV1EDIH2nxgcERYLI9mlg4i
         7Vdg==
X-Gm-Message-State: AOAM532cjpkqQtsazYjL0yK5olHJ1i3IsZ9pf9PW58u2qMm9hgLsfsmy
        JvQwINswckZk/uy58tENMD7huZXeHDT7jg==
X-Google-Smtp-Source: ABdhPJyZjJeTYHofPdlDM6rlgdwdavW2NCpIAKddrG2AND612nBzr0eHsYwwjnTmprAq9gqYX33Evw==
X-Received: by 2002:a7b:c2fa:: with SMTP id e26mr9924341wmk.102.1629313630170;
        Wed, 18 Aug 2021 12:07:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id 6sm570875wmk.20.2021.08.18.12.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:09 -0700 (PDT)
Subject: [PATCH 4/8] sfc: Use new function pci_vpd_alloc
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <e58f1e40-c043-0266-9a0f-e5a7f3f6883c@gmail.com>
Date:   Wed, 18 Aug 2021 21:02:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new VPD API function pci_vpd_alloc() for dynamically allocating
a properly sized buffer and reading the full VPD data into it.
This avoids having to allocate a buffer on the stack, and we don't
have to make any assumptions on VPD size and location of information
in VPD any longer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/sfc/efx.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a295e2621..e04a63109 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -900,21 +900,18 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 /* NIC VPD information
  * Called during probe to display the part number of the
- * installed NIC.  VPD is potentially very large but this should
- * always appear within the first 512 bytes.
+ * installed NIC.
  */
-#define SFC_VPD_LEN 512
 static void efx_probe_vpd_strings(struct efx_nic *efx)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	char vpd_data[SFC_VPD_LEN];
-	ssize_t vpd_size;
 	int ro_start, ro_size, i, j;
+	unsigned int vpd_size;
+	u8 *vpd_data;
 
-	/* Get the vpd data from the device */
-	vpd_size = pci_read_vpd(dev, 0, sizeof(vpd_data), vpd_data);
-	if (vpd_size <= 0) {
-		netif_err(efx, drv, efx->net_dev, "Unable to read VPD\n");
+	vpd_data = pci_vpd_alloc(dev, &vpd_size);
+	if (IS_ERR(vpd_data)) {
+		pci_warn(dev, "Unable to read VPD\n");
 		return;
 	}
 
@@ -922,7 +919,7 @@ static void efx_probe_vpd_strings(struct efx_nic *efx)
 	ro_start = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
 	if (ro_start < 0) {
 		netif_err(efx, drv, efx->net_dev, "VPD Read-only not found\n");
-		return;
+		goto out;
 	}
 
 	ro_size = pci_vpd_lrdt_size(&vpd_data[ro_start]);
@@ -935,14 +932,14 @@ static void efx_probe_vpd_strings(struct efx_nic *efx)
 	i = pci_vpd_find_info_keyword(vpd_data, i, j, "PN");
 	if (i < 0) {
 		netif_err(efx, drv, efx->net_dev, "Part number not found\n");
-		return;
+		goto out;
 	}
 
 	j = pci_vpd_info_field_size(&vpd_data[i]);
 	i += PCI_VPD_INFO_FLD_HDR_SIZE;
 	if (i + j > vpd_size) {
 		netif_err(efx, drv, efx->net_dev, "Incomplete part number\n");
-		return;
+		goto out;
 	}
 
 	netif_info(efx, drv, efx->net_dev,
@@ -953,21 +950,23 @@ static void efx_probe_vpd_strings(struct efx_nic *efx)
 	i = pci_vpd_find_info_keyword(vpd_data, i, j, "SN");
 	if (i < 0) {
 		netif_err(efx, drv, efx->net_dev, "Serial number not found\n");
-		return;
+		goto out;
 	}
 
 	j = pci_vpd_info_field_size(&vpd_data[i]);
 	i += PCI_VPD_INFO_FLD_HDR_SIZE;
 	if (i + j > vpd_size) {
 		netif_err(efx, drv, efx->net_dev, "Incomplete serial number\n");
-		return;
+		goto out;
 	}
 
 	efx->vpd_sn = kmalloc(j + 1, GFP_KERNEL);
 	if (!efx->vpd_sn)
-		return;
+		goto out;
 
 	snprintf(efx->vpd_sn, j + 1, "%s", &vpd_data[i]);
+out:
+	kfree(vpd_data);
 }
 
 
-- 
2.32.0


