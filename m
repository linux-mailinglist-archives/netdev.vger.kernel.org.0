Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0349E3CCC64
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhGSCwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSCwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:52:30 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7980EC061762;
        Sun, 18 Jul 2021 19:49:30 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id c13so9390589qtc.10;
        Sun, 18 Jul 2021 19:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QjOI48s72H+Xl2byafvGyOneGgwizH2KHF/7bNKQchE=;
        b=sQV8outJz+6b7wG8pCz6FLz+/q1KnTgFKbZW2uF9N8ql/QD95YJEguBCEIMSyOcwYm
         g8IWJ/psNSpuVzhLutpsORsxm8bZUXw+SH2G3BZM42Rm2ZaCqWtsG+tmZRoR2HxHhEGX
         oaLGShvS/YTRs1tqApxct4eSBHuOWZtqbs2pyD/+IBIHZ7PUIguKQXAuK14LswLz/RFH
         B6MPJJAlJxLEw2fAbo++G88DuozdvWaP0ovsA+p7M4/Evot5cLbog6btnddcSMbNUkzS
         6NSdX2EgIFOaW2aWXQgPi+43uyI1bQgDRP3U3wXZe5HMbNoPM81k1Zra/EbUzLv+PJw/
         GtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QjOI48s72H+Xl2byafvGyOneGgwizH2KHF/7bNKQchE=;
        b=BB7zR/4lk9afte3VNa1Ge4+TqJU/JOjqDSlSb7S0kcyAib/jzbfcPFSMwO1T3/QtV5
         QJENOtHZNRC7Pq5jacdLl7uDNFdeNbCZsYHVixLxv+StGu+1dvyC/RC++D6AvV0CU5dc
         A52s4rliDWPnUFfnn8hDHo8TEgPiaKSpU5xgPi6AZuds+cSUnLOILsky/GwTJdLQEqSE
         YNdj3RcXaId9WT+uOAnhT2M7uj42KBHX1IWvmEMf33u69CiHIory9ntcrQtMDa30pn6y
         N47ieNcXi58F4w7z0CKHTA40k4QltFYTqs3gwyp34DoLWSaWNDw3d1cFx3xKFdEm/fyS
         Ag+A==
X-Gm-Message-State: AOAM530eCgg4xOtkyGf9n+OON8OihXKARYiJEKFa1Rud0/09EyGAtuaq
        GfEQp92Vb8R/qNkuXISIw+Ehr/xGS4dETB/LyTw=
X-Google-Smtp-Source: ABdhPJzOfvu8Jk4YGlqlIq5u5Nf0nyq3jqmTG9FcpceEUas2pmlvtpHsTY4cy1dd7XkCzlQrH4WdKj2KJe75zbwY7ss=
X-Received: by 2002:aed:3167:: with SMTP id 94mr20286965qtg.33.1626662969593;
 Sun, 18 Jul 2021 19:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAOSf1CGVpogQGAatuY_N0db6OL2BFegGtj6VTLA9KFz0TqYBQg@mail.gmail.com>
 <20210708154550.GA1019947@bjorn-Precision-5520> <CAOSf1CHtHLyEHC58jwemZS6j=jAU2OrrYitkUYmdisJtuFu4dw@mail.gmail.com>
 <20210718225059.hd3od4k4on3aopcu@pali>
In-Reply-To: <20210718225059.hd3od4k4on3aopcu@pali>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Mon, 19 Jul 2021 12:49:18 +1000
Message-ID: <CAOSf1CHOrUBfibO0t6Zr2=SZ7GjLTiAzfoKBeZL8RXdcC+Ou3A@mail.gmail.com>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 8:51 AM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> And do we have some solution for this kind of issue? There are more PCIe
> controllers / platforms which do not like MMIO read/write operation when
> card / link is not connected.

Do you have some actual examples? The few times I've seen those
crashes were due to broken firmware-first error handling. The AER
notifications would be escalated into some kind of ACPI error which
the kernel didn't have a good way of dealing with so it panicked
instead.

Assuming it is a real problem then as Bjorn pointed out this sort of
hack doesn't really fix the issue because hotplug and AER
notifications are fundamentally asynchronous. If the driver is
actively using the device when the error / removal happens then the
pci_dev_is_disconnected() check will pass and the MMIO will go
through. If the MMIO is poisonous because of dumb hardware then this
sort of hack will only paper over the issue.

> If we do not provide a way how to solve these problems then we can
> expect that people would just hack ethernet / wifi / ... device drivers
> which are currently crashing by patches like in this thread.
>
> Maybe PCI subsystem could provide wrapper function which implements
> above pattern and which can be used by device drivers?

We could do that and I think there was a proposal to add some
pci_readl(pdev, <addr>) style wrappers at one point. On powerpc
there's hooks in the arch provided MMIO functions to detect error
responses and kick off the error handling machinery when a problem is
detected. Those hooks are mainly there to help the platform detect
errors though and they don't make life much easier for drivers. Due to
locking concerns the driver's .error_detected() callback cannot be
called in the MMIO hook so even when the platform detects errors
synchronously the driver notifications must happen asynchronously. In
the meanwhile the driver still needs to handle the 0xFFs response
safely and there's not much we can do from the platform side to help
there.

Oliver
