Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6456BA86E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCOGwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjCOGwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:52:07 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F149F9;
        Tue, 14 Mar 2023 23:51:40 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id CD97C2B06874;
        Wed, 15 Mar 2023 02:50:50 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 15 Mar 2023 02:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678863050; x=1678870250; bh=34
        HZu+QxANz64sdbgwEEpIKdNrBPFX/SLnskCihCx9g=; b=unXcXrb2R6W7Z/T5+H
        tMkGplkj2HQfMVCWlZ4qdsD6UMCC8j6hbZ86GSAyx9JV1oe9yh+Xi0uTRv34ZFUF
        yAZ1M3xXUsa48KQyWcU3jhGmuJayYagKJT1Pjjpy89OfwZ1y0ua62Zn6cgUAQYDj
        VmEveQlSrd84prvEaadeJpixg1ckgmYiCc+L8YySuyuEhe1NC22kq4HH3xFJEhpB
        Sp9jh16UMtCsy/yflnuj/72bHoNm0cg3SEA0F5fDPqMOjG0q0Gmsrh3KgQguS8q4
        HuVI0nP+MO1x5XDO2J4gsoGPSDurJCucxOWtAVcBShEvLgssnJi7e8nTyT6fgGvO
        fz+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678863050; x=1678870250; bh=34HZu+QxANz64
        sdbgwEEpIKdNrBPFX/SLnskCihCx9g=; b=KkfnFcijOHmLiTuw04qroNmj+oREf
        eVpdL51Swqq29NElAH2GOqsRliSE7KHrMchxo38l+c+htILMuPgkx/HGR04okJQl
        qs9pPz8bWzo474r17cYW1mMpLWbp7ydjgFui3iAQQUGQ8X2g812XhXjW28LNKh8K
        rDgoKsQM6++W5sU+h8AZua5eylDHSmM52KM7uRIUZbWE3QzHci1IYiDYXn46RA6u
        a5zbVPhD5aw9f9QwtS6apjj6oPTALlkN9XjhfApltzEKXLxrIP6SzdFdhx6sSSIr
        MbVcLe+ntGML5bRJHICQ+yNCcm9mEBNKwgbUIqDZhFpaDyxemFTl38sfw==
X-ME-Sender: <xms:yWoRZEGlC2-UqnrfN9eEt2cdxX5uxwiff_5bEAVK_euuuY2RDQkoOQ>
    <xme:yWoRZNXeT7x8qoi5aBjzyyLwpKkMmqQb-lbiA4ZoHPHUeO7OSMBhq9_3ozq0iPIif
    8_eJAfQumVf6gak1wk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvjedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:yWoRZOKW8Qn8HW1f5pi3t_kRoCkOTTg3_538hKkRmg4No2owXMQKhw>
    <xmx:yWoRZGG2p6Jqd4xRgYewIqkYSwqQvWeDcqIWzPO5vefIUIk4lKyo1w>
    <xmx:yWoRZKWR82osrjyHUSfRd3A4IMn8mO8Ea_2gnSayNB3hi_geFEArEg>
    <xmx:ymoRZE3dnYOHZai1SW7l2Rw5DQMBaDYUk0sQjAa9yslbWB3Ycww7IxUSo4g>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5987FB60086; Wed, 15 Mar 2023 02:50:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-221-gec32977366-fm-20230306.001-gec329773
Mime-Version: 1.0
Message-Id: <afee6a67-2406-4f52-99a2-ee7eb26e587b@app.fastmail.com>
In-Reply-To: <57c42604-38b0-61ce-2fc4-2284fbb9d708@linaro.org>
References: <20230314163201.955689-1-arnd@kernel.org>
 <4ac809d2-3924-3839-479f-0b4be9f18a1f@linaro.org>
 <e19fd8bc-5944-409d-a4a1-3a3d53691634@app.fastmail.com>
 <57c42604-38b0-61ce-2fc4-2284fbb9d708@linaro.org>
Date:   Wed, 15 Mar 2023 07:50:28 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Christian Lamparter" <chunkeey@googlemail.com>,
        "Kalle Valo" <kvalo@kernel.org>
Cc:     "Linus Walleij" <linus.walleij@linaro.org>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "Tony Lindgren" <tony@atomide.com>,
        "Aaro Koskinen" <aaro.koskinen@iki.fi>,
        "Felipe Balbi" <balbi@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] p54spi: convert to devicetree
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023, at 07:32, Krzysztof Kozlowski wrote:
> On 14/03/2023 22:40, Arnd Bergmann wrote:
>
>>>> +
>>>> +  power-gpios:
>>>
>>> If this is GPIO driving some power pin, then it should be
>>> "powerdown-gpios" (like in /bindings/gpio/gpio-consumer-common.yaml)
>> 
>> As far as I can tell, it's the opposite: the gpio turns the power on
>> in 'high' state. I could make it GPIO_ACTIVE_LOW and call it powerdown,
>> if you think that's better, but I don't think that is how it was
>> meant.
>
> Whether this is active low or high, I think does not matter. If this is
> pin responsible to control the power, then we use the name
> "powerdown-gpios". Effectively powerup GPIO is the same as powerdown,
> just reversed.

Ok, so should I make this GPIO_ACTIVE_LOW and adapt the patch to
call it powerdown in both the code and dt for consistency?

      Arnd
