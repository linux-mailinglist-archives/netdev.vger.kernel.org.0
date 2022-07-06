Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A96567CDB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiGFD4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGFD4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:56:06 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA3B19286;
        Tue,  5 Jul 2022 20:56:01 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id CB602320094E;
        Tue,  5 Jul 2022 23:55:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 05 Jul 2022 23:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1657079756; x=
        1657166156; bh=Xp5o6gyxdCzArszMKlaxjCeE8en69xtf9sJ/OOknFpw=; b=t
        QjgxdFTZ/sUqBixmaQRr4hw6EYwdgHYSkiRP0iuxNrvlEdqAMUACl2Hcgldpg859
        KvrASy01+4n+WZM6RjXvjDI1hgy4Hqbaftix4Le1sY39cRnl7hZcm9UMwHtm8QLS
        JR7I8VuZlm9BglD346DCV2XbU8raU8FU9C1/X1ZNHStFdS0NMHvTtwApdFGzjoBL
        plbJtCniV2B0pyqlyLv8HRVneulIbXgUG6xJySofMQGSIiDFHYYhPBavmBw/lIXw
        X5EhS+xxIZwg2Hkh4QFc5NIOHFnq+HqW6wYKZpSw3WY5kblUFviu6bFx6nr7vcJ7
        pMyRD98EeahoZjdEXMAoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1657079756; x=
        1657166156; bh=Xp5o6gyxdCzArszMKlaxjCeE8en69xtf9sJ/OOknFpw=; b=i
        +wBPw2eDYxdbbxq2CljoEg2WZ4X6XY95ngfukq2ibo4Mgp/V2vrNPbKscpiyRRtH
        XAMbey+IW8pqctdRHFPNYG2lC2zbkKR1Ea6sLnvTeIri4CPV7TZT3Kg5q5kguvQN
        K2PBaBGKgZDMn+zhLBiQT6ThtxnXDJFZi6viX4m67YrNUe6qS8+yC0Co0tHpbsYX
        +xsdz58PEQgVmuuwBIepVSMgQGPs1AVS3eAaXw2LTSd86nSuUDiakhVVcvIYtQRQ
        CkQKv92ZfCc40rnbIrCrlVByfv3kgdzORWIDxR+GLDeIEThxCJgd4zs3A7uUHV45
        h99YlaDrf9GwjtBfj1Suw==
X-ME-Sender: <xms:ywfFYkpEwjKqpg_RCclvnqXfNW6z6CTowdmENDLwkFyzpKPumTcqDg>
    <xme:ywfFYqqrP471WWg2kOkAUfglarASmf18wOd0j56inmJTvP7TAwyydJs6rVBvq8qrs
    XUg-FkJ8XNdFq4LsA>
X-ME-Received: <xmr:ywfFYpMrb2l3Bd3fbMc1WA6w3Vi2MBG5a2nQ1IxnKd16WTB3ti_L-_kx4sl2JTCEhBgsA_EaMzbFAp9ZIQNdNzz7P-9lyMuEQMoK5xDuM0URg9SPF_hZTRbLvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeivddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffuvfevfhfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghm
    uhgvlhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedthefhheevffegvdehkeehieffkeegffethfejteelieejffdu
    veejkeduleeltdenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhl
    rghnugdrohhrgh
X-ME-Proxy: <xmx:ywfFYr4L468_Mqq1TBX6j7WTTY6Y90bk6HT-rAROHGRWJw51CGB1zQ>
    <xmx:ywfFYj54pLMF3-jpJMy7WkcOVUGaR3Jq1QTtV-U-3qNf2G6U_x4zfQ>
    <xmx:ywfFYriCHV_1o9BkG_FtzD82xZHcVS3HudHTtGMqxkYBVj20QciZVg>
    <xmx:zAfFYqIs_oBKvV1qh5lPpLrnF6KoOTns_NvTkgy-EyIi7o2GsLajcw>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Jul 2022 23:55:54 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
Subject: Re: [PATCH v12 1/7] dt-bindings: arm: sunxi: Add H616 EMAC compatible
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220701112453.2310722-1-andre.przywara@arm.com>
 <20220701112453.2310722-2-andre.przywara@arm.com>
 <b2661412-5fce-a20d-c7c4-6df58efdb930@sholland.org>
 <20220705111906.3c553f23@donnerap.cambridge.arm.com>
Message-ID: <b3149c47-7fbf-53b2-f0d7-a45942bb819c@sholland.org>
Date:   Tue, 5 Jul 2022 22:55:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20220705111906.3c553f23@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

On 7/5/22 5:19 AM, Andre Przywara wrote:
> On Mon, 4 Jul 2022 18:53:14 -0500
> Samuel Holland <samuel@sholland.org> wrote:
>> On 7/1/22 6:24 AM, Andre Przywara wrote:
>>> The Allwinner H616 contains an "EMAC" Ethernet MAC compatible to the A64
>>> version.
>>>
>>> Add it to the list of compatible strings.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml       | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
>>> index 6a4831fd3616c..87f1306831cc9 100644
>>> --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
>>> @@ -22,6 +22,7 @@ properties:
>>>            - enum:
>>>                - allwinner,sun20i-d1-emac
>>>                - allwinner,sun50i-h6-emac
>>> +              - allwinner,sun50i-h616-emac  
>>
>> The H616 manual has register fields for an internal PHY, like H3. Are these not
>> hooked up for either EMAC?
> 
> Which register fields do you mean, exactly?

I mean bits 15-31 of EMAC_EPHY_CLK_REG0.

> The H616 uses the same internal PHY solution as the H6: an AC200 die
> co-packaged on the carrier (or whatever integration solution they actually
> chose). The difference to the H6 is that EMAC0 is hardwired to the external
> RGMII pins, whereas EMAC1 is hardwired to the internal AC200 RMII pins.
> From all I could see that does not impact the actual MAC IP: both are the
> same as in the H6, or A64, for that matter.

If those bits in EMAC_EPHY_CLK_REG0 have no effect, then I agree. But if
switching bit 15 to internal PHY causes Ethernet to stop working, then the mux
really does exist (even if one side is not connected to anything). In that case,
we need to make sure the mux is set to the external PHY, using the code from H3.

> There is one twist, though: the second EMAC uses a separate EMAC clock
> register in the syscon. I came up with this patch to support that:
> https://github.com/apritzel/linux/commit/078f591017794a0ec689345b0eeb7150908cf85a
> That extends the syscon to take an optional(!) index. So EMAC0 works
> exactly like before (both as "<&syscon>;", or "<&syscon 0>;", but for EMAC1
> we need the index: "<&syscon 4>;".
> But in my opinion this should not affect the MAC binding, at least not for
> MAC0.

It definitely affects the MAC binding, because we have to change the definition
of the syscon property. We should still get that reviewed before doing anything
that depends on it. (And I think EMAC0 support depends on it.)

> And I think we should get away without a different compatible string
> for EMAC1, since the MAC IP is technically the same, it's just the
> connection that is different.

If you claim that both EMACs are compatible with allwinner,sun50i-a64-emac, then
you are saying that any existing driver for allwinner,sun50i-a64-emac will also
work with both of the H616 EMACs. But this is not true. If I hook up both EMACs
in the DT per the binding, and use the driver in master, at best only EMAC0 will
work, and likely neither will work.

So at minimum you need a new compatible for the second EMAC, so it only binds to
drivers that know about the syscon offset specifier.

> In any case I think this does not affect the level of support we promise
> today: EMAC0 with an external PHY only.

This can work if you introduce a second compatible for EMAC1. But at that point
you don't need the syscon offset specifier; it can be part of the driver data,
like for R40. (And any future EMAC1 could likely fall back to this compatible.)

Regards,
Samuel
