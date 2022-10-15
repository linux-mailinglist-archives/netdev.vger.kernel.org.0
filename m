Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF565FFAEA
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJOPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiJOPTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 11:19:22 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5FF5FE8
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 08:19:20 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r19so5426668qtx.6
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 08:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5lnInENwLybwBq+BGW9XxaGeEpI0F9YvSORSJTCPbgo=;
        b=tH2d2Fg2+rkIGI3g30tLYVACKy0d5S84UFuNYvLPX2jB7j1OU1s7hRZuvtaYaThLl+
         DVRX+YUAGvtLKD3k1P+nvbXARq1pZqxR+3jcthoC732WsTyygYmvBpNy0ogD83ytNN0o
         mct2GWnXik+WHSCVd8mXSryojXZ4tKde5eRzbSxYGRCMd7WGBsjihW5p/VfdA6h+QYSo
         4mvukBY/TajIL/LhoFP9fMi6Dxy7BP/AxIYoRIhBV1JvAf8GJMMLT3OPKk7DEsj8dD5r
         SgnimZMd+cNj6EcFymL/976s/bkyjFlv7uaNDY8zdHzGGO+rwOvEKXUZSXKZRSP79Gu/
         Do2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lnInENwLybwBq+BGW9XxaGeEpI0F9YvSORSJTCPbgo=;
        b=PjWBwqse1Q7VvKTjA3E3WDdAtEmTS8bd4bWVzG/xs/GvNtmut4Dy6leOR6sxzlwMk0
         eN2GDVBHMHi7a01Tb3jGtYXCxEXYw5P+JFRXymULsrP7OCmGCxY3QtfFJ2xPy1ewO2rl
         eT0LamifI0qanSPxCkxJltnjeFAVZMm7W+3QmdZEEwDZpfC2NNb+kKSGeWiecgpfftdH
         /h0fH9bDm2O1GwUycS07FHuPFCRZbHTX7cAezwpiOPTpBTmMzB7wKfLSylKRLCU8hcu+
         QJCptdpgBahjdW/9qQ1Xmx9YnMGWYZn3GuxiMASrk8lshwVTQuFM59ZMejSIqbWoV2PP
         gDOA==
X-Gm-Message-State: ACrzQf1Hq2eNUKR13r8EHv/QPfMPlYfk6Du0ezh/wZUqrshT/VK+tUis
        ypT/1H5RxvaDBWxoxAflX9tVhA==
X-Google-Smtp-Source: AMsMyM7SK8HhtjT3RcbC18eK6Wx6yTJR3yAlueJ7R3Fy7tkuEa2py8ydKmqXp8AC0za/7RsOMMmaNw==
X-Received: by 2002:a05:622a:13ce:b0:39c:c82a:4584 with SMTP id p14-20020a05622a13ce00b0039cc82a4584mr2279261qtk.150.1665847159474;
        Sat, 15 Oct 2022 08:19:19 -0700 (PDT)
Received: from ?IPV6:2601:42:0:3450:9477:c2f0:ddea:ea08? ([2601:42:0:3450:9477:c2f0:ddea:ea08])
        by smtp.gmail.com with ESMTPSA id fz25-20020a05622a5a9900b00399ad646794sm4165768qtb.41.2022.10.15.08.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Oct 2022 08:19:18 -0700 (PDT)
Message-ID: <608e194f-3137-ceb7-f9e9-155010ce1afa@linaro.org>
Date:   Sat, 15 Oct 2022 11:19:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples, again
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Nandhini Srikandan <nandhini.srikandan@intel.com>,
        Rashmi A <rashmi.a@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sumit Gupta <sumitg@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-iio@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-phy@lists.infradead.org
References: <20221014205104.2822159-1-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221014205104.2822159-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2022 16:51, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
> 
> A meta-schema check for this is pending, so hopefully the last time to
> fix these.
> 
> Fix the indentation in intel,phy-thunderbay-emmc while we're here.
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

