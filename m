Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EA1475815
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhLOLps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhLOLpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:45:47 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11A0C061574;
        Wed, 15 Dec 2021 03:45:46 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i22so7890787wrb.13;
        Wed, 15 Dec 2021 03:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5y9YMe/eWv7WDQGk94/07WbC1a0DggODyRLYD1P022w=;
        b=n4gfdQGtJRqAzx00gI6mLDt2NbdkIyc+NxbfPJrTlqNX60e56q9DthJI2mw9r0uEnY
         eEln0HhO674GE3KKvOVbhaGlj44wII6r49y7Qk/HD/FmwOhdLxoyiawZXotQZBogKNLc
         kgIRDiiYL1Fwo48Is4wnDByoePXvgMg4I/zd4Qmb4vXVnw+FHbXhDlyLwfRrE3TMzmDT
         OykPVnxr3B2U6o22QB3IWvxl6RTaJ7CqLjbYXuBgGT8YH0jJYH5Cab5f0OgYPjYLc/Qa
         4jm5lfmRfOOp56FpKY19WEbTQNXr3WruVF+WoxlYUlsAH1ud7pcznOVUGuQsNYz8ZqzI
         Swdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5y9YMe/eWv7WDQGk94/07WbC1a0DggODyRLYD1P022w=;
        b=Xxq6A2n+VwmSaT8PYHnvPRVYn+SzLRhgCmTrnNW9P9J/j60r/m9EoJVhzF55rY8BV4
         WNO7WacyzugyITtEXCU+VxXlMjg3JypgPcNyfYllXh6Dr0xBsSKc0E0VZKp/A/Yvl4V3
         tIg2y0T+RTOR8jgIxmXNUD+B4rxpDkt+ipZUKa76ha85uHfJ4yb+v+/Z2Orn5RveI/HK
         VZqMo5pvcY5PXXXrv3LViTClrYPKMyFWapGRbvJbbdLlEclIcKLydqCaeqzFhPB+N8g3
         W2AtP54Skk58KyrZd3VjFSy4Lxiv2gvFLxd2/NnGG3rAt3rZxZUeiowOvhYbRTd+5/Gi
         Di2g==
X-Gm-Message-State: AOAM530kwXgsWJ4FYX+yu5yzvgwO3d4X4xdXwOWogtl9ioO0hpneMv2B
        FO72HD8pX752257BjzOCbQM=
X-Google-Smtp-Source: ABdhPJzfEo9sd2GIgoURytIw3qwhBdStk/HfcyqWv5JqSA7tEFDWFDXxOBg+w4URjUIO+m8wgC9iVA==
X-Received: by 2002:a5d:6a8f:: with SMTP id s15mr4110956wru.544.1639568745415;
        Wed, 15 Dec 2021 03:45:45 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-108.dab.02.net. [82.132.229.108])
        by smtp.gmail.com with ESMTPSA id y15sm2449440wry.72.2021.12.15.03.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 03:45:45 -0800 (PST)
Message-ID: <e18915fe-8c2e-2622-3225-b8d94d396fe9@gmail.com>
Date:   Wed, 15 Dec 2021 11:45:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2] cgroup/bpf: fast path for not loaded skb BPF filtering
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <d1b6d4756287c28faf9ad9ce824e1a62be9a5e84.1639200253.git.asml.silence@gmail.com>
 <20211214072716.jdemxmsavd6venci@kafai-mbp.dhcp.thefacebook.com>
 <3f89041e-685a-efa5-6405-8ea6a6cf83f3@gmail.com>
 <20211214191430.h36grlvnxeicuqea@kafai-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211214191430.h36grlvnxeicuqea@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 19:14, Martin KaFai Lau wrote:
> On Tue, Dec 14, 2021 at 11:40:26AM +0000, Pavel Begunkov wrote:
>> On 12/14/21 07:27, Martin KaFai Lau wrote:
>>> On Sat, Dec 11, 2021 at 07:17:49PM +0000, Pavel Begunkov wrote:
>>>> cgroup_bpf_enabled_key static key guards from overhead in cases where
>>>> no cgroup bpf program of a specific type is loaded in any cgroup. Turn
>>>> out that's not always good enough, e.g. when there are many cgroups but
>>>> ones that we're interesting in are without bpf. It's seen in server
>>>> environments, but the problem seems to be even wider as apparently
>>>> systemd loads some BPF affecting my laptop.
>>>>
>>>> Profiles for small packet or zerocopy transmissions over fast network
>>>> show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
>>>> migrate_disable/enable(), and similarly on the receiving side. Also
>>>> got +4-5% of t-put for local testing.
>>> What is t-put?  throughput?
>>
>> yes
>>
>>> Local testing means sending to lo/dummy?
>>
>> yes, it was dummy specifically
> Thanks for confirming.
> 
> Please also put these details in the commit log.
> I was slow.  With only '%' as a unit, it took me a min to guess
> what t-put may mean ;)

I guess requests/s is a more natural metric for net. I anyway going
to resend, will reword it a bit.

>>>> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
>>> and change cgroup.c to directly use this instead, so
>>> everywhere holding a fullsock sk will use this instead
>>> of having two helpers for empty check.
>>
>> Why?
> As mentioned earlier, prefer to have one way to do the same thing
> for checking with a fullsock.
> 
>> CGROUP_BPF_TYPE_ENABLED can't be a function atm because of header
>> dependency hell, and so it'd kill some of typization, which doesn't add
>> clarity.
> I didn't mean to change it to a function.  I actually think,
> for the sk context, it should eventually be folded with the existing
> cgroup_bpf_enabled() macro because those are the tests to ensure
> there is bpf prog to run before proceeding.
> Need to audit about the non fullsock case. not sure yet.

btw, would be nice to rewrite helpers as inline functions, but
sock, cgroup, etc. are not defined in bpf-cgroup.h are can't be
included. May make sense e.g. not include bpf-cgroup.h in bpf.h
but to move some definitions like struct cgroup_bpf into
include/linux/cgroup-defs.h.
Though I'd rather leave it to someone with a better grasp on
BPF code base.


>> And also it imposes some extra overhead to *sockopt using
>> the first helper directly.
> I think it is unimportant unless it is measurable in normal
> use case.

I hope so


>> I think it's better with two of them.
> Ok. I won't insist.  There are atype that may not have sk, so
> a separate inline function for checking emptiness may eventually
> be useful there.

-- 
Pavel Begunkov
