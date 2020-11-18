Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14002B7386
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgKRBLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRBLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:11:14 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D2AC061A48;
        Tue, 17 Nov 2020 17:11:13 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id v20so467455ljk.8;
        Tue, 17 Nov 2020 17:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k1uTQmCaLL4z76gRIZgW5OMObzd3UGBaR1Yyv4E9eQk=;
        b=Rto2KIJM7zEuqxypzt93PDHfcpYVAnMQjlVgugOtPIY1GPn2Tw90KZC8IDmMAgskdH
         MpG1EIk215aNH6cupXTUHxfQ8Bbl+mpgpfJp0peA/fe0RrKAAWolRMLkeCG7jLDMd11k
         zJK4RTe+XCWdXkNCnfBznOiiUS7Lj+G1iWigoKsKEjh8zCYqadxrwBTxZ+XkfHdKSHwx
         XHlCfihABAX4t7PfS2ZuU7+/Hwz0tzGdqYDBz7M9CVw2X7Lf2X+uu4fsie3usrLuIv++
         4I2MXFy1zla+tRXxG6yQFQyQ9iVrmAP9Z9zeYW5/nkcLo2Jbw0StYzyA55eqBiNnqDCJ
         3/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k1uTQmCaLL4z76gRIZgW5OMObzd3UGBaR1Yyv4E9eQk=;
        b=s9i9yfBZbr+hym+iSeP94VxfXlZ61ERB9p4NlF95e+e/tC2q55mJytfrQN+AGFbqXb
         oEglMg2EzVxBhal9s2khcnzJsNYoeOzw1YvcgdCXLfdbBlbR77FndwTluNFsI7T70bzf
         RUQdRhz1mutpkcE/oX69S/LB/s7CYQl51ljOyqNL5kY4ZAFkwNrvIA7OT3ChaEu1qP5/
         bUKv0/qWbZ6hZKy8Ct9xKM694nvbX2/CbyzILNLui7h/JjgMQpDwsioCUuMAqtlugEq8
         cU/hp5M9QW1ZqfrHMYkvhtOajjoxgSQzUJjrV9uQ5HDaFGOOmlk/FEn7Rhoy4vWN+dsm
         DSgg==
X-Gm-Message-State: AOAM5329xkolMYWu6s3tTgpIAhghsbzQWowk5YXWE519GC+mMtm+/4RJ
        T0MrCWWD4u3Syyh3G/9yEwyw0nSzB7u0BhElLU0=
X-Google-Smtp-Source: ABdhPJzb6cde2dyBm3bIrgT1Vq6ukk4rXZepBUsZDjJ6oDvxq1XcIFvseiplfDvZZYigk6moJ3qfcsvtkmrpxniKtxE=
X-Received: by 2002:a2e:8982:: with SMTP id c2mr3041179lji.121.1605661872055;
 Tue, 17 Nov 2020 17:11:12 -0800 (PST)
MIME-Version: 1.0
References: <20201117034108.1186569-1-guro@fb.com> <20201117034108.1186569-7-guro@fb.com>
 <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net> <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
 <20201118010703.GC156448@carbon.DHCP.thefacebook.com>
In-Reply-To: <20201118010703.GC156448@carbon.DHCP.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Nov 2020 17:11:00 -0800
Message-ID: <CAADnVQ+vSLfgVCXB7KnXMBzVe3rL20qLwrKf=xrJXpZTmUEnYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
To:     Roman Gushchin <guro@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 5:07 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Nov 17, 2020 at 04:46:34PM -0800, Roman Gushchin wrote:
> > On Wed, Nov 18, 2020 at 01:06:17AM +0100, Daniel Borkmann wrote:
> > > On 11/17/20 4:40 AM, Roman Gushchin wrote:
> > > > In the absolute majority of cases if a process is making a kernel
> > > > allocation, it's memory cgroup is getting charged.
> > > >
> > > > Bpf maps can be updated from an interrupt context and in such
> > > > case there is no process which can be charged. It makes the memory
> > > > accounting of bpf maps non-trivial.
> > > >
> > > > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> > > > memcg accounting from interrupt contexts") and b87d8cefe43c
> > > > ("mm, memcg: rework remote charging API to support nesting")
> > > > it's finally possible.
> > > >
> > > > To do it, a pointer to the memory cgroup of the process which created
> > > > the map is saved, and this cgroup is getting charged for all
> > > > allocations made from an interrupt context.
> > > >
> > > > Allocations made from a process context will be accounted in a usual way.
> > > >
> > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > [...]
> > > > +#ifdef CONFIG_MEMCG_KMEM
> > > > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > > > +                                          void *value, u64 flags)
> > > > +{
> > > > + struct mem_cgroup *old_memcg;
> > > > + bool in_interrupt;
> > > > + int ret;
> > > > +
> > > > + /*
> > > > +  * If update from an interrupt context results in a memory allocation,
> > > > +  * the memory cgroup to charge can't be determined from the context
> > > > +  * of the current task. Instead, we charge the memory cgroup, which
> > > > +  * contained a process created the map.
> > > > +  */
> > > > + in_interrupt = in_interrupt();
> > > > + if (in_interrupt)
> > > > +         old_memcg = set_active_memcg(map->memcg);
> > > > +
> > > > + ret = map->ops->map_update_elem(map, key, value, flags);
> > > > +
> > > > + if (in_interrupt)
> > > > +         set_active_memcg(old_memcg);
> > > > +
> > > > + return ret;
> > >
> > > Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
> > > retpoline for lookup/update/delete calls on maps") which removes the indirect
> > > call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
> > > not invoked for the vast majority of cases.
> >
> > I see. Well, the first option is to move these calls into map-specific update
> > functions, but the list is relatively long:
> >   nsim_map_update_elem()
> >   cgroup_storage_update_elem()
> >   htab_map_update_elem()
> >   htab_percpu_map_update_elem()
> >   dev_map_update_elem()
> >   dev_map_hash_update_elem()
> >   trie_update_elem()
> >   cpu_map_update_elem()
> >   bpf_pid_task_storage_update_elem()
> >   bpf_fd_inode_storage_update_elem()
> >   bpf_fd_sk_storage_update_elem()
> >   sock_map_update_elem()
> >   xsk_map_update_elem()
> >
> > Alternatively, we can set the active memcg for the whole duration of bpf
> > execution. It's simpler, but will add some overhead. Maybe we can somehow
> > mark programs calling into update helpers and skip all others?
>
> Actually, this is problematic if a program updates several maps, because
> in theory they can belong to different cgroups.
> So it seems that the first option is the way to go. Do you agree?

May be instead of kmalloc_node() that is used by most of the map updates
introduce bpf_map_kmalloc_node() that takes a map pointer as an argument?
And do set_memcg inside?
