Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD17E6BDA63
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjCPUut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCPUus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:50:48 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03137607C;
        Thu, 16 Mar 2023 13:50:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x17so3997666lfu.5;
        Thu, 16 Mar 2023 13:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678999845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tm+CR5BUEZPIc6XrcLK40BWz/iwrOweB0rbSxedxb6c=;
        b=DgFpRDyQ6ojzdXRizZH6TFtk+GAyYW0lqAuQCMMBbGoDuLzPT0H77cdP1mV9opDXwB
         6xKWAd7Th/DWIIx4BFYiTDX0yCcjvUuaDmHtHV+YakvBj2YSV2LiGMfn8b3JdMZeXRLD
         P/mQlgYRFi1Zz5icl6QD8T8iuq6vSd8Ig7g1qBh/N63rahkv78/GhY+ItG9FWuqTAwQC
         6+j4mlgSlfPfztlufjqnWDckg6tKHnvUbVDktywcTfMyrxo5QjgRuyw8kI3bEaK/pqbX
         jMycNKQaHSAlbAIGyVOpgkjvcNByY775FhUI1LpaKp26skX+4dGlPqP0ASIPZ20i6lFv
         PypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678999845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tm+CR5BUEZPIc6XrcLK40BWz/iwrOweB0rbSxedxb6c=;
        b=u8DGPALKPoF3yA4kTJNrUh4SCG0opSRYls61FdCI4AvBr8xpW159oy7letyyerMqea
         jz//PkejOC3pdA+oN39nmgqIHxtY3YJp47pDZOiXkn6Mz3ftMl37WiIK/PQDSMaR381+
         w3O8V8earyKH03+8FX0IRrYuwWKkgIloHs+R/PJuUwPdtkXhdQWMfugNF+oNxwKfl/uU
         P6RVZ8JN9ncSjBkYefxKUxrck3TFx2g7EAJiXm0voatnRlwiHdJKvkh/Lpm5iJKEWql3
         GefXI89WUg/TYXgGHg/7S4WnIWWOY9cghi+LFhKlHZVHy5S3geO7aVXncuWDyiWiVSUo
         Gx1g==
X-Gm-Message-State: AO0yUKVbiyAK/NqsD69S/0PJjUbLxVIPGYFBe7p5qpURqL5cnQMVrNpX
        dGOGwznIBkSeodoJqgtJE+8=
X-Google-Smtp-Source: AK7set93Hh4wAnzsV+brV3vssp16g1107+6Kt8j0R3UNFEyry4cAodJdQraD2u1FFr5AcThx4B+/YQ==
X-Received: by 2002:a05:6512:33c7:b0:4dc:790c:9100 with SMTP id d7-20020a05651233c700b004dc790c9100mr280464lfg.12.1678999845018;
        Thu, 16 Mar 2023 13:50:45 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id 8-20020ac25688000000b004d863fa8681sm36473lfr.173.2023.03.16.13.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 13:50:44 -0700 (PDT)
Date:   Thu, 16 Mar 2023 23:50:41 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        Christian Marangi <ansuelsmth@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next 01/16] dt-bindings: net: dwmac: Validate PBL for
 all IP-cores
Message-ID: <20230316205041.vr6nrfbrrbwetng7@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
 <167880254800.26004.7037306365469081272.robh@kernel.org>
 <20230314150657.ytgyegi7qlwao6px@mobilestation>
 <20230314170945.6yow2i5z4jdubwgt@mobilestation>
 <20230316204037.GA3844212-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316204037.GA3844212-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 03:40:37PM -0500, Rob Herring wrote:
> On Tue, Mar 14, 2023 at 08:09:45PM +0300, Serge Semin wrote:
> > On Tue, Mar 14, 2023 at 06:07:01PM +0300, Serge Semin wrote:
> > > On Tue, Mar 14, 2023 at 09:10:19AM -0500, Rob Herring wrote:
> > > > 
> > > > On Tue, 14 Mar 2023 01:50:48 +0300, Serge Semin wrote:
> > > > > Indeed the maximum DMA burst length can be programmed not only for DW
> > > > > xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
> > > > > for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
> > > > > the property and then apply the configuration for all supported DW MAC
> > > > > devices. All of that makes the property being available for all IP-cores
> > > > > the bindings supports. Let's make sure the PBL-related properties are
> > > > > validated for all of them by the common DW MAC DT schema.
> > > > > 
> > > > > [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
> > > > >     October 2013, p. 380.
> > > > > 
> > > > > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > > 
> > > > > ---
> > > > > 
> > > > > Changelog v1:
> > > > > - Use correct syntax of the JSON pointers, so the later would begin
> > > > >   with a '/' after the '#'.
> > > > > ---
> > > > >  .../devicetree/bindings/net/snps,dwmac.yaml   | 77 +++++++------------
> > > > >  1 file changed, 26 insertions(+), 51 deletions(-)
> > > > > 
> > > > 
> > > > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > > > 
> > > > yamllint warnings/errors:
> > > > 
> > > > dtschema/dtc warnings/errors:
> > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> > > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> > > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> > > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> > > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: Unevaluated properties are not allowed ('interrupt-names', 'interrupts', 'mac-address', 'phy-mode', 'reg', 'snps,reset-delays-us', 'snps,reset-gpio', 'snps,rxpbl', 'snps,txpbl' were unexpected)
> > > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > > 
> > > Oops, on rebasing my work from older kernel I missed that the PBL
> > > properties constraints have already been extended. I'll drop the next
> > > patch in the series then and fix this one so the already defined
> > > constraints would be preserved.
> > 
> > BTW it's strange I didn't have that bug spotted during my
> > dt_binding_check run...
> 

> Perhaps because you set DT_SCHEMA_FILES?

Can't remember now. I might have missed that in the long log as well.
Anyway I'll test it out one more time before fixing.
Thanks for your response.

-Serge(y)

