Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2235F54A2
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJEMhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEMhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:37:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50065725E
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 05:37:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r13so4268008wrj.11
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KTX8CzjgT3X/t2r5vWkkyRPC+B6Zpur5yx6z33EALmI=;
        b=dzsfAxgdAGlUvKVUY6p3V8qGo313WeGugAOXWZSt+1fBP2srisSYreLvsC4Jt8R7vI
         6CCNZ2KSUzFipf2TUazEUfYo06vjjv91Xy+qnqqccv6JnCX5hNP31NA70WmGp0Yy32QP
         mExqi6cWI3IjFT/cgE6UfcZSCVhbtLcSJWWwIhNYbOhV6a1O9pc8mtgsF6so8OABSDbC
         Zz/V8dDJJNEFO8LSd3y5bD7HlZgjLbp0vYE7xf1uhZtqnOrcZuofQtpcfMuSMNNg7ivk
         kfkIb4D7afc9KH4Wn9yfjJvGbhkNxbmLo2OKigcWEZvHo4LzCO3D1KBst2Iy2FRzztXS
         ++rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTX8CzjgT3X/t2r5vWkkyRPC+B6Zpur5yx6z33EALmI=;
        b=fUuPiDMX9ULehxlsqC9kvMpcAJKbCbgDmsQ5kFbdiH9wb8U4TisYluaH9fQP/TCKNv
         42llx24ubhcyr9PaX0YciW2z9Mnmr7fpLwBfDSlxhv2wCD1i+6/8eh065SWSKAs1uotM
         wqct72xNuKdAsrWCXoFFB6Wbdxu44zDq4/Keo52fTbB9g507rP1mjYv5H7qSMW8mTnS8
         0SOQrVkniQKM77rNgEvHrQ6TWfE1I2WERn+LfvR/GdfuVdEUVefNq9XpMLlnTqjQ2E1W
         5LD+1E341ulNcwq1QtjEfXDliz+bYRUJM0CQsHexsxEFaIx1rc8+YmDuDPXKs4VYgwZX
         M8Zg==
X-Gm-Message-State: ACrzQf1OuUFcSuhVdbqENDhMDmEEkRAtaLKJNYagL945CubbNNZr4fWp
        I7NnvcSL/ETThwWItQyGLjfvFg==
X-Google-Smtp-Source: AMsMyM6Jlg5EJX8UPumAZ9rKA8q/8S24FJ3Uw0SxmI6WuaZGcUfDRQsK4mhRcGoSkeMPVSiGBC98sw==
X-Received: by 2002:a5d:5983:0:b0:22c:b9a0:e874 with SMTP id n3-20020a5d5983000000b0022cb9a0e874mr19860166wri.306.1664973437294;
        Wed, 05 Oct 2022 05:37:17 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:ffcf:b5a4:bbee:42a5? ([2a05:6e02:1041:c10:ffcf:b5a4:bbee:42a5])
        by smtp.googlemail.com with ESMTPSA id f18-20020a05600c4e9200b003b492b30822sm2031325wmq.2.2022.10.05.05.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 05:37:16 -0700 (PDT)
Message-ID: <851008bf-145d-224c-87a8-cb6ec1e9addb@linaro.org>
Date:   Wed, 5 Oct 2022 14:37:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
Content-Language: en-US
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, rafael@kernel.org
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
 <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
 <c3258cb2-9a56-d048-5738-1132331a157d@linaro.org>
In-Reply-To: <c3258cb2-9a56-d048-5738-1132331a157d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marek,

On 03/10/2022 23:18, Daniel Lezcano wrote:

[ ... ]

>> I've tested this v8 patchset after fixing the issue with Exynos TMU with
>> https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/ 
>>
>> patch and I got the following lockdep warning on all Exynos-based boards:
>>
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
>> ------------------------------------------------------
>> swapper/0/1 is trying to acquire lock:
>> c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8
>>
>> but task is already holding lock:
>> c2979b94 (&tz->lock){+.+.}-{3:3}, at:
>> thermal_zone_device_update.part.0+0x3c/0x528
>>
>> which lock already depends on the new lock.
> 
> I'm wondering if the problem is not already there and related to 
> data->lock ...
> 
> Doesn't the thermal zone lock already prevent racy access to the data 
> structure?
> 
> Another question: if the sensor clock is disabled after reading it, how 
> does the hardware update the temperature and detect the programed 
> threshold is crossed?

just a gentle ping, as the fix will depend on your answer ;)

Thanks

   -- D.

[ ... ]


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
