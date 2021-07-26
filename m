Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32EE3D5AD2
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhGZNSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbhGZNSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:18:03 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DF8C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 06:58:31 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q6so10918795oiw.7
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 06:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cGmkIhRovSNcHOVibf/srq/YEMP/lLJWPcQ+k9UHHVo=;
        b=nX5JXk4HyUo5JKLmbvbIMDgV3EFxmmXsCr0KiTSlZ2gnSJftD3IJo2sqnJqbGBFf+C
         P3JesYU00wdkw84mIgFRuu4FpIBJWIaydmlQN9wMwS64pNpIUCzZgVUXXcEQ/ArCueKt
         9seieVPWjVFxVng1F0k/Cr9j1laWFlJYcMXHqiAck8VHw37rW/5TeU9CbTXHsgCO20Ud
         xUUU4EVN6XtNrr9gZ0q/JcgjvlDBmZNL1syF6tNZUTgM7o8UoZsZMvhBfKSaZPP97GhL
         uo44GCPmBv99OCNQUYuzk2G2wnzklmje9oplJ6/XQX65pyyzFuHpMNkZLPciaLUM7Vxt
         z3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cGmkIhRovSNcHOVibf/srq/YEMP/lLJWPcQ+k9UHHVo=;
        b=EpjjVSUCbXtM7QqyIGCiJI3DeHc6G7JZsbAihafLJkAqpDccWSpMiMTKx7e5NQh59A
         aJKkPaHBO5JNvG0eUYz0h05j+6pvfo0DFnYU20LNgda+JVKC080Iy/5pMpkUKHCLNMkb
         jRAAu1ZdxctvO9CljzNtg83VV8v73o2AxyvWmp5wqCOra2ucFQX5z+yRZ7tCDmL9u9dG
         8ysve4Cf7DMqbqlt4VDnYkiWbta42ldSgJifzPvcHXk1vQAO52e5s9uNPUal7eW6o8Yv
         gfO1j9zsGpbrb+ARxWsB6oHJmjyaRoYxrDi6oJQFNtf67T80xBGqbSwXrK34Tqn7w7vH
         lTEQ==
X-Gm-Message-State: AOAM5302qlgB8oZuUdzTOtLcMAE4VkprCS8PE7qCExK7GSOMr0CUGD7X
        kqjIbGtwq0IZ5bJwBeoOutg=
X-Google-Smtp-Source: ABdhPJwdJA4mspuZHEYXacKTVMUSxMSjAVHpC41M3zAZxHWoqGErSMunNTl84aJ/GLMY7z3X0KcJIA==
X-Received: by 2002:aca:49d7:: with SMTP id w206mr9137890oia.147.1627307910469;
        Mon, 26 Jul 2021 06:58:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id c21sm3645949oiw.16.2021.07.26.06.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:58:29 -0700 (PDT)
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
 <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com>
 <CAEf4Bza3gMzfSQcv_QDzVP=vsCzxy=8DHwU-EVqOt8XagK7OHw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cce56767-efbe-e572-6290-111c6c845578@gmail.com>
Date:   Mon, 26 Jul 2021 07:58:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza3gMzfSQcv_QDzVP=vsCzxy=8DHwU-EVqOt8XagK7OHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/21 6:25 PM, Andrii Nakryiko wrote:
>>>>>> This is still problematic, because one section can have multiple BPF
>>>>>> programs. I.e., it's possible two define two or more XDP BPF programs
>>>>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
>>>>>> moving users to specify the program name (i.e., C function name
>>>>>> representing the BPF program). All the xdp_mycustom_suffix namings are
>>>>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
>>>>>> a head start on fixing this early on.
>>>>>
>>>>> Thanks for bringing this up. Currently, there is no way to specify a
>>>>> function name with "tc exec bpf" (only a section name via the "sec" arg). So
>>>>> probably, we should just add another arg to specify the function name.
>>>>
>>>> How about add a "prog" arg to load specified program name and mark
>>>> "sec" as not recommended? To keep backwards compatibility we just load the
>>>> first program in the section.
>>>
>>> Why not error out if there is more than one program with the same
>>> section name? if there is just one (and thus section name is still
>>> unique) -- then proceed. It seems much less confusing, IMO.
>>>
>>
>> Let' see if I understand this correctly: libbpf 1.0 is not going to
>> allow SEC("xdp_foo") or SEC("xdp_bar") kind of section names - which is
>> the hint for libbpf to know program type. Instead only SEC("xdp") is
>> allowed.
> 
> Right.
> 
>>
>> Further, a single object file is not going to be allowed to have
>> multiple SEC("xdp") instances for each program name.
> 
> On the contrary. Libbpf already allows (and will keep allowing)
> multiple BPF programs with SEC("xdp") in a single object file. Which
> is why section_name is not a unique program identifier.
> 

Does that require BTF? My attempts at loading an object file with 2
SEC("xdp") programs failed. This is using bpftool from top of tree and
loadall.
