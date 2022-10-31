Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57200613DE2
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJaS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJaS5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 14:57:38 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5DEE83;
        Mon, 31 Oct 2022 11:57:37 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id r13-20020a056830418d00b0065601df69c0so7260678otu.7;
        Mon, 31 Oct 2022 11:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDlfsp4Z5dv3KOOJ8RIYeDVzw6SpbAuGhZbFngKWrh4=;
        b=ApuCjdQGnAkYEw3aA45vxd0De/Gil+rj9tD0m/YWBgUkGcvsbx2I87/If8v+SiNwxb
         D2aIP/kI/PsCppCc3exCPIXngc6x/8v5rplluP+Ao7CSJxI3Em/xMZpuhBeKs3PhEZ4d
         QEAgQkuoROlbsJZLewmnlQaKb+32OXImbotim/l048xrFEzxWG9JmBojgu1xvAmiuJqU
         fx+7mK7yLLzIIfsxKyNw/cUezt5D5dhTgRNR7VWNlxNaV7arWNwQCGI8W0gha0YnDgBu
         US8ZgTOgj6u2V2QG9+jB2t3Oibz01vHhny5rJ6TybbRgBw2Hcwh9kj9KNFtV2VuHre4G
         MGfw==
X-Gm-Message-State: ACrzQf3JA9P2P0uqgKP+cltt5xQOl/vRZ7RzPhC/+fk2D99SOhpxZDeO
        c2QYpcPhWtgZWCkDcP/pEcCGOcXsNA==
X-Google-Smtp-Source: AMsMyM79yUDuGBea14DUf4Zuj8HFysGU8WkrzLwG32UPNQt2MnBJ3ULoUWcDy4y7qO1o86pkPKNvgw==
X-Received: by 2002:a05:6830:1e97:b0:66c:52cc:8e9 with SMTP id n23-20020a0568301e9700b0066c52cc08e9mr3271198otr.113.1667242656487;
        Mon, 31 Oct 2022 11:57:36 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t8-20020a4aadc8000000b00480e77f90f9sm2619242oon.41.2022.10.31.11.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:57:36 -0700 (PDT)
Received: (nullmailer pid 3255352 invoked by uid 1000);
        Mon, 31 Oct 2022 18:57:37 -0000
Date:   Mon, 31 Oct 2022 13:57:37 -0500
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
Subject: Re: [PATCH] dt-bindings: net: constrain number of 'reg' in ethernet
 ports
Message-ID: <20221031185737.GA3249912-robh@kernel.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
 <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 10:03:25AM -0400, Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention for Ethernet controller's port number.
> 

Shouldn't this constrained by dsa-port.yaml (or the under review 
ethernet switch schemas that split out the DSA parts)?

> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Please give it a time for Rob's bot to process this.
> ---
>  Documentation/devicetree/bindings/net/asix,ax88178.yaml       | 4 +++-
>  Documentation/devicetree/bindings/net/microchip,lan95xx.yaml  | 4 +++-
>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml     | 4 ++--
>  .../devicetree/bindings/net/microchip,sparx5-switch.yaml      | 3 ++-
>  .../devicetree/bindings/net/mscc,vsc7514-switch.yaml          | 3 ++-
>  .../bindings/net/renesas,r8a779f0-ether-switch.yaml           | 4 ++--
>  6 files changed, 14 insertions(+), 8 deletions(-)
