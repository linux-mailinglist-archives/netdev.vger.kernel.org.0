Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE730FC27
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239559AbhBDTCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239502AbhBDTBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:01:32 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF5C06178C
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:13 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id a1so2212666qvd.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CosMoQ9tIc5/m79M0QFjwdsnFzFUErPjwYBk3dn+CMM=;
        b=u+CkVqrVV12cZ1chwGYhTraddNcAEOyRVY6lY4Hja9ayTgCPhQ7ZykQWXZbD6J+xSR
         gDFTS3qPZPga3pqA3abMQqiR2Dj26kE1xzr3apDexQAyWz+7bkoFloTmAxNmzHth/I2e
         mtI+ie1vFu52G3c9th9bqQfEOtnhTU2SKK64MsqEy9FTQrsr0BzVitNOhvF0VMeqexHZ
         OmZKHZdKP5fEoF950L57HGGu+2BwQ1RWHD0iUbiT0452P1Z7rNSMna/Ta3fjX1eG4F0h
         NajZWLNsTQ0z/LG0wqbUIRSdnTnC+I0GULESRAYVnEnAJO2UR4lJ/Wbuge/Ig4L2Kz3L
         veug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CosMoQ9tIc5/m79M0QFjwdsnFzFUErPjwYBk3dn+CMM=;
        b=VGd7NHnDWf2glh6Apqg65Y1kRhVxoXTSMt87jVYdXfFv2pbUw/wcwjxjNg+7VASEo/
         dCDPCMmj+JdCkHomhPUypYgdqdjJGhfmqpQWl4HPYJitXBNx5SF1PEeNe3nqrEaBzpWi
         pVVVPRE32FooPcQVZE3XNTpZIVkvgIDJMktQJRBtbPd4WI/R7603PLTMt2J3W1kwVJRa
         tqWc7Eg6jUEzaCkxk8inz2Bx4Hr4EqrqyH2MdMMLmBWWSvAfdzg5dk89v/jjUHh7naRN
         VGbSDOGqovAayZEb2sIrS/ZWe+7RunGFgv10AkrdgvKQn/YXGmSAQs+0JnINsAhCz+jc
         WNYg==
X-Gm-Message-State: AOAM532C6ZzSBjM0HN7tT5T7qT0sG53jpDxYCSKKaDDA3Ydn/9G87xrO
        FJJ33ciCVsmakUbPmDYt9UWcE+AyZzUXAcX6sAjb2w==
X-Google-Smtp-Source: ABdhPJxhcI6Dc686Xb422FLIvhEsjd3vXHH5hrkN4IpWirX0bcsqAZpQ4e/1tHxJu8EGp+7i4BcqEO3MsmgOBHy0sUk=
X-Received: by 2002:a0c:c509:: with SMTP id x9mr616635qvi.59.1612465212754;
 Thu, 04 Feb 2021 11:00:12 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com> <1612253821-1148-6-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-6-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 20:00:01 +0100
Message-ID: <CAPv3WKc4WMnwQ0K_bQhBYmRvLkDCC-CXD5gCd-PdnjzxKdhruQ@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 05/15] net: mvpp2: always compare hw-version
 vs MVPP21
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

wt., 2 lut 2021 o 09:17 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Currently we have PP2v1 and PP2v2 hw-versions, with some different
> handlers depending upon condition hw_version =3D MVPP21/MVPP22.
> In a future there will be also PP2v3. Let's use now the generic
> "if equal/notEqual MVPP21" for all cases instead of "if MVPP22".
>
> This patch does not change any functionality.
> It is not intended to introduce PP2v3.

This is a preparation patch and it should be commited before "net:
mvpp2: add PPv23 version definition"

Thanks,
Marcin


> It just modifies MVPP21/MVPP22 check-condition
> bringing it to generic and unified form correct for new-code
> introducing and PP2v3 net-next generation.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 36 ++++++++++---------=
-
>  1 file changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 11c56d2..d80947a 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -320,7 +320,7 @@ static int mvpp2_get_nrxqs(struct mvpp2 *priv)
>  {
>         unsigned int nrxqs;
>
> -       if (priv->hw_version =3D=3D MVPP22 && queue_mode =3D=3D MVPP2_QDI=
ST_SINGLE_MODE)
> +       if (priv->hw_version !=3D MVPP21 && queue_mode =3D=3D MVPP2_QDIST=
_SINGLE_MODE)
>                 return 1;
>
>         /* According to the PPv2.2 datasheet and our experiments on
> @@ -447,7 +447,7 @@ static void mvpp2_bm_bufs_get_addrs(struct device *de=
v, struct mvpp2 *priv,
>                                       MVPP2_BM_PHY_ALLOC_REG(bm_pool->id)=
);
>         *phys_addr =3D mvpp2_thread_read(priv, thread, MVPP2_BM_VIRT_ALLO=
C_REG);
>
> -       if (priv->hw_version =3D=3D MVPP22) {
> +       if (priv->hw_version !=3D MVPP21) {
>                 u32 val;
>                 u32 dma_addr_highbits, phys_addr_highbits;
>
> @@ -743,7 +743,7 @@ static inline void mvpp2_bm_pool_put(struct mvpp2_por=
t *port, int pool,
>         if (test_bit(thread, &port->priv->lock_map))
>                 spin_lock_irqsave(&port->bm_lock[thread], flags);
>
> -       if (port->priv->hw_version =3D=3D MVPP22) {
> +       if (port->priv->hw_version !=3D MVPP21) {
>                 u32 val =3D 0;
>
>                 if (sizeof(dma_addr_t) =3D=3D 8)
> @@ -1200,7 +1200,7 @@ static bool mvpp2_port_supports_xlg(struct mvpp2_po=
rt *port)
>
>  static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)
>  {
> -       return !(port->priv->hw_version =3D=3D MVPP22 && port->gop_id =3D=
=3D 0);
> +       return !(port->priv->hw_version !=3D MVPP21 && port->gop_id =3D=
=3D 0);
>  }
>
>  /* Port configuration routines */
> @@ -1818,7 +1818,7 @@ static void mvpp2_mac_reset_assert(struct mvpp2_por=
t *port)
>               MVPP2_GMAC_PORT_RESET_MASK;
>         writel(val, port->base + MVPP2_GMAC_CTRL_2_REG);
>
> -       if (port->priv->hw_version =3D=3D MVPP22 && port->gop_id =3D=3D 0=
) {
> +       if (port->priv->hw_version !=3D MVPP21 && port->gop_id =3D=3D 0) =
{
>                 val =3D readl(port->base + MVPP22_XLG_CTRL0_REG) &
>                       ~MVPP22_XLG_CTRL0_MAC_RESET_DIS;
>                 writel(val, port->base + MVPP22_XLG_CTRL0_REG);
> @@ -1831,7 +1831,7 @@ static void mvpp22_pcs_reset_assert(struct mvpp2_po=
rt *port)
>         void __iomem *mpcs, *xpcs;
>         u32 val;
>
> -       if (port->priv->hw_version !=3D MVPP22 || port->gop_id !=3D 0)
> +       if (port->priv->hw_version =3D=3D MVPP21 || port->gop_id !=3D 0)
>                 return;
>
>         mpcs =3D priv->iface_base + MVPP22_MPCS_BASE(port->gop_id);
> @@ -1852,7 +1852,7 @@ static void mvpp22_pcs_reset_deassert(struct mvpp2_=
port *port)
>         void __iomem *mpcs, *xpcs;
>         u32 val;
>
> -       if (port->priv->hw_version !=3D MVPP22 || port->gop_id !=3D 0)
> +       if (port->priv->hw_version =3D=3D MVPP21 || port->gop_id !=3D 0)
>                 return;
>
>         mpcs =3D priv->iface_base + MVPP22_MPCS_BASE(port->gop_id);
> @@ -4189,7 +4189,7 @@ static void mvpp2_start_dev(struct mvpp2_port *port=
)
>         /* Enable interrupts on all threads */
>         mvpp2_interrupts_enable(port);
>
> -       if (port->priv->hw_version =3D=3D MVPP22)
> +       if (port->priv->hw_version !=3D MVPP21)
>                 mvpp22_mode_reconfigure(port);
>
>         if (port->phylink) {
> @@ -4405,7 +4405,7 @@ static int mvpp2_open(struct net_device *dev)
>                 valid =3D true;
>         }
>
> -       if (priv->hw_version =3D=3D MVPP22 && port->port_irq) {
> +       if (priv->hw_version !=3D MVPP21 && port->port_irq) {
>                 err =3D request_irq(port->port_irq, mvpp2_port_isr, 0,
>                                   dev->name, port);
>                 if (err) {
> @@ -6053,7 +6053,7 @@ static int mvpp2__mac_prepare(struct phylink_config=
 *config, unsigned int mode,
>                              MVPP2_GMAC_PORT_RESET_MASK,
>                              MVPP2_GMAC_PORT_RESET_MASK);
>
> -               if (port->priv->hw_version =3D=3D MVPP22) {
> +               if (port->priv->hw_version !=3D MVPP21) {
>                         mvpp22_gop_mask_irq(port);
>
>                         phy_power_off(port->comphy);
> @@ -6107,7 +6107,7 @@ static int mvpp2_mac_finish(struct phylink_config *=
config, unsigned int mode,
>  {
>         struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>
> -       if (port->priv->hw_version =3D=3D MVPP22 &&
> +       if (port->priv->hw_version !=3D MVPP21 &&
>             port->phy_interface !=3D interface) {
>                 port->phy_interface =3D interface;
>
> @@ -6787,7 +6787,7 @@ static int mvpp2_init(struct platform_device *pdev,=
 struct mvpp2 *priv)
>         if (dram_target_info)
>                 mvpp2_conf_mbus_windows(dram_target_info, priv);
>
> -       if (priv->hw_version =3D=3D MVPP22)
> +       if (priv->hw_version !=3D MVPP21)
>                 mvpp2_axi_init(priv);
>
>         /* Disable HW PHY polling */
> @@ -6950,7 +6950,7 @@ static int mvpp2_probe(struct platform_device *pdev=
)
>                         dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
>         }
>
> -       if (priv->hw_version =3D=3D MVPP22 && dev_of_node(&pdev->dev)) {
> +       if (priv->hw_version !=3D MVPP21 && dev_of_node(&pdev->dev)) {
>                 priv->sysctrl_base =3D
>                         syscon_regmap_lookup_by_phandle(pdev->dev.of_node=
,
>                                                         "marvell,system-c=
ontroller");
> @@ -6963,7 +6963,7 @@ static int mvpp2_probe(struct platform_device *pdev=
)
>                         priv->sysctrl_base =3D NULL;
>         }
>
> -       if (priv->hw_version =3D=3D MVPP22 &&
> +       if (priv->hw_version !=3D MVPP21 &&
>             mvpp2_get_nrxqs(priv) * 2 <=3D MVPP2_BM_MAX_POOLS)
>                 priv->percpu_pools =3D 1;
>
> @@ -7010,7 +7010,7 @@ static int mvpp2_probe(struct platform_device *pdev=
)
>                 if (err < 0)
>                         goto err_pp_clk;
>
> -               if (priv->hw_version =3D=3D MVPP22) {
> +               if (priv->hw_version !=3D MVPP21) {
>                         priv->mg_clk =3D devm_clk_get(&pdev->dev, "mg_clk=
");
>                         if (IS_ERR(priv->mg_clk)) {
>                                 err =3D PTR_ERR(priv->mg_clk);
> @@ -7051,7 +7051,7 @@ static int mvpp2_probe(struct platform_device *pdev=
)
>                 return -EINVAL;
>         }
>
> -       if (priv->hw_version =3D=3D MVPP22) {
> +       if (priv->hw_version !=3D MVPP21) {
>                 err =3D dma_set_mask(&pdev->dev, MVPP2_DESC_DMA_MASK);
>                 if (err)
>                         goto err_axi_clk;
> @@ -7131,10 +7131,10 @@ static int mvpp2_probe(struct platform_device *pd=
ev)
>         clk_disable_unprepare(priv->axi_clk);
>
>  err_mg_core_clk:
> -       if (priv->hw_version =3D=3D MVPP22)
> +       if (priv->hw_version !=3D MVPP21)
>                 clk_disable_unprepare(priv->mg_core_clk);
>  err_mg_clk:
> -       if (priv->hw_version =3D=3D MVPP22)
> +       if (priv->hw_version !=3D MVPP21)
>                 clk_disable_unprepare(priv->mg_clk);
>  err_gop_clk:
>         clk_disable_unprepare(priv->gop_clk);
> --
> 1.9.1
>
