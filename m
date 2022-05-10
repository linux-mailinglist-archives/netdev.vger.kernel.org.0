Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9120552101C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiEJJAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbiEJJAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:00:07 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B9F17909A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:56:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x18so22831046wrc.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4tRLxiEfapdgf/U9EFVjBVGgvdBx2RQ6+Dq8TsNOap0=;
        b=AzZNu7PTvcDrdFdSll+dUFp4ykSuCofrARtqVU8gFVIchsq6v9dDMPs1JKNG6iebpO
         VJB9tIRy/bRDsJ4CCHJSXn1cXZEOVd/OAtK6FPU6x2w+P5mywtavA9gQ2ZLyl6tWzWAV
         NASZpn+vnKZdN2WVRrrYWrFsYxpuNJ7dCSDI03BH+s7/ccugVmVoC1pRJXk/QEcnFazA
         sSUhfYTODt04lqERkc1kmNaxCrcU4zdAR/akoZHq3KH88C4TFPZNmYAGMQ5u5YXbG2eW
         OZOEIVA7ZnDAeS+LJqPMrWxlPUSSCQ763YEfRqvhjY3BUcXNgMRK7qXb1jzxAjl6duos
         zpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4tRLxiEfapdgf/U9EFVjBVGgvdBx2RQ6+Dq8TsNOap0=;
        b=WfxEsS/YX+F26C/rU1Xbfe+O2h5Bh9RNn0AEEwH1HG2sjQ/5P2ic3L65OIgrRNhRa2
         369wVax2Tft6qDM6iYJAd22jNrJqNOqRv+PMJvHVWtbzrhivuazQXG37k0Go0TpomFiE
         XZyoZpIYjJ7Li3WTdgUTYlhQLTNyk7ymgbEiUdT3zrnW0Eg7KTh6t5rrp+SR8KJc6QbS
         Xzd2G1qP/fNZE+ZWgDLS7OYJEXovQXKNc2L9JlOsFzJSO3S5IxnyGtcErTXVwv/ND1LR
         FlRVNzgfv4x4m5zJSWrk8F2dCmRVFOUDYWHf6FJcq5nFhZ2TGiOaNKodjsDSJQDMBi1V
         IOYQ==
X-Gm-Message-State: AOAM532DmouZJ/GWyZLEQZlJD9jiE9UVIvW01jIuR6nH8lVyNdfjBGn1
        EkSTjz0znv6CakUZ90vPGsTfig==
X-Google-Smtp-Source: ABdhPJxuOQwh+vy+SrhwKCobqjdicffWh+KMHB3k94CeBPEwDRucEYh3ezPgIDGmrFzt+N9F3JdJuA==
X-Received: by 2002:a05:6000:786:b0:20c:d72e:ad3c with SMTP id bu6-20020a056000078600b0020cd72ead3cmr1347185wrb.67.1652172967768;
        Tue, 10 May 2022 01:56:07 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id j33-20020a05600c1c2100b003942a244ec9sm2560804wms.14.2022.05.10.01.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 01:56:07 -0700 (PDT)
Message-ID: <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
Date:   Tue, 10 May 2022 11:56:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <YnkN954Wb7ioPkru@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 09.05.22 um 15:49 schrieb Andrew Lunn:
> On Mon, May 09, 2022 at 03:29:38PM +0300, Josua Mayer wrote:
>> Dear Maintainers,
>>
>> I am working on a new device based on the LX2160A platform, that exposes
>> 16 sfp connectors, each with its own led controlled by gpios intended
>> to show link status.
> Can you define link status?
I am still struggling with the lower levels of networking terminology 
... so I was considering
when ethtool would report "Link detected: yes".
>   It is a messy concept with SFPs. Is it
> !LOS? I guess not, because you would not of used a GPIO, just hard
> wired it.
I believe the intention was to decide later what information to visualize.
In this iteration there is one LED per sfp connector, with one colour.
But it is conceivable to in the future add more, and use them to 
indicate e.g. the negotiated speed (10/100/1000/10000).
> Does it mean the SERDES has sync? Does it reflect the netdev
> carrier status?
>
>> We have found that there is a way in sysfs to echo the name of the network
>> device to the api of the led driver, and it will start showing link status.
>> However this has to be done at runtime by the user.
> Please take a look at the patches Ansuel Smith submitted last week,
> maybe the week before last.

Found them. Those are a great pointer - I did not notice the 
trigger-sources property
while looking at led documentation and bindings,
but Documentation/devicetree/bindings/leds/common.yaml does have it.

So what his patch-set proposes covers a large part of my question here, 
thanks!

>> On the Layerscape platform in particular these devices are created dynamically
>> by the networkign coprocessor, which supports complex functions such as
>> creating one network interface that spans multiple ports.
> The linux model is that each MAC has a netdev, hence a name. If you
> need to span multiple ports, you then add a bridge and add the MACs to
> the bridge. So there should not be an issue here.
Okay. That will do for the immediate use-case.
>> It seems to me that the netdev trigger therefore can not properly reflect
>> the relation between an LED (which is hard-wired to an sfp cage), and the
>> link state reported by e.g. a phy inside an sfp module.
> The netdev carrier will correctly reflect this.
Once the netdev (eth[0-9]+) has been created, all relations are known, yes.
And because you mentioned above that each MAC has a netdev, it will do.
E.g. while whatever we plug into the sfp connector changes, the MAC 
stays where it is - connected to a particular cage.
>
>> You may notice that again leds are tied to existence of a particular logical
>> network interface, which may or may not exist, and may span multiple
>> physical interfaces in case of layerscape.
> As far as i'm aware, the in kernel code always has a netdev for each
> MAC. Are you talking about the vendor stack?
The coprocessor can be configured both at boot-time and runtime.
During runtime there is a vendor tool "restool" which can create and 
destroy network interfaces, which the dpaa2 driver knows to discover and 
bind to.

Your statement holds, quoting from the dpaa2 driver documentation:
"... exposes each switch port as a network interface, which can be 
included in a bridge or used as a standalone interface"

I made a false assumption here, Thank you!

> 	Andrew
sincerely
Josua Mayer
