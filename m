Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1386529066
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347756AbiEPUaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347571AbiEPU3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:29:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4EA1D31C;
        Mon, 16 May 2022 13:12:02 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id j28so5757889eda.13;
        Mon, 16 May 2022 13:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZCX9ZXrfBYFo8ppmGdS4vsd39cre5IyNg8Ul5W4QUOM=;
        b=eY32+6QDOlX8sByrQ94OB6LdTcAwBGHjmkm7W4QoadC0WKyeoFc/FzBFsNFG/pekQh
         1mB1HBgORPUarS13FEJNf06Xe7XbNHCqA/+O9kgoMIt9RfFUcpbKgsDoi1tCtVhH9uOZ
         te2KmBASqNxltCbskYTG2ZCk4S6I/Ozv8mV1Ir7t+OPfTsgV+I3H7mlvScofOhPJwuzP
         sFe9rWmvSQQ8t0JBigZRcUk4qupj3FwU585+BU4nm05vZrl+uRtQNlSbQFagmIDRgAXM
         8JGZ/xiR+C6wuZ74bgWM5scodqIyXzyCK31IYs6Gfz25Cfn8oL9TvoUlKVaJ3hcTMrKu
         Cdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZCX9ZXrfBYFo8ppmGdS4vsd39cre5IyNg8Ul5W4QUOM=;
        b=2UZoFgHw1oN1Du+6pMWwvnPMCS+AzGZe3z6u3Jk/POHcY0PSmhNcezwFi40Mj1/rBW
         cm9IH5XkVvhHhfYm8VefdFf2nK/cSTZV9GBdYTFD+NnVsAkGyjJcJPmVuyGCgrkEWsQT
         PtQjkfYf3PnuDcq4GwpHNdkLsnuowqVQrcPMKK74nU7KwAyimjuVcIgkR8xe+sOXGcDM
         67/fq8XKcacNWUYViw1d2obfPAdgMy2ELmIuNVqi4+oUGWsDcp83RfRMuWx2y33hiY+S
         rXKXduX8vGw8oeqGhF0e85vnp9Wz5TK4FkLHhbLgHJUg8As7v5wv/xlV7gr6cBfumbJq
         CTzQ==
X-Gm-Message-State: AOAM533ucZLkICWffpfDJfrtCRxSNSntroZ9FGYJQ6kymcOwpuM5YQUC
        l9RRS9bigg4GebXZ3UuG1cc=
X-Google-Smtp-Source: ABdhPJw0xaAds0qvtZ2horG5tUebFQY1UPZglOEYJu4PHfUnAhPU4JhfKfcmBH6586nh9Ug3gG1K7Q==
X-Received: by 2002:a05:6402:4492:b0:428:a206:8912 with SMTP id er18-20020a056402449200b00428a2068912mr15185437edb.279.1652731921518;
        Mon, 16 May 2022 13:12:01 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.74])
        by smtp.gmail.com with ESMTPSA id es16-20020a056402381000b0042a96c77e9esm3807434edb.91.2022.05.16.13.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 13:12:01 -0700 (PDT)
Message-ID: <cc171828-8ea8-bf5a-cdd8-b769f6beb7a1@gmail.com>
Date:   Mon, 16 May 2022 21:10:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v3 03/10] udp/ipv6: prioritise the ip6 path over
 ip4 checks
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1652368648.git.asml.silence@gmail.com>
 <50cca375d8730b5bf74b975d0fede64b1a3744c4.1652368648.git.asml.silence@gmail.com>
 <f0fb2ffbde15b2939ed76545b549bdcd33b92ae8.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f0fb2ffbde15b2939ed76545b549bdcd33b92ae8.camel@redhat.com>
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

On 5/16/22 14:14, Paolo Abeni wrote:
> On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
>> For AF_INET6 sockets we care the most about ipv6 but not ip4 mappings as
>> it's requires some extra hops anyway. Take AF_INET6 case from the address
>> parsing switch and add an explicit path for it. It removes some extra
>> ifs from the path and removes the switch overhead.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   net/ipv6/udp.c | 37 +++++++++++++++++--------------------
>>   1 file changed, 17 insertions(+), 20 deletions(-)
>>
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index 85bff1252f5c..e0b1bea998ce 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -1360,30 +1360,27 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>   
>>   	/* destination address check */
>>   	if (sin6) {
>> -		if (addr_len < offsetof(struct sockaddr, sa_data))
>> -			return -EINVAL;
>> +		if (addr_len < SIN6_LEN_RFC2133 || sin6->sin6_family != AF_INET6) {
>> +			if (addr_len < offsetof(struct sockaddr, sa_data))
>> +				return -EINVAL;
> 
> I think you can't access 'sin6->sin6_family' before validating the
> socket address len, that is before doing:

Paolo, thanks for reviewing it!


sin6_family is protected by

if (addr_len < SIN6_LEN_RFC2133 ...)

on the previous line. I can add a BUILD_BUG_ON() if that
would be more reassuring.


> 
> if (addr_len < offsetof(struct sockaddr, sa_data))

-- 
Pavel Begunkov
