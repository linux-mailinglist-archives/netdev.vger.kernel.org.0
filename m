Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7855BE164
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiITJHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiITJH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:07:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DA16F559
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:05:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id r18so4475346eja.11
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=mzfcqpBkglh/gR500QL3rZ/H+YTKdF7NYoFfORcrUF8=;
        b=nvC7B5puBTkanDM2WAtQpj1DNNpkPTP5davaWRsUkcxnKe6ZC9G1ytrMkFHrKKA3mu
         Ejme7m7jGZGm7levGS6nGS3XQtesd8RLF6snWkWieIYfc7y9DIKLH9DwhuwQKrWIHdUu
         ohiUx0cyND8cY31YsjSGX11CR7PgiqsnsD5wmv+EZaVaSn2PJZQ7ivk8At966B9j+MDf
         HBPx9frB57nB5rEY9wsElR9bmlOwZgH6sHGLKJc4jgRyxCjMcNxbRTSqV++/k4V44JeL
         TgUsZtShVuQdU8PeGJV0OjdSqIkTXvG1Bg99tPCGzjg0tr2VbBF7GM/bCw0mzN07x7JS
         vqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=mzfcqpBkglh/gR500QL3rZ/H+YTKdF7NYoFfORcrUF8=;
        b=E7NQe8kF8fV5xxkhn+cpA1UeJ2kgCBTdDWKssLopkXG7UktFi36MeV+5Po/gPdwawE
         mVZ0fkSYoMGqd7d8WwCwim6V/i8n5B6Szpsc50lmi7t7KtcPmzBdId7dJ3FjzsaA801K
         KTTY8Jz9FnpnPsfjM4OytM4VWO18/vkfcCaoYasDAtXL9VN3Ru/XKRdhFkw1goyIIr/k
         LL85aGCoDibXpojSca9JVDlhVAqIMcp140YpHXyZ3FFq8LEYdXh0gzIZaMUhO18XXplm
         Zx59yTwDV7a+PbQp9mizw21e6foK344C4THCEZoGWHyGfE8HlxrEk7Lbb+MlUQyZMPt2
         cWOA==
X-Gm-Message-State: ACrzQf2yeXhsIBSxGd/ZX42IbS7c6Vs3lOo6t4gH1hYjcb/MKFikeKsG
        ifmJkHo9kBSlJ9OMtcZhEo+GNA==
X-Google-Smtp-Source: AMsMyM5OCtwf1QDqpUMZvbZsQ4NnB5yK+DhuotL+pox4bnOZnUMy0iGooBhwNA3oGYYhgbMl8AMizQ==
X-Received: by 2002:a17:907:75e3:b0:77a:2378:91ba with SMTP id jz3-20020a17090775e300b0077a237891bamr15623579ejc.738.1663664726112;
        Tue, 20 Sep 2022 02:05:26 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id s1-20020a170906454100b00780f24b797dsm514800ejq.108.2022.09.20.02.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 02:05:25 -0700 (PDT)
Message-ID: <f26fa81a-dc13-6a27-2e63-74b13359756e@blackwall.org>
Date:   Tue, 20 Sep 2022 12:05:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next v4 04/12] net: netlink: add NLM_F_BULK delete
 request modifier
Content-Language: en-US
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220413105202.2616106-1-razor@blackwall.org>
 <20220413105202.2616106-5-razor@blackwall.org>
 <0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 10:49, Nicolas Dichtel wrote:
> 
> Le 13/04/2022 à 12:51, Nikolay Aleksandrov a écrit :
>> Add a new delete request modifier called NLM_F_BULK which, when
>> supported, would cause the request to delete multiple objects. The flag
>> is a convenient way to signal that a multiple delete operation is
>> requested which can be gradually added to different delete requests. In
>> order to make sure older kernels will error out if the operation is not
>> supported instead of doing something unintended we have to break a
>> required condition when implementing support for this flag, f.e. for
>> neighbors we will omit the mandatory mac address attribute.
>> Initially it will be used to add flush with filtering support for bridge
>> fdbs, but it also opens the door to add similar support to others.
>>
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>>  include/uapi/linux/netlink.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
>> index 4c0cde075c27..855dffb4c1c3 100644
>> --- a/include/uapi/linux/netlink.h
>> +++ b/include/uapi/linux/netlink.h
>> @@ -72,6 +72,7 @@ struct nlmsghdr {
>>  
>>  /* Modifiers to DELETE request */
>>  #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
>> +#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
> Sorry to reply to an old patch, but FWIW, this patch broke the uAPI.
> One of our applications was using NLM_F_EXCL with RTM_DELTFILTER. This is
> conceptually wrong but it was working. After this patch, the kernel returns an
> error (EOPNOTSUPP).
> 
> Here is the patch series:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?h=92716869375b
> 
> We probably can't do anything now, but to avoid this in the future, I see only
> two options:
>  - enforce flags validation depending on the operation (but this may break some
>    existing apps)
>  - stop adding new flags that overlap between NEW and DEL operations (by adding
>    a comment or defining dummy flags).
> 
> Any thoughts?
> 

Personally I'd prefer to enforce validation so we don't lose the flags because of buggy user-space
applications, but we can break someone (who arguably should fix their app though). We already had
that discussion while the set was under review[1] and just to be a bit more confident I also
tried searching for open-source buggy users, but didn't find any.

> Regards,
> Nicolas

[1] https://lore.kernel.org/netdev/97774474-65a3-fa45-e0b9-8db6c748da28@kernel.org/t/#m23018ce831dae16d42cb9c393c7c6bad1bc621c3
