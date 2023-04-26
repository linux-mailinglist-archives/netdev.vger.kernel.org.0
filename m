Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5C16EF895
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjDZQmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjDZQmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:42:51 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CB66181;
        Wed, 26 Apr 2023 09:42:50 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-5ef4eba2598so33161656d6.3;
        Wed, 26 Apr 2023 09:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682527369; x=1685119369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggpp339csvMck1qaojB4l0EJxGca4R1Yz1EgNOKYVtM=;
        b=sT64F7TcldJzjpkimocfIbwdtkCOo+TcMFPZP12s8jidVl0aDSjJ9gRjV5sAQqxZGA
         hQ78cQAqGL5i53r8U+LXsyeCeZM4a/e3KHPmb9a5O0E51j/SmLlGBMk40NweB+GHVGB7
         ARZHZoYiGIjsSMQqbkVj3DJG4OCZ5LQl7eOTb9WHN7zeDrp+2E0ZUXvHZtcyqJsnGaE7
         KTJemL7q1FRyWuupQZDXsfPCVn3tosiFtI5f6bLCaeeDEENDYY/fcKvfUWxLPqU9noT/
         CWHIEjBBKJAZfH8ONLDNDffetNKmqmYbXjQXpMWloSS9jTpfUaTZSFilmIxN8EG6UZXt
         nOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682527369; x=1685119369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ggpp339csvMck1qaojB4l0EJxGca4R1Yz1EgNOKYVtM=;
        b=S6w/yDN/g/SJ86dP2hxuKd8pJfqNOlv96FK7igVZVCoU05EoXJMMBWIAmVtTisGNA2
         eFiLmVIsSb8tRPBOTTiA83ZpqPl46uaXOjNmkyK6Idid38+ExluVGn17pd+uyqEaMoe0
         PnkbXo0/mLlp2d1hJDpycDSfdVr/j+Aczp4wkqUVn9fCOEyBkDc3WpKoWd6I5XrQJ7su
         5zEn93cICCjDMSGSzqy42dJbgZlDpLauciuni7MIAIs6SQk2BwOlAvcSDgmFAviwvkC8
         Qst07b9VBOvXc7TvMh5QRhlGKE0mqS/4Ki81628dDdUKBVY5NnBmhAcACvRhRmOltCWY
         Ojlw==
X-Gm-Message-State: AAQBX9dYItEnATi2lD4rtVqDc1zTsavuyX1MtTfEgzpEKjNzr97DLD2E
        eyezQrIedCR+xNlyXf1fbBE9e41Wn94dfQqBaO4=
X-Google-Smtp-Source: AKy350Y2jqYhQeTdBxdIqzYV84xZ6UGCodZ9YFavgvUcXld9txQu168Q3f9vqRKA7yt1auTUXb2Sa0H+29LvlRVMdF0=
X-Received: by 2002:a05:6214:20c1:b0:5ea:654e:4d3f with SMTP id
 1-20020a05621420c100b005ea654e4d3fmr33485133qve.5.1682527369654; Wed, 26 Apr
 2023 09:42:49 -0700 (PDT)
MIME-Version: 1.0
References: <1682327030-25535-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682327030-25535-3-git-send-email-quic_rohiagar@quicinc.com>
 <ZEk9lySMZcrRZYwX@surfacebook> <66158251-6934-a07f-4b82-4deaa76fa482@quicinc.com>
In-Reply-To: <66158251-6934-a07f-4b82-4deaa76fa482@quicinc.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 26 Apr 2023 19:42:13 +0300
Message-ID: <CAHp75VcCAOD3utLjjXeQ97nGcUTm7pic5F52+e7cJDxpDXwttA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] pinctrl: qcom: Add SDX75 pincontrol driver
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 6:18=E2=80=AFPM Rohit Agarwal <quic_rohiagar@quicin=
c.com> wrote:
> On 4/26/2023 8:34 PM, andy.shevchenko@gmail.com wrote:
> > Mon, Apr 24, 2023 at 02:33:50PM +0530, Rohit Agarwal kirjoitti:

...

> >> +#define FUNCTION(fname)                                              =
       \
> >> +    [msm_mux_##fname] =3D {                                          =
 \
> >> +            .name =3D #fname,                                        =
 \
> >> +            .groups =3D fname##_groups,                              =
 \
> >> +    .ngroups =3D ARRAY_SIZE(fname##_groups),                         =
 \
> >> +    }
> > PINCTRL_PINFUNCTION() ?
> Ok, Will update this. Shall I also update "PINGROUP" to "PINCTRL_PINGROUP=
"?

Yes, please.

--=20
With Best Regards,
Andy Shevchenko
