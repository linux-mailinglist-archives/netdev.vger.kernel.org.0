Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674F64227AB
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhJENWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:22:07 -0400
Received: from mail-vs1-f43.google.com ([209.85.217.43]:34478 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhJENWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 09:22:05 -0400
Received: by mail-vs1-f43.google.com with SMTP id d18so1004850vsh.1;
        Tue, 05 Oct 2021 06:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U41vIYP4S6yqbRG1Slu37+HOLovPRo8OgE9R7vD6bFY=;
        b=Z66mpLt9SVNNibuByFl4WaSt4+BQoBxkVew1v+5rys1pEBrplaPjg2HeSXbqrujp5y
         04YwOSNkDjfry308R00Q8dlryC7pKqcnSpAeh01otNZRMAwxKCgWEstCe8DIz5yfey4R
         ypEVBvvGagbjS+nELpYA8BOfrCfawng90LnJqHUrPJTj6Ahwe92k4leZ5OjTrnRh2eBx
         mvNFoEAXEvPOMzWi2iy+7H52JgioG8P3PC930SUVGo16ktAx9kMvFDF3CIsEZzrKD7Wj
         vYmi90yUiCFzmBuq3OwEp+vSVy7rM4VyeP+cSVgFJdFbpV+7LBaDtiyHI5SwBIiLWuqe
         O/yQ==
X-Gm-Message-State: AOAM5317TEnHSTDuoVixWifjyor7aiZaUEqBuMSCe+lX9bP1Y1I//Ixt
        uWKBQRyfjDKrKp6Imz8uYk4S90jjip3FdRFe4tA=
X-Google-Smtp-Source: ABdhPJx6S8AApCKlPVWbntYziz6p+YUeec4ETTmqZaPRa1Htlr9pyQIUAheWi4UTTxbnWWGp+v6ssK0XG8neizkedao=
X-Received: by 2002:a67:2c58:: with SMTP id s85mr18268943vss.35.1633440014839;
 Tue, 05 Oct 2021 06:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210924153113.10046-1-uli+renesas@fpond.eu> <20210924153113.10046-4-uli+renesas@fpond.eu>
In-Reply-To: <20210924153113.10046-4-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Oct 2021 15:20:03 +0200
Message-ID: <CAMuHMdXKuvxnLBRXUgaT=kvvyE4LY9tzM8WiM1J+=4__kY8Stw@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: dts: r8a779a0: Add CANFD device node
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Fri, Sep 24, 2021 at 5:34 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> This patch adds CANFD device node for r8a779a0.
>
> Based on patch by Kazuya Mizuguchi.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for your patch!

> --- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi

> @@ -236,6 +243,54 @@
>                         #interrupt-cells = <2>;
>                 };
>
> +               canfd: can@e6660000 {

Please preserve sort order (by unit address).

> +                       compatible = "renesas,r8a779a0-canfd";
> +                       reg = <0 0xe6660000 0 0x8000>;
> +                       interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
> +                                       <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;

Please add interrupt-names, so we can make the property required soon.

> +                       clocks = <&cpg CPG_MOD 328>,
> +                                <&cpg CPG_CORE R8A779A0_CLK_CANFD>,
> +                                <&can_clk>;
> +                       clock-names = "fck", "canfd", "can_clk";
> +                       assigned-clocks = <&cpg CPG_CORE R8A779A0_CLK_CANFD>;
> +                       assigned-clock-rates = <40000000>;
> +                       power-domains = <&sysc R8A779A0_PD_ALWAYS_ON>;
> +                       resets = <&cpg 328>;
> +                       status = "disabled";
> +
> +                       channel0 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel1 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel2 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel3 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel4 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel5 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel6 {
> +                               status = "disabled";
> +                       };
> +
> +                       channel7 {
> +                               status = "disabled";
> +                       };
> +               };
> +
>                 cmt0: timer@e60f0000 {
>                         compatible = "renesas,r8a779a0-cmt0",
>                                      "renesas,rcar-gen3-cmt0";

With the above fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
