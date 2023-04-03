Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B586D5047
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjDCS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjDCS1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:27:33 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F242122;
        Mon,  3 Apr 2023 11:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680546405; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=amFYB6/8kFu+/YBDW6rCTEjJgABW/rHXOC8eJnq+PvIBx/W0/lLNWfwRmuY2pz7ulM9zQAAwpOxA2VV4S/3nQ16UWNUaAqB2I8u/f6Gzkxz1YBi8AgnAFYNU/+Qe2gW5rr6BQL9PPa5KLVC+rTfCyQwV5mNOp0bkfQfSwlk15p0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680546405; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yjadkvpHaI84b2mrZAym00QmfOP3XKu1mCYPopoQH7g=; 
        b=JAiQ8O04DL2ze4heXj2ea9wnQStPf81gWjNJY7RLdemUsqlWkWdvdbvFTgZg8grQ3m1rRyr4tJ2txYcHYOmujGZFnjFRz9YEIYyTLUajT3lvETP+lDVs5YrTIzDDgtbvu1Nb07YrhPMdefYc9jUx6oEnCBWVgeBVH3GxbOh9NGw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680546405;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=yjadkvpHaI84b2mrZAym00QmfOP3XKu1mCYPopoQH7g=;
        b=VdEhOC0KKnP16srLGg4XsK8m8c3Cyt8O+DvnYgtnnKecCuz7ehsuUsJYmYPhAyw7
        rsejEBvnLAfGSzIwvCv/IFktrLzkzXNPCjabkkarIGMYcqwocMz+bFnOJZbY1gva28z
        vYbq4O1hPcORtXH/L0II+h8k6s6ZkOUqydodGpRc=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680546404035403.7134331614941; Mon, 3 Apr 2023 11:26:44 -0700 (PDT)
Message-ID: <5b68a0c5-b7b1-9507-b095-60c773d24ade@arinc9.com>
Date:   Mon, 3 Apr 2023 21:26:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 00/14] net: dsa: add support for MT7988
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
 <73ce771f-3a13-b1c7-659d-7e1c236fdd0b@arinc9.com>
 <ZCsXV7MkcUJldQbf@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZCsXV7MkcUJldQbf@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3.04.2023 21:13, Daniel Golle wrote:
> On Mon, Apr 03, 2023 at 08:50:11PM +0300, Arınç ÜNAL wrote:
>> On 3.04.2023 20:42, Daniel Golle wrote:
>>> Hi Arınç,
>>>
>>> On Mon, Apr 03, 2023 at 08:08:19PM +0300, Arınç ÜNAL wrote:
>>>> On 3.04.2023 04:16, Daniel Golle wrote:
>>>>> The MediaTek MT7988 SoC comes with a built-in switch very similar to
>>>>> previous MT7530 and MT7531. However, the switch address space is mapped
>>>>> into the SoCs memory space rather than being connected via MDIO.
>>>>> Using MMIO simplifies register access and also removes the need for a bus
>>>>> lock, and for that reason also makes interrupt handling more light-weight.
>>>>>
>>>>> Note that this is different from previous SoCs like MT7621 and MT7623N
>>>>> which also came with an integrated MT7530-like switch which yet had to be
>>>>> accessed via MDIO.
>>>>>
>>>>> Split-off the part of the driver registering an MDIO driver, then add
>>>>> another module acting as MMIO/platform driver.
>>>>>
>>>>> The whole series has been tested on various MediaTek boards:
>>>>>     * MT7623A + MT7530 (BPi-R2)
>>>>>     * MT7986A + MT7531 (BPi-R3)
>>>>>     * MT7988A reference board
>>>>
>>>> You did not address the incorrect information I pointed out here. Now that
>>>
>>> I'm sorry, that was certainly not intentional and I may have missed
>>> your comments. Actually it doesn't look like they have made it to the
>>> netdev list archive or patchwork either.
>>>
>>>> the patch series is applied, people reading this on the merge branch commit
>>>> will be misled by the misinformation.
>>>
>>> I've changed Kconfig stuff according to your recommendation and also
>>> addressed possible misleading USXGMII and 10GBase-KR support by
>>> introducing MT7988-specific functions and using 'internal' PHY mode.
>>> So which of your comments have not been addressed?
>>
>> https://lore.kernel.org/netdev/c11c86e4-5f8e-5b9b-1db5-e3861b2bade6@arinc9.com/
> 
> Strange that both emails didn't make it into patchwork.

I don't understand how how patchwork handles the conversation on the 
cover letter. I was never able to see them on patchwork but lore.kernel.org.

My review for patch 15 was received on patchworks as it should. It was 
missing "net-next" on the subject so perhaps that's why you missed it.

https://patchwork.kernel.org/project/netdevbpf/patch/80a853f182eac24735338f3c1f505e5f580053ca.1680180959.git.daniel@makrotopia.org/#25278482

Why don't you just check your inbox? We're emailing each other in the end.

> 
>>
>>>
>>>>
>>>>>
>>>>> Changes since v1:
>>>>>     * use 'internal' PHY mode where appropriate
>>>>>     * use regmap_update_bits in mt7530_rmw
>>>>>     * improve dt-bindings
>>>>
>>>> As a maintainer of the said dt-bindings, I pointed out almost 7 things for
>>>> you to change. Of those 7 points, you only did one, a trivial grammar
>>>> change. The patch series is applied now so one of us maintainers (you are
>>>> one too now) need to fix it with additional patches.
>>>
>>> I was also surprised the series made it to net-next so quickly, but it
>>> wasn't me applying it, I merly posted v2 with all comments I received
>>> addressed.
>>>
>>> Me and supposedly also netdevbpf maintainers use patchwork to track
>>> patches and whether comments have been addressed. Can you point me to
>>> emails with the comments which haven't been addressed there? Looking in
>>> patchwork for the dt-bindings patch [1] I don't see any comments there.
>>
>> https://lore.kernel.org/netdev/a7ab2828-dc03-4847-c947-c7685841f884@arinc9.com/
>>
>>>
>>>
>>> Thank you for reviewing!
>>>
>>>
>>> Daniel
>>>
>>>
>>> [1]: See patchwork tracking for RFCv3, v1 and v2. Prior to RFCv3 the series
>>> didn't have the dt-bindings addition, I introduced it with RFCv3 when splitting
>>> the series into many small changes:
>>> https://patchwork.kernel.org/project/netdevbpf/patch/9b504e3e88807bfb62022c0877451933d30abeb5.1680105013.git.daniel@makrotopia.org/
>>> https://patchwork.kernel.org/project/netdevbpf/patch/fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org/
>>> https://patchwork.kernel.org/project/netdevbpf/patch/dffacdb59aea462c9f7d4242cf9563a04cf79807.1680483896.git.daniel@makrotopia.org/
>>
>> Although I've been a maintainer for the dt-bindings schema for quite some
>> time, I was somehow missed as a recipient on RFC v3.
> 
> Yeah, that was my mistake. get_maintainers.pl comes up with unreadable
> unicode garbage, probably something is wrong in my local Perl setup.
> So I always manually replace your name with readable UTF-8, but I missed
> that for RFC v3.

Did you try writing the output of get_maintainers.pl to a file, then 
feed the file directly to git send-email as recipients?

That may bypass that issue. It's also currently how I send my patches.

https://arinc9.notion.site/get_maintainers-and-git-send-email-e8edd99d962041eca874966021acefe6

Arınç
