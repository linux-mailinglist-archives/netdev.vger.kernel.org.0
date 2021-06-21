Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF233AF78C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFUVmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:42:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230331AbhFUVmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 17:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624311596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jzWaPe8h4CRseJEm0cE/5rnrSI8YdCLOcrVRZjUcpOU=;
        b=hWfFyKYwbN57wwEv5b2Y65vEdTW0Q/r+/QIEarIetjTdc9fGlZQWE1eCLjBa8UR42UkVJL
        +uRFlCwsDKnJUZ79qxhSyiIycLbjHnVwgppoNgAhCEFjIU70YS6i0J9ICBT8rQZMbIdCOm
        fXsMdHS+ixeHqvE/SAVdpLq6PjyDOJk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-fFnX7u0WMte4bAlRKEsFrQ-1; Mon, 21 Jun 2021 17:39:55 -0400
X-MC-Unique: fFnX7u0WMte4bAlRKEsFrQ-1
Received: by mail-ed1-f71.google.com with SMTP id v8-20020a0564023488b0290393873961f6so8440800edc.17
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 14:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=jzWaPe8h4CRseJEm0cE/5rnrSI8YdCLOcrVRZjUcpOU=;
        b=aKSFou8IriySXk4iGfcV6o+8he5PbYpo87gn/wr0y4enqm/XekSsLY7S+IlQ4KPTDo
         w1LCXBMeqRzvZPKNet91twYgsh/xxdbmvP7x0bJhidne3z1NjaIbDJMBL2Onqizto8EW
         azSn+0ClRvP0BpEYfon0tJ4LORvKkhVcZFvQW1ifsTvr8QKkT21gm+ZPDSZjatQ9CHQF
         nywMVZLj1tNa8ogWwXFpF1Ya806xLyCCh0/RVBfsN6yXcPg/eXWfckRqcSFezupK7UCC
         DDDK6GYYAcLBqLoj+L35xCkMvbwhZlLnIySi6Uzviz+Lv+o1yRfHw/C9BWZQkFnzgPXC
         AAoA==
X-Gm-Message-State: AOAM531h64Ef2hj+rEO89FCvJgo0jnhIwqWodA2vOnzCGpX/gQy/BtKC
        ZYfScByyOY7ZBfiMDsVnfn7XtmU1c+CDWI4SrlhqBZ8lK7rctgZIC5Tn0G/sLUi4bi7BCsDmgmg
        3lgDZ4AoUvR4c/dpB
X-Received: by 2002:a17:907:a064:: with SMTP id ia4mr228481ejc.482.1624311593859;
        Mon, 21 Jun 2021 14:39:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkUNgwLUZ881r6H3AO8bCpuxwbtyM7I8bD2+OLW6XYrMJCG7moZIAnPlz3IETx4zMGJe2vCA==
X-Received: by 2002:a17:907:a064:: with SMTP id ia4mr228468ejc.482.1624311593660;
        Mon, 21 Jun 2021 14:39:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g16sm5129750ejh.92.2021.06.21.14.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 14:39:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B921618071D; Mon, 21 Jun 2021 23:39:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 21 Jun 2021 23:39:51 +0200
Message-ID: <87zgvirj6g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 6/17/21 11:27 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> XDP_REDIRECT works by a three-step process: the bpf_redirect() and
>> bpf_redirect_map() helpers will lookup the target of the redirect and st=
ore
>> it (along with some other metadata) in a per-CPU struct bpf_redirect_inf=
o.
>> Next, when the program returns the XDP_REDIRECT return code, the driver
>> will call xdp_do_redirect() which will use the information thus stored to
>> actually enqueue the frame into a bulk queue structure (that differs
>> slightly by map type, but shares the same principle). Finally, before
>> exiting its NAPI poll loop, the driver will call xdp_do_flush(), which w=
ill
>> flush all the different bulk queues, thus completing the redirect.
>>=20
>> Pointers to the map entries will be kept around for this whole sequence =
of
>> steps, protected by RCU. However, there is no top-level rcu_read_lock() =
in
>> the core code; instead drivers add their own rcu_read_lock() around the =
XDP
>> portions of the code, but somewhat inconsistently as Martin discovered[0=
].
>> However, things still work because everything happens inside a single NA=
PI
>> poll sequence, which means it's between a pair of calls to
>> local_bh_disable()/local_bh_enable(). So Paul suggested[1] that we could
>> document this intention by using rcu_dereference_check() with
>> rcu_read_lock_bh_held() as a second parameter, thus allowing sparse and
>> lockdep to verify that everything is done correctly.
>>=20
>> This patch does just that: we add an __rcu annotation to the map entry
>> pointers and remove the various comments explaining the NAPI poll assura=
nce
>> strewn through devmap.c in favour of a longer explanation in filter.c. T=
he
>> goal is to have one coherent documentation of the entire flow, and rely =
on
>> the RCU annotations as a "standard" way of communicating the flow in the
>> map code (which can additionally be understood by sparse and lockdep).
>>=20
>> The RCU annotation replacements result in a fairly straight-forward
>> replacement where READ_ONCE() becomes rcu_dereference_check(), WRITE_ONC=
E()
>> becomes rcu_assign_pointer() and xchg() and cmpxchg() gets wrapped in the
>> proper constructs to cast the pointer back and forth between __rcu and
>> __kernel address space (for the benefit of sparse). The one complication=
 is
>> that xskmap has a few constructions where double-pointers are passed back
>> and forth; these simply all gain __rcu annotations, and only the final
>> reference/dereference to the inner-most pointer gets changed.
>>=20
>> With this, everything can be run through sparse without eliciting
>> complaints, and lockdep can verify correctness even without the use of
>> rcu_read_lock() in the drivers. Subsequent patches will clean these up f=
rom
>> the drivers.
>>=20
>> [0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mb=
p.dhcp.thefacebook.com/
>> [1] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad=
-P17-Gen-1/
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>   include/net/xdp_sock.h |  2 +-
>>   kernel/bpf/cpumap.c    | 13 +++++++----
>>   kernel/bpf/devmap.c    | 49 ++++++++++++++++++------------------------
>>   net/core/filter.c      | 28 ++++++++++++++++++++++++
>>   net/xdp/xsk.c          |  4 ++--
>>   net/xdp/xsk.h          |  4 ++--
>>   net/xdp/xskmap.c       | 29 ++++++++++++++-----------
>>   7 files changed, 80 insertions(+), 49 deletions(-)
> [...]
>>   						 __dev_map_entry_free);
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index caa88955562e..0b7db5c70385 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3922,6 +3922,34 @@ static const struct bpf_func_proto bpf_xdp_adjust=
_meta_proto =3D {
>>   	.arg2_type	=3D ARG_ANYTHING,
>>   };
>>=20=20=20
>> +/* XDP_REDIRECT works by a three-step process, implemented in the funct=
ions
>> + * below:
>> + *
>> + * 1. The bpf_redirect() and bpf_redirect_map() helpers will lookup the=
 target
>> + *    of the redirect and store it (along with some other metadata) in =
a per-CPU
>> + *    struct bpf_redirect_info.
>> + *
>> + * 2. When the program returns the XDP_REDIRECT return code, the driver=
 will
>> + *    call xdp_do_redirect() which will use the information in struct
>> + *    bpf_redirect_info to actually enqueue the frame into a map type-s=
pecific
>> + *    bulk queue structure.
>> + *
>> + * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_fl=
ush(),
>> + *    which will flush all the different bulk queues, thus completing t=
he
>> + *    redirect.
>> + *
>> + * Pointers to the map entries will be kept around for this whole seque=
nce of
>> + * steps, protected by RCU. However, there is no top-level rcu_read_loc=
k() in
>> + * the core code; instead, the RCU protection relies on everything happ=
ening
>> + * inside a single NAPI poll sequence, which means it's between a pair =
of calls
>> + * to local_bh_disable()/local_bh_enable().
>> + *
>> + * The map entries are marked as __rcu and the map code makes sure to
>> + * dereference those pointers with rcu_dereference_check() in a way tha=
t works
>> + * for both sections that to hold an rcu_read_lock() and sections that =
are
>> + * called from NAPI without a separate rcu_read_lock(). The code below =
does not
>> + * use RCU annotations, but relies on those in the map code.
>
> One more follow-up question related to tc BPF: given we do use rcu_read_l=
ock_bh()
> in case of sch_handle_egress(), could we also remove the rcu_read_lock() =
pair
> from cls_bpf_classify() then?

I believe so, yeah. Patch 2 in this series should even make lockdep stop
complaining about it :)

I can add a patch removing the rcu_read_lock() from cls_bpf in the next
version.

> It would also be great if this scenario in general could be placed
> under the Documentation/RCU/whatisRCU.rst as an example, so we could
> refer to the official doc on this, too, if Paul is good with this.

I'll take a look and see if I can find a way to fit it in there...

> Could you also update the RCU comment in bpf_prog_run_xdp()? Or
> alternatively move all the below driver comments in there as a single
> location?
>
>    /* This code is invoked within a single NAPI poll cycle and thus under
>     * local_bh_disable(), which provides the needed RCU protection.
>     */

Sure, can do. And yeah, I do agree that moving the comment in there
makes more sense than scattering it over all the drivers, even if that
means I have to go back and edit all the drivers again :P

-Toke

