Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A1858C2CA
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 07:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbiHHFYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 01:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbiHHFYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 01:24:10 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3576AE67
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 22:24:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q30so9556553wra.11
        for <netdev@vger.kernel.org>; Sun, 07 Aug 2022 22:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=epvBdCzoLdaTzO8R/dOMwi76RUdf0O2pSwjYAyOVC1U=;
        b=gDjHHIL96yM4+6xr4yCHOTKQqqkxFRZH8SewcwgjmV7JfukhNRuzHPdSRr4RqR2gI6
         GWzCN0up8EA/JWncYA2ah5LOAdlVgv1msccJfCz3ZhZJLh55CMks+O1htO6smig5QhUg
         w5NOPcYKk5VUbuelwwj1JMUHAnf/PDoIDlrjEgyD7ps3QkbAZgcfIEjctGLRwcn4z1li
         9Xf9O+iwuPEyD2tqj23R5wxAlm5SCWur45NgI8BxrML+7Ad2xoLoETQtAqm9UL9Ih7gi
         IlKlydSgXmXR/AqPrqXwmxeyg2/WVKKzDM9izukgvQZ2x7FGEKzt8LEoBhnFNzWLCPGl
         bOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=epvBdCzoLdaTzO8R/dOMwi76RUdf0O2pSwjYAyOVC1U=;
        b=uWL0APYPwvNRv85/OpcC8KpumQUsut9XxH+RHdciKozy5KdD9y+xeExegC7pE+3V43
         NlwcnoNdJTxcV/ZKCHJSfvCEO0XI7iXu3R/9zDX8W458sT1wB9tFWfiObRcwu3fflELO
         u3kU+MocAkJukmmN5rNupSLFWHea9Hnw1sCDst0JIO67/zPaSv/4Kg9fM+If5eKsC/oN
         dH0cqqoyzdiS3MtJShyVR8JPEk2CTMO/og7XvMS3e4JZM2IiwP0L0CcC8xO7GZzasJwZ
         dt8dLblf2Rg1wIA/vaG6xy07CXuOXU8RPFcOdH02rAbCn3gIMztme2OkkJiRPVODPBTC
         d60A==
X-Gm-Message-State: ACgBeo0G3c3Q/roNz7xnakhVI1mOYJDHOu2zf4JX0PhJOvW1RbhdgrIx
        Kud1VVvDcUvY8nSN/B6aQsE=
X-Google-Smtp-Source: AA6agR5IIVopg0iyyIOlTDEkqEBfhoJg/re9oSAJelcAeLjRGCsiWIRGEX4qPTB/GFrGRBRPXHDCTg==
X-Received: by 2002:adf:fe81:0:b0:21b:88ea:6981 with SMTP id l1-20020adffe81000000b0021b88ea6981mr11096766wrr.616.1659936247454;
        Sun, 07 Aug 2022 22:24:07 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id z11-20020a5d44cb000000b00220688d445esm12433121wrr.117.2022.08.07.22.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Aug 2022 22:24:07 -0700 (PDT)
Message-ID: <1513fb1a-e196-bc2c-cdb8-34f962282ea2@gmail.com>
Date:   Mon, 8 Aug 2022 08:24:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
 <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
 <20220803182432.363b0c04@kernel.org>
 <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
 <20220804085950.414bfa41@kernel.org>
 <5696e2f2-1a0d-7da9-700b-d665045c79d9@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <5696e2f2-1a0d-7da9-700b-d665045c79d9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/7/2022 9:01 AM, Tariq Toukan wrote:
> 
> 
> On 8/4/2022 6:59 PM, Jakub Kicinski wrote:
>> On Thu, 4 Aug 2022 11:05:18 +0300 Tariq Toukan wrote:
>>>>        trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - 
>>>> rxm->full_len,
>>>
>>> Now we see a different trace:
>>>
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 4 PID: 45887 at net/tls/tls_strp.c:53
>>
>> OK, if you find another I promise I'll try to hassle a machine with
>> offload from somewhere... here's the fix for the new one:
>>
>> --->8----------------
>> tls: rx: device: don't try to copy too much on detach
>>
>> Another device offload bug, we use the length of the output
>> skb as an indication of how much data to copy. But that skb
>> is sized to offset + record length, and we start from offset.
>> So we end up double-counting the offset which leads to
>> skb_copy_bits() returning -EFAULT.
>>
>> Reported-by: Tariq Toukan <tariqt@nvidia.com>
>> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>>   net/tls/tls_strp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
>> index f0b7c9122fba..9b79e334dbd9 100644
>> --- a/net/tls/tls_strp.c
>> +++ b/net/tls/tls_strp.c
>> @@ -41,7 +41,7 @@ static struct sk_buff *tls_strp_msg_make_copy(struct 
>> tls_strparser *strp)
>>       struct sk_buff *skb;
>>       int i, err, offset;
>> -    skb = alloc_skb_with_frags(0, strp->anchor->len, TLS_PAGE_ORDER,
>> +    skb = alloc_skb_with_frags(0, strp->stm.full_len, TLS_PAGE_ORDER,
>>                      &err, strp->sk->sk_allocation);
>>       if (!skb)
>>           return NULL;
> 
> Hi Jakub,
> Thanks for the patch.
> We're testing it and I'll update.

Trace is gone. But we got TlsDecryptError counter increasing by 2.
