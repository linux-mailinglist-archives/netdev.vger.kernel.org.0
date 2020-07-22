Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5240229120
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgGVGpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGVGpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:45:24 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5367C061794;
        Tue, 21 Jul 2020 23:45:23 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id k18so1014284qke.4;
        Tue, 21 Jul 2020 23:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HQwq0SpxxWofhQpM3mlaAQD8Almqzte1lkFSPnMIj+4=;
        b=qa+VX+TXyQQh9hvCzn21DTxIGXXKp8OiRdQ2raAYbJL63HHNkgyeTbcQtm2Hf21Td5
         nYVx6ve7M54LnduAOeww+J2lC/Nm8pKn1q0wvtA36YrH3EbdWGQ/q+EfOxnZXL9Mg3iQ
         fsvXSm57jS0UHE10vMdowmY6FC2jSIFm3RI900L4JzrjNCW/Vp8TplWX8Fx8keE3aTig
         Z9k6FxP1QsHPA/bWhEXeYITM1CRTFpVyyp0V5Cm35hxUdwC066gpXiNFpZXQw8iqxCBw
         YhiShaiIGDLdW+fC1xeZwmZW5EmIEX8KGuTxTWOfxZBDyeK85gf2msAsFGYakUB/jCLS
         UovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HQwq0SpxxWofhQpM3mlaAQD8Almqzte1lkFSPnMIj+4=;
        b=OOBm2XixcMzhPB7AGg2xqKvqD1jK7DKXLvQGl7hw46UxWXOANtx5m+Ukbh2ssReDWR
         b4zGEOVcG+RH8LVyiDSa+JDayEHY8fwa+SNzKkWrtJkStnyEg0Pk23SaO8qN1fRFvFAM
         Y5tYJg6Xf2YGomQ3YwmwYXPY7S8RwbSfAGBt6IZfJqNObq6xblQ6HQDmx7XzZPCELuxK
         i+kmJNaQGZsZKjBnwkB25c5+Ti8cXiHcozhHAeRM73uaWfXul0gi9m/jOWsS7LJYJ+t1
         smXGi+lM1iReliAnMnzXIXSx8SfmsW8j/Ef82z9fKXa3SJCSdwQLVzw/k2ik8wpk8P2g
         EReA==
X-Gm-Message-State: AOAM5336HN8NRbZKJhYNtosJh4iL0DThtazkUGcP7d+/XrX0WYiLIl8x
        Fv/aFgvF3Cazv21NZZuiuGoyJUF799gcWG9ncGo=
X-Google-Smtp-Source: ABdhPJyPhlME8n9iaKO0F6LxtlHehLpksHE7SGm84Txv9tcVHhuDZYqOWmK5B6ADg9NTKA5ujVM6uxCOmMc+tTbWS4k=
X-Received: by 2002:a37:7683:: with SMTP id r125mr30568252qkc.39.1595400323022;
 Tue, 21 Jul 2020 23:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
 <877dv6gpxd.fsf@toke.dk> <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com>
 <87v9ipg8jd.fsf@toke.dk> <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com>
 <87lfjlg4fg.fsf@toke.dk> <CAEf4BzYMaKgJOA3koGkcThXriTGAOKGxjhQXYSNT9sVEFbS7ig@mail.gmail.com>
 <87y2nkeq4s.fsf@toke.dk> <CAEf4BzbgPqN8xKX5xpHBRMJSZkhz_BBzBg7r_FPRo=j3ZmLNUQ@mail.gmail.com>
 <87k0z3enpr.fsf@toke.dk>
In-Reply-To: <87k0z3enpr.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jul 2020 23:45:11 -0700
Message-ID: <CAEf4BzZn66Qk1xDj3aS8H2kvK4Xi5ZU3UPtV7Czrk-4TkPQE5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 3:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Jul 15, 2020 at 8:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> >> Yup, that was helpful, thanks! I think our difference of opinion on=
 this
> >> >> stems from the same place as our disagreement about point 2.: You a=
re
> >> >> assuming that an application that uses XDP sticks around and holds =
on to
> >> >> its bpf_link, while I'm assuming it doesn't (and so has to rely on
> >> >> pinning for any persistence). In the latter case you don't really g=
ain
> >> >> much from the bpf_link auto-cleanup, and whether it's a prog fd or =
a
> >> >> link fd you go find in your bpffs doesn't make that much difference=
...
> >> >
> >> > Right. But if I had to pick just one implementation (prog fd-based v=
s
> >> > bpf_link), I'd stick with bpf_link because it is flexible enough to
> >> > "emulate" prog fd attachment (through BPF FS), but the same isn't tr=
ue
> >> > about prog fd attachment emulating bpf_link. That's it. I really don=
't
> >> > enjoy harping on that point, but it feels to be silently dismissed a=
ll
> >> > the time based on one particular arrangement for particular existing
> >> > XDP flow.
> >>
> >> It can; kinda. But you introduce a dependency on bpffs that wasn't the=
re
> >> before, and you end up with resources that are kept around in the kern=
el
> >> if the interface disappears (because they are still pinned). So I
> >> consider it a poor emulation.
> >
> > Yes, it's not exactly 100% the same semantics.
> > It is possible with slight additions to API to support essentially
> > exactly the same semantics you want with prog attachment. E.g., we can
> > either have a flag at LINK_CREATE time, or a separate command (e.g.,
> > LINK_PIN or something), that would mark bpf_link as "sticky", bump
> > it's refcnt. What happens then is that even if last FD is closed,
> > there is still refcnt 1 there, and then there are two ways to detach
> > that link:
> >
> > 1) interface/cgroup/whatever is destroyed and bpf_link is
> > auto-detached. At that point auto-detach handler will see that it's a
> > "sticky" bpf_link, will decrement refcnt and subsequently free
> > bpf_link kernel object (unless some application still has FD open, of
> > course).
> >
> > 2) a new LINK_DESTROY BPF command will be introduced, which will only
> > work with "sticky" bpf_links. It will decrement refcnt and do the same
> > stuff as the auto-detach handler does today (so bpf_link->dev =3D NULL,
> > for XDP link).

So it seems there is an interest in having this LINK_DESTROY command
irrespective of sticky/non-sticky BPF links. I'm going to follow up
with a patch set adding this as a LINK_DETACH command (I think it's a
more proper name) generically to links that it makes most sense for.
I.e., cgroup, netns and (now) xdp links are natural candidates, as
they already have to do this as part of auto-detach. I'll take a look
at tracing/bpf_iter links as well and see how hard it is to support
something like that. Of course `bpftool link detach` command needs to
be added, etc.

Sticky links are a bit more controversial and less clear from API
stand-point, so we can consider them separately from LINK_DETACH this.

> >
> > I don't mind this, as long as this is not a default semantics and
> > require conscious opt-in from whoever creates the link.
>
> Now *this* I would like to see! I have the issue with component progs of
> the multiprog dispatcher being pinned and making everything stick
> around.
>
> [...]
>
> > Sure, thanks, enjoy your vacation! I'll post v3 then with build fixes
> > I have so far.
>
> Thanks! :)
>
> -Toke
>
