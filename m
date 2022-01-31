Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEE34A5302
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiAaXNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:13:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57272 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiAaXNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:13:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A8AB82CC6;
        Mon, 31 Jan 2022 23:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EF1C340E8;
        Mon, 31 Jan 2022 23:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643670799;
        bh=3qFSuUKUP32If9vkUAh7+Qa4t/86G61Dz7klzbTOZIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IeYmosIheVuVTUo8TbFb42UxdN1/uJoNP+EbfjiSm2MkeSo6BfXFwSuLDx5lb1De1
         KIAVWr3dMYWV+oVY6i8Xrs8OVh8/UKXM6RfUdXMrosGM0viyNH0MIQXNRkLJvVInDO
         1SmGwAvIA2AMzJLEJETvv/RUbca9pnH9yda62Wxqtbw7m8neBTLLKidDvRoBeM891Z
         7YMJk0If2vdvZegbHkI/+ajhc2tAR1s7O6Z7g9oqcXmqnuimV/1l+xB8WbPzyBcdb5
         H+VNEnflBc5Gms8USCZQW2rN4gV04YZ7iT0lGiGRw8Bkc3tMId0hqqhPIDY9lY5+Iy
         UrrAc0Zg68K4g==
Date:   Mon, 31 Jan 2022 15:13:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
References: <20220131172450.4905-1-saeed@kernel.org>
        <20220131095905.08722670@hermes.local>
        <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
        <20220131183540.6ekn3z7tudy5ocdl@sx1>
        <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
        <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 15:06:01 -0800 Florian Fainelli wrote:
> >> Right, but once you start hiding NET_VENDOR_DRIVER_XYZ under a
> >> NET_VENDOR_XYZ Kconfig symbol dependency, if NET_VENDOR_XYZ is not set
> >> to Y, then you have no way to select NET_VENDOR_DRIVER_XYZ and so your
> >> old defconfig breaks.  
> > 
> > To be clear do we actually care about *old* configs or *def* configs?  
> 
> I think we care about oldconfig but maybe less so about defconfigs which 
> are in tree and can be updated.

The oldconfigs would have to not be updated on any intervening kernel
in the last 10+ years to break, right? Or is there another way that an
oldconfig would not have the vendor config set to y at this point?
