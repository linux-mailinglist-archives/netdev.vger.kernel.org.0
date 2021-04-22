Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD83680C6
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhDVMqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:46:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236340AbhDVMqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 08:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619095575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJdetsQNKO+HfPrY27/1LZB2tNfMg+8AplOf5GBQwVs=;
        b=eepqfEzFHUt7UPARGa75LJz2W/np60elv6IT2Q3AGEDnJLEZSOAMgDSGuxESs6Bx1kdrlx
        2AqED9l+Jz3hr7Mb7ceTKbrzltXA8gR1Ne4QIbH+s00jCGLbIcbTP7KECpnVKF2nJH+ghO
        stawTHUGixjFDmVXcu88cTKGWIIHFps=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-am-3U1-wN9S1zOmrUHITxg-1; Thu, 22 Apr 2021 08:46:12 -0400
X-MC-Unique: am-3U1-wN9S1zOmrUHITxg-1
Received: by mail-ed1-f71.google.com with SMTP id r4-20020a0564022344b0290382ce72b7f9so16681041eda.19
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 05:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wJdetsQNKO+HfPrY27/1LZB2tNfMg+8AplOf5GBQwVs=;
        b=uP/0ETM2Fwp8nJjK0cLLzgERu/VJpUsc7/frFrSODhkvTdrCj8YP2TwQVTLzE403gP
         PyQE77pYZuRnKXTEO4A/QOPD61xacQ2Ebvp9LwRv4AqjWH84KviZS8sW97CEKFPavAeV
         dcxA9e4W+GMZExuVOSQAK5JrE10/oDgrU52INTCD/VAvqzZ6OCldCUIO+E2kd6x63tgL
         NiMT3vDN7kyFq+zefNY11gfZ2R6syDFidlJbmYlokrjpf5ZgTmR1Hm4ip8I2mp7woTqa
         4SWIzQOdgi08AXPA/U7LB3hm1vsQEq/JQAlVN3GRSW2Vpj1bYGEB3JTvXf0RbOCdNZSc
         Y2Eg==
X-Gm-Message-State: AOAM533wWRthYywJGocy25v+tb/lGLJSGOPq5XSUmp9wOWi8TG9SUuif
        EhWMTaIyo4/k7wZ0p1gD8yfOQptI/x6pNXWu6iytoOw822PMQmk7WliN6VunEA2yWMJYb4nyCNs
        E8AP8VJmVbcKvCGwk
X-Received: by 2002:a17:906:350e:: with SMTP id r14mr3189837eja.365.1619095571629;
        Thu, 22 Apr 2021 05:46:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGkQVIAQtHd9cDZNFi4IVj77yakTnxMj5BdrnuUZbozuZW9uuUei5Hn20uAb1OJjqp/YUCuQ==
X-Received: by 2002:a17:906:350e:: with SMTP id r14mr3189809eja.365.1619095571349;
        Thu, 22 Apr 2021 05:46:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d14sm2008128edc.11.2021.04.22.05.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 05:46:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 20980180675; Thu, 22 Apr 2021 14:46:10 +0200 (CEST)
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
In-Reply-To: <ab19b29f-f7a7-5f4b-001f-28d57c6c203f@iogearbox.net>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <CAEf4BzYj_pODiQ_Xkdz_czAj3iaBcRhudeb_kJ4M2SczA_jDjA@mail.gmail.com>
 <87tunzh11d.fsf@toke.dk>
 <bd2ed7ed-a502-bee5-0a56-0f3064ee2be5@iogearbox.net>
 <875z0ehej8.fsf@toke.dk>
 <ab19b29f-f7a7-5f4b-001f-28d57c6c203f@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Apr 2021 14:46:10 +0200
Message-ID: <8735vih4h9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/22/21 11:08 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 4/21/21 9:48 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>>> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
>>>>> <memxor@gmail.com> wrote:
>>> [...]
>>>>>> ---
>>>>>>    tools/lib/bpf/libbpf.h   |  44 ++++++
>>>>>>    tools/lib/bpf/libbpf.map |   3 +
>>>>>>    tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++=
++++-
>>>>>>    3 files changed, 360 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>>>>>> index bec4e6a6e31d..b4ed6a41ea70 100644
>>>>>> --- a/tools/lib/bpf/libbpf.h
>>>>>> +++ b/tools/lib/bpf/libbpf.h
>>>>>> @@ -16,6 +16,8 @@
>>>>>>    #include <stdbool.h>
>>>>>>    #include <sys/types.h>  // for size_t
>>>>>>    #include <linux/bpf.h>
>>>>>> +#include <linux/pkt_sched.h>
>>>>>> +#include <linux/tc_act/tc_bpf.h>
>>>>>
>>>>> apart from those unused macros below, are these needed in public API =
header?
>>>>>
>>>>>>    #include "libbpf_common.h"
>>>>>>
>>>>>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_=
linker *linker, const char *filen
>>>>>>    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>>>>>    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>>>>>
>>>>>> +/* Convenience macros for the clsact attach hooks */
>>>>>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRE=
SS)
>>>>>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>>>>>
>>>>> these seem to be used only internally, why exposing them in public
>>>>> API?
>>>>
>>>> No they're "aliases" for when you want to attach the filter directly to
>>>> the interface (and thus install the clsact qdisc as the root). You can
>>>> also use the filter with an existing qdisc (most commonly HTB), in whi=
ch
>>>> case you need to specify the qdisc handle as the root. We have a few
>>>> examples of this use case:
>>>>
>>>> https://github.com/xdp-project/bpf-examples/tree/master/traffic-pacing=
-edt
>>>> and
>>>> https://github.com/xdp-project/xdp-cpumap-tc
>>>
>>> I'm a bit puzzled, could you elaborate on your use case on why you woul=
dn't
>>> use the tc egress hook for those especially given it's guaranteed to run
>>> outside of root qdisc lock?
>>=20
>> Jesper can correct me if I'm wrong, but I think the first one of the
>> links above is basically his implementation of just that EDT-based
>> shaper. And it works reasonably well, except you don't get the nice
>> per-flow scheduling and sparse flow prioritisation like in FQ-CoDel
>> unless you implement that yourself in BPF when you set the timestamps
>> (and that is by no means trivial to implement).
>>=20
>> So if you want to use any of the features of the existing qdiscs (I have
>> also been suggesting to people that they use tc_bpf if they want to
>> customise sch_cake's notion of flows or shaping tiers), you need to be
>> able to attach the filter to an existing qdisc. Sure, this means you're
>> still stuck behind the qdisc lock, but for some applications that is
>> fine (not everything is a data centre, some devices don't have that many
>> CPUs anyway; and as the second example above shows, you can get around
>> the qdisc lock by some clever use of partitioning of flows using
>> cpumap).
>>=20
>> So what this boils down to is, we should keep the 'parent' parameter not
>> just as an egress/ingress enum, but also as a field the user can fill
>> out. I'm fine with moving the latter into the opts struct, though, so
>> maybe the function parameter can be an enum like:
>>=20
>> enum bpf_tc_attach_point {
>>    BPF_TC_CLSACT_INGRESS,
>>    BPF_TC_CLSACT_EGRESS,
>>    BPF_TC_QDISC_PARENT
>> };
>>=20
>> where if you set the last one you have to fill in the parent in opts?
>
> Fair enough, I still think this is a bit backwards and should be discoura=
ged
> given the constraints, but if you have an actual need for it ... I'd rath=
er
> simplify API naming, the fact that it's clsact is an implementation detail
> and shouldn't matter to a user, like:
>
> enum bpf_tc_attach_point {
> 	BPF_TC_INGRESS,
> 	BPF_TC_EGRESS,
> 	BPF_TC_CUSTOM_PARENT,
> };
>
> For BPF_TC_INGRESS and BPF_TC_EGRESS, I would enforce opts parent paramet=
er
> to be /zero/ from the API.

OK, SGTM :)

-Toke

