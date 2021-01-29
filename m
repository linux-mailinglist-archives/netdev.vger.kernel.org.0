Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E113083F7
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhA2CzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhA2CzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 21:55:22 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA75FC061573;
        Thu, 28 Jan 2021 18:54:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s24so5010884pjp.5;
        Thu, 28 Jan 2021 18:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=szSPZD4f9nJJL/ReQL9fvwbRY1tcDEbXe+P5IvdDyVs=;
        b=btoB28MCHFjNFu/sCLrI4zM3BpbpBe8SHuFg9kzlAEapdssVfmL1PVQXnGXzSFEs3q
         fPppz+E1jhcNQ9gvtH5LtJMTV2Tg+2MxIaS8X5LJaMZgMTebzb+3zJ3S5rKauVQzGUIc
         f+woZvqjAvsVs3En4rACFFVk4NV5Dhp0hC9QrU5YwzBsaDghvXuymynfurbHn7Qfdoht
         XLTV1S1itJ63y+p13O1e1LELJypvQY16dbdfrmG+4XqJWgwk7qN5+Qbegy/kFkXQTKrA
         hSfc3p9HyYgHw4Y+WPqlgzsu0qHvutnrcbiKPAAxYmFvgo2v1qysgtarI9T68oXwLyMp
         b6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=szSPZD4f9nJJL/ReQL9fvwbRY1tcDEbXe+P5IvdDyVs=;
        b=V+skz8d9H6ieovnEOkrQw5PDU3hWNhdhr/gYEX2F2b37ZuTAIhlbnszoq2VVxKqGVC
         TEhUtK+9H4FsIf3iBnDGow/eeS+HE0qwFefQ7tOdBm83RhcYQUy4mc1YstV3q+enMyiu
         SkRJkhMvqcScKWP5CTVsbS8NDypKtascK8O5lANXOBFc0wml582TzymEllSNWYsHcoOu
         SK882nSZzzivtfVqZHE5Fr3s29Sny9yROIXQXgFP47Jb14K69Nix60VKTQDhEMyrLQ38
         XY5uQgQFR07MPLL4LCmMeRiTD4REHTsZeKyPyqCeKFCAdFeR0yHVpb4oUYgoByqCdEQQ
         rm3A==
X-Gm-Message-State: AOAM5328jNjjuSGs4x0mVuqgFMhp+pmD9+QKT1Aba6Nb6H61FPxuRbVQ
        XveFC0/IQWMr3B9JSzYFlds=
X-Google-Smtp-Source: ABdhPJxpVsDS6H2OF14lIxJf2VWY/ReDyYL9RFT4XZGw3IdKDtccm3zv4WuVWT05ylaLwU2DmqxSjw==
X-Received: by 2002:a17:90a:4209:: with SMTP id o9mr2421513pjg.75.1611888881414;
        Thu, 28 Jan 2021 18:54:41 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8ed])
        by smtp.gmail.com with ESMTPSA id r194sm7021638pfr.168.2021.01.28.18.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 18:54:40 -0800 (PST)
Date:   Thu, 28 Jan 2021 18:54:35 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
Message-ID: <20210129025435.a34ydsgmwzrnwjlg@ast-mbp.dhcp.thefacebook.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com>
 <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
 <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 10:28:15PM -0800, Cong Wang wrote:
> On Wed, Jan 27, 2021 at 10:00 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 11:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >               ret = PTR_ERR(l_new);
> > > > > +             if (ret == -EAGAIN) {
> > > > > +                     htab_unlock_bucket(htab, b, hash, flags);
> > > > > +                     htab_gc_elem(htab, l_old);
> > > > > +                     mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
> > > > > +                     goto again;
> > > >
> > > > Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
> > > > in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?
> > >
> > > In this case, the old one is scheduled for removal in GC, we just wait for GC
> > > to finally remove it. It won't stall unless GC itself or the worker scheduler is
> > > wrong, both of which should be kernel bugs.
> > >
> > > If we don't do this, users would get a -E2BIG when it is not too big. I don't
> > > know a better way to handle this sad situation, maybe returning -EBUSY
> > > to users and let them call again?
> >
> > I think using wq for timers is a non-starter.
> > Tying a hash/lru map with a timer is not a good idea either.
> 
> Both xt_hashlimit and nf_conntrack_core use delayed/deferrable
> works, probably since their beginnings. They seem to have started
> well. ;)

That code was written when network speed was in Mbits and DDoS abbreviation
wasn't invented. Things are different now.

> > I'm proposing a timer map where each object will go through
> > bpf_timer_setup(timer, callback, flags);
> > where "callback" is a bpf subprogram.
> > Corresponding bpf_del_timer and bpf_mod_timer would work the same way
> > they are in the kernel.
> > The tricky part is kernel style of using from_timer() to access the
> > object with additional info.
> > I think bpf timer map can model it the same way.
> > At map creation time the value_size will specify the amount of extra
> > bytes necessary.
> > Another alternative is to pass an extra data argument to a callback.
> 
> Hmm, this idea is very interesting. I still think arming a timer,
> whether a kernel timer or a bpf timer, for each entry is overkill,
> but we can arm one for each map, something like:
> 
> bpf_timer_run(interval, bpf_prog, &any_map);
> 
> so we run 'bpf_prog' on any map every 'interval', but the 'bpf_prog'
> would have to iterate the whole map during each interval to delete
> the expired ones. This is probably doable: the timestamps can be
> stored either as a part of key or value, and bpf_jiffies64() is already
> available, users would have to discard expired ones after lookup
> when they are faster than the timer GC.

I meant it would look like:

noinline per_elem_callback(map, key, value, ...)
{
  if (value->foo > ...)
    bpf_delete_map_elem(map, key);
}

noinline timer_callback(timer, ctx)
{
  map = ctx->map;
  bpf_for_each_map_elem(map, per_elem_callback, ...);
}

int main_bpf_prog(skb)
{
  bpf_timer_setup(my_timer, timer_callback, ...);
  bpf_mod_timer(my_timer, HZ);
}

The bpf_for_each_map_elem() work is already in progress. Expect patches to hit
mailing list soon.
If you can work on patches for bpf_timer_*() it would be awesome.
