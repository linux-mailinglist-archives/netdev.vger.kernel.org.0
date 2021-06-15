Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADADD3A75F5
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhFOEgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOEgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 00:36:12 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D50C061574;
        Mon, 14 Jun 2021 21:34:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e33so5687211pgm.3;
        Mon, 14 Jun 2021 21:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s933K64sEJN12PqWwPxXkmuVnjl6Ur+lvZ1v303M6KI=;
        b=ZJf1gNYGzhu8KoUdLW98k3CfUF0VsLTGm0/3OnhvWP1hPOYvGHhd+FfZMiPRhWo3Qk
         X7nJXngCm4QcLYOqVmeQJZ77FP8ZOBUdkFPUMcyHCf68Q6jbQboEXmNxIS/uqmUyTew6
         Rq6Q7v/SGeUvmUVqOHbgnP6Y0MTolq/sZM2rKbeG/TR5Rhc+KojipzmY/24CI3Kx31NI
         76xZrHMGhaGJTRuFUsg6d3gccTvmiczAndciT+AJ82S7Dno6MAZj9ktL/rnRWv3Lvt/D
         /6CK9Id7n070dtAdu9LQiSjTvq+00iyTCYTsdXbUgrj4Q5aUFjfmC73a1bW7GVIe6QMK
         uS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s933K64sEJN12PqWwPxXkmuVnjl6Ur+lvZ1v303M6KI=;
        b=E5NvKtFhrlGmi9GxVvJLozdNozjIXiamDTZ6NiT60zRw0IoyW2AKpJ8uxXkTMlrn+D
         Pw3p5TguG3v1maAC+9OHziKt8291c7EIP8yLlhnekzamz12GP/xQnSGsShrbPsqlv9JE
         rWICsQi9tsG9hB0PohItFcY7F1sGOFB/Yk60n48V52n+RCXuvMT8uzM8wjDQBIfNvtvR
         7YATE12yYDRQoZW2qlLqJRqFApGOh37TYYqhTdEH/ws3FL8+01Wg4buwDNcMH959DiDv
         p1jJGA+37sSy3yvIBjdGXI+Q6QznIbJS4ov5J4kBg/0Z4dbzK69f79CSDpg2UHaTiNhO
         D8pA==
X-Gm-Message-State: AOAM530xG6j14bqx3ey8OuwOpLGOWQmdjUXBIxbwwQeUdQymA4pUfdgq
        T8GfeDPM71TUp6hL9ilPIAKYa98Ddb68OIRygqI=
X-Google-Smtp-Source: ABdhPJy/RRlTJM7+LkXcUb/IKczq5S5/FiTr+q/inxV4mbNNRdJzVFRE8wbaMBrSrViQpyoSMRBMAPnA6KZERce9twY=
X-Received: by 2002:aa7:9507:0:b029:2df:b6dc:c68c with SMTP id
 b7-20020aa795070000b02902dfb6dcc68cmr2539871pfp.31.1623731647676; Mon, 14 Jun
 2021 21:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo> <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo> <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo> <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
In-Reply-To: <20210613025308.75uia7rnt4ue2k7q@apollo>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Jun 2021 21:33:56 -0700
Message-ID: <CAM_iQpW7ZAz5rLAanMRg7R52Pn55N=puVkvoHcHF618wq8uA1g@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 7:54 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Jun 11, 2021 at 07:30:49AM IST, Cong Wang wrote:
> > On Tue, Jun 8, 2021 at 12:20 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > So we're not really creating a qdisc here, we're just tying the filter (which in
> > > the current semantics exists only while attached) to the bpf_link. The filter is
> > > the attachment, so tying its lifetime to bpf_link makes sense. When you destroy
> > > the bpf_link, the filter goes away too, which means classification at that
> > > hook (parent/class) in the qdisc stops working. This is why creating the filter
> > > from the bpf_link made sense to me.
> >
> > I see why you are creating TC filters now, because you are trying to
> > force the lifetime of a bpf target to align with the bpf program itself.
> > The deeper reason seems to be that a cls_bpf filter looks so small
> > that it appears to you that it has nothing but a bpf_prog, right?
> >
>
> Yes, pretty much.

OK. Just in case of any misunderstand: cls_bpf filter has more than
just a bpf prog, it inherits all other generic attributes, e.g. TC proto/prio,
too from TC infra. If you can agree on this, then it is no different from
netdev/cgroup/netns bpf_links.

>
> > I offer two different views here:
> >
> > 1. If you view a TC filter as an instance as a netdev/qdisc/action, they
> > are no different from this perspective. Maybe the fact that a TC filter
> > resides in a qdisc makes a slight difference here, but like I mentioned, it
> > actually makes sense to let TC filters be standalone, qdisc's just have to
> > bind with them, like how we bind TC filters with standalone TC actions.
>
> You propose something different below IIUC, but I explained why I'm wary of
> these unbound filters. They seem to add a step to classifier setup for no real
> benefit to the user (except keeping track of one more object and cleaning it
> up with the link when done).

I am not even sure if unbound filters help your case at all, making
them unbound merely changes their residence, not ownership.
You are trying to pass the ownership from TC to bpf_link, which
is what I am against.

>
> I understand that the filter is very much an object of its own and why keeping
> them unbound makes sense, but for the user there is no real benefit of this
> scheme (some things like classid attribute are contextual in that they make
> sense to be set based on what parent we're attaching to).
>
> > These are all updated independently, despite some of them residing in
> > another. There should not be an exceptional TC filter which can not
> > be updated via `tc filter` command.
>
> I see, but I'm mirroring what was done for XDP bpf_link.

Really? Does XDP bpf_link create a netdev or remove it? I see none.
It merely looks up netdev by attr->link_create.target_ifindex in
bpf_xdp_link_attach(). Where does the "mirroring" come from?

>
> Besides, flush still works, it's only that manipulating a filter managed by
> bpf_link is not allowed, which sounds reasonable to me, given we're bringing
> new ownership semantics here which didn't exist before with netlink, so it
> doesn't make sense to allow netlink to simply invalidate the filter installed by
> some other program.
>
> You wouldn't do something like that for a cooperating setup, we're just
> enforcing that using -EPERM (bpf_link is not allowed to replace netlink
> installed filters either, so it goes both ways).

I think our argument is never who manages it, our argument is who owns
it. By creating a TC filter from bpf_link and managed by bpf_link exclusively,
the ownership pretty much goes to bpf_link.

>
> >
> > 2. For cls_bpf specifically, it is also an instance, like all other TC filters.
> > You can update it in the same way: tc filter change [...] The only difference
> > is a bpf program can attach to such an instance. So you can view the bpf
> > program attached to cls_bpf as a property of it. From this point of view,
> > there is no difference with XDP to netdev, where an XDP program
> > attached to a netdev is also a property of netdev. A netdev can still
> > function without XDP. Same for cls_bpf, it can be just a nop returns
> > TC_ACT_SHOT (or whatever) if no ppf program is attached. Thus,
> > the lifetime of a bpf program can be separated from the target it
> > attaches too, like all other bpf_link targets. bpf_link is just a
> > supplement to `tc filter change cls_bpf`, not to replace it.
> >
>
> So this is different now, as in the filter is attached as usual but bpf_link
> represents attachment of bpf prog to the filter itself, not the filter to the
> qdisc.

Yes, I think this is the right view of cls_bpf. It contains more than just
a bpf prog, its generic part (struct tcf_proto) contains other attributes
of this filter inherited from TC infra. And of course, TC actions can be
inherited too (for non-DA).

>
> To me it seems apart from not having to create filter, this would pretty much be
> equivalent to where I hook the bpf_link right now?
>
> TBF, this split doesn't really seem to be bringing anything to the table (except
> maybe preserving netlink as the only way to manipulate filter properties) and
> keeping filters as separate objects. I can understand your position but for the
> user it's just more and more objects to keep track of with no proper
> ownership/cleanup semantics.
>
> Though considering it for cls_bpf in particular, there are mainly three things
> you would want to tc filter change:
>
> * Integrated actions
>   These are not allowed anyway, we force enable direct action mode, and I don't
>   plan on opening up actions for this if its gets accepted. Anything missing
>   we'll try to make it work in eBPF (act_ct etc.)
>
> * classid
>   cls_bpf has a good alternative of instead manipulating __sk_buff::tc_classid
>
> * skip_hw/skip_sw
>   Not supported for now, but can be done using flags in BPF_LINK_UPDATE
>
> * BPF program
>   Already works using BPF_LINK_UPDATE

Our argument is never which pieces of cls_bpf should be updated by TC
or bpf_link. It is always ownership. TC should own TC filters, even its name
tells so. You are trying to create TC filters with bpf_link which are not even
owned by TC. And more importantly, you are not doing the same for other
bpf_link targets, by singling out TC filters for no valid reason.

>
> So bpf_link isn't really prohibitive in any way.
>
> Doing it your way also complicates cleanup of the filter (in case we don't want
> to leave it attached), because it is hard to know who closes the link_fd last.
> Closing it earlier would break the link for existing users, not doing it would
> leave around unused object (which can accumulate if we use auto allocation of
> filter priority). Counting existing links is racy.
>
> This is better done in the kernel than worked around in userspace, as part of
> attachment.

I am not proposing anything for your case, I am only explaining why
creating TC filters exclusively via bpf_link does not make sense to me.

Thanks.
