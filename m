Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5777E587430
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiHAXAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbiHAXA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:00:28 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34DF2ACC
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:00:16 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id v13so3483328vke.3
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 16:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aurora.tech; s=google;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=d1mDb2a2v5329ifGIpZKAthbn6aAeF9uBnt1OeyGSno=;
        b=ES/PQe98egd7+R9bNGcqpEC2zMpz2RlfQ9kGgpgfi725GTaBm5Nw/ghctXtX/nOO+O
         f5LRbuhhcpA0wlX6gS4UaJAU5C3QwDJNKeQQ8YY4ZMwCpG9NK37LfzqqmF8mKAI4B7C6
         s1u7uKQiXguq7hyBlTZgyQYyd2eVKxjTsBw1wBeUXMWVgZ9dfMeM9BRjugX03A208SCx
         MQjWon9Py1SPcH2JCD5TwukggI4cmtiQWJsscYdtnIhvWvkyo/WMYJKEl6OUAFU2Oj1n
         hkXHJyo/dNOfPqzxG3k0xzL1uAzHA297YfYwHS3TXSu+eeAjv3giLgUoHkj85y8s0kB0
         FHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=d1mDb2a2v5329ifGIpZKAthbn6aAeF9uBnt1OeyGSno=;
        b=72vBJCSht5oHN3JhVstKX3L09hGnizZ5V9BSIIKwKF+bKD+jKcMReaxrwf7/u2S97S
         rlFrSA2vqMoul+A//k7DBECHMPCQcTbYSRkMV5lIqDC8jOEdKI3yliMGybte84jw5Sq8
         sETMZLRrc1CpxIXoxOOtPuoB4+H4wqXHjB8eF1HZlhjJ+tQkxHwjFtfLoJOOWKcPqfEP
         ez6Jhs9BRbjsTM623qQnGEKWCStkOhJONqhFAIa8LraCj7FuqCM+/Ir21lhzlq/YvE6t
         /3MqFAhGTpGsVZgrWZ/MR8j1H9az/hQelMdjVgxki83Xcm0Y1HwoMgLhkhEBoN6+tIbW
         PLow==
X-Gm-Message-State: AJIora/yjuime/5NXFbXimKg2bxDX29v/bYDibogUZafaEOoCIH+aFWs
        6TNdtanOw9Q0iCesgKQR80R+kz+ZbTPbVo3ZLpW7kA==
X-Google-Smtp-Source: AGRyM1tAXkm7vLC0y1aF7PlaH3eymvJiM1XO5v8dGr9NfGhObcDMk/+LbVWbkcPN++H4WDh1c4f0AgQGGDgsdFEhrtU=
X-Received: by 2002:a1f:300c:0:b0:36f:eb7d:746f with SMTP id
 w12-20020a1f300c000000b0036feb7d746fmr6659713vkw.27.1659394815519; Mon, 01
 Aug 2022 16:00:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220801133750.7312-1-achaiken@aurora.tech> <CO1PR11MB508966EB7A3CF01A58553536D69A9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAFzL-7tX845o2kJmE4o8EhbeD-=vkR6rmaiz_ZEWfSD4W+iWEA@mail.gmail.com> <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
In-Reply-To: <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
From:   Ilya Evenbach <ievenbach@aurora.tech>
Date:   Mon, 1 Aug 2022 16:00:03 -0700
Message-ID: <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com>
Subject: Fwd: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
To:     Alison Chaiken <achaiken@aurora.tech>, jacob.e.keller@intel.com,
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

> > -----Original Message-----
> > From: achaiken@aurora.tech <achaiken@aurora.tech>
> > Sent: Monday, August 01, 2022 6:38 AM
> > To: Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> > richardcochran@gmail.com
> > Cc: spayne@aurora.tech; achaiken@aurora.tech; alison@she-devel.com;
> > netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> > Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
> >
> > From: Steve Payne <spayne@aurora.tech>
> >
> > For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
> > from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
> > by a seemingly inconsistent amount, which causes discontinuities in
> > time synchronization. Explicitly reset the NIC's PHC to
> > `CLOCK_REALTIME` whenever the NIC goes up or down by calling
> > `ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.
> >
> > Signed-off-by: Steve Payne <spayne@aurora.tech>
> > Signed-off-by: Alison Chaiken <achaiken@aurora.tech>
> >
>
> Resetting PTP could be a problem if the clock was not being synchronized with the kernel CLOCK_REALTIME,

That is true, but most likely not really important, as the unmitigated
problem also introduces significant discontinuities in time.
Basically, this patch does not make things worse.

>
> and does result in some loss of timer precision either way due to the delays involved with setting the time.

 That precision loss is negligible compared to jumps resulting from
link down/up, and should be corrected by normal PTP operation very
quickly.

>
> Do you have an example of the clock jump? How much is it?

2021-02-12T09:24:37.741191+00:00 bench-12 phc2sys: [195230.451]
CLOCK_REALTIME phc offset        61 s2 freq  -36503 delay   2298
2021-02-12T09:24:38.741315+00:00 bench-12 phc2sys: [195231.451]
CLOCK_REALTIME phc offset       169 s2 freq  -36377 delay   2294
2021-02-12T09:24:39.741407+00:00 bench-12 phc2sys: [195232.451]
CLOCK_REALTIME phc offset 195213702387037 s2 freq +100000000 delay
2301
2021-02-12T09:24:40.741489+00:00 bench-12 phc2sys: [195233.452]
CLOCK_REALTIME phc offset 195213591220495 s2 freq +100000000 delay
2081

>
> How often is it? Every time?

Every time (though the specific amount differs, it is usually at
similar magnitude)

> More information would help in order to debug what is going wrong here.
>
> Thanks,
> Jake
>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index 750b02bb2fdc2..ab1ec076fa75f 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -7462,7 +7462,7 @@ static void ixgbe_watchdog_link_is_up(struct
> > ixgbe_adapter *adapter)
> >       adapter->last_rx_ptp_check = jiffies;
> >
> >       if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state))
> > -             ixgbe_ptp_start_cyclecounter(adapter);
> > +             ixgbe_ptp_reset(adapter);
> >
> >       switch (link_speed) {
> >       case IXGBE_LINK_SPEED_10GB_FULL:
> > @@ -7527,7 +7527,7 @@ static void ixgbe_watchdog_link_is_down(struct
> > ixgbe_adapter *adapter)
> >               adapter->flags2 |= IXGBE_FLAG2_SEARCH_FOR_SFP;
> >
> >       if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state))
> > -             ixgbe_ptp_start_cyclecounter(adapter);
> > +             ixgbe_ptp_reset(adapter);
> >
> >       e_info(drv, "NIC Link is Down\n");
> >       netif_carrier_off(netdev);
> > --
> > 2.32.0
>
