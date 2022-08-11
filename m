Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1566758FFE3
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbiHKPeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbiHKPeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:34:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417909A973;
        Thu, 11 Aug 2022 08:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34D40B82160;
        Thu, 11 Aug 2022 15:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DE0C433D6;
        Thu, 11 Aug 2022 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231943;
        bh=KIB9EVKtBzfUUknAr4YPMO7GrWCmDHZ1sLMzEulCnzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMaxqTKzkR74zNVRyiJY1M3HIWTohLRPJhDjQ2Qq0/Fqpbh063AVsTdDrW+nZDHbJ
         /AAWkA9yAlU4WFl64kV12QrPdtq1Ie0q1tt1HNDNHegOOv5gtEm7TuU24tazd9/z/Q
         ZUy8oHTV6TnSQFAJyMjTcxZrAdk8/Usky4t/yJ9IVm8MFStbcbOPU1vwKCidOk0lLH
         GUeZmYqOJrkHq8Z/cMUP0pP9IG/bZSOD9PwwidFnbTguk9+CKYirs6MCIRUFv3Vzbk
         o9rWX8a9n8UU1PXuf9gWWUJTIclTiTNep4tdDQGj/pYHGyDJl515GyJiw0QroGAsb0
         tq8GlqVsEwvEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, olteanv@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 028/105] net: make xpcs_do_config to accept advertising for pcs-xpcs and sja1105
Date:   Thu, 11 Aug 2022 11:27:12 -0400
Message-Id: <20220811152851.1520029-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit fa9c562f9735d24c3253747eb21f3f0c0f6de48e ]

xpcs_config() has 'advertising' input that is required for C37 1000BASE-X
AN in later patch series. So, we prepare xpcs_do_config() for it.

For sja1105, xpcs_do_config() is used for xpcs configuration without
depending on advertising input, so set to NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 drivers/net/pcs/pcs-xpcs.c             | 6 +++---
 include/linux/pcs/pcs-xpcs.h           | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 698c7d1fb45c..b03d0d0c3dbf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2330,7 +2330,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		else
 			mode = MLO_AN_PHY;
 
-		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode);
+		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode, NULL);
 		if (rc < 0)
 			goto out;
 
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index d25fbb9caeba..b17908a0b27c 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -795,7 +795,7 @@ static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 }
 
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode)
+		   unsigned int mode, const unsigned long *advertising)
 {
 	const struct xpcs_compat *compat;
 	int ret;
@@ -843,7 +843,7 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
-	return xpcs_do_config(xpcs, interface, mode);
+	return xpcs_do_config(xpcs, interface, mode, advertising);
 }
 
 static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
@@ -864,7 +864,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 
 		state->link = 0;
 
-		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND);
+		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
 	}
 
 	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 266eb26fb029..37eb97cc2283 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -30,7 +30,7 @@ int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
 void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		  phy_interface_t interface, int speed, int duplex);
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode);
+		   unsigned int mode, const unsigned long *advertising);
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-- 
2.35.1

