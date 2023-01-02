Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4635365B26E
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 13:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjABMzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 07:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABMzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 07:55:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FE7C7B;
        Mon,  2 Jan 2023 04:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6869F60F9B;
        Mon,  2 Jan 2023 12:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27FEC433D2;
        Mon,  2 Jan 2023 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672664137;
        bh=+O8WT+Mutfqnirbic+s0CqiW9/5UVPlgZlFFpC0wM2Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hKwI5pCvfacoAtQhp1K8GooIUKpyPdOL2/1bYIRCDxrIIcSfqlu7YkLqvtT6yBbyK
         //B4UoIBfESwsLpvUNlqaMfB5I/3RvU5CUarfw2h8z4puo4pIpurnabjWPgTA2E1mF
         atIAdQdyMyiCg6087kDCC/FauAvNdLz70SrInmefNaRgMRLbmlGVDKuBydCOaJ8nMw
         Ud5VaAI5LeykH5aG6HvUYCh4a04xtNrtS8helW2KxEVvndmqUvGLoW58R5m1KIxioC
         tmp+l6MdMFUiy13f7hJuvTc121CbZySrfrVe0sl3gHKc4GdIZxxQYn5A+mXDJHhh9y
         l/5T7AYXcPwJw==
Message-ID: <2b50caa7-68a7-ee99-594c-0293168666cb@kernel.org>
Date:   Mon, 2 Jan 2023 14:55:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch
Cc:     nm@ti.com, ssantosh@kernel.org, srk@ti.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-3-danishanwar@ti.com>
 <e7960761-07c1-8cc7-60b3-1454ddb9317b@linaro.org>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <e7960761-07c1-8cc7-60b3-1454ddb9317b@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 23/12/2022 13:32, Krzysztof Kozlowski wrote:
> On 23/12/2022 12:09, MD Danish Anwar wrote:
>> From: Roger Quadros <rogerq@ti.com>
>>
>> This is the Ethernet driver for TI AM654 Silicon rev. 2
>> with the ICSSG PRU Sub-system running dual-EMAC firmware.
>>
> 
> 
> (...)
> 
>> +
>> +/* Memory Usage of : DMEM1
>> + *
>> + */
> 
> ??? What's this?
> 
>> +
>> +/* Memory Usage of : PA_STAT
>> + *
>> + */
> 
> Same question.
> 
>> +
>> +/*Start of 32 bits PA_STAT counters*/
> 
> That's not a Linux coding style. Add spaces and make it readable.

The contents of this file were copied from f/w.

This file needs to be reduced to only the elements that
we really use in the Linux driver and coding style fixed.

cheers,
-roger
