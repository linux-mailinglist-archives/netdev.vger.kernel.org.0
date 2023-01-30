Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A858681B2B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjA3UQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjA3UQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:16:17 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490DF3757F;
        Mon, 30 Jan 2023 12:16:16 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hx15so15771556ejc.11;
        Mon, 30 Jan 2023 12:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uPkPZ9hXb0YMQ9faHMJ8j8JGYXj5rWLnlmb1qb1codI=;
        b=WIJw0SxW2vsP9TRRknDb2FY31vDOZgEWggYys5sjxOFiZibWs2TKug6ZNVKVM0ijVi
         5clmtMicO0cMGzi+QAUZaQC8pFWRB3FfSnvPgOB5hGcWG/1eVvT7TG8RWdG/rLp1maA4
         2YusTbQ1V3t3AgT/FDNsE6N83zQVqU5x8aOa+uTYs6Mfn5HqUJzNUUByenEZuoKxjK72
         PUR2KIKcInpU+2koT99kYNC7WjgGh7juflxgHl5ruF2ols1qRD7FTLqhUr/CfWnK5BCN
         GgIIPsNRntsUWtZVRqHwrzEMpGBlgMdaJE+wZERFwkDktRL9KXvNqoUgeSA5r3dIex8u
         CEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uPkPZ9hXb0YMQ9faHMJ8j8JGYXj5rWLnlmb1qb1codI=;
        b=OjJ0qzbOMDxOb7kv7U8isbSpa+KRJdZkHrsgI+uLK/DOvBUrjPDiP2IyDsv7FDRrOO
         xIC6S9mo/il6XGBqvbna6L2aRcug7VHsIhe9lf54Mhv5TLn9SVke42Kj+i6wsfLS0ipA
         6xF4TTU5hCtFrdPgPY7or1REGI42cR1J13ArSjPDZapkGHtaz9Xg4VvvYCM8FEOmG1Wb
         CzrQNT6wALDtbYVBQAPCilIVsEt/gxWwj8Ow2aPY5TR1auxAF5QjFcuVzUhx0zelZZuD
         xo5k+qaa9oTGAIUv1FgFgVdtvvQYE8F9FWDp43gACN1q8NRtBtNeSzsK3TgypNrOGrUB
         6zdg==
X-Gm-Message-State: AO0yUKUA9Fm4wzj2XNgsZhy3cCE57lP7TuUanagTGneZoFBaXqFJgjeV
        6SoMy0CdCBuT4UAugFeWZS7mEwAEa5A=
X-Google-Smtp-Source: AK7set/iisSzpF5vyGzXWeKEJ9SOXJV/hMny8Yz/vbZ7Y7oBrWg2V1eTmKTsaWJW0ik2OkN3038pKw==
X-Received: by 2002:a17:906:8444:b0:879:ab3:2864 with SMTP id e4-20020a170906844400b008790ab32864mr12057736ejy.24.1675109774600;
        Mon, 30 Jan 2023 12:16:14 -0800 (PST)
Received: from ?IPV6:2a01:c23:c074:7400:d941:3cb5:fa86:8ec8? (dynamic-2a01-0c23-c074-7400-d941-3cb5-fa86-8ec8.c23.pool.telefonica.de. [2a01:c23:c074:7400:d941:3cb5:fa86:8ec8])
        by smtp.googlemail.com with ESMTPSA id k16-20020a170906579000b0087bdae33badsm5772981ejq.56.2023.01.30.12.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 12:16:14 -0800 (PST)
Message-ID: <0489ac03-ff79-adf1-104d-72523ace9701@gmail.com>
Date:   Mon, 30 Jan 2023 21:16:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
Content-Language: en-US
To:     Chris Healy <cphealy@gmail.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
References: <20230130200352.462548-1-cphealy@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230130200352.462548-1-cphealy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.01.2023 21:03, Chris Healy wrote:
> From: Chris Healy <healych@amazon.com>
> 
> The Meson G12A Internal PHY does not support standard IEEE MMD extended
> register access, therefore add generic dummy stubs to fail the read and
> write MMD calls. This is necessary to prevent the core PHY code from
> erroneously believing that EEE is supported by this PHY even though this
> PHY does not support EEE, as MMD register access returns all FFFFs.
> 
> Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
> Signed-off-by: Chris Healy <healych@amazon.com>
> ---
> 
> Change in v2:
> * Add fixes tag
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>


