Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B02D3055CE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhA0I3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhA0IZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 03:25:13 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE68C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 23:57:56 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a1so878524wrq.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 23:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XiLOVrpmWJ7QR/0JjfRLYOEW/5K7ivp851NmvPhRk/c=;
        b=eL6FH9hoTB/Xm0MspGAL75S5YS4EiRjC5BYVkZIaa/KjEFhQbG1nbj1od523xPoIji
         oaJ3K2hcUn8o0cdOIH6L4f+fhehW1Fbw49jqKoFyQmfZjHzD7OcWhOzmPok7JqexjIJY
         VCUIVNTcGV5d3HgEha4TqoY7Ef2nsvDJJQnZClSrfu45dskakWcEqE6Ou/H5L+fEVCft
         kG/SpFkvxpCV/Xi1p2zohInf1lPBcdDF8Y+wowk17COHQ8OfiIogdsD4+wRSmySSUB8M
         TlCwR6WEjI59eAWY8/7yRuqbMbNDkHngfiL6nyMxepD2Jt/l/91D9zhGa08agqWqlX5a
         9BjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XiLOVrpmWJ7QR/0JjfRLYOEW/5K7ivp851NmvPhRk/c=;
        b=cmYqan9RNQNel7gPwurafdqFHeKDjtF/+72RCHPZHZsAupAZPcsQVkUXAZTvwWYgIc
         EYLCTZS3unqu+/9JYp3dI40CE9gAchGasoebkcrhJj8J0PKm4GCC14Z9ZJPO3OrWz/um
         JkErWMBWj44Cd9R3WaON8t2xI9+hQgYygGbMuUM1tmKty4OfvlgeQHbBcC0ZWcAmZchI
         lFAeKkkYcmO00mRq2jbEzGNq6jWBOHSky5VztzMUcfhOG/sJpQGyO5IRLOFiZHJR9B+0
         xui2x6aF6c4YSo+ko4Iag+KbZkAcsAfZUG6YWHEkOu8bKMn6PjwtF+WOb5fdkC25pgYN
         RFPg==
X-Gm-Message-State: AOAM532neyGP76JxrFLdvIXmmESL5tgVvQPtyix5W47tVGP8a/F0/Gca
        V3F16GnWZrxzOnWJjTKdL3+fSg==
X-Google-Smtp-Source: ABdhPJzCJ/JDwPQKm3UxgpADCqfG/mCncogdX2tgdbG/aA7M6n/U7uAOXPgNj04yrqpYI8STcM1a7w==
X-Received: by 2002:a5d:4f84:: with SMTP id d4mr9753716wru.374.1611734275152;
        Tue, 26 Jan 2021 23:57:55 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p15sm1830038wrt.15.2021.01.26.23.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 23:57:54 -0800 (PST)
Date:   Wed, 27 Jan 2021 08:57:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210127075753.GP3565223@nanopsycho.orion>
References: <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBAfeESYudCENZ2e@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 26, 2021 at 02:56:08PM CET, andrew@lunn.ch wrote:
>On Tue, Jan 26, 2021 at 12:33:26PM +0100, Jiri Pirko wrote:
>> Fri, Jan 22, 2021 at 03:13:12PM CET, andrew@lunn.ch wrote:
>> >> I don't see any way. The userspace is the one who can get the info, from
>> >> the i2c driver. The mlxsw driver has no means to get that info itself.
>> >
>> >Hi Jiri
>> >
>> >Please can you tell us more about this i2c driver. Do you have any
>> >architecture pictures?
>> 
>> Quoting Vadim Pasternak:
>> "
>> Not upstreamed yet.
>> It will be mlxreg-lc driver for line card in drivers/platfrom/mellanox and
>> additional mlxreg-pm for line card powering on/off, setting enable/disable
>> and handling power off upon thermal shutdown event.
>> "
>> 
>> 
>> >
>> >It is not unknown for one driver to embed another driver inside it. So
>> >the i2c driver could be inside the mlxsw. It is also possible to link
>> >drivers together, the mlxsw could go find the i2c driver and make use
>> >of its services.
>> 
>> Okay. Do you have examples? How could the kernel figure out the relation
>> of the instances?
>
>Hi Jiri
>
>One driver, embedded into another? You actually submitted an example:
>
>commit 6882b0aee180f2797b8803bdf699aa45c2e5f2d6
>Author: Vadim Pasternak <vadimp@mellanox.com>
>Date:   Wed Nov 16 15:20:44 2016 +0100
>
>    mlxsw: Introduce support for I2C bus
>    
>    Add I2C bus implementation for Mellanox Technologies Switch ASICs.
>    This includes command interface implementation using input / out mailboxes,
>    whose location is retrieved from the firmware during probe time.
>    
>    Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
>    Reviewed-by: Ido Schimmel <idosch@mellanox.com>
>    Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
>There are Linux standard APIs for controlling the power to devices,
>the regulator API. So i assume mlxreg-pm will make use of that. There
>are also standard APIs for thermal management, which again, mlxreg-pm
>should be using. The regulator API allows you to find regulators by
>name. So just define a sensible naming convention, and the switch
>driver can lookup the regulator, and turn it on/off as needed.


I don't think it would apply. The thing is, i2c driver has a channel to
the linecard eeprom, from where it can read info about the linecard. The
i2c driver also knows when the linecard is plugged in, unlike mlxsw.
It acts as a standalone driver. Mlxsw has no way to directly find if the
card was plugged in (unpowered) and which type it is.

Not sure how to "embed" it. I don't think any existing API could help.
Basicall mlxsw would have to register a callback to the i2c driver
called every time card is inserted to do auto-provision.
Now consider a case when there are multiple instances of the ASIC on the
system. How to assemble a relationship between mlxsw instance and i2c
driver instance?

But again, auto-provision is only one usecase. Manual provisioning is
needed anyway. And that is exactly what my patchset is aiming to
introduce. Auto-provision can be added when/if needed later on.


>
>I'm guessing there are no standard Linux API which mlxreg-lc fits. I'm
>also not sure it offers anything useful standalone. So i would
>actually embed it inside the switchdev driver, and have internal APIs
>to get information about the line card.
>
>But i'm missing big picture architecture knowledge here, there could
>be reasons why these suggestions don't work.
>
>   Andrew
