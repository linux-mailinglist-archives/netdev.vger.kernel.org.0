Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0C5107B95
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKVXrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:47:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40972 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKVXrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:47:39 -0500
Received: by mail-lj1-f196.google.com with SMTP id m4so9220290ljj.8
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 15:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BUKr4yoGpKaxYmTEmTDH/7ICwo7GEhPoNnnopGTuMFc=;
        b=Q8dtbXc+uzPlnQ7A3hyBJf9uHmj4UbqP18hCKWDZhmVvKvjKGssVYIijTzf0ayTkVO
         LAEg4y9VzSoF/UnQ2ptgX5kr3ovEqBBhLP10m920O87sMgbXTALiqLwGLiYm+BsjHzNr
         09usHFb7cS5XOfK9/diQukOnyjNUlcwP5GZdpBPAwx+wj33CfNIM1bNH8kaX6DcGAD+u
         qgIv5rdhBD4DEwr/Nwnvi1OIOJrxJ0E2E04ivUsCckocWk+PvRXZ7JpQCHoQVn/cGwDe
         eTKQwJvbO6GE63u/3wsmEDuSX6u+vuIPuLf/X1GL65Qkvko/beBq4O2+gMkISVjy+2rM
         cRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=BUKr4yoGpKaxYmTEmTDH/7ICwo7GEhPoNnnopGTuMFc=;
        b=c10OJceDpGV0nu5sjHZSIjkpW+Jgw/Wu8pGyEZAURxQ4Sa1/G8GGbbOPxiDsiFnc3q
         avQ3ETmwwV8TV6U7lSwRYyfaN9uGW33qpfn0Jn1i5Km7m3eUJ03ibAKzdN0ml/iJTNjO
         WuxjwMBG05LEewQ3PCYWpWqqK7JDn8xAbZximVIwIyxwWHdXLlKeI/Aa1F131Szs9nZx
         egHgiPxXF/Lp0HdhytOdE+a3lyXYID1oU5e89rlg/TDD7pasRIliAvH6aEybNCENkBjV
         l94mQklN26dGv0+jgYs98OBDmSHxkIl0JKwQt0EOdbW8Q+oA3PF5WbAGBJO888yf8TfW
         lGsQ==
X-Gm-Message-State: APjAAAW9Iq3enw7m4LFSuuKYwGS6dN9mR5oTETpDnffO8lmuOdMJ57W9
        7MNJNZ1Ut7MUHg1Xav3zeqbuvw==
X-Google-Smtp-Source: APXvYqz0tvkYX9lNjGIZfLY/VjLXdb9DDKAILAvxppaODGA/mHO1za/hr61E9lBoBkP1KloPumXSOg==
X-Received: by 2002:a2e:9a95:: with SMTP id p21mr13622079lji.175.1574466456985;
        Fri, 22 Nov 2019 15:47:36 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id t12sm3744290lfc.73.2019.11.22.15.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 15:47:36 -0800 (PST)
Date:   Sat, 23 Nov 2019 01:47:34 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v5 bpf-next 11/15] libbpf: don't use cxx to test_libpf
 target
Message-ID: <20191122234733.GA2474@khorivan>
Mail-Followup-To: Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com,
        Andrii Nakryiko <andriin@fb.com>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-12-ivan.khoronzhuk@linaro.org>
 <20191121214225.GA3145429@mini-arch.hsd1.ca.comcast.net>
 <CAEf4BzZWPwzC8ZBWcBOfQQmxBkDRjogxw2xHZ+dMWOrrMmU0sg@mail.gmail.com>
 <20191122163211.GB3145429@mini-arch.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122163211.GB3145429@mini-arch.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 08:32:11AM -0800, Stanislav Fomichev wrote:
>On 11/21, Andrii Nakryiko wrote:
>> On Thu, Nov 21, 2019 at 1:42 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>> >
>> > On 10/11, Ivan Khoronzhuk wrote:
>> > > No need to use C++ for test_libbpf target when libbpf is on C and it
>> > > can be tested with C, after this change the CXXFLAGS in makefiles can
>> > > be avoided, at least in bpf samples, when sysroot is used, passing
>> > > same C/LDFLAGS as for lib.
>> > > Add "return 0" in test_libbpf to avoid warn, but also remove spaces at
>> > > start of the lines to keep same style and avoid warns while apply.
>> > Hey, just spotted this patch, not sure how it slipped through.
>> > The c++ test was there to make sure libbpf can be included and
>> > linked against c++ code (i.e. libbpf headers don't have some c++
>> > keywords/etc).
>> >
>> > Any particular reason you were not happy with it? Can we revert it
>> > back to c++ and fix your use-case instead? Alternatively, we can just
>> > remove this test if we don't really care about c++.
>> >
>>
>> No one seemed to know why we have C++ pieces in pure C library and its
>> Makefile, so we decide to "fix" this. :)
>It's surprising, the commit 8c4905b995c6 clearly states the reason
>for adding it. Looks like it deserved a real comment in the Makefile :-)

I dislike changing things like this, but I was asked while review and
it seemed logical enough. The comment could prevent us from doing this.

>
>> But I do understand your concern. Would it be possible to instead do
>> this as a proper selftests test? Do you mind taking a look at that?
>Ack, will move this test_libbpf.c into selftests and convert back to
>c++.

-- 
Regards,
Ivan Khoronzhuk
