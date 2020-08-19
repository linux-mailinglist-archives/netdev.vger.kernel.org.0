Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F0024A802
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHSUv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHSUvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:51:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE4CC061757;
        Wed, 19 Aug 2020 13:51:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so11422598plt.3;
        Wed, 19 Aug 2020 13:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9TX9XzKRN7dNPcsRS3b4Jd5+wB3kzX0sXoNzZYYwbG4=;
        b=I4J73SbBRdIhrd9K2yU3DltmtJFSlUPZownUuVKUKUGA80qDd0RWE1bkktpsiibkFg
         2rNg7/EbcELJ8poBqgTUXPQBFWv1yKe188Xel2ff4F3fYp4MbnmXqVxzHwqT5yT4IDOO
         w1r7Ii+hFCyZ/rdAeOS/diB03vXEeWzY7+IBxZhnkNmc4uR/ZbSdBHo1j+t3afJeIR6x
         KZfnliAJI3XKkvTFyLO1PEU9XoGKm68+0xKm0jmNoKd2cBtAaDj7KSHPX52uQD7V+luH
         GWzIlodVVmlMoRvpgTSnNvXT3hkJpTQDTo2M0UTjke8AiiYegPrGAjB77w6wHOxMVWYa
         CHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9TX9XzKRN7dNPcsRS3b4Jd5+wB3kzX0sXoNzZYYwbG4=;
        b=J2tFn/xJxZtaWZkjY2cvxkPKXE9mRJIGTpJgX5wtvIXFWOvNvueDW7KHOT+YaOFRIw
         gmImRnmy59VauTveS5Kj1Lu6TaymlRrPbMbgYdjUcL4938VYloUb/1U3dK2QtfdQV0L1
         TmjFtNWUnx4vEbT1G6XaGrBRsIPL6WFmECPLQ0MM7ve35UNtkMy7K3OBc0BUbHDiHbYF
         1kUdW7lWilZVokWsfqikThKmrCc6h0JcB6ffxu10B0r9Ne4aMUG/DHfZftYrLmheRVme
         g/CudwHJYvEK+MgiRWULbIP2Wp1E3XzcgWDp5H5f8kSqylUk9nOKRIw0Z6IqNtxMg93Y
         Opzg==
X-Gm-Message-State: AOAM531Lt96EEReeLMej6MHVAMk/VCYp/BMZhqwqrLmcO0WSstNYlA+f
        VwMmFhiRkq2RJHe445Erzh5d5GLmT+6xhA==
X-Google-Smtp-Source: ABdhPJxS5VQCC6i1Wt07RlUEsHrnlVzTLdCoR6eMOpbKPKiR4OqLNTj0eciwumkt74USs713xXbh1Q==
X-Received: by 2002:a17:90a:7f8a:: with SMTP id m10mr3374481pjl.47.1597870284645;
        Wed, 19 Aug 2020 13:51:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l78sm98024pfd.130.2020.08.19.13.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:51:24 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:51:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, jakub@cloudflare.com,
        john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5f3d90c432246_2c9b2adeefb585bc89@john-XPS-13-9370.notmuch>
In-Reply-To: <20200819092436.58232-5-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-5-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next 4/6] bpf: override the meaning of
 ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The verifier assumes that map values are simple blobs of memory, and
> therefore treats ARG_PTR_TO_MAP_VALUE, etc. as such. However, there are
> map types where this isn't true. For example, sockmap and sockhash store
> sockets. In general this isn't a big problem: we can just
> write helpers that explicitly requests PTR_TO_SOCKET instead of
> ARG_PTR_TO_MAP_VALUE.
> 
> The one exception are the standard map helpers like map_update_elem,
> map_lookup_elem, etc. Here it would be nice we could overload the
> function prototype for different kinds of maps. Unfortunately, this
> isn't entirely straight forward:
> We only know the type of the map once we have resolved meta->map_ptr
> in check_func_arg. This means we can't swap out the prototype
> in check_helper_call until we're half way through the function.
> 
> Instead, modify check_func_arg to treat ARG_PTR_TO_MAP_VALUE* to
> mean "the native type for the map" instead of "pointer to memory"
> for sockmap and sockhash. This means we don't have to modify the
> function prototype at all
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  kernel/bpf/verifier.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b6ccfce3bf4c..47f9b94bb9d4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3872,6 +3872,38 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
>  	return -EINVAL;
>  }
>  
> +static int override_map_arg_type(struct bpf_verifier_env *env,
> +				 const struct bpf_call_arg_meta *meta,
> +				 enum bpf_arg_type *arg_type)

One nit can we rename this to refine_map_arg_type or resolve_map_arg_type I
don't like the name "override" we are getting a more precise type here.

> +{
> +	if (!meta->map_ptr) {
> +		/* kernel subsystem misconfigured verifier */
> +		verbose(env, "invalid map_ptr to access map->type\n");
> +		return -EACCES;
> +	}
> +
> +	switch (meta->map_ptr->map_type) {
> +	case BPF_MAP_TYPE_SOCKMAP:
> +	case BPF_MAP_TYPE_SOCKHASH:
> +		switch (*arg_type) {
> +		case ARG_PTR_TO_MAP_VALUE:
> +			*arg_type = ARG_PTR_TO_SOCKET;
> +			break;
> +		case ARG_PTR_TO_MAP_VALUE_OR_NULL:
> +			*arg_type = ARG_PTR_TO_SOCKET_OR_NULL;
> +			break;
> +		default:
> +			verbose(env, "invalid arg_type for sockmap/sockhash\n");

Might be worth pushing the arg_type into the verbose message so its obvious
where the types went wrong. We will probably "know" just based on the
switch in front of this, but users in general wont. Just a suggestion if
you think its overkill go ahead and skip.

> +			return -EINVAL;
> +		}
> +		break;
> +
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +

Otherwise LGTM.

>  static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>  			  struct bpf_call_arg_meta *meta,
>  			  const struct bpf_func_proto *fn)
> @@ -3904,6 +3936,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>  		return -EACCES;
>  	}
>  
> +	if (arg_type == ARG_PTR_TO_MAP_VALUE ||
> +	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> +	    arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
> +		err = override_map_arg_type(env, meta, &arg_type);
> +		if (err)
> +			return err;
> +	}
> +
>  	if (arg_type == ARG_PTR_TO_MAP_KEY ||
>  	    arg_type == ARG_PTR_TO_MAP_VALUE ||
>  	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> -- 
> 2.25.1
> 
