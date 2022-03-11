Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6B4D57FB
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 03:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345610AbiCKCRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 21:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbiCKCRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 21:17:42 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE561181E47;
        Thu, 10 Mar 2022 18:16:40 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t5so6711483pfg.4;
        Thu, 10 Mar 2022 18:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Hu+ByQ7g8o0/IQmD4UvW283mwUOYWBZvyLmeZYp2qmE=;
        b=NpN2YMJXCk1Imm6w6/LparviICti3f9hwFdzU/dKaKwiCDBTpsH2UYdwAxAOCUG8rF
         zrkXFq3feeI4yPrlz/3+KQmTwFLe+eHyZV9nAD7lRcKWCqVgfs2AeJWzjbWaSqPOejs8
         Z71iq0Y2Xm2KiGMCfqJVGFxAHYJptBOdxF60vxfpcxhr5Vj5fB4rTW3BeVlm7/K8JIu+
         7tl/ddAZjmC1YPi13FacQhbWXJ7aDUPouT7IVkhlso7npFt/GXiFDgfwgsqnFMbd/hzp
         afu+TqWf6bWJjoHyZnToL0rXCa+ZdX1IFNTRBZ/L9cYrJOpWazwbQFj2vXoDyNu6xkoV
         jojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hu+ByQ7g8o0/IQmD4UvW283mwUOYWBZvyLmeZYp2qmE=;
        b=uolbkMy/jxKomf7D1gxPowyzSE0NWfeDajoKtgfrtWEG+BiiAeqQibtUqprFf8cj7i
         Ad+L+Rt989q376NH1y6WgFhx1TuWo+yveegkHMsiOl5HcJLhhQcJiAUAJxdxvpt82aEj
         vK8TImgiX1H0z3MW06mrwEjOcYGnqXpFHr9YoRL6f0RtqV/x8tW081dnPFoASigP6e/w
         TmwOQJXWHMNopKgz2I9pWmCsjIMbThsZI5ks2r4k0laPwHMWIW39/4i8kZqe7pWE3nUV
         64XZHf8w+wvseo0hipkVyOvrMmBpa1DgqIqSIR9H41PgqyLHCdba0yh7HLOxr0ZZjjYN
         i2tQ==
X-Gm-Message-State: AOAM530TCHzoPae9uBiyUzm5wmbT3NsRJ/iI4yhY3xzx9TLSnqhBj+NJ
        TKWop5ENsijQRFz8KxPX0LgOm2VcjHY=
X-Google-Smtp-Source: ABdhPJxll3Jmf2v5eSDnF+2ZhH6v20KKXN6QGJMDGxUpnuRsCBBMqd75eDIoLBnhEOwJVwEkzJYJ8Q==
X-Received: by 2002:a05:6a00:1a0b:b0:4cf:9a9:5c5f with SMTP id g11-20020a056a001a0b00b004cf09a95c5fmr8067317pfv.45.1646965000012;
        Thu, 10 Mar 2022 18:16:40 -0800 (PST)
Received: from [192.168.1.100] ([166.111.139.99])
        by smtp.gmail.com with ESMTPSA id j14-20020a056a00174e00b004f66ce6367bsm9269762pfc.147.2022.03.10.18.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 18:16:39 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: check the return value of devm_kzalloc() in
 brcmf_of_probe()
To:     Kalle Valo <kvalo@kernel.org>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        davem@davemloft.net, kuba@kernel.org, shawn.guo@linaro.org,
        gustavoars@kernel.org, len.baker@gmx.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220225132138.27722-1-baijiaju1990@gmail.com>
 <164692859274.6056.13961655347011053680.kvalo@kernel.org>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <adb61d50-8a17-de4b-2757-5c4da1b00ff7@gmail.com>
Date:   Fri, 11 Mar 2022 10:16:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <164692859274.6056.13961655347011053680.kvalo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/11 0:09, Kalle Valo wrote:
> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
>> The function devm_kzalloc() in brcmf_of_probe() can fail, so its return
>> value should be checked.
>>
>> Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> You are not calling of_node_put() in the error path. And I don't think
> this even applies.
>
> Patch set to Changes Requested.
>

Hi Kalle,

Thanks for the reply :)
I will add of_node_put() and send a V2 patch.


Best wishes,
Jia-Ju Bai
