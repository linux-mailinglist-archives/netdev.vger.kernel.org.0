Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5679C6B9886
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjCNPHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCNPHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:07:11 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E32AD039;
        Tue, 14 Mar 2023 08:07:02 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id y14so16350746ljq.4;
        Tue, 14 Mar 2023 08:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678806421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vbLXsISyWgbVocJH/scN2oci69TRy0WQAp+UcL8HxWE=;
        b=p0EHmvR1vBC356rN7/hm4DOqRkE0aTTA91VTR19VIj+t/xskGgPxcVC3Swn6v9ey4F
         hbZfTPYuaYAyhipmyuQAQiT9RiKEflzSzfvMU8NftKq826q6fQGijvPoAqFXQfhx2YNM
         DZ0i8d+f5YC8PUInQ/YGggRBNF7L0zduinQoSh/szpA7/UfmEdSQZnXCD88Lw2CyoPd2
         AsbYncMjY75d3PAIP65fHKB/efe59KSueM5VSxPJOzIxxOgST+XFh4HkqwTZw7xG5WoD
         H4IY3tz0HYGYUCEVI5Y7rZ2y+Y0sOCOq+odtg7nB0dEuKuiCUypgbTjBbVm/5a2Jzwas
         QqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbLXsISyWgbVocJH/scN2oci69TRy0WQAp+UcL8HxWE=;
        b=0wIr9/tn4Nwwv7e8J4z7ps/dhSU/ejiOgIlQK7T6knllv8+6iBKjnv7SFU+Z4BFcx7
         GRErpxkqMTrmxo39/MffqLtu62UhjcebRFY4HMlpWo2cERUQLEBV8R9hUaXGWn7libgx
         6lBAFynF6be6mEYWvKpQTFSzbyL1Gti2VVXeo6NKvrZhKAQiUELv6DrxwniXfttykLBv
         O1FmRxisovbztgmrupz3B/yjXpWXCQFmwZRRO97/CzzA+l3TsB787HSHUShAeeZP6QFS
         TYg8N0GkMv5jKSVQHZMHkRxTIYPqKNoUPsz8c84BfQIu+kUJ6/GHZHoFfrEmaDz22hVY
         +Ebw==
X-Gm-Message-State: AO0yUKXnjX7/ro4cwANEL8AAD9HcIEpZ29pdEnKjhMdYzKNKbmxxnFMx
        iwcK6VT6V4dUUGZ2T2NR/gQ=
X-Google-Smtp-Source: AK7set+bnaLvSzK+Qv9g7g8oQCKeqApzg3XCPn/W6kdtRZtalZ50JNrzKxOFyptmqs0wq8VDOrJGng==
X-Received: by 2002:a2e:8e8d:0:b0:298:6f36:dd6c with SMTP id z13-20020a2e8e8d000000b002986f36dd6cmr7223147ljk.11.1678806421025;
        Tue, 14 Mar 2023 08:07:01 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id f14-20020a2e9e8e000000b00295b1b6e063sm482600ljk.34.2023.03.14.08.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:07:00 -0700 (PDT)
Date:   Tue, 14 Mar 2023 18:06:57 +0300
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
Message-ID: <20230314150657.ytgyegi7qlwao6px@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
 <167880254800.26004.7037306365469081272.robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167880254800.26004.7037306365469081272.robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:10:19AM -0500, Rob Herring wrote:
> 
> On Tue, 14 Mar 2023 01:50:48 +0300, Serge Semin wrote:
> > Indeed the maximum DMA burst length can be programmed not only for DW
> > xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
> > for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
> > the property and then apply the configuration for all supported DW MAC
> > devices. All of that makes the property being available for all IP-cores
> > the bindings supports. Let's make sure the PBL-related properties are
> > validated for all of them by the common DW MAC DT schema.
> > 
> > [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
> >     October 2013, p. 380.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > 
> > ---
> > 
> > Changelog v1:
> > - Use correct syntax of the JSON pointers, so the later would begin
> >   with a '/' after the '#'.
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml   | 77 +++++++------------
> >  1 file changed, 26 insertions(+), 51 deletions(-)
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: Unevaluated properties are not allowed ('interrupt-names', 'interrupts', 'mac-address', 'phy-mode', 'reg', 'snps,reset-delays-us', 'snps,reset-gpio', 'snps,rxpbl', 'snps,txpbl' were unexpected)
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

Oops, on rebasing my work from older kernel I missed that the PBL
properties constraints have already been extended. I'll drop the next
patch in the series then and fix this one so the already defined
constraints would be preserved.

-Serge(y)

> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 
