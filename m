Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437CF66A887
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 03:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjANCHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 21:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjANCHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 21:07:16 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744CB3B92E
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 18:07:15 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id g10so10476342qvo.6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 18:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GHcGhB9jaSdxosk+1hQLvYye0vfkD2v7Ah59UKjYNNE=;
        b=CIL3Sx1Z8uQxvvLCk9y65PDtohKcUQFNvUDF54dVpDxU6lCt+4TS355s4gctqd/8Kj
         mBLr2afAQB4NDqFAzZ6jKkNA/M9LqTy7ONehpijVwgCZAXB8JHFvPOUhJwvIfLd5r2zJ
         x3XOYss1z1UDwFPKt0KxokntbilsWzG5hV7eSkoU03O2BrMJE7DxfIjEUTkM6z9rQQSC
         VsV9yCl5zr5kP/bBuPgNggkpKomgTUAkzlPkg/4xQ6BNUnotPzNV7ZN56HtYZEKs8HhF
         g9h+L8TMeaKcMgeaqzbCYAqGk+ZhQazMfKHwKXO34oAax+m2frkdr2JullNGVO4Rs4hD
         CP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GHcGhB9jaSdxosk+1hQLvYye0vfkD2v7Ah59UKjYNNE=;
        b=I0DapuHeKSxGRdfdzKuPekDimLazpfLDqkwc7ZFWIyb8YGNm9KKsAsTo8U8fKscpgt
         0WdE5rKcOToopL+flXnXmszUVLPqY3yxmP7Wfa0QvoaZkjYHt5H+b7ZsrO1yCL7vp35n
         ckpxIIO8nubqUX17GbEl/eBIfJMp1QEpXPlH037xovSB492gMmuRA8AMVWIyt9syil/0
         ANcC+5wgwfXLThZWVUH/07emjeZ9qNo/DAVWN5kBeQjcN5ZSI3b3zkvcCIosYV4RHjDd
         v2YiMpt5xIpeSNETpzEAM66GBzBb2EcqblXSIZIGWSmuZnxAnreefkyUNRd87CyhQ/xW
         eYlw==
X-Gm-Message-State: AFqh2kpIws3S0XDDxYUQaBlKTOg0myE8ouwhDNqyJkh8givajlfQ/jh/
        QDDBIqPeDLc79F671wazbEk=
X-Google-Smtp-Source: AMrXdXs4TWHGBdbLWY84IBqCiV/JVlOve7IJz3mEXLpAbBsLEFl42VeMr3JqpuIi74c314xVNlx1Yw==
X-Received: by 2002:a05:6214:3687:b0:4c6:eb3a:8f74 with SMTP id nl7-20020a056214368700b004c6eb3a8f74mr120183348qvb.30.1673662034531;
        Fri, 13 Jan 2023 18:07:14 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a057000b006fa12a74c53sm13442334qkp.61.2023.01.13.18.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 18:07:13 -0800 (PST)
Message-ID: <a370fcd9-0a66-cfad-309d-dceebcf362de@gmail.com>
Date:   Fri, 13 Jan 2023 18:07:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH ethtool 3/3] marvell.c: Fix build with musl-libc
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-4-f.fainelli@gmail.com>
 <20230114001346.tm3f7f5px7swjuzf@lion.mk-sys.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230114001346.tm3f7f5px7swjuzf@lion.mk-sys.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2023 4:13 PM, Michal Kubecek wrote:
> On Fri, Jan 13, 2023 at 03:31:48PM -0800, Florian Fainelli wrote:
>> After commit 1fa60003a8b8 ("misc: header includes cleanup") we stopped
>> including net/if.h which resolved the proper defines to pull in
>> sys/types.h and provide a definition for u_int32_t. With musl-libc we
>> need to define _GNU_SOURCE to ensure that sys/types.h does provide a
>> definition for u_int32_t.
>>
>> Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   marvell.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/marvell.c b/marvell.c
>> index d3d570e4d4ad..be2fc36b8fc5 100644
>> --- a/marvell.c
>> +++ b/marvell.c
>> @@ -6,7 +6,7 @@
>>    */
>>   
>>   #include <stdio.h>
>> -
>> +#define _GNU_SOURCE
>>   #include "internal.h"
>>   
>>   static void dump_addr(int n, const u8 *a)
> 
> I would prefer replacing u_intXX_t types with standard uintXX_t and
> including <stdint.h>. That would be consistent with the rest of the
> code which uses ISO uintXX_t types or (older code) kernel uXX types.

Sounds good, I will do that in v2.
-- 
Florian
