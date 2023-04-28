Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD596F1F2C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345610AbjD1UQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345675AbjD1UQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:16:05 -0400
Received: from mail.aboehler.at (mail.aboehler.at [IPv6:2a01:4f8:121:5012::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5922700
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:16:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.aboehler.at (Postfix) with ESMTP id 8D4793CC03F3;
        Fri, 28 Apr 2023 22:15:57 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at aboehler.at
Received: from mail.aboehler.at ([127.0.0.1])
        by localhost (aboehler.at [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uDgWDdo1JeAu; Fri, 28 Apr 2023 22:15:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aboehler.at;
        s=default; t=1682712956;
        bh=LfeUMNFTO/p+o9B3MafXJotrjJhRY6eXannpkzk5Qlw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aFl/I9ifccvR0yBWTfHXGR28e2bDLjMV1076PD/Abg9GESX55lRv5/F3fxzlB+F/h
         9m9abrVwBBaApliI3vIBwmVse5SYSjfOrG7lYBrwVpeVJimMwGRK2LKrEDa8ZjXj+7
         run4XoRnmjMomR+r4lfQ06ObtHSJ662ZFnXM0LS8=
Received: from [192.168.17.124] (84-113-45-48.cable.dynamic.surfer.at [84.113.45.48])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: andreas@aboehler.at)
        by mail.aboehler.at (Postfix) with ESMTPSA id 35B2D3CC03F2;
        Fri, 28 Apr 2023 22:15:56 +0200 (CEST)
Message-ID: <e9a859b0-c1da-0f65-b02e-fbf3aa297286@aboehler.at>
Date:   Fri, 28 Apr 2023 22:15:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: SFP: Copper module with different PHY address (Netgear AGM734)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
References: <d57b4fcd-2fa6-bc92-0650-72530fbdc0a8@aboehler.at>
 <d4d526db-995b-4426-8a8d-b53acceb5f74@lunn.ch>
Content-Language: de-AT
From:   =?UTF-8?Q?Andreas_B=c3=b6hler?= <news@aboehler.at>
In-Reply-To: <d4d526db-995b-4426-8a8d-b53acceb5f74@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
thanks for the quick reply!

On 26/04/2023 19:04, Andrew Lunn wrote:
> On Wed, Apr 26, 2023 at 06:47:33PM +0200, Andreas Böhler wrote:
>> Hi,
>>
>> I have a bunch of Netgear AGM734 copper SFP modules that I would like to use
>> with my switches. Upon insertion, a message "no PHY detected" pops up.
>>
>> Upon further investigation I found out that the Marvell PHY in these modules
>> is at 0x53 and not at the expected 0x56. A quick check with a changed
>> SFP_PHY_ADDR works as expected.
>>
>> Which is the best scenario to proceed?
>>
>> 1. Always probe SFP_PHY_ADDR and SFP_PHY_ADDR - 3
>>
>> 2. Create a fixup for this specific module to probe at a different address.
>> However, I'm afraid this might break "compatible" modules.
>>
>> 3. Something else?
> 
> 
> What does ethtool -m show?

Offset          Values
------          ------
0x0000:         03 04 00 00 00 00 08 00 00 00 00 01 0d 00 00 00
0x0010:         00 00 64 00 4e 45 54 47 45 41 52 20 20 20 20 20
0x0020:         20 20 20 20 00 00 09 5b 41 47 4d 37 33 34 20 20
0x0030:         20 20 20 20 20 20 20 20 30 30 30 30 00 00 00 7e
0x0040:         00 01 00 00 31 38 31 36 30 34 31 30 30 33 34 37
0x0050:         20 20 20 20 31 38 30 34 32 35 30 31 00 00 00 79
0x0060:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0070:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0080:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0090:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00a0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00b0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00c0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00d0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00e0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00f0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

This is the output of i2cdetect -y 0:

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 -- -- 53 -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --


> Is there something we a key a quirk off?

Unfortunately, I don't understand this sentence.

> Is it a true Netgear SFP?

Yes, it's a brand new original Netgear module.

> There are OEMs which will load there EEPROM to emulate other
> vendors. e.g.:

Yes, this is what I meant with a quirk might break "compatible" modules.

Regards,
Andreas
