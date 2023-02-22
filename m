Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D460269ECC1
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjBVCM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjBVCM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:12:57 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8923ABC;
        Tue, 21 Feb 2023 18:12:56 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id ay9so6419489qtb.9;
        Tue, 21 Feb 2023 18:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677031975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v4lpwOHYzSxX5c6WRqSa/GkQgz2QeIYbbm22Xe8Te0w=;
        b=pEDIEPw3gYH7ZaJUkisB9tmLdQ7teuqxxgEKcDeQQhbXHowsGl4Q6g68bU4GDWMEiD
         v8uReP/oDn5uxTjeRWtPr9nlSqTqLFsqfteL0l1BAg5jNRZNhVChEKoyyBVjDqhHflmE
         TAAme2jpirE7qbsXbkVvEorKhT+c+MIHZEOhqLO5tvwTxyiGsLnaMjnjS/ANqyDxAqVf
         Cou+qX3YAIjxajoWb6rZiy9gdNHSRaVQnw8vdsMJTYVGdzuSTHd+yAGY2DFLn6H3gJ+n
         seIootlUUI+i+63EQXpv8x6IWCWEjioOf03NDFUNGdIQRmBcssqWlWPYCyBEoBeFu5lF
         QtpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677031975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v4lpwOHYzSxX5c6WRqSa/GkQgz2QeIYbbm22Xe8Te0w=;
        b=bjBvKobtodb74evXWNboWW4zTgd0YYKzLA4MEArjYa7f1vhRUZCSWGCX/NJXjQTbce
         Yih96EMvuS23iwgLy3C6G3/SqO0YbqhGTtBIO0xlQIodD2njGI484mTZlHUgGZb+Nzyn
         uRZj99+075+Zw6aboZpVJ/FduDnEiHgOqGQd8qMXGjl7Y4JsTRRQ03oliFk+Fl2J6TDO
         B6xo1kuoqejB+Te0A312KUOb4mpn10Y4B0SoV4YUn1pFZUlwTzc7saw8az+oyICVR7XS
         IXOdDzs2iy7oLUaqVInwo5dq8s3viOng1ExLfdxDDm1zTUn9QRL+8pWvO+3LSFcbgG9T
         PWqQ==
X-Gm-Message-State: AO0yUKWnja/+1/0n8NvmWrO046KcfUgiHnMDE6eJwN5sIiQpQRsErYvu
        x0uwJln0l+xl4IitAlXcPYI=
X-Google-Smtp-Source: AK7set94RYPR0akbGu13MdyWZMtApnFSeK+yvGf5fCi1QUM0c7B0jPjngQ4uXN+CKqxVTrIEBJXxBQ==
X-Received: by 2002:ac8:7d05:0:b0:3b9:a4d4:7f37 with SMTP id g5-20020ac87d05000000b003b9a4d47f37mr14756063qtb.3.1677031975238;
        Tue, 21 Feb 2023 18:12:55 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id t195-20020a3746cc000000b0073fe1056b00sm4474138qka.55.2023.02.21.18.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 18:12:54 -0800 (PST)
Message-ID: <a953cdd9-1cf6-f976-fb6f-4ce0c5d9f3b7@gmail.com>
Date:   Wed, 22 Feb 2023 10:12:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dccp: delete redundant ackvec record in
 dccp_insert_options()
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ian.mcdonald@jandi.co.nz, gerrit@erg.abdn.ac.uk,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230221092206.39741-1-hbh25y@gmail.com>
 <CANn89iJmYoewECcRTDW-F5c=jJZRxwFGMMrOGYe6XBLOgohc6w@mail.gmail.com>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <CANn89iJmYoewECcRTDW-F5c=jJZRxwFGMMrOGYe6XBLOgohc6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/2/2023 20:46, Eric Dumazet wrote:
> On Tue, Feb 21, 2023 at 10:22 AM Hangyu Hua <hbh25y@gmail.com> wrote:
>>
>> A useless record can be insert into av_records when dccp_insert_options()
>> fails after dccp_insert_option_ackvec(). Repeated triggering may cause
>> av_records to have a lot of useless record with the same avr_ack_seqno.
>>
>> Fixes: 8b7b6c75c638 ("dccp: Integrate feature-negotiation insertion code")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/dccp/options.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/dccp/options.c b/net/dccp/options.c
>> index d24cad05001e..8aa4abeb15ea 100644
>> --- a/net/dccp/options.c
>> +++ b/net/dccp/options.c
>> @@ -549,6 +549,8 @@ static void dccp_insert_option_padding(struct sk_buff *skb)
>>   int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
>>   {
>>          struct dccp_sock *dp = dccp_sk(sk);
>> +       struct dccp_ackvec *av = dp->dccps_hc_rx_ackvec;
>> +       struct dccp_ackvec_record *avr;
>>
>>          DCCP_SKB_CB(skb)->dccpd_opt_len = 0;
>>
>> @@ -577,16 +579,22 @@ int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
>>
>>          if (dp->dccps_hc_rx_insert_options) {
>>                  if (ccid_hc_rx_insert_options(dp->dccps_hc_rx_ccid, sk, skb))
>> -                       return -1;
>> +                       goto delete_ackvec;
>>                  dp->dccps_hc_rx_insert_options = 0;
>>          }
>>
>>          if (dp->dccps_timestamp_echo != 0 &&
>>              dccp_insert_option_timestamp_echo(dp, NULL, skb))
>> -               return -1;
>> +               goto delete_ackvec;
>>
>>          dccp_insert_option_padding(skb);
>>          return 0;
>> +
>> +delete_ackvec:
>> +       avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
> 
> Why avr would be not NULL ?
> 
>> +       list_del(&avr->avr_node);
>> +       kmem_cache_free(dccp_ackvec_record_slab, avr);
>> +       return -1;
>>   }
> 
> Are you really using DCCP and/or how have you tested this patch ?
> 
> net/dccp/ackvec.c:15:static struct kmem_cache *dccp_ackvec_record_slab;
> 
> I doubt this patch has been compiled.
> 
> I would rather mark DCCP deprecated and stop trying to fix it.

My bad. I will fix these problems.

Thanks,
Hangyu
