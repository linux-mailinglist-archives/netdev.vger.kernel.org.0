Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773CA528268
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbiEPKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242889AbiEPKng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:43:36 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD56224950
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 03:43:10 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o22so16690219ljp.8
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 03:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HMrxutDweeUYQ3ATxwWpcqN8/976PlWz92Z8YtqbWzw=;
        b=RgimAa0q2u5zJ5ZY0mkEsPOVENHf5WfOmpAWknPRBcfPpvBBLO6fUtB83DFiEptqPI
         hS+THU5KI73w//qfz++JIoya54tm65L34Endgdg9ROFNZFZV8wg8Tkx/pj6L7OfcckRN
         2ooJEHGAUw8tyw092xdvEYnL3uE3o+aHyb+Zm2NjBMUHp4lrmyitnEKO2xr/4prLRMsl
         Dz4RMqtNZNrHxTiRgog9rtg/dX+dj/clXXMMXkp6OgMQMJXlhuQpdoMPkwko0UZjd16T
         GZF6f4HlcET6rZfRwWlifKuNFCD4pGAe/sgQfvplFTt0ovrn9mTLR+FNo46Ri82VZ4HL
         FVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HMrxutDweeUYQ3ATxwWpcqN8/976PlWz92Z8YtqbWzw=;
        b=qUiBNhK/t3kyZ5Lfyqm30GBC8nW1wd7E890DZ3Yf7R0H+C5tNJr6afNO6R5tSeNVUD
         vO8M8JX3keo3cQE82Vb5ciw9e75a81lFsgd9HkXqmJBDArITIynx1J2UsCkSBOVDWsGQ
         /RmoHVjcR0mySkwFcV5RdHzcfBj9qMeskgnYltBr8UNeuIV24rPEhmdWiZHh+GiOYVlU
         6uXYfXiYLbUdsWK0ZIDk9VWg9c2gqeiFmTp1Q/7inukS+aJCmIkAAz5yRBhnm+ogtW/j
         /emr4fgXjThaLsXsRhJgyNKBCRN2ObGl0EFdzDjqk1OAeEOsep7lAaJ6we5lCCmXlrJj
         Kybw==
X-Gm-Message-State: AOAM531MnShcXAKmZArIc3FXGOR5XlpohNxi/o7/uhrTV7So1E+gt85i
        0GJy2ZXmMmNywF8tBAmd7lP68w==
X-Google-Smtp-Source: ABdhPJw91cQ2XfbmgzGL8D01LEHR3rpwl6a3yuvXOYVaArq35Nl0sdSUqVPITn5NbhfalGLcCIiavA==
X-Received: by 2002:a05:651c:1542:b0:249:a87f:8a34 with SMTP id y2-20020a05651c154200b00249a87f8a34mr10770319ljp.442.1652697789158;
        Mon, 16 May 2022 03:43:09 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z15-20020ac25def000000b0047255d21180sm1264983lfq.175.2022.05.16.03.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 03:43:08 -0700 (PDT)
Message-ID: <ea2af2f9-002a-5681-4293-a05718ce9dcd@linaro.org>
Date:   Mon, 16 May 2022 12:43:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
Content-Language: en-US
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, netdev@vger.kernel.org
References: <20220516021028.54063-1-duoming@zju.edu.cn>
 <d5fdfe27-a6de-3030-ce51-9f4f45d552f3@linaro.org>
 <6aba1413.196eb.180cc609bf1.Coremail.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <6aba1413.196eb.180cc609bf1.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/05/2022 12:18, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Mon, 16 May 2022 08:44:39 +0200 Krzysztof wrote:
> 
>>> There are sleep in atomic context bugs when the request to secure
>>> element of st21nfca is timeout. The root cause is that kzalloc and
>>> alloc_skb with GFP_KERNEL parameter is called in st21nfca_se_wt_timeout
>>> which is a timer handler. The call tree shows the execution paths that
>>> could lead to bugs:
>>>
>>>    (Interrupt context)
>>> st21nfca_se_wt_timeout
>>>   nfc_hci_send_event
>>>     nfc_hci_hcp_message_tx
>>>       kzalloc(..., GFP_KERNEL) //may sleep
>>>       alloc_skb(..., GFP_KERNEL) //may sleep
>>>
>>> This patch changes allocation mode of kzalloc and alloc_skb from
>>> GFP_KERNEL to GFP_ATOMIC in order to prevent atomic context from
>>> sleeping. The GFP_ATOMIC flag makes memory allocation operation
>>> could be used in atomic context.
>>>
>>> Fixes: 8b8d2e08bf0d ("NFC: HCI support")
>>> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
>>> ---
>>>  net/nfc/hci/hcp.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
>>> index 05c60988f59..1caf9c2086f 100644
>>> --- a/net/nfc/hci/hcp.c
>>> +++ b/net/nfc/hci/hcp.c
>>> @@ -30,7 +30,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
>>>  	int hci_len, err;
>>>  	bool firstfrag = true;
>>>  
>>> -	cmd = kzalloc(sizeof(struct hci_msg), GFP_KERNEL);
>>> +	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
>>
>> No, this does not look correct. This function can sleep, so it can use
>> GFP_KERNEL. Please just look at the function before replacing any flags...
> 
> I am sorry, I don`t understand why nfc_hci_hcp_message_tx() can sleep.

Why? because in line 93 it uses a mutex (which is a sleeping primitve).

> 
> I think st21nfca_se_wt_timeout() is a timer handler, which is in interrupt context.
> The call tree shows the execution paths that could lead to bugs:
> 
> st21nfca_hci_se_io()
>   mod_timer(&info->se_info.bwi_timer,...)
>     st21nfca_se_wt_timeout()  //timer handler, interrupt context
>       nfc_hci_send_event()
>         nfc_hci_hcp_message_tx()
>           kzalloc(..., GFP_KERNEL) //may sleep
>           alloc_skb(..., GFP_KERNEL) //may sleep
> 
> What`s more, I think the "mutex_lock(&hdev->msg_tx_mutex)" called by nfc_hci_hcp_message_tx()
> is also improper.
> 
> Please correct me, If you think I am wrong. Thanks for your time.

Your patch is not correct in current semantics of this function. This
function can sleep (because it uses a mutex), so the mistake is rather
calling it from interrupt context.


Best regards,
Krzysztof
