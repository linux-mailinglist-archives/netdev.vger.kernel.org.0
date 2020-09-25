Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E398B278AC8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgIYOVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgIYOVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 10:21:33 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC76C0613CE;
        Fri, 25 Sep 2020 07:21:32 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id s66so2455001otb.2;
        Fri, 25 Sep 2020 07:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dmeYRQ5MoR6w6wiYlinGL/yGjDRvX+bZSOTcEBEHyCM=;
        b=E8k1U1Kinr80GqjBDT9klnRkqC1cvipTyNYuJIRqqkIvETrwmTtq/sM+aXoegqU+Mr
         NwUNl1yxend8fCIkDuJ5SbFebpno4l3HDkyNjUjpQyuMbvkE+0QpcM/Z1w71Mw+Fa6Bk
         D9B6QzrxamUuypREBmBuBE0qyOxoCR+OTr4sMGlJYrkHUEHq4TfsYUgW0ZLnrGZ7ZxaC
         ZwBso2jU/xctagyehscXChmnzZSjizDnDjYOc8WvLE/cPUsljeUu+7V9ZLJ25JvnxLhC
         KdGsEhl4w6WMMnh9we4khCI1NYPqqEfsZSSzPgIuy7Ra14bp5TCroedFRIZ4sWYpGBbZ
         QJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dmeYRQ5MoR6w6wiYlinGL/yGjDRvX+bZSOTcEBEHyCM=;
        b=C7oiyVrPj+z9+xd0yTPAEYXveIH3jzOhAiU4URtMUoVNuzeKSI6IfZCAoY6SobtaX4
         p1Uf9mqOcIsm8E9RL3x79wwU2OWbV8y50be+QaudaG6TGo7C1voOSshlI/J89DuGGMLb
         3dHzqDSC5gi9GYjsr7n2mTIw+hPB14mOupHsdCCtJpjVq2SbKdhgfzxbXN352nj7OUng
         wPXJxFXtPySgMKJ/cjds/bLtBYzTM6JDLhxfIg/trUD9zxaXunkruzWyAVKaUXpmYAdj
         21uC2m6+oyHiyKXHH0fFuPqkEQ/MuOtKebPYxBGGk2BPObVP2udGsuBt67sj/w6jgCEk
         vo1g==
X-Gm-Message-State: AOAM533zz6ZmiceCsg/wVJxV//v3VzaZFK7KBhUGEG78BHuvHtsmY+R8
        dEdmO2pltYooytqS5EvOo0M=
X-Google-Smtp-Source: ABdhPJzArkjEDeYENv4i1jqjlsSD0aCTAc527MMnGgF5x9O7x53uuNoyYp+KjP7Z2Ob7LA7mhIH6Vw==
X-Received: by 2002:a9d:2666:: with SMTP id a93mr468654otb.324.1601043692310;
        Fri, 25 Sep 2020 07:21:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d17sm656167oth.73.2020.09.25.07.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 07:21:31 -0700 (PDT)
Date:   Fri, 25 Sep 2020 07:21:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org
Message-ID: <5f6dfce2db3e4_835ea20891@john-XPS-13-9370.notmuch>
In-Reply-To: <20200925000350.3855720-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
 <20200925000350.3855720-1-kafai@fb.com>
Subject: RE: [PATCH v4 bpf-next 02/13] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> There is a constant need to add more fields into the bpf_tcp_sock
> for the bpf programs running at tc, sock_ops...etc.
> 
> A current workaround could be to use bpf_probe_read_kernel().  However,
> other than making another helper call for reading each field and missing
> CO-RE, it is also not as intuitive to use as directly reading
> "tp->lsndtime" for example.  While already having perfmon cap to do
> bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> directly read from the tcp_sock.
> 
> This patch tries to do that by using the existing casting-helpers
> bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> kernel "struct tcp_sock".
> 
> These helpers are also added to is_ptr_cast_function().
> It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> That will keep the ref-tracking works properly.
> 
> The bpf_skc_to_* helpers are made available to most of the bpf prog
> types in filter.c. The bpf_skc_to_* helpers will be limited by
> perfmon cap.
> 
> This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> they will accept pointer obtained from skb->sk.
> 
> Instead of specifying both arg_type and arg_btf_id in the same func_proto
> which is how the current ARG_PTR_TO_BTF_ID does, the arg_btf_id of
> the new ARG_PTR_TO_BTF_ID_SOCK_COMMON is specified in the
> compatible_reg_types[] in verifier.c.  The reason is the arg_btf_id is
> always the same.  Discussion in this thread:
> https://lore.kernel.org/bpf/20200922070422.1917351-1-kafai@fb.com/
> 
> The ARG_PTR_TO_BTF_ID_ part gives a clear expectation that the helper is
> expecting a PTR_TO_BTF_ID which could be NULL.  This is the same
> behavior as the existing helper taking ARG_PTR_TO_BTF_ID.
> 
> The _SOCK_COMMON part means the helper is also expecting the legacy
> SOCK_COMMON pointer.
> 
> By excluding the _OR_NULL part, the bpf prog cannot call helper
> with a literal NULL which doesn't make sense in most cases.
> e.g. bpf_skc_to_tcp_sock(NULL) will be rejected.  All PTR_TO_*_OR_NULL
> reg has to do a NULL check first before passing into the helper or else
> the bpf prog will be rejected.  This behavior is nothing new and
> consistent with the current expectation during bpf-prog-load.
> 
> [ ARG_PTR_TO_BTF_ID_SOCK_COMMON will be used to replace
>   ARG_PTR_TO_SOCK* of other existing helpers later such that
>   those existing helpers can take the PTR_TO_BTF_ID returned by
>   the bpf_skc_to_*() helpers.
> 
>   The only special case is bpf_sk_lookup_assign() which can accept a
>   literal NULL ptr.  It has to be handled specially in another follow
>   up patch if there is a need (e.g. by renaming ARG_PTR_TO_SOCKET_OR_NULL
>   to ARG_PTR_TO_BTF_ID_SOCK_COMMON_OR_NULL). ]
> 
> [ When converting the older helpers that take ARG_PTR_TO_SOCK* in
>   the later patch, if the kernel does not support BTF,
>   ARG_PTR_TO_BTF_ID_SOCK_COMMON will behave like ARG_PTR_TO_SOCK_COMMON
>   because no reg->type could have PTR_TO_BTF_ID in this case.
> 
>   It is not a concern for the newer-btf-only helper like the bpf_skc_to_*()
>   here though because these helpers must require BTF vmlinux to begin
>   with. ]
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

LGTM it took a bit of looking around to convince myself that
we have ret_type set to PTR_TO_SOCK_*_OR_NULL types in the sk lookup
helpers so that we force a null check before passing these into the
skc_to_* helpers here, but I didn't see any holes. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> @@ -4575,10 +4601,14 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
>  {
>  	int i;
>  
> -	for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++)
> +	for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++) {
>  		if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
>  			return false;
>  
> +		if (fn->arg_type[i] != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
> +			return false;
> +	}
> +

I guess this case is harmless? If some other arg has a btf_id its setup
wrong, so nice to fail here I think.

>  	return true;
>  }
>  
