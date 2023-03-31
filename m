Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D226D291E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 22:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjCaUJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 16:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCaUI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 16:08:59 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6880A21A81;
        Fri, 31 Mar 2023 13:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680293280; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VYIqs3CCiPpYDFh/h4Eps0HPs2Z35OTZuosQRHHupQBZgUFFCKHyidMzngbjIYjG+abq0YLEU3O9LI7y+R4ZHl2pJuQ5HEJMjLiCTkxZ8MJSC46+y6rSVWRELqSJT8MaRWLkF7Dkg2LILQZ3jNjJCEUkl42SfgOfbhO9VWCAO7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680293280; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=adlBIyha/e7/m9rUhGH8gGOH3BBWP5KjDgLVUiU1vf0=; 
        b=ILzJlo9akLEVvqyExxh2LFt1wi19r4ldW5dijs2CMspgBx9ZuwKtp0ZCRweQfxX6HkKUCf3rLnXpGodyMnByOzZ2B2qnh0mJpPcpcBnSSHqZbWAulMXZeDtrBi9CDzCSK6GolIOGSGERGerEH3qLnlbbYLgQzMk/TcSg21EFJi4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680293280;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=adlBIyha/e7/m9rUhGH8gGOH3BBWP5KjDgLVUiU1vf0=;
        b=SE6C4KjE1/EKPrCeBf2O37b3LyvbiBckyv64k4WnkU75QuemF62Yj/wU5KiL6QlC
        ycQesbq9gaGFMfSRWybzVFeQm4EcT/qzQTdCjxuceOxxA7mR+JH639td6ko/xqSoC0J
        LOvigc05NRuSgXqNIHivZx8rw3aOQaQfCLbqGs4A=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680293279357652.4368473040126; Fri, 31 Mar 2023 13:07:59 -0700 (PDT)
Message-ID: <56adf82a-3db0-5909-e948-e21717e3fe03@arinc9.com>
Date:   Fri, 31 Mar 2023 23:07:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 14/15] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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
 <7d0acaef-0cec-91b9-a5c6-d094b71e3dbd@arinc9.com>
 <28d048c9-6389-749b-d0eb-18a9c2d83c4e@arinc9.com>
Content-Language: en-US
In-Reply-To: <28d048c9-6389-749b-d0eb-18a9c2d83c4e@arinc9.com>
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

On 31.03.2023 16:18, Arınç ÜNAL wrote:
> On 31.03.2023 15:06, Arınç ÜNAL wrote:
>> On 31.03.2023 13:16, Daniel Golle wrote:
>>> On Fri, Mar 31, 2023 at 08:50:28AM +0300, Arınç ÜNAL wrote:
>>>> On 30.03.2023 18:23, Daniel Golle wrote:
>>>>> Add driver for the built-in Gigabit Ethernet switch which can be found
>>>>> in the MediaTek MT7988 SoC.
>>>>>
>>>>> The switch shares most of its design with MT7530 and MT7531, but has
>>>>> it's registers mapped into the SoCs register space rather than being
>>>>> connected externally or internally via MDIO.
>>>>>
>>>>> Introduce a new platform driver to support that.
>>>>>
>>>>> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>>>>> ---
>>>>>    MAINTAINERS                   |   2 +
>>>>>    drivers/net/dsa/Kconfig       |  12 ++++
>>>>>    drivers/net/dsa/Makefile      |   1 +
>>>>>    drivers/net/dsa/mt7530-mmio.c | 101 
>>>>> ++++++++++++++++++++++++++++++++++
>>>>>    drivers/net/dsa/mt7530.c      |  86 ++++++++++++++++++++++++++++-
>>>>>    drivers/net/dsa/mt7530.h      |  12 ++--
>>>>>    6 files changed, 206 insertions(+), 8 deletions(-)
>>>>>    create mode 100644 drivers/net/dsa/mt7530-mmio.c
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index 14924aed15ca7..674673dbdfd8b 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -13174,9 +13174,11 @@ MEDIATEK SWITCH DRIVER
>>>>>    M:    Sean Wang <sean.wang@mediatek.com>
>>>>>    M:    Landen Chao <Landen.Chao@mediatek.com>
>>>>>    M:    DENG Qingfang <dqfext@gmail.com>
>>>>> +M:    Daniel Golle <daniel@makrotopia.org>
>>>>>    L:    netdev@vger.kernel.org
>>>>>    S:    Maintained
>>>>>    F:    drivers/net/dsa/mt7530-mdio.c
>>>>> +F:    drivers/net/dsa/mt7530-mmio.c
>>>>>    F:    drivers/net/dsa/mt7530.*
>>>>>    F:    net/dsa/tag_mtk.c
>>>>> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
>>>>> index c2551b13324c2..de4d86e37973f 100644
>>>>> --- a/drivers/net/dsa/Kconfig
>>>>> +++ b/drivers/net/dsa/Kconfig
>>>>> @@ -52,6 +52,18 @@ config NET_DSA_MT7530
>>>>>          Multi-chip module MT7530 in MT7621AT, MT7621DAT, MT7621ST and
>>>>>          MT7623AI SoCs is supported as well.
>>>>> +config NET_DSA_MT7988
>>>>> +    tristate "MediaTek MT7988 built-in Ethernet switch support"
>>>>> +    select NET_DSA_MT7530_COMMON
>>>>> +    depends on HAS_IOMEM
>>>>> +    help
>>>>> +      This enables support for the built-in Ethernet switch found
>>>>> +      in the MediaTek MT7988 SoC.
>>>>> +      The switch is a similar design as MT7531, however, unlike
>>>>> +      other MT7530 and MT7531 the switch registers are directly
>>>>> +      mapped into the SoCs register space rather than being 
>>>>> accessible
>>>>> +      via MDIO.
>>>>> +
>>>>>    config NET_DSA_MV88E6060
>>>>>        tristate "Marvell 88E6060 ethernet switch chip support"
>>>>>        select NET_DSA_TAG_TRAILER
>>>>> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
>>>>> index 71250d7dd41af..103a33e20de4b 100644
>>>>> --- a/drivers/net/dsa/Makefile
>>>>> +++ b/drivers/net/dsa/Makefile
>>>>> @@ -8,6 +8,7 @@ endif
>>>>>    obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
>>>>>    obj-$(CONFIG_NET_DSA_MT7530_COMMON) += mt7530.o
>>>>>    obj-$(CONFIG_NET_DSA_MT7530)    += mt7530-mdio.o
>>>>> +obj-$(CONFIG_NET_DSA_MT7988)    += mt7530-mmio.o
>>>>
>>>> I'm not fond of this way. Wouldn't it be better if we split the mdio 
>>>> and
>>>> mmio drivers to separate modules and kept switch hardware support on
>>>> mt7530.c?
>>>
>>> You mean this in terms of Kconfig symbols?
>>> Because the way you describe is basically what I'm doing here:
>>>   * mt7530.c is the shared/common switch hardware driver
>>>   * mt7530-mdio.c contains the MDIO accessors and MDIO device drivers 
>>> for
>>>     MT7530, MT7531, MT7621, MT7623, ...
>>>   * mt7530-mmio.c contains the platform device driver for in-SoC 
>>> switches
>>>     which are accessed via MMIO, ie. MT7988 (and yes, this could be
>>>     extended to also support MT7620A/N).
>>
>> Ok great.
>>
>>>
>>> In early drafts I also named the Kconfig symbols
>>> CONFIG_NET_DSA_MT7530 for mt7530.c (ie. the common part)
>>> CONFIG_NET_DSA_MT7530_MDIO for the MDIO driver
>>> CONFIG_NET_DSA_MT7530_MMIO for the MMIO driver
>>>
>>> However, as existing kernel configurations expect 
>>> CONFIG_NET_DSA_MT7530 to
>>> select the MDIO driver, I decided it would be better to hide the 
>>> symbol of
>>> the common part and have CONFIG_NET_DSA_MT7530 select the MDIO driver 
>>> like
>>> it was before.
>>
>> You can "imply NET_DSA_MT7530_MDIO" from NET_DSA_MT7530 so the MDIO 
>> driver is also enabled when NET_DSA_MT7530 is selected. For example, 
>> on Realtek, both MDIO and SMI drivers are enabled by default when 
>> either of the main drivers are selected.
>>
>> config NET_DSA_MT7530
>>      tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
>>      select NET_DSA_TAG_MTK
>>      select MEDIATEK_GE_PHY
>>      select PCS_MTK_LYNXI
>>      imply NET_DSA_MT7530_MDIO
>>      imply NET_DSA_MT7530_MMIO
> 
> The final kconfig should look like this:
> 
> config NET_DSA_MT7530
>      tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
>      select NET_DSA_TAG_MTK
>      select MEDIATEK_GE_PHY
>      select PCS_MTK_LYNXI

Looks like PCS_MTK_LYNXI is used on NET_DSA_MT7530_MDIO instead now. I 
also see '#include <linux/pcs/pcs-mtk-lynxi.h>' on mt7530.c but don't 
see any functions called on it. Leftover?

>      imply NET_DSA_MT7530_MDIO
>      imply NET_DSA_MT7530_MMIO
>      help
>        This enables support for the MediaTek MT7530 and MT7531 Ethernet
>        switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
>        MT7621ST and MT7623AI SoCs, and built-in switch in MT7688 SoC is
>        supported.
> 
> config NET_DSA_MT7530_MDIO
>      tristate "MediaTek MT7530 MDIO interface driver"

Should go here:

select PCS_MTK_LYNXI

Arınç
