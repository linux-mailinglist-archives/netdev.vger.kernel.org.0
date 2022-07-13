Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736D5573CCE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbiGMSzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGMSzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:55:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1497922501;
        Wed, 13 Jul 2022 11:55:22 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r6so15259221edd.7;
        Wed, 13 Jul 2022 11:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJ3J6U3erLSOZGmNYbqKk0ATHfm/1BrLEtgC9UcaHwo=;
        b=Ck/CbbA3OX5lp6LJ1sZabGr2T1OfzinQavxwJznhg7ruAvLjEkPjlFH/V3pCfUo+/d
         4oF7x5IxUBM2EXS05a5QXtJCfqN6oq1B4ZmongtVQcdc2zF9HzxoaA8aQYOxzgTpOBmQ
         m8tBDC/s1MLH55xfue5EcLgojVhpIzXy9CcFDcsiS4k4f0Q1toJ2tPCdUyFrx/oIafDE
         Qblnt3VX1OsIR7ahvQ1PZ7Omp4pIDFS3laEkNHqce/lfIo0+6obI5naze8eOkxvX0P/k
         Khk4dC0GTy/SfhJiGHoOvBkew69TIVBTePT3PDzGIds2odhOqnPhE9DgRI15ZCCLfx/S
         sumg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJ3J6U3erLSOZGmNYbqKk0ATHfm/1BrLEtgC9UcaHwo=;
        b=iqQMeK8XSxUJq0t5lQvd3AnbIWfFHjAsxT3uvOt6I2vZeiEDAlm/1qPYHCaDnsjtAJ
         dKRS0/EUT+N3/ZHBskJhYcPCgzJg7+oHWh+MDKzEbm3f1cR0GsZs7j3TTmAU/VCkYR2J
         Nx+s+t/Lx036LCtcHu83MEtqEo8/sNU94p7VFDaVywZ24HXI2ZiSrxetuojqQy1C4NV2
         4s+l7fZidDOqaFnBgUQkmW2YSuMVbfMS2KGGNwzkozt1xj5jGZwe539HuRhPsSsMX79t
         0+r+8IinGL8WnSSkGJ50Nh+IduYvI25w2hkcFX2WNg5ObOyssMVwRggu2QJufsrLKo2n
         PmJg==
X-Gm-Message-State: AJIora9SmQKalufQ3i6R7l2TsBfPMn9ev28aLMuXp1dn5ov4Vq6ZSHwN
        rXr4t3RX+P+t/CRHobPNUb3k6pqcP0EDMRU4BYw=
X-Google-Smtp-Source: AGRyM1uGJ5Rq/+ji5AnvmRPbCnPH5vNTAo4mUKyX374Kypr7qWhpOUP5legkS9SOVPXKUMvRjp/O0exg310NcurxyS4=
X-Received: by 2002:a05:6402:228f:b0:43a:896:e4f0 with SMTP id
 cw15-20020a056402228f00b0043a0896e4f0mr6767659edb.81.1657738520636; Wed, 13
 Jul 2022 11:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220712030813.865410-1-pulehui@huawei.com> <20220712030813.865410-4-pulehui@huawei.com>
In-Reply-To: <20220712030813.865410-4-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 11:55:09 -0700
Message-ID: <CAEf4Bza15HfVKDrA8dV+U5GJiDcPS0bnV81rmdxuFn0+_2hrXw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: iterators: build and use lightweight
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
> kernel/bpf/preload/iterators use bpftool for vmlinux.h, skeleton, and
> static linking only. So we can use lightweight bootstrap version of
> bpftool to handle these, and it will be faster.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  kernel/bpf/preload/iterators/Makefile | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
> index bfe24f8c5a20..cf5f39f95fed 100644
> --- a/kernel/bpf/preload/iterators/Makefile
> +++ b/kernel/bpf/preload/iterators/Makefile
> @@ -9,7 +9,7 @@ LLVM_STRIP ?= llvm-strip
>  TOOLS_PATH := $(abspath ../../../../tools)
>  BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
>  BPFTOOL_OUTPUT := $(abs_out)/bpftool
> -DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
> +DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>
>  LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
> @@ -61,9 +61,14 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>                     OUTPUT=$(abspath $(dir $@))/ prefix=                       \
>                     DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
>
> +ifeq ($(CROSS_COMPILE),)
>  $(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
>         $(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)                        \
>                     OUTPUT=$(BPFTOOL_OUTPUT)/                                  \
> -                   LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/                            \
> -                   LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/                          \
> -                   prefix= DESTDIR=$(abs_out)/ install-bin
> +                   LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/                  \
> +                   LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
> +else
> +$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)                        \
> +                   OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
> +endif

another idea (related to my two previous comments for this patch set),
maybe we can teach bpftool's Makefile to reuse LIBBPF_OUTPUT as
LIBBPF_BOOTSTRAP_OUTPUT, if there is no CROSS_COMPILE? Then we can
keep iterators/Makefile, samples/bpf/Makefile and runqslower/Makefile
simpler and ignorant of CROSS_COMPILE, but still get the benefit of
not rebuilding libbpf unnecessarily in non-cross-compile mode?

> --
> 2.25.1
>
