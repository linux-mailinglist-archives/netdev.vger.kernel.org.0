Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2392126AEDB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgIOUsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgIOUr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:47:29 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25620C06174A;
        Tue, 15 Sep 2020 13:47:28 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x14so5433495oic.9;
        Tue, 15 Sep 2020 13:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OIuRgcFlTxfaP90+9msbWVcCrwNMEUrSlP9dST0eMV0=;
        b=VdTt9DB0Qj2KcTjInZldnPHaKAxaQLxrXytsY70qenGhfpCuiPL8+g5tR7SES1yFMN
         YClit66x2z9Q3mPzl2wOE8fn/h3xmD4VV/2k1O+bZDEZFD3UOp21b7ytQhtWuhKXLQSW
         WaVdRWyR32K/ojiNApmrG5x/2Id3b7T4oWyY+Mf4dT13C128CbpXa0gbe+z4oxsnRS7T
         AEtrmYboIRnfXQlGtmcYvFIdNywoav+hyemM8oU+aoKVg16VXrIQVwdS/hvooOJO5v6Q
         uzBAWEO6yqzqaUgKuY/Q3q9aN34nyQvAHjkjzDHWHBWO9T6Y9w9FxrDDMGlXLg+tcvFV
         p5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIuRgcFlTxfaP90+9msbWVcCrwNMEUrSlP9dST0eMV0=;
        b=KBDkS+jUk5l800s+mTkykuET+HRvy/bOqphkmKmQeneTsdG+R00TTVhSC3NHzDp1B+
         6Rc1Xvx0cMgaPqGQr0f0MjX0doNxm4B+mLtnaWjP3p5JeaLZLC+4/kKK+LoWu6OyHBAU
         +9tKlltARxfMdyEQCoyro0ID20qidWwe83ZIPLuh6CwAdhufZy/r2imH4bRc1kgTOIzU
         5N6WheWB7FtuTbMr1j/A1pp8GwkQeS9+zciV7AMgayJlTxquZFVydhgv6QkaQMccXxD6
         JxVcJSRtE+oPbD/1g+ZkkKJ2u6M65UiZeJ7s6MbUlbOv+avGKHai/TDjm0PSx8+ZLu9m
         r/gg==
X-Gm-Message-State: AOAM531uWUYFFrmjjTWGaTWLyEj7ZGWEX+GBxEvA5Dc0A31rNe124i+3
        3mEw5Nss7EvINu/feleHgJMeC6llG/fDGP7CjE8=
X-Google-Smtp-Source: ABdhPJzlAsO4eDIUIeSF/kUt++MszHsCflQWvBucCSUHV4kXz+Ql2ae2nHnM6AavonJDI5JwFbsBjCHYsVvKkTecfbs=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr915414oij.154.1600202847068;
 Tue, 15 Sep 2020 13:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Tue, 15 Sep 2020 23:46:58 +0300
Message-ID: <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Sep 2020 20:10:08 +0300 Oded Gabbay wrote:
> > Hello,
> >
> > This is the second version of the patch-set to upstream the GAUDI NIC code
> > into the habanalabs driver.
> >
> > The only modification from v2 is in the ethtool patch (patch 12). Details
> > are in that patch's commit message.
>
> You keep reposting this, yet this SDK shim^W^W driver is still living in
> drivers/misc. If you want to make it look like a NIC, the code belongs
> where NIC drivers are.
>
> Then again, is it a NIC? Why do you have those custom IOCTLs? That's far
> from normal.

Hi Jakub,
I'm sorry but from your question it seems as if you didn't read my
cover letter at all, as I took great lengths in explaining exactly
what our device is and why we use custom IOCTLs.
TL;DR
We have an accelerator for deep learning (GAUDI) which uses RDMA as
infrastructure for communication between multiple accelerators. Same
as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
The RDMA implementation we did does NOT support some basic RDMA
IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
library or to connect to the rdma infrastructure in the kernel. We
wanted to do it but when we analyzed it, we saw we wouldn't be able to
support basic stuff and therefore we had to revert to our IOCTLs.
To sum it up, because our NIC is used for intra-communication, we
don't expose nor intend users to use it as a NIC per-se. However, to
be able to get statistics and manage them in a standard way, and
support control plane over Ethernet, we do register each port to the
net subsystem (i.e. create netdev per port).

I hope this short summary explains this better.
As per your request that this code lives in the net subsystem, I think
that will make it only more complicated and hard to upstream and
maintain.
I see there are other examples (e.g. sgi-xp) that contain networking
driver code in misc so I don't understand this objection.
>
> Please make sure to CC linux-rdma. You clearly stated that the device
> does RDMA-like transfers.

We don't use the RDMA infrastructure in the kernel and we can't
connect to it due to the lack of H/W support we have so I don't see
why we need to CC linux-rdma.

Oded
