Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1348EA53
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfHOLcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:32:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33554 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730944AbfHOLcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 07:32:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so1231762pfq.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 04:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6yyNNZcoZXd04iOxCA2uv7QHQpYeH3o1GL76tGnvZsI=;
        b=BdQMSyc7Ew3WW/RLs9+hxDLI4sxwJvXm8pIJM78jiMehrBRUjW+8VSjLqWzqtwoFZn
         Esj/v9R8BWdvpkoa0amEwj8W1IG3tgXWbyiYUqEDHkDvdarSI3uAogTd25i00Umn2DZ1
         tAYIG0r3PM5WaOf2/6Ix2ZU83b83MImN/bJKcbbhVVegy3Gict/B0VTDGpmXW3KWqB45
         9UdCJi9C/lodmvIaiSLzOI1jNmnfOHHv3bOAJX82boWFEJ3aK0+YhKCbrllvi5V7jVWk
         EcDaBlgsSE3R+QchaiNUDjooXbQNZO4O1md6PP5OlqJncyCrfx5nWsYX3yIK1xVHj4cE
         xZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6yyNNZcoZXd04iOxCA2uv7QHQpYeH3o1GL76tGnvZsI=;
        b=Qw6izSaIbNZVv4oxeMYwWOAkxtH8kEmz1FFgobZfEL2pSJT7baLhRyBtruyFgYK11r
         SYUIxvWKetqvOYW1IXdQfqClz06XwAAGG+/zJ8PwTTmtlnQzzK8ssNbfmweXcg9wdROi
         7uzhPrjMeeyoAJul9JNIna1Wk9W/HHXdJmBpcCUMV0aXdshiSDsHBAMDBZTEtTk+UGuc
         g981+E5l92M+/hre5vXCOCrjwF8y9UEf9ZzVDwyXA8Pz/b9pYshK+U+kztAS5wnbS2M6
         5BWKBJEtXxADBBzA0Zc97k7yIOrbWdjZrnMZAnlrqudZ52MoEg6wocfEP3bQJu7E3bBE
         iPYA==
X-Gm-Message-State: APjAAAUalDivDYi8afNEalfZXdZkYk7n8W5q9nYkDC2387v6WQmxHeIj
        SQRbOuHn63kIqHeDbtwgmoR3jA==
X-Google-Smtp-Source: APXvYqwgHmgCJuJEfgUj6l4fxv/gOjQK+RkzIq0qwwxYOQmPh1Tiut8Hgxg0E93Jt/4ki2OwB4k+8A==
X-Received: by 2002:a17:90a:bc06:: with SMTP id w6mr1878592pjr.130.1565868771311;
        Thu, 15 Aug 2019 04:32:51 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id t6sm1190242pjy.18.2019.08.15.04.32.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 04:32:50 -0700 (PDT)
Date:   Thu, 15 Aug 2019 19:32:42 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5] perf machine: arm/arm64: Improve completeness for
 kernel address space
Message-ID: <20190815113242.GA28881@leoy-ThinkPad-X240s>
References: <20190815082521.16885-1-leo.yan@linaro.org>
 <d874e6b3-c115-6c8c-bb12-160cfd600505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d874e6b3-c115-6c8c-bb12-160cfd600505@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian,

On Thu, Aug 15, 2019 at 11:54:54AM +0300, Adrian Hunter wrote:

[...]

> > diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> > index e4988f49ea79..d7ff839d8b20 100644
> > --- a/tools/perf/Makefile.config
> > +++ b/tools/perf/Makefile.config
> > @@ -48,9 +48,20 @@ ifeq ($(SRCARCH),x86)
> >    NO_PERF_REGS := 0
> >  endif
> >  
> > +ARM_PRE_START_SIZE := 0
> > +
> >  ifeq ($(SRCARCH),arm)
> >    NO_PERF_REGS := 0
> >    LIBUNWIND_LIBS = -lunwind -lunwind-arm
> > +  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
> > +    # Extract info from lds:
> > +    #   . = ((0xC0000000)) + 0x00208000;
> > +    # ARM_PRE_START_SIZE := 0x00208000
> > +    ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
> > +      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
> > +      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> > +      awk -F' ' '{printf "0x%x", $$2}' 2>/dev/null)
> > +  endif
> >  endif
> >  
> >  ifeq ($(SRCARCH),arm64)
> > @@ -58,8 +69,19 @@ ifeq ($(SRCARCH),arm64)
> >    NO_SYSCALL_TABLE := 0
> >    CFLAGS += -I$(OUTPUT)arch/arm64/include/generated
> >    LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
> > +  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
> > +    # Extract info from lds:
> > +    #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
> > +    # ARM_PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000) = 0x10080000
> > +    ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
> > +      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
> > +      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> > +      awk -F' ' '{printf "0x%x", $$6+$$7+$$8}' 2>/dev/null)
> > +  endif
> 
> So, that is not going to work if you take a perf.data file to a non-arm machine?

Yeah, this patch will only allow perf to work correctly when perf
run natively on arm/arm64, so it can resolve partial of the issue.

> How come you cannot use kallsyms to get the information?

Thanks for pointing out this.  Sorry I skipped your comment "I don't
know how you intend to calculate ARM_PRE_START_SIZE" when you reviewed
the patch v3, I should use that chance to elaborate the detailed idea
and so can get more feedback/guidance before procceed.

Actually, I have considered to use kallsyms when worked on the previous
patch set.

As mentioned in patch set v4's cover letter, I tried to implement
machine__create_extra_kernel_maps() for arm/arm64, the purpose is to
parse kallsyms so can find more kernel maps and thus also can fixup
the kernel start address.  But I found the 'perf script' tool directly
calls machine__get_kernel_start() instead of running into the flow for
machine__create_extra_kernel_maps(); so I finally gave up to use
machine__create_extra_kernel_maps() for tweaking kernel start address
and went back to use this patch's approach by parsing lds files.

So for next step, I want to get some guidances:

- One method is to add a new weak function, e.g.
  arch__fix_kernel_text_start(), then every arch can implement its own
  function to fixup the kernel start address;

  For arm/arm64, can use kallsyms to find the symbols with least
  address and fixup for kernel start address.

- Another method is to directly parse kallsyms in the function
  machine__get_kernel_start(), thus the change can be used for all
  archs;

Seems to me the second method is to address this issue as a common
issue crossing all archs.  But not sure if this is the requirement for
all archs or just this is only required for arm/arm64.  Please let me
know what's your preference or other thoughts.  Thanks a lot!

Leo.

> >  endif
> >  
> > +CFLAGS += -DARM_PRE_START_SIZE=$(ARM_PRE_START_SIZE)
> > +
> >  ifeq ($(SRCARCH),csky)
> >    NO_PERF_REGS := 0
> >  endif
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index f6ee7fbad3e4..e993f891bb82 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -2687,13 +2687,26 @@ int machine__get_kernel_start(struct machine *machine)
> >  	machine->kernel_start = 1ULL << 63;
> >  	if (map) {
> >  		err = map__load(map);
> > +		if (err)
> > +			return err;
> > +
> >  		/*
> >  		 * On x86_64, PTI entry trampolines are less than the
> >  		 * start of kernel text, but still above 2^63. So leave
> >  		 * kernel_start = 1ULL << 63 for x86_64.
> >  		 */
> > -		if (!err && !machine__is(machine, "x86_64"))
> > +		if (!machine__is(machine, "x86_64"))
> >  			machine->kernel_start = map->start;
> > +
> > +		/*
> > +		 * On arm/arm64, the kernel uses some memory regions which are
> > +		 * prior to '_stext' symbol; to reflect the complete kernel
> > +		 * address space, compensate these pre-defined regions for
> > +		 * kernel start address.
> > +		 */
> > +		if (!strcmp(perf_env__arch(machine->env), "arm") ||
> > +		    !strcmp(perf_env__arch(machine->env), "arm64"))
> > +			machine->kernel_start -= ARM_PRE_START_SIZE;
> >  	}
> >  	return err;
> >  }
> > 
> 
