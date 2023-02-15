Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E03697CE3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 14:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbjBONLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 08:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjBONLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 08:11:44 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18101710
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 05:11:42 -0800 (PST)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 06D1A3F4B7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676466701;
        bh=1XdYb1DRbOmlAI6DRkBJIyrIK+/5tdCGTTdbxhb+wmw=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=mBoW16fVkEwXTxRnSNlMI4i0CwJNHPgXgs9XoZ3Gz52zAbyHNX7xo7E9/g3ZSCshY
         JCVik0cxPmdu+1CpkzlBRYX1OVC/nToz3fwt7OVKVjnA8ZoEk1KDEpAy9ts+0R0kaR
         N4HlRKOR/1xp5oCHzmnb3Hor+3nHAGPQK4tP5RRFqNBk+1htCtgdxOod4IvvjYl6F+
         0AUeBBlYK6ICVh6V/VhYfXUk+YwAWUD7jhcknezEZI+p1VmzAi3xNpT1H/Sjp3ybtl
         UEQ6aBxNVrUBny8sni+5C8hQXi17rCyRXqI2quJLe539sTK8mdAUnFzQhmiT9iPo/x
         BqPTO+GEk3jDg==
Received: by mail-qt1-f200.google.com with SMTP id c14-20020ac87d8e000000b003ba2d72f98aso11094366qtd.10
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 05:11:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XdYb1DRbOmlAI6DRkBJIyrIK+/5tdCGTTdbxhb+wmw=;
        b=ViIdDoitn3D0BsWTJ6QOQsXQRu5uxJWZZOGWT+seulWhAiGJ02ZAtPtovivOLW5BNG
         6vcijh7dLB+Ct0g5hSRnbwV0ixoYWf1LrguFXewu1s1jaGRdYHPdGbNDn+bRcdVoz40p
         +Wk1++E/XABFf+bX9KMp9dHpnoYp2jBStVSLFZst0kPg1EOAZDXU/0g+vLdLPQ29jLta
         b/UQnzfic5sPtPSOh14Fz1On8iTG+VRF3OHb8aMa0laa7JBWPTbcvvu2GrllNd4okqo7
         Wdl0++D8uHSf3S8h5Ynpz33dzug2noQVSz7b7qJlqi9CjfV/uxnuqliYWhv9/9NvDPtA
         SdvQ==
X-Gm-Message-State: AO0yUKVzZKlHB80J/ap7tt93Pwohg4DrI220W66NnBkpqmtOwFycwIj5
        odQPce9G+nsYL8wJ3fvJuj8mfgEL9o860eZDLGeG2JGDj6cRuKp8YZpN3HdA2VM74w2E4C/Hcb3
        d6El4X26NLsLNpHA7l9h8A56GeqYpuZdGzUQXZLSfD26tv4zP8A==
X-Received: by 2002:a05:622a:164f:b0:3bc:e3a8:d1d6 with SMTP id y15-20020a05622a164f00b003bce3a8d1d6mr228754qtj.229.1676466699841;
        Wed, 15 Feb 2023 05:11:39 -0800 (PST)
X-Google-Smtp-Source: AK7set+4/1NxoBcvUdWQnW9B5yPBwHcyWHA8dOVvJArdaItgCToDNjAmHnj0L1BgI9mhCHcGqlTdul+lrgFnVADu40o=
X-Received: by 2002:a05:622a:164f:b0:3bc:e3a8:d1d6 with SMTP id
 y15-20020a05622a164f00b003bce3a8d1d6mr228728qtj.229.1676466699567; Wed, 15
 Feb 2023 05:11:39 -0800 (PST)
MIME-Version: 1.0
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-2-cristian.ciocaltea@collabora.com> <Y+vxw28NWPfaW7ql@spud>
In-Reply-To: <Y+vxw28NWPfaW7ql@spud>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Wed, 15 Feb 2023 14:11:22 +0100
Message-ID: <CAJM55Z_x3omY9DQtxPUgLX0NKEm3PCXDkFFDVAzG7opFLsZX+A@mail.gmail.com>
Subject: Re: [PATCH 01/12] dt-bindings: riscv: sifive-ccache: Add compatible
 for StarFive JH7100 SoC
To:     Conor Dooley <conor@kernel.org>
Cc:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 at 21:42, Conor Dooley <conor@kernel.org> wrote:
>
> Hey all,
>
> On Sat, Feb 11, 2023 at 05:18:10AM +0200, Cristian Ciocaltea wrote:
> > Document the compatible for the SiFive Composable Cache Controller found
> > on the StarFive JH7100 SoC.
> >
> > This also requires extending the 'reg' property to handle distinct
> > ranges, as specified via 'reg-names'.
> >
> > Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> > ---
> >  .../bindings/riscv/sifive,ccache0.yaml        | 28 ++++++++++++++++++-
> >  1 file changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
> > index 31d20efaa6d3..2b864b2f12c9 100644
> > --- a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
> > +++ b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
> > @@ -25,6 +25,7 @@ select:
> >            - sifive,ccache0
> >            - sifive,fu540-c000-ccache
> >            - sifive,fu740-c000-ccache
> > +          - starfive,jh7100-ccache
> >
> >    required:
> >      - compatible
> > @@ -37,6 +38,7 @@ properties:
> >                - sifive,ccache0
> >                - sifive,fu540-c000-ccache
> >                - sifive,fu740-c000-ccache
> > +              - starfive,jh7100-ccache
> >            - const: cache
> >        - items:
> >            - const: starfive,jh7110-ccache
> > @@ -70,7 +72,13 @@ properties:
> >        - description: DirFail interrupt
> >
> >    reg:
> > -    maxItems: 1
> > +    minItems: 1
> > +    maxItems: 2
> > +
> > +  reg-names:
> > +    items:
> > +      - const: control
> > +      - const: sideband
>
> So why is this called "sideband"?
> In the docs for the JH7100 it is called LIM & it's called LIM in our
> docs for the PolarFire SoC (at the same address btw) and we run the HSS
> out of it! LIM being "loosely integrated memory", which by the limit
> hits on Google may be a SiFive-ism?
>
> I'm not really sure if adding it as a "reg" section is the right thing
> to do as it's not "just" a register bank.
> Perhaps Rob/Krzysztof have a take on that one?

Yes, this seems to be a leftover I didn't manage to clean up yet. The
"sideband" range is called L2 LIM in the datasheet and seems to be a
way to use the cache directly. The Sifive docs read "When cache ways
are disabled, they are addressable in the L2 Loosely-Integrated Memory
(L2 LIM) address space [..]". This feature is not used by Linux on the
JH7100, so can just be removed here.

/Emil

> >
> >    next-level-cache: true
> >
> > @@ -89,6 +97,7 @@ allOf:
> >            contains:
> >              enum:
> >                - sifive,fu740-c000-ccache
> > +              - starfive,jh7100-ccache
> >                - starfive,jh7110-ccache
> >                - microchip,mpfs-ccache
> >
> > @@ -106,12 +115,29 @@ allOf:
> >              Must contain entries for DirError, DataError and DataFail signals.
> >            maxItems: 3
> >
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: starfive,jh7100-ccache
> > +
> > +    then:
> > +      properties:
> > +        reg:
> > +          maxItems: 2
> > +
> > +    else:
> > +      properties:
> > +        reg:
> > +          maxItems: 1
> > +
> >    - if:
> >        properties:
> >          compatible:
> >            contains:
> >              enum:
> >                - sifive,fu740-c000-ccache
> > +              - starfive,jh7100-ccache
> >                - starfive,jh7110-ccache
> >
> >      then:
> > --
> > 2.39.1
> >
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
