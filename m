Return-Path: <netdev+bounces-4660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E03070DB77
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6811280E83
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1126F4A864;
	Tue, 23 May 2023 11:29:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037484A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:29:29 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F09F11A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:29:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae58e4b295so47155985ad.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684841367; x=1687433367;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QmAH7D4gu+/LqJqROct5SqtuBq3KdxiRPY9I9eXlXSE=;
        b=ZD5D7CE/e65K27r8szZiMurwNaCxaRdGb67vzDNUWeChI6i63diAJ9ZuRmF9bB697f
         6gq/mt8563OZF98uGaHx/v6F+vLeHlPFPzMw6JmhX2OpP0Ee5mcUSzxis1J3R1dYazye
         VAjvzZEj+mYljzEv9oJ6E+9zCr1qdhBUR9zrZsMSPpWcpyU/uEn6OiLehEP8HarUBp6n
         yPeZbCl+hTQZG1ERSNAeyEfI3wkYia6hwdokOqleSbHiw9OjzEmf454iCy48BLwDk8n9
         DZ8xUEXrYssKrhZ7ikr74PJa0MT9ui8xQbErT47JodVA15gPYf1Eph9j6tOjcAanGhG4
         jKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684841367; x=1687433367;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QmAH7D4gu+/LqJqROct5SqtuBq3KdxiRPY9I9eXlXSE=;
        b=kaV6qNEV9r56XM5/aB/ywpq0nrSY9+RGv3iU0+Vth1kr8OCGuNnMQArtxN5ivmCxtl
         Mc9RobJpGaJQyI0NLt9//L2vE7CP4hj++P2IfbNCKbQxf/7hhNq5myLdimM9FoiVqjzg
         8EpEka7AwDRi0SN1VjBaItzTpD827IdWFPeKx6f3b9fBdQ7AO7F0+KOHL4l/U6ETf+ah
         o4vhqopQEBfoxGS7MF1TeKoTjWub5mNn+FIZFvPwEAlDnxc7eI8/YUZQDpOG88LiR2x8
         +ktJQ+S1sMxX9sljd+0wJxUMTJZKIb6YjNEbDzLpAa2UF/k5ruMj63ZhYE6QdnNoO6KB
         qTXw==
X-Gm-Message-State: AC+VfDwBztbVMXL7p04rj671ajJ5rJxC2kq/wA+lxYCKIn6Hl4f8k37/
	QxoXjHIwg2z7OuleafEj35iyDQ==
X-Google-Smtp-Source: ACHHUZ7nUaQPePxWSD/ka5HaSe15sJIKu/E/LKlKePd9CPLwgQaxsiHIYn4rXk+I9Qp2jmGC6V0Z6Q==
X-Received: by 2002:a17:902:c20c:b0:1aa:ef83:34be with SMTP id 12-20020a170902c20c00b001aaef8334bemr13534069pll.47.1684841366703;
        Tue, 23 May 2023 04:29:26 -0700 (PDT)
Received: from [10.255.25.150] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902788500b001a96269e12csm6574848pll.51.2023.05.23.04.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:29:26 -0700 (PDT)
Message-ID: <79945d0c-2430-c094-f3ba-12ee428eb8c7@bytedance.com>
Date: Tue, 23 May 2023 19:29:20 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: Re: [PATCH v3 4/5] sock: Consider memcg pressure when raising
 sockmem
Content-Language: en-US
To: Paolo Abeni <pabeni@redhat.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230523094652.49411-1-wuyun.abel@bytedance.com>
 <20230523094652.49411-5-wuyun.abel@bytedance.com>
 <58241c427684e6da0ab454d344421c2fb29a0465.camel@redhat.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <58241c427684e6da0ab454d344421c2fb29a0465.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/23/23 6:26 PM, Paolo Abeni wrote:
> On Tue, 2023-05-23 at 17:46 +0800, Abel Wu wrote:
>> For now __sk_mem_raise_allocated() mainly considers global socket
>> memory pressure and allows to raise if no global pressure observed,
>> including the sockets whose memcgs are in pressure, which might
>> result in longer memcg memstall.
>>
>> So take net-memcg's pressure into consideration when allocating
>> socket memory to alleviate long tail latencies.
>>
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>> ---
>>   net/core/sock.c | 23 ++++++++++++++++-------
>>   1 file changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 801df091e37a..b899e0b9feda 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2976,22 +2976,31 @@ EXPORT_SYMBOL(sk_wait_data);
>>   int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>>   {
>>   	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
>> +	bool charged = true, pressured = false;
>>   	struct proto *prot = sk->sk_prot;
>> -	bool charged = true;
>>   	long allocated;
>>   
>>   	sk_memory_allocated_add(sk, amt);
>>   	allocated = sk_memory_allocated(sk);
>> -	if (memcg_charge &&
>> -	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
>> -						gfp_memcg_charge())))
>> -		goto suppress_allocation;
>> +
>> +	if (memcg_charge) {
>> +		charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
>> +						  gfp_memcg_charge());
>> +		if (!charged)
>> +			goto suppress_allocation;
>> +		if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
>> +			pressured = true;
>> +	}
>>   
>>   	/* Under limit. */
>> -	if (allocated <= sk_prot_mem_limits(sk, 0)) {
>> +	if (allocated <= sk_prot_mem_limits(sk, 0))
>>   		sk_leave_memory_pressure(sk);
>> +	else
>> +		pressured = true;
> 
> The above looks not correct to me.
> 
> 	allocated > sk_prot_mem_limits(sk, 0)
> 
> does not mean the protocol has memory pressure. Such condition is
> checked later with:
> 
> 	if (allocated > sk_prot_mem_limits(sk, 1))

Yes, this condition stands means the global socket memory is absolutely
under pressure, and the status is sustained until @allocated falls down
to sk_prot_mem_limits(sk, 0). I see some places in the source tree call
it 'soft pressure' if usage between index [0] and [1].

The idea behind this patch is to allow the socket memory to raise if
there is no pressure neither in global nor net-memcg. With the condition

	@allocated > sk_prot_mem_limits(sk, 0)

we can't be sure whether there is pressure or not in global. And this
also aligns with the original logic if net-memcg is not used.

I am thinking changing the name of this variable to @might_pressured or
something to better illustrate the status of memory pressure. What do
you think?

> 
> Here an allocation could fail even if memcg charge is successful and
> the protocol is not under pressure, which in turn sounds quite (too
> much?) conservative.

IIUC the failure can only be due to its memcg under vmpressure. In this
case allowing the allocation would burden the mm subsys with increased
fragmented unmovable/unreclaimable memory.

Thanks & Best,
	Abel

