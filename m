Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0015874C8
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 02:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiHBAYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 20:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiHBAYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 20:24:31 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B55E1F634
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 17:24:29 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3246910dac3so73406207b3.12
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 17:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aurora.tech; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=THL7kXmuzb6t+j9BasB/qWwgChzRIog+35BlUowjwVQ=;
        b=CjS5t0y0TX2+T94BfNae8/yw/FO6/2sqhEmTcrRb/2f85lVG8AtTYqFtAuU5fjDCPU
         Xh7N11adK3KLBwHA6GbSVaL9wdPoaATvE9CLL0Fyw0gImVo61rv6/85kXNWnmCNvScuS
         NA7glNPUxyRrjU+XywZg7pGAYGEYvNDu6DWCz7X8Bsw+tZ9LWKat6hYlJZAbUqGG1ids
         Dyw1XyWs20kya1vTh9nA8IyQqmOzsDUdOsG7fuvA4Pa+TODcqAD+4Lbu5kSFaVN63yfg
         9xsyynV5nqbO23gEL8NUJE8OAK3B70CNXQ3LdpMIQkZ/aWs0wo29LaXKzpwOHXviTemC
         HBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=THL7kXmuzb6t+j9BasB/qWwgChzRIog+35BlUowjwVQ=;
        b=XhUFjag2T54uaWPR0162zwETsn3BmLbcJz0izBvgn1Zj79x7WusOUuhxRDFuJfpbL9
         znJZZgG8ZIu1Dp3RjSFIsk8JW3Xaj5xgh9YSdrXo+jgpFNY5CiEyIzWzuMNJKbGtJdew
         ETzTtBq5JhnUfK25WLklI3OvnflV5TpqbuL0zsKTIOh8yTCMk+bTZWXHbJn3kQFlXEgd
         tqLVMm495BvM04t8An9I4pdo44VRNYTBb7WUM98py1GtmR+WiyePhBxy5Xq9ZLYPbXnp
         CVMaU21lwHrR6c/rVRscgmrHOvB41XZmdIIWCJdw9NFqrRPZdcxojnHGBb53YdzntwDc
         pk9g==
X-Gm-Message-State: ACgBeo1R3EJlgyqHk0FeO7iV53gT2lX3g7HT+3VxPki88Z9AdZcocA8g
        19p+zcAy0lmofJbjSrET5qqhCTQCRR7D96/+9gw+OA==
X-Google-Smtp-Source: AA6agR7V2ra/dfef1EWEdDoiBaycFKEPJFuXjRTPfOK4RQG86lIkt08CkNkj0gQpi17Bc76IzBn1NxgiwKw84DceIwU=
X-Received: by 2002:a81:ad1:0:b0:318:3b63:6d00 with SMTP id
 200-20020a810ad1000000b003183b636d00mr15902154ywk.146.1659399868699; Mon, 01
 Aug 2022 17:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220801133750.7312-1-achaiken@aurora.tech> <CO1PR11MB508966EB7A3CF01A58553536D69A9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAFzL-7tX845o2kJmE4o8EhbeD-=vkR6rmaiz_ZEWfSD4W+iWEA@mail.gmail.com>
 <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
 <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com> <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com>
In-Reply-To: <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com>
From:   Alison Chaiken <achaiken@aurora.tech>
Date:   Mon, 1 Aug 2022 17:24:17 -0700
Message-ID: <CAFzL-7uBrzQNmYCXvaL-OokE07cWT-jr4tgGR2VgeaUeayLfxw@mail.gmail.com>
Subject: Re: Fwd: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Ilya Evenbach <ievenbach@aurora.tech>,
        Steve Payne <spayne@aurora.tech>, jesse.brandeburg@intel.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 4:29 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
>
>
> On 8/1/2022 4:00 PM, Ilya Evenbach wrote:
> >>> -----Original Message-----
> >>> From: achaiken@aurora.tech <achaiken@aurora.tech>
> >>> Sent: Monday, August 01, 2022 6:38 AM
> >>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> >>> richardcochran@gmail.com
> >>> Cc: spayne@aurora.tech; achaiken@aurora.tech; alison@she-devel.com;
> >>> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> >>> Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
> >>>
> >>> From: Steve Payne <spayne@aurora.tech>
> >>>
> >>> For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
> >>> from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
> >>> by a seemingly inconsistent amount, which causes discontinuities in
> >>> time synchronization. Explicitly reset the NIC's PHC to
> >>> `CLOCK_REALTIME` whenever the NIC goes up or down by calling
> >>> `ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.
> >>>
> >>> Signed-off-by: Steve Payne <spayne@aurora.tech>
> >>> Signed-off-by: Alison Chaiken <achaiken@aurora.tech>
> >>>
> >>
> >> Resetting PTP could be a problem if the clock was not being synchronized with the kernel CLOCK_REALTIME,
> >
> > That is true, but most likely not really important, as the unmitigated
> > problem also introduces significant discontinuities in time.
> > Basically, this patch does not make things worse.
> >
>
> Sure, but I am trying to see if I can understand *why* things get wonky.
> I suspect the issue is caused because of how we're resetting the
> cyclecounter.
>
> >>
> >> and does result in some loss of timer precision either way due to the delays involved with setting the time.
> >
> >  That precision loss is negligible compared to jumps resulting from
> > link down/up, and should be corrected by normal PTP operation very
> > quickly.
> >
>
> Only if CLOCK_REALTIME is actually being synchronized. Yes, that is
> generally true, but its not necessarily guaranteed.
>
> >>
> >> Do you have an example of the clock jump? How much is it?
> >
> > 2021-02-12T09:24:37.741191+00:00 bench-12 phc2sys: [195230.451]
> > CLOCK_REALTIME phc offset        61 s2 freq  -36503 delay   2298
> > 2021-02-12T09:24:38.741315+00:00 bench-12 phc2sys: [195231.451]
> > CLOCK_REALTIME phc offset       169 s2 freq  -36377 delay   2294
> > 2021-02-12T09:24:39.741407+00:00 bench-12 phc2sys: [195232.451]
> > CLOCK_REALTIME phc offset 195213702387037 s2 freq +100000000 delay
> > 2301
> > 2021-02-12T09:24:40.741489+00:00 bench-12 phc2sys: [195233.452]
> > CLOCK_REALTIME phc offset 195213591220495 s2 freq +100000000 delay
> > 2081
> >
>
> Thanks.
>
> I think what's actually going on is a bug in the
> ixgbe_ptp_start_cyclecounter function where the system time registers
> are being reset.
>
> What hardware are you operating on? Do you know if its an X550 board?

Indeed it is.

> It
> looks like this has been the case since a9763f3cb54c ("ixgbe: Update PTP
> to support X550EM_x devices").

The current test results come from v5.15.49-rt47. We observed the same
problem in 5.4.93-rt51, which contains a9763f3cb54c.

> The start_cyclecounter was never supposed to modify the current time
> registers, but resetting it to 0 as it does for X550 devices would give
> the exact behavior you're seeing.

That certainly sounds plausible.

Thanks,
Alison Chaiken
Aurora Innovation
