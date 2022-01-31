Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC45A4A4F2C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbiAaTGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:06:48 -0500
Received: from mail.i8u.org ([75.148.87.25]:51535 "EHLO chris.i8u.org"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235245AbiAaTGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 14:06:46 -0500
X-Greylist: delayed 691 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2022 14:06:46 EST
Received: by chris.i8u.org (Postfix, from userid 1000)
        id B353F16C9535; Mon, 31 Jan 2022 10:55:14 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by chris.i8u.org (Postfix) with ESMTP id AE22316C92D6;
        Mon, 31 Jan 2022 10:55:14 -0800 (PST)
Date:   Mon, 31 Jan 2022 10:55:14 -0800 (PST)
From:   Hisashi T Fujinaka <htodd@twofifty.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        David Awogbemila <awogbemila@google.com>,
        Linus Walleij <linus.walleij@linaro.org>, rafal@milecki.pl,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-sunxi@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>,
        l.stelmach@samsung.com, Shay Agroskin <shayagr@amazon.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Jon Mason <jdmason@kudzu.us>,
        Shannon Nelson <snelson@pensando.io>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Chris Snook <chris.snook@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Gabriel Somlo <gsomlo@gmail.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Shai Malin <smalin@marvell.com>,
        Maxime Ripard <mripard@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Omkar Kulkarni <okulkarni@marvell.com>,
        linux-arm-kernel@lists.infradead.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        David Arinzon <darinzon@amazon.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Catherine Sullivan <csully@google.com>,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        Noam Dagan <ndagan@amazon.com>, Rob Herring <robh@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>, Joel Stanley <joel@jms.id.au>,
        Simon Horman <simon.horman@corigine.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Slark Xiao <slark_xiao@163.com>, Gary Guo <gary@garyguo.net>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>,
        David Thompson <davthompson@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next] net: kbuild: Don't default
 net vendor configs to y
In-Reply-To: <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
Message-ID: <09c97169-5f9a-fc8f-dea5-5423e7bfef34@twofifty.com>
References: <20220131172450.4905-1-saeed@kernel.org> <20220131095905.08722670@hermes.local> <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com> <20220131183540.6ekn3z7tudy5ocdl@sx1> <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022, Florian Fainelli wrote:

> On 1/31/2022 10:35 AM, Saeed Mahameed wrote:
>> On 31 Jan 19:30, Geert Uytterhoeven wrote:
>>> On Mon, Jan 31, 2022 at 6:59 PM Stephen Hemminger
>>> <stephen@networkplumber.org> wrote:
>>>> On Mon, 31 Jan 2022 09:24:50 -0800
>>>> Saeed Mahameed <saeed@kernel.org> wrote:
>>>> 
>>>> > From: Saeed Mahameed <saeedm@nvidia.com>
>>>> >
>>>> > NET_VENDOR_XYZ were defaulted to 'y' for no technical reason.
>>>> >
>>>> > Since all drivers belonging to a vendor are supposed to default to 'n',
>>>> > defaulting all vendors to 'n' shouldn't be an issue, and aligns well
>>>> > with the 'no new drivers' by default mentality.
>>>> >
>>>> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>>> 
>>>> This was done back when vendors were introduced in the network drivers 
>>>> tree.
>>>> The default of Y allowed older configurations to just work.
>>> 
>>> And changing the defaults means all defconfigs must be updated first,
>>> else the user's configs will end up without drivers needed.
>>> 
>> 
>> As I understand correctly, at least for most common net drivers, having 
>> NET_VENDOR_XYZ=y doesn't actually build anything, we have flags per
>> module for each vendor and those are defaulted to N.
>
> Right, but once you start hiding NET_VENDOR_DRIVER_XYZ under a NET_VENDOR_XYZ 
> Kconfig symbol dependency, if NET_VENDOR_XYZ is not set to Y, then you have 
> no way to select NET_VENDOR_DRIVER_XYZ and so your old defconfig breaks.
>
>> 
>>>> So there was a reason, not sure if it matters anymore.
>>>> But it seems like useless repainting to change it now.
>>> 
>>> It might make sense to tune some of the defaults (i.e. change to
>>> "default y if ARCH_*") for drivers with clear platform dependencies.
>>> 
>> 
>> either set hard default to 'n' or just keep it as is, anything else is just
>> more confusion.
>
> Maybe the rule should go like this: any new driver vendor defaults to n, and 
> existing ones remain set to y, until we deprecate doing that and switching 
> them all off to n by 5.18?

Forgive my ignorance, but isn't it a regression if things quit working
even if it's just a configuration change?

From a user perspective I like having everything turned on initially so
it just works. Pruning things down is a lot easier than trying to figure
out what all to turn on. Especially in graphics.

-- 
Hisashi T Fujinaka - htodd@twofifty.com
