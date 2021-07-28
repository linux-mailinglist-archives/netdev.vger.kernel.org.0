Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856363D89A6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbhG1ITv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 04:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbhG1ITu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 04:19:50 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37D8C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 01:19:48 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y200so2005644iof.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 01:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXJ3iSdjN7ziLNi8B75zID1RPfa0lMdMtXAJeHKQC5Q=;
        b=1jm7kcFdFsShboGcPAVuMVmI5c38f9CG1BzW+WNxMLnH52+G91UGv5/mRO+Nm/ka8S
         kk0oWW+43yc49SgJQaEei85sI2F59Epd7fXVjjPL8PqpYVOtaWkF8gHtLyDmGdW2AaCb
         zQqZKPJ8LBOauvI5tnwnm6B2oP/vTAL+VnmFv8HPr8glxgvCct/y2T8rTekQ1JKLcQ+k
         b2N3rRkLxh4/n0iOA8zKphA9NEQVq0gPKJsXyg2r/SZ2ajaVN7St8RrX1Hqe4SXRmtof
         HU/xF94k2f0QJnZ26hOt9x91S307vdE/CFPLr/HbcTy7Nb+5bBVoxD7ySslGOVUrtklz
         DsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXJ3iSdjN7ziLNi8B75zID1RPfa0lMdMtXAJeHKQC5Q=;
        b=p4lJIfYKk8HJLjMsBdot5DDQA1d0qn7JNlFYPe5CsskwqFR64e4RRr3k7acXJyA1bD
         9ox00hRVC0Gn4SoP9SMea/ZBOwq6zAsSKOQzVspR4zagowB4X/0msFwDs9tD0LoQnZMx
         EZCb7/N8Y3gRVXFnP3tedipAJDFhrA/yaBeSH+J++8EePBtBpoH3x7kHlPf4l15heRQc
         1RGGdh4qWWNmp0Bv2pZLpvNDf9ijGbjnCrU4GqWhw2J8ImZX9AzzPENMl/jYEjsw841r
         GaxSHjuTXTbmRZspDPOrSRJ0kupBk44lHPttYVMxN+RIV9hQDfdHuVyJDvXr3ysjI9IF
         gAVw==
X-Gm-Message-State: AOAM533STSEHlKFyYgd8pnJNsf/x8aV0n0039METJn3v2mudDZtSHRct
        RQfgus6j1A9uZLmNwP7rHIPrbkNY8r88zkvam0HVoA==
X-Google-Smtp-Source: ABdhPJwOOQFuY9CnUJtyVTQG5TdKmbbm2M/G37/DKj6HDG/BV+YfJEcFLl66GmqXME6btAvFcUjH0a4xqR9/YwC5NDs=
X-Received: by 2002:a02:90cb:: with SMTP id c11mr25819795jag.53.1627460388476;
 Wed, 28 Jul 2021 01:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com> <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
 <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
 <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
 <CANr-f5zWdFAYAteE7tX5qTvT4XMZ+kxaHy03=BnRxFbQLt3pUg@mail.gmail.com> <43958f2b-6756-056a-b2fa-cb8f6d84f603@xilinx.com>
In-Reply-To: <43958f2b-6756-056a-b2fa-cb8f6d84f603@xilinx.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 28 Jul 2021 10:19:37 +0200
Message-ID: <CANr-f5xu=xHn7CGve3=Msd8CEcoDujQzSYSNQ2Zbh7NOvyXFYA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 7:10 AM Michal Simek <michal.simek@xilinx.com> wrote:
> On 7/27/21 10:23 PM, Gerhard Engleder wrote:
> > On Tue, Jul 27, 2021 at 10:18 PM Rob Herring <robh+dt@kernel.org> wrote:
> >>> The evaluation platform is based on ZCU104. The difference is not
> >>> only the FPGA image. Also a FMC extension card with Ethernet PHYs is
> >>> needed. So also the physical hardware is different.
> >>
> >> Okay, that's enough of a reason for another compatible. You'll have to
> >> update the schema.
> >
> > Ok, I will update Documentation/devicetree/bindings/arm/xilinx.yaml.
>
> In past we said that we won't be accepting any FPGA description in
> u-boot/linux projects. I don't think anything has changed from that time
> and I don't want to end up in situation that we will have a lot of
> configurations which none else can try and use.

I agree that it does not make sense to add configurations that no one else
can try and use. The goal is that others can easily try out the IP. I want to
provide the FPGA image to others who are interested. It won't be many of
course.

> Also based on your description where you use evaluation board with FMC
> card it is far from any product and looks like demonstration configuration.

You are right, it is not product, which is addressed to end users. It is a
demonstration configuration for developers. Isn't that valid for all evaluation
boards? As a developer I'm very happy if I can do evaluation and development
without any vendor tree. I can do that now with the ZCU104. So a big thank
you from me for your work!

> You can add the same fragment to dt binding example which should be
> enough for everybody to understand how your IP should be described.

This dt binding example is already there.

So a device tree like this won't be accepted?

Gerhard
