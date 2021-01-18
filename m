Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913122FA0A9
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392076AbhARNCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 08:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391972AbhARNA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 08:00:56 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3245CC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 05:00:14 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d26so16363832wrb.12
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 05:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4qPAUXos/RFVlktxv/aD1QceJ4yoWahYlcZ36hAfgtY=;
        b=ZbAaW3iarMkSzWxsa5oUIsBzwxb3iFZIeqpAnVqC++nNNjhwUjeR6sJvFUT0gEY67V
         dIkfPnbCmPARJTI4ScWAM9mRF/XKYHfYqyanRx5VHHAxZTaTHAVxY/ehEJoj+ZA8Oftx
         U5eqlcBcwtX+aE5ipWmspLjKYd18ZrnALIVicsgGADwjqLK6c3/zOpdA0Ih4rDgjkNk9
         /CYoqd0QdZkVZhEkVC1Q4DWh3hYraqIL7NLCBxXaLapSoug8eCHSXd6ADYP5gSsNIvm6
         vbTeYUNeNO1g6Wz/6YajALGyF9IdCJlBsf2w3154RMs+Jg7cdJy3eK2oidSg5xjZn/IC
         i3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4qPAUXos/RFVlktxv/aD1QceJ4yoWahYlcZ36hAfgtY=;
        b=qTRRs/kX94lw0HIClDpxAIP4UrofLjspu8+ETL8h+sRZ0iAD/URdJXeRS06RPopu0r
         BO8pBicJ2qMXoHIhHV+qaW7OSRMFSo9qAgahoDNEnXal/hwE92gb/vlzsudDDAxpHsi+
         oTrDV3vzoVtCCg9JswaJTj4CqO/DKJMIGyySD4gA/qSJ4721thiBh0wI0YSBt9ZVvKFd
         S+W9uaxGNADB6pPZ2COZPqGri/xyaiEj9yRtgU/+YPtSlnROa9GoRJCTtueNAO3pg2Am
         GMRcfkMtFeOZMFZJssh2vHtruMQtBRj0OcQqOg5Xm3i4KkK2BhWPaNias0ksf/f3ONKo
         BiHA==
X-Gm-Message-State: AOAM530xkYxSaCImIrOaW6lST4GNXXpmZ+l/25uLk8cxk/fjj2rVaYIU
        l3Dvtsksv7Un64R4aIeJBrZMlA==
X-Google-Smtp-Source: ABdhPJzxOZaozYJ+eQGCyS2ZJQ24T0rOg6s+pR5uPrAJeXMwawBq/dapFX+hyHZInjZgJkkM19UnfQ==
X-Received: by 2002:adf:e710:: with SMTP id c16mr25993307wrm.295.1610974812807;
        Mon, 18 Jan 2021 05:00:12 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id r126sm11768814wma.48.2021.01.18.05.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 05:00:12 -0800 (PST)
Date:   Mon, 18 Jan 2021 14:00:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210118130009.GU3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114074804.GK3565223@nanopsycho.orion>
 <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115143906.GM3565223@nanopsycho.orion>
 <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 08:26:17PM CET, kuba@kernel.org wrote:
>On Fri, 15 Jan 2021 15:39:06 +0100 Jiri Pirko wrote:
>> >I'm not a SFP experts so maybe someone will correct me but AFAIU
>> >the QSFP (for optics) is the same regardless of breakout. It's the
>> >passive optical strands that are either bundled or not. So there is 
>> >no way for the system to detect the cable type (AFAIK).  
>> 
>> For SFP module, you are able to detect those.
>
>Not sure you understand what I'm saying. Maybe you're thinking about
>DACs? This is a optical cable for breakout:
>
>https://www.fs.com/products/68048.html
>
>There is no electronics in it to "detect" things AFAIU. Same QSFP can
>be used with this cable or a non-breakout.

Ah, got you.


>
>> >Or to put it differently IMO the netdev should be provisioned if the
>> >system has a port into which user can plug in a cable. When there is   
>> 
>> Not really. For slit cables, the ports are provisioned not matter which
>> cable is connected, slitter 1->2/1->4 or 1->1 cable.
>> 
>> 
>> >a line card-sized hole in the chassis, I'd be surprised to see ports.
>> >
>> >That said I never worked with real world routers so maybe that's what
>> >they do. Maybe some with a Cisco router in the basement can tell us? :)  
>> 
>> The need for provision/pre-configure splitter/linecard is that the
>> ports/netdevices do not disapper/reappear when you replace
>> splitter/linecard. Consider a faulty linecard with one port burned. You
>> just want to replace it with new one. And in that case, you really don't
>> want kernel to remove netdevices and possibly mess up routing for
>> example.
>
>Having a single burned port sounds like a relatively rare scenario.

Hmm, rare in scale is common...


>Reconfiguring routing is not the end of the world.

Well, yes, but you don't really want netdevices to come and go then you
plug in/out cables/modules. That's why we have split implemented as we
do. I don't understand why do you think linecards are different.

Plus, I'm not really sure that our hw can report the type, will check.
One way or another, I think that both configuration flows have valid
usecase. Some user may want pre-configuration, some user may want auto.
Btw, it is possible to implement splitter cable in auto mode as well.


>
>> >If the device really needs this configuration / can't detect things
>> >automatically, then we gotta do something like what you have.
>> >The only question is do we still want to call it a line card.
>> >Sounds more like a front panel module. At Netronome we called 
>> >those phymods.  
>> 
>> Sure, the name is up to the discussion. We call it "linecard"
>> internally. I don't care about the name.
>
>Yeah, let's call it something more appropriate to indicate its
>breakout/retimer/gearbox nature, and we'll be good :)

Well, it can contain much more. It can contain a smartnic/fpga/whatever
for example. Not sure we can find something that fits to all cases.
I was thinking about it in the past, I think that the linecard is quite
appropriate. It connects with lines/lanes, and it does something,
either phy/gearbox, or just interconnects the lanes using smartnic/fpga
for example.

