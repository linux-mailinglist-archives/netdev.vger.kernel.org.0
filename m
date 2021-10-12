Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA142AB60
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJLSBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:01:00 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:36741 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLSBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 14:01:00 -0400
Received: by mail-ot1-f45.google.com with SMTP id p6-20020a9d7446000000b0054e6bb223f3so389232otk.3;
        Tue, 12 Oct 2021 10:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c2wHi0IsvvbTH5QwojHP29Nw/ht55S854mw0G0+05o0=;
        b=SXK02OwZ5qwq1AvjWUYnzmt/zIo/lO8I/7OGlOAViPtzPBkg00+oWC2q6yTkGhojbl
         LTmZJR9Ljjear8rzJ6CuKqIm9kaAtmEz6SZ4tzEkkDVrTo172pfPIxpYETO7vq1EPuDX
         3Tq3SLx28fB3qZmNAGFpVD9/yxzMG/pjoum4buGUd88/SbdgwlmKS6FSP2ZAsXvYdH1w
         ljMBYsNhGAcPFYT64Rz1DE3ZTWxv3AeMb+FbKftg+A0cNZqDDtcPlOdXzM1SxIfYXFQO
         2AI/fOy5AxIXvfangfA/5vzkPM+jI/uyZjep6mVegX+NSFLYjv60gJbmFzFNkQ4jTJVe
         5rYA==
X-Gm-Message-State: AOAM530ITrtLPjV/3z+YzU6dyLkq3lkRFTXWYbp/ilhotYq7UXeInNE7
        qn0Ylo1cTOHv/1M1qoxu0OkkuSJFtdB9hBdpRto=
X-Google-Smtp-Source: ABdhPJwkV3+7VqGccFRlX/nVgDFie+jFqR5G8Jl/Z4xr89wPEnQZO0oUkBCcsthggrRRQ4FA82xwXHIZxYklyLJUq/k=
X-Received: by 2002:a05:6830:1af0:: with SMTP id c16mr14382990otd.16.1634061538134;
 Tue, 12 Oct 2021 10:58:58 -0700 (PDT)
MIME-Version: 1.0
References: <1823864.tdWV9SEqCh@kailua> <2944777.ktpJ11cQ8Q@pinacolada>
 <c75203e9-0ef4-20bd-87a5-ad0846863886@intel.com> <2801801.e9J7NaK4W3@kailua> <6faf4b92-78d5-47a4-63df-cc2bab7769d0@molgen.mpg.de>
In-Reply-To: <6faf4b92-78d5-47a4-63df-cc2bab7769d0@molgen.mpg.de>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 12 Oct 2021 19:58:47 +0200
Message-ID: <CAJZ5v0gf0y6qDHUJOsvLFctqn8tgKeuTYn5S9rb6+T0Sj26aKw@mail.gmail.com>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14
 ("The NVM Checksum Is Not Valid") [8086:1521]
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Andreas K. Huettel" <andreas.huettel@ur.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kubakici@wp.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 7:42 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> [Cc: +ACPI maintainers]
>
> Am 12.10.21 um 18:34 schrieb Andreas K. Huettel:
> >>> The messages easily identifiable are:
> >>>
> >>> huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
> >>> Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethernet Network Driver
> >>> Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-2014 Intel Corporation.
> >>> Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling device (0000 -> 0002)
> >>
> >> This line is missing below, it indicates that the kernel couldn't or
> >> didn't power up the PCIe for some reason. We're looking for something
> >> like ACPI or PCI patches (possibly PCI-Power management) to be the
> >> culprit here.
> >
> > So I did a git bisect from linux-v5.10 (good) to linux-v5.14.11 (bad).
> >
> > The result was:
> >
> > dilfridge /usr/src/linux-git # git bisect bad
> > 6381195ad7d06ef979528c7452f3ff93659f86b1 is the first bad commit
> > commit 6381195ad7d06ef979528c7452f3ff93659f86b1
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Mon May 24 17:26:16 2021 +0200
> >
> >      ACPI: power: Rework turning off unused power resources
> > [...]
> >
> > I tried naive reverting of this commit on top of 5.14.11. That applies nearly cleanly,
> > and after a reboot the additional ethernet interfaces show up with their MAC in the
> > boot messages.
> >
> > (Not knowing how safe that experiment was, I did not go further than single mode and
> > immediately rebooted into 5.10 afterwards.)

Reverting this is rather not an option, because the code before it was
a one-off fix of an earlier issue, but it should be fixable given some
more information.

Basically, I need a boot log from both the good and bad cases and the
acpidump output from the affected machine.
