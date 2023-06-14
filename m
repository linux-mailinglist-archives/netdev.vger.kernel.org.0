Return-Path: <netdev+bounces-10892-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 208C7730ABA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42E7F1C20DD3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E2A156C6;
	Wed, 14 Jun 2023 22:30:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA481EA8C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:30:45 +0000 (UTC)
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE57269A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:30:39 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f9de2605b2so1002951cf.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686781838; x=1689373838;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NOMdCaKqX+qGcOjuE2+H2oQX+8AJZglldz8FH3LX8zc=;
        b=dW4gIonDqtz0rYSGBOJ1PGQk1eeYs0Sq/FKjSmbcilMF6T5ks+Nj0yS++FL24sCIN8
         ruuFHKey5UtwkdEMSrjTzP4eY57+g6Z50LGBKXitMv+DytAOsnfAQK5ODPADw39UFUIt
         Q+JBxIQexf8Vmf9CjXGSTUYdl5tARTdSjtnbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686781838; x=1689373838;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOMdCaKqX+qGcOjuE2+H2oQX+8AJZglldz8FH3LX8zc=;
        b=F5rp2WpMFbaMJ8XHEOGWL1GxXVP+eBl1hgp2rdF3lxbS/nlsRW0XCmbRbVRcOFIHFp
         w6sc0h0Fc6oeZhUYmn8RCmp9FjnclajfEgHbRbSnYoj8GAWHmI4Hfu82+DhCFkN/eRfc
         u1c5gKrEXuGOkyin1Fwlzf06bqTbg0BoAgUBqfEjARhzmbcIDbn/MUf0MlGZAQjk8viz
         SO6antVNMABQmNJ9dCoPg1P6Qr93ruk8jIfSDEgurcFLNlxHAk7FJsCIhc64Cn16BZlj
         VWoh2Qua8XTs3O4jy5ALysRvNi5Azwf9/qc2mlpRcVV2v0IbVjS2tF8LKIK8+ZpbqnyS
         W/0w==
X-Gm-Message-State: AC+VfDwvXalOrDEt/D4xnFh0FxBETrS60E1CbaNttK/TmtTtKTw3L8wh
	DCSWgTbnkrVGYgeMXxq1ymGl2iw90mGJbTBp/WfWad/QOL/OMg13y5xbj+7C303OWcDvH0EYZfE
	/X36Lb/8CVGhwf4RJ73dsFxKxNQ7L/v72qQUJocRNxgWI4XaDU4N3CEchVtU6VFFFu2KlAaSvhX
	3Q/SAF0Q==
X-Google-Smtp-Source: ACHHUZ4shW84sK/NjglsIHbdA4txgU/WmnunxiRLyCo5e/kAKwZlvxBnMvDJadpm9fKitfFA/CnzzQ==
X-Received: by 2002:ac8:7d4d:0:b0:3f8:25c:c434 with SMTP id h13-20020ac87d4d000000b003f8025cc434mr3460689qtb.19.1686781838434;
        Wed, 14 Jun 2023 15:30:38 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d3-20020ac85443000000b003ef2db16e72sm5419360qtq.94.2023.06.14.15.30.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jun 2023 15:30:37 -0700 (PDT)
From: Justin Chen <justin.chen@broadcom.com>
To: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com
Cc: florian.fainelli@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	opendmb@gmail.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	richardcochran@gmail.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	simon.horman@corigine.com,
	Justin Chen <justin.chen@broadcom.com>
Subject: [PATCH net-next v7 04/11] net: bcmasp: Add support for WoL magic packet
Date: Wed, 14 Jun 2023 15:30:13 -0700
Message-Id: <1686781820-832-5-git-send-email-justin.chen@broadcom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
References: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000051e7bb05fe1e80d5"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

--00000000000051e7bb05fe1e80d5

Add support for Wake-On-Lan magic packet and magic packet with password.

Signed-off-by: Justin Chen <justin.chen@broadcom.com>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 148 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  18 +++
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  36 +++++
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |  77 +++++++++--
 4 files changed, 266 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index 5dbd9fcdd23f..9e3977856b71 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -441,6 +441,139 @@ static int bcmasp_is_port_valid(struct bcmasp_priv *priv, int port)
 	return port == 0 || port == 1;
 }
 
+static irqreturn_t bcmasp_isr_wol(int irq, void *data)
+{
+	struct bcmasp_priv *priv = data;
+	u32 status;
+
+	/* No L3 IRQ, so we good */
+	if (priv->wol_irq <= 0)
+		goto irq_handled;
+
+	status = wakeup_intr2_core_rl(priv, ASP_WAKEUP_INTR2_STATUS) &
+		~wakeup_intr2_core_rl(priv, ASP_WAKEUP_INTR2_MASK_STATUS);
+	wakeup_intr2_core_wl(priv, status, ASP_WAKEUP_INTR2_CLEAR);
+
+irq_handled:
+	pm_wakeup_event(&priv->pdev->dev, 0);
+	return IRQ_HANDLED;
+}
+
+static int bcmasp_get_and_request_irq(struct bcmasp_priv *priv, int i)
+{
+	struct platform_device *pdev = priv->pdev;
+	int irq, ret;
+
+	irq = platform_get_irq_optional(pdev, i);
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_irq(&pdev->dev, irq, bcmasp_isr_wol, 0,
+			       pdev->name, priv);
+	if (ret)
+		return ret;
+
+	return irq;
+}
+
+static void bcmasp_init_wol_shared(struct bcmasp_priv *priv)
+{
+	struct platform_device *pdev = priv->pdev;
+	struct device *dev = &pdev->dev;
+	int irq;
+
+	irq = bcmasp_get_and_request_irq(priv, 1);
+	if (irq < 0) {
+		dev_warn(dev, "Failed to init WoL irq: %d\n", irq);
+		return;
+	}
+
+	priv->wol_irq = irq;
+	priv->wol_irq_enabled_mask = 0;
+	device_set_wakeup_capable(&pdev->dev, 1);
+}
+
+static void bcmasp_enable_wol_shared(struct bcmasp_intf *intf, bool en)
+{
+	struct bcmasp_priv *priv = intf->parent;
+	struct device *dev = &priv->pdev->dev;
+
+	if (en) {
+		if (priv->wol_irq_enabled_mask) {
+			set_bit(intf->port, &priv->wol_irq_enabled_mask);
+			return;
+		}
+
+		/* First enable */
+		set_bit(intf->port, &priv->wol_irq_enabled_mask);
+		enable_irq_wake(priv->wol_irq);
+		device_set_wakeup_enable(dev, 1);
+	} else {
+		if (!priv->wol_irq_enabled_mask)
+			return;
+
+		clear_bit(intf->port, &priv->wol_irq_enabled_mask);
+		if (priv->wol_irq_enabled_mask)
+			return;
+
+		/* Last disable */
+		disable_irq_wake(priv->wol_irq);
+		device_set_wakeup_enable(dev, 0);
+	}
+}
+
+static void bcmasp_wol_irq_destroy_shared(struct bcmasp_priv *priv)
+{
+	if (priv->wol_irq > 0)
+		free_irq(priv->wol_irq, priv);
+}
+
+static void bcmasp_init_wol_per_intf(struct bcmasp_priv *priv)
+{
+	struct platform_device *pdev = priv->pdev;
+	struct device *dev = &pdev->dev;
+	struct bcmasp_intf *intf;
+	int irq, i;
+
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+		irq = bcmasp_get_and_request_irq(priv, intf->port + 1);
+		if (irq < 0) {
+			dev_warn(dev, "Failed to init WoL irq(port %d): %d\n",
+				 intf->port, irq);
+			continue;
+		}
+
+		intf->wol_irq = irq;
+		intf->wol_irq_enabled = false;
+		device_set_wakeup_capable(&pdev->dev, 1);
+	}
+}
+
+static void bcmasp_enable_wol_per_intf(struct bcmasp_intf *intf, bool en)
+{
+	struct device *dev = &intf->parent->pdev->dev;
+
+	if (en ^ intf->wol_irq_enabled)
+		irq_set_irq_wake(intf->wol_irq, en);
+
+	intf->wol_irq_enabled = en;
+	device_set_wakeup_enable(dev, en);
+}
+
+static void bcmasp_wol_irq_destroy_per_intf(struct bcmasp_priv *priv)
+{
+	struct bcmasp_intf *intf;
+	int i;
+
+	for (i = 0; i < priv->intf_count; i++) {
+		intf = priv->intfs[i];
+
+		if (intf->wol_irq > 0)
+			free_irq(intf->wol_irq, priv);
+	}
+}
+
 static struct bcmasp_hw_info v20_hw_info = {
 	.rx_ctrl_flush = ASP_RX_CTRL_FLUSH,
 	.umac2fb = UMAC2FB_OFFSET,
@@ -450,6 +583,9 @@ static struct bcmasp_hw_info v20_hw_info = {
 };
 
 static const struct bcmasp_plat_data v20_plat_data = {
+	.init_wol = bcmasp_init_wol_per_intf,
+	.enable_wol = bcmasp_enable_wol_per_intf,
+	.destroy_wol = bcmasp_wol_irq_destroy_per_intf,
 	.hw_info = &v20_hw_info,
 };
 
@@ -463,6 +599,9 @@ static struct bcmasp_hw_info v21_hw_info = {
 };
 
 static const struct bcmasp_plat_data v21_plat_data = {
+	.init_wol = bcmasp_init_wol_shared,
+	.enable_wol = bcmasp_enable_wol_shared,
+	.destroy_wol = bcmasp_wol_irq_destroy_shared,
 	.hw_info = &v21_hw_info,
 };
 
@@ -515,11 +654,15 @@ static int bcmasp_probe(struct platform_device *pdev)
 	priv->pdev = pdev;
 	spin_lock_init(&priv->mda_lock);
 	spin_lock_init(&priv->clk_lock);
+	mutex_init(&priv->wol_lock);
 
 	pdata = device_get_match_data(&pdev->dev);
 	if (!pdata)
 		return dev_err_probe(dev, -EINVAL, "unable to find platform data\n");
 
+	priv->init_wol = pdata->init_wol;
+	priv->enable_wol = pdata->enable_wol;
+	priv->destroy_wol = pdata->destroy_wol;
 	priv->hw_info = pdata->hw_info;
 
 	/* Enable all clocks to ensure successful probing */
@@ -579,6 +722,9 @@ static int bcmasp_probe(struct platform_device *pdev)
 		i++;
 	}
 
+	/* Check and enable WoL */
+	priv->init_wol(priv);
+
 	/* Drop the clock reference count now and let ndo_open()/ndo_close()
 	 * manage it for us from now on.
 	 */
@@ -617,6 +763,8 @@ static int bcmasp_remove(struct platform_device *pdev)
 	struct bcmasp_intf *intf;
 	int i;
 
+	priv->destroy_wol(priv);
+
 	for (i = 0; i < priv->intf_count; i++) {
 		intf = priv->intfs[i];
 		if (!intf)
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.h b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
index 26bcf09a63df..7034418101a4 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -299,6 +299,12 @@ struct bcmasp_intf {
 
 	/* Statistics */
 	struct bcmasp_intf_stats64	stats64;
+
+	u32			wolopts;
+	u8			sopass[SOPASS_MAX];
+	/* Used if per intf wol irq */
+	int			wol_irq;
+	unsigned int		wol_irq_enabled:1;
 };
 
 #define NUM_MDA_FILTERS				32
@@ -321,6 +327,9 @@ struct bcmasp_hw_info {
 };
 
 struct bcmasp_plat_data {
+	void (*init_wol)(struct bcmasp_priv *priv);
+	void (*enable_wol)(struct bcmasp_intf *intf, bool en);
+	void (*destroy_wol)(struct bcmasp_priv *priv);
 	struct bcmasp_hw_info		*hw_info;
 };
 
@@ -331,6 +340,15 @@ struct bcmasp_priv {
 	int				irq;
 	u32				irq_mask;
 
+	/* Used if shared wol irq */
+	struct mutex			wol_lock;
+	int				wol_irq;
+	unsigned long			wol_irq_enabled_mask;
+
+	void (*init_wol)(struct bcmasp_priv *priv);
+	void (*enable_wol)(struct bcmasp_intf *intf, bool en);
+	void (*destroy_wol)(struct bcmasp_priv *priv);
+
 	void __iomem			*base;
 	struct	bcmasp_hw_info		*hw_info;
 
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
index 394c0e1cb026..ae24a1f74d49 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -30,6 +30,40 @@ static void bcmasp_set_msglevel(struct net_device *dev, u32 level)
 	intf->msg_enable = level;
 }
 
+#define BCMASP_SUPPORTED_WAKE   (WAKE_MAGIC | WAKE_MAGICSECURE)
+static void bcmasp_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	wol->supported = BCMASP_SUPPORTED_WAKE;
+	wol->wolopts = intf->wolopts;
+	memset(wol->sopass, 0, sizeof(wol->sopass));
+
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(wol->sopass, intf->sopass, sizeof(intf->sopass));
+}
+
+static int bcmasp_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	struct bcmasp_priv *priv = intf->parent;
+	struct device *kdev = &priv->pdev->dev;
+
+	if (!device_can_wakeup(kdev))
+		return -EOPNOTSUPP;
+
+	/* Interface Specific */
+	intf->wolopts = wol->wolopts;
+	if (intf->wolopts & WAKE_MAGICSECURE)
+		memcpy(intf->sopass, wol->sopass, sizeof(wol->sopass));
+
+	mutex_lock(&priv->wol_lock);
+	priv->enable_wol(intf, !!intf->wolopts);
+	mutex_unlock(&priv->wol_lock);
+
+	return 0;
+}
+
 const struct ethtool_ops bcmasp_ethtool_ops = {
 	.get_drvinfo		= bcmasp_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
@@ -37,4 +71,6 @@ const struct ethtool_ops bcmasp_ethtool_ops = {
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.get_msglevel		= bcmasp_get_msglevel,
 	.set_msglevel		= bcmasp_set_msglevel,
+	.get_wol		= bcmasp_get_wol,
+	.set_wol		= bcmasp_set_wol,
 };
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 9d5990663768..35b9d6390db3 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1044,7 +1044,7 @@ static int bcmasp_netif_init(struct net_device *dev, bool phy_connect)
 			netdev_err(dev, "could not attach to PHY\n");
 			goto err_phy_disable;
 		}
-	} else {
+	} else if (!intf->wolopts) {
 		ret = phy_resume(dev->phydev);
 		if (ret)
 			goto err_phy_disable;
@@ -1301,8 +1301,39 @@ void bcmasp_interface_destroy(struct bcmasp_intf *intf, bool unregister)
 	free_netdev(intf->ndev);
 }
 
+static void bcmasp_suspend_to_wol(struct bcmasp_intf *intf)
+{
+	struct net_device *ndev = intf->ndev;
+	u32 reg;
+
+	reg = umac_rl(intf, UMC_MPD_CTRL);
+	if (intf->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE))
+		reg |= UMC_MPD_CTRL_MPD_EN;
+	reg &= ~UMC_MPD_CTRL_PSW_EN;
+	if (intf->wolopts & WAKE_MAGICSECURE) {
+		/* Program the SecureOn password */
+		umac_wl(intf, get_unaligned_be16(&intf->sopass[0]),
+			UMC_PSW_MS);
+		umac_wl(intf, get_unaligned_be32(&intf->sopass[2]),
+			UMC_PSW_LS);
+		reg |= UMC_MPD_CTRL_PSW_EN;
+	}
+	umac_wl(intf, reg, UMC_MPD_CTRL);
+
+	/* UniMAC receive needs to be turned on */
+	umac_enable_set(intf, UMC_CMD_RX_EN, 1);
+
+	if (intf->parent->wol_irq > 0) {
+		wakeup_intr2_core_wl(intf->parent, 0xffffffff,
+				     ASP_WAKEUP_INTR2_MASK_CLEAR);
+	}
+
+	netif_dbg(intf, wol, ndev, "entered WOL mode\n");
+}
+
 int bcmasp_interface_suspend(struct bcmasp_intf *intf)
 {
+	struct device *kdev = &intf->parent->pdev->dev;
 	struct net_device *dev = intf->ndev;
 	int ret = 0;
 
@@ -1313,20 +1344,24 @@ int bcmasp_interface_suspend(struct bcmasp_intf *intf)
 
 	bcmasp_netif_deinit(dev);
 
-	ret = phy_suspend(dev->phydev);
-	if (ret)
-		goto out;
+	if (!intf->wolopts) {
+		ret = phy_suspend(dev->phydev);
+		if (ret)
+			goto out;
 
-	if (intf->internal_phy)
-		bcmasp_ephy_enable_set(intf, false);
-	else
-		bcmasp_rgmii_mode_en_set(intf, false);
+		if (intf->internal_phy)
+			bcmasp_ephy_enable_set(intf, false);
+		else
+			bcmasp_rgmii_mode_en_set(intf, false);
 
-	/*
-	 * If Wake-on-LAN is disabled, we can safely
-	 * disable the network interface clocks.
-	 */
-	bcmasp_core_clock_set_intf(intf, false);
+		/* If Wake-on-LAN is disabled, we can safely
+		 * disable the network interface clocks.
+		 */
+		bcmasp_core_clock_set_intf(intf, false);
+	}
+
+	if (device_may_wakeup(kdev) && intf->wolopts)
+		bcmasp_suspend_to_wol(intf);
 
 	clk_disable_unprepare(intf->parent->clk);
 
@@ -1337,6 +1372,20 @@ int bcmasp_interface_suspend(struct bcmasp_intf *intf)
 	return ret;
 }
 
+static void bcmasp_resume_from_wol(struct bcmasp_intf *intf)
+{
+	u32 reg;
+
+	reg = umac_rl(intf, UMC_MPD_CTRL);
+	reg &= ~UMC_MPD_CTRL_MPD_EN;
+	umac_wl(intf, reg, UMC_MPD_CTRL);
+
+	if (intf->parent->wol_irq > 0) {
+		wakeup_intr2_core_wl(intf->parent, 0xffffffff,
+				     ASP_WAKEUP_INTR2_MASK_SET);
+	}
+}
+
 int bcmasp_interface_resume(struct bcmasp_intf *intf)
 {
 	struct net_device *dev = intf->ndev;
@@ -1353,6 +1402,8 @@ int bcmasp_interface_resume(struct bcmasp_intf *intf)
 	if (ret)
 		goto out;
 
+	bcmasp_resume_from_wol(intf);
+
 	netif_device_attach(dev);
 
 	return 0;
-- 
2.7.4


--00000000000051e7bb05fe1e80d5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
NhTY3E+cXCB11wty89QStajwXdhGJTYEvUgvsq1h8CwJj9w/38ldAQf5WjhPmApYeJR2ewFrBMCM
4lHkdRJ6TDc9nXoEkypUfjJkJHe7Eal06tosh6JpAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGp1c3Rpbi5jaGVuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUIWGeYuaTsnIada5Xx8TR3cheUbgw
DQYJKoZIhvcNAQELBQADggEBAHNQlMqQOFYPYFO71A+8t+qWMmtOdd2iGswSOvpSZ/pmGlfw8ZvY
dRTkl27m37la84AxRkiVMes14JyOZJoMh/g7fbgPlU14eBc6WQWkIA6AmNkduFWTr1pRezkjpeo6
xVmdBLM4VY1TFDYj7S8H2adPuypd62uHMY/MZi+BIUys4uAFA+N3NuUBNjcVZXYPplYxxKEuIFq6
sDL+OV16G+F9CkNMN3txsym8Nnx5WAYZb6+rBUIhMGz70V05xsHQfzvo2s7f0J1tJ5BoRlPPhL0h
VOnWA3h71u9TfSsv+PXVm3P21TfOS2uc1hbzEqyENCP4i5XQ0rv0TmPW42GZ0o4xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwj8BKLXNpALfemdRAwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHRy6/DfzTKpxo4ddX5X82RIxh1l90vAmt0c
MAi93ciHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNDIy
MzAzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAR+a9x0iGrN/lLUT41rXJnyEnT66oh5wmXa0HmjtR0OMsaHGcYN21R
H/nQuJ2+yfxtzBgthfyJzzgghx4L9DWrm2LOeu+jew2H3jgG7P/wO3ru/XAbUdBdTPuNHgU9q8MT
lNVrdYcDhg/XGsYaJ8QuKN+TPsPR4NbQskNdOVncwtA0obC9/Fl2UZSvlnTxsJmgRH98VTa7fVCj
14970Wn6nYW57I/bNzFGcrEOAMlJChPQW3RDpZ7ZBnvlJUDN931vWGA+jG4i2RbznQmQjLhWdxtv
HGJzddQ+TXiHza+el55/rbIKPoZ61ukZVfDxTVg8XLJXm4JnkOaxcmjI2Ep0
--00000000000051e7bb05fe1e80d5--

