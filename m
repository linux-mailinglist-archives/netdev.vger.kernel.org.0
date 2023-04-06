Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8AD6D97BC
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbjDFNP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbjDFNP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:15:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6415B81
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:15:25 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q19so36416870wrc.5
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 06:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680786923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8jl2u7ZgIomwOzSs9gTkCTnXd22WXIrlnSqWMsc6pk=;
        b=kDBn/dmCu985IQTLBWCcwWI4Q9kXEIZSWrO1xFMeJQadLDT4SmbNj2tA7fAkrtBVEx
         190VkK3IKSdOk7aMZx7xCFQ17vXvjKmyYziqzMMhWweLUjvgVB9szl7TjqmcN/k1BHGH
         Wl4moR+0SxMj4ggSdodfBomBhH659fuLkjeRgVLewmGkGz9hzH44HXr40SiMWV1wLqX0
         NNZoziQBeyroM3nmA1mh/FNGhcQPe2xKWjbF1m39mZBBwkduYncrQDySUTdu9QEUrjRg
         zrojhwYu+SMIaYU30i2GwOA6ne+96eUz6nZHRrDdYjOTJ1th/biVY5IPD2t64JDzwsmS
         GIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680786923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8jl2u7ZgIomwOzSs9gTkCTnXd22WXIrlnSqWMsc6pk=;
        b=RPc7wNvSe8W3Y1GjcQyOxHXnB9VCSx7z8ZjK4npiVd9CsopxLADsnLiuC5/LwfN/s6
         MtYFniFTiG+5gAYbtBfe6KGEvy47N+Aw41haiNHbs98aDVixzWrUvV/jQ5aMndQoxY+m
         TNSH9eLnkAa/XOHIIXTx8WDvZ8BrrpFYwlNMr2WdXIyxFn0hRoxeDYkcLBwTgE0RJ2MN
         bjFMQ/aqhsQH0zsBf2+WVy4xLjZ8rgZ91Vbtv25QpNcvgeYwzm7DHRiJoinw7lpSXO8G
         o1rjjKKhf2xhaASFIomKuYajvjaaEGKEwfG1An5QgjX9MlsdXoZvJum0XDRN2EtzsL2m
         T73g==
X-Gm-Message-State: AAQBX9eqRk84EmmNXNaFQBPdh9Jzc3fc/oKouu2zZ+zMV5xOVw6iKlVF
        1Mg/aGUeFloAWFyk+Lbmd8vj6lcMa8AfAjIEgn0uAQ==
X-Google-Smtp-Source: AKy350bq2EBTopZZNM0f+YHHQfpscHHsUX8kWBbB0wT9Q3Hobf/OeHI3zi0Ixs6k5NucJt4veM2MPKre5NBx7CjYTLY=
X-Received: by 2002:a5d:47a7:0:b0:2ee:b548:c64f with SMTP id
 7-20020a5d47a7000000b002eeb548c64fmr803994wrb.3.1680786923515; Thu, 06 Apr
 2023 06:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230404115336.599430-1-danishanwar@ti.com> <86ee5333-6d65-d28b-0dd5-40dfe485d48b@ti.com>
In-Reply-To: <86ee5333-6d65-d28b-0dd5-40dfe485d48b@ti.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Thu, 6 Apr 2023 07:15:12 -0600
Message-ID: <CANLsYkyrvAcVa8VNkbsrxyAC-60fyGYoXVS=fqwLcsMverzNcg@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Introduce PRU platform consumer API
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 at 00:54, Md Danish Anwar <a0501179@ti.com> wrote:
>
> On 04/04/23 17:23, MD Danish Anwar wrote:
> > Hi All,
> > The Programmable Real-Time Unit and Industrial Communication Subsystem =
(PRU-ICSS
> > or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
> > (Programmable Real-Time Units, or PRUs) for program execution.
> >
> > There are 3 foundation components for TI PRUSS subsystem: the PRUSS pla=
tform
> > driver, the PRUSS INTC driver and the PRUSS remoteproc driver. All of t=
hem have
> > already been merged and can be found under:
> > 1) drivers/soc/ti/pruss.c
> >    Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> > 2) drivers/irqchip/irq-pruss-intc.c
> >    Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc=
.yaml
> > 3) drivers/remoteproc/pru_rproc.c
> >    Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> >
> > The programmable nature of the PRUs provide flexibility to implement cu=
stom
> > peripheral interfaces, fast real-time responses, or specialized data ha=
ndling.
> > Example of a PRU consumer drivers will be:
> >   - Software UART over PRUSS
> >   - PRU-ICSS Ethernet EMAC
> >
> > In order to make usage of common PRU resources and allow the consumer d=
rivers
> > to configure the PRU hardware for specific usage the PRU API is introdu=
ced.
> >
> > This is the v7 of the old patch series [9].
> >
>
> Hi Mathieu, Can you please review this series. I have addressed comments =
made
> by you in v5. I have also addressed Simon's comment in v6 and removed red=
undant
> macros from pruss.h header file.
>

You are pushing me to review your code 19 hours after sending the last
revision?  Are you serious?

> > Changes from v6 [9] to v7:
> > *) Addressed Simon's comment on patch 3 of this series and dropped unne=
cassary
> > macros from the patch.
> >
> > Changes from v5 [1] to v6:
> > *) Added Reviewed by tags of Roger and Tony to the patches.
> > *) Added Acked by tag of Mathieu to patch 2 of this series.
> > *) Added NULL check for @mux in pruss_cfg_get_gpmux() API.
> > *) Added comment to the pruss_get() function documentation mentioning i=
t is
> > expected the caller will have done a pru_rproc_get() on @rproc.
> > *) Fixed compilation warning "warning: =E2=80=98pruss_cfg_update=E2=80=
=99 defined but not used"
> > in patch 3 by squashing patch 3 [7] and patch 5 [8] of previous revisio=
n
> > together. Squashed patch 5 instead of patch 4 with patch 3 because patc=
h 5 uses
> > both read() and update() APIs where as patch 4 only uses update() API.
> > Previously pruss_cfg_read()/update() APIs were intoroduced in patch 3
> > and used in patch 4 and 5. Now these APIs are introduced as well as use=
d in
> > patch 3.
> >
>
>
> --
> Thanks and Regards,
> Danish.
