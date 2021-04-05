Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA28354600
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhDER1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhDER1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:27:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A25C061756;
        Mon,  5 Apr 2021 10:27:39 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id j206so4620325ybj.11;
        Mon, 05 Apr 2021 10:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ilLEo82+XgkDwadzDIZ1C62u8oced/ve+4GZbG5zloU=;
        b=LPe6hya8jmph4em6lpqAtanmyMttLP7wXip5yQa9Xbdxi2aw597NciH0CbZ4n+y7SH
         oSQ6qSRjyunJDgbYWRKWhs85OgvGh+uJPwCOQc/rF3stiF+LVF4+OwLKz2NwU39dCvLG
         qxPCV7cY3XRqC2BhQqTaOutOMxe78e3HI5AdBWGcNRvUNdWOZrknui4TMbZwjKeFNTWB
         DmKcZoDh2wEH3YU3lGq+gD+ND74nKTW519IEmR75H/D1Xtf6R3pzZugX5EMgnv7W1jLE
         zVQeL6LNNAs94YveJu/9X2jQziK1O1+lMFywRPNTe4v+eZvlS6J7iprSh9yd6ryrdjjh
         nUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ilLEo82+XgkDwadzDIZ1C62u8oced/ve+4GZbG5zloU=;
        b=UfjHQHczeoDDGCkLYHwYQa9mwl2kShC0Ye6kqpm+fv9PLVRjwFq+GPeO+Uw4cdj0gA
         mTWxb78FcKza+KdsKgorbl6e2vK1q05PIUWM3UIssSFz4rrYxAY7K0m3hFi/RBzRY9kv
         6RFkGteWIaLpatnAEL26IcCmrtVj5sirqHyWOWPEbOox2mdrEpHUahvFzJQ2BRCSeChG
         8la3ETX+lLJorU6OPUPgIOC+ktCUhqS6LMzwaD5CzyVJoi2G85zbRWQKrLd3/C9cioXI
         uY4dVL4UgnUXoWU3HsvERltR/1LQK/Qic5KCvt2EGBk9E2fiZkWpcf1FdizqeIgc30wq
         NBZQ==
X-Gm-Message-State: AOAM533ObpauADYS82qqDh1ym4x/Y8Tecp8NZ+WL7FE03P9Oo6z6kfpi
        ln3tmLPrcOh5poXHBTRn1NtIzgnUckG5QMWy+SkpVk2s
X-Google-Smtp-Source: ABdhPJyBJlSM5NRrnBOBig+puflZRFT5juOWXlJXHWmKb/k64b5X4jnoJ3uyo8xLwoIxCJTtjOjm2DXU7DKuMhb3+6w=
X-Received: by 2002:a05:6902:6a3:: with SMTP id j3mr14502845ybt.403.1617643658864;
 Mon, 05 Apr 2021 10:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-4-memxor@gmail.com> <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo> <20210403174721.vg4wle327wvossgl@ast-mbp>
In-Reply-To: <20210403174721.vg4wle327wvossgl@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Apr 2021 10:27:28 -0700
Message-ID: <CAEf4Bzaeu4apgEtwS_3q1iPuURjPXMs9H43cYUtJSmjPMU5M9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
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

On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwivedi wrote:
> > On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
> > > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > > [...]
> > >
> > > All of these things are messy because of tc legacy. bpf tried to follow tc style
> > > with cls and act distinction and it didn't quite work. cls with
> > > direct-action is the only
> > > thing that became mainstream while tc style attach wasn't really addressed.
> > > There were several incidents where tc had tens of thousands of progs attached
> > > because of this attach/query/index weirdness described above.
> > > I think the only way to address this properly is to introduce bpf_link style of
> > > attaching to tc. Such bpf_link would support ingress/egress only.
> > > direction-action will be implied. There won't be any index and query
> > > will be obvious.
> >
> > Note that we already have bpf_link support working (without support for pinning
> > ofcourse) in a limited way. The ifindex, protocol, parent_id, priority, handle,
> > chain_index tuple uniquely identifies a filter, so we stash this in the bpf_link
> > and are able to operate on the exact filter during release.
>
> Except they're not unique. The library can stash them, but something else
> doing detach via iproute2 or their own netlink calls will detach the prog.
> This other app can attach to the same spot a different prog and now
> bpf_link__destroy will be detaching somebody else prog.
>
> > > So I would like to propose to take this patch set a step further from
> > > what Daniel said:
> > > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> > > and make this proposed api to return FD.
> > > To detach from tc ingress/egress just close(fd).
> >
> > You mean adding an fd-based TC API to the kernel?
>
> yes.

I'm totally for bpf_link-based TC attachment.

But I think *also* having "legacy" netlink-based APIs will allow
applications to handle older kernels in a much nicer way without extra
dependency on iproute2. We have a similar situation with kprobe, where
currently libbpf only supports "modern" fd-based attachment, but users
periodically ask questions and struggle to figure out issues on older
kernels that don't support new APIs.

So I think we'd have to support legacy TC APIs, but I agree with
Alexei and Daniel that we should keep it to the simplest and most
straightforward API of supporting direction-action attachments and
setting up qdisc transparently (if I'm getting all the terminology
right, after reading Quentin's blog post). That coincidentally should
probably match how bpf_link-based TC API will look like, so all that
can be abstracted behind a single bpf_link__attach_tc() API as well,
right? That's the plan for dealing with kprobe right now, btw. Libbpf
will detect the best available API and transparently fall back (maybe
with some warning for awareness, due to inherent downsides of legacy
APIs: no auto-cleanup being the most prominent one).

>
> > > The user processes will not conflict with each other and will not accidently
> > > detach bpf program that was attached by another user process.
> > > Such api will address the existing tc query/attach/detach race race conditions.
> >
> > Hmm, I think we do solve the race condition by returning the id. As long as you
> > don't misuse the interface and go around deleting filters arbitrarily (i.e. only
> > detach using the id), programs won't step over each other's filters. Storing the
> > id from the netlink response received during detach also eliminates any
> > ambigiuity from probing through get_info after attach. Same goes for actions,
> > and the same applies to the bpf_link returning API (which stashes id/index).
>
> There are plenty of tools and libraries out there that do attach/detach of bpf
> to tc. Everyone is not going to convert to this new libbpf api overnight.
> So 'miuse of the interface' is not a misuse. It's a reality that is going to keep
> happening unless the kernel guarantees ownership of the attachment via FD.
>
> > The only advantage of fd would be the possibility of pinning it, and extending
> > lifetime of the filter.
>
> Pinning is one of the advantages. The main selling point of FD is ownership
> of the attachment.
