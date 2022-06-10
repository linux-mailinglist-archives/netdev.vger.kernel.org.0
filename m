Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DC8546E22
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350577AbiFJUQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350566AbiFJUQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:16:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5D61252C23
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 13:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654892183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XUd3iI82RYKfLGGyIgdiniKbIV1mTuvEfES7u11sPk=;
        b=hceNo2dIQZviffJ4kowf3pXv9Rqmsr7BzR3LfUH6Gq1x1mTPYMU34NxwwxQNHPjcbbIDWu
        uahdDuBVoSj1vjEfxEPTfwbJhIsAZSYvwdOq7iDFsFrp3el847+/gTC8GgANsyg0KoxNkK
        rgE48dPQ0U/sDnXyV+oNn95GacfDRHM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-NgfpSA4JOneHqKoN4Io7tA-1; Fri, 10 Jun 2022 16:16:22 -0400
X-MC-Unique: NgfpSA4JOneHqKoN4Io7tA-1
Received: by mail-ed1-f71.google.com with SMTP id g8-20020a056402090800b00433940d207eso170438edz.1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 13:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1XUd3iI82RYKfLGGyIgdiniKbIV1mTuvEfES7u11sPk=;
        b=JNVSpOl7MtVWYu8j+/a+3LkjugaKbXrLSbklTywccAiKDUj18NiLjVLODnEiqdL0oi
         KmCCzMW08+rGNK1SUHz0PWP2MrOaLtV6VaKuoGJI+Vw21KO5uSy+AdF+QzHfzw9D3mlN
         u664hJwn8igybcEStLKU29f/SPtRDFlVr8vofVzgsgKq5o8vHKQ1yJEU+/sDfx891PsH
         b0EIjeDVJyIl4nLDyyq/M++tOiqgU54gIDhagelgeqS1xfq662KdM5SguwXq3uQAn/dM
         iZJdKcFAC2mF21Xao3ASfiDSLVoiqSQwRNUwM0S9GT59RawnCVJgK3MgIftP2ur7Nxsa
         yhDg==
X-Gm-Message-State: AOAM5326r+R2MiYCflkhWLa6pVNqidNkjhGefniOFvKbXu8DwuiFjskm
        pp8LrbCewFnNqfycJkRMW+nGGULABcD0WkzObtb0hPBy2bU5785ojGRqGiO0+nsT7EL7nPfyG05
        Fl/U0pTGvvHq9tOBK
X-Received: by 2002:a05:6402:1910:b0:42d:f4f8:c7bd with SMTP id e16-20020a056402191000b0042df4f8c7bdmr52933596edz.382.1654892180959;
        Fri, 10 Jun 2022 13:16:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziNdRX+/uPl6hhvUNC82p0euBOChJ3fCULQGaTwdJffLPzzzZbD5Pz3Zk5hnyRowF8hp5sHw==
X-Received: by 2002:a05:6402:1910:b0:42d:f4f8:c7bd with SMTP id e16-20020a056402191000b0042df4f8c7bdmr52933539edz.382.1654892180121;
        Fri, 10 Jun 2022 13:16:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id da26-20020a056402177a00b004315050d7dfsm96186edb.81.2022.06.10.13.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 13:16:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AB9BD405EF6; Fri, 10 Jun 2022 22:16:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
In-Reply-To: <20220610193418.4kqpu7crwfb5efzy@apollo.legion>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jun 2022 22:16:18 +0200
Message-ID: <87h74s2s19.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Sat, Jun 11, 2022 at 12:37:50AM IST, Joanne Koong wrote:
>> On Fri, Jun 10, 2022 at 10:23 AM Joanne Koong <joannelkoong@gmail.com> w=
rote:
>> >
>> > On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
>> > <memxor@gmail.com> wrote:
>> > >
>> > > On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
>> > > > On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
>> > > > <memxor@gmail.com> wrote:
>> > > > >
>> > > > > This is the second (non-RFC) version.
>> > > > >
>> > > > > This adds a bpf_link path to create TC filters tied to cls_bpf c=
lassifier, and
>> > > > > introduces fd based ownership for such TC filters. Netlink canno=
t delete or
>> > > > > replace such filters, but the bpf_link is severed on indirect de=
struction of the
>> > > > > filter (backing qdisc being deleted, or chain being flushed, etc=
.). To ensure
>> > > > > that filters remain attached beyond process lifetime, the usual =
bpf_link fd
>> > > > > pinning approach can be used.
>> > > > >
>> > > > > The individual patches contain more details and comments, but th=
e overall kernel
>> > > > > API and libbpf helper mirrors the semantics of the netlink based=
 TC-BPF API
>> > > > > merged recently. This means that we start by always setting dire=
ct action mode,
>> > > > > protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need=
 for more
>> > > > > options in the future, they can be easily exposed through the bp=
f_link API in
>> > > > > the future.
>> > > > >
>> > > > > Patch 1 refactors cls_bpf change function to extract two helpers=
 that will be
>> > > > > reused in bpf_link creation.
>> > > > >
>> > > > > Patch 2 exports some bpf_link management functions to modules. T=
his is needed
>> > > > > because our bpf_link object is tied to the cls_bpf_prog object. =
Tying it to
>> > > > > tcf_proto would be weird, because the update path has to replace=
 offloaded bpf
>> > > > > prog, which happens using internal cls_bpf helpers, and would in=
 general be more
>> > > > > code to abstract over an operation that is unlikely to be implem=
ented for other
>> > > > > filter types.
>> > > > >
>> > > > > Patch 3 adds the main bpf_link API. A function in cls_api takes =
care of
>> > > > > obtaining block reference, creating the filter object, and then =
calls the
>> > > > > bpf_link_change tcf_proto op (only supported by cls_bpf) that re=
turns a fd after
>> > > > > setting up the internal structures. An optimization is made to n=
ot keep around
>> > > > > resources for extended actions, which is explained in a code com=
ment as it wasn't
>> > > > > immediately obvious.
>> > > > >
>> > > > > Patch 4 adds an update path for bpf_link. Since bpf_link_update =
only supports
>> > > > > replacing the bpf_prog, we can skip tc filter's change path by r=
eusing the
>> > > > > filter object but swapping its bpf_prog. This takes care of repl=
acing the
>> > > > > offloaded prog as well (if that fails, update is aborted). So fa=
r however,
>> > > > > tcf_classify could do normal load (possibly torn) as the cls_bpf=
_prog->filter
>> > > > > would never be modified concurrently. This is no longer true, an=
d to not
>> > > > > penalize the classify hot path, we also cannot impose serializat=
ion around
>> > > > > its load. Hence the load is changed to READ_ONCE, so that the po=
inter value is
>> > > > > always consistent. Due to invocation in a RCU critical section, =
the lifetime of
>> > > > > the prog is guaranteed for the duration of the call.
>> > > > >
>> > > > > Patch 5, 6 take care of updating the userspace bits and add a bp=
f_link returning
>> > > > > function to libbpf.
>> > > > >
>> > > > > Patch 7 adds a selftest that exercises all possible problematic =
interactions
>> > > > > that I could think of.
>> > > > >
>> > > > > Design:
>> > > > >
>> > > > > This is where in the object hierarchy our bpf_link object is att=
ached.
>> > > > >
>> > > > >                                                                 =
            =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>> > > > >                                                                 =
            =E2=94=82     =E2=94=82
>> > > > >                                                                 =
            =E2=94=82 BPF =E2=94=82
>> > > > >                                                                 =
            program
>> > > > >                                                                 =
            =E2=94=82     =E2=94=82
>> > > > >                                                                 =
            =E2=94=94=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=98
>> > > > >                                                       =E2=94=8C=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90   =
             =E2=94=82
>> > > > >                                                       =E2=94=82 =
      =E2=94=82         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90
>> > > > >                                                       =E2=94=82 =
 mod  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=96=BA cls_bpf_prog =E2=94=82
>> > > > > =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=90                                    =E2=94=82cls_bp=
f=E2=94=82         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=
=E2=94=80=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98
>> > > > > =E2=94=82    tcf_block   =E2=94=82                              =
      =E2=94=82       =E2=94=82              =E2=94=82   =E2=94=82
>> > > > > =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=98                                    =E2=94=94=E2=94=
=80=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=98         =
     =E2=94=82   =E2=94=82
>> > > > >          =E2=94=82          =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=90                       =E2=94=82                =E2=
=94=8C=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=90
>> > > > >          =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_chain  =E2=94=
=82                       =E2=94=82                =E2=94=82bpf_link=E2=94=
=82
>> > > > >                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98                       =E2=94=82                =E2=94=94=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98
>> > > > >                             =E2=94=82          =E2=94=8C=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82
>> > > > >                             =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  t=
cf_proto  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>> > > > >                                        =E2=94=94=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>> > > > >
>> > > > > The bpf_link is detached on destruction of the cls_bpf_prog.  Do=
ing it this way
>> > > > > allows us to implement update in a lightweight manner without ha=
ving to recreate
>> > > > > a new filter, where we can just replace the BPF prog attached to=
 cls_bpf_prog.
>> > > > >
>> > > > > The other way to do it would be to link the bpf_link to tcf_prot=
o, there are
>> > > > > numerous downsides to this:
>> > > > >
>> > > > > 1. All filters have to embed the pointer even though they won't =
be using it when
>> > > > > cls_bpf is compiled in.
>> > > > > 2. This probably won't make sense to be extended to other filter=
 types anyway.
>> > > > > 3. We aren't able to optimize the update case without adding ano=
ther bpf_link
>> > > > > specific update operation to tcf_proto ops.
>> > > > >
>> > > > > The downside with tying this to the module is having to export b=
pf_link
>> > > > > management functions and introducing a tcf_proto op. Hopefully t=
he cost of
>> > > > > another operation func pointer is not big enough (as there is on=
ly one ops
>> > > > > struct per module).
>> > > > >
>> > > > Hi Kumar,
>> > > >
>> > > > Do you have any plans / bandwidth to land this feature upstream? If
>> > > > so, do you have a tentative estimation for when you'll be able to =
work
>> > > > on this? And if not, are you okay with someone else working on thi=
s to
>> > > > get it merged in?
>> > > >
>> > >
>> > > I can have a look at resurrecting it later this month, if you're ok =
with waiting
>> > > until then, otherwise if someone else wants to pick this up before t=
hat it's
>> > > fine by me, just let me know so we avoid duplicated effort. Note tha=
t the
>> > > approach in v2 is dead/unlikely to get accepted by the TC maintainer=
s, so we'd
>> > > have to implement the way Daniel mentioned in [0].
>> >
>> > Sounds great! We'll wait and check back in with you later this month.
>> >
>> After reading the linked thread (which I should have done before
>> submitting my previous reply :)),  if I'm understanding it correctly,
>> it seems then that the work needed for tc bpf_link will be in a new
>> direction that's not based on the code in this v2 patchset. I'm
>> interested in learning more about bpf link and tc - I can pick this up
>> to work on. But if this was something you wanted to work on though,
>> please don't hesitate to let me know; I can find some other bpf link
>> thing to work on instead if that's the case.
>>
>
> Feel free to take it. And yes, it's going to be much simpler than this. I=
 think
> you can just add two bpf_prog pointers in struct net_device, use rtnl_loc=
k to
> protect the updates, and invoke using bpf_prog_run in sch_handle_ingress =
and
> sch_handle_egress.

Except we'd want to also support multiple programs on different
priorities? I don't think requiring a libxdp-like dispatcher to achieve
this is a good idea if we can just have it be part of the API from the
get-go...

-Toke

