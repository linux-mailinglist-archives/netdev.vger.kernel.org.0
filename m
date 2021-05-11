Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF7637AB20
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhEKPu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhEKPu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 11:50:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC33C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:49:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b21so11062284plz.0
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6Yw3y6YctXCbwYCAEhABs2MPb9zSsZH8Xaovo5cWgm4=;
        b=VRV73auLceMwvABY40DqJXQdj5buWQn4AHlJ+FI9PP95b+uOPeBC3d2iS6tta2WRUm
         nLWUeLPoLNU1bHcr59DEDZbhLuZ7Syg3vK4dpXBg2yk7xPlorVfd53Lz5EcFhNri7Ub5
         TThJ/+/30bduj94suHOMMT/mgkDVYW6LDmNKTuW1wX27Su0LOfR2RIBtUDLPeSEwYgwl
         lCntdEUPvkrkjEauiesnhuXXnw6RaiVincU1ER7tBNDwrgK/r9vkVZNShX+7xcmKLfIe
         /7sQrVUTa2vHyPtXG6J4VkGf1yfe4G6lTM+oN0MlqxtwdI9Y8yfEPvPATFLfqoIn/BBq
         ojuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6Yw3y6YctXCbwYCAEhABs2MPb9zSsZH8Xaovo5cWgm4=;
        b=epABd4SFSmfBL2mE430lF4xnpALx83NuMHArsj3xDt/NpTsluEFvzNJ8EwLKTNfZcn
         h1rH5PgqH1cNgwQ1ktSzIJ7ZC1YyLkYbRIsH1muYb7O6+RixaaQm5R7aZNDNs8Da2tQd
         VXFNud1zgDL7bd1jGtvZ9THrnUWT3u9E7zyTBdkR8x7Ptv5R7JNBeWcLmIiO9bODjta9
         QWhQchPUwFLYKuPxDpBYds6x1v9r6wmWRmvyheZyqbHfxWMUOQniW7TfPw6NsmJrkZHl
         l4xaQlUbghTo6dNGWCw0djy1NrjGWIcW4Luaer4NsYjTaegIWA4vZVkg94hRpebdUq/t
         Y2JQ==
X-Gm-Message-State: AOAM5335o/teiSs6N6whiy/r77sgFP/akLGUcmKnBsaUjZlgIaMBwjPZ
        E55rhsFSwUcyhi0U1QTo3cQ1gUceixs=
X-Google-Smtp-Source: ABdhPJzOBkxaQERJ6/mK3+L+F6bBjJH9xNPQbne3/9rT2aXYC5Jb7dVouW0Vrp9eCfUgxIHYw6dZTQ==
X-Received: by 2002:a17:90a:5d14:: with SMTP id s20mr33619278pji.185.1620748191375;
        Tue, 11 May 2021 08:49:51 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i24sm13693737pfd.35.2021.05.11.08.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 08:49:50 -0700 (PDT)
Date:   Tue, 11 May 2021 08:49:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next 0/6] ptp: support virtual clocks for multiple domains
Message-ID: <20210511154948.GB23757@hoboy.vegasvil.org>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210508191718.GC13867@hoboy.vegasvil.org>
 <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210510231832.GA28585@hoboy.vegasvil.org>
 <DB7PR04MB501793F21441B465A45E0699F8539@DB7PR04MB5017.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB501793F21441B465A45E0699F8539@DB7PR04MB5017.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 10:40:15AM +0000, Y.b. Lu wrote:
> What I thought was in code writing registers to adjust physical clock frequency, and immediately adjusting virtual clocks in opposite direction.
> Make the operations atomic by locking. Assume the code execution has a DELAY, and the frequency adjusted is PPM.
> Then the time error affecting on virtual clock will be DELAY * PPM. I'm not sure what the DELAY value will be on other platforms.
> Just for example, for 1us delay, 1000ppm adjustment will have 1ns time error.
> 
> But indeed, this approach may be not feasible as you said. Especially it is adjusting clock in max frequency, and there are many virtual clocks.
> The time error may be large enough to cause issues. (I'm not sure whether I understand you correctly, sorry.)

You understand correctly.

> So, a question is, for hardware which supports only one PTP clock, can multiple domains be supported where physical clock also participates in synchronization of a domain?
> (Because sometime the physical clock is required to be synchronized for TSN using, or other usages.)
> Do you think it's possible?

No, it won't work.  You can't adjust both the physical clock and the
timecounters at the same time.  The code would be an awful hack, and
it would not work in all real world circumstances.  If the kernel
offers a new time service, then it has to work always.

So, getting back to my user space idea, it _would_ work to let the
application stack control the HW clock as before, but to track the
other domains numerically.  Then, the other applications could use the
TIME_STATUS_NP management message (designed for use with gPTP and
free_running) to get the current time in the other domains.

So take your pick.  You can't have it both ways, I'm afraid.

> > In addition to that, you will need a way to make the relationships between the
> > clocks and the network interfaces discoverable.
> 
> Agree. This should be done carefully and everything should be considered.
> Will converting physical clock ptp0 to virtual clock ptp0 introduce more effort to implement,
> comparing to keep physical clock ptp0 but limit to use it?

I think either way, it would be a substantial change in the kernel
code.

> > It needs more thought and careful design, but I think having
> > clock_gettime() available for the different clocks would be nice to have for the
> > applications.
> 
> Thank you. Then regarding the domain timestamp, do you think it's proper to do the conversion in kernel as I implemented.

Yes, it would be very nice for the applications, because they wouldn't
have to use a different API for gettime().

The drawback is that you loose the ability to generate synchronized
signals in HW from the physical clock.

(Time stamping inputs would still work, because the timecounter code
cleverly allows that.)

Thanks,
Richard
