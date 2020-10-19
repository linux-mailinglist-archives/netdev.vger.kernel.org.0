Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938FA292728
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgJSMYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJSMYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:24:31 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9073FC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:24:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a72so10072974wme.5
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fV6aDJT9SCLWBKgibQdt925gka8bWxfaTxdU1yxURVc=;
        b=xPhmD6RDgC2Y1b9G1hf8Aa66xzW5ZhLmWUGSvqGgIusk8tGLo4g1lmLp6IDjDVzpdm
         0X3IGamDr2+kO0kKqQWAXrUMXbhkG4XCJcA2k9qjpLfrF2NqG+dDz1I3uO/c8ra1Qr4A
         Kd292ZneX6ThfHrC4gjX6OSr9CcwsB6OVeRT/ayvtW47BGIKbpAchI50Je9vg72N2FTo
         XpxVm41NxmS9kYHkoRGaabk3zB8M9aT6GDvWq7AZLievsk3CVAaPJ3mRJ7uMyWK9h/Pf
         xPEL3ELkyzy5tMcB2FTZ6KDSW0nquhXUf75SvJRJ8mQZDQdP3DnJ3+bykbM33UmNmNRm
         ucAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fV6aDJT9SCLWBKgibQdt925gka8bWxfaTxdU1yxURVc=;
        b=K0aanCjgBlGrP0xbn7zNAkMfVENcpoZp4MVh5l3gx1YWLds6thCGS0MqDPyQ6rHC+u
         Hgat4TejdNOIYeu9nAMI3325hH4F2ceGkMLVSD7PdpA0Cw+PYHTdNCsjBJoVbv7Z4qA5
         Oc9EVif+6IcP6fdYSRedhm5xTNvS/4YxI+aR7t1z4y91ip/iQ7xIdAILLCpVb6PPKrzv
         Y4OsFVKXbXpI090vIl/UdIEKvAm7Ly9vzxpV0+KDZsPlseboeI5Yy5m4J7+n/eG11PBg
         mSXRM6SEtMSUpFJXRzFLBUu61zYVj0+LuWy5aIWoKVMDqZFCi0kk+AyYdGnyWFE1WHhE
         HdiQ==
X-Gm-Message-State: AOAM530Nrr9DrLQimEsf9TL0Y32L152RXg7LpDLmm0ETOpOFxf8jNo1k
        JvOplz4POG3WM2gy43FTSuVBeg==
X-Google-Smtp-Source: ABdhPJy7Ywf6WjeuOkbTQPu40S/5XtMjEqjhnWIU6ZYwcM3ElgnXDbFrzzTbNcNBOFvMNZ9KI+s0mQ==
X-Received: by 2002:a1c:5641:: with SMTP id k62mr16701791wmb.108.1603110270362;
        Mon, 19 Oct 2020 05:24:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 205sm16799284wme.38.2020.10.19.05.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 05:24:29 -0700 (PDT)
Date:   Mon, 19 Oct 2020 14:24:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201019122428.GB11282@nanopsycho.orion>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016221553.GN139700@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 17, 2020 at 12:15:53AM CEST, andrew@lunn.ch wrote:
>> Example:
>> - swp1 is a 200G port with 4 lanes.
>> - QSFP28 is plugged in.
>> - The user wants to select configuration of 100G speed using 2 lanes, 50G each.
>> 
>> $ ethtool swp1
>> Settings for swp1:
>>         Supported ports: [ FIBRE         Backplane ]
>>         Supported link modes:   1000baseT/Full
>>                                 10000baseT/Full
>>                                 1000baseKX/Full
>>                                 10000baseKR/Full
>>                                 10000baseR_FEC
>>                                 40000baseKR4/Full
>>                                 40000baseCR4/Full
>>                                 40000baseSR4/Full
>>                                 40000baseLR4/Full
>>                                 25000baseCR/Full
>>                                 25000baseKR/Full
>>                                 25000baseSR/Full
>>                                 50000baseCR2/Full
>>                                 50000baseKR2/Full
>>                                 100000baseKR4/Full
>>                                 100000baseSR4/Full
>>                                 100000baseCR4/Full
>>                                 100000baseLR4_ER4/Full
>>                                 50000baseSR2/Full
>>                                 10000baseCR/Full
>>                                 10000baseSR/Full
>>                                 10000baseLR/Full
>>                                 10000baseER/Full
>>                                 50000baseKR/Full
>>                                 50000baseSR/Full
>>                                 50000baseCR/Full
>>                                 50000baseLR_ER_FR/Full
>>                                 50000baseDR/Full
>
>>                                 100000baseKR2/Full
>>                                 100000baseSR2/Full
>>                                 100000baseCR2/Full
>>                                 100000baseLR2_ER2_FR2/Full
>>                                 100000baseDR2/Full
>
>I'm not sure i fully understand all these different link modes, but i
>thought these 5 are all 100G using 2 lanes? So why cannot the user
>simply do
>
>ethtool -s swp1 advertise 100000baseKR2/Full
>
>and the driver can figure out it needs to use two lanes at 50G?

100000baseKR2 is 2 lanes. No need to figure anything out. What do you
mean by that?

>
>    Andrew
