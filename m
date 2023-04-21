Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D286EB000
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjDURAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjDURAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:00:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279941563F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:00:15 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5069097bac7so3279879a12.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1682096387; x=1684688387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT/YYNidqu3A4BNDZJk8UgJVKfbhp8UpzHeC81fLwQU=;
        b=D2hM9+BKb4GsOroNx+/2Qf3HuWU7SAKw0AO34XJw8mAFUTQqZpfI7shT/sgx4W5jCj
         cFTbaR6CN2Q1yTr6s2dj9n8eQEPgiLLssKSGowQJdgtci2hIg/ixyJkJuRov67Zyorw7
         Jq5+5BFl02Mtae9ZS+g34wWmjDpkXrUETy1LOhKFQPaZGJeQUO03YuATHQkswyLlpRoO
         YGNowK3cmq7/Vw8J2Np0+vsY0wAc5NGd10BUB+1sz7iH0mI/AxiPDJwONrxf3rB4eTyz
         dcjWzxXQeABQpGE+Rd5ZPuTRZpaiAcaDDpNGBXk9bF/l6fSKjogZg+YsCmyuqlTjS8Pj
         rtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096387; x=1684688387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QT/YYNidqu3A4BNDZJk8UgJVKfbhp8UpzHeC81fLwQU=;
        b=iph1P/zvlxPRPLETAXedahUtTwMnHZ/nW7u73jATXdH89+tr1g0WfVyuNQVU8UCd/e
         titrfJsktwi6a7GR6VcAMu+9IbryRdih+3iR8fHEZijgA4mNlP2fkPQkQVGfWMUSsreK
         LhFsuC2oLjup5B+YFpmWJe9881OmPJFoXKHwjnzx3Pw/AgBf+LqFCTvpv+ZvLcO7UgB0
         hO+mlL4NzOY78yKKRwDmHMVOtnv16vxb9xccH6GAOesTqGyhvxiKl7brSV4xM9Kqc2eT
         wY6g9a+4XASQngp5vNhskuwM7Gt90BV5pavtjJPJR2uS1ZLbc/6J5yl4lpiMI1vMZu7Q
         5qQQ==
X-Gm-Message-State: AAQBX9fDypgfbE1SkpATjfqzLK329i9PwxTlqO/f7kNvfdLZ46IC4ESz
        OZ4HKb6rWGZ23l8pyLxrES3grIcqdc/bhNYzW85Zjw==
X-Google-Smtp-Source: AKy350b9a4jCLi4HJbMPu1T+4q9CM6Y8OH1cDOw94YTZ4Km3f1mfLPfh+N6EitCgpEUZ7xZmQHrta+EW3DOKPuAzovM=
X-Received: by 2002:a05:6402:ca:b0:506:8884:7f5 with SMTP id
 i10-20020a05640200ca00b00506888407f5mr5245621edu.41.1682096386944; Fri, 21
 Apr 2023 09:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com> <20230421-fp4-bluetooth-v1-3-0430e3a7e0a2@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v1-3-0430e3a7e0a2@fairphone.com>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Fri, 21 Apr 2023 11:59:35 -0500
Message-ID: <CAKXuJqgeK1i8pi5Wujy3tJRRk-6yajJtoQvZjs=639Mbid=Q0Q@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] arm64: dts: qcom: sm6350: add uart1 node
To:     Luca Weiss <luca.weiss@fairphone.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 9:12=E2=80=AFAM Luca Weiss <luca.weiss@fairphone.co=
m> wrote:
>
> Add the node describing uart1 incl. opp table and pinctrl.
>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/sm6350.dtsi | 63 ++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/q=
com/sm6350.dtsi
> index 18c4616848ce..16c5e9a6c98a 100644
> --- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
> @@ -378,6 +378,25 @@ opp-2073600000 {
>                 };
>         };
>
> +       qup_opp_table: opp-table-qup {
> +               compatible =3D "operating-points-v2";
> +
> +               opp-75000000 {
> +                       opp-hz =3D /bits/ 64 <75000000>;
> +                       required-opps =3D <&rpmhpd_opp_low_svs>;
> +               };
> +
> +               opp-100000000 {
> +                       opp-hz =3D /bits/ 64 <100000000>;
> +                       required-opps =3D <&rpmhpd_opp_svs>;
> +               };
> +
> +               opp-128000000 {
> +                       opp-hz =3D /bits/ 64 <128000000>;
> +                       required-opps =3D <&rpmhpd_opp_nom>;
> +               };
> +       };
> +
>         pmu {
>                 compatible =3D "arm,armv8-pmuv3";
>                 interrupts =3D <GIC_PPI 5 IRQ_TYPE_LEVEL_LOW>;
> @@ -741,6 +760,22 @@ i2c0: i2c@880000 {
>                                 status =3D "disabled";
>                         };
>
> +                       uart1: serial@884000 {
> +                               compatible =3D "qcom,geni-uart";
> +                               reg =3D <0 0x00884000 0 0x4000>;
> +                               clock-names =3D "se";
> +                               clocks =3D <&gcc GCC_QUPV3_WRAP0_S1_CLK>;
> +                               pinctrl-names =3D "default";
> +                               pinctrl-0 =3D <&qup_uart1_cts>, <&qup_uar=
t1_rts>, <&qup_uart1_tx>, <&qup_uart1_rx>;
> +                               interrupts =3D <GIC_SPI 602 IRQ_TYPE_LEVE=
L_HIGH>;
> +                               power-domains =3D <&rpmhpd SM6350_CX>;
> +                               operating-points-v2 =3D <&qup_opp_table>;
> +                               interconnects =3D <&clk_virt MASTER_QUP_C=
ORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
> +                                               <&aggre1_noc MASTER_QUP_0=
 0 &clk_virt SLAVE_EBI_CH0 0>;
> +                               interconnect-names =3D "qup-core", "qup-c=
onfig";
> +                               status =3D "disabled";
> +                       };
> +
>                         i2c2: i2c@888000 {
>                                 compatible =3D "qcom,geni-i2c";
>                                 reg =3D <0 0x00888000 0 0x4000>;
> @@ -1726,6 +1761,34 @@ qup_i2c10_default: qup-i2c10-default-state {
>                                 drive-strength =3D <2>;
>                                 bias-pull-up;
>                         };
> +
> +                       qup_uart1_cts: qup-uart1-cts-default-state {
> +                               pins =3D "gpio61";
> +                               function =3D "qup01";
> +                               drive-strength =3D <2>;
> +                               bias-disable;
> +                       };
> +
> +                       qup_uart1_rts: qup-uart1-rts-default-state {
> +                               pins =3D "gpio62";
> +                               function =3D "qup01";
> +                               drive-strength =3D <2>;
> +                               bias-pull-down;
> +                       };
> +
> +                       qup_uart1_tx: qup-uart1-tx-default-state {
> +                               pins =3D "gpio63";
> +                               function =3D "qup01";
> +                               drive-strength =3D <2>;
> +                               bias-pull-up;
> +                       };
> +
tx should come after the rx, this caught me too when I was doing my
bluetooth driver, it goes by name, not gpio#.

> +                       qup_uart1_rx: qup-uart1-rx-default-state {
> +                               pins =3D "gpio64";
> +                               function =3D "qup01";
> +                               drive-strength =3D <2>;
> +                               bias-disable;
> +                       };
>                 };
>
>                 apps_smmu: iommu@15000000 {
>
> --
> 2.40.0
>
