Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080856C6BF6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjCWPMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjCWPMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:12:07 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6979319C44;
        Thu, 23 Mar 2023 08:11:35 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id k37so15252806lfv.0;
        Thu, 23 Mar 2023 08:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679584291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=09gF+ci4EZ7xKNHFBN4nQXrjScsnzrqt/YgXpgBpcd0=;
        b=Mu76RFZOyAfrq9LEOuqynAliFMXq6UNacOyT2uAPTpnq5G3H+re0Cx4K/gGwiBMVIi
         c/cB37JF5RoQfM4k+LLFb0flTYpNLJD1E9OqFxtJc9XNGb0f6Chyw3Ax/hYXAsgNQEmM
         hPkLk/8WJgpOVjkfW2By4WK6f18UAW+IynBO9hIT17PcpBC79JaazKDFsOnZr2I104Mh
         VSB05qI7RSyU3URsvUBR8qornl8zwj0iyQgPOIpbCqaq0vqoPbaClmMYGGUOgLuevuOT
         kWOtDMygByiviB7puF3lgqpj2y4ovP3fvmPiV2jzjaRFe43U7jLJwRdZycaz7ztObeHH
         B6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09gF+ci4EZ7xKNHFBN4nQXrjScsnzrqt/YgXpgBpcd0=;
        b=jyklPVTD9e1NT+fbnv834QqdaGjqeJhnHEc2IdaXf1f1vThUcHZDqm4lH9ZNByDKuu
         VGj3BTV5xb6M19zoUsaeLVZEZyz105QuA2Kq6Gtp0p4p8EBWtWqzsQagzUj4NfZV30br
         FcWLEqjXnqO8nAdje1O5IaL0cG6EWWMhCjO5RT/mwNcs1K0jG1L2lSM/ebZZg4lmR4vQ
         eGqGO8SHGG3JFDxoUSOqzKND6TiXrqmFQSMy4UHVhLg9cVCDqZo75mMfyxGyDaBq70O6
         Y4rDLA2L69ImOw05ObZTuPxGqvVyQP13J5AzQMcdh5avxjcoKwKscd0iHucuoAp674DX
         B92w==
X-Gm-Message-State: AO0yUKUMh9fCpgAzme4oNJfcStit5L548xwiE3a/jd6xwHeY2zAht21a
        7R2KYY6MHBNt9xtKpyb8lW8=
X-Google-Smtp-Source: AK7set8+y6nFsaRhX1UdZartcuOV9lCKqA6Fzy/bfBfHkNjRTDXtDL4DUFOei4x0Jj1AQNWUtFdkzA==
X-Received: by 2002:ac2:4c39:0:b0:4ea:e688:a04a with SMTP id u25-20020ac24c39000000b004eae688a04amr2864973lfq.66.1679584291452;
        Thu, 23 Mar 2023 08:11:31 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id w19-20020ac24433000000b004eb00c0d417sm150066lfl.130.2023.03.23.08.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:10:47 -0700 (PDT)
Date:   Thu, 23 Mar 2023 18:10:22 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
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
Subject: Re: [PATCH net-next 15/16] dt-bindings: net: dwmac: Simplify MTL
 queue props dependencies
Message-ID: <20230323151022.q5h6rf3azbncfid3@mobilestation>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-16-Sergey.Semin@baikalelectronics.ru>
 <20230317205604.GA2723387-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317205604.GA2723387-robh@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:56:04PM -0500, Rob Herring wrote:
> On Tue, Mar 14, 2023 at 01:51:02AM +0300, Serge Semin wrote:
> > Currently the Tx/Rx queues properties interdependencies are described by
> > means of the pattern: "if: required: X, then: properties: Y: false, Z:
> > false, etc". Due to very unfortunate MTL Tx/Rx queue DT-node design the
> > resultant sub-nodes schemas look very bulky and thus hard to read. The
> > situation can be improved by using the "allOf:/oneOf: required: X,
> > required: Y, etc" pattern instead thus getting shorter and a bit easier to
> > comprehend constructions.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > 
> > ---
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> > 
> > Note the solution can be shortened out a bit further by replacing the
> > single-entry allOf statements with just the "not: required: etc" pattern.
> > But in order to do that the DT-schema validation tool must be fixed like
> > this:
> > 
> > --- a/meta-schemas/nodes.yaml	2021-02-08 14:20:56.732447780 +0300
> > +++ b/meta-schemas/nodes.yaml	2021-02-08 14:21:00.736492245 +0300
> > @@ -22,6 +22,7 @@
> >      - unevaluatedProperties
> >      - deprecated
> >      - required
> > +    - not
> >      - allOf
> >      - anyOf
> >      - oneOf
> 

> This should be added regardless. Can you send a patch to devicetree-spec 
> or a GH PR. But I'd skip using that here for now because then we require 
> a new version of dtschema.

Ok. I'll send the patch to the devicetree-spec mailing list.

* Note meta-schemas/base.yaml will be fixed in the similar way.

-Serge(y)

> 
> Rob
