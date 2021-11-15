Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4E245034D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKOLX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 06:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhKOLXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 06:23:21 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331FEC061766
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 03:20:24 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so12095987wmb.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 03:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dM9DRPgSpJ0jYURWvDVlbmzfJrqC6EeymCjwHEDZ6Es=;
        b=xOD0AkPy2gwLWVAKrrvHs32rV78rbaPL2H73G5vr1U7KZToCSz6p8Rq5/Fb7N4JG08
         TV5RsRwS5HOWrf2coQN+Eh4dXDHf30y4l4JJacFNzB/hyRZPZruRawHAhBzcUeBvcDK3
         8iGBdem8Yy+s7rnZp1BlM2/pZRn20b0jI3HW9je2YyhS/jGw1xojFDA8U0IdktOwJOiL
         zKK2gx/fp8DmK8gRttrY9e33y5O+6CPfv+WLUUkhvJ5oH0CYelVoz4m45WUEi/4NW4kj
         Kce8QNtsMKuUCnVj4g6NM5hEh7vFlySUJ1NevVg2LCHRFkgWWZo+s8qA2ZvhjN9dv9QS
         3c4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dM9DRPgSpJ0jYURWvDVlbmzfJrqC6EeymCjwHEDZ6Es=;
        b=bsw4iymR08revmkjSVJVhP58PDHMV8d2Nu0evBzaeSOuEFKpSfvMD1jhznYzxI05z0
         6mFn45UCHChRrvePNtngIZSX8i59HPA6zzmijasn0x2c09n9Q+f+Mr1n2wUFybqXUsfD
         yOAf6n42t9DOADmjLEVbRQz6l8opik27Kz55aWRQuYqDw0taW5mmD7V/nEsqk1aItkcJ
         4k4hEIZhmzBbhO8Pd3pyFLd5L7olK6dhPoZoUkJrhqGhu0kjUL59WWU/tgKAnlr+yI5Z
         eG4ofC+WUqzHVCWl05LCKoVf7sjWbgs5ybLG3oQb6yMMmS7KHY9jw2xJ+u1rCO/2u+NN
         hhyQ==
X-Gm-Message-State: AOAM5301ByeZr4AWjLm4icLa994+TJOZtRn297MsjvqO6g+4Rbi5sdY3
        3VhbVHIGsGkjTqcZ1eAb51jGhA==
X-Google-Smtp-Source: ABdhPJzYi8iIhkZycZ6PrR6eG5g7mUUosggXB1jNrJ6nd0jrj7CHwHF6FPbvwqNTXObdzBkNXznpHQ==
X-Received: by 2002:a1c:9842:: with SMTP id a63mr58984430wme.102.1636975223009;
        Mon, 15 Nov 2021 03:20:23 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z7sm19191262wmi.33.2021.11.15.03.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 03:20:22 -0800 (PST)
Date:   Mon, 15 Nov 2021 12:20:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YZJCdSy+wzqlwrE2@nanopsycho>
References: <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
 <YZCqVig9GQi/o1iz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZCqVig9GQi/o1iz@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Nov 14, 2021 at 07:19:02AM CET, leon@kernel.org wrote:
>On Fri, Nov 12, 2021 at 08:38:56AM +0100, Jiri Pirko wrote:
>> Thu, Nov 11, 2021 at 01:17:52PM CET, leon@kernel.org wrote:
>> >On Thu, Nov 11, 2021 at 01:05:11PM +0100, Jiri Pirko wrote:
>> >> Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
>> >> >On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
>> >> >> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
>> >> >> > > > I once sketched out fixing this by removing the need to hold the
>> >> >> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
>> >> >> > > > over the devlink reload paths. It seemed like a reasonable step toward
>> >> >> > > > finer grained locking.  
>> >> >> > > 
>> >> >> > > Seems to me the locking is just a symptom.  
>> >> >> > 
>> >> >> > My fear is this reload during net ns destruction is devlink uAPI now
>> >> >> > and, yes it may be only a symptom, but the root cause may be unfixable
>> >> >> > uAPI constraints.
>> >> >> 
>> >> >> If I'm reading this right it locks up 100% of the time, what is a uAPI
>> >> >> for? DoS? ;)
>> >> >> 
>> >> >> Hence my questions about the actual use cases.
>> >> >
>> >> >Removing namespace support from devlink would solve the crasher. I
>> >> >certainly didn't feel bold enough to suggest such a thing :)
>> >> >
>> >> >If no other devlink driver cares about this it is probably the best
>> >> >idea.
>> >> 
>> >> Devlink namespace support is not generic, not related to any driver.
>> >
>> >What do you mean?
>> >
>> >devlink_pernet_pre_exit() calls to devlink reload, which means that only
>> >drivers that support reload care about it. The reload is driver thing.
>> 
>> However, Jason was talking about "namespace support removal from
>> devlink"..
>
>The code that sparkles deadlocks is in devlink_pernet_pre_exit() and
>this will be nice to remove. I just don't know if it is possible to do
>without ripping whole namespace support from devlink.

As discussed offline, the non-standard mlx5/IB usage of network
namespaces requires non standard mlx5/IB workaround. Does not make any
sense to remove the devlink net namespace support removal.


>
>Thanks
>
>> 
>> 
>> >
>> >Thanks
>> >
>> >> 
>> >> >
>> >> >Jason
