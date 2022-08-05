Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC2158B13F
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 23:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbiHEVsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 17:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240856AbiHEVsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 17:48:08 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE69776965
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 14:48:06 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso1796461wmq.3
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 14:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=KNQEUmGLVAbpCL4HkkFhEE/6SImMj5y9sN/w12ODgTw=;
        b=jYZWLSIT9H0LRa+afvoDdTI6v9xPc8cnlCQpGbLUhRaPcF1SM6WHC5BHjkaqv5NjCk
         Yh7dkVnLhm8wxOJZWbaXB2EN96SjQsb/Z26zhRSsn8/rgQaAQPb3WXwHWs/T3prkd5vC
         s/FeK9eBEan701j/vVLXLyNe0zgYSb7o3KE2xHLUKQgCEDuJqrzBblY6zgL+U5ekyIwz
         obagY/3919u+7YKVdaz2pzWIrIM6iUQWxG6xfH9sqEG7Xcbzj/UtOVyljvP7jKnID1f/
         K1fiA3NsKcrw/oUuU5tUsTAe7rafALMqcSiU5axawpMG9QnzqthOYEeYYRfhHinf3FdB
         0Z+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KNQEUmGLVAbpCL4HkkFhEE/6SImMj5y9sN/w12ODgTw=;
        b=P2VkQbURP/LTsX+e8ywdlp+/L2MWa/AEFIfWuMRC8umSf5I9vOOWJs6n+hDI8IP4k9
         QaIgTzyfDjOmnuso62CfTqlqr1kWmAFd6wTxId71sIwaBxGJTX393xhb+xaH2gaP5xAM
         cdzq8LRZlqujsSx11caoPwc02uxvahA9ucPxuhxJ9xWeakLuaDEwp5rXmc3jYNh4s68l
         LHOt35YwK4iM/C1+ARpSwdBthmkaKl0p40oZproiyEhirZYtHaLInG5LBGjiZXOc4oT9
         T11bF0SVCsil7HmtOo7wsYnwzwBbyyKQMgz/Q/pxqLT502Gjpd6LFAbZEKWMPDWen8Tu
         h9SQ==
X-Gm-Message-State: ACgBeo3SvrC7AIjbVF0zEsCipmGQUUUP7S1NXvUJ+dQHMcs1V1MeD9za
        w3XXtFbAhXAB9XogBqF6IkiGUg==
X-Google-Smtp-Source: AA6agR4D+809mtr5avMU9X5e/xHyX7TA26uXLp93UmNMlvgekiPNqGS+KILtxbAeNq8dHuAg5E8uDQ==
X-Received: by 2002:a05:600c:4e03:b0:3a5:1755:8498 with SMTP id b3-20020a05600c4e0300b003a517558498mr4028757wmq.137.1659736085153;
        Fri, 05 Aug 2022 14:48:05 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:aef0:8606:da6b:79ef? ([2a05:6e02:1041:c10:aef0:8606:da6b:79ef])
        by smtp.googlemail.com with ESMTPSA id b13-20020adff90d000000b0021e5adb92desm4701234wrr.60.2022.08.05.14.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 14:48:04 -0700 (PDT)
Message-ID: <82d5701e-9d22-cc4d-0d19-324147b64192@linaro.org>
Date:   Fri, 5 Aug 2022 23:48:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 24/26] thermal/drivers/cxgb4: Use generic
 thermal_zone_get_trip() function
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     rafael@kernel.org, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>
References: <20220805145729.2491611-1-daniel.lezcano@linaro.org>
 <20220805145729.2491611-25-daniel.lezcano@linaro.org>
 <20220805131157.08f6a50f@kernel.org>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20220805131157.08f6a50f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/08/2022 22:11, Jakub Kicinski wrote:
> On Fri,  5 Aug 2022 16:57:27 +0200 Daniel Lezcano wrote:
>> Subject: [PATCH v1 24/26] thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
> 
> s@thermal/drivers/@net/ethernet/@

Ok, thanks

> Are you targeting 6.0 with these or should we pick it up for 6.1 via
> netdev? I didn't see any notes on merging in the cover letter.

Right, if it can go through the thermal tree, all the changes will be in 
the same place, that will help


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
