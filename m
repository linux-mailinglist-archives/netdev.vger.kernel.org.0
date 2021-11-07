Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86463447113
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 01:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhKGAYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 20:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhKGAYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 20:24:08 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AED3C061746
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 17:21:26 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d3so19965224wrh.8
        for <netdev@vger.kernel.org>; Sat, 06 Nov 2021 17:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=si5tlyn6HjXs/k2N6uFM1eCM7PYGPBsMizUHEFvUaTA=;
        b=S0RjQ23foC6IYzsZDlw+lK8l00W9mxKm+R635i1iCUBTIpIUbJwCrIGfT5JS7d/GX+
         1IbNy7RZT87Uq2uS/lmB66/uxowtaFIQbePZ/h5sB9mGemv2jgOd361tM+pu7QAX3TLX
         Thk+VZUQKE0zvEE8GrHcc6wvI68sTqzu/Xl/36PRUklAFcvnz7TslNtmFjn7HpeA+RuU
         RtJx5z6La8yxz/FSOGd+J1Nlc30bW3FMMp5Wp8UIyreUfIU9RFVv5YiZJN4J5G7nmjMJ
         isizlRjHMQKDZ/EUihY+m6fsAmqsgRU+QNWYYg/lqp9T4A9tKi2AscfL5gvkZwdtdpbz
         cgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=si5tlyn6HjXs/k2N6uFM1eCM7PYGPBsMizUHEFvUaTA=;
        b=UJCtyhFGOZB4La+BzdGTnb4GM2RaJstCqfObkvUNx/R7261t+0ujatWYaCDTTkIkZF
         TaggL3eNFggP7N9lULBl9elTKDy+5fS91Ywx166hfttqahnwAmhVRXvO1t/xnsrHZjyb
         z3ZnJN80SCqlVeLEExpZY+Zvk+Twkzv9c+67IsqA9iRM9M4NQauftRAVN5KuMgejuxqP
         xFw8vpOndDZh+s9WInmpXWDeuaWIRmivyiA7BHTIO5hEhA66WUS1fo8GWNPRFVwnDElV
         ri2cNGQL4gsS4T7ougeQ0JnLzONopA6R2WxzO3Q7MSULYNlrb7mH39Xj+xyKmiYXpuso
         k3aA==
X-Gm-Message-State: AOAM532ndDLzpYa3UETs7kgYTZhBjbJWwro5ZCxHAiA5wuDgEqhygr45
        L8++jFdaCcL0x6iZoIV/CuS6iw==
X-Google-Smtp-Source: ABdhPJw0BPZlS9F5R6uB1wvtU2kjB0wbgQMfPuogrmeglxKThlY1fHRZcYgV0FvfCa8lUw8tUPF+rw==
X-Received: by 2002:adf:fe8e:: with SMTP id l14mr50633476wrr.177.1636244485013;
        Sat, 06 Nov 2021 17:21:25 -0700 (PDT)
Received: from [192.168.1.11] ([149.86.67.25])
        by smtp.gmail.com with ESMTPSA id o9sm11979624wrs.4.2021.11.06.17.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 17:21:24 -0700 (PDT)
Message-ID: <813cc0db-51d0-65b3-70f4-f1a823b0d029@isovalent.com>
Date:   Sun, 7 Nov 2021 00:21:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [BUG] Re: [PATCH bpf-next] perf build: Install libbpf headers
 locally when building
Content-Language: en-GB
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20211105020244.6869-1-quentin@isovalent.com>
 <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
 <YYbXjE1aAdNjI+aY@kernel.org> <YYbhwPnn4OvnybzQ@kernel.org>
 <YYbuA347Y5nMJ4Xm@kernel.org> <YYbxigLXFkomexsZ@kernel.org>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <YYbxigLXFkomexsZ@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-11-06 18:20 UTC-0300 ~ Arnaldo Carvalho de Melo <acme@kernel.org>
> Em Sat, Nov 06, 2021 at 06:05:07PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Sat, Nov 06, 2021 at 05:12:48PM -0300, Arnaldo Carvalho de Melo escreveu:
>>> Em Sat, Nov 06, 2021 at 04:29:16PM -0300, Arnaldo Carvalho de Melo escreveu:
>>>> Em Fri, Nov 05, 2021 at 11:38:50AM -0700, Andrii Nakryiko escreveu:
>>>>> On Thu, Nov 4, 2021 at 7:02 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>>>
>>>>>> API headers from libbpf should not be accessed directly from the
>>>>>> library's source directory. Instead, they should be exported with "make
>>>>>> install_headers". Let's adjust perf's Makefile to install those headers
>>>>>> locally when building libbpf.
>>>>>>
>>>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>>>> ---
>>>>>> Note: Sending to bpf-next because it's directly related to libbpf, and
>>>>>> to similar patches merged through bpf-next, but maybe Arnaldo prefers to
>>>>>> take it?
>>>>>
>>>>> Arnaldo would know better how to thoroughly test it, so I'd prefer to
>>>>> route this through perf tree. Any objections, Arnaldo?
>>>>
>>>> Preliminary testing passed for 'BUILD_BPF_SKEL=1' with without
>>>> LIBBPF_DYNAMIC=1 (using the system's libbpf-devel to build perf), so far
>>>> so good, so I tentatively applied it, will see with the full set of
>>>> containers.
>>>
>>> Because all the preliminary tests used O= to have that OUTPUT variable
>>> set, when we do simply:
>>>
>>> 	make -C tools/perf
>>
>> So I'll have to remove it now as my container builds test both O= and
>> in-place builds (make -C tools/perf), I know many people (Jiri for
>> instance) don't use O=.
>>
>> I tried to fix this but run out of time today, visits arriving soon, so
>> I'll try to come back to this tomorrow early morning, to push what I
>> have in to Linus, that is blocked by this now :-\
> 
> What I have, with your patch, is at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tmp.perf/core
> 
> It has both patches, as its needed for the BUILD_BPF_SKEL=1 mode to
> build correctly with/without LIBBPF_DYNAMIC=1.

Hi Arnaldo, thanks for the review and testing. Apologies, I missed that
the recipe for the $(LIBBPF_OUTPUT) directory was located under the
"ifdef BUILD_BPF_SKEL". I'm sending a v2 that will handle this case better.

Quentin
