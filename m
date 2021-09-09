Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF486405B95
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhIIQ5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhIIQ5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 12:57:46 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D5EC061574;
        Thu,  9 Sep 2021 09:56:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k24so2390525pgh.8;
        Thu, 09 Sep 2021 09:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d0um/axuJ3r16rMBlaskZ7yotW/MSL6Ipn9q9Wl2+Zo=;
        b=bW3YPTr5V5UzNYXEQjY85mcUVsdbVylkrW0ft0XV617jPZ4tx/AUPBwnwp5T/G2fwR
         n9I1etPIbpj/7MbERTUddag97TzedvjhWvinsHr6Mk6veTLrYakdze7fnBLploBtCsel
         kF7eg/f6yONFgtMGlgwQDSBrvmWyiQZTA0oywJakXE2o9jL0nwwbyIflCAtPL5IpjhIk
         aaFOj2z3QL/cSuxFeFA37SAkpjRk+O2/ihDkY5UFqdctKW6dnPjp5Gv1+FL1LPG6r1e1
         10zZ/h7JjyFiBIQfTzeSIFITPocFTe98MIDlaqfkbooV3JueN66Qayg0c+vqhURug3Ip
         imDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d0um/axuJ3r16rMBlaskZ7yotW/MSL6Ipn9q9Wl2+Zo=;
        b=6HXKQ77UBMxYJFr1NJ59k1q9Q4w8F8ZCJvHfibX45N2jcwgj4BlbsHqST5yEuiVZfO
         I8ev1xfyyHJ/tYQ1BsHKsjzrXdUUvPxvZqDlXylXukVRGtVbdWXSzgmsPeeOdvbD7XLD
         ApDIL0UbFD7vEMu8kQbGfzKja4kIr1m85tpGNFfB7tdsAShBEZEn43mKgd+wu3DLiJAq
         yIu5W1i6T1bzt2XT8emcGH2nFLy84INw7lwqbWo120nPdKFv1pcGKNncSawGXTo99XFQ
         edBbSzAfc3nXQL2E/tY1QhL5w+W8IhaJfqfN38WJ+4KgLYDTtWlGzFSVeQo9GfqmqVm6
         Q2qA==
X-Gm-Message-State: AOAM532sEyJeG7Q7pi3QS8/pkM1/1JkXKYOZe/ndW9TzCTTw8TNWCwA5
        ilIDByY+dRGQj3XZQiBQppw=
X-Google-Smtp-Source: ABdhPJyRyyNmEOJjjBxSHiH5m984sSGDHBHqCrtZe8H3SS5cAimrlhtQiUpsVlB7L6+jrXOWzGKn9Q==
X-Received: by 2002:a63:f410:: with SMTP id g16mr3471753pgi.201.1631206596098;
        Thu, 09 Sep 2021 09:56:36 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id me10sm2642713pjb.51.2021.09.09.09.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 09:56:35 -0700 (PDT)
Message-ID: <0da3e5a4-e95a-c34a-6332-6ecb76e98f1f@gmail.com>
Date:   Thu, 9 Sep 2021 09:56:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YTll0i6Rz3WAAYzs@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YTll0i6Rz3WAAYzs@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2021 6:39 PM, Andrew Lunn wrote:
>> --- a/net/dsa/dsa2.c
>> +++ b/net/dsa/dsa2.c
>> @@ -1286,6 +1286,17 @@ static int dsa_switch_parse_of(struct
>> dsa_switch *ds, struct device_node *dn)
>>   {
>>          int err;
>>
>> +       /* A lot of switch devices have their PHYs as child devices and have
>> +        * the PHYs depend on the switch as a supplier (Eg: interrupt
>> +        * controller). With fw_devlink=on, that means the PHYs will defer
>> +        * probe until the probe() of the switch completes. However, the way
>> +        * the DSA framework is designed, the PHYs are expected to be probed
>> +        * successfully before the probe() of the switch completes.
>> +        *
>> +        * So, mark the switch devices as a "broken parent" so that fw_devlink
>> +        * knows not to create device links between PHYs and the parent switch.
>> +        */
>> +       np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
>>          err = dsa_switch_parse_member_of(ds, dn);
>>          if (err)
>>                  return err;
> 
> This does not work. First off, its dn, not np. But with that fixed, it
> still does not work. This is too late, the mdio busses have already
> been registered and probed, the PHYs have been found on the busses,
> and the PHYs would of been probed, if not for fw_devlink.
> 
> What did work was:
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index c45ca2473743..45d67d50e35f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -6249,8 +6249,10 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>          if (!np && !pdata)
>                  return -EINVAL;
>   
> -       if (np)
> +       if (np) {
>                  compat_info = of_device_get_match_data(dev);
> +               np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> +       }
>   
>          if (pdata) {
>                  compat_info = pdata_device_get_match_data(dev);
> 
> This will fix it for mv88e6xxx. But if the same problem occurs in any
> of the other DSA drivers, they will still be broken:
> 
> ~/linux/drivers/net/dsa$ grep -r mdiobus_register *
> bcm_sf2.c:	err = mdiobus_register(priv->slave_mii_bus);
> dsa_loop_bdinfo.c:	return mdiobus_register_board_info(&bdinfo, 1);
> lantiq_gswip.c:	return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
> mt7530.c:	ret = mdiobus_register(bus);
> mv88e6xxx/chip.c:	err = of_mdiobus_register(bus, np);
> grep: mv88e6xxx/chip.o: binary file matches
> ocelot/seville_vsc9953.c:	rc = mdiobus_register(bus);
> ocelot/felix_vsc9959.c:	rc = mdiobus_register(bus);
> qca/ar9331.c:	ret = of_mdiobus_register(mbus, mnp);
> qca8k.c:	return devm_of_mdiobus_register(priv->dev, bus, mdio);
> realtek-smi-core.c:	ret = of_mdiobus_register(smi->slave_mii_bus, mdio_np);
> sja1105/sja1105_mdio.c:	rc = of_mdiobus_register(bus, np);
> sja1105/sja1105_mdio.c:	rc = of_mdiobus_register(bus, np);
> sja1105/sja1105_mdio.c:	rc = mdiobus_register(bus);
> sja1105/sja1105_mdio.c:int sja1105_mdiobus_register(struct dsa_switch *ds)
> sja1105/sja1105.h:int sja1105_mdiobus_register(struct dsa_switch *ds);
> sja1105/sja1105_main.c:	rc = sja1105_mdiobus_register(ds);
> 
> If you are happy to use a big hammer:
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..7ecd910f7fb8 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -525,6 +525,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>              NULL == bus->read || NULL == bus->write)
>                  return -EINVAL;
>   
> +       if (bus->parent && bus->parent->of_node)
> +               bus->parent->of_node->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> +
>          BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
>                 bus->state != MDIOBUS_UNREGISTERED);
>   
> So basically saying all MDIO busses potentially have a problem.
> 
> I also don't like the name FWNODE_FLAG_BROKEN_PARENT. The parents are
> not broken, they work fine, if fw_devlink gets out of the way and
> allows them to do their job.
> 
> You also asked about why the component framework is not used. DSA has
> been around for a while, the first commit dates back to October
> 2008. Russell Kings first commit for the component framework is
> January 2014. The plain driver model has worked for the last 13 years,
> so there has not been any need to change.

That part of the story is more complicated than that, DSA did not get 
any development from 2008 till 2014 when I picked it up to add support 
for Broadcom switches. In 2016, in order to support more switches, 
especially those that were "pure" MDIO devices, Andrew came up with the 
mdio_device structure and also created "dsa2" which allowed registering 
switches from their actual bus. This allowed us to depart from all of 
the limitations of the unique "dsa" platform device which was just 
horrible to work with.

I recall very clearly that one of your prototypes that I tested was 
using the component framework, although I do not remember why we did not 
pursue that route and instead the DSA switch tree got reference counted 
and got its current form. So Andrew, you did evaluate the component 
framework but ended up not using it, do you remember why?

There is nothing wrong with the current approach of allowing switches to 
come up and do the final tree setup when the tree is fully resolved. If 
there are driver level changes that we can make to ease the pain on the 
device link framework, we should certainly entertain them, keep in mind 
that DSA for better or worse shows a lot of cargo cult programming.
-- 
Florian
