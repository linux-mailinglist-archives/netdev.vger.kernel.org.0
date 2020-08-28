Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FC025613D
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgH1T1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgH1T1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:27:18 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216C0C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:27:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id ay8so97676edb.8
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ludt+w++AZ/zvssRXmf58ClW7Q8FwqVtlN0qCaWMqR8=;
        b=jL/XrtByo1fQK28A6l3+45dXm0+1gYdr7K4NOU+06zEbHF4X5I8Q9PyJ+DYev7v1TW
         mx9INEMW70vitPQsvwO/G0PuisAoql/1apOdY/pUi2L8I2VyG8ghAPQ+NJruPeryGe0C
         uLMRG3Nth+40FZ1Glrmve4zCeh0PXFuSKvYgYAI5A4VtDTGWiyMuPs0/p7Qd8ATHdrsK
         zFWB+oJp3UTcPOCBAqbTzn2yWa5fjV1U3Tlx93vFamOjdQhvzcDJe3qI8T5+gR9CgaAz
         5/qS83G3Nah7RUV+lYAASZ7w3epsM677D6BX/hsdo3t08jZedbyHyDvqiRqgyBZPj+qC
         AunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ludt+w++AZ/zvssRXmf58ClW7Q8FwqVtlN0qCaWMqR8=;
        b=gmi8A0V6RQctrfHhaR0+zg4VYOaTf6KBLpD5reLDsO1ysZ+S6Bv4eqiENyplDUfcfo
         kn8Ya4bOsS/f1QE9qdK8OFyB9ZitvbZnbbMXAJeGqE7s+0PqFmHyRe674UqP1iUVf3WR
         PrHgzfq9Urq6oDN/qIwqeMlpJMqRZyv4pLPKZupp/DqF5o0rTL8jfvyNrfGF/ZX60i0C
         spDEia6bWwhjtrihCQaJx2nde7hB4T8tSIq36YDP+y/nY3e/Qjf5NNujI3NAARmuGPio
         qH2DnhiZM8xDSi+zP4uVwTSEZkG1oP+EIvW8ulLrPH8kE8tvwD+pmcaLHknO4HY0b2zn
         S2Rg==
X-Gm-Message-State: AOAM533r14vqSpBYMb8oyORYKuvjbMOkXQg2jKXtQgxpsdJNSiq0IEdb
        KeaHYrrFWZYuXpp8oLgwFGI=
X-Google-Smtp-Source: ABdhPJz3hVJMvmCK71GjTpffAHZpsGe82M3vrxwJMddkIxmmNhxwEDCV2I8w4m/cEO4l5asvdyLkUw==
X-Received: by 2002:aa7:cb0a:: with SMTP id s10mr299993edt.134.1598642836744;
        Fri, 28 Aug 2020 12:27:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8d31:58e3:8dd6:df93? (p200300ea8f2357008d3158e38dd6df93.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8d31:58e3:8dd6:df93])
        by smtp.googlemail.com with ESMTPSA id a23sm92821eju.43.2020.08.28.12.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 12:27:15 -0700 (PDT)
Subject: Re: [PATCHi v2] net: mdiobus: fix device unregistering in
 mdiobus_register
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
References: <20200827070618.26754-1-s.hauer@pengutronix.de>
 <3f9daa3c-8a16-734b-da7b-e0721ddf992c@gmail.com>
 <20200828141512.GF4498@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e1a1251a-9660-af82-2bf5-e4c664dde031@gmail.com>
Date:   Fri, 28 Aug 2020 21:27:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200828141512.GF4498@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.08.2020 16:15, Sascha Hauer wrote:
> On Thu, Aug 27, 2020 at 10:48:48AM +0200, Heiner Kallweit wrote:
>> On 27.08.2020 09:06, Sascha Hauer wrote:
>>> After device_register has been called the device structure may not be
>>> freed anymore, put_device() has to be called instead. This gets violated
>>> when device_register() or any of the following steps before the mdio
>>> bus is fully registered fails. In this case the caller will call
>>> mdiobus_free() which then directly frees the mdio bus structure.
>>>
>>> Set bus->state to MDIOBUS_UNREGISTERED right before calling
>>> device_register(). With this mdiobus_free() calls put_device() instead
>>> as it ought to be.
>>>
>>> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
>>> ---
>>>
>>> Changes since v1:
>>> - set bus->state before calling device_register(), not afterwards
>>>
>>>  drivers/net/phy/mdio_bus.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>>> index 0af20faad69d..9434b04a11c8 100644
>>> --- a/drivers/net/phy/mdio_bus.c
>>> +++ b/drivers/net/phy/mdio_bus.c
>>> @@ -534,6 +534,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>>  	bus->dev.groups = NULL;
>>>  	dev_set_name(&bus->dev, "%s", bus->id);
>>>  
>>> +	bus->state = MDIOBUS_UNREGISTERED;
>>> +
>>>  	err = device_register(&bus->dev);
>>>  	if (err) {
>>>  		pr_err("mii_bus %s failed to register\n", bus->id);
>>>
>> LGTM. Just two points:
>> 1. Subject has a typo (PATCHi). And it should be [PATCH net v2], because it's
>>    something for the stable branch.
>> 2. A "Fixes" tag is needed.
> 
> Uh, AFAICT this fixes a patch from 2008, this makes for quite some
> stable updates :)
> 
There's just a handful of LTS kernel versions (oldest is 4.4), therefore it
shouldn't be that bad. But right, for things that have always been like they
are now, sometimes it's tricky to find a proper Fixes tag.

> Sascha
> 
> | commit 161c8d2f50109b44b664eaf23831ea1587979a61
> | Author: Krzysztof Halasa <khc@pm.waw.pl>
> | Date:   Thu Dec 25 16:50:41 2008 -0800
> | 
> |     net: PHYLIB mdio fixes #2
> 

