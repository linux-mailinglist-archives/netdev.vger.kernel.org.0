Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BA55A2448
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343750AbiHZJ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343856AbiHZJ0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:26:42 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C93D7CE2;
        Fri, 26 Aug 2022 02:26:15 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D0BC91256;
        Fri, 26 Aug 2022 11:26:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661505972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Gn4ptS3/ed2Lm1nmPK54UxVCGs6kaZ+V6UVk8hc79U=;
        b=Irw98jOHKcCBpzxbXnbnBm2WErySqK5FadcE+qJOfx92ZI0qBZ9UHGmrTx8X2oz2XLU00a
        tmaoSaNRgzuL/++suOPWBSMvQGWiIh42Nre8sKtp04SGTywJdLWuTYOrOOTHxqjKJIEw5W
        fiO/RbCqoQftZleMGu5NYvjZGR6TIoP1yU+x+tId8hstkPGk0QqfDhuRW9dB6pDMvCreMK
        v3FqDTu43Kak3T+C5omcDOPgybjR06bMlVQUIw/zk5qSj8gSmoRSqdFQx2MRY5G3uVeYKJ
        pCIn4yfCvmndIHmCnj7iGs75SBE5VFaHkcnqPkYvAys5ETHxUblhg9sszHQmxQ==
MIME-Version: 1.0
Date:   Fri, 26 Aug 2022 11:26:12 +0200
From:   Michael Walle <michael@walle.cc>
To:     Divya.Koppera@microchip.com,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814
 phy
In-Reply-To: <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <20220826084249.1031557-1-michael@walle.cc>
 <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <421712ea840fbe5edffcae4a6cb08150@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+ Oleksij Rempel]

Hi,

Am 2022-08-26 11:11, schrieb Divya.Koppera@microchip.com:
>> > Supports SQI(Signal Quality Index) for lan8814 phy, where it has SQI
>> > index of 0-7 values and this indicator can be used for cable integrity
>> > diagnostic and investigating other noise sources.
>> >
>> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>

..

>> > +#define LAN8814_DCQ_CTRL_CHANNEL_MASK                        GENMASK(1,
>> 0)
>> > +#define LAN8814_DCQ_SQI                                      0xe4
>> > +#define LAN8814_DCQ_SQI_MAX                          7
>> > +#define LAN8814_DCQ_SQI_VAL_MASK                     GENMASK(3, 1)
>> > +
>> >  static int lanphy_read_page_reg(struct phy_device *phydev, int page,
>> > u32 addr)  {
>> >       int data;
>> > @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device
>> *phydev)
>> >       return 0;
>> >  }
>> >
>> > +static int lan8814_get_sqi(struct phy_device *phydev) {
>> > +     int rc, val;
>> > +
>> > +     val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
>> > +     if (val < 0)
>> > +             return val;
>> > +
>> > +     val &= ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
>> 
>> I do have a datasheet for this PHY, but it doesn't mention 0xe6 on 
>> EP1.
> 
> This register values are present in GPHY hard macro as below
> 
> 4.2.225	DCQ Control Register
> Index (In Decimal):	EP 1.230	Size:	16 bits
> 
> Can you give me the name of the datasheet which you are following, so
> that I'll check and let you know the reason.

I have the AN4286/DS00004286A ("LAN8804/LAN8814 GPHY Register
Definitions"). Maybe there is a newer version of it.

> 
>> So I can only guess that this "channel mask" is for the 4 rx/tx pairs 
>> on GbE?
> 
> Yes channel mask is for wire pair.
> 
>> And you only seem to evaluate one of them. Is that the correct thing 
>> to do
>> here?
>> 
> 
> I found in below link is that, get_SQI returns sqi value for 100 
> base-t1 phy's
> https://lore.kernel.org/netdev/20200519075200.24631-2-o.rempel@pengutronix.de/T/

That one is for the 100base-t1 which has only one pair.

> In lan8814 phy only channel 0 is used for 100base-tx. So returning SQI
> value for channel 0.

What if the other pairs are bad? Maybe Oleksij has an opinion here.

Also 100baseTX (and 10baseT) has two pairs, one for transmitting and one
for receiving. I guess you meassure the SQI on the receiving side. So is
channel 0 correct here?

Again this is the first time I hear about SQI but it puzzles me that
it only evaluate one pair in this case. So as a user who reads this
SQI might be misleaded.

-michael
