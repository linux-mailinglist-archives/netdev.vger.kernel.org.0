Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A911969FCFE
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjBVU3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 15:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjBVU3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 15:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4402FCC2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 12:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677097750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=31LxPJZI3zdBsKK5tpOvW3uyU2wcbBKh3h1QoBUrRCs=;
        b=OPW/GlvmdPHANmW5zQs+laP1fWsTmbSmiZ2F40X1q3YTuu7TusK7HLUexz4vOwCpJudzeE
        x1JeGAWucGp9XvEcBD5TiCKVLF32zWumVwGf3+8/oSX4gMDZPV0PUWtx04Z0OYw9jTR7+H
        jnNxFfYG1wbYh46bOl67IM5pOoRUGm4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-572-RjhCvHcmPNWUsAIxi1YbOg-1; Wed, 22 Feb 2023 15:29:08 -0500
X-MC-Unique: RjhCvHcmPNWUsAIxi1YbOg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17255c4ce4fso1433675fac.18
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 12:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31LxPJZI3zdBsKK5tpOvW3uyU2wcbBKh3h1QoBUrRCs=;
        b=yWltT1+Oy0hh3la9OaLpZv4vk/CcRhjNUkTfR5O1Dhmt2wz31yXslQ62IKREln3JDi
         5nnlUOrsiRxBc/kBSlxNUqWGg9hg7xbuHCXJdrYDfGt8nN92u0Jad3YEyTMZzgcjXJnl
         jm/xGaC9BpIbdkUYKf43gE4rWBl30idAXZNNNNI0FrK89oh57gF9K9OZFWkpH+8IVz5R
         mc2tcmFAQdqadk5dKQpQiKeg1KPlX/f/ymzoS5vgfXsIK0VpR1XxnCgZOgPlvqjMKd6a
         0risdsocVQJy5Y8Js1DS/b8Ds72GgDwadNsieMx5fdcNurjStjQaeLYTtNnC45k+7sD0
         XXyQ==
X-Gm-Message-State: AO0yUKXwgebBfYav6rwQ+avvCopxyrrS3eE4TmAR7mj9kMvLkd6e1xSi
        CLZ/1yfs+bwCTl5SrNi0oOCFimyN5OTafjuJxNJho2Qi+lmBDyou3NmJp+v7k88pZZ/u3RZcOkX
        Vf+Z6Vrp46IJz3zFp
X-Received: by 2002:a05:6830:1f48:b0:68b:d7c1:d095 with SMTP id u8-20020a0568301f4800b0068bd7c1d095mr4561574oth.25.1677097748113;
        Wed, 22 Feb 2023 12:29:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+FnnF0bFHokIgYSx+T9xokiJqO8a2z1YkPriDlHMjDry+p841GTCxY+dup1Y6SZvIxGvvB7A==
X-Received: by 2002:a05:6830:1f48:b0:68b:d7c1:d095 with SMTP id u8-20020a0568301f4800b0068bd7c1d095mr4561560oth.25.1677097747836;
        Wed, 22 Feb 2023 12:29:07 -0800 (PST)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id a10-20020a9d470a000000b0068bce0cd4e1sm1362519otf.9.2023.02.22.12.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 12:29:07 -0800 (PST)
Date:   Wed, 22 Feb 2023 14:29:04 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings
 to yaml
Message-ID: <20230222202904.mhsbxnaxt3psmwr7@halaney-x13s>
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
 <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
 <1163e862-d36a-9b5e-2019-c69be41cc220@linaro.org>
 <9999a1a3-cda0-2759-f6f4-9bc7414f9ee4@linaro.org>
 <0aeb2c5e-9a5e-90c6-a974-f2a0b866d64f@linaro.org>
 <ca62fc03-8acc-73fc-3b15-bd95fe8e05a4@linaro.org>
 <CAH=2Nty1BfaTWbE-PZQPiRtAco=5xhvJT3QbpqYsABxZxBzF3w@mail.gmail.com>
 <2e68d64f-766c-0a52-9df8-74f0681a5973@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e68d64f-766c-0a52-9df8-74f0681a5973@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 11:32:58AM +0200, Krzysztof Kozlowski wrote:
> On 03/10/2022 10:29, Bhupesh Sharma wrote:
> > On Sun, 2 Oct 2022 at 13:24, Krzysztof Kozlowski
> > <krzysztof.kozlowski@linaro.org> wrote:
> >>
> >> On 01/10/2022 14:51, Bhupesh Sharma wrote:
> >>>>> Right, most of them are to avoid the make dtbs_check errors / warnings
> >>>>> like the one mentioned above.
> >>>>
> >>>> All of them should not be here.
> >>>
> >>> I guess only 'snps,reset-gpio' need not be replicated here, as for
> >>> others I still see 'dtbs_check' error, if they are not replicated here:
> >>>
> >>>
> >>> arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated
> >>> properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth',
> >>> 'tx-fifo-depth' were unexpected)
> >>>       From schema: /Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> >>>
> >>> Am I missing something here?
> >>
> >> Probably the snps,dwmac schema failed. It is then considered
> >> unevaluated, so such properties are unknown for qcom,ethqos schema. Run
> >> check with snps,dwmac and fix all errors first.
> >
> > Running dt_binding_check DT_SCHEMA_FILES=net/snps,dwmac.yaml
> > reports no error currently.
>
> Then it's something in your commits. I don't know what you wrote, as you
> did not sent a commit. I cannot reproduce your errors after removing
> unneeded power-domains.
>
> Just to clarify - I am testing only the dt_binding_check (so only the
> examples - I assume they are meaningful).

Just a little note before I forget..

I picked this up yesterday (in prep for adding sa8540p support here),
and noticed the same thing as Bhupesh when validating dtbs with
the requested changes (not duplicating snsp,dwmac.yaml). I ended up
tracking it down to a (fixed) bug in dtschema:

    https://github.com/devicetree-org/dt-schema/commit/e503ec1115345bdfa06b96c9d6c4496457cbd75b

And a little test output showing before and after (fix is in the 2022.12
release):

    (dtschema-2022.11) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % make CHECK_DTBS=y DT_SCHEMA_FILES=/net/qcom,ethqos.yaml qcom/sm8150-hdk.dtb
      LINT    Documentation/devicetree/bindings
      CHKDT   Documentation/devicetree/bindings/processed-schema.json
      SCHEMA  Documentation/devicetree/bindings/processed-schema.json
      DTC_CHK arch/arm64/boot/dts/qcom/sm8150-hdk.dtb
    /home/ahalaney/git/redhat/stmmac/arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth', 'snps,tso', 'tx-fifo-depth' were unexpected)
        From schema: /home/ahalaney/git/redhat/stmmac/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
    (dtschema-2022.11) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % pip3 list | grep dtschema
    dtschema         2022.11
    (dtschema-2022.11) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] %

    dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % pip3 list | grep dtschema
    dtschema         2023.1
    (dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % make CHECK_DTBS=y DT_SCHEMA_FILES=/net/qcom,ethqos.yaml qcom/sm8150-hdk.dtb
      LINT    Documentation/devicetree/bindings
      CHKDT   Documentation/devicetree/bindings/processed-schema.json
      SCHEMA  Documentation/devicetree/bindings/processed-schema.json
      DTC_CHK arch/arm64/boot/dts/qcom/sm8150-hdk.dtb
    (dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] %


I'll go ahead and make the adjustments and pull this series into mine
adding sa8540p support, thanks for starting it!

- Andrew

