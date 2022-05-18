Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19A52C1CB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiERSFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiERSFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:05:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B57A2218D1;
        Wed, 18 May 2022 11:05:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds11so2855650pjb.0;
        Wed, 18 May 2022 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u9+JPq0YWfXxjUAqZwa4MFI6EUqcPNwEYnHh7u9RESw=;
        b=eiDox5bIriVi94aqiix+B00JOnWTV6JolirNXgznshoVG0SrhrAe3CA88vUxKVS1fe
         WDKAvPd5qJnRY3KoAAm/9yZxu8Vh1vHXUWkNnwWNpisUjA2Wsm+XwgMnp9ejC9inCHmZ
         /D6ozx0C7C5XyYSmY8NHrwLMq1GRelT04frhKQP0m5daa+GvyHkh9JIJuXSyMfvAPwKd
         SzQvZxwtklsGLAPnh5yAm5uQP/sc7A7BRHhg24msdmo4h46rAy17ZAJRzjNeck5TiPoC
         lZxNrMJ3AaOPB10gxDNLuMlX4L/Baj2Bb2sKBuHA2+m4D1Eln1dydVHi6eRYaGkaI3hw
         P6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9+JPq0YWfXxjUAqZwa4MFI6EUqcPNwEYnHh7u9RESw=;
        b=yiOS9pGXv/TX7wlQTxtIwkswB/++zpe8txaXR90QAUm8ExViz0PO7cRTwb3FAdwVsv
         pRx+2BtmxH7BEEps/QZVCKgfQdVXlC+fAOsjKKlMH2Y90DeIgqWPKb+rzN/qZSU2YtPO
         Hcv3lQdjqBFs8elJvanD6JVcOsRvP5cC+VvQSw9L4aVmmFzc4hgSRycaOa97wy0328EQ
         fLqxqJoc4bOSGZ+yHkcFHmWpqmMNTRTuYfRdzPQnhk9QK+DSLAYDmKh+l0PIkqk9fP0v
         jwrhXMbkGPSV+LQCf8Vqi3+Q80Z43mUGW5n3LDmKQNxesjpGdYssMBEzOuxjOa3Ebshj
         cJow==
X-Gm-Message-State: AOAM532EAEaL8Yl4PZKOeyJ42j1ATpNjccuQjyutRqZ15xswgh5mHCO8
        +it/HH8tniELp3SRSM2veGF3VdX5l9Y=
X-Google-Smtp-Source: ABdhPJxNu345qea6n5GM2ISwEI4F55ydVZzlwwLwOTyiy9Tbx8rm9+o0iIEF4FllypEUldztmrc19A==
X-Received: by 2002:a17:90b:3142:b0:1df:77f2:e169 with SMTP id ip2-20020a17090b314200b001df77f2e169mr1179624pjb.245.1652897131441;
        Wed, 18 May 2022 11:05:31 -0700 (PDT)
Received: from localhost ([14.96.13.220])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902ed5400b0015ea8b4b8f3sm1963278plb.263.2022.05.18.11.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 11:05:31 -0700 (PDT)
Date:   Wed, 18 May 2022 23:36:13 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: Re: [PATCH v3 bpf-next 1/5] bpf: Add support for forcing kfunc args
 to be referenced
Message-ID: <20220518180613.su37c23ckgc5irmu@apollo.legion>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <7addba8ead6d590c9182020c03c7696ba5512036.1652870182.git.lorenzo@kernel.org>
 <8912c7c2-9396-f7d8-74e2-a2560fbaad56@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8912c7c2-9396-f7d8-74e2-a2560fbaad56@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 11:28:12PM IST, Yonghong Song wrote:
>
>
> On 5/18/22 3:43 AM, Lorenzo Bianconi wrote:
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >
> > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > treat __ref suffix on argument name to imply that it must be a
> > referenced pointer when passed to kfunc. This is required to ensure that
> > kfunc that operate on some object only work on acquired pointers and not
> > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > walking. Release functions need not specify such suffix on release
> > arguments as they are already expected to receive one referenced
> > argument.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   kernel/bpf/btf.c   | 40 ++++++++++++++++++++++++++++++----------
> >   net/bpf/test_run.c |  5 +++++
> >   2 files changed, 35 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 2f0b0440131c..83a354732d96 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6021,18 +6021,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
> >   	return true;
> >   }
> > -static bool is_kfunc_arg_mem_size(const struct btf *btf,
> > -				  const struct btf_param *arg,
> > -				  const struct bpf_reg_state *reg)
> > +static bool btf_param_match_suffix(const struct btf *btf,
> > +				   const struct btf_param *arg,
> > +				   const char *suffix)
> >   {
> > -	int len, sfx_len = sizeof("__sz") - 1;
> > -	const struct btf_type *t;
> > +	int len, sfx_len = strlen(suffix);
> >   	const char *param_name;
> > -	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > -	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> > -		return false;
> > -
> >   	/* In the future, this can be ported to use BTF tagging */
> >   	param_name = btf_name_by_offset(btf, arg->name_off);
> >   	if (str_is_empty(param_name))
> > @@ -6041,12 +6036,31 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
> >   	if (len < sfx_len)
> >   		return false;
> >   	param_name += len - sfx_len;
> > -	if (strncmp(param_name, "__sz", sfx_len))
> > +	if (strncmp(param_name, suffix, sfx_len))
> >   		return false;
> >   	return true;
> >   }
> > +static bool is_kfunc_arg_ref(const struct btf *btf,
> > +			     const struct btf_param *arg)
> > +{
> > +	return btf_param_match_suffix(btf, arg, "__ref");
>
> Do we also need to do btf_type_skip_modifiers and to ensure
> the type after skipping modifiers are a pointer type?
> The current implementation should work for
> bpf_kfunc_call_test_ref(), but with additional checking
> we may avoid some accidental mistakes.
>

The point where this check happens, arg[i].type is already known to be a pointer
type, after skipping modifiers.

> > +}
> > +
> > +static bool is_kfunc_arg_mem_size(const struct btf *btf,
> > +				  const struct btf_param *arg,
> > +				  const struct bpf_reg_state *reg)
> > +{
> > +	const struct btf_type *t;
> > +
> > +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > +	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> > +		return false;
> > +
> > +	return btf_param_match_suffix(btf, arg, "__sz");
> > +}
> > +
> >   static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >   				    const struct btf *btf, u32 func_id,
> >   				    struct bpf_reg_state *regs,
> > @@ -6115,6 +6129,12 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >   			return -EINVAL;
> >   		}
> > +		/* Check if argument must be a referenced pointer */
> > +		if (is_kfunc && is_kfunc_arg_ref(btf, args + i) && !reg->ref_obj_id) {
> > +			bpf_log(log, "R%d must be referenced\n", regno);
> > +			return -EINVAL;
> > +		}
> > +
> >   		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
> >   		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index 4d08cca771c7..adbc7dd18511 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -690,6 +690,10 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
> >   {
> >   }
> > +noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p__ref)
> > +{
> > +}
> > +
> >   __diag_pop();
> [...]

--
Kartikeya
