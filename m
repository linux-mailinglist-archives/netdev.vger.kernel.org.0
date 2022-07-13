Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042A2573CC8
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbiGMSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGMSw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:52:58 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659942F3A0;
        Wed, 13 Jul 2022 11:52:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id t1so5705661ejd.12;
        Wed, 13 Jul 2022 11:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bgHp5GltHRu7x3p+LHbRBECphkMhi0jBJngyJToasY=;
        b=ggeRot3BOwOSl6Mix3mhgE0RWM1j+eok5TQUCCvO2pl1qahgQfGis8fK7xZfEaTeDH
         Zs5nP1MYEVbRDq8lGMoPyePwI0NAbgiJrzdg6JIcl/HEA48Iy8wrD5QwdwXPu7WRi12R
         0/OKJn5Ljk3YKjjRHvfbPFqSR588dpz/rALG/feCNsxYN9bbFaWY/ijwNh4jBvbh3Uv8
         APUJr68H6KEPp5i6kWGkJfg8RxaxXsZ5L8wt/QffrHhLoVvWx/3dVpgieAsYNRxpdCL1
         sKrgjs54Rq5GOLXGlEioSuFlL4iDL3Oh3DyfQnrLsfq2Cjl9dotmGw/8aGEIZRL8jzCX
         Q6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0bgHp5GltHRu7x3p+LHbRBECphkMhi0jBJngyJToasY=;
        b=w1sIrMBPGYOUVX4rOpdPZybzulYQty8cb5Wx+sV8T1iZ7QQb7bt/NHtdoGv7HvdoUW
         mhMKQ7QsG9S1FGdfoOANzJ4iF/9Eeb+45T8n3FfzSkwso8yfh5oRP8sVoOZ0Eu6mY6Xw
         zs9PKGbe0cINhxRaaPtrCYcI/NZAnoBi7oHfxJ0Y7JQZWywqJngmLp8dcSWSGyjycyz/
         +tONMRDwSzAr3h+U6s2iOQ3d/5d2dZH1+1dKWTyD68Kiiplg1wFOVrKzdw5GCbqPJVQb
         WGWYyQ1Bc+5p4T4UZIB6rm5V2z9sqmUFGlPib4fKPXiXzol9yZYpgiIxkGZpBiC/nfAa
         90GQ==
X-Gm-Message-State: AJIora+4No9VWWHOCB8SdA/qN69z0gMM2EyfnWmb6Id5su0X/wqeQaAn
        kqy718NSbxyWx0xPwAyYugf/wOo6tYCflZMXkvQ=
X-Google-Smtp-Source: AGRyM1sksK1ex29u77iuCP6vw0V3I40Ta7AANfhP1ySgvZslVV4Zce6BHLB+70fA25Tn0NQdu08l+RjEtFK5fSXQ5Pg=
X-Received: by 2002:a17:906:cc0c:b0:72b:68df:8aff with SMTP id
 ml12-20020a170906cc0c00b0072b68df8affmr4921265ejb.226.1657738376004; Wed, 13
 Jul 2022 11:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220712030813.865410-1-pulehui@huawei.com> <20220712030813.865410-3-pulehui@huawei.com>
In-Reply-To: <20220712030813.865410-3-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 11:52:44 -0700
Message-ID: <CAEf4BzYQM0RpsgUZgZpcMuDRSD2o96HzWzSeU5=GC0YfmjiXug@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] tools: runqslower: build and use lightweight
 bootstrap version of bpftool
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 7:37 PM Pu Lehui <pulehui@huawei.com> wrote:
>
> tools/runqslower use bpftool for vmlinux.h, skeleton, and static linking
> only. So we can use lightweight bootstrap version of bpftool to handle
> these, and it will be faster.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/bpf/runqslower/Makefile | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index da6de16a3dfb..8900c74f29e2 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -4,7 +4,7 @@ include ../../scripts/Makefile.include
>  OUTPUT ?= $(abspath .output)/
>
>  BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
> -DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bpftool
> +DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bootstrap/bpftool
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>  LIBBPF_SRC := $(abspath ../../lib/bpf)
>  BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
> @@ -86,6 +86,12 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OU
>         $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) \
>                     DESTDIR=$(BPFOBJ_OUTPUT) prefix= $(abspath $@) install_headers
>
> +ifeq ($(CROSS_COMPILE),)
>  $(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
>         $(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT)   \
> -                   ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD)
> +                   LIBBPF_BOOTSTRAP_OUTPUT=$(BPFOBJ_OUTPUT)                   \
> +                   LIBBPF_BOOTSTRAP_DESTDIR=$(BPF_DESTDIR) bootstrap
> +else
> +$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
> +       $(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT) bootstrap
> +endif

Same comment as on the other patch, this CROSS_COMPILE if/else seems a
bit fragile, let's keep only the second cleaner part, maybe?


> --
> 2.25.1
>
