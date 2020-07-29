Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B521231FF0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgG2OIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgG2OIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:08:34 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D73FC061794;
        Wed, 29 Jul 2020 07:08:32 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k4so20831281oik.2;
        Wed, 29 Jul 2020 07:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hm8aMuReT2MP2t/QxG6C0N81VyHztkfXbdkrx0wl/Cc=;
        b=fBQ87jmKa7xz5BbSRqknn/AKea99rra36bs/4fDp7ex97AOkFMg/aySHBwQqHU8QpN
         A5sv81iIXPWEj0vtOOi8HT5TYVSuDVepIOBA1n1EpGwOcW8WcUjaFPQ4jVQT0P55itcu
         XQ1hcsNgPG11aR6+ZjcqtUno904zyNIR0hBpEdFWo/0/ggagjDpN0Q1KJItI+v/PlUUU
         02hILBvY9OAtEJ2uP8GVzXlU2TBCAsdUTTdrLvUE9eVFkihz0qnKI/1mMpDHtMNxgmic
         6YVWfYKIw63dAGBBIO2vmspYesLCVuNNhsp7i818FI+UVrHR5tYVpqFlEYJi2mueCTma
         qSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hm8aMuReT2MP2t/QxG6C0N81VyHztkfXbdkrx0wl/Cc=;
        b=JBzZMG6ox+l8SBTq05sGuoVibpENWTAnVL0cy4nu6KrSPoAe8E28ovsp6iQKRzTmnd
         qt1xUgr9Qdh2dEH3otWn0Z1FxchHr3NWeUw1wKc8uwLSiPOe1C8sTJwQVbRGI3l9eUTs
         w9wPCvGm/yJ+ZsBqRgZ9s0WlTVqP/iQEs82GNMlQsEk7jzKBXotLj9yL0Ok/6tfBSUuB
         4P5KMYYx9jdyuFdsdnF868X36pS5f1IZqWnXIb0FBHT9+fOF3pDWPBuGdjFzMV8uGR5q
         H8SlLEG3JvC7kKN4iRWEtfr1s2psGYa93vS1S4NmXGylLxmmdZxzTVoySK/LiYkYqBIi
         iKPQ==
X-Gm-Message-State: AOAM532YWrj7P3CwtpouHoF6vT4Hd+wtgF8s1XYTyHoKD/kFPRn+xnOW
        sbH5/VX+cYK0BtIFPk1p18w=
X-Google-Smtp-Source: ABdhPJwP3DeYLeoOPO5c4TWmCTvlwLABeZuL94gdnTiliVqGLEmXNsLY+g4q4FwFa9T7sc7wVCxQEA==
X-Received: by 2002:a54:4d92:: with SMTP id y18mr1691081oix.74.1596031711870;
        Wed, 29 Jul 2020 07:08:31 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c873:abf:83ee:21b3? ([2601:284:8202:10b0:c873:abf:83ee:21b3])
        by smtp.googlemail.com with ESMTPSA id z2sm322339otq.17.2020.07.29.07.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 07:08:31 -0700 (PDT)
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        bimmy.pujari@intel.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, mchehab@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
References: <20200727233431.4103-1-bimmy.pujari@intel.com>
 <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
 <CANP3RGd2fKh7qXyWVeqPM8nVKZRtJrJ65apmGF=w9cwXy6TReQ@mail.gmail.com>
 <CAEf4BzaiCZ3rOBc0EXuLUuWh9m5QXv=51Aoyi5OHwb6T11nnjw@mail.gmail.com>
 <9e9ca486-f6f5-2301-8850-8f53429b160e@gmail.com>
 <CAEf4BzaNyBHOrTrrvua1fe4PTzYvzBtY0oYw63iubgk=K84mrQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <994db919-bdd2-76b1-3cab-67dd2396b046@gmail.com>
Date:   Wed, 29 Jul 2020 08:08:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaNyBHOrTrrvua1fe4PTzYvzBtY0oYw63iubgk=K84mrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 11:15 PM, Andrii Nakryiko wrote:
> On Tue, Jul 28, 2020 at 1:57 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 7/28/20 12:28 PM, Andrii Nakryiko wrote:
>>> In some, yes, which also means that in some other they can't. So I'm
>>> still worried about misuses of REALCLOCK, within (internal daemons
>>> within the company) our outside (BCC tools and alike) of data centers.
>>> Especially if people will start using it to measure elapsed time
>>> between events. I'd rather not have to explain over and over again
>>> that REALCLOCK is not for measuring passage of time.
>>
>> Why is documenting the type of clock and its limitations not sufficient?
>> Users are going to make mistakes and use of gettimeofday to measure time
>> differences is a common one for userspace code. That should not define
>> or limit the ability to correctly and most directly do something in bpf.
>>
>> I have a patch to export local_clock as bpf_ktime_get_fast_ns. It too
>> can be abused given that it has limitations (can not be used across CPUs
>> and does not correlate to any exported clock), but it too has important
>> use cases (twice as fast as bpf_ktime_get_ns and useful for per-cpu
>> delta-time needs).
>>
>> Users have to know what they are doing; making mistakes is part of
>> learning. Proper documentation is all you can do.
> 
> I don't believe that's all we can do. Designing APIs that are less
> error-prone is at least one way to go about that. One can find plenty
> of examples where well-documented and standardized APIs are
> nevertheless misused regularly. Also, "users read and follow
> documentation" doesn't match my experience, unfortunately.
> 

This API is about exposing a standard, well-known clock source to bpf
programs. Your argument is no because some users might use it
incorrectly, and I think that argument is wrong. Don't make people who
know what they are doing jump through hoops because a novice might make
a mistake.
