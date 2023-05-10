Return-Path: <netdev+bounces-1500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EEE6FE060
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11B4B1C20DA0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59CA14A90;
	Wed, 10 May 2023 14:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D7520B54
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:34:46 +0000 (UTC)
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F7B11D;
	Wed, 10 May 2023 07:34:45 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-75131c2997bso2593463785a.1;
        Wed, 10 May 2023 07:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683729285; x=1686321285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3GG0ZoCFLdF+IhloxAqhSUzqvE1UvnFSXjfPq8BjX8=;
        b=pg6KCrpq4etIlqmSDAHj4tf0U0nFI6ApVG5xybW00dHnSKS9qXORBYMXDoXvXe/EtY
         PCtFoohpuZf0yeAlDJEEtkbaBbiHejWzAz5hSNMmu996dFnSWGj7r6lGuVZLGxb2UslN
         8PDrGxcgN2pyK2DEjHWSEDooGvU6snbLlgzqXuiV75jDNqQqVhlFiNRVCS2xrwlVPkCY
         +/VZh701ddmqetDo0qzhyuZQ41y2y0U3kOvnKNHPn2Qe7n9IuY8GF5+5bDoO0eN7AK7+
         X1wmHV+da/2/Eu4TR8X9AlOswDMIjcjHpWPWwQbbxRmxFI7TWnUw3V+oJNCnfRzPauZe
         fRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729285; x=1686321285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3GG0ZoCFLdF+IhloxAqhSUzqvE1UvnFSXjfPq8BjX8=;
        b=BxhApeqNoMM7B3JoKjWf3fquR5yWItl9lHIUSh3B/Zxax82hVh8ebDjCuWAoi1n7L4
         Mr45KiI/l0yCHgDuhNPNh1a3ocY6SL9B2LyVL28XlMB79LlaaJ6qNpBtd5P9p9vOpDGr
         ZdyVQBvplJ/dk+hjiACHuOUeM4+Oic1mmodpRk89iDvxmQmLPb2ZeEpttLi9+TSihZOi
         6lpFytD1HO/Zfj6obmOALEEqnsusqQKsU0t306l08PxNAvsxypvelk5iCEFD2iXAgmeV
         k+3wM4G49Gi801rOakogIBMXaD9guews95rqAQD6gt7En+Qa2NDQryDguUq2XFUUMhIy
         chCg==
X-Gm-Message-State: AC+VfDxfjerzdBnhm8o9tXnGPj++4NyGllMHwntTaIkMywNT0LN5sEuS
	GBantpeOGN0UN5LDbsOtVaGnzQ+8JFGca6EVps4=
X-Google-Smtp-Source: ACHHUZ47kFkGv5DWJ4FIB7/9Y6ScllXX9dI6c1TwVNpSKc60n5AKTMW68fzzHUSBVE4C8mVkq33jz3XE7HCl3fx559w=
X-Received: by 2002:a05:6214:76c:b0:61b:5faf:9a72 with SMTP id
 f12-20020a056214076c00b0061b5faf9a72mr34208469qvz.3.1683729284734; Wed, 10
 May 2023 07:34:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683718725-14869-5-git-send-email-quic_rohiagar@quicinc.com>
 <ZFun8m5y-r0yUHhq@surfacebook> <1ffc9474-0a05-44d8-0cc0-24a065443b18@quicinc.com>
In-Reply-To: <1ffc9474-0a05-44d8-0cc0-24a065443b18@quicinc.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 10 May 2023 17:34:08 +0300
Message-ID: <CAHp75VcCYo2uF2VY6x3jFb3v-whXrCW_U_bKnnWAfzg+dAe1zQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] pinctrl: qcom: Add SDX75 pincontrol driver
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

On Wed, May 10, 2023 at 5:31=E2=80=AFPM Rohit Agarwal <quic_rohiagar@quicin=
c.com> wrote:
> On 5/10/2023 7:49 PM, andy.shevchenko@gmail.com wrote:
> > Wed, May 10, 2023 at 05:08:45PM +0530, Rohit Agarwal kirjoitti:

...

> >> +#define FUNCTION(n)                                                 \
> >> +    [msm_mux_##n] =3D {                                              =
 \
> >> +                    .func =3D PINCTRL_PINFUNCTION(#n,                =
 \
> >> +                                    n##_groups,                     \
> >> +                                    ARRAY_SIZE(n##_groups))         \
> >> +                    }
> > But don't you now have MSM_PIN_FUNCTION() macro?
>
> So Sorry, a mistake from my end. Will immediately update.

Don't forget to collect my tags for the other patches.

--=20
With Best Regards,
Andy Shevchenko

