Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C47C5EC525
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiI0N6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiI0N5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:57:54 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF1114C041;
        Tue, 27 Sep 2022 06:57:52 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id cj27so6021449qtb.7;
        Tue, 27 Sep 2022 06:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=mUB704FSEGxSOVArknJGqafUlGbK8/FllOe0WL2/T7w=;
        b=PipCI1tcJgWnQmjn/22EAsWD11kC47AcgNPKWaFlmZdH2xcMZYOcI/vGZ4fbA6dIfR
         puPf3XKj83NkFy37waZvfGxF/zUKbMWJXlZCyFioAUalrn7pJjmxankgwvVOB1AAB5Pf
         WVPFxWNDS9jtqx5LlzmsLgWEa9UA/gUBLPTrd3UPoiB804wQmQFXnRz1+ZdawuM1I3lR
         ef6VhGUTDskhqz3M4UrTx+ue06wEMeG/ZMUwz1iwv/uA576cu6ndETRYUYfE1vC/ycEp
         CLTdHy0iBe4k1Trc0rzRLqCni03HCiBpR4d9swldF1d7dBpUDR38377AMnrAG5cX+pLt
         VfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=mUB704FSEGxSOVArknJGqafUlGbK8/FllOe0WL2/T7w=;
        b=j5XPizaJoaJUxhImKj3PxcI2h5l3mtRa0m0EUiEUpFDnG26M11/JBV21Fnga6XCTPQ
         EGe+HUDsBM0vqsElYQeyY7GrdCVHD2Ma1wpjKUne8ANbHLPm3pm/upM80Kgr5sERCM9x
         dS+BHyMRl4dJvU5NzpLroMPG8GEBKS5Y1QHjlMOxcc1hOA2SkE9GEo44kalRN2B4178g
         5ZwFSToQkcNF0XpJrKoglzsoJulmrIcAz9ozknTviE3nwXefZjp4oARy0lQMHNoegCk8
         HUqC2to5Z+hBtG18VmWqfFCEqX9iM+QbtRkXXNLWJQ0os6ag2BSZOkelCXN06CpneAqP
         sYJw==
X-Gm-Message-State: ACrzQf32VojHYk0D5e2BtvsmuGu4Q0aurPnsUESlcZBThYBWMw2ksFuI
        vt6Bvbk6IKk69o7WJjNb6/4=
X-Google-Smtp-Source: AMsMyM4i19SLgtb/zAa+/hoI5z7lUAYLxIftnm77N+XPhAdWsOv5dfN8gnP/tI7brApRRVKJuybTCw==
X-Received: by 2002:ac8:5f48:0:b0:35d:1b11:6ae5 with SMTP id y8-20020ac85f48000000b0035d1b116ae5mr20606060qta.247.1664287071504;
        Tue, 27 Sep 2022 06:57:51 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id br15-20020a05620a460f00b006b5cc25535fsm980289qkb.99.2022.09.27.06.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 06:57:51 -0700 (PDT)
Message-ID: <b7cc392b-448d-ad40-f915-4b4e4b8c232b@gmail.com>
Date:   Tue, 27 Sep 2022 09:57:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 07/13] sunhme: Convert FOO((...)) to FOO(...)
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220924015339.1816744-1-seanga2@gmail.com>
 <20220924015339.1816744-8-seanga2@gmail.com>
 <9412f706a4934d218019d74c5f4b74ae@AcuMS.aculab.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <9412f706a4934d218019d74c5f4b74ae@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 03:58, David Laight wrote:
> From: Sean Anderson
>> Sent: 24 September 2022 02:54
>>
>> With the power of variadic macros, double parentheses are unnecessary.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
>> ---
>>
>> Changes in v2:
>> - sumhme -> sunhme
>>
>>   drivers/net/ethernet/sun/sunhme.c | 272 +++++++++++++++---------------
>>   1 file changed, 136 insertions(+), 136 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index 7d6825c573a2..77a2a192f2ce 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -134,17 +134,17 @@ static __inline__ void tx_dump_log(void)
>>   #endif
>>
>>   #ifdef HMEDEBUG
>> -#define HMD(x)  printk x
>> +#define HMD printk
> 
> That probably ought to be:
> 	#define HMD(...) printk(__VA_ARGS__)
> 
> (and followed through all the other patches)

The final macro is

#define hme_debug(fmt, ...) pr_debug("%s: " fmt, __func__, ##__VA_ARGS__)
#define HMD hme_debug

so I think that satisfies your comment.

--Sean

