Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D336BC75
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 02:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhD0AFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 20:05:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:52976 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhD0AFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 20:05:34 -0400
Received: from ip6-localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 13QNi8nL025548;
        Mon, 26 Apr 2021 18:44:08 -0500
Message-ID: <3677398ebb77f334abb4899770db633d9658fe82.camel@kernel.crashing.org>
Subject: Re: [PATCH net-next v4 2/2] of: net: fix of_get_mac_addr_nvmem()
 for non-platform devices
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Michael Walle <michael@walle.cc>, Rob Herring <robh+dt@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
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
        Paul Mackerras <paulus@samba.org>,
        Andreas Larsson <andreas@gaisler.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Chris Snook <chris.snook@gmail.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
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
        =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 27 Apr 2021 09:44:07 +1000
In-Reply-To: <108f268a35843368466004f7fe5f9f88@walle.cc>
References: <20210412174718.17382-1-michael@walle.cc>
         <20210412174718.17382-3-michael@walle.cc>
         <730d603b12e590c56770309b4df2bd668f7afbe3.camel@kernel.crashing.org>
         <8157eba9317609294da80472622deb28@walle.cc>
         <CAL_JsqLrx6nFZrKiEtm2a1vDvQGG+FkpGtJCG2osM8hhGo3P=Q@mail.gmail.com>
         <108f268a35843368466004f7fe5f9f88@walle.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-26 at 12:54 +0200, Michael Walle wrote:
> Before I'll try to come up with a patch for this, I'd like to get
> your opinion on it.
> 
> (1) replacing of_get_mac_address(node) with eth_get_mac_address(dev)
>      might sometimes lead to confusing comments like in
>      drivers/net/ethernet/allwinner/sun4i-emac.c:
> 
>      /* Read MAC-address from DT */
>      ret = of_get_mac_address(np, ndev->dev_addr);

You could leave it or turn it into "from platform", doesn't matter...

> (2) What do you think of eth_get_mac_address(ndev). That is, the

Not sure what you mean, eth_platform_get_mac_address() takes the
address as an argument. I think what you want is a consolidated
nvmem_get_mac_address + eth_platform_get_mac_address that takes a
device, which would have no requirement of the bus_type at all.

Cheers,
Ben.

