Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444F0B612A
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfIRKMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 06:12:23 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39810 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbfIRKMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 06:12:23 -0400
Received: by mail-lf1-f65.google.com with SMTP id 72so5261390lfh.6
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 03:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JzNHZht1bd6w8WtrKX6lmZo1NhKQxsQQoKxRAfLfPag=;
        b=cFV6lZrPn1Mcf4EtX5AxtvIqIB1Qk4sGu9JQlMv9h7FqQpBqv/aXUI+14JI21629HA
         lkOuieXLAl/nkeBUyxDgGxcI1rwy2EvvU59BVBmKIN+cpFE1Uw+42ItVzXATDn/Vdtxd
         iQuMqn9GMssOl1d4JRTjpsiS5u/Pwfs1rnpSsCoigwBi89ovKKwmAPhnULg1PPfp3Clv
         xWvFgOiCbBH+oAe2OiwCm9MwC2HYhsRxBcbHl6pnb5uTBr8etIffKratODyx5yz4NHp3
         ikvmSAsrEy8FN2AzOhNVNxuQm1CtCiRqloW8AZFIMLAJAm2xuZroldu5PFrMj+TiTzvJ
         sWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=JzNHZht1bd6w8WtrKX6lmZo1NhKQxsQQoKxRAfLfPag=;
        b=W7QdBXItTxAtx2JJS1a1Y2O/eEqjlRJVp+S9DJd/KCXzJ+O7JWRMSjdDJ/t2WQ7FfA
         ow/ueMcWf/HoDD6Vri5T7kohsvVM69T7xFZ4Qq4voUFR/QNKi7qPzeWXucqNFgrj02BF
         SVqt2+wYk3a22sic7aqUhB2/+mB2bSTrf3zQHgGInzEP2cI1ErdLh+gsYq3a0dMLaj8G
         E7bkrorT1zqh1wUQU6PgKv+Y2ByvCE0nYNXHLf/D7dNSYIE33BDVYj7hiKbKi+wJX3aY
         nIBITmFn42CWqESoLRQ1jvdYz+tqT2MpuyPm9GQyh2hZvkTxt4CQVuz+zBQ0B5ZvegVY
         3htA==
X-Gm-Message-State: APjAAAWHMTaqgAeqokPxeujZpAE1R5H9k1B8IxjNjDtMrlpFQ2CDSEpx
        i1UEoR+72+LN1KqK0LJF12HAng==
X-Google-Smtp-Source: APXvYqwwcnWx7o1Se4k8YtBfuMRVpPQNz/bjMByXwDKLlJMYEddmufdN8gJLgcO37T1JynR5hVhoOw==
X-Received: by 2002:ac2:4308:: with SMTP id l8mr1641108lfh.25.1568801540147;
        Wed, 18 Sep 2019 03:12:20 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id 77sm951751ljf.85.2019.09.18.03.12.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 03:12:19 -0700 (PDT)
Date:   Wed, 18 Sep 2019 13:12:17 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 bpf-next 07/14] samples: bpf: add makefile.target for
 separate CC target build
Message-ID: <20190918101216.GA2908@khorivan>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-8-ivan.khoronzhuk@linaro.org>
 <CAEf4Bzaidog3n0YP6F5dL2rCrHtKCOBXS0as7usymk8Twdro4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4Bzaidog3n0YP6F5dL2rCrHtKCOBXS0as7usymk8Twdro4w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 04:19:40PM -0700, Andrii Nakryiko wrote:
>On Mon, Sep 16, 2019 at 3:58 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> The makefile.target is added only and will be used in
>
>typo: Makefile
>
>> sample/bpf/Makefile later in order to switch cross-compiling on CC
>
>on -> to
>
>> from HOSTCC environment.
>>
>> The HOSTCC is supposed to build binaries and tools running on the host
>> afterwards, in order to simplify build or so, like "fixdep" or else.
>> In case of cross compiling "fixdep" is executed on host when the rest
>> samples should run on target arch. In order to build binaries for
>> target arch with CC and tools running on host with HOSTCC, lets add
>> Makefile.target for simplicity, having definition and routines similar
>> to ones, used in script/Makefile.host. This allows later add
>> cross-compilation to samples/bpf with minimum changes.
>>
>> The tprog stands for target programs built with CC.
>
>Why tprog? Could we just use prog: hostprog vs prog.
Prev. version was with prog, but Yonghong Song found it ambiguous.
As prog can be bpf also. So, decision was made to follow logic:
* target prog - non bpf progs
* bpf prog = bpf prog, that can be later smth similar, providing build options
  for each bpf object separately.

Details here:
https://lkml.org/lkml/2019/9/13/1037

>
>>
>> Makefile.target contains only stuff needed for samples/bpf, potentially
>> can be reused later and now needed only for unblocking tricky
>> samples/bpf cross compilation.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  samples/bpf/Makefile.target | 75 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 75 insertions(+)
>>  create mode 100644 samples/bpf/Makefile.target
>>
>> diff --git a/samples/bpf/Makefile.target b/samples/bpf/Makefile.target
>> new file mode 100644
>> index 000000000000..fb6de63f7d2f
>> --- /dev/null
>> +++ b/samples/bpf/Makefile.target
>> @@ -0,0 +1,75 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# ==========================================================================
>> +# Building binaries on the host system
>> +# Binaries are not used during the compilation of the kernel, and intendent
>
>typo: intended
>
>> +# to be build for target board, target board can be host ofc. Added to build
>
>What's ofc, is it "of course"?
yes, ofc )

>
>> +# binaries to run not on host system.
>> +#
>> +# Sample syntax (see Documentation/kbuild/makefiles.rst for reference)
>> +# tprogs-y := xsk_example
>> +# Will compile xdpsock_example.c and create an executable named xsk_example
>
>You mix references to xsk_example and xdpsock_example, which is very
>confusing. I'm guessing you meant to use xdpsock_example consistently.
Oh, yes. Thanks.

>
>> +#
>> +# tprogs-y    := xdpsock
>> +# xdpsock-objs := xdpsock_1.o xdpsock_2.o
>> +# Will compile xdpsock_1.c and xdpsock_2.c, and then link the executable
>> +# xdpsock, based on xdpsock_1.o and xdpsock_2.o
>> +#
>> +# Inherited from scripts/Makefile.host
>
>"Inspired by" or "Derived from" would be probably more appropriate term :)
I will replace with "Derived from", looks better.

>
>> +#
>> +__tprogs := $(sort $(tprogs-y))
>> +
>> +# C code
>> +# Executables compiled from a single .c file
>> +tprog-csingle  := $(foreach m,$(__tprogs), \
>> +                       $(if $($(m)-objs),,$(m)))
>> +
>> +# C executables linked based on several .o files
>> +tprog-cmulti   := $(foreach m,$(__tprogs),\
>> +                       $(if $($(m)-objs),$(m)))
>> +
>> +# Object (.o) files compiled from .c files
>> +tprog-cobjs    := $(sort $(foreach m,$(__tprogs),$($(m)-objs)))
>> +
>> +tprog-csingle  := $(addprefix $(obj)/,$(tprog-csingle))
>> +tprog-cmulti   := $(addprefix $(obj)/,$(tprog-cmulti))
>> +tprog-cobjs    := $(addprefix $(obj)/,$(tprog-cobjs))
>> +
>> +#####
>> +# Handle options to gcc. Support building with separate output directory
>> +
>> +_tprogc_flags   = $(TPROGS_CFLAGS) \
>> +                 $(TPROGCFLAGS_$(basetarget).o)
>> +
>> +# $(objtree)/$(obj) for including generated headers from checkin source files
>> +ifeq ($(KBUILD_EXTMOD),)
>> +ifdef building_out_of_srctree
>> +_tprogc_flags   += -I $(objtree)/$(obj)
>> +endif
>> +endif
>> +
>> +tprogc_flags    = -Wp,-MD,$(depfile) $(_tprogc_flags)
>> +
>> +# Create executable from a single .c file
>> +# tprog-csingle -> Executable
>> +quiet_cmd_tprog-csingle        = CC  $@
>> +      cmd_tprog-csingle        = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ $< \
>> +               $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
>> +$(tprog-csingle): $(obj)/%: $(src)/%.c FORCE
>> +       $(call if_changed_dep,tprog-csingle)
>> +
>> +# Link an executable based on list of .o files, all plain c
>> +# tprog-cmulti -> executable
>> +quiet_cmd_tprog-cmulti = LD  $@
>> +      cmd_tprog-cmulti = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ \
>> +                         $(addprefix $(obj)/,$($(@F)-objs)) \
>> +                         $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
>> +$(tprog-cmulti): $(tprog-cobjs) FORCE
>> +       $(call if_changed,tprog-cmulti)
>> +$(call multi_depend, $(tprog-cmulti), , -objs)
>> +
>> +# Create .o file from a single .c file
>> +# tprog-cobjs -> .o
>> +quiet_cmd_tprog-cobjs  = CC  $@
>> +      cmd_tprog-cobjs  = $(CC) $(tprogc_flags) -c -o $@ $<
>> +$(tprog-cobjs): $(obj)/%.o: $(src)/%.c FORCE
>> +       $(call if_changed_dep,tprog-cobjs)
>> --
>> 2.17.1
>>
>
>tprogs is quite confusing, but overall looks good to me.
I tend to leave it as tprogs, unless it's going to be progs and agreed with
Yonghong.

It follows logic:
- tprogs for bins
- bpfprogs or bojs or bprogs (could be) for bpf obj

-- 
Regards,
Ivan Khoronzhuk
