Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3052F2066F7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbgFWWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389401AbgFWWL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:11:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616ACC061573;
        Tue, 23 Jun 2020 15:11:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b5so51982pfp.9;
        Tue, 23 Jun 2020 15:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+5IJDnZQqQFZHwLYeKtmGuz/RCrxf3/d/nSinCwk21A=;
        b=tzM3PFMNQV5udEKabZBfaEPo+aYu3Sy/GLJ8H4Um7gwwHB+dJpFW/cCjHsI6kvGiVm
         1W99pTK6HwukbvqBmrLwtx5E6QeE6V6mO9dM14cEAQYYpMRxIk1kcR9DE5Yk8iSlpVl1
         mKeuRntLzsP8QetozfBqTrLM+MhPo8EOdJn2gxpQXkRXClhSDyddRPoPKqzAxYFoOP1A
         4sxnPnCtxzQHNeH4dQrRSJ+tUv0DajsZvs6hkKOxblqYfgsjRpsgMsNS6RKthGH9dje3
         NxFNOPUln+3tseLt+54tF1EdYkvDBC6mXxL6ilxhxlhQvWErHM60IAHIe/J8iVua5JgF
         rfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+5IJDnZQqQFZHwLYeKtmGuz/RCrxf3/d/nSinCwk21A=;
        b=ATJZjKX88+ll7tEs3d+AKLy9BswIfCunFnSe95ccqdNj36EBe6g5T34PK10Xla7g3X
         BlBxwV98/xhwl6EGSExZ/HwbaxJp5JtMzr6adrZSF/Q8q25I6ROb2dkTMyqG8sk3rz7y
         Z/NjLNQJyDK4+9iLrg7IrlwpXgqeyhSC+GM9+dK7qA8RQsz9DTn2NKUnV7OyNfdrN5E9
         xQ9bTR8rryeWTHMxdvwjknwyjHU1fWKviLW5OZ/18M0n9hYrbFP1pvzgUHV++jn6m6oK
         4zCOXhO7FE0iP8E2To3/uYM3VmTjYpBGpvi6b2vL/NpyDAhUNHSfHryFutxsFJlivkre
         bpdA==
X-Gm-Message-State: AOAM533cpxw0/KjtBMtakuz9HZrF6grYCRG8d1Bs6VOwNpVU33rO0UfA
        BxWPfG/N6b+FtGWSRzHmEEkpjC+2
X-Google-Smtp-Source: ABdhPJy7nDiSafQO9ZtRLhlx7queFvQOYR+rGWFAizm3mQYfnWGqLvoDt4JbzcT5uKsramrCIe9VjQ==
X-Received: by 2002:a65:6714:: with SMTP id u20mr12997718pgf.121.1592950286704;
        Tue, 23 Jun 2020 15:11:26 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u23sm8646276pgn.26.2020.06.23.15.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 15:11:25 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3 09/15] bpf: add bpf_skc_to_udp6_sock() helper
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003636.3074473-1-yhs@fb.com>
 <d0a594f6-bd83-bb48-01ce-bb960fdf8eb3@gmail.com>
 <a721817d-7382-f3d1-9cd0-7e6564b70f8b@fb.com>
 <37d6021e-1f93-259e-e90a-5cda7fddcb21@gmail.com>
 <3e24b214-fc7e-d585-9c8d-98edd6202e70@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ca899dce-4eac-382d-538b-4cab1f5c249d@gmail.com>
Date:   Tue, 23 Jun 2020 15:11:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <3e24b214-fc7e-d585-9c8d-98edd6202e70@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 10:03 AM, Yonghong Song wrote:
> 
> 
> On 6/23/20 9:27 AM, Eric Dumazet wrote:
>>
>>
>> On 6/22/20 7:22 PM, Yonghong Song wrote:
>>>
>>>
>>> On 6/22/20 6:47 PM, Eric Dumazet wrote:
>> &
>>>>
>>>> Why is the sk_fullsock(sk) needed ?
>>>
>>> The parameter 'sk' could be a sock_common. That is why the
>>> helper name bpf_skc_to_udp6_sock implies. The sock_common cannot
>>> access sk_protocol, hence we requires sk_fullsock(sk) here.
>>> Did I miss anything?
>>
>> OK, if arbitrary sockets can land here, you need also to check sk_type
> 
> The current check is:
>         if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_UDP &&
>             sk->sk_family == AF_INET6)
>                 return (unsigned long)sk;
> it checks to ensure it is full socket, it is a ipv6 socket and then check protocol.
> 
> Are you suggesting to add the following check?
>   sk->sk_type == SOCK_DGRAM
> 
> Not a networking expert. Maybe you can explain when we could have
> protocol is IPPROTO_UDP and sk_type not SOCK_DGRAM?


RAW sockets for instance.

Look at :

commit 940ba14986657a50c15f694efca1beba31fa568f
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Jan 21 23:17:14 2020 -0800

    gtp: make sure only SOCK_DGRAM UDP sockets are accepted
    
    A malicious user could use RAW sockets and fool
    GTP using them as standard SOCK_DGRAM UDP sockets.
