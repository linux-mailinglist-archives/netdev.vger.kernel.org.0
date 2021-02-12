Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB3231A5A2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBLTvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:51:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhBLTvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 14:51:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5306C64E2B;
        Fri, 12 Feb 2021 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613159456;
        bh=+jZNSXASRKJbVihU0PCI0TJ9OGQXrg2LKG1WrjZJIgs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JhtBFXoGZUHWLOqWkA5XyPMUhsah0NvARU8luvp2B85iaT8O2dHlbbQtIEi/q/QVR
         mzwhMSsKUd8fJ9h7B88cz7n03dKtwUI01NsHni8p8eLkF4Ei18CUXNl+C4GF8YO6TM
         Ls3bnSUnKb8ZxJTt/VyZxNO/40fhrWr9KlUaRSaeLgDjJw9fZBbhiXIQge2CQfTJ4Z
         ay84UME2iq9K1PMYwI/4EFBrcSP8HQogW3HZXZ2OYSpiQZ1P/SwPMN/mSjM4HYIIIB
         omGYSpHaGlPZ5pqWOuimBT8lgbQU1CYCcngQ+ENn6tVqYgvIjQZpggN77U5dq0rqDV
         heiRtjyotwkaA==
Received: by mail-oi1-f176.google.com with SMTP id d20so858070oiw.10;
        Fri, 12 Feb 2021 11:50:56 -0800 (PST)
X-Gm-Message-State: AOAM530YBdEvpvfE+IFP0+B9p6U4JblzpKd8i7IRktvkpwFBj85xnNM2
        1Z+7UGBwFSPFwIpEK7ShEVwAKj9LGfQGUjTd898=
X-Google-Smtp-Source: ABdhPJxZ6eS625gu7tCP3jyhoqzsmf/FtIBFwRQIDAEQc4KaCDOmL6Ivz2W9OCHRIBdzssaLb91SOBuyyD32FdF0usg=
X-Received: by 2002:aca:d908:: with SMTP id q8mr749970oig.67.1613159455601;
 Fri, 12 Feb 2021 11:50:55 -0800 (PST)
MIME-Version: 1.0
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com> <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 12 Feb 2021 20:50:39 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
Message-ID: <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
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

On Fri, Feb 12, 2021 at 5:19 PM Min Li <min.li.xe@renesas.com> wrote:
>
> >
> > Ah, so if this is for a PTP related driver, it should probably be integrated into
> > the PTP subsystem rather than being a separate class.
> >
>
> I was trying to add these functions to PHC subsystem but was not accepted because the functions
> are specific to Renesas device and there is no place for those functions in PHC driver.

It would be useful to explain that in the patch description and link
to the original
discussion there. What exactly was the objection?

> > > > This tells me that you got the abstraction the wrong way: the common
> > > > files should not need to know anything about the specific
> > implementations.
> > > >
> > > > Instead, these should be in separate modules that call exported
> > > > functions from the common code.
> > > >
> > > >
> > >
> > > I got what you mean. But so far it only supports small set of
> > > functions, which is why I don't feet it is worth the effort to over abstract
> > things.
> >
> > Then maybe pick one of the two hardware variants and drop the abstraction
> > you have. You can then add more features before you add a proper
> > abstraction layer and then the second driver.
> >
>
> If I come up with a new file and move all the abstraction code there,
> does that work?

I think so, but it's more important to figure out a good user space
interface first. The ioctl interfaces should be written on a higher-level
abstraction, to ensure they can work with any hardware implementation
and are not specific to Renesas devices.

Can you describe on an abstract level how a user would use the
character device, and what they achieve by that?

       Arnd
