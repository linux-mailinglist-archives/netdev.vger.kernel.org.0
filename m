Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4656C6710
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjCWLtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjCWLtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:49:07 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14664305DF;
        Thu, 23 Mar 2023 04:49:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id s8so27031956lfr.8;
        Thu, 23 Mar 2023 04:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679572144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P98gCKiuXHcAXO0IW30QLmGZe+1zDOszgmMTppwep1Y=;
        b=kOLDCZtRhvL2t2ixB4Ecmb2mYtVsQbpH9hOUXBtXyzSDEwmtf3LohWwaXB5dq2O2zw
         Z6PX8n6kUNNZQAxIdWGhkryNkYVIJMNdbbkGSvKKJdrMbqgpZ68Iw+hpNL8N9hZ2ghlv
         UMg9yh/qiaxJFDaHnrLOLMeFbRCKOLWUThRxhs95006FEWVpAxNVSlxPNPsDdXvp3LHP
         9KIG35rbALoZAeyE03QVGRc8OPPQkXMkXoxr0uCRbOepeaI6PUowMtYrDYQDZR4uu8y1
         e8WOM7sl8eXeFkrEA2OdFzPcaud8gkL2UgUkgv2iVthLNW+zTEA4biOipmqZ+8KroTg4
         o4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679572144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P98gCKiuXHcAXO0IW30QLmGZe+1zDOszgmMTppwep1Y=;
        b=adoiVxf81FB6/O47VQGHXyBAARA1p6UGR6EFJTEdPDMxvP8cy80UZXt78PfDSqepUK
         g8pI6/TagvjbLFC/3Clav3KtGND1UelQKjGVLd63krKwrfYGH5U+DbJ6B+2o9O0iLIol
         cnMDIVhcFhnumtBG8vUVpHJ32IwxkSOHD1SB/9IFRXhMszi99zW4M1VAS2nv2dJRDiHG
         d5NHUMvYLM8CAgOaiyrTqol5CHEl2mOKyHFVX7H3HH0iByeKq0a2f2lokEy4SLnWugtg
         9XO7h7aTpEda0UURga0a8+2csQLkAkh7Sh1DqsjtDV7usxoPWAD3AglWWkIuJp4woSL6
         JAkQ==
X-Gm-Message-State: AO0yUKXpJek34Ky2Jz9ljwKEC0oO9ZFB5F5WdvMqJKwhZwQH/5vPYE6c
        2eaeslVWsJ8nVz3RW0iuhr8=
X-Google-Smtp-Source: AK7set+OZ5RohXKrqoNxbr5LNz9IYAEZzXjD7ahv2qbaEU7/L9WaV1ILCB8rtLSxCgXFO6/YSbF/bA==
X-Received: by 2002:ac2:43d3:0:b0:4a4:68b9:1a14 with SMTP id u19-20020ac243d3000000b004a468b91a14mr2636974lfl.60.1679572143721;
        Thu, 23 Mar 2023 04:49:03 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id c3-20020ac244a3000000b004e792045b3dsm2912464lfm.106.2023.03.23.04.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:49:03 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:49:00 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 10/16] dt-bindings: net: dwmac: Add AXI-bus
 properties constraints
Message-ID: <20230323114900.l56bqiazkc5llvql@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-11-Sergey.Semin@baikalelectronics.ru>
 <c9577e01-b6a0-48d9-173e-2eddffd8019c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9577e01-b6a0-48d9-173e-2eddffd8019c@linaro.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 09:06:32AM +0100, Krzysztof Kozlowski wrote:
> On 13/03/2023 23:50, Serge Semin wrote:
> > Currently none of the AXI-bus non-boolean DT-properties have constraints
> > defined meanwhile they can be specified at least based on the
> > corresponding device configs. Let's do that:
> > + snps,wr_osr_lm/snps,rd_osr_lmt - maximum number of outstanding AXI-bus
> > read/write requests is limited with the IP-core synthesize parameter
> > AXI_MAX_{RD,WR}_REQ. DW MAC/GMAC: <= 16, DW Eth QoS: <= 32, DW xGMAC: <=
> > 64. The least restrictive constraint is defined since the DT-schema is
> > common for all IP-cores.
> > + snps,blen - array of the burst lengths supported by the AXI-bus. Values
> > are limited by the AXI3/4 bus standard, available AXI/System bus CSR flags
> > and the AXI-bus IP-core synthesize config . All DW *MACs support setting
> > the burst length within the set: 4, 8, 16, 32, 64, 128, 256. If some burst
> > length is unsupported a zero value can be specified instead in the array.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> 
> >  
> >        snps,kbbe:
> >          $ref: /schemas/types.yaml#/definitions/uint32
> > @@ -501,6 +507,8 @@ properties:
> >            this is a vector of supported burst length.
> >          minItems: 7
> >          maxItems: 7
> > +        items:
> > +          enum: [256, 128, 64, 32, 16, 8, 4, 0]
> 

> Increasing order.

Ok.

-Serge(y)

> 
> Best regards,
> Krzysztof
> 
