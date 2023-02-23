Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720746A1024
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 20:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjBWTJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 14:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjBWTJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 14:09:34 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1069031E00
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 11:09:33 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id i9so14843564lfc.6
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 11:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ki/+8rKjqaLiO1EXm/3PKBzNTnhWcpNouZYryd40ZXw=;
        b=xIuTFUJwmjUmo/ZY7Efw7KXI4HDpZwPevKdH4zReUGBB530x2VTfEXIap7soq0xrkt
         fLxo3HUQXeuriXYqhotDJepEW6dKbiKyscYKjciNlfpIQ7fIuhqj74/8rDCysXnnO0JS
         4Rf3qTXcAeSv7w9CaUQ4B3flmF0e7QuqGF5lBxjmALTvorOeudLvwvHwKkIWAMFH6FGY
         RzPjMj1fh5sESLWEVhNtWl4+eoCT4hsOhoXtes5Embqey5/DrfNuKrjAedYKpFs1dksR
         kK0cf+naL7g3BnH+Zg0cDxH484/qNt5tBW1W5g+ElnpeGmP/16EUhsw6If9ri8NPv5Js
         WtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ki/+8rKjqaLiO1EXm/3PKBzNTnhWcpNouZYryd40ZXw=;
        b=8JBn6XfHT/XfXL23aFqesYkdDNdveOS9ka10dPPxrFlLAhgFXT02xNiSBmcCKJYBVC
         CLN+LP9FLyeq60nE4Yo83KJhRH1X++YsrGRMj8iNQPoDMSrNMiOZWsgPibyZhlRt6szD
         Bce4+U3SYDhsqpPq+XlvB8gQYwc3QSBy65J+zlISQNNycpsnm5u36SKrJTZ4XYQhQuxI
         1xYhHlEpk1lyupzLhtta1Lj+5AX0fS/XknyX31gKNP9gDYiVGVhCkS80vKbZnX1Zr4l7
         JEmobTSFHB3lkSLBCNcRX8eXx57rco8tPypxWWZFpU+RWKosu5+eV9feYcnHI74Vzz0K
         A8Gg==
X-Gm-Message-State: AO0yUKWcGR6rmJuNPF054uLGbKZyRACvsqHpBQQEy6GItDZ5uIGSMFiK
        3oN+4Z0zPknEKLXX2u+KugEG/L8Yelng12R2ToEoXQ==
X-Google-Smtp-Source: AK7set+1Snm8QmjNNVo8GqQflRkjIgua4+rtwYxMZTP19pOBlpTETTnalWgFkXRsDT/zGvsFyvQiZm0rEv+ZUq9Zrys=
X-Received: by 2002:ac2:5387:0:b0:4d5:ca32:7bbb with SMTP id
 g7-20020ac25387000000b004d5ca327bbbmr4069994lfh.2.1677179371151; Thu, 23 Feb
 2023 11:09:31 -0800 (PST)
MIME-Version: 1.0
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org> <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
 <1163e862-d36a-9b5e-2019-c69be41cc220@linaro.org> <9999a1a3-cda0-2759-f6f4-9bc7414f9ee4@linaro.org>
 <0aeb2c5e-9a5e-90c6-a974-f2a0b866d64f@linaro.org> <ca62fc03-8acc-73fc-3b15-bd95fe8e05a4@linaro.org>
 <CAH=2Nty1BfaTWbE-PZQPiRtAco=5xhvJT3QbpqYsABxZxBzF3w@mail.gmail.com>
 <2e68d64f-766c-0a52-9df8-74f0681a5973@linaro.org> <20230222202904.mhsbxnaxt3psmwr7@halaney-x13s>
In-Reply-To: <20230222202904.mhsbxnaxt3psmwr7@halaney-x13s>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Fri, 24 Feb 2023 00:39:19 +0530
Message-ID: <CAH=2NtzJViZ2e7aw9Ej67=XRrWOPzGrq1gccCsFiHBzRDZxmmQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 at 01:59, Andrew Halaney <ahalaney@redhat.com> wrote:
>
> On Mon, Oct 03, 2022 at 11:32:58AM +0200, Krzysztof Kozlowski wrote:
> > On 03/10/2022 10:29, Bhupesh Sharma wrote:
> > > On Sun, 2 Oct 2022 at 13:24, Krzysztof Kozlowski
> > > <krzysztof.kozlowski@linaro.org> wrote:
> > >>
> > >> On 01/10/2022 14:51, Bhupesh Sharma wrote:
> > >>>>> Right, most of them are to avoid the make dtbs_check errors / warnings
> > >>>>> like the one mentioned above.
> > >>>>
> > >>>> All of them should not be here.
> > >>>
> > >>> I guess only 'snps,reset-gpio' need not be replicated here, as for
> > >>> others I still see 'dtbs_check' error, if they are not replicated here:
> > >>>
> > >>>
> > >>> arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated
> > >>> properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth',
> > >>> 'tx-fifo-depth' were unexpected)
> > >>>       From schema: /Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> > >>>
> > >>> Am I missing something here?
> > >>
> > >> Probably the snps,dwmac schema failed. It is then considered
> > >> unevaluated, so such properties are unknown for qcom,ethqos schema. Run
> > >> check with snps,dwmac and fix all errors first.
> > >
> > > Running dt_binding_check DT_SCHEMA_FILES=net/snps,dwmac.yaml
> > > reports no error currently.
> >
> > Then it's something in your commits. I don't know what you wrote, as you
> > did not sent a commit. I cannot reproduce your errors after removing
> > unneeded power-domains.
> >
> > Just to clarify - I am testing only the dt_binding_check (so only the
> > examples - I assume they are meaningful).
>
> Just a little note before I forget..
>
> I picked this up yesterday (in prep for adding sa8540p support here),
> and noticed the same thing as Bhupesh when validating dtbs with
> the requested changes (not duplicating snsp,dwmac.yaml). I ended up
> tracking it down to a (fixed) bug in dtschema:
>
>     https://github.com/devicetree-org/dt-schema/commit/e503ec1115345bdfa06b96c9d6c4496457cbd75b
>
> And a little test output showing before and after (fix is in the 2022.12
> release):
>
>     (dtschema-2022.11) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % make CHECK_DTBS=y DT_SCHEMA_FILES=/net/qcom,ethqos.yaml qcom/sm8150-hdk.dtb
>       LINT    Documentation/devicetree/bindings
>       CHKDT   Documentation/devicetree/bindings/processed-schema.json
>       SCHEMA  Documentation/devicetree/bindings/processed-schema.json
>       DTC_CHK arch/arm64/boot/dts/qcom/sm8150-hdk.dtb
>     /home/ahalaney/git/redhat/stmmac/arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth', 'snps,tso', 'tx-fifo-depth' were unexpected)
>         From schema: /home/ahalaney/git/redhat/stmmac/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>     (dtschema-2022.11) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % pip3 list | grep dtschema
>     dtschema         2022.11
>     (dtschema-2022.11) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] %
>
>     dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % pip3 list | grep dtschema
>     dtschema         2023.1
>     (dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % make CHECK_DTBS=y DT_SCHEMA_FILES=/net/qcom,ethqos.yaml qcom/sm8150-hdk.dtb
>       LINT    Documentation/devicetree/bindings
>       CHKDT   Documentation/devicetree/bindings/processed-schema.json
>       SCHEMA  Documentation/devicetree/bindings/processed-schema.json
>       DTC_CHK arch/arm64/boot/dts/qcom/sm8150-hdk.dtb
>     (dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] %
>
>
> I'll go ahead and make the adjustments and pull this series into mine
> adding sa8540p support, thanks for starting it!

Thanks Andrew. Please feel free to add it to your series.

Regards,
Bhupesh
