Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E293545F3
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhDERV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbhDERV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:21:27 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A69C061788;
        Mon,  5 Apr 2021 10:21:21 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id e188so2196582ybb.13;
        Mon, 05 Apr 2021 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D1j4GTXgVcvQqtBZ11yQ00wW6q8PqAarV4AdOOYag4E=;
        b=fWNKlN4tH6BXb9nVGV9wlyjRl14zawifzMAmEc5tKEwxuEC2xq7nCLEr+ARfpa+nic
         pJ+znioEvWbDv1kCcjA5/9zu+qLXwjfMkVEp5rKfVL2G4allvfl+nsPiI9GrsSaUGTeN
         Qaz17QiB+xDnuwccQhcOalblW6jmE50dKTg1hnMG2iCXhdRcFcxmtea9yhbcihdiPUIj
         baaRgmNrmjqJm+26o8UkLVyT0e+O3wttZMBejANMaNIWEbP4cY8AR5Z0t0Cya74lskts
         EaLtxn/PFGKHTxFKKi11bRKhgEJyF0CNrNY48JC8GJT9/2GOGlL40WFfdQCOHYmAKvQl
         ucLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1j4GTXgVcvQqtBZ11yQ00wW6q8PqAarV4AdOOYag4E=;
        b=IvNaASRKJxQZMFbaganeC8MPYF+/U7VxGQtragazSL9CUuwWyiYRbuvh5A+wFiYIYj
         V6apsYCkLbCfgD4BSvHY7mHbJPiYnCQkO30CyV2OSFgVblrCPked4tst5OJnx0w151aB
         phUl+KHlMpHbJ8gpHOcrMQLzh0gXF5NV3AQrhi5xX149EPz2yWVVNNougHiIW83pAxXk
         alOXXi7ww5PectxBtu9EedJ8GHoD81/BtLBjp7xgHzUMEOuducZwrGVo9pcmSWumzlu9
         nBoewOvBlbtbPMvVnxjoRYVsiA8P/dJF9gCS/8EifDr6hXGehfXxN0L3m4inKDUMNkRm
         tbvA==
X-Gm-Message-State: AOAM5324dC4STOZ6ymB2qi0qWx15dNe+HhgEfcDIsbVPY86h3pQns8R+
        PX7e8/gNXH5tU/Q4QBWSh/Lxydv73u1Dy1LaoOc=
X-Google-Smtp-Source: ABdhPJzi2Po5MbZ2DhUoKELA7Awk1h+3mM+hjwGAXeW6+e80CKnIfPYVIeXIHz9NGrmETcUQCKjeBLwXtKfJ98rlLoQ=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr37329185ybf.425.1617643280740;
 Mon, 05 Apr 2021 10:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
In-Reply-To: <20210402152743.dbadpgcmrgjt4eca@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Apr 2021 10:21:09 -0700
Message-ID: <CAEf4Bzbk9t9Cx4DONzNu8reP+Fkdq8WA90syqesgQYgAQyCaLw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Fri, Apr 02, 2021 at 05:49:29AM IST, Daniel Borkmann wrote:
> > On 3/31/21 11:44 AM, Kumar Kartikeya Dwivedi wrote:
> > > On Wed, Mar 31, 2021 at 02:55:47AM IST, Daniel Borkmann wrote:
> > > > Do we even need the _block variant? I would rather prefer to take the chance
> > > > and make it as simple as possible, and only iff really needed extend with
> > > > other APIs, for example:
> > >
> > > The block variant can be dropped, I'll use the TC_BLOCK/TC_DEV alternative which
> > > sets parent_id/ifindex properly.
> > >
> > > >    bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS});
> > > >
> > > > Internally, this will create the sch_clsact qdisc & cls_bpf filter instance
> > > > iff not present yet, and attach to a default prio 1 handle 1, and _always_ in
> > > > direct-action mode. This is /as simple as it gets/ and we don't need to bother
> > > > users with more complex tc/cls_bpf internals unless desired. For example,
> > > > extended APIs could add prio/parent so that multi-prog can be attached to a
> > > > single cls_bpf instance, but even that could be a second step, imho.
> > >
> > > I am not opposed to clsact qdisc setup if INGRESS/EGRESS is supplied (not sure
> > > how others feel about it).
> >
> > What speaks against it? It would be 100% clear from API side where the prog is
> > being attached. Same as with tc cmdline where you specify 'ingress'/'egress'.
> >
>
> Ok, I will add the qdisc setup in the next revision.
>
> > > We could make direct_action mode default, and similarly choose prio
> >
> > To be honest, I wouldn't even support a mode from the lib/API side where direct_action
> > is not set. It should always be forced to true. Everything else is rather broken
> > setup-wise, imho, since it won't scale. We added direct_action a bit later to the
> > kernel than original cls_bpf, but if I would do it again today, I'd make it the
> > only available option. I don't see a reasonable use-case where you have it to false.
> >
>
> I'm all for doing that, but in some sense that also speaks against SCHED_ACT
> support. Currently, you can load SCHED_ACT programs using this series, but not
> really bind them to classifier. I left that option open to a future patch, it
> would just reuse the existing tc_act_add_action helper (also why I kept it in
> its own function). Maybe we need to reconsider that, if direct action is the
> only recommended way going forward (to discourage people from using SCHED_ACT),
> or just add opts to do all the setup in low level API, instead of leaving it
> incomplete.
>
> > > as 1 by default instead of letting the kernel do it. Then you can just pass in
> > > NULL for bpf_tc_cls_opts and be close to what you're proposing. For protocol we
> > > can choose ETH_P_ALL by default too if the user doesn't set it.
> >
> > Same here with ETH_P_ALL, I'm not sure anyone uses anything other than ETH_P_ALL,
> > so yes, that should be default.
>
> Ack.
>
> >
> > > With these modifications, the equivalent would look like
> > >     bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, INGRESS), NULL, &id);
> >
> > Few things compared to bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> >
> > 1) nit, but why even 'cls' in the name. I think we shouldn't expose such old-days
> >    tc semantics to a user. Just bpf_tc_attach() is cleaner/simpler to understand.
>
> Since it would make it clear this is for SCHED_CLS progs, likewise bpf_tc_act_*
> is for SCHED_ACT progs. Not opposed to changing the name.
>
> > 2) What's the 'TC_DEV(ifindex, INGRESS)' macro doing exactly? Looks unnecessary,
> >    why not regular args to the API?
>
> It is very easy to support BLOCK (I know it's not really popular here, but I
> think if supporting it just requires adding a macro, then we can go ahead). So
> the user can use TC_BLOCK(block_idx) instead of remembering ifindex is to be set
> to TCM_IFINDEX_MAGIC_BLOCK and parent_id to actual block index. It will just
> expand to:
>
> #define TC_BLOCK(block_idx) TCM_IFINDEX_MAGIC_BLOCK, (block_idx)
>
> TC_DEV macro can be dropped, since user can directly pass ifindex and parent_id.

if _block variant is just a special ifindex value, then it should be
fine for users to know such a detail (we can leave a comment
mentioning this specifically), especially given it's not a very
popular thing. Almost doubling amount of APIs just for this doesn't
make much sense, IMO.

>
> > 3) Exposed bpf_tc_attach() API could internally call a bpf_tc_attach_opts() API
> >    with preset defaults, and the latter could have all the custom bits if the user
> >    needs to go beyond the simple API, so from your bpf_tc_cls_attach() I'd also
> >    drop the NULL.
>
> Ok, this is probably better (but maybe we can do this for the high-level
> bpf_program__attach that returns a bpf_link * instead of introducing yet
> another function).


If we know that we need variant with options, I'd vote for having just
one bpf_tc_attach() API which always takes options. Passing NULL for
opts is simple, no need for two APIs, I think.

>
> > 4) For the simple API I'd likely also drop the id (you could have a query API if
> >    needed).
> >
>
> This would be fine, because it's not a fast path or anything, but right now we
> return the id using the netlink response, otherwise for query we have to open
> the socket, prepare the msg, send and recv again. So it's a minor optimization.
>
> However, there's one other problem. In an earlier version of this series, I
> didn't keep the id/index out parameters (to act as handle to the newly attached
> filter/action). This lead to problems on query. Suppose a user doesn't properly
> fill the opts during query (e.g. in case of filters). This means the netlink
> dump includes all filters matching filled in attributes. If the prog_id for all
> of these is same (e.g. all have same bpf classifier prog attached to them), it
> becomes impossible to determine which one is the filter user asked for. It is
> not possible to enforce filling in all kinds of attributes since some can be
> left out and assigned by default in the kernel (priority, chain_index etc.). So
> returning the newly created filter's id turned out to be the best option. This
> is also used to stash filter related information in bpf_link to properly release
> it later.
>
> The same problem happens with actions, where we look up using the prog_id, we
> multiple actions with different index can match on same prog_id. It is not
> possible to determine which index corresponds to last loaded action.
>
> So unless there's a better idea on how to deal with this, a query API won't work
> for the case where same bpf prog is attached more than once. Returning the
> id/index during attach seemed better than all other options we considered.

Which parts of that id struct is the data that caller might not know
or can't know? Is it handle and chain_index? Or just one of them?
Or?... If there is something that has to be returned back, I'd keep
only that, instead of returning 6+ fields, most of which user should
already know.

>
> --
> Kartikeya
