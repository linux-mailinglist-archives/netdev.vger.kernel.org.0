Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687F75291DD
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347434AbiEPU3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348606AbiEPU1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:27:35 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6A217E16;
        Mon, 16 May 2022 13:10:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id er5so6257947edb.12;
        Mon, 16 May 2022 13:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j+pGwvii1jc/tNdHYIgSpOrAOOK3r8Jt2vj3y0L4fGM=;
        b=U2JZNJI3sulLCkpj0n+9znizP3kQ8boz6tjbcSmp3lf+CQLXQhV+0RQFIHcIAtzGD2
         XSAy44rTYzOQjFYDrjea1aTdngZDRFrWETv4+EWwm/bRXfoR9oQWShgTec5QDyqahXYU
         cyvHpRaLeRgujgKl4nRPQxIyKxA+CVlDlhxA7QdYu4dKMuZfuVpMA+RSrQZpBOaNCmC7
         RGczdslQx3geJ0AsaxfrDjxc9WQ0sTRwQfar/Cn4LEyWaCiH/ZBByD/KhKR9ZxmaR0ZO
         SwQJ9erDavhIr4UXcNPnx03KoQRPH5bgcQLZZrelBBAcfuHEDvZwDdRX7Fkt0lH3FK/r
         1G2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j+pGwvii1jc/tNdHYIgSpOrAOOK3r8Jt2vj3y0L4fGM=;
        b=qcEE/xk9vBDiBpQTT/XgwGiuLLFo05NhEnnnJusqLElli/6idlfZA27SfirKmj3tWO
         FW5l8qq68thXF7J4L3khV1Einakk14m4OBRxsgIu98FgxWnfdHhYQqJXMEsX1/6sJYHN
         C1yiEpcT5opne1rD09fPukrW0G4iyqZlgoF9bo7tfKBVh/1T6ZsDhtdUmarBkFUc28I4
         onmbFh9J1mtVpJX6mFF61zKLLeJgozDjObF6uCfZA0sxzgTWbMKxp+YApZwOdRSh9q1V
         bZLYCqr8vJEoMY2gZtcFkO/EXNaSxvdTsEQmKMEQ1LN0jkD8mRCrgyk1nb2Zx+wQTGTf
         EJLw==
X-Gm-Message-State: AOAM533cUUccZN/wPnEHu434f6zh3jSIQffmde7fnhhvSVTyAWbYb4tR
        kCxzygl9P9qcVNPVMOHyaqo=
X-Google-Smtp-Source: ABdhPJxylhJTYmg6HhuUBuaR84WYzenXA4sDeCzrc+yAfT2f2j7gNohWKKabRT6wAuKGq7/bTasfAA==
X-Received: by 2002:aa7:d659:0:b0:42a:b0d5:a64e with SMTP id v25-20020aa7d659000000b0042ab0d5a64emr7475335edr.157.1652731857280;
        Mon, 16 May 2022 13:10:57 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.74])
        by smtp.gmail.com with ESMTPSA id en21-20020a17090728d500b006f3ef214e6csm108579ejc.210.2022.05.16.13.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 13:10:56 -0700 (PDT)
Message-ID: <c8b30350-6e1c-8ad5-0150-a38996bef13f@gmail.com>
Date:   Mon, 16 May 2022 21:09:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v3 02/10] udp/ipv6: move pending section of
 udpv6_sendmsg
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1652368648.git.asml.silence@gmail.com>
 <a0e7477985ef08c5f08f35b8c7336587c8adce12.1652368648.git.asml.silence@gmail.com>
 <b9844f3ce486c5aff8547e79abf4344488db6568.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b9844f3ce486c5aff8547e79abf4344488db6568.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/22 14:11, Paolo Abeni wrote:
> On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
>> Move up->pending section of udpv6_sendmsg() to the beginning of the
>> function. Even though it require some code duplication for sin6 parsing,
>> it clearly localises the pending handling in one place, removes an extra
>> if and more importantly will prepare the code for further patches.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   net/ipv6/udp.c | 70 ++++++++++++++++++++++++++++++--------------------
>>   1 file changed, 42 insertions(+), 28 deletions(-)
>>
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index 11d44ed46953..85bff1252f5c 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -1318,6 +1318,46 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>   	ipc6.sockc.tsflags = sk->sk_tsflags;
>>   	ipc6.sockc.mark = sk->sk_mark;
>>   
>> +	/* Rough check on arithmetic overflow,
>> +	   better check is made in ip6_append_data().
>> +	   */
>> +	if (unlikely(len > INT_MAX - sizeof(struct udphdr)))
>> +		return -EMSGSIZE;
>> +
>> +	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
>> +
>> +	/* There are pending frames. */
>> +	if (up->pending) {
>> +		if (up->pending == AF_INET)
>> +			return udp_sendmsg(sk, msg, len);
>> +
>> +		/* Do a quick destination sanity check before corking. */
>> +		if (sin6) {
>> +			if (msg->msg_namelen < offsetof(struct sockaddr, sa_data))
>> +				return -EINVAL;
>> +			if (sin6->sin6_family == AF_INET6) {
>> +				if (msg->msg_namelen < SIN6_LEN_RFC2133)
>> +					return -EINVAL;
>> +				if (ipv6_addr_any(&sin6->sin6_addr) &&
>> +				    ipv6_addr_v4mapped(&np->saddr))
>> +					return -EINVAL;
> 
> It looks like 'any' destination with ipv4 mapped source is now
> rejected, while the existing code accept it.

It should be up->pending == AF_INET6 to get there, and previously it'd
fall into udp_sendmsg() and fail

if (unlikely(up->pending != AF_INET))
         return -EINVAL;

I don't see it anyhow rejecting cases that were working before.
Can you elaborate a bit?

-- 
Pavel Begunkov
