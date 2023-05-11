Return-Path: <netdev+bounces-1779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDEF66FF203
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABD4B281718
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0820A1F94D;
	Thu, 11 May 2023 13:01:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A917720
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:01:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3CF7AA1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683810040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vC82GVZNta5C2s6FviEe75siOIYDxDiS8n0N5diVq6A=;
	b=ETHYelFEhiwp0F2wnw2bLBCNt0Fjsz9SQiJ+G0NqRXK65FMijb3h/sJedr91SoeFLAIjDk
	ySIgjm47njmV2mquc9ErxVSNPGbEoFPAzzbGAjGwqHoG5yeZbjiMRKFmxKp5dP6qYS8gbS
	+6gOzwc5fBI2ajpPAWmBgHgbwg1+cU4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-Fdt5BZpVOFCQxoDnNtOyuw-1; Thu, 11 May 2023 09:00:37 -0400
X-MC-Unique: Fdt5BZpVOFCQxoDnNtOyuw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f315735edeso186312175e9.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683810036; x=1686402036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vC82GVZNta5C2s6FviEe75siOIYDxDiS8n0N5diVq6A=;
        b=T6Uj1TacTQJxb/CIZerpU2IRnTcGS72S74RWtxYsRy8Fdi3nN/rLeRDdlZ18CGqu/V
         iyBFA2SMR0bugIPc9YvkeWnsjcDD4P1rI+COCBRvzkuLOReA5FpDcGJu5OZEyZGlDq/x
         O2xVgTb4dCJ1EcmOghLkWFeUCJLi6VR3LTqKKbjJEs45WQ9roIzMRyWomFSJBsAgO7eG
         NIYESB734JW+gC3HpWNWTc7bJ1qVZVSqD5d14CLCoAXkxibnmSBisSFiXygU9WxgNbVf
         bpWkXVH25jqr2UguxhIXlNoKz4fqwvXFC/4s9d4YyUF/RZvhjIGzALu8wsNjYiBa/aw+
         kNRg==
X-Gm-Message-State: AC+VfDxbaqJPQvL+iekQTgPacqLvAPqcZ4pkjuqnGQ1dGGiGvkkC2K+j
	u/op+Cyi3v6tAEuFTInlfrZjkmds9/yNwjOUcIsGkSL1gEfmH3RBVzzNleKUPIxws8XOCnKInMM
	EO7qFbBWRyj4dYtZu
X-Received: by 2002:adf:ff8c:0:b0:2f8:33bd:a170 with SMTP id j12-20020adfff8c000000b002f833bda170mr19005560wrr.32.1683810036659;
        Thu, 11 May 2023 06:00:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6RH5am32/825UQYdOxcIUYqFYYE08CxJaDK45G+BDQwntBRUycHrh3FdbM05b0lNorjYx2Jw==
X-Received: by 2002:adf:ff8c:0:b0:2f8:33bd:a170 with SMTP id j12-20020adfff8c000000b002f833bda170mr19005521wrr.32.1683810036208;
        Thu, 11 May 2023 06:00:36 -0700 (PDT)
Received: from [192.168.178.60] (82-75-96-200.cable.dynamic.v4.ziggo.nl. [82.75.96.200])
        by smtp.gmail.com with ESMTPSA id f24-20020a1cc918000000b003f0ad8d1c69sm25492151wmb.25.2023.05.11.06.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 06:00:35 -0700 (PDT)
Message-ID: <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com>
Date: Thu, 11 May 2023 15:00:34 +0200
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
To: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 Ilya Maximets <i.maximets@ovn.org>
References: <20230511093456.672221-1-atenart@kernel.org>
 <20230511093456.672221-5-atenart@kernel.org>
 <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
 <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
From: Dumitru Ceara <dceara@redhat.com>
In-Reply-To: <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 14:33, Eric Dumazet wrote:
> On Thu, May 11, 2023 at 2:10 PM Dumitru Ceara <dceara@redhat.com> wrote:
>>
>> Hi Antoine,
>>
>> On 5/11/23 11:34, Antoine Tenart wrote:
>>> Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
>>> sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
>>> used in the TCP Tx path to populate skb->hash, with skb->l4_hash=1.
>>> With this, skb->l4_hash does not always indicate the hash is a
>>> "canonical 4-tuple hash over transport ports" but rather a hash from L4
>>> layer to provide a uniform distribution over flows. Reword the comment
>>> accordingly, to avoid misunderstandings.
>>
>> But AFAIU the hash used to be a canonical 4-tuple hash and was used as
>> such by other components, e.g., OvS:
>>
>> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L1069
>>
>> It seems to me at least unfortunate that semantics change without
>> considering other users.  The fact that we now fix the documentation
>> makes it seem like OvS was wrong to use the skb hash.  However, before
>> 877d1f6291f8 ("net: Set sk_txhash from a random number") it was OK for
>> OvS to use the skb hash as a canonical 4-tuple hash.
>>
> 
> I do not think we can undo stuff that was done back in 2015
> 

I understand.  I guess I was kind of grasping at straws in the hope of
getting a canonical 4-tuple hash.

> Has anyone complained ?
> 

It did go unnoticed for a while but recently we started getting
(indirect) reports due to the hash changing.

This one is from an upstream OVN (OvS) user:
https://github.com/ovn-org/ovn/issues/112

This is from an OpenShift (also running OVN/OvS) user:
https://issues.redhat.com/browse/OCPBUGS-7406

> Note that skb->hash has never been considered as canonical, for obvious reasons.
> 
> 
>> Best regards,
>> Dumitru
>>
>>>
>>> Signed-off-by: Antoine Tenart <atenart@kernel.org>
>>> ---
>>>  include/linux/skbuff.h | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>> index 738776ab8838..f54c84193b23 100644
>>> --- a/include/linux/skbuff.h
>>> +++ b/include/linux/skbuff.h
>>> @@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
>>>   *   @active_extensions: active extensions (skb_ext_id types)
>>>   *   @ndisc_nodetype: router type (from link layer)
>>>   *   @ooo_okay: allow the mapping of a socket to a queue to be changed
>>> - *   @l4_hash: indicate hash is a canonical 4-tuple hash over transport
>>> - *           ports.
>>> + *   @l4_hash: indicate hash is from layer 4 and provides a uniform
>>> + *           distribution over flows.
>>>   *   @sw_hash: indicates hash was computed in software stack
>>>   *   @wifi_acked_valid: wifi_acked was set
>>>   *   @wifi_acked: whether frame was acked on wifi or not
>>
> 


