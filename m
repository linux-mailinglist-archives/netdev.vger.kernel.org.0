Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088F43531A7
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 01:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhDBXpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 19:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhDBXpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 19:45:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F1EC0613E6;
        Fri,  2 Apr 2021 16:45:04 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w11so3113246ply.6;
        Fri, 02 Apr 2021 16:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+foaeO5OfbBiZpUT5n3bA81rc2IF+4U2NHdudGSQ/fQ=;
        b=W0iGzU/sa0O2IzTT0QKB0ljymjlr1O/f54n3daiUgE9cNJBUJXR0zQY74Y5Zzr4XmI
         E3P2jj1twZdSL7rX5E4L4+rNkLwdeE6YN4a/JxT7aOombbWiv2pWCLvsDhHd62mK1d6T
         XnJtdTLgv8e0PzjITQDHSqVWjNQ/3RT/LwiSGWV/0G2u1t+LZg7ZVaVzDphLMhLwZoKH
         28wKapMAP9ubKHQ/lwBHM5D6ZJp0Qjqn048RIQZd6tp67JzVqKSMD5AMo273e4UuXcdT
         lL/WuYT9ixlkkei+xFRVuwkJsOjbAAoUFfw5JF9SLJOWemcDT5RbADn5Z/HxiOQywFaU
         HtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+foaeO5OfbBiZpUT5n3bA81rc2IF+4U2NHdudGSQ/fQ=;
        b=JDkLlNXfkCuDHtKD7U33NecuN8Y7kjVBVfvS2AcXiGgB5UQ4TqaN0CsM73Ny2iPpMw
         O4623/3vbsL/dDcRwPnfui1GPBN9Jb8ZyPEOjKcoY6+w33IvPPUPWEzX59KIQFU4bzZv
         gZAIBRyHfu0AN4iH7vYUHQ8fbe4kKhC4PdFSscJKET4JoSko20xtJgg0N1cmwRRWnDuY
         5oujKxAQCISBHjeTqTbNa4/g9JNkV/U9KpHEsVt6Gf8DfxIhY8/bW+4CqIQT+D0Pb6Fh
         WaqIGcvz3s776SntsqyvGx4bnL8iIM/ucSL2IQWH99lRekHXHVXn9Jy9Oc2IQfyJkd/k
         8qHQ==
X-Gm-Message-State: AOAM530aOAogwd4ERl23HHqu3Mkfz35aU/Kugd/Eh43yCjSLTn0kw0X0
        2pRM7yUOw2ZMzsp83hKYmwU=
X-Google-Smtp-Source: ABdhPJyNRBc3YLuMneuAvdM1Vbhm54FYK9b2yBg0/hxCbEd67mJFtplZLiZqgH6sYq/u9/XLn4efBw==
X-Received: by 2002:a17:90b:1651:: with SMTP id il17mr16135021pjb.16.1617407103899;
        Fri, 02 Apr 2021 16:45:03 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f671])
        by smtp.gmail.com with ESMTPSA id w17sm8180430pfu.29.2021.04.02.16.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 16:45:03 -0700 (PDT)
Date:   Fri, 2 Apr 2021 16:45:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Message-ID: <20210402234500.by3wigegeluy5w7j@ast-mbp>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp>
 <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 02:24:51PM -0700, Cong Wang wrote:
> > > where the key is the timer ID and the value is the timer expire
> > > timer.
> >
> > The timer ID is unnecessary. We cannot introduce new IDR for every new
> > bpf object. It doesn't scale.
> 
> The IDR is per map, not per timer.

Per-map is not acceptable. One IDR for all maps with timers is not acceptable either.
We have 3 IDRs now: for progs, for maps, and for links.
No other objects need IDRs.

> > Here is how more general timers might look like:
> > https://lore.kernel.org/bpf/20210310011905.ozz4xahpkqbfkkvd@ast-mbp.dhcp.thefacebook.com/
> >
> > include/uapi/linux/bpf.h:
> > struct bpf_timer {
> >   u64 opaque;
> > };
> > The 'opaque' field contains a pointer to dynamically allocated struct timer_list and other data.
> 
> This is my initial design as we already discussed, it does not work,
> please see below.

It does work. The perceived "issue" you referred to is a misunderstanding. See below.

> >
> > The prog would do:
> > struct map_elem {
> >     int stuff;
> >     struct bpf_timer timer;
> > };
> >
> > struct {
> >     __uint(type, BPF_MAP_TYPE_HASH);
> >     __uint(max_entries, 1);
> >     __type(key, int);
> >     __type(value, struct map_elem);
> > } hmap SEC(".maps");
> >
> > static int timer_cb(struct map_elem *elem)
> > {
> >     if (whatever && elem->stuff)
> >         bpf_timer_mod(&elem->timer, new_expire);
> > }
> >
> > int bpf_timer_test(...)
> > {
> >     struct map_elem *val;
> >
> >     val = bpf_map_lookup_elem(&hmap, &key);
> >     if (val) {
> >         bpf_timer_init(&val->timer, timer_cb, flags);
> >         val->stuff = 123;
> >         bpf_timer_mod(&val->timer, expires);
> >     }
> > }
> >
> > bpf_map_update_elem() either from bpf prog or from user space
> > allocates map element and zeros 8 byte space for the timer pointer.
> > bpf_timer_init() allocates timer_list and stores it into opaque if opaque == 0.
> > The validation of timer_cb() is done by the verifier.
> > bpf_map_delete_elem() either from bpf prog or from user space
> > does del_timer() if elem->opaque != 0.
> > If prog refers such hmap as above during prog free the kernel does
> > for_each_map_elem {if (elem->opaque) del_timer().}
> > I think that is the simplest way of prevent timers firing past the prog life time.
> > There could be other ways to solve it (like prog_array and ref/uref).
> >
> > Pseudo code:
> > int bpf_timer_init(struct bpf_timer *timer, void *timer_cb, int flags)
> > {
> >   if (timer->opaque)
> >     return -EBUSY;
> >   t = alloc timer_list
> >   t->cb = timer_cb;
> >   t->..
> >   timer->opaque = (long)t;
> > }
> >
> > int bpf_timer_mod(struct bpf_timer *timer, u64 expires)
> > {
> >   if (!time->opaque)
> >     return -EINVAL;
> >   t = (struct timer_list *)timer->opaque;
> >   mod_timer(t,..);
> > }
> >
> > int bpf_timer_del(struct bpf_timer *timer)
> > {
> >   if (!time->opaque)
> >     return -EINVAL;
> >   t = (struct timer_list *)timer->opaque;
> >   del_timer(t);
> > }
> >
> > The verifier would need to check that 8 bytes occupied by bpf_timer and not accessed
> > via load/store by the program. The same way it does it for bpf_spin_lock.
> 
> This does not work, because bpf_timer_del() has to be matched
> with bpf_timer_init(), otherwise we would leak timer resources.
> For example:
> 
> SEC("foo")
> bad_ebpf_code()
> {
>   struct bpf_timer t;
>   bpf_timer_init(&t, ...); // allocate a timer
>   bpf_timer_mod(&t, ..);
>   // end of BPF program
>   // now the timer is leaked, no one will delete it
> }
> 
> We can not enforce the matching in the verifier, because users would
> have to call bpf_timer_del() before exiting, which is not what we want
> either.

```
bad_ebpf_code()
{
  struct bpf_timer t;
```
is not at all what was proposed. This kind of code will be rejected by the verifier.

'struct bpf_timer' has to be part of the map element and the verifier will enforce that
just like it does so for bpf_spin_lock.
Try writing the following program:
```
bad_ebpf_code()
{
  struct bpf_spin_lock t;
  bpf_spin_lock(&t);
}
``
and then follow the code to see why the verifier rejects it.

The implementation of what I'm proposing is straightforward.
I certainly understand that it might look intimidating and "impossible",
but it's really quite simple.
