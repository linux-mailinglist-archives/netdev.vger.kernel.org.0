Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA31D2F7E65
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbhAOOjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbhAOOjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:39:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E10C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:39:08 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id by27so9739834edb.10
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8w19BwsYjrc1URVjV0LFI1aJq2YRF2GN3hqjIU27qxs=;
        b=poqeaviSh2w4ltq5sIT+f982LKVol9FDGwvzH9kkpaSHgGrx+fMlnMpiuAfOx2Jfqv
         SRHJm1cPQmVJBx+oKMXl7JQfFX9xyciyqOEiBaPVOG5+H438rpUdrLG0Q4hwo4Znurz1
         cutD1J8jHZZwCuBU02YsGmxRGzfaT5t7RJTAQOE1Ko9x9+cpFqoKnl8I/EI5Wp2bzO9i
         S305pr5luE076CDgK5WSDPH4861Pm5SIsdW3hgMXiyS6p1BmBg9q/IMWjI/rnOqVSyAn
         57MT1vIzPR3oGXNQs3hsbwRAjT5h4O3IeJ6eq8F1+egYs2HNyJ0osKAXMAu4jP+bBjps
         BACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8w19BwsYjrc1URVjV0LFI1aJq2YRF2GN3hqjIU27qxs=;
        b=j++1ps6ok6m6dChQv2p6tSG0fe4n7n1AQwYazImzQuqqmEon2kuSYkbY3LcdNgflp8
         I9Lr4whkR91O7PwhPBic3UFivLELgjk+Kdj4nCsVWJL7bQi1x0KzsyPUVvpHVawZmXW2
         GHqoHqMCluXJIAtpbJgLCpBLjAxBe/4MVfT4N9lioXa18ziJmE4qtANS6roQpKt3TfSq
         FxdW7PNAGl6K5//RSiIWxcb6tRb9bznqVtZWK4bnSdL/1ncEPJEoeje8ZV2YoW/tvN5l
         Mi5uZpWWD+mpKOUrxzua8gndvPNt+fL8nMPlIdBn5AiysLcYawRDUpA0XYYqD8JgbSbD
         g3eQ==
X-Gm-Message-State: AOAM531hG9JfMcPNULlLgZcQNornQPSUvEQk7vFErhMtjxrdb14hf+5f
        H4447Pq7AC879NKxt0VGxRogKA==
X-Google-Smtp-Source: ABdhPJyU6t6c3RpLu3UQgHNr1SHnvAKt9yTXmEBRATC22Mapp0Oji7hrojs2rKRj5uXzS6tsECxqLQ==
X-Received: by 2002:a50:c209:: with SMTP id n9mr9885787edf.123.1610721547415;
        Fri, 15 Jan 2021 06:39:07 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y24sm3895802edt.80.2021.01.15.06.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:39:07 -0800 (PST)
Date:   Fri, 15 Jan 2021 15:39:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115143906.GM3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114074804.GK3565223@nanopsycho.orion>
 <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 12:30:13AM CET, kuba@kernel.org wrote:
>On Thu, 14 Jan 2021 08:48:04 +0100 Jiri Pirko wrote:
>> Thu, Jan 14, 2021 at 03:27:16AM CET, kuba@kernel.org wrote:
>> >On Wed, 13 Jan 2021 13:12:12 +0100 Jiri Pirko wrote:  
>> >> This patchset introduces support for modular switch systems.
>> >> NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
>> >> to accomodate line cards. Available line cards include:
>> >> 16X 100GbE (QSFP28)
>> >> 8X 200GbE (QSFP56)
>> >> 4X 400GbE (QSFP-DD)
>> >> 
>> >> Similar to split cabels, it is essencial for the correctness of
>> >> configuration and funcionality to treat the line card entities
>> >> in the same way, no matter the line card is inserted or not.
>> >> Meaning, the netdevice of a line card port cannot just disappear
>> >> when line card is removed. Also, system admin needs to be able
>> >> to apply configuration on netdevices belonging to line card port
>> >> even before the linecard gets inserted.  
>> >
>> >I don't understand why that would be. Please provide reasoning, 
>> >e.g. what the FW/HW limitation is.  
>> 
>> Well, for split cable, you need to be able to say:
>> port 2, split into 4. And you will have 4 netdevices. These netdevices
>> you can use to put into bridge, configure mtu, speeds, routes, etc.
>> These will exist no matter if the splitter cable is actually inserted or
>> not.
>
>The difference is that the line card is more detectable (I hope).
>
>I'm not a SFP experts so maybe someone will correct me but AFAIU
>the QSFP (for optics) is the same regardless of breakout. It's the
>passive optical strands that are either bundled or not. So there is 
>no way for the system to detect the cable type (AFAIK).

For SFP module, you are able to detect those.

>
>Or to put it differently IMO the netdev should be provisioned if the
>system has a port into which user can plug in a cable. When there is 

Not really. For slit cables, the ports are provisioned not matter which
cable is connected, slitter 1->2/1->4 or 1->1 cable.


>a line card-sized hole in the chassis, I'd be surprised to see ports.
>
>That said I never worked with real world routers so maybe that's what
>they do. Maybe some with a Cisco router in the basement can tell us? :)

The need for provision/pre-configure splitter/linecard is that the
ports/netdevices do not disapper/reappear when you replace
splitter/linecard. Consider a faulty linecard with one port burned. You
just want to replace it with new one. And in that case, you really don't
want kernel to remove netdevices and possibly mess up routing for
example.


>
>> With linecards, this is very similar. By provisioning, you also create
>> certain number of ports, according to the linecard that you plan to
>> insert. And similarly to the splitter, the netdevices are created.
>> 
>> You may combine the linecard/splitter config when splitter cable is
>> connected to a linecard port. Then you provision a linecard,
>> port is going to appear and you will split this port.
>> 
>> >> To resolve this, a concept of "provisioning" is introduced.
>> >> The user may "provision" certain slot with a line card type.
>> >> Driver then creates all instances (devlink ports, netdevices, etc)
>> >> related to this line card type. The carrier of netdevices stays down.
>> >> Once the line card is inserted and activated, the carrier of the
>> >> related netdevices goes up.  
>> >
>> >Dunno what "line card" means for Mellovidia but I don't think 
>> >the analogy of port splitting works. To my knowledge traditional
>> >line cards often carry processors w/ full MACs etc. so I'd say 
>> >plugging in a line card is much more like plugging in a new NIC.  
>> 
>> No. It is basically a phy gearbox. The mac is not there. The interface
>> between asic and linecard are lanes. The linecards is basically an
>> attachable phy.
>
>If the device really needs this configuration / can't detect things
>automatically, then we gotta do something like what you have.
>The only question is do we still want to call it a line card.
>Sounds more like a front panel module. At Netronome we called 
>those phymods.

Sure, the name is up to the discussion. We call it "linecard"
internally. I don't care about the name.

