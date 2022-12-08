Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3A6474D9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLHRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLHRIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:08:10 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A1D85D11
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:08:09 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s186so2016794oia.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 09:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b8SQhv1HrvHF/UwzGYo8EpDfp9nVdvsuqFkA4JsYAdU=;
        b=d2qB5MJgcwJuiou8UcZwfpLe5Mm8YljTi6OfBKxv48zUR64NBrbun+X5Pg0H8aMznL
         OreAXc5VNF9A7lKpFw3hF5942WlCVAsA4JeR16mVhmR+B+guy9Nv1HTdNDGt4AZl45Rt
         eT7owMC3bFTHoLZpz4sc+UmOpNiFVDfCXAl1yMgfAuBFQACS6im/c1Z2K/hYyIIpcgnB
         qn2rtppn/SXxZIUIk/BaWN1p/ay36zXG7RSnnJ+djEwSB+Vs6Kx80iyYnXcAOk2sYKun
         jDKkTXlrW4y2+UqudhXYgjxQeOLpOt9AA+BiBGWyt87HFCYHq2Fug1s8M58GE/6laHx8
         e2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b8SQhv1HrvHF/UwzGYo8EpDfp9nVdvsuqFkA4JsYAdU=;
        b=VQpOoR9MgqbqmBkpoiB+KCUqDjarud6KHiK9THnj+iTxCJYYhWbW8bCjzquQY76R+F
         UdpMgb6EfSzf2uKeH7ckDqfi6AruhitWcE72KLYqi6CaRZ3ge2a9IGf5hFfVG9UpF+Zw
         B+jgnY+ik/z6jQia7tebkiHFg7wPva6ZorvggRaCoR8XHkYw+GKargH+y3dHl3oMtYZ9
         teLOXSIgMUlapmZoKiHzzCQV+ME33b1sue3dY7UnEKFPJpznyjLgTxAI7yQzEA9fZmnI
         WUk+bK9JlrizcTOZq+Sz1+i9SN+nbEdIZf42GA4K++2qxVncq8MQZeSMmK0ZAGW0+w1u
         Q8fg==
X-Gm-Message-State: ANoB5pnX26XellfI7v5tT7khnTPTY1L/94tEy08F4/bqnYP7j21T9seQ
        DcOWJhdgTM4GC/1EpAUWGu+X7SKPZoW8WqaoEQbMtc28syRkLF0s
X-Google-Smtp-Source: AA0mqf7cq+vBjOcTuJszU2+aIxz0Wai+WLB3PE+VVmC0lvWlFgGmlTK0bN2sztGpnXCXu8WURaj1xDh2x40fmnNzmBA=
X-Received: by 2002:aca:2801:0:b0:35a:13f4:d875 with SMTP id
 1-20020aca2801000000b0035a13f4d875mr48685797oix.190.1670519288817; Thu, 08
 Dec 2022 09:08:08 -0800 (PST)
MIME-Version: 1.0
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
 <Y4731q0/oqwhHZod@nanopsycho> <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
 <CADvbK_eaEb9vQ9h34WNcibULBFHAZcPB05dNztV=+QOUzOYBwQ@mail.gmail.com>
 <Y5CVoc7vnKGg1KYj@nanopsycho> <CADvbK_dFAAd3=cBf9aonBbJcJ38V3=KDK5YzUd+=hBO2axkMBg@mail.gmail.com>
 <Y5HIUiL7kYYSCgV8@nanopsycho>
In-Reply-To: <Y5HIUiL7kYYSCgV8@nanopsycho>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 8 Dec 2022 12:07:17 -0500
Message-ID: <CADvbK_euRvkO8iKmUojb+Vbf6F59VGGxyaDWg5ebLmP51-mj8g@mail.gmail.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port devices
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, LiLiang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 6:19 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Thu, Dec 08, 2022 at 12:35:48AM CET, lucien.xin@gmail.com wrote:
> >On Wed, Dec 7, 2022 at 8:31 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Tue, Dec 06, 2022 at 10:52:33PM CET, lucien.xin@gmail.com wrote:
> >> >On Tue, Dec 6, 2022 at 8:32 AM Xin Long <lucien.xin@gmail.com> wrote:
> >> >>
> >> >> On Tue, Dec 6, 2022 at 3:05 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >> >> >
> >> >> > Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
> >> >> > >The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
> >> >> > >for slaves separately from master") is also needed in Team. Otherwise,
> >> >> > >DAD and RS packets to be sent from the slaves in turn can confuse the
> >> >> > >switches and cause them to incorrectly update their forwarding tables
> >> >> > >as Liang noticed in the test with activebackup mode.
> >> >> > >
> >> >> > >Note that the patch also sets IFF_MASTER flag for Team dev accordingly
> >> >> > >while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
> >> >> > >not really used in Team, it's good to show in 'ip link':
> >> >> > >
> >> >> > >  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
> >> >> > >  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
> >> >> > >
> >> >> > >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> >> >> > >Reported-by: LiLiang <liali@redhat.com>
> >> >> > >Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >> >> >
> >> >> > Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
> >> >> > flags used by bonding and eql. Should not be used for other devices.
> >> >> I see. I was wondering why it was not used in Team at the beginning. :)
> >> >>
> >> >> >
> >> >> > addrconf_addr_gen() should not check IFF_SLAVE. It should use:
> >> >> > netif_is_lag_port() and netif_is_failover_slave() helpers.
> >> >Hi Jiri,
> >> >
> >> >Sorry, it seems not to work with this.
> >> >
> >> >As addrconf_addr_gen() is also called in NETDEV_UP event where
> >> >IFF_TEAM_PORT and IFF_BONDING haven't yet been set before
> >> >dev_open() when adding the port.
> >> >
> >> >If we move IFF_TEAM_PORT setting ahead of dev_open(), it will revert
> >> >the fix in:
> >> >
> >> >commit d7d3c05135f37d8fdf73f9966d27155cada36e56
> >> >Author: Jiri Pirko <jiri@resnulli.us>
> >> >Date:   Mon Aug 25 21:38:27 2014 +0200
> >> >
> >> >    team: set IFF_TEAM_PORT priv_flag after rx_handler is registered
> >> >
> >> >Can we keep IFF_SLAVE here only for no ipv6 addrconf?
> >>
> >> So, shouldn't it be rather a new flag specifically for this purpose?
> >Maybe IFF_NO_ADDRCONF in dev->priv_flags?
>
> Sounds fine to me.
BTW, IFF_LIVE_RENAME_OK flag was just deleted in net-next.git by:

commit bd039b5ea2a91ea707ee8539df26456bd5be80af
Author: Andy Ren <andy.ren@getcruise.com>
Date:   Mon Nov 7 09:42:42 2022 -0800

    net/core: Allow live renaming when an interface is up

do you think it is okay to use that vacance and define:

IFF_NO_ADDRCONF = BIT_ULL(30)

in netdev_priv_flags ?

Thanks.

>
>
> >
> >I will give it a try.
> >
> >Thanks.
