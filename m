Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29386417D2
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 17:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLCQk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 11:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLCQk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 11:40:56 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBC01FCD2;
        Sat,  3 Dec 2022 08:40:54 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l11so10293964edb.4;
        Sat, 03 Dec 2022 08:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LQ8xubanzd9+YmlzrGLsTJHNMcl91Ughdo9/l+FSuMM=;
        b=hiY3HcrHTc3T2Oy7z7Tj94uZbex9hv4uZ8RdWdocPqJJ3JrlvPjas0gykuLomSXAbO
         IWOmQSX4LMYYWtTZ1CacLVMD7c84cCa7h4ylhirAXzjVmWxRgNQsCKGfBemrqbIsHrgL
         DwHiR0sJJgpwnLiwFD+vQOEP8MwvxxAhvw/9MIL/sNtwLlPEcAuAhHckHERutyU5PuVB
         RLxLScIOFmKMwRCoTjNoJKP4mxXCbIcaTyON0/pTw1MfzNKjPN3UlrPTODnDs0aSagCb
         hVK2lX+vulXKUVwDflC5uLOZ4fNe58A0OgzpHbcHwiebSknNt5MsDGclTYvdPFw/YfOt
         0tKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQ8xubanzd9+YmlzrGLsTJHNMcl91Ughdo9/l+FSuMM=;
        b=YnYu0/NrdZXjLrXXpFoX96B6MwYLYJijXkGUD9jYs+oYuMR56h5qMJ4wNyC3hHKFKZ
         6/wR91i7rlcZhoY2beiGJ+/SvxF8vck7fiX6QVGsVW/YcsDXhE9Zr4K6xH1XEbhLFC2v
         tdakiEE0jHQmsg3x/CqgevCQ30Qx16Yglwgj+w/e/lBoTUsMDxHIiTeg1Au+VJidXaKY
         QmqRqPIeSHVmzPFxSLMjUjsVIeG3CORjNMw5uyz94KCvSMLCnUdf4I5fyy0pqR1MejUX
         W01SD8CbTSyY55HvxtWuvaV/LXLvViIQCIQ5Ctz2ROpLnrUmbDha+s4WCUW6gDd7aiMl
         iOLw==
X-Gm-Message-State: ANoB5pkcA0psZLvGNXCG/HEOCBo1B5YcY6EVQDC7RY5xTWt2QVeYYrK2
        KiYBaZNKUzY890haOSPWZTA63jOyxjAZDd+HYhE=
X-Google-Smtp-Source: AA0mqf4Fw05PxBvulQnp1D6VoFF5JChDHkFZuOW2NiyjEVA5vYEc30GGZtqJod+PxyqLMHFYYJGccX0aEIHnfwS1zzg=
X-Received: by 2002:a05:6402:5289:b0:462:70ee:fdb8 with SMTP id
 en9-20020a056402528900b0046270eefdb8mr33646016edb.66.1670085651954; Sat, 03
 Dec 2022 08:40:51 -0800 (PST)
MIME-Version: 1.0
References: <20221126094530.226629-1-yangjihong1@huawei.com>
 <20221126094530.226629-2-yangjihong1@huawei.com> <20221128015758.aekybr3qlahfopwq@MacBook-Pro-5.local>
 <dc9d1823-80f2-e2d9-39a8-c39b6f52dec5@huawei.com> <CAADnVQJPRCnESmJ92W39bo-btqNbYaNsGQO0is6FD3JLU_mSjQ@mail.gmail.com>
 <8cb54255-4dce-6d50-d6f0-ac9af0e56f37@huawei.com>
In-Reply-To: <8cb54255-4dce-6d50-d6f0-ac9af0e56f37@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 3 Dec 2022 08:40:40 -0800
Message-ID: <CAADnVQJXr6XxpG2E-AkO7__qg-sujrhyO+JWWa1iwYmAO4S0Pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/4] bpf: Adapt 32-bit return value kfunc for
 32-bit ARM when zext extension
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        colin.i.king@gmail.com, Artem Savkov <asavkov@redhat.com>,
        Delyan Kratunov <delyank@fb.com>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 2, 2022 at 6:58 PM Yang Jihong <yangjihong1@huawei.com> wrote:
>
>
>
> On 2022/11/29 0:41, Alexei Starovoitov wrote:
> > On Mon, Nov 28, 2022 at 4:40 AM Yang Jihong <yangjihong1@huawei.com> wrote:
> >>
> >>
> >>
> >> On 2022/11/28 9:57, Alexei Starovoitov wrote:
> >>> On Sat, Nov 26, 2022 at 05:45:27PM +0800, Yang Jihong wrote:
> >>>> For ARM32 architecture, if data width of kfunc return value is 32 bits,
> >>>> need to do explicit zero extension for high 32-bit, insn_def_regno should
> >>>> return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
> >>>> opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.
> >>>>
> >>>> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> >>>> ---
> >>>>    kernel/bpf/verifier.c | 44 ++++++++++++++++++++++++++++++++++++++++---
> >>>>    1 file changed, 41 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>> index 264b3dc714cc..193ea927aa69 100644
> >>>> --- a/kernel/bpf/verifier.c
> >>>> +++ b/kernel/bpf/verifier.c
> >>>> @@ -1927,6 +1927,21 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
> >>>>                      sizeof(tab->descs[0]), kfunc_desc_cmp_by_id_off);
> >>>>    }
> >>>>
> >>>> +static int kfunc_desc_cmp_by_imm(const void *a, const void *b);
> >>>> +
> >>>> +static const struct bpf_kfunc_desc *
> >>>> +find_kfunc_desc_by_imm(const struct bpf_prog *prog, s32 imm)
> >>>> +{
> >>>> +    struct bpf_kfunc_desc desc = {
> >>>> +            .imm = imm,
> >>>> +    };
> >>>> +    struct bpf_kfunc_desc_tab *tab;
> >>>> +
> >>>> +    tab = prog->aux->kfunc_tab;
> >>>> +    return bsearch(&desc, tab->descs, tab->nr_descs,
> >>>> +                   sizeof(tab->descs[0]), kfunc_desc_cmp_by_imm);
> >>>> +}
> >>>> +
> >>>>    static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
> >>>>                                        s16 offset)
> >>>>    {
> >>>> @@ -2342,6 +2357,13 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >>>>                        */
> >>>>                       if (insn->src_reg == BPF_PSEUDO_CALL)
> >>>>                               return false;
> >>>> +
> >>>> +                    /* Kfunc call will reach here because of insn_has_def32,
> >>>> +                     * conservatively return TRUE.
> >>>> +                     */
> >>>> +                    if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
> >>>> +                            return true;
> >>>> +
> >>>>                       /* Helper call will reach here because of arg type
> >>>>                        * check, conservatively return TRUE.
> >>>>                        */
> >>>> @@ -2405,10 +2427,26 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >>>>    }
> >>>>
> >>>>    /* Return the regno defined by the insn, or -1. */
> >>>> -static int insn_def_regno(const struct bpf_insn *insn)
> >>>> +static int insn_def_regno(struct bpf_verifier_env *env, const struct bpf_insn *insn)
> >>>>    {
> >>>>       switch (BPF_CLASS(insn->code)) {
> >>>>       case BPF_JMP:
> >>>> +            if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
> >>>> +                    const struct bpf_kfunc_desc *desc;
> >>>> +
> >>>> +                    /* The value of desc cannot be NULL */
> >>>> +                    desc = find_kfunc_desc_by_imm(env->prog, insn->imm);
> >>>> +
> >>>> +                    /* A kfunc can return void.
> >>>> +                     * The btf type of the kfunc's return value needs
> >>>> +                     * to be checked against "void" first
> >>>> +                     */
> >>>> +                    if (desc->func_model.ret_size == 0)
> >>>> +                            return -1;
> >>>> +                    else
> >>>> +                            return insn->dst_reg;
> >>>> +            }
> >>>> +            fallthrough;
> >>>
> >>> I cannot make any sense of this patch.
> >>> insn->dst_reg above is 0.
> >>> The kfunc call doesn't define a register from insn_def_regno() pov.
> >>>
> >>> Are you hacking insn_def_regno() to return 0 so that
> >>> if (WARN_ON(load_reg == -1)) {
> >>>     verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
> >>>     return -EFAULT;
> >>> }
> >>> in opt_subreg_zext_lo32_rnd_hi32() doesn't trigger ?
> >>>
> >>> But this verifier message should have been a hint that you need
> >>> to analyze why zext_dst is set on this kfunc call.
> >>> Maybe it shouldn't ?
> >>> Did you analyze the logic of mark_btf_func_reg_size() ?
> >> make r0 zext is not caused by mark_btf_func_reg_size.
> >>
> >> This problem occurs when running the kfunc_call_test_ref_btf_id test
> >> case in the 32-bit ARM environment.
> >
> > Why is it not failing on x86-32 ?
> Use the latest mainline kernel code to test on the x86_32 machine. The
> test also fails:
>
>    # ./test_progs -t kfunc_call/kfunc_call_test_ref_btf_id
>    Failed to load bpf_testmod.ko into the kernel: -8
>    WARNING! Selftests relying on bpf_testmod.ko will be skipped.
>    libbpf: prog 'kfunc_call_test_ref_btf_id': BPF program load failed:
> Bad address
>    libbpf: prog 'kfunc_call_test_ref_btf_id': -- BEGIN PROG LOAD LOG --
>    processed 25 insns (limit 1000000) max_states_per_insn 0 total_states
> 2 peak_states 2 mark_read 1
>    -- END PROG LOAD LOG --
>    libbpf: prog 'kfunc_call_test_ref_btf_id': failed to load: -14
>    libbpf: failed to load object 'kfunc_call_test'
>    libbpf: failed to load BPF skeleton 'kfunc_call_test': -14
>    verify_success:FAIL:skel unexpected error: -14
>
> Therefore, this problem also exists on x86_32:
> "verifier bug. zext_dst is set, but no reg is defined"

The kernel returns -14 == EFAULT.
That's a completely different issue.
