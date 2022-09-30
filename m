Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C405F10FD
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiI3Rho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiI3Rhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:37:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E31DBEEA;
        Fri, 30 Sep 2022 10:37:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h7so7867810wru.10;
        Fri, 30 Sep 2022 10:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=4DpRehj64wbjbBKzPjGMiI2BBSTE79pTuDiNAxSu6DI=;
        b=Q+yuIbNZLqL1Jdi8evRRwF8ncYYX5SQbBpfF+NnMkWBe4HvN+aTBBOnBG7aWFhjT7e
         BjGJB3HXDnyn+aPH7Nd7vKgDikN7rTCrnTweu/PQfs3hD2r671IcofuvBs3weGIYmufn
         6+xBijHDTvvF+UWIWVtW2zWlBU3LkudlmZYx/XerHaARq8CIb6u0wcATmxtZyOJSxpw2
         1w+16GAlmjRSjg3P0L1g2t0YBtFiMBHTC9nNB8nL8dyrBgHzciXBGZVFjBOgpAhtwBJS
         D/cm94IdS2ZSwIT6UWhN60UlePAkUpew7aRezro6DNOXJCCxeEpOR6aJ/3QPIBensAy1
         usyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=4DpRehj64wbjbBKzPjGMiI2BBSTE79pTuDiNAxSu6DI=;
        b=taaZZWi03wB7Ze32q8GCXIv/8u+p26ngdt5vJqjFPfPN/3z8eEmwXHSeatlCYeH05o
         79+YvTqWl1g9aBdX19bCbBbWifwGb86QbKPyi0weVfMs6zn+vQc4mWwRpRvVvZnBUR9S
         16LV7LKvLbL+ihSHEVaNgpI6bqvqYpSdkMKbL3/h/pbyTEOFnHUjK04Jni1wbddH14MQ
         JnYwiFL5ypNpnGt/vtkZcwHDxNg1NArYc5qtC77phu1vlWIdZ+IiNwx9VTfjEr4y6e6e
         fEDRUSsxxVXAH3inlIp6jAf0UkfwMDoWOwxBqeignoqmRsdu/4QzsNXRR13HBGlqeNJm
         HhEA==
X-Gm-Message-State: ACrzQf0yrxTB4K2pOamNQ8KQDtQVz1ifH4CaeJj0y7H9nzo4C0cEbQXo
        /xEHFvDpFQAXNn7u1Jqwc00=
X-Google-Smtp-Source: AMsMyM4pYq9Ma/gyFQ/ttIX3J+Nka2o7KD3K3QUfaCql7zhOjdxPmhURcdTBheiwr1dSiX2K6U4CgA==
X-Received: by 2002:a5d:684f:0:b0:228:d83f:5e3c with SMTP id o15-20020a5d684f000000b00228d83f5e3cmr6521226wrw.318.1664559460858;
        Fri, 30 Sep 2022 10:37:40 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id p3-20020a5d4e03000000b002238ea5750csm1701501wrt.72.2022.09.30.10.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 10:37:40 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 30 Sep 2022 19:37:38 +0200
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
Subject: Re: [PATCH bpf-next] selftests/bpf: make libbpf_probe_prog_types
 testcase aware of kernel configuration
Message-ID: <YzcpYjkv8RBaZQcM@krava>
References: <20220930110900.75492-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930110900.75492-1-asavkov@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 01:09:00PM +0200, Artem Savkov wrote:
> At the moment libbpf_probe_prog_types test iterates over all available
> BPF_PROG_TYPE regardless of kernel configuration which can exclude some
> of those. Unfortunately there is no direct way to tell which types are
> available, but we can look at struct bpf_ctx_onvert to tell which ones
> are available.
> 
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/libbpf_probes.c  | 33 +++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c b/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
> index 9f766ddd946ab..753ddf79cf5e0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
> +++ b/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
> @@ -4,12 +4,29 @@
>  #include <test_progs.h>
>  #include <bpf/btf.h>
>  
> +static int find_type_in_ctx_convert(struct btf *btf,
> +				    const char *prog_type_name,
> +				    const struct btf_type *t)
> +{
> +	const struct btf_member *m;
> +	size_t cmplen = strlen(prog_type_name);
> +	int i, n;
> +
> +	for (m = btf_members(t), i = 0, n = btf_vlen(t); i < n; m++, i++) {
> +		const char *member_name = btf__str_by_offset(btf, m->name_off);
> +
> +		if (!strncmp(prog_type_name, member_name, cmplen))
> +			return 1;
> +	}
> +	return 0;
> +}
> +
>  void test_libbpf_probe_prog_types(void)
>  {
>  	struct btf *btf;
> -	const struct btf_type *t;
> +	const struct btf_type *t, *context_convert_t;
>  	const struct btf_enum *e;
> -	int i, n, id;
> +	int i, n, id, context_convert_id;
>  
>  	btf = btf__parse("/sys/kernel/btf/vmlinux", NULL);
>  	if (!ASSERT_OK_PTR(btf, "btf_parse"))
> @@ -23,6 +40,14 @@ void test_libbpf_probe_prog_types(void)
>  	if (!ASSERT_OK_PTR(t, "bpf_prog_type_enum"))
>  		goto cleanup;
>  
> +	context_convert_id = btf__find_by_name_kind(btf, "bpf_ctx_convert",
> +						    BTF_KIND_STRUCT);
> +	if (!ASSERT_GT(context_convert_id, 0, "bpf_ctx_convert_id"))
> +		goto cleanup;
> +	context_convert_t = btf__type_by_id(btf, context_convert_id);
> +	if (!ASSERT_OK_PTR(t, "bpf_ctx_convert_type"))

ASSERT_OK_PTR should check context_convert_t ?

I wonder if we could traverse bpf_ctx_convert members directly
instead of bpf_prog_type enum, but maybe there'd be other issues

jirka

> +		goto cleanup;
> +
>  	for (e = btf_enum(t), i = 0, n = btf_vlen(t); i < n; e++, i++) {
>  		const char *prog_type_name = btf__str_by_offset(btf, e->name_off);
>  		enum bpf_prog_type prog_type = (enum bpf_prog_type)e->val;
> @@ -31,6 +56,10 @@ void test_libbpf_probe_prog_types(void)
>  		if (prog_type == BPF_PROG_TYPE_UNSPEC)
>  			continue;
>  
> +		if (!find_type_in_ctx_convert(btf, prog_type_name,
> +					      context_convert_t))
> +			continue;
> +
>  		if (!test__start_subtest(prog_type_name))
>  			continue;
>  
> -- 
> 2.37.3
> 
