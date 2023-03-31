Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713286D1FA8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjCaMHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCaMHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:07:45 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5621CBAE;
        Fri, 31 Mar 2023 05:07:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680264408; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=nQDVC4JjA3NdAGSWM9ktQ+XCdLUDUCggLTs4jCMp4Ht+JMfO+RSLizTHJl9ezJnmqm7aBOejj0yriZ/kXmKkSfjwreSzBygGgpcq8zM6qnlcmijNIHVAVyAjevzKe9cx6leMMR+dw6UPPQZyR1pDGHr0yuSLrsKturmluEp93pU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680264408; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=1vNfJdKQwrEtYF8n/ai78HpDnCOi8yLzcURhYBAjz50=; 
        b=gPipwgEAMw0Y1x02VC6QwW9lumKA+KOOfJk/fH/zZGEJsrDH4l/PNYU5ZUhyDKy+jfvlbRPZywmCwtNhhsruBLF1hVyv1XdkhRhuLWCotvpAA7+2yjiqDwYWtJce2JdA6RDiINijMULhbMS68VMRP+AOWzlQ1yiL2yRGKZuAHKc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680264408;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=1vNfJdKQwrEtYF8n/ai78HpDnCOi8yLzcURhYBAjz50=;
        b=DlLbDYHR1gW0iqU/7/15Qf9Ux2fQ+8Ix32khUO63X5jLZ4cYZRiREpsRraWAwFH5
        McYKHSW7sLLUaB4KMRUPvUiuc4k/lQDrFaKipcXLpcUQNnO7iplW0L4U16Ci4uR2YKD
        GKfdm3rXktqhDJ6dChfUakAMOQSTrrc2FePz6d+g=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680264406519361.58419658300465; Fri, 31 Mar 2023 05:06:46 -0700 (PDT)
Message-ID: <7d0acaef-0cec-91b9-a5c6-d094b71e3dbd@arinc9.com>
Date:   Fri, 31 Mar 2023 15:06:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 14/15] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org>
 <6a7c5f81-a8a3-27b5-4af3-7175a3313f9a@arinc9.com>
 <ZCazDBJvFvjcQfKo@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZCazDBJvFvjcQfKo@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.03.2023 13:16, Daniel Golle wrote:
> On Fri, Mar 31, 2023 at 08:50:28AM +0300, Arınç ÜNAL wrote:
>> On 30.03.2023 18:23, Daniel Golle wrote:
>>> Add driver for the built-in Gigabit Ethernet switch which can be found
>>> in the MediaTek MT7988 SoC.
>>>
>>> The switch shares most of its design with MT7530 and MT7531, but has
>>> it's registers mapped into the SoCs register space rather than being
>>> connected externally or internally via MDIO.
>>>
>>> Introduce a new platform driver to support that.
>>>
>>> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>>> ---
>>>    MAINTAINERS                   |   2 +
>>>    drivers/net/dsa/Kconfig       |  12 ++++
>>>    drivers/net/dsa/Makefile      |   1 +
>>>    drivers/net/dsa/mt7530-mmio.c | 101 ++++++++++++++++++++++++++++++++++
>>>    drivers/net/dsa/mt7530.c      |  86 ++++++++++++++++++++++++++++-
>>>    drivers/net/dsa/mt7530.h      |  12 ++--
>>>    6 files changed, 206 insertions(+), 8 deletions(-)
>>>    create mode 100644 drivers/net/dsa/mt7530-mmio.c
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 14924aed15ca7..674673dbdfd8b 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -13174,9 +13174,11 @@ MEDIATEK SWITCH DRIVER
>>>    M:	Sean Wang <sean.wang@mediatek.com>
>>>    M:	Landen Chao <Landen.Chao@mediatek.com>
>>>    M:	DENG Qingfang <dqfext@gmail.com>
>>> +M:	Daniel Golle <daniel@makrotopia.org>
>>>    L:	netdev@vger.kernel.org
>>>    S:	Maintained
>>>    F:	drivers/net/dsa/mt7530-mdio.c
>>> +F:	drivers/net/dsa/mt7530-mmio.c
>>>    F:	drivers/net/dsa/mt7530.*
>>>    F:	net/dsa/tag_mtk.c
>>> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
>>> index c2551b13324c2..de4d86e37973f 100644
>>> --- a/drivers/net/dsa/Kconfig
>>> +++ b/drivers/net/dsa/Kconfig
>>> @@ -52,6 +52,18 @@ config NET_DSA_MT7530
>>>    	  Multi-chip module MT7530 in MT7621AT, MT7621DAT, MT7621ST and
>>>    	  MT7623AI SoCs is supported as well.
>>> +config NET_DSA_MT7988
>>> +	tristate "MediaTek MT7988 built-in Ethernet switch support"
>>> +	select NET_DSA_MT7530_COMMON
>>> +	depends on HAS_IOMEM
>>> +	help
>>> +	  This enables support for the built-in Ethernet switch found
>>> +	  in the MediaTek MT7988 SoC.
>>> +	  The switch is a similar design as MT7531, however, unlike
>>> +	  other MT7530 and MT7531 the switch registers are directly
>>> +	  mapped into the SoCs register space rather than being accessible
>>> +	  via MDIO.
>>> +
>>>    config NET_DSA_MV88E6060
>>>    	tristate "Marvell 88E6060 ethernet switch chip support"
>>>    	select NET_DSA_TAG_TRAILER
>>> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
>>> index 71250d7dd41af..103a33e20de4b 100644
>>> --- a/drivers/net/dsa/Makefile
>>> +++ b/drivers/net/dsa/Makefile
>>> @@ -8,6 +8,7 @@ endif
>>>    obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
>>>    obj-$(CONFIG_NET_DSA_MT7530_COMMON) += mt7530.o
>>>    obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530-mdio.o
>>> +obj-$(CONFIG_NET_DSA_MT7988)	+= mt7530-mmio.o
>>
>> I'm not fond of this way. Wouldn't it be better if we split the mdio and
>> mmio drivers to separate modules and kept switch hardware support on
>> mt7530.c?
> 
> You mean this in terms of Kconfig symbols?
> Because the way you describe is basically what I'm doing here:
>   * mt7530.c is the shared/common switch hardware driver
>   * mt7530-mdio.c contains the MDIO accessors and MDIO device drivers for
>     MT7530, MT7531, MT7621, MT7623, ...
>   * mt7530-mmio.c contains the platform device driver for in-SoC switches
>     which are accessed via MMIO, ie. MT7988 (and yes, this could be
>     extended to also support MT7620A/N).

Ok great.

> 
> In early drafts I also named the Kconfig symbols
> CONFIG_NET_DSA_MT7530 for mt7530.c (ie. the common part)
> CONFIG_NET_DSA_MT7530_MDIO for the MDIO driver
> CONFIG_NET_DSA_MT7530_MMIO for the MMIO driver
> 
> However, as existing kernel configurations expect CONFIG_NET_DSA_MT7530 to
> select the MDIO driver, I decided it would be better to hide the symbol of
> the common part and have CONFIG_NET_DSA_MT7530 select the MDIO driver like
> it was before.

You can "imply NET_DSA_MT7530_MDIO" from NET_DSA_MT7530 so the MDIO 
driver is also enabled when NET_DSA_MT7530 is selected. For example, on 
Realtek, both MDIO and SMI drivers are enabled by default when either of 
the main drivers are selected.

config NET_DSA_MT7530
	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
	select NET_DSA_TAG_MTK
	select MEDIATEK_GE_PHY
	select PCS_MTK_LYNXI
	imply NET_DSA_MT7530_MDIO
	imply NET_DSA_MT7530_MMIO

> 
> Hence I decided to go with
> CONFIG_NET_DSA_MT7530 selects the MDIO driver, just like before
> CONFIG_NET_DSA_MT7988 selects the new MMIO driver
> CONFIG_NET_DSA_MT7530_COMMON is hidden, selected by both of the above
> 
>>
>> The mmio driver could be useful in the future for the MT7530 on the MT7620
>> SoCs or generally new hardware that would use MMIO to be controlled.
>>
> 
> Sure, it would be a bit confusing once we add support for MT7620A/N (if
> that ever happens...), then CONFIG_NET_DSA_MT7988 would need to be
> selected to support this ancient MIPS SoC...
> 
> If you are planning to work on support for MT7620A/N feel free to suggest
> a better way to name the Kconfig symbols.

I don't plan to but Luiz may. Onto my suggestions.

Firstly, all of the functions on the mt7530-mmio driver should be 
changed from mt7988_* to mt7530_mmio_*. Same goes for the mt7530-mdio 
driver too as some of the functions don't start with mt7530_mdio_*. The 
MDIO and MMIO drivers are supposed to be used for the switches the 
MT7530 DSA driver supports. The mt7530_ prefix is derived from that. The 
mmio_ or mdio_ prefix is derived from, well, the driver itself.

You're calling the .name of the MMIO driver, mt7988-switch; the MDIO 
driver mt7530. That doesn't make sense. They should be mt7530-mmio and 
mt7530-mdio (or mediatek-mmio and mediatek-mdio).

What I'm going to say next depends on how generic the MMIO and MDIO 
drivers are so that they can be used on all MediaTek architecture 
switches. Let's say, a new MediaTek switch is introduced. It seems 
likely that either the MMIO or MDIO driver will be used to control the 
switch. Maybe the driver for this new switch won't be under mt7530.c, 
like on Realtek, but that doesn't change the outcome.

You know the MMIO and MDIO drivers better than I do, so if this makes 
sense to you, I'd rather call the MDIO and MMIO drivers MediaTek MDIO 
and MediaTek MMIO, and change the code accordingly. E.g. mt7988_* to 
mediatek_mmio_*, the filename from mt7530-mmio.c to mediatek-mmio.c, 
kernel config option from NET_DSA_MT7530_MMIO to NET_DSA_MEDIATEK_MMIO. 
This is currently the case with the Realtek MDIO and SMI drivers.

If not, call it MediaTek MT7530 MMIO and MediaTek MT7530 MDIO.

> 
>> Luiz did this for the Realtek switches that use MDIO and SMI to be
>> controlled.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/realtek/Kconfig
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/realtek/Makefile
> 
> Are you suggesting to split-off a device-specific driver which would
> then select the access-method driver (MDIO vs. MMIO) and the
> common/shared driver? To me this looks like overkill for MT7530, given
> that the designs of all MT7530 are pretty similar, ie. same tag format
> and also otherwise very similar.

No, and agreed. I just wanted to show the Realtek MDIO and SMI drivers' 
kconfig as an example.

> 
> 
> Thank you for reviewing!

Great work so far!

Arınç
