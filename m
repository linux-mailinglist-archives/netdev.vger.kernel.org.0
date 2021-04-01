Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3705351D62
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbhDAS2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbhDASTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:19:04 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAADCC03114E;
        Thu,  1 Apr 2021 09:44:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d191so1362600wmd.2;
        Thu, 01 Apr 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dsZYTG5YjRYIylzLECh8VUqy5Nq7ENfTH8PmA/1aukE=;
        b=SEp0n4y/wxztrOXia6Y2ncc4SWEsVWT0v7PfduwVzHDoszXd3cSTsNhzauJy9QheWF
         2QcGmVSNCcLLEoY0Mo42isZ1onV2bDIwLw51pQr7Zlc+nompdU7A7QKXUbV55bakOgwI
         pW0wzL8f0ZWA+B4RSHKBhLOzyE4hZRgGz3YXNg0yk0uUUkGGjc95Uuo5fZ4qhkKOAFDl
         Kc5XvNr4Q+3Izlj8gn1qsP5bDIkWOSIf8jn7kQ1KwBQUaeaAwldb8bDx2dr3qcB1yR8l
         TncTSn09jqv36lKcdrTmcUs1DspNnPomDa5iaC5247OJKiBPa+/vdmjssyY/OkeL4qSx
         W0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dsZYTG5YjRYIylzLECh8VUqy5Nq7ENfTH8PmA/1aukE=;
        b=U9DV6qPf6wRrVDxmZOiv1hsAWyTe66GQKAdzZq5Y1ZGEC3KMsq16WRYNVl+aF3A+ru
         3RMIZyFJxzzVBnPUU1BO6RfYpZEDLDJQyGMqQl+qRem1B0HHzlfO0Q7R+QqfZf8T8LyP
         NyqhBN9q8J8OxS63KzLZhPXdIR3/hmuzoQgrBYzNfRc9uiJ/7exqCb9R3TIVhn8OV9RE
         FSp5sVtQb9CaCU8ciMW6dm+w1/5kk2G83SaWFqppCP4fIYDiEcUmaX+8fwkxhE6xi8a7
         CpJJFTWs2Z36pWRYZ0ceTd5sql/qBSF8Pp71Ki0ylcmldOvPvmjhHG9K6/YuAlSUVcaX
         uRXA==
X-Gm-Message-State: AOAM532xK4RQ14JfLjLF39wjac4BVWIHDFCwidsWQIhQ+76EA21EuDYJ
        5UBEdmTGR4nOXilRnd8wbz3QG42FC6c49A==
X-Google-Smtp-Source: ABdhPJzuWtuDjAu1sovzH17Gr8k8/fS+vntCAbg4BsS+EF8kjJ/UPRNArdTs1HXXEGzifhnk4+3qvg==
X-Received: by 2002:a05:600c:ac2:: with SMTP id c2mr8394938wmr.23.1617295474784;
        Thu, 01 Apr 2021 09:44:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:5544:e633:d47e:4b76? (p200300ea8f1fbb005544e633d47e4b76.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:5544:e633:d47e:4b76])
        by smtp.googlemail.com with ESMTPSA id c8sm8863953wmb.34.2021.04.01.09.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 09:44:32 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Michael Chan <michael.chan@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>
References: <1a0155ce-6c20-b653-d319-58e6505a1a40@gmail.com>
Subject: [PATCH 2/3] PCI/VPD: Remove argument off from pci_vpd_find_tag
Message-ID: <f62e6e19-5423-2ead-b2bd-62844b23ef8f@gmail.com>
Date:   Thu, 1 Apr 2021 18:43:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1a0155ce-6c20-b653-d319-58e6505a1a40@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers pass 0 as offset. Therefore remove the parameter and use
a fixed offset 0 in pci_vpd_find_tag().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2.c             | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 3 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c        | 2 +-
 drivers/net/ethernet/broadcom/tg3.c              | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c       | 2 +-
 drivers/net/ethernet/sfc/efx.c                   | 2 +-
 drivers/net/ethernet/sfc/falcon/efx.c            | 2 +-
 drivers/pci/vpd.c                                | 4 ++--
 drivers/scsi/cxlflash/main.c                     | 3 +--
 include/linux/pci.h                              | 3 +--
 10 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 3e8a179f3..c0986096c 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8057,7 +8057,7 @@ bnx2_read_vpd_fw_ver(struct bnx2 *bp)
 		data[i + 3] = data[i + BNX2_VPD_LEN];
 	}
 
-	i = pci_vpd_find_tag(data, 0, BNX2_VPD_LEN, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag(data, BNX2_VPD_LEN, PCI_VPD_LRDT_RO_DATA);
 	if (i < 0)
 		goto vpd_done;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 568013875..281b1c2e0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12206,8 +12206,7 @@ static void bnx2x_read_fwinfo(struct bnx2x *bp)
 	/* VPD RO tag should be first tag after identifier string, hence
 	 * we should be able to find it in first BNX2X_VPD_LEN chars
 	 */
-	i = pci_vpd_find_tag(vpd_start, 0, BNX2X_VPD_LEN,
-			     PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag(vpd_start, BNX2X_VPD_LEN, PCI_VPD_LRDT_RO_DATA);
 	if (i < 0)
 		goto out_not_found;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6f1364212..4c517fe70 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12719,7 +12719,7 @@ static void bnxt_vpd_read_info(struct bnxt *bp)
 		goto exit;
 	}
 
-	i = pci_vpd_find_tag(vpd_data, 0, vpd_size, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
 	if (i < 0) {
 		netdev_err(bp->dev, "VPD READ-Only not found\n");
 		goto exit;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index d23819299..b0e49643f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13016,7 +13016,7 @@ static int tg3_test_nvram(struct tg3 *tp)
 	if (!buf)
 		return -ENOMEM;
 
-	i = pci_vpd_find_tag((u8 *)buf, 0, len, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag((u8 *)buf, len, PCI_VPD_LRDT_RO_DATA);
 	if (i > 0) {
 		j = pci_vpd_lrdt_size(&((u8 *)buf)[i]);
 		if (j < 0)
@@ -15629,7 +15629,7 @@ static void tg3_read_vpd(struct tg3 *tp)
 	if (!vpd_data)
 		goto out_no_vpd;
 
-	i = pci_vpd_find_tag(vpd_data, 0, vpdlen, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag(vpd_data, vpdlen, PCI_VPD_LRDT_RO_DATA);
 	if (i < 0)
 		goto out_not_found;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 98829e482..ef5d10e1c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2774,7 +2774,7 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 	if (id_len > ID_LEN)
 		id_len = ID_LEN;
 
-	i = pci_vpd_find_tag(vpd, 0, VPD_LEN, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag(vpd, VPD_LEN, PCI_VPD_LRDT_RO_DATA);
 	if (i < 0) {
 		dev_err(adapter->pdev_dev, "missing VPD-R section\n");
 		ret = -EINVAL;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 36c8625a6..c746ca723 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -920,7 +920,7 @@ static void efx_probe_vpd_strings(struct efx_nic *efx)
 	}
 
 	/* Get the Read only section */
-	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size, PCI_VPD_LRDT_RO_DATA);
+	ro_start = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
 	if (ro_start < 0) {
 		netif_err(efx, drv, efx->net_dev, "VPD Read-only not found\n");
 		return;
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f89799919..5e7a57b68 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2800,7 +2800,7 @@ static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 	}
 
 	/* Get the Read only section */
-	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size, PCI_VPD_LRDT_RO_DATA);
+	ro_start = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
 	if (ro_start < 0) {
 		netif_err(efx, drv, efx->net_dev, "VPD Read-only not found\n");
 		return;
diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 85889718a..5b80db02d 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -367,11 +367,11 @@ void pci_vpd_release(struct pci_dev *dev)
 	kfree(dev->vpd);
 }
 
-int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt)
+int pci_vpd_find_tag(const u8 *buf, unsigned int len, u8 rdt)
 {
 	int i;
 
-	for (i = off; i < len; ) {
+	for (i = 0; i < len; ) {
 		u8 val = buf[i];
 
 		if (val & PCI_VPD_LRDT) {
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index dc36531d5..222593bc2 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1649,8 +1649,7 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	}
 
 	/* Get the read only section offset */
-	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size,
-				    PCI_VPD_LRDT_RO_DATA);
+	ro_start = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
 	if (unlikely(ro_start < 0)) {
 		dev_err(dev, "%s: VPD Read-only data not found\n", __func__);
 		rc = -ENODEV;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 51660ab67..56125397f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2311,14 +2311,13 @@ static inline u8 pci_vpd_info_field_size(const u8 *info_field)
 /**
  * pci_vpd_find_tag - Locates the Resource Data Type tag provided
  * @buf: Pointer to buffered vpd data
- * @off: The offset into the buffer at which to begin the search
  * @len: The length of the vpd buffer
  * @rdt: The Resource Data Type to search for
  *
  * Returns the index where the Resource Data Type was found or
  * -ENOENT otherwise.
  */
-int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt);
+int pci_vpd_find_tag(const u8 *buf, unsigned int len, u8 rdt);
 
 /**
  * pci_vpd_find_info_keyword - Locates an information field keyword in the VPD
-- 
2.31.1


