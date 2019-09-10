Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027A3AE1CE
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390948AbfIJBG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:06:56 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36945 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfIJBG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:06:56 -0400
Received: by mail-ed1-f66.google.com with SMTP id i1so15222594edv.4
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3AAp4uidMD6oK2/hORnz733Qbbeu8HkCNsTEU3urkwg=;
        b=mX+AYJIBpreRw42Qcy6E3pFV3NTtBpsNiCQZtP0aHljelQlOAIuMYud9ssteGQ83nH
         VKcwBVRPyr1wvs7DzzkUYAWo+Pan2mWGMafAHvC72ys/Rx0cso+P1GBy1RY6vXSWq5gw
         uUs3wjmjiwnu3po8vKgjnHUAf2ysn9MxWjro0lQ1HUO1OZ4Zumu2LlhYIBLlTs+inZRy
         hpdLhnaCvQtOMwkXH5kX5ze8TZ7kRuSY/Q3ctGGTNk9Onck1k3vYPzsm5tzfuNxmwKoJ
         6jdnvnOevsXM3SqqZrWdXyi1ZL37wjsAS3FB5sjX0WaNYTU2EnJVYtKynZtLgcUHzmMP
         Bh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3AAp4uidMD6oK2/hORnz733Qbbeu8HkCNsTEU3urkwg=;
        b=mJBlBiRTPZKm4VUF04qhyjC108p+9jWKb0h6vTTsGa5NKIZ2BjcNJDlnL2UtB5vyDU
         IQltKX7bQGH+JOx7yoDePsyJeu9vUX5IN2YgzT4aOs1S0yc+6Wso0gnmoiVAiFzNwpHM
         jWQrQ8eS1pBy7+X2khulyhO6nopBuJPrqNxXz0odRj64fZNLUuFrayjGHT/PgjBdozTP
         bAIITphOKnogHPgJ83DFuIUllSazJ8KSPa2ATvIWXu4u5FHm2iGPU3zk/m6UdRJgf7J+
         AMmB85OEHO3MrplUF0t4N2mlce2SAJgJSWxb+NT/ZWKgqHiLQdbyVCefq3VKekdtxoMp
         tyrQ==
X-Gm-Message-State: APjAAAUnW+f7btXZ84cYr0Gi3gZH3DKhovGCl3BKOF1Y9kulMjSWyM8X
        fK9mDmGd69d51+iS1CR/boKZ0llb/3KcWLDvY0E=
X-Google-Smtp-Source: APXvYqz5B3cjEeTzTJoMrrvhgEsnKTUO7JRXZjCY5BVLb5AQ67HxPMRXgc/ysiFs+Mf3KSIeA511PPl6jXE0dHENqt8=
X-Received: by 2002:a17:906:4f0e:: with SMTP id t14mr21552495eju.47.1568077614161;
 Mon, 09 Sep 2019 18:06:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Mon, 9 Sep 2019 18:06:53
 -0700 (PDT)
In-Reply-To: <BN6PR11MB00500FA0D6B5D39E794B44BB86B70@BN6PR11MB0050.namprd11.prod.outlook.com>
References: <20190902162544.24613-1-olteanv@gmail.com> <20190907.155549.1880685136488421385.davem@davemloft.net>
 <BN6PR11MB00500FA0D6B5D39E794B44BB86B70@BN6PR11MB0050.namprd11.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 10 Sep 2019 02:06:53 +0100
Message-ID: <CA+h21hoQ-DaFGzALVmGo2mDJancUp5Fndc=o0f4LfD_9yaNi0g@mail.gmail.com>
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

Hi Vinicius!

On 10/09/2019, Gomes, Vinicius <vinicius.gomes@intel.com> wrote:
> Hi Vladimir,
>
>> This is a warning that I will toss this patch series if it receives no
>> series review in
>> the next couple of days.
>
> Sorry about the delay on reviewing this. On top on the usual business, so=
me
> changes to the
> IT infrastructure here have hit my email workflow pretty hard.
>

No problem, I've also been traveling and hence delaying patching some
taprio issues we discussed last week.

> I am taking a look at the datasheet in the meantime, it's been a long tim=
e
> since I looked at it,
> the idea is to help review the scheduler from hell :-)
>

Ok, but don't get hung up on it :)

> One thing that wasn't clear is what you did to test this series.
>

Right, this is one particular aspect I didn't really insist on a lot,
and I hope I'm not going to lose everybody when explaining it, because
it requires a bit of understanding of how sja1105 integrates with DSA
overall.
The basic idea is that none of the switch's ports is special in any
way from a hardware perspective, and that includes the "CPU port". But
to support the DSA paradigm of annotating frames that go towards the
CPU with information about the source port they came from, I am
repurposing VLAN tags with a customized EtherType (0xdadb instead of
0x8100).
This is relevant because to a 802.1Q bridge, the QoS hints come from:
- The 3-bit PCP field from the VLAN header
- A default, port-based VLAN PCP in case RX traffic is untagged (I
would also like to have a knob to change this, currently hardcoded to
0 in the driver!)
So to inject a frame into a sja1105 TX queue means to annotate it with
a VLAN PCP which maps to that queue. In the datasheet there is a
VLAN_PMAP register that manages the ingress-priority ->
egress-priority -> egress-queue mapping. I'm keeping that hardcoded to
1:1:1 for sanity.
Now back to the driver's use of the VLAN header.
- When the sja1105 operates as a bridge with vlan_filtering=3D1, the
VLANs are installed by the user (via the bridge command from
iproute2), parsed by the switch and VLAN-tagged traffic is expected to
be received from the connected ports. So it honors the VLAN PCP in
this mode.
- When it isn't (it is either a VLAN-unaware bridge, or 4x standalone
ports), then the VLAN header (with custom EtherType) is used to route
frames from the CPU towards the correct egress switch port. A
consequence of it still being parsed by the switch as VLAN is that the
host Linux system is able to specify the VLAN PCP to mean "inject in
this egress queue".

Now because the EtherType changes between these modes of operation,
the switch can either expose the VLAN PCP to (a) the host Linux netdev
queues (as DSA sees them*), or (b) to the devices connected to its
external ports.
* When operating in vlan_filtering=3D1 mode, technically the sja1105
becomes a "managed dumb switch" (control traffic: PTP, STP etc still
works, but for general purpose traffic you must now open your socket
on the DSA master netdevice, not the switch ports). So the DSA master
netdevice is in fact just another node connected to the switch in this
mode, for all the hardware cares. So technically you _can_ still do
QoS from the host Linux if you put a VLAN sub-interface on top of the
DSA master netdevice.

Now, to finally answer your question. I have used the sja1105 as a
bridge between two endpoints who are sending/receiving VLAN-tagged
traffic in a 3-board network synchronized by PTP. There is a schedule
configured on the switch that is aligned to the beginning of the
second, and the cycle time is known. PTP uses traffic class 7, and the
scheduled traffic uses traffic class 5.
The traffic sender is not too complicated: it's a raw L2 socket that
is sending scheduled traffic based on calls to
clock_nanosleep(CLOCK_REALTIME) and an a-priori knowledge of the
network schedule (it's invoked from a script), minus an advance time.
The reason I'm not sharing too many details about the traffic sender
now is that I just configured the advance time experimentally and
there's no hard guarantee that its egress latency will be smaller and
that the frames will always be sent on time. But the sender's
CLOCK_REALTIME is in sync with its /dev/ptp0 by phc2sys, that's why I
can poll it instead of polling the hardware clock.
Then I am taking TX and RX timestamps for the scheduled traffic on the
sender and on the receiver. I can do a reasonable diff between the 2
timestamps because the PHCs are kept in sync by PTP, and that is my
path delay. I expect it to be more or less 2x a single link's path
delay (sender -> bridge + bridge -> receiver), and not in any case a
multiple of the cycle time (which is a sign that cycles were missed).

As for the sja1105-as-endpoint use case, I checked that I can inject
traffic into each particular queue, but I didn't really explore it
further.

I'll make sure this subtlety is more clearly formulated in the next
version of the patch.

> Cheers,
> --
> Vinicius
>
>
>

Actually let me ask you a few questions as well:

- I'm trying to understand what is the correct use of the tc-mqprio
"queues" argument. I've only tested it with "1@0 1@1 1@2 1@3 1@4 1@5
1@6 1@7", which I believe is equivalent to not specifying it at all? I
believe it should be interpreted as: "allocate this many netdev queues
for each traffic class", where "traffic class" means a group of queues
having the same priority (equal to the traffic class's number), but
engaged in a strict priority scheme with other groups of queues
(traffic classes). Right?

- DSA can only formally support multi-queue, because its connection to
the Linux host is through an Ethernet MAC (FIFO). Even if the DSA
master netdevice may be multi-queue, allocating and separating those
queues for each front-panel switch port is a task best left to the
user/administrator. This means that DSA should reject all other
"queues" mappings except the trivial one I pointed to above?

- I'm looking at the "tc_mask_to_queue_mask" function that I'm
carrying along from your initial offload RFC. Are you sure this is the
right approach? I don't feel a need to translate from traffic class to
netdev queues, considering that in the general case, a traffic class
is a group of queues, and 802.1Qbv doesn't really specify that you can
gate individual queues from a traffic class. In the software
implementation you are only looking at netdev_get_prio_tc_map, which
is not equivalent as far as my understanding goes, but saner.
Actually 802.1Q-2018 does not really clarify this either. It looks to
me like they use the term "queue" and "traffic class" interchangeably.
See two examples below (emphasis mine):

Q.2 Using gate operations to create protected windows
The enhancements for scheduled traffic described in 8.6.8.4 allow
transmission to be switched on and off on a timed basis for each
_traffic class_ that is implemented on a port. This switching is
achieved by means of individual on/off transmission gates associated
with each _traffic class_ and a list of gate operations that control
the gates; an individual SetGateStates operation has a time delay
parameter that indicates the delay after the gate operation is
executed until the next operation is to occur, and a GateState
parameter that defines a vector of up to eight state values (open or
closed) that is to be applied to each gate when the operation is
executed. The gate operations allow any combination of open/closed
states to be defined, and the mechanism makes no assumptions about
which _traffic classes_ are being =E2=80=9Cprotected=E2=80=9D and which are
=E2=80=9Cunprotected=E2=80=9D; any such assumptions are left to the designe=
r of the
sequence of gate operations.

Table 8-7=E2=80=94Gate operations
The GateState parameter indicates a value, open or closed, for each of
the Port=E2=80=99s _queues_.

- What happens with the "clockid" argument now that hardware offload
is possible? Do we allow "/dev/ptp0" to be specified as input?
Actually this question is relevant to your txtime-assist mode as well:
doesn't it assume that there is an implicit phc2sys instance running
to keep the system time in sync with the PHC?

Thanks,
-Vladimir
