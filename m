Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADF2639F1C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 02:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiK1B6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 20:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK1B6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 20:58:03 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E535588;
        Sun, 27 Nov 2022 17:58:02 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a16so8668390pfg.4;
        Sun, 27 Nov 2022 17:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qe5hs8FVwx45grj4bepS5YGWgIaIZzpvoky/dPKEgAk=;
        b=TpscOfhnmXx5pu5TdPhBFc7zRC07xeXebnx+Y9ppmhZYFRHkldn7qCe6ojvHTNGJU5
         yfZ7a6rAKyzM8l7JTHp78PAiMDBaKEImvd0GA8o6MpXL0KeLnoofdor7TKoUGqrDeja3
         r49Fy2JPrJgz7U/hjsabD6BCnoo2AQPT2GZ1NAZhu3jxsM5endb1hglbbJ0qGhYYM7bX
         e5803Ljb5Bc5BfiXqGccsVhBt8Y4VCS0mguJkq/odVAnUtzgI98Ie1YfixHOEUPgINjB
         1T8qW/hDnDEdIhI5Lw1KMSl39i8klSdYMYCBmpZ1zX6pFJ0DaP0hGP+VUFFYrSdt0Z94
         5VgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qe5hs8FVwx45grj4bepS5YGWgIaIZzpvoky/dPKEgAk=;
        b=eN5b64gW4TKo3rfoTUTClnwxFTX14p/55DWS616YQILse13lgjtmF3Gs76/DuGxOSr
         7PocdpsyQT2hle+g6IGwV9fBKviNANs6k15vn71/tnTPPi7S1SSecNSq5yfeIKULrsfs
         3MOtNGqiHQ9Qr6jaeiT9Ei3Nmyf66AHw6QwLSsw/WNReE/sRITN+1GQHpJ1bhbBy8r4f
         W+H5jP46ufO1dX7Y/B/GGG24B2l/cJZfxnM5urkkfb1kHlpT/M7s7FdAOytY/ZoxVG8/
         i7Ej+KSzvhKX6MA8Wj+6UDKKRAmZ4B8sNt2ea0y4hxz844YvWYYAzA9ducBivfNpJhy7
         3QJg==
X-Gm-Message-State: ANoB5pmA4gA4LydD2QNN6kxbFQgV6wmanh5IkUTt53jLqygVOGovIKR/
        QqVU/0W+uMPeQCLPzboSZwA=
X-Google-Smtp-Source: AA0mqf6LnCWalB/CHpLF1Wy9qOn4snB2bh4yLi18Y4L4ZAcXtWAV8uvGpIw9WL/CvXIIWkiMytzgmw==
X-Received: by 2002:a63:902:0:b0:46e:9bb2:f0f7 with SMTP id 2-20020a630902000000b0046e9bb2f0f7mr26810278pgj.203.1669600681853;
        Sun, 27 Nov 2022 17:58:01 -0800 (PST)
Received: from MacBook-Pro-5.local ([2620:10d:c090:500::7:8561])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902904900b00187033cac81sm7452217plz.145.2022.11.27.17.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 17:58:01 -0800 (PST)
Date:   Sun, 27 Nov 2022 17:57:58 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, illusionist.neo@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, benjamin.tissoires@redhat.com, memxor@gmail.com,
        colin.i.king@gmail.com, asavkov@redhat.com, delyank@fb.com,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/4] bpf: Adapt 32-bit return value kfunc for
 32-bit ARM when zext extension
Message-ID: <20221128015758.aekybr3qlahfopwq@MacBook-Pro-5.local>
References: <20221126094530.226629-1-yangjihong1@huawei.com>
 <20221126094530.226629-2-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221126094530.226629-2-yangjihong1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 26, 2022 at 05:45:27PM +0800, Yang Jihong wrote:
> For ARM32 architecture, if data width of kfunc return value is 32 bits,
> need to do explicit zero extension for high 32-bit, insn_def_regno should
> return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
> opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.
> 
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>  kernel/bpf/verifier.c | 44 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 264b3dc714cc..193ea927aa69 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1927,6 +1927,21 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
>  		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_id_off);
>  }
>  
> +static int kfunc_desc_cmp_by_imm(const void *a, const void *b);
> +
> +static const struct bpf_kfunc_desc *
> +find_kfunc_desc_by_imm(const struct bpf_prog *prog, s32 imm)
> +{
> +	struct bpf_kfunc_desc desc = {
> +		.imm = imm,
> +	};
> +	struct bpf_kfunc_desc_tab *tab;
> +
> +	tab = prog->aux->kfunc_tab;
> +	return bsearch(&desc, tab->descs, tab->nr_descs,
> +		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_imm);
> +}
> +
>  static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
>  					 s16 offset)
>  {
> @@ -2342,6 +2357,13 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  			 */
>  			if (insn->src_reg == BPF_PSEUDO_CALL)
>  				return false;
> +
> +			/* Kfunc call will reach here because of insn_has_def32,
> +			 * conservatively return TRUE.
> +			 */
> +			if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
> +				return true;
> +
>  			/* Helper call will reach here because of arg type
>  			 * check, conservatively return TRUE.
>  			 */
> @@ -2405,10 +2427,26 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  }
>  
>  /* Return the regno defined by the insn, or -1. */
> -static int insn_def_regno(const struct bpf_insn *insn)
> +static int insn_def_regno(struct bpf_verifier_env *env, const struct bpf_insn *insn)
>  {
>  	switch (BPF_CLASS(insn->code)) {
>  	case BPF_JMP:
> +		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
> +			const struct bpf_kfunc_desc *desc;
> +
> +			/* The value of desc cannot be NULL */
> +			desc = find_kfunc_desc_by_imm(env->prog, insn->imm);
> +
> +			/* A kfunc can return void.
> +			 * The btf type of the kfunc's return value needs
> +			 * to be checked against "void" first
> +			 */
> +			if (desc->func_model.ret_size == 0)
> +				return -1;
> +			else
> +				return insn->dst_reg;
> +		}
> +		fallthrough;

I cannot make any sense of this patch.
insn->dst_reg above is 0.
The kfunc call doesn't define a register from insn_def_regno() pov.

Are you hacking insn_def_regno() to return 0 so that
if (WARN_ON(load_reg == -1)) {
  verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
  return -EFAULT;
}
in opt_subreg_zext_lo32_rnd_hi32() doesn't trigger ?

But this verifier message should have been a hint that you need
to analyze why zext_dst is set on this kfunc call.
Maybe it shouldn't ?
Did you analyze the logic of mark_btf_func_reg_size() ?

Before producing any patches please understand the logic fully.
Your commit log
"insn_def_regno should
 return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL."

Makes no sense to me, since dst_reg is unused in JMP insn.
There is no concept of a src or dst register in a JMP insn.

32-bit x86 supports calling kfuncs. See emit_kfunc_call().
And we don't have this "verifier bug. zext_dst is set" issue there, right?
But what you're saying in the commit log:
"if data width of kfunc return value is 32 bits"
should have been applicable to x86-32 as well.
So please start with a test that demonstrates the issue on x86-32 and
then we can discuss the way to fix it.

The patch 2 sort-of makes sense.

For patch 3 pls add new test funcs to bpf_testmod.
We will move all of them from net/bpf/test_run.c to bpf_testmod eventually.
