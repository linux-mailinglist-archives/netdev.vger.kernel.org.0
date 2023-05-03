Return-Path: <netdev+bounces-131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5F36F552B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60A8E1C2093F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF915AD55;
	Wed,  3 May 2023 09:48:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E2EED2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:48:16 +0000 (UTC)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAB35B92;
	Wed,  3 May 2023 02:48:14 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-74db3642400so448558985a.2;
        Wed, 03 May 2023 02:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683107293; x=1685699293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLkQD32F3IyzI9nuizEgzw57kW3UmWyAr9AlLHhtw/w=;
        b=EzxTxtGSL3zdYaLaEhs72pGdeB0Zra/NxBtuqx7f8JwACc+XbqYDu37vlb6u8y2ohO
         qFcW7MytFMXf+78FAiD9S0g4DGsNZy72i4FbVuz35UOrbuwStgOCmqwrj4VcNyr5DKWD
         GdYS3KBu1ib4z11kTk8ZXXSNDyejh6T0UTLt2HsiKQf3xBZdYVJGS5GPCR7aTbCXS6AL
         rfW8XO2hv5VC4eItvnc2zXcZIZtMlIxCt/7kKRh7pGOr71A6bBmnfp854IRTfyIWs1La
         dKT3bN4+F73RsM1MnR5CFo/fpM7zEk9ALtzvcZJDKxfYq/oQKvW0iC5wq++VrhEdy0fs
         gDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683107293; x=1685699293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tLkQD32F3IyzI9nuizEgzw57kW3UmWyAr9AlLHhtw/w=;
        b=OaUOjUHzaDjm5oAK+CTaeE0MXMYZ/KCQil9Z7HWdqC7Lt4/IW7sycwz0XQRBY/8Dne
         8y5KMFOZbrWFDb+u2JmSl/vV6YX84vYGkF2U7zniPHLSX6wz3hQcLdT10v31GNiyEZCh
         EPPxrwb/s3QfaeLR4YEHDRSU4blc3zM72s3zAUKcx3rwON5LpvoPu4wedDYAUev9hH6O
         t7wMzj5TFehb3GphonZaAurWehmfgRTxkpIVV4rQ9/2v2AALLNB2xkkrKkcGge2qNElj
         CM2XPeSE63d+h8kSus4s/I4JJr/07hI5qrw/KNYnvTGzrL2AIcGz2I4xk1NzMD0i3HwA
         gksg==
X-Gm-Message-State: AC+VfDzJsYsd4Hok4KC7stH7zNF9SMnVrzSg8QjtkamTz0vidZ5LWlkf
	IO66+J+a9KtrxwB+czvPmfpkp8uBu9L7A8gsYUo=
X-Google-Smtp-Source: ACHHUZ4Q5WQUaumtaNYI49nhQWXJyCnvaZUIKU+GwPX9rXu7Tuv0i4XSm6dxaPFhw0f4LYxtCet8Vcp57kX3RfIVqac=
X-Received: by 2002:a05:6214:5012:b0:5ef:45a7:a3c0 with SMTP id
 jo18-20020a056214501200b005ef45a7a3c0mr10842556qvb.27.1683107293366; Wed, 03
 May 2023 02:48:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com> <1683092380-29551-4-git-send-email-quic_rohiagar@quicinc.com>
In-Reply-To: <1683092380-29551-4-git-send-email-quic_rohiagar@quicinc.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 3 May 2023 12:47:37 +0300
Message-ID: <CAHp75Ve0FqX7=x3B5eaCfj0AE5m1qMXGrYzLoHzqbLY7gdOSOg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] pinctrl: qcom: Add SDX75 pincontrol driver
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org, 
	linus.walleij@linaro.org, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com, 
	manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org, 
	linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 3, 2023 at 8:39=E2=80=AFAM Rohit Agarwal <quic_rohiagar@quicinc=
.com> wrote:
>
> Add initial Qualcomm SDX75 pinctrl driver to support pin configuration
> with pinctrl framework for SDX75 SoC.
> While at it, reordering the SDX65 entry.

...

> +#define FUNCTION(n)                                                    \
> +       [msm_mux_##n] =3D {                                              =
 \
> +                       .func =3D PINCTRL_PINFUNCTION(#n,                =
 \
> +                                       n##_groups,                     \
> +                                       ARRAY_SIZE(n##_groups))         \
> +                       }

Or even define

  #define MSM_PIN_FUNCTION(fname) \
      [msm_mux_##fname] =3D PINCTRL_PINFUNCTION(...)

in the header for all MSM related controllers.

All the same for the rest groups (if any), otherwise use redefinition
of FUNCTION inside each file.

--=20
With Best Regards,
Andy Shevchenko

