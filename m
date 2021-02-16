Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2912D31D1B7
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhBPUps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229767AbhBPUpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 15:45:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF1B664E0F;
        Tue, 16 Feb 2021 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613508302;
        bh=rOeuFZ6Y/l/ecXy81XM0438EC3ZMAbCvHSH0pFo/szA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mktU5rtJ2BanR+JPWtkUuUxMnhAsk1Wcw6C130rlEY2RXTZ8/ZjOdUJbhhRW0kzYE
         8xQyHir3X0JDGFoodBAuuqg9jhfrAMMu9j6UFgSX3H/pnXO4m7GNsiYltPNYAOIwbf
         hcl1/L4b6P9/KdAQcQfUx8YoexEaWXh18aj2/XzZNg9qCfeYOTEaPQ7vv2g4iLhlmr
         ZO9fNvCKSQ+iZgDFpx1h4CRSS2INHcro124M5pL442lEBVZN3NeEiZ0cYe2aUnSltD
         Ji2WjzQYLir9DSUWtbasCLFrrbBw5UnOEg4UBCcPpwmyQKVoS8zUgSr3eT2o5SbR0S
         W8omgMSeEMFqA==
Received: by mail-oi1-f178.google.com with SMTP id h17so8721944oih.5;
        Tue, 16 Feb 2021 12:45:01 -0800 (PST)
X-Gm-Message-State: AOAM532AaFyM/OCd4tl7igqcZY09clrrZJEN9lfWVMH/i0YbwxdxIHDs
        M0Y9D1aXDQvC/oPbKQc/iPsDuJ3lgeoQGTfNjOI=
X-Google-Smtp-Source: ABdhPJwG6kW2B7NLoKxJeJQv+NBIKybJoyNzbmV5gqHDs7/mS7FoIXx3B4fyR5t+nBfgX233gnDvLvoyU8rr4SIBbls=
X-Received: by 2002:aca:e103:: with SMTP id y3mr3589679oig.11.1613508301169;
 Tue, 16 Feb 2021 12:45:01 -0800 (PST)
MIME-Version: 1.0
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com> <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 16 Feb 2021 21:44:45 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
Message-ID: <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
Subject: Re: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
To:     Min Li <min.li.xe@renesas.com>
Cc:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 6:10 PM Min Li <min.li.xe@renesas.com> wrote:
> > > If I come up with a new file and move all the abstraction code there,
> > > does that work?
> >
> > I think so, but it's more important to figure out a good user space interface
> > first. The ioctl interfaces should be written on a higher-level abstraction, to
> > ensure they can work with any hardware implementation and are not
> > specific to Renesas devices.
> >
> > Can you describe on an abstract level how a user would use the character
> > device, and what they achieve by that?
>
> This driver is meant to be used by Renesas PTP Clock Manager for
> Linux (pcm4l) software for Renesas device only.
>
> About how pcm4l uses the char device, pcm4l will open the device
> and do the supported ioctl cmds on the device, simple like that.
>
> At the same time, pcm4l will also open ptp hardware clock device,
> which is /dev/ptp[x], to do clock adjustments.

I can't help but think you are evading my question I asked. If there is no
specific action that this pcm4l tool needs to perform, then I'd think
we should better not provide any interface for it at all.

I also found a reference to only closed source software at
https://www.renesas.com/us/en/software-tool/ptp-clock-manager-linux
We don't add low-level interfaces to the kernel that are only
usable by closed-source software.

Once you are able to describe the requirements for what pcm4l
actually needs from the hardware, we can start discussing what
a high-level interface would look like that can be used to replace
the your current interface, in a way that would work across vendors
and with both pcm4l and open-source tools that do the same job.

      Arnd
