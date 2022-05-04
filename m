Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AD9519765
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344946AbiEDGf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbiEDGfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:35:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F16E114F
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:32:18 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so961592ejo.12
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 23:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XiGtsn5suJGp364Ut5ARLksbX95MjHeSBk/Ld3aNPvM=;
        b=tgffE7DIQMbb0Lm82+pVSeeJDjnRZQiPHkxCmhzxOR+i93hkbALu7B+mBcaM7FNY9+
         5jZYsxbrbSy1LY11HB98ZCkTjxjiHIKIvrTgeZWBs85xODTMNuIMbxradK8zOU7wX6+u
         MKxdFM/vQ1A4iqRYdDNKB4rKPP16P1mB4SuaCEF2+JipWRTgVRQ6QmATVgIEI2z7X8Xh
         uwIGbI5/3srkJ3g8t3b3OdDDKHBJBpDQhwTMqgRlffs0Vj6WXuV4L0rTC69t38YlnMZN
         e17xn4B/858ebq5OX4XduQbGMSr095tRzNxKbOMkEt/6eFqxDl88dG8xnnyoSgHgP+eF
         vFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XiGtsn5suJGp364Ut5ARLksbX95MjHeSBk/Ld3aNPvM=;
        b=6bVnpphugCiUGR6s3CO650tb+jxQkCWgqv5DFW94bPuTmXEM0FMqTBCJsmVpl3KzfL
         1JSwQdG/EIP89Sc7bpKDJ57poDwxpeFpZJNi0h/g6EVUB//UpaYn+OLBWpoocOWmJr8s
         dQYgaLfIhzL4WV6WznURYOfdD5ze2hKuAu44Zt+QdiEfvNJ4idNmpO4MkcVrxcJY6aUq
         gNoHOU7BT0/W1LCioeh8GicENahCR6UkkWEgCMgUWhkm+fKfzHCJPJ9P0dN5mzQQc+BP
         ECEVbWMHsxnKJwaI7eMBSuHUILmkCF1Vr8h7gGI0vjhD/PP+qDWgPsEzbnxWNGZUb0aK
         oG+Q==
X-Gm-Message-State: AOAM530sAIX8hhEG24hWZXTfTSt8lyuPD7KS/5+y6oQMcsiYoapFpK1r
        gBR710T0Z+PuydPHnM08sXzdmA==
X-Google-Smtp-Source: ABdhPJwP8WWwFvistMPkC2qQxLH44OtID/e9i7s30DIwMGwHZdjsM2Yw6IgfCNrJANUuHATr5IWMVg==
X-Received: by 2002:a17:907:3e94:b0:6f4:64ad:1e2 with SMTP id hs20-20020a1709073e9400b006f464ad01e2mr10149463ejc.464.1651645936611;
        Tue, 03 May 2022 23:32:16 -0700 (PDT)
Received: from [192.168.0.207] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id h20-20020a1709070b1400b006f3ef214db8sm5270851ejl.30.2022.05.03.23.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 23:32:16 -0700 (PDT)
Message-ID: <6aeef03a-eabb-e6d8-c100-9a74f3506f79@linaro.org>
Date:   Wed, 4 May 2022 08:32:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v5 2/2] nfc: nfcmrvl: main: reorder destructive
 operations in nfcmrvl_nci_unregister_dev to avoid bugs
Content-Language: en-US
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        gregkh@linuxfoundation.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org, linma@zju.edu.cn
References: <cover.1651194245.git.duoming@zju.edu.cn>
 <bb2769acc79f42d25d61ed8988c8d240c8585f33.1651194245.git.duoming@zju.edu.cn>
 <8656d527-94ab-228f-66f1-06e5d533e16a@linaro.org>
 <73fe1723.69fe.1807498ab4d.Coremail.duoming@zju.edu.cn>
 <405e3948-7fb2-01de-4c01-29775a21218c@linaro.org>
 <614ae365.b499.18083a8bb17.Coremail.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <614ae365.b499.18083a8bb17.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2022 09:25, duoming@zju.edu.cn wrote:
> 
> 
> 
>> -----原始邮件-----
>> 发件人: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
>> 发送时间: 2022-05-02 14:34:07 (星期一)
>> 收件人: duoming@zju.edu.cn
>> 抄送: linux-kernel@vger.kernel.org, kuba@kernel.org, gregkh@linuxfoundation.org, davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, alexander.deucher@amd.com, akpm@linux-foundation.org, broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn
>> 主题: Re: [PATCH net v5 2/2] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
>>
>> On 29/04/2022 11:13, duoming@zju.edu.cn wrote:
>>> Hello,
>>>
>>> On Fri, 29 Apr 2022 09:27:48 +0200 Krzysztof wrote:
>>>
>>>>> There are destructive operations such as nfcmrvl_fw_dnld_abort and
>>>>> gpio_free in nfcmrvl_nci_unregister_dev. The resources such as firmware,
>>>>> gpio and so on could be destructed while the upper layer functions such as
>>>>> nfcmrvl_fw_dnld_start and nfcmrvl_nci_recv_frame is executing, which leads
>>>>> to double-free, use-after-free and null-ptr-deref bugs.
>>>>>
>>>>> There are three situations that could lead to double-free bugs.
>>>>>
>>>>> The first situation is shown below:
>>>>>
>>>>>    (Thread 1)                 |      (Thread 2)
>>>>> nfcmrvl_fw_dnld_start         |
>>>>>  ...                          |  nfcmrvl_nci_unregister_dev
>>>>>  release_firmware()           |   nfcmrvl_fw_dnld_abort
>>>>>   kfree(fw) //(1)             |    fw_dnld_over
>>>>>                               |     release_firmware
>>>>>   ...                         |      kfree(fw) //(2)
>>>>>                               |     ...
>>>>>
>>>>> The second situation is shown below:
>>>>>
>>>>>    (Thread 1)                 |      (Thread 2)
>>>>> nfcmrvl_fw_dnld_start         |
>>>>>  ...                          |
>>>>>  mod_timer                    |
>>>>>  (wait a time)                |
>>>>>  fw_dnld_timeout              |  nfcmrvl_nci_unregister_dev
>>>>>    fw_dnld_over               |   nfcmrvl_fw_dnld_abort
>>>>>     release_firmware          |    fw_dnld_over
>>>>>      kfree(fw) //(1)          |     release_firmware
>>>>>      ...                      |      kfree(fw) //(2)
>>>>
>>>> How exactly the case here is being prevented?
>>>>
>>>> If nfcmrvl_nci_unregister_dev() happens slightly earlier, before
>>>> fw_dnld_timeout() on the left side (T1), the T1 will still hit it, won't it?
>>>
>>> I think it could be prevented. We use nci_unregister_device() to synchronize, if the
>>> firmware download routine is running, the cleanup routine will wait it to finish. 
>>> The flag "fw_download_in_progress" will be set to false, if the the firmware download
>>> routine is finished. 
>>
>> fw_download_in_progress is not synchronized in
>> nfcmrvl_nci_unregister_dev(), so even if fw_dnld_timeout() set it to
>> true, the nfcmrvl_nci_unregister_dev() happening concurrently will not
>> see updated fw_download_in_progress.
> 
> The fw_download_in_progress is set to false in nfc_fw_download(). The nfc_fw_download() is
> synchronized with nfc_unregister_device().

No, it is not. There is no synchronization primitive in
nfc_unregister_device(), at least explicitly.

> If nfc_fw_download() is running, nfc_unregister_device()
> will wait nfc_fw_download() to finish. So the nfcmrvl_nci_unregister_dev() could see the updated
> fw_download_in_progress. The process is shown below:
> 
>         (Thread 1)                                         |       (Thread 2)
>  nfcmrvl_nci_unregister_dev                                | nfc_fw_download
>    nci_unregister_device                                   |  ...
>                                                            |  device_lock()
>      ...                                                   |  dev->fw_download_in_progress = false; //(1)
>                                                            |  device_unlock()
>      nfc_unregister_device                                 | 
>    if (priv->ndev->nfc_dev->fw_download_in_progress) //(2) | 
>      nfcmrvl_fw_dnld_abort(priv); //not execute            |   
> 
> We set fw_download_in_progress to false in position (1) and the check in position (2) will fail,
> the nfcmrvl_fw_dnld_abort() in nfcmrvl_nci_unregister_dev() will not execute. So the double-free
> bugs could be prevented.

You just repeated the same not answering the question. The
fw_download_in_progress at point (2) can be still true, on that CPU. I
explain it third time so let me rephrase it - the
fw_download_in_progress can be reordered by compiler or CPU to:

T1                                          | T2
nfcmrvl_nci_unregister_dev()
  nci_unregister_device()
    var = fw_download_in_progress; (true)
                                            | nfc_fw_download
                                            | device_lock
                                            | dev->fw_download = false;
                                            | device_unlock
    if (var)                                |
      nfcmrvl_fw_dnld_abort(priv);          |

Every write barrier must be paired with read barrier. Every lock on one
access to variable, must be paired with same lock on other access to
variable .

> 
>>> Although the timer handler fw_dnld_timeout() could be running, nfcmrvl_nci_unregister_dev()
>>> will check the flag "fw_download_in_progress" which is already set to false and nfcmrvl_fw_dnld_abort()
>>> in nfcmrvl_nci_unregister_dev() will not execute.
>>
>> I am sorry, but you cannot move code around hoping it will by itself
>> solve synchronization issues.
> 
> I think this solution sove synchronization issues. If you still have any questions welcome to ask me.

No, you still do not get the pint. You cannot move code around because
this itself does not solve missing synchronization primitives and
related issues.


Best regards,
Krzysztof
