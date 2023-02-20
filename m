Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCD969D15E
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjBTQeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjBTQeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:34:18 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F86E1043A
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:34:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g1so6652281edz.7
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg82EH6v54nz9s2cOc/El0UjUj0Xg2W5gp1JvuuyPx0=;
        b=Ym9Lb/b42geZ6fXyHgmj1ZxoqixNu1TcltgYa0t6O2BJuZcTduJhRwtoEuhEmF0whX
         xOSgA1lSHHynGH662YtsPLVXxsQJpW9ndq713J0/1F5ArK/SeC4GgdVlQvnQrpGC4pHr
         JABxRu54PVqD9/F+m+0RhMv14nyeKpDtTM6la8BJlxBKy88J1WISWAOtBb8Ue9J7kXqE
         uDdW4ZH7PKqvEPqjtHNjTY7ga7AIAkJqTktiVdKxvJnFP6+Cx8fM0Mn5F+15noO17z35
         CsGm5iVxkRrn4cxfqj3lz1XkTMhzgwOrQF2bBo2sTZfFDGx68TMWYi5oSJUTA+MiPjMT
         60YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mg82EH6v54nz9s2cOc/El0UjUj0Xg2W5gp1JvuuyPx0=;
        b=VkmjNQE+8l5RKH8UwNVHFIh6lnIIYBVOejznt8tbbUzKq5S74UF8Rhn95VW2xi+aHG
         SnDh6wBQ3FpGqJUHaZWJ+nWHRc0VO4+waWetaWjuEvVG7esroBTPGOfgbzK9w5qGB/oc
         JU8htmiJp46Mqg+5JsfIKS9cTzCfzsIkhzgF/SFNxSqXnHNxjBnRl81OBQ5vCZFvowyA
         ix29F0aF70kRb46MfSNIZsoWf+qIDnfsZR0JsAH738O5gmKr+E4hQuZN97Sea7MR2gio
         fwlxvQYywlHJNE+vUtrsIav7ddfV6KVu5IylcIN+lZ6ip9+zJ+5eKn3b/x5xo3ztgna1
         KvHA==
X-Gm-Message-State: AO0yUKW4nYy2xQLyQA1FA2LybbqTHTRmy+bqOGqdEfibFJFnUt4yCKx9
        XqrvjEDzuQdkCcrHSVPOeYPCIOUeJxzO0JQ4tpw=
X-Google-Smtp-Source: AK7set+qPDkCV8evE3TLHfXsFHzW26s9m5+ulyKVmyP6ygBMY7priwjeRcGi2UwUuKjXwO/iY6r1f0KWO7ucBmXfzPM=
X-Received: by 2002:a17:906:6d07:b0:8af:4963:fb08 with SMTP id
 m7-20020a1709066d0700b008af4963fb08mr4943522ejr.15.1676910854434; Mon, 20 Feb
 2023 08:34:14 -0800 (PST)
MIME-Version: 1.0
References: <20230220150548.2021-1-peti.antal99@gmail.com> <20230220152942.kj7uojbgfcsowfap@skbuf>
 <CAHzwrcfpsBpiEsf4b2Y6xEAhno3rNKz6tWuxqRAUb0HyBT6c7Q@mail.gmail.com> <20230220161809.t2vj6daixio7uzbw@skbuf>
In-Reply-To: <20230220161809.t2vj6daixio7uzbw@skbuf>
From:   =?UTF-8?B?UMOpdGVyIEFudGFs?= <peti.antal99@gmail.com>
Date:   Mon, 20 Feb 2023 17:34:04 +0100
Message-ID: <CAHzwrce1wfXbiNqYa5uU9Kv+YX=t9mWYhPtUwPczpZf2GuJ-Fg@mail.gmail.com>
Subject: Re: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping
 with examples
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ferenc Fejes <fejes@inf.elte.hu>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        =?UTF-8?B?UMOpdGVyIEFudGFs?= <antal.peti99@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Vladimir Oltean <vladimir.oltean@nxp.com> ezt =C3=ADrta (id=C5=91pont: 2023=
.
febr. 20., H, 17:18):
>
> On Mon, Feb 20, 2023 at 05:01:57PM +0100, P=C3=A9ter Antal wrote:
> > Hi Vladimir,
> >
> > Vladimir Oltean <vladimir.oltean@nxp.com> ezt =C3=ADrta (id=C5=91pont: =
2023.
> > febr. 20., H, 16:29):
> > >
> > > Hi P=C3=A9ter,
> > >
> > > On Mon, Feb 20, 2023 at 04:05:48PM +0100, P=C3=A9ter Antal wrote:
> > > > The current mqprio manual is not detailed about queue mapping
> > > > and priorities, this patch adds some examples to it.
> > > >
> > > > Suggested-by: Ferenc Fejes <fejes@inf.elte.hu>
> > > > Signed-off-by: P=C3=A9ter Antal <peti.antal99@gmail.com>
> > > > ---
> > >
> > > I think it's great that you are doing this. However, with all due res=
pect,
> > > this conflicts with the man page restructuring I am already doing for=
 the
> > > frame preemption work. Do you mind if I fix up some things and I pick=
 your
> > > patch up, and submit it as part of my series? I have some comments be=
low.
> >
> > That's all right, thank you for doing this, just please carry my
> > signoff as co-developer if possible.
>
> Absolutely, this is implied.
>
> > I agree with most of your suggestions.
>
> I've applied your changes on top of mine. Can you and Ferenc please
> review the end result? I'll take a small break of a couple of hours,
> and continue working on this when I come back.
>
> $ cat man/man8/tc-mqprio.8
> .TH MQPRIO 8 "24 Sept 2013" "iproute2" "Linux"
> .SH NAME
> MQPRIO \- Multiqueue Priority Qdisc (Offloaded Hardware QOS)
> .SH SYNOPSIS
> .B tc qdisc ... dev
> dev (
> .B parent
> classid | root) [
> .B handle
> major: ]
> .B mqprio
> .ti +8
> [
> .B num_tc
> tcs ] [
> .B map
> P0 P1 P2... ] [
> .B queues
> count1@offset1 count2@offset2 ... ]
> .ti +8
> [
> .B hw
> 1|0 ] [
> .B mode
> dcb|channel ] [
> .B shaper
> dcb|bw_rlimit ]
> .ti +8
> [
> .B min_rate
> min_rate1 min_rate2 ... ] [
> .B max_rate
> max_rate1 max_rate2 ... ]
> .ti +8
> [
> .B fp
> FP0 FP1 FP2 ... ]
>
> .SH DESCRIPTION
> The MQPRIO qdisc is a simple queuing discipline that allows mapping
> traffic flows to hardware queue ranges using priorities and a configurabl=
e
> priority to traffic class mapping. A traffic class in this context is
> a set of contiguous qdisc classes which map 1:1 to a set of hardware
> exposed queues.
>
> By default the qdisc allocates a pfifo qdisc (packet limited first in, fi=
rst
> out queue) per TX queue exposed by the lower layer device. Other queuing
> disciplines may be added subsequently. Packets are enqueued using the
> .B map
> parameter and hashed across the indicated queues in the
> .B offset
> and
> .B count.
> By default these parameters are configured by the hardware
> driver to match the hardware QOS structures.
>
> .B Channel
> mode supports full offload of the mqprio options, the traffic classes, th=
e queue
> configurations and QOS attributes to the hardware. Enabled hardware can p=
rovide
> hardware QOS with the ability to steer traffic flows to designated traffi=
c
> classes provided by this qdisc. Hardware based QOS is configured using th=
e
> .B shaper
> parameter.
> .B bw_rlimit
> with minimum and maximum bandwidth rates can be used for setting
> transmission rates on each traffic class. Also further qdiscs may be adde=
d
> to the classes of MQPRIO to create more complex configurations.
>
> .SH ALGORITHM
> On creation with 'tc qdisc add', eight traffic classes are created mappin=
g
> priorities 0..7 to traffic classes 0..7 and priorities greater than 7 to
> traffic class 0. This requires base driver support and the creation will
> fail on devices that do not support hardware QOS schemes.
>
> These defaults can be overridden using the qdisc parameters. Providing
> the 'hw 0' flag allows software to run without hardware coordination.
>
> If hardware coordination is being used and arguments are provided that
> the hardware can not support then an error is returned. For many users
> hardware defaults should work reasonably well.
>
> As one specific example numerous Ethernet cards support the 802.1Q
> link strict priority transmission selection algorithm (TSA). MQPRIO
> enabled hardware in conjunction with the classification methods below
> can provide hardware offloaded support for this TSA.
>
> .SH CLASSIFICATION
> Multiple methods are available to set the SKB priority which MQPRIO
> uses to select which traffic class to enqueue the packet.
> .TP
> From user space
> A process with sufficient privileges can encode the destination class
> directly with SO_PRIORITY, see
> .BR socket(7).
> .TP
> with iptables/nftables
> An iptables/nftables rule can be created to match traffic flows and
> set the priority.
> .BR iptables(8)
> .TP
> with net_prio cgroups
> The net_prio cgroup can be used to set the priority of all sockets
> belong to an application. See kernel and cgroup documentation for details=
.
>
> .SH QDISC PARAMETERS
> .TP
> num_tc
> Number of traffic classes to use. Up to 16 classes supported.
> There cannot be more traffic classes than TX queues.
>
> .TP
> map
> The priority to traffic class map. Maps priorities 0..15 to a specified
> traffic class. The default value for this argument is
>
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82Prio=E2=94=82 tc =E2=94=82
>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=A4
>   =E2=94=82  0 =E2=94=82  0 =E2=94=82
>   =E2=94=82  1 =E2=94=82  1 =E2=94=82
>   =E2=94=82  2 =E2=94=82  2 =E2=94=82
>   =E2=94=82  3 =E2=94=82  3 =E2=94=82
>   =E2=94=82  4 =E2=94=82  4 =E2=94=82
>   =E2=94=82  5 =E2=94=82  5 =E2=94=82
>   =E2=94=82  6 =E2=94=82  6 =E2=94=82
>   =E2=94=82  7 =E2=94=82  7 =E2=94=82
>   =E2=94=82  8 =E2=94=82  0 =E2=94=82
>   =E2=94=82  9 =E2=94=82  1 =E2=94=82
>   =E2=94=82 10 =E2=94=82  1 =E2=94=82
>   =E2=94=82 11 =E2=94=82  1 =E2=94=82
>   =E2=94=82 12 =E2=94=82  3 =E2=94=82
>   =E2=94=82 13 =E2=94=82  3 =E2=94=82
>   =E2=94=82 14 =E2=94=82  3 =E2=94=82
>   =E2=94=82 15 =E2=94=82  3 =E2=94=82
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=98
>
> .TP
> queues
> Provide count and offset of queue range for each traffic class. In the
> format,
> .B count@offset.
> Without hardware coordination, queue ranges for each traffic classes cann=
ot
> overlap and must be a contiguous range of queues. With hardware coordinat=
ion,
> the device driver may apply a different queue configuration than requeste=
d,
> and the requested queue configuration may overlap (but the one which is a=
pplied
> may not). The default value for this argument is:
>
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82 tc =E2=94=82 count =E2=94=82 offset =E2=94=82
>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>   =E2=94=82  0 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  1 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  2 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  3 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  4 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  5 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  6 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  7 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  8 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82  9 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82 10 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82 11 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82 12 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82 13 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82 14 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=82 15 =E2=94=82    0  =E2=94=82    0   =E2=94=82
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>

Maybe this default table is obvious, and stating that "by default the
traffic classes are mapped to 0@0" could be enough.
But feel free to ignore this.

> .TP
> hw
> Set to
> .B 1
> to support hardware offload. Set to
> .B 0
> to configure user specified values in software only.
> Without hardware coordination, the device driver is not notified of the n=
umber
> of traffic classes and their mapping to TXQs. The device is not expected =
to
> prioritize between traffic classes without hardware coordination.
> The default value of this parameter is
> .B 1.
>
> .TP
> mode
> Set to
> .B channel
> for full use of the mqprio options. Use
> .B dcb
> to offload only TC values and use hardware QOS defaults. Supported with '=
hw'
> set to 1 only.
>
> .TP
> shaper
> Use
> .B bw_rlimit
> to set bandwidth rate limits for a traffic class. Use
> .B dcb
> for hardware QOS defaults. Supported with 'hw' set to 1 only.
>
> .TP
> min_rate
> Minimum value of bandwidth rate limit for a traffic class. Supported only=
 when
> the
> .B 'shaper'
> argument is set to
> .B 'bw_rlimit'.
>
> .TP
> max_rate
> Maximum value of bandwidth rate limit for a traffic class. Supported only=
 when
> the
> .B 'shaper'
> argument is set to
> .B 'bw_rlimit'.
>
> .TP
> fp
> Selects whether traffic classes are express (deliver packets via the eMAC=
) or
> preemptible (deliver packets via the pMAC), according to IEEE 802.1Q-2018
> clause 6.7.2 Frame preemption. Takes the form of an array (one element pe=
r
> traffic class) with values being
> .B 'E'
> (for express) or
> .B 'P'
> (for preemptible).
>
> Multiple priorities which map to the same traffic class, as well as multi=
ple
> TXQs which map to the same traffic class, must have the same FP attribute=
s.
> To interpret the FP as an attribute per priority, the
> .B 'map'
> argument can be used for translation. To interpret FP as an attribute per=
 TXQ,
> the
> .B 'queues'
> argument can be used for translation.
>
> Traffic classes are express by default. The argument is supported only wi=
th
> .B 'hw'
> set to 1. Preemptible traffic classes are accepted only if the device has=
 a MAC
> Merge layer configurable through
> .BR ethtool(8).
>
> .SH SEE ALSO
> .BR ethtool(8)
>
> .SH EXAMPLE
>
> The following example shows how to attach priorities to 4 traffic classes
> ('num_tc 4'), and how to pair these traffic classes with 4 hardware queue=
s,
> with hardware coordination ('hw 1'), according to the following configura=
tion.
>
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82Prio=E2=94=82 tc =E2=94=82 queue =E2=94=82
>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=A4
>   =E2=94=82  0 =E2=94=82  0 =E2=94=82     0 =E2=94=82
>   =E2=94=82  1 =E2=94=82  0 =E2=94=82     0 =E2=94=82
>   =E2=94=82  2 =E2=94=82  0 =E2=94=82     0 =E2=94=82
>   =E2=94=82  3 =E2=94=82  0 =E2=94=82     0 =E2=94=82
>   =E2=94=82  4 =E2=94=82  1 =E2=94=82     1 =E2=94=82
>   =E2=94=82  5 =E2=94=82  1 =E2=94=82     1 =E2=94=82
>   =E2=94=82  6 =E2=94=82  1 =E2=94=82     1 =E2=94=82
>   =E2=94=82  7 =E2=94=82  1 =E2=94=82     1 =E2=94=82
>   =E2=94=82  8 =E2=94=82  2 =E2=94=82     2 =E2=94=82
>   =E2=94=82  9 =E2=94=82  2 =E2=94=82     2 =E2=94=82
>   =E2=94=82 10 =E2=94=82  2 =E2=94=82     2 =E2=94=82
>   =E2=94=82 11 =E2=94=82  2 =E2=94=82     2 =E2=94=82
>   =E2=94=82 12 =E2=94=82  3 =E2=94=82     3 =E2=94=82
>   =E2=94=82 13 =E2=94=82  3 =E2=94=82     3 =E2=94=82
>   =E2=94=82 14 =E2=94=82  3 =E2=94=82     3 =E2=94=82
>   =E2=94=82 15 =E2=94=82  3 =E2=94=82     3 =E2=94=82
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98
>
> Traffic class 0 (TC0) is mapped to hardware queue 0 (TXQ0), TC1 is mapped=
 to
> TXQ1, TC2 is mapped to TXQ2, and TC3 to TXQ3.
>
> .EX
> # tc qdisc add dev eth0 root mqprio \\
>         num_tc 4 \\
>         map 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 \\
>         queues 1@0 1@1 1@2 1@3 \\
>         hw 1
> .EE
>
> The following example shows how to attach priorities to 3 traffic classes
> ('num_tc 3'), and how to pair these traffic classes with 4 queues, withou=
t
> hardware coordination ('hw 0'), according to the following configuration:
>
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82Prio=E2=94=82 tc =E2=94=82  queue =E2=94=82
>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>   =E2=94=82  0 =E2=94=82  0 =E2=94=82      0 =E2=94=82
>   =E2=94=82  1 =E2=94=82  0 =E2=94=82      0 =E2=94=82
>   =E2=94=82  2 =E2=94=82  0 =E2=94=82      0 =E2=94=82
>   =E2=94=82  3 =E2=94=82  0 =E2=94=82      0 =E2=94=82
>   =E2=94=82  4 =E2=94=82  1 =E2=94=82      1 =E2=94=82
>   =E2=94=82  5 =E2=94=82  1 =E2=94=82      1 =E2=94=82
>   =E2=94=82  6 =E2=94=82  1 =E2=94=82      1 =E2=94=82
>   =E2=94=82  7 =E2=94=82  1 =E2=94=82      1 =E2=94=82
>   =E2=94=82  8 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82  9 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82 10 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82 11 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82 12 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82 13 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82 14 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=82 15 =E2=94=82  2 =E2=94=82 2 or 3 =E2=94=82
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>
> TC0 is mapped to hardware TXQ0, TC1 to TXQ1, and TC2 is mapped to TXQ2 an=
d
> TXQ3, where the queue selection between these two queues is arbitrary.
>
> .EX
> # tc qdisc add dev eth0 root mqprio \\
>         num_tc 3 \\
>         map 0 0 0 0 1 1 1 1 2 2 2 2 2 2 2 2 \\
>         queues 1@0 1@1 2@2 \\
>         hw 0
> .EE
>
> In the following example, there are 8 hardware queues mapped to 5 traffic
> classes according to the configuration below:
>
>         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90
>  tc0=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4Queue 0=E2=94=82=E2=97=
=84=E2=94=80=E2=94=80=E2=94=80=E2=94=801@0
>         =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=A4
>       =E2=94=8C=E2=94=80=E2=94=A4Queue 1=E2=94=82=E2=97=84=E2=94=80=E2=94=
=80=E2=94=80=E2=94=802@1
>  tc1=E2=94=80=E2=94=80=E2=94=A4 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>       =E2=94=94=E2=94=80=E2=94=A4Queue 2=E2=94=82
>         =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=A4
>  tc2=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4Queue 3=E2=94=82=E2=97=
=84=E2=94=80=E2=94=80=E2=94=80=E2=94=801@3
>         =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=A4
>  tc3=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4Queue 4=E2=94=82=E2=97=
=84=E2=94=80=E2=94=80=E2=94=80=E2=94=801@4
>         =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=A4
>       =E2=94=8C=E2=94=80=E2=94=A4Queue 5=E2=94=82=E2=97=84=E2=94=80=E2=94=
=80=E2=94=80=E2=94=803@5
>       =E2=94=82 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=A4
>  tc4=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=A4Queue 6=E2=94=82
>       =E2=94=82 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=A4
>       =E2=94=94=E2=94=80=E2=94=A4Queue 7=E2=94=82
>         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98
>
> .EX
> # tc qdisc add dev eth0 root mqprio \\
>         num_tc 5 \\
>         map 0 0 0 1 1 1 1 2 2 3 3 4 4 4 4 4 \\
>         queues 1@0 2@1 1@3 1@4 3@5
> .EE
>
>
> .SH AUTHORS
> John Fastabend, <john.r.fastabend@intel.com>

Aside from that LGTM!

Acked-by: P=C3=A9ter Antal <peti.antal99@gmail.com>

Thanks!
P=C3=A9ter
