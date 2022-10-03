Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C355F2C59
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJCItP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiJCIs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:48:58 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B26247
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 01:29:42 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id q14so8771120lfo.11
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 01:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=XZiDx2g7aXKR9agqFK0ZQyqnnudlz/UN1Lm6FTwoFUM=;
        b=VYiut/UPgayYZjKj8w/2DI6z8StJj58gr/3IeYSdNO9Ps0c3+W39pR1Ja1BCqabJ3b
         M6VdDhBF/HV93RlytNRCOY5bF/WKpRxx+WWqYkhTjx5+VLiI7kgGxpKYbRUFtvWo8eqJ
         qxKrqeSKJd681hNva1vZP2Ku2i8wjOhFZkcD1rD2Tzu0ISK3+oLWEunyqgTJejlKfjie
         uX0RAnJmBE50NLywWwpfMZUCe0SO1tJu11pZ1vyOzdhvEpajYCNlkIj7Hqg5mn23Pkys
         8YLtXKvNlTFQn6bQDja8Ur0wKZSMGeLjyTgq2g4OI7jVc2wR0Yzktmptxs6bbLTe4oO1
         +QHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=XZiDx2g7aXKR9agqFK0ZQyqnnudlz/UN1Lm6FTwoFUM=;
        b=a8Uax9LeVI8vsxVmsclCMXhvojmHqp0Al+q5CcyTAR2wwfz2xieuxMnYujBI2fpeF8
         uZ5QT2FXkT6Ht/QiAQ/qwqQuzBsS8Q6lJQjPOpDPB/HJs0yCturq9CSl0Agm0VWzaCqZ
         k2X63uP04qzRZTs+FWETz03jVX1N/akERuTcrq2YGDqe3BlLj+7hIwAnFOVm5gV60nAE
         1MEMqXcQScq51M2EcB+p38Yq4C3AfO3zNpRuhsOePvpv6arCDNSLP00k0OXAtn1nMZgd
         rym7OJTfrCTNdLubTbH4WIMuWXnTp44DttvI2COU49Nojhlt+Vpa/eXqvRCOYQeQseYp
         5XXw==
X-Gm-Message-State: ACrzQf1IGDoMGzGIFWZNIfM9xSzdfsA1FXh1haunqtTnZRzJ94A0fQcb
        m6JA3SzNh09LH1qzVL5/6siYxK38wYQEbyU8ZSKA/Q==
X-Google-Smtp-Source: AMsMyM5k/Q4Z91/nCdcKkyrlnQEl0gr7xh2MgZ9rvBDyonQOIHzOSOTMJZH5KtWahDt6uNZcyJq/FCmzp13hgyK7JgM=
X-Received: by 2002:ac2:47f7:0:b0:4a2:2a58:3cc0 with SMTP id
 b23-20020ac247f7000000b004a22a583cc0mr2723764lfp.150.1664785780685; Mon, 03
 Oct 2022 01:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org> <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
 <1163e862-d36a-9b5e-2019-c69be41cc220@linaro.org> <9999a1a3-cda0-2759-f6f4-9bc7414f9ee4@linaro.org>
 <0aeb2c5e-9a5e-90c6-a974-f2a0b866d64f@linaro.org> <ca62fc03-8acc-73fc-3b15-bd95fe8e05a4@linaro.org>
In-Reply-To: <ca62fc03-8acc-73fc-3b15-bd95fe8e05a4@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 3 Oct 2022 13:59:27 +0530
Message-ID: <CAH=2Nty1BfaTWbE-PZQPiRtAco=5xhvJT3QbpqYsABxZxBzF3w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Oct 2022 at 13:24, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 01/10/2022 14:51, Bhupesh Sharma wrote:
> >>> Right, most of them are to avoid the make dtbs_check errors / warnings
> >>> like the one mentioned above.
> >>
> >> All of them should not be here.
> >
> > I guess only 'snps,reset-gpio' need not be replicated here, as for
> > others I still see 'dtbs_check' error, if they are not replicated here:
> >
> >
> > arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated
> > properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth',
> > 'tx-fifo-depth' were unexpected)
> >       From schema: /Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> >
> > Am I missing something here?
>
> Probably the snps,dwmac schema failed. It is then considered
> unevaluated, so such properties are unknown for qcom,ethqos schema. Run
> check with snps,dwmac and fix all errors first.

Running dt_binding_check DT_SCHEMA_FILES=net/snps,dwmac.yaml
reports no error currently.

Thanks.
