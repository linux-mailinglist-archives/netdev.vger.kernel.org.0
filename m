Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF642FB33
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 20:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241417AbhJOSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 14:45:15 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:44836 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbhJOSpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 14:45:14 -0400
Received: by mail-oi1-f176.google.com with SMTP id y207so14317411oia.11;
        Fri, 15 Oct 2021 11:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fZwrJiqd9seqRcT3s1yzrveoPyn/0SNgpRsZ6dkHhUE=;
        b=uu2FCpPOQPggrIbiC8aQW2020lccnD67CvV/1B4vmu50ViXUi0S6j25Cg8lltVYKfz
         YZLbCyMbtxunoaVhcZ21V4YgyowelxPR0KI4t6mK0jFs2k81AzpSh8sJaPg1FTUXksWd
         i11gB2LTaxbN+U/Gz3djtN8KAeqEu+DzinYrjP5v/XPuE59ACSb0yP7yru9WeWc6cPfX
         yy2xqThcXxt1/ujKNQPLvwQsUbWLeHuCMwikL8MrfusQlpj7+lL6UzSbnyA+ZvvlZ2dG
         IZjsHoPB4QEu41qL+/bAwCBl6/OxZeG3RiYttB7ZjY1vk/IITPmEcvS1XUKiN42RItdG
         mJYg==
X-Gm-Message-State: AOAM532n4UVcyItUKulHYCtwMf30wxuyYYbHhBgY6hjwgg9nuljeXcCJ
        2XmNnWkZFXOMKJs6egtOi9o15r4E5fIqQHWk3Tg=
X-Google-Smtp-Source: ABdhPJzZ0uV63o3Hwjz2dns+zeVN4BkgONSzt2MO9uu96aEdLiBcXu2SI6u4FCs4OUzOhUCZmQ/Q7BviE23krVGt358=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr19063404oif.51.1634323387558;
 Fri, 15 Oct 2021 11:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <1823864.tdWV9SEqCh@kailua> <9965462.DAOxP5AVGn@pinacolada>
 <CAJZ5v0icUwksYVjKW0H5G0DNpfVHSyfm4oC782+Fsy56mQ330A@mail.gmail.com> <4697216.31r3eYUQgx@kailua>
In-Reply-To: <4697216.31r3eYUQgx@kailua>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 15 Oct 2021 20:42:56 +0200
Message-ID: <CAJZ5v0grz=_vi-+S7M8xshigpETtjYw__vvt3=Aeb1XbARfkng@mail.gmail.com>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14
 ("The NVM Checksum Is Not Valid") [8086:1521]
To:     "Andreas K. Huettel" <andreas.huettel@ur.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kubakici@wp.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 4:01 PM Andreas K. Huettel
<andreas.huettel@ur.de> wrote:
>
> Am Donnerstag, 14. Oktober 2021, 14:09:39 CEST schrieb Rafael J. Wysocki:
> > > > > >>> huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
> > > > > >>> Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethernet Network Driver
> > > > > >>> Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-2014 Intel Corporation.
> > > > > >>> Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling device (0000 -> 0002)
> > > > > >>
> > > > > >> This line is missing below, it indicates that the kernel couldn't or
> > > > > >> didn't power up the PCIe for some reason. We're looking for something
> > > > > >> like ACPI or PCI patches (possibly PCI-Power management) to be the
> > > > > >> culprit here.
> > > > > >
> > > > > > So I did a git bisect from linux-v5.10 (good) to linux-v5.14.11 (bad).
> > > > > >
> > > > > > The result was:
> > > > > >
> > > > > > dilfridge /usr/src/linux-git # git bisect bad
> > > > > > 6381195ad7d06ef979528c7452f3ff93659f86b1 is the first bad commit
> > > > > > commit 6381195ad7d06ef979528c7452f3ff93659f86b1
> > > > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > Date:   Mon May 24 17:26:16 2021 +0200
> > > > > >
> > > > > >      ACPI: power: Rework turning off unused power resources
> > > > > > [...]
> > > > > >
> > > > > > I tried naive reverting of this commit on top of 5.14.11. That applies nearly cleanly,
> > > > > > and after a reboot the additional ethernet interfaces show up with their MAC in the
> > > > > > boot messages.
> > > > > >
> > > > > > (Not knowing how safe that experiment was, I did not go further than single mode and
> > > > > > immediately rebooted into 5.10 afterwards.)
> > > >
> > > > Reverting this is rather not an option, because the code before it was
> > > > a one-off fix of an earlier issue, but it should be fixable given some
> > > > more information.
> > > >
> > > > Basically, I need a boot log from both the good and bad cases and the
> > > > acpidump output from the affected machine.
> > > >
> > >
> > > https://dev.gentoo.org/~dilfridge/igb/
> > >
> > > ^ Should all be here now.
> > >
> > > 5.10 -> "good" log (the errors are caused by missing support for my i915 graphics and hopefully unrelated)
> > > 5.14 -> "bad" log
> > >
> > > Thank you for looking at this. If you need anything else, just ask.
> >
> > You're welcome.
> >
> > Please test the attached patch and let me know if it helps.
> >
>
> It helps (*); the second ethernet adaptor is initialized, and works normally as far as I can see.
>
> (*) The debug output line following the if-condition apparently changed in the meantime, so I had
> to apply the change in the if-condition "manually".
>
> igb: Intel(R) Gigabit Ethernet Network Driver
> igb: Copyright (c) 2007-2014 Intel Corporation.
> igb 0000:01:00.0: enabling device (0000 -> 0002)
> igb 0000:01:00.0: added PHC on eth1
> igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
> igb 0000:01:00.0: eth1: (PCIe:5.0Gb/s:Width x4) 6c:b3:11:23:d4:4c
> igb 0000:01:00.0: eth1: PBA No: H47819-001
> igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> igb 0000:01:00.1: enabling device (0000 -> 0002)
> igb 0000:01:00.1: added PHC on eth2
> igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
> igb 0000:01:00.1: eth2: (PCIe:5.0Gb/s:Width x4) 6c:b3:11:23:d4:4d
> igb 0000:01:00.1: eth2: PBA No: H47819-001
> igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>
> The full boot log is at https://dev.gentoo.org/~dilfridge/igb/ as 5.14.11-*.txt

Thank you!

I've added a changelog to it and resent along with another patch to
test for you:

https://lore.kernel.org/linux-acpi/21226252.EfDdHjke4D@kreacher/
