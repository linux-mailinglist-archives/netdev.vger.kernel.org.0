Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED66D4C1457
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbiBWNkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240978AbiBWNkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:40:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FBF5AC04B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645623571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ZjjBLEVy1E0rixG8g+5okuLN72qxgLAUeebM7Ze/UU=;
        b=JQeDFBnLrQAkE0Jx+F1WAFd5dFBUR9jHZclXi65uIst1Lhj6ILDdv6OfUcwKVE/lzwOIZc
        0vnD7+pxw6CzQmOotG7mVh/yQsjBHTP2daOWbnCb2lzvrKz5ft+GkDBUmO7h57wK/by05w
        lcU57iT16sx/XZ0z0sNAwATmp0qYFIo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-pZzyb5EENRu62S0y7iLMTw-1; Wed, 23 Feb 2022 08:39:30 -0500
X-MC-Unique: pZzyb5EENRu62S0y7iLMTw-1
Received: by mail-ed1-f69.google.com with SMTP id n7-20020a05640205c700b0040b7be76147so13585506edx.10
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:39:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9ZjjBLEVy1E0rixG8g+5okuLN72qxgLAUeebM7Ze/UU=;
        b=vR92IEvTmhVgkhv8UlZUqPxPZuMoHPtlA3YyCb2o77XEoh/sSJ/HdAKm/uQ1X5gBjG
         WljJPAziGd2Nq9L9CXn2c2hz0Bp9v3MtRYmHfwPQYN+EFmS9oPiY+7lEE46PimAmS2Sj
         XjgalYsLcDWc4CXwI4tjSq9TnbBImsuxnSnF21V16ccNn1wEacNzoSy5QZRYRRkZMEbF
         BRCgw0BHDeiCm7vOQTvVik0FOk13sEbEyin6FoPTQuiR8hKjbJcxkdi5QMDMkLpl83d7
         RaHARAs5q3qkSvfiLam+at1mXFIuQov//8dY/kAOC5bG3DgByWlh3S3Lg9wyetRpXHXX
         +UWw==
X-Gm-Message-State: AOAM53082v/csbIuKh/UOeEdyRvVozUPBBCFOdCxMaDpS+GJ3WwRd0XQ
        U3HKedO6K3uC2DCyjxtKXav9P3KIYP4f99CP+GJCcYvYXgUnaOaqwAHcxzBsFAgoO+KgYsV7o9m
        K3ZoZ67D0HpbNsMNT
X-Received: by 2002:a17:906:2ec6:b0:69f:286a:66ab with SMTP id s6-20020a1709062ec600b0069f286a66abmr23540588eji.684.1645623568942;
        Wed, 23 Feb 2022 05:39:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzv4Ge2wJLmCbyT5FqSu5aHs9KNkldmFXzly5bPRTsLBfjQrPx6LpsM4oEgZIy3mytLBsRKzw==
X-Received: by 2002:a17:906:2ec6:b0:69f:286a:66ab with SMTP id s6-20020a1709062ec600b0069f286a66abmr23540565eji.684.1645623568621;
        Wed, 23 Feb 2022 05:39:28 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id z22sm12238431edd.45.2022.02.23.05.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 05:39:28 -0800 (PST)
Message-ID: <4d611fe8-b82a-1709-507a-56be94263688@redhat.com>
Date:   Wed, 23 Feb 2022 14:39:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com> <20220222142513.026ad98c@fixe.home>
 <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
 <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
 <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/23/22 13:41, Russell King (Oracle) wrote:
> On Wed, Feb 23, 2022 at 01:02:23PM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 2/23/22 12:22, Andy Shevchenko wrote:
>>> On Tue, Feb 22, 2022 at 02:25:13PM +0100, Clément Léger wrote:
>>>> Le Mon, 21 Feb 2022 19:57:39 +0200,
>>>> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
>>>>
>>>>> On Mon, Feb 21, 2022 at 05:26:52PM +0100, Clément Léger wrote:
>>>>>> Add support to retrieve a i2c bus in sfp with a fwnode. This support
>>>>>> is using the fwnode API which also works with device-tree and ACPI.
>>>>>> For this purpose, the device-tree and ACPI code handling the i2c
>>>>>> adapter retrieval was factorized with the new code. This also allows
>>>>>> i2c devices using a software_node description to be used by sfp code.  
>>>>>
>>>>> If I'm not mistaken this patch can even go separately right now, since all used
>>>>> APIs are already available.
>>>>
>>>> This patches uses fwnode_find_i2c_adapter_by_node() which is introduced
>>>> by "i2c: fwnode: add fwnode_find_i2c_adapter_by_node()" but they can
>>>> probably be contributed both in a separate series.
>>>
>>> I summon Hans into the discussion since I remember he recently refactored
>>> a bit I2C (ACPI/fwnode) APIs. Also he might have an idea about entire big
>>> picture approach with this series based on his ACPI experience.
>>
>> If I understand this series correctly then this is about a PCI-E card
>> which has an I2C controller on the card and behind that I2C-controller
>> there are a couple if I2C muxes + I2C clients.
> 
> That is what I gathered as well.
> 
>> Assuming I did understand the above correctly. One alternative would be
>> to simply manually instantiate the I2C muxes + clients using
>> i2c_new_client_device(). But I'm not sure if i2c_new_client_device()
>> will work for the muxes without adding some software_nodes which
>> brings us back to something like this patch-set.
> 
> That assumes that an I2C device is always present, which is not always
> the case - there are hot-pluggable devices on I2C buses.
> 
> Specifically, this series includes pluggable SFP modules, which fall
> into this category of "hot-pluggable I2C devices" - spanning several
> bus addresses (0x50, 0x51, 0x56). 0x50 is EEPROM like, but not quite
> as the top 128 bytes is paged and sometimes buggy in terms of access
> behaviour. 0x51 contains a bunch of monitoring and other controls
> for the module which again can be paged. At 0x56, there may possibly
> be some kind of device that translates I2C accesses to MDIO accesses
> to access a PHY onboard.
> 
> Consequently, the SFP driver and MDIO translation layer wants access to
> the I2C bus, rather than a device.
> 
> Now, before ARM was converted to DT, we had ways to cope with
> non-firmware described setups like this by using platform devices and
> platform data. Much of that ended up deprecated, because - hey - DT
> is great and more modern and the old way is disgusting and we want to
> get rid of it.
> 
> However, that approach locks us into describing stuff in firmware,
> which is unsuitable when something like this comes along.
> 
> I think what we need is both approaches. We need a way for the SFP
> driver (which is a platform_driver) to be used _without_ needing
> descriptions in firmware. I think we have that for GPIOs, but for an
> I2C bus, We have i2c_get_adapter() for I2C buses, but that needs the
> bus number - we could either pass the i2c_adapter or the adapter
> number through platform data to the SFP driver.
> 
> Or is there another solution to being able to reuse multi-driver
> based infrastructure that we have developed based on DT descriptions
> in situations such as an add-in PCI card?

The use of software fwnode-s as proposed in this patch-set is another
way to deal with this. There has been work to abstract ACPI vs
of/dt firmware-nodes into a generic fwnode concept and software-nodes
are a third way to define fwnode-s for "struct device" devices.

Software nodes currently are mainly used as so called secondary
fwnodes which means they can e.g. add extra properties to cover
for the firmware description missing some info (which at least
on ACPI happens more often then we would like).

But a software-node can also be used as the primary fwnode for
a device. So what this patch-set does is move the i2c of/dt
enumeration code over to the fwnode abstraction (1). This allows
the driver for the SPF card to attach a software fwnode to the
device for the i2c-controller which describes the hotplug pins +
any other always present hw in the same way as it would be done
in a devicetree fwnode and then the existing of/dt based SPF
code can be re-used as is.

At least that is my understanding of this patch-set.

Regards,

Hans



1) This should result in no functional changes for existing
devicetree use cases.

