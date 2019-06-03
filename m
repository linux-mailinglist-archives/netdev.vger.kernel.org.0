Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982EF33A4E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfFCVxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:53:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFCVxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:53:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EF52133E97B7;
        Mon,  3 Jun 2019 14:53:20 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:53:19 -0700 (PDT)
Message-Id: <20190603.145319.259092628945656490.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.torgue@st.com, biao.huang@mediatek.com,
        boon.leong.ong@intel.com, hock.leong.kweh@intel.com
Subject: Re: [PATCH net-next v5 2/5] net: stmmac: introducing support for
 DWC xPCS logics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559332694-6354-3-git-send-email-weifeng.voon@intel.com>
References: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
        <1559332694-6354-3-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:53:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Sat,  1 Jun 2019 03:58:11 +0800

> +static void dw_xpcs_init(struct net_device *ndev, int pcs_mode)
> +{
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	int xpcs_phy_addr = priv->plat->xpcs_phy_addr;
> +	int phydata;

Reverse christmas tree please.  Put the assignments onto separate
lines if necessary.

> +static void dw_xpcs_ctrl_ane(struct net_device *ndev, bool ane,
> +			     bool loopback)
> +{
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	int xpcs_phy_addr = priv->plat->xpcs_phy_addr;
> +
> +	int phydata = xpcs_read(XPCS_MDIO_MII_MMD, MII_BMCR);

Please don't break up the local variable declarations like this, and
also reverse christmas tree.

> +static void dw_xpcs_get_adv_lp(struct net_device *ndev,
> +			       struct rgmii_adv *adv_lp,
> +			       int pcs_mode)
> +{
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	int xpcs_phy_addr = priv->plat->xpcs_phy_addr;
> +
> +	/* AN Advertisement Ability */
> +	int value = xpcs_read(XPCS_MDIO_MII_MMD, MII_ADVERTISE);

Likewise.

> +static int dw_xpcs_irq_status(struct net_device *ndev,
> +			      struct stmmac_extra_stats *x,
> +			      int pcs_mode)
> +{
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	int xpcs_phy_addr = priv->plat->xpcs_phy_addr;
> +	int ret = IRQ_NONE;
> +
> +	/* AN status */
> +	int an_stat = xpcs_read(XPCS_MDIO_MII_MMD, MDIO_MII_MMD_AN_STAT);

Likewise.
