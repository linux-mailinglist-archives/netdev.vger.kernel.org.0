Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2497431E166
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhBQVb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232890AbhBQVbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 16:31:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5497664E85;
        Wed, 17 Feb 2021 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613597431;
        bh=WgRxiqmGWb/NNjj30Km3X2UGAL7IO9ln+kqQU/TQu6U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IIUYl+kx286L8XAbuoI1nFhR6GLGmWR37+lXiZQPd90hH0szDCBrQ5FWMXeULISx4
         gaGpIyG2FFlt+DMObk0hMPlCkYnTawuCtljEEkzUUU0RSvnC0yJ0NNUKpMYcekSOvh
         Yh32Mpve4kb1c1Vs1CdrIcxcOXSPV0X7VowLnjotPugA6AEXPwYJ8z2NkUvAafVWit
         Inak6DJoiZrLTk28Ij6mL2nyqxB6h8v1qO5SCswhTtT4OiUmdFL3E4UQqf2I8jn7nS
         k1Q+T/5tBxPh2r++1Q5iSVvz81r6cURl4C0hA/4QwHqr2FZznojt5aH8PwyLmIDWrV
         FMrnWA7HNT1OA==
Received: by mail-ot1-f50.google.com with SMTP id 80so33786oty.2;
        Wed, 17 Feb 2021 13:30:31 -0800 (PST)
X-Gm-Message-State: AOAM531JY6QzHLiBU7S5n6LuNv4XVtzclYzmJ84vdsYFYNEQqs6tO3mX
        21eUbij8ekOttpQWyG9r4iK3+T+MmB7u73HZPYU=
X-Google-Smtp-Source: ABdhPJz1Azps44lN+jQOH+CDQmyg6qd67SBn4K0xmXvmlNAmv1A2dJGjw6f5euo1835xoHhFcxpq3LVx1T8pcul4Uyw=
X-Received: by 2002:a05:6830:1db5:: with SMTP id z21mr807185oti.210.1613597430588;
 Wed, 17 Feb 2021 13:30:30 -0800 (PST)
MIME-Version: 1.0
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
 <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com> <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 17 Feb 2021 22:30:14 +0100
X-Gmail-Original-Message-ID: <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
Message-ID: <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
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

On Wed, Feb 17, 2021 at 9:20 PM Min Li <min.li.xe@renesas.com> wrote:
>
> I attached the G.8273.2 document, where chapter 6 is about supporting physical layer
> frequency. And combo mode is Renesas way to support this requirement. Other companies
> may come up with different ways to support it.
>
> When EEC quality is below certain level, we would wanna turn off combo mode.

Maybe this is something that could be handled inside of the device driver then?

If the driver can use the same algorithm that is in your user space software
today, that would seem to be a nicer way to handle it than requiring a separate
application.

> > > This function will read FCW first and convert it to FFO.
> >
> > Is this related to the information in the timex->freq field? It sounds like this
> > would already be accessible through the existing
> > clock_adjtime() interface.
> >
>
> They are related, but dealing with timex->freq has limitations
>
> 1) Renesas SMU has up to 8 DPLLs and only one of the them would be ptp
> clock and we want to be able to read any DPLL's FFO or state

Is this necessarily unique to Renesas SMU though? Not sure what
makes sense in terms of the phc/ptp interface. Could there just be
a separate instance for each DPLL in the phc subsystem even if it's
actually a ptp clock, or would that be an incorrect use?

> 2) timex->freq's unit is ppb and we want to read more precise ffo in smaller unit of ppqt

This also sounds like something that would not be vendor specific. If you
need a higher resolution, then at some point others would need it as well.
There is already precedence in 'struct timex' to redefine the resolution of
some fields based on a flag -- 'time.tv_usec' can either refer to microseconds
to nanoseconds.

If the range of the 'freq' field is sufficient to encode ppqt, you could add
another flag for that, otherwise another reserved field can be used.

> 3) there is no interface in the current ptp hardware clock infrastructure to read ffo back from hardware

Adding an internal interface is the easy part here, the hard part is defining
the user interface.

> > Wouldn't any PTP clock run in one of these modes? If this is just
> > informational, it might be appropriate to have another sysfs attribute for
> > each PTP clock that shows the state of the DPLL, and then have the PTP
> > driver either fill in the current value in 'struct ptp_clock', or provide a
> > callback to report the state when a user reads the sysfs attribute.
> >
>
> What you propose can work. But DPLL operating mode is not standardized
> so different vendor may have different explanation for various modes.

If it's a string, that could easily be extended to further modes, as long
as the kernel documents which names are allowed. If multiple vendors
refer to the same mode by different names, someone will have to decide
what to call it in the kernel, and everyone afterwards would use the same
name.

> Also, I thought sysfs is only for debug or informational purpose.
> Production software is not supposed to use it for critical tasks?

No, you are probably thinking of debugfs. sysfs is one of multiple
common ways to exchange this kind of data in a reliable way.

An ioctl would probably work just as well though, usually sysfs
is better when the information makes sense to human operators
or simple shell scripts, while an ioctl interface is better if performance
is important, or if the information is primarily used in C programs.

        Arnd
