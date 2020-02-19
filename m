Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6B1652B9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgBSWv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:51:58 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52326 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgBSWv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 17:51:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so17186wmc.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 14:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jbujtbx8IL4E4woX2WznpDK1BwIAnRN303wihEdTgzE=;
        b=bDsHKLLnaLt1VWDmj4X2+Wjsl7sQsft8qDmFVzh3QBpfMZI+HI93+Tox1K/5evJ2NV
         FbJjsUH/gtpR9LesG6TgJn+iGSJSbm8cXYH0jEAHcg8/dLpcfWWUNpHuvSp6GgTY1Q01
         wGmhJVWbuwCyepIJOcQM9d5Hx0sqHA81dpza3eLDyh/y84So0YrCzYNGjLnNtAHFUOL8
         BoUmxU0eP+QDNxqujLDW6HnK3QRF7LSikJAGwrTF47D3hiyDNjhnzoWEvJJEqQ4P+HGO
         lNIJDNGWWxSUKnODyKiG/jKJ3ZfGGjPWjacPHNn+vKUil8TYHN3c7XTzzDnn8XdeITFw
         xDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jbujtbx8IL4E4woX2WznpDK1BwIAnRN303wihEdTgzE=;
        b=Xz3OtoLOcAeCXZStJzpO2MJrjZq6OF5i4MOgxwzlB/BOYznVW+BKvwkHCur3ypFdPt
         0alfkzE41QB0QUbydYpeqtthStj+pXFQVDNUMfqQxWhG1n0SXx2X31Qdjd/x5++A+6gW
         EZWL1p3bmztUhvnV72+tKKeG4d0uxzX3A8Vhbn6DZmqvLGf/adR5Sr/ekObK8MdazOAu
         2RPnF3M5LRSXIOblweAB1cp9ccBQp9iV0jFH4E8+JGVKtPLyUOqQQclESAt+spoBfVse
         MMnQfTuLeRjRi0xcGoGrn2JlzLYkqQ0zLwUmEisQnAzM/tWSF5cTc+wHLBkB3NFx+fn0
         n83w==
X-Gm-Message-State: APjAAAVd0Zu9bk0zC0zpXvK83ZtR/ujdqwbTTqMW4LGMI4R8ZyiNUgV0
        wjkNk1mEAW/Ri/Gd6svJoDHRmPDt
X-Google-Smtp-Source: APXvYqzfYp03m0zPkQahTYSBYVDmgm4tLMEjxzNrhq/D0IyDnE5Wi76CA/XT/QfLLRFJsuMx/i2ZQw==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr16754wma.134.1582152715179;
        Wed, 19 Feb 2020 14:51:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:a8cb:6924:1f30:ec1a? (p200300EA8F296000A8CB69241F30EC1A.dip0.t-ipconnect.de. [2003:ea:8f29:6000:a8cb:6924:1f30:ec1a])
        by smtp.googlemail.com with ESMTPSA id t9sm1727642wrv.63.2020.02.19.14.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 14:51:54 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] net: phy: unregister MDIO bus in
 _devm_mdiobus_free if needed
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
 <913abdae-0617-b411-7eaa-599588f95e32@gmail.com>
 <20200219222103.GZ31084@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <57df2161-a4f8-c57a-d5d0-e360f06aa9a2@gmail.com>
Date:   Wed, 19 Feb 2020 23:51:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219222103.GZ31084@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.02.2020 23:21, Andrew Lunn wrote:
> On Mon, Feb 17, 2020 at 09:34:57PM +0100, Heiner Kallweit wrote:
>> If using managed MDIO bus handling (devm_mdiobus_alloc et al) we still
>> have to manually unregister the MDIO bus. For drivers that don't depend
>> on unregistering the MDIO bus at a specific, earlier point in time we
>> can make driver author's life easier by automagically unregistering
>> the MDIO bus. This extension is transparent to existing drivers.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/mdio_bus.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 9bb9f37f2..6af51cbdb 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -170,7 +170,12 @@ EXPORT_SYMBOL(mdiobus_alloc_size);
>>  
>>  static void _devm_mdiobus_free(struct device *dev, void *res)
>>  {
>> -	mdiobus_free(*(struct mii_bus **)res);
>> +	struct mii_bus *bus = *(struct mii_bus **)res;
>> +
>> +	if (bus->state == MDIOBUS_REGISTERED)
>> +		mdiobus_unregister(bus);
>> +
>> +	mdiobus_free(bus);
>>  }
> 
> Hi Heiner
> 
> The API is rather asymmetric. The alloc is not just setting up a free,
> but also an unregister. Are there other examples of this in the
> kernel?
> 
To a certain extent pcim_release() is similar. It silently reverses
previous calls to pci_enable_msi / pci_enable_msix (after calling
pcim_enable_device).

> Maybe a devm_of_mdiobus_register() would be better? It is then clear
> that the unregister happens because of this call, and the free because
> of the devm_mdiobus_alloc().
> 
I understand the concern regarding the asymmetry. For me the question
is whether the additional effort for avoiding it is worth it.
We'd have to create at least devm_register_mdiobus and
devm_of_mdiobus_register.
Also then we'd have to think about how to deal with the case that a
non-perfect driver author combines a non-managed mdiobus_alloc
with a later call to devm_register_mdiobus, because we'd like to
avoid the case that mdiobus_free is called before mdiobus_unregister.
Maybe we would need a mechanism similar to the one used in the
PCI core functions mentioned earlier.
devm_register_mdiobus would have to warn if the bus allocation was
non-managed.

>    Andrew
> 
Heiner
