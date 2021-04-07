Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1889356099
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 03:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245607AbhDGBNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 21:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhDGBNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 21:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BD5613C4;
        Wed,  7 Apr 2021 01:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617758008;
        bh=4wmgtd3m+Ta1X4jkV88q8R8S6J8R9xiITuF0Yr6xVvE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pRLlQVTSNNqQq6FWgIz2B7IVJb0WD4DcmH/q1OoNuEMrYaWQrNUQZE+TGHQqvO7uZ
         0sbEWPuyB8HyaAmOyOmuJUzxCmp1p115y8GLeeHMULg8c7AuvfXjx5Z564IDbK8lJq
         gmbN4+vm5P6n1CiJ0TfpP9EWDKvzUd31Ix6pvdON87LVzboxcqirc6EFlZYA+M4j8G
         jHfCtKJ3iJFDoh1b09Poyvm8SAkLWUaz66KIw278EYEG9sTTsgo5EgmZQ4PmQnu3Wd
         /7t4s6bK6dnu7hbZeox3JOJGIH6WZmQ5XIo2AS7KlPr83ACsPhjvDPLHQqqdmOaGvc
         LBaAPBKO1awEA==
Received: by mail-ej1-f52.google.com with SMTP id n2so18613159ejy.7;
        Tue, 06 Apr 2021 18:13:28 -0700 (PDT)
X-Gm-Message-State: AOAM533YnDaot013beTdGHT2EJJKb9olBZ/IgK/ViKzJymm5cml8JSmO
        J/yoS2/ORwvBWB7zWBhZRT8+yg7Pu5adv2GpWA==
X-Google-Smtp-Source: ABdhPJzl6RD27BOpLC9b+ksVgecIqSPzz04cn67QiZn3u6NF8pL8OvwlE6sLhJddWpFdEonXi5GuOvvWMqx7AYRmDLw=
X-Received: by 2002:a17:906:1984:: with SMTP id g4mr847605ejd.525.1617758006930;
 Tue, 06 Apr 2021 18:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210405164643.21130-1-michael@walle.cc> <20210405164643.21130-3-michael@walle.cc>
In-Reply-To: <20210405164643.21130-3-michael@walle.cc>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 6 Apr 2021 20:13:15 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKbxY5sCJ_8F7iF0hFr52cwRsSc2bu48H7cqcNeWytDpA@mail.gmail.com>
Message-ID: <CAL_JsqKbxY5sCJ_8F7iF0hFr52cwRsSc2bu48H7cqcNeWytDpA@mail.gmail.com>
Subject: Re: [PATCH 2/2] of: net: fix of_get_mac_addr_nvmem() for PCI and DSA nodes
To:     Michael Walle <michael@walle.cc>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        linux-oxnas@groups.io, linux-omap <linux-omap@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-staging@lists.linux.dev,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Larsson <andreas@gaisler.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Chris Snook <chris.snook@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "maintainer:BROADCOM BCM7XXX ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Byungho An <bh74.an@samsung.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 5, 2021 at 11:47 AM Michael Walle <michael@walle.cc> wrote:
>
> of_get_mac_address() already supports fetching the MAC address by an
> nvmem provider. But until now, it was just working for platform devices.
> Esp. it was not working for DSA ports and PCI devices. It gets more
> common that PCI devices have a device tree binding since SoCs contain
> integrated root complexes.
>
> Use the nvmem of_* binding to fetch the nvmem cells by a struct
> device_node. We still have to try to read the cell by device first
> because there might be a nvmem_cell_lookup associated with that device.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> Please note, that I've kept the nvmem_get_mac_address() which operates
> on a device. The new of_get_mac_addr_nvmem() is almost identical and
> there are no users of the former function right now, but it seems to be
> the "newer" version to get the MAC address for a "struct device". Thus
> I've kept it. Please advise, if I should kill it though.

It seems kind of backwards from how we normally design this type of
API where the API with a struct device will call a firmware specific
version if there's a firmware handle. But certainly, I don't think we
should be operating on platform device if we can help it.

>  drivers/of/of_net.c | 37 +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> index 2344ad7fff5e..2323c6063eaf 100644
> --- a/drivers/of/of_net.c
> +++ b/drivers/of/of_net.c
> @@ -11,6 +11,7 @@
>  #include <linux/phy.h>
>  #include <linux/export.h>
>  #include <linux/device.h>
> +#include <linux/nvmem-consumer.h>
>
>  /**
>   * of_get_phy_mode - Get phy mode for given device_node
> @@ -56,18 +57,42 @@ static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
>         return -ENODEV;
>  }
>
> -static int of_get_mac_addr_nvmem(struct device_node *np, u8 addr)
> +static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
>  {
>         struct platform_device *pdev = of_find_device_by_node(np);
> +       struct nvmem_cell *cell;
> +       const void *mac;
> +       size_t len;
>         int ret;
>
> -       if (!pdev)
> -               return -ENODEV;
> +       /* Try lookup by device first, there might be a nvmem_cell_lookup
> +        * associated with a given device.
> +        */
> +       if (pdev) {
> +               ret = nvmem_get_mac_address(&pdev->dev, addr);
> +               put_device(&pdev->dev);
> +               return ret;
> +       }
> +
> +       cell = of_nvmem_cell_get(np, "mac-address");
> +       if (IS_ERR(cell))
> +               return PTR_ERR(cell);
> +
> +       mac = nvmem_cell_read(cell, &len);
> +       nvmem_cell_put(cell);
> +
> +       if (IS_ERR(mac))
> +               return PTR_ERR(mac);
> +
> +       if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
> +               kfree(mac);
> +               return -EINVAL;
> +       }
>
> -       ret = nvmem_get_mac_address(&pdev->dev, addr);
> -       put_device(&pdev->dev);
> +       ether_addr_copy(addr, mac);
> +       kfree(mac);
>
> -       return ret;
> +       return 0;
>  }
>
>  /**
> --
> 2.20.1
>
