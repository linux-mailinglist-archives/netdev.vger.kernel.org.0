Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC35A69C1BD
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 18:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjBSRjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 12:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjBSRjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 12:39:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74E211667
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 09:39:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id a5-20020a17090a70c500b00236679bc70cso1436729pjm.4
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oTkh7bHnBrf8xNH57JH5tGqLDGpDhBqqy/hYme6ukz8=;
        b=b0PRy2df0h/QuzcJKtpVT3Iqlths7wKM5grGB/305Fm4l21v6+aW/KMU9AUBknK88L
         nl9iIi4t65leMHaaFvQMwq1fENsGXflhM807PsZSOxbKfGjO8Nc3nztZbM0bz1l7nv77
         +OWspmDUAHdmc7aSiVIJP/h5GM0k4fg75CfiqF4nP0B5yEgpFkxN50KxwEbhKAIb6ULS
         OetFm9mzm9KBmKtSdLXEunCCYBgb40LVl7wVRXHefv4rkB3xkiynnjjxbMQ5XZINqNA+
         2lNMmXT2giF27HzhcvdmqBHhSniFcl8KKUejYj/1fRz9Hu07EQ3ZOMztr7srHp8NCeFK
         n5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTkh7bHnBrf8xNH57JH5tGqLDGpDhBqqy/hYme6ukz8=;
        b=PAj2QbPDF+CwiHXhGMCRb8B3pbj7ANoWFB/SeO+eyE3OfbRX+w2UCVmX5c0HOkq9QG
         lDDWAUDi81H7zvu0joi/choqowg+Ze5va6qPvCEGtUUxLeNmyZDCW+dTC21KTTRqRRGS
         +LJfK5qWKmxCBDTvy+EOCqdyohr6885xIUDJzsxsQKTiwufFYGKzOBUkfbMtZ8yZCqg7
         DSzQzw28FbNBB3fO8p+wPviPgvpXyuuzUUuiuaK2ViIFxPSnx7jjjTKy4uU7x2GcJF20
         6vdzbypjuaeC7Rfiw3Gz+aMZO2f6xCiJf3rNYRthFSjjj0RHqPWAukr1b3qciUL9IBeD
         FP8Q==
X-Gm-Message-State: AO0yUKUFl3rD5e3ZxdBre59E2+0qnCat2DR8bam6RalMKyuQ/3A4KVhn
        UHycQQHSeKO4D61Gz8TFowE=
X-Google-Smtp-Source: AK7set/QKC/2k3FwPbUMOscElw0F0Qm9fg7Y/0xvH9CNOzkZ3cZEs2VCN9vzW06iAU+q3YnWJ4A4Yw==
X-Received: by 2002:a17:902:e745:b0:19a:8284:8398 with SMTP id p5-20020a170902e74500b0019a82848398mr3526173plf.14.1676828384792;
        Sun, 19 Feb 2023 09:39:44 -0800 (PST)
Received: from [192.168.0.128] ([98.97.32.92])
        by smtp.googlemail.com with ESMTPSA id jd7-20020a170903260700b00194a297cb8esm6255769plb.191.2023.02.19.09.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 09:39:44 -0800 (PST)
Message-ID: <87a68b97ca35255bd7cf406819a2030e77c12f8b.camel@gmail.com>
Subject: Re: Kernel interface to configure queue-group parameters
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Date:   Sun, 19 Feb 2023 09:39:42 -0800
In-Reply-To: <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
         <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
         <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
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

On Thu, 2023-02-16 at 02:35 -0800, Nambiar, Amritha wrote:
> On 2/7/2023 8:28 AM, Alexander H Duyck wrote:
> > On Mon, 2023-02-06 at 16:15 -0800, Nambiar, Amritha wrote:
> > > Hello,
> > >=20
> > > We are looking for feedback on the kernel interface to configure
> > > queue-group level parameters.
> > >=20
> > > Queues are primary residents in the kernel and there are multiple
> > > interfaces to configure queue-level parameters. For example, tx_maxra=
te
> > > for a transmit queue can be controlled via the sysfs interface. Ethto=
ol
> > > is another option to change the RX/TX ring parameters of the specifie=
d
> > > network device (example, rx-buf-len, tx-push etc.).
> > >=20
> > > Queue_groups are a set of queues grouped together into a single objec=
t.
> > > For example, tx_queue_group-0 is a transmit queue_group with index 0 =
and
> > > can have transmit queues say 0-31, similarly rx_queue_group-0 is a
> > > receive queue_group with index 0 and can have receive queues 0-31,
> > > tx/rx_queue_group_1 may consist of TX and RX queues say 32-127
> > > respectively. Currently, upstream drivers for both ice and mlx5 suppo=
rt
> > > creating TX and RX queue groups via the tc-mqprio and ethtool interfa=
ces.
> > >=20
> > > At this point, the kernel does not have an abstraction for queue_grou=
p.
> > > A close equivalent in the kernel is a 'traffic class' which consists =
of
> > > a set of transmit queues. Today, traffic classes are created using TC=
's
> > > mqprio scheduler. Only a limited set of parameters can be configured =
on
> > > each traffic class via mqprio, example priority per traffic class, mi=
n
> > > and max bandwidth rates per traffic class etc. Mqprio also supports
> > > offload of these parameters to the hardware. The parameters set for t=
he
> > > traffic class (tx queue_group) is applicable to all transmit queues
> > > belonging to the queue_group. However, introducing additional paramet=
ers
> > > for queue_groups and configuring them via mqprio makes the interface
> > > less user-friendly (as the command line gets cumbersome due to the
> > > number of qdisc parameters). Although, mqprio is the interface to cre=
ate
> > > transmit queue_groups, and is also the interface to configure and
> > > offload certain transmit queue_group parameters, due to these
> > > limitations we are wondering if it is worth considering other interfa=
ce
> > > options for configuring queue_group parameters.
> > >=20
> >=20
> > I think much of this depends on exactly what functionality we are
> > talking about. The problem is the Intel use case conflates interrupts
> > w/ queues w/ the applications themselves since what it is trying to do
> > is a poor imitation of RDMA being implemented using something akin to
> > VMDq last I knew.
> >=20
> > So for example one of the things you are asking about below is
> > establishing a minimum rate for outgoing Tx packets. In my mind we
> > would probably want to use something like mqprio to set that up since
> > it is Tx rate limiting and if we were to configure it to happen in
> > software it would need to be handled in the Qdisc layer.
> >=20
>=20
> Configuring min and max rates for outgoing TX packets are already=20
> supported in ice driver using mqprio. The issue is that dynamically=20
> changing the rates per traffic class/queue_group via mqprio is not=20
> straightforward, the "tc qdisc change" command will need all the rates=
=20
> for traffic classes again, even for the tcs where rates are not being=20
> changed.
> For example, here's the sample command to configure min and max rates on=
=20
> 4 TX queue groups:
>=20
> # tc qdisc add dev $iface root mqprio \
>                        num_tc 4        \
>                        map 0 1 2 3     \
>                        queues 2@0 4@2 8@6 16@14  \
>                        hw 1 mode channel \
>                        shaper bw_rlimit \
>                        min_rate 1Gbit 2Gbit 2Gbit 1Gbit\
>                        max_rate 4Gbit 5Gbit 5Gbit 10Gbit
>=20
> Now, changing TX min_rate for TC1 to 20 Gbit:
>=20
> # tc qdisc change dev $iface root mqprio \
>    shaper bw_rlimit min_rate 1Gbit 20Gbit 2Gbit 1Gbit
>=20
> Although this is not a major concern, I was looking for the simplicity=
=20
> that something like sysfs provides with tx_maxrate for a queue, so that=
=20
> when there are large number of tcs, just the ones that are being changed=
=20
> needs to be dealt with (if we were to have sysfs rates per queue_group).

So it sounds like there is an interface already, you may just not like
having to work with it due to the userspace tooling. Perhaps the
solution would be to look at fixing things up so that the tooling would
allow you to make changes to individual values. I haven't looked into
the interface much but is there any way to retrieve the current
settings from the Qdisc? If so you might be able to just update tc so
that it would allow incremental updates and fill in the gaps with the
config it already has.

> > As far as the NAPI pollers attribute that seems like something that
> > needs further clarification. Are you limiting the number of busy poll
> > instances that can run on a single queue group? Is there a reason for
> > doing it per queue group instead of this being something that could be
> > enabled on a specific set of queues within the group?
> >=20
>=20
> Yes, we are trying to limit the number of napi instances for the queues=
=20
> within a queue-group. Some options we could use:
>=20
> 1. A 'num_poller' attribute on a queue_group level - The initial idea=20
> was to configure the number of poller threads that would be handling the=
=20
> queues within the queue_group, as an example, a num_poller value of 4 on=
=20
> a queue_group consisting of 4 queues would imply that there is a poller=
=20
> per queue. This could also be changed to something like a single poller=
=20
> for all 4 queues within the group.
>=20
> 2. A poller bitmap for each queue (both TX and RX) - The main concern=20
> with the queue-level maps is that it would still be nice to have a=20
> higher level queue-group isolation, so that a poller is not shared among=
=20
> queues belonging to distinct queue-groups. Also, a queue-group level=20
> config would consolidate the mapping of queues and vectors in the driver=
=20
> in batches, instead of the driver having to update the queue<->vector=20
> mapping in response to each queue's poller configuration.
>=20
> But we could do away with having these at queue-group level, and instead=
=20
> use a different method as the third option below:
> 3. A queues bitmap per napi instance - So the default arrangement today=
=20
> is 1:1 mapping between queues and interrupt vectors and hence 1:1=20
> queue<->poller association. If the user could configure one interrupt=20
> vector to serve different queues, these queues can be serviced by the=20
> poller/napi instance for the vector.
> One way to do this is to have a bitmap of queues for each IRQ allocated=
=20
> for the device (similar to smp_affinity CPUs bitmap for the given IRQ).=
=20
> So, /sys/class/net/<iface>/device/msi_irqs/ lists all the IRQs=20
> associated with the network interface. If the IRQ can take additional=20
> attribute like queues_affinity for the IRQs on the network device (use=
=20
> /sys/class/net/<iface>/device/msi_irqs/N/ since queues_affinity would be=
=20
> specific to the network subsystem), this would enable multiple queues=20
> <-> single vector association configurable by the user. The driver would=
=20
> validate that a queue is not mapped multiple interrupts. This way an=20
> interrupt can be shared among different queues as configured by the user.
> Another approach is to expose the napi-ids via sysfs and support=20
> per-napi attributes.
> /sys/class/net/<iface>/napis/napi<0-N>
> Each numbered sub-directory N contains attributes of that napi. A=20
> 'napi_queues' attribute would be a bitmap of queues associated with the=
=20
> napi-N enabling many queues <-> single napi association. Example,=20
> /sys/class/net/<iface>/napis/napi-N/napi_queues
>=20
> We also plan to introduce an additional napi attribute for each napi=20
> instance called 'poller_timeout' indicating the timeout in jiffies.=20
> Exposing the napi-ids would also enable moving some existing napi=20
> attributes such as 'threaded' and 'napi_defer_hard_irqs' etc. (which are=
=20
> currently per netdev) to be per napi instance.

This one will require more thought and discussion as the NAPI instances
themselves have been something that was largely hidden and not exposed
to userspace up until now.

However with that said I am pretty certain sysfs isn't the way to go.

> > > Likewise, receive queue_groups can be created using the ethtool
> > > interface as RSS contexts. Next step would be to configure
> > > per-rx_queue_group parameters. Based on the discussion in
> > > https://lore.kernel.org/netdev/20221114091559.7e24c7de@kernel.org/,
> > > it looks like ethtool may not be the right interface to configure
> > > rx_queue_group parameters (that are unrelated to flow<->queue
> > > assignment), example NAPI configurations on the queue_group.
> > >=20
> > > The key gaps in the kernel to support queue-group parameters are:
> > > 1. 'queue_group' abstraction in the kernel for both TX and RX distinc=
tly
> > > 2. Offload hooks for TX/RX queue_group parameters depending on the
> > > chosen interface.
> > >=20
> > > Following are the options we have investigated:
> > >=20
> > > 1. tc-mqprio:
> > >      Pros:
> > >      - Already supports creating queue_groups, offload of certain par=
ameters
> > >=20
> > >      Cons:
> > >      - Introducing new parameters makes the interface less user-frien=
dly.
> > >    TC qdisc parameters are specified at the qdisc creation, larger th=
e
> > > number of traffic classes and their respective parameters, lesser the
> > > usability.
> >=20
> > Yes and no. The TC layer is mostly meant for handling the Tx side of
> > things. For something like the rate limiting it might make sense since
> > there is already logic there to do it in mqprio. But if you are trying
> > to pull in NAPI or RSS attributes then I agree it would hurt usability.
> >=20
>=20
> The TX queue-group parameters supported via mqprio are limited to=20
> priority, min and max rates. I think extending mqprio for a larger set=
=20
> of TX parameters beyond just rates (say max burst) would bloat up the=20
> command line. But yes, I agree, the TC layer is not the place for NAPI=
=20
> attributes on TX queues.

The problem is you are reinventing the wheel. It sounds like this
mostly does what you are looking for. If you are going to look at
extending it then you should do so. Otherwise maybe you need to look at
putting together a new Qdisc instead of creating an entirely new
infrastructure since Qdisc is how we would deal with implementing
something like this in software. We shouldn't be bypassing that as we
should be implementing an equivilent for what we are wanting to do in
hardware in the software.

> > > 2. Ethtool:
> > >      Pros:
> > >      - Already creates RX queue_groups as RSS contexts
> > >=20
> > >      Cons:
> > >      - May not be the right interface for non-RSS related parameters
> > >=20
> > >      Example for configuring number of napi pollers for a queue group=
:
> > >      ethtool -X <iface> context <context_num> num_pollers <n>
> >=20
> > One thing that might make sense would be to look at adding a possible
> > alias for context that could work with something like DCB or the queue
> > groups use case. I believe that for DCB there is a similar issue where
> > the various priorities could have seperate RSS contexts so it might
> > make sense to look at applying a similar logic. Also there has been
> > talk about trying to do the the round robin on SYN type logic. That
> > might make sense to expose as a hfunc type since it would be overriding
> > RSS for TCP flows.
> >=20
>=20
> For the round robin flow steering of TCP flows (on SYN by overriding RSS=
=20
> hash), the plan was to add a new 'inline_fd' parameter to ethtool rss=20
> context. Will look into your suggestion for using hfunc type.

It sounds like we are generally thinking in the same area so that is a
good start there.

> >=20
> > > 3. sysfs:
> > >      Pros:
> > >      - Ideal to configure parameters such as NAPI/IRQ for Rx queue_gr=
oup.
> > >      - Makes it possible to support some existing per-netdev napi
> > > parameters like 'threaded' and 'napi_defer_hard_irqs' etc. to be
> > > per-queue-group parameters.
> > >=20
> > >      Cons:
> > >      - Requires introducing new queue_group structures for TX and RX
> > > queue groups and references for it, kset references for queue_group i=
n
> > > struct net_device
> > >      - Additional ndo ops in net_device_ops for each parameter for
> > > hardware offload.
> > >=20
> > >      Examples :
> > >      /sys/class/net/<iface>/queue_groups/rxqg-<0-n>/num_pollers
> > >      /sys/class/net/<iface>/queue_groups/txqg-<0-n>/min_rate
> >=20
> > So min_rate is something already handled in mqprio since it is so DCB
> > like. You are essentially guaranteeing bandwidth aren't you? Couldn't
> > you just define a bw_rlimit shaper for mqprio and then use the existing
> > bw_rlimit values to define the min_rate?
> >=20
>=20
> The ice driver already supports min_rate per queue_group using mqprio. I=
=20
> was suggesting this in case we happen to have a TX queue_group object,=
=20
> since dynamically changing rates via mqprio was not handy enough as I=20
> mentioned above.

Yeah, but based on the description you are rewriting the kernel side
because you don't like dealing with the userspace tools. Again maybe
the solution here would be to look at cleaning up the userspace
interface to add support for reading/retrieving the existing values and
then updating instead of requiring a complete update every time.

What we want to avoid is creating new overhead in the kernel where we
now have yet another way to control Tx rates as each redundant
interface added is that much more overhead that has to be dealt with
throughout the Tx path. If we already have a way to do this with mqprio
lets support just offloading that into hardware rather than adding yet
another Tx rate control.

> > As far as adding the queue_groups interface one ugly bit would be that
> > we would probably need to have links between the queues and these
> > groups which would start to turn the sysfs into a tangled mess.
> >=20
> Agree, maintaining the links between queues and groups is not trivial.
>=20
> > The biggest issue I see is that there isn't any sort of sysfs interface
> > exposed for NAPI which is what you would essentially need to justify
> > something like this since that is what you are modifying.
> >=20
>=20
> Right. Something like /sys/class/net/<iface>/napis/napi<0-N>
> Maybe, initially there would be as many napis as queues due to 1:1=20
> association, but as the queues bitmap is tuned for the napi, only those=
=20
> napis that have queue[s] associated with it would be exposed.

As Jakub already pointed out adding more sysfs is generally frowned
upon.
