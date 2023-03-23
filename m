Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014636C67AD
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjCWMJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCWMI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:08:59 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5375A46B6;
        Thu, 23 Mar 2023 05:08:58 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id s8so27120909lfr.8;
        Thu, 23 Mar 2023 05:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679573336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xzgI+B9ASfOGNYBH0IR4jXCQ7CKwmiqjpGUIbZHwnnc=;
        b=LFKNwiWKSW7Ndn5zWY0V3TIVkQO7LGJoUbnGfHAzF6WG24W5M+VIvRUapx+q+WFgqu
         SiyZaq1BBzTjpH26yZ1+BD5RLXxCxh8nNjMJnF+CGTYpFdCpXcRkYajpbGkw1zfSivqo
         5IbuF/edaVAQ5qWwJFUnXpaJhfGHvvtuN3Idj9qkPciVMZV3kF20JpRrP/irEPtV356v
         YTIncCqa+BiKhDPKRbdtpvbYACV7gZI35YJAvAl+ch2HBhVuntntMdOtTX6Nz6EXUFm7
         +TzPJp7JG42UcAAjUTqqvbbhAuK3aC9XyJgPsXIeicQ66tAIUXpg+pjastRoG67dkUgj
         f+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679573336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzgI+B9ASfOGNYBH0IR4jXCQ7CKwmiqjpGUIbZHwnnc=;
        b=Z8eHpdCJ+GeDWSdryqygS/svudkg4BpbiVZDq82TjfBNaAUZwqVShysGCYKEKDL6ws
         qcKxLqxfwSIPbPeT74CGfpXRZM8yQL4t0T3VGHD5iO2LX1drPqxW7Spon+3Wv7rAF8NM
         y0/+t1sBi+P4waR83p24niqw+hdq2PXToWadsMAX9wr4JpiOZh+dbkKjR/BZlMkBTNRv
         Cl1wd4xv4GlUzRgrE3m8FkMZZLA3XlWtHm3ijlivtiFX8HysNLN4+oxkeb7AafuyZtN5
         iFq7CvQWKUhcy0yJ9YpMfBtUAt/rg4l83Ne8HtJ03DNN2m9LpkUB35JcHJjO96ePcv3J
         CNlA==
X-Gm-Message-State: AO0yUKXQ0v2ZgYR2TEQ6Q75u9e8LL5j2/9iHI5tPXTk6+VZMRup4rLqw
        20m14uYeK82j5PtqkWw4kWQ=
X-Google-Smtp-Source: AK7set+84k7eBxJAPoHl2JzEu70ox/d+Ysoy3SdQ5Tz3UrPm6eVSvg55ypTOmhgj5bq6t2O+AVvFgA==
X-Received: by 2002:a05:6512:249:b0:4b4:e14a:ec7d with SMTP id b9-20020a056512024900b004b4e14aec7dmr3143131lfo.17.1679573336526;
        Thu, 23 Mar 2023 05:08:56 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id p19-20020a19f013000000b004eaf9ef5e7asm422577lfc.226.2023.03.23.05.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 05:08:56 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:08:53 +0300
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
Subject: Re: [PATCH net-next 14/16] dt-bindings: net: dwmac: Use flag
 definition instead of booleans
Message-ID: <20230323120853.wse2pvknvznawxpk@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-15-Sergey.Semin@baikalelectronics.ru>
 <faf70823-f87b-ba50-ac72-3552de1cc7e3@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf70823-f87b-ba50-ac72-3552de1cc7e3@linaro.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 09:09:37AM +0100, Krzysztof Kozlowski wrote:
> On 13/03/2023 23:51, Serge Semin wrote:
> > Currently some of the boolean properties defined in the DT-schema are
> > marked to have the basic boolean type meanwhile the rest referencing the
> > /schemas/types.yaml#/definitions/flag schema. For the sake of unification
> > let's convert the first group to referencing the pre-defined flag schema.
> > Thus bindings will look a bit more coherent and the DT-bindings
> > maintainers will have a better control over the booleans defined in the
> > schema (if ever needed).
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml   | 45 ++++++++++++-------
> >  1 file changed, 30 insertions(+), 15 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > index 69be39d55403..a863b5860566 100644
> > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -120,11 +120,13 @@ properties:
> >          maximum: 12
> >  
> >        snps,rx-sched-sp:
> > -        type: boolean
> > +        $ref: /schemas/types.yaml#/definitions/flag
> >          description: Strict priority
> 

> If ever touching this, it should be other way -> boolean.

Ok. I'll drop the patch then.

-Serge(y)

> 
> Best regards,
> Krzysztof
> 
