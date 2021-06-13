Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6CE3A5611
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 04:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhFMC53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 22:57:29 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40604 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFMC52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 22:57:28 -0400
Received: by mail-pj1-f66.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso8038581pjb.5;
        Sat, 12 Jun 2021 19:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZG20iOccyJA2Tjd2b0pbr2sG0HFtYwH87KiODNSXn+M=;
        b=RUnt6qwNbghDXyPsmS/bDYILZ6WuCjDIvJl1M0wF4HMga3H1aCyBwBWUOpvEYoXAaj
         RDlurVRh0lPOVM1nNTaEM5lrPBzUqBV9PVIvUhig7psguZitXwENWBtU34Q+N46gZEPI
         Vmp9JRVpprO9OA1dGRazopULsucFZUZPIPC+KZOfkQ2wmlgAgYSRFYC7YK8f8sD/gim0
         +u1eJJLFejcLFuQUBslmEn4XLdlolEw5wCmZzVJQYB8ZRmFeP2AYGA59tBzkSukU5FV1
         xWHckiNSrPMrX3LcJkNs36cFnBwF/vidlXlxmcb7jP6r0wowReDY/HEdFjI3O6tzM0vw
         ibKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZG20iOccyJA2Tjd2b0pbr2sG0HFtYwH87KiODNSXn+M=;
        b=LUMuRIfuls/TMUGwHKmu8VScS4fGO9XvgRRtHVprwLTHvBiE5OhrxEi/yUScY+7yfd
         BFZH87bW7QvNiLO7uR0zv7OCGyCZOoCZlWUN1rxYY5cVOxkhE2uwBw/V7ZtznXktge0y
         ujQbHAikKclp6DTxcp9jQ5Iob5Ko55Fk5IN0oS7mYB97hygRAmA5qUM25GDOk6H+Us+D
         Rns726Imlth5oAiGAfnkcjYJc1mSjAPWIZY4POMykxZJRInxdX+l6MGbxafV7R2Atd33
         wrWxtyN4O1jsrPGIRaK8jic1kCVqfGyKxxsgSi2rxVRm96SnW+v0qFU/mmNqf58pkWhN
         1+0w==
X-Gm-Message-State: AOAM532SsCaOOCt0CZcOG4JEMjcyL14R8PBULBiXJraQsWF1B0KWwVNi
        95csv77uMFSjrPiwHNbOhB4=
X-Google-Smtp-Source: ABdhPJyklnfOcyHa76tRnl1oFIbTsVl6Pvltxsq1x7m0A/e9NMr2j5qsKmoqL+DH4NvENwne0S/WxA==
X-Received: by 2002:a17:903:182:b029:112:b62f:8852 with SMTP id z2-20020a1709030182b0290112b62f8852mr10866408plg.4.1623552868354;
        Sat, 12 Jun 2021 19:54:28 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id gk21sm13107019pjb.20.2021.06.12.19.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 19:54:28 -0700 (PDT)
Date:   Sun, 13 Jun 2021 08:23:08 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
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
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210613025308.75uia7rnt4ue2k7q@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 07:30:49AM IST, Cong Wang wrote:
> On Tue, Jun 8, 2021 at 12:20 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > So we're not really creating a qdisc here, we're just tying the filter (which in
> > the current semantics exists only while attached) to the bpf_link. The filter is
> > the attachment, so tying its lifetime to bpf_link makes sense. When you destroy
> > the bpf_link, the filter goes away too, which means classification at that
> > hook (parent/class) in the qdisc stops working. This is why creating the filter
> > from the bpf_link made sense to me.
>
> I see why you are creating TC filters now, because you are trying to
> force the lifetime of a bpf target to align with the bpf program itself.
> The deeper reason seems to be that a cls_bpf filter looks so small
> that it appears to you that it has nothing but a bpf_prog, right?
>

Yes, pretty much.

> I offer two different views here:
>
> 1. If you view a TC filter as an instance as a netdev/qdisc/action, they
> are no different from this perspective. Maybe the fact that a TC filter
> resides in a qdisc makes a slight difference here, but like I mentioned, it
> actually makes sense to let TC filters be standalone, qdisc's just have to
> bind with them, like how we bind TC filters with standalone TC actions.

You propose something different below IIUC, but I explained why I'm wary of
these unbound filters. They seem to add a step to classifier setup for no real
benefit to the user (except keeping track of one more object and cleaning it
up with the link when done).

I understand that the filter is very much an object of its own and why keeping
them unbound makes sense, but for the user there is no real benefit of this
scheme (some things like classid attribute are contextual in that they make
sense to be set based on what parent we're attaching to).

> These are all updated independently, despite some of them residing in
> another. There should not be an exceptional TC filter which can not
> be updated via `tc filter` command.

I see, but I'm mirroring what was done for XDP bpf_link.

Besides, flush still works, it's only that manipulating a filter managed by
bpf_link is not allowed, which sounds reasonable to me, given we're bringing
new ownership semantics here which didn't exist before with netlink, so it
doesn't make sense to allow netlink to simply invalidate the filter installed by
some other program.

You wouldn't do something like that for a cooperating setup, we're just
enforcing that using -EPERM (bpf_link is not allowed to replace netlink
installed filters either, so it goes both ways).

>
> 2. For cls_bpf specifically, it is also an instance, like all other TC filters.
> You can update it in the same way: tc filter change [...] The only difference
> is a bpf program can attach to such an instance. So you can view the bpf
> program attached to cls_bpf as a property of it. From this point of view,
> there is no difference with XDP to netdev, where an XDP program
> attached to a netdev is also a property of netdev. A netdev can still
> function without XDP. Same for cls_bpf, it can be just a nop returns
> TC_ACT_SHOT (or whatever) if no ppf program is attached. Thus,
> the lifetime of a bpf program can be separated from the target it
> attaches too, like all other bpf_link targets. bpf_link is just a
> supplement to `tc filter change cls_bpf`, not to replace it.
>

So this is different now, as in the filter is attached as usual but bpf_link
represents attachment of bpf prog to the filter itself, not the filter to the
qdisc.

To me it seems apart from not having to create filter, this would pretty much be
equivalent to where I hook the bpf_link right now?

TBF, this split doesn't really seem to be bringing anything to the table (except
maybe preserving netlink as the only way to manipulate filter properties) and
keeping filters as separate objects. I can understand your position but for the
user it's just more and more objects to keep track of with no proper
ownership/cleanup semantics.

Though considering it for cls_bpf in particular, there are mainly three things
you would want to tc filter change:

* Integrated actions
  These are not allowed anyway, we force enable direct action mode, and I don't
  plan on opening up actions for this if its gets accepted. Anything missing
  we'll try to make it work in eBPF (act_ct etc.)

* classid
  cls_bpf has a good alternative of instead manipulating __sk_buff::tc_classid

* skip_hw/skip_sw
  Not supported for now, but can be done using flags in BPF_LINK_UPDATE

* BPF program
  Already works using BPF_LINK_UPDATE

So bpf_link isn't really prohibitive in any way.

Doing it your way also complicates cleanup of the filter (in case we don't want
to leave it attached), because it is hard to know who closes the link_fd last.
Closing it earlier would break the link for existing users, not doing it would
leave around unused object (which can accumulate if we use auto allocation of
filter priority). Counting existing links is racy.

This is better done in the kernel than worked around in userspace, as part of
attachment.

> This is actually simpler, you do not need to worry about whether
> netdev is destroyed when you detach the XDP bpf_link anyway,
> same for cls_bpf filters. Likewise, TC filters don't need to worry
> about bpf_links associated.
>
> Thanks.

--
Kartikeya
