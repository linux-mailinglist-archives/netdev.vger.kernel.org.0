Return-Path: <netdev+bounces-125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C3D6F54FA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE0EE1C20CD4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D869475;
	Wed,  3 May 2023 09:42:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B4ED2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:42:37 +0000 (UTC)
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A6E4ED3;
	Wed,  3 May 2023 02:42:34 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-75131c2997bso144244485a.1;
        Wed, 03 May 2023 02:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683106953; x=1685698953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UswhBddqVaXIV7KahhOAL0L+vAcJJ2NqdC/L7ARqHLI=;
        b=bBkeJTcutU1gEMmYbPqloKEmhZKGZR3vpAPR7Ly0UkZvZDSfS7SqZtHaoocQe4Xkua
         ruNsGSw4EPvXfAczKkPscYyr7DOnesMtTPrEsZwtu/v8VA0C2oPy8KAiyqUYmd4ST1Mt
         F4a3P3xeHlxoRjr5qfxHgTvKW5G2kHD979Wo+p2GYDISigYAmzacBXZdDX2UkDVJbLAH
         K2v1SDwptNS+y+cBH86OVLtfuf3Hdu4FcHBkXnoXoAD6u7Q3fOEHAn51J3tzAGuQsvKG
         Wsge8r7s9YnWEYWFCkvC2AAVGeD6+Kb/zJq0qmgLAME0Ci2Bt1iJtx0ORC3WEsRfb2uV
         9b/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683106953; x=1685698953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UswhBddqVaXIV7KahhOAL0L+vAcJJ2NqdC/L7ARqHLI=;
        b=U39WTqd3NMwtFhujE19T71JNvVgRVzaD+WtGaBNJHhoZQ6b70O4zAdilUuaoxcL15A
         WSfbouWYDkmgR3oOFcADg9rf9VUYGTuU2LuA5vTtZcaZDMFU2AdYY+geLGxHvBM7YL8w
         eqV64Y3mMdyQB7TC+s0zBFlk4jtnOcLWIPNKNfI4+t+8BYDjJ6AX6eOvLPBkP0I6y3CA
         34NEYFB3tX/09i6tDPvUrM9xirBpsgM52UgzghR9FE22MIaUPm2q8yEMOydpJi+Khf7s
         XlB5HVkztC7TFQVsGGVYlY42PD5FZkqJ8T7q2WzBHHGAV/0B19Vy8RFUZRdUf96o6sMV
         wEWQ==
X-Gm-Message-State: AC+VfDwJdsLUXhkIEKJiaMtj3Owk4CzhIIWxuUso1ZY08IQUqmWixlOB
	caO/UaOKRdcqEW+rF3F3t0IIypJ5CoWTP6oA1/s=
X-Google-Smtp-Source: ACHHUZ6FApUZmpoYv7ei9QTTm9Bil42o9GopYVbQ7LWiRSSlgewFbtRxNZlhfGGbv7z1d3UtbL2jGNKCTm/YkX9t5jM=
X-Received: by 2002:a05:6214:d64:b0:5ef:653e:169b with SMTP id
 4-20020a0562140d6400b005ef653e169bmr2275095qvs.8.1683106953183; Wed, 03 May
 2023 02:42:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com> <1683092380-29551-3-git-send-email-quic_rohiagar@quicinc.com>
In-Reply-To: <1683092380-29551-3-git-send-email-quic_rohiagar@quicinc.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 3 May 2023 12:41:56 +0300
Message-ID: <CAHp75VegxMgAamS3ORiJ2=D4MH7asD9PiWrM+3JAm-QOuEgcrg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] pinctrl: qcom: Refactor target specific pinctrl driver
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
> Update the msm_function and msm_pingroup structure to reuse the generic

structures

> pinfunction and pingroup structures. Also refactor pinctrl drivers to adj=
ust
> the new macro and updated structure defined in pinctrl.h and pinctrl_msm.=
h
> respectively.

Thanks for this, my comments below.

...

>  #define FUNCTION(fname)                                        \
>         [APQ_MUX_##fname] =3D {                           \
> -               .name =3D #fname,                         \
> -               .groups =3D fname##_groups,               \
> -               .ngroups =3D ARRAY_SIZE(fname##_groups),  \
> -       }
> +               .func =3D PINCTRL_PINFUNCTION(#fname,                    =
 \
> +                                       fname##_groups,                 \
> +                                       ARRAY_SIZE(fname##_groups))      =
       \
> +                       }

Does it really make sense to keep an additional wrapper data type that
does not add any value? Can't we simply have

  #define FUNCTION(fname)      [...fname] =3D PINCTRL_PINFUNCTION(...)

?

...

> +               .grp =3D PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,    =
 \
> +                       (unsigned int)ARRAY_SIZE(gpio##id##_pins)),     \

Why do you need this casting? Same Q to all the rest of the similar cases.

...

> +#include <linux/pinctrl/pinctrl.h>

Keep it separate, and below the generic ones...

>  #include <linux/pm.h>
>  #include <linux/types.h>
>

...like here (note also a blank line).

...

>  /**
>   * struct msm_function - a pinmux function
> - * @name:    Name of the pinmux function.
> - * @groups:  List of pingroups for this function.
> - * @ngroups: Number of entries in @groups.
> + * @func: Generic data of the pin function (name and groups of pins)
>   */
>  struct msm_function {
> -       const char *name;
> -       const char * const *groups;
> -       unsigned ngroups;
> +       struct pinfunction func;
>  };

But why? Just kill the entire structure.

...

>  #define FUNCTION(fname)                                        \

This definition appears in many files, instead you can make a generic
to this drivers one and use it here

#define QCOM_FUNCTION(_prefix_, _fname_)
  [_prefix_##_fname_] =3D PINCTRL_PINFUNCTION(...)

#define FUNCTION(fname) QCOM_FUNCTION(msm_mux, fname)

(this just a pseudocode, might not even be compilable)

>         [msm_mux_##fname] =3D {                           \
> -               .name =3D #fname,                         \
> -               .groups =3D fname##_groups,               \
> -               .ngroups =3D ARRAY_SIZE(fname##_groups),  \
> +               .func =3D PINCTRL_PINFUNCTION(#fname,                    =
 \
> +                                       fname##_groups,                 \
> +                                       ARRAY_SIZE(fname##_groups))      =
       \
>         }

--=20
With Best Regards,
Andy Shevchenko

