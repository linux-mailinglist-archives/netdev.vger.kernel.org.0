Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517056C6795
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjCWMF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCWMFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:05:08 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D83E1730;
        Thu, 23 Mar 2023 05:03:42 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id x20so3781488ljq.9;
        Thu, 23 Mar 2023 05:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679573020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d2mt8Dc/ocS7AxhWRTNt2+9WEZGZV0jc7YgGpq/l2wA=;
        b=PKA51kt0JsQLOKFobEusgiO4xJ1YNpSFSbrAdYyVvaGFYamI5SD9/YMoX9/hn344/I
         CJ1dNvsSMFw+jgrkeVxmecO/d7TOM5wfn+PnXRkBAhhdRy/+gtszDOPoVy9Cex/UEWKF
         ThhaO9Jk5LKsGJu75nAaK4P16JF6HtTRCjXmb8pb7rmUkit8XLz+XX98FrNkeJg5EZjR
         EVFVBxyyMh3ZGoARC822bXiG7gyfv3Q8JglwenH2yUQt9w8S6SLC0uYg5fBNo1tkL3TA
         LyOfJL1LcAeeHU0Ib/SHhRi1fNOBWmeYyiYjBCmvER3Vnc2oVTUnn/o1OtA4wXyz/m4t
         LRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679573020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2mt8Dc/ocS7AxhWRTNt2+9WEZGZV0jc7YgGpq/l2wA=;
        b=W6NeYVJLP0jQWqsnmSgU5kWooXTinzr/mkmDnF6T2aS4VC5JDa31dzS/gE/v8ztqAP
         fcCCBs3d1CGIK7KBgzSioUZ4jPmtfSLHT/TknUU86kU5vevBQhdtyFkNjaGquKGOtNyT
         Az+KjQKvdrXlsrn+QBH8JlZxMWk/Q7La/OB23CAWZ1ZQeAwuBYYAFKPmq65GNbsyMaj6
         xNSImInjpT6Q0ulFFSud/9eUCSu+hPr0hIhSK3qaos/rnQdXHwi575R3sfI2KYcRoEhq
         P29lRKK82X+yFdivHQwTN0eAl5SKbv8nK5GgTEqEOU2wFYikmQQe06+lHjqg5mNEu6CF
         ghrA==
X-Gm-Message-State: AO0yUKV6odXhiRaZGkKlg5RQu8EzxmExDSWRkKiqsZ8SnQWCGGAy1xih
        C7oZ0USMgJGbOlwjwuvWwyg=
X-Google-Smtp-Source: AK7set96yscptfSwhFYLFTxrBRamLAA1lhCOjFEeDzgEeGGXtplepcLYTAzk8FeHyTyPHNUIF654Sw==
X-Received: by 2002:a2e:9697:0:b0:29f:7525:ce90 with SMTP id q23-20020a2e9697000000b0029f7525ce90mr3078096lji.11.1679573020385;
        Thu, 23 Mar 2023 05:03:40 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id h16-20020a05651211d000b004db3e445f1fsm2900003lfr.97.2023.03.23.05.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 05:03:39 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:03:37 +0300
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
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 13/16] dt-bindings: net: dwmac: Fix MTL Tx Queue
 props description
Message-ID: <20230323120337.xdqetfgnclkmbt7o@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-14-Sergey.Semin@baikalelectronics.ru>
 <cee5e3d7-132c-2c6a-de11-c02ca6499231@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cee5e3d7-132c-2c6a-de11-c02ca6499231@linaro.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 09:08:48AM +0100, Krzysztof Kozlowski wrote:
> On 13/03/2023 23:51, Serge Semin wrote:
> > Invalid MTL Tx Queues DT-properties description was added right at the
> > initial DCB/AVB features patch. Most likely due to copy-paste mistake the
> > text currently matches to what is specified for the AXI-bus config
> > properties. Let's fix that by providing correct descriptions for MTL Tx
> > Queue DT-properties utilized for the AVB feature (CBS algorithm) tuning.
> > 
> > Fixes: 19d918731797 ("net: stmmac: configuration of CBS in case of a TX AVB queue")
> 
> Fixes must be first in the patchset.

Ok.

-Serge(y)

> 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> 
> 
> Best regards,
> Krzysztof
> 
