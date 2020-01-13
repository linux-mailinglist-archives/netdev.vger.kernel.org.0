Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6172139240
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgAMNe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:34:29 -0500
Received: from mail-ed1-f46.google.com ([209.85.208.46]:38952 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMNe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:34:29 -0500
Received: by mail-ed1-f46.google.com with SMTP id t17so8459676eds.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 05:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/i1acawGF1CJ7b8rXBeWoPsiJBd4W6WCUA96EQbEfzQ=;
        b=ebPpLZMM3GZENu9Vw2T9ToonkoBgbE8jZ+otYE+glg5Pz+H1v62S7+BO5IaQ9Xh5Mq
         C3zjoHKGfHirWoUH6n2vd6XDo40K/Qsaxnzelz/JLJ+2e0XY8cv+8kH13mVla9msAntE
         11F+pgFXnmzF62Ffpwr2692t1O0XcQbL+pAyGn1vC7g+z+d3DCoZN4/i7WThbXzS/knQ
         aWhk3/Ny36OZyo+cSSuAwspDw4/Fqh/GZIFHBco08Tjp4pfykpGTZXjD4GxqGBG0+sWp
         dBdCyTim+5Eh7nPi4Nsu5XKN7y8jGyvkfuhxujKRLfc1RLOPh5woDps6uFwMFpic6Mh/
         /1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/i1acawGF1CJ7b8rXBeWoPsiJBd4W6WCUA96EQbEfzQ=;
        b=E6nK5dNippb6jFs+QUUwQtcQKzydEUFKsjitDvg/2rIoCWgZx/MTeh3LPkM5fyY9h2
         a3HcMSQN45YS4j0fuzH1HkvSg5+CjzSG1W/kEpW8kTTJbqDeN2+yMqwmt2l8GtbT3JNQ
         mSZAKv84wZTeVzvPoH+xo+Jxl9W2M8/1OaSFpTokE49qeFH2hUfroX+2JcZUGdjXYB9K
         yp74QxG8iRX711pbB9ATiN0GP6IHvoovUjGErB8+WaIxJv4Xc4Ai59LlqnL03bvlfiir
         ITc7t9t8G0PrrTuwcIrevwEsgLI7C0dAWCUBMgbhNlAFBnZCRcR+mfAi2EORmcDjY+y8
         ozTg==
X-Gm-Message-State: APjAAAUp6TqTMFYqgge11I2wptPgoNNQns+Re8GE7seNUPwL/qU3P60y
        Toil0Qk7Ejl1T8Xan0rtMmujHEj+SDT8Sai1UhE=
X-Google-Smtp-Source: APXvYqx+jfD4yo/+v3zyPEl98KBUPU/jKs0g8g2+I39tNk/PNS6P36UXk2P9jK2vZnYIN3E7UWyEgEce/dhsONv2SNA=
X-Received: by 2002:a05:6402:153:: with SMTP id s19mr17436178edu.149.1578922467353;
 Mon, 13 Jan 2020 05:34:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:290:0:0:0:0 with HTTP; Mon, 13 Jan 2020 05:34:26
 -0800 (PST)
In-Reply-To: <87blr7wn7a.fsf@toke.dk>
References: <20200110062657.7217-1-gautamramk@gmail.com> <20200110062657.7217-3-gautamramk@gmail.com>
 <20200112173624.5f7b754b@cakuba> <87eew3wpg9.fsf@toke.dk> <20200113041922.25282650@cakuba>
 <87blr7wn7a.fsf@toke.dk>
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
Date:   Mon, 13 Jan 2020 19:04:26 +0530
Message-ID: <CADAms0xuzTU6QG6iXAguP-fQN+2WDVjsxVnNuOr3xt7SsUztXA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: sched: add Flow Queue PIE packet scheduler
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub and Toke,

Thanks for the comments. We shall make the required changes and
resubmit v4 once we get some more feedback from the mailing list,
probably by tomorrow.

Thank You,
Gautam

On 1/13/20, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>
>> On Mon, 13 Jan 2020 12:44:38 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
>>> Jakub Kicinski <kuba@kernel.org> writes:
>>> > On Fri, 10 Jan 2020 11:56:57 +0530, gautamramk@gmail.com wrote:
>>> >> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>>> >>
>>> >> Principles:
>>> >>   - Packets are classified on flows.
>>> >>   - This is a Stochastic model (as we use a hash, several flows migh=
t
>>> >>                                 be hashed on the same slot)
>>> >>   - Each flow has a PIE managed queue.
>>> >>   - Flows are linked onto two (Round Robin) lists,
>>> >>     so that new flows have priority on old ones.
>>> >>   - For a given flow, packets are not reordered.
>>> >>   - Drops during enqueue only.
>>> >>   - ECN capability is off by default.
>>> >>   - ECN threshold is at 10% by default.
>>> >>   - Uses timestamps to calculate queue delay by default.
>>> >>
>>> >> Usage:
>>> >> tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
>>> >>                     [ alpha NUMBER ] [ beta NUMBER ]
>>> >>                     [ target TIME us ] [ tupdate TIME us ]
>>> >>                     [ memory_limit BYTES ] [ quantum BYTES ]
>>> >>                     [ ecnprob PERCENTAGE ] [ [no]ecn ]
>>> >>                     [ [no]bytemode ] [ [no_]dq_rate_estimator ]
>>> >>
>>> >> defaults:
>>> >>   limit: 10240 packets, flows: 1024
>>> >>   alpha: 1/8, beta : 5/4
>>> >>   target: 15 ms, tupdate: 15 ms (in jiffies)
>>> >>   memory_limit: 32 Mb, quantum: device MTU
>>> >>   ecnprob: 10%, ecn: off
>>> >>   bytemode: off, dq_rate_estimator: off
>>> >
>>> > Some reviews below, but hopefully someone who knows more about qdiscs
>>> > will still review :)
>>>
>>> I looked it over, and didn't find anything you hadn't already pointed
>>> out below. It's pretty obvious that this started out as a copy of
>>> sch_fq_codel. Which is good, because that's pretty solid. And bad,
>>> because that means it introduces another almost-identical qdisc without
>>> sharing any of the code...
>>>
>>> I think it would be worthwhile to try to consolidate things at some
>>> point. Either by just merging code from fq_{codel,pie}, but another
>>> option would be to express fq_codel and fq_pie using the fq{,_impl}.h
>>> includes. Maybe even sch_cake as well, but that may take a bit more
>>> work. Not sure if we should require this before merging fq_pie, or just
>>> leave it as a possible enhancement for later? WDYT?
>>
>> Tricky :/ No strong opinion on my side. I'm already a little weary of
>> added function calls in the fast path (e.g. pie_drop_early()), but using
>> some static inlines wouldn't hurt... Then again since fq_codel doesn't
>> use fq{,_impl}.h it indeed seems like a bigger project to clean things
>> up.
>
> Yeah, definitely a bigger project; and I do worry about regressions.
> Especially since fq{,_impl}.h relies heavily on indirect calls...
>
>> IMHO if this qdisc works and is useful it could probably be merged as
>> is. Hopefully we can get an opinion on this from Stephen or others.
>
> OK, fine with me :)
>
> -Toke
>
>


--=20
-------------
Gautam |
