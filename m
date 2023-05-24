Return-Path: <netdev+bounces-5012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A872C70F6EE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D12128120F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA9760858;
	Wed, 24 May 2023 12:52:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6002660848
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:52:31 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2412F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:52:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96f99222e80so214397366b.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684932741; x=1687524741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4jVCBihOkUg8I7br77j3MvbR7iCX6aB+sSxj9zryEhU=;
        b=QZsHkzxkp3A65zOu+EffaBnF5ujh7mqpm04tZ5nVF5RMM/e4vGx7W9Cp+taatOWqNM
         RzueOdvJ9k77QsMOCCncvn8Si8E2SRMzN4+SV/1ofFXXf85p7y18B7ykLFJFh8xB6E+P
         qr8oNfsi2pmJoCsFPbAuWvLg4nXoXaL/AgiTXWO0zfea5Ma9Q4Zy76lN45Otkw80baHN
         oTS8WtLrSsNC+BBS+MqfS6mcoQqEBU0R4UU/Kzq0Ld8JZRxq06J7ActtflVb3Uxpy0KG
         WO9qLo1JwARFmP0udfZKgjquj5FTd/qRmznTljyaehVdmZtbOfG4GI4OkTFiW749WM28
         wqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684932741; x=1687524741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4jVCBihOkUg8I7br77j3MvbR7iCX6aB+sSxj9zryEhU=;
        b=B12HeLNaEO2NZ6sXsqjC932aBcRk4qAp10m5HdadHSiNZWV04ibpYaqJOrcX+63Bn4
         s3IVzKu1y6Sls419VxhM2dAwq+U89epKWYzI1JUvq2Mq50Unlt4vwf90aO5A85EjwxV3
         Q042HDrH2NXwd8xMl/6UiYyivFzS9HnVCupOH5r1T3dV2qD7oCO/Rl4hb4n9sDN/p7MZ
         gVPf7hAeLe1wZIi/PntwRdj3wE8+8pyUFNIHUI7lP/RJpijdmxw42pj/wG9GrTDj+LjN
         OJJLy/tJwvC4zSweuaIAYwJGHCllw1JhR0XRh/aPSyLqBhvbjQ/gQOshLnQRjo3AtX8C
         FwFw==
X-Gm-Message-State: AC+VfDzoSKH/SC0lFQdN3oIo1NMWwzEpEjfmVqduHMMs1ayVMA7O3gYY
	M1lO5dOs8RVE+Ou65yOEDrYUAad2hWM=
X-Google-Smtp-Source: ACHHUZ7VlkGRZ4xxO0X9pXIBhZwnMUb9XbrbT63MjHm4EUKi+BynbDkWC+7HE6QggiylG0yeilfhTg==
X-Received: by 2002:a17:907:1c26:b0:96f:a412:8b03 with SMTP id nc38-20020a1709071c2600b0096fa4128b03mr13689717ejc.5.1684932740936;
        Wed, 24 May 2023 05:52:20 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:db3c])
        by smtp.gmail.com with ESMTPSA id w11-20020a170906480b00b0096f82171bdesm5688743ejq.215.2023.05.24.05.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 05:52:20 -0700 (PDT)
Message-ID: <5b93b626-df9a-6f8f-edc3-32a4478b8f00@gmail.com>
Date: Wed, 24 May 2023 13:51:17 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] net/tcp: optimise locking for blocking
 splice
To: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 edumazet@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org
References: <cover.1684501922.git.asml.silence@gmail.com>
 <a6838ca891ccff2c2407d9232ccd2a46fa3f8989.1684501922.git.asml.silence@gmail.com>
 <c025952ddc527f0b60b2c476bb30bd45e9863d41.camel@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c025952ddc527f0b60b2c476bb30bd45e9863d41.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/23/23 14:52, Paolo Abeni wrote:
> On Fri, 2023-05-19 at 14:33 +0100, Pavel Begunkov wrote:
>> Even when tcp_splice_read() reads all it was asked for, for blocking
>> sockets it'll release and immediately regrab the socket lock, loop
>> around and break on the while check.
>>
>> Check tss.len right after we adjust it, and return if we're done.
>> That saves us one release_sock(); lock_sock(); pair per successful
>> blocking splice read.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   net/ipv4/tcp.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index 4d6392c16b7a..bf7627f37e69 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -789,13 +789,15 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
>>   	 */
>>   	if (unlikely(*ppos))
>>   		return -ESPIPE;
>> +	if (unlikely(!tss.len))
>> +		return 0;
>>   
>>   	ret = spliced = 0;
>>   
>>   	lock_sock(sk);
>>   
>>   	timeo = sock_rcvtimeo(sk, sock->file->f_flags & O_NONBLOCK);
>> -	while (tss.len) {
>> +	while (true) {
>>   		ret = __tcp_splice_read(sk, &tss);
>>   		if (ret < 0)
>>   			break;
>> @@ -835,10 +837,10 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
>>   			}
>>   			continue;
>>   		}
>> -		tss.len -= ret;
>>   		spliced += ret;
>> +		tss.len -= ret;
> 
> The patch LGTM. The only minor thing that I note is that the above
> chunk is not needed. Perhaps avoiding unneeded delta could be worthy.

It keeps it closer to the tss.len test, so I'd leave it for that reason,
but on the other hand the compiler should be perfectly able to optimise it
regardless (i.e. sub;cmp;jcc; vs sub;jcc;). I don't have a hard feeling
on that, can change if you want.

-- 
Pavel Begunkov

