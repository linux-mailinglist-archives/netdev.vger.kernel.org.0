Return-Path: <netdev+bounces-4505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090E370D226
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C1631C20B97
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF46963DD;
	Tue, 23 May 2023 03:04:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00E04C83
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:04:30 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FA48F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:04:28 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-51b33c72686so4672089a12.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684811068; x=1687403068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFNNihuBrXSC701L37bPlsyjHuGUOLaLQwRdUI1QSrM=;
        b=IYn1Lsfyd0/h3pNjHVrIaDJ1pbFjPR3XxctiNvG+P4ElqouoVNhCq8TIGhxSB4tn2+
         +8azudD9VJeI98Lm3g+ir7kOQ+kn3GpOasu2KHaoGvq4MUnahgXyYdcN5oAZ3E9f3l2P
         wG/HiJ61SGhzQxT3nEuEF2kvJA+IEfTnQgMXonzZLr7jRdo4KsGHbtoPYm6TtOj3cHhz
         7wnKRMIFEl0cgsPqrgxuvVlvybyMfNY51vgnE9aR1fI8+JBAXg2ETQ6x2jWk3ufts7fD
         r6skFVysonK39GJ54Oovn2lad4/lpSh84YMgxC6r8Je4lGcQJVhnyAdJwiVJnBAwir7g
         Xkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684811068; x=1687403068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFNNihuBrXSC701L37bPlsyjHuGUOLaLQwRdUI1QSrM=;
        b=kL5kqasSLoOj2PLH2pxg/TwHJLBKnsVOLa9nrA6jk+/seq7DMBXjGn7n68hH3YLyNh
         I5NEmzH4/fHqRGQYnryAwDQORLjNSQKaSu8EZmTWHSj3Rh/VcKzoMXISOp4Zt/zwgizO
         fUXsjAypAGRjswG+0m6t+jHpmak/lqzrD1oyjAzwQE2E84RUpQflJo+GM1uCq1gR9P7J
         kVzZetTkquCnkiSUn2MU7bJRXnMCR/jjfL+G4q1bsvsYYns/seNHNuCrRUVh6Ll7cEVX
         4MzjO1Xg3d6TgqrNDCfMKE9P2YgvGxrEli8H51Rg45lDey/DAg6838UcuyFKEOtNXeHT
         DBRw==
X-Gm-Message-State: AC+VfDyj1Q9ToGa68ww8tXHv5gYdIB/EzLQwitB4LxXe/jGq1zaTpRPu
	u22L+W9P6Ux5jzIk5syQxOqpQQ==
X-Google-Smtp-Source: ACHHUZ6yQU7ZG8zePTbfq80ocZHL60v6iyIxrqH8T42ih7vJQB9zJJk4bGKeFrDgtNX3xO3GkT31lQ==
X-Received: by 2002:a17:902:e80b:b0:1ae:62ed:9630 with SMTP id u11-20020a170902e80b00b001ae62ed9630mr16141107plg.15.1684811068270;
        Mon, 22 May 2023 20:04:28 -0700 (PDT)
Received: from [10.255.25.150] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id ji6-20020a170903324600b001a804b16e38sm5550294plb.150.2023.05.22.20.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 20:04:27 -0700 (PDT)
Message-ID: <59a250f6-d38d-9fae-8835-4fd1c501d913@bytedance.com>
Date: Tue, 23 May 2023 11:04:22 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: Re: [PATCH v2 4/4] sock: Remove redundant cond of memcg pressure
To: Simon Horman <simon.horman@corigine.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Glauber Costa <glommer@parallels.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-5-wuyun.abel@bytedance.com>
 <ZGtmH/0ytVZkkmCP@corigine.com>
Content-Language: en-US
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <ZGtmH/0ytVZkkmCP@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon, thanks for reviewing! I will fix the coding style issues
next version!

Thanks,
	Abel

On 5/22/23 8:54 PM, Simon Horman wrote:
> On Mon, May 22, 2023 at 03:01:22PM +0800, Abel Wu wrote:
>> Now with the preivous patch, __sk_mem_raise_allocated() considers
> 
> nit: s/preivous/previous/
> 
>> the memory pressure of both global and the socket's memcg on a func-
>> wide level, making the condition of memcg's pressure in question
>> redundant.
>>
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>> ---
>>   net/core/sock.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 7641d64293af..baccbb58a11a 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -3029,9 +3029,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>>   	if (sk_has_memory_pressure(sk)) {
>>   		u64 alloc;
>>   
>> -		if (!sk_under_memory_pressure(sk))
>> +		if (!sk_under_global_memory_pressure(sk))
>>   			return 1;
>>   		alloc = sk_sockets_allocated_read_positive(sk);
>> +		/*
>> +		 * If under global pressure, allow the sockets that are below
>> +		 * average memory usage to raise, trying to be fair among all
>> +		 * the sockets under global constrains.
>> +		 */
> 
> nit:
> 		/* Multi-line comments in networking code
> 		 * look like this.
> 		 */
> 
>>   		if (sk_prot_mem_limits(sk, 2) > alloc *
>>   		    sk_mem_pages(sk->sk_wmem_queued +
>>   				 atomic_read(&sk->sk_rmem_alloc) +
>> -- 
>> 2.37.3
>>
>>

