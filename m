Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EED6BA197
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 22:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCNVuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 17:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCNVux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 17:50:53 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 14:50:52 PDT
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A7051F9B;
        Tue, 14 Mar 2023 14:50:52 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 4D0D92B06998;
        Tue, 14 Mar 2023 17:40:49 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 14 Mar 2023 17:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678830048; x=1678837248; bh=5b
        KacenUJfm/nP5sO5Oy+iL59bFvwd5SQ5iWdLqSo4g=; b=YqOtIxPA+cenlSXmEi
        oE/uy4NZjAva5jR+QabiGcAlnZf+GRYmdaLPuezreOWpGLeK+79HKWs5ovQI73Qy
        /ZdzNjiELcZ0Khc7tQThlji9o9aFMFZDN1xjHPZogp5+qVudhvyJBfye7KCv95DC
        DA+WVurirmQ/hdAM0KmQ78F7b431AfMs4xX720iKXEh57fiNLCmqxob4UQcj2k6h
        jxK1y4kfRwDcGvPtfoUOWFPfquGeblyJ65toUwiq++c0GqUijdGGcCvvfFmFojtj
        cotFBBTH/22V7ya8bJJ9JJtgDzbHMwh+fxM74Qt+tT6qeY7BgHaDdR8gfXi7o+u7
        cBmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678830048; x=1678837248; bh=5bKacenUJfm/n
        P5sO5Oy+iL59bFvwd5SQ5iWdLqSo4g=; b=qRxUZQAmpg5QJcl9WX1S5CgDDmK0M
        cxCVreIPFl1JJRODX1xb4GquKGhrsmBy8O3olaVB7KlQESzM3cVmXuskNOSzrJgb
        S9Z/B0JQlGb/YhDjY6VSdF3E7DN7H8owbH4HUBBtrRMBp0Ci08hhEUZ1kAaHAIJo
        2rAf9fiTU90Hmiwbr7F6C//na42jhy/xR4LsZ++HpA3R8ebSlyb4Qyw7G/orPVMs
        hguqbgIDqFeARu2762LQbprGfPc9ZG2DT+9203hBJLU4YqnS6GNsG9bFadE/oE8H
        iZdZR5j5H7MH9/gW7rq4twT0rf+5+NOOUpu+sl9kcfPGS9xI9Mn5oTS9A==
X-ME-Sender: <xms:3-kQZJXFQJHQkta4QvilzNqcOzjithYjaaFBh78TLVaLM_y9qNiIFQ>
    <xme:3-kQZJkaaq3elsxKt3gPqWaNSR6jxEhGj-_9oZoVjaPEHGPycq4VASFWz9afPRKcc
    bbAEfPxyGdTyozlP8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddviedgudehhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:3-kQZFYhf1TsT3pLLX6NZmaCfIf3H5wp84LFusnJJ-Pp3lKSQxYTcw>
    <xmx:3-kQZMXhP8b3Tp_w9haN4FT9huU5zgBLyGlGmPBxE4InX9Bagld48g>
    <xmx:3-kQZDnj6QFV9Xb2HDYBWc7nJILXRyYWy5rv6CJdxk0EcLsKHxZxpA>
    <xmx:4OkQZBFL9QqWRkq4JlCzjiqgfKAqW_oC1iZCdZn2Rj279g00Z1zyPhldr-E>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5FE61B60089; Tue, 14 Mar 2023 17:40:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-221-gec32977366-fm-20230306.001-gec329773
Mime-Version: 1.0
Message-Id: <e19fd8bc-5944-409d-a4a1-3a3d53691634@app.fastmail.com>
In-Reply-To: <4ac809d2-3924-3839-479f-0b4be9f18a1f@linaro.org>
References: <20230314163201.955689-1-arnd@kernel.org>
 <4ac809d2-3924-3839-479f-0b4be9f18a1f@linaro.org>
Date:   Tue, 14 Mar 2023 22:40:26 +0100
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
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023, at 20:57, Krzysztof Kozlowski wrote:
> On 14/03/2023 17:30, Arnd Bergmann wrote:
>
> Please split bindings to separate patch.
>
>>  MAINTAINERS                                   |  1 +
>>  arch/arm/boot/dts/omap2.dtsi                  |  4 ++
>>  arch/arm/boot/dts/omap2420-n8x0-common.dtsi   | 12 ++++
>
> DTS as well...

ok

>> +maintainers:
>> +  - Johannes Berg <johannes@sipsolutions.net>
>> +  - Christian Lamparter <chunkeey@web.de>
>> +
>> +description: |
>
> You can drop '|'.

ok

>> +properties:
>> +  compatible:
>> +    enum:
>> +      - st,stlc4550
>> +      - st,stlc4560
>> +      - isil,p54spi
>> +      - cnxt,3110x
>
> Order above entries by name.

ok

>> +
>> +  power-gpios:
>
> If this is GPIO driving some power pin, then it should be
> "powerdown-gpios" (like in /bindings/gpio/gpio-consumer-common.yaml)

As far as I can tell, it's the opposite: the gpio turns the power on
in 'high' state. I could make it GPIO_ACTIVE_LOW and call it powerdown,
if you think that's better, but I don't think that is how it was
meant.

>> +examples:
>> +  - |
>> +   gpio {
>
> Align example with above |, so four spaces. Or better indent entire
> example with four spaces.

Ok, that makes it much more readable.

>> +     gpio-controller;
>> +     #gpio-cells = <1>;
>> +     #interupt-cells = <1>;
>> +   };
>
> Drop "gpio" node. It's not needed for the example.

ok.

>> +   spi {
>> +      #address-cells = <1>;
>> +      #size-cells = <0>;
>> +
>> +      wifi@0 {
>> +        reg = <0>;
>> +        compatible = "st,stlc4560";
>
> compatible before reg.

ok.

       Arnd
