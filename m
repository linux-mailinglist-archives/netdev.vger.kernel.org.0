Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959F6646532
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiLGXgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLGXgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:36:44 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB498AAEA
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:36:39 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id o5-20020a4aa805000000b004a020f841cbso165666oom.3
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 15:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4bM6SKRE6ik5tlaOBWLBJYdHHUJEelxxwN2ETMMhnlM=;
        b=PAesO0oyso3RT03s+40SoCv07++5Q73wo7wdVXLLLoyFSgNpJT7KjNLBa0tMoe8e7C
         MOvpxBAJaQyaTjMjKzxPDe7yI62KcGNEZO9bFOIJU8LSb0hIWdrEl0HWdHXIieeM/+uD
         rsPDvJk3J7Dsmb4THWltIjdNKwmixKPfTMStllKijNyeOrRBOvVzH5b+7bqvgfDk7Dz3
         /hIHEeetO+kvHtjSuzBRHYfvShEcaf00hU6cuSKUOooMGZWuF6XhtOZxLb3PjqTzsTpM
         qI0q6WbWb2cF8bQm4v1L70UKiZlJi4OkPdGGYHY9iFAiLB9VxPxPftLoNfU5e4BEPN20
         OhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4bM6SKRE6ik5tlaOBWLBJYdHHUJEelxxwN2ETMMhnlM=;
        b=FzEDmpnZmISNBVs41y//8cilEXsfkPlRSogq41KMZzkOMx1sKji87zcYUymT9e8JNG
         ipK1YKsGfGOGSS2AOoiQ3GBre9rFIP0OQtfTzE3LKGQaM/UD3yVN5IC/EjiBzQyyM0Z3
         i9NrU5UTnmog7/O0BWCGIGQXBi7vrJP3KlE9fy6bE+LuPVMACZuMAg5d+1BqTTV1tWGO
         YtwcTezlB+VJ+AmFlXRsyd1iCndrtp/r2HACde/Z/wlP983Cn+Qq8Oar4+QfhQ0DuvL9
         aVzWHG9Rjb8dIwbHhLEonTczRxLGnXny7oQw7XGXtU9Ei/FvBVehToC7DGJviPhFKDP3
         zPJw==
X-Gm-Message-State: ANoB5pnOCqjeLvBbsk8YmUGAWPo4KEuWjQSSWoaLpWuNBywqJq70bM0w
        0ceFfHOW8aZlpjj1GV//ibfCUGlTXeXyynmXADA=
X-Google-Smtp-Source: AA0mqf6tpQds8NrJuGmOcjzcQO41FnUo5W68RotULLJf3PXCgtJmDa3awHPigfwXZ4Xw/2WPDDr5ksCkVR1Mxe8bxD4=
X-Received: by 2002:a4a:8c23:0:b0:47f:d445:b435 with SMTP id
 u32-20020a4a8c23000000b0047fd445b435mr32313994ooj.87.1670456198996; Wed, 07
 Dec 2022 15:36:38 -0800 (PST)
MIME-Version: 1.0
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
 <Y4731q0/oqwhHZod@nanopsycho> <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
 <CADvbK_eaEb9vQ9h34WNcibULBFHAZcPB05dNztV=+QOUzOYBwQ@mail.gmail.com> <Y5CVoc7vnKGg1KYj@nanopsycho>
In-Reply-To: <Y5CVoc7vnKGg1KYj@nanopsycho>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 7 Dec 2022 18:35:48 -0500
Message-ID: <CADvbK_dFAAd3=cBf9aonBbJcJ38V3=KDK5YzUd+=hBO2axkMBg@mail.gmail.com>
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

On Wed, Dec 7, 2022 at 8:31 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, Dec 06, 2022 at 10:52:33PM CET, lucien.xin@gmail.com wrote:
> >On Tue, Dec 6, 2022 at 8:32 AM Xin Long <lucien.xin@gmail.com> wrote:
> >>
> >> On Tue, Dec 6, 2022 at 3:05 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >> >
> >> > Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
> >> > >The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
> >> > >for slaves separately from master") is also needed in Team. Otherwise,
> >> > >DAD and RS packets to be sent from the slaves in turn can confuse the
> >> > >switches and cause them to incorrectly update their forwarding tables
> >> > >as Liang noticed in the test with activebackup mode.
> >> > >
> >> > >Note that the patch also sets IFF_MASTER flag for Team dev accordingly
> >> > >while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
> >> > >not really used in Team, it's good to show in 'ip link':
> >> > >
> >> > >  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
> >> > >  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
> >> > >
> >> > >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> >> > >Reported-by: LiLiang <liali@redhat.com>
> >> > >Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >> >
> >> > Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
> >> > flags used by bonding and eql. Should not be used for other devices.
> >> I see. I was wondering why it was not used in Team at the beginning. :)
> >>
> >> >
> >> > addrconf_addr_gen() should not check IFF_SLAVE. It should use:
> >> > netif_is_lag_port() and netif_is_failover_slave() helpers.
> >Hi Jiri,
> >
> >Sorry, it seems not to work with this.
> >
> >As addrconf_addr_gen() is also called in NETDEV_UP event where
> >IFF_TEAM_PORT and IFF_BONDING haven't yet been set before
> >dev_open() when adding the port.
> >
> >If we move IFF_TEAM_PORT setting ahead of dev_open(), it will revert
> >the fix in:
> >
> >commit d7d3c05135f37d8fdf73f9966d27155cada36e56
> >Author: Jiri Pirko <jiri@resnulli.us>
> >Date:   Mon Aug 25 21:38:27 2014 +0200
> >
> >    team: set IFF_TEAM_PORT priv_flag after rx_handler is registered
> >
> >Can we keep IFF_SLAVE here only for no ipv6 addrconf?
>
> So, shouldn't it be rather a new flag specifically for this purpose?
Maybe IFF_NO_ADDRCONF in dev->priv_flags?

I will give it a try.

Thanks.
