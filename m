Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223553AE47E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhFUIDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhFUIDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 04:03:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B5F961156;
        Mon, 21 Jun 2021 08:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624262483;
        bh=xkIVlbEuJDCy/58h9s+rXKkCBkl+0cKos+yjyqiA2ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2g8JzKD4v4BtPFaM377n22YOz19qDW8FDr/F6xVWyQRWzCgygQYMyg2ToGzRI8EU
         F+y+BRT0TzfXol6Be0CqTpJ2Ug5vR+2GX3SPKM36A8yGVoqtoHi1Ab4nqfBBF2Xn00
         t1Iv53NuBY0HAIj1hIbMHjJz/NaXQ4HZOHQ1TPdqGosS6/c/dZKDRUJMwEh7CT1R89
         awvM/3rgZ2BNiCGuZ7AQLyAelNCYbPafo6JHOFLxnrmwUszf30dhVra0yrnAfUg1ZS
         kByFHj5hDrRnB+FYupkp4/Epz+uTj6N7x1U8lSSdIlplOZdDT/Xl72oGga+5K5/F+y
         EjUbrIZ3Fp8Jw==
Date:   Mon, 21 Jun 2021 11:01:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        luobin9@huawei.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        nilal@redhat.com
Subject: Re: [PATCH v1 13/14] net/mlx5: Use irq_update_affinity_hint
Message-ID: <YNBHUMRqc+s0JesY@unreal>
References: <20210617182242.8637-1-nitesh@redhat.com>
 <20210617182242.8637-14-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617182242.8637-14-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 02:22:41PM -0400, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> that is consumed by the userspace to distribute the interrupts. However,
> under the hood irq_set_affinity_hint() also applies the provided cpumask
> (if not NULL) as the affinity for the given interrupt which is an
> undocumented side effect.
> 
> To remove this side effect irq_set_affinity_hint() has been marked
> as deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
> that only updates the affinity_hint pointer.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
