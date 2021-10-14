Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F05D42E4BD
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 01:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhJNX1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 19:27:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231325AbhJNX1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 19:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634253895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58YTi92JxqxRq++md/KKAxrsh0Af56ZfwF2hgsGhkQc=;
        b=SV0braBsTPQSVthHy5eXgtQJ1QIEy8sMa8uYtZEVWhEhYMv6SRqcViupclu6gm27p+CE5/
        6rr6PECmFE+4iU2+5w6FT9YOVOYf2bYSKHckoLHDIvav8jkzC8YSBuTY3grtiqcFGWc7JJ
        3bscBvPrjj/CMhaTXzB9sbK3r70tAJs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-oetD9bh-M3KLyBCi33cOzQ-1; Thu, 14 Oct 2021 19:24:54 -0400
X-MC-Unique: oetD9bh-M3KLyBCi33cOzQ-1
Received: by mail-ed1-f71.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so6585797edv.10
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 16:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=58YTi92JxqxRq++md/KKAxrsh0Af56ZfwF2hgsGhkQc=;
        b=GYptF1Fu2o93KBZLEelTCsZsV6ZkwBBFuwN/lkc3ZsnLaTZSX3pZE5VOtF0wXkjrHE
         QWOVGH5kWBNnsWiYNNaABqlZTuwriNU2psyN2E6k8OpTw0TAqQysCuY1Wi41BrhAA6KB
         tZuPyMI1YR1AnqqaGlFAk4cBvnax7xUboCEuJTSPpWX3PpzMzte0b017h877bjVlfDls
         1kV22nGwScncjm8JVfv8sbbIX7RQUvlGKeJwTcbhzlec/JVNhGht08LckptNtCW9mP8W
         oRHFbNBayaMB50hGzd1vO3TJjIllAD/Rq4ul0Zu2XIVX6p7CQ+lpipEC8p90tVX3PPFY
         WzJQ==
X-Gm-Message-State: AOAM533W0EZh/3DEHuG5P/txqw5MqrEOIoBw9pb1uh+voAvpbg03Acgq
        krKpD8xgde7clgE+yrBc/XoqGDQiwKt52ij+szfIsr/0IyszdVd35LSv6Hg1bbMTUNu6pXVAQLX
        oVUpicYHlgoVnyzk4
X-Received: by 2002:a17:906:b183:: with SMTP id w3mr2489068ejy.394.1634253892269;
        Thu, 14 Oct 2021 16:24:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNXoTXKQthCNoT65f3bRrkAH+Y/SPpV+LTseSEW740MKajJ7nTk8x0xtXlbQ4hhjjMMQ/Qcw==
X-Received: by 2002:a17:906:b183:: with SMTP id w3mr2488962ejy.394.1634253891020;
        Thu, 14 Oct 2021 16:24:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x16sm2988788ejj.8.2021.10.14.16.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 16:24:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A263918025F; Fri, 15 Oct 2021 01:24:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>, Bob Briscoe <in@bobbriscoe.net>
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
In-Reply-To: <CANn89iLbJL2Jzot5fy7m07xDhP_iCf8ro8SBzXx1hd0EYVvHcA@mail.gmail.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <87wnmf1ixc.fsf@toke.dk>
 <CANn89iLbJL2Jzot5fy7m07xDhP_iCf8ro8SBzXx1hd0EYVvHcA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Oct 2021 01:24:49 +0200
Message-ID: <87mtnb196m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Thu, Oct 14, 2021 at 12:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Eric Dumazet <eric.dumazet@gmail.com> writes:
>>
>> > From: Eric Dumazet <edumazet@google.com>
>> >
>> > Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latenc=
y,
>> > Low Loss, Scalable Throughput (L4S) style marking, along with ce_thres=
hold.
>> >
>> > If enabled, only packets with ECT(1) can be transformed to CE
>> > if their sojourn time is above the ce_threshold.
>> >
>> > Note that this new option does not change rules for codel law.
>> > In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
>> > the default when fq_codel qdisc is created), ECT(0) packets can
>> > still get CE if codel law (as governed by limit/target) decides so.
>>
>> The ability to have certain packets receive a shallow marking threshold
>> and others regular ECN semantics is no doubt useful. However, given that
>> it is by no means certain how the L4S experiment will pan out (and I for
>> one remain sceptical that the real-world benefits will turn out to match
>> the tech demos), I think it's premature to bake the ECT(1) semantics
>> into UAPI.
>
> Chicken and egg problem.
> We had fq_codel in linux kernel years before RFC after all :)

Sure, but fq_codel is a self-contained algorithm, it doesn't add new
meanings to bits of the IP header... :)

>> So how about tying this behaviour to a configurable skb->mark instead?
>> That way users can get the shallow marking behaviour for any subset of
>> packets they want, simply by installing a suitable filter on the
>> qdisc...
>
> This seems an idea, but do you really expect users installing a sophistic=
ated
> filter ? Please provide more details, and cost analysis.

Not sure it's that sophisticated; pretty simple to do with tc-u32
(although it's complicated a bit by having to restore the default
hashing behaviour of fq_codel with a second filter). Something like:

# tc qdisc replace dev $DEV handle 1: fq_codel
# tc filter add dev $DEV parent 1: pref 1 protocol ipv6 u32 match u32 00100=
000 00100000 action skbedit mark 2 continue
# tc filter add dev $DEV parent 1: pref 2 protocol ip u32 match ip dsfield =
1 1 action skbedit mark 2 continue
# tc filter add dev $DEV parent 1: handle 1 pref 3 protocol all flow hash k=
eys src,dst,proto,proto-src,proto-dst divisor 1024

or one could write a single BPF program that combines all three to save
some cycles walking the filter chain.

> (Having to install a filter is probably more expensive than testing a
> boolean, after the sojourn time has exceeded the threshold)

No doubt, all other things being equal. But odds are they're not: if
you're already running a BPF filter somewhere in the path, adding the
logic above to an existing filter reduces it back down to a couple of
boolean comparisons, for instance.

But even if it does add a bit of overhead, IMO the flexibility makes up
for this. We can always revisit it if L4S becomes a standards-track RFC
at some point :)

> Given that INET_ECN_set_ce(skb) only operates on ECT(1) and ECT(0),
> I guess we could  use a bitmask of two bits so that users can decide
> which code points can become CE.

That would be an improvement. But if we're doing bitmasks, and since the
code is reading the whole dsfield anyway, why not extend that bitmask to
the whole dsfield?

-Toke

