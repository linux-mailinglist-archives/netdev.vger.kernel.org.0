Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472396BC839
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCPIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCPIGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:06:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F284EB06F6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:06:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x13so4240298edd.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678953994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KZkYtSR+YFrQLhjFXxMBdPgks/5EamNF6JACsG0aG5I=;
        b=MZyWQTzvPjgcuXcNYT/yQuy4ao0cb9lt1XOBPuBy/LGocjOIgUnBTqrQrapFtA6C5E
         AGe9t2b3JcQHb3Q0v31fRCNeKoqIgB7uxmG4eUHu6PVn7YXwLKvofq1IsrNhzIQ5Ig5L
         G47IzFDjVpaYokKqTGsVn5LsAe2j9nVg+gL3gFJb2RBUQ/fJqO+x/XbJ3fW4DQcZliwU
         2eUuZbzvtg+tchztjsUboLm+FqCFo08EcEwtrqlxVmR2ZcECbx4rwrcx1fBjxjsLkdUt
         yKxW9Om5vG01d/pnvBq5Fk53TFajpGZVA36Mz47lJtM3a1KHEpphS9VYczFs/+gzUbIi
         cl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678953994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KZkYtSR+YFrQLhjFXxMBdPgks/5EamNF6JACsG0aG5I=;
        b=s2ykMw3tSt0SaOuGwbu/lY4gFSPrwXAjJxEzTDL04TMyfImE7OkzeB+uOKvbhSAGIA
         edtoVfGjCWm7c1yy/575MZW2Cmy52kzgONMyDUpyZ2Z6GBst6xkC30eWpy+eLs2vcMCR
         Q5K37sFDgSbrti/EGkTCIlxzYT87O1FZN3OmgLND454INLsHTdHJCt64JAbQKnwOPg9n
         twT/65ecES01jyHqMMD+oUknfZwYgTvBiOdPtGfQSfy4DzAlAlijuS5bBmPzOqyno7TN
         cqFr+lv8G4Btz+o9SzXb0eGLBEE4xjnq9w2LaIjPaiayFfoLWJGg385UaFh8NsPXAobX
         I4fg==
X-Gm-Message-State: AO0yUKUIGNAh5o6kLUFyMMVasKbI9qsP+toZUec9+D+xR5GmKlWeqOIM
        W8qZF9wHJ+Co73ySqQJliZURDA==
X-Google-Smtp-Source: AK7set816JtppXD+OBP7Q2nHJWHyKFcPf9wNBzn6R33ibzuPGNNFWGvEWVf1ckoXJyxR+9WOJERVLA==
X-Received: by 2002:a17:906:b17:b0:8b1:7857:2331 with SMTP id u23-20020a1709060b1700b008b178572331mr8990750ejg.65.1678953994419;
        Thu, 16 Mar 2023 01:06:34 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id oq12-20020a170906cc8c00b0092fdb0b2e5dsm938055ejb.93.2023.03.16.01.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:06:34 -0700 (PDT)
Message-ID: <c9577e01-b6a0-48d9-173e-2eddffd8019c@linaro.org>
Date:   Thu, 16 Mar 2023 09:06:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 10/16] dt-bindings: net: dwmac: Add AXI-bus
 properties constraints
Content-Language: en-US
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-11-Sergey.Semin@baikalelectronics.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313225103.30512-11-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 23:50, Serge Semin wrote:
> Currently none of the AXI-bus non-boolean DT-properties have constraints
> defined meanwhile they can be specified at least based on the
> corresponding device configs. Let's do that:
> + snps,wr_osr_lm/snps,rd_osr_lmt - maximum number of outstanding AXI-bus
> read/write requests is limited with the IP-core synthesize parameter
> AXI_MAX_{RD,WR}_REQ. DW MAC/GMAC: <= 16, DW Eth QoS: <= 32, DW xGMAC: <=
> 64. The least restrictive constraint is defined since the DT-schema is
> common for all IP-cores.
> + snps,blen - array of the burst lengths supported by the AXI-bus. Values
> are limited by the AXI3/4 bus standard, available AXI/System bus CSR flags
> and the AXI-bus IP-core synthesize config . All DW *MACs support setting
> the burst length within the set: 4, 8, 16, 32, 64, 128, 256. If some burst
> length is unsupported a zero value can be specified instead in the array.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>


>  
>        snps,kbbe:
>          $ref: /schemas/types.yaml#/definitions/uint32
> @@ -501,6 +507,8 @@ properties:
>            this is a vector of supported burst length.
>          minItems: 7
>          maxItems: 7
> +        items:
> +          enum: [256, 128, 64, 32, 16, 8, 4, 0]

Increasing order.

Best regards,
Krzysztof

