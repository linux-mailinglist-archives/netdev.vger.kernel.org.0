Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232885F491B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJDSPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJDSPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:15:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A243F015
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 11:15:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a26so4809507pfg.7
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 11:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aurora.tech; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pjUcIfC4N+MJ+Ls6kt2gg2LjSDSZQ5bQdu/jOyN4X3I=;
        b=J8GqUqBDAGJ07n1VPd8kiTSe5+ZeiWtvwLsn8aMCy0Yd6NPn9du+TdMGwSCRDDH7N8
         FCahGQC8VdicvJwlUl1Wuhbiyh2VRLJI35aimx5rvhuYx/c0cCCaQ1nS6v+5Gaytu38/
         1txn+y9myuhv1qREwZTvqCH0WTXAIi1f+NHLXAyRk9C/Xxl2e1XpRKlyGS554bdzJ4o2
         Sq3Jc7VjTAsxLP9MrIiiHxhDruvq5mx6wRWvQKuK9SpeEI0sMSD6TBFWv4inE+X826+Q
         kJBwJycSPBT+i13AUQXoISrUQrHjAKUAlEKcD2g4MHr/6xjbGrbk5QrTZBwhMmrBNmxL
         KoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjUcIfC4N+MJ+Ls6kt2gg2LjSDSZQ5bQdu/jOyN4X3I=;
        b=hM2oQVLXBrTdvNq0b6mSu64UgXApjhzO9toAaupvh7jKd89T5k/YdaPsUIxbzZpctj
         7i9nboAZD0wsAe1f28QF2VStqzKhjbgNGP/0umxZ7RaL92oPe7af1idue5HzrdhA0HeU
         /+aTQUALDHa/77EBDnPhr9igwgn6t+a6l03fqh7DemjeFrv7ZtCySPBNKSE3D9I/3yzz
         NMMvmYn98n2VQop7a51S365QzJfdh1pS9iyjoIO4SPEo5BK6fIZt40FkMe8f+sf6dm/H
         EjI1UN85eKqAdffPGhV/CCzpaMRuJzYujoXIVlbgQwBTP0LO/MAkdDkXgmUU02BbvM7r
         e+cQ==
X-Gm-Message-State: ACrzQf1QRjcNaiZhngz1rkbsXbY2WY7svztmzvX02LaIv6G2DvQ15FtU
        hqKlw5WVLOEwmM8vufdCn9dmdG8LUsKLdVKvio2eZg==
X-Google-Smtp-Source: AMsMyM4z+7fWGuwn/DVhu6Gk40JZow3QaimXVBJC/i2MbMlaWcExb2uHkDg2CMrN09HkprckJRhI+yHDqsQyg4MUQQU=
X-Received: by 2002:a63:4283:0:b0:457:dced:8ba3 with SMTP id
 p125-20020a634283000000b00457dced8ba3mr511199pga.220.1664907301731; Tue, 04
 Oct 2022 11:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220801133750.7312-1-achaiken@aurora.tech> <CO1PR11MB508966EB7A3CF01A58553536D69A9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAFzL-7tX845o2kJmE4o8EhbeD-=vkR6rmaiz_ZEWfSD4W+iWEA@mail.gmail.com>
 <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
 <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com>
 <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com> <0048e66d-6115-4b71-0804-3a0180105431@intel.com>
In-Reply-To: <0048e66d-6115-4b71-0804-3a0180105431@intel.com>
From:   Alison Chaiken <achaiken@aurora.tech>
Date:   Tue, 4 Oct 2022 11:14:50 -0700
Message-ID: <CAFzL-7v-wLuaunUwKfEy0W+OMkKSXJ8ohecb8_Gok+=eQHdeAA@mail.gmail.com>
Subject: Re: Fwd: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
To:     anthony.l.nguyen@intel.com
Cc:     Steve Payne <spayne@aurora.tech>, jesse.brandeburg@intel.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jacob Keller <jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How about this Intel X550 PTP fix for 6.1?

https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20220801/029590.html

Thanks,
Alison Chaiken
Aurora Innovation

On Mon, Aug 1, 2022 at 5:26 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
> On 8/1/2022 4:29 PM, Jacob Keller wrote:
> >
> >
> > On 8/1/2022 4:00 PM, Ilya Evenbach wrote:
> >>>> -----Original Message-----
> >>>> From: achaiken@aurora.tech <achaiken@aurora.tech>
> >>>> Sent: Monday, August 01, 2022 6:38 AM
> >>>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> >>>> richardcochran@gmail.com
> >>>> Cc: spayne@aurora.tech; achaiken@aurora.tech; alison@she-devel.com;
> >>>> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> >>>> Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
> >>>>
> >>>> From: Steve Payne <spayne@aurora.tech>
> >>>>
> >>>> For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
> >>>> from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
> >>>> by a seemingly inconsistent amount, which causes discontinuities in
> >>>> time synchronization. Explicitly reset the NIC's PHC to
> >>>> `CLOCK_REALTIME` whenever the NIC goes up or down by calling
> >>>> `ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.
> >>>>
> >>>> Signed-off-by: Steve Payne <spayne@aurora.tech>
> >>>> Signed-off-by: Alison Chaiken <achaiken@aurora.tech>
> >>>>
> >>>
> >>> Resetting PTP could be a problem if the clock was not being synchronized with the kernel CLOCK_REALTIME,
> >>
> >> That is true, but most likely not really important, as the unmitigated
> >> problem also introduces significant discontinuities in time.
> >> Basically, this patch does not make things worse.
> >>
> >
> > Sure, but I am trying to see if I can understand *why* things get wonky.
> > I suspect the issue is caused because of how we're resetting the
> > cyclecounter.
> >
> >>>
> >>> and does result in some loss of timer precision either way due to the delays involved with setting the time.
> >>
> >>  That precision loss is negligible compared to jumps resulting from
> >> link down/up, and should be corrected by normal PTP operation very
> >> quickly.
> >>
> >
> > Only if CLOCK_REALTIME is actually being synchronized. Yes, that is
> > generally true, but its not necessarily guaranteed.
> >
> >>>
> >>> Do you have an example of the clock jump? How much is it?
> >>
> >> 2021-02-12T09:24:37.741191+00:00 bench-12 phc2sys: [195230.451]
> >> CLOCK_REALTIME phc offset        61 s2 freq  -36503 delay   2298
> >> 2021-02-12T09:24:38.741315+00:00 bench-12 phc2sys: [195231.451]
> >> CLOCK_REALTIME phc offset       169 s2 freq  -36377 delay   2294
> >> 2021-02-12T09:24:39.741407+00:00 bench-12 phc2sys: [195232.451]
> >> CLOCK_REALTIME phc offset 195213702387037 s2 freq +100000000 delay
> >> 2301
> >> 2021-02-12T09:24:40.741489+00:00 bench-12 phc2sys: [195233.452]
> >> CLOCK_REALTIME phc offset 195213591220495 s2 freq +100000000 delay
> >> 2081
> >>
> >
> > Thanks.
> >
> > I think what's actually going on is a bug in the
> > ixgbe_ptp_start_cyclecounter function where the system time registers
> > are being reset.
> >
> > What hardware are you operating on? Do you know if its an X550 board? It
> > looks like this has been the case since a9763f3cb54c ("ixgbe: Update PTP
> > to support X550EM_x devices").
> >
> > The start_cyclecounter was never supposed to modify the current time
> > registers, but resetting it to 0 as it does for X550 devices would give
> > the exact behavior you're seeing.
>
> I just posted an alternative fix which I believe resolves this issue.
>
> Thanks,
> Jake
