Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED60594E7F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiHPCJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiHPCJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:09:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AF71152D2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660601072; x=1692137072;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=mCnPGuBTSAbumhTTiZQTUjaZShN9K8bfCZ3fCP2Fa9k=;
  b=dVnEU6o1Ql6/YxYeDKC+uSwX49RXPGbKc10GPfwXnbqzyLtmQjqBWUzS
   siylWJQciX/xSt/jyihaxaC99LQQy5uaJjqrhXePkPFSw7Iws9LaTCWId
   MJI3i1hY6GzJl5cKqjnjoFPEil5o4Ds6dumekGZ10EwN4PDyD0PlQn3aU
   z/wyByCm4qmUUgoLQP+b6labyuFN9Uv74Y1FocKL7+KLOZCkOpY/rCQpK
   07j/cvmWdXIws3D2Pce2GTOMq2vPzGNqBkYGXwdK4JeyXiqT6lRwoU2ow
   wTBFmqom0Po7zPX3qVi8TZlQl/QkkDfxp0VMX5ls2p0MHmFE3qT1//axB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="353809749"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="353809749"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 15:04:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="603315542"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 15:04:32 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
Cc:     "marton12050@gmail.com" <marton12050@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <1016fb1e514ff38ebfd22c52e2d848a7e8bc8d1a.camel@ericsson.com>
References: <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf>
 <1016fb1e514ff38ebfd22c52e2d848a7e8bc8d1a.camel@ericsson.com>
Date:   Mon, 15 Aug 2022 15:04:31 -0700
Message-ID: <87pmh1i2og.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

Ferenc Fejes <ferenc.fejes@ericsson.com> writes:

> Hi Vladimir!
>
> Thank you for the reply!
>
> On Fri, 2022-08-12 at 20:16 +0000, Vladimir Oltean wrote:
>> Hi Ferenc,
>>=20
>> On Fri, Aug 12, 2022 at 02:13:52PM +0000, Ferenc Fejes wrote:
>> > Ethtool after the measurement:
>> > ethtool -S enp3s0 | grep hwtstamp
>> > =C2=A0=C2=A0=C2=A0=C2=A0 tx_hwtstamp_timeouts: 1
>> > =C2=A0=C2=A0=C2=A0=C2=A0 tx_hwtstamp_skipped: 419
>> > =C2=A0=C2=A0=C2=A0=C2=A0 rx_hwtstamp_cleared: 0
>> >=20
>> > Which is inline with what the isochron see.
>> >=20
>> > But thats only happens if I forcingly put the affinity of the
>> > sender
>> > different CPU core than the ptp worker of the igc. If those running
>> > on
>> > the same core I doesnt lost any HW timestam even for 10 million
>> > packets. Worth to mention actually I see many lost timestamp which
>> > confused me a little bit but those are lost because of the small
>> > MSG_ERRQUEUE. When I increased that from few kbytes to 20 mbytes I
>> > got
>> > every timestamp successfully.
>>=20
>> I have zero knowledge of Intel hardware. That being said, I've looked
>> at
>> the driver for about 5 minutes, and the design seems to be that where
>> the timestamp is not available in band from the TX completion NAPI as
>> part of BD ring metadata, but rather, a TX timestamp complete is
>> raised,
>> and this results in igc_tsync_interrupt() being called. However there
>> are 2 paths in the driver which call this, one is igc_msix_other()
>> and
>> the other is igc_intr_msi() - this latter one is also the interrupt
>> that
>> triggers the napi_schedule(). It would be interesting to see exactly
>> which MSI-X interrupt is the one that triggers igc_tsync_interrupt().
>>=20
>> It's also interesting to understand what you mean precisely by
>> affinity
>> of isochron. It has a main thread (used for PTP monitoring and for TX
>> timestamps) and a pthread for the sending process. The main thread's
>> affinity is controlled via taskset; the sender thread via --cpu-mask.
>
> I just played with those a little. Looks like the --cpu-mask the one it
> helps in my case. For example I checked the CPU core of the
> igc_ptp_tx_work:
>
> # bpftrace -e 'kprobe:igc_ptp_tx_work { printf("%d\n", cpu); exit(); }'
> Attaching 1 probe...
> 0
>
> Looks like its running on core 0, so I run the isochro:
> taskset -c 0 isochron ... --cpu-mask $((1 << 0)) - no lost timestamps
> taskset -c 1 isochron ... --cpu-mask $((1 << 0)) - no lost timestamps
> taskset -c 0 isochron ... --cpu-mask $((1 << 1)) - losing timestamps
> taskset -c 1 isochron ... --cpu-mask $((1 << 1)) - losing timestamps
>
>> Is it the *sender* thread the one who makes the TX timestamps be
>> available quicker to user space, rather than the main thread, who
>> actually dequeues them from the error queue? If so, it might be
>> because
>> the TX packets will trigger the TX completion interrupt, and this
>> will
>> accelerate the processing of the TX timestamps. I'm unclear what
>> happens
>> when the sender thread runs on a different CPU core than the TX
>> timestamp thread.
>
> Well I have no clue unfortunately but your theory makes sense. Vinicius
> might help us out here.
>

I think it's more related to the synchronization (and communication)
overhead of having two CPUs involved. And the fact that the workqueue
runs with low priority (as Vladimir pointed out below) on a different
CPU doesn't help.

>>=20
>> Your need to increase the SO_RCVBUF is also interesting. Keep in mind
>> that isochron at that scheduling priority and policy is a CPU hog,
>> and
>> that igc_tsync_interrupt() calls schedule_work() - which uses the
>> system
>> workqueue that runs at a very low priority (this begs the question,
>> how
>> do you know how to match the CPU on which isochron runs with the CPU
>> of
>> the system workqueue?). So isochron, high priority, competes for CPU
>> time with igc_ptp_tx_work(), low priority. One produces data, one
>> consumes it; queues are bound to get full at some point.
>
> Maybe this is what helps in my case? With funccount tracer I checked
> that when the sender thread and igc_ptp_tx_work running on the same
> core, the worker called exactly as many times as many packets I sent.
>
> However if the worker running on different core, funccount show some
> random number (less than the packets sent) and in that case I also lost
> timestamps.
>
> I'm not sure what happening here, maybe the "deferred" scheduling of
> the worker sometimes too slow to enqueue every timestamp into the error
> queue? And because I force both the sender and worker to the same core,
> they executed in order (my system pretty much idle other than these
> processes) introducing some sort of throtthling to the timestamp
> processing?
>
>> On the other hand, other drivers use the ptp_aux_kworker() that the
>> PTP
>> core creates specifically for this purpose. It is a dedicated kthread
>> whose scheduling policy and priority can be adjusted using chrt. I
>> think
>> it would be interesting to see how things behave when you replace
>> schedule_work() with ptp_schedule_worker().
>
> I will try to take a look into that. Anyway, thank you for the
> insights, I'm happy with the way how it works now (at least I can do my
> experiments with that).
>
> Best,
> Ferenc
>

--=20
Vinicius
