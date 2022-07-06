Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB1569254
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiGFTFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiGFTFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:05:37 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114131DA49
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 12:05:34 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4LdTWs17Ljz9sWt;
        Wed,  6 Jul 2022 21:05:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1657134329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sLxuyklC0Z7iml/ksSQYe1DeafX43pbTIjDNNAg5waQ=;
        b=H+ddahvO/iCAE4BAUNiDslqXdPqRz80YgzRdqppXb4q4W726+hz2cl3mcRFbKWuZRr3ta3
        hPLVvw3gB4g1laCKHc1hZHA48Myufd14c9BvHdtaGp/F32CQkFVRIs5leYaoeR03doB1X3
        lMbzLBxl+qO+dXDUcebcOkQRW9Pv+sx7F7BJ19+P3aE0HPPhdRGA9fJB+9IgkrkJ03169D
        4XtLbTCi/8zNwIqLiQ4N+L4xK4kw/fqsxxXMYXDq8HgUljemIXUcYWJQX4yBD/TdLuyDNO
        s5drMOe8CYMGAf0eF84ha+K1weIoq8XBvfRNkZwb/S0FRxrwlxrfp4jaGKca+Q==
Message-ID: <4ec0461c-0000-ff8c-4368-5d68d70b894e@hauke-m.de>
Date:   Wed, 6 Jul 2022 21:05:22 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <7fe6b661-06b9-96dd-e064-1db23a9eaae7@gmail.com>
 <20220706101459.tahby2xpm3e7okjz@skbuf>
 <d65824fc-a139-0430-5550-481dd202ad34@gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
In-Reply-To: <d65824fc-a139-0430-5550-481dd202ad34@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 18:27, Florian Fainelli wrote:
> On 7/6/22 03:14, Vladimir Oltean wrote:
>> Hi Florian,
>>
>> On Tue, Jul 05, 2022 at 09:42:33AM -0700, Florian Fainelli wrote:
>>> On 7/5/22 02:46, Russell King (Oracle) wrote:
>>>> A new revision of the series which incorporates changes that Marek
>>>> suggested. Specifically, the changes are:
>>>>
>>>> 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
>>>>      default interface rather than re-using port_max_speed_mode()
>>>>
>>>> 2. Patch 4 - if no default interface is provided, use the supported
>>>>      interface mask to search for the first interface that gives the
>>>>      fastest speed.
>>>>
>>>> 3. Patch 5 - now also removes the port_max_speed_mode() method
>>>
>>> This was tested with bcm_sf2.c and b53_srab.b and did not cause 
>>> regressions,
>>> however we do have a 'fixed-link' property for the CPU port (always 
>>> have had
>>> one), so there was no regression expected.
>>
>> What about arch/arm/boot/dts/bcm47189-tenda-ac9.dts?
> 
> You found one of the devices that I do not have access to and did not 
> test, thanks. We do expect to run the port at 2GBits/sec on these 
> devices however there is no "official" way to advertise that a port can 
> run at 2Gbits/sec, as this is not even a "sanctioned" speed. I do have a 
> similar device however, so let me run some more tests, we won't see a 
> regression however since we do not use the NATP accelerator which would 
> be the reason to run the port at 2Gbits/sec.

I will try this change on some devices with the lantiq gswip driver at 
the weekend.

On the SoC supported by the lantiq gswip driver the switch is integrated 
in the SoC and there is a internal link with more than 1GBit/s 
connecting the switch to the rest of the system. I think it is also 
around 2GBit/s. We can not configure the interface speed or many other 
interface settings for the link between the switch and the CPU. How 
should the device tree ideally look for this setup?

Hauke
