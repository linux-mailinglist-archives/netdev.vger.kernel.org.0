Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BA06B9C86
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjCNRJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCNRJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:09:56 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2A379B23;
        Tue, 14 Mar 2023 10:09:50 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id m4so7922747lfj.2;
        Tue, 14 Mar 2023 10:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678813789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3mTGYj7JV/DxYx8PY7Jjtyf3i3A4TY4QKPyGUShY+4=;
        b=Pt9FXMyV5qPTnBsN9S1/ue6ef/xHOAdmSIiLfyYu0b5z8FVXXS1yj4ZK1ucSROuPRG
         jDyAlusKmNAaEVi6bK3kDVBpf6AGWU9T7G5LNXbgXRxebGCYrJidVsFdZ+6LCbkTcR59
         xnKKxVKWv9z9kJBHtIXobR8p6nSXCU3GzZTqFQP7wexHJsPLFmx2tZSCK/GA+REeelbu
         0SxCODAFMY88ynul6wJCGBHe7NI+t6qu825Iptsp1ZbKcS8A9M1zyNkc1e1A84ehOq4o
         IdU+k74tQ+L39Bk+Fa/ESNr/YZwbgGVjHerqrj0/7/gdEYmlX3/IBoI1i1DggLgPpprn
         f2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678813789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3mTGYj7JV/DxYx8PY7Jjtyf3i3A4TY4QKPyGUShY+4=;
        b=Vvp24ywrq1Jzu5HWi+Zxpa77lH+K+uctTX9pfh88EylYZlXXqUBwkA2+U3/gxg0g1d
         vhwBHMNfwLkyNFs0OVMv8sjesl/CnzF7IudTPzRqYMxo3skLdkgNfjjhA9A2vPeMkI3+
         00RKxSwwHC/5qDrG8cCaYUwI4+Ia1DMNIARTR4wYNmiEDHP6IW9jWiUXUrafxpUmBWNV
         j84K0jY8xDZssPtEFVfRZdGDGkO+OD8ryKC9fUSJBqsqOEKh8BkxCexv9WbrmA7n+TJy
         sIwjLW56JnnEIgDZWYQhCK1ggRXmyBgUC+7iqLL/XHQ6HR7v53TUO/C40RZgVIqnqaVW
         AtYg==
X-Gm-Message-State: AO0yUKVlNdkNw1IcDaPcqQKc76RVVbCd73aLfDEsqyuE2O80TfIADrTU
        VvdXt8QEQLoay4JG8YAjijc=
X-Google-Smtp-Source: AK7set+uEt5IoqG9OS+mes6VV9AY4oMiyZ0VVvoQaK5iRVnuv11mr63pkW7lH+CP6HBvafiA2+RvoQ==
X-Received: by 2002:ac2:5449:0:b0:4e7:b481:c1c3 with SMTP id d9-20020ac25449000000b004e7b481c1c3mr1072908lfn.20.1678813788840;
        Tue, 14 Mar 2023 10:09:48 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id b7-20020a056512024700b004caf992bba9sm464219lfo.268.2023.03.14.10.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:09:48 -0700 (PDT)
Date:   Tue, 14 Mar 2023 20:09:45 +0300
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
        Rob Herring <robh+dt@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next 01/16] dt-bindings: net: dwmac: Validate PBL for
 all IP-cores
Message-ID: <20230314170945.6yow2i5z4jdubwgt@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
 <167880254800.26004.7037306365469081272.robh@kernel.org>
 <20230314150657.ytgyegi7qlwao6px@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314150657.ytgyegi7qlwao6px@mobilestation>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 06:07:01PM +0300, Serge Semin wrote:
> On Tue, Mar 14, 2023 at 09:10:19AM -0500, Rob Herring wrote:
> > 
> > On Tue, 14 Mar 2023 01:50:48 +0300, Serge Semin wrote:
> > > Indeed the maximum DMA burst length can be programmed not only for DW
> > > xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
> > > for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
> > > the property and then apply the configuration for all supported DW MAC
> > > devices. All of that makes the property being available for all IP-cores
> > > the bindings supports. Let's make sure the PBL-related properties are
> > > validated for all of them by the common DW MAC DT schema.
> > > 
> > > [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
> > >     October 2013, p. 380.
> > > 
> > > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > 
> > > ---
> > > 
> > > Changelog v1:
> > > - Use correct syntax of the JSON pointers, so the later would begin
> > >   with a '/' after the '#'.
> > > ---
> > >  .../devicetree/bindings/net/snps,dwmac.yaml   | 77 +++++++------------
> > >  1 file changed, 26 insertions(+), 51 deletions(-)
> > > 
> > 
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > 
> > yamllint warnings/errors:
> > 
> > dtschema/dtc warnings/errors:
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: Unevaluated properties are not allowed ('interrupt-names', 'interrupts', 'mac-address', 'phy-mode', 'reg', 'snps,reset-delays-us', 'snps,reset-gpio', 'snps,rxpbl', 'snps,txpbl' were unexpected)
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 
> Oops, on rebasing my work from older kernel I missed that the PBL
> properties constraints have already been extended. I'll drop the next
> patch in the series then and fix this one so the already defined
> constraints would be preserved.

BTW it's strange I didn't have that bug spotted during my
dt_binding_check run...

-Serge(y)

> 
> -Serge(y)
> 
> > 
> > doc reference errors (make refcheckdocs):
> > 
> > See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru
> > 
> > The base for the series is generally the latest rc1. A different dependency
> > should be noted in *this* patch.
> > 
> > If you already ran 'make dt_binding_check' and didn't see the above
> > error(s), then make sure 'yamllint' is installed and dt-schema is up to
> > date:
> > 
> > pip3 install dtschema --upgrade
> > 
> > Please check and re-submit after running the above command yourself. Note
> > that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> > your schema. However, it must be unset to test all examples with your schema.
> > 
