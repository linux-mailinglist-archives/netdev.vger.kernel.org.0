Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1816B3601
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCJFMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCJFMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:12:51 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92482E1910
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:12:34 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q189so2399328pga.9
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678425154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SITOzkH6L88pZqDAhqMy9DEvC8US1EB8vqjavUCwyfs=;
        b=VHV67Ol5jS9AgyWnrNQmDPR/QJW/YpWWQOGgW6HuuVzGlym55tGN14z6r3JRpNizAA
         POJ0mH7HqHCHQd8RX89MLvD7YZQSVsKJN5u4ozcGXPOCYmA52JvTrIIjzOcSZrhby1zA
         Y8iTe5W5POxWJz0SxQIRcO4qn8ut/PN5KhorbO7419OfWzj22zk94+/ll4EY2Eaydec4
         y89LH/qstI8XZURakDaz4a6VYk81IYMM/OayjLvQmMTXUCQflxIN7Uhi8BgWcacL4L2l
         fipT2RHZvW2RZc03p8a2poyf+MqSt2QwqpiucL5Tz/44vPFq7KQ3n8dTwyYwill2CzUr
         17AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678425154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SITOzkH6L88pZqDAhqMy9DEvC8US1EB8vqjavUCwyfs=;
        b=ZpSln+jQ6aZls5vuslScMsOw+nVvI4JCGbYyzzwYnfN3VdUA7TUw7p4gdJOCRSv7oV
         nhNeujw6Ki+r4N0Nw8dXbDDsxY/nZmIImMfSxkW0748YYz8os6yOF7bN1FMCUX7xh1B5
         edeh7rVHoqsLHKqUutNTRW+/XfrXcvqPjDNqFpMCZcEX2pN6Am/pSEw9Q1FTDZFuxcnm
         QTdKgwCsQqGyPkrfbug3ZettK9saeqgRzT9s8uFuWkSm2vkcIeWjT58E3u5FHRh2cLLT
         glGYeEw1pSOsver0TaAYa2UFvXE71+uTY+RGoOB7Newdvn0mELRr43IYge0hYBMiwYk9
         0SAA==
X-Gm-Message-State: AO0yUKXfNoIsg0LauRHDCdgRQuvuSSkWqRJpWLcYLCgTHVsAWx04LOIk
        jVgXZlS5XFV3LdgfstxP/J0Mt7eGYeByQ66tUIrXig==
X-Google-Smtp-Source: AK7set9+GxoPfXeWOCYjdjvMXg/Tdn8ugqQpGUobbka5pP7uhm5ExBPVHL2WuazMI5FHI61aqdpnQzWpCKu+/LztVm8=
X-Received: by 2002:a63:7242:0:b0:507:3e33:43e3 with SMTP id
 c2-20020a637242000000b005073e3343e3mr5964544pgn.7.1678425153735; Thu, 09 Mar
 2023 21:12:33 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-11-joannelkoong@gmail.com> <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
 <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
 <20230308015500.6pycr5i4nynyu22n@heavy> <CAJnrk1Y1ONmEJpwDqGzCUmyrkDf9s_HpDhR5mW=6fNKM6PiXew@mail.gmail.com>
 <c27727cfabced2b9207eabbba71bed158ca35eec.camel@linux.ibm.com>
 <CAJnrk1Za8KaAq4=v7X=YEHRu5jc3upR059AcY9eanr-v_9VSqg@mail.gmail.com> <67a28d535a91396a20e7fb5ff4c322395c947eb8.camel@linux.ibm.com>
In-Reply-To: <67a28d535a91396a20e7fb5ff4c322395c947eb8.camel@linux.ibm.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 9 Mar 2023 21:12:22 -0800
Message-ID: <CAKH8qBvv5EkKvMuZV_k9GWA+rAgx=M4ndiQDn5Jg8h0Qtc5SLg@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 7:40=E2=80=AFPM Ilya Leoshkevich <iii@linux.ibm.com>=
 wrote:
>
> On Thu, 2023-03-09 at 00:13 -0800, Joanne Koong wrote:
> > On Wed, Mar 8, 2023 at 6:24=E2=80=AFAM Ilya Leoshkevich <iii@linux.ibm.=
com>
> > wrote:
> > >
> > > On Tue, 2023-03-07 at 23:22 -0800, Joanne Koong wrote:
> > > > On Tue, Mar 7, 2023 at 5:55=E2=80=AFPM Ilya Leoshkevich
> > > > <iii@linux.ibm.com>
> > > > wrote:
> > > > >
> > > > > On Wed, Mar 01, 2023 at 08:28:40PM -0800, Joanne Koong wrote:
> > > > > > On Wed, Mar 1, 2023 at 10:08=E2=80=AFAM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > > On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong
> > > > > > > <joannelkoong@gmail.com> wrote:
> > > > > > > >
> > > > > > > > 5) progs/dynptr_success.c
> > > > > > > >    * Add test case "test_skb_readonly" for testing
> > > > > > > > attempts
> > > > > > > > at writes
> > > > > > > >      on a prog type with read-only skb ctx.
> > > > > > > >    * Add "test_dynptr_skb_data" for testing that
> > > > > > > > bpf_dynptr_data isn't
> > > > > > > >      supported for skb progs.
> > > > > > >
> > > > > > > I added
> > > > > > > +dynptr/test_dynptr_skb_data
> > > > > > > +dynptr/test_skb_readonly
> > > > > > > to DENYLIST.s390x and applied.
> > > > > >
> > > > > > Thanks, I'm still not sure why s390x cannot load these
> > > > > > programs.
> > > > > > It is
> > > > > > being loaded in the same way as other tests like
> > > > > > test_parse_tcp_hdr_opt() are loading programs. I will keep
> > > > > > looking
> > > > > > some more into this
> > > > >
> > > > > Hi,
> > > > >
> > > > > I believe the culprit is:
> > > > >
> > > > >     insn->imm =3D BPF_CALL_IMM(bpf_dynptr_from_skb_rdonly);
> > > > >
> > > > > s390x needs to know the kfunc model in order to emit the call
> > > > > (like
> > > > > i386), but after this assignment it's no longer possible to
> > > > > look it
> > > > > up in kfunc_tab by insn->imm. x86_64 does not need this,
> > > > > because
> > > > > its
> > > > > ABI is exactly the same as BPF ABI.
> > > > >
> > > > > The simplest solution seems to be adding an artificial
> > > > > kfunc_desc
> > > > > like this:
> > > > >
> > > > >     {
> > > > >         .func_model =3D desc->func_model,  /* model must be
> > > > > compatible */
> > > > >         .func_id =3D 0,                    /* unused at this
> > > > > point */
> > > > >         .imm =3D insn->imm,                /* new target */
> > > > >         .offset =3D 0,                     /* unused at this
> > > > > point */
> > > > >     }
> > > > >
> > > > > here and also after this assignment:
> > > > >
> > > > >     insn->imm =3D BPF_CALL_IMM(xdp_kfunc);
> > > > >
> > > > > What do you think?
> > > >
> > > > Ohh interesting! This makes sense to me. In particular, you're
> > > > referring to the bpf_jit_find_kfunc_model() call in
> > > > bpf_jit_insn()
> > > > (in
> > > > arch/s390/net/bpf_jit_comp.c) as the one that fails out whenever
> > > > insn->imm gets set, correct?
> > >
> > > Precisely.
> > >
> > > > I like your proposed solution, I agree that this looks like the
> > > > simplest, though maybe we should replace the existing kfunc_desc
> > > > instead of adding it so we don't have to deal with the edge case
> > > > of
> > > > reaching MAX_KFUNC_DESCS? To get the func model of the new insn-
> > > > >imm,
> > >
> > > I wonder whether replacement is safe? This would depend on the
> > > following functions returning the same value for the same inputs:
> > >
> > > - may_access_direct_pkt_data() - this looks ok;
> > > - bpf_dev_bound_resolve_kfunc() - I'm not so sure, any insights?
> >
> > For the bpf_dev_bound_resolve_kfunc() case (in fixup_kfunc_call()), I
> > think directly replacing the kfunc_desc here is okay because
> > bpf_dev_bound_resolve_kfunc() is findingthe target device-specific
> > version of the kfunc (if it exists) to replace the generic version of
> > the kfunc with, and we're using that target device-specific version
> > of
> > the kfunc as the new updated insn->imm to call
>
> I'm worried that its return value is going to change while we are
> doing the rewriting. It looks as if
> __bpf_offload_dev_netdev_unregister() can cause this. So if we have
> two instructions that use the same generic kfunc, they may end up
> pointing to two different device-specific kfuncs, and the kfunc_tab
> will contain only one of the two.
>
> This sounds dangerous, but maybe I don't see some safeguard that
> already prevents or mitigates the effects of this?
>
> Stanislav, could you as the bpf_dev_bound_resolve_kfunc() author
> give your opinion please? I've seen your comment:
>
> +       /* We don't hold bpf_devs_lock while resolving several
> +        * kfuncs and can race with the unregister_netdevice().
> +        * We rely on bpf_dev_bound_match() check at attach
> +        * to render this program unusable.
> +        */
>
> and I'm wondering whether you meant bpf_prog_dev_bound_match(), and
> whether it protects against the ABA problem, i.e., if
> __bpf_offload_dev_netdev_unregister() is called twice, and we get
> aux->offload and aux->offload->netdev at the same addresses?

Yes, the comment is talking about bpf_prog_dev_bound_match during attach ti=
me.
When __bpf_offload_dev_netdev_unregister races with our prog load
(which is being loaded for some specific netdev),
bpf_prog_dev_bound_match check during attach time should render this
program un-attach-able / unusable (since the original netdev, for
which this prog has been loaded, is gone).

But going back to s390 issue: so basically, rewriting imm for kfuncs
early in the verifier prevents jit from being able to call
bpf_jit_find_kfunc_model? Did I get that correctly?
Adding kfunc_desc seems like a nice hack, but I liked your previous
series which pushed that imm resolution down to the jits better :-(
For the xdp_kfunc case though, if you were to go the extra kfunc_desc
route, adding the one that it's been resolved to is fine. If we race
with __bpf_offload_dev_netdev_unregister, the prog will be unusable
anyway (due to that dev_bound_match check); so if it fails ealer
somewhere in the jit - doesn't seem like a big deal to me. Hope that
helps.

> > > If it's not, then MAX_KFUNC_DESCS indeed becomes a concern.
> > >
> > > > it seems pretty straightforward, it looks like we can just use
> > > > btf_distill_func_proto(). or call add_kfunc_call() directly,
> > > > which
> > > > would do everything needed, but adds an additional unnecessary
> > > > sort
> > > > and more overhead for replacing (eg we'd need to first swap the
> > > > old
> > > > kfunc_desc with the last tab->descs[tab->nr_descs] entry and then
> > > > delete the old kfunc_desc before adding the new one). What are
> > > > your
> > > > thoughts?
> > >
> > > Is there a way to find BTF by function pointer?
> > > IIUC bpf_dev_bound_resolve_kfunc() can return many different
> > > things,
> > > and btf_distill_func_proto() and add_kfunc_call() need BTF.
> > > A straightforward way that immediately comes to mind is to do
> > > kallsyms
> > > lookup and then resolve by name, but this sounds clumsy.
> > >
> >
> > I'm not sure whether there's a way to find the function's BTF by its
> > pointer, but I think maybe we can use the vmlinux btf (which we can
> > get through the bpf_get_btf_vmlinux() api) to get the func proto?
>
> The device-specific function may come from a kernel module (e.g.,
> veth). But on second thought we don't need this at all; we should
> really just take func_model of the generic function, that we already
> have. If it is not the same as the model of the device-specific
> function, it must be a bug.
>
> > > I've been looking into this in context of fixing (kfunc
> > > __bpf_call_base) not fitting into 32 bits on s390x. A solution that
> >
> > Sorry, I'm not fully understanding - can you elaborate a little on
> > what the issue is? why doesn't the __bpf_call_base address fit on
> > s390x? my understanding is that s390x is a 64-bit architecture?
>
> On s390x modules and kernel are far away from each other, so
> BPF_CALL_IMM() may return ~40 significant bits. This makes the
> insn->imm rewriting trick unusable, because insn->imm is just 32 bits
> and cannot be extended. There is even a safeguard against this in
> add_kfunc_call() ("address of kernel function %s is out of range"
> check).
>
> I had a patch that kept BTF ID in insn->imm, but it was decided that
> since it required adjusting several JITs, we should not be doing it.
>
> When the s390x JIT sees a kfunc call, it needs to find the respective
> kfunc's address and model. Normally this is done using kfunc_tab
> lookup. kfunc_tab is indexed by insn->imm values, which we cannot use
> for reasons outlined above. Hence the idea below: create another
> (unfortunately much less memory-efficient) kfunc_tab indexed by insn
> numbers.
>
> Conveniently, this would also solve the problem that we are seeing
> here.
>
> > > would solve both problems that I'm currently thinking about is to
> > > associate
> > >
> > > struct {
> > >     struct btf_func_model *m;
> > >     unsigned long addr;
> > > } kfunc_callee;
> > >
> > > with every insn - during verification it could live in
> > > bpf_insn_aux_data, during jiting in bpf_prog, and afterwards it can
> > > be freed. Any thoughts about this?
>
