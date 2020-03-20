Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2333F18D8FC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCTUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:24:58 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:40114 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgCTUY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:24:58 -0400
Received: by mail-qv1-f66.google.com with SMTP id cy12so3733583qvb.7;
        Fri, 20 Mar 2020 13:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o7SwPtKOPm+0Wb3fK59kuKPlfB1Jibqv6sRHYrNfJy8=;
        b=i3OGO2CHpzlCVWcow5sUWOkqybpNiDyLoajYtZXGM/fJPGRvhjHbF3bHUSylRThfFL
         XCbM0sjdWOlfijcUKjBEQeP3070iTrJOqpAiWf6e+py86fDDT4mLfvFn1AL8toARFr8+
         kyd9viYdQEnpQQAH/pNxBaUR9omjdUyXyAcfs7hQjrBK4f9prayt4Y+SaQlziqf/jhVw
         jkByPk8/XNoVGFIca8AWLE6wfHCH+m7oHnyufLxR9zxRnPXn86xYYrdd4VKxw3zhcje4
         VQctZQxPLllErsB6LwfO33zWuQcXss+SR25mcyApuWnmwIeMx4qkNgWFGKU1mHJLFial
         hrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o7SwPtKOPm+0Wb3fK59kuKPlfB1Jibqv6sRHYrNfJy8=;
        b=H0ydwTtg79cTIJo9qmpv37H8X5W9q9HnhjbXrxldNIhjEJ+bX+u2YkOReeNUpWdVBo
         0fULZzh1cYppgmjbm3486G03Wud1ZLbDWIdIO8Ry0aNHGy1QRb9reiU+iSFRDdu5T/qM
         yQ2GzxbJotK0/+1myI/2llrOXO8wrBkwS9xRxqWqAn1HDY5PZktr3jp96PvHiMUR02dt
         mzcWxFilQ7LNQsbbtd5H/ZWBubKJnbWhYeon8mZzjqTBFclVejWoB04Y30U5EYaXSNkm
         UpJO+o3syPoOsvq9/4NAvOvo1Hp/bc2/ckcJAM+9SDLRXsmasUR/42ZoQdNeTTGSZntJ
         52PQ==
X-Gm-Message-State: ANhLgQ2N3Jooe/FMCievhVGyy66rkdXQ+4fq+vA6QF4gzBr+uC1R7B82
        a3MDHBP4WsJE1rLqJTklYvd6bGxLswUsUcZqP8c=
X-Google-Smtp-Source: ADFU+vvWj5F/vBmx15w6yLihdRAtwuckOPzczFMWZP4IAP8pAxTf0tVUBpdnBIAK6RPrQCqFi90dXOp7vkqQm05n1PU=
X-Received: by 2002:a0c:f786:: with SMTP id s6mr10085742qvn.224.1584735896859;
 Fri, 20 Mar 2020 13:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
In-Reply-To: <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Mar 2020 13:24:45 -0700
Message-ID: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Jakub Kicinski wrote:
> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> > > Jakub Kicinski <kuba@kernel.org> writes:
> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen=
 wrote:
> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > >>
> > > >> While it is currently possible for userspace to specify that an ex=
isting
> > > >> XDP program should not be replaced when attaching to an interface,=
 there is
> > > >> no mechanism to safely replace a specific XDP program with another=
.
> > > >>
> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, whi=
ch can be
> > > >> set along with IFLA_XDP_FD. If set, the kernel will check that the=
 program
> > > >> currently loaded on the interface matches the expected one, and fa=
il the
> > > >> operation if it does not. This corresponds to a 'cmpxchg' memory o=
peration.
> > > >>
> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explic=
itly
> > > >> request checking of the EXPECTED_FD attribute. This is needed for =
userspace
> > > >> to discover whether the kernel supports the new attribute.
> > > >>
> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > >
> > > > I didn't know we wanted to go ahead with this...
> > >
> > > Well, I'm aware of the bpf_link discussion, obviously. Not sure what'=
s
> > > happening with that, though. So since this is a straight-forward
> > > extension of the existing API, that doesn't carry a high implementati=
on
> > > cost, I figured I'd just go ahead with this. Doesn't mean we can't ha=
ve
> > > something similar in bpf_link as well, of course.
> >
> > I'm not really in the loop, but from what I overheard - I think the
> > bpf_link may be targeting something non-networking first.
>
> My preference is to avoid building two different APIs one for XDP and ano=
ther
> for everything else. If we have userlands that already understand links a=
nd
> pinning support is on the way imo lets use these APIs for networking as w=
ell.

I agree here. And yes, I've been working on extending bpf_link into
cgroup and then to XDP. We are still discussing some cgroup-specific
details, but the patch is ready. I'm going to post it as an RFC to get
the discussion started, before we do this for XDP.

>
> Would a link_swap() API (proposed by Andrii iirc) resolve this use case a=
s
> well? If not why? If it can it seems like the more general and consistent
> solution. I can imagine swapping links is useful in tracing as well and
> likely other cases I haven't thought about.

Yes, that's the idea. Right now I have implementation for cgroups, but
API itself is generic and should/will be extended to tracing and XDP.
