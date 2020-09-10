Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBF52650EC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgIJUgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgIJUdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:33:12 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9392C061573;
        Thu, 10 Sep 2020 13:33:11 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id y5so6505861otg.5;
        Thu, 10 Sep 2020 13:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MaRMb1u1PASBXrBgy1VMCX3eJaTYWufRPC5mbdyiCdQ=;
        b=a7wK0ROU1zybzDz/ZX01K2LQ72ZSh7pK+Y1BXyKq0Kq7ZWv1YKH8k/Gl1Z9kgQiOOJ
         tPU5kiSSCRFiS102b6+VJ9qzWlChWvHvQnOR4O5A9eX7MmcQv4GhuqP3qKj09lLksZzO
         r2ttUbP6ThllNJWe2zYbdOBtLL7PXvXqQMYlaoZ8usCDu4aq4xjT6fLOgwp2Sf2PeawN
         vn/RAOzbF3hlUEHopITUqgH7lZfvY47wONPSl4wXtSQYzS/EE2fOMsTKpovFpps8eNXJ
         kbB+ngRnVtUNZANkdqHf3ai7LEI/ZqgxEAVdVhQ65OXm7e0nfolBg+i1r0S4YUWGlEzt
         mHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MaRMb1u1PASBXrBgy1VMCX3eJaTYWufRPC5mbdyiCdQ=;
        b=mdA8+tR5zjRFGLkws6J8ktX0GYSuDqigd+h7t0wE8HTOlUScTHZSiQVCSqS4DjBCLx
         LB0LuCslUXqaTxErA91rC48HQW5NtN4hww3TFwA6c/WUlL4ttXt1mwdkKu4n04S8XS4p
         pxwBiVl8oQlmI8wyTqvKbJZNnpGXyZOdy0StzKPfjXDC5Rcoap/7jR0vPrAHPQ7ucwHp
         GOesldwcx/1/9y/eWfP0J/fLyhJ1tQMKJAPKGvfeDls/OBVHXPLQjcKxz6e95jxNOu2z
         vTEbedkFcwnnKFnpZYWbvCnJF9Qd/cPOMeDxuoy8XCrcL26t1GBtzF3cFuAH83mRbAYs
         Fg6g==
X-Gm-Message-State: AOAM5300WxusyuMCe2qxLDury5RXoT2z9muZr96V/BzKL6itFmmsalHf
        SsZncQGg9SxwVV19DIZOmRvVE9qzGw7YaI/jgcM=
X-Google-Smtp-Source: ABdhPJzU6+u3Wka5CHttm5s9y+snyZ3d6IucHtOGKjAsNA6SInPpN8vF00ANbsfDCRZq8ilOnDrxm+x6yUxHCU2ICM4=
X-Received: by 2002:a9d:66cf:: with SMTP id t15mr5352433otm.143.1599769990878;
 Thu, 10 Sep 2020 13:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com> <20200910132835.1bf7b638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910132835.1bf7b638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:32:42 +0300
Message-ID: <CAFCwf127fssgiDEwYvv3rFW7iFFfKKZDE=oxDUbFBcwpz3yQkQ@mail.gmail.com>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Sep 2020 23:16:22 +0300 Oded Gabbay wrote:
> > On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 10 Sep 2020 19:11:11 +0300 Oded Gabbay wrote:
> > > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
> > > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
> > > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
> > > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
> > > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
> > > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
> > > >  create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
> > >
> > > The relevant code needs to live under drivers/net/(ethernet/).
> > > For one thing our automation won't trigger for drivers in random
> > > (/misc) part of the tree.
> >
> > Can you please elaborate on how to do this with a single driver that
> > is already in misc ?
> > As I mentioned in the cover letter, we are not developing a
> > stand-alone NIC. We have a deep-learning accelerator with a NIC
> > interface.
> > Therefore, we don't have a separate PCI physical function for the NIC
> > and I can't have a second driver registering to it.
>
> Is it not possible to move the files and still build them into a single
> module?
hmm...
I actually didn't try that as I thought it will be very strange and
I'm not familiar with other drivers that build as a single ko but have
files spread out in different subsystems.
I don't feel it is a better option than what we did here.

Will I need to split pull requests to different subsystem maintainers
? For the same driver ?
Sounds to me this is not going to fly.
Thanks,
Oded


>
> > We did this design based on existing examples in the kernel
> > (registering to netdev), such as (just a few examples):
> > 1. sgi-xp driver in drivers/misc/sgi-xp (see file xpnet.c)
> > 2. bnx2fc in drivers/scsi/bnx2fc
> >
> > Thanks,
> > Oded
>
