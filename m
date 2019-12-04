Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E4B112115
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 02:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfLDBfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 20:35:19 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35360 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfLDBfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 20:35:19 -0500
Received: by mail-lj1-f195.google.com with SMTP id j6so6105416lja.2
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 17:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UMPvyqOszpTR57mHBBfSkcYqC/fepbtPH7cx3hUMoGI=;
        b=sXvmJSip+Siy6ewwPH3vALjZHZExzfc05x1+Et3PJFRgfaqTQLg1nBuVLjTjM45rxT
         QJ/Ocqv3E2sN6bWpOm2bI9PmpG1FZDlHwR7HcQOUEyrng5e4xavYTpdn1wa4nICp9YL+
         MEVkQE56b75Msm6a6in+ufAiX6zIBbl3Xk/H/HcOg9seQiwbjobVMSTvIiUGA1vJ52iv
         lNJLLSj0Lkn+9T12AXFyowYiEz6mNhD7YRzGYRXkPdC22ZaS9lLQu+E6NDn+PRex5ur2
         MxDjAZ1ffJU4Qqhe5r1ZMJL5TfZJpCs383vWF+LFCXGMZC66ZVjc0JelN0rtY3eJTPa7
         DOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=UMPvyqOszpTR57mHBBfSkcYqC/fepbtPH7cx3hUMoGI=;
        b=K0pWmCxIu+i4CfSsJ3JMKrRipnmo2sMqyXn0VhJIMA+ILCRnp2wlahJpxO0Xk2SQW7
         eLl8v47uP2Z2j9Q7ntoazFX+V9fDlqxG2sPpRMMcg6cKStqJQ+I/a/E9bmAAIRKLfwyK
         Sv/kaOc3zXvHnLnGKTyCyzsbqYHFn4IrDxUiLqxIv4lnVTTiYnW4l/HndxTV8fWoa5Ku
         lGPI6W9fDE3EFz0PE6kfzxP8ZF0jMkb9YUk9U8+pN2VdqVKcGfTosona6KZhhlSOhRBj
         OMGTl0Hd6NJpB5vjcEgKemH7sW9ModokS/y+5DpRrPAWFCVrFhe3HphuQPN1ar7DZjwG
         w5fA==
X-Gm-Message-State: APjAAAXeE7G9xLMzgzlU9WprKS6rSy6oNfhRV7rwAfWRrY6xo5LDkt+w
        FyvbAqqN9DdI0UuxUMyhD8Gd1Q==
X-Google-Smtp-Source: APXvYqwlMKc0C/OfS1CLH3gVfSS45eYbhx+z6m+ZuTHt6NG+ldhat7v7GVH0HvhGKi+VKbcymUgTFg==
X-Received: by 2002:a2e:b537:: with SMTP id z23mr310394ljm.129.1575423315806;
        Tue, 03 Dec 2019 17:35:15 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id 144sm2271623lfi.67.2019.12.03.17.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 17:35:15 -0800 (PST)
Date:   Wed, 4 Dec 2019 03:35:12 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v1,net-next, 2/2] enetc: implement the enetc 802.1Qbu hardware
 function
Message-ID: <20191204013511.GF2680@khorivan>
Mail-Followup-To: Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <20191127094517.6255-2-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191127094517.6255-2-Po.Liu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 09:59:30AM +0000, Po Liu wrote:

Hi, Po Liu

>The interface follow up the ethtool 'preemption' set/get.
>Hardware features also need to set hw_features with
>NETIF_F_PREEMPTION flag. So ethtool could check kernel
>link features if there is preemption capability of port.
>
>There are two MACs in ENETC. One is express MAC which traffic
>classes in it are advanced transmition. Another is preemptable
>MAC which traffic classes are frame preemptable.
>
>The hardware need to initialize the MACs at initial stage.
>And then set the preemption enable registers of traffic
>classes when ethtool set .get_link_ksettings/.set_link_ksettings
>stage.
>
>To test the ENETC preemption capability, user need to set mqprio
>or taprio to mapping the traffic classes with priorities. Then
>use ethtool command to set 'preemption' with a 8 bits value.
>MSB represent high number traffic class.
>
>Signed-off-by: Po Liu <Po.Liu@nxp.com>
>---
> drivers/net/ethernet/freescale/enetc/enetc.c  |   3 +
> drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
> .../ethernet/freescale/enetc/enetc_ethtool.c  | 142 ++++++++++++++++--
> .../net/ethernet/freescale/enetc/enetc_hw.h   |  17 +++
> .../net/ethernet/freescale/enetc/enetc_pf.c   |  15 +-
> .../net/ethernet/freescale/enetc/enetc_qos.c  |   4 +

[...]

>+
>+static u32 enetc_preemption_get(struct net_device *ndev)
>+{
>+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>+	u32 ptvector = 0;
>+	u8 tc_num;
>+	int i;
>+
>+	/* If preemptable MAC is not enable return 0 */
>+	if (!(enetc_port_rd(&priv->si->hw, ENETC_PFPMR) & ENETC_PFPMR_PMACE))
>+		return 0;
>+
>+	tc_num = enetc_get_tc_num(priv->si);
>+
>+	for (i = 0; i < tc_num; i++)
>+		if (enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(i)) & ENETC_FPE)
>+			ptvector |= 1 << i;

Would be better to replace above on just priv var?

>+
>+	return ptvector;
>+}
>+
>+static int enetc_get_link_ksettings(struct net_device *ndev,
>+				    struct ethtool_link_ksettings *cmd)
>+{
>+	cmd->base.preemption = enetc_preemption_get(ndev);
>+
>+	return phy_ethtool_get_link_ksettings(ndev, cmd);
>+}
>+
>+static int enetc_set_link_ksettings(struct net_device *ndev,
>+				    const struct ethtool_link_ksettings *cmd)
>+{
>+	int err;
>+
>+	err = enetc_preemption_set(ndev, cmd->base.preemption);
>+	if (err)
>+		return err;

Shouldn't it be after
phy_ethtool_set_link_ksettings() ?

I mean after potential phy restart, does it have impact on it?

>+
>+	return phy_ethtool_set_link_ksettings(ndev, cmd);
>+}
>+
> static const struct ethtool_ops enetc_pf_ethtool_ops = {
> 	.get_regs_len = enetc_get_reglen,
> 	.get_regs = enetc_get_regs,
>@@ -622,8 +746,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
> 	.get_rxfh = enetc_get_rxfh,
> 	.set_rxfh = enetc_set_rxfh,
> 	.get_ringparam = enetc_get_ringparam,
>-	.get_link_ksettings = phy_ethtool_get_link_ksettings,
>-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
>+	.get_link_ksettings = enetc_get_link_ksettings,
>+	.set_link_ksettings = enetc_set_link_ksettings,
> 	.get_link = ethtool_op_get_link,
> 	.get_ts_info = enetc_get_ts_info,
> 	.get_wol = enetc_get_wol,
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>index 51f543ef37a8..b609ec095710 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>@@ -19,6 +19,7 @@
> #define ENETC_SICTR1	0x1c
> #define ENETC_SIPCAPR0	0x20
> #define ENETC_SIPCAPR0_QBV	BIT(4)
>+#define ENETC_SIPCAPR0_QBU	BIT(3)
> #define ENETC_SIPCAPR0_RSS	BIT(8)
> #define ENETC_SIPCAPR1	0x24
> #define ENETC_SITGTGR	0x30
>@@ -176,6 +177,7 @@ enum enetc_bdr_type {TX, RX};
> #define ENETC_PCAPR0_RXBDR(val)	((val) >> 24)
> #define ENETC_PCAPR0_TXBDR(val)	(((val) >> 16) & 0xff)
> #define ENETC_PCAPR1		0x0904
>+#define ENETC_NUM_TCS_MASK	GENMASK(6, 4)
> #define ENETC_PSICFGR0(n)	(0x0940 + (n) * 0xc)  /* n = SI index */
> #define ENETC_PSICFGR0_SET_TXBDR(val)	((val) & 0xff)
> #define ENETC_PSICFGR0_SET_RXBDR(val)	(((val) & 0xff) << 16)
>@@ -223,6 +225,7 @@ enum enetc_bdr_type {TX, RX};
> #define ENETC_SET_TX_MTU(val)	((val) << 16)
> #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
> #define ENETC_PM0_IF_MODE	0x8300
>+#define ENETC_PM1_IF_MODE       0x9300
> #define ENETC_PMO_IFM_RG	BIT(2)
> #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
> #define ENETC_PM0_IFM_RGAUTO	(BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
>@@ -276,6 +279,15 @@ enum enetc_bdr_type {TX, RX};
> #define ENETC_PM0_TSCOL		0x82E0
> #define ENETC_PM0_TLCOL		0x82E8
> #define ENETC_PM0_TECOL		0x82F0
>+#define ENETC_PM1_RFRM		0x9120
>+#define ENETC_PM1_RDRP		0x9158
>+#define ENETC_PM1_RPKT		0x9160
>+#define ENETC_PM1_RFRG		0x91B8
>+#define ENETC_PM1_TFRM		0x9220
>+#define ENETC_PM1_TERR		0x9238
>+#define ENETC_PM1_TPKT		0x9260
>+#define ENETC_MAC_MERGE_MMFCRXR	0x1f14
>+#define ENETC_MAC_MERGE_MMFCTXR	0x1f18
>
> /* Port counters */
> #define ENETC_PICDR(n)		(0x0700 + (n) * 8) /* n = [0..3] */
>@@ -615,3 +627,8 @@ struct enetc_cbd {
> /* Port time gating capability register */
> #define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
> #define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
>+
>+#define ENETC_QBU_TC_MASK	GENMASK(7, 0)
>+
>+#define ENETC_PTCFPR(n)         (0x1910 + (n) * 4)
>+#define ENETC_FPE               BIT(31)
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>index e7482d483b28..f1873c4da77f 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>@@ -523,10 +523,15 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
> 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
> 		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
> 	/* set auto-speed for RGMII */
>-	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
>+	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG) {
> 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
>-	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII)
>+		enetc_port_wr(hw, ENETC_PM1_IF_MODE, ENETC_PM0_IFM_RGAUTO);
>+	}
>+
>+	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII) {
> 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
>+		enetc_port_wr(hw, ENETC_PM1_IF_MODE, ENETC_PM0_IFM_XGMII);
>+	}
> }
>
> static void enetc_configure_port_pmac(struct enetc_hw *hw)
>@@ -745,6 +750,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
> 	if (si->hw_features & ENETC_SI_F_QBV)
> 		priv->active_offloads |= ENETC_F_QBV;
>
>+	if (si->hw_features & ENETC_SI_F_QBU) {
>+		ndev->hw_features |= NETIF_F_PREEMPTION;
>+		ndev->features |= NETIF_F_PREEMPTION;
>+		priv->active_offloads |= ENETC_F_QBU;
>+	}
>+
> 	/* pick up primary MAC address from SI */
> 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
> }
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
>index 2e99438cb1bf..94dde847d052 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
>@@ -169,6 +169,10 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
> 					   priv->tx_ring[i]->index,
> 					   taprio->enable ? 0 : i);
>
>+	/* preemption off if TC priority is all 0 */
>+	if ((err && taprio->enable) || !(err || taprio->enable))
>+		enetc_preemption_set(ndev, 0);
>+
> 	return err;
> }
>
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk
