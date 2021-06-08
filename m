Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF339EFDD
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhFHHrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHHro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 03:47:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09E3861184
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 07:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623138352;
        bh=AkUl8Q24/0XKmG2S67RhU07Q4g50X3FT6MduHRZDzyU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DyWzA7ndYEiuQ1awn5A4Yl/dTGFu8uPqgudOYq6SAVZZ3epxd/0V7J64+gzWDm/MB
         Rtg2+zP1r4rlSI6m7CpOk/Lley2e7LjHThRfBZfPWk8Xt+fLn8PjDBpmhIqDK6seqR
         wtrUpd9F8R4bTd5Q19OpSElEGRTQAQSBiAzS/oJYY/tGODcy3v6zbvwP1Vdhe0hfU6
         yRcDCX6n/UFsPvy8FEUb4uqiEf37oHPMXea32lS5YTumPgRAcHUwdNy+NjXjMISFqh
         NgZI7psqdG8FfttLppU9NRexmW4WKe8WkOgQnsDMVfxTAM7qebEg+Gb+edEWC0F5AI
         IVkz37QXUTFNQ==
Received: by mail-wm1-f54.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso1060179wmc.1
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 00:45:51 -0700 (PDT)
X-Gm-Message-State: AOAM5312M/y1t0oiQKoBdjLaF1cRDaCrgMDKwthEQ1fr19bmGXrWWkj5
        mhQ6sUTqciby/8mrkUf6h6x8c7aoxXheAQsbJ4g=
X-Google-Smtp-Source: ABdhPJw7eQojZkth660KJeQokoKOzuKw7ZUeqo2yjiAiDJRC3w+i13NNzA6abSZrUFp+ELanfgn4vP2c62MPFqMenKY=
X-Received: by 2002:a1c:7d15:: with SMTP id y21mr2739827wmc.120.1623138350627;
 Tue, 08 Jun 2021 00:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
 <60BEA6CF.9080500@gmail.com>
In-Reply-To: <60BEA6CF.9080500@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 8 Jun 2021 09:44:00 +0200
X-Gmail-Original-Message-ID: <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
Message-ID: <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 1:07 AM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
> 02.06.2021 12:12, Arnd Bergmann:
> [...]
> > I think the easiest workaround to address this reliably would be to move all
> > the irq processing into the poll function. This way the interrupt is completely
> > masked in the device until the poll handler finishes, and unmasking it
> > while there
> > are pending events would reliably trigger a new irq regardless of level or edge
> > mode. Something like the untested change at https://pastebin.com/MhBJDt6Z .
> > I don't know of other drivers that do it like this though, so I'm not
> > sure if this causes a different set of problems.
>
> I started applying your patch (trying to morph it a little bit so as to
> shove in a minimally invasive manner into 4.14) and then noticed that it
> probably won't work as intended. If I'm not mistaken this rx poll thing
> is only active within kind of "rx bursts", so it is not guaranteed to be
> continually running all the time when there is no or little rx input.
> I'd suppose some new additional work/thread would have to be introduced
> in order for such approach to be reliably implemented.

The basic idea of the napi poll function is to do batch processing as much
as possible and avoid excessive interrupts when the system is already
busy processing the received data.

However, it should not lead to any missed interrupts with my patch:
at any point in time, you have either all hardware interrupts enabled,
or you are in napi polling mode and are guaranteed to call the poll
function within a relatively short timespan. If you have no pending
rx events, processing should be pretty much instantaneous, it just
gets pushed from the irq handler to immediately following the irq
handler. If there is a constant stream of incoming data, it gets
moved into softirqd context, which may be delayed when there is
another thread running.

        Arnd
