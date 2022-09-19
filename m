Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61575BD224
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiISQZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiISQY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:24:58 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8128C29CAE
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 09:24:57 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id k10so47781820lfm.4
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=eAOafVCNVmR9N9v0Yvq51YsgQAP+hB4f5u0L/4nUBKA=;
        b=ethu0EynC43p9UpiI84ruyAXrMRMdZfuiof4jGWO3COHQkx9EjPMb0Llez11+BLPKc
         5EqefT79o5oAfWdTFyJjgnxiKXiq84VSTx1yMZv0TukcBhrSE770dxQz5AgwGe1/wdX2
         cUJsrSok2ZwMke4mNjZjszTcRrHhEleMa2aQSfFC8yHWRZB04kXsxZz6CdO77YeDIaKv
         W7FxT0sb23ogGQ7pc/WVP0aKVEqqH7TJDENRj5695hxAabD43bspb6BjFX+2A2W7QhTc
         h3skjS9SO/0P+2xMjVxsZpwoqFCCIKq/pCYKaq7GoKibRjTOB+55a8piA4ChmXfjbqDC
         To3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=eAOafVCNVmR9N9v0Yvq51YsgQAP+hB4f5u0L/4nUBKA=;
        b=Vos+VHobPS8rkI0mJtYCPs6MzI0H0PbECq+q7Z3vCKMyUM9qrPJfcImc4inAVbteXT
         EEZ4805edaqhTPw0J7rvMmxZ8jiFhCyThnG0aC+qQ/6KxrHO3VV1Kve1VYy9rY9zJzP6
         +PqhZMW6FbldWCB6BpS4WrQW7Pywh8OWBl/4MPi9IBNIk7/FLIQzvth5j+qJJNbRRNA0
         sUiVjAfQRK66p1cwBWJgzj33563WjdwvL3PGPnqbWurEU4mLb8GoTPrasEHul3xOwW5X
         c5GsHxcWMW7MUiKRLkcx5LILOO1jUlPeQDhNjtdVTNh/ffeI4IxuWoSbPyjAnpP8cib7
         Fa+g==
X-Gm-Message-State: ACrzQf2Z/2K3P7fuCh92cHKNQg28gqbmcLIbMPoP+PJObUYsP9dcPECu
        jCmQnZrxANBxZc8Dv3IxRgaE8g==
X-Google-Smtp-Source: AMsMyM7Q5L1McMMFqSUa7fGLN03YMRs0ciA4N40x8PHN9GOTdAWbWDoQN39MejGALAtGiMvhd/RDEg==
X-Received: by 2002:ac2:4e0d:0:b0:49c:d593:9d6c with SMTP id e13-20020ac24e0d000000b0049cd5939d6cmr6740730lfr.37.1663604695831;
        Mon, 19 Sep 2022 09:24:55 -0700 (PDT)
Received: from krzk-bin (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id v23-20020a056512349700b00499d70c0310sm5061842lfr.3.2022.09.19.09.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 09:24:55 -0700 (PDT)
Date:   Mon, 19 Sep 2022 18:24:53 +0200
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Biao Huang <biao.huang@mediatek.com>,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 2/2] net: dt-bindings: dwmac: add support for mt8188
Message-ID: <20220919162453.4kkphzhc2tu6wzou@krzk-bin>
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
 <20220919080410.11270-3-jianguo.zhang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220919080410.11270-3-jianguo.zhang@mediatek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Sep 2022 16:04:10 +0800, Jianguo Zhang wrote:
> Add binding document for the ethernet on mt8188
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/net/mediatek-dwmac.yaml | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/


ethernet@1101c000: Unevaluated properties are not allowed ('clk_csr' was unexpected)
	arch/arm64/boot/dts/mediatek/mt2712-evb.dtb
