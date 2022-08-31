Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF7E5A7CC3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiHaMCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiHaMCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:02:03 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6A5D2900;
        Wed, 31 Aug 2022 05:02:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so14749313pji.1;
        Wed, 31 Aug 2022 05:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=eRbKItI3AZhVvsC86qxXWb/4uz2oQCgmwoWLMJsb7bs=;
        b=aEaUiZbBL3nk9VM+21DWCPPZgDS3s2+8btGMtGjrqc0FEjYXnJxi6cSlN07QXAldvJ
         8c36bVI7E7TQQrvlGQvQAIcNIFkKQv1aWR/3VD4XspDYvWQDvBcFfkBCdOnxe033cZmR
         x+P5U08z+h7sS/rJnYiXrEyDKeNsI8El5vo7l5XvzRU2K0d9JR54xlR2iyfqr3d2qEpu
         jZp6SECjrob07TcOeEFz7BfwOgfwbdEshNk5ZHA2zcm9yAjpwb849xfJVvZF/9Pk2RB+
         jbZxaVMnyC1jrFRPyo5zg/V39ugsVnQpe6hXLTju00ol29oB2yrdO7zDsrnVOfnQ+0vf
         VRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eRbKItI3AZhVvsC86qxXWb/4uz2oQCgmwoWLMJsb7bs=;
        b=Qy0/4gHkHwL6GI7VM7pi507wQSKPR1md+zUUFZZpnyouEmikJ9DIxb12pf+O9Sdgym
         C5QcPYPPZhZ3011XpSo5l6c4tSTLliMAzzGeTIcENesQHScwTgYFssPJcWIsN3pyYhUV
         DrJoUPjdTNwxIlkuWpI5gclXUamxWaa2WIZb6aT4t1ixSypy0h7U5jC6XKKRWz+vW0ZS
         6FFMVRy71Xg6h3DRPKrB3zPoCjoCqVhlZ2D/f38/DReZwXdQxUBFQGLn4Aj1ToXr5lBw
         QjsdXmTKvzgTW3GgGBYvIA3L6ok6WUWBh7jwu3MLcBI2ZCC8iM9iBYFbpUZ1AiqMTEBJ
         EoiQ==
X-Gm-Message-State: ACgBeo1VBUXjcDetPEzZO3SJfTrw+5YCMABAgCc/0Yz0SWNUBAbi9cvZ
        LMXxdUgKHqO9VZWFgj3BJgk=
X-Google-Smtp-Source: AA6agR5AGbwB0CETQbgBGxEfglVui+utWA4TxrvKZPB7PL0Bz2yipS4fqz5X9Aq8TvcpVQ86SsOGzA==
X-Received: by 2002:a17:90b:4acc:b0:1f5:7f05:12e8 with SMTP id mh12-20020a17090b4acc00b001f57f0512e8mr2910177pjb.92.1661947321614;
        Wed, 31 Aug 2022 05:02:01 -0700 (PDT)
Received: from [192.168.0.110] ([103.159.189.140])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090aac1300b001fbbbe38387sm1156380pjq.10.2022.08.31.05.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 05:02:01 -0700 (PDT)
Message-ID: <7768a8f1-fcc6-50da-e5a5-7e2cef619459@gmail.com>
Date:   Wed, 31 Aug 2022 18:01:54 +0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] xfrm: Don't increase scratch users if allocation fails
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <00000000000092839d0581fd74ad@google.com>
 <20220831014126.6708-1-khalid.masum.92@gmail.com>
 <Yw8mUVCdov6l3Cun@gondor.apana.org.au>
From:   Khalid Masum <khalid.masum.92@gmail.com>
In-Reply-To: <Yw8mUVCdov6l3Cun@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/22 15:13, Herbert Xu wrote:
> On Wed, Aug 31, 2022 at 07:41:26AM +0600, Khalid Masum wrote:
>> ipcomp_alloc_scratches() routine increases ipcomp_scratch_users count
>> even if it fails to allocate memory. Therefore, ipcomp_free_scratches()
>> routine, when triggered, tries to vfree() non existent percpu
>> ipcomp_scratches.
>>
>> To fix this breakage, do not increase scratch users count if
>> ipcomp_alloc_scratches() fails to allocate scratches.
>>
>> Reported-and-tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
>> Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
>> ---
>>   net/xfrm/xfrm_ipcomp.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
>> index cb40ff0ff28d..af9097983139 100644
>> --- a/net/xfrm/xfrm_ipcomp.c
>> +++ b/net/xfrm/xfrm_ipcomp.c
>> @@ -210,13 +210,15 @@ static void * __percpu *ipcomp_alloc_scratches(void)
>>   	void * __percpu *scratches;
>>   	int i;
>>   
>> -	if (ipcomp_scratch_users++)
>> +	if (ipcomp_scratch_users) {
>> +		ipcomp_scratch_users++;
>>   		return ipcomp_scratches;
>> -
>> +	}
>>   	scratches = alloc_percpu(void *);
>>   	if (!scratches)
>>   		return NULL;
>>   
>> +	ipcomp_scratch_users++;
>>   	ipcomp_scratches = scratches;
> 
> This patch is broken because on error we will always call
> ipcomp_free_scratches which frees any partially allocated memory
> and restores ipcomp_scratch_users to zero.
> 
> With this patch ipcomp_scratch_users will turn negative on error.
> 
> Cheers,

Thanks for the review. I think it can be fixed by assigning NULL in 
ipcomp_scratches when the allocation fails as ipcomp_free_scratches
checks for it. I shall follow this email with a v2 shortly.

thanks,
   -- Khalid Masum
