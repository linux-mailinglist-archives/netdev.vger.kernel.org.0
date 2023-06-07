Return-Path: <netdev+bounces-9035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE51726A70
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5787D1C20E90
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0603C39252;
	Wed,  7 Jun 2023 20:10:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA81010FC;
	Wed,  7 Jun 2023 20:10:14 +0000 (UTC)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2688118F;
	Wed,  7 Jun 2023 13:10:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-256422ad25dso3395804a91.0;
        Wed, 07 Jun 2023 13:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686168612; x=1688760612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qYBbVxG5qTvWtJpvG1GFdSzWMjaAkI3hKSe+dIzx3pQ=;
        b=WtfDyXhz2c9B23otUHcznVCyEeGumOxVaBHOmoJj/VlFydX+O2M8X83iGvkqQks565
         lOKZG2S83nN87F5KgGSaNQ1GYjtUDGSlRbGa7QGuCFnkMTjpvbCH1NSiMUIW/fek9rQ9
         srkVO0fQH5kVuu7cBEehH3/lDd4RTMaAqeVHoSc7AHYZMZmmByicoyBaEsPqBMW98aDQ
         HuOh9g/23bvvs+hvEQWriEeZsKKVLkaOo//HIcI5yD3lc3OVotkbxXPsqHnSNG1r4p01
         3xDDxe2CORbxUBc8K07LsMjvXND5z7yGHW6K/DxZxS85X2H+aZjghB2x23a8KC+fKJv4
         9Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686168612; x=1688760612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYBbVxG5qTvWtJpvG1GFdSzWMjaAkI3hKSe+dIzx3pQ=;
        b=XmbwPRSgoqPWSqPP55zmiAbAxnu9Zcf9Kka/ASEfXPMKPCQqO9XRxwlEtI1NaJpvQ1
         RDcjJelsdgvsIB7gZDQkX6nFVoESFxj4mxKctFTpIFMp/ekzr9a7aDM7S1BVjFl5k9qy
         OAJ72Mj0KuOjZJQJUdLrkYYEWYqJxOkYj+nlMPp6S5isBXMOCRq81XzNia8/JJD2nb0v
         ns6ZeoDr0OcaMmTCZnasPI+sbBPF/E+U9NSvZ0PLB55VXnsDNdu78TitF+sbVWic/X/i
         HJyd6QP59DrXBTVAwsWaa9s2l0sygSw4EMYfjnZ5iCbjV9cYq9FRoTeAPMXnGIZwfPki
         OBpQ==
X-Gm-Message-State: AC+VfDx0HA1xVhY45EPCYizDa9lie/7n8GkFDz8+5mNLiIZTqDyJCs6o
	U8CyX8z+vRgG+YaqDyck498=
X-Google-Smtp-Source: ACHHUZ4h4suM9rAl/2fMKAeD8dDqnHEOTIlWctoaikfJw1mjnZNBjFADfaIGHYLBECxSkDuj4AnC2Q==
X-Received: by 2002:a17:90a:6408:b0:255:b1d9:a206 with SMTP id g8-20020a17090a640800b00255b1d9a206mr2363761pjj.22.1686168612499;
        Wed, 07 Jun 2023 13:10:12 -0700 (PDT)
Received: from macbook-pro-8.dhcp.thefacebook.com ([2620:10d:c090:500::6:1c96])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090b018300b0023fcece8067sm1718674pjs.2.2023.06.07.13.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 13:10:12 -0700 (PDT)
Date: Wed, 7 Jun 2023 13:10:08 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: menglong8.dong@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, x86@kernel.org,
	imagedong@tencent.com, benbjiang@tencent.com,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 3/3] selftests/bpf: add testcase for
 FENTRY/FEXIT with 6+ arguments
Message-ID: <20230607201008.662mecxnksxiees3@macbook-pro-8.dhcp.thefacebook.com>
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-4-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607125911.145345-4-imagedong@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:59:11PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Add test9/test10 in fexit_test.c and fentry_test.c to test the fentry
> and fexit whose target function have 7/12 arguments.
> 
> Correspondingly, add bpf_testmod_fentry_test7() and
> bpf_testmod_fentry_test12() to bpf_testmod.c
> 
> And the testcases passed:
> 
> ./test_progs -t fexit
> Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED
> 
> ./test_progs -t fentry
> Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED
> 
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v3:
> - move bpf_fentry_test{7,12} to bpf_testmod.c and rename them to
>   bpf_testmod_fentry_test{7,12} meanwhile
> - get return value by bpf_get_func_ret() in
>   "fexit/bpf_testmod_fentry_test12", as we don't change ___bpf_ctx_cast()
>   in this version
> ---
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 19 ++++++++++-
>  .../selftests/bpf/prog_tests/fentry_fexit.c   |  4 ++-
>  .../selftests/bpf/prog_tests/fentry_test.c    |  2 ++
>  .../selftests/bpf/prog_tests/fexit_test.c     |  2 ++
>  .../testing/selftests/bpf/progs/fentry_test.c | 21 ++++++++++++
>  .../testing/selftests/bpf/progs/fexit_test.c  | 33 +++++++++++++++++++
>  6 files changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> index cf216041876c..66615fdbe3df 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> @@ -191,6 +191,19 @@ noinline int bpf_testmod_fentry_test3(char a, int b, u64 c)
>  	return a + b + c;
>  }
>  
> +noinline int bpf_testmod_fentry_test7(u64 a, void *b, short c, int d,
> +				      void *e, u64 f, u64 g)
> +{
> +	return a + (long)b + c + d + (long)e + f + g;
> +}
> +
> +noinline int bpf_testmod_fentry_test12(u64 a, void *b, short c, int d,
> +				       void *e, u64 f, u64 g, u64 h,
> +				       u64 i, u64 j, u64 k, u64 l)

Please switch args to a combination of u8,u16,u32,u64.
u64 only args might hide bugs.

