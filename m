Return-Path: <netdev+bounces-168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 391B56F5963
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A6601C20E97
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B37D53A;
	Wed,  3 May 2023 13:54:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7154321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:54:33 +0000 (UTC)
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217DF59D1;
	Wed,  3 May 2023 06:54:28 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-74e13e46cb9so231184285a.1;
        Wed, 03 May 2023 06:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683122067; x=1685714067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xUQbiTykYAvIdK6HEBeDPCbi8CS8G1uFcYtsrWp+q4=;
        b=boNlRGA/cEF9KFonM+yRy0NGrsx4qeiT++wfyKSTFofkB0BIUqq5VY4iTL2FzvJpAH
         56t+icdIn9V8tDwJy5dylefB/J+UpeyFHMcNJ649CIW7U9pu/zA8jMwVq+VlqSC4yHnH
         WtviHfncvFc8mJk/krSb/36aTcbmb9Z2K+pkv5SErREB7fz4gX68fHUxOuY27kjYAkzv
         dWO76V3ZyK+vwnBNchATPp+H5pZKES8uy3aXCin32usV3o0kXitug3eUlCG459RYuhqB
         4LUuRNdUjaJ6neM+hbkAu/2h4fqwGPJR0qzl6FoCjdzL0ffufh9Wmq5DnRC50DNNc+uD
         v77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683122067; x=1685714067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xUQbiTykYAvIdK6HEBeDPCbi8CS8G1uFcYtsrWp+q4=;
        b=iHoQ2JXZPKg2LBkvo2qKTdfzPz1/kSSengYZie9gEKDHt/KKQXnAb4OwR5sfV+pc1g
         36J+/LH0C7SWuEUlrTURLbOgu+z6ecOUSXlAReSzM6biJDC7dv4sCyFxl9xNY1QtFO40
         wAv7gDWrNjmrTW4j+Pzvc4yjsfC3bUTH42jbFyPQR8U2T7dajEQPUIEXlpY+7hq+bqWk
         CFrXiRuDD7+aXR7dvHFd3SjXJiKFlHbbow/9O1iL3ffY3Y47cfDhXiPTOd7F+tZUtHe7
         sfaic/x9PVhatcbS7OdTqDbUJGREwVc41Wxi+m6fOsyF/ctvN3yEQ9UEQeh4H2S7FsGz
         dW6g==
X-Gm-Message-State: AC+VfDxzJwFnMGjZ3JzE0OAQ4FsLkvoBIJjb0FHKNSWmuB+9gdFqJj/1
	c5Gw84PUcVYjXREcRzElcyn+DbfJOe5cT/Bw0zM=
X-Google-Smtp-Source: ACHHUZ7ijvIFJIGPdN/7sNe7lc22jF+Py1AL218MhRZqDRJGqcJqlxvONjnHtn5y4jD5BoyJ0NMuXcQsa/ZmGAClCvo=
X-Received: by 2002:a05:6214:2409:b0:605:648b:2adc with SMTP id
 fv9-20020a056214240900b00605648b2adcmr11265824qvb.19.1683122067145; Wed, 03
 May 2023 06:54:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683092380-29551-3-git-send-email-quic_rohiagar@quicinc.com>
 <CAHp75VegxMgAamS3ORiJ2=D4MH7asD9PiWrM+3JAm-QOuEgcrg@mail.gmail.com> <20a45e1e-6e62-9940-33d8-af7bad02b68d@quicinc.com>
In-Reply-To: <20a45e1e-6e62-9940-33d8-af7bad02b68d@quicinc.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 3 May 2023 16:53:50 +0300
Message-ID: <CAHp75VekkTVzVCJs10GEi=1Andb2rWTwK8RELw6SqMzKYCPq2w@mail.gmail.com>
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

On Wed, May 3, 2023 at 2:14=E2=80=AFPM Rohit Agarwal <quic_rohiagar@quicinc=
.com> wrote:
> On 5/3/2023 3:11 PM, Andy Shevchenko wrote:
> > On Wed, May 3, 2023 at 8:39=E2=80=AFAM Rohit Agarwal <quic_rohiagar@qui=
cinc.com> wrote:

...

> >>   /**
> >>    * struct msm_function - a pinmux function
> >> - * @name:    Name of the pinmux function.
> >> - * @groups:  List of pingroups for this function.
> >> - * @ngroups: Number of entries in @groups.
> >> + * @func: Generic data of the pin function (name and groups of pins)
> >>    */
> >>   struct msm_function {
> >> -       const char *name;
> >> -       const char * const *groups;
> >> -       unsigned ngroups;
> >> +       struct pinfunction func;
> >>   };
> > But why? Just kill the entire structure.
> Got it. Can we have a typedef for pinfunction to msm_function in the msm
> header file?

But why? You can replace the type everywhere it needs to be replaced.
I can't expect many lines to change.

Also consider splitting struct pingroup change out of this. We will
focus only on the struct pinfunction change and less code to review.

--=20
With Best Regards,
Andy Shevchenko

