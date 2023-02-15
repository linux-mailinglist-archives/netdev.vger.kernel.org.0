Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204F46979D0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjBOK0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjBOK0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:26:15 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A94A6A78;
        Wed, 15 Feb 2023 02:26:14 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id co8so14825838wrb.1;
        Wed, 15 Feb 2023 02:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LX8eysKoq3lc1UrbqO/I7YpGQcuabTwSQRGz/IP26yI=;
        b=mMkkdgbmYZPweEnduVDAs6FJHt9kcWSPace7dJUzw19urNAEBvfjYouAB2Ux+V8cDI
         yvomOT5G/hziVywVsY6ZRrIAxaCXLx9HNdNtUJVQgL9hwq9wATM/jYJ73bToZCuYpVA4
         5d7Mc8cGgsiCLFjfwHfg3f6oDWfcRZTnMlx7MkWsNo8tz5gAsmey7xbEyUwpyxZxIWhd
         W8WJvx9UTCdfg3SotHm0EoD5SO0eqVD7m89GxHVWozVYrEcukFMu2hHr/C+bnUE/ADma
         m7Ib11zi2nbJHhi/2pGFioWgAbVRcfjiYgrYWD3IVwVPF3DqEILkjAt/xfBgbCNiJqkc
         SEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LX8eysKoq3lc1UrbqO/I7YpGQcuabTwSQRGz/IP26yI=;
        b=PjjMx53soh02Z2ezYHllHSNiYMdn16epd+vGi+rupPjurwNqFFbO6FdTh9Rt6E9xju
         Cgp+z+EYrfbJYbP0F4hvQZhC4lpn09863DLyiv9FZjwQDMraLh4Djl5qFVOgm5/h2mAq
         yDOVb5z93k4aifxwun+7IYoCr///mM2fVUIjNEAhexq8d078ux8RV+07k+QMgwFjCdHw
         c3tWO3ZF767ILLpXQ2yQt/TIWA8SgOGRrTbXfCEONIUlO0ipX3cYgSwWb/TyVYbKzTBp
         5ustm02/8gsY8SkN4Gy5dR+MAzs3ldeeVw8Dp0ErDiKVliU50VETGaphYPR/Pt0srcrg
         Hy8Q==
X-Gm-Message-State: AO0yUKVTZ0svecAjwrfrbeKy6eBq+5IzNEcRDOxsMrTkxBtvJoOvkPe7
        pdK3Ur2tF0kAbx+9Q6X06lA=
X-Google-Smtp-Source: AK7set+7scO1x59icCnaomC+lmjsaYuJRb/RuYqnCKEr4iAK90pq61GhDgHbNuQKRvYcKJPPWscgGg==
X-Received: by 2002:a05:6000:1010:b0:2c5:4659:3e76 with SMTP id a16-20020a056000101000b002c546593e76mr1395477wrx.18.1676456772557;
        Wed, 15 Feb 2023 02:26:12 -0800 (PST)
Received: from localhost ([2a02:1210:74a0:3200:2fc:d4f0:c121:5e8b])
        by smtp.gmail.com with ESMTPSA id r2-20020adff702000000b002bddac15b3dsm14898488wrp.33.2023.02.15.02.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 02:26:11 -0800 (PST)
Date:   Wed, 15 Feb 2023 11:26:09 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix map_kptr test.
Message-ID: <20230215102609.5o2isbowvtoungws@apollo>
References: <20230214235051.22938-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214235051.22938-1-alexei.starovoitov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 12:50:51AM CET, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>
> The compiler is optimizing out majority of unref_ptr read/writes, so the test
> wasn't testing much. For example, one could delete '__kptr' tag from
> 'struct prog_test_ref_kfunc __kptr *unref_ptr;' and the test would still "pass".
>
> Convert it to volatile stores. Confirmed by comparing bpf asm before/after.
>
> Fixes: 2cbc469a6fc3 ("selftests/bpf: Add C tests for kptr")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

There's also the same test in the test_verifier suite, so there's still coverage
for this case.

>  tools/testing/selftests/bpf/progs/map_kptr.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
> index eb8217803493..228ec45365a8 100644
> --- a/tools/testing/selftests/bpf/progs/map_kptr.c
> +++ b/tools/testing/selftests/bpf/progs/map_kptr.c
> @@ -62,21 +62,23 @@ extern struct prog_test_ref_kfunc *
>  bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
>  extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
>
> +#define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
> +
>  static void test_kptr_unref(struct map_value *v)
>  {
>  	struct prog_test_ref_kfunc *p;
>
>  	p = v->unref_ptr;
>  	/* store untrusted_ptr_or_null_ */
> -	v->unref_ptr = p;
> +	WRITE_ONCE(v->unref_ptr, p);
>  	if (!p)
>  		return;
>  	if (p->a + p->b > 100)
>  		return;
>  	/* store untrusted_ptr_ */
> -	v->unref_ptr = p;
> +	WRITE_ONCE(v->unref_ptr, p);
>  	/* store NULL */
> -	v->unref_ptr = NULL;
> +	WRITE_ONCE(v->unref_ptr, NULL);
>  }
>
>  static void test_kptr_ref(struct map_value *v)
> @@ -85,7 +87,7 @@ static void test_kptr_ref(struct map_value *v)
>
>  	p = v->ref_ptr;
>  	/* store ptr_or_null_ */
> -	v->unref_ptr = p;
> +	WRITE_ONCE(v->unref_ptr, p);
>  	if (!p)
>  		return;
>  	if (p->a + p->b > 100)
> @@ -99,7 +101,7 @@ static void test_kptr_ref(struct map_value *v)
>  		return;
>  	}
>  	/* store ptr_ */
> -	v->unref_ptr = p;
> +	WRITE_ONCE(v->unref_ptr, p);
>  	bpf_kfunc_call_test_release(p);
>
>  	p = bpf_kfunc_call_test_acquire(&(unsigned long){0});
> --
> 2.30.2
>
