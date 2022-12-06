Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AD1644005
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiLFJoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiLFJoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:44:07 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE0A1B9CB;
        Tue,  6 Dec 2022 01:44:06 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id DFDA615A7;
        Tue,  6 Dec 2022 10:44:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670319845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jsEW3NAT0uIVieWN2G6SR+yV/DSLwSpgw7F9CfJYPMg=;
        b=0c5na9E9OlQfDNdIl9jSgfLlLn3oQ0MC4Eo9Qeyh0JF2IH5QsrOjhrikUvIVuYVqYWtTzu
        s8ZYkeoOatpO7mH4YsV+86w/l+jkesv3OC4XyDSQt348N0QGVZ9L770r72PFKi4tquh20D
        +Pkd1JpE5Pgrr80AufP2T7GR6YPDryLMW2EN/KsulWx1srY1oVMqo/buv4qpEUZxd0zmeJ
        kSdTe3Aysr3aHTE7GGgHxKYJQJl2gY+G79FaPA3xuXNqlK9GK/4xjIuMYS/ObjrfPKdh2Z
        LPW3RkCWdqnzfcEgTeB16u+ifd7d/lhPRVcQTCgKN85HmuPtS7i/R8HQDcoHxw==
MIME-Version: 1.0
Date:   Tue, 06 Dec 2022 10:44:04 +0100
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh@kernel.org>, Xu Liang <lxu@maxlinear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <2597b9e5-7c61-e91c-741c-3fe18247e27c@linaro.org>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
 <20221205212924.GA2638223-robh@kernel.org>
 <99d4f476d4e0ce5945fa7e1823d9824a@walle.cc>
 <9c0506a6f654f72ea62fed864c1b2a26@walle.cc>
 <2597b9e5-7c61-e91c-741c-3fe18247e27c@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6c82b403962aaf1450eb5014c9908328@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-06 09:38, schrieb Krzysztof Kozlowski:

>>>> Just omit the interrupt property if you don't want interrupts and
>>>> add it if you do.
>>> 
>>> How does that work together with "the device tree describes
>>> the hardware and not the configuration". The interrupt line
>>> is there, its just broken sometimes and thus it's disabled
>>> by default for these PHY revisions/firmwares. With this
>>> flag the user can say, "hey on this hardware it is not
>>> relevant because we don't have shared interrupts or because
>>> I know what I'm doing".
> 
> Yeah, that's a good question. In your case broken interrupts could be
> understood the same as "not connected", so property not present. When
> things are broken, you do not describe them fully in DTS for the
> completeness of hardware description, right?

I'd agree here, but in this case it's different. First, it isn't
obvious in the first place that things are broken and boards in
the field wouldn't/couldn't get that update. I'd really expect
an erratum from MaxLinear here. And secondly, (which I
just noticed right now, sorry), is that the interrupt line
is also used for wake-on-lan, which can also be used even for
the "broken" PHYs.

To work around this, the basic idea was to just disable the
normal interrupts and fall back to polling mode, as the PHY
driver just use it for link detection and don't offer any
advanced features like PTP (for now). But still get the system
integrator a knob to opt-in to the old behavior on new device
trees.

>> Specifically you can't do the following: Have the same device
>> tree and still being able to use it with a future PHY firmware
>> update/revision. Because according to your suggestion, this
>> won't have the interrupt property set. With this flag you can
>> have the following cases:
>>   (1) the interrupt information is there and can be used in the
>>       future by non-broken PHY revisions,
>>   (2) broken PHYs will ignore the interrupt line
>>   (3) except the system designer opts-in with this flag (because
>>       maybe this is the only PHY on the interrupt line etc).
> 
> I am not sure if I understand the case. You want to have a DTS with
> interrupts and "maxlinear,use-broken-interrupts", where the latter will
> be ignored by some future firmware?

Yes, that's correct.

> Isn't then the property not really correct? Broken for one firmware
> on the same device, working for other firmware on the same device?

Arguable, but you can interpret "use broken-interrupts" as no-op
if there are no broken interrupts.

> I would assume that in such cases you (or bootloader or overlay)
> should patch the DTS...

I think this would turn the opt-in into an opt-out and we'd rely
on the bootloader to workaround the erratum. Which isn't what we
want here.

-michael
