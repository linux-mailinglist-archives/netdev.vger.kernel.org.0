Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECFC4817F8
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 01:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhL3A56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 19:57:58 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:47794
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233486AbhL3A55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 19:57:57 -0500
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 83FA93F207
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 00:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640825876;
        bh=9Hwlmcj0whxK49ykZw434uUikfx+0hXzEWWfpG3itis=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=tITYeT6KcBWIVEN2XOBh+4Y+l4Yf8zDaTEO+PnPyl3uzRwyxDyiNjwOjJGZIDLpzV
         CuO54i6BhsW0f5eEzqfZEQfvBXfuhyrB9eK2NFuPGj8WMX3ue8mgnAyN6IKB7a53uz
         TP3lgEC1lQ18adV0z9C8hpGk6pVUryxp9uU2IPDdxew5xskvnb85v2nACQyhRrutVx
         JPM5I0Abz2Krd/FQZjhTLbN9VJ0EXTTzYMgbk6jwWe55/O7DC1z2kDulb2fw38zR1J
         jINBzByB0S9u1Xho6IKh+ETsZftpLMHuOIqw5M+ILheji3cn3r97AxQBkQjlC3hp+S
         IQ9PFmczyHpDQ==
Received: by mail-ot1-f70.google.com with SMTP id z16-20020a056830129000b0055c7b3ceaf5so7167458otp.8
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 16:57:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Hwlmcj0whxK49ykZw434uUikfx+0hXzEWWfpG3itis=;
        b=gaIg1hYzvRr47/byORDnB8Yl9hFca+Iy7i8M06r4Z+RzltNO07q2Jq1mIz6SL5q8WJ
         iNbBqj81JXowkbEKX2eNvPUiEbwxEebBOnFMyzFdNQyoKzeJcNElE7J80QRJ7X2UEB3h
         UA8FOQOTriR+4I9OxwI5KAIYFFZMwGEdql2oLyn1RNBKwuWUAa2fLTTJccJed/oSeLmb
         itGTU8o900fy8zNS6YjpTGhpspID3uinAdKqlm+PC+8+1dviXIpDvppzqaHcdo+hPyQy
         /5mZtln8JIfiRJHjfY/t5mMxpli63dq3WhcLfBInTq1ErSpc8M6OZVMzICZsg+L7vATF
         VU9Q==
X-Gm-Message-State: AOAM5337+3AcNeU3Qaa6cMMDdXP1d6FU4nAGuqSKd+CZqxI/XtQMpvkR
        zNRzQfqf/5K9m4xxbbKH4QeR6kXZ+SmGZSO8diaA5wWpjA5DQ1KHiO8bZLXzXV+Pf+uRCld623T
        ALdWaC9b9auw/s4Bz9fuvtFKqcQ7yjJJZVDypYuhB18gTy0/BGg==
X-Received: by 2002:a4a:9406:: with SMTP id h6mr17864663ooi.80.1640825875120;
        Wed, 29 Dec 2021 16:57:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCOxmVFWE0YLjVd6KBaomVjMm7A0pPvlpZY/iwXtxTaHI020iaE+lbr1yOC/2PkujCMzC8WJeCzYUhLg1b854=
X-Received: by 2002:a4a:9406:: with SMTP id h6mr17864647ooi.80.1640825874776;
 Wed, 29 Dec 2021 16:57:54 -0800 (PST)
MIME-Version: 1.0
References: <20211224081914.345292-1-kai.heng.feng@canonical.com> <20211229201229.GA1698801@bhelgaas>
In-Reply-To: <20211229201229.GA1698801@bhelgaas>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 30 Dec 2021 08:57:42 +0800
Message-ID: <CAAd53p5GJRqRUvNSqNBLq2yTjjvJnSq5hFPSJYv08wuSLExx_w@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: wwan: iosm: Let PCI core handle PCI power transition
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 4:12 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> [+cc Rafael, in case you have insight about the PCI_D0 question below;
> Vaibhav, since this is related to your generic PM conversions]
>
> On Fri, Dec 24, 2021 at 04:19:13PM +0800, Kai-Heng Feng wrote:
> > pci_pm_suspend_noirq() and pci_pm_resume_noirq() already handle power
> > transition for system-wide suspend and resume, so it's not necessary to
> > do it in the driver.
>
> I see DaveM has already applied this, but it looks good to me, thanks
> for doing this!
>
> One minor question below...
>
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 49 ++-------------------------
> >  1 file changed, 2 insertions(+), 47 deletions(-)
> >
> > diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > index 2fe88b8be3481..d73894e2a84ed 100644
> > --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > @@ -363,67 +363,22 @@ static int __maybe_unused ipc_pcie_resume_s2idle(struct iosm_pcie *ipc_pcie)
> >
> >  int __maybe_unused ipc_pcie_suspend(struct iosm_pcie *ipc_pcie)
> >  {
> > -     struct pci_dev *pdev;
> > -     int ret;
> > -
> > -     pdev = ipc_pcie->pci;
> > -
> > -     /* Execute D3 one time. */
> > -     if (pdev->current_state != PCI_D0) {
> > -             dev_dbg(ipc_pcie->dev, "done for PM=%d", pdev->current_state);
> > -             return 0;
> > -     }
>
> I don't understand the intent of this early exit, and it's not obvious
> to me that pci_pm_suspend_noirq() bails out early when
> (pdev->current_state != PCI_D0).

Yes, I think this can be removed too. Please let me send v2.

Kai-Heng

>
> >       /* The HAL shall ask the shared memory layer whether D3 is allowed. */
> >       ipc_imem_pm_suspend(ipc_pcie->imem);
> >
> > -     /* Save the PCI configuration space of a device before suspending. */
> > -     ret = pci_save_state(pdev);
> > -
> > -     if (ret) {
> > -             dev_err(ipc_pcie->dev, "pci_save_state error=%d", ret);
> > -             return ret;
> > -     }
> > -
> > -     /* Set the power state of a PCI device.
> > -      * Transition a device to a new power state, using the device's PCI PM
> > -      * registers.
> > -      */
> > -     ret = pci_set_power_state(pdev, PCI_D3cold);
> > -
> > -     if (ret) {
> > -             dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
> > -             return ret;
> > -     }
> > -
> >       dev_dbg(ipc_pcie->dev, "SUSPEND done");
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  int __maybe_unused ipc_pcie_resume(struct iosm_pcie *ipc_pcie)
> >  {
> > -     int ret;
> > -
> > -     /* Set the power state of a PCI device.
> > -      * Transition a device to a new power state, using the device's PCI PM
> > -      * registers.
> > -      */
> > -     ret = pci_set_power_state(ipc_pcie->pci, PCI_D0);
> > -
> > -     if (ret) {
> > -             dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
> > -             return ret;
> > -     }
> > -
> > -     pci_restore_state(ipc_pcie->pci);
> > -
> >       /* The HAL shall inform the shared memory layer that the device is
> >        * active.
> >        */
> >       ipc_imem_pm_resume(ipc_pcie->imem);
> >
> >       dev_dbg(ipc_pcie->dev, "RESUME done");
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  static int __maybe_unused ipc_pcie_suspend_cb(struct device *dev)
> > --
> > 2.33.1
> >
