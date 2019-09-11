Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD27AFBEE
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfIKLwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:52:03 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38955 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKLwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:52:02 -0400
Received: by mail-ed1-f65.google.com with SMTP id u6so20347680edq.6
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B7c7IwvPkgdHKLA3bcyOTs9rxT0PtGRTUmUrnvwuCTc=;
        b=CbWbmkwscCDYhGrNG8hCdvF9gEsu6MmjGx/wKoFcqNptXgRomEnnrDAQfWCwEOwZrG
         PCzNh6U9aCed80C/e0vRwTzk9GdTbELXTDcRKFrFZ6IdgT9DLtmQbeEKr5xx0hHD/l3g
         6u8BMQpE2+FCJ4R5TkCgdds+/shH+xSyKAhCuHtcg5NO8pGQ13oztKTYWh4bUgZkMIKq
         XE0jMJCpGPqekNhxUYw9AX7u0ZMlZGomNHfyg4JY9TDZlF5ABveVqqwFjbA2hAQ4TFkI
         3u5IRkgExCAW1W0ybrhbOC1KKgLOYULcKSthFAc1CzVpuBOS/AW44R8AqEosVaaXuYMb
         QcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B7c7IwvPkgdHKLA3bcyOTs9rxT0PtGRTUmUrnvwuCTc=;
        b=RKpXC1WztTN1Eh1tptzJv8VUTcDAmNoaGJkwtYoviOSF7iECD6hzvSuZ2QlkzbnlLc
         EHsOGTseD5jMcxyK/RPPXTjLVdxq2CAY9UsVZDWPd8ZTgM98q5dd6pJg1jl9E/0HHsAB
         Px1aCtw1Gifd2ZMFbCtJzDjt76KSktGnJ1y+8kdKl1rGD5OQssq5nXWiPdfLSGmNRtPa
         cxqqcAyzjSJ8/iAUazWCkKMgwr2U7LpVTts1K079rInkOqY/V3QG5Rz00sVoyV9snCIX
         R+TnNgSczYu9nolNL3rxAhy+tY4rM1BbCu+LEfe3D1xvj7U2NIdEiK0UxsJdK3pcrmPq
         /v0Q==
X-Gm-Message-State: APjAAAVTkZlTSLbFr0Eees4BUbwug73ILiS8d4XrWxWU87dErp/ffokM
        oF+zJRJoTUNYrBoID4Cdv6pg7ouRbQePdhAQ4tU=
X-Google-Smtp-Source: APXvYqy4UYPAnzouTHlX+OAl222e72g0qsqIu5+7yO/HBQmTQSRU3F1pp0oPAT9y32fjB5TiqGnHxGrIMfSn0p9Ivm4=
X-Received: by 2002:aa7:d755:: with SMTP id a21mr35614807eds.18.1568202720119;
 Wed, 11 Sep 2019 04:52:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Wed, 11 Sep 2019 04:51:59
 -0700 (PDT)
In-Reply-To: <BN6PR11MB0050D9E694A143CBBAA24E2986B10@BN6PR11MB0050.namprd11.prod.outlook.com>
References: <20190902162544.24613-1-olteanv@gmail.com> <20190907.155549.1880685136488421385.davem@davemloft.net>
 <BN6PR11MB00500FA0D6B5D39E794B44BB86B70@BN6PR11MB0050.namprd11.prod.outlook.com>
 <CA+h21hoQ-DaFGzALVmGo2mDJancUp5Fndc=o0f4LfD_9yaNi0g@mail.gmail.com> <BN6PR11MB0050D9E694A143CBBAA24E2986B10@BN6PR11MB0050.namprd11.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Sep 2019 12:51:59 +0100
Message-ID: <CA+h21hrL+HqgnsOgixWeuZv=ki1pxEOH54fY2YKyaa6MBa=1OA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
To:     "Gomes, Vinicius" <vinicius.gomes@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Patel, Vedang" <vedang.patel@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kurt.kanzenbach@linutronix.de" <kurt.kanzenbach@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 11/09/2019, Gomes, Vinicius <vinicius.gomes@intel.com> wrote:
> Hi Vladimir,
>
> [...]
>
>>
>> I'll make sure this subtlety is more clearly formulated in the next
>> version of the
>> patch.
>>
>
> Ack.
>
>> Actually let me ask you a few questions as well:
>>
>> - I'm trying to understand what is the correct use of the tc-mqprio
>> "queues"
>> argument. I've only tested it with "1@0 1@1 1@2 1@3 1@4 1@5
>> 1@6 1@7", which I believe is equivalent to not specifying it at all? I
>> believe it
>> should be interpreted as: "allocate this many netdev queues for each
>> traffic
>> class", where "traffic class" means a group of queues having the same
>> priority
>> (equal to the traffic class's number), but engaged in a strict priority
>> scheme with
>> other groups of queues (traffic classes). Right?
>
> Specifying the "queues" is mandatory, IIRC. Yeah, your reading of those
> arguments
> for you example matches mine.
>
> So you mean, that you only tested situations when only one queue is "open=
"
> at a time?
> I think this is another good thing to test.
>

No, I tested (using the "gatemask" shell function I wrote as a wrapper
for the SetGateStates command in tc-taprio) a schedule comprised of:
gatemask 7 # PTP
gatemask 5 # My scheduled traffic with clock_nanosleep()
gatemask "0 1 2 3 4 6" # Everything else

>>
>> - DSA can only formally support multi-queue, because its connection to t=
he
>> Linux
>> host is through an Ethernet MAC (FIFO). Even if the DSA master netdevice
>> may
>> be multi-queue, allocating and separating those queues for each
>> front-panel
>> switch port is a task best left to the user/administrator. This means th=
at
>> DSA
>> should reject all other "queues" mappings except the trivial one I point=
ed
>> to
>> above?
>>
>> - I'm looking at the "tc_mask_to_queue_mask" function that I'm carrying
>> along
>> from your initial offload RFC. Are you sure this is the right approach? =
I
>> don't feel
>> a need to translate from traffic class to netdev queues, considering tha=
t
>> in the
>> general case, a traffic class is a group of queues, and 802.1Qbv doesn't
>> really
>> specify that you can gate individual queues from a traffic class. In the
>> software
>> implementation you are only looking at netdev_get_prio_tc_map, which is
>> not
>> equivalent as far as my understanding goes, but saner.
>> Actually 802.1Q-2018 does not really clarify this either. It looks to me
>> like they
>> use the term "queue" and "traffic class" interchangeably.
>> See two examples below (emphasis mine):
>
> I spent quite a long time thinking about this, still not sure that I got =
it
> right. Let me begin
> with the objective for that "translation". Scheduled traffic only makes
> sense when
> the whole network shares the same schedule, so, I wanted a way so I minim=
ize
> the
> amount of information of each schedule that's controller dependent, Linux
> already
> does most of it with the separation of traffic classes and queues (you ar=
e
> right that
> 802.1Q is confusing on this), the idea is that the only thing that needs =
to
> change from
> one node to another in the network is the "queues" parameter. Because eac=
h
> node might
> have different number of queues, or assign different priorities to differ=
ent
> queues.
>
> So, that's the idea of doing that intermediate "transformation" step: tap=
rio
> knows about
> traffic classes and HW queues, but the driver only knows about HW queues.

Not necessarily, I think.
The "other" TSN-capable SoC I know of - the NXP LS1028A, has a
standalone Ethernet controller (drivers/net/ethernet/freescale/enetc)
and an embedded L2 switch (not upstream yet). The ENETC has a
configurable number of TX rings per port. Each TX ring has an
"internal priority value" (IPV) and there is an IPV-to-TC mapping
register. The enetc driver keeps the rings with equal priorities under
normal circumstances (and affines 1 TX ring per core) - the idea being
to spread the load. In ndo_setup_tc for mqprio, they allocate num_tc
TX rings and they put them in strict priority mode by configuring the
IPV (internally mapped 1-to-1 to TC) as increasing values for each
ring.
Then the TSN egress scheduler is wired to look at the traffic class of
each frame, via the TX ring is was enqueued on, mapped to the IPV,
mapped to the TC.
The embedded switch in LS1028A is mostly the same if I just consider
the egress portion.
And the sja1105 doesn't really make a distinction between egress
priority queue and traffic class. They are hardcoded 1-to-1 in the
egress port.

> And unless I made
> a mistake, tc_mask_to_queue_mask() should be equivalent to:
>
> netdev_get_prio_tc_map() + scanning the gatemask for BIT(tc).
>

Yes, but my point is: do you know of any hardware implementation that
schedules traffic per-queue (in a situation where the queue-to-tc
mapping is not 1-to-1)? I know of 3 that don't. So if you translate
traffic class into netdev queue, then these drivers would just need to
translate it back into traffic class for programming the full offload.
The hardware doesn't know anything about the netdev queues.
Or are you saying that the driver doesn't need to care (or may not
care) about the traffic class and you're trying to make their life
easier? But my point is that with an mqprio-type offload, both the
driver and the stack already need to be fully aware of the traffic
class. See for example this snippet from skb_tx_hash, which is called
from netdev_pick_tx:

	if (dev->num_tc) {
		u8 tc =3D netdev_get_prio_tc_map(dev, skb->priority);

		qoffset =3D sb_dev->tc_to_txq[tc].offset;
		qcount =3D sb_dev->tc_to_txq[tc].count;
	}

So the stack does tx hashing to pick a queue only from the queue pool
that the driver is supposed to assign a strict hardware priority. It
has this awareness because it's not supposed to hash between queues of
different priorities (which is akin to playing Russian roulette). And
of course the driver needs to ensure that each netdev queue is
correctly assigned to a traffic class (which may mean something to do,
or not).
My suggestion is: let's keep the SetGateStates semantics operate on
traffic classes for the full offload, just like for the software
implementation. If for whatever reason the driver needs to associate
the tc with a tx queue, let them do it privately and not imprint it
into the qdisc interface.

I think your mindset that the driver does not know about the traffic
class is because the taprio offload structure does not pass that info
to it, like mqprio does? But you kindly provide that info indirectly
to both the stack and the driver, through the netdev_set_tc_queue and
netdev_set_prio_tc_map calls, so the driver should have all the rope
it needs (maybe except num_tcs). In the future, maybe we can move
those calls them before taprio_enable_offload? Right now there would
be no justification to do so. And also perhaps maybe there should be a
call to netdev_reset_tc in case the qdisc is removed?

> (Thinking more about this, I am having a few ideas about ways to simplify
> software mode :-)
>
>>
>> Q.2 Using gate operations to create protected windows The enhancements
>> for
>> scheduled traffic described in 8.6.8.4 allow transmission to be switched
>> on and
>> off on a timed basis for each _traffic class_ that is implemented on a
>> port. This
>> switching is achieved by means of individual on/off transmission gates
>> associated with each _traffic class_ and a list of gate operations that
>> control the
>> gates; an individual SetGateStates operation has a time delay parameter
>> that
>> indicates the delay after the gate operation is executed until the next
>> operation
>> is to occur, and a GateState parameter that defines a vector of up to
>> eight state
>> values (open or
>> closed) that is to be applied to each gate when the operation is execute=
d.
>> The
>> gate operations allow any combination of open/closed states to be define=
d,
>> and
>> the mechanism makes no assumptions about which _traffic classes_ are
>> being
>> =E2=80=9Cprotected=E2=80=9D and which are =E2=80=9Cunprotected=E2=80=9D;=
 any such assumptions are left to
>> the
>> designer of the sequence of gate operations.
>>
>> Table 8-7=E2=80=94Gate operations
>> The GateState parameter indicates a value, open or closed, for each of
>> the
>> Port=E2=80=99s _queues_.
>>
>> - What happens with the "clockid" argument now that hardware offload is
>> possible? Do we allow "/dev/ptp0" to be specified as input?
>> Actually this question is relevant to your txtime-assist mode as well:
>> doesn't it assume that there is an implicit phc2sys instance running to
>> keep the
>> system time in sync with the PHC?
>
> That's a very interesting question. I think, for now, allowing specifying
> /dev/ptp* clocks
> won't work "always": if the driver or something needs to add a timer to b=
e
> able to run
> the schedule, it won't be able to use /dev/ptp* clocks (hrtimers and ptp
> clocks don=E2=80=99t mix).
> But for "full" offloads, it should work.
>

But since the full offload could only work with the interface's PHC as
clockid, that kind of makes specifying any clockid redundant, right? I
think the right behavior would be to ignore that parameter (allow the
user to not specify it)?

> So, you are right, taprio and txtime-assisted (and ETF) require the syste=
m
> clock and phc
> clock to be synchronized, via something like phc2sys.
>
> Hope I got all your questions.
>
> Cheers,
> --
> Vinicius
>
>

I only have a very superficial understanding of the qdisc and
discussing these aspects with you helps a lot. There are a lot of
subtleties I'm missing, so I'm looking forward to your response. One
thing I would like to avoid is introduce more complexity than is
needed to solve the task at hand - hopefully I'm not oversimplifying.

Thanks,
-Vladimir
