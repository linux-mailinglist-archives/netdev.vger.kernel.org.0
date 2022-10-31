Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE62613DF1
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 20:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJaTBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 15:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaTBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 15:01:05 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D5E64E5;
        Mon, 31 Oct 2022 12:01:04 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id r187so13712844oia.8;
        Mon, 31 Oct 2022 12:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97OeCNtvARFMLHt3Ap1ZoXYFgbmXk1P85smxt9Y1vS4=;
        b=ChJyjd3rnBBqgE2l7KjO60iXRzc/qPVFf253RPtM5yl7lnQNhJCA5qWndMCh2mq7H9
         AHXKQjJAbAggQi2bHbbjqp0MCNaAnLJkfoSUaEkygU2RVzyMQfAprgLVg9MO3PyCpS9W
         w0mfgG12Go4Fo49JEUnAnve891CqSei/ELr+2fYgQDXEm6NuM/J8LwrhCM4jA01MVibl
         26FGfL3NE4EHwli+5v406gml/PsHO4Yw4fIGCXHFHolBuEJYvc8ZugNtLaZyFLRsA3F6
         +OPwhavtuuA+yi/1i4+rVUuWFBviAdDDM5FGP2pfZ893lvk+8QLevDyvKruwAn9DJ9RA
         /3dA==
X-Gm-Message-State: ACrzQf3yoYQ2E0jlbJASDn3yk+qpsoz70Ka3ovDdLeuuqUWw86z8Jj3o
        2tKCUltEHQfOcDKm1y81Tg==
X-Google-Smtp-Source: AMsMyM4tZ4U7APjHhUeEZUR88VKHJ79ebC4Z8DAfRPUK25IfNsrRoJMYHULuY3pEru30WN830H99Ow==
X-Received: by 2002:a05:6808:1248:b0:354:2c04:c35b with SMTP id o8-20020a056808124800b003542c04c35bmr15126786oiv.143.1667242863194;
        Mon, 31 Oct 2022 12:01:03 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o4-20020acabe04000000b0035494c1202csm2584831oif.42.2022.10.31.12.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 12:01:02 -0700 (PDT)
Received: (nullmailer pid 3259256 invoked by uid 1000);
        Mon, 31 Oct 2022 19:01:03 -0000
Date:   Mon, 31 Oct 2022 14:01:03 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Martin Botka <martin.botka@somainline.org>,
        Taniya Das <tdas@codeaurora.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        krishna Lanka <quic_vamslank@quicinc.com>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Del Regno <angelogioacchino.delregno@somainline.org>,
        Robert Foss <robert.foss@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Govind Singh <govinds@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: clock: qcom: cleanup
Message-ID: <20221031190103.GA3257132-robh@kernel.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
 <20221028140326.43470-3-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028140326.43470-3-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 10:03:26AM -0400, Krzysztof Kozlowski wrote:
> Clean the Qualcomm SoCs clock bindings:

Perhaps at least 'Clean-up titles and descriptions' for the subject.

> 1. Drop redundant "bindings" in title.
> 2. Correct language grammar "<independent clause without verb>, which
>    supports" -> "provides".
> 3. Use full path to the bindings header, so tools can validate it.
> 4. Drop quotes where not needed.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../bindings/clock/qcom,a53pll.yaml           |  2 +-
>  .../devicetree/bindings/clock/qcom,a7pll.yaml |  2 +-
>  .../bindings/clock/qcom,aoncc-sm8250.yaml     |  2 +-
>  .../bindings/clock/qcom,audiocc-sm8250.yaml   |  2 +-
>  .../bindings/clock/qcom,camcc-sm8250.yaml     |  6 ++--
>  .../bindings/clock/qcom,dispcc-sm6125.yaml    |  9 +++---
>  .../bindings/clock/qcom,dispcc-sm6350.yaml    |  8 ++---
>  .../bindings/clock/qcom,dispcc-sm8x50.yaml    | 14 ++++-----
>  .../bindings/clock/qcom,gcc-apq8064.yaml      | 18 +++++------
>  .../bindings/clock/qcom,gcc-apq8084.yaml      | 10 +++----
>  .../bindings/clock/qcom,gcc-ipq8064.yaml      | 18 +++++------
>  .../bindings/clock/qcom,gcc-ipq8074.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-msm8660.yaml      | 12 ++++----
>  .../bindings/clock/qcom,gcc-msm8909.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-msm8916.yaml      | 16 +++++-----
>  .../bindings/clock/qcom,gcc-msm8976.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-msm8994.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-msm8996.yaml      |  7 ++---
>  .../bindings/clock/qcom,gcc-msm8998.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-other.yaml        | 30 +++++++++----------
>  .../bindings/clock/qcom,gcc-qcm2290.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-qcs404.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sc7180.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sc7280.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sc8180x.yaml      |  9 +++---
>  .../bindings/clock/qcom,gcc-sc8280xp.yaml     |  7 ++---
>  .../bindings/clock/qcom,gcc-sdm660.yaml       |  8 ++---
>  .../bindings/clock/qcom,gcc-sdm845.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sdx55.yaml        |  7 ++---
>  .../bindings/clock/qcom,gcc-sdx65.yaml        |  9 +++---
>  .../bindings/clock/qcom,gcc-sm6115.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sm6125.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sm6350.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sm8150.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sm8250.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sm8350.yaml       |  9 +++---
>  .../bindings/clock/qcom,gcc-sm8450.yaml       |  9 +++---
>  .../devicetree/bindings/clock/qcom,gcc.yaml   |  6 ++--
>  .../bindings/clock/qcom,gpucc-sdm660.yaml     |  4 +--
>  .../bindings/clock/qcom,gpucc-sm8350.yaml     |  9 +++---
>  .../devicetree/bindings/clock/qcom,gpucc.yaml | 22 +++++++-------
>  .../devicetree/bindings/clock/qcom,mmcc.yaml  |  4 +--
>  .../bindings/clock/qcom,msm8998-gpucc.yaml    |  8 ++---
>  .../bindings/clock/qcom,q6sstopcc.yaml        |  2 +-
>  .../bindings/clock/qcom,qcm2290-dispcc.yaml   |  8 ++---
>  .../bindings/clock/qcom,sc7180-camcc.yaml     |  9 +++---
>  .../bindings/clock/qcom,sc7180-dispcc.yaml    |  8 ++---
>  .../clock/qcom,sc7180-lpasscorecc.yaml        |  9 +++---
>  .../bindings/clock/qcom,sc7180-mss.yaml       |  7 ++---
>  .../bindings/clock/qcom,sc7280-camcc.yaml     |  6 ++--
>  .../bindings/clock/qcom,sc7280-dispcc.yaml    |  8 ++---
>  .../bindings/clock/qcom,sc7280-lpasscc.yaml   |  9 +++---
>  .../clock/qcom,sc7280-lpasscorecc.yaml        | 12 ++++----
>  .../bindings/clock/qcom,sdm845-camcc.yaml     |  8 ++---
>  .../bindings/clock/qcom,sdm845-dispcc.yaml    |  8 ++---
>  .../bindings/clock/qcom,sm6115-dispcc.yaml    |  7 ++---
>  .../bindings/clock/qcom,sm6375-gcc.yaml       |  9 +++---
>  .../bindings/clock/qcom,sm8450-camcc.yaml     |  8 ++---
>  .../bindings/clock/qcom,sm8450-dispcc.yaml    |  7 ++---
>  .../bindings/clock/qcom,videocc.yaml          | 20 ++++++-------
>  60 files changed, 258 insertions(+), 289 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
