Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC94A64AD
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiBATKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiBATKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:10:49 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0818C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 11:10:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id j10so16230534pgc.6
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 11:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7t7ALTdh7Ppeybwpj8PcPIYayRUvHKINDo+m4qdsdMs=;
        b=l8cPoYUUEDNtTgVpqsfREwtzQs6f1td0KnwnvZ/VzXJY4utnsBHUzVKxso4DQt5/LX
         fch4RUKPJ+cl2qRWSkRjlRkpxxVvQGU2y209dLayRGY5pMtK3nt8JTI00cxcoK8iB/tP
         R4rPy9EZuX8Oc2OJJgyTe1uzIWT8FcqV9ucPcN6i3gZBtODoUyIefbecDHfIZD8gQr38
         J2Z512zgG3QTJrhvsSyscEXWfuo/93nu3i9yzvhGmUmaxJ4n1153+wWSfZJSqItQvoJc
         Ud5XcJfqghM17U/Q11mDX501xyzj7s3zGhXv4j1BwQUV5ecqXcIHl8K5RZDqCgpilGa/
         9SPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7t7ALTdh7Ppeybwpj8PcPIYayRUvHKINDo+m4qdsdMs=;
        b=W6rAwpnSMQLZ0/wdgikYIudgXarW7ohNhdeBLisGlM3T3wbuxzKqbUb64vw47/xCRm
         GlyGBD/NlSu38h4Mwpk92xqHr/uVbmoab7NSvRYH82FwUocOxIkHVhlTxH+lQhH13t8P
         NvJQX906SlhadmT/TuzGGcYSHkJ6b7T1XOw2evfQ11aCO9GjWBZSCDlF5oWprE7GmJsC
         V4xXZ8DIgeRwxYMSjF7VnlXtL/ZGi+7vEa3gybsCo8DJekDLkEoE+sbuSo6E+xLTbKX3
         IvCiR/se4EVxvk8vPpxVIi8wsamqSW3xn48N60EgwlCR6cVzSXgfJH7j/qm8x8porHyK
         p1VQ==
X-Gm-Message-State: AOAM530cGhnFQDyssOZ3yYJdi22RPKY/L1A4C+GlofzmyeNg6fqJdVPu
        n22+a7Fa9VxkFcMkzkPLvvIiiEttcKDlpA==
X-Google-Smtp-Source: ABdhPJwKAb7So6AaQKyJrxbqw/9VaeD0bumSO1kh9x12SFTfeqJH2y8poK2wetpHehTDM1aYi0/EpA==
X-Received: by 2002:a63:e704:: with SMTP id b4mr21748440pgi.315.1643742648527;
        Tue, 01 Feb 2022 11:10:48 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 6sm11449750pgx.36.2022.02.01.11.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 11:10:48 -0800 (PST)
Date:   Tue, 1 Feb 2022 11:10:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <20220201191041.GB7009@hoboy.vegasvil.org>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
 <20220127220116.GB26514@hoboy.vegasvil.org>
 <Yfe4FPHbFjc6FoTa@localhost>
 <20220131163240.GA22495@hoboy.vegasvil.org>
 <YfjyX893NV2Hga35@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfjyX893NV2Hga35@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 09:42:07AM +0100, Miroslav Lichvar wrote:
> On Mon, Jan 31, 2022 at 08:32:40AM -0800, Richard Cochran wrote:
> > On Mon, Jan 31, 2022 at 11:21:08AM +0100, Miroslav Lichvar wrote:
> > > To me, it seems very strange to start the PHC at 0. It makes the
> > > initial clock correction unnecessarily larger by ~7 orders of
> > > magnitude. The system clock is initialized from the RTC, which can
> > > have an error comparable to the TAI-UTC offset, especially if the
> > > machine was turned off for a longer period of time, so why not
> > > initialize the PHC from the system time? The error is much smaller
> > > than billions of seconds.
> > 
> > When the clock reads Jan 1, 1970, then that is clearly wrong, and so a
> > user might suspect that it is uninititalized.
> 
> FWIW, my first thought when I saw the huge offset in ptp4l was that
> something is horribly broken. 

Yes, that is my point!  Although you may have jumped to conclusions
about the root cause, still the zero value got your attention.

It is just too easy for people to see the correct date and time (down
to the minute) and assume all is okay.
 
> I'd prefer smaller initial error and consistency. The vast majority of
> existing drivers seem to initialize the clock at current system time.
> Drivers starting at 0 now create confusion. If this is the right way,
> shouldn't be all existing drivers patched to follow that?

I agree that consistency is good, and I would love to get rid of all
that ktime_get usage, but maybe people will argue against it for their
beloved driver.

Going forward, I'm asking that new drivers start from zero for an
"uninitialized" clock.

Thanks,
Richard
