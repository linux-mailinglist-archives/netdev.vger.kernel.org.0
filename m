Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6132E17E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfE2Ps0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:48:26 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41381 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2Ps0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:48:26 -0400
Received: by mail-oi1-f195.google.com with SMTP id y10so2427589oia.8;
        Wed, 29 May 2019 08:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LZchaD3I1pN+W2x6aXpBTqpBkJQ7vSF4YhK33FN5Rj8=;
        b=qzpiO6pTCKQX1nUSnENk6OCaUVGtGus+mU7zsIokP7VFrV3/y6NS1q/t8kZUrPm7aP
         G/bdxogT3+udxBk/3V7yhiqG71qB2Rc2OQvBzMnVF7yGbPxSrxkBcvODfNb6vBY2HrPH
         PMQDgvwIEWh4+dhjjK31PZsMYDlJy+rmHWDeIfn9KPovn4rPdOtVIBlNHmK0Tjz0ExUp
         AcVnBsDAmCmpR0rOHQ2O7CdXu7na9dF5cnw2pitOB4liUPUSUpyLMv++PuErGsA0rc4c
         ZOAH0otCcetK3U7GVbzqWCgdsafDP+Z61FSmffpJP+YPllAk/FmOZqe/wNIrdobm30xK
         4hVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LZchaD3I1pN+W2x6aXpBTqpBkJQ7vSF4YhK33FN5Rj8=;
        b=JVzF8gEvSUhjLKfurjD35yUpyGretPhLqnEkTGl0T8vpJzqqa3GTANzOj2vZ5xiZ4Y
         BbrvYBMhJmgJf0eP6N+rrzDxAX3vJC0IsmJsOGPfYFcbUwiqCxxh2laF9A8AB/vF1npQ
         HknVB479IyCSJcliuZo3dimsuhe3wvO3D75oYwmyslM4R8T7W8Aq/6lk+3pxviBODZob
         To2yYAqI1j2MoD3cFkzohCN439BFsPtuvgYqmsSsAM8sx7AXSNHp2ZpjVat3YujTJCja
         PL/3oLuCD0rHw+sot4mONjD3Bslmcfw6crzPH2USUac1wTqDcrVqiNFyoQ/j28iznC+U
         P9UQ==
X-Gm-Message-State: APjAAAX8MfBvviQOpHTkUe6T9ibhCEUHDyqZaeYssDj9JtmrdSjWK0GY
        lzxhyXoFo89d1IKqbxJfhDBqYrlU
X-Google-Smtp-Source: APXvYqzffYfqcKCi1LN/X7kBP+pUiwaRtjqaBthtG1n+KqU9jvNOTltF+EZDu4QrfcdWF0UXHAf+5A==
X-Received: by 2002:aca:314a:: with SMTP id x71mr6875894oix.142.1559144904941;
        Wed, 29 May 2019 08:48:24 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id i8sm568364oib.12.2019.05.29.08.48.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 08:48:22 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Fix null-pointer dereferences in error handling
 code of rtl_pci_probe()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190514123439.10524-1-baijiaju1990@gmail.com>
 <20190528115555.301E760F3C@smtp.codeaurora.org>
 <2658b691-b992-b773-c6cf-85801adc479f@lwfinger.net>
 <357682ba-d1ae-23b1-2372-b1a33d2ba1ac@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <589a0fb2-0033-1374-c3e0-597392a3f4c8@lwfinger.net>
Date:   Wed, 29 May 2019 10:48:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <357682ba-d1ae-23b1-2372-b1a33d2ba1ac@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 5:30 AM, Jia-Ju Bai wrote:
> 
> 
> On 2019/5/28 21:00, Larry Finger wrote:
>> On 5/28/19 6:55 AM, Kalle Valo wrote:
>>> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>>>
>>>> *BUG 1:
>>>> In rtl_pci_probe(), when rtlpriv->cfg->ops->init_sw_vars() fails,
>>>> rtl_deinit_core() in the error handling code is executed.
>>>> rtl_deinit_core() calls rtl_free_entries_from_scan_list(), which uses
>>>> rtlpriv->scan_list.list in list_for_each_entry_safe(), but it has been
>>>> initialized. Thus a null-pointer dereference occurs.
>>>> The reason is that rtlpriv->scan_list.list is initialized by
>>>> INIT_LIST_HEAD() in rtl_init_core(), which has not been called.
>>>>
>>>> To fix this bug, rtl_deinit_core() should not be called when
>>>> rtlpriv->cfg->ops->init_sw_vars() fails.
>>>>
>>>> *BUG 2:
>>>> In rtl_pci_probe(), rtl_init_core() can fail when rtl_regd_init() in
>>>> this function fails, and rtlpriv->scan_list.list has not been
>>>> initialized by INIT_LIST_HEAD(). Then, rtl_deinit_core() in the error
>>>> handling code of rtl_pci_probe() is executed. Finally, a null-pointer
>>>> dereference occurs due to the same reason of the above bug.
>>>>
>>>> To fix this bug, the initialization of lists in rtl_init_core() are
>>>> performed before the call to rtl_regd_init().
>>>>
>>>> These bugs are found by a runtime fuzzing tool named FIZZER written by
>>>> us.
>>>>
>>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>>
>>> Ping & Larry, is this ok to take?
>>>
>>
>> Kalle,
>>
>> Not at the moment. In reviewing the code, I was unable to see how this 
>> situation could develop, and his backtrace did not mention any rtlwifi code. 
>> For that reason, I asked him to add printk stat4ements to show the last part 
>> of rtl_pci that executed correctly. In 
>> https://marc.info/?l=linux-wireless&m=155788322631134&w=2, he promised to do 
>> that, but I have not seen the result.
>>
> 
> Hi Larry,
> 
> This patch is not related to the message you mentioned.
> That message is about an occasional crash that I reported.
> That crash occurred when request_irq() in rtl_pci_intr_mode_legacy() in 
> rtl_pci_intr_mode_decide() fails.
> I have added printk statements and try to reproduce and debug that crash, but 
> that crash does not always occur, and I still do not know the root cause of that 
> crash.
> 
> The null-pointer dereferences fixed by this patch are different from that crash, 
> and they always occur when the related functions fail.
> So please review these null-pointer dereferences, thanks :)
> 
> 
> Best wishes,
> Jia-Ju Bai

Sorry if I got confused. Kalle has dropped this patch, thus you will need to 
submit a new version.

Larry

