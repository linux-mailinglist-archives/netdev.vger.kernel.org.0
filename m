Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40336B9166
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCNLRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjCNLR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:17:28 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520CE1ADEB;
        Tue, 14 Mar 2023 04:17:01 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id i28so19554982lfv.0;
        Tue, 14 Mar 2023 04:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678792619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xqpuC0LKrzGcakbAULieo80qd/AxM1sSXYQ7KZfz9CA=;
        b=JfWQLDnss9RLHNQT55qIGS7gtnCy62QpDQIUDeg79wYVY91Jw/3YXc1F0z+nyOtiO2
         nFkf2/EEka2c/FmumixC9rihiTVJW3OJjXdGGjtfhIznb+dubYo3ONv0+F0XS+PXyRDD
         IWagIto5G2xwdRaSrZQ7Wd5dexIqaV34M4cKotJLIAIogNdJh/bqyv6qG2NUCJ3rn15G
         7nipq10oEMqOSJOfHKzu0U7dJRX0IusaF3FFWe37xqJMi+K3F/6iLJaPxgdshwhkQvma
         vMqNjiONBJOFOEgEk58PdFrCMWluAibeawFS1u/PPyXAIAzv9JV1QnJzNUtP31E3sdQR
         kQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678792619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqpuC0LKrzGcakbAULieo80qd/AxM1sSXYQ7KZfz9CA=;
        b=QS23SsT+qaZ4S50K1bRz7STaAdIWpek6hEE++knRMLvDy02G36MwhuTxE7ldjFYK3H
         wu0T9kxkCLEE8TXVIk8m5sd4a4vq0hlwAJB/ibjG1vmrMM8atbrQYpT+i66kOsvISgA5
         83qOnmq/Zyqi6/q5LbkOcwXzLWe5mr5Z2zMqJIwx9RPCvfSShoyIFB/wWM98CpRxhxZq
         ILkyN6bUJNKXKicExsPROs28SxSaReeZzcbalZmG0txzwYIKZbOlAG5FnzSTO4ZGPtcL
         Khnv3Uo5xw/H6C/0v5OGIjAe4fPQJFmS4Q+Qgs/3h1dR/2nsSDtxFYhwP2+qDROMzMKd
         v/3g==
X-Gm-Message-State: AO0yUKWSO3y6+O0Qxi3qs7MhmXxZLMayTd9Or4QKMko5vyLOYgC79NSG
        0BJRauihhLnjT+Nfn9G95c0=
X-Google-Smtp-Source: AK7set9ZcenVszb/blJH1/YrWz7TaGM2/EeKvjtDVgJWlZfEvoGSveVyrjgsuwIuViFfdf8ZyAN9/Q==
X-Received: by 2002:a05:6512:4c7:b0:4b4:8f01:f8b1 with SMTP id w7-20020a05651204c700b004b48f01f8b1mr628005lfq.31.1678792618656;
        Tue, 14 Mar 2023 04:16:58 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id u10-20020a056512040a00b004dd7ddc696esm356706lfk.293.2023.03.14.04.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 04:16:57 -0700 (PDT)
Date:   Tue, 14 Mar 2023 14:16:54 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 01/13] net: phy: realtek: Fix events detection
 failure in LPI mode
Message-ID: <20230314111654.x2nsdr7jmumg6bp7@mobilestation>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-2-Sergey.Semin@baikalelectronics.ru>
 <c87c9964-af29-4885-a977-c8a4a2fe704e@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87c9964-af29-4885-a977-c8a4a2fe704e@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

On Tue, Mar 14, 2023 at 01:39:43AM +0100, Andrew Lunn wrote:
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Since this is for net, you need to provide a Fixes: tag.

Hm, for some reason I was sure that all the patches in this series were
equipped with the Fixes-tags. Anyway since the patch fixes the particular
device malfunction then it's relevant to the commit initially adding the
device support:
Fixes: ef3d90491a15 ("net: phy: realtek: add rtl8211e driver")

I'll add that tag on v2. Thanks for reminding.

-Serge(y)

> 
>       Andrew
