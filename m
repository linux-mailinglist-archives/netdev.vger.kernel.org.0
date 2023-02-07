Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FE168DDF7
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjBGQ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjBGQ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:29:06 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735AD3E0B5
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:29:01 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d6-20020a17090ae28600b00230aa72904fso7222177pjz.5
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 08:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FmGEh2FI/6MrkraYmiCWUfza0qpbPHyiGlK1HWz2hT8=;
        b=ggjMvdAIQOjaHki3bXnKIrfiCF4Eb9HuJL/sdU63NyjBaBv25vJA2zz3FKRqm6br3A
         CY62rbJ8kKZeELSUWBleLbp4ltZ5dGJdd8pUBapJi/4tE0wKSUG2XpFPAtnBsf8Ib7lc
         pWQsyjQwUB2bWJTNGIbYi37vFbMb2NOgFvHdss/k1vSykfT3E2EWhGUfck15xw9oNTpp
         tRbfVRq86psTQP7fkpG1+U2NbrWhnMgC9Z8juBNgbeUsMBvaqIUSnRVv6tr5kdJgfE8D
         8CIMUQIHOwI7jFeXImVmrzlSCAaOxKRrs5M7+wK1S3e+DqdX2n3OT2jHmwXLiHosXtu+
         SvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FmGEh2FI/6MrkraYmiCWUfza0qpbPHyiGlK1HWz2hT8=;
        b=7ZrpnX2i+AIFVPscNLeBo6DoJmrm9UPBc/huvOiDamaKIs5GhbV7MXnb52WxK0fcr7
         FhTHCjIX6HosHCqk2dR2tya6UMHcWCCgH4hV2FZ8jh8Nxj83UWudkSK20mZQaaAIWlkW
         /X4lvOQ1EAqsgt9SzV94B15YhAtzEcd1h7sJYuJxx1RQOOpl9ot3V+7tbQPC8LedV/Ys
         lOQ/gKdwzeB++D4mxsqaKuYElSczJSW8tVRah/9/qHKKmQ/Q5r62lsmTnDE08XWCA6Lo
         Vx2URaaDX8G4fUOj/I0Eucj06rrLf6h4+Jng8y5LKoHq4IzMcVbYCdsk+09L6rF8JVcH
         gLsQ==
X-Gm-Message-State: AO0yUKVP3GdDs2X5LW/PkjJdTMNDegi1/o6HEw45Xm+C701/It4iROrd
        qpr2ZeIJRh40mZXiWfmyk7cHKcf+xTU=
X-Google-Smtp-Source: AK7set9ktWSM6oQC1YBC9hl1coIvEHU3YViet5gkMag4tBP/6vMC5Z4exvv1wAb071KRI3y3UCp+Iw==
X-Received: by 2002:a17:90b:3a8b:b0:230:a183:847e with SMTP id om11-20020a17090b3a8b00b00230a183847emr4755036pjb.3.1675787340383;
        Tue, 07 Feb 2023 08:29:00 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id mm18-20020a17090b359200b0022bbad75af6sm1870696pjb.1.2023.02.07.08.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 08:28:59 -0800 (PST)
Message-ID: <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
Subject: Re: Kernel interface to configure queue-group parameters
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Date:   Tue, 07 Feb 2023 08:28:56 -0800
In-Reply-To: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-06 at 16:15 -0800, Nambiar, Amritha wrote:
> Hello,
>=20
> We are looking for feedback on the kernel interface to configure=20
> queue-group level parameters.
>=20
> Queues are primary residents in the kernel and there are multiple=20
> interfaces to configure queue-level parameters. For example, tx_maxrate=
=20
> for a transmit queue can be controlled via the sysfs interface. Ethtool=
=20
> is another option to change the RX/TX ring parameters of the specified=
=20
> network device (example, rx-buf-len, tx-push etc.).
>=20
> Queue_groups are a set of queues grouped together into a single object.=
=20
> For example, tx_queue_group-0 is a transmit queue_group with index 0 and=
=20
> can have transmit queues say 0-31, similarly rx_queue_group-0 is a=20
> receive queue_group with index 0 and can have receive queues 0-31,=20
> tx/rx_queue_group_1 may consist of TX and RX queues say 32-127=20
> respectively. Currently, upstream drivers for both ice and mlx5 support=
=20
> creating TX and RX queue groups via the tc-mqprio and ethtool interfaces.
>=20
> At this point, the kernel does not have an abstraction for queue_group.=
=20
> A close equivalent in the kernel is a 'traffic class' which consists of=
=20
> a set of transmit queues. Today, traffic classes are created using TC's=
=20
> mqprio scheduler. Only a limited set of parameters can be configured on=
=20
> each traffic class via mqprio, example priority per traffic class, min=
=20
> and max bandwidth rates per traffic class etc. Mqprio also supports=20
> offload of these parameters to the hardware. The parameters set for the=
=20
> traffic class (tx queue_group) is applicable to all transmit queues=20
> belonging to the queue_group. However, introducing additional parameters=
=20
> for queue_groups and configuring them via mqprio makes the interface=20
> less user-friendly (as the command line gets cumbersome due to the=20
> number of qdisc parameters). Although, mqprio is the interface to create=
=20
> transmit queue_groups, and is also the interface to configure and=20
> offload certain transmit queue_group parameters, due to these=20
> limitations we are wondering if it is worth considering other interface=
=20
> options for configuring queue_group parameters.
>=20

I think much of this depends on exactly what functionality we are
talking about. The problem is the Intel use case conflates interrupts
w/ queues w/ the applications themselves since what it is trying to do
is a poor imitation of RDMA being implemented using something akin to
VMDq last I knew.

So for example one of the things you are asking about below is
establishing a minimum rate for outgoing Tx packets. In my mind we
would probably want to use something like mqprio to set that up since
it is Tx rate limiting and if we were to configure it to happen in
software it would need to be handled in the Qdisc layer.

As far as the NAPI pollers attribute that seems like something that
needs further clarification. Are you limiting the number of busy poll
instances that can run on a single queue group? Is there a reason for
doing it per queue group instead of this being something that could be
enabled on a specific set of queues within the group?

> Likewise, receive queue_groups can be created using the ethtool=20
> interface as RSS contexts. Next step would be to configure=20
> per-rx_queue_group parameters. Based on the discussion in=20
> https://lore.kernel.org/netdev/20221114091559.7e24c7de@kernel.org/,
> it looks like ethtool may not be the right interface to configure=20
> rx_queue_group parameters (that are unrelated to flow<->queue=20
> assignment), example NAPI configurations on the queue_group.
>=20
> The key gaps in the kernel to support queue-group parameters are:
> 1. 'queue_group' abstraction in the kernel for both TX and RX distinctly
> 2. Offload hooks for TX/RX queue_group parameters depending on the=20
> chosen interface.
>=20
> Following are the options we have investigated:
>=20
> 1. tc-mqprio:
>     Pros:
>     - Already supports creating queue_groups, offload of certain paramete=
rs
>=20
>     Cons:
>     - Introducing new parameters makes the interface less user-friendly.=
=20
>   TC qdisc parameters are specified at the qdisc creation, larger the=20
> number of traffic classes and their respective parameters, lesser the=20
> usability.

Yes and no. The TC layer is mostly meant for handling the Tx side of
things. For something like the rate limiting it might make sense since
there is already logic there to do it in mqprio. But if you are trying
to pull in NAPI or RSS attributes then I agree it would hurt usability.

> 2. Ethtool:
>     Pros:
>     - Already creates RX queue_groups as RSS contexts
>=20
>     Cons:
>     - May not be the right interface for non-RSS related parameters
>=20
>     Example for configuring number of napi pollers for a queue group:
>     ethtool -X <iface> context <context_num> num_pollers <n>

One thing that might make sense would be to look at adding a possible
alias for context that could work with something like DCB or the queue
groups use case. I believe that for DCB there is a similar issue where
the various priorities could have seperate RSS contexts so it might
make sense to look at applying a similar logic. Also there has been
talk about trying to do the the round robin on SYN type logic. That
might make sense to expose as a hfunc type since it would be overriding
RSS for TCP flows.

The num_pollers can be problematic though as we don't really have
anything like that in ethtool currently. Probably the closest thing I
can think of is interrupt moderation. It depends on if it has to be a
per queue group attribute or if it could be a per-queue attrtibute.
Specifically I am referring to the -Q option that is currently applied
to the coalescing functions in ethtool.=20

> 3. sysfs:
>     Pros:
>     - Ideal to configure parameters such as NAPI/IRQ for Rx queue_group.
>     - Makes it possible to support some existing per-netdev napi=20
> parameters like 'threaded' and 'napi_defer_hard_irqs' etc. to be=20
> per-queue-group parameters.
>=20
>     Cons:
>     - Requires introducing new queue_group structures for TX and RX=20
> queue groups and references for it, kset references for queue_group in=
=20
> struct net_device
>     - Additional ndo ops in net_device_ops for each parameter for=20
> hardware offload.
>=20
>     Examples :
>     /sys/class/net/<iface>/queue_groups/rxqg-<0-n>/num_pollers
>     /sys/class/net/<iface>/queue_groups/txqg-<0-n>/min_rate

So min_rate is something already handled in mqprio since it is so DCB
like. You are essentially guaranteeing bandwidth aren't you? Couldn't
you just define a bw_rlimit shaper for mqprio and then use the existing
bw_rlimit values to define the min_rate?

As far as adding the queue_groups interface one ugly bit would be that
we would probably need to have links between the queues and these
groups which would start to turn the sysfs into a tangled mess.

The biggest issue I see is that there isn't any sort of sysfs interface
exposed for NAPI which is what you would essentially need to justify
something like this since that is what you are modifying.

> 4. Devlink:
>     Pros:
>     - New parameters can be added without any changes to the kernel or=
=20
> userspace.
>=20
>     Cons:
>     - Queue/Queue_group is a function-wide entity, Devlink is for=20
> device-wide stuff. Devlink being device centric is not suitable for=20
> queue parameters such as rates, NAPI etc.

Yeah, I wouldn't expect something like this to be a good fit.
