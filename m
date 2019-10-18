Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CD1DC634
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410373AbfJRNfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:35:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43786 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfJRNfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:35:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so3910559pfo.10;
        Fri, 18 Oct 2019 06:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c+eVa0dX1kop+2tsq8KrMiGw2+4GgT6C7+BH1dW27GI=;
        b=aHYcGgCaJslTpUkam+cYawYj1EaRI6rZvzNRxBcoYsQsVAUeK30TqNO+a87PL2sdmc
         k2XY2kJOCh+NkZd51OE+x0vW1s818gsI/FX7cjt7ZvnB6/TcTa4BNHL8SEW7+hpfc9zU
         VHHR+s/zt5ZBbUTrobNAW1K+9T8y0+BGJMT9SkRnGPPZGIaWU8HKwrIuvcAepvtJy/8n
         gFF0X7vmGycIcihrIwt1ah57qxhOwhrGit/OOwQ446fA7z6gF96pIyhnDZph58x1s7Um
         utsmLi918pqdLq0aBxbimq8aDtAm/RKC8ojpHq6A/InesFi7iQzy7ln0UOrsGWryk95O
         Qszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+eVa0dX1kop+2tsq8KrMiGw2+4GgT6C7+BH1dW27GI=;
        b=NTsBnCi0p4ReugwmtrVqR9fahMbgOMfzxyKV5ij+AnSuBXSrU+1fHPtKonn18huqkj
         RGn21nfHVzqrRROmikL9FaVnqZZuhvYjr5KqXLcgxrRENSiaGJ3FG+o1gE745fUyKqkW
         xOz6pnnPv+7cTkDvTtpf0udiqufgC5Kqx8c1NMP8nOQICZGxaBCrl3fQTO0doG9KHvZC
         m56yRTiV4iMA2YD2pfPUs5WUbKLuQiA1Kxbs6ZaS7JR4AUy/MJ3r//hzTvP8rAPPkDnF
         LBFonYJFwVu9ZCX1VT7lqkIxIyi/W1f30p4F7yZLPOZDkxMvqALR0Fyu3rWnDkXRzzE7
         eN6Q==
X-Gm-Message-State: APjAAAVih9jDIujNS3EV+jjMfW2m6/mDSAIuesld49rpfrbkD2PfnN1T
        Un+Q+vvg+g/Xz4okP5SIRf+bmJsO
X-Google-Smtp-Source: APXvYqwxSMNs5esLdkoYCG6yzU0JGtKPvY5fdNDQDDB062FoWx32+QY1xWLP+X4HM9LEsUJPEbDq3g==
X-Received: by 2002:a63:4d09:: with SMTP id a9mr9953861pgb.229.1571405748967;
        Fri, 18 Oct 2019 06:35:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r185sm6728195pfr.68.2019.10.18.06.35.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 06:35:48 -0700 (PDT)
Subject: Re: [PATCH 2/2] Fix a NULL-ptr-deref bug in
 ath10k_usb_alloc_urb_from_pipe
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Hui Peng <benquike@gmail.com>, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190804003101.11541-1-benquike@gmail.com>
 <20190831213139.GA32507@roeck-us.net>
 <87ftlgqw42.fsf@kamboji.qca.qualcomm.com>
 <20191018040530.GA28167@roeck-us.net>
 <875zkmxz6f.fsf@kamboji.qca.qualcomm.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5e0e1760-07ee-efa1-1c33-3276dc81cc67@roeck-us.net>
Date:   Fri, 18 Oct 2019 06:35:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <875zkmxz6f.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/19 12:58 AM, Kalle Valo wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
> 
>> On Sun, Sep 01, 2019 at 11:06:05AM +0300, Kalle Valo wrote:
>>> Guenter Roeck <linux@roeck-us.net> writes:
>>>
>>>> Hi,
>>>>
>>>> On Sat, Aug 03, 2019 at 08:31:01PM -0400, Hui Peng wrote:
>>>>> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
>>>>> are initialized to point to the containing `ath10k_usb` object
>>>>> according to endpoint descriptors read from the device side, as shown
>>>>> below in `ath10k_usb_setup_pipe_resources`:
>>>>>
>>>>> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>>>>>          endpoint = &iface_desc->endpoint[i].desc;
>>>>>
>>>>>          // get the address from endpoint descriptor
>>>>>          pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
>>>>>                                                  endpoint->bEndpointAddress,
>>>>>                                                  &urbcount);
>>>>>          ......
>>>>>          // select the pipe object
>>>>>          pipe = &ar_usb->pipes[pipe_num];
>>>>>
>>>>>          // initialize the ar_usb field
>>>>>          pipe->ar_usb = ar_usb;
>>>>> }
>>>>>
>>>>> The driver assumes that the addresses reported in endpoint
>>>>> descriptors from device side  to be complete. If a device is
>>>>> malicious and does not report complete addresses, it may trigger
>>>>> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
>>>>> `ath10k_usb_free_urb_to_pipe`.
>>>>>
>>>>> This patch fixes the bug by preventing potential NULL-ptr-deref.
>>>>>
>>>>> Signed-off-by: Hui Peng <benquike@gmail.com>
>>>>> Reported-by: Hui Peng <benquike@gmail.com>
>>>>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>>>>
>>>> This patch fixes CVE-2019-15099, which has CVSS scores of 7.5 (CVSS 3.0)
>>>> and 7.8 (CVSS 2.0). Yet, I don't find it in the upstream kernel or in Linux
>>>> next.
>>>>
>>>> Is the patch going to be applied to the upstream kernel anytime soon ?
>>>
>>> Same answer as in patch 1:
>>>
>>> https://patchwork.kernel.org/patch/11074655/
>>>
>>
>> Sorry to bring this up again. The ath6k patch made it into the upstream
>> kernel, but the ath10k patch didn't. Did it get lost, or was there a
>> reason not to apply this patch ?
> 
> This patch had a build warning, you can see it from patchwork:
> 
> https://patchwork.kernel.org/patch/11074657/
> 
> Can someone fix it and resend the patch, please?
> 

Done.

Guenter
