Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84781292742
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgJSM0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgJSM0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:47 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD44C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:26:46 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d81so10111083wmc.1
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V0zAxCPlRmLbxbHjlMHtswZLUtOTvqHnkFGmoI6YI0Y=;
        b=V11gNrERTPki6WSvrLtSIZkUjb0gKQZkUxYv6cmODEUcPdYHnDlnYl2PaHf4SJUmoi
         HIYgEdQz9Ltl0/7dzNl/ySK+67T9ouXvWffIomDIaz6lnvKBAoQVZJ2meMfqd9W9CePG
         89TIvYtuqT/Vr5xnSeMZ+l0gK0gFOhsn3Ci5/VLLX1Gsl3ucp8ikh8YuHnhAEVOSH2Go
         /PaXkJpNq8rIpiR2wSuXIbH5pFfB7wNuXVHtOo1hrs8AsEcyCLf+DLMl8y60tVsczX4b
         NkwXC+fS2SdQsxT7Adz7RAtui0Yb0TQli4mz9FljH7dBXI6YPu++ZxdbPVnP4xLlB/Q+
         Ahiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V0zAxCPlRmLbxbHjlMHtswZLUtOTvqHnkFGmoI6YI0Y=;
        b=KC3ghrdoTLOMj8uE94RbEAi+ik+alnanqvhQbs6sGRmgBT1Ndba/zOjwqB03BykiaJ
         Yuq8BJ79XrAoE+A3UcY++yc+EBX/RmcSh34SbDbLfVQEjT49i9O3jRSMbWMDOG6E9axn
         igK/9EmvlJ2zx6gLR6t29eWe9Upugk5i/pNGeOmOEwWqZtB+vtEhq+DgX1y7+JCs7oGb
         YVVSbYQnxRsy75IRUsDb3q9y+IDlAwuxkki/k5Z2Y6XpFw3NbOBWczsSvm52/xJCGgme
         1cyrecw96434qShts+0pjsCOvthoBsqOXykito3C6Ict1iaH3ThGpknzFUsozRd8Ocji
         eGEg==
X-Gm-Message-State: AOAM532OEEIX5oSnbmicvmo6QPpsFWn2IrwADcP+GTNiTSHhq9QtSaCw
        0BQwy17r/3R1g9QuzPeWZSQDTA==
X-Google-Smtp-Source: ABdhPJyqezKU0itTvTLeoWK1FGpT6tnRVvPcJnuPfNl1GieXDRjxtYkjXq9q3/kehCCTnCcBk+Ufpw==
X-Received: by 2002:a1c:9854:: with SMTP id a81mr17882009wme.72.1603110405259;
        Mon, 19 Oct 2020 05:26:45 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q10sm13287775wme.2.2020.10.19.05.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 05:26:44 -0700 (PDT)
Date:   Mon, 19 Oct 2020 14:26:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201019122643.GC11282@nanopsycho.orion>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 19, 2020 at 01:04:22PM CEST, mkubecek@suse.cz wrote:
>On Mon, Oct 19, 2020 at 07:19:34AM +0000, Danielle Ratson wrote:
>> > -----Original Message-----
>> > From: Andrew Lunn <andrew@lunn.ch>
>> > Sent: Saturday, October 17, 2020 1:16 AM
>> > 
>> > I'm not sure i fully understand all these different link modes, but
>> > i thought these 5 are all 100G using 2 lanes? So why cannot the user
>> > simply do
>> > 
>> > ethtool -s swp1 advertise 100000baseKR2/Full
>> > 
>> > and the driver can figure out it needs to use two lanes at 50G?
>> > 
>> >     Andrew
>> 
>> Hi Andrew,
>> 
>> Thanks for the feedback.
>> 
>> I guess you mean " ethtool -s swp1 advertise 100000baseKR2/Full on".
>> 
>> First, the idea might work but only for auto negotiation mode, whereas
>> the lanes parameter is a solution for both.
>> 
>> Second, the command as you have suggested it, wouldn't change anything
>> in the current situation as I checked. We can disable all the others
>> and leave only the one we want but the command doesn't filter the
>> other link modes but it just turns the mentioned link modes up if they
>> aren't. However, the lanes parameter is a selector, which make it much
>> more user friendly in my opinion.
>
>It would be quite easy to extend the ethtool command line parser to
>allow also
>
>  ethtool -s <dev> advertise <mode> ...
>
>in addition to already supported
>
>  ethtool -s <dev> advertise <mask>
>  ethtool -s <dev> advertise <mask>/<mask>
>  ethtool -s { <mode> { on | off } } ...
>
>Parser converting simple list of values into a maskless bitset is
>already there so it would be only matter of checking if there are at
>least two arguments and second is "on" or "off" and using corresponding
>parser. I think it would be useful independently of this series.

Understood. So basically you will pass some selectors on cmdline and the
uapi would stay intact.
How do you imagine the specific lane number selection should look like
on the cmdline?



>
>> Also, we can't turn only one of them up. But you have to set for
>> example:
>> 
>> $ ethtool -s swp1 advertise 100000baseKR2/Full on 100000baseSR2/Full on 100000baseCR2/Full on 100000baseLR2_ER2_FR2/Full on 100000baseDR2/Full on
>> 
>> Am I missing something?
>
>IIUC Jakub's concern is rather about real life need for such selectors,
>i.e. how realistic is "I want a(ny) 100Gb/s mode with two lanes" as an
>actual user need; if it wouldn't be mostly (or only) used as a quick way
>to distinguish between two supported 100Gb/s modes.
>
>IMHO if we go this way, we should consider going all the way, i.e. allow
>also selecting by the remaining part of the mode ("media type", e.g.
>"LR", not sure what the official name is) and, more important, get full
>information about link mode in use from driver (we only get speed and
>duplex at the moment). But that would require changes in the
>get_linksettings() interface and drivers.
>
>Michal
