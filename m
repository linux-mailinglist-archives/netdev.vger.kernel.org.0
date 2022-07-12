Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA295716E0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiGLKMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiGLKMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:12:22 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC70AB7E8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:11:56 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c131-20020a1c3589000000b003a2cc290135so4917799wma.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i2XYOzCUtA8Ta1rr8OzoyXDjrIADtZBW93UGTbpRQTs=;
        b=HuqOXEtE1Aefa8vkyqcUnK8kCIMt6cgP0dnwVak+AjhJ/OJs5cVFYIaPCgtc8AybKr
         PM1mAszWA+rKfgVfOqv32nx5ok8Q978lXTCZlK3ze46hzvc4YYD60jBe/HLJfP00kLrX
         bNCjxDultJYZJznYedjsjFfy0/mq/fejVM3zypto8nxiwJZ+IBvAcxf8cpBARlRSuNOA
         lpK5F/aGSKF9RpEaZSXaWZVDH2vIfnBMoIeaMVJPDOqjwZCBOcPb+IHx7t+E9kzv/q6L
         ojoJcJ/O5CjA++wuWCKvUpbgaN6WGsuwQgpqQkvkPFC3Qr0ueEfeV/uQw1y/AUvNAdPS
         DkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i2XYOzCUtA8Ta1rr8OzoyXDjrIADtZBW93UGTbpRQTs=;
        b=yKbThStxI9AUuhjJpsv/eOKSknO6xSGrUHs6Bw1MBiFp4ABrabMTSgUPjAlnoZ5gv+
         o4j8kOtl2HUqmzhxBjaZafNuJQt3WwLd/RaRUawJ2zPWlpNEeEGG7R2N2ZINjpnSClCy
         nWBvBmrDsvo/0ogDQK4/nSUr/LYr+GJSe9jtR/NKePL3tR5xMYHvoiW9eDC7DafeFFJ8
         OUx+/h8UjE/FMPFI0tcCjrVhm8q9P1fOE62wIGwSCNrwN1AJ8wmhBvKm2ENNMYgJ+vK4
         4O7T/IuN6l9T/tlzNyc5jIo1E0EJYfqucgsLttMgSGgll2qxlIStJ7xs4LjyOOHXiTV7
         WhKg==
X-Gm-Message-State: AJIora+CylhT/P0EIO8mMObF3k6A/9AmNYuZ0OXEOd+6ZmUB3lGLr3zO
        bvh6gElh7UqXPYh5pg4g36y47A==
X-Google-Smtp-Source: AGRyM1vDQohmXGbbjMuTB8tna0YftEx/WQsqRgPk4KBe+/NA1T7pca7ljNWjq5QzQB47mumtb7HS6g==
X-Received: by 2002:a05:600c:3845:b0:3a2:c04d:5ff9 with SMTP id s5-20020a05600c384500b003a2c04d5ff9mr2997243wmr.74.1657620715194;
        Tue, 12 Jul 2022 03:11:55 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id b2-20020adfde02000000b0021d9591c64fsm7895138wrm.33.2022.07.12.03.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 03:11:54 -0700 (PDT)
Message-ID: <e1dd40cd-647c-10b4-53f9-a313e509474e@isovalent.com>
Date:   Tue, 12 Jul 2022 11:11:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: Fix cross-compiling error by
 using bootstrap bpftool
Content-Language: en-GB
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220712030813.865410-1-pulehui@huawei.com>
 <20220712030813.865410-2-pulehui@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220712030813.865410-2-pulehui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/07/2022 04:08, Pu Lehui wrote:
> Currently, when cross compiling bpf samples, the host side cannot
> use arch-specific bpftool to generate vmlinux.h or skeleton. Since
> samples/bpf use bpftool for vmlinux.h, skeleton, and static linking
> only, we can use lightweight bootstrap version of bpftool to handle
> these, and it's always host-native.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  samples/bpf/Makefile | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 5002a5b9a7da..57012b8259d2 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -282,12 +282,18 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>  
>  BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
>  BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
> -BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
> +BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
> +ifeq ($(CROSS_COMPILE),)
>  $(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> -	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
> -		OUTPUT=$(BPFTOOL_OUTPUT)/ \
> -		LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
> -		LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
> +	$(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../		\
> +		OUTPUT=$(BPFTOOL_OUTPUT)/ 					\
> +		LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/ 			\
> +		LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
> +else
> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)

Thanks for this! Just trying to fully understand the details here. When
cross-compiling, you leave aside the dependency on target-arch-libbpf,
so that "make -C <bpftool-dir> bootstrap" rebuilds its own host-arch
libbpf, is this correct?

> +	$(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ 		\
> +		OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
> +endif
>  
>  $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
>  	$(call msg,MKDIR,$@)

