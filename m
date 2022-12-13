Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969AC64B796
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbiLMOk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiLMOk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:40:26 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC641DA6A
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:40:25 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id y25so5207798lfa.9
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5t8uFnV9ZqPSvA2UaqPNOrL+Ayaa9y3Ab0d9AqlsRJA=;
        b=UkL2nZ14HwltG6Oh1K+R7MxhcvkMx1sK5XvBteUU5j/k+68BEWiht1rLNvTMJoBpwn
         EswV0DvzgbpCgtzfD/lx+th2Qa7rAIPkIOWwZH/dvdnKtkhp44QYruzLWZj0DYGx81GU
         7x1NEway8XxLCjifzg2KwjED/qqPsfJtAg7W1nm6KiPV5Lhu5UXCwkfNgBQa+C5geb/Z
         qo7W3L2+Uv0ohgPnM+fGTvy5VK0R/7tVYUOiIZJsTMC4KpT2WVITpsaIIdilXVrC9XbN
         k6p8h2k2cX2twxXhFpzGjSEzYZHtr+NPHqZqqMgVzqc8fTlHqkOLItCoTGRd7WeYwcyc
         NOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5t8uFnV9ZqPSvA2UaqPNOrL+Ayaa9y3Ab0d9AqlsRJA=;
        b=iyvGEFrroRKYfCuHi6Uuwp74/AOLPfFuIlta30wF/z0TydM6MPKP9WDYsSi5mhhkm9
         E0tqV0c7Or8MZ5b9S4UXpATu7pMgWQz76mLoMTEpV6yluSS8GTfPXVm5/RWR15o7gWVP
         j7fZmtxaMsK27YPaIYr6qSjQufti1n7/HKb10mtZfczfSXlf1lb3axVI4M1bDtDMIU+I
         nidcBtmrkfrFwiA6qi86B13Akb64S7ucMQQDbbrQ3iLxecmeo7FnLtq5wIR/nrNNOTE+
         BJF421fMVWQbmhWQo++dqc6uMuHo/Cvmwpg1EGX1l8joA9H0HrZwu7ci2chnIn0U/XEN
         t15A==
X-Gm-Message-State: ANoB5pm/Cy32BxTDG29K/CcD3V6u5qNwIZ7QgGVCoS9fTGQCt3iKlUwK
        aDcwRRz+uy+cscph3QhkGb5JPQ==
X-Google-Smtp-Source: AA0mqf7ptOc3OaIB5f2/AYqlH26io1IJ4bezkYd+JtFApPbCDY8ZJq6NcisHAhzAchQEjusSPQtSAA==
X-Received: by 2002:a05:6512:3b8b:b0:4b4:8f01:f8b1 with SMTP id g11-20020a0565123b8b00b004b48f01f8b1mr7182848lfv.31.1670942423958;
        Tue, 13 Dec 2022 06:40:23 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id 25-20020ac24839000000b004b5979f9ba8sm388550lft.210.2022.12.13.06.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 06:40:23 -0800 (PST)
Message-ID: <6149eb8e-74dc-46bd-029f-309c4224a005@linaro.org>
Date:   Tue, 13 Dec 2022 15:40:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net] nfc: pn533: Clear nfc_target in
 pn533_poll_dep_complete() before being used
Content-Language: en-US
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr
References: <20221213014120.969-1-linuxlovemin@yonsei.ac.kr>
 <15aba5c2-1f22-cb8a-742e-8bb8b1e8f0a0@linaro.org>
 <20221213142053.GA107908@medve-MS-7D32>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221213142053.GA107908@medve-MS-7D32>
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

On 13/12/2022 15:20, Minsuk Kang wrote:

> 
>>> ==================================================================
>>>
>>> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
>>> Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
>>> Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
>>> Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
>>
>> Reported-by is for crediting other people, not crediting yourself.
>> Otherwise all my patches would be reported-by, right? Please drop this
>> one and keep only credit for other people who actually reported it. It's
>> anyway weird to see three people reporting one bug.
>>
>> Additionally I really dislike private reports because they sometimes
>> cannot be trusted (see all the fake report credits from running
>> coccinelle by Hulk Robot and others)... Care to provide link to the
>> reports of this bug?
>>
> 
> My intention was to credit all the people contributed to the
> modification of syzkaller that led to this bug. But I will drop them in
> v2.

Then shouldn't you also credit all authors of original syzkaller as
well? And people who wrote core libraries being used there? Let's don't
go that way...

Best regards,
Krzysztof

