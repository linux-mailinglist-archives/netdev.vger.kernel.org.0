Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1017376CE3
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhEGWhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGWhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 18:37:45 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B10BC061574;
        Fri,  7 May 2021 15:36:45 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id x9so3322184uao.3;
        Fri, 07 May 2021 15:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b7SX7qLCM1WLkyOXKXr7x2SnRM68jsAlaH9i3EjxTDc=;
        b=PfdS5NDIy+rUTOaYBNbyqSuOAALBBPWIDfjQhcZ3p6xEqWrFtZerDWhiWcjfOmGF4Q
         a04JdapesIUE+i9QusAv3VxUCbRlS/LGrPa/HmdWSO0DTGUXMf+WuhqXDX/aMIgqDFCu
         wTVDLNSBM25FTa0aV1N3yF+TuuUzcfCJNSoT9cmFyB5PIySIzWdQp/XwrFkWhXqOcYt/
         fxo7Kvu57PP2Ht74jd2nQ5Xvsn41i3PdKxUPEH1hjOkA7ZRVwVW/3vOIvsqEMxyfAtq1
         nhCYydI5u6iio/kQ/NbNSgRjJZxGf5Gpybdo1cuiEHKSddaPJJ9EbZFR/IBnNPJ8m84B
         nEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b7SX7qLCM1WLkyOXKXr7x2SnRM68jsAlaH9i3EjxTDc=;
        b=Qjx3ftkC/bIPNy7TCUuTc+1zHoHsM7va2E7Eu1CdeWDiKwwAuGz+T/8V+ECpr41EIr
         N6VAIQmVcZev/+2OLfb1iv7K9JOvZL0bycCKIHmJWW6lRh61zYZfImrBnjlPqmMSr3sd
         1rDnXeiNX416s4wvhuxR8SOP0dPHYUdJAZgDIEjhbI/iGYHLGKjCxKmvM17cvAjg2fCx
         YJ/SPvevxUvVi+7j+mf3y1Nn3mjMsGpDqRtGyx4+Xn5BXM3U2d3X5nq8rvQrmRlw98Cx
         uzu3tAA3b0+hjeosxMfGpt3lnEFsKdvnfRc0HB0InBJzkuMHI5fXfJ3eI1Gg4dM60fD4
         EHng==
X-Gm-Message-State: AOAM533RiUYiPODQifJkHkbVukOfbsGtsE1aJaAO1gxE9o07QrDO5Od3
        t3WzkxPArfTmHMbRFbuxAxCQhsNi+9P9jG0uoQnoalRJM8bk6g==
X-Google-Smtp-Source: ABdhPJx+oBo9o19LC6Z3dtB4RSeSDPSsS5tIrSvFxY/Wl+yAd922f/5bf7jlOwDjkNDpICJ8uZd0tey5XVUAXGyhofA=
X-Received: by 2002:a9f:376a:: with SMTP id a39mr12020731uae.12.1620427004379;
 Fri, 07 May 2021 15:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210407080118.1916040-1-mkl@pengutronix.de> <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de> <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
In-Reply-To: <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
From:   Drew Fustini <pdp7pdp7@gmail.com>
Date:   Fri, 7 May 2021 15:36:32 -0700
Message-ID: <CAEf4M_Dg5u=b+fYwXDUMRGSXeXHuo-bXZmzoAs2bW0kFncMSQg@mail.gmail.com>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Drew Fustini <drew@beagleboard.org>, netdev@vger.kernel.org,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Will C <will@macchina.cc>, menschel.p@posteo.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 12:56 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 22.04.2021 09:18:54, Marc Kleine-Budde wrote:
> > On 4/21/21 9:58 PM, Drew Fustini wrote:
> > > I am encountering similar error with the 5.10 raspberrypi kernel on
> > > RPi 4 with MCP2518FD:
> > >
> > >   mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=4,
> > > data=00 ad 58 67, CRC=0xbbfd) retrying
> >
> > What's the situation you see these errors?
> >
> > I'm not particular happy with that patch, as it only works around that one
> > particular bit flip issue. If you really hammer the register, the driver will
> > still notice CRC errors that can be explained by other bits flipping. Consider
> > this as the first order approximation of a higher order problem :) - the root
> > cause is still unknown.
> >
> > > Would it be possible for you to pull these patches into a v5.10 branch
> > > in your linux-rpi repo [1]?
> >
> > Here you are:
> >
> > https://github.com/marckleinebudde/linux-rpi/tree/v5.10-rpi/backport-performance-improvements
> >
> > I've included the UINC performance enhancements, too. The branch is compiled
> > tested only, though. I'll send a pull request to the rpi kernel after I've
> > testing feedback from you.
>
> Drew, Patrick, have you tested this branch? If so I'll send a pull
> request to the raspi kernel.

Thank you for following up.

I need to build it and send it to the friend who was testing to check
if the CRC errors go away.  He is testing CANFD with a 2021 Ford F150
truck.  I will follow up here once I know the results.

-Drew
