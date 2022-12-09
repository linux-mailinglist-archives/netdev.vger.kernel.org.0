Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E1564815D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLILLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLILLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:11:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90605E9D2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:11:47 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id x22so10678905ejs.11
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 03:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0z4/ah4BVncMpivgK93HW1VqKKMhGSgVcEeTAXT9zuQ=;
        b=vhxriAqgpWtcq0YIsgLRKFlKYukQiZwoqxgfObBcWwvbQmMQygZ73hsV/vrv3BnbOC
         tyIIWECtv/tYwuf0/6g5HJJSfOJ12zJo0EeWAavF7U0GmKzXvklWNlDZFFs2bVbAX8Hw
         ceXdZpAKpF6Wy7/FXn7B4EplJaQrjKwwUHC2XmwUDTCNPlan7hRBZY1GojseN0ZNAueJ
         gLbNrK/dGw8D8HMoroDnwCtCl9DZ5TivHgtskDmAzCULuq1qImAww9hPHkp4BeVq7/wD
         43JxQVUQH0R3Txx+j1tHYoronWLDHh0GHPHDwKl5Xb1/58pEP7m48RBul79KhKtkIMls
         Cr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0z4/ah4BVncMpivgK93HW1VqKKMhGSgVcEeTAXT9zuQ=;
        b=sGcJXUx0cuzVTyYHXOo1EJGDSKVYOieD2vhcA24d5S2KEodKm7tKXFFFiMe8vDcac3
         EjJ/Yn+9JSv27M3Bbi2Bhdr/fHLqHWMtehJKGSQ0Q4YFQYBiGuxVPFHFjn+E3hUMelar
         kQ8mHQzzEPBF6b+e0aNep3Ox2OiDq+gJ5+YKglbKSvlloeX79WPn/SkzGcjRxXktpV/D
         w59PktEAjmLwRiZuDYaIeoEXnhzKHFkb7xHOnKuGQYmz1mydWuF6YbHlel50iT4h/jKC
         pGFKHrNjv0ig4+roVTSUP2BQXk0cGqN+pi1xNts7VoE3f2lUWtUufF7Xut048DTk0Z6N
         JPHw==
X-Gm-Message-State: ANoB5pmYeMlvuYosjhRneOxyppz4y+yWEqw6fcGbx7zyJovyvwU+NEZA
        HRX64kHagGVW8KNFiEROFd7SFg==
X-Google-Smtp-Source: AA0mqf43Qg5nnapRc4fEINYBqUx+dUPLL+ftTNU2ZZmVBdnmH8iL0wy+BbOjtJvc/6BUDYgX7ZvBqQ==
X-Received: by 2002:a17:907:7819:b0:7c1:48b3:2494 with SMTP id la25-20020a170907781900b007c148b32494mr134909ejc.17.1670584306507;
        Fri, 09 Dec 2022 03:11:46 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id si10-20020a170906ceca00b007c09da0d773sm435667ejb.100.2022.12.09.03.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:11:45 -0800 (PST)
Date:   Fri, 9 Dec 2022 12:11:44 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port devices
Message-ID: <Y5MX8HeU/MJkDwwM@nanopsycho>
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
 <Y4731q0/oqwhHZod@nanopsycho>
 <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
 <CADvbK_eaEb9vQ9h34WNcibULBFHAZcPB05dNztV=+QOUzOYBwQ@mail.gmail.com>
 <Y5CVoc7vnKGg1KYj@nanopsycho>
 <CADvbK_dFAAd3=cBf9aonBbJcJ38V3=KDK5YzUd+=hBO2axkMBg@mail.gmail.com>
 <Y5HIUiL7kYYSCgV8@nanopsycho>
 <CADvbK_euRvkO8iKmUojb+Vbf6F59VGGxyaDWg5ebLmP51-mj8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_euRvkO8iKmUojb+Vbf6F59VGGxyaDWg5ebLmP51-mj8g@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 06:07:17PM CET, lucien.xin@gmail.com wrote:
>On Thu, Dec 8, 2022 at 6:19 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Thu, Dec 08, 2022 at 12:35:48AM CET, lucien.xin@gmail.com wrote:
>> >On Wed, Dec 7, 2022 at 8:31 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Tue, Dec 06, 2022 at 10:52:33PM CET, lucien.xin@gmail.com wrote:
>> >> >On Tue, Dec 6, 2022 at 8:32 AM Xin Long <lucien.xin@gmail.com> wrote:
>> >> >>
>> >> >> On Tue, Dec 6, 2022 at 3:05 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >> >
>> >> >> > Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
>> >> >> > >The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
>> >> >> > >for slaves separately from master") is also needed in Team. Otherwise,
>> >> >> > >DAD and RS packets to be sent from the slaves in turn can confuse the
>> >> >> > >switches and cause them to incorrectly update their forwarding tables
>> >> >> > >as Liang noticed in the test with activebackup mode.
>> >> >> > >
>> >> >> > >Note that the patch also sets IFF_MASTER flag for Team dev accordingly
>> >> >> > >while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
>> >> >> > >not really used in Team, it's good to show in 'ip link':
>> >> >> > >
>> >> >> > >  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
>> >> >> > >  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
>> >> >> > >
>> >> >> > >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>> >> >> > >Reported-by: LiLiang <liali@redhat.com>
>> >> >> > >Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> >> >> >
>> >> >> > Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
>> >> >> > flags used by bonding and eql. Should not be used for other devices.
>> >> >> I see. I was wondering why it was not used in Team at the beginning. :)
>> >> >>
>> >> >> >
>> >> >> > addrconf_addr_gen() should not check IFF_SLAVE. It should use:
>> >> >> > netif_is_lag_port() and netif_is_failover_slave() helpers.
>> >> >Hi Jiri,
>> >> >
>> >> >Sorry, it seems not to work with this.
>> >> >
>> >> >As addrconf_addr_gen() is also called in NETDEV_UP event where
>> >> >IFF_TEAM_PORT and IFF_BONDING haven't yet been set before
>> >> >dev_open() when adding the port.
>> >> >
>> >> >If we move IFF_TEAM_PORT setting ahead of dev_open(), it will revert
>> >> >the fix in:
>> >> >
>> >> >commit d7d3c05135f37d8fdf73f9966d27155cada36e56
>> >> >Author: Jiri Pirko <jiri@resnulli.us>
>> >> >Date:   Mon Aug 25 21:38:27 2014 +0200
>> >> >
>> >> >    team: set IFF_TEAM_PORT priv_flag after rx_handler is registered
>> >> >
>> >> >Can we keep IFF_SLAVE here only for no ipv6 addrconf?
>> >>
>> >> So, shouldn't it be rather a new flag specifically for this purpose?
>> >Maybe IFF_NO_ADDRCONF in dev->priv_flags?
>>
>> Sounds fine to me.
>BTW, IFF_LIVE_RENAME_OK flag was just deleted in net-next.git by:
>
>commit bd039b5ea2a91ea707ee8539df26456bd5be80af
>Author: Andy Ren <andy.ren@getcruise.com>
>Date:   Mon Nov 7 09:42:42 2022 -0800
>
>    net/core: Allow live renaming when an interface is up
>
>do you think it is okay to use that vacance and define:
>
>IFF_NO_ADDRCONF = BIT_ULL(30)
>
>in netdev_priv_flags ?

It's a private define, no UAPI, I don't see why not. Let's make the
backporter live a bit harder :)

>
>Thanks.
>
>>
>>
>> >
>> >I will give it a try.
>> >
>> >Thanks.
