Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08B13BF3B9
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 04:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhGHCGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 22:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhGHCGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 22:06:54 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB6C061574;
        Wed,  7 Jul 2021 19:04:13 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id e14so4173694qkl.9;
        Wed, 07 Jul 2021 19:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79kwFs/IWOybBEWDpXckF21cEhoS06YNllAgNDTsoVg=;
        b=hVGjXYQsWBZZw7yVg9bUUkTWh/xdX7LlFOHM+hJm2HhfcwAb+nl/0JPaJOTXWJTHQH
         VbAMf9l6tBwOAKkMYIQguuVFEi2LLRDTn77c7pXcr8xn7TASO0f2/PYc1UxC2tAAXX1o
         d1YvFq2qNQ+8NL353gnHQkhwRoRSEK9b1B7IeKR1qRJ1VdZ97U+t9LXi89I8qYvIdsOa
         XSR8lKjTwQ1nqTiZTXC8KM0CyrnnYw4qyQ5XDvZ+lX7quf5g5/PA/uowPeOXcCsdYRk4
         MDykq9kSUMC+IIt3+NuRghd5pSq7pyZ7b/M6OpoRWZhKqft2uBh1x51XyLJcqWcZXEUf
         4Dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79kwFs/IWOybBEWDpXckF21cEhoS06YNllAgNDTsoVg=;
        b=tsNCpGjcCQfHPk7Oc6GRMG3EUJfQdj2fuDo/lisn/P5g1DrpvPPOWcidXS1slhIGT8
         HUAdhO9hrqnfA7jM/RDnz5tTCyXrVulQsvvcGldWzfiBfdj5GfLuaj4e33z7J/rvO9s+
         2C8pbQKP1upfGLedW4kNn6smR/18RiruYaaQyeyvAskbUotoWrew4yh3sl/y07o4fWkb
         /Ke5xVTjf6y7HcSwBxnfFX00Fv5jubd8gQkFiWMKIp/4UvEbFPL66HEpbKddusVCz0fj
         nnYg/bs+mf1bNBOGVrlfUaSa+MMmOQNceVRLvuFemi5U/SuAbDf2xRr25w7PeX3oZQK8
         jESQ==
X-Gm-Message-State: AOAM532KPFofymnHJbkJQnLwt4D8+Q7X5gSEoaNI2ZrDBVOHluZlNTaK
        Z1m+noD6+E9DOEPYZNcudGfFwM9kwHMaA/CCz9w=
X-Google-Smtp-Source: ABdhPJz36Y73BP3gqp3tXPYbQSOgNuHy8oCF6MwJ+BkwlhSi6HtlRN1S+1M4GXUbV3xFm+jrlGDyHZpJD+Pya6GH38g=
X-Received: by 2002:a37:e4a:: with SMTP id 71mr16713996qko.374.1625709853075;
 Wed, 07 Jul 2021 19:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210707215337.lwbgvb6lxs3gmsbb@pali> <20210707221042.GA939059@bjorn-Precision-5520>
In-Reply-To: <20210707221042.GA939059@bjorn-Precision-5520>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Thu, 8 Jul 2021 12:04:02 +1000
Message-ID: <CAOSf1CGVpogQGAatuY_N0db6OL2BFegGtj6VTLA9KFz0TqYBQg@mail.gmail.com>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 8:40 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> If we add the check as proposed in this patch, I think people will
> read it and think this is the correct way to avoid MMIO errors.  It
> does happen to avoid some MMIO errors, but it cannot avoid them all,
> so it's not a complete solution and it gives a false sense of
> security.

I think it's helpful to classify MMIO errors as either benign or
poisonous with the poison MMIOs causing some kind of crash. Most of
the discussions about pci_dev_is_disconnected(), including this one,
seem to stem from people trying to use it to avoid the poison case. I
agree that using pci_dev_is_disconnected() that way is hacky and
doesn't really fix the problem, but considering poison MMIOs usually
stem from broken hardware or firmware  maybe we should allow it
anyway. We can't do anything better and it's an improvement compared
to crashing.

> A complete solution requires a test *after* the MMIO read.  If you
> have the test after the read, you don't really need one before.  Sure,
> testing before means you can avoid one MMIO read failure in some
> cases.  But avoiding that failure costs quite a lot in code clutter.

It's not that much clutter if the checks are buried in the MMIO
helpers which most drivers define. Speaking of which:

> u32 igc_rd32(struct igc_hw *hw, u32 reg)
> {
>   struct igc_adapter *igc = container_of(hw, struct igc_adapter, hw);
>   u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
>   u32 value = 0;
>
>   value = readl(&hw_addr[reg]);
>
>   /* reads should not return all F's */
>   if (!(~value) && (!reg || !(~readl(hw_addr)))) {
>     struct net_device *netdev = igc->netdev;
>
>     hw->hw_addr = NULL;
>     netif_device_detach(netdev);
>     netdev_err(netdev, "PCIe link lost, device now detached\n");
>     WARN(pci_device_is_present(igc->pdev),
>          "igc: Failed to read reg 0x%x!\n", reg);
>   }
>
>   return value;
> }

I think I found where that page fault is coming from.

I wonder if we should provide drivers some way of invoking the error
recovery mechanisms manually or even just flagging itself as broken.
Right now even if the driver bothers with synchronous error detection
the driver can't really do anything other than parking itself and
hoping AER/EEH recovery kicks in.

Oliver
