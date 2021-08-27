Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB03F93D8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 06:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhH0E5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 00:57:46 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:39748
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhH0E5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 00:57:45 -0400
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D7A5C4079E
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 04:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630040215;
        bh=k2kXvQJzyGKPPRNtItos+fbwHILHlMCv9moNO8dHNrs=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=OUIXVPTiq4bw6kmhRfIUlWs0aLZ14JHqzXSMQJ1ofu+lPxJvM4wlzrWG6eFpclXaH
         4BG+ZjJqzeqWHBxktrT4LodpwBvF5HzIEutFmtIG4+kzP/r/TZlYaaVYWOkqAHqrq+
         W/vkRJiih2dO8Y+V1fEoOD/+F1r/OeDNG4iONh1F3qkVvx5yPuNuh5svyNKNe0aRcD
         zl01UazvcmtW9oPHQcXNqSxBELAWb4ATwqlivZ7OJN6nb330uhiR9wLIyOXdXtrU7y
         TaELptaKgeQz1YikzYW5gEAs3+w/jlRCCCLVmqrmzoQwhcN8TBM3Febs4dHnU2pzRQ
         Hh2lNFBzKl3cQ==
Received: by mail-ej1-f69.google.com with SMTP id gw26-20020a170906f15a00b005c48318c60eso2127927ejb.7
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 21:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k2kXvQJzyGKPPRNtItos+fbwHILHlMCv9moNO8dHNrs=;
        b=qg4tGP6GYY3/Q/55FLCAP396urJsdxjmTKFSU7KVT21Oi8Xlo9uWTpeKbEPcCe+G+q
         Jra8R5BzWj0zqgy1CRjWmYkH6VPZnjxWUJjNkvPY7CPHYKQZ9GEBq9QdKR79vRexIHCe
         9GxfMEKw7RLN2uAW3GyEmGIfO6B5e8Akk47dm3Eax4SalhSM17n1/zpXlgq6sbh/6o6N
         Sz3S4iJUxxkyLekt6jLkbtEnprVNTxD6bS746Yp2E1Ns0u0p0Wsiscbq74INu6ibAM+3
         DkuGL0w4DMJEhLCzHlgMI1VFFu+mcJJMlE1ZS9GHjfoY9UJhh8v6A1p917Rx2cKIKlib
         dopg==
X-Gm-Message-State: AOAM530V0PpKhLyLRXAUQmyIMXwTIznRb/wEJUhFq1BDKIAEkCJP/qCU
        K4gmZmyHpryJyZoeIA91e+zXW7TykAK+NvR5JIHYOP4Cw/QJV3ODmkvCk8IWGaLIktuhKtOtOVi
        fgqNR8/dF1b74QdNqfLlrlhi/RmqMOjEfDd24qyJtRwuaVOJlmA==
X-Received: by 2002:a17:906:8a5a:: with SMTP id gx26mr5525802ejc.78.1630040215385;
        Thu, 26 Aug 2021 21:56:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJ40BL0BSKF4QXHn3M+h3/4+Kn7L1h7Gb3l78NpvqKT/hZyQcIZAqUSaKQEU/3IQpRZUDrLXxv7LIun2nS/i0=
X-Received: by 2002:a17:906:8a5a:: with SMTP id gx26mr5525782ejc.78.1630040215126;
 Thu, 26 Aug 2021 21:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAAd53p5KH69NPMejM93STx3J+0WNBuXzaheWJJoURM39=DLvxg@mail.gmail.com>
 <20210824145339.GA3453132@bjorn-Precision-5520>
In-Reply-To: <20210824145339.GA3453132@bjorn-Precision-5520>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 27 Aug 2021 12:56:43 +0800
Message-ID: <CAAd53p4icgipmdrdJxNR69n7DRRbLm9qTrBZyFySqty3qWv8uA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/3] r8169: Implement dynamic ASPM mechanism
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 10:53 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Tue, Aug 24, 2021 at 03:39:35PM +0800, Kai-Heng Feng wrote:
> > On Sat, Aug 21, 2021 at 5:03 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > >
> > > On Thu, Aug 19, 2021 at 05:45:22PM +0200, Heiner Kallweit wrote:
> > > > On 19.08.2021 13:42, Bjorn Helgaas wrote:
> > > > > On Thu, Aug 19, 2021 at 01:45:40PM +0800, Kai-Heng Feng wrote:
> > > > >> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > > > >> Same issue can be observed with older vendor drivers.
> > > > >
> > > > > On some platforms but not on others?  Maybe the PCIe topology is a
> > > > > factor?  Do you have bug reports with data, e.g., "lspci -vv" output?
> > > > >
> > > > >> The issue is however solved by the latest vendor driver. There's a new
> > > > >> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > > > >> more than 10 packets, and vice versa.
> > > > >
> > > > > Presumably there's a time interval related to the 10 packets?  For
> > > > > example, do you want to disable ASPM if 10 packets are received (or
> > > > > sent?) in a certain amount of time?
> > > > >
> > > > >> The possible reason for this is
> > > > >> likely because the buffer on the chip is too small for its ASPM exit
> > > > >> latency.
> > > > >
> > > > > Maybe this means the chip advertises incorrect exit latencies?  If so,
> > > > > maybe a quirk could override that?
> > > > >
> > > > >> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> > > > >> use dynamic ASPM under Windows. So implement the same mechanism here to
> > > > >> resolve the issue.
> > > > >
> > > > > What exactly is "dynamic ASPM"?
> > > > >
> > > > > I see Heiner's comment about this being intended only for a downstream
> > > > > kernel.  But why?
> > > > >
> > > > We've seen various more or less obvious symptoms caused by the broken
> > > > ASPM support on Realtek network chips. Unfortunately Realtek releases
> > > > neither datasheets nor errata information.
> > > > Last time we attempted to re-enable ASPM numerous problem reports came
> > > > in. These Realtek chips are used on basically every consumer mainboard.
> > > > The proposed workaround has potential side effects: In case of a
> > > > congestion in the chip it may take up to a second until ASPM gets
> > > > disabled, what may affect performance, especially in case of alternating
> > > > traffic patterns. Also we can't expect support from Realtek.
> > > > Having said that my decision was that it's too risky to re-enable ASPM
> > > > in mainline even with this workaround in place. Kai-Heng weights the
> > > > power saving higher and wants to take the risk in his downstream kernel.
> > > > If there are no problems downstream after few months, then this
> > > > workaround may make it to mainline.
> > >
> > > Since ASPM apparently works well on some platforms but not others, I'd
> > > suspect some incorrect exit latencies.
> >
> > Can be, but if their dynamic ASPM mechanism can workaround the issue,
> > maybe their hardware is just designed that way?
>
> Designed what way?  You mean the hardware uses the architected ASPM
> control bits in the PCIe capability to control some ASPM functionality
> that doesn't work like the spec says it should work?

Yes, it requires both standard PCIe ASPM control bits and Realtek
specific register bits to make ASPM really work.
Does PCI spec mandates PCIe config space to be the only way to enable ASPM?

>
> > > Ideally we'd have some launchpad/bugzilla links, and a better
> > > understanding of the problem, and maybe a quirk that makes this work
> > > on all platforms without mucking up the driver with ASPM tweaks.
> >
> > The tweaks is OS-agnostic and is also implemented in Windows.
>
> I assume you mean these tweaks are also implemented in the Windows
> *driver* from Realtek.  That's not a very convincing argument that
> this is the way it should work.

Since Realtek doesn't publish any erratum so following the driver
tweaks is the most practical way to improve the situation under Linux.
The same tweaks (i.e. dynamically enable/disable ASPM) can also be
found in another driver, drivers/infiniband/hw/hfi1/aspm.c.

>
> If ASPM works well on some platforms, we should be able to make it
> work well on other platforms, too.  The actual data ("lspci -vvxxx")
> from working and problematic platforms might have hints.

OK, I'll ask affected users' lspci data.

>
>
> > > But I'm a little out of turn here because the only direct impact to
> > > the PCI core is the pcie_aspm_supported() interface.  It *looks* like
> > > these patches don't actually touch the PCIe architected ASPM controls
> > > in Link Control; all I see is mucking with Realtek-specific registers.
> >
> > AFAICT, Realtek ethernet NIC and wireless NIC both have two layers of
> > ASPM, one is the regular PCIe ASPM, and a Realtek specific internal
> > ASPM.
> > Both have to be enabled to really make ASPM work for them.
>
> It's common for devices to have chicken bits.  But when a feature is
> enabled, it should work as defined by the PCIe spec so it will work
> with other spec-compliant devices.

I have no idea why they designed ASPM in two layers. Only Realtek
knows the reason...

>
> Bjorn
