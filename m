Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A57C6B8075
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCMS1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjCMS0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:26:40 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A015383154
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:41 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id c11so10119801oiw.2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678731940;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qt8GzsWVwQf48KJF/w2M1cY91OaUYyKxO7BVQ0dcWE4=;
        b=Wrc3QnEtJot/S114qt2x0Z1AugqZH50+MrSOmYONv2Oxr/LBrw8NYVj3mZyYAytbZK
         7m2rujiMn5Mp1/CLMqzJdKea13wUorU64ONoOMldAMCz9VCpa2QMwpN1gp04vCAgFRFR
         e7MgumlzaMm33VjdlYCU/EprubOYonDQiiBcuXRcZ8ryeEmAxba7uzp6wm5ExYXWKTsT
         1lb9KiqbLAZ4QYKYrw2bI3nZLMgkS5MnB0ansRAn9WHWSD4KkKwQX/+wjrgr3VFjd0Os
         oSKjeqcGS2SRH+B/lJDz69/J8yimKdJhih3BKykHb3M2gAAOYG+Z7tk0ZtUAoVccjrba
         yvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678731940;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qt8GzsWVwQf48KJF/w2M1cY91OaUYyKxO7BVQ0dcWE4=;
        b=ArpAWTQe9n4N6VeT52UuTp2TeAYYZ8XbfyqR0O6PP1Mt3VO+dxqHuihrTiNHIcCxO3
         DZoYqaDQXWaOBXBnfC1nqn2eo9r/gnGDIqORevNjeXLP6MAGFfE8ky46h25UZc07ejsI
         ADb5hn6H2kWPnpGTrfaf3uWR6/o1RBeM0TNu1k6N3AUo/Pq9yfa1yiZH+uXE4dp33Tj3
         ATZ4x4nDh5MYEoGCCraRcs7S1fTEhqZb5yoZZ+oha/OB/k1rwZDoAWVNTfcyWQ3s50j2
         xIQRUvBNVjRs84j0ajJ8MI8o91KWCSUTZRZ3eTVWqO8cmcoGTG4u5UjCsmsXG9S3ZsKc
         LCHQ==
X-Gm-Message-State: AO0yUKWEolUiWyvpNP2QfwRwRofbj5JQHOmo1ktslle2pFv6shvbEyJ5
        5gTGd8MPNI0gKwjM7I2FPtFGlQ==
X-Google-Smtp-Source: AK7set9IO45+0J+kpkPi3ethqLJpol5BchcKFrfVEcofUbOjFVLEtB5gQRayJI320yC1OEjACUal7g==
X-Received: by 2002:a05:6808:8d7:b0:384:3b4e:4adc with SMTP id k23-20020a05680808d700b003843b4e4adcmr15817691oij.43.1678731940362;
        Mon, 13 Mar 2023 11:25:40 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:49ae:9f38:271d:6240? ([2804:14d:5c5e:4698:49ae:9f38:271d:6240])
        by smtp.gmail.com with ESMTPSA id w20-20020a4a2754000000b0051ac0f54447sm165970oow.33.2023.03.13.11.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 11:25:40 -0700 (PDT)
Message-ID: <8274ae94-a7e5-3a47-3884-2f7d222d4d25@mojatatu.com>
Date:   Mon, 13 Mar 2023 15:25:36 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 1/3] net/sched: act_pedit: use extack in 'ex'
 parsing errors
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230309185158.310994-1-pctammela@mojatatu.com>
 <20230309185158.310994-2-pctammela@mojatatu.com>
 <ZAs8Wc14R3hE/Z4z@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZAs8Wc14R3hE/Z4z@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2023 11:19, Simon Horman wrote:
> On Thu, Mar 09, 2023 at 03:51:56PM -0300, Pedro Tammela wrote:
>> We have extack available when parsing 'ex' keys, so pass it to
>> tcf_pedit_keys_ex_parse and add more detailed error messages.
>> While at it, remove redundant code from the 'err_out' label code path.
>>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> Some errors in tcf_pedit_keys_ex_parse() result in extact being set.
> And some don't.
> 
> Is that intentional?

Good point, I will add more messages.
