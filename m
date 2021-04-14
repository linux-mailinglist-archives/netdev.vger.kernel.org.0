Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0935F1DB
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbhDNLEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhDNLEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:04:00 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B79BC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 04:03:38 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c6so15082437qtc.1
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 04:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xPJH+8ni3Tbc++EN9THBhmv1spCFHq5kSPS5Enne5o4=;
        b=oyvHyjL0ynuWGMffMOxS7jwBxxw+p16S+n4aXl/Avsuttlkke2KdqiR6sBY+zgG0v5
         pFUkm/9l7PP573h4yofSotwM/Gk1LO22msby+NoLcrElg2ubu8wchdDdDp8ibn5/9qeX
         BaF3bmvAl2ccE+T8OD6eUzBwbCnEQ7gn2Ung4ouUW8Hx9c9uVu9Mnj+DedkShE6jJYl0
         wfPb/gkbMy8aJqnN/HLt++fnDn69fOv8RZw/AJdrevqwPxEnMZyqUB5Bw9c2PiDJJL0i
         IWLZKDnHV4VI2ueUI4m5CZ79I54QHwwxQaLs9qsvMh8niyBW7GdtH4XQj4azRikMlu0s
         TeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xPJH+8ni3Tbc++EN9THBhmv1spCFHq5kSPS5Enne5o4=;
        b=Hz2Nawl6LhP+XwEQqiKqMmogOpU9c9z4mdoxx63tO5FtkHXZoBv8Si9gI9VueGoJA8
         JH2VgZFBBFVGyDRYfS/LRIBcqym2o6A/VNugdmmLDFU8t/GZCec0HQ4gLmJP7n92octr
         /waqfeTu83cPXTakoujKewk9aF1YTVJsf4SfaFSTV601tAgyOllBTlhimFTxk5lJ9yiI
         ayDVZG3HoSclHWZk/7tpkd1xmptbVj3EyNc2D0cneE1ljaDLF4XG8LGytCXAHe54HfWF
         43/dHrqkNbfDkYs2LuwheHlmUW1noBGJeiVZU/kuUiuQyc6EhPStZO5vaIfZe71+dPWJ
         z5Lw==
X-Gm-Message-State: AOAM532iktWCYMPws/gZoQDDASyHD+JNFMLPfs/x1Q/tA9InzgtvV2Uy
        ObzYZEGxdYLLSqDMszR9Djq7MF6n0wVJT7iUgN8=
X-Google-Smtp-Source: ABdhPJwkW9MfcHyOxelix6kKQaVDPyQHLuzmYo1PN+fEIWkXgSZaLagmCzJ+fOTlvIH6DSloOGtT18tE9CC3B6XVZ0Y=
X-Received: by 2002:a05:622a:216:: with SMTP id b22mr34997747qtx.263.1618398216995;
 Wed, 14 Apr 2021 04:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdYzYpv0dvz4X2JE4J6Qg-5D9mnkqe5RpiRC845wQpZhDKDPA@mail.gmail.com>
 <1412-60762b80-423-d9eaa5@27901112>
In-Reply-To: <1412-60762b80-423-d9eaa5@27901112>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Wed, 14 Apr 2021 07:03:25 -0400
Message-ID: <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 7:37 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> On Tuesday, April 13, 2021 19:51 -03, Peter Geis <pgwipeout@gmail.com> wrote:
>
> > On Tue, Apr 13, 2021 at 5:03 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > >
> > > From: David Wu <david.wu@rock-chips.com>
> > >
> > > Add constants and callback functions for the dwmac present
> > > on RK3566 and RK3568 SoCs. As can be seen, the base structure
> > > is the same, only registers and the bits in them moved slightly.
> > >
> > > RK3568 supports two MACs, and RK3566 support just one.
> >
> > Tested this driver on the rk3566-quartz64.
> > It fails to fully probe the gmac with the following error:
> > [    5.711127] rk_gmac-dwmac fe010000.ethernet: IRQ eth_lpi not found
> > [    5.714147] rk_gmac-dwmac fe010000.ethernet: no regulator found
> > [    5.714766] rk_gmac-dwmac fe010000.ethernet: clock input or output? (input).
> > [    5.715474] rk_gmac-dwmac fe010000.ethernet: TX delay(0x4f).
> > [    5.716058] rk_gmac-dwmac fe010000.ethernet: RX delay(0x25).
> > [    5.716694] rk_gmac-dwmac fe010000.ethernet: integrated PHY? (no).
> > [    5.718413] rk_gmac-dwmac fe010000.ethernet: clock input from PHY
> > [    5.724140] rk_gmac-dwmac fe010000.ethernet: init for RGMII
> > [    5.726802] rk_gmac-dwmac fe010000.ethernet: Version ID not available
> > [    5.727525] rk_gmac-dwmac fe010000.ethernet:         DWMAC1000
> > [    5.728064] rk_gmac-dwmac fe010000.ethernet: DMA HW capability
> > register supported
> > [    5.729026] rk_gmac-dwmac fe010000.ethernet: Normal descriptors
> > [    5.729624] rk_gmac-dwmac fe010000.ethernet: Ring mode enabled
> > [    5.731123] rk_gmac-dwmac fe010000.ethernet: Unbalanced pm_runtime_enable!
> > [    5.873329] libphy: stmmac: probed
> > [    5.905599] rk_gmac-dwmac fe010000.ethernet: Cannot register the MDIO bus
> > [    5.906335] rk_gmac-dwmac fe010000.ethernet: stmmac_dvr_probe: MDIO
> > bus (id: 1) registration failed
> > [    5.914338] rk_gmac-dwmac: probe of fe010000.ethernet failed with error -5
> >
> > This is due to the lack of setting has_gmac4 = true.
> >
>
> You are probably missing a "snps,dwmac-4.20a" in your compatible string, i.e.:
>   compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";

Ah yes, I had disabled that because my variant took a different path.
Thanks!

>
> This seems to be common practice, judging from arch/arm/boot/dts/stm32***.
>
> Let me know how that goes!
> Ezequiel
>
> > >
> > > Signed-off-by: David Wu <david.wu@rock-chips.com>
> > > [Ezequiel: Add rockchip,rk3566-gmac compatible string]
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >  .../bindings/net/rockchip-dwmac.txt           |   2 +
> > >  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 142 ++++++++++++++++++
> > >  2 files changed, 144 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> > > index 3b71da7e8742..80203b16b652 100644
> > > --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> > > +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> > > @@ -12,6 +12,8 @@ Required properties:
> > >     "rockchip,rk3366-gmac": found on RK3366 SoCs
> > >     "rockchip,rk3368-gmac": found on RK3368 SoCs
> > >     "rockchip,rk3399-gmac": found on RK3399 SoCs
> > > +   "rockchip,rk3566-gmac": found on RK3566 SoCs
> > > +   "rockchip,rk3568-gmac": found on RK3568 SoCs
> > >     "rockchip,rv1108-gmac": found on RV1108 SoCs
> > >   - reg: addresses and length of the register sets for the device.
> > >   - interrupts: Should contain the GMAC interrupts.
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > > index d2637d83899e..096965b0fec9 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> > > @@ -948,6 +948,146 @@ static const struct rk_gmac_ops rk3399_ops = {
> > >         .set_rmii_speed = rk3399_set_rmii_speed,
> > >  };
> > >
> > > +#define RK3568_GRF_GMAC0_CON0          0x0380
> > > +#define RK3568_GRF_GMAC0_CON1          0x0384
> > > +#define RK3568_GRF_GMAC1_CON0          0x0388
> > > +#define RK3568_GRF_GMAC1_CON1          0x038c
> > > +
> > > +/* RK3568_GRF_GMAC0_CON1 && RK3568_GRF_GMAC1_CON1 */
> > > +#define RK3568_GMAC_PHY_INTF_SEL_RGMII \
> > > +               (GRF_BIT(4) | GRF_CLR_BIT(5) | GRF_CLR_BIT(6))
> > > +#define RK3568_GMAC_PHY_INTF_SEL_RMII  \
> > > +               (GRF_CLR_BIT(4) | GRF_CLR_BIT(5) | GRF_BIT(6))
> > > +#define RK3568_GMAC_FLOW_CTRL                  GRF_BIT(3)
> > > +#define RK3568_GMAC_FLOW_CTRL_CLR              GRF_CLR_BIT(3)
> > > +#define RK3568_GMAC_RXCLK_DLY_ENABLE           GRF_BIT(1)
> > > +#define RK3568_GMAC_RXCLK_DLY_DISABLE          GRF_CLR_BIT(1)
> > > +#define RK3568_GMAC_TXCLK_DLY_ENABLE           GRF_BIT(0)
> > > +#define RK3568_GMAC_TXCLK_DLY_DISABLE          GRF_CLR_BIT(0)
> > > +
> > > +/* RK3568_GRF_GMAC0_CON0 && RK3568_GRF_GMAC1_CON0 */
> > > +#define RK3568_GMAC_CLK_RX_DL_CFG(val) HIWORD_UPDATE(val, 0x7F, 8)
> > > +#define RK3568_GMAC_CLK_TX_DL_CFG(val) HIWORD_UPDATE(val, 0x7F, 0)
> > > +
> > > +static void rk3566_set_to_rgmii(struct rk_priv_data *bsp_priv,
> > > +                               int tx_delay, int rx_delay)
> > > +{
> > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > +
> > > +       if (IS_ERR(bsp_priv->grf)) {
> > > +               dev_err(dev, "Missing rockchip,grf property\n");
> > > +               return;
> > > +       }
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > +}
> > > +
> > > +static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
> > > +{
> > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > +
> > > +       if (IS_ERR(bsp_priv->grf)) {
> > > +               dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
> > > +               return;
> > > +       }
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> > > +}
> > > +
> > > +static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
> > > +                               int tx_delay, int rx_delay)
> > > +{
> > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > +
> > > +       if (IS_ERR(bsp_priv->grf)) {
> > > +               dev_err(dev, "Missing rockchip,grf property\n");
> > > +               return;
> > > +       }
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
> > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON0,
> > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> >
> > Since there are two GMACs on the rk3568, and either, or, or both may
> > be enabled in various configurations, we should only configure the
> > controller we are currently operating.

Perhaps we should have match data (such as reg = <0>, or against the
address) to identify the individual controllers.

> >
> > > +}
> > > +
> > > +static void rk3568_set_to_rmii(struct rk_priv_data *bsp_priv)
> > > +{
> > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > +
> > > +       if (IS_ERR(bsp_priv->grf)) {
> > > +               dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
> > > +               return;
> > > +       }
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
> > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> > > +
> > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> >
> > Same as above.
> >
> > > +}
> > > +
> > > +static void rk3568_set_gmac_speed(struct rk_priv_data *bsp_priv, int speed)
> > > +{
> > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > +       unsigned long rate;
> > > +       int ret;
> > > +
> > > +       switch (speed) {
> > > +       case 10:
> > > +               rate = 2500000;
> > > +               break;
> > > +       case 100:
> > > +               rate = 25000000;
> > > +               break;
> > > +       case 1000:
> > > +               rate = 125000000;
> > > +               break;
> > > +       default:
> > > +               dev_err(dev, "unknown speed value for GMAC speed=%d", speed);
> > > +               return;
> > > +       }
> > > +
> > > +       ret = clk_set_rate(bsp_priv->clk_mac_speed, rate);
> > > +       if (ret)
> > > +               dev_err(dev, "%s: set clk_mac_speed rate %ld failed %d\n",
> > > +                       __func__, rate, ret);
> > > +}
> > > +
> > > +static const struct rk_gmac_ops rk3568_ops = {
> > > +       .set_to_rgmii = rk3568_set_to_rgmii,
> > > +       .set_to_rmii = rk3568_set_to_rmii,
> > > +       .set_rgmii_speed = rk3568_set_gmac_speed,
> > > +       .set_rmii_speed = rk3568_set_gmac_speed,
> > > +};
> > > +
> > > +static const struct rk_gmac_ops rk3566_ops = {
> > > +       .set_to_rgmii = rk3566_set_to_rgmii,
> > > +       .set_to_rmii = rk3566_set_to_rmii,
> > > +       .set_rgmii_speed = rk3568_set_gmac_speed,
> > > +       .set_rmii_speed = rk3568_set_gmac_speed,
> > > +};
> > > +
> > >  #define RV1108_GRF_GMAC_CON0           0X0900
> > >
> > >  /* RV1108_GRF_GMAC_CON0 */
> > > @@ -1512,6 +1652,8 @@ static const struct of_device_id rk_gmac_dwmac_match[] = {
> > >         { .compatible = "rockchip,rk3366-gmac", .data = &rk3366_ops },
> > >         { .compatible = "rockchip,rk3368-gmac", .data = &rk3368_ops },
> > >         { .compatible = "rockchip,rk3399-gmac", .data = &rk3399_ops },
> > > +       { .compatible = "rockchip,rk3568-gmac", .data = &rk3568_ops },
> > > +       { .compatible = "rockchip,rk3566-gmac", .data = &rk3566_ops },
> > >         { .compatible = "rockchip,rv1108-gmac", .data = &rv1108_ops },
> > >         { }
> > >  };
> > > --
> > > 2.30.0
> > >
>
