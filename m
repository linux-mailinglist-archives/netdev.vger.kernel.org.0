Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5096A1880
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBXJId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjBXJIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:08:32 -0500
X-Greylist: delayed 1218 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Feb 2023 01:08:27 PST
Received: from mxout70.expurgate.net (mxout70.expurgate.net [91.198.224.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73275243
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:08:27 -0800 (PST)
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <prvs=9433889ceb=ms@dev.tdt.de>)
        id 1pVTkN-0005Ji-TG; Fri, 24 Feb 2023 09:48:07 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1pVTkN-000NGc-G0; Fri, 24 Feb 2023 09:48:07 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 39008240049;
        Fri, 24 Feb 2023 09:48:07 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id DF262240040;
        Fri, 24 Feb 2023 09:48:06 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 8F9972D463;
        Fri, 24 Feb 2023 09:48:06 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 24 Feb 2023 09:48:06 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Michael Walle <michael@walle.cc>
Cc:     tharvey@gateworks.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, hauke@hauke-m.de, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <df9a0b6e59d27d5898a9021915ca333a@walle.cc>
References: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <20230222160425.4040683-1-michael@walle.cc>
 <8aa26f417c99761cdf1b6b7082fdec14@dev.tdt.de>
 <df9a0b6e59d27d5898a9021915ca333a@walle.cc>
Message-ID: <adb55f7dc3b4be01317cf7766e389874@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1677228487-5128C51F-D4FACCC0/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-24 09:04, Michael Walle wrote:
> Hi Martin,
> 
> Am 2023-02-24 07:25, schrieb Martin Schiller:
>> On 2023-02-22 17:04, Michael Walle wrote:
>>> Hi Tim, Hi Martin,
>>> 
>>>> I've got some boards with the GPY111 phy on them and I'm finding 
>>>> that
>>>> modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless 
>>>> I
>>>> do a soft reset (BCMR_RESET) first. I don't see anything in the
>>>> datasheet which specifies this to be the case so I'm interested it
>>>> what you have found. Are you sure adjusting the skews like this
>>>> without a soft (or hard pin based) reset actually works?
>>> 
>>> I do have the same PHY and I'm puzzled with the delay settings. Do
>>> you have an EEPROM attached to the PHY? According to my datasheet,
>>> that seems to make a difference. Apparently, only if there is an
>>> EEPROM, you can change the value (the value is then also written to
>>> the EEPROM according the datasheet).
>>> If you don't have one, the values will get overwritten by the
>>> external strappings on a soft reset. Therefore, it seems they cannot
>>> be set. (FWIW there is also a sticky bit, but that doesn't seem to
>>> help in this case).
>>> 
>>> -michael
>> 
>> Yes, you are right. The datasheet says: "In no-EEPROM mode, writing to
>> this register has no impact on operation of the device".
>> 
>> But changing this settings without an EEPROM indeed has an impact.
>> 
>> We don't use an EEPROM and without tuning this values some boards are
>> unable to communicate on the ethernet port(s).
> 
> Thanks for confirming! Could you share your PHYID1/PHYID2 register and
> firmware version (FWV, 0x1E) contents?

I've 2 PHYs integrated into the VR268 SoC which shows this values:

STD_PHYID1(reg 0x02): 0xd565
STD_PHYID2(reg 0x03): 0xa409
PHY_FWV   (reg 0x1E): 0x8435

And then there are 2 external GPY111 with this values:

STD_PHYID1(reg 0x02): 0xd565
STD_PHYID2(reg 0x03): 0xa401
PHY_FWV   (reg 0x1E): 0x8435

And one external GPY112 with this values:

STD_PHYID1(reg 0x02): 0xd565
STD_PHYID2(reg 0x03): 0xa401
PHY_FWV   (reg 0x1E): 0x8435

> 
> In our case, any changes in MIICTRL are lost after a soft reset.
> 
>> I varied these values during operation in the uboot and was able to 
>> test
>> the limits very nicely.
> 
> So I guess, the value you write into MIICTRL are retained on a soft 
> reset.

No, the value I write into MIICTRL are not retained on a soft reset.

> I.e.
> 
> mii write <phyad> 0x17 0xffff
> mii write <phyad> 0x00 0x8000
> mii read <phyad> 0x17
> 
> will still return 0xffff?

In my tests I always set the skew values in register 0x17 first and
then triggered a restart of the ANEG via register 0x0. This then led to
the new values being adopted.

> 
>> 
>> I wouldn't have introduced this feature if it hasn't got any impact.
> 
> Sure, I'm just trying to figure out the differences ;)
> 
> Thanks,
> Michael

- Martin
