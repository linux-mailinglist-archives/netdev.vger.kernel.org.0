Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B743E3A99E1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhFPMGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:06:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232821AbhFPMGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623845044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pBL/cWZLjH7AvvpeVIeZW3LuRVTP6jy3YXY7ILAJQ3Q=;
        b=ih0aMgdoUWzlB3mSgrDwcGBJuTEae8r5zL3lTxYSopKhgpg600jDSMsQ9aH0wvuKlgVSq/
        lLromLTUs/siU/VPGratTy4oYPZZn3KLuoWm/FTwWi0UfkJqbLxdLGCDhrbfaZ1aXSFwTW
        ySHAVyfzGo4+i41xF7VcZ9bJpHhZyvE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-IqGtMlUBOhygEEXuNnjErw-1; Wed, 16 Jun 2021 08:04:00 -0400
X-MC-Unique: IqGtMlUBOhygEEXuNnjErw-1
Received: by mail-ej1-f70.google.com with SMTP id mh17-20020a170906eb91b0290477da799023so163512ejb.1
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 05:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pBL/cWZLjH7AvvpeVIeZW3LuRVTP6jy3YXY7ILAJQ3Q=;
        b=hzZxrMm2J5/hYqgo895ZKZ1Uo5ucvhOsBRbVBAi/gjbqJiPvkrGUin5XnzCAwkHMEy
         bZFIfMZb8iTcMFkSq/IDjOh0fektEaf0Pa2Rt+EnjoRcBLe7WS4MqLT5hAarTMFxEmVe
         ClZEEMi3WVfD8jOffDdXeii5mmDgpKg+JTkbhwt0TnP/JFQd0xefstcJ2ko/r+qvQBQx
         WuhN1Bm9k7k8tQwIX1OVuLhIvpxYK36jFd36CjDj33yAtyCzx52I22bf0FoEhNWASKx3
         PDZOViu5yXj9lilpCnvdDGF1JIbzoR05OhyYV9pyVflGbmRpZnchfpR6bwExo2iTm1Wc
         FLPw==
X-Gm-Message-State: AOAM532I68ctpB1DzSFgR4KuYT5gjDnbGD2S6Xn43SbZm7+s8MlYNtqh
        OK/tZOP4BgHNuvQONUXxi0SaQ+hEqYfaKNVS91UF/29uJGn4YDKeTlSrsAOxLFKUbBgbe2iIWRi
        Pul2yiVuvyC/H7yUd
X-Received: by 2002:aa7:c7cd:: with SMTP id o13mr3723524eds.269.1623845039555;
        Wed, 16 Jun 2021 05:03:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1fCsxeMQFLiuXlDkhshkO5c8JQbYXu6dp+IeYZNq+FBqnplEU62m2iAFyL8pPxX7VHJ70kA==
X-Received: by 2002:aa7:c7cd:: with SMTP id o13mr3723486eds.269.1623845039352;
        Wed, 16 Jun 2021 05:03:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id df20sm1058528edb.76.2021.06.16.05.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 05:03:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E58641802C0; Wed, 16 Jun 2021 14:03:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
In-Reply-To: <15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <CAM_iQpW7ZAz5rLAanMRg7R52Pn55N=puVkvoHcHF618wq8uA1g@mail.gmail.com>
 <877divs5py.fsf@toke.dk>
 <15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Jun 2021 14:03:56 +0200
Message-ID: <87a6nqqamr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 6/15/21 1:54 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
> [...]
>>>>> I offer two different views here:
>>>>>
>>>>> 1. If you view a TC filter as an instance as a netdev/qdisc/action, t=
hey
>>>>> are no different from this perspective. Maybe the fact that a TC filt=
er
>>>>> resides in a qdisc makes a slight difference here, but like I mention=
ed, it
>>>>> actually makes sense to let TC filters be standalone, qdisc's just ha=
ve to
>>>>> bind with them, like how we bind TC filters with standalone TC action=
s.
>>>>
>>>> You propose something different below IIUC, but I explained why I'm wa=
ry of
>>>> these unbound filters. They seem to add a step to classifier setup for=
 no real
>>>> benefit to the user (except keeping track of one more object and clean=
ing it
>>>> up with the link when done).
>>>
>>> I am not even sure if unbound filters help your case at all, making
>>> them unbound merely changes their residence, not ownership.
>>> You are trying to pass the ownership from TC to bpf_link, which
>>> is what I am against.
>>=20
>> So what do you propose instead?
>>=20
>> bpf_link is solving a specific problem: ensuring automatic cleanup of
>> kernel resources held by a userspace application with a BPF component.
>> Not all applications work this way, but for the ones that do it's very
>> useful. But if the TC filter stays around after bpf_link detaches, that
>> kinda defeats the point of the automatic cleanup.
>>=20
>> So I don't really see any way around transferring ownership somehow.
>> Unless you have some other idea that I'm missing?
>
> Just to keep on brainstorming here, I wanted to bring back Alexei's earli=
er quote:
>
>    > I think it makes sense to create these objects as part of establishi=
ng bpf_link.
>    > ingress qdisc is a fake qdisc anyway.
>    > If we could go back in time I would argue that its existence doesn't
>    > need to be shown in iproute2. It's an object that serves no purpose
>    > other than attaching filters to it. It doesn't do any queuing unlike
>    > real qdiscs.
>    > It's an artifact of old choices. Old doesn't mean good.
>    > The kernel is full of such quirks and oddities. New api-s shouldn't
>    > blindly follow them.
>    > tc qdisc add dev eth0 clsact
>    > is a useless command with nop effect.
>
> The whole bpf_link in this context feels somewhat awkward because both ar=
e two
> different worlds, one accessible via netlink with its own lifetime etc, t=
he other
> one tied to fds and bpf syscall. Back in the days we did the cls_bpf inte=
gration
> since it felt the most natural at that time and it had support for both t=
he ingress
> and egress side, along with the direct action support which was added lat=
er to have
> a proper fast path for BPF. One thing that I personally never liked is th=
at later
> on tc sadly became a complex, quirky dumping ground for all the nic hw of=
floads (I
> guess mainly driven from ovs side) for which I have a hard time convincin=
g myself
> that this is used at scale in production. Stuff like af699626ee26 just to=
 pick one
> which annoyingly also adds to the fast path given distros will just compi=
le in most
> of these things (like NET_TC_SKB_EXT)... what if such bpf_link object is =
not tied
> at all to cls_bpf or cls_act qdisc, and instead would implement the tcf_c=
lassify_
> {egress,ingress}() as-is in that sense, similar like the bpf_lsm hooks. M=
eaning,
> you could run existing tc BPF prog without any modifications and without =
additional
> extra overhead (no need to walk the clsact qdisc and then again into the =
cls_bpf
> one). These tc BPF programs would be managed only from bpf() via tc bpf_l=
ink api,
> and are otherwise not bothering to classic tc command (though they could =
be dumped
> there as well for sake of visibility, though bpftool would be fitting too=
). However,
> if there is something attached from classic tc side, it would also go int=
o the old
> style tcf_classify_ingress() implementation and walk whatever is there so=
 that nothing
> existing breaks (same as when no bpf_link would be present so that there =
is no extra
> overhead). This would also allow for a migration path of multi prog from =
cls_bpf to
> this new implementation. Details still tbd, but I would much rather like =
such an
> approach than the current discussed one, and it would also fit better giv=
en we don't
> run into this current mismatch of both worlds.

So this would entail adding a separate list of BPF programs and run
through those at the start of sch_handle_{egress,ingress}() I suppose?
And that list of filters would only contain bpf_link-attached BPF
programs, sorted by priority like TC filters? And return codes of
TC_ACT_OK or TC_ACT_RECLASSIFY would continue through to
tcf_classify_{egress,ingress}()?

I suppose that could work; we could even stick the second filter list in
struct mini_Qdisc and have clsact and bpf_link cooperate on managing
that, no? That way it would also be easy to dump the BPF filters via
netlink: I do think that will be the least surprising thing to do (so
people can at least see there's something there with existing tools).

The overhead would be a single extra branch when only one of clsact or
bpf_link is in use (to check if the other list of filters is set);
that's probably acceptable at this level...

-Toke

