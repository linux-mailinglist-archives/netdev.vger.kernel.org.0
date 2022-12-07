Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FEA645AF2
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLGNbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGNbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:31:18 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B68D2A726
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:31:17 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kw15so10559034ejc.10
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rrSzYpicx6GF/Em5Yde8gBnOIclkcrrCx0V2H/SsjSI=;
        b=mTeWSXo8EFFIi3Hv8AP8YnxKBq4tBxpTbsyZce9MFpUXrzqJEvTxihBPoessNF6iHv
         x1SOJqiNuYnVlkSc/6WVtCKpHiHzf1YelukxVi1JS9GYVcUbGqq5GFRviFa7fnulC5/Z
         5DgkuHQERbvXzg9WbjqTSCa/RQiHpPulV70Gl9iIqHSxfktBNsdZpni22zb8J3sbHEjB
         YVLaAWBpY9D5yQfYxkcD9tA2ZxQ52UDg4lWjpRZ1oh00qR0Lytqt4r4kxdAfE8oZfTcc
         LdK2NgOsWYb8E6WOx9bmd9xhFHelmP8mp7erjkhXQbV82Ib1k2YvNssrMcgYM4IWjkvG
         LSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrSzYpicx6GF/Em5Yde8gBnOIclkcrrCx0V2H/SsjSI=;
        b=1KeDzVyvSvchWZfsjUUJ2dPRQYZc/A2ke/3zFfKAmQgqp7XfqzK99X6OmfPg2prLyR
         ZR6Robg5HAc+eKzf2BPLRqAyoWEFLUs1V5IdSO0/UUioiI1ByGFggmTdq5/lmWDXdxWp
         cW3mM3TYAhbTX35KfQQIreRyQljCpbOfedZtX5tJw09MJJQ7Adih+wAGlahrv2NaP9E+
         InX5JJNwzIpf0iF5GlTtfhfB9CfA1pKOKkMkpvmlvRBUaMKEMMOPwjETSiEJyvlvvgYZ
         EdL9URJAY3Yk87cIXIZANBzrt6e3IIv2flg8gQ9+5aAo8Xn4RcF5iZdsJlUtbIDwBrDA
         ovmg==
X-Gm-Message-State: ANoB5pm7i7jS38f+q6CheHtmjQKsc/44GTqqFuv9rUuLcTwjPrELod6/
        mjyex2RDOUN6pg+qnwXF7hl7wA==
X-Google-Smtp-Source: AA0mqf5RbD4ZlnSlxurt5U9KF6BKeKibf1Bl7SwypfAAkKPY9/ojj8nmiqP3cgJHztYag1suikBnlQ==
X-Received: by 2002:a17:906:f0da:b0:7c0:d609:4120 with SMTP id dk26-20020a170906f0da00b007c0d6094120mr15649101ejb.320.1670419875662;
        Wed, 07 Dec 2022 05:31:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906328700b007c0c1e18e28sm6298382ejw.124.2022.12.07.05.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:31:15 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:31:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port devices
Message-ID: <Y5CVoc7vnKGg1KYj@nanopsycho>
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
 <Y4731q0/oqwhHZod@nanopsycho>
 <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
 <CADvbK_eaEb9vQ9h34WNcibULBFHAZcPB05dNztV=+QOUzOYBwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_eaEb9vQ9h34WNcibULBFHAZcPB05dNztV=+QOUzOYBwQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 10:52:33PM CET, lucien.xin@gmail.com wrote:
>On Tue, Dec 6, 2022 at 8:32 AM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Tue, Dec 6, 2022 at 3:05 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >
>> > Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
>> > >The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
>> > >for slaves separately from master") is also needed in Team. Otherwise,
>> > >DAD and RS packets to be sent from the slaves in turn can confuse the
>> > >switches and cause them to incorrectly update their forwarding tables
>> > >as Liang noticed in the test with activebackup mode.
>> > >
>> > >Note that the patch also sets IFF_MASTER flag for Team dev accordingly
>> > >while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
>> > >not really used in Team, it's good to show in 'ip link':
>> > >
>> > >  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
>> > >  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
>> > >
>> > >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>> > >Reported-by: LiLiang <liali@redhat.com>
>> > >Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> >
>> > Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
>> > flags used by bonding and eql. Should not be used for other devices.
>> I see. I was wondering why it was not used in Team at the beginning. :)
>>
>> >
>> > addrconf_addr_gen() should not check IFF_SLAVE. It should use:
>> > netif_is_lag_port() and netif_is_failover_slave() helpers.
>Hi Jiri,
>
>Sorry, it seems not to work with this.
>
>As addrconf_addr_gen() is also called in NETDEV_UP event where
>IFF_TEAM_PORT and IFF_BONDING haven't yet been set before
>dev_open() when adding the port.
>
>If we move IFF_TEAM_PORT setting ahead of dev_open(), it will revert
>the fix in:
>
>commit d7d3c05135f37d8fdf73f9966d27155cada36e56
>Author: Jiri Pirko <jiri@resnulli.us>
>Date:   Mon Aug 25 21:38:27 2014 +0200
>
>    team: set IFF_TEAM_PORT priv_flag after rx_handler is registered
>
>Can we keep IFF_SLAVE here only for no ipv6 addrconf?

So, shouldn't it be rather a new flag specifically for this purpose?


>or do you see a better solution?
>
>Thanks.
