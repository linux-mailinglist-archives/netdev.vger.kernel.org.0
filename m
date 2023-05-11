Return-Path: <netdev+bounces-1953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8C56FFB78
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94AF31C210BE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876EDAD53;
	Thu, 11 May 2023 20:50:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743EB12B94
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:50:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CBE1FE9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683838236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pg6DJQ39PxLTjlD/npOMy/qUAXPrBddJcGcULYZUAVk=;
	b=RZ0GdcDdJRjIJW5m+otp18Aofa+3POpj6tI/rHu2RICCcGqCg3Kndx6ot2Wc0rgVkaRWJE
	KE2FoDKyOoXhYb5BkE9a0TNriH1lQNCwlui2e31dOGrQnT3/mT1gz1T6Do4VxgdOeytCE+
	zstBaA3lycnwP4xSjN4jAmylEwhwpv8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-u3pKSU68PZqYzUmgKLpd9A-1; Thu, 11 May 2023 16:50:35 -0400
X-MC-Unique: u3pKSU68PZqYzUmgKLpd9A-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-50bc46a14e8so8336274a12.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683838234; x=1686430234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pg6DJQ39PxLTjlD/npOMy/qUAXPrBddJcGcULYZUAVk=;
        b=O+wC2MFSu9XaQnwt2remROD3ZwCM34gO3vlzyIAMvkuCBlO8xR4fdGBVOEqlIU8pRb
         288XKTcpWsc9HO3Se1zjQTcJmZTqd6SgrBPj+i7bD+XPwRVOdCBZzCOjXj9LILq8t8A6
         PBiDU4vpsd1LCmP+83hJZNYu1Z+waAWP1j6hL42tT4gIYNRujBQpwVhceJOPqTZ5BroL
         DpxYcfTCXnGcM8Dd5jkqPkncYek0yjQSQSGvm5DFhvyU9w4eWddMeyjP86bWiu+g2dT2
         32O7enzM4emOkTlpiLUUl2/t9JnlboC1GIrnapZJg4ocVnBkWKeISsCBHbOUjFBMSS3E
         4RBQ==
X-Gm-Message-State: AC+VfDyExMqY1a+xLbuyYQO1u6msdu5ZnUsp01thZDZcgO8lEK3afsL3
	TVHk0m0JH/7LPPV3ozb665dlqXeX5zjiMtdcpi7sTQVb+pNVSugvG0FNSsHgSOIkT3UQ6mSvmgD
	fabGBl1rCNM511Jj1
X-Received: by 2002:a17:907:1c26:b0:96a:440b:d5db with SMTP id nc38-20020a1709071c2600b0096a440bd5dbmr6139604ejc.47.1683838234372;
        Thu, 11 May 2023 13:50:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6IOii4lzcOpKiwQEXCYdaz9gRGH9Pu1oLKa7Ler+HslbE324KSU5B69Qmzl4ja+tEzwAUTiQ==
X-Received: by 2002:a17:907:1c26:b0:96a:440b:d5db with SMTP id nc38-20020a1709071c2600b0096a440bd5dbmr6139588ejc.47.1683838233969;
        Thu, 11 May 2023 13:50:33 -0700 (PDT)
Received: from [192.168.178.60] (82-75-96-200.cable.dynamic.v4.ziggo.nl. [82.75.96.200])
        by smtp.gmail.com with ESMTPSA id w4-20020a170906b18400b00965fdb9b051sm4495992ejy.115.2023.05.11.13.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 13:50:33 -0700 (PDT)
Message-ID: <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com>
Date: Thu, 11 May 2023 22:50:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
Content-Language: en-US
To: Ilya Maximets <i.maximets@ovn.org>, Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20230511093456.672221-1-atenart@kernel.org>
 <20230511093456.672221-5-atenart@kernel.org>
 <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
 <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
 <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com>
 <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org>
From: Dumitru Ceara <dceara@redhat.com>
In-Reply-To: <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 19:54, Ilya Maximets wrote:
> On 5/11/23 15:00, Dumitru Ceara wrote:
>> On 5/11/23 14:33, Eric Dumazet wrote:
>>> On Thu, May 11, 2023 at 2:10 PM Dumitru Ceara <dceara@redhat.com> wrote:
>>>>
>>>> Hi Antoine,
>>>>
>>>> On 5/11/23 11:34, Antoine Tenart wrote:
>>>>> Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
>>>>> sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
>>>>> used in the TCP Tx path to populate skb->hash, with skb->l4_hash=1.
>>>>> With this, skb->l4_hash does not always indicate the hash is a
>>>>> "canonical 4-tuple hash over transport ports" but rather a hash from L4
>>>>> layer to provide a uniform distribution over flows. Reword the comment
>>>>> accordingly, to avoid misunderstandings.
>>>>
>>>> But AFAIU the hash used to be a canonical 4-tuple hash and was used as
>>>> such by other components, e.g., OvS:
>>>>
>>>> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L1069
>>>>
>>>> It seems to me at least unfortunate that semantics change without
>>>> considering other users.  The fact that we now fix the documentation
>>>> makes it seem like OvS was wrong to use the skb hash.  However, before
>>>> 877d1f6291f8 ("net: Set sk_txhash from a random number") it was OK for
>>>> OvS to use the skb hash as a canonical 4-tuple hash.
>>>>
>>>
>>> I do not think we can undo stuff that was done back in 2015
>>>
>>
>> I understand.  I guess I was kind of grasping at straws in the hope of
>> getting a canonical 4-tuple hash.
>>
>>> Has anyone complained ?
>>>
>>
>> It did go unnoticed for a while but recently we started getting
>> (indirect) reports due to the hash changing.
>>
>> This one is from an upstream OVN (OvS) user:
>> https://github.com/ovn-org/ovn/issues/112
>>
>> This is from an OpenShift (also running OVN/OvS) user:
>> https://issues.redhat.com/browse/OCPBUGS-7406
>>

I just realized we need a bit more context here.  It started being a
visible problem after 265f94ff54d6 ("net: Recompute sk_txhash on
negative routing advice") and also after 3acf3ec3f4b0 ("tcp: Change
txhash on every SYN and RTO retransmit") when retransmits started
changing the txhash and implicitly the hash used by OvS.

>>> Note that skb->hash has never been considered as canonical, for obvious reasons.
> 
> I guess, the other point here is that it's not an L4 hash either.
> 
> It's a random number.  So, the documentation will still not be
> correct even after the change proposed in this patch.
> 
> 
> One other solution to the problem might be to stop setting l4_hash
> flag while it's a random number.
> 
> One way to not break everything doing that will be to introduce a
> new flag, e.g. 'rnd_hash' that will be a hash that is "not related
> to packet fields, but provides a uniform distribution over flows".
> 
> skb_get_hash() then may return the current hash if it's any of
> l4, rnd or sw.  That should preserve the current logic across
> the kernel code.
> But having a new flag, we could introduce a new helper, for example
> skb_get_stable_hash() or skb_get_hash_nonrandom() or something like
> that, that will be equal to the current version of skb_get_hash(),
> i.e. not take the random hash into account.
> 
> Affected subsystems (OVS, ECMP, SRv6) can be changed to use that
> new function.  This way these subsystems will get a software hash
> based on the real packet fields, if it was originally random.
> This will also preserve ability to use hash provided by the HW,
> since it is not normally random.
> 
> With that, we'll also not need to have in the API something that has
> 'L4' in the name and in the docs, but has no relation to packet fields.
> It can be argued that the description in the doc doesn't mean that
> this hash is computed using L4 packet fields, but it's confusing
> regardless and getting overlooked while creating new code, as it
> shown by the issues in multiple substystems.
> 
> Hope this makes some sense.
> 
> 
> Dumitru also had some alternative ideas on how to provide a stable
> hash to subsystems that need it, but I'll leave it to him.
> 
What I had in mind is not really a stable hash but a "good enough
alternative".  It's probably "good enough" (at least for OvS/OVN) if the
hash used by OvS doesn't change throughout the lifetime of a TCP session.

Would it be possible to save the original (random) hash that was
generated for a locally terminated TCP session?  E.g., a new field in
'struct sock'.  It would be in essence a random tag associated to the
session that doesn't change throughout the lifetime of the session.
Unlike sk->sk_txhash which changes on retransmit/negative routing advice.

That means OvS doesn't have to compute a stable hash every time it
processes a packet,  It would just access this value through
skb->sk->good_name_for_this_new_tag.  The advantage is that it gives the
appearance of a canonical 4-tuple hash throughout the lifetime of a
session and it doesn't affect any of the use cases that required
877d1f6291f8 ("net: Set sk_txhash from a random number").

I probably missed relevant things but I thought it might be worth
sharing in case the idea has some value.

Regards,
Dumitru

> Best regards, Ilya Maximets.
> 
>>>
>>>
>>>> Best regards,
>>>> Dumitru
>>>>
>>>>>
>>>>> Signed-off-by: Antoine Tenart <atenart@kernel.org>
>>>>> ---
>>>>>  include/linux/skbuff.h | 4 ++--
>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>>>> index 738776ab8838..f54c84193b23 100644
>>>>> --- a/include/linux/skbuff.h
>>>>> +++ b/include/linux/skbuff.h
>>>>> @@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
>>>>>   *   @active_extensions: active extensions (skb_ext_id types)
>>>>>   *   @ndisc_nodetype: router type (from link layer)
>>>>>   *   @ooo_okay: allow the mapping of a socket to a queue to be changed
>>>>> - *   @l4_hash: indicate hash is a canonical 4-tuple hash over transport
>>>>> - *           ports.
>>>>> + *   @l4_hash: indicate hash is from layer 4 and provides a uniform
>>>>> + *           distribution over flows.
>>>>>   *   @sw_hash: indicates hash was computed in software stack
>>>>>   *   @wifi_acked_valid: wifi_acked was set
>>>>>   *   @wifi_acked: whether frame was acked on wifi or not
>>>>
>>>
>>
> 


