Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED656306BE2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhA1EG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhA1EFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:05:32 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC3C0617AB;
        Wed, 27 Jan 2021 19:53:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cq1so3079965pjb.4;
        Wed, 27 Jan 2021 19:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vL2Ls/K94DeV6njPMNfjB8BEObaZUQsRgrO5DBIVlqM=;
        b=Q4JbkF8MvUQcA+j2Fl1/8WFHpjVicak5lU39i8WrOCah3GfZrLnhHkSIratFBbWfND
         FV55Y+d6ifPevS0yp4si2ndwtaksmcOXpCX395FnAMwGtu6I0L2mG5I2QEInhu58snWQ
         sCZM2+cLYU3kKbaS9N+OyfpNwOIZKqYnSBzRGVB2rjECMlAWxBCyEzhOUCso071oh0oY
         6UCpKuxoSIyyDMCmmqbX6vH+U8w7XwSbLr15b+IVSfh4gqrqeKhip/tDrlnTAWiS2hJY
         ZrXbdH9u5jCo2VZ7M7LEJzV0Gdu5AsoYukgGp6YB3g3kou0YFKNOKI2kSLcs7cmY1PPX
         EY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vL2Ls/K94DeV6njPMNfjB8BEObaZUQsRgrO5DBIVlqM=;
        b=TL36t5dT1LLDLDEdZfMIjfTWABCf8YG95vjNvseQ8UJE2rtjCcr0XRPyy/hpKGGctb
         kp9qLv1s3bDV774HQBWisvrOU1y/svliQnfdshb6CoBcaMzhyW8OOa35sj0pPd4PKAW/
         VbAAXrtY3g0DXXbIzqpQyfZpiMuvsvoVFi0RIwt6jgtNqEgtPU/4A27/HKtVv0d9LCnm
         Fz+kR5XbkuJjji6RTMga99ElOqGK++1xyK9SqNai4c5ypIlECV96J8ur/jN6N/iwkbba
         cFdGgIf03BYR/phvyrOeUBJF1D6njazxyo36SWLCbWUcQ56ahGiJNcvKjjoRv3hICDoy
         MlqA==
X-Gm-Message-State: AOAM530+0Gjq150ZacuXbGuJt8HFTWpcqv8ZzfsBJ2cZy9Vw8qjTIUfA
        2Tb6FeSbHhy/1bAOuwcIxMk=
X-Google-Smtp-Source: ABdhPJxvy3q8H2306Ycyakn+l2HhardN2cj2y5jBnKXTt04ZrCDa/tUlj8oyBs0K2Q1TRw+cK4gFXw==
X-Received: by 2002:a17:90a:1109:: with SMTP id d9mr9152958pja.94.1611806027035;
        Wed, 27 Jan 2021 19:53:47 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b17sm3603179pfo.151.2021.01.27.19.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 19:53:46 -0800 (PST)
Date:   Thu, 28 Jan 2021 11:53:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv17 bpf-next 5/6] selftests/bpf: Add verifier tests for
 bpf arg ARG_CONST_MAP_PTR_OR_NULL
Message-ID: <20210128035300.GQ1421720@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-6-liuhangbin@gmail.com>
 <6011e82feb2_a0fd920881@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6011e82feb2_a0fd920881@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 02:24:47PM -0800, John Fastabend wrote:
> [...]
> 
> > +{
> > +	"ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map",
> > +	.insns = {
> > +		BPF_MOV64_IMM(BPF_REG_1, 0),
> > +		/* bpf_redirect_map_multi arg1 (in_map) */
> > +		BPF_LD_MAP_FD(BPF_REG_1, 0),
> > +		/* bpf_redirect_map_multi arg2 (ex_map) */
> > +		BPF_MOV64_IMM(BPF_REG_2, 0),
> > +		/* bpf_redirect_map_multi arg3 (flags) */
> > +		BPF_MOV64_IMM(BPF_REG_3, 0),
> > +		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
> > +		BPF_EXIT_INSN(),
> > +	},
> > +	.fixup_map_devmap = { 1 },
> > +	.result = ACCEPT,
> > +	.prog_type = BPF_PROG_TYPE_XDP,
> > +	.retval = 4,
> 
> Do we need one more case where this is map_or_null? In above
> ex_map will be scalar tnum_const=0 and be exactly a null. This
> will push verifier here,
> 
>   meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;
> 
> In the below case it is known to be not null.
> 
> Is it also interesting to have a case where register_is_null(reg)
> check fails and reg->map_ptr is set, but may be null.

Hi John,

I'm not familiar with the test_verifier syntax. Doesn't
BPF_LD_MAP_FD(BPF_REG_1, 0) just assign the register with map NULL?

Thanks
hangbin
