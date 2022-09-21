Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CF05C043A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiIUQd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiIUQdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:33:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC52E2657F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663776854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pps5NN4tyV31j8rRjKQbrvGT/5pPh43OI/2rqdvmH44=;
        b=iZBft9okfFLga15g1yVYxFeYw95OX3fEY55EXoHivA5pD9aDcqapbXEnluLKWEKQmKg5DK
        gRYuxLQ8CKEGps9qOozz0BIVOjTXJOkjmMzEAPqJUNZIqsinphql29VV5PvXKjoRo7igo5
        ErtE0U4cGBZ1yjoTr8aA3eEjm6qdj2k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-ekqJWxoNOmK_XLHyRnymog-1; Wed, 21 Sep 2022 12:14:13 -0400
X-MC-Unique: ekqJWxoNOmK_XLHyRnymog-1
Received: by mail-wr1-f69.google.com with SMTP id u27-20020adfa19b000000b0022863c08ac4so2617783wru.11
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=pps5NN4tyV31j8rRjKQbrvGT/5pPh43OI/2rqdvmH44=;
        b=Ylz6E5sc0DQ014xm+KQpSStsJbqhAQWhdqFSbuUyaoR/7d4XwviK39cCYZWGTQNRa9
         4uL9OVLWyHgKJuhy+hceDgVZf9mya+2DqQF+re9iXgDKafe9HJ519ljIZ4XnQF7vI+3G
         MSjI8uzL5ec/dMwHUGVy3iijfC3q3QOI91AmwRXwjjRi3i4eAkXOtq5xq89zovH4PlY0
         73LRClSJRfcLmNYN+ocPMfs98AguUApws7sfHY2rpW+HjFa9tOFpsbUHIU6iWk2lBHfV
         6RNUeItI6fjeQJZdauv46oq3krRbKmDmNneeGdIgOlBuInk23L8L5QHKS7Icr1Sn5kYE
         U3Cw==
X-Gm-Message-State: ACrzQf0vieSa//n1AbugJIKOZOkp1cNDBTxJcc86B9/2FMU3Evo4tRzJ
        02hDOOe4lgB/YFaoS4dC7M2ds4gRJEFJoLIOzW2eE0fhO3Jt229VWqdQWKSP0YmOB9BSQofKXi4
        0ISk3M0/QptA7osOO
X-Received: by 2002:a05:600c:24c:b0:3b4:fa20:6f6b with SMTP id 12-20020a05600c024c00b003b4fa206f6bmr323042wmj.14.1663776852311;
        Wed, 21 Sep 2022 09:14:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7SCayDOHgp8l8IQ8+zPH1FvXjMwUJLfSRY5ICPCyZteT21tCVfpFUXC1aveGQ+PFc3uax90g==
X-Received: by 2002:a05:600c:24c:b0:3b4:fa20:6f6b with SMTP id 12-20020a05600c024c00b003b4fa206f6bmr323033wmj.14.1663776852088;
        Wed, 21 Sep 2022 09:14:12 -0700 (PDT)
Received: from debian.home (2a01cb058d2cf4004ad3915553d340e2.ipv6.abo.wanadoo.fr. [2a01:cb05:8d2c:f400:4ad3:9155:53d3:40e2])
        by smtp.gmail.com with ESMTPSA id y15-20020a05600c364f00b003b31c560a0csm3097941wmq.12.2022.09.21.09.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:14:11 -0700 (PDT)
Date:   Wed, 21 Sep 2022 18:14:09 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Message-ID: <20220921161409.GA11793@debian.home>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921060123.1236276d@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 06:01:23AM -0700, Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 11:07:21 +0800 Hangbin Liu wrote:
> > Netlink messages are used for communicating between user and kernel space.
> > When user space configures the kernel with netlink messages, it can set the
> > NLM_F_ECHO flag to request the kernel to send the applied configuration back
> > to the caller. This allows user space to retrieve configuration information
> > that are filled by the kernel (either because these parameters can only be
> > set by the kernel or because user space let the kernel choose a default
> > value).
> > 
> > This patch handles NLM_F_ECHO flag and send link info back after
> > rtnl_{new, set}link.
> > 
> > Suggested-by: Guillaume Nault <gnault@redhat.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > 
> > In this patch I use rtnl_unicast to send the nlmsg directly. But we can
> > also pass "struct nlmsghdr *nlh" to rtnl_newlink_create() and
> > do_setlink(), then call rtnl_notify to send the nlmsg. I'm not sure
> > which way is better, any comments?
> > 
> > For iproute2 patch, please see
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220916033428.400131-2-liuhangbin@gmail.com/
> 
> I feel like the justification for the change is lacking.

To be fair, this is an old idea of mine, that Hangbin just picked it
up. So let me just explain a bit the original reasons behin his work.

> I'm biased [and frankly it takes a lot of self-restraint for me not
> to say how I _really_ feel about netlink msg flags ;)] but IMO the
> message flags fall squarely into the "this is magic which was never
> properly implemented" bucket.

My original idea was indeed to fix NLM_F_ECHO, rather than discarding
the whole idea. It's true that most netlink handlers don't handle it
properly, but some do and it happened to be useful on some projects I
worked on in the past.

> What makes this flag better than just issuing a GET command form user
> space?

I can see three problems with the extra GET command approach:

  * It's racy wrt. external processes. For example when creating a
    network device, the ifname might be changed by an external process
    between the RTM_NEWLINK and the RTM_GETLINK calls.

  * In some cases, you just don't have the required information to
    build a GET message. Reusing the previous example, one could let
    the kernel choose an ifname for the new device, to ensure the
    request isn't going to fail because another device with the same
    ifname already exists. Then there's no ifname or ifindex that can
    be used to query the new device.

  * GET obviously doesn't work after a DEL command. With NLM_F_ECHO,
    one can get the precise informations of the object that was
    deleted.

We can tell developpers to work around these problems by listening at
netlink notifications but that's not very practical. Depending on the
modified object it can be hard or maybe even impossible to accurately
match a notification with the original request. Also, in multi-threaded
programs, the notification handler will likely run in a different
thread. So extra synchronisation will be required between the thread
making the kernel request and the thread reading netlink events. With
NLM_F_ECHO the thread that makes the request can simply read its
netlink socket to get the information.

To summarise, NLM_F_ECHO allows a program to get a reliable feedback
on how the kernel handles its request. I'm not aware of any other
mechanism that provides this reliability.

> The flag was never checked on input and is not implemented by 99% of
> netlink families and commands.

There's at least one case where a netlink message handler later
realised that it needed to handle NLM_F_ECHO:
commit 993e4c929a07 ("netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID")

This commit avoided the need for RTM_NEWNSID to reimplement the same
mechanism in its own way in net/core/net_namespace.c:
https://lore.kernel.org/netdev/20190930160214.4512-1-nicolas.dichtel@6wind.com/#t

> I'd love to hear what others think. IMO we should declare a moratorium
> on any use of netlink flags and fixed fields, push netlink towards
> being a simple conduit for TLVs.

At my previous employer, we had a small program inserting and removing
routes depending on several external events (not a full-fledged routing
daemon). NLM_F_ECHO was used at least to log the real kernel actions (as
opposed to what the program intended to do) and link that to the events
that triggered these actions. That was really helpful for network
administrators. Yes, we were lucky that the RTM_NEWROUTE and
RTM_DELROUTE message handlers supported NLM_F_ECHO. I was surprised when
I later realised that RTM_NEWLINK and many others didn't.

Then, a few years ago, I had questions from another team (maybe Network
Manager but I'm not sure) who asked how to reliably retrieve
informations like the ifindex of newly created devices. That's the use
case NLM_F_ECHO is for, but lacking this feature this team had to rely
on a more convoluted and probably racy way. That was the moment I
decided to expose the problem to our team. Fast-forwarding a couple of
years and Hangbin picked up the task.

Sorry for the long email. I hope the context and use cases are clearer
now.

