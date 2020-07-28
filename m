Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF102311B8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732434AbgG1S27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgG1S26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:28:58 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B383C061794;
        Tue, 28 Jul 2020 11:28:58 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id j10so2913673qvo.13;
        Tue, 28 Jul 2020 11:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1rpHtskjxrM2i+o6HJIWEi0DF9GgQejEkqnPKF0GUcg=;
        b=GpatUsFIglnfF94LLR9yqFnCVGuGihT9JvZbpF8/EiJRypp++fRTML2bms41VpATT2
         kcT4JXwaI+Jug97m9j2bvpcATp9Puw1VKp9p5+H6mjpn7wPQtUIrKgskXvZtTK4k1nK7
         b0/qDa+YXKcJdkkrJSMTHHpR1ZGcs7AZQGJ2+T1kgFw3ThB8Tc/LocwLftHAP9lgFmze
         TScAzSbv/LOwVpGRLF+zK4qhVPm+nUAZqrswZ1NaafvsZVtcA6JorttXrRM0K0ZkvgxE
         bMtvMJnU7YBqwpteHMyiRJ9kp0d7RMOl6zmBq5juOZK+bJ+oSWlVXal5vCLFZq4FASaT
         052g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1rpHtskjxrM2i+o6HJIWEi0DF9GgQejEkqnPKF0GUcg=;
        b=oEXVL7WXYok71bD637Egd1CStxkI5TP5uIDiV7ERlta6mr6GDvxfvURcG5Z/qCp0mP
         1pTSgQNshwkrpN1psh8m2kl5FAT/iKu1U87MrM3b6xXQUnuunKXkBoGbpXLtbzHsH1jh
         PaMVXlBt3McamEQ0UZGIkE/4MLjgFbtNM7BGi51YgCntLC7eb8Sc8kFgA3m+UWHegzSw
         c+Gtm2xrwfLF03VF1NfhTGkLWVz1cxgB+Qm8COEVgblyg+dSSvp2AYn9+LBkRhbMEsY3
         kReSMNEdOchqmfcuwCeCziJWAl2i2c4lOltbzGWkSr2YnmTuYI1seHIBAepsSSB5PXJ0
         flQQ==
X-Gm-Message-State: AOAM532UOT4NOBynGTT98zQ5jpQmYjcT5pAVnRQhC7sftKcfpYvm0SJ2
        Iyv9AKOpYAHCGVbN9pHiu+Vg3LxHnuE56MEFGoo=
X-Google-Smtp-Source: ABdhPJyWyT8/JV97sGku2kNUcmdn/R9V9f9c52KfMfng7AUHG3XoyE1iYGocfXUZn/YkT0GxsEkZVzcMvTxaCCy7Iyc=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr29631452qvv.163.1595960937715;
 Tue, 28 Jul 2020 11:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200727233431.4103-1-bimmy.pujari@intel.com> <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
 <CANP3RGd2fKh7qXyWVeqPM8nVKZRtJrJ65apmGF=w9cwXy6TReQ@mail.gmail.com>
In-Reply-To: <CANP3RGd2fKh7qXyWVeqPM8nVKZRtJrJ65apmGF=w9cwXy6TReQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 11:28:46 -0700
Message-ID: <CAEf4BzaiCZ3rOBc0EXuLUuWh9m5QXv=51Aoyi5OHwb6T11nnjw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     bimmy.pujari@intel.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, mchehab@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 10:57 AM Maciej =C5=BBenczykowski <maze@google.com>=
 wrote:
>
> On Mon, Jul 27, 2020 at 10:01 PM Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
>>
>> On Mon, Jul 27, 2020 at 4:35 PM <bimmy.pujari@intel.com> wrote:
>> >
>> > From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
>> >
>> > The existing bpf helper functions to get timestamp return the time
>> > elapsed since system boot. This timestamp is not particularly useful
>> > where epoch timestamp is required or more than one server is involved
>> > and time sync is required. Instead, you want to use CLOCK_REALTIME,
>> > which provides epoch timestamp.
>> > Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
>> >
>>
>> This doesn't seem like a good idea.
>
>
> I disagree.
>
>>
>> With time-since-boot it's very
>> easy to translate timestamp into a real time on the host.
>
>
> While it's easy to do, it's annoying, because you need to hardcode the of=
fset into the bpf program
> (which has security implications) or use another bpf array lookup/read (p=
erf implications).

There is no array lookup/read if you are using a global variable for this.

>
>>
>> Having
>> get_real_ns() variant might just encourage people to assume precise
>> wall-clock timestamps that can be compared between within or even
>> across different hosts.
>
>
> In some environments they *can*.  Within a datacenter it is pretty common
> to have extremely tightly synchronized clocks across thousands of machine=
s.

In some, yes, which also means that in some other they can't. So I'm
still worried about misuses of REALCLOCK, within (internal daemons
within the company) our outside (BCC tools and alike) of data centers.
Especially if people will start using it to measure elapsed time
between events. I'd rather not have to explain over and over again
that REALCLOCK is not for measuring passage of time.

>
>>
>> REALCLOCK can jump around, you can get
>> duplicate timestamps, timestamps can go back in time, etc.
>
>
> That's only true if you allow it to.  On a server machine, once it's boot=
ed

Right, but BPF is used so widely that it will be true at least in some case=
s.

> up and time is synchronized, it no longer jumps around, only the frequenc=
y
> is slowly adjusted to keep things in sync.
>
>>
>> It's just not a good way to measure time.
>
>
> It doesn't change the fact that some packets/protocols include real world=
 timestamps.
> We already have the since-boot time fetchers, so this doesn't prevent you=
 from
> using that - if that is what you want.
>
> Also one thing to remember is that a lot of time you only need ~1s precis=
ion.
> In which case 'real' can simply be a lot easier to deal with.
>

Again, I'm worried about ensuing confusion by users trying to pick
which variant to use. I'm not worried about those who understand the
difference and can pick the right one for their needs, I'm worried
about those that don't even give it a second thought. Given it's
rather simple to convert boot time into wall-clock time, it doesn't
seem like a necessary addition.

>>
>> Also, you mention the need for time sync. It's an extremely hard thing
>> to have synchronized time between two different physical hosts, as
>> anyone that has dealt with distributed systems will attest. Having
>> this helper will just create a dangerous illusion that it is possible
>> and will just cause more problems down the road for people.
>
>
> It is possible.  But yes.  It is very very hard.
> You can read up on Google TrueTime as an example real world implementatio=
n.

Thank you, I did, though quite a while ago. Notice, I didn't say it's
impossible, right? ;) But then Google TrueTime provides a range of
time within confidence intervals, not a single seemingly-deterministic
timestamp. And it needs custom hardware, so it's not realistic to
expect to have it everywhere :)

>
>>
>>
>> > Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
>> > Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
>> > ---
>> >  drivers/media/rc/bpf-lirc.c    |  2 ++
>> >  include/linux/bpf.h            |  1 +
>> >  include/uapi/linux/bpf.h       |  7 +++++++
>> >  kernel/bpf/core.c              |  1 +
>> >  kernel/bpf/helpers.c           | 14 ++++++++++++++
>> >  kernel/trace/bpf_trace.c       |  2 ++
>> >  tools/include/uapi/linux/bpf.h |  7 +++++++
>> >  7 files changed, 34 insertions(+)
>>
>> [...]
>
>
> Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
