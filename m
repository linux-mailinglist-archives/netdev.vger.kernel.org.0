Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C556308656
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 08:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhA2HVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 02:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhA2HU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 02:20:59 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F01C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 23:20:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id s24so6452010wmj.0
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 23:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jyho0UycZssS7J46a3dPUJwKiK5cdJC2DFYwQOX75sk=;
        b=rNgg+zNCbgpJznkoBDr68qBdeptDob2dsdT2Qgs5YZg4bh7LM/jrYo/jAwCntxs+Ob
         0bFLTNsRwSWbW6zap492XcWuFcK5LlmFjI5EXJ7pwE/kW/CnJMfaye2pJ510Tn4+Z3pl
         VhBTj4kgJrVk2Qli6C8ifUa48DyqoD+tBPPAaTqpOv5c/GJPTZ2TnwR7Kv5SF4aTg+ta
         RqSyxYZAYhu+dXGAraviB/5fP1EPAZX0mgDCwkWz59YKRnat2UdI1/BDot3HXHXOvIn6
         2ZxaLB4ZqllzymIMqkCN/Ai5+NRFsDdS9/TpAOc8gpGhgpJBWHXK+x/a/5pz0rwNH2Og
         iVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jyho0UycZssS7J46a3dPUJwKiK5cdJC2DFYwQOX75sk=;
        b=W2hQhPnB82hhw2mo3/nByAG42pmVws8PqNrY7Faf0vdMNdmZH/vxTinPWAR6hShTUY
         eAkOB6M65VLp/OYu5McFhuOeGro0mlzLkWuroRBhB75GAlMSsrvDf3imPnOdvtvU4DCh
         48/9douT3mdd9FdFEhee3hOG18Om9X5wvwHR4dJxAHrgXIFu8NMjC8QU/yqM3HsARTgh
         JuMww6b5/vpdCmVsQi/bp4ppVE9evhD5hDRiBBH+rFhGgvRN9a1Tq8thpG4kgqhvloCg
         1SVk7XxWt8tTrq3Kreh4NoGlIe9ir/rJ6ySRf8PH5v19frHoXXz13oMCAh0ijLTBmihr
         uffA==
X-Gm-Message-State: AOAM5337pn79Azdc9hAa3WBhdfzl8axNOjr3WlCWunHhBCztjSjPfjlG
        1aqVVhpLRscEk61m4V22z1KWuA==
X-Google-Smtp-Source: ABdhPJwEa5YJpHRTVJC7f+OQ0iioECOiNInSmMXCa0BA7Oj6+h3lOvqoDtSiGhCxP+IAU4KeKtdmrQ==
X-Received: by 2002:a7b:ca4d:: with SMTP id m13mr2560980wml.28.1611904817120;
        Thu, 28 Jan 2021 23:20:17 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n11sm12044373wra.9.2021.01.28.23.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 23:20:16 -0800 (PST)
Date:   Fri, 29 Jan 2021 08:20:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210129072015.GA4652@nanopsycho.orion>
References: <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBLHaagSmqqUVap+@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 28, 2021 at 03:17:13PM CET, andrew@lunn.ch wrote:
>On Thu, Jan 28, 2021 at 09:14:34AM +0100, Jiri Pirko wrote:
>> Wed, Jan 27, 2021 at 03:14:34PM CET, andrew@lunn.ch wrote:
>> >> >There are Linux standard APIs for controlling the power to devices,
>> >> >the regulator API. So i assume mlxreg-pm will make use of that. There
>> >> >are also standard APIs for thermal management, which again, mlxreg-pm
>> >> >should be using. The regulator API allows you to find regulators by
>> >> >name. So just define a sensible naming convention, and the switch
>> >> >driver can lookup the regulator, and turn it on/off as needed.
>> >> 
>> >> 
>> >> I don't think it would apply. The thing is, i2c driver has a channel to
>> >> the linecard eeprom, from where it can read info about the linecard. The
>> >> i2c driver also knows when the linecard is plugged in, unlike mlxsw.
>> >> It acts as a standalone driver. Mlxsw has no way to directly find if the
>> >> card was plugged in (unpowered) and which type it is.
>> >> 
>> >> Not sure how to "embed" it. I don't think any existing API could help.
>> >> Basicall mlxsw would have to register a callback to the i2c driver
>> >> called every time card is inserted to do auto-provision.
>> >> Now consider a case when there are multiple instances of the ASIC on the
>> >> system. How to assemble a relationship between mlxsw instance and i2c
>> >> driver instance?
>> >
>> >You have that knowledge already, otherwise you cannot solve this
>> 
>> No I don't have it. I'm not sure why do you say so. The mlxsw and i2c
>> driver act independently.
>
>Ah, so you just export some information in /sys from the i2c driver?
>And you expect the poor user to look at the values, and copy paste
>them to the correct mlxsw instance? 50/50 guess if you have two
>switches, and hope they don't make a typO?

Which values are you talking about here exactly?


>
>> >I still don't actually get this use case. Why would i want to manually
>> >provision?
>> 
>> Because user might want to see the system with all netdevices, configure
>> them, change the linecard if they got broken and all config, like
>> bridge, tc, etc will stay on the netdevices. Again, this is the same we
>> do for split port. This is important requirement, user don't want to see
>> netdevices come and go when he is plugging/unplugging cables. Linecards
>> are the same in this matter. Basically is is a "splitter module",
>> replacing the "splitter cable"
>
>So, what is the real use case here? Why might the user want to do
>this?
>
>Is it: The magic smoke has escaped. The user takes a spare switch, and
>wants to put it on her desk to configure it where she has a comfy chair
>and piece and quiet, unlike in the data centre, which is very noise,
>only has hard plastic chair, no coffee allowed. She makes her best
>guess at the configuration, up/downs the interfaces, reboots, to make
>sure it is permanent, and only then moves to the data centre to swap
>the dead router for the new one, and fix up whatever configuration
>errors there are, while sat on the hard chair?
>
>So this feature is about comfy chair vs hard chair?

I don't really get the question, but configuring switch w/o any linecard
and plug the linecards in later on is definitelly a usecase.


>
>I'm also wondering about the splitter port use case. At what point do
>you tell the user that it is physically impossible to split the port
>because the SFP simply does not support it? You say the netdevs don't
>come/go. I assume the link never goes up, but how does the user know
>the configuration is FUBAR, not the SFP? To me, it seems a lot more
>intuitive that when i remove an SFP which has been split into 4, and
>pop in an SFP which only supports a single stream, the 3 extra netdevs
>would just vanish.

As I wrote easlier in this thread, for hw that supports it, there should
be possibility to turn on "autosplit" mode that would do exactly what
you describe. But depends on a usecase. User should be in power to
configure "autosplit" for split cables and "autodetect" for linecards.
Both should be treated in the same way I believe.


>
>   Andrew
>
