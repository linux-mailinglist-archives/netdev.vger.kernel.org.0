Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7E4BF279
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiBVHKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:10:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiBVHKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:10:54 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE69B16EB;
        Mon, 21 Feb 2022 23:10:29 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u5so14835483ple.3;
        Mon, 21 Feb 2022 23:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r9EcDAw5i8f/LonERLT1GnedtQjlY1MI1MiGjZ0g9PM=;
        b=NUeThgPEOJEEEI91SzYY9ewn1+ynbgWVum84oPeJWYl3pLJ+kMVG9zNo7Hkq6wObMO
         /dnKaR/gw2SFtehlpgISUu950Ka/0S1eXAFw+Jej/9UCai0ttODwpN2a01k+/0qeLj4g
         VUEFDPfeClXowPkB0oQqnJP5gt5vSO7bZVcLeKKXbdAh7U0rf0zPK0V590luXALngeCv
         xbx9P3AccnyelppdZP+ely07o0rNxGjy6e8zNvpUAKpMfTzjXzbSkuPRIkXfFjX4YWwF
         5jeVQvfZBNzCLyYZOlVU3HJrngL1yrRv08NNrN4Y+5j1VUGBMc74fNF8xqGi2c9mtkqn
         nUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r9EcDAw5i8f/LonERLT1GnedtQjlY1MI1MiGjZ0g9PM=;
        b=5DbX+nqfMGFlCcFixlvP9DuOD0AfBboARXz2m3gWrGAo9D3Nk5/4W25oi594GuowAp
         xH+sOu0VV9eKWcjYegZAl1a9ikZwUceVuBQ4fH5RLFaqdbPL5T59V3wqp+RF6OtP659O
         iOBeuu6yhr+YN5yXGoLkEG95wR7pYnIM5FTAnLT9HhnvWYQCnXCsAZp2vFty6i1jKGZ/
         Lee8/p5v/ftaWIZ0HTh9aQkl3lYXfK2Sn2D/B3AeT7/aFGySCiO2gcvHoFbWtbXfHh1C
         oZ8G4UQMciGlBiG7zOvBtCQbMKpygZs4NM/mFVuzg8XQEQWL6n7ab24Bzw+O3ks5SoTk
         yu8A==
X-Gm-Message-State: AOAM532KMxJUp44MbL/eaFibPW0jkcLlN7Q0y4L/bBaS5MZnV+4M3QX5
        u4YOwKqSE+gPUHo7vEBRH5fhnioOB3w=
X-Google-Smtp-Source: ABdhPJwYpKv1lil+GbBGBpNAhY97vI+UXZRhts+CqCB+OZBpYWcgqISG4pwZVBrJeBdhqNsHUyhn/A==
X-Received: by 2002:a17:90a:a78c:b0:1b8:b769:62d0 with SMTP id f12-20020a17090aa78c00b001b8b76962d0mr2723831pjq.227.1645513829070;
        Mon, 21 Feb 2022 23:10:29 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id l22sm16766529pfc.191.2022.02.21.23.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 23:10:28 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:40:26 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 04/15] bpf: Allow storing referenced
 PTR_TO_BTF_ID in map
Message-ID: <20220222071026.fqdjmd5fhjbl56xl@apollo.legion>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-5-memxor@gmail.com>
 <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222065349.ladxy5cqfpdklk3a@ast-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 12:23:49PM IST, Alexei Starovoitov wrote:
> On Sun, Feb 20, 2022 at 07:18:02PM +0530, Kumar Kartikeya Dwivedi wrote:
> >  static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regno,
> >  			    int off, int bpf_size, enum bpf_access_type t,
> > -			    int value_regno, bool strict_alignment_once)
> > +			    int value_regno, bool strict_alignment_once,
> > +			    struct bpf_reg_state *atomic_load_reg)
>
> No new side effects please.
> value_regno is not pretty already.
> At least its known ugliness that we need to clean up one day.
>
> >  static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
> >  {
> > +	struct bpf_reg_state atomic_load_reg;
> >  	int load_reg;
> >  	int err;
> >
> > +	__mark_reg_unknown(env, &atomic_load_reg);
> > +
> >  	switch (insn->imm) {
> >  	case BPF_ADD:
> >  	case BPF_ADD | BPF_FETCH:
> > @@ -4813,6 +4894,7 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> >  		else
> >  			load_reg = insn->src_reg;
> >
> > +		atomic_load_reg = *reg_state(env, load_reg);
> >  		/* check and record load of old value */
> >  		err = check_reg_arg(env, load_reg, DST_OP);
> >  		if (err)
> > @@ -4825,20 +4907,21 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
> >  	}
> >
> >  	/* Check whether we can read the memory, with second call for fetch
> > -	 * case to simulate the register fill.
> > +	 * case to simulate the register fill, which also triggers checks
> > +	 * for manipulation of BTF ID pointers embedded in BPF maps.
> >  	 */
> >  	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> > -			       BPF_SIZE(insn->code), BPF_READ, -1, true);
> > +			       BPF_SIZE(insn->code), BPF_READ, -1, true, NULL);
> >  	if (!err && load_reg >= 0)
> >  		err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
> >  				       BPF_SIZE(insn->code), BPF_READ, load_reg,
> > -				       true);
> > +				       true, load_reg >= 0 ? &atomic_load_reg : NULL);
>
> Special xchg logic should be down outside of check_mem_access()
> instead of hidden by layers of calls.

Right, it's ugly, but if we don't capture the reg state before that
check_reg_arg(env, load_reg, DST_OP), it's not possible to see the actual
PTR_TO_BTF_ID being moved into the map, since check_reg_arg will do a
mark_reg_unknown for value_regno. Any other ideas on what I can do?

37086bfdc737 ("bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH")
changed the order of check_mem_access and DST_OP check_reg_arg.

--
Kartikeya
