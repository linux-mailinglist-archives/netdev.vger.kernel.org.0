Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901752C826A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgK3Kmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727288AbgK3Kmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:42:33 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E15C0613D3;
        Mon, 30 Nov 2020 02:41:53 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id iq13so1077081pjb.3;
        Mon, 30 Nov 2020 02:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JFWMskB7fcJ8bEDz+gDr8rZxF7QDCLZctuHRy5whdrg=;
        b=MHVGH9zPED6+k3AogAFwV63kYP/y9uvLRSFeQyaK6BTcJIFZanejwC0JikQurFMpOh
         Ciqq/ToXP0CGRlIuFq04zIugywQ+SSjFib+7eTcaWShAwdb+j+gMMT1XyDyNzRFBKLyT
         KZ9IovdLyyvo4GVhos4yJ2slVTjrvMG+wRlPAprPUyppqdL27eNos5rn8k3qwTZ/JwXM
         ypUP6fl+AxgNboVk32ogGz+jGjHNeYdW+xRujIBy6xwIg65KygkqxNMI8dz6cD5TNo35
         YsvkxfpTgdb+B93xlzyUQLyW8Eb7w0c6Czj+ZpoFgO9tT8sCSAf0XlW2bkvFUNNbwDpT
         Jt8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JFWMskB7fcJ8bEDz+gDr8rZxF7QDCLZctuHRy5whdrg=;
        b=rUxM22XXvlp/1W0r2j07BLTKc743ht47rzvA4voLVKWBn+0C3XSPKEe+9CWSaeK7hI
         LZqrWmd6m8xIbjW2VBHwOz3CgmPPlI5eTwkqTgtxzdgTAE7yKhI+6ndIUGnxvtXg/f0o
         qslT4b7iO7OS6SKhND1Nht/ehOe3y8kyFfZwktT6HVk1U6wl2yCCgLpMqUaIa4vNfc8q
         dTuy0n1e6zYyrmg1zWtNETiw4BJzF/FUBgdx6As7FOG2pzUGI8kk40eiI6Lgjkuv7EK8
         yg2YpfC/0eDVyXU1Tidphd86hcRMmzhs71snKKjc6/DwISHepX9kelHLnLkBFl91WgvW
         CScg==
X-Gm-Message-State: AOAM532GqpLmykMhPn/wfGxfW01jxjDywOBGcatan0lsVr90YS+VoNXy
        5iKPAQrum2h3r7wRKAKp7o9Hk15oV7w=
X-Google-Smtp-Source: ABdhPJx+ksQYaKdPAj3Om+JZHRbC42lsZoRqbbP68lT4yiK4IbXR++0ACpEeaMPUiCfp8w/FcvRc4w==
X-Received: by 2002:a17:90b:46d2:: with SMTP id jx18mr3257454pjb.106.1606732912588;
        Mon, 30 Nov 2020 02:41:52 -0800 (PST)
Received: from localhost.localdomain ([8.210.202.142])
        by smtp.gmail.com with ESMTPSA id p6sm22165867pjt.13.2020.11.30.02.41.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 02:41:52 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net: phy: marvell: replace phy_modify()
Date:   Mon, 30 Nov 2020 18:41:35 +0800
Message-Id: <1606732895-9136-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a set of phy_set_bits() looks more neater

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 drivers/net/phy/marvell.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 587930a..620052c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1132,8 +1132,8 @@ static int m88e1510_config_init(struct phy_device *phydev)
 			return err;
 
 		/* PHY reset is necessary after changing MODE[2:0] */
-		err = phy_modify(phydev, MII_88E1510_GEN_CTRL_REG_1, 0,
-				 MII_88E1510_GEN_CTRL_REG_1_RESET);
+		err = phy_set_bits(phydev, MII_88E1510_GEN_CTRL_REG_1,
+				   MII_88E1510_GEN_CTRL_REG_1_RESET);
 		if (err < 0)
 			return err;
 
@@ -1725,8 +1725,8 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			__phy_read(phydev, MII_M1011_IEVENT);
 
 		/* Enable the WOL interrupt */
-		err = __phy_modify(phydev, MII_88E1318S_PHY_CSIER, 0,
-				   MII_88E1318S_PHY_CSIER_WOL_EIE);
+		err = __phy_set_bits(phydev, MII_88E1318S_PHY_CSIER,
+				     MII_88E1318S_PHY_CSIER_WOL_EIE);
 		if (err < 0)
 			goto error;
 
@@ -1764,9 +1764,9 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			goto error;
 
 		/* Clear WOL status and enable magic packet matching */
-		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL, 0,
-				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS |
-				   MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE);
+		err = __phy_set_bits(phydev, MII_88E1318S_PHY_WOL_CTRL,
+				     MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS |
+				     MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE);
 		if (err < 0)
 			goto error;
 	} else {
@@ -1995,7 +1995,7 @@ static int marvell_cable_test_start_common(struct phy_device *phydev)
 		return bmsr;
 
 	if (bmcr & BMCR_ANENABLE) {
-		ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+		ret =  phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE);
 		if (ret < 0)
 			return ret;
 		ret = genphy_soft_reset(phydev);
-- 
1.9.1

