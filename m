Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8617B44E26A
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhKLHl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 02:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbhKLHlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 02:41:50 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5083FC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:38:59 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r8so13916077wra.7
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=elmtw5JKXy45qzIUIcO3QrJwyTUW9zlTA4B18c8yXdg=;
        b=c5C8KKaiq3Oroq/valkhfXoOl8O8ca0Ce7MNiP5wzrJcfz5MiB+FOwwHSrS1dGCWhG
         Z5nhjv0CRCGxcIPkQjC77njo1G/glCmhS7bICEQ/JcDZVDrEVHpknfw1+vFIXkDGuY17
         rpwGM+9U1JtO+QIjCCbyT643q8d+J2P/fjOKEaJsHZCNuP1Iljh5fRYhYcpfiWKZLM1/
         Mec3JSJRnQTVtA3XeIvYcenaaBPFe5vD2f2AgTkyNTHj1cZPv6ddJJeEyb0Ts5XlDlbG
         OLLaJpjPykEZy9dWzK6f04zFi8K4xIEu/VIbUo0z2Zqrweq5IhDhuHhQGtx/EYU1f7CN
         dvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=elmtw5JKXy45qzIUIcO3QrJwyTUW9zlTA4B18c8yXdg=;
        b=IhKA3f79TSDJ8TlVm9k4ugy5EiWg9zxcAn4UmSmkcHVHr+zuQqirrZMThZsF2lNSwg
         LEqOVWuVRIlP3R0RO563zcaZy4yD2DPjX6iGAZs76n6g+TBXqBl2W1b2FE3O9mueEpy7
         JCMVcK3Il6CVQflTpgRcd/ft2Q8cxghKwH41qkwFYxwhTIdr9Loi3L4eeZfbXMwPeAZe
         TaQMNMGR8ddKsXLBW0fhLOo44JgtV9tszEO+TuIqpUsd81QK+l2vdPi006ACXA8pkeCh
         X7AIh4wtUE7JFotHSDdsAe7k0SPrYzn+UDGJqCU1JvV/APs5WuVhpo7ZqLcEokZ2jtEI
         gwFQ==
X-Gm-Message-State: AOAM532m85g09RUTyK4DZhmdc2AHRvdyCpgWQWaEL6MJ0wcccSogwpmo
        IkGY/XO0Tme/N2ZdVA+Hped1z3xISmEGiLpVNN4=
X-Google-Smtp-Source: ABdhPJw9IHWhmplvaIJHx7aDpyprzWyYudlCeJnWRB/SxgO/vVdHfQLW53AWzqWwZCX/BpLJIlWRXg==
X-Received: by 2002:adf:f88c:: with SMTP id u12mr16645205wrp.29.1636702737927;
        Thu, 11 Nov 2021 23:38:57 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s13sm11485803wmc.47.2021.11.11.23.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 23:38:57 -0800 (PST)
Date:   Fri, 12 Nov 2021 08:38:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YY4aEFkVuqR+vauw@nanopsycho>
References: <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY0J8IOLQBBhok2M@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 11, 2021 at 01:17:52PM CET, leon@kernel.org wrote:
>On Thu, Nov 11, 2021 at 01:05:11PM +0100, Jiri Pirko wrote:
>> Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
>> >On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
>> >> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
>> >> > > > I once sketched out fixing this by removing the need to hold the
>> >> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
>> >> > > > over the devlink reload paths. It seemed like a reasonable step toward
>> >> > > > finer grained locking.  
>> >> > > 
>> >> > > Seems to me the locking is just a symptom.  
>> >> > 
>> >> > My fear is this reload during net ns destruction is devlink uAPI now
>> >> > and, yes it may be only a symptom, but the root cause may be unfixable
>> >> > uAPI constraints.
>> >> 
>> >> If I'm reading this right it locks up 100% of the time, what is a uAPI
>> >> for? DoS? ;)
>> >> 
>> >> Hence my questions about the actual use cases.
>> >
>> >Removing namespace support from devlink would solve the crasher. I
>> >certainly didn't feel bold enough to suggest such a thing :)
>> >
>> >If no other devlink driver cares about this it is probably the best
>> >idea.
>> 
>> Devlink namespace support is not generic, not related to any driver.
>
>What do you mean?
>
>devlink_pernet_pre_exit() calls to devlink reload, which means that only
>drivers that support reload care about it. The reload is driver thing.

However, Jason was talking about "namespace support removal from
devlink"..


>
>Thanks
>
>> 
>> >
>> >Jason
