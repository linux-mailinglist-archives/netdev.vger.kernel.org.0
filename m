Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88714A648E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242235AbiBATEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242224AbiBATD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:03:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C66DC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 11:03:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id qe6-20020a17090b4f8600b001b7aaad65b9so3561747pjb.2
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 11:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1d8zXu3tuf0PmJ/glVNKFoN845j55t2V2/9bPyCks5I=;
        b=AefvwQDjHzweH2G38T+f3THM2piIouMgbQeSaRxzhN2HsLYG6HFHX/kSUkFv/BEcea
         789k4HuTe7TqX1yO4pJEcyF7sI64Oncj6El56DtyG6hp15QmiTVNZTTaIIL4Rr/XT8c9
         35p1KUl54jmHbEl2rDbbG/5LsSFNF1zRvbPSWmjteH51923LKtEZ45Eak3jyqSr6d0fr
         E8tgd75FF5t+VLd34AbzCRhwrzbvhJXbWVg5uteurozn0WHIeJ+etVpDp6LcxXDUGUdr
         JrwDwQDkirr1sjKi5uHOtQlrOdhTWb7v3iYeEpmzI+J9Hs0Mr1u5oD95d+V8yv/J8pAe
         tIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1d8zXu3tuf0PmJ/glVNKFoN845j55t2V2/9bPyCks5I=;
        b=7yPJJfbaL3jChFiNvjQomf/pQdIKgUWEgRZcbAvFc3qV7Nx1OVjjPC8kZX3XsI7Pb6
         8oky2ZDHO+SooJh0iZRUXuf8HBuFUQXHMVM9htHiCYSA3LkcLIWp3cULpaFd+OSk5Me3
         AyQN7okz3kxr/rCgPnuHkoJkw5IQs5Lk7SbYSSuO1EB5xwrQzwM9vq9x/PhmfYHMlq5N
         zV4LDeOLowcAvbn4gDpi/MuYWTRPsoFXO69MeJdqh3bUYQg/yNWTQhuvvmla4ccM8tU9
         nB4vQJeyHUT7qXBmcJdMzjkn5x23SeiPE8sDFCASdOB383y8W+iycIMVroMJrhNrwhCg
         nzmw==
X-Gm-Message-State: AOAM533AgiCpE1kRGyb7XP0r4XrA6i3KBwv7DgEriVYETPG2kzW+Fgcy
        23ae9kKW1YDevEBuX420xaU=
X-Google-Smtp-Source: ABdhPJzePusij6jw8mLSJz5/aeoTQNIm0zEZXJUkksZOVh5+fGFBtl6pct/2th12nBTs7yRtbIemTA==
X-Received: by 2002:a17:90b:4f8a:: with SMTP id qe10mr3915919pjb.168.1643742238529;
        Tue, 01 Feb 2022 11:03:58 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id mv10sm3457280pjb.45.2022.02.01.11.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 11:03:58 -0800 (PST)
Date:   Tue, 1 Feb 2022 11:03:51 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <20220201190351.GA7009@hoboy.vegasvil.org>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
 <20220127220116.GB26514@hoboy.vegasvil.org>
 <Yfe4FPHbFjc6FoTa@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfe4FPHbFjc6FoTa@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 11:21:08AM +0100, Miroslav Lichvar wrote:
> On Thu, Jan 27, 2022 at 02:01:16PM -0800, Richard Cochran wrote:
> > On Thu, Jan 27, 2022 at 12:45:36PM +0100, Miroslav Lichvar wrote:
> > > When a virtual clock is being created, initialize the timecounter to the
> > > current system time instead of the Unix epoch to avoid very large steps
> > > when the clock will be synchronized.
> > 
> > I think we agreed that, going forward, new PHC drivers should start at
> > zero (1970) instead of TAI - 37.
> 
> I tried to find the discussion around this decision, but failed. Do
> you have a link?

Here is one of the discussions.  It didn't lay down a law or anything,
but my arguments still stand.

   https://lore.kernel.org/all/20180815175040.3736548-1-arnd@arndb.de/

I've been pushing back on new drivers that use ktime_get isntead of
zero, but some still sneak through, now and again.
 
> To me, it seems very strange to start the PHC at 0. It makes the
> initial clock correction unnecessarily larger by ~7 orders of
> magnitude. The system clock is initialized from the RTC, which can
> have an error comparable to the TAI-UTC offset, especially if the
> machine was turned off for a longer period of time, so why not
> initialize the PHC from the system time? The error is much smaller
> than billions of seconds.

Who cares?  The size of the error is irrelevant, because the initial
offset is wrong, and the action of the PTP will correct it, whether
large or small.

Thanks,
Richard
