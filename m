Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521F56AC4D0
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjCFP13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCFP12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:27:28 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26C630B01
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 07:27:21 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id u9so40270361edd.2
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 07:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678116440;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ODNvh0aj+RRcc0sJE3W2ZNeaulZCi+AZxVWHyLYlNzA=;
        b=AqDBHud3xX7XCrcHWa5O19qVjUg7N96KM4zCm7tQZ9qbecaSGYt3cJBRSHOsG7m91H
         3cD3agmBuYbFBxBnlY5cdY1gvNd45lLIvmkMA7F8wGnmx2u2v89LelBw+3PEW+ALy/nA
         NX7X8lOirF6ev97+0Di1vfJIneprxBaKJ0RNIo2X0qjVimdEtL3Cg+kUNDGyX8KWp/nP
         0gKoVHYwWU8L75nsr93uLCNjZT0IoZYGzht+61VYkKlSvKhoa/Rn3X+PEdLc2SUuGW57
         vCmixDchC2OJhvahAp3JRUr+GZVST4d7fAek0ynU9ZcbRpOPRfCoTVPmzYHCd1gk6eh1
         gVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678116440;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODNvh0aj+RRcc0sJE3W2ZNeaulZCi+AZxVWHyLYlNzA=;
        b=4uPsFxbbycj7VGsPUWLW/f5CLXfFVDJ8MBJ9qkci+CQSHS1IH4WQgarovW59FB2/rz
         jP0iJwM6mWSvblpcf9MZ4Owzun9p1YfBubZko4enBVwqmGcP0MJnmLxFdtbY6awn2Gil
         wpkjla8IBjE0ZUBIy8s9deIx2jTfCWZOZHBJWVyzM052r2YhC2ZHHVkRjNhmw9RTZiap
         9CwSuRJnU3NZmCh0ggUr96xbpDIu0vP6St9Y51iMGflGmftYMPG9Lg52XYNUCBTWH7GD
         d/shtGAZ/tkl9YfN3j0kJxLPgQm22477MMVmZvdTjwSdOwLV/Zp1RI5m3z6fIghb8eEI
         5niA==
X-Gm-Message-State: AO0yUKXghW5/mGQ73i2QX7ezZE7gDSwXjdxmzMS/cMPvjLRF/YKsRw2e
        91IDgDRyCS+31wgJX0LeLDsTuw==
X-Google-Smtp-Source: AK7set//DXK2NFElPWWdfefGNYB8q/vr/0SdcYbhhdP4nrgNd+1EHgYzumflJt70FpO31uL6521Vfw==
X-Received: by 2002:a17:907:6d92:b0:8ed:e8d6:4e0e with SMTP id sb18-20020a1709076d9200b008ede8d64e0emr17396285ejc.36.1678116440341;
        Mon, 06 Mar 2023 07:27:20 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:c1e7:5006:98ac:f57? ([2a02:810d:15c0:828:c1e7:5006:98ac:f57])
        by smtp.gmail.com with ESMTPSA id h7-20020a50cdc7000000b004bc15a440f1sm5301661edj.78.2023.03.06.07.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 07:27:20 -0800 (PST)
Message-ID: <e004ef95-290d-19d4-eab7-483b1ede573b@linaro.org>
Date:   Mon, 6 Mar 2023 16:27:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] nfc: fix memory leak of se_io context in nfc_genl_se_io
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
References: <20230225105614.379382-1-pchelkin@ispras.ru>
 <b0f65aaa-37aa-378f-fbbf-57d107f29f5f@linaro.org>
 <20230227150553.m3okhdxqmjgon4dd@fpc>
 <7e9ffa10-d6e8-48b5-e832-cf77ac1a8802@linaro.org>
 <20230228112531.gam3dwqyx36pyynf@fpc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230228112531.gam3dwqyx36pyynf@fpc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/02/2023 12:25, Fedor Pchelkin wrote:
> On Tue, Feb 28, 2023 at 11:14:03AM +0100, Krzysztof Kozlowski wrote:
>> On 27/02/2023 16:05, Fedor Pchelkin wrote:
>>>>> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
>>>>> Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
>>>>> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
>>>>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>>>>
>>>> SoB order is a bit odd. Who is the author?
>>>>
>>>
>>> The author is me (Fedor). I thought the authorship is expressed with the
>>> first Signed-off-by line, isn't it?
>>
>> Yes and since you are sending it, then what is Alexey's Sob for? The
>> tags are in order...
>>
> 
> Now I get what you mean. Alexey is my supervisor and the patches I make
> are passed through him (even though they are sent by me). If this is not
> a customary thing, then I'll take that into account for further
> submissions. I guess something like Acked-by is more appropriate?

Different people abuse these tags in different way, so it happens, but
it's not necessarily the correct way. I, for example, see little value
of some tags added from some internal and private arrangements. If
Alexey wants to ack something, sure, please ack - we have mailing list
for that. Storing acks for some of your private process is not relevant
to upstream process.

> 
>>>
>>>>> ---
>>>>>  drivers/nfc/st-nci/se.c   | 6 ++++++
>>>>>  drivers/nfc/st21nfca/se.c | 6 ++++++
>>>>>  net/nfc/netlink.c         | 4 ++++
>>>>>  3 files changed, 16 insertions(+)
>>>>>
>>>>> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
>>>>> index ec87dd21e054..b2f1ced8e6dd 100644
>>>>> --- a/drivers/nfc/st-nci/se.c
>>>>> +++ b/drivers/nfc/st-nci/se.c
>>>>> @@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
>>>>>  					ST_NCI_EVT_TRANSMIT_DATA, apdu,
>>>>>  					apdu_length)
>>>> nci_hci_send_event() should also free it in its error paths.
>>>> nci_data_exchange_complete() as well? Who eventually frees it? These
>>>> might be separate patches.
>>>>
>>>>
>>>
>>> nci_hci_send_event(), as I can see, should not free the callback context.
>>> I should have probably better explained that in the commit info (will
>>> include this in the patch v2), but the main thing is: nfc_se_io() is
>>> called with se_io_cb callback function as an argument and that callback is 
>>> the exact place where an allocated se_io_ctx context should be freed. And
>>> it is actually freed there unless some error path happens that leads the
>>
>> Exactly, so why nci_hci_send_event() error path should not free it?
>>
> 
> nci_hci_send_event() should not free it on its error path because the
> bwi_timer is already charged before nci_hci_send_event() is called.
> 
> The pattern in the .se_io functions of the corresponding drivers (st-nci,
> st21nfca) is following:
> 
> 	info->se_info.cb = cb;
> 	info->se_info.cb_context = cb_context;
> 	mod_timer(&info->se_info.bwi_timer, jiffies +
> 		  msecs_to_jiffies(info->se_info.wt_timeout)); // <-charged
> 	info->se_info.bwi_active = true;
> 	return nci_hci_send_event(...);
> 
> As the timer is charged, it will eventually call se_io_cb() to free the
> context, even if the error path is taken inside nci_hci_send_event().
> 
> Am I missing something?

Hm, sounds right.

Best regards,
Krzysztof

