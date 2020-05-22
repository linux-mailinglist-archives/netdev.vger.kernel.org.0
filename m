Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046121DEC05
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbgEVPgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgEVPgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:36:08 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15248C08C5C0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:36:07 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id z5so4917182qvw.4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=61+HQokeJZQ8qkHJ2OEdKbbtcdPY4X5ntDI2ko215XA=;
        b=FsB9N5UHSBWaHC/PI7gccIUfEYQI9QY2OJ2DpQw6NYmUIu/yS181SpbIsrMxh4tBq2
         251MX3ARNKmg1PIdHLrIfedovaTFRuT7fr6qAJ0OzP4eZ9kHh5QC9Uqu8z6t+H3RAa5L
         F060Wo09d4reWusv3yHvuVJT+swTL3Pz0DXKljhhGyA3kFwjN4C8iZYyafihOn7/z3Qg
         0IuxiDtjd4U1Id+/0zAMVIS4TwL0Ptw3vYEV4ApNhTbJ9HL4cLaRC/CpSTAqYS2lFN8k
         vztqA+6NvLDs6svcdY+jVjLfyDAKQ9YtsTkPHdPtxR9XEgWCjKhKy8Zuuz0XJ0fQto/0
         lmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=61+HQokeJZQ8qkHJ2OEdKbbtcdPY4X5ntDI2ko215XA=;
        b=F1khfKmmYwpioePNfypNfA1bCkn44TJkpDaQMrNuN5u8Nz4wSRr5t0MEeedxv8Q+Af
         xk8N+O5ke410MYBkYync2s/XYf/9ABMV1a9qtbs8tA1SPa07814yjiUjVrtQDd71RFcD
         cafQdYdIaEkGd2z3Gg3gfszEsal1uAkAEEHRftdBjwhbYzBvX4R6V7eIN4WTZiN7b1Dx
         NYLOXui8LmTNPHG20XM2ppHjt8yd1v7xwfbxL6uxtHJk8lYRH0Tctct6JRGnJ1VBVsDR
         HQox2yn0jkYDT+0WlowfM/Lb78LkzFCy+1QU1UVJhdEO3bWZrlPj7nQ4RnBgGtyo2Asa
         Xvmw==
X-Gm-Message-State: AOAM530rM1e46AHL+6/N0tfmuv+9GdsN1NX9HEUFrfsnqOfJOzZtuKpF
        O2Om156rGZ1GoGIv5LHJ5IzCj/p0DWk4nV3MEP/iaw==
X-Google-Smtp-Source: ABdhPJxlFh9zM8Njqgrp9/xR4Z1brfdmQPtm73E6Mi4XIQKqvXjo8/lYWwCLTLOHbqsxApeDG9Che+ylwvNrK03MWBo=
X-Received: by 2002:a0c:be88:: with SMTP id n8mr4247699qvi.134.1590161766309;
 Fri, 22 May 2020 08:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200522120700.838-1-brgl@bgdev.pl> <20200522120700.838-7-brgl@bgdev.pl>
 <5627e304-3463-9229-fa86-d7d31cad7a61@gmail.com>
In-Reply-To: <5627e304-3463-9229-fa86-d7d31cad7a61@gmail.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Fri, 22 May 2020 17:35:55 +0200
Message-ID: <CAMpxmJVg3VPt7Xu0U9Qnt4wYRmT75iryMDu1qaYdoGib1bhdiQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] net: ethernet: mtk-star-emac: new driver
To:     Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 22 maj 2020 o 17:06 Matthias Brugger <matthias.bgg@gmail.com> napisa=
=C5=82(a):
>
>
>
> On 22/05/2020 14:06, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > This adds the driver for the MediaTek STAR Ethernet MAC currently used
> > on the MT8* SoC family. For now we only support full-duplex.
>
> MT85** SoC family, AFAIU it's not used on MT81** devices. Correct?
>

It's used on MT81**, MT83** and MT85**. What's wrong with the
description anyway?

Bart
