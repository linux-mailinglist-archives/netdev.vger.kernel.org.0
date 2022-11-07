Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A83161F00C
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 11:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiKGKNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 05:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKGKN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 05:13:27 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66905646C
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 02:13:26 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u11so15443716ljk.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 02:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gREae39cyXf+2rcYcopnnaWLsAAmSHnBlWh1ZAL3kRE=;
        b=BCY4Gt3M8IRghSgyT7vaIixUGfTWV0b+ii8jG0z0hhI+50We+B2SUYkmiuzDKgEaSC
         xakp9TyO/9FnNNt8nEdQbjHeo1hOU+dmz7euFNvkz3YqK7K0VSD2LwOKFgUl2AGiqzSy
         CB6RL9VA9C4n1lb711DNHR9MfIv29njP+h3wS2Xs6DmlT4oPLb+6QxipOGiq4nY5YBCy
         liKQKeM6TLgEcpI7tPmuJ/fi9JvmHzAagji2jbNNgQRQNTv1iPGJaZZCFzMqIImj2qZI
         5NWotcg8Gxbok9aORW4EUEvAZKL06E3Vc+X4fKq0MPKjAPpyuoLpKVFUPsuZZwoQvk9P
         ka/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gREae39cyXf+2rcYcopnnaWLsAAmSHnBlWh1ZAL3kRE=;
        b=QqQAlQUR/k8pOpYMi1Imcd0zM1uK3agQlk6GreJBeIlb3BVGAIaC7/rFtmPx5AMVIa
         el+7+UqBTNCT50eKaGz1cTXuy3XYb7ELbZGCVIPeBz1TKqgLuiV6zVOaui9aYjMfhgx2
         gnHI+NdRrhWyKcp7W+WgIQKf4RfujFfbGaB2tmkQ4HYPwfZAe9COAAJO2U9Qqm/JNvUS
         vBuqHyMVNPLX5iZu/eCDSrOTp43LJARY4dCvCdOToD8OPFaSsuXRtQqMiokNISb/IsSf
         CBdR1+9NkhZiyOo9Z1akC5seUPRvPnoUQdfklxEejUgL8V/PzR3xbokAdfTI1QOQMVtM
         jUEA==
X-Gm-Message-State: ANoB5pm6atFqv19xkpj0iQ8Eu5eNnq6TauIMtGGWaHrYcsAz1cCBrzh+
        4pMiGyrjcpJNO7yqtQKERdIXxQ==
X-Google-Smtp-Source: AA0mqf6Xz7jfBmrnhSTHtY98QgJvV11pa1RfLvIEVjzzjPzSfRPbsFyaLzh8Qc3zJ05c1Wvx39PcOg==
X-Received: by 2002:a2e:a276:0:b0:277:3cfd:1b93 with SMTP id k22-20020a2ea276000000b002773cfd1b93mr1515080ljm.448.1667816004805;
        Mon, 07 Nov 2022 02:13:24 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id m4-20020a056512114400b004979db5aa5bsm1166050lfg.223.2022.11.07.02.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 02:13:21 -0800 (PST)
Message-ID: <50eabe88-48e8-20a5-99c2-de0fcd3bd3d6@linaro.org>
Date:   Mon, 7 Nov 2022 11:13:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4a 19/38] timers: nfc: pn533: Use timer_shutdown_sync()
 before freeing timer
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chengfeng Ye <cyeaa@connect.ust.hk>, Lin Ma <linma@zju.edu.cn>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org
References: <20221105060024.598488967@goodmis.org>
 <20221105060158.322031906@goodmis.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221105060158.322031906@goodmis.org>
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

On 05/11/2022 07:00, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Before a timer is freed, timer_shutdown_sync() must be called.
> 
> Link: https://lore.kernel.org/all/20221104054053.431922658@goodmis.org/
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

