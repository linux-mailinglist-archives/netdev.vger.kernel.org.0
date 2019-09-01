Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A85A4B75
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 21:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfIATqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 15:46:02 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37919 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfIATqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 15:46:02 -0400
Received: by mail-io1-f67.google.com with SMTP id p12so25172649iog.5;
        Sun, 01 Sep 2019 12:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=exATxEDmVr8tY6PaCJvDBgnaUkdR9wAvkh7ugWPQO1Q=;
        b=n7yyqs0ZR2xE5OTPJqC89jRK0yhI+I0BvGnhxY0Ky14lTnNmu4jhvTgsRNd+H7qPGY
         BUUxu56UaShPGyBxZCApNsbsVT8DzGDIzLMNOMlrbMDtXka40+8w5RztQ2T/bDqppqfu
         cIe/chZKnRBDLJD4khJtGaa5tLQUf0bRg31sKka3LPH3H3vxZ8dmu8D/LA1y/x4ezTPH
         M1Qz+ReQYjER9Ap4bJGNiDaB1qAI7aD6j9DYLgMHGFdA75NDBsTHZD2Hog4T2Jspm9hh
         7H9M3wOinAE2XM4v8Zl4tq4P4SVOpRjfVqRosJCGQ1jDsKFs3vq/edvGvxTdTcotmkr+
         N6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=exATxEDmVr8tY6PaCJvDBgnaUkdR9wAvkh7ugWPQO1Q=;
        b=CYO+3r5doRtxXrJCpNr393MrzgOLoRlIfZMmTaYAjlb7EzPkTGuodZlD2qF+JaoDFi
         eHN1aGIBo/P81CFG5mAyWDcycZBLrdrjVVbbArjFJ82dpK7bfhmDRa602oBjusRuCdpj
         D1pma1zXk+y35MtYS3MtOl5xg/TuTSLP+FFGVGOonP5UfwRCHy99S7hMtMYCQROrU0AO
         d6IMqeUDwdUqbO5W98SWA5CD0Azw4/kzfpfINfqCgxxdbX0gX24dYynGX9q4tLkTu9h/
         UUybx2sw8hnCELHlSS7ZE0sEXB0qXUmvoh2eBob+HwrHc4vs6rq9yuphUCIunxYtrPE3
         4z1w==
X-Gm-Message-State: APjAAAW8R40IamB+eGWjk1d1Eiu6P8i6KYiyXnNA3RlTLkupPkTva8Fh
        qFyXZHzfhDVnWK2hz6/msqwhrLjJLNWIEw==
X-Google-Smtp-Source: APXvYqx/IFGQPxOLc9+Miz1/cdCffAShZlB11L3b4JxW75EkyltoizXA0mq064XzbIjbHfL1fIpqXg==
X-Received: by 2002:a02:a909:: with SMTP id n9mr12910812jam.57.1567367160836;
        Sun, 01 Sep 2019 12:46:00 -0700 (PDT)
Received: from [10.164.9.36] (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.gmail.com with ESMTPSA id d9sm9018277ioo.15.2019.09.01.12.45.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 12:46:00 -0700 (PDT)
From:   Hui Peng <benquike@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a NULL-ptr-deref bug in
 ath10k_usb_alloc_urb_from_pipe
References: <20190804003101.11541-1-benquike@gmail.com>
 <20190831213139.GA32507@roeck-us.net>
Message-ID: <8bc83a3f-2c14-1abe-9add-eb9cfca6917f@gmail.com>
Date:   Sun, 1 Sep 2019 15:45:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190831213139.GA32507@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/19 5:31 PM, Guenter Roeck wrote:
> Hi,
>
> On Sat, Aug 03, 2019 at 08:31:01PM -0400, Hui Peng wrote:
>> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
>> are initialized to point to the containing `ath10k_usb` object
>> according to endpoint descriptors read from the device side, as shown
>> below in `ath10k_usb_setup_pipe_resources`:
>>
>> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>>         endpoint = &iface_desc->endpoint[i].desc;
>>
>>         // get the address from endpoint descriptor
>>         pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
>>                                                 endpoint->bEndpointAddress,
>>                                                 &urbcount);
>>         ......
>>         // select the pipe object
>>         pipe = &ar_usb->pipes[pipe_num];
>>
>>         // initialize the ar_usb field
>>         pipe->ar_usb = ar_usb;
>> }
>>
>> The driver assumes that the addresses reported in endpoint
>> descriptors from device side  to be complete. If a device is
>> malicious and does not report complete addresses, it may trigger
>> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
>> `ath10k_usb_free_urb_to_pipe`.
>>
>> This patch fixes the bug by preventing potential NULL-ptr-deref.
>>
>> Signed-off-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> This patch fixes CVE-2019-15099, which has CVSS scores of 7.5 (CVSS 3.0)
> and 7.8 (CVSS 2.0). Yet, I don't find it in the upstream kernel or in Linux
> next.
>
> Is the patch going to be applied to the upstream kernel anytime soon ? If
> not, is there reason to believe that its severity may not be as high as the
> CVSS score indicates ?
The score was assigned by MITRE.
Same as previous ones, it is under review, once passed, it will be applied.
> Thanks,
> Guenter
>
>> ---
>>  drivers/net/wireless/ath/ath10k/usb.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
>> index e1420f67f776..14d86627b47f 100644
>> --- a/drivers/net/wireless/ath/ath10k/usb.c
>> +++ b/drivers/net/wireless/ath/ath10k/usb.c
>> @@ -38,6 +38,10 @@ ath10k_usb_alloc_urb_from_pipe(struct ath10k_usb_pipe *pipe)
>>  	struct ath10k_urb_context *urb_context = NULL;
>>  	unsigned long flags;
>>  
>> +	/* bail if this pipe is not initialized */
>> +	if (!pipe->ar_usb)
>> +		return NULL;
>> +
>>  	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
>>  	if (!list_empty(&pipe->urb_list_head)) {
>>  		urb_context = list_first_entry(&pipe->urb_list_head,
>> @@ -55,6 +59,10 @@ static void ath10k_usb_free_urb_to_pipe(struct ath10k_usb_pipe *pipe,
>>  {
>>  	unsigned long flags;
>>  
>> +	/* bail if this pipe is not initialized */
>> +	if (!pipe->ar_usb)
>> +		return NULL;
>> +
>>  	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
>>  
>>  	pipe->urb_cnt++;
>> -- 
>> 2.22.0
>>
