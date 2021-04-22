Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE39367D35
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhDVJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:09:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhDVJJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619082546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rCc8lLkNUHdhonmC2gi0L9aKXC3shqcqZPuL+BdCFg=;
        b=QALoVgz8UbVL6y8tGEgXFDlipk0TV2n4C9Nr3T9vdSx6LW2ZR9KtV8AS9S88QN+/9SC7Ao
        Z9kq1J7inn3raoX47X3Z2CxyN9Oxn7IGQ/nwgK9u+zJN5gS0fx1bh7XNYbCM5CkU+bUyea
        +f4iOufKr9Vtanq2DRs8qgn6Xc6YauY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-KLzexBnFMlGX7mxQAiE-Hw-1; Thu, 22 Apr 2021 05:09:03 -0400
X-MC-Unique: KLzexBnFMlGX7mxQAiE-Hw-1
Received: by mail-ed1-f70.google.com with SMTP id m18-20020a0564025112b0290378d2a266ebso16372546edd.15
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4rCc8lLkNUHdhonmC2gi0L9aKXC3shqcqZPuL+BdCFg=;
        b=CruMy7Eg+EGtJU6ex3X8876vQVqQOUmZzOMs5PuBSPoJ0QbjLrnqVUPIWExXTol6UK
         iOW6loz9FeH2+LWImmsqmd9CpGY1HVqTZJ7e3SwI9XRjA+PyXZ/vFkv28xu7CGQiGrU1
         mrpN4bvefG2oOWozCL4aBTvUIVWsWq2oQEogyiQ7lO8r1BMqgL+tLynyjPNeUUESwmUV
         6KmNsIgnrqHEyWKA0K22EczJQx06PPOmC14bNet86mV5kWnUysvjqDzqNrsfkPxjvN/w
         lKj0cJ3mzQR8YrRvpo3zrGBNHs/HE46wD5JR1+2o2hlj3OW3RONzOkuOUnqZsJRYVlsG
         hnXg==
X-Gm-Message-State: AOAM533vPISg4KwePTH49N901IQs1YSPcwoSo6NiBLxBRo2UD7s1DIc7
        xZl/olbWARvNU4+7WcRp1SDhZkqkdumElh2TNaHZqXfl84EbhcLTRLa7tj/WgifJWAzIy2E9vNC
        ivbpiu82WHTN541zq
X-Received: by 2002:a05:6402:10c9:: with SMTP id p9mr2579860edu.268.1619082541802;
        Thu, 22 Apr 2021 02:09:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjBEzGdVX1CQq9A+Dj2UFi2PunHTkRL//AaNrncT26WrCeL1f0mRERmTIFkIr+bSUhpseTAQ==
X-Received: by 2002:a05:6402:10c9:: with SMTP id p9mr2579834edu.268.1619082541601;
        Thu, 22 Apr 2021 02:09:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ck29sm1559672edb.47.2021.04.22.02.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 02:09:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F378C180675; Thu, 22 Apr 2021 11:08:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
In-Reply-To: <bd2ed7ed-a502-bee5-0a56-0f3064ee2be5@iogearbox.net>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <CAEf4BzYj_pODiQ_Xkdz_czAj3iaBcRhudeb_kJ4M2SczA_jDjA@mail.gmail.com>
 <87tunzh11d.fsf@toke.dk>
 <bd2ed7ed-a502-bee5-0a56-0f3064ee2be5@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Apr 2021 11:08:59 +0200
Message-ID: <875z0ehej8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/21/21 9:48 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
>>> <memxor@gmail.com> wrote:
> [...]
>>>> ---
>>>>   tools/lib/bpf/libbpf.h   |  44 ++++++
>>>>   tools/lib/bpf/libbpf.map |   3 +
>>>>   tools/lib/bpf/netlink.c  | 319 +++++++++++++++++++++++++++++++++++++=
+-
>>>>   3 files changed, 360 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>>>> index bec4e6a6e31d..b4ed6a41ea70 100644
>>>> --- a/tools/lib/bpf/libbpf.h
>>>> +++ b/tools/lib/bpf/libbpf.h
>>>> @@ -16,6 +16,8 @@
>>>>   #include <stdbool.h>
>>>>   #include <sys/types.h>  // for size_t
>>>>   #include <linux/bpf.h>
>>>> +#include <linux/pkt_sched.h>
>>>> +#include <linux/tc_act/tc_bpf.h>
>>>
>>> apart from those unused macros below, are these needed in public API he=
ader?
>>>
>>>>   #include "libbpf_common.h"
>>>>
>>>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_li=
nker *linker, const char *filen
>>>>   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>>>   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>>>
>>>> +/* Convenience macros for the clsact attach hooks */
>>>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
>>>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>>>
>>> these seem to be used only internally, why exposing them in public
>>> API?
>>=20
>> No they're "aliases" for when you want to attach the filter directly to
>> the interface (and thus install the clsact qdisc as the root). You can
>> also use the filter with an existing qdisc (most commonly HTB), in which
>> case you need to specify the qdisc handle as the root. We have a few
>> examples of this use case:
>>=20
>> https://github.com/xdp-project/bpf-examples/tree/master/traffic-pacing-e=
dt
>> and
>> https://github.com/xdp-project/xdp-cpumap-tc
>
> I'm a bit puzzled, could you elaborate on your use case on why you wouldn=
't
> use the tc egress hook for those especially given it's guaranteed to run
> outside of root qdisc lock?

Jesper can correct me if I'm wrong, but I think the first one of the
links above is basically his implementation of just that EDT-based
shaper. And it works reasonably well, except you don't get the nice
per-flow scheduling and sparse flow prioritisation like in FQ-CoDel
unless you implement that yourself in BPF when you set the timestamps
(and that is by no means trivial to implement).

So if you want to use any of the features of the existing qdiscs (I have
also been suggesting to people that they use tc_bpf if they want to
customise sch_cake's notion of flows or shaping tiers), you need to be
able to attach the filter to an existing qdisc. Sure, this means you're
still stuck behind the qdisc lock, but for some applications that is
fine (not everything is a data centre, some devices don't have that many
CPUs anyway; and as the second example above shows, you can get around
the qdisc lock by some clever use of partitioning of flows using
cpumap).

So what this boils down to is, we should keep the 'parent' parameter not
just as an egress/ingress enum, but also as a field the user can fill
out. I'm fine with moving the latter into the opts struct, though, so
maybe the function parameter can be an enum like:

enum bpf_tc_attach_point {
  BPF_TC_CLSACT_INGRESS,
  BPF_TC_CLSACT_EGRESS,
  BPF_TC_QDISC_PARENT
};

where if you set the last one you have to fill in the parent in opts?

-Toke

