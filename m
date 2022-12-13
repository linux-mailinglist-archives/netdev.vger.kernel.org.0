Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C064B93F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiLMQFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiLMQFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:05:32 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D65920F49
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:05:31 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f16so3743507ljc.8
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Md5BnzDKCo+Ixqvyz8wEbbhxUPDSLaf7mvzv+YJu9GA=;
        b=yDR+1E0+9HVxTIEyGoGvb4UWDiWtOA8vsmZvRo2ahUjWNASrgP6i64Qjb5BATHr/8K
         aiwiXTG71AsWPcuHhvYbJpGhBKymSZCQP9PwsmYaF7MtWS3CAo93UyJ5D2IGJp5NnAkX
         c/fSyzMx9JbpvFBWCGjvqEwBlAeVP/Mbn0HF5dqSmcYYcgqlvHLNFehHu7VGuGR1IW4O
         beTLh/H18ZvsSRI6+R9YtEeYZszKgC7zQJTqm4x5m/iQ5w0qf9flDFWt+nn0HfDC4+Oc
         P+Y8O49ph3On+PXiJGaG7/LOmqDOhsxyKxkiZGr9LKGAESsOQVSGiFt7GBUtLLMRnWgM
         4Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Md5BnzDKCo+Ixqvyz8wEbbhxUPDSLaf7mvzv+YJu9GA=;
        b=sAlgYeEfFFojYb/GCF3pz6Vo10LenM96CgMG7+BIkjyzQSLR5O6W8Wc86JSfLwJXI1
         x7bM65jCIfyqZoXaOwOcma7IH5bgebxwStNMSI0WDw6FqPuVKrjXxiqY61NMxFlXEzrx
         e6aBdcb5goXgtmF6oed556s9g+YCT45/2S/4l2YzGGRPjDK+FTFRPc51Zu3fRw97+e4S
         rrIrBkHw4QNQMOzd5Vrj1PaYzmWlgfbEiaZXGFpUOjjrEYKp2zR+4X1nOORdrabeS8Cj
         8deNDiYtHcSIPs6ktHP0oNFH2Jm90//fsQYSGM+xS7uWNJt46bLw+IVVlDTEdpNnsnSG
         2KKg==
X-Gm-Message-State: ANoB5pmORAZi8Lre5ePV9vGC7c3MT9kv2yzU5vIpGkreMgpXMXvRWrgH
        XQi9LUhW8AOS7wo2O41NVUT4jA==
X-Google-Smtp-Source: AA0mqf6NpVWNi0HjErEZFi68jhRTsarHgIWM+qXSYk/XA52AnA3Vv8xex9wzwvw36/SutKGkoR6a2w==
X-Received: by 2002:a2e:be1f:0:b0:26f:db35:7e42 with SMTP id z31-20020a2ebe1f000000b0026fdb357e42mr6705134ljq.17.1670947529514;
        Tue, 13 Dec 2022 08:05:29 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id h5-20020a2eb0e5000000b0027973ba8718sm310623ljl.37.2022.12.13.08.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 08:05:28 -0800 (PST)
Message-ID: <0fb173e7-8810-6e3f-eff2-446cbfcc2eab@linaro.org>
Date:   Tue, 13 Dec 2022 17:05:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v2] nfc: pn533: Clear nfc_target before being used
Content-Language: en-US
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr
References: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
 <decda09c-34ed-ce22-13c4-2f12085e99bd@linaro.org>
 <cd3a1383-9d6a-19ad-fd6e-c45da7e646b4@linaro.org>
 <20221213160358.GA109198@medve-MS-7D32>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221213160358.GA109198@medve-MS-7D32>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2022 17:03, Minsuk Kang wrote:
> On Tue, Dec 13, 2022 at 03:41:36PM +0100, Krzysztof Kozlowski wrote:
>> On 13/12/2022 15:38, Krzysztof Kozlowski wrote:
>>> On 13/12/2022 15:27, Minsuk Kang wrote:
>>>> Fix a slab-out-of-bounds read that occurs in nla_put() called from
>>>> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
>>>> from an nfc_target in pn533, is too large as the nfc_target is not
>>>> properly initialized and retains garbage values. Clear nfc_targets with
>>>> memset() before they are used.
>>>>
>>>> Found by a modified version of syzkaller.
>>>>
>>>> BUG: KASAN: slab-out-of-bounds in nla_put
>>>> Call Trace:
>>>>  memcpy
>>>>  nla_put
>>>>  nfc_genl_dump_targets
>>>>  genl_lock_dumpit
>>>>  netlink_dump
>>>>  __netlink_dump_start
>>>>  genl_family_rcv_msg_dumpit
>>>>  genl_rcv_msg
>>>>  netlink_rcv_skb
>>>>  genl_rcv
>>>>  netlink_unicast
>>>>  netlink_sendmsg
>>>>  sock_sendmsg
>>>>  ____sys_sendmsg
>>>>  ___sys_sendmsg
>>>>  __sys_sendmsg
>>>>  do_syscall_64
>>>>
>>>> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
>>>> Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
>>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>>
>>> How did it happen? From where did you get it?
>>
>> I double checked - I did not send it. This is some fake tag. Please do
>> not add fake/invented/created tags with people's names.
> 
> Sorry for my confusion.
> 
> https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L505
> 
> I missed the definition of the tag as I did not read the document
> carefully and misunderstood that the tag simply means I have got a
> reply from maintainers and I should manually attach it if that is
> the case. I will rewrite the patch after I make sure I fully
> understand the whole rules.

The document says:
"By offering my Reviewed-by: tag, I state that:"

You need to receive it explicitly from the reviewer. Once received, but
only then, add to the patch.

Best regards,
Krzysztof

