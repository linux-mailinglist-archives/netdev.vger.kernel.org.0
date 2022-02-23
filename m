Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9504C121C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiBWMC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240210AbiBWMCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:02:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 125EF58E7C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645617747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rxw0Z+reGZb0g3ZpKzxxXhVmrLWhbn6dM0h9967n9S4=;
        b=Y6pdqY7cuOtczfvBkwSEM6srAvve0XTst7PAvyaSJ2Nj33vvCygqXvVvFtz6S/3gAGLn95
        yaHRqV7cmrEN9299Px6+lUwGLucNMwu02+BGlYeSHbPXTKqE0jJsM55ZcAb+w8T1AWENt/
        zXnmXMwCv4ZG9fMTDepaVBd3DKIVNc8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-j7064IgVNeiyGvdXJYZeSg-1; Wed, 23 Feb 2022 07:02:25 -0500
X-MC-Unique: j7064IgVNeiyGvdXJYZeSg-1
Received: by mail-ed1-f71.google.com with SMTP id e10-20020a056402190a00b00410f20467abso13473728edz.14
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:02:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rxw0Z+reGZb0g3ZpKzxxXhVmrLWhbn6dM0h9967n9S4=;
        b=XquKNC30Gmtq70ztsjYZBZ3WXVTacXHwqxh6mT/HrOTOFK2QJGYIJirCD3fDY4YwGF
         Zkrdz/I6rFG1x0jDIesWFb3/QBlbEmbqNqiD4wsSb1MnQFIMfUy+KUyXZt6rN6fysW/G
         /6t6S1AejNFB0aX6yBctiKwrxe6EUIHdn5Vaq9a1Kt+0RashGgiF8cPiIAv1KTRjXkak
         XH/pKbSqvS7LrIo2UXJDyTPsQ2P1hQwHiRYhq5V6m9bbjkZaHIgDMLeDXK93FWxmFE0e
         UIoVGruP3v/1fKE7YscE0YDSwIX/Ci2U4bKNGkLLWnFlCefKGofQw5yjtBWr2bDyX5IY
         B+7w==
X-Gm-Message-State: AOAM531gufR3MbDLH6V4XqAAU5j9OLiaSEgCglAMBap8YLn8UVrptuyx
        vz5UyAo764K3P5436r0/GFtXAJEiitYxOH4w5A/Vn84dedIi/kHEKjlTcuFQQxEkor6grxDGKQ2
        XJyX+TCGZtr3IpDlS
X-Received: by 2002:aa7:cc96:0:b0:410:b9ac:241 with SMTP id p22-20020aa7cc96000000b00410b9ac0241mr31879377edt.246.1645617744686;
        Wed, 23 Feb 2022 04:02:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfeaFDjsJwitSmeTHc7QM+d+toZyNkK8DQVMWIsAnMGqcK0Rpdfv174Ak9wkYZNTh4U2N2nQ==
X-Received: by 2002:aa7:cc96:0:b0:410:b9ac:241 with SMTP id p22-20020aa7cc96000000b00410b9ac0241mr31879344edt.246.1645617744435;
        Wed, 23 Feb 2022 04:02:24 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id e15sm3312059ejk.3.2022.02.23.04.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 04:02:24 -0800 (PST)
Message-ID: <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
Date:   Wed, 23 Feb 2022 13:02:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
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
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/23/22 12:22, Andy Shevchenko wrote:
> On Tue, Feb 22, 2022 at 02:25:13PM +0100, Clément Léger wrote:
>> Le Mon, 21 Feb 2022 19:57:39 +0200,
>> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
>>
>>> On Mon, Feb 21, 2022 at 05:26:52PM +0100, Clément Léger wrote:
>>>> Add support to retrieve a i2c bus in sfp with a fwnode. This support
>>>> is using the fwnode API which also works with device-tree and ACPI.
>>>> For this purpose, the device-tree and ACPI code handling the i2c
>>>> adapter retrieval was factorized with the new code. This also allows
>>>> i2c devices using a software_node description to be used by sfp code.  
>>>
>>> If I'm not mistaken this patch can even go separately right now, since all used
>>> APIs are already available.
>>
>> This patches uses fwnode_find_i2c_adapter_by_node() which is introduced
>> by "i2c: fwnode: add fwnode_find_i2c_adapter_by_node()" but they can
>> probably be contributed both in a separate series.
> 
> I summon Hans into the discussion since I remember he recently refactored
> a bit I2C (ACPI/fwnode) APIs. Also he might have an idea about entire big
> picture approach with this series based on his ACPI experience.

If I understand this series correctly then this is about a PCI-E card
which has an I2C controller on the card and behind that I2C-controller
there are a couple if I2C muxes + I2C clients.

And the goal of the series is to describe those I2C muxes + I2C clients
with software nodes so that the existing I2C enumeration code can be
used (after porting the existing I2C enumeration code from OF functions
to generic fwnode functions).

Did I understand this bit correctly? I believe that a lot of the
discussion here is caused by the initial problem / hw-setup this
series tries to address / support is not described very well ?

Assuming I did understand the above correctly. One alternative would be
to simply manually instantiate the I2C muxes + clients using
i2c_new_client_device(). But I'm not sure if i2c_new_client_device()
will work for the muxes without adding some software_nodes which
brings us back to something like this patch-set.

In general I believe that porting things away from OF specific parsing
to the generic fwnode APIs is a good thing.

Making device_get_match_data() for devices with only a software fwnode
use of_device_id matching feels a bit weird. But it also makes sense
since that requires just adding a compatible string to the software
fwnode properties which is easy and it allows re-uses existing
matching code in the drivers.

I understand various people falling over this weirdness but AFAICT
the alternative would be adding some special swnode_id type + matching
code for devices where the primary fwnode is a software fwnode, which
would just be a whole bunch of extra code ending up with something
similar.

So re-using of_device_id-s for matching of devices where the primary
fwnode is a software fwnode seems like a good idea. *But* this all
needs to be explained in the commit message a lot better. It really
needs to be spelled out that this is:

a) Only for matching devices where the primary fwnode is a software fwnode 

b) Really has nothing to do with of/dt but of_device_id matching is
   used here to avoid having to introduce a new matching mechanism just
   for devices where the primary fwnode is a software fwnode

c) That introducing a new software fwnode matching mechanism would be
   a bad idea since this will require adding new swnode_match tables
   to many drivers, where as re-using of_device_id will make drivers
   which already have an of_match_table just work.

And this should be spelled out in both the commit message as well
as in some documentation / kdoc comments. Because although a useful
trick, reusing the of_match_id-s is also confusing which I believe
is what has led to a lot of the discussion on this patch-set so far.

Note the above all relies on my interpretation of this patch set,
which may be wrong, since as said the patch-set does seem to be
lacking when it comes to documentation / motivation of the patches.

Regards,

Hans


