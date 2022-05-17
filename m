Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD5C529D9F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244327AbiEQJMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243768AbiEQJMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:12:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7C53055B;
        Tue, 17 May 2022 02:12:45 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j28so7495513eda.13;
        Tue, 17 May 2022 02:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WSRw1Pwnan2nbIFjF7GvgpMAawLqzQo4p+q82BQEguE=;
        b=LjeX+DA75x1FUBh9TKF2FwzUAn42vtQcynsZgE53sBbfQ2Z+W/Q8EvBRkxSWSkFt9E
         ZzHkJEbd1yEw/kW3653DnDdqxVbzqoicSH2Ca9v1EM0KexEts3z0si04eArE33PAmQpm
         YP9iwaPxnodFuDxT0dbcx8QI/Im96YAg0MC0MNyxfNETOxiW7TR1aiMEcOI8vLT0RA+t
         VIwIutJ8k26XKrmHSyo2vCFlj24rx1HY0El/xVrV3VLK1yTBnmKacaH9blICJId9bO61
         SMEAIbReF94tx5qKwYA6KNGH22wapcjP8Jq6Bao8y7TjUuYj3HgZpUoH+hhsSlAhDsjg
         HGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WSRw1Pwnan2nbIFjF7GvgpMAawLqzQo4p+q82BQEguE=;
        b=OSNFgBH7BQNiZGPFdkKRh6CbNJoJMeI7ExRhNJCZS7arkWT7fSwPGJO8gkpuZEjOXp
         DAmNkVvj+pCNhL/stVCdQzVNPIo6OanqmQMsKcj41iu0E/gy8pL7Ixd8OE61z25geHBb
         mPTNdM4/d/IfIkYJ60/dDbk6mMbtjWtOP75o5XsacjSTydep5chYtZN8kTzfxvrCQqB0
         mT3k2wknQomTOa+VwA4PH9YbalptZbN6DMYWnCHopItRh+WDKMf1Xk/4RNBEKR64Xymo
         dROseObpLRUPtwfhAp/MU4YE6eP1kYbj+VMxxsyv0APt0Jt+DmzjsqzOfJ3Vcc7nxIkZ
         DtWg==
X-Gm-Message-State: AOAM532iBpson5lGpYNCQIwk3E7rQauyyt5ZInYMyZLn8bY12GLkDwGT
        dTT8HSly8RQuYubaPvCauvI=
X-Google-Smtp-Source: ABdhPJzI+2mseapOLyonVdtI88hGRVWahwfpEgpTCab/cMq7qfEYOPFG16q4lbZAKku81lBLCRGMuA==
X-Received: by 2002:a05:6402:3585:b0:427:ccd4:bec3 with SMTP id y5-20020a056402358500b00427ccd4bec3mr18004810edc.2.1652778763846;
        Tue, 17 May 2022 02:12:43 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id s2-20020aa7cb02000000b0042617ba63a5sm6440784edt.47.2022.05.17.02.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 02:12:43 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 May 2022 11:12:41 +0200
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <YoNnCaofiAc6M8jc@krava>
References: <cover.1652772731.git.esyr@redhat.com>
 <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:36:15AM +0200, Eugene Syromiatnikov wrote:
> Check that size would not overflow before calculation (and return
> -EOVERFLOW if it will), to prevent potential out-of-bounds write
> with the following copy_from_user.  Use kvmalloc_array
> in copy_user_syms to prevent out-of-bounds write into syms
> (and especially buf) as well.
> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Cc: <stable@vger.kernel.org> # 5.18
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  kernel/trace/bpf_trace.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 7141ca8..9c041be 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2261,11 +2261,11 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
>  	int err = -ENOMEM;
>  	unsigned int i;
>  
> -	syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
> +	syms = kvmalloc_array(cnt, sizeof(*syms), GFP_KERNEL);
>  	if (!syms)
>  		goto error;
>  
> -	buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
> +	buf = kvmalloc_array(cnt, KSYM_NAME_LEN, GFP_KERNEL);
>  	if (!buf)
>  		goto error;
>  
> @@ -2461,7 +2461,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	if (!cnt)
>  		return -EINVAL;
>  
> -	size = cnt * sizeof(*addrs);
> +	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +		return -EOVERFLOW;
>  	addrs = kvmalloc(size, GFP_KERNEL);
>  	if (!addrs)
>  		return -ENOMEM;
> -- 
> 2.1.4
> 
