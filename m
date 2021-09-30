Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B27941DC65
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350339AbhI3OhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348440AbhI3OhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:37:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1A4C06176A;
        Thu, 30 Sep 2021 07:35:31 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t11so4144429plq.11;
        Thu, 30 Sep 2021 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lYJPRniTRBZbff9MFqNleWr6TXhR2CJIGNuRoQ2wgy8=;
        b=XQEYgilh70OAlHfZfNiT4UE+CVMlUBQBBEfmJuQpsArcbqLTUq2qLCSTq3g+lPTSuA
         dsil27f5oQCy6Hg5aa+KT279e0Zeli5QMjLxeCUfpExxRMcIttaoa/SArfrgd0L7QeDt
         mfDKQesUR1GNj5IQhtH5ailEAiefK2xyc2iA9qr7bKOlbC+AIpNDBmGB+OJMJ654bdBs
         oRxExW0W3xlZF8SvT/AW6pnx7pdQ3jTfnxDto7MwUygnBoLsE4wygMbnmM0r20jPLdZC
         rUn4GC2A9kzWvE1vXEif7hDxMrSX1heB5xMZEBfAR+h3FgM91M3BYcqQ5PcRaT25ebk0
         QR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lYJPRniTRBZbff9MFqNleWr6TXhR2CJIGNuRoQ2wgy8=;
        b=pvp4M+chC2WEYc16DCsE75K69ornul7PrT1So9WgRJK7hkC24N5AjYroYGKeJkN+P5
         D7qdyiExao5Srlr5Wd/UnV+atGq7hCPy5ddN82HMZMH3Ztng6XgirkoG8rqbhKgDIw+E
         NfUSdaeY4kD4TWYgvQ5frmRYcaJg36gD+v6hWboWpd9lYzjfuikbBcJ5Z0rjWJNQ47UQ
         srS4Cer5Pwd87o2Oo/ZlXGlste4X09AhA0GFK5eRdnglMLFQ7576t16XpCpoqhKvWsKk
         AG0+RUrF5AOqEjh8aBGQM1jD9S+qHJvU6amGV7Fp0dsnHSND4KtlNXE/Xr86osvHvctR
         779Q==
X-Gm-Message-State: AOAM533oN/ULwVoSSB1bzHir4XNbwU2Sb6JgDiWs8zmGgTCkCoOhSSnJ
        hoO+xCqvAOLqby16LEI/abs=
X-Google-Smtp-Source: ABdhPJzOYNarPIvIznW68ec40qAzjkKpHUN+ruoL95o7U+ATJK1Bqw1yOg5bN+fboQvyHOo6Hz2vlg==
X-Received: by 2002:a17:90a:db95:: with SMTP id h21mr13615635pjv.102.1633012530501;
        Thu, 30 Sep 2021 07:35:30 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d5sm2966317pjs.53.2021.09.30.07.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 07:35:29 -0700 (PDT)
Date:   Thu, 30 Sep 2021 07:35:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20210930143527.GA14158@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
 <20210927145916.GA9549@hoboy.vegasvil.org>
 <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 05:00:56PM +0200, Sebastien Laveze wrote:
> On Tue, 2021-09-28 at 06:31 -0700, Richard Cochran wrote:
> > On Tue, Sep 28, 2021 at 01:50:23PM +0200, Sebastien Laveze wrote:
> > > Yes that would do it. Only drawback is that ALL rx and tx timestamps
> > > are converted to the N domains instead of a few as needed.
> > 
> > No, the kernel would provide only those that are selected by the
> > program via the socket option API.
> 
> But _all_ timestamps (rx and tx) are converted when a domain is
> selected.

So what?  It is only a mult/shift.  Cheaper than syscall by far.

> If we consider gPTP,
> -using the ioctl, you only need to convert the sync receive timestamps.
> PDelay (rx, tx, fup), sync (tx and fup) and signalling don't need to be
> converted. So that's for a default sync period of 125 ms, 8 ioctl /
> second / domain.

Well, today that is true, for your very specific use case.  But we
don't invent kernel interfaces for one-off projects.

> -doing the conversion in the kernel will necessarly be done for every
> timestamp handled by the socket. In addition, the vclock device lookup
> is not free as well and done for _each_ conversion.

Sounds like something that can be optimized in the kernel implementation.

> From a high-level view, I understand that you would have N
> instance/process of linuxptp to support N domains ?

Yes.

> CMLDS performed by
> one of them and then some signalling to the other instances ?

Yes, something like that.  One process measures peer delay, and the
others read the result via management messages (could also be pushed
via ptp4l's management notification method).
 
> What we miss currently in the kernel for a better multi-domain usage
> and would like to find a solution:
> -allow PHC adjustment with virtual clocks. Otherwise scheduled traffic
> cannot be used... (I've read your comments on this topic, we are
> experimenting things on MCUs and we need to assess on measurements)

Yeah, so you cannot have it both ways, I'm afraid.  Either you adjust
the HW clock or not.  If you don't, it becomes impractical to program
the event registers for output signals.  (Time stamps on input signals
are not an issue, though)

> -timer support for virtual clocks (nanosleep likely, as yous suggested
> IIRC).

Right, and this is (probably) difficult to sell on lkml.  Look at the
hrtimer implementation to see what I mean.

I could imagine adding one additional hrtimer base under user space
control that isn't clock_monotonic or _realtime or _tai, but not N new
bases.

I think the best option for user space wanting timers in multiple
domains is to periodically do 

   gettime(monotonic); gettime(vclock); gettime(monotonic);

figure the conversion, and schedule using clock_monotonic.


HTH,
Richard

