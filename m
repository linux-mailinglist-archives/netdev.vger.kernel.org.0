Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE312764C7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 01:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIWXyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 19:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWXyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 19:54:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC5FC0613CE;
        Wed, 23 Sep 2020 16:54:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so582237pjb.0;
        Wed, 23 Sep 2020 16:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zvclOKBel47+J/CodBKVbxJC0ysdFRFSxr6Rq7511+M=;
        b=jIv4YS5gE80rvHyzf7RxkEATH3MF/RHwybjjD1t5tckkG0nbiiuI26B7MoCnwf/Gu2
         0oGSkqAv3ersGogoWBZCH/b1jchKhiH6b2E6L7MktYCpoIc2+J1Fitg+lPC58qt1a0S/
         dHXWDMW7A8QzVPJMbHdmtzhuNiZVJ15aCiLx0HkM2mInaHFx8XhVr1eSaXT1JZX6hW8G
         URPFO9dn8PxPkqS6bSHdGNHgYQJBi8HGNURfcTxnNIc4umPuzpxyRHZupDxnxhy/F4dr
         qZ6p1ghSu7YHZSxZzEylfA1ZpJQkjyfwPBWa8fFgQXPzWLbu89GE1gW7lYgoQC31/JZL
         w/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zvclOKBel47+J/CodBKVbxJC0ysdFRFSxr6Rq7511+M=;
        b=Un2uj8f3PMaSnqHJK5O834IHbcH5p5gyats01Xsjd7OuDUPy/tphxiUTbcfIdkUs5b
         hyJcuIffghhRlcfAAg+HvSZY/gB5CXsMMLaijWpZtm+4IDfam5PtcqvqzlUZHQnXq3tW
         umAnhobIsWLG61z1tLOR1cMrfe1peLAqYqg6coTn3eQuN1FhDPHRLypt7eblexwLuy6J
         COXmiFguKv1NzSM/fO0mlnRm61aKgQqUXKlcP3fTJXAQsicW/6SlRNMF0AXeZ19Id+if
         dBsWeYIxTy2tVy95St3AYu5ITAMXlX96copjg/Cdt27puZGkxBtvxtmlM8s/7QEhu8A6
         Sa1g==
X-Gm-Message-State: AOAM530gRidIkQiXzc/fYLEkVPjbgi8n+C5iTFtRLVnt/rbDV58VVi4V
        HItv3oR2hlk8aVWJCMVlEzE=
X-Google-Smtp-Source: ABdhPJyxHfdkd1TBVMN6LiD8a+H3Kgpk4VV53bbxny/o1dwdCJyZ9HWlHAYL1/Tra5yvf8wyIdFBXw==
X-Received: by 2002:a17:90a:f3d1:: with SMTP id ha17mr1484458pjb.231.1600905282665;
        Wed, 23 Sep 2020 16:54:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1807])
        by smtp.gmail.com with ESMTPSA id n67sm858118pgn.14.2020.09.23.16.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 16:54:41 -0700 (PDT)
Date:   Wed, 23 Sep 2020 16:54:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 03/11] bpf: verifier: refactor
 check_attach_btf_id()
Message-ID: <20200923235439.bdi43f3znff67o3n@ast-mbp.dhcp.thefacebook.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991702.8301.18141427563623823055.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160079991702.8301.18141427563623823055.stgit@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 08:38:37PM +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The check_attach_btf_id() function really does three things:
> 
> 1. It performs a bunch of checks on the program to ensure that the
>    attachment is valid.
> 
> 2. It stores a bunch of state about the attachment being requested in
>    the verifier environment and struct bpf_prog objects.
> 
> 3. It allocates a trampoline for the attachment.
> 
> This patch splits out (1.) and (3.) into separate functions in preparation
> for reusing them when the actual attachment is happening (in the
> raw_tracepoint_open syscall operation), which will allow tracing programs
> to have multiple (compatible) attachments.

raw_tp_open part is no longer correct.

Also could you re-phrase it that 'stores a bunch of state about the attechment'
is still the case. It doesn't store into bpf_prog directly, but returns instead.

> This also fixes a bug where a bunch of checks were skipped if a trampoline
> already existed for the tracing target.

This time we were lucky. When you see such selftests failures please debug
them before submitting the patches. The reviewers should not be pointing out
that the patch broke some tests.
If anything breaks please mention it in the cover letter.

> -static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
> +static int check_attach_modify_return(const struct bpf_prog *prog, unsigned long addr,
> +				      const char *func_name)

Since you're adding 'func_name' why keep 'prog' there? Pls drop it.

>  {
>  	if (within_error_injection_list(addr) ||
> -	    !strncmp(SECURITY_PREFIX, prog->aux->attach_func_name,
> -		     sizeof(SECURITY_PREFIX) - 1))
> +	    !strncmp(SECURITY_PREFIX, func_name, sizeof(SECURITY_PREFIX) - 1))
>  		return 0;
>  
>  	return -EINVAL;
> @@ -11215,43 +11215,29 @@ static int check_non_sleepable_error_inject(u32 btf_id)
>  	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
>  }
>  
> -static int check_attach_btf_id(struct bpf_verifier_env *env)
> +int bpf_check_attach_target(struct bpf_verifier_log *log,
> +			    const struct bpf_prog *prog,
> +			    const struct bpf_prog *tgt_prog,
> +			    u32 btf_id,
> +			    struct btf_func_model *fmodel,
> +			    long *tgt_addr,
> +			    const char **tgt_name,
> +			    const struct btf_type **tgt_type)

How about grouping the return args into
struct bpf_attach_target_info {
 struct btf_func_model fmodel;
 long tgt_addr;
 const char *tgt_name;
 const struct btf_type *tgt_type;
};
allocate it on stack in the caller and pass a pointer into this function?

The same way pass the whole &bpf_attach_target_info into bpf_trampoline_get().
It will use fmodel and tgt_addr out of it, but it doesn't hurt to pass
the whole thing.

Overall I like the refactoring, but this prototype and conditional
if (tgt_name) *tgt_name =; and if (tgt_type) makes it harder to comprehend.

>  		if (!tgt_prog->jited) {
>  			bpf_log(log, "Can attach to only JITed progs\n");
> @@ -11328,13 +11312,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>  			bpf_log(log, "Cannot extend fentry/fexit\n");
>  			return -EINVAL;
>  		}
> -		key = ((u64)aux->id) << 32 | btf_id;

Could you please refactor key computation into a helper as well?
Especially since it will be used out of verifier.c and from syscall.c.
Something like this for bpf.h
static inline u64 bpf_trampoline_compute_key(struct bpf_prog *tgt_prog, u32 btf_id)
{
        if (tgt_prog) {
                return ((u64)tgt_prog->aux->id) << 32 | btf_id;
        } else {
                return btf_id;
        }
}

> +	ret = bpf_check_attach_target(&env->log, prog, tgt_prog, btf_id,
> +				      &fmodel, &addr, &tname, &t);
> +	if (ret)
>  		return ret;
> +
> +	if (tgt_prog) {
> +		if (prog->type == BPF_PROG_TYPE_EXT) {
> +			env->ops = bpf_verifier_ops[tgt_prog->type];
> +			prog->expected_attach_type =
> +				tgt_prog->expected_attach_type;
> +		}
> +		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;
> +	} else {
> +		key = btf_id;
>  	}

and here it would be:
if (tgt_prog && prog->type == BPF_PROG_TYPE_EXT) {
	env->ops = bpf_verifier_ops[tgt_prog->type];
	prog->expected_attach_type = tgt_prog->expected_attach_type;
}
key = bpf_trampoline_compute_key(tgt_prog, btf_id);

otherwise above 'if' groups two separate things.
It's not pretty in the existing code, no doubt, but since you're doing
nice cleanup let's make it clean here too.

> +
> +	/* remember two read only pointers that are valid for
> +	 * the life time of the kernel
> +	 */

Here this comment is not correct.
It was correct in the place you copy-pasted it from, but not here.
Please think it through and adjust accordingly.
