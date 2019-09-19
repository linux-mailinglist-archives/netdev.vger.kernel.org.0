Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FA0B7BFC
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbfISOS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:18:57 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41219 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389504AbfISOS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:18:56 -0400
Received: by mail-lf1-f65.google.com with SMTP id r2so2495099lfn.8
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VJcWMgQlBXCDJq+mIxTwVnwKjmA/FYBDYBWzdA4+waM=;
        b=Ue2ocIOyWscRCt7ZzCTi01c0gL7F7vMVAGP9yIEGYKpEYohfx/PwMKCvSdrtlzdPYK
         BUht9dlkdUgnz/lwVucsdrAvl5byjMtVldpfPt9guguIxcbNz4SFJOHcYVK+1BiYwvNe
         7DuwgnRk82njueUCROP8jC8sMCF0EJrc49hkHVFvhTE4Bp3o+Q85DuhPxSlM/vTG26Nu
         CQ6tS1ewupHReyrLiQCexCiPBVGy5oIcGB/rLj/GtSYvVxZkjonoQgHZA1zmA7kWgQO1
         tBGOWhOzQKBPw8V7d9iQI2UgQVnQN7Osy+Chy72rqp+xsMyXSmOKfZvFWJ1OpljK4fFB
         95mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=VJcWMgQlBXCDJq+mIxTwVnwKjmA/FYBDYBWzdA4+waM=;
        b=EEaAl8XDyKH3wvyBYByq2yxzHGlzl4p/wpRWKU5fVWRaQfj8huCbI2Pc7rbIiOnh5i
         KOrEPBOiCYcA/kgldaHetV5GSRy19SxahWXe6WlQBRdgKx2O4xlFVC19L0PRPeSYCEBl
         6SUlsTtBKNXburdD2p/HUl4r6WaInuHnElAHMZ+f3iz95bkHf9qYn7i9A5+l9barqOzi
         38yqc0t/AEDXNNti+9HaBPnPBuHl3Dzxu8DBLLs99eJukjjt7shZbb45qG7r+xSXgRUo
         wGUquUnIb/l+CT45Hor5Xa9P1hDYDmiJMrrkw6gs2ZLmmEicGBZH8I4h0NA5qeynyUFo
         bEdw==
X-Gm-Message-State: APjAAAVemJGEtdmOFNprzqivQ8l6lh9Y+o/DN1JKk3CuoQtCTMzapSWa
        rbDC98+vH8AufkHw9qlJWiILdQ==
X-Google-Smtp-Source: APXvYqxRTZr3llIsZI+fWfYF0ZscJkUyk92xFy/A2Pm6OM2f9WsqMwr+jw4KsPtNY/3pk4jduAvUPw==
X-Received: by 2002:a19:d6:: with SMTP id 205mr5444406lfa.144.1568902734233;
        Thu, 19 Sep 2019 07:18:54 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id d25sm1582984lfj.15.2019.09.19.07.18.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Sep 2019 07:18:53 -0700 (PDT)
Date:   Thu, 19 Sep 2019 17:18:50 +0300
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
Subject: Re: [PATCH v3 bpf-next 09/14] samples: bpf: makefile: use own flags
 but not host when cross compile
Message-ID: <20190919141848.GA8870@khorivan>
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
 <20190916105433.11404-10-ivan.khoronzhuk@linaro.org>
 <CAEf4BzbuPnxAs0A=w60q0jTCy5pb2R-h0uEuT2tmvjsaj4DH4A@mail.gmail.com>
 <20190918103508.GC2908@khorivan>
 <CAEf4BzYCNrkaMf-LFHYDi78m9jgMDOswh8VYXGcbttJV-3D21w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzYCNrkaMf-LFHYDi78m9jgMDOswh8VYXGcbttJV-3D21w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 02:29:53PM -0700, Andrii Nakryiko wrote:
>On Wed, Sep 18, 2019 at 3:35 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> On Tue, Sep 17, 2019 at 04:42:07PM -0700, Andrii Nakryiko wrote:
>> >On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
>> ><ivan.khoronzhuk@linaro.org> wrote:
>> >>
>> >> While compile natively, the hosts cflags and ldflags are equal to ones
>> >> used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it should
>> >> have own, used for target arch. While verification, for arm, arm64 and
>> >> x86_64 the following flags were used alsways:
>> >>
>> >> -Wall
>> >> -O2
>> >> -fomit-frame-pointer
>> >> -Wmissing-prototypes
>> >> -Wstrict-prototypes
>> >>
>> >> So, add them as they were verified and used before adding
>> >> Makefile.target, but anyway limit it only for cross compile options as
>> >> for host can be some configurations when another options can be used,
>> >> So, for host arch samples left all as is, it allows to avoid potential
>> >> option mistmatches for existent environments.
>> >>
>> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >> ---
>> >>  samples/bpf/Makefile | 9 +++++++++
>> >>  1 file changed, 9 insertions(+)
>> >>
>> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> >> index 1579cc16a1c2..b5c87a8b8b51 100644
>> >> --- a/samples/bpf/Makefile
>> >> +++ b/samples/bpf/Makefile
>> >> @@ -178,8 +178,17 @@ CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
>> >>  TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>> >>  endif
>> >>
>> >> +ifdef CROSS_COMPILE
>> >> +TPROGS_CFLAGS += -Wall
>> >> +TPROGS_CFLAGS += -O2
>> >
>> >Specifying one arg per line seems like overkill, put them in one line?
>> Will combine.
>>
>> >
>> >> +TPROGS_CFLAGS += -fomit-frame-pointer
>> >
>> >Why this one?
>> I've explained in commit msg. The logic is to have as much as close options
>> to have smiliar binaries. As those options are used before for hosts and kinda
>> cross builds - better follow same way.
>
>I'm just asking why omit frame pointers and make it harder to do stuff
>like profiling? What performance benefits are we seeking for in BPF
>samples?
>
>>
>> >
>> >> +TPROGS_CFLAGS += -Wmissing-prototypes
>> >> +TPROGS_CFLAGS += -Wstrict-prototypes
>> >
>> >Are these in some way special that we want them in cross-compile mode only?
>> >
>> >All of those flags seem useful regardless of cross-compilation or not,
>> >shouldn't they be common? I'm a bit lost about the intent here...
>> They are common but split is needed to expose it at least. Also host for
>> different arches can have some own opts already used that shouldn't be present
>> for cross, better not mix it for safety.
>
>We want -Wmissing-prototypes and -Wstrict-prototypes for cross-compile
>and non-cross-compile cases, right? So let's specify them as common
>set of options, instead of relying on KBUILD_HOSTCFLAGS or
>HOST_EXTRACFLAGS to have them. Otherwise we'll be getting extra
>warnings for just cross-compile case, which is not good. If you are
>worrying about having duplicate -W flags, seems like it's handled by
>GCC already, so shouldn't be a problem.

Ok, lets drop omit-frame-pointer.

But then, lets do more radical step and drop
KBUILD_HOSTCFLAGS & HOST_EXTRACFLAG in this patch:

-ifdef CROSS_COMPILE
+TPROGS_CFLAGS += -Wall -O2
+TPROGS_CFLAGS += -Wmissing-prototypes
+TPROGS_CFLAGS += -Wstrict-prototypes
-else
-TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
-TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
-endif

At least it allows to use same options always for both, native and cross.

I verified on native x86_64, arm64 and arm and cross for arm and arm64,
but should work for others, at least it can be tuned explicitly and
no need to depend on KBUILD and use "cross" fork here.

-- 
Regards,
Ivan Khoronzhuk
