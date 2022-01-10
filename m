Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9662848A10C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 21:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiAJUnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 15:43:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45210 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239763AbiAJUni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 15:43:38 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1641847416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSQg5QxFFnpqwJJ5k+FjLh4UR3ZqJkxM7MxfmaJ8TEs=;
        b=FIay8q5XK7Abf2rZQPbuvYk/nDhrHJ+0hjwHr7vLxER7365Ipv4vKB+26ATBmn2s5z10+I
        YX1BITszBdll24wIn2IjLLj1lQJkw2ICzGG9Ex1b13S+5JpE2GtQxv390VjjWp4RG21itK
        wOGbUuSkr2575ba5uN2y99CisdjOzRBaBcHEXSpa5bWKPtUZdLi026IJ9gcDKnwKs8XWRY
        EuCYPIHWINYjKWiRA8U5jJQ3NQmc70MLX+OUXFYts5t99lylfu7ilfG38d6R1DFq7k9sti
        +uwOcGxoE244DDcl7sncrxjc+t0okaq1dxy8Sdld5qcg/pV7GkGA8Ae235sItA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1641847416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSQg5QxFFnpqwJJ5k+FjLh4UR3ZqJkxM7MxfmaJ8TEs=;
        b=3S4JuyW9Mcq5MmSfOUJ4Km81+eRBDl7za31q5Eur1eM77rZ0/E18/jyFKVBlnwTn/UCGgS
        aRN1FmsA3lEJcMCQ==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Nishanth Menon <nm@ti.com>, Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        lkp@lists.01.org, lkp@intel.com, nic_swsd@realtek.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [genirq/msi] 495c66aca3:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c
In-Reply-To: <da2cd97c-bd64-ebbd-549b-259ca56e3023@gmail.com>
References: <20211227150535.GA16252@xsang-OptiPlex-9020>
 <87czlgd14o.ffs@tglx> <da2cd97c-bd64-ebbd-549b-259ca56e3023@gmail.com>
Date:   Mon, 10 Jan 2022 21:43:36 +0100
Message-ID: <87fspvqq2v.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28 2021 at 20:25, Heiner Kallweit wrote:
> On 28.12.2021 19:40, Thomas Gleixner wrote:
>>  	if (jumbo_max)
>>  		netdev_info(dev, "jumbo features [frames: %d bytes, tx checksumming: %s]\n",
>
> Thanks for the patch, I'll submit it with your SoB.

Thank you!

> Apart from pci_irq_vector() incl. underlying msi_get_virq(), are there
> more functions that must not be called from atomic context any longer?

I don't think so. The allocation/free functions were always restricted
to preemptible context.

> Maybe the new constraint should be added to kernel-doc of affected
> functions?

Probably.

Thanks,

        tglx
