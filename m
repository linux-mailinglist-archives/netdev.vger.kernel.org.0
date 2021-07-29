Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A173D9E0B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhG2HHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbhG2HHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:07:21 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331BBC061757
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:07:18 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id q18so4753215ile.9
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7tWRI2/pBsm3KiewYI+IUt6wiFkejoi1mmnLILvYmc=;
        b=sT5JTE6XinjkASQnvhqTkRgdbM2Plu97ocAZcRrBRdX+ZThyfzmnZXDm2cxJ8XGYI8
         2HznEkK46F2ghVgtKcIbNSoFjtIzhHnsXZqn6C7P57bXHiEeKf7vOWG42FCBDgiL+GE4
         nJ+stW5ratEg+5YpD3qlqgHxuVuYlogWDwIwoXVm/N2xRQ9CVkoX+eRrqCdCNdb1Ai2q
         cWept1McEdaQ/3F8JEFiGn6E/O8q8NeV+MkjQXYt5m02WYcX/7qKZP5S4e6WKkkjEFn/
         F1nfWwhh+Jli0PlcLkGy2fFrUVwCVPsHL8KLDT7m2gQEggFRXP8J4SCWaaWv8zRjPvIh
         esfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7tWRI2/pBsm3KiewYI+IUt6wiFkejoi1mmnLILvYmc=;
        b=DviSfZF2jYDRJ3nXIp8N5GFaH03TrsXrMOL9PtkZo0SLdgvHzrWWL0HqC0j/izmq4i
         h0sAHxvJ4bpg0oyDWj466CjiPd3eoPrx6H+J0BQVZX/G9E5bUY7dpvYdEKaZhjpM3xaG
         ZhS6SZh6+4cV3wrxJjsW3k+rpCfnKlmFqTtabYxBuKq3lLJb7Ipai7tveK/AocfHK6Fs
         8mlAr/5LooXUt0LOhDRT9W4K+TwGNXszng0M1/NXgFOjdS8YiM8qiq0H/zLT5KrUoJqO
         newaZaarXtij/9SWavR7JzXDn+JXmogrma27f66AtrDBcee/jflXxkLssdwm+VBCXXlb
         8vZg==
X-Gm-Message-State: AOAM531BhX9AMm12JEzZMxfGNuwpD2XLVKEykSpGq4ovq5GBHvAER3JE
        m3f5yv5JI7DRgPovwDIkLfqagkCHwI5/JNLtATB+lA==
X-Google-Smtp-Source: ABdhPJygcOzVJpOIGLdlyW/c4B2i5pB2/N0Hgv6RXIUsYWMi5xQM67oaenWnR+ocJnNBnz6lvlGXhc4JKOzyHSCAqvw=
X-Received: by 2002:a92:cec5:: with SMTP id z5mr2493504ilq.226.1627542437600;
 Thu, 29 Jul 2021 00:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com> <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
 <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
 <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
 <ae17968a-e265-6108-233a-bd0538ad186c@xilinx.com> <CANr-f5zvWN6pFUqRHvYV9oMGhF+VBJzhK+yE+SqMuSEhA5-X7Q@mail.gmail.com>
 <b3921ff3-55d4-0d26-ebe3-2fee0c73332e@xilinx.com> <CANr-f5y4=1hj-6WFT1HdewU=sich6KgkgmR6-qWimFxQiV5MFQ@mail.gmail.com>
 <2a151f9a-f743-31f4-a4c1-cdf15daf1b67@xilinx.com>
In-Reply-To: <2a151f9a-f743-31f4-a4c1-cdf15daf1b67@xilinx.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 29 Jul 2021 09:07:06 +0200
Message-ID: <CANr-f5wuZTo-bH2rvB8oCGKJe4Qmg-gz9r7ym_VhWemP42o2sQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet controller
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 7:07 AM Michal Simek <michal.simek@xilinx.com> wrote:
> On 7/28/21 10:14 PM, Gerhard Engleder wrote:
> > On Wed, Jul 28, 2021 at 12:55 PM Michal Simek <michal.simek@xilinx.com> wrote:
> >>>>>>>> +      - enum:
> >>>>>>>> +        - engleder,tsnep
> >>>>>>>
> >>>>>>> tsnep is pretty generic. Only 1 version ever? Or differences are/will
> >>>>>>> be discoverable by other means.
> >>>>>>
> >>>>>> Differences shall be detected by flags in the registers; e.g., a flag for
> >>>>>> gate control support. Anyway a version may make sense. Can you
> >>>>>> point to a good reference binding with versions? I did not find a
> >>>>>> network controller binding with versions.
> >>>>>
> >>>>> Some of the SiFive IP blocks have versions. Version numbers are the
> >>>>> exception though. Ideally they would correspond to some version of
> >>>>> your FPGA image. I just don't want to see 'v1' because that sounds
> >>>>> made up. The above string can mean 'v1' or whatever version you want.
> >>>>> I'm fine if you just add some description here about feature flag
> >>>>> registers.
> >>>>
> >>>> Don't Xilinx design tool (vivado) force you to use IP version?
> >>>> Normally all Xilinx IPs have certain version because that's the only way
> >>>> how to manage it.
> >>>
> >>> Yes I use an IP version in the Xilinx design tool. I use it as a version of the
> >>> VHDL code itself. In my case this version is not related to the
> >>> hardware software
> >>> interface. The goal is to keep the hardware software interface compatible, so
> >>> the IP version should not be relevant.
> >>
> >> I expect this is goal for everybody but it fails over time. We normally
> >> compose compatible string for PL based IP with IP version which is used.
> >> And it is quite common that couple of HW version are SW compatible to
> >> each other.
> >> It means use the same HW version as you use now. When you reach the
> >> point when your HW IP needs to be upgraded and will require SW alignment
> >> you have versions around which can be used directly.
> >
> > I would like to follow the argument from Rob:
> > "The above string can mean 'v1' or whatever version you want."
> > If there ever is an incompatible new IP version, then a new compatible string
> > can be added which means 'v2'. E.g. for 128bit physical address support I
> > would choose the compatible string 'engleder,tsnep128'. I don't see an
> > advantage in adding a version number to the compatible string.
> >
> > This IP will be used in products where compatible hardware is a must.
> > An IP upgrade which requires SW alignment will result in heavy complaints
> > from the customers. Such an IP upgrade would result in a new IP.
> > Like for shared libraries, an incompatible API change is similar to a new
> > library.
>
> From my point of view where I expect the most of customers are using
> Xilinx DTG (device tree generator) compatible string is composed with IP
> name and version used in design tool. This is unique combination which
> properly describes your HW.
> And choosing different compatible string or string without version is
> breaking this connection between hw design tool and sw.
>
> From my perspective it is much simpler to understand that your HW ip
> called ABC-rev1 requires DT node which is your_company,ABC-rev1 instead
> of any made name.
> But up2you - you will be talking to your customers.

Thanks for explaining your point of view. From my side I don't expect that
Xilinx DTG is used. The few people I know who are working with Zynq/ZynqMP
are using the Xilinx tools only to generate the bitstream. This way you are able
to do software development for the Zynq/ZynqMP like for any other hardware
platform.

Thanks for your Feedback!

Gerhard
