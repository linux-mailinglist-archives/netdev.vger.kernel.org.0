Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1503673BD
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243366AbhDUTs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235886AbhDUTs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 15:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619034505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDyAIAqxEn1SzlmQk6UpZ8hs3r6UcjdZArF9QOOa8Jk=;
        b=bP+xMkLB+pab2BZjl5J6CBIoO117bH98C6bDTZofqg4XCu5/lAmkeoNt7VUXzmcZquTtoz
        ipBemHpHm4428QxpXZlwJUcX/aYJ3v/kzeq7iHvl9bfVAoMBTDx2trjo8vU28PUefUfNv0
        0RY5JvtG9ZC4kcyTMMKTGdDHgt4oT9o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-X7pKH2LJO3GMxMMAD_zBCQ-1; Wed, 21 Apr 2021 15:48:17 -0400
X-MC-Unique: X7pKH2LJO3GMxMMAD_zBCQ-1
Received: by mail-ej1-f69.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso6278789ejn.10
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 12:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=aDyAIAqxEn1SzlmQk6UpZ8hs3r6UcjdZArF9QOOa8Jk=;
        b=gL6G1Ynqe3SSapCQSraQXdjTnusNGaETyWZK0rKLraeK7rM9QDqTyGqSop262POUhF
         ldSusDQrwvM8zmRGwaZafb9g95WVQ1uNM/g3I4G+oNFd7mpp2TsndJOeW19PBOFNY8Ad
         WjdmBooPLMGOP3gmaUMWLkCXGGMnBM0iGcP9gDci0PFXqgFez7uMkYF4ZB7ZjP4kr4/0
         nRIvYSchTfwONL2gWgqT/xPAAmlUNI6uD2K1ety8A8MRgwBFYCpGJoAF/LGcJ4sO+j6d
         RNXP0cBHbiDEhxshhMMrv/Utpep3rP9J5dq6reTSL9q5o8C5HNsNEc7E12Tkhg94Mwjj
         DcRw==
X-Gm-Message-State: AOAM533I1lPoGuqwIi03GUZ8zQXGTszrq6f+AKk8zAkkEqKh8jEh85rP
        CuIJbyNmtPOmxcqMkgPwSYt0gaGFCITEPov8CVPQG9spRX6Q/MN1HC7sJVfON0/LEm1kzUmm5k2
        aXaLzPwxGph37eBHZ
X-Received: by 2002:a17:906:1c98:: with SMTP id g24mr34969325ejh.457.1619034496277;
        Wed, 21 Apr 2021 12:48:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUEQGSALFlwav/fV6aD+lgzplpjC3to3umNZrY1bwWGdvt15dySM2RR9Gi0GKsq8zflWd6BA==
X-Received: by 2002:a17:906:1c98:: with SMTP id g24mr34969298ejh.457.1619034495962;
        Wed, 21 Apr 2021 12:48:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v19sm314399ejy.78.2021.04.21.12.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 12:48:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 501A41802FE; Wed, 21 Apr 2021 21:48:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
In-Reply-To: <CAEf4BzYj_pODiQ_Xkdz_czAj3iaBcRhudeb_kJ4M2SczA_jDjA@mail.gmail.com>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <CAEf4BzYj_pODiQ_Xkdz_czAj3iaBcRhudeb_kJ4M2SczA_jDjA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Apr 2021 21:48:14 +0200
Message-ID: <87tunzh11d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>>
>> This adds functions that wrap the netlink API used for adding,
>> manipulating, and removing traffic control filters. These functions
>> operate directly on the loaded prog's fd, and return a handle to the
>> filter using an out parameter named id.
>>
>> The basic featureset is covered to allow for attaching and removal of
>> filters. Some additional features like TCA_BPF_POLICE and TCA_RATE for
>> the API have been omitted. These can added on top later by extending the
>> bpf_tc_opts struct.
>>
>> Support for binding actions directly to a classifier by passing them in
>> during filter creation has also been omitted for now. These actions have
>> an auto clean up property because their lifetime is bound to the filter
>> they are attached to. This can be added later, but was omitted for now
>> as direct action mode is a better alternative to it, which is enabled by
>> default.
>>
>> An API summary:
>>
>> bpf_tc_attach may be used to attach, and replace SCHED_CLS bpf
>> classifier. The protocol is always set as ETH_P_ALL. The replace option
>> in bpf_tc_opts is used to control replacement behavior.  Attachment
>> fails if filter with existing attributes already exists.
>>
>> bpf_tc_detach may be used to detach existing SCHED_CLS filter. The
>> bpf_tc_attach_id object filled in during attach must be passed in to the
>> detach functions for them to remove the filter and its attached
>> classififer correctly.
>>
>> bpf_tc_get_info is a helper that can be used to obtain attributes
>> for the filter and classififer.
>>
>> Examples:
>>
>>         struct bpf_tc_attach_id id =3D {};
>>         struct bpf_object *obj;
>>         struct bpf_program *p;
>>         int fd, r;
>>
>>         obj =3D bpf_object_open("foo.o");
>>         if (IS_ERR_OR_NULL(obj))
>>                 return PTR_ERR(obj);
>>
>>         p =3D bpf_object__find_program_by_title(obj, "classifier");
>>         if (IS_ERR_OR_NULL(p))
>>                 return PTR_ERR(p);
>>
>>         if (bpf_object__load(obj) < 0)
>>                 return -1;
>>
>>         fd =3D bpf_program__fd(p);
>>
>>         r =3D bpf_tc_attach(fd, if_nametoindex("lo"),
>>                           BPF_TC_CLSACT_INGRESS,
>>                           NULL, &id);
>>         if (r < 0)
>>                 return r;
>>
>> ... which is roughly equivalent to:
>>   # tc qdisc add dev lo clsact
>>   # tc filter add dev lo ingress bpf obj foo.o sec classifier da
>>
>> ... as direct action mode is always enabled.
>>
>> To replace an existing filter:
>>
>>         DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D id.handle,
>>                             .priority =3D id.priority, .replace =3D true=
);
>>         r =3D bpf_tc_attach(fd, if_nametoindex("lo"),
>>                           BPF_TC_CLSACT_INGRESS,
>>                           &opts, &id);
>>         if (r < 0)
>>                 return r;
>>
>> To obtain info of a particular filter, the example above can be extended
>> as follows:
>>
>>         struct bpf_tc_info info =3D {};
>>
>>         r =3D bpf_tc_get_info(if_nametoindex("lo"),
>>                             BPF_TC_CLSACT_INGRESS,
>>                             &id, &info);
>>         if (r < 0)
>>                 return r;
>>
>> ... where id corresponds to the bpf_tc_attach_id filled in during an
>> attach operation.
>>
>> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> ---
>>  tools/lib/bpf/libbpf.h   |  44 ++++++
>>  tools/lib/bpf/libbpf.map |   3 +
>>  tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 360 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index bec4e6a6e31d..b4ed6a41ea70 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -16,6 +16,8 @@
>>  #include <stdbool.h>
>>  #include <sys/types.h>  // for size_t
>>  #include <linux/bpf.h>
>> +#include <linux/pkt_sched.h>
>> +#include <linux/tc_act/tc_bpf.h>
>
> apart from those unused macros below, are these needed in public API head=
er?
>
>>
>>  #include "libbpf_common.h"
>>
>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_link=
er *linker, const char *filen
>>  LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>  LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>
>> +/* Convenience macros for the clsact attach hooks */
>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>
> these seem to be used only internally, why exposing them in public
> API?

No they're "aliases" for when you want to attach the filter directly to
the interface (and thus install the clsact qdisc as the root). You can
also use the filter with an existing qdisc (most commonly HTB), in which
case you need to specify the qdisc handle as the root. We have a few
examples of this use case:

https://github.com/xdp-project/bpf-examples/tree/master/traffic-pacing-edt
and
https://github.com/xdp-project/xdp-cpumap-tc

>> +struct bpf_tc_opts {
>> +       size_t sz;
>> +       __u32 handle;
>> +       __u32 class_id;
>> +       __u16 priority;
>> +       bool replace;
>> +       size_t :0;
>> +};
>> +
>> +#define bpf_tc_opts__last_field replace
>> +
>> +/* Acts as a handle for an attached filter */
>> +struct bpf_tc_attach_id {
>> +       __u32 handle;
>> +       __u16 priority;
>> +};
>
> what are the chances that we'll need to grow this id struct? If that
> happens, how do we do that in a backward/forward compatible manner?
>
> if handle/prio are the only two ever necessary, we can actually use
> bpf_tc_opts to return them back to user (we do that with
> bpf_test_run_opts API). And then adjust detach/get_info methods to let
> pass those values.
>
> The whole idea of a struct for id just screams "compatibility problems
> down the road" at me. Does anyone else has any other opinion on this?

Well, *if* we ever want to extend them (e.g., to support other values of
the protocol field, if that ever becomes necessary), we'll probably also
want to make it possible to pass the same identifiers as options, so
just reusing the opts struct definitely makes sense!

>> +struct bpf_tc_info {
>> +       struct bpf_tc_attach_id id;
>> +       __u16 protocol;
>> +       __u32 chain_index;
>> +       __u32 prog_id;
>> +       __u8 tag[BPF_TAG_SIZE];
>> +       __u32 class_id;
>> +       __u32 bpf_flags;
>> +       __u32 bpf_flags_gen;
>> +};
>> +
>> +/* id is out parameter that will be written to, it must not be NULL */
>> +LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
>
> so parent_id is INGRESS|EGRESS, right? Is that an obvious name for
> this parameter? I had to look at the code to understand what's
> expected. Is it possible that it will be anything other than INGRESS
> or EGRESS? If not `bool ingress` might be an option. Or perhaps enum
> bpf_tc_direction { BPF_TC_INGRESS, BPF_TC_EGRESS } is better still.

See above; the parent is the attach point, and you use the defines from
above if you just want to attach to the interface.

But maybe documenting this in a comment above the function signature
would be good (along with a bit of terminology from the TC world for
those coming from there) :)

>> +                            const struct bpf_tc_opts *opts,
>> +                            struct bpf_tc_attach_id *id);
>> +LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
>> +                            const struct bpf_tc_attach_id *id);
>> +LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
>
> bpf_tc_query() to be more in line with attach/detach single-word
> verbs?

OK by me!

-Toke

