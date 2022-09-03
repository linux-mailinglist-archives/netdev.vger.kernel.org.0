Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5775ABFAF
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiICQKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 12:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiICQKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 12:10:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDBE52E7B
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 09:10:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c59so6306528edf.10
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 09:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date;
        bh=CsfQQCBFm+OZdqC4A1e77KQXd7CNjhlhrXIxhjh0JNU=;
        b=X/VFa0HRTImW58bsMauDnmQeDrts4EO7I04lC8cL5RG7hsOSdHcMtCI9PvX8SwEtwS
         Sdcla8LzYwHrtFNTzJ5VCc5eTnRMwOojboe1e4PzB5xvMHMyenn8TD/nnk9L/FhKUO68
         InRu7G6amAPpSbW4ueDLxuH7YpmIZuTQi3oXK5V22bk3GZ4UZH3iKnPlTGGMtX2Ncvwv
         SJP0WQKsL/kN6oH2C1j9FiZ5vduJeSaxcgxGc6owoHj55J/IMkHdetQOTGH9bGjrk8Z+
         d2H8X1Ek/lKrLuhZfXL7W/KsZ9b0NfCnrqSbT8wQDszH4Qk68ghTq4MkmVVWvAHYlbK3
         3Zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CsfQQCBFm+OZdqC4A1e77KQXd7CNjhlhrXIxhjh0JNU=;
        b=tcDJ2Dh1GScsyNTRewM9cGAp/ixo6a+fjKE5vc+4O+UUJcDLYnGLYRSrrNsfgEd825
         lwcsrG1HG5xF9DZwnw30elEmRRsBr75BbFWMab/Bn/kkRgEwCMXMfKo64AFKWRUkFdoc
         cOc9gyftu3usaH9uXdftxs2SGqffFDc7lwW2V0G1rAb8gtIsiw8edRMMiV7rEN++YHY7
         WQq98AbdVbR4Q1Gd1Fi4xRaCA2zk49QJY3U4URDARiSuMgK55hneaMcYeRdTW9OixudT
         pHe3n7SbLnNjsbdKmI+IZupeBdoRK989vwp5f+SDy/2xUgQHe3Yo04wQovG+2LKma1mQ
         eiMw==
X-Gm-Message-State: ACgBeo2YPmq9dePHZzZSrQp3fNV+Kl1zJXeM1zYJqzTNY5Kg9aWlp21r
        hQ/3cl1I+XqmypKWpu/SqvO0QYc7n5k=
X-Google-Smtp-Source: AA6agR5PuEKNEoIxPzmlO1scePJGUAP4bV2qSBGBKWkMZJzSPlGAINsrMlFmXvMeikkAAiH3Z0PwKQ==
X-Received: by 2002:a05:6402:440f:b0:435:2e63:aca9 with SMTP id y15-20020a056402440f00b004352e63aca9mr36586518eda.162.1662221439265;
        Sat, 03 Sep 2022 09:10:39 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bdec:da00:5920:51b2:99c1:4c89? (dynamic-2a01-0c23-bdec-da00-5920-51b2-99c1-4c89.c23.pool.telefonica.de. [2a01:c23:bdec:da00:5920:51b2:99c1:4c89])
        by smtp.googlemail.com with ESMTPSA id lb14-20020a170907784e00b00741a0c3f4cdsm2624710ejc.189.2022.09.03.09.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 09:10:38 -0700 (PDT)
Message-ID: <86fd2d55-4fc3-f242-a427-7a7164f44f46@gmail.com>
Date:   Sat, 3 Sep 2022 18:10:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
 <YxNw/6qh5gwWZH7N@electric-eye.fr.zoreil.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] r8169: remove not needed net_ratelimit() check
In-Reply-To: <YxNw/6qh5gwWZH7N@electric-eye.fr.zoreil.com>
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

On 03.09.2022 17:21, Francois Romieu wrote:
> Heiner Kallweit <hkallweit1@gmail.com> :
>> We're not in a hot path and don't want to miss this message,
>> therefore remove the net_ratelimit() check.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> There had historically been some user push against excess "spam"
> messages, even when systems are able to stand a gazillion of phy
> generated messages - resources constrained systems may not - due
> to dysfunctionning hardware or externally triggered events.
> 
> Things may have changed though.
> 
I don't have a strong opinion here and would follow the net
maintainers decision. I looked at a few other drivers and none of
them protects link up/down messages. If also other network-related
components print a message on link-up, then we might miss the
PHY message due to the network-global nature of net_ratelimit().
In general newer drivers don't seem to use net_ratelimit()
extensively, even though that's not really an argument against
using it.

