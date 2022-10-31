Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE9613DC2
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 19:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiJaSvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 14:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiJaSvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 14:51:24 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E5E13EBB;
        Mon, 31 Oct 2022 11:51:17 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id p127so13670080oih.9;
        Mon, 31 Oct 2022 11:51:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RndPaegPky68KZOdumOMylBv9kWNrkQoLXpeXbebU08=;
        b=FHJL26nrBO7Y+ooYGT8JNwBVhk5kEDmH5ZkJa+x3N7fmDsrryTfLmFbVK8pI+1zUBi
         6Z/uze63re3oi/u45Sj1v4pmQi7JQTX+D4QGRE0mHijV7pY1Y3Mk9cTCMqJL4frMBrR4
         SfhDLYs4kXYDucLxE9NE2naToeTvFoe0LrXqYtbfMsEErVm8I5WsMW2w+rhDRJaXIBcv
         o/agymsecg1xOov3RIXRhJLKVQXZipKXGOyE13WVB0w5df+HsTtSfz7b4wJLyEQ3UEH7
         Y5x+68mDb3OV8BfEzatVolJ6BLGUSs3gBs7qWMtOej9cv/BAt2N8omVutmQuU0vKgevA
         INCg==
X-Gm-Message-State: ACrzQf0SEkFgs7GJ7R3x5YZjhjVg0PswnnHaFrPMdnM68mCc0Zw5AVKJ
        wV3RP6OFsaI7TZHijLAOAw==
X-Google-Smtp-Source: AMsMyM6v/cJPflJtabY+T+O+Vhy37yW2suHI3E7cGffQ2s7Uq9cqhT/JjWVLuNAjcq9ze5HnDlOyGQ==
X-Received: by 2002:a05:6808:120c:b0:351:6d17:1845 with SMTP id a12-20020a056808120c00b003516d171845mr7565039oil.254.1667242276384;
        Mon, 31 Oct 2022 11:51:16 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k9-20020a056870350900b0013191fdeb9bsm3411798oah.38.2022.10.31.11.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:51:15 -0700 (PDT)
Received: (nullmailer pid 3248529 invoked by uid 1000);
        Mon, 31 Oct 2022 18:51:16 -0000
Date:   Mon, 31 Oct 2022 13:51:16 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Del Regno <angelogioacchino.delregno@somainline.org>,
        linux-arm-msm@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Taniya Das <tdas@codeaurora.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Martin Botka <martin.botka@somainline.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        UNGLinuxDriver@microchip.com, Jonathan Marek <jonathan@marek.ca>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Stephen Boyd <sboyd@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        krishna Lanka <quic_vamslank@quicinc.com>,
        Govind Singh <govinds@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: clock: qcom,gcc-ipq8074: use common GCC
 schema
Message-ID: <166724227425.3248438.11996329262779132119.robh@kernel.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 28 Oct 2022 10:03:24 -0400, Krzysztof Kozlowski wrote:
> Reference common Qualcomm GCC schema to remove common pieces.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../bindings/clock/qcom,gcc-ipq8074.yaml      | 25 +++----------------
>  1 file changed, 4 insertions(+), 21 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
