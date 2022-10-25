Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5C60C4A1
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiJYHCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJYHC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:02:28 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B81AB1BA3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:02:27 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id fy4so10187397ejc.5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTZ9XSXY51LXE4jSLx8/7Y425Go53KxTtpmQE436jms=;
        b=Vrn50l/7KcIqk45mCOD0jXO0febPcbWtWGjEe0hfU9wx/ioohNIusCONFG1//hwvtb
         EhyTDGnaChULuE+Q6+b0DNlqwwvx31dxnYOabBzMd4gQwDxJZXs8WqEKV7BGjVaJB9yU
         L+cRUFr+J2JzZiigkzHUgfekEjodEdDdMtk48mYzc4ehTa8l0Xh7kSyTsOJnjWea42hE
         yHYs37mFLnU9X+U5WhV2hQvY2KAT+DbjP2pIOqQIZcaWTkYWCKMkrqyEFKJdlV5VN0he
         LkyEiQEadIWtKwXEW/ppUtc5svDYsTgipmeLyOrr7qjWZq1191o60l/3NFvKMhwFRkdy
         vYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTZ9XSXY51LXE4jSLx8/7Y425Go53KxTtpmQE436jms=;
        b=gKY2DTPYbeWlrKoJMXek5SGYdaRbdMBI0hrNghm7H1bjJA8jaYDDEWW3goGLJyOWcG
         riyj6WSDZRtS49+JIxV7F5NXtxHuxd4lqCicLE2+USFkwqck0HALzFc6AUC02Oc5v3eL
         QRSdUlkfsCjDGXM0ZcpG8ZIRh06v8N8feYc/fDKwgpgjnvFLKD5eNPIu4lk/ZA2fIgOk
         sSk7hrHHwW3bKHuwVtbeNgi/i9/vUtA/ttgcdzf5vDHD6ThJzPkLLhsL2LS9VWV5OwkS
         uxFvS3F1M2RCPzv/auMJikIQgOibCrab5Oe0gQ2ga8F2g3gGgFOVYTtD5ARdqK+s8daT
         Z+XA==
X-Gm-Message-State: ACrzQf1HX7iazxFgZHCvGb5vXOUBuqHlZRCMV1GR6YpqcqVFJ0SlGn0o
        ZXEQO1tD0J+Rub9n+oSuEHggwQ==
X-Google-Smtp-Source: AMsMyM4tNlC0ScUTYnXvwt3Ls+S3XvBHssRegDia1ErDnteViPsVrAmp6mDxo/TVUt7rRc1QFOBK2w==
X-Received: by 2002:a17:907:3f94:b0:78d:9d2f:3002 with SMTP id hr20-20020a1709073f9400b0078d9d2f3002mr30783518ejc.40.1666681346111;
        Tue, 25 Oct 2022 00:02:26 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:8219:f4b9:b78d:7de7? ([2a05:6e02:1041:c10:8219:f4b9:b78d:7de7])
        by smtp.googlemail.com with ESMTPSA id ca28-20020aa7cd7c000000b004618e343149sm1052055edb.19.2022.10.25.00.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 00:02:25 -0700 (PDT)
Message-ID: <cb44e8f7-92f6-0756-a622-1128d830291c@linaro.org>
Date:   Tue, 25 Oct 2022 09:02:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, vadimp@nvidia.com
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
 <20221014073253.3719911-2-daniel.lezcano@linaro.org>
 <Y05Hmmz1jKzk3dfk@shredder>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <Y05Hmmz1jKzk3dfk@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Ido,

On 18/10/2022 08:28, Ido Schimmel wrote:
> + Vadim
> 
> On Fri, Oct 14, 2022 at 09:32:51AM +0200, Daniel Lezcano wrote:
>> The thermal framework gives the possibility to register the trip
>> points with the thermal zone. When that is done, no get_trip_* ops are
>> needed and they can be removed.
>>
>> Convert ops content logic into generic trip points and register them with the
>> thermal zone.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> Vadim, can you please review and test?
> 
> Daniel, I saw that you wrote to Kalle that you want to take it via the
> thermal tree. Any reason not to take it via net-next? I'm asking because
> it will be the second release in a row where we need to try to avoid
> conflicts in this file.

Because I hope I can remove the ops->get_trip_ ops from thermal_ops 
structure before the end of this cycle.

May be you can consider moving the thermal driver into drivers/thermal?


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
