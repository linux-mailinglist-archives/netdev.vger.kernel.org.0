Return-Path: <netdev+bounces-1065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E09D6FC0C3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15BD12811EA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC45171C6;
	Tue,  9 May 2023 07:52:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E66121
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:52:13 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBDAAD09
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:52:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30771c68a9eso4764930f8f.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 00:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683618728; x=1686210728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AiJ7j1UJ/LHlbk27yV5v4iaBxOzxNWaEAWpsBwu4K1A=;
        b=vjnA/N0wYP3JqBq0LLnPmY5ySAhBGZ45WZz+1ago1Razib7wJoAVGwVCPdoVGISI/d
         soAW/KkFE6Q9i14xhTWawPMvnao0Oj/c1rWhgExXYgo7VJdlo2BJiumnj03gzDL3DYHp
         zxjp+zinNpZcebIEZCyWeDbaEMkaG8e6AbZFeYZ3+oYVv76YYPQoT0bG87E9muOV2Rvy
         IB3Cr4V++wky/Mm/gY3lysEyssFSKAJ9kFu7mdYiuXc/MDO/M2IBB8tEet16Mc3azG2O
         3+CjALJ2my6fdZR5EYCLJM9bNhU5YNBFyC4EWEGQikjdfIi1ydwpimRtuLDTmrcQD679
         dhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683618728; x=1686210728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AiJ7j1UJ/LHlbk27yV5v4iaBxOzxNWaEAWpsBwu4K1A=;
        b=PnKyUSfvx1aRwVN7nHhfxSOdXoSPIm2k9YrYL/23oKr+v5XciBojkTWN7ThBCiZrL3
         dg1AXUwQSxqHIK3QmYLolNoehm0dCFzIQPtGdefilIpFEjJ5LuzpWkTR+84ngcV1mkCK
         MfcyFnsiPhCjyZku/Eq4zsiYdLjOQAiDn9o2mfnHOQVNEPfN+EvynC+pA2F4w6+SSW3v
         iYrDE0f43dDE/JYrEGwgjUdjQp5KCO3pxAqfXjk0DoMqmVUv/NQL8YvFZsTYQoZtIZGj
         LrGktGz9WvNcH+wEtoQHlQMu/AYLpyk2MxrRCMKpvc0uoajbtx8LcG54UH9brjO1OXFY
         zzlQ==
X-Gm-Message-State: AC+VfDxVsRk2n5BmHYimiwdfj8fCNOQ0dvb3RBlN71Zqbsxz+BGtMIGQ
	hpJGVj/ZRw4ZZzbPpRW+kjkHoKw5om9j89yQ8JNv9g==
X-Google-Smtp-Source: ACHHUZ77GpidyDYIXFEMgkHoj7nqJ/307eHJcLHJeO+DhUlVx5SZRURaeMCdJvEWfKUhMwqMENMCtgi6rH1kQyKcaXI=
X-Received: by 2002:adf:e690:0:b0:2e8:b9bb:f969 with SMTP id
 r16-20020adfe690000000b002e8b9bbf969mr9090559wrm.0.1683618728362; Tue, 09 May
 2023 00:52:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de> <20230508142637.1449363-7-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230508142637.1449363-7-u.kleine-koenig@pengutronix.de>
From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date: Tue, 9 May 2023 13:21:56 +0530
Message-ID: <CAH=2Ntyc-Oi-FCNQJbLwgyWT8Tt7tVpHO7HOc=hM2RdNweOzjg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 06/11] net: stmmac: dwmac-qcom-ethqos: Convert
 to platform remove callback returning void
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Vinod Koul <vkoul@kernel.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Jose Abreu <joabreu@synopsys.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Uwe,

On Mon, 8 May 2023 at 19:56, Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored

^^^ mostly, here seems confusing. Only if the return value is ignored
marking the function
as 'void' makes sense IMO.

> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/dr=
ivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> index bf17c6c8f2eb..1db97a5209c4 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> @@ -665,14 +665,12 @@ static int qcom_ethqos_probe(struct platform_device=
 *pdev)
>         return ret;
>  }
>
> -static int qcom_ethqos_remove(struct platform_device *pdev)
> +static void qcom_ethqos_remove(struct platform_device *pdev)
>  {
>         struct qcom_ethqos *ethqos =3D get_stmmac_bsp_priv(&pdev->dev);
>
>         stmmac_pltfr_remove(pdev);
>         ethqos_clks_config(ethqos, false);
> -
> -       return 0;
>  }
>
>  static const struct of_device_id qcom_ethqos_match[] =3D {
> @@ -685,7 +683,7 @@ MODULE_DEVICE_TABLE(of, qcom_ethqos_match);
>
>  static struct platform_driver qcom_ethqos_driver =3D {
>         .probe  =3D qcom_ethqos_probe,
> -       .remove =3D qcom_ethqos_remove,
> +       .remove_new =3D qcom_ethqos_remove,
>         .driver =3D {
>                 .name           =3D "qcom-ethqos",
>                 .pm             =3D &stmmac_pltfr_pm_ops,
> --
> 2.39.2

Also a small note (maybe a TBD) indicating that 'remove_new' will be
eventually replaced with 'remove' would make reading this easier. Rest
seems fine, so:

Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Thanks.

