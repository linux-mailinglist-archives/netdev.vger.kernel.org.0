Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049904563DB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhKRUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhKRUHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:07:34 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354AEC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:04:34 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso8610547wmr.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=OD7LhaYizJXAMxProAZ9XZeSLSmgt4ZYNlUEJCkYd4A=;
        b=jAjvANrBCEgoxyshr9svnmOpSVye1o3n4gASMH0h5vdY36fDNxo1oj/wezS5de0PTP
         IGxpqHAQGjJZhLDTfiO1SbSvIvmpIipO/wDEMBJB+qrmtLCzvWjOopFffUohKStHkvtM
         YW4Bm1io+A+KhcHC/zBdt7/sOZS+LWW6DWvI96CmNDLSojnwt8PXsCJdsEsim00agSZu
         9RHk8587C2stQt2Ur/nXXV6gdQG3yqQu9rXKlOHHCpFH8HgiPoOx7YACqZ0n/kpiiBIr
         xMhaJICsIi03EdcYWQcIPAKGnWuuk+6j3QeWzefvDWLypWC1U81S82zA+6MKipwjhMRt
         lHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=OD7LhaYizJXAMxProAZ9XZeSLSmgt4ZYNlUEJCkYd4A=;
        b=jM2Po5v5NcFS/RAOm5319VZBXw8fLOTuN7num6rmTVNfHJ4EsSwmXwZj/0XsL/6mhj
         ImTYvfgohrDzelIrI70KjnTvQAWNSsyOC1byb7wJRPEMZTtH+oGhm5YyoliywYVUrZvw
         Aj6zQbmidTZrWBSfEyAw3YkIqiobX7K8/fa9mItQxdpIK717IXU7QR0v3hLB92PBDLcZ
         +ezkBubJeK8l1ttJxtoOQAo/LVEvfpc89+eVruq50Eq2kq4vAUJX2PmgRuz1vxi5y6Te
         oC21BVEv4Nxe7uRL9KBmDLH8njVDJKsJI19ToI05Ap4IK+gxSRLnLAvQ+zFZOKa2RwuI
         oXfA==
X-Gm-Message-State: AOAM533+HO/ndz1Ju9/CwImKAIsXPFUphFeeso8Bh88oKFY8yOfdlSAg
        z0Zf0iTf42IleMjfqrTGV26XTaif7vU=
X-Google-Smtp-Source: ABdhPJz2DxCicLRdNX/p7ttB1eDhVJQm1gApC2CkX3kZYWhonkXdK3nGEyDdXhcVv+52R7PwVLizDw==
X-Received: by 2002:a05:600c:4e51:: with SMTP id e17mr13476883wmq.127.1637265872702;
        Thu, 18 Nov 2021 12:04:32 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:fc8d:4de8:c1d1:9213? (p200300ea8f1a0f00fc8d4de8c1d19213.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:fc8d:4de8:c1d1:9213])
        by smtp.googlemail.com with ESMTPSA id f8sm9555965wmf.2.2021.11.18.12.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 12:04:32 -0800 (PST)
Message-ID: <a12724c0-2aba-3d3c-358d-a26e0c73eb38@gmail.com>
Date:   Thu, 18 Nov 2021 21:04:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] sky2: use PCI VPD API in eeprom ethtool ops
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently pci_read/write_vpd_any() have been added to the PCI VPD API.
These functions allow to access VPD address space outside the
auto-detected VPD, and they can be used to significantly simplify the
eeprom ethtool ops.

Tested with a 88E8070 card with 1KB EEPROM.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/marvell/sky2.c | 84 +++++------------------------
 1 file changed, 12 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e9fc74e54..5ed44a191 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4266,96 +4266,36 @@ static int sky2_get_eeprom_len(struct net_device *dev)
 	return 1 << ( ((reg2 & PCI_VPD_ROM_SZ) >> 14) + 8);
 }
 
-static int sky2_vpd_wait(const struct sky2_hw *hw, int cap, u16 busy)
-{
-	unsigned long start = jiffies;
-
-	while ( (sky2_pci_read16(hw, cap + PCI_VPD_ADDR) & PCI_VPD_ADDR_F) == busy) {
-		/* Can take up to 10.6 ms for write */
-		if (time_after(jiffies, start + HZ/4)) {
-			dev_err(&hw->pdev->dev, "VPD cycle timed out\n");
-			return -ETIMEDOUT;
-		}
-		msleep(1);
-	}
-
-	return 0;
-}
-
-static int sky2_vpd_read(struct sky2_hw *hw, int cap, void *data,
-			 u16 offset, size_t length)
-{
-	int rc = 0;
-
-	while (length > 0) {
-		u32 val;
-
-		sky2_pci_write16(hw, cap + PCI_VPD_ADDR, offset);
-		rc = sky2_vpd_wait(hw, cap, 0);
-		if (rc)
-			break;
-
-		val = sky2_pci_read32(hw, cap + PCI_VPD_DATA);
-
-		memcpy(data, &val, min(sizeof(val), length));
-		offset += sizeof(u32);
-		data += sizeof(u32);
-		length -= sizeof(u32);
-	}
-
-	return rc;
-}
-
-static int sky2_vpd_write(struct sky2_hw *hw, int cap, const void *data,
-			  u16 offset, unsigned int length)
-{
-	unsigned int i;
-	int rc = 0;
-
-	for (i = 0; i < length; i += sizeof(u32)) {
-		u32 val = *(u32 *)(data + i);
-
-		sky2_pci_write32(hw, cap + PCI_VPD_DATA, val);
-		sky2_pci_write32(hw, cap + PCI_VPD_ADDR, offset | PCI_VPD_ADDR_F);
-
-		rc = sky2_vpd_wait(hw, cap, PCI_VPD_ADDR_F);
-		if (rc)
-			break;
-	}
-	return rc;
-}
-
 static int sky2_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 			   u8 *data)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
-	int cap = pci_find_capability(sky2->hw->pdev, PCI_CAP_ID_VPD);
-
-	if (!cap)
-		return -EINVAL;
+	int rc;
 
 	eeprom->magic = SKY2_EEPROM_MAGIC;
+	rc = pci_read_vpd_any(sky2->hw->pdev, eeprom->offset, eeprom->len,
+			      data);
+	if (rc < 0)
+		return rc;
+
+	eeprom->len = rc;
 
-	return sky2_vpd_read(sky2->hw, cap, data, eeprom->offset, eeprom->len);
+	return 0;
 }
 
 static int sky2_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 			   u8 *data)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
-	int cap = pci_find_capability(sky2->hw->pdev, PCI_CAP_ID_VPD);
-
-	if (!cap)
-		return -EINVAL;
+	int rc;
 
 	if (eeprom->magic != SKY2_EEPROM_MAGIC)
 		return -EINVAL;
 
-	/* Partial writes not supported */
-	if ((eeprom->offset & 3) || (eeprom->len & 3))
-		return -EINVAL;
+	rc = pci_write_vpd_any(sky2->hw->pdev, eeprom->offset, eeprom->len,
+			       data);
 
-	return sky2_vpd_write(sky2->hw, cap, data, eeprom->offset, eeprom->len);
+	return rc < 0 ? rc : 0;
 }
 
 static netdev_features_t sky2_fix_features(struct net_device *dev,
-- 
2.33.0

