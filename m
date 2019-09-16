Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0BBB43B0
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 00:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfIPWBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 18:01:23 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39364 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbfIPWBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 18:01:23 -0400
Received: by mail-lj1-f196.google.com with SMTP id s19so1414001lji.6
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 15:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f3SMr7nW/IIKR4uf3MqZBa7hhd+3LcyORNLugjWgB8w=;
        b=KYd1qA467jctBVyDgfFJXTEnxdMaK2KiExe6nlvwlt573Sil0F2vay6dqepe6Hrqsf
         GXO6cWf0i4wM8q9idqXN0tKD2eV885lEJd6vjYGDIWEUPsq0ImhxXkff7dO2c1I5+C9S
         hrqJ12L9qPlOaKw1otwnSpiLTFSwnaAI7j7Bwu8fspXMfB+sGjVadmRIN9goc6b6XD90
         pezjko2N4amqKkiesyv9P/SusWs7fax9J/8jaU3qNxkVxVxObuydTkTFPbGmJrzc4bFA
         lRACOpaNR5kmAhPjkySBXJjbwm4adBdd4wCGGw/i3g/Mi0CDo96EUBOA6VBwbIpnB1ZK
         WiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=f3SMr7nW/IIKR4uf3MqZBa7hhd+3LcyORNLugjWgB8w=;
        b=bYp/ZjTcE7W9ZQBgkG5v3tYYkTo9GoeZPsTVKK8IgRpgPgF7VQf2A6i0vzU50WdFs3
         eOcDOlIMtOEsqog0Ijm5ChIc2wLjjAnXe1wnBWDh3kiceFAfdobWmCsF6U647HE80NZJ
         JgEG0mzAm2ruL2xgAQsaopBtYxa9LOWD84aCCGQder7TAUDOc/55c0+HmBO628+MOXJd
         Lgy2daqBxPDbXcI5TvIfenw9awuC+1uoYsjf3p//Qn/3Ia160TNrv/7pxDksjssRigf3
         3LZxuxTMgqdZuD8X9ClQ1U4Ixie8FVo+9IwjmWxoHQPVpApyxJZK00rxM158gLudoGft
         8xCA==
X-Gm-Message-State: APjAAAVYEkgd6Kbvr90GBMCOPObOX10GU8l2w9+ws43XcNhZL7RQtOQM
        ucToRV9GcOP0Wbz3IUMTEKgSvA==
X-Google-Smtp-Source: APXvYqw+ngzdkLuBJbzj+87LaoUrAcM9OkQTZa/zN5wMZhHB9fg4Q5ReA3BfYr3o4UJQQk95L5rvGg==
X-Received: by 2002:a2e:8805:: with SMTP id x5mr66628ljh.102.1568671281368;
        Mon, 16 Sep 2019 15:01:21 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id r8sm10192lfm.71.2019.09.16.15.01.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Sep 2019 15:01:20 -0700 (PDT)
Date:   Tue, 17 Sep 2019 01:01:18 +0300
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
Subject: Re: [PATCH v3 bpf-next 04/14] samples: bpf: use own EXTRA_CFLAGS for
 clang commands
Message-ID: <20190916220117.GB4420@khorivan>
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
 <20190916105433.11404-5-ivan.khoronzhuk@linaro.org>
 <CAEf4BzYJ5Q4rBHGET5z6nPBhh=8qAK7uuCK=Qnsh14FDH-24gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzYJ5Q4rBHGET5z6nPBhh=8qAK7uuCK=Qnsh14FDH-24gA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 01:35:21PM -0700, Andrii Nakryiko wrote:
>On Mon, Sep 16, 2019 at 4:01 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> It can overlap with CFLAGS used for libraries built with gcc if
>> not now then in next patches. Correct it here for simplicity.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>
>With GCC BPF front-end recently added, we should probably generalize
>this to something like BPF_EXTRA_CFLAGS or something like that,
>eventually. But for now:
>
>Acked-by: Andrii Nakryiko <andriin@fb.com>

I can replace with BPF_EXTRA_CFLAGS in next v.

>
>>  samples/bpf/Makefile | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index b59e77e2250e..8ecc5d0c2d5b 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -218,10 +218,10 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
>>                           /bin/rm -f ./llvm_btf_verify.o)
>>
>>  ifneq ($(BTF_LLVM_PROBE),)
>> -       EXTRA_CFLAGS += -g
>> +       CLANG_EXTRA_CFLAGS += -g
>>  else
>>  ifneq ($(and $(BTF_LLC_PROBE),$(BTF_PAHOLE_PROBE),$(BTF_OBJCOPY_PROBE)),)
>> -       EXTRA_CFLAGS += -g
>> +       CLANG_EXTRA_CFLAGS += -g
>>         LLC_FLAGS += -mattr=dwarfris
>>         DWARF2BTF = y
>>  endif
>> @@ -280,8 +280,8 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>>  # useless for BPF samples.
>>  $(obj)/%.o: $(src)/%.c
>>         @echo "  CLANG-bpf " $@
>> -       $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
>> -               -I$(srctree)/tools/testing/selftests/bpf/ \
>> +       $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(CLANG_EXTRA_CFLAGS) \
>> +               -I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
>>                 -D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
>>                 -D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
>>                 -Wno-gnu-variable-sized-type-not-at-end \
>> --
>> 2.17.1
>>

-- 
Regards,
Ivan Khoronzhuk
