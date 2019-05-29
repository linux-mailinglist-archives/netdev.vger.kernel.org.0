Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF252DACA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfE2Kaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:30:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40800 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2Kaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:30:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id g69so881350plb.7;
        Wed, 29 May 2019 03:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eqm2y/EYl4t9ex2ApVRgE5oPtA8beu8cf/DNbQrWYC4=;
        b=uMu3UTNKyJbv+4as+0rx0Fi2vB4KtZcLZq5TD6/9FDRPs13p6whhNkASMmJjD6Ozb7
         lXhyVLIo1j3zjvzxLSjkOZzArNGza7sHn9UK0KWfi50964KUPElWKYzx33u1JDcqPOVF
         RZTY85DytWLIzMkoRfoaDvnq0lKwRX7iCNLWP9+baOTfqjvXJc6u5Fa4+VR17p7kThCZ
         7N6y7yj/ndb9hPZ2RSui1bEQZN5uDaX93pPnFhJ6HCCzqZPkHL7gjkKdaPaTAeshvjfb
         b8hiOAKyqBzMaAyIYXMgXIr97oY1EfFQhhyjbVr1XVCHAlavhcyQ0dpTtxU3+MgKtRf3
         tX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eqm2y/EYl4t9ex2ApVRgE5oPtA8beu8cf/DNbQrWYC4=;
        b=rhTPYxB8zjm2F1zsAMqFOX9RbP3FLsi4/ZDY1lN5purwj+sYWXD1iYcjcxyoto0rJS
         43OaRBqHH0FumuZ4o2Wq1ZgtU5I6w2HIo4aNHF+NHbnhEFTq8pP9TLhjPkdZ5RWCxZxT
         cDNFJTTpj2F+JhifQgry+x+Y+RT0EAm9eAgDOaFYbhwsnbjEXCXVVRL2kZSGx7H4p2Rr
         IIk1pBmKzAqrImVkRFddbu8VMZHjSypHqqnfz1DkwvEflUGNxouyJgAR/+IEjGYco0Ym
         qh4nQTr1zDzP68EpKKyJXMkdUrLSvbMIjtfMxkotd1hBNrhMexRZ2lHbbq/A2Yj7yA6/
         AYkg==
X-Gm-Message-State: APjAAAXXdgBeSA5qwTJpYanE9Bpj1a6fAvcV0nGBUwV0EAW6ArZnmnJq
        F9N3yeDZYvZacwWIAZ2AgQ0a8UnY
X-Google-Smtp-Source: APXvYqy4UuEQmCOIlNfSXgEQNLzqyrc/T8k26j9JHdYBHLQOWsBiZt/cus10aFbM3YVtAvOLl4GZNA==
X-Received: by 2002:a17:902:2865:: with SMTP id e92mr29668592plb.264.1559125851418;
        Wed, 29 May 2019 03:30:51 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.21? ([2402:f000:1:1501:200:5efe:a66f:4715])
        by smtp.gmail.com with ESMTPSA id t24sm20556776pfq.63.2019.05.29.03.30.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 03:30:50 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Fix null-pointer dereferences in error handling
 code of rtl_pci_probe()
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190514123439.10524-1-baijiaju1990@gmail.com>
 <20190528115555.301E760F3C@smtp.codeaurora.org>
 <2658b691-b992-b773-c6cf-85801adc479f@lwfinger.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <357682ba-d1ae-23b1-2372-b1a33d2ba1ac@gmail.com>
Date:   Wed, 29 May 2019 18:30:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <2658b691-b992-b773-c6cf-85801adc479f@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/28 21:00, Larry Finger wrote:
> On 5/28/19 6:55 AM, Kalle Valo wrote:
>> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>>
>>> *BUG 1:
>>> In rtl_pci_probe(), when rtlpriv->cfg->ops->init_sw_vars() fails,
>>> rtl_deinit_core() in the error handling code is executed.
>>> rtl_deinit_core() calls rtl_free_entries_from_scan_list(), which uses
>>> rtlpriv->scan_list.list in list_for_each_entry_safe(), but it has been
>>> initialized. Thus a null-pointer dereference occurs.
>>> The reason is that rtlpriv->scan_list.list is initialized by
>>> INIT_LIST_HEAD() in rtl_init_core(), which has not been called.
>>>
>>> To fix this bug, rtl_deinit_core() should not be called when
>>> rtlpriv->cfg->ops->init_sw_vars() fails.
>>>
>>> *BUG 2:
>>> In rtl_pci_probe(), rtl_init_core() can fail when rtl_regd_init() in
>>> this function fails, and rtlpriv->scan_list.list has not been
>>> initialized by INIT_LIST_HEAD(). Then, rtl_deinit_core() in the error
>>> handling code of rtl_pci_probe() is executed. Finally, a null-pointer
>>> dereference occurs due to the same reason of the above bug.
>>>
>>> To fix this bug, the initialization of lists in rtl_init_core() are
>>> performed before the call to rtl_regd_init().
>>>
>>> These bugs are found by a runtime fuzzing tool named FIZZER written by
>>> us.
>>>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>
>> Ping & Larry, is this ok to take?
>>
>
> Kalle,
>
> Not at the moment. In reviewing the code, I was unable to see how this 
> situation could develop, and his backtrace did not mention any rtlwifi 
> code. For that reason, I asked him to add printk stat4ements to show 
> the last part of rtl_pci that executed correctly. In 
> https://marc.info/?l=linux-wireless&m=155788322631134&w=2, he promised 
> to do that, but I have not seen the result.
>

Hi Larry,

This patch is not related to the message you mentioned.
That message is about an occasional crash that I reported.
That crash occurred when request_irq() in rtl_pci_intr_mode_legacy() in 
rtl_pci_intr_mode_decide() fails.
I have added printk statements and try to reproduce and debug that 
crash, but that crash does not always occur, and I still do not know the 
root cause of that crash.

The null-pointer dereferences fixed by this patch are different from 
that crash, and they always occur when the related functions fail.
So please review these null-pointer dereferences, thanks :)


Best wishes,
Jia-Ju Bai

