Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CFC56AE25
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiGGWOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGGWOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:14:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C0F2DAB7
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 15:14:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id fd6so24821883edb.5
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 15:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AOzonu74G88DxgvMZKiIFo3EHxFQqJl5NBGJL+KQbBg=;
        b=ZKIIyz/Cnhg+EjLAPjXWYTkMbNGt1e70EBw6r4U/hP76TTG+j7PHoAOLWHOSPUCiJe
         4MCu5dF3Og4x5MHBcFRdeje29olgMBKkkq/76bDzEGDpOhdV8oOXDfkOCD8wOjIDdAnp
         pdTou1VTq+tzd5MyPVFahos1oN5Gi8D0zF7skRPsJWyUwIDWLW8usdFOJDGBbcj8ftid
         +HzsLgHl1BMK9v+t7w5e1HJKfaf5WiJkcR0S/IHZfs+Hl0wmKtIIS9M3z05i+N7CtCrJ
         IxySRaXvci4DkPAo8rHbZRUsFvj820WcL5mG9vnGpIU8t8pZ69xY2cyTg2zIKfI7H5jM
         1wnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AOzonu74G88DxgvMZKiIFo3EHxFQqJl5NBGJL+KQbBg=;
        b=L+TaBl0yPQS50yRcyqHJ5VrxwJttWMGAj+Np9tVrHY51YCTHFFEbmE6BPH89mPEZVo
         Tv2HRInU1hCB74pe3FYvoOiuT4FRt/+YJrRVgw5gQrA+tGnhGI1Azlz3MnroV79zoiVJ
         YIkqgmWQziV9zYtxfiJE+7qZcNDBBX4lKomgMPxfU4fx8xrbwNQQpbDYQv76mfmRxXK5
         MgCX/iBdE2Q92rQL/z0zb0yW/ZgYf7XsVy5mraAwYfXf+uTD5CQJLrNgpVF2XHBnEX8U
         pnxaqQFKlXqmkgXWDQcQq9VLHCZbuGVkzQkDFlVIkJDd3QbDF0Ghd7pZTfB6oGyYzJml
         9A4g==
X-Gm-Message-State: AJIora+vovgcVEw9zV3nrp2lkBC7cR2bH6WiWDFWn0YixLSyu79/50HP
        1myPYu6w/O497ClskfmAJQU=
X-Google-Smtp-Source: AGRyM1trAxPNGfH30s1f5gbkxWItzJWEfQw9CQO8Ez3mlDbYYz1Jm0nA6U8q1cZ1vstwq3XJNi4EHQ==
X-Received: by 2002:a05:6402:34ce:b0:43a:a4bb:27a6 with SMTP id w14-20020a05640234ce00b0043aa4bb27a6mr443298edc.158.1657232074955;
        Thu, 07 Jul 2022 15:14:34 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id t17-20020a1709067c1100b00711d5baae0esm19730219ejo.145.2022.07.07.15.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 15:14:34 -0700 (PDT)
Message-ID: <953f4a8c-1b17-cf22-9cbf-151ba4d39656@gmail.com>
Date:   Fri, 8 Jul 2022 01:14:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next 11/15] net/tls: Multi-threaded calls to TX tls_dev_del
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
References: <20220706232421.41269-1-saeed@kernel.org>
 <20220706232421.41269-12-saeed@kernel.org>
 <20220706193735.49d5f081@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220706193735.49d5f081@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2022 5:37 AM, Jakub Kicinski wrote:
> On Wed,  6 Jul 2022 16:24:17 -0700 Saeed Mahameed wrote:
>> diff --git a/include/net/tls.h b/include/net/tls.h
>> index 4fc16ca5f469..c4be74635502 100644
>> --- a/include/net/tls.h
>> +++ b/include/net/tls.h
>> @@ -163,6 +163,11 @@ struct tls_record_info {
>>   	skb_frag_t frags[MAX_SKB_FRAGS];
>>   };
>>   
>> +struct destruct_work {
>> +	struct work_struct work;
>> +	struct tls_context *ctx;
> 
> Pretty strange to bundle the back-pointer with the work.
> Why not put it directly in struct tls_offload_context_tx?
> 

I can put them directly under struct tls_offload_context_tx.
No strong reason, I just followed the code reference in 
include/net/tls.h :: struct tx_work.
I'll change it and respin.

> Also now that we have the backpointer, can we move the list member of
> struct tls_context to the offload context? (I haven't checked if its
> used in other places)

I'll check and move if possible.

> 
>>   
>>   	up_write(&device_offload_lock);
>>   
>> -	flush_work(&tls_device_gc_work);
>> -
>>   	return NOTIFY_DONE;
>>   }
>>   
>> @@ -1435,6 +1416,5 @@ void __init tls_device_init(void)
>>   void __exit tls_device_cleanup(void)
>>   {
>>   	unregister_netdevice_notifier(&tls_dev_notifier);
>> -	flush_work(&tls_device_gc_work);
>>   	clean_acked_data_flush();
>>   }
> 
> Why don't we need the flush any more? The module reference is gone as
> soon as destructor runs (i.e. on ULP cleanup), the work can still be
> pending, no?

So this garbage collector work does not exist anymore. Replaced by 
per-context works, with no accessibility to them from this function.
It seems that we need to guarantee completion of these works. Maybe by 
queuing them to a new dedicated queue, flushing it here.

