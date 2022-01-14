Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F048E502
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 08:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiANHqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 02:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiANHqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 02:46:47 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22CC061574;
        Thu, 13 Jan 2022 23:46:47 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 78so2064064pfu.10;
        Thu, 13 Jan 2022 23:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z4KOJcQZQtvlKNXQ7dtsE282W/mN9HhhUFMJRCRUci0=;
        b=TvpC2E0LgeoJZfDkvGeCylLHKDgDezVo4/mPCNJimYTokRBWeX5SZwR7Rnw2ySlehz
         wa5t4hqeSLf/sPNY4CDicNU/l57bgvXLdTeK9P9dM4SsIsI7JM9l5NlX38Eu0RbkZY5A
         ApabsLukabAVULm71b7d8XZGpAMmomJ9PHBmbeQOuall2+awbcVowg5nBWp/Uv8xtV3d
         GkGXuNnkxbXJTgk/eCctJMblOXBDAZ1qpTmObb2e1Mq8mPYlmuMG2XAdM2wrE/4WYP2A
         C7LvdGpLmrqRBR1ztypwCkfCkfLCG8tKp+Ee3lczo8jw2jfFzw3Bz7Dc4kTRMm0yEAU7
         Ug1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z4KOJcQZQtvlKNXQ7dtsE282W/mN9HhhUFMJRCRUci0=;
        b=QSu8hKwLM003UanAm9FUQL3xK3IAuG6C6Sp2P5vgGMXOGJ1gAp3zVH41mmsLMb1R4m
         IEDfb/xnTTgi41QcQl4bAPECP855hSqGT7XMQcPUm7H4xFPvJM0VvtIiOP3FFPLL2Xot
         rkf9qzF4iznM0ywLtJhI4dpxZU7ALBogrq1t+SU+yUmmxHRH3rDCoWXPzi1iGDiuuy/Q
         Ywa/FmcDOYg/7yZ6aypkBu5syTn/o6SMabwvltLzBHf98EZQH9J5WRHwzewAhPJ8dmzx
         cqbS90NL7QBzjHutv39KD27JDFfNdX27ThWO40oapA0VbkJiKL5rQ/KYIGb2ChKokPRz
         /SnA==
X-Gm-Message-State: AOAM531t8H6skvsQjWamFx4ouW9sR6PK0/rklWq0cVRCTjgiZtD9vvkh
        /YnodwD+q5HyMM1XITovejk=
X-Google-Smtp-Source: ABdhPJx8g6C2wcBT6ewZvdHiZnO2Fbdo9ZcD4wvMd+Kk+ezfRjcRxkTGrsTMeh+i7wX4Z6aPjiLXQg==
X-Received: by 2002:a63:7156:: with SMTP id b22mr7087769pgn.288.1642146406755;
        Thu, 13 Jan 2022 23:46:46 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id h5sm4541743pfi.46.2022.01.13.23.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 23:46:45 -0800 (PST)
Date:   Fri, 14 Jan 2022 13:16:01 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v7 02/10] bpf: Populate kfunc BTF ID sets in
 struct btf
Message-ID: <20220114074601.cncdpzrnfeu7gs3d@apollo.legion>
References: <20220111180428.931466-1-memxor@gmail.com>
 <20220111180428.931466-3-memxor@gmail.com>
 <20220113223211.s2m5fkvafd6fk4tv@ast-mbp.dhcp.thefacebook.com>
 <20220114044950.24jr6juxbuzxskw2@apollo.legion>
 <20220114052129.dwx7tvdjrwokw5sc@apollo.legion>
 <CAADnVQ+0413hUaMpaO-xuXM68+yvECQ2U8Mrer6_rvaZhVP5TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+0413hUaMpaO-xuXM68+yvECQ2U8Mrer6_rvaZhVP5TQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 12:22:29PM IST, Alexei Starovoitov wrote:
> On Thu, Jan 13, 2022 at 9:22 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Fri, Jan 14, 2022 at 10:19:50AM IST, Kumar Kartikeya Dwivedi wrote:
> > > On Fri, Jan 14, 2022 at 04:02:11AM IST, Alexei Starovoitov wrote:
> > > > On Tue, Jan 11, 2022 at 11:34:20PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > > [...]
> > > > > + /* Make sure all updates are visible before we go to MODULE_STATE_LIVE,
> > > > > +  * pairs with smp_rmb in btf_try_get_module (for success case).
> > > > > +  *
> > > > > +  * btf_populate_kfunc_set(...)
> > > > > +  * smp_wmb()    <-----------.
> > > > > +  * mod->state = LIVE        |           if (mod->state == LIVE)
> > > > > +  *                          |             atomic_inc_nz(mod)
> > > > > +  *                          `--------->   smp_rmb()
> > > > > +  *                                        btf_kfunc_id_set_contains(...)
> > > > > +  */
> > > > > + smp_wmb();
> > > >
> > > > This comment somehow implies that mod->state = LIVE
> > > > and if (mod->state == LIVE && try_mod_get) can race.
> > > > That's not the case.
> > > > The patch 1 closed the race.
> > > > btf_kfunc_id_set_contains() will be called only on LIVE modules.
> > > > At that point all __init funcs of the module including register_btf_kfunc_id_set()
> > > > have completed.
> > > > This smp_wmb/rmb pair serves no purpose.
> > > > Unless I'm missing something?
> > > >
> > >
> > > Right, I'm no expert on memory ordering, but even if we closed the race, to me
> > > there seems to be no reason why the CPU cannot reorder the stores to tab (or its
> > > hook/type slot) with mod->state = LIVE store.
> > >
> > > Usually, the visibility is handled by whatever lock is used to register the
> > > module somewhere in some subsystem, as the next acquirer can see all updates
> > > from the previous registration.
> > >
> > > In this case, we're directly assigning a pointer without holding any locks etc.
> > > While it won't be concurrently accessed until module state is LIVE, it is
> > > necessary to make all updates visible in the right order (that is, once state is
> > > LIVE, everything stored previously in struct btf for module is also visible).
> > >
> > > Once mod->state = LIVE is visible, we will start accessing kfunc_set_tab, but if
> > > previous stores to it were not visible by then, we'll access a badly-formed
> > > kfunc_set_tab.
> > >
> > > For this particular case, you can think of mod->state = LIVE acting as a release
> > > store, and the read for mod->state == LIVE acting as an acquire load.
> > >
> >
> > Also, to be more precise, we're now synchronizing using btf_mod->flags, not
> > mod->state, so I should atleast update the comment, but the idea is the same.
>
> So the concern is that cpu can execute
> mod->state = MODULE_STATE_LIVE;
> from kernel/module.c
> earlier than stores inside __btf_populate_kfunc_set
> that are called from do_one_initcall()
> couple lines earlier in kernel/module.c ?
> Let's assume cpu is not Intel, since Intel never reorders stores.
> (as far as I remember the only weak store ordering architecture
> ever produced is Alpha).
> But it's not mod->state, it's btf_mod->flags (as you said)
> which is done under btf_module_mutex.
> and btf_kfunc_id_set_contains() can only do that after
> btf_try_get_module() succeeds which is under the same
> btf_module_mutex.
> So what is the race ?
> I think it's important to be concerned about race
> conditions, but they gotta be real.
> So please spell out a precise scenario if you still believe it's there.

Ah, indeed you're right, btf_module_mutex's unlock would prevent it now, so we
can drop it. I should have revisited whether the barrier was still required.

---

Just for the record, I was thinking about this case when adding it.

do_one_initcall
  register_btf_kfunc_id_set
    btf_get_module_btf
    btf->kfunc_set_tab = ...		// A
    tab->sets[hook][type] = ...		// B
mod->state = LIVE			// C

There was nothing preventing A and B to be visible after C (as per LKMM, maybe
it isn't a problem on real architectures after all), so there was need for some
ordering.

After the btf_mod->flags change, we would have:

do_one_initcall
  register_btf_kfunc_id_set
    btf_get_module_btf
    btf->kfunc_set_tab = ...		// A
    tab->sets[hook][type] = ...		// B
mod->state = LIVE
notifier_call
  btf_module_notify
  case MODULE_STATE_LIVE:
    mutex_lock(btf_module_mutex)
      btf_mod->flags |= LIVE		// C
    mutex_unlock(btf_module_mutex)	// D

Now we have A, B, and C that may be individually reordered, but when taking the
mutex all will be visible due to the release in mutex_unlock (D), even though in
the worst case A and B can seep into the critical section and reorder with C
(again, perhaps only theoretically, as per LKMM), but next critical section
should see everything.

--
Kartikeya
