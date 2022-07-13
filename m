Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4047657359C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiGMLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbiGMLgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:36:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CAE610291A
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657712196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yrCSuJaHzqqJrDzlPoHK3BCroMA+MPPreiwAH9qdrfA=;
        b=JDcdVJFSnY3H8mKLTXNgmxEJzQ1kDPKnIpAOxkxsh4HEn/OGu+bz1Cre5/FbErriGM2fpu
        nV0LkPs5wZj5wg4zENTvIY6RMkymPTZHkqAHwsGfiCaHW7rB6BOj59ZB6paP9H8nUMqvQP
        SyumZ/4KerX1W63cYbngmMKCkUo7QDQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-XDYTI7SCOlqzZOV-fmCcgw-1; Wed, 13 Jul 2022 07:36:35 -0400
X-MC-Unique: XDYTI7SCOlqzZOV-fmCcgw-1
Received: by mail-pj1-f71.google.com with SMTP id o21-20020a17090a9f9500b001f0574225faso1415781pjp.6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yrCSuJaHzqqJrDzlPoHK3BCroMA+MPPreiwAH9qdrfA=;
        b=puNyG6lqjEOufubFrD7bom6cfpq+lO5SHUhSbWHfENLxXIpw+R6rqeVdANXaclJy4P
         ziP5EjFLbhmuPv/3CRbhrG3Xemr8J+FJA+lzawulLoXWOTqRs6XZKVfu8hb1VvyWqp+x
         jehn2xBKlQrm4sty0cjt7mqSCc0ahNTLumSRUA5guy4PNVNkoXUpsOdKIQ6GDf3CtQPV
         R5bdF6x30ZYfmMXIFaIEEd4PiXahii2BJ4yBsIOBI1/EIMqpjHALywCKL3Q/bUQH5Fiu
         xwNHubCHGdbggttbQsvVQST9U7SwHam1Z1qnAt25Zp3STPnhR9d0YMtoO5fv1+/51WST
         Xq/A==
X-Gm-Message-State: AJIora8PwWYqBIbZGN6uzuv5rgKZeUyIybC3to8daE0mM067AnWvJvnf
        ZwL8W2shpLaWxLETgqBIQsnsFFDyFnmCQfQZEcOH0TDdSHesT0FGWkJ1xJyQES4UBOVKWIHYROQ
        rC1fRrrVsYsBiC9bOBonncLapnri7W9cO
X-Received: by 2002:a63:5b16:0:b0:416:1b3b:9562 with SMTP id p22-20020a635b16000000b004161b3b9562mr2640553pgb.146.1657712193990;
        Wed, 13 Jul 2022 04:36:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tMvNaIU5RdJs8xFRKHMRkHgZ6gojSHT6mUC3bNG1PFZd6uvWCEzPNcBAqRmFF+sgNMHsiXK2QJJwUhF0wM9ws=
X-Received: by 2002:a63:5b16:0:b0:416:1b3b:9562 with SMTP id
 p22-20020a635b16000000b004161b3b9562mr2640529pgb.146.1657712193703; Wed, 13
 Jul 2022 04:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-13-benjamin.tissoires@redhat.com> <668a2f86-9446-61de-494c-f2d2ee15f09e@isovalent.com>
In-Reply-To: <668a2f86-9446-61de-494c-f2d2ee15f09e@isovalent.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Wed, 13 Jul 2022 13:36:22 +0200
Message-ID: <CAO-hwJ+23HWjRHx8463uL5hA1HMYcmPD2=63Fv=J__x7zvmLjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 12/23] HID: initial BPF implementation
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pu Lehui <pulehui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 10:48 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 12/07/2022 15:58, Benjamin Tissoires wrote:
[...]
> > diff --git a/drivers/hid/bpf/entrypoints/Makefile b/drivers/hid/bpf/entrypoints/Makefile
> > new file mode 100644
> > index 000000000000..dd60a460c6c4
> > --- /dev/null
> > +++ b/drivers/hid/bpf/entrypoints/Makefile
> > @@ -0,0 +1,88 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +OUTPUT := .output
> > +abs_out := $(abspath $(OUTPUT))
> > +
> > +CLANG ?= clang
> > +LLC ?= llc
> > +LLVM_STRIP ?= llvm-strip
> > +
> > +TOOLS_PATH := $(abspath ../../../../tools)
> > +BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
> > +BPFTOOL_OUTPUT := $(abs_out)/bpftool
> > +DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
> > +BPFTOOL ?= $(DEFAULT_BPFTOOL)
> > +
> > +LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
> > +LIBBPF_OUTPUT := $(abs_out)/libbpf
> > +LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
> > +LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
> > +BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
> > +
> > +INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE) -I$(TOOLS_PATH)/include/uapi
> > +CFLAGS := -g -Wall
> > +
> > +VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                         \
> > +                  $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \
> > +                  ../../../../vmlinux                                \
> > +                  /sys/kernel/btf/vmlinux                            \
> > +                  /boot/vmlinux-$(shell uname -r)
> > +VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> > +ifeq ($(VMLINUX_BTF),)
> > +$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> > +endif
> > +
> > +ifeq ($(V),1)
> > +Q =
> > +msg =
> > +else
> > +Q = @
> > +msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
> > +MAKEFLAGS += --no-print-directory
> > +submake_extras := feature_display=0
> > +endif
> > +
> > +.DELETE_ON_ERROR:
> > +
> > +.PHONY: all clean
> > +
> > +all: entrypoints.lskel.h
> > +
> > +clean:
> > +     $(call msg,CLEAN)
> > +     $(Q)rm -rf $(OUTPUT) entrypoints
> > +
> > +entrypoints.lskel.h: $(OUTPUT)/entrypoints.bpf.o | $(BPFTOOL)
> > +     $(call msg,GEN-SKEL,$@)
> > +     $(Q)$(BPFTOOL) gen skeleton -L $< > $@
> > +
> > +
> > +$(OUTPUT)/entrypoints.bpf.o: entrypoints.bpf.c $(OUTPUT)/vmlinux.h $(BPFOBJ) | $(OUTPUT)
> > +     $(call msg,BPF,$@)
> > +     $(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)                           \
> > +              -c $(filter %.c,$^) -o $@ &&                                 \
> > +     $(LLVM_STRIP) -g $@
> > +
> > +$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
> > +ifeq ($(VMLINUX_H),)
> > +     $(call msg,GEN,,$@)
> > +     $(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> > +else
> > +     $(call msg,CP,,$@)
> > +     $(Q)cp "$(VMLINUX_H)" $@
> > +endif
> > +
> > +$(OUTPUT) $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
> > +     $(call msg,MKDIR,$@)
> > +     $(Q)mkdir -p $@
> > +
> > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OUTPUT)
> > +     $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)                         \
> > +                 OUTPUT=$(abspath $(dir $@))/ prefix=                       \
> > +                 DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
> > +
> > +$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
> > +     $(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)                        \
> > +                 OUTPUT=$(BPFTOOL_OUTPUT)/                                  \
> > +                 LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/                            \
> > +                 LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/                          \
> > +                 prefix= DESTDIR=$(abs_out)/ install-bin
>
> Hi Benjamin,
>
> Note that, at other locations where bpftool is needed to generate the
> vmlinux.h or the skeletons, there is some work in progress to use only
> the "bootstrap" version of bpftool (the intermediary bpftool binary used
> to generate skeletons required for the final bpftool binary) [0]. This
> is enough to generate these objects, it makes compiling the bpftool
> binary faster, and solves some issues related to cross-compilation. It's
> probably worth exploring in your case (or as a follow-up) as well.
>

Hi Quentin,

Indeed, I applied a similar patch to [1] (the 3/3 in the series you
mentioned) and I have the exact same light skeleton.
I have stashed the changes locally for a future revision (I doubt
everything will go through in this version ;-P ).

Cheers,
Benjamin

> Quentin
>
> [0]
> https://lore.kernel.org/all/20220712030813.865410-1-pulehui@huawei.com/t/#u
>
[1] https://lore.kernel.org/all/20220712030813.865410-4-pulehui@huawei.com/

