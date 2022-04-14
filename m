Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B08501D9C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 23:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346199AbiDNVoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 17:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243924AbiDNVod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 17:44:33 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5AF6D3BD;
        Thu, 14 Apr 2022 14:42:07 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r12so1009161iod.6;
        Thu, 14 Apr 2022 14:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A8T3geCVvKVTA6Avl3OMEDJW2WjZ2vZaDt7GVLQ/SgI=;
        b=B1cI3aHRrF0OZIgY1hX9Qqcv9G9vigkba3fTOK4neEpA++wKAvix247me4070x75VW
         oVjBoOLRXdvC4J3GHQ0p/8B65W80cZnqoOEoMJegL1Z2fBaXhZbyAZYutC9NEQ+Y6JOT
         S6Sz4eLSr9YoYVrJ124RgnrhewBs8dPPxpsncfvn8GfyhoRT0HBXwm9GrnzD1CnTgh/0
         ujEGeDR/rcwBx1CsbniA9/oDt/DhhATPSv1SMva5YOUdk9vqD9xsQ2F9Y5C5GMztMFxX
         xEzJasp2s4I9Zw0X6hWAsilwcQCgzxhr5OZPx1mn2r9Vd7IFF1wb3PkuLQflYOvnkEAZ
         FFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A8T3geCVvKVTA6Avl3OMEDJW2WjZ2vZaDt7GVLQ/SgI=;
        b=Ezi62heE2MQYesOGaAFIYJfgWfhPxcgM1WNDb/rCY/lwpemK3ksGkjrA9nqjZhMgVU
         A3EHJ4WATlLz68tBx8sUI/oXPEPy9JhJSZgqmI7XRy47paHhr9TIIzThOHYIwdkFojOQ
         m6f54hFQfF4BheXYvMSxVABILUjM7Gu5elpWhgjkw1nbrcLVegI4J772HoE/pDsI3osr
         1CZ5zVZFiduChZP590pBQcl4B1cxfwc+cYNvGLgQqsuceXCQ/injn554q8ClRbfs5iFR
         AO70Ar2zS6W219Qzl+t5b0VWFde3TptY631HsyRc6S42GgRE1pYzm46bKhBsVsWFTnNn
         TBOA==
X-Gm-Message-State: AOAM531xuMFDkEe0PRVlAIrCwcL1b/iiLNxCAAt+hqjfCp9F06jHeKAD
        K3G0VlSwGc7r2FyDZQ0vSiprEbLimu12iOrKfGpIwCBL
X-Google-Smtp-Source: ABdhPJz1qDHt3yhPJ76qXYTbM8OCGv36Rv88cJs+K5VmehMyqLox+1kLZ6XVeJN1zvK+qvZ4iUmjfzOuoKZOm3p/rWw=
X-Received: by 2002:a02:a18c:0:b0:326:6de8:ed2f with SMTP id
 n12-20020a02a18c000000b003266de8ed2fmr2147082jah.237.1649972526594; Thu, 14
 Apr 2022 14:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220413183256.1819164-1-sdf@google.com> <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
 <Ylcm/dfeU3AEYqlV@google.com> <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
 <20220413223216.7lrdbizxg4g2bv5i@kafai-mbp.dhcp.thefacebook.com>
 <YldUIipJvL/7tK4P@google.com> <20220413235612.dpwtebrielg7v75p@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220413235612.dpwtebrielg7v75p@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Apr 2022 14:41:55 -0700
Message-ID: <CAEf4BzaR9LCLMxoCSh62HUjQr7HmThuytQfJ2uqeo85u=YnKhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 4:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Apr 13, 2022 at 03:52:18PM -0700, sdf@google.com wrote:
> > On 04/13, Martin KaFai Lau wrote:
> > > On Wed, Apr 13, 2022 at 12:52:53PM -0700, Andrii Nakryiko wrote:
> > > > On Wed, Apr 13, 2022 at 12:39 PM <sdf@google.com> wrote:
> > > > >
> > > > > On 04/13, Andrii Nakryiko wrote:
> > > > > > On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com>
> > > > > > wrote:
> > > > > > >
> > > > > > > Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of
> > > macros
> > > > > > > into functions") switched a bunch of BPF_PROG_RUN macros to inline
> > > > > > > routines. This changed the semantic a bit. Due to arguments
> > > expansion
> > > > > > > of macros, it used to be:
> > > > > > >
> > > > > > >         rcu_read_lock();
> > > > > > >         array = rcu_dereference(cgrp->bpf.effective[atype]);
> > > > > > >         ...
> > > > > > >
> > > > > > > Now, with with inline routines, we have:
> > > > > > >         array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
> > > > > > >         /* array_rcu can be kfree'd here */
> > > > > > >         rcu_read_lock();
> > > > > > >         array = rcu_dereference(array_rcu);
> > > > > > >
> > > > >
> > > > > > So subtle difference, wow...
> > > > >
> > > > > > But this open-coding of rcu_read_lock() seems very unfortunate as
> > > > > > well. Would making BPF_PROG_RUN_ARRAY back to a macro which only
> > > does
> > > > > > rcu lock/unlock and grabs effective array and then calls static
> > > inline
> > > > > > function be a viable solution?
> > > > >
> > > > > > #define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog,
> > > ret_flags) \
> > > > > >    ({
> > > > > >        int ret;
> > > > >
> > > > > >        rcu_read_lock();
> > > > > >        ret =
> > > > > > __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
> > > > > >        rcu_read_unlock();
> > > > > >        ret;
> > > > > >    })
> > > > >
> > > > >
> > > > > > where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
> > > > > > BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation
> > > dropped
> > > > > > (and no internal rcu stuff)?
> > > > >
> > > > > Yeah, that should work. But why do you think it's better to hide them?
> > > > > I find those automatic rcu locks deep in the call stack a bit obscure
> > > > > (when reasoning about sleepable vs non-sleepable contexts/bpf).
> > > > >
> > > > > I, as the caller, know that the effective array is rcu-managed (it
> > > > > has __rcu annotation) and it seems natural for me to grab rcu lock
> > > > > while work with it; I might grab it for some other things like cgroup
> > > > > anyway.
> > > >
> > > > If you think that having this more explicitly is better, I'm fine with
> > > > that as well. I thought a simpler invocation pattern would be good,
> > > > given we call bpf_prog_run_array variants in quite a lot of places. So
> > > > count me indifferent. I'm curious what others think.
> >
> > > Would it work if the bpf_prog_run_array_cg() directly takes the
> > > 'struct cgroup *cgrp' argument instead of the array ?
> > > bpf_prog_run_array_cg() should know what protection is needed
> > > to get member from the cgrp ptr.  The sk call path should be able
> > > to provide a cgrp ptr.  For current cgrp, pass NULL as the cgrp
> > > pointer and then current will be used in bpf_prog_run_array_cg().
> > > A rcu_read_lock() is needed anyway to get the current's cgrp
> > > and can be done together in bpf_prog_run_array_cg().
> >
> > > That there are only two remaining bpf_prog_run_array() usages
> > > from lirc and bpf_trace which are not too bad to have them
> > > directly do rcu_read_lock on their own struct ?
> >
> > From Andrii's original commit message:
> >
> >     I think BPF_PROG_RUN_ARRAY_CG would benefit from further refactoring to
> > accept
> >     struct cgroup and enum bpf_attach_type instead of bpf_prog_array,
> > fetching
> >     cgrp->bpf.effective[type] and RCU-dereferencing it internally. But that
> >     required including include/linux/cgroup-defs.h, which I wasn't sure is
> > ok with
> >     everyone.
> >
> > I guess including cgroup-defs.h/bpf-cgroup-defs.h into bpf.h might still
> > be somewhat problematic?
> >
> > But even if we pass the cgroup pointer, I'm assuming that this cgroup
> > pointer
> > is still rcu-managed, right? So the callers still have to rcu-lock.
> > However, in most places we don't care and do "cgrp =
> > sock_cgroup_ptr(&sk->sk_cgrp_data);"
> > but seems like it depends on the fact that sockets can't (yet?)
> > change their cgroup association and it's fine to not rcu-lock that
> > cgroup. Seems fragile, but ok.
> There is no __rcu tag in struct sock_cgroup_data, so presumably it
> won't change or a lock is needed ?  seems to be the former.
>
> > It always stumbles me when I see:
> >
> > cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > bpf_prog_run_array_cg_flags(cgrp.bpf->effective[atype], ...)
> >
> > But then, with current, it becomes:
> >
> > rcu_read_lock();
> > cgrp = task_dfl_cgroup(current);
> > bpf_prog_run_array_cg_flags(cgrp.bpf->effective[atype], ...)
> > rcu_read_unlock();
> >
> > Idk, I might be overthinking it. I'll try to see if including
> > bpf-cgroup-defs.h and passing cgroup_bpf is workable.
> yeah, passing cgroup_bpf and bpf-cgroup-defs.h is a better option.

+1. Daniel, would you be fine with this instead of explicit
rcu_read_lock()/rcu_read_unlock() everywhere?
