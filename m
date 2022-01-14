Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696F848E478
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiANGw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbiANGwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:52:46 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2300DC061759;
        Thu, 13 Jan 2022 22:52:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c3so12538573pls.5;
        Thu, 13 Jan 2022 22:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SPAPqo3ptbOEK+GBLxpjcckVNlsKW/PT3fT/lJFLaFY=;
        b=A4ZOzUKkIFjxxonqG6tfTqrXICrszyIGoxdrJJBNU7kr5YrpPo+mwArfBA1Jb85qNz
         ZpUy0COU7QynJicFHkJjyvOEVA3giHT06BQLwsHWEFjbt2mwPFxCKYr0iaHJg2Xs42MK
         UB3CD95iiynkBnSr2LAhnLro1COOSBasWXp+Gu2Swt9f0w/nj1zvF1rzM5yA88ZVt21N
         F0pdGs6H+EDHqJ1mYgeWpB2Ng8TA3nxvdkyh7BJVvn5rmmNj1CTkzpT49urd9SvfDYOJ
         An+WCw1+axhG++LQoQQayYh7K95wV6r7uWBBq5Zd8CQTeaeWYk7jv11ER2iOSf6ACLZP
         lRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SPAPqo3ptbOEK+GBLxpjcckVNlsKW/PT3fT/lJFLaFY=;
        b=KTNrZBk+Smm2AlQVk6Rs/To2mS4rXhZgtjpEzgQ4wtz/bdrG+JVkNF5sxm5hEgzd5H
         i6h30UpNd8LWju0qxXekwWPUrGNbexh5bV/qEaW9roIBFhdWNtJumKW125g3XRc4Iq4v
         hunOjG69OAiVcqgC1muXmwzg2P/U3+z8EcKJQm2RdiOWrKGGM7cvnROVftka6Wvkgc9R
         PKvtzOUq11cFSfpXDIAC7anfzPbg/8hIEknMe61/+j6IcObOZT5teKWVKT+pmem7rGdC
         Zyb1pfXHhaB6lfu8KQPOLMNiDs+RdSPIhGLVZyUK6XUO1YoKhBdkZZ9IjZs3YROMMfSW
         zmWw==
X-Gm-Message-State: AOAM531sW5j34Ju/jSHJHiPhtHUtMA7tzpequQoCuc8qYK0BZ9wsysCU
        62kDvbMV+/kQgL990vUTcxPgciNKBZjmA33gl90=
X-Google-Smtp-Source: ABdhPJw2YWD6pZbmYWdQM2jmUvgws5TGOjflK5phYwjeDQerR/wu10TualQE7/Ks7RmjTnrzGdLn5r23znHJZCBjSUQ=
X-Received: by 2002:a17:90b:3a82:: with SMTP id om2mr9258728pjb.138.1642143160578;
 Thu, 13 Jan 2022 22:52:40 -0800 (PST)
MIME-Version: 1.0
References: <20220111180428.931466-1-memxor@gmail.com> <20220111180428.931466-3-memxor@gmail.com>
 <20220113223211.s2m5fkvafd6fk4tv@ast-mbp.dhcp.thefacebook.com>
 <20220114044950.24jr6juxbuzxskw2@apollo.legion> <20220114052129.dwx7tvdjrwokw5sc@apollo.legion>
In-Reply-To: <20220114052129.dwx7tvdjrwokw5sc@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Jan 2022 22:52:29 -0800
Message-ID: <CAADnVQ+0413hUaMpaO-xuXM68+yvECQ2U8Mrer6_rvaZhVP5TQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 02/10] bpf: Populate kfunc BTF ID sets in
 struct btf
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 9:22 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Jan 14, 2022 at 10:19:50AM IST, Kumar Kartikeya Dwivedi wrote:
> > On Fri, Jan 14, 2022 at 04:02:11AM IST, Alexei Starovoitov wrote:
> > > On Tue, Jan 11, 2022 at 11:34:20PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > [...]
> > > > + /* Make sure all updates are visible before we go to MODULE_STATE_LIVE,
> > > > +  * pairs with smp_rmb in btf_try_get_module (for success case).
> > > > +  *
> > > > +  * btf_populate_kfunc_set(...)
> > > > +  * smp_wmb()    <-----------.
> > > > +  * mod->state = LIVE        |           if (mod->state == LIVE)
> > > > +  *                          |             atomic_inc_nz(mod)
> > > > +  *                          `--------->   smp_rmb()
> > > > +  *                                        btf_kfunc_id_set_contains(...)
> > > > +  */
> > > > + smp_wmb();
> > >
> > > This comment somehow implies that mod->state = LIVE
> > > and if (mod->state == LIVE && try_mod_get) can race.
> > > That's not the case.
> > > The patch 1 closed the race.
> > > btf_kfunc_id_set_contains() will be called only on LIVE modules.
> > > At that point all __init funcs of the module including register_btf_kfunc_id_set()
> > > have completed.
> > > This smp_wmb/rmb pair serves no purpose.
> > > Unless I'm missing something?
> > >
> >
> > Right, I'm no expert on memory ordering, but even if we closed the race, to me
> > there seems to be no reason why the CPU cannot reorder the stores to tab (or its
> > hook/type slot) with mod->state = LIVE store.
> >
> > Usually, the visibility is handled by whatever lock is used to register the
> > module somewhere in some subsystem, as the next acquirer can see all updates
> > from the previous registration.
> >
> > In this case, we're directly assigning a pointer without holding any locks etc.
> > While it won't be concurrently accessed until module state is LIVE, it is
> > necessary to make all updates visible in the right order (that is, once state is
> > LIVE, everything stored previously in struct btf for module is also visible).
> >
> > Once mod->state = LIVE is visible, we will start accessing kfunc_set_tab, but if
> > previous stores to it were not visible by then, we'll access a badly-formed
> > kfunc_set_tab.
> >
> > For this particular case, you can think of mod->state = LIVE acting as a release
> > store, and the read for mod->state == LIVE acting as an acquire load.
> >
>
> Also, to be more precise, we're now synchronizing using btf_mod->flags, not
> mod->state, so I should atleast update the comment, but the idea is the same.

So the concern is that cpu can execute
mod->state = MODULE_STATE_LIVE;
from kernel/module.c
earlier than stores inside __btf_populate_kfunc_set
that are called from do_one_initcall()
couple lines earlier in kernel/module.c ?
Let's assume cpu is not Intel, since Intel never reorders stores.
(as far as I remember the only weak store ordering architecture
ever produced is Alpha).
But it's not mod->state, it's btf_mod->flags (as you said)
which is done under btf_module_mutex.
and btf_kfunc_id_set_contains() can only do that after
btf_try_get_module() succeeds which is under the same
btf_module_mutex.
So what is the race ?
I think it's important to be concerned about race
conditions, but they gotta be real.
So please spell out a precise scenario if you still believe it's there.
