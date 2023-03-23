Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21836C5C31
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCWBhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 21:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCWBhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 21:37:02 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350CF18B38;
        Wed, 22 Mar 2023 18:37:02 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id bj20so5664500oib.3;
        Wed, 22 Mar 2023 18:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679535421;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=GAeMpc1+nBu4zhLlk549VumAogD8igLZqFxBr9F9Rhk=;
        b=UWzeiCbSMJw/9/1HYmr+QHHALIfhH8mJ2TSbeA/SSPeM3Dey9/FQC21geYdX8eekb5
         pK6T5dR2wSavr7JmlkECKeIzirv59xGhA1Xhxq+VxrD6FW0dS7Dk2bhapgBO0dwqLwpL
         QlRrWWuWXQzDvrzxB5xJMEkJ4hhLIRy2dm6hmvJc1Ob0e4TJAhuAqfNKx7z6dPK8qhy/
         UbTQP0bl415HIW2AOf7i1pHqvnAt3F1SYBVCym08XmdyV7KsiN/kHmS24nhu/8lrRGUj
         yUxRVHEHekW3Qz418febKwIV+sAzSNPIEINujzZIYBzcG07xxpE8rvYJlrPwOgYb0pK/
         besA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679535421;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GAeMpc1+nBu4zhLlk549VumAogD8igLZqFxBr9F9Rhk=;
        b=JpEE4gE2fXxVQMCzX/RNfEe4mNXRvfbzuWpqpVBDllJpUpszWqJhiiVok0CBueGynZ
         Y4miJZ6xTGDTsji3eF3Eicvks+aUphrOpm1PJ1CwuLi//yOe+WPYmftUnd/kgTbd85I7
         1sSe1cQ/8HlSxP1RlXyjni8lX/2HD9sYGOSh4YBNje+sZ+g3r4/Zur7/Pp6TypuJ7Agf
         B59qCKvHBCkDUwfQSQ4/E+qEkPEDZ5X2tE6zhZdkmXH+qMqZBoPuHr47cWC+kYklA8BR
         dvL7K8+AZm0lD+MZDs5Ce/K8RNO8Pr7h2+pRDki/YWVuu5PZjDEMyJtxiOqpSjOGoBge
         wfWg==
X-Gm-Message-State: AO0yUKVsjPkMncliYGmSWwZmCPSF3uiK6gsZ3IoMuQPmt6cNKdbit19i
        rqRWZRFLErDzVktRRx0OpIGfGOKcPgo=
X-Google-Smtp-Source: AK7set9kr7Xo7B3gVewt6gj9VajuyTIciYgxkUxCuXZue7n4VxfE0wm0fjbs8mCYu0V6/wiM5nfWGA==
X-Received: by 2002:a05:6808:16ac:b0:386:9bf4:4ec6 with SMTP id bb44-20020a05680816ac00b003869bf44ec6mr2869570oib.5.1679535421499;
        Wed, 22 Mar 2023 18:37:01 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id r2-20020a056808210200b00387160bcd46sm2841654oiw.46.2023.03.22.18.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 18:37:01 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <284f6f33-1789-341b-e123-f6b2b706b68b@lwfinger.net>
Date:   Wed, 22 Mar 2023 20:36:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <ZBskz06HJdLzhFl5@hyeyoo>
 <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
 <CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com>
 <e4f8e55f843041978098f57ecb7e558b@realtek.com>
Content-Language: en-US
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

Hyeonggon,

I have tested the above patch and added it to my GitHub repo that I mentioned 
earlier. Using the repo, you will be able to get the new code without patching 
and regenerating an entire new kernel.

Larry

