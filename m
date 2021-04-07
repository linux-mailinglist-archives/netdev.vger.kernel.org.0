Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE55C3560EB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 03:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347802AbhDGBpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 21:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbhDGBpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 21:45:44 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112F9C06174A;
        Tue,  6 Apr 2021 18:45:36 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id s11so11767572pfm.1;
        Tue, 06 Apr 2021 18:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w25lwMo3bZrfNfXLpALA+4I29YoJZak3FyajA6HeC94=;
        b=CIChkHRrI3lQGQaVgR3g6LW6mtE7yO24xnIbA3eBb2OBsSB2LpEOsEMe8qhA6ppB4/
         GFg8WBsRxrdBL+opf48EhryRN/JKtLSyUf8TtU4rVTRQa0D+2XsyLYjF95V4ZrkFFl1U
         5mLtoliRkEQSihgjqgixl9vUQ0ZABFHT2oc60rmHwJ60bV8gTNkz1J4AlAZwO+5B+DuQ
         +5lul+5kAwz6HwmSJjNChHm4+EocR2sBxC3baPIbPs036zqFQh7Ew01atfiMB7d3C/Ow
         PUNTNMFbHGoK1bfa8ixotxlbsKJ3STRzqpF8jldPfQ8ke/3eiY6H4rtWu1h0K8XYB2Vv
         rgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w25lwMo3bZrfNfXLpALA+4I29YoJZak3FyajA6HeC94=;
        b=ZU0MW/s3N/7mB5Ayf5VDrKVTUrik4K9iobD9tc/ZWORPPvbn/zH+/D4i+SJVqSFM4a
         dwN/VELsTEWH8S99XU9n9Yj2VFouj19HAsdMa0SPpkZvtDNCoaSR4tXxIag3RLCEXhXQ
         AL6QraKB6px6+xtll74L2QnJyf0DhnOvpVXUanllljPyhQmqFahJosEnamEa5w24Pyn7
         P5emqEaCFH/IlrMxpkVQg8jK0RcfanJcBmldzB/h//HyFZ287Spbewo5ljK/FeBp4rwu
         dTuUKgPAj6D6xFMe1FEzgXC+V6aeJ33tj7/34h9YEYhqSgd766l4OLL9g2nhFQB5zG75
         WgnQ==
X-Gm-Message-State: AOAM53078O9EpPUub+LZpigFibuCj7s8bqxtFeANemtsfgOj+cUJk9DF
        TUSVnc1h//NUruXFJ+T/o1g=
X-Google-Smtp-Source: ABdhPJyjkdVdAMZsiQs6PYIHXwhXVO+uLzcp0Xe8vbkVPgJP52Fozx3Xafo1rzDkv0TO669OyIEiUA==
X-Received: by 2002:a63:fb12:: with SMTP id o18mr948658pgh.438.1617759935548;
        Tue, 06 Apr 2021 18:45:35 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o13sm20193959pgv.40.2021.04.06.18.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 18:45:34 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/2] of: net: fix of_get_mac_addr_nvmem() for
 PCI and DSA nodes
To:     Michael Walle <michael@walle.cc>, ath9k-devel@qca.qualcomm.com,
        UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org, linux-oxnas@groups.io,
        linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-staging@lists.linux.dev
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        bcm-kernel-feedback-list@broadcom.com,
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
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210406220921.24313-1-michael@walle.cc>
 <20210406220921.24313-3-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <70b649a4-4b1f-3e95-a6b9-23a00bbaf122@gmail.com>
Date:   Tue, 6 Apr 2021 18:45:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210406220921.24313-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2021 3:09 PM, Michael Walle wrote:
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

Nit: if you need to resubmit you could rephrase the subject such that
the limitation of of_get_mac_addr_nvmem() is lifted to include all kinds
of devices, and no longer just platform_device instances as before.
-- 
Florian
