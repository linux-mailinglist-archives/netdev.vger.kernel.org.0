Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184E34EDF28
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbiCaQ4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiCaQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:56:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 974071C3930
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648745696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZToWZTWG2RatZjFZuNOLSxQ2WgnIc03BVug5gHu45Xk=;
        b=edU7XxDp6ZELc6w6P3q5JjnGk91nah7GBQFBrbDX7Gs2ETzcPYa55oFco3jQ8mrp7FRRoi
        N0BQT22Ku+3GuaRDEU27N2e7GMKWA/gIweixLYy5D+RKjk65RKMsjpXLk1GxPMLPq9JxP+
        3Z/hDTU6G7hby8xqo2NHg9LNZZ+U1GU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-txp6c9HPMKaqjHeOAFzpPA-1; Thu, 31 Mar 2022 12:54:55 -0400
X-MC-Unique: txp6c9HPMKaqjHeOAFzpPA-1
Received: by mail-qk1-f198.google.com with SMTP id y140-20020a376492000000b0067b14129a63so15215930qkb.9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZToWZTWG2RatZjFZuNOLSxQ2WgnIc03BVug5gHu45Xk=;
        b=OP9L4/DkigLVceGn7vsxdfM8oHEnoHVH5FVqDs6L53Qhx8V7ZJjYM/j6oTCi/iiMAr
         CgjGUOSz/1FwKGIVnRYiuVCceMoNW5X/eLOP4kjLrn3a9ehx0v9IfFthl6OGf4b84IVp
         iHHjpM1s1zW2DTbhLydNoKB+NGcidlFtz+1lWx7mCydecp+KQ72L8JhrooXfPOmmOeSp
         qMTYTcEGQ4rfdROgyodJ4LhBS3k3mqWxQzO0yDgnUD7ifodrYddpMALEbTyyJDSFG7BH
         aGJG6K13aUb1zVQBkq/jtOlGedVIMT/WOwC+VTLkuZ4NzwH/ucv6munx7hb1JuiKXKts
         mF9A==
X-Gm-Message-State: AOAM530yIzjoUxaxowUbsANB53OhMDR/WoB6YTnHI/SMg/j/oX+cMBQE
        KTBtCyW31hDk4/i4BaFDtIIhP+tUuqiPS7yWlP6E4gWoCnsoICXI/JQeUET1POF679fZaxj0jjB
        nuh1q37lrTf0f2Lzz
X-Received: by 2002:a05:6214:d0a:b0:441:895:6e10 with SMTP id 10-20020a0562140d0a00b0044108956e10mr37050978qvh.70.1648745694569;
        Thu, 31 Mar 2022 09:54:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/zvDc9XumUGcwDsPiLJXLHWwCOXDUQjv4SWRvpgccMWnCRkuKX4ywh92US3bMoyU8ZCoolw==
X-Received: by 2002:a05:6214:d0a:b0:441:895:6e10 with SMTP id 10-20020a0562140d0a00b0044108956e10mr37050948qvh.70.1648745694253;
        Thu, 31 Mar 2022 09:54:54 -0700 (PDT)
Received: from [10.0.0.97] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id y196-20020a3764cd000000b0067d51bbacdfsm13035497qkb.107.2022.03.31.09.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 09:54:53 -0700 (PDT)
Message-ID: <ff3f66ae-6dad-f56f-149f-3587c7181d35@redhat.com>
Date:   Thu, 31 Mar 2022 12:54:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] tipc: use a write lock for keepalive_intv instead of
 a read lock
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Niels Dossche <dossche.niels@gmail.com>,
        tipc-discussion@lists.sourceforge.net
Cc:     netdev@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hoang Le <hoang.h.le@dektech.com.au>
References: <20220329161213.93576-1-dossche.niels@gmail.com>
 <c80aa031a57d1d4a98dc3fbc98863d35e5fc9b58.camel@redhat.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <c80aa031a57d1d4a98dc3fbc98863d35e5fc9b58.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/22 10:28, Paolo Abeni wrote:
> On Tue, 2022-03-29 at 18:12 +0200, Niels Dossche wrote:
>> Currently, n->keepalive_intv is written to while n is locked by a read
>> lock instead of a write lock. This seems to me to break the atomicity
>> against other readers.
>> Change this to a write lock instead to solve the issue.
>>
>> Note:
>> I am currently working on a static analyser to detect missing locks
>> using type-based static analysis as my master's thesis
>> in order to obtain my master's degree.
>> If you would like to have more details, please let me know.
>> This was a reported case. I manually verified the report by looking
>> at the code, so that I do not send wrong information or patches.
>> After concluding that this seems to be a true positive, I created
>> this patch. I have both compile-tested this patch and runtime-tested
>> this patch on x86_64. The effect on a running system could be a
>> potential race condition in exceptional cases.
>> This issue was found on Linux v5.17.
>>
>> Fixes: f5d6c3e5a359 ("tipc: fix node keep alive interval calculation")
>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>> ---
>>   net/tipc/node.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/tipc/node.c b/net/tipc/node.c
>> index 6ef95ce565bd..da867ddb93f5 100644
>> --- a/net/tipc/node.c
>> +++ b/net/tipc/node.c
>> @@ -806,9 +806,9 @@ static void tipc_node_timeout(struct timer_list *t)
>>   	/* Initial node interval to value larger (10 seconds), then it will be
>>   	 * recalculated with link lowest tolerance
>>   	 */
>> -	tipc_node_read_lock(n);
>> +	tipc_node_write_lock(n);
> I agree with Hoang, this should be safe even without write lock, as
> tipc_node_timeout() is the only function modifying keepalive_intv, and
> such function is invoked only by a timer, so we are guaranteeded there
> are no possible concurrent updates...
>
>>   	n->keepalive_intv = 10000;
>> -	tipc_node_read_unlock(n);
>> +	tipc_node_write_unlock(n);
>>   	for (bearer_id = 0; remains && (bearer_id < MAX_BEARERS); bearer_id++) {
>>   		tipc_node_read_lock(n);
> ...otherwise we have a similar issue here: a few line below
> keepalive_intv is updated via tipc_node_calculate_timer(), still under
> the read lock
>
> Thanks!
>
> Paolo
>
Hoang's and Paolo's conclusion is correct.
The patch is not needed.
///jon

