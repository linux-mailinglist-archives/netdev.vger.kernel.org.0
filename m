Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EE560B64C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiJXSyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiJXSyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:54:12 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FB3AC3A7;
        Mon, 24 Oct 2022 10:35:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id jb18so3571105wmb.4;
        Mon, 24 Oct 2022 10:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/CmfQBZQO8HFGCmP6F3RlgjNo/BJ+Zzeh2yojnxzfuU=;
        b=icPjWAo/1lxkMMIzSYyjrKgrnOq4JrrKpqWnupCy2kTGuXZcXBwbK5yKeuwq3YidMn
         VgAgN9T6wJpdY/0NDLZcD/YoNFcabsYQ0k3CynP6varz/ItMzLM3NBxDOzZxdxD9dS2i
         y2PscTk0ZDLHhmJExB+jqH0vA+IVkSfwqZvF4+S0MRQyOwuKqLWblGEJcpX/tLS/lwb5
         uFfJ7NLZJBdRitHOBVxaCdZpK9IMdc2+cG3LPbEwWCpUyABFV4irJ8BW5KmDjjuviMM6
         qmK3BQlNNjsFb1R/C5Oc9RPe1kgC47bBPhUhJO6Zb3DkfhCKzTxR4fV39m0hg6viFOSV
         ZMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CmfQBZQO8HFGCmP6F3RlgjNo/BJ+Zzeh2yojnxzfuU=;
        b=JHV0NhlsYATfjJKTG98X976bbQhW1Wsl0JaulB/GaI+W5bCt3xa2h2b4ZsGE558jwZ
         jhtClB1c8N0+uM/JcNYrwjw8zWoU1UDfA+7mGjEL/TE2Ycd61NPs3CE8GIRgmCMcpVSY
         h9t3V4tOI9OEzZ0M4KefdzofT/2oOgEfF/gKjcuq0Iz8931hPxZ1KRBR702Wa0mqWvRl
         FhMYNdecD/uAUHfc3+4H/L3sb2QDfk9cflKRnk9nX5HT5YI0vYivF9UqNywZo5KQ4W22
         YCdgr7QvyoEk8BqMZMkJ9690Zn0gGotvn6V9rKF5FlBwbP7Lfwyl7luRSZYl3O3CdTbf
         H8Ug==
X-Gm-Message-State: ACrzQf0LSh8gmV3Lra7SCRsx0Yoq1gPE8JTIAb+KLd4nO0OFkc/CxPdA
        q2BBxaq+hiiZzap30mZ/t7RE0Nw+kJ9wNQ==
X-Google-Smtp-Source: AMsMyM7ylij/N6Sj1hh/C/1WKkdBAkPX3qpw9lWw2oxS36L3PBhnQeJc89MR5k2t7/rAnJ+vA48Amw==
X-Received: by 2002:a05:600c:2219:b0:3c4:cf31:8a13 with SMTP id z25-20020a05600c221900b003c4cf318a13mr43750409wml.122.1666630919011;
        Mon, 24 Oct 2022 10:01:59 -0700 (PDT)
Received: from [10.12.252.220] ([185.92.96.86])
        by smtp.gmail.com with ESMTPSA id m17-20020a056000009100b0022eafed36ebsm123075wrx.73.2022.10.24.10.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 10:01:58 -0700 (PDT)
Message-ID: <27c801d6-4031-8510-1eeb-18b7c7e26d1f@gmail.com>
Date:   Mon, 24 Oct 2022 18:00:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1666346426.git.asml.silence@gmail.com>
 <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
 <20221021091404.58d244af@kernel.org>
 <99ab0cb7-45ad-c67d-66f4-6b52c5e6ac33@gmail.com>
 <7852a65b-d0eb-74dd-63f1-08df3434a06e@kernel.dk>
 <d49a8932-eda9-6bb5-bde9-6418406018cd@samba.org>
 <3baa63ac-ff1a-201f-06b3-e7a093f88b11@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3baa63ac-ff1a-201f-06b3-e7a093f88b11@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 15:12, Stefan Metzmacher wrote:
> Am 24.10.22 um 14:49 schrieb Stefan Metzmacher:
>> Am 22.10.22 um 18:07 schrieb Jens Axboe:
>>> On 10/22/22 9:57 AM, Pavel Begunkov wrote:
>>>> On 10/21/22 17:14, Jakub Kicinski wrote:
>>>>> On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
>>>>>> We need an efficient way in io_uring to check whether a socket supports
>>>>>> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
>>>>>> socket flags fields.
>>>>>>
>>>>>> Cc: <stable@vger.kernel.org> # 6.0
>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>> ---
>>>>>> ? include/linux/net.h | 1 +
>>>>>> ? net/ipv4/tcp.c????? | 1 +
>>>>>> ? net/ipv4/udp.c????? | 1 +
>>>>>> ? 3 files changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/include/linux/net.h b/include/linux/net.h
>>>>>> index 711c3593c3b8..18d942bbdf6e 100644
>>>>>> --- a/include/linux/net.h
>>>>>> +++ b/include/linux/net.h
>>>>>> @@ -41,6 +41,7 @@ struct net;
>>>>>> ? #define SOCK_NOSPACE??????? 2
>>>>>> ? #define SOCK_PASSCRED??????? 3
>>>>>> ? #define SOCK_PASSSEC??????? 4
>>>>>> +#define SOCK_SUPPORT_ZC??????? 5
>>>>>
>>>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>>>>
>>>>> Any idea on when this will make it to Linus? If within a week we can
>>>>> probably delay:
>>>>
>>>> After a chat with Jens, IIUC he can take it and send out to
>>>> Linus early. So, sounds like a good plan
>>>
>>> Yes, and let's retain the name for now, can always be changed if we need
>>> to make it more granular. I'll ship this off before -rc2.
>>
>> I'm now always getting -EOPNOTSUPP from SENDMSG_ZC for tcp connections...
> 
> The problem is that inet_accept() doesn't set SOCK_SUPPORT_ZC...

Yeah, you're right, accept is not handled, not great. Thanks
for tracking it down. And I'll add a test for it


> This hack below fixes it for me, but I'm sure there's a nicer way...
> 
> The natural way would be to overload inet_csk_accept for tcp,
> but sk1->sk_prot->accept() is called with sk2->sk_socket == NULL,
> because sock_graft() is called later...

I think it's acceptable for a fix. sk_is_tcp() sounds a bit better
assuming that sk_type/protocol are set there.


> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 3dd02396517d..0f35f2a32756 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -736,6 +736,7 @@ EXPORT_SYMBOL(inet_stream_connect);
>    *    Accept a pending connection. The TCP layer now gives BSD semantics.
>    */
> 
> +#include <net/transp_v6.h>
>   int inet_accept(struct socket *sock, struct socket *newsock, int flags,
>           bool kern)
>   {
> @@ -754,6 +755,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
>             (TCPF_ESTABLISHED | TCPF_SYN_RECV |
>             TCPF_CLOSE_WAIT | TCPF_CLOSE)));
> 
> +    if (sk2->sk_prot == &tcp_prot || sk2->sk_prot == &tcpv6_prot)
> +        set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
>       sock_graft(sk2, newsock);
> 
>       newsock->state = SS_CONNECTED;

-- 
Pavel Begunkov
