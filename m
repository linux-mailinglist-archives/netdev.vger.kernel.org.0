Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52681573185
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiGMItB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiGMIs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:48:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AF8E03E
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:48:46 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bu1so13308661wrb.9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h6g5uJIv3ktxDvHxrK6ISo0m1BGbhqs5ZaLO4zM2se4=;
        b=lhHmsz6bc/KZhJlgJbamwNnE0Ejo/KP2xqmVRN+TpkLc3KJurEQYoLmGm2EFF7P+LM
         xgZY4E8IQ3PG4j6ozbErPKRw5t+EcfAV7qdoo2fch3mDLDMZk9UU1hsf0geJMQsNB6so
         9/u18HqJ9Sgel++YoWceDBwy7ZfbJ2rzcr51J3I9wo4YmYU6Y23BVh/VvUnM3Fpq5sQT
         ZqpJKyghpnMG3dkCrapXwgMVuTrSPsEubWn77DxNUwMi/zF+IK9RoX78bU0wN5BiK3yW
         8CQwgkdtvnxvx7gt56SAIY1btf7rFwtms2PwYXdhGrZMeW9d62uW3RHZsIichCIOEByd
         gH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h6g5uJIv3ktxDvHxrK6ISo0m1BGbhqs5ZaLO4zM2se4=;
        b=W8T0LcPxBmiJODUzRek7R/3JokqxlAqKj39drG1Z96snfCZpjs4B6XfdL34tfpJ6Qn
         TF11zaeLk8tZk02M7tzSBgrzObfL1M65QjWdNrtrUTbjckfwhptP6QQNs4f3ofXFte5d
         G/QPS2xIwlsuCvgNPhivN+MY0LLcCFw1X+ybCJz+B9ipC9rmxrtrHpx1+qQZNLZm/yiu
         mLWWTiURl0Er64TivA0sqcaYk7+yK1dl/+ecJUtEKTjz6TkAhCk1crbMJmB7bKmS0/++
         6B3UkroeB91HsX6BsIK00TYSruFloenix5ffytXyukAsVnz/bj3t2FWfRqyn2lGrXbzK
         +nRQ==
X-Gm-Message-State: AJIora+7kaS8LteGCUUERRdZKxYS8xeqgRKvHjj7+7lEX138et2mMOXX
        uMYkecesEkuUBsOKmk71RgmHAA==
X-Google-Smtp-Source: AGRyM1sBfA/YZ/XdYxUSPw+34l5uN/CpJXd5UkFyWG0owvkQ9EV3Tsz92vW7iSDK/rzr5kV71CBnVA==
X-Received: by 2002:a5d:6b0e:0:b0:21d:7886:f4ba with SMTP id v14-20020a5d6b0e000000b0021d7886f4bamr2121466wrw.91.1657702124953;
        Wed, 13 Jul 2022 01:48:44 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id b17-20020adff911000000b0021d819c8f6dsm10240459wrr.39.2022.07.13.01.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 01:48:44 -0700 (PDT)
Message-ID: <668a2f86-9446-61de-494c-f2d2ee15f09e@isovalent.com>
Date:   Wed, 13 Jul 2022 09:48:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH bpf-next v6 12/23] HID: initial BPF implementation
Content-Language: en-GB
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Pu Lehui <pulehui@huawei.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-13-benjamin.tissoires@redhat.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220712145850.599666-13-benjamin.tissoires@redhat.com>
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

On 12/07/2022 15:58, Benjamin Tissoires wrote:
> Declare an entry point that can use fmod_ret BPF programs, and
> also an API to access and change the incoming data.
> 
> A simpler implementation would consist in just calling
> hid_bpf_device_event() for any incoming event and let users deal
> with the fact that they will be called for any event of any device.
> 
> The goal of HID-BPF is to partially replace drivers, so this situation
> can be problematic because we might have programs which will step on
> each other toes.
> 
> For that, we add a new API hid_bpf_attach_prog() that can be called
> from a syscall and we manually deal with a jump table in hid-bpf.
> 
> Whenever we add a program to the jump table (in other words, when we
> attach a program to a HID device), we keep the number of time we added
> this program in the jump table so we can release it whenever there are
> no other users.
> 
> HID devices have an RCU protected list of available programs in the
> jump table, and those programs are called one after the other thanks
> to bpf_tail_call().
> 
> To achieve the detection of users losing their fds on the programs we
> attached, we add 2 tracing facilities on bpf_prog_release() (for when
> a fd is closed) and bpf_free_inode() (for when a pinned program gets
> unpinned).
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v6:
> - use BTF_ID to get the btf_id of hid_bpf_device_event instead of
>   loading/unloading a dummy eBPF program.
> 
> changes in v5:
> - all the HID bpf operations are in their dedicated module
> - a bpf program is preloaded on startup so we can call subsequent
>   calls with bpf_tail_call
> - make hid_bpf_ctx more compact
> - add a dedicated hid_bpf_attach_prog() API
> - store the list of progs in each hdev
> - monitor the calls to bpf_prog_release to automatically release
>   attached progs when there are no other users
> - add kernel docs directly when functions are defined
> 
> new-ish in v4:
> - far from complete, but gives an overview of what we can do now.
> 
> fix initial HID-bpf
> ---
>  drivers/hid/Kconfig                           |   2 +
>  drivers/hid/Makefile                          |   2 +
>  drivers/hid/bpf/Kconfig                       |  19 +
>  drivers/hid/bpf/Makefile                      |  11 +
>  drivers/hid/bpf/entrypoints/Makefile          |  88 +++
>  drivers/hid/bpf/entrypoints/README            |   4 +
>  drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
>  .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++++++++
>  drivers/hid/bpf/hid_bpf_dispatch.c            | 235 ++++++
>  drivers/hid/bpf/hid_bpf_dispatch.h            |  27 +
>  drivers/hid/bpf/hid_bpf_jmp_table.c           | 568 +++++++++++++++
>  drivers/hid/hid-core.c                        |  15 +
>  include/linux/hid.h                           |   5 +
>  include/linux/hid_bpf.h                       |  99 +++
>  include/uapi/linux/hid_bpf.h                  |  25 +
>  tools/include/uapi/linux/hid.h                |  62 ++
>  tools/include/uapi/linux/hid_bpf.h            |  25 +
>  17 files changed, 1935 insertions(+)
>  create mode 100644 drivers/hid/bpf/Kconfig
>  create mode 100644 drivers/hid/bpf/Makefile
>  create mode 100644 drivers/hid/bpf/entrypoints/Makefile
>  create mode 100644 drivers/hid/bpf/entrypoints/README
>  create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
>  create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
>  create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
>  create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
>  create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
>  create mode 100644 include/linux/hid_bpf.h
>  create mode 100644 include/uapi/linux/hid_bpf.h
>  create mode 100644 tools/include/uapi/linux/hid.h
>  create mode 100644 tools/include/uapi/linux/hid_bpf.h
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 70da5931082f..4bedced90545 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -1310,6 +1310,8 @@ endmenu
>  
>  endif # HID
>  
> +source "drivers/hid/bpf/Kconfig"
> +
>  source "drivers/hid/usbhid/Kconfig"
>  
>  source "drivers/hid/i2c-hid/Kconfig"
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index cac2cbe26d11..94672a2d4fbb 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -5,6 +5,8 @@
>  hid-y			:= hid-core.o hid-input.o hid-quirks.o
>  hid-$(CONFIG_DEBUG_FS)		+= hid-debug.o
>  
> +obj-$(CONFIG_HID_BPF)		+= bpf/
> +
>  obj-$(CONFIG_HID)		+= hid.o
>  obj-$(CONFIG_UHID)		+= uhid.o
>  
> diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
> new file mode 100644
> index 000000000000..c54a2f07b8d7
> --- /dev/null
> +++ b/drivers/hid/bpf/Kconfig
> @@ -0,0 +1,19 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +menu "HID-BPF support"
> +	#depends on x86_64
> +
> +config HID_BPF
> +	bool "HID-BPF support"
> +	default y
> +	depends on BPF && BPF_SYSCALL
> +	select HID
> +	help
> +	This option allows to support eBPF programs on the HID subsystem.
> +	eBPF programs can fix HID devices in a lighter way than a full
> +	kernel patch and allow a lot more flexibility.
> +
> +	For documentation, see Documentation/hid/hid-bpf.rst
> +
> +	If unsure, say Y.
> +
> +endmenu
> diff --git a/drivers/hid/bpf/Makefile b/drivers/hid/bpf/Makefile
> new file mode 100644
> index 000000000000..cf55120cf7d6
> --- /dev/null
> +++ b/drivers/hid/bpf/Makefile
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for HID-BPF
> +#
> +
> +LIBBPF_INCLUDE = $(srctree)/tools/lib
> +
> +obj-$(CONFIG_HID_BPF) += hid_bpf.o
> +CFLAGS_hid_bpf_dispatch.o += -I$(LIBBPF_INCLUDE)
> +CFLAGS_hid_bpf_jmp_table.o += -I$(LIBBPF_INCLUDE)
> +hid_bpf-objs += hid_bpf_dispatch.o hid_bpf_jmp_table.o
> diff --git a/drivers/hid/bpf/entrypoints/Makefile b/drivers/hid/bpf/entrypoints/Makefile
> new file mode 100644
> index 000000000000..dd60a460c6c4
> --- /dev/null
> +++ b/drivers/hid/bpf/entrypoints/Makefile
> @@ -0,0 +1,88 @@
> +# SPDX-License-Identifier: GPL-2.0
> +OUTPUT := .output
> +abs_out := $(abspath $(OUTPUT))
> +
> +CLANG ?= clang
> +LLC ?= llc
> +LLVM_STRIP ?= llvm-strip
> +
> +TOOLS_PATH := $(abspath ../../../../tools)
> +BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
> +BPFTOOL_OUTPUT := $(abs_out)/bpftool
> +DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
> +BPFTOOL ?= $(DEFAULT_BPFTOOL)
> +
> +LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
> +LIBBPF_OUTPUT := $(abs_out)/libbpf
> +LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
> +LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
> +BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
> +
> +INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE) -I$(TOOLS_PATH)/include/uapi
> +CFLAGS := -g -Wall
> +
> +VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
> +		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
> +		     ../../../../vmlinux				\
> +		     /sys/kernel/btf/vmlinux				\
> +		     /boot/vmlinux-$(shell uname -r)
> +VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> +ifeq ($(VMLINUX_BTF),)
> +$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> +endif
> +
> +ifeq ($(V),1)
> +Q =
> +msg =
> +else
> +Q = @
> +msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
> +MAKEFLAGS += --no-print-directory
> +submake_extras := feature_display=0
> +endif
> +
> +.DELETE_ON_ERROR:
> +
> +.PHONY: all clean
> +
> +all: entrypoints.lskel.h
> +
> +clean:
> +	$(call msg,CLEAN)
> +	$(Q)rm -rf $(OUTPUT) entrypoints
> +
> +entrypoints.lskel.h: $(OUTPUT)/entrypoints.bpf.o | $(BPFTOOL)
> +	$(call msg,GEN-SKEL,$@)
> +	$(Q)$(BPFTOOL) gen skeleton -L $< > $@
> +
> +
> +$(OUTPUT)/entrypoints.bpf.o: entrypoints.bpf.c $(OUTPUT)/vmlinux.h $(BPFOBJ) | $(OUTPUT)
> +	$(call msg,BPF,$@)
> +	$(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)			      \
> +		 -c $(filter %.c,$^) -o $@ &&				      \
> +	$(LLVM_STRIP) -g $@
> +
> +$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
> +ifeq ($(VMLINUX_H),)
> +	$(call msg,GEN,,$@)
> +	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> +else
> +	$(call msg,CP,,$@)
> +	$(Q)cp "$(VMLINUX_H)" $@
> +endif
> +
> +$(OUTPUT) $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
> +	$(call msg,MKDIR,$@)
> +	$(Q)mkdir -p $@
> +
> +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OUTPUT)
> +	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
> +		    OUTPUT=$(abspath $(dir $@))/ prefix=		       \
> +		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
> +
> +$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)			       \
> +		    OUTPUT=$(BPFTOOL_OUTPUT)/				       \
> +		    LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/			       \
> +		    LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/			       \
> +		    prefix= DESTDIR=$(abs_out)/ install-bin

Hi Benjamin,

Note that, at other locations where bpftool is needed to generate the
vmlinux.h or the skeletons, there is some work in progress to use only
the "bootstrap" version of bpftool (the intermediary bpftool binary used
to generate skeletons required for the final bpftool binary) [0]. This
is enough to generate these objects, it makes compiling the bpftool
binary faster, and solves some issues related to cross-compilation. It's
probably worth exploring in your case (or as a follow-up) as well.

Quentin

[0]
https://lore.kernel.org/all/20220712030813.865410-1-pulehui@huawei.com/t/#u
