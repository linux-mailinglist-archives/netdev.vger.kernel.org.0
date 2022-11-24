Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670636374BD
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKXJFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiKXJE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:04:56 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C7D112C4D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:04:54 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id e141so1151419ybh.3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQMn/QyPPR2r1LCYoxqFu28Ro+07zKB9FKhQSMwSCuA=;
        b=53uPRna67y5ORU5RPKz1WcXbdcnaVn8LOEwexY9S7887D5qkBKi1gNKPt43omOSSbx
         9wjuPNuzTzvMvcwNwruYYb5xvqNsbNDU/Yc1o+qWsq3dzLPLil07tXZT3yJSc6zZpRIG
         DlWtO0VLqN+38ET8jvkL6ezI7QAg0dbETE/vI56ICDvX+77nNa9PjZgviS3q7lYfqRr2
         N/aSrpMGjBN6alIBG4N4b+zjSdt27hlTo/naz+E9ucl4yrKzdzj3IHNTs/eEFg3R6lVP
         cTvWpJD6MEbejZ8ATMQ9H4qX+HM1HzWfvkrLjc4bH1v24kX/6h9rDeT0ad4iAYjcGmiG
         ZJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQMn/QyPPR2r1LCYoxqFu28Ro+07zKB9FKhQSMwSCuA=;
        b=0K0tsXJHuX/IpZUtjOE88KKIlMDkl1lcHWzcvNmosGR2s1z/CYUecUZZAzTV6+ByNH
         ms+wmMl8UwcOTAFoirbsbRmr1impEkE+IVFf+pUc5N7qlQjbf3OoQqTEfK2EXEGQ4Jzy
         R8WWN/3jyViDDTvzWdL7/nx3USG5TUQw6R8FOlgJG1mx30YVetyx+DpRqhnys3opNsDA
         YXR7NpfnFdF/mVT/YrfGw88xnPDk582b8rSf4CNi/nwcnCAL2Vv5mJ8FgCeyWFwdm0AB
         q0gsbBt2YkNECSduYnTQv595+vGWC9LMV7sosQ+XaBgIbEpNCiYheY63I1HAZxy+lLKo
         KtiA==
X-Gm-Message-State: ANoB5pnig9SZNWsKsRf42wupIn63HOHWbnbNxP8wysg+E3/kLLrG3Byp
        jSecelmzyhHY11VyXTGQSMed1jMM/KpiALEjC52GFQ==
X-Google-Smtp-Source: AA0mqf4/98SG5FePo0fHg3o1sgkYBRPrR934rSaKrm0ZYEpLYaIfbM9/Qa7CPjKox6A/TJnwoLcZw7wg1gnYQTuty5g=
X-Received: by 2002:a5b:49:0:b0:6cf:cfa9:94e9 with SMTP id e9-20020a5b0049000000b006cfcfa994e9mr12484087ybp.35.1669280693699;
 Thu, 24 Nov 2022 01:04:53 -0800 (PST)
MIME-Version: 1.0
References: <20221108181144.433087-1-nfrayer@baylibre.com> <20221108181144.433087-3-nfrayer@baylibre.com>
 <d0a8d451-2068-6536-3969-5cdfcd09d595@infradead.org>
In-Reply-To: <d0a8d451-2068-6536-3969-5cdfcd09d595@infradead.org>
From:   Nicolas Frayer <nfrayer@baylibre.com>
Date:   Thu, 24 Nov 2022 10:04:42 +0100
Message-ID: <CANyCTtRc=aUcU5zFR6+fR-2HQ4UeKsuN-1okQXMuJNXVTCqdUw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] soc: ti: Add module build support
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Nishanth Menon <nm@ti.com>, ssantosh@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>, vkoul@kernel.org,
        dmaengine@vger.kernel.org, grygorii.strashko@ti.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Guillaume La Roque <glaroque@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

Le mar. 8 nov. 2022 =C3=A0 19:18, Randy Dunlap <rdunlap@infradead.org> a =
=C3=A9crit :
>
> Hi--
>
> On 11/8/22 10:11, Nicolas Frayer wrote:
> > Added module build support for the TI K3 SoC info driver.
> >
> > Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
> > ---
> >  arch/arm64/Kconfig.platforms |  1 -
> >  drivers/soc/ti/Kconfig       |  3 ++-
> >  drivers/soc/ti/k3-socinfo.c  | 11 +++++++++++
> >  3 files changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platform=
s
> > index 76580b932e44..4f2f92eb499f 100644
> > --- a/arch/arm64/Kconfig.platforms
> > +++ b/arch/arm64/Kconfig.platforms
> > @@ -130,7 +130,6 @@ config ARCH_K3
> >       select TI_SCI_PROTOCOL
> >       select TI_SCI_INTR_IRQCHIP
> >       select TI_SCI_INTA_IRQCHIP
> > -     select TI_K3_SOCINFO
> >       help
> >         This enables support for Texas Instruments' K3 multicore SoC
> >         architecture.
> > diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
> > index 7e2fb1c16af1..1a730c057cce 100644
> > --- a/drivers/soc/ti/Kconfig
> > +++ b/drivers/soc/ti/Kconfig
> > @@ -74,7 +74,8 @@ config TI_K3_RINGACC
> >         If unsure, say N.
> >
> >  config TI_K3_SOCINFO
> > -     bool
> > +     tristate "TI K3 SoC info driver"
> > +     default y
>
> Maybe
>         default ARCH_K3
> ?

You're correct this should be defaulted to ARCH_K3.
This series will be dropped as it introduces dependency issues with
consumer drivers.

>
> >       depends on ARCH_K3 || COMPILE_TEST
> >       select SOC_BUS
> >       select MFD_SYSCON
>
>
> --
> ~Randy
Thanks,
Nicolas
