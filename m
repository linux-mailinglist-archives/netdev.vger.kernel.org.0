Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A494851F4CB
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiEIGzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiEIGtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:49:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13B12AEA
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 23:45:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e5so11234012pgc.5
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 23:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kAjy3pf0qb7+heiXBH3y8E/LCTh3nUX0uQCIGPiEK0U=;
        b=dzHkrdsIhzLpIa7/4ofU4ZZaUqWXsfU1CgtvL1BwleuQ1ngIkC246ZoH1eon1i5hGK
         sRaymUOxKIglW3j2ogwq+N+8+15I72qLtq0azB0wy6UsPRMTLQf8h34YYb3C+9CYZo6+
         9nqgAAleFIMKW5sHDPzdkBRiUqqtgxCToVZSOsym5ZgaIdewoVP+Tzi1Q6FsOjrIIjyk
         2snyGvD9dhW+AHajSbMXd3rpHtVzRI7Xv6Wuf34Rq2mAQgTCl7wQh/qoBM6kOJl/kXyk
         FFB1mneAXJ/HtJTLOxHpvIGIFZv20UVTLbl1ysAHtrSZZ6GmawuC1x4IG9QZsBXBciwW
         MO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kAjy3pf0qb7+heiXBH3y8E/LCTh3nUX0uQCIGPiEK0U=;
        b=sRVuzFK/7XHTkZFZCVqEYkGapEsedMtWbhIdaNcKHaNOkLCbHrajOfJ95rEnnPLf92
         8/53m6of+cLg2LrF0dRwZ8tXjvU1rsX/u1vDAXf+dgbTzowTNgYg6GK6EzVScHULfM5C
         Ps+7Rh8LnyaV5O0j8F+Kiu5zuyFhajtRcqgwylnZ72PqLZJMZJtogeJU9ZDvuBsJok/s
         cR9hBn7mj00DWHCcmso8gtglX1kzpQznIEX9tAV+mjlT6OUbbHoN6JpK6+bqq1XO3R4d
         +ffSs1eo7/H6xa5SPVZbcDdNxftRxokc1HPdYx25sva0oXcItX3cMykBAgFm+hhUvhcG
         447Q==
X-Gm-Message-State: AOAM532JHN0Cps0wTj3oou7dXonx6kCofsk4/ZvadTB+AaFjOnukGwWy
        c2UyseSNFCSJsyG8HbhQfwWtusZn/P/hGiv8HkM=
X-Google-Smtp-Source: ABdhPJx/bcn+wATA+boDpNhrwQzthmpQELMbQhVxJdIf5ny+RGwtZN/TkOq9t8B+iyOG8nazCf377cp1O6wVOFZqHbM=
X-Received: by 2002:aa7:88ce:0:b0:510:72bd:5a61 with SMTP id
 k14-20020aa788ce000000b0051072bd5a61mr14850757pff.21.1652078722319; Sun, 08
 May 2022 23:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220508224848.2384723-1-hauke@hauke-m.de> <20220508224848.2384723-4-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-4-hauke@hauke-m.de>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 9 May 2022 03:45:11 -0300
Message-ID: <CAJq09z75yzP-V=bwnK6QNGQW+eoj-pnx2q0CB-03VYH65dKhgA@mail.gmail.com>
Subject: Re: [PATCH 3/4] net: dsa: realtek: rtl8365mb: Add setting MTU
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The switch does not support per port MTU setting, but only a MRU
> setting. Implement this by setting the MTU on the CPU port.
>
> Without this patch the MRU was always set to 1536, not it is set by the
> DSA subsystem and the user scan change it.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 43 ++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index be64cfdeccc7..f9b690251155 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -1132,6 +1132,38 @@ static int rtl8365mb_port_set_isolation(struct realtek_priv *priv, int port,
>         return regmap_write(priv->map, RTL8365MB_PORT_ISOLATION_REG(port), mask);
>  }
>
> +static int rtl8365mb_port_change_mtu(struct dsa_switch *ds, int port,
> +                                    int new_mtu)
> +{
> +       struct dsa_port *dp = dsa_to_port(ds, port);
> +       struct realtek_priv *priv = ds->priv;
> +       int length;
> +
> +       /* When a new MTU is set, DSA always set the CPU port's MTU to the
> +        * largest MTU of the slave ports. Because the switch only has a global
> +        * RX length register, only allowing CPU port here is enough.
> +        */
> +       if (!dsa_is_cpu_port(ds, port))
> +               return 0;
> +
> +       length = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> +       length += dp->tag_ops->needed_headroom;
> +       length += dp->tag_ops->needed_tailroom;

Isn't it better to keep that within the driver? No matter the tag
position, it will be either 4 (RTL8365MB_CPU_FORMAT_4BYTES) or 8
(RTL8365MB_CPU_FORMAT_8BYTES) bytes. You can retrieve that from
priv->chip_data->cpu->format, but the driver will probably never
support RTL8365MB_CPU_FORMAT_4BYTES. Until someone does implement the
4-bytes tag (for some mysterious reason), I believe we could simply
use a constant here (using a proper new macro).

> +
> +       if (length > RTL8365MB_CFG0_MAX_LEN_MASK)
> +               return -EINVAL;
> +
> +       return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> +                                 RTL8365MB_CFG0_MAX_LEN_MASK,
> +                                 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK,
> +                                            length));
> +}
> +
> +static int rtl8365mb_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +       return RTL8365MB_CFG0_MAX_LEN_MASK - ETH_HLEN - ETH_FCS_LEN - 8;

What is this magic 8? RTL8_4_TAG_LEN?

> +}
> +
>  static int rtl8365mb_mib_counter_read(struct realtek_priv *priv, int port,
>                                       u32 offset, u32 length, u64 *mibvalue)
>  {
> @@ -1928,13 +1960,6 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>                 p->index = i;
>         }
>
> -       /* Set maximum packet length to 1536 bytes */
> -       ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> -                                RTL8365MB_CFG0_MAX_LEN_MASK,
> -                                FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
> -       if (ret)
> -               goto out_teardown_irq;
> -
>         if (priv->setup_interface) {
>                 ret = priv->setup_interface(ds);
>                 if (ret) {
> @@ -2080,6 +2105,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
>         .phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
>         .phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
>         .port_stp_state_set = rtl8365mb_port_stp_state_set,
> +       .port_change_mtu = rtl8365mb_port_change_mtu,
> +       .port_max_mtu = rtl8365mb_port_max_mtu,
>         .get_strings = rtl8365mb_get_strings,
>         .get_ethtool_stats = rtl8365mb_get_ethtool_stats,
>         .get_sset_count = rtl8365mb_get_sset_count,
> @@ -2101,6 +2128,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
>         .phy_read = rtl8365mb_dsa_phy_read,
>         .phy_write = rtl8365mb_dsa_phy_write,
>         .port_stp_state_set = rtl8365mb_port_stp_state_set,
> +       .port_change_mtu = rtl8365mb_port_change_mtu,
> +       .port_max_mtu = rtl8365mb_port_max_mtu,
>         .get_strings = rtl8365mb_get_strings,
>         .get_ethtool_stats = rtl8365mb_get_ethtool_stats,
>         .get_sset_count = rtl8365mb_get_sset_count,
> --
> 2.30.2
>
