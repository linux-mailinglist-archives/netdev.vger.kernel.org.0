Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A04513855
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349163AbiD1Pb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349039AbiD1Pb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:31:26 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA1AB0A4F;
        Thu, 28 Apr 2022 08:28:11 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g20so5941770edw.6;
        Thu, 28 Apr 2022 08:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ch/ZtI4KpEXScEqZimVchhnhnRwZuiX0qxTyST1Yn2o=;
        b=BY5xSbA0UnNgyOKeZBLaGbeP7emvZCKOxpo0COt1DslBptxCiWnZIMOFwvxI+Ftf2s
         X32E13UDx9/c1FbsJRN78jtM9zq9ud+LRGrHDqRQ6kFJgTPdvPoKY16CjUGDpnLhgOAo
         fcq9CGX+i2atQhSaZHM6EvZm1N98o0QPAKEu2VoTlJ0B8rDTj1Xin9jFPw4lvnJCH1f4
         UjpYvh1BC815dkW5y7cWCWDnO/LOawQ5oAMuUfxtgCGMhpDfU4uwt37rG/o+GF3xtgQa
         kjfRra4QKZJfP4DeZHP1+600NbFyTEqjgAuoYea5Ea0slBpjJPvbatt+4MCib7u6sD1i
         aEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ch/ZtI4KpEXScEqZimVchhnhnRwZuiX0qxTyST1Yn2o=;
        b=47Kh/HVS3YT/kG7mTgX7wdNHVxDxqfBueL7fbOUxn8rsUV/nLjSjTqHJggFUvLJklx
         qAh7UFmqGgeBGo/AQqkaMqfT9ffw2djRqIUx5/LKhy/iFigJ3kuQFq/bGd2EdQjZanHE
         KQcWoSczVGz+aTkSF2+rB7N+ZUAtB9U+oeWzbym2iput22LRAi2USPJLHvQ26UpCWeSt
         W4xiCntOV72ATXKF4RGhHtp12WrhRTbIP1n+wNZ9GViTF3GeYY124ejQNAFUIoIo7XL2
         aVIA/HwzQrD3r+EJzGHimS6xutw8nJbhn/L4VBDbDuMRUHjRggICLEAxf+/lEoGGIv5t
         yD6w==
X-Gm-Message-State: AOAM531BAhUtrILXANb5zeflkAMAMD/DQveyk8qqukiR/fDLC6vPJ2Ta
        6XB03AeCE3m+BBTPZspnp8U=
X-Google-Smtp-Source: ABdhPJwlZ+HlhcNftxpgUFH4WQGGTIK106UeyDR06lq4db6fJTGhdiYuK0CMOhx/Qp2FTuHBihUZrw==
X-Received: by 2002:aa7:d751:0:b0:425:d38c:41a1 with SMTP id a17-20020aa7d751000000b00425d38c41a1mr29299130eds.162.1651159689975;
        Thu, 28 Apr 2022 08:28:09 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id b20-20020a1709063f9400b006e12836e07fsm103527ejj.154.2022.04.28.08.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 08:28:09 -0700 (PDT)
Message-ID: <e4a9103e-feaa-7e0d-8597-1fe35b399561@gmail.com>
Date:   Thu, 28 Apr 2022 16:27:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 01/11] ipv6: optimise ipcm6 cookie init
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1651071843.git.asml.silence@gmail.com>
 <64341db6ca5a1f4d1eebbe86a7ee0b7d7400335e.1651071843.git.asml.silence@gmail.com>
 <ffc7a45e9c77303b47bf2faaf3498ed8a3c1ab1a.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ffc7a45e9c77303b47bf2faaf3498ed8a3c1ab1a.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 15:04, Paolo Abeni wrote:
> On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
>> Users of ipcm6_init() have a somewhat complex post initialisation
>> of ->dontfrag and ->tclass. Not only it adds additional overhead,
>> but also complicates the code.
>>
>> First, replace ipcm6_init() with ipcm6_init_sk(). As it might be not an
>> equivalent change, let's first look at ->dontfrag. The logic was to set
>> it from cmsg if specified and otherwise fallback to np->dontfrag. Now
>> it's initialising to np->dontfrag in the beginning and then potentially
>> overriding with cmsg, which is absolutely the same behaviour.
>>
>> It's a bit more complex with ->tclass as ip6_datagram_send_ctl() might
>> set it to -1, which is a default and not valid value. The solution
>> here is to skip -1's specified in cmsg, so it'll be left with the socket
>> default value getting us to the old behaviour.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/net/ipv6.h    | 9 ---------
>>   net/ipv6/datagram.c   | 4 ++--
>>   net/ipv6/ip6_output.c | 2 --
>>   net/ipv6/raw.c        | 8 +-------
>>   net/ipv6/udp.c        | 7 +------
>>   net/l2tp/l2tp_ip6.c   | 8 +-------
>>   6 files changed, 5 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
>> index 213612f1680c..30a3447e34b4 100644
>> --- a/include/net/ipv6.h
>> +++ b/include/net/ipv6.h
>> @@ -352,15 +352,6 @@ struct ipcm6_cookie {
>>   	struct ipv6_txoptions *opt;
>>   };
>>   
>> -static inline void ipcm6_init(struct ipcm6_cookie *ipc6)
>> -{
>> -	*ipc6 = (struct ipcm6_cookie) {
>> -		.hlimit = -1,
>> -		.tclass = -1,
>> -		.dontfrag = -1,
>> -	};
>> -}
>> -
>>   static inline void ipcm6_init_sk(struct ipcm6_cookie *ipc6,
>>   				 const struct ipv6_pinfo *np)
>>   {
>> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
>> index 206f66310a88..1b334bc855ae 100644
>> --- a/net/ipv6/datagram.c
>> +++ b/net/ipv6/datagram.c
>> @@ -1003,9 +1003,9 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
>>   			if (tc < -1 || tc > 0xff)
>>   				goto exit_f;
>>   
>> +			if (tc != -1)
>> +				ipc6->tclass = tc;
>>   			err = 0;
>> -			ipc6->tclass = tc;
>> -
>>   			break;
>>   		    }
> 
> It looks like the above causes a behavioral change: before this patch
> cmsg took precedence on socket status, after this patch looks like it's
> the opposide.
> 
> Am I missing something?

before:

ipc6.tclass = -1;
if (cmsg)
	ip6_datagram_send_ctl(&ipc6);
if (ipc6.tclass < 0)
	ipc6.tclass = np->tclass;

after:

ipc6.tclass = np->tclass; // ipcm6_init_sk()
if (cmsg)
	ip6_datagram_send_ctl(&ipc6);


Both should prioritise cmsg. The only catch is when tclass is
specified in cmsg but it's -1. The old version would assign
np->tclass in the end, the new one does the same but with
this added "if" in ip6_datagram_send_ctl() in the chunk
you quoted. Unless I missed something as well.

-- 
Pavel Begunkov
