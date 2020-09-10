Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B6265128
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgIJUp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbgIJU2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:28:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D1320BED;
        Thu, 10 Sep 2020 20:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599769718;
        bh=cyXH2m9SbRuw7AjC0kYLstZqv7BypKK9aZYMN9yTQBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WsTM7hlODce3jLyshd/OIuWYBbW5Hl6gkfAQaPzbD1pKZklQmyFakMp/wn4q2jDCT
         OOkI5U8JXddYLqyGrcZFXIqPzbJuIKkeJ0szKPvWa65u9BDMmPS2w88TxbL4rxTlk2
         nLIO5y0zyPGgsWLXf+Abz4t+xek4YXNDj+3M36yA=
Date:   Thu, 10 Sep 2020 13:28:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200910132835.1bf7b638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 23:16:22 +0300 Oded Gabbay wrote:
> On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 10 Sep 2020 19:11:11 +0300 Oded Gabbay wrote:  
> > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
> > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
> > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
> > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
> > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
> > >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
> > >  create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h  
> >
> > The relevant code needs to live under drivers/net/(ethernet/).
> > For one thing our automation won't trigger for drivers in random
> > (/misc) part of the tree.  
> 
> Can you please elaborate on how to do this with a single driver that
> is already in misc ?
> As I mentioned in the cover letter, we are not developing a
> stand-alone NIC. We have a deep-learning accelerator with a NIC
> interface.
> Therefore, we don't have a separate PCI physical function for the NIC
> and I can't have a second driver registering to it.

Is it not possible to move the files and still build them into a single
module?

> We did this design based on existing examples in the kernel
> (registering to netdev), such as (just a few examples):
> 1. sgi-xp driver in drivers/misc/sgi-xp (see file xpnet.c)
> 2. bnx2fc in drivers/scsi/bnx2fc
> 
> Thanks,
> Oded

