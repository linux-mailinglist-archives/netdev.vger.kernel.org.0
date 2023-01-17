Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF785670AD2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjAQWCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjAQWAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:00:15 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301938088A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:43:14 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m21so46805785edc.3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Sa5slVgOfPeHyw3rVfYpgTlgrIyo9VmD35Ic54zMpU=;
        b=aF7id6NbOgUoBZ5hz1TwzqZpMta99Woz9nh2Bqkqyb4DQv0uIeC2zrqGyGD4qzoQ1b
         4MtAG2a+eTliNgSp74NBIjA10XGuxcRhUTNBTStedTa/ynnWznP7dFjQUnbHOSOXBmZm
         0wlb6R1vjYWwBCwfY1mdxacw49iL5Z1TD9qBUUMiwfwT+ct7Ww3W47npVCw4P6x99lql
         2NNvoZzxdgbaxOoIEiVAIhcQb6jmoMGgJ1c7INh7xK8F9v4RGYS5sTcQPoMkZxJzZaSP
         QA7icK48dpbaqy//HKj4LibLc888+gF9XXGDAPRlVPdHiw2RmK4r7ErRdlgco/AnO0wj
         8vPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Sa5slVgOfPeHyw3rVfYpgTlgrIyo9VmD35Ic54zMpU=;
        b=vNVlbP+EzayMDImqwNSQMLGJjmwH/7AlFH4rfa1AMXsJ8Zg8f+jwJiKGfNeFr1YWn7
         b7AuRbKSZNyDcIAQ4Kg9W1Gwr+a/cl2wh46lu+8OatQrwhYm9ep9hXK3uEx+67FTB4CF
         Yzh2gG0No70cPko65iqRkGuaRFQg+65wfCA9aHM0ve1gsct5qL+S/JnpKymBJuDjcxG1
         ag7VNL0qSwaYu1rtUOjkkFh5wqiVnJlZkRvrNRnpBEBZWTUKwdJ+vS+Cz/q/AncsLkNN
         rLrDCs5LAFeD/3DRxn6HPWEeUeeCvvtDMLcnQuR9seXo7sh3CZLt9dbfzBhsgmIlJ3Yj
         MubA==
X-Gm-Message-State: AFqh2ko+/s0xaBBpHQvwDuQBIYSA/z5KrvSptEw0eIzRpA2FR7jQEow6
        bt2hfhT4KQZUWXlyag7Bai0=
X-Google-Smtp-Source: AMrXdXvvHPgDI++xB97v2PhR2X9tsYjp6A+VWHX1mN9FIy870E0Kf8pXwfO2QQZMJ3FcvkwPu8xiHg==
X-Received: by 2002:a05:6402:1003:b0:49e:1e:14ee with SMTP id c3-20020a056402100300b0049e001e14eemr4778737edu.34.1673988193326;
        Tue, 17 Jan 2023 12:43:13 -0800 (PST)
Received: from ?IPV6:2a01:c22:7346:8100:11fa:3b53:e36a:9e73? (dynamic-2a01-0c22-7346-8100-11fa-3b53-e36a-9e73.c22.pool.telefonica.de. [2a01:c22:7346:8100:11fa:3b53:e36a:9e73])
        by smtp.googlemail.com with ESMTPSA id r8-20020a05640251c800b0049df0f91b78sm4439655edd.78.2023.01.17.12.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 12:43:12 -0800 (PST)
Message-ID: <1a20853b-3c08-d6dc-4f1e-9f38fb197a37@gmail.com>
Date:   Tue, 17 Jan 2023 21:43:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: mdio: validate parameter addr in
 mdiobus_get_phy()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
 <5ce7d9c3db722ebb46d1e10ef79812c83bab010f.camel@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <5ce7d9c3db722ebb46d1e10ef79812c83bab010f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.01.2023 12:31, Paolo Abeni wrote:
> On Sun, 2023-01-15 at 11:54 +0100, Heiner Kallweit wrote:
>> The caller may pass any value as addr, what may result in an out-of-bounds
>> access to array mdio_map. One existing case is stmmac_init_phy() that
>> may pass -1 as addr. Therefore validate addr before using it.
>>
>> Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to a bus.")
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/mdio_bus.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 902e1c88e..132dd1f90 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -108,7 +108,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>>  
>>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>>  {
>> -	struct mdio_device *mdiodev = bus->mdio_map[addr];
>> +	struct mdio_device *mdiodev;
>> +
>> +	if (addr < 0 || addr >= ARRAY_SIZE(bus->mdio_map))
>> +		return NULL;
> 
> Speaking of possible follow-ups, would it make sense to add a
> WARN_ON_ONCE() or similar on the above condition?
> 
Yes, I think that's a good idea.
I'll send a follow-up patch.

> Thanks!
> 
> Paolo
>>
> 

