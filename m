Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CDA3D9674
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhG1UO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhG1UOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 16:14:25 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E865CC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 13:14:23 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id y200so4283881iof.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 13:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ubJgrDNEMsCflqG4YOXZKMLlAzg0rRahHfeJ5NprhF4=;
        b=AUo6FFwz913kDcN1mpv6AVTcXif3PDz/6RQZXRMSov+XphL+u5wIBnKUG/Lg0GF14A
         LjWbd11MNhh3GEwvrf8gmBxImE+rzhg4WKpI+MQqE6Ccv/0jdOK5E7CDPeY3MQHFsBTv
         KQt7HGf8sQNcsOZcbXlXJ2ESxsxHdwzj5V6vqhmHdDGOOejzTSmh0Hgt94rqV6cB7vQM
         jBt6dkzL/xg0bk0MXWlfFSdiK6PotnaMpmZ6Dp0OEgHfxNOMEBCnJw9wIzfAkPaPFV0x
         WYu7PIdYykbV5F4IJfTeA3R0I0pTfUs0YZMCZOGOy8fGCBRV7YLTuJjZ3+K3VPRXkwVK
         r9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ubJgrDNEMsCflqG4YOXZKMLlAzg0rRahHfeJ5NprhF4=;
        b=gnlog459VgggXiXmc92R1imrM6Mlx60TmkeaXAFb+C0LNhVQUsHRVARmieMRzI1ZGN
         SikN5oTWdlf6KgSA092wDueyDy+6UpK4wj58kNtVMieeC4Q2LkvUlj7UFxG0xz5sNYXu
         bW2rJp/TCjPQusyseuCum0HYtT8dNzoMHqqJ6uFislpFI0QARbs32poAbnCUqE1CGfCo
         13M/i0bRIuXPmKwKv4n3SZ1OavcTuBMfV/j29V6vM0Xd95TsNmao6WbnqFQVx200IaLs
         uB0JiJSCrWveq2cI2gVrp2lWFFSwWQybS9M6hhiwF5ffUVrMipaxFZxFLRJXfi0TLz7Q
         ND/A==
X-Gm-Message-State: AOAM5302SkNwU43yj5/73R4GMs0pz0a1NW4fhuBkq5SJj46uAQpcJTUk
        XO6C9GwI6stCAcQ+dfKPpgfD1c0pHgUph5mw82SGrg==
X-Google-Smtp-Source: ABdhPJxzqdXkxuX25EnHM978DCQhthOlj+NIH/N6KcP4+iZ2prrC914LGZnIHH2uvlZ2pl+4CvlQWWbP61r6zbicC4M=
X-Received: by 2002:a05:6638:538:: with SMTP id j24mr1293839jar.59.1627503263335;
 Wed, 28 Jul 2021 13:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com> <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
 <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
 <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
 <ae17968a-e265-6108-233a-bd0538ad186c@xilinx.com> <CANr-f5zvWN6pFUqRHvYV9oMGhF+VBJzhK+yE+SqMuSEhA5-X7Q@mail.gmail.com>
 <b3921ff3-55d4-0d26-ebe3-2fee0c73332e@xilinx.com>
In-Reply-To: <b3921ff3-55d4-0d26-ebe3-2fee0c73332e@xilinx.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 28 Jul 2021 22:14:12 +0200
Message-ID: <CANr-f5y4=1hj-6WFT1HdewU=sich6KgkgmR6-qWimFxQiV5MFQ@mail.gmail.com>
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

On Wed, Jul 28, 2021 at 12:55 PM Michal Simek <michal.simek@xilinx.com> wrote:
> >>>>>> +      - enum:
> >>>>>> +        - engleder,tsnep
> >>>>>
> >>>>> tsnep is pretty generic. Only 1 version ever? Or differences are/will
> >>>>> be discoverable by other means.
> >>>>
> >>>> Differences shall be detected by flags in the registers; e.g., a flag for
> >>>> gate control support. Anyway a version may make sense. Can you
> >>>> point to a good reference binding with versions? I did not find a
> >>>> network controller binding with versions.
> >>>
> >>> Some of the SiFive IP blocks have versions. Version numbers are the
> >>> exception though. Ideally they would correspond to some version of
> >>> your FPGA image. I just don't want to see 'v1' because that sounds
> >>> made up. The above string can mean 'v1' or whatever version you want.
> >>> I'm fine if you just add some description here about feature flag
> >>> registers.
> >>
> >> Don't Xilinx design tool (vivado) force you to use IP version?
> >> Normally all Xilinx IPs have certain version because that's the only way
> >> how to manage it.
> >
> > Yes I use an IP version in the Xilinx design tool. I use it as a version of the
> > VHDL code itself. In my case this version is not related to the
> > hardware software
> > interface. The goal is to keep the hardware software interface compatible, so
> > the IP version should not be relevant.
>
> I expect this is goal for everybody but it fails over time. We normally
> compose compatible string for PL based IP with IP version which is used.
> And it is quite common that couple of HW version are SW compatible to
> each other.
> It means use the same HW version as you use now. When you reach the
> point when your HW IP needs to be upgraded and will require SW alignment
> you have versions around which can be used directly.

I would like to follow the argument from Rob:
"The above string can mean 'v1' or whatever version you want."
If there ever is an incompatible new IP version, then a new compatible string
can be added which means 'v2'. E.g. for 128bit physical address support I
would choose the compatible string 'engleder,tsnep128'. I don't see an
advantage in adding a version number to the compatible string.

This IP will be used in products where compatible hardware is a must.
An IP upgrade which requires SW alignment will result in heavy complaints
from the customers. Such an IP upgrade would result in a new IP.
Like for shared libraries, an incompatible API change is similar to a new
library.

Gerhard
