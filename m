Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492D04BF24B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 07:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiBVGyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 01:54:17 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiBVGyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 01:54:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480D1110A2;
        Mon, 21 Feb 2022 22:53:52 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso1470765pjs.1;
        Mon, 21 Feb 2022 22:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cd9N84G12yMFVfK5hwY1Mfhlsjik3wthSQDQX9hRXUk=;
        b=QsZHvnPM00q1KFr+MDI7WnueUZbQ34onU4GTJ20f+wM2J+G2gGk2cM+59PMI3zkPCq
         QRnNrb9+zZuLG7lS9EKnY0JQwn717kkyNl5tHxiL0t1mFVn/jzi+MkfbKBnHanzvWfzs
         Hb+Nk6RhH5Bj/r5dYkzdaeENOLRF16i8A7LShNGTYV+GLK+BdH1KbSAw7247kRAAIZQA
         vGUEp27VpDw+6wgqmGSJqEl5k0+/sdXVvNhp5PqMmg7nXQuo5dn0fDhXlMiiwl/gScAW
         05QhJ9YmWQraaeXjYunyOrS5uj16NN3rQgLac7qEYhuMPj4k39WNRftFdze3d+CrvyCv
         NjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cd9N84G12yMFVfK5hwY1Mfhlsjik3wthSQDQX9hRXUk=;
        b=2qmu+Vt1rBchbq8BGZNtEcU9Hj79urOBLqlE6yD6J3KxXORbf+sR3QfLJkYwCS22WZ
         iEhn6AqE6DIrwCMF51MkvD1NQiit+GJSEaxFjtzTXlJCe5iFzD2RNKTkJYESusFsMd+m
         9FThwdtmYloCGgUoDTaLCGZ7SJ1P32zgUeSDWUIU56qJjmEETmiSokZwgAa9T1+xo+1/
         pSeaiUQ+C3LDwmgaJMDJqN4BEY9rlpMNMqSSbuCuQ9yJKVYegzALtJ7dHTgbFY4dSxZi
         V+XYILy5RIk2uFTN9+RJv3ZZMPOU/NwD2c4EY2uF+SGVS9xxwNB9JRLWYa61uCIrAEl8
         MtXg==
X-Gm-Message-State: AOAM531gennrbsUM4VXx4RRfRE+xcq7dofIRfzepw+B4SUv76VHAj5+p
        FoqV69khIezmfh+u1fRwZ0vsNCwheMk=
X-Google-Smtp-Source: ABdhPJzBZ/ZuqMSsu1fSF5yxoyHpFwov8SDC/eQY7EC9oneZl9/eBYokReG6uYHSIf+dWE/3Bk44zw==
X-Received: by 2002:a17:902:ec83:b0:14f:ba2b:990c with SMTP id x3-20020a170902ec8300b0014fba2b990cmr7867242plg.119.1645512831548;
        Mon, 21 Feb 2022 22:53:51 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e2d6])
        by smtp.gmail.com with ESMTPSA id t2sm15676094pfg.207.2022.02.21.22.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 22:53:51 -0800 (PST)
Date:   Mon, 21 Feb 2022 22:53:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 04/15] bpf: Allow storing referenced
 PTR_TO_BTF_ID in map
Message-ID: <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-5-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-5-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 07:18:02PM +0530, Kumar Kartikeya Dwivedi wrote:
>  static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
>  			    int off, int bpf_size, enum bpf_access_type t,
> -			    int value_regno, bool strict_alignment_once)
> +			    int value_regno, bool strict_alignment_once,
> +			    struct bpf_reg_state *atomic_load_reg)

No new side effects please.
value_regno is not pretty already.
At least its known ugliness that we need to clean up one day.

>  static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
>  {
> +	struct bpf_reg_state atomic_load_reg;
>  	int load_reg;
>  	int err;
>  
> +	__mark_reg_unknown(env, &atomic_load_reg);
> +
>  	switch (insn->imm) {
>  	case BPF_ADD:
>  	case BPF_ADD | BPF_FETCH:
> @@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
>  		else
>  			load_reg = insn->src_reg;
>  
> +		atomic_load_reg = *reg_state(env, load_reg);
>  		/* check and record load of old value */
>  		err = check_reg_arg(env, load_reg, DST_OP);
>  		if (err)
> @@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
>  	}
>  
>  	/* Check whether we can read the memory, with second call for fetch
> -	 * case to simulate the register fill.
> +	 * case to simulate the register fill, which also triggers checks
> +	 * for manipulation of BTF ID pointers embedded in BPF maps.
>  	 */
>  	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> -			       BPF_SIZE(insn->code), BPF_READ, -1, true);
> +			       BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
>  	if (!err && load_reg >= 0)
>  		err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
>  				       BPF_SIZE(insn->code), BPF_READ, load_reg,
> -				       true);
> +				       true, load_reg >= 0 ? &atomic_load_reg : NULL);

Special xchg logic should be down outside of check_mem_access()
instead of hidden by layers of calls.
