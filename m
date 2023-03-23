Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA016C5C3A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCWBl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 21:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCWBl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 21:41:28 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61EA1A679;
        Wed, 22 Mar 2023 18:41:20 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-17997ccf711so21340265fac.0;
        Wed, 22 Mar 2023 18:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679535680;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=NNXeoomdIQOt004AlJOnSgnLw25N2D8cGdIOmQLx+ko=;
        b=UMO7gqTkVjQsEPwyKZoD+GVPjGfCmggfqo9p0eEtn+jV6PFCB4Gei5n6FlWBEH71WV
         AOF26erhHHy30TKa0Bi8JCIzcNnCxXKBGo1asTvx92ytgQWCfkv7carzU+LFFRnRx9c8
         Pv4RctFSZBXEdxsslLVpt9PF8N7nZu4d0VfMPmhe2IXB/Ly8/u0SldbWWerFiia3TkAM
         oZ2aXr3IYXcE72CWbj3Q1JnDWIJyrk/oD3Yqjf5y5e7qX87js/tLdZHPhxGhGZjQJVNh
         QJFVO9oDPjW79PIIeq21AsTB85rP6Nf6/zx8RiGy5MG1WGYcfwmRJW29spSLsFpQUXK0
         NRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679535680;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NNXeoomdIQOt004AlJOnSgnLw25N2D8cGdIOmQLx+ko=;
        b=HNfPydOI218lJ05YQmOxEuCe+FmLGznHzdtY8Q9VL+OPbo56FeVB943piPbL0pZiA8
         42VblYwmDKfTZovsCvuUFFyW/7amMI/oQ8iJw8Wy8XSV3uoL5aM9+rsNnWYmTatBwRZP
         f4rKk8dJwnsXV9fOYv6bjByLuHVgqqbUgh3haRKAQukh5R+eN/4hxx6IvgXS0geAgNrf
         WVvUpbEW32+N1p15SxPzm0j0dPcGwBPJB88B1NWu2ktzks9uWXUC8rw0ve5Vt3t4MHwO
         ubxZsrwZAOfBcABFTTzU18wHm814RZGiizXWEh5vTW+E8AvE8e4V9yRSDX5lcXBNzKj2
         b+0w==
X-Gm-Message-State: AO0yUKWhC18Eqs634GjGVn7RdrEVLxr9+9omn19uJJtuZeC5gEIoBjPw
        R47sQDvWTRSI4FfA0zl0PQk=
X-Google-Smtp-Source: AKy350aXYKgDVuSBCeLmJTefA2R0A1ZA6GuRB8d7xALaCZjbZx1Lk39HTHBV8zqlMWEbFgXYEF8MKQ==
X-Received: by 2002:a05:6870:b622:b0:16d:f82a:3608 with SMTP id cm34-20020a056870b62200b0016df82a3608mr1079951oab.55.1679535680075;
        Wed, 22 Mar 2023 18:41:20 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id bd35-20020a056871b32300b00177be9585desm5834293oac.1.2023.03.22.18.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 18:41:19 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <4c841575-1e02-32f2-b63d-52bc0c063c82@lwfinger.net>
Date:   Wed, 22 Mar 2023 20:41:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <ZBskz06HJdLzhFl5@hyeyoo>
 <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
 <CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com>
 <e4f8e55f843041978098f57ecb7e558b@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <e4f8e55f843041978098f57ecb7e558b@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 19:59, Ping-Ke Shih wrote:
> 
> 
>> -----Original Message-----
>> From: Jonas Gorski <jonas.gorski@gmail.com>
>> Sent: Thursday, March 23, 2023 4:52 AM
>> To: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>; netdev@vger.kernel.org; linux-wireless@vger.kernel.org; Ping-Ke
>> Shih <pkshih@realtek.com>
>> Subject: Re: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
>>
>> On Wed, 22 Mar 2023 at 18:03, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>
>>> On 3/22/23 10:54, Hyeonggon Yoo wrote:
>>>>
>>>> Hello folks,
>>>> I've just encountered weird bug when booting Linux v6.2.7
>>>>
>>>> config: attached
>>>> dmesg: attached
>>>>
>>>> I'm not sure exactly how to trigger this issue yet because it's not
>>>> stably reproducible. (just have encountered randomly when logging in)
>>>>
>>>> At quick look it seems to be related to rtw89 wireless driver or network subsystem.
>>>
>>> Your bug is weird indeed, and it does come from rtw89_8852be. My distro has not
>>> yet released kernel 6.2.7, but I have not seen this problem with mainline
>>> kernels throughout the 6.2 or 6.3 development series.
>>
>> Looking at the rtw89 driver's probe function, the bug is probably a
>> simple race condition:
>>
>> int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> {
>>      ...
>>      ret = rtw89_core_register(rtwdev); <- calls ieee80211_register_hw();
>>      ...
>>      rtw89_core_napi_init(rtwdev);
>>      ...
>> }
>>
>> so it registers the wifi device first, making it visible to userspace,
>> and then initializes napi.
>>
>> So there is a window where a fast userspace may already try to
>> interact with the device before the driver got around to initializing
>> the napi parts, and then it explodes. At least that is my theory for
>> the issue.
>>
>> Switching the order of these two functions should avoid it in theory,
>> as long as rtw89_core_napi_init() doesn't depend on anything
>> rtw89_core_register() does.
>>
>> FWIW, registering the irq handler only after registering the device
>> also seems suspect, and should probably also happen before that.
> 
> Adding a 10 seconds sleep between rtw89_core_register() and
> rtw89_core_napi_init(), and I can reproduce this issue:
> 
> int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> {
>      ...
>      ret = rtw89_core_register(rtwdev);
>      ...
> 	msleep(10 * 100);
> 	...
>      rtw89_core_napi_init(rtwdev);
>      ...
> }
> 
> And, as your suggestion, I move the rtw89_core_register() to the last step
> of PCI probe. Then, it looks more reasonable that we prepare NAPI and
> interrupt handlers before registering netdev. Could you give it a try with
> below fix?
> 
> diff --git a/pci.c b/pci.c
> index fe6c0efc..087de2e0 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -3879,25 +3879,26 @@ int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>          rtw89_pci_link_cfg(rtwdev);
>          rtw89_pci_l1ss_cfg(rtwdev);
> 
> -       ret = rtw89_core_register(rtwdev);
> -       if (ret) {
> -               rtw89_err(rtwdev, "failed to register core\n");
> -               goto err_clear_resource;
> -       }
> -
>          rtw89_core_napi_init(rtwdev);
> 
>          ret = rtw89_pci_request_irq(rtwdev, pdev);
>          if (ret) {
>                  rtw89_err(rtwdev, "failed to request pci irq\n");
> -               goto err_unregister;
> +               goto err_deinit_napi;
> +       }
> +
> +       ret = rtw89_core_register(rtwdev);
> +       if (ret) {
> +               rtw89_err(rtwdev, "failed to register core\n");
> +               goto err_free_irq;
>          }
> 
>          return 0;
> 
> -err_unregister:
> +err_free_irq:
> +       rtw89_pci_free_irq(rtwdev, pdev);
> +err_deinit_napi:
>          rtw89_core_napi_deinit(rtwdev);
> -       rtw89_core_unregister(rtwdev);
>   err_clear_resource:
>          rtw89_pci_clear_resource(rtwdev, pdev);
>   err_declaim_pci:

Ping-Ke,

The patch works fine here, but I did not have the problem.

When you submit it, add a Tested-by: Larry Finger<Larry.Finger@lwfinger.net> and 
a Reviewed-by for the same address.

@Jonas: Good catch.

Larry


