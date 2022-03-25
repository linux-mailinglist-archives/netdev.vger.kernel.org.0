Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12824E7D01
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiCYWD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCYWD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:03:28 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E33A517CB
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:01:53 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id c23so10461721ioi.4
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ux8vi8AzaeQVXwTLxplZyLRv4W2ifNndvajUUwrDoXU=;
        b=z2VmD85OEJIeZtvGVRmmv6Qni7z1Ef478XYeGhKCiTAegu2V7EkHmrQxa8j0tspnPo
         XkmW1wDs+mRuMtw3MxhY0X0XCVaIhRe1p8wFeFziRlzBfCOxLEQdbFREo5lUke44p22E
         vOC7tH+kJlunK7xEGW7tOcYEGom/ukR7vAgOy50BnYBUG5Xl9zHFtRuTUPs4d9HR5s59
         oMFFSnssQlL05a0SCmI2XH7xNq4ygUczWywhCDKzKf919KX5+2m84vQhrqth72+ZCBoQ
         eYHNjQ5XrCeG95ppGREJGxXfMej6vdjMfawpc5wonvKe9JMeTli69oCNW6tiypnfirp8
         +wGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ux8vi8AzaeQVXwTLxplZyLRv4W2ifNndvajUUwrDoXU=;
        b=wSRhRM4p3OdzpgJq7wQXPYD1x7h4MPfmhhON89P/Rwx0x60uBFakhwvLczZgu94/Oj
         NV3yzEp83bKDNKEF70QmoqfKmdRx/hNIjxFdmQrDYDyNYlXcfUrzHlcFKLh9NuMUYbYI
         gJWKrJkRa6+y2kvmxeS6UKiAtxOi8Dzey7mVqxNS+yJpJiiEpmopn1WIY0VDyYRkp5ga
         uH1RPT1gV9ktLuFfVOB1QYdxVOa6px8bYIYN4GDfgo8supE/FKUA9T5mgXC+8dq3XdMu
         kY+Kum1jq7c86A9fKhckBysUPDgdhnzcNh68qy7V3s503dDve4dj7JHgrq2EW5QrndRu
         ZZfA==
X-Gm-Message-State: AOAM533q3N7Bl65pukXLnO/ZC2i8Mp9bM5FNFjkXdj8qov6MCp2GRV3g
        9Gl4S1NY0vwRPFSQ6in5EBLvBllMvLgbaqe8wRCkRg==
X-Google-Smtp-Source: ABdhPJzqMvF+V/SSC/R+eNOAQzDqxwCtWbJIMWI5YJ3kXbQlyMgfPVLZHARCOrR4jabEqDAVRWgszskmwYMgdxllKdg=
X-Received: by 2002:a5d:9d84:0:b0:649:d813:4d22 with SMTP id
 ay4-20020a5d9d84000000b00649d8134d22mr544795iob.133.1648245712287; Fri, 25
 Mar 2022 15:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220322210722.6405-1-gerhard@engleder-embedded.com> <87tubm5289.fsf@intel.com>
In-Reply-To: <87tubm5289.fsf@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Fri, 25 Mar 2022 23:01:41 +0100
Message-ID: <CANr-f5zGHiQuGH=P1GddRyFStNFJnVWwbeJJeU2sfOf4aRt4-g@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/6] ptp: Support hardware clocks with
 additional free running time
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi,
>
> Gerhard Engleder <gerhard@engleder-embedded.com> writes:
>
> > ptp vclocks require a clock with free running time for the timecounter.
> > Currently only a physical clock forced to free running is supported.
> > If vclocks are used, then the physical clock cannot be synchronized
> > anymore. The synchronized time is not available in hardware in this
> > case. As a result, timed transmission with TAPRIO hardware support
> > is not possible anymore.
> >
> > If hardware would support a free running time additionally to the
> > physical clock, then the physical clock does not need to be forced to
> > free running. Thus, the physical clocks can still be synchronized while
> > vclocks are in use.
> >
> > The physical clock could be used to synchronize the time domain of the
> > TSN network and trigger TAPRIO. In parallel vclocks can be used to
> > synchronize other time domains.
> >
> > One year ago I thought for two time domains within a TSN network also
> > two physical clocks are required. This would lead to new kernel
> > interfaces for asking for the second clock, ... . But actually for a
> > time triggered system like TSN there can be only one time domain that
> > controls the system itself. All other time domains belong to other
> > layers, but not to the time triggered system itself. So other time
> > domains can be based on a free running counter if similar mechanisms
> > like 2 step synchroisation are used.
>
> I tried to look at this series from the point of view of the Intel i225
> NIC and its 4 sets of timer registers, and thinking how adding support
> for the "extra" 4 timers would fit with this proposal.

I was hoping that there are other devices out there, which could also implement
that feature. At least in the TSN niche I expect that others have
similar requirements.

> From what I could gather, the idea that would make more sense would be
> exposing the other(s?) i225 timers as vclocks. That sounds neat to me,
> i.e. the extra timer registers are indeed other "views" to the same
> clock (the name "virtual" makes sense).

The other i225 timer would be exposed as vclock, yes. But it would be exposed
in a restricted way. Only as free running time which forms the base for the
vclocks. The actual time of the vclocks would not be available in the
extra timer
registers. So transformation of the "view" is done in software and not
in hardware.
Only one additional timer register set would be used.

> When retrieving the timestamps from packets (we can timestamp each
> packet with two timers), the driver knows what timestamp (and what to do
> with it) the user is interested in.

Yes, the driver knows it. For TX it is known in advance. For RX the
driver does not
know before reception which timestamp the user is interested in. So
the driver must
keep two timestamps (of physical clock and new free running time)
until the packet
is assigned to a socket.

As the i225 also supports two timestamps, my suggestion would be to use one
timestamp for the physical clock which would also trigger TAPRIO and the other
timestamp as base for an unlimited number of vclocks.

> Is this what you (and others) had in mind?

If one additional timer register set is used as free running time,
then I would say yes.

If you expect to export additional functions of the 4 timer register
sets with vclocks, then
I would say no. At least not with current vclock implementation, which
requires/supports
only a free running time in hardware and nothing else. But others may
know better how
vclocks could evolve in the future. These changes could be seen as a
first step, which
enhances the functionality of vclocks if additional hardware support
is available. The i225
timer register sets may allow further enhancements.

> If so, API-wise this series looks good to me. I will take a closer look
> at the code tomorrow.

Looking forward to your feedback!

Gerhard


On Fri, Mar 25, 2022 at 1:02 AM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> Gerhard Engleder <gerhard@engleder-embedded.com> writes:
>
> > ptp vclocks require a clock with free running time for the timecounter.
> > Currently only a physical clock forced to free running is supported.
> > If vclocks are used, then the physical clock cannot be synchronized
> > anymore. The synchronized time is not available in hardware in this
> > case. As a result, timed transmission with TAPRIO hardware support
> > is not possible anymore.
> >
> > If hardware would support a free running time additionally to the
> > physical clock, then the physical clock does not need to be forced to
> > free running. Thus, the physical clocks can still be synchronized while
> > vclocks are in use.
> >
> > The physical clock could be used to synchronize the time domain of the
> > TSN network and trigger TAPRIO. In parallel vclocks can be used to
> > synchronize other time domains.
> >
> > One year ago I thought for two time domains within a TSN network also
> > two physical clocks are required. This would lead to new kernel
> > interfaces for asking for the second clock, ... . But actually for a
> > time triggered system like TSN there can be only one time domain that
> > controls the system itself. All other time domains belong to other
> > layers, but not to the time triggered system itself. So other time
> > domains can be based on a free running counter if similar mechanisms
> > like 2 step synchroisation are used.
>
> I tried to look at this series from the point of view of the Intel i225
> NIC and its 4 sets of timer registers, and thinking how adding support
> for the "extra" 4 timers would fit with this proposal.
>
> From what I could gather, the idea that would make more sense would be
> exposing the other(s?) i225 timers as vclocks. That sounds neat to me,
> i.e. the extra timer registers are indeed other "views" to the same
> clock (the name "virtual" makes sense).
>
> When retrieving the timestamps from packets (we can timestamp each
> packet with two timers), the driver knows what timestamp (and what to do
> with it) the user is interested in.
>
> Is this what you (and others) had in mind?
>
> If so, API-wise this series looks good to me. I will take a closer look
> at the code tomorrow.
>
> >
> > Synchronisation was tested with two time domains between two directly
> > connected hosts. Each host run two ptp4l instances, the first used the
> > physical clock and the second used the virtual clock. I used my FPGA
> > based network controller as network device. ptp4l was used in
> > combination with the virtual clock support patches from Miroslav
> > Lichvar.
> >
> > v1:
> > - comlete rework based on feedback to RFC (Richard Cochran)
> >
> > Gerhard Engleder (6):
> >   ptp: Add cycles support for virtual clocks
> >   ptp: Request cycles for TX timestamp
> >   ptp: Pass hwtstamp to ptp_convert_timestamp()
> >   ethtool: Add kernel API for PHC index
> >   ptp: Support late timestamp determination
> >   tsnep: Add physical clock cycles support
> >
> >  drivers/net/ethernet/engleder/tsnep_hw.h   |  9 ++-
> >  drivers/net/ethernet/engleder/tsnep_main.c | 27 ++++++---
> >  drivers/net/ethernet/engleder/tsnep_ptp.c  | 44 ++++++++++++++
> >  drivers/ptp/ptp_clock.c                    | 58 +++++++++++++++++--
> >  drivers/ptp/ptp_private.h                  | 10 ++++
> >  drivers/ptp/ptp_sysfs.c                    | 10 ++--
> >  drivers/ptp/ptp_vclock.c                   | 18 +++---
> >  include/linux/ethtool.h                    |  8 +++
> >  include/linux/ptp_clock_kernel.h           | 67 ++++++++++++++++++++--
> >  include/linux/skbuff.h                     | 11 +++-
> >  net/core/skbuff.c                          |  2 +
> >  net/ethtool/common.c                       | 13 +++++
> >  net/socket.c                               | 45 +++++++++++----
> >  13 files changed, 275 insertions(+), 47 deletions(-)
> >
> > --
> > 2.20.1
> >
>
> --
> Vinicius
