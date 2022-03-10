Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8570A4D552D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242972AbiCJXQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiCJXQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:16:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85D819ABDB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:14:58 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bi12so15522564ejb.3
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wH4UoppwTQ4UdNrMcUN9KetHM0Xaq1JFbqvZ/4c39pE=;
        b=SNhkaHJXjQoqs0ip3K5+XvdeJZ6128TILSVmodirU7iOHi/3LADyejQdcvjZjeEiRs
         mhz97BnSZ5KJGRTEeXdzKgKdskvb3mYy4gTu8tSrs4Xvl/Sa74/MvhNScjZekFcGU+Xn
         YG6RnZ7rdMBKjlPNZbMe3PDXlX9clfe1teo1fkcvJ329ar+ab19h9hIC0eDCiNVxvdQa
         4dMmulPNe8J/V2R0Ggy7oYT7K31inkMKefU7fGng8ZxkAxMbACoYROKYnC+KvaajK12Y
         frvgeCeJ1Emgndq08xiHJcRsQDvcsVft5jyq2oecV1a4DvRAPZ3a5mV5HQ5auCijlqtc
         TS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wH4UoppwTQ4UdNrMcUN9KetHM0Xaq1JFbqvZ/4c39pE=;
        b=avKFz3fZPdkhs6p16Rv53EvqenU/yIXCOCe8w2vqGx0exdasBxhlNDS4EfjtpSJajU
         xgymyYAchqKNYzI940UUFo6jJ++ZNNk65WqNVccKDNpv28ICedyVrAfaDNlAWNHgpdIB
         1uw6lC8mYlA7XfPw5HPxZRL6t3GohBAM5oMTz16bmIomqY3grhos/hsh4eaz8aoN1DeI
         8gXBOjk8D7Q0Bij1FdECkMLZwXORZuXYUH1r1kAyopDMSlY9Tpw64b7pjXSf1cLifqfu
         J53L3GRBcB4X62ySEqWL9CX0NTA3Cu3+P+6S3Sp2ED342p0nHJF1uXnBtivmTbWghC+y
         Nbhw==
X-Gm-Message-State: AOAM5322QQixgSxMGUteY90xDECgtsLxRLFKHdeT2wzbpxMCZrayFLLT
        5tlYhxhZyBoKQzZfoXB1ZN0=
X-Google-Smtp-Source: ABdhPJxXehoOTrd2fO6m9lfXPprPLDHUKV4hOs/G2UkCT2SR/d9GjNabGNEi9nRNF6XLOwdwDPHjpA==
X-Received: by 2002:a17:906:4313:b0:6b8:b3e5:a46 with SMTP id j19-20020a170906431300b006b8b3e50a46mr6269719ejm.417.1646954097223;
        Thu, 10 Mar 2022 15:14:57 -0800 (PST)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id r6-20020a1709064d0600b006da7ca3e514sm2220798eju.208.2022.03.10.15.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 15:14:56 -0800 (PST)
Message-ID: <14cf7c22-622b-d5e2-0eb1-076d92db56a2@gmail.com>
Date:   Fri, 11 Mar 2022 00:14:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] alx: acquire mutex for alx_reinit in alx_change_mtu
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20220310161313.43595-1-dossche.niels@gmail.com>
 <20220310150500.38ae567c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <20220310150500.38ae567c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2022 00:05, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 17:13:16 +0100 Niels Dossche wrote:
>> alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
>> alx_reinit is called from two places: alx_reset and alx_change_mtu.
>> alx_reset does acquire alx->mtx before calling alx_reinit.
>> alx_change_mtu does not acquire this mutex, nor do its callers or any
>> path towards alx_change_mtu.
>> Acquire the mutex in alx_change_mtu.
>>
>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> 
> What's the Fixes tag?

Commit 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
introduced fine-grained locking and introduced the assertion.
I can resend the patch with the Fixes tag if you want me to.
