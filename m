Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C6757D954
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiGVELC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGVELB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:11:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F6D89AA0;
        Thu, 21 Jul 2022 21:11:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b7-20020a17090a12c700b001f20eb82a08so7122561pjg.3;
        Thu, 21 Jul 2022 21:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Hbsikftw7Ck+qtgf2iU/lIUQA7uKjUidRMS9WyjJwE=;
        b=kmuDdEgzaqZNfJRplcZwi1REHeoWn0ZcztTXgCclg1tmtiO8lfr4u3xTNqHY6hL5cO
         dFEFPLo8OkEK7jBaSN+IxH44BFY7YxAkQWfm+CO+szn3vIX/z3u1qY4xRrtqZJrYgPXw
         8jrVGTj9wL5ipeNXnC1gH8Yr+toSEFVMp7LInjohhYFZBEv6GcnsmnW8jRr+yykcI93u
         xBFCDmgOYptUE6KNyWzAbhRHhZRYrbKbGxzL2R2eP7NHdTuwtfrOK9teJJEILpcUEMUJ
         z0132+b65ElBIXfRwyMBfevSqd/brYV9ClhJ77/0+jEwLkCUTVDoY02zu29f2H0gkIjA
         jXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Hbsikftw7Ck+qtgf2iU/lIUQA7uKjUidRMS9WyjJwE=;
        b=xMqsiV/ORhqGz8R2bF1Qx7sG2TlzW/UiBcPR4/ipwlnlwDSV4KBSbTKCKQd2Y/yWC6
         c6+xHPyZuNP7O3Dsq1H123UPF4QpYemv40PCnnLaG3nUTGVSU82g7z3aB8VO0F0A4T7m
         V2KaLlfgcVoEyc0K+JUCmGHfdxpjI+Sa4ojwSgX24bFcrRnXtQfxgtXu8xQTAUzTDn9P
         GdOiAHUNjzHPdKSUmA1n5K1fo208ClMHo/yl0FECwN78lzszcTNx29geXa2K+J74t0Bq
         foifpyCSS3Wcl26JlgvjvmwTjFsi4/DUFeqXqORxk7pskzAvRyB8jlM6GD3fBGwCyd7y
         XQyw==
X-Gm-Message-State: AJIora+Sv/K7EpglRqH8pX2W8DBOjBmjG3YNJyZbHBEJ3SrGnqxjcNXa
        TQczdswpG3lRdDOIS7BGsIg=
X-Google-Smtp-Source: AGRyM1tUe0HM8qSeNJ2sBlFZGiFYctTy8eEVtrGRGmW8+MxGXqPZPhTqeRag6bmrpEIgHeu/icZF4g==
X-Received: by 2002:a17:903:1111:b0:16a:acf4:e951 with SMTP id n17-20020a170903111100b0016aacf4e951mr1531884plh.72.1658463059957;
        Thu, 21 Jul 2022 21:10:59 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:3424])
        by smtp.gmail.com with ESMTPSA id s27-20020a63525b000000b00419b02043e1sm2307013pgl.38.2022.07.21.21.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 21:10:59 -0700 (PDT)
Date:   Thu, 21 Jul 2022 21:10:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc
 args to be trusted
Message-ID: <20220722041056.r2ozhs4p3s7mt7go@macbook-pro-3.dhcp.thefacebook.com>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-5-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721134245.2450-5-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 03:42:36PM +0200, Kumar Kartikeya Dwivedi wrote:
> +/* Trusted arguments are those which are meant to be referenced arguments with
> + * unchanged offset. It is used to enforce that pointers obtained from acquire
> + * kfuncs remain unmodified when being passed to helpers taking trusted args.
> + *
> + * Consider
> + *	struct foo {
> + *		int data;
> + *		struct foo *next;
> + *	};
> + *
> + *	struct bar {
> + *		int data;
> + *		struct foo f;
> + *	};
> + *
> + *	struct foo *f = alloc_foo(); // Acquire kfunc
> + *	struct bar *b = alloc_bar(); // Acquire kfunc
> + *
> + * If a kfunc set_foo_data() wants to operate only on the allocated object, it
> + * will set the KF_TRUSTED_ARGS flag, which will prevent unsafe usage like:
> + *
> + *	set_foo_data(f, 42);	   // Allowed
> + *	set_foo_data(f->next, 42); // Rejected, non-referenced pointer
> + *	set_foo_data(&f->next, 42);// Rejected, referenced, but bad offset
> + *	set_foo_data(&b->f, 42);   // Rejected, referenced, but wrong type

I think you meant to swap above two comments ?
That's what I did while applying.

Also fixed typo in Fixes tag in patch 13. It was missing a letter in sha.

Since there are 3 other pending patchsets in patchwork that add new kfuncs
this cleanup of kfunc registration couldn't have come at better time.

Thank you for doing this work.
