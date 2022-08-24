Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457875A02E0
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 22:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbiHXUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 16:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiHXUgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 16:36:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5892E77565
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:36:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so1563856wme.1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=PHwTuCnEL7EtB2rU0ZKm2AoGKO0cbH9wf0XuAB8In50=;
        b=jS0OlYQI0Zplep4Ed4lMnqtdkDh40PLTcf6EeIDIlwiNXwTOKErL+p8HbdM2fk5Ckn
         l5eZIkjVtiWgcadwvtz/U6auUIRNobBA97as2BuE8E0gG3ojYAXRpd3o3lx5cqJssTfs
         spVaPDijVyq6UD2hvgGdM3DE7RKbZjoWn04mzcKt/V5qVyFgBdJxwn4XRlKCa98OHIDO
         FMdRHHVnlNdO/fUO/r84C++gHF1WwO4J4tTiaOUbAzSsqRkU6nq6RRK450r6vNgEGR3J
         3smItmJjxekSn/7b+Nf1JAGA5h5jxbLZqk36Wo4QEX3OL2EPFHtBANMtpMVXUuPyheuw
         VR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PHwTuCnEL7EtB2rU0ZKm2AoGKO0cbH9wf0XuAB8In50=;
        b=YfSH80IL3eTU3PXhNodEU9HyWfKBqmf+LpGMa/ZZMlMhn3igqgOaMyVJA9WNEk6NnI
         cZ2bCVhcj50Ac1LeKRMIDvYPDal+YTmavQ6iAcKxeFp1D322nuEc3oeyfx/j2Pg68KMd
         KpHujlv0VE93VSBvlQ/VzWAJQtIL/v2mZq58+SJu6ei246RgYTnnppCIWOKlDpbNYf+w
         ThPeaPIuEULUmCDB+6aD5FUaW5QITby1JkG0TmgXKFzAPfAIcy6ap4GtwxWV7r2mBV9y
         qOjcMqMfgRRSH+WY2/1eERsWCvAV/1inP73iHf5dkl9s1DJUC9rfP/lRZNBQrlHi+HA0
         J/Fg==
X-Gm-Message-State: ACgBeo0kVB6/DIOwccoIST5AMRxVgYW6gUMmSzcs8fc/3hDp34TCIWxx
        OLlNhfkgIVT3Ea57BMfrFQY=
X-Google-Smtp-Source: AA6agR7iDVcDClHA4R60UnKf6VHm8MI5AZ7TR4qlLMkKRcInxtkl24wT3rFQ9Rjrr/7DSPqxBkZPew==
X-Received: by 2002:a05:600c:3b92:b0:3a6:8d6:9a2f with SMTP id n18-20020a05600c3b9200b003a608d69a2fmr6342451wms.159.1661373393818;
        Wed, 24 Aug 2022 13:36:33 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7aa2:100:8857:e17a:56:c2b2? (dynamic-2a01-0c22-7aa2-0100-8857-e17a-0056-c2b2.c22.pool.telefonica.de. [2a01:c22:7aa2:100:8857:e17a:56:c2b2])
        by smtp.googlemail.com with ESMTPSA id bh19-20020a05600c3d1300b003a54d610e5fsm3168381wmb.26.2022.08.24.13.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 13:36:33 -0700 (PDT)
Message-ID: <776ece87-e24c-bb19-e472-8a04d1cbbaa3@gmail.com>
Date:   Wed, 24 Aug 2022 22:36:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net] net: stmmac: work around sporadic tx issue on link-up
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Qi Duan <qi.duan@amlogic.com>, Da Xue <da@lessconfused.com>,
        Jerome Brunet <jbrunet@baylibre.com>
References: <72755b6b-f071-1c54-c2fd-5ea0376effe1@gmail.com>
 <20220823162259.36401af0@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20220823162259.36401af0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2022 01:22, Jakub Kicinski wrote:
> On Sat, 20 Aug 2022 17:20:37 +0200 Heiner Kallweit wrote:
>> This is a follow-up to the discussion in [0]. It seems to me that
>> at least the IP version used on Amlogic SoC's sometimes has a problem
>> if register MAC_CTRL_REG is written whilst the chip is still processing
>> a previous write. But that's just a guess.
>> Adding a delay between two writes to this register helps, but we can
>> also simply omit the offending second write. This patch uses the second
>> approach and is based on a suggestion from Qi Duan.
>> Benefit of this approach is that we can save few register writes, also
>> on not affected chip versions.
>>
>> This patch doesn't apply cleanly before the commit marked as fixed.
>> There's nothing wrong with this commit.
> 
> I don't think this is right, please do your best to identify where
> the bug was actually introduced and put that in the Fixes tag.
> 
> IIRC this is not the first time you've made this choice so let's
> sort this out, we can bring it up with Greg if you would like,
> I don't see it clarified in the docs.
> 
> My understanding and experience doing backports for my employer is 
> that cutting off the Fixes tag at the place patch application fails 
> is very counter productive. Better to go too far back and let 
> the person maintaining the tree decide if the backport is needed.
> 
OK, I changed the Fixes tag accordingly and submitted a v2.
