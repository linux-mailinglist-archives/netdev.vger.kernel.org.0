Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AFB49C1B3
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbiAZDEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiAZDEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:04:41 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9A8C06161C;
        Tue, 25 Jan 2022 19:04:41 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id i62so10418367ioa.1;
        Tue, 25 Jan 2022 19:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RJx93SIGFBDDn7EsRNuaC6WbM1HCYqgOCfc1oYCMVtc=;
        b=nyHUH8z04QuJfVzLgFeE9NKHzUg16pG3vr1z50y0g67XKx7PIgJ4NNEayEWqMmkdDK
         kMmy0p16K1fDBOnRSbsT6z1v7hQeSK36Xr580eimxR/Q0HWPvY0sAv5UmwfHmDKOUvyc
         uIgAg7DEe+SRIm5tIi1GjNJKsorA6rp7VN94kUASEsjDE/Oop2VRUkP3w37zJFbr9Xp6
         1mCFdjWNECZoZoJC25fGOfijrLXCtBRqMq7jrwuEjH5flMH1O9SZo/uPIeCz52vVCu0T
         Tkziu8dSG2xyouog42mXZoiwJfY20drKxAPaISPHFo3l1WSwJXPmKvpMAMfT+0fAcV3s
         VcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RJx93SIGFBDDn7EsRNuaC6WbM1HCYqgOCfc1oYCMVtc=;
        b=qfjQaZrqkc/IbuknBJ3bi4bBYlEtR4ZpuRyIe+yOvOWEY2lZVnMx9iAdBDicoEEie2
         DhOBERq7zee3a5sza1kgDXrsCeJeH3taLbvIRTdV+6TLOxdgUTe2r8H9XpS/YKRpFgAS
         NQm0VkY+8N5aGWs7n1IwazMRIz4FjwptOt867gQw1gmB7nVusc3aosbZUiKyJy9UARw4
         yypOgQrm0e6lWs3b5KEeH0k1qdQDsPVzREp5fe8LomVNoip7OzRWxibeUbqY/RC9fCo0
         zDTdugHxpFWT7h08j798TFLx1uvBtbhApX73H1Jf3x6wTYvk5qd7bjsHnGjcCO8ve9B8
         +hng==
X-Gm-Message-State: AOAM533Q5/czkcwGFjuHn6Q6DTeQ7Lth+l5flJSZSH8TX7bqvwLK105m
        2mEUOk0CbHb1/bq7BEWrbxQ=
X-Google-Smtp-Source: ABdhPJxMJvlv6Fmn4M3k6RfKRfRseGZVubQCz4bw/tFBurUfSLYMeRec5Y9LRKKWqfrRfAyAMyEnww==
X-Received: by 2002:a02:2ac8:: with SMTP id w191mr9505237jaw.89.1643166280955;
        Tue, 25 Jan 2022 19:04:40 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id y3sm9751056iov.29.2022.01.25.19.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:04:40 -0800 (PST)
Message-ID: <00b8e410-7162-2386-4ce9-d6a619474c30@gmail.com>
Date:   Tue, 25 Jan 2022 20:04:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 5/6] net: udp: use kfree_skb_reason() in
 udp_queue_rcv_one_skb()
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-6-imagedong@tencent.com>
 <308b88bf-7874-4b04-47f7-51203fef4128@gmail.com>
 <CADxym3aFJcsz=fckaFx9SJh8B7=0Xv-EPz79bbUFW1wG_zNYbw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CADxym3aFJcsz=fckaFx9SJh8B7=0Xv-EPz79bbUFW1wG_zNYbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 7:43 PM, Menglong Dong wrote:
> On Wed, Jan 26, 2022 at 10:25 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>> index 603f77ef2170..dd64a4f2ff1d 100644
>>> --- a/include/linux/skbuff.h
>>> +++ b/include/linux/skbuff.h
>>> @@ -330,6 +330,7 @@ enum skb_drop_reason {
>>>       SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
>>>       SKB_DROP_REASON_XFRM_POLICY,
>>>       SKB_DROP_REASON_IP_NOPROTO,
>>> +     SKB_DROP_REASON_UDP_FILTER,
>>
>> Is there really a need for a UDP and TCP version? why not just:
>>
>>         /* dropped due to bpf filter on socket */
>>         SKB_DROP_REASON_SOCKET_FILTER
>>
> 
> I realized it, but SKB_DROP_REASON_TCP_FILTER was already
> introduced before. Besides, I think maybe

SKB_DROP_REASON_TCP_FILTER is not in a released kernel yet. If
Dave/Jakub are ok you can change SKB_DROP_REASON_TCP_FILTER to
SKB_DROP_REASON_SOCKET_FILTER in 'net' repository to make it usable in
both code paths.


> a SKB_DROP_REASON_L4_CSUM is enough for UDP/TCP/ICMP
> checksum error?

Separating this one has value to me since they are separate protocols.
