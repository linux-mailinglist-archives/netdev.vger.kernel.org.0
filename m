Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B266C66C7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjCWLh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCWLh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:37:56 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215DD12BDE;
        Thu, 23 Mar 2023 04:37:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id j11so27237078lfg.13;
        Thu, 23 Mar 2023 04:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679571472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9wqfCTQu6TpSkQBuufTN+FDVnW3u9zukJQMSdPwg2XI=;
        b=Op0RbaHTvg7xYxUMJ5x37/ssOSmmCk314Ar6tZMsow7cQf4VpukR5WbwpoKvNPlu2w
         qpLueWiBUoznP+bidlh55yerR8HD4zeejtChefwtTSe1QazWFMbdyGnY7mUCCXIN+C5p
         UtnU1MO4sn6fjSneBxTpdUUWbf/OTjbDO2fQyhJFMTedWk4Q8Hz0fa2g4qKvUuPB0R0L
         pOA5cNoFm5zLcVhgdJ0m8/KbohJNPJzBwmiyVYWwPrA/h+CvdZpyS1elXEd1H4aTKx2K
         M5V9cImzOfpBDW+UvHUuaXJGB+wAOK6qAO5qwuxxINZy8nyW6mJW1jCqvnH/gYAcr4fB
         81Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679571472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wqfCTQu6TpSkQBuufTN+FDVnW3u9zukJQMSdPwg2XI=;
        b=Unbvszsm7eLglGA1LnP6fJu/N3jEBKeqP5T62uf83AX/NevSgXKkZgXRB70MSXoNLa
         g6TkGur8DRXD2ZstJGHX/H9hSd2J96izAZVK46J+8sji6m6W44kO1LIOsMYTIvgiwDn9
         N6Ku4cjlll3GwwIu/j9YOGTkDXbv7fUCOPXYfY1waxZzRKoweFsr4Gec1syTewcX23L5
         O+ien4cHkO9n/UdYxjHYXBfAXr5xCyTCLUIaqQGK1CCOr16XSaiS9vid7Pk7j1HhTQQh
         RrawrcCylXj3FcNDDdqasi4DcO6ImLmVtM3zHZdV8+OdIhltkQNX3U/Xj4/igpsUkcl+
         Ma5Q==
X-Gm-Message-State: AO0yUKUaKjsD5nuAIGWcDApTUoeyL5CevFZg3JC5uYBsyG/r/w4YMpUj
        NHicp+w2woNCATJVLNoO1Yc=
X-Google-Smtp-Source: AK7set/GwotgsUGGJrT8NBvp53IUC4qj6qO7Ly+8+IGCS8e+OHcK+s+ODAxaZ68ZV4PenA/B0IUpqw==
X-Received: by 2002:a05:6512:102d:b0:4e7:fa8a:886e with SMTP id r13-20020a056512102d00b004e7fa8a886emr2704920lfr.51.1679571472098;
        Thu, 23 Mar 2023 04:37:52 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id w9-20020ac254a9000000b004e845b49d81sm2898087lfk.140.2023.03.23.04.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:37:51 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:37:48 +0300
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
Subject: Re: [PATCH net-next 09/16] dt-bindings: net: dwmac: Prohibit
 additional props in AXI-config
Message-ID: <20230323113748.bj45qbvut2cthvyr@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-10-Sergey.Semin@baikalelectronics.ru>
 <78224241-00a3-2e8e-4763-603b27ac3b83@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78224241-00a3-2e8e-4763-603b27ac3b83@linaro.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 09:06:04AM +0100, Krzysztof Kozlowski wrote:
> On 13/03/2023 23:50, Serge Semin wrote:
> > Currently DT-schema of the AXI-bus config sub-node prohibits to have
> > unknown properties by using the unevaluatedProperties property. It's
> > overkill for the sub-node which doesn't use any combining schemas
> > keywords (allOf, anyOf, etc). Instead more natural is to use
> > additionalProperties to prohibit for that.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > index 89be67e55c3e..d1b2910b799b 100644
> > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -466,7 +466,6 @@ properties:
> >  
> >    stmmac-axi-config:
> >      type: object
> > -    unevaluatedProperties: false
> >      description:
> >        AXI BUS Mode parameters.
> >  
> > @@ -518,6 +517,8 @@ properties:
> >          description:
> >            rebuild INCRx Burst
> >  
> > +    additionalProperties: false
> 
> But why moving it? Keep the same placement.

No firm justification except that vast majority of DT bindings have
that keyword placed at the tail of the schema body. Anyway I'll get
the it back to the original line.

-Serge(y)

> 
> Best regards,
> Krzysztof
> 
