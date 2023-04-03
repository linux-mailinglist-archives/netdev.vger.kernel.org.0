Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6CD6D4F8F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 19:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjDCRvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 13:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjDCRv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 13:51:28 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C85F2724;
        Mon,  3 Apr 2023 10:50:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680544220; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QDL7TOiFOS7WUYxSU8dSnOPrWgppYx8KT3RI8ZuSWwDWaCTwoucBYIjAXuGxneoHuTXO2k0Csy6Ds1drNhsoZxi8jiOrEk5LqV/5dtWogs9zInsVHVWrg3cwiKdCxYkUKf76fJwr0JMxjTzw2vLxKHfpCOs9L9HDq+e8WaAbgtk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680544220; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uO8wqfElcb1z3v0LAGna76ya2fLufvATKsG5PxIgHEY=; 
        b=kG4SsvsESsFJ5+aN820NZLSBEpIarCKt+TgPXY3sKfbTTV0bCtf4R6Pqlqvjit8CZEvFon6ugt2Q+7t6D1ne5/0WVSdIFJLnXKtrnu81KP+ddhM/Eb0AFJ8iYURcV96alyW7nPW3tVD424bclKgWjHPGtyH1BT0q9m5t6Ro4K2A=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680544220;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=uO8wqfElcb1z3v0LAGna76ya2fLufvATKsG5PxIgHEY=;
        b=K2zpsW8fVBnG0jb/9bzHM1lyYDjNkrQVx61ISfKpADo3m0s4HCRn07dfPzj9Rly8
        Kl/DfvOpwruj9LrHvyHA0lgoV4ELDaezSu+TKX4fnUX2/5X47Lnu726pZwvbjEScqt5
        ymWlURfcXt4D0kfg/WDg1KadrErklYVadGsbRh8o=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680544219268224.82519150142696; Mon, 3 Apr 2023 10:50:19 -0700 (PDT)
Message-ID: <73ce771f-3a13-b1c7-659d-7e1c236fdd0b@arinc9.com>
Date:   Mon, 3 Apr 2023 20:50:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 00/14] net: dsa: add support for MT7988
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Russell King <linux@armlinux.org.uk>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
References: <cover.1680483895.git.daniel@makrotopia.org>
 <53d89480-936d-25b1-6422-cda7769de369@arinc9.com>
 <ZCsQIylAgh-rxjfu@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZCsQIylAgh-rxjfu@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3.04.2023 20:42, Daniel Golle wrote:
> Hi Arınç,
> 
> On Mon, Apr 03, 2023 at 08:08:19PM +0300, Arınç ÜNAL wrote:
>> On 3.04.2023 04:16, Daniel Golle wrote:
>>> The MediaTek MT7988 SoC comes with a built-in switch very similar to
>>> previous MT7530 and MT7531. However, the switch address space is mapped
>>> into the SoCs memory space rather than being connected via MDIO.
>>> Using MMIO simplifies register access and also removes the need for a bus
>>> lock, and for that reason also makes interrupt handling more light-weight.
>>>
>>> Note that this is different from previous SoCs like MT7621 and MT7623N
>>> which also came with an integrated MT7530-like switch which yet had to be
>>> accessed via MDIO.
>>>
>>> Split-off the part of the driver registering an MDIO driver, then add
>>> another module acting as MMIO/platform driver.
>>>
>>> The whole series has been tested on various MediaTek boards:
>>>    * MT7623A + MT7530 (BPi-R2)
>>>    * MT7986A + MT7531 (BPi-R3)
>>>    * MT7988A reference board
>>
>> You did not address the incorrect information I pointed out here. Now that
> 
> I'm sorry, that was certainly not intentional and I may have missed
> your comments. Actually it doesn't look like they have made it to the
> netdev list archive or patchwork either.
> 
>> the patch series is applied, people reading this on the merge branch commit
>> will be misled by the misinformation.
> 
> I've changed Kconfig stuff according to your recommendation and also
> addressed possible misleading USXGMII and 10GBase-KR support by
> introducing MT7988-specific functions and using 'internal' PHY mode.
> So which of your comments have not been addressed?

https://lore.kernel.org/netdev/c11c86e4-5f8e-5b9b-1db5-e3861b2bade6@arinc9.com/

> 
>>
>>>
>>> Changes since v1:
>>>    * use 'internal' PHY mode where appropriate
>>>    * use regmap_update_bits in mt7530_rmw
>>>    * improve dt-bindings
>>
>> As a maintainer of the said dt-bindings, I pointed out almost 7 things for
>> you to change. Of those 7 points, you only did one, a trivial grammar
>> change. The patch series is applied now so one of us maintainers (you are
>> one too now) need to fix it with additional patches.
> 
> I was also surprised the series made it to net-next so quickly, but it
> wasn't me applying it, I merly posted v2 with all comments I received
> addressed.
> 
> Me and supposedly also netdevbpf maintainers use patchwork to track
> patches and whether comments have been addressed. Can you point me to
> emails with the comments which haven't been addressed there? Looking in
> patchwork for the dt-bindings patch [1] I don't see any comments there.

https://lore.kernel.org/netdev/a7ab2828-dc03-4847-c947-c7685841f884@arinc9.com/

> 
> 
> Thank you for reviewing!
> 
> 
> Daniel
> 
> 
> [1]: See patchwork tracking for RFCv3, v1 and v2. Prior to RFCv3 the series
> didn't have the dt-bindings addition, I introduced it with RFCv3 when splitting
> the series into many small changes:
> https://patchwork.kernel.org/project/netdevbpf/patch/9b504e3e88807bfb62022c0877451933d30abeb5.1680105013.git.daniel@makrotopia.org/
> https://patchwork.kernel.org/project/netdevbpf/patch/fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org/
> https://patchwork.kernel.org/project/netdevbpf/patch/dffacdb59aea462c9f7d4242cf9563a04cf79807.1680483896.git.daniel@makrotopia.org/

Although I've been a maintainer for the dt-bindings schema for quite 
some time, I was somehow missed as a recipient on RFC v3.

Arınç
