Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B230A6E6C36
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjDRSgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjDRSgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:36:35 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8445FEB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:36:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-517bfdf55c3so1102246a12.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681842988; x=1684434988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApsPN1GAt+bKSjbs42LxkANlc6ClVgqELeBRCapEZOY=;
        b=fcvQ6uiiAwbiDHp9ofdozAuOiqo8sbjEaS1wJfZPJdR7ku/k91ggC43xkhzyyW+7nI
         yL05D8fKTVowBu7cH7oGSbwvorwMmpZfZp+be71T12rL9TRGAsRKhgX9BtbLc+iyZwgq
         Qb48G1rKzQZjLEUD5f92333ozX9LrkHTarpi26AV6WxfUdF8E317PyK+GRvYlhJDse5Z
         MEZRohJ9XuAxL4kVb0Aft7cnNRU1ffRIyB+Hpuwglq4gprdj5r075/QYekStmw9Zcc7e
         uJaoVEg0RaJ6z9kkri0qCgyEJPxz6DZVa/1Zx09Yl/HmHiUZVgIL62G/nueZQ1DngeXx
         2F5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681842988; x=1684434988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ApsPN1GAt+bKSjbs42LxkANlc6ClVgqELeBRCapEZOY=;
        b=PqsNdsfhlKHjnys+QXT5IA6gSbAirIpYc4gnJzWGzPhRKkwi6FlDBUIlOwmiwZx0dO
         4FnUChVX7FAuupGjjfuurKYfy7r3fBBBQIh6YJ+9T9XoiNlEL7ZBiUEsoxVT6U4m+HoX
         pd97b2ign2FEnsLMhxxN4SMs1kxuOkZGOGcwPM2Paeu+mFRv6qH2OKo7117zvgnQtAvP
         Rbo1BQ810av8bcZxUKyllntj47vQYm2BdU7+MmrRLzC1Fm0+WK2cNusgf8w28urlwtp7
         BxZHfRJq+qlUf72atRQV3u8Ct8bcQLALXod2IseK2EvDXJnAKs+ectamB0l3JSBNfGmb
         1ZfA==
X-Gm-Message-State: AAQBX9eIqvRDE7t7LKWpkwGjfkdYaagkGZ/mAXhSHHWYGSV6rYFnLuOT
        sCbBRR7LIyQugoeYEV390U/0GTtom5PW8OBo2Enf9A==
X-Google-Smtp-Source: AKy350ZShnO2tG7T/57z/jUzMW01PDWOatg+RwsX6uSLq6+zwhs8lAyWd6JaHE6qNghBF+/vCyIJp0/ga1bkMCOPgjE=
X-Received: by 2002:a17:90a:d70b:b0:246:ba3f:4f3e with SMTP id
 y11-20020a17090ad70b00b00246ba3f4f3emr605102pju.6.1681842988421; Tue, 18 Apr
 2023 11:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230418-dwmac-meson8b-clk-cb-cast-v1-1-e892b670cbbb@kernel.org>
In-Reply-To: <20230418-dwmac-meson8b-clk-cb-cast-v1-1-e892b670cbbb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 18 Apr 2023 11:36:17 -0700
Message-ID: <CAKwvOd=DeCNoQYuTJVfbd0tSddJpGVaKBTEfC-+XUN4OJ4hRRw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: stmmac: dwmac-meson8b: Avoid cast to
 incompatible function type
To:     Simon Horman <horms@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, llvm@lists.linux.dev,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 4:07=E2=80=AFAM Simon Horman <horms@kernel.org> wro=
te:
>
> Rather than casting clk_disable_unprepare to an incompatible function
> type provide a trivial wrapper with the correct signature for the
> use-case.
>
> Reported by clang-16 with W=3D1:
>
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c:276:6: error: cast f=
rom 'void (*)(struct clk *)' to 'void (*)(void *)' converts to incompatible=
 function type [-Werror,-Wcast-function-type-strict]
>                                         (void(*)(void *))clk_disable_unpr=
epare,
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> No functional change intended.
> Compile tested only.
>
> Signed-off-by: Simon Horman <horms@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/driver=
s/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> index e8b507f88fbc..f6754e3643f3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> @@ -263,6 +263,11 @@ static int meson_axg_set_phy_mode(struct meson8b_dwm=
ac *dwmac)
>         return 0;
>  }
>
> +static void meson8b_clk_disable_unprepare(void *data)
> +{
> +       clk_disable_unprepare(data);
> +}
> +
>  static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
>                                            struct clk *clk)
>  {
> @@ -273,8 +278,7 @@ static int meson8b_devm_clk_prepare_enable(struct mes=
on8b_dwmac *dwmac,
>                 return ret;
>
>         return devm_add_action_or_reset(dwmac->dev,
> -                                       (void(*)(void *))clk_disable_unpr=
epare,
> -                                       clk);
> +                                       meson8b_clk_disable_unprepare, cl=
k);
>  }
>
>  static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
>


--=20
Thanks,
~Nick Desaulniers
