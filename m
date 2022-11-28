Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B8663ADFF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiK1QlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiK1QlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:41:17 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509C324F2B;
        Mon, 28 Nov 2022 08:41:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bj12so27224477ejb.13;
        Mon, 28 Nov 2022 08:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jjP+oHXKqqF5zS0C0EUDCrcK3pjIhLTSLdYwKHMtCFI=;
        b=iGq5qLooqXThwOwtjjiCIc1whgDj7Fx3WrYx9vSVSXBcxJ3GuwlzQIPU5VXEsBjR77
         fDDvRyZ1DRuZX6YctVtl0C+rBoeEp4ywwUuX2pb2RXdoljqOE7dJ4TJUAwZPeCeRlQNv
         ay5OWYNu71dcILiF50dEwUkhDwPjIm7xKJqF1bpJ1W82wKsQYlpqBxNXW2fMrmq8APhb
         mDV+ZqX0oJqI2d+8uw3uPOLAjw/4gLhvuxEwV+6HkI2TEtV9/PW97+/i1IwEuBvX5tX9
         k8fa3ZUPyUZN1icDJag1oJPqWBnI0gj2wVrS9Zcpcr9POf12LLMskzunUHxftXK+yq2X
         IGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjP+oHXKqqF5zS0C0EUDCrcK3pjIhLTSLdYwKHMtCFI=;
        b=6LC6eeZfeC7s6NvQyFAITsKDY22lfovd8iznTO5qc19M095T5qk+Zjxf8j6n9XFjAg
         KHvVvV5npXmHGOs5A/IH2ck5PJcEnMZBZerRnbzLSFvmj7w6ZwShAFcuQ1X7jfIuqahi
         xVh4viKjTAjLqvuIQTbLt4zTZF8hxH4s46psnKsDcYacnuMkBVPyva0Z+Tff4ntUrcLN
         M5gkGxorqGximySgFO9rfZx6xeRJz/yzxva/Nnb/yhBz0lOeKtaEYS8BbL5zdb07mVBQ
         4jhREg1EbVheZg9g28Z5lJ4HGhP8dFSFWgokXi32C8WK+BRWq/wpV7QCYyf4W0lnbWsH
         +9bQ==
X-Gm-Message-State: ANoB5pmxK65RMzWdCkKgdCbRDFhKkPOAoCi2sBvS7sFTQ1OcEbt6vDhE
        VAuHkggnkKTgc55xAo0R8YDoi7D28ECJt9/mmzw=
X-Google-Smtp-Source: AA0mqf735MuN6EN0Omhyiib0Dnmqfd9HCeKNrPRRs/0daz9C8xf3gRuYxVttE1AuXtqljIpfwHGWZ3dAM/t1Z++7Qv4=
X-Received: by 2002:a17:907:76e6:b0:7c0:543a:5229 with SMTP id
 kg6-20020a17090776e600b007c0543a5229mr3755504ejc.58.1669653674591; Mon, 28
 Nov 2022 08:41:14 -0800 (PST)
MIME-Version: 1.0
References: <20221126094530.226629-1-yangjihong1@huawei.com>
 <20221126094530.226629-2-yangjihong1@huawei.com> <20221128015758.aekybr3qlahfopwq@MacBook-Pro-5.local>
 <dc9d1823-80f2-e2d9-39a8-c39b6f52dec5@huawei.com>
In-Reply-To: <dc9d1823-80f2-e2d9-39a8-c39b6f52dec5@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 28 Nov 2022 08:41:03 -0800
Message-ID: <CAADnVQJPRCnESmJ92W39bo-btqNbYaNsGQO0is6FD3JLU_mSjQ@mail.gmail.com>
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

On Mon, Nov 28, 2022 at 4:40 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>
>
>
> On 2022/11/28 9:57, Alexei Starovoitov wrote:
> > On Sat, Nov 26, 2022 at 05:45:27PM +0800, Yang Jihong wrote:
> >> For ARM32 architecture, if data width of kfunc return value is 32 bits,
> >> need to do explicit zero extension for high 32-bit, insn_def_regno should
> >> return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
> >> opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.
> >>
> >> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> >> ---
> >>   kernel/bpf/verifier.c | 44 ++++++++++++++++++++++++++++++++++++++++---
> >>   1 file changed, 41 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index 264b3dc714cc..193ea927aa69 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -1927,6 +1927,21 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
> >>                     sizeof(tab->descs[0]), kfunc_desc_cmp_by_id_off);
> >>   }
> >>
> >> +static int kfunc_desc_cmp_by_imm(const void *a, const void *b);
> >> +
> >> +static const struct bpf_kfunc_desc *
> >> +find_kfunc_desc_by_imm(const struct bpf_prog *prog, s32 imm)
> >> +{
> >> +    struct bpf_kfunc_desc desc = {
> >> +            .imm = imm,
> >> +    };
> >> +    struct bpf_kfunc_desc_tab *tab;
> >> +
> >> +    tab = prog->aux->kfunc_tab;
> >> +    return bsearch(&desc, tab->descs, tab->nr_descs,
> >> +                   sizeof(tab->descs[0]), kfunc_desc_cmp_by_imm);
> >> +}
> >> +
> >>   static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
> >>                                       s16 offset)
> >>   {
> >> @@ -2342,6 +2357,13 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >>                       */
> >>                      if (insn->src_reg == BPF_PSEUDO_CALL)
> >>                              return false;
> >> +
> >> +                    /* Kfunc call will reach here because of insn_has_def32,
> >> +                     * conservatively return TRUE.
> >> +                     */
> >> +                    if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
> >> +                            return true;
> >> +
> >>                      /* Helper call will reach here because of arg type
> >>                       * check, conservatively return TRUE.
> >>                       */
> >> @@ -2405,10 +2427,26 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >>   }
> >>
> >>   /* Return the regno defined by the insn, or -1. */
> >> -static int insn_def_regno(const struct bpf_insn *insn)
> >> +static int insn_def_regno(struct bpf_verifier_env *env, const struct bpf_insn *insn)
> >>   {
> >>      switch (BPF_CLASS(insn->code)) {
> >>      case BPF_JMP:
> >> +            if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
> >> +                    const struct bpf_kfunc_desc *desc;
> >> +
> >> +                    /* The value of desc cannot be NULL */
> >> +                    desc = find_kfunc_desc_by_imm(env->prog, insn->imm);
> >> +
> >> +                    /* A kfunc can return void.
> >> +                     * The btf type of the kfunc's return value needs
> >> +                     * to be checked against "void" first
> >> +                     */
> >> +                    if (desc->func_model.ret_size == 0)
> >> +                            return -1;
> >> +                    else
> >> +                            return insn->dst_reg;
> >> +            }
> >> +            fallthrough;
> >
> > I cannot make any sense of this patch.
> > insn->dst_reg above is 0.
> > The kfunc call doesn't define a register from insn_def_regno() pov.
> >
> > Are you hacking insn_def_regno() to return 0 so that
> > if (WARN_ON(load_reg == -1)) {
> >    verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
> >    return -EFAULT;
> > }
> > in opt_subreg_zext_lo32_rnd_hi32() doesn't trigger ?
> >
> > But this verifier message should have been a hint that you need
> > to analyze why zext_dst is set on this kfunc call.
> > Maybe it shouldn't ?
> > Did you analyze the logic of mark_btf_func_reg_size() ?
> make r0 zext is not caused by mark_btf_func_reg_size.
>
> This problem occurs when running the kfunc_call_test_ref_btf_id test
> case in the 32-bit ARM environment.

Why is it not failing on x86-32 ?

> The bpf prog is as follows:
> int kfunc_call_test_ref_btf_id(struct __sk_buff *skb)
> {
> struct prog_test_ref_kfunc *pt;
> unsigned long s = 0;
> int ret = 0;
>
> pt = bpf_kfunc_call_test_acquire(&s);
> if (pt) {
>       // here, do_check clears the upper 32bits of r0 through:
>       // check_alu_op
>       //   ->check_reg_arg
>       //    ->mark_insn_zext
> if (pt->a != 42 || pt->b != 108)
> ret = -1;
> bpf_kfunc_call_test_release(pt);
> }
> return ret;
> }
>
> >
> > Before producing any patches please understand the logic fully.
> > Your commit log
> > "insn_def_regno should
> >   return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL."
> >
> > Makes no sense to me, since dst_reg is unused in JMP insn.
> > There is no concept of a src or dst register in a JMP insn.
> >
> > 32-bit x86 supports calling kfuncs. See emit_kfunc_call().
> > And we don't have this "verifier bug. zext_dst is set" issue there, right?
> > But what you're saying in the commit log:
> > "if data width of kfunc return value is 32 bits"
> > should have been applicable to x86-32 as well.
> > So please start with a test that demonstrates the issue on x86-32 and
> > then we can discuss the way to fix it.
> >
> > The patch 2 sort-of makes sense.
> >
> > For patch 3 pls add new test funcs to bpf_testmod.
> > We will move all of them from net/bpf/test_run.c to bpf_testmod eventually.
> > .
> >
