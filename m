Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70996BF045
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCQR7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjCQR7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:59:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA4420A02
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:59:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w9so23601551edc.3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679075945;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CURlZjlwXFBYnr22NG5seE+9tLCX5eL5DZHpPYvttPk=;
        b=qmd/CN745cn4LhYQ0lO3SPLXta/uEBfAThJzBEAkvsTEC/C34wzUXzWWUv+9dsm/zr
         q9x2rvwcf3i5UNSPeN2y9fLIj5gYH7vFYZS1W/6/srnbeli5xE2qKoykOOyKPTp8RdeP
         CPgHX03iN8JwjbB6jQOrm3urlHiwOZe/LviSJQu/pRN0iS49rgxTM+crr0pVRn3JX3Zk
         /ktK8GX4O0GjpF0YIRNDg5dUNBFCZHwz74AXHEDh04gO+aHAhaWaM+1Yu3fHMqORkMD3
         Q4bJBdy4CRe1CkthMTtX08AsZQKATwFJck0WVYNpxRsw4AowMfBGKcEYEc7NdZ+vrfqd
         l6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679075945;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CURlZjlwXFBYnr22NG5seE+9tLCX5eL5DZHpPYvttPk=;
        b=csTGhUD9hThy1/hKTpuFBGU3f8Kc0eHAt9k4dcSwz92w6ToSyMQjXlOwhivSJvnppX
         SDqBwg765CQ+Rbt2hobBRKaDE7kLRrjGEvTHvMzC4cjOWSCoS+jHXFqE40pvibwMd2O+
         Un4wU8qTIBO1TaCHxH8gXupAq1Ohl66PdNE9SDAd1lqYMoNFQf3B+0NjPgQQ5dbLZlPc
         jjQZiM8ZXwwFlFDy+JpBbdrIfU5PONzRb2+NGYX5lAHf81V2iC+VvZT+ML3n5if8O2sc
         voxsvJI22BA4M6jHMD6Vmbbm+lJfbWfIPmrvfNpXFehBITYIWDPFX1aUPrM8loChT60d
         ALug==
X-Gm-Message-State: AO0yUKU5vKdPstQjS6DV4IRV9ur+h92s7lMya4R8v+HGQ/622Q6aZdWn
        Hc6KwBwchMZ3A3XSYExAX7EFb+toud3UAKdeU4s=
X-Google-Smtp-Source: AK7set9OAo5PzMdo/PUAVySCz6yI6OKUJS97VHyaHKf5oJmmwavA29dc1XCBRfhMw1OvbJT5TF2n5Q==
X-Received: by 2002:a05:6402:2143:b0:4fd:29a1:6a58 with SMTP id bq3-20020a056402214300b004fd29a16a58mr4077018edb.19.1679075944990;
        Fri, 17 Mar 2023 10:59:04 -0700 (PDT)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id q30-20020a50aa9e000000b004fadc041e13sm1382394edc.42.2023.03.17.10.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:59:04 -0700 (PDT)
Message-ID: <618e9ca8-29fd-abf2-9f0b-eca253b6d2f4@tessares.net>
Date:   Fri, 17 Mar 2023 18:59:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 09/10] mptcp: preserve const qualifier in
 mptcp_sk()
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, MPTCP Upstream <mptcp@lists.linux.dev>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-10-edumazet@google.com>
 <b9b3e7a2-788b-13ca-91a6-3017c8afbbf4@tessares.net>
 <CANn89i+xOmDmD2=1EQF0U5F5+GQb_HfAWmQD=1FP+6L=qK-E5w@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <CANn89i+xOmDmD2=1EQF0U5F5+GQb_HfAWmQD=1FP+6L=qK-E5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thank you for your quick reply!

On 17/03/2023 18:47, Eric Dumazet wrote:
> On Fri, Mar 17, 2023 at 10:32 AM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
>> On 17/03/2023 16:55, Eric Dumazet wrote:
>>
>> (...)
>>
>>> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
>>> index 61fd8eabfca2028680e04558b4baca9f48bbaaaa..4ed8ffffb1ca473179217e640a23bc268742628d 100644
>>> --- a/net/mptcp/protocol.h
>>> +++ b/net/mptcp/protocol.h
>>
>> (...)
>>
>>> @@ -381,7 +378,7 @@ static inline struct mptcp_data_frag *mptcp_pending_tail(const struct sock *sk)
>>>       return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
>>>  }
>>>
>>> -static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
>>> +static inline struct mptcp_data_frag *mptcp_rtx_head(struct sock *sk)
>>
>> It was not clear to me why you had to remove the "const" qualifier here
>> and not just have to add one when assigning the msk just below. But then
>> I looked at what was behind the list_first_entry_or_null() macro used in
>> this function and understood what was the issue.
>>
>>
>> My naive approach would be to modify this macro but I guess we don't
>> want to go down that road, right?
>>
>> -------------------- 8< --------------------
>> diff --git a/include/linux/list.h b/include/linux/list.h
>> index f10344dbad4d..cd770766f451 100644
>> --- a/include/linux/list.h
>> +++ b/include/linux/list.h
>> @@ -550,7 +550,7 @@ static inline void list_splice_tail_init(struct
>> list_head *list,
>>   * Note that if the list is empty, it returns NULL.
>>   */
>>  #define list_first_entry_or_null(ptr, type, member) ({ \
>> -       struct list_head *head__ = (ptr); \
>> +       const struct list_head *head__ = (ptr); \
>>         struct list_head *pos__ = READ_ONCE(head__->next); \
>>         pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
>>  })
>> -------------------- 8< --------------------
> 
> This could work, but it is a bit awkward.
> 
> mptcp_rtx_head() is used  in a context where we are changing the
> socket, not during a readonly lookup ?

Indeed, you are right. It is currently only used in a context where we
are changing the socket.

I can see cases where a new packets scheduler might just need to check
if the rtx queue is empty but then we should probably add a new helper
using list_empty() instead.

So yes, no need to change anything!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
