Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFAEEBF7
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfD2VOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbfD2VOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 17:14:48 -0400
Received: from localhost (odyssey.drury.edu [64.22.249.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95338215EA;
        Mon, 29 Apr 2019 21:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556572487;
        bh=XX0aTJglLKQg7dsZbY4eNn1vqzsBT3b0Sj+xLrzx0yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YxHibykQtphUqTaLCrPFMVUnoPuwdK1iYO2VrtH44UQZDBpPNEIgM+EQM+ho0ajOH
         U7bQco5v19ubB1D43u2lfNBs8KvFl6/Tbwn+o5UIMte+7mdc6Euc/IXTI8nadeZc+Z
         9qxqwwsQIbuhid6oF/FqEvGGNc8TC6PpId9D37hU=
Date:   Mon, 29 Apr 2019 16:14:46 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Mackerras <paulus@samba.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD KFD" <dri-devel@lists.freedesktop.org>,
        "open list:RADEON and AMDGPU DRM DRIVERS" 
        <amd-gfx@lists.freedesktop.org>,
        "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] PCI: add help pci_dev_id
Message-ID: <20190429211446.GA145057@google.com>
References: <2e1f9a57-6d08-d017-24da-3e6b97fa2449@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e1f9a57-6d08-d017-24da-3e6b97fa2449@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 24, 2019 at 09:10:21PM +0200, Heiner Kallweit wrote:
> In several places in the kernel we find PCI_DEVID used like this:
> PCI_DEVID(dev->bus->number, dev->devfn) Therefore create a helper
> for it.
> 
> v2:
> - apply the change to all affected places in the kernel
> 
> Heiner Kallweit (9):
>   PCI: add helper pci_dev_id
>   PCI: use helper pci_dev_id
>   r8169: use new helper pci_dev_id
>   powerpc/powernv/npu: use helper pci_dev_id
>   drm/amdkfd: use helper pci_dev_id
>   iommu/amd: use helper pci_dev_id
>   iommu/vt-d: use helper pci_dev_id
>   stmmac: pci: use helper pci_dev_id
>   platform/chrome: chromeos_laptop: use helper pci_dev_id
> 
>  arch/powerpc/platforms/powernv/npu-dma.c         | 14 ++++++--------
>  drivers/gpu/drm/amd/amdkfd/kfd_topology.c        |  3 +--
>  drivers/iommu/amd_iommu.c                        |  2 +-
>  drivers/iommu/intel-iommu.c                      |  2 +-
>  drivers/iommu/intel_irq_remapping.c              |  2 +-
>  drivers/net/ethernet/realtek/r8169.c             |  3 +--
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  2 +-
>  drivers/pci/msi.c                                |  6 +++---
>  drivers/pci/search.c                             | 10 +++-------
>  drivers/platform/chrome/chromeos_laptop.c        |  2 +-
>  include/linux/pci.h                              |  5 +++++
>  11 files changed, 24 insertions(+), 27 deletions(-)

Applied with acks/reviewed-by from Benson, Joerg, Christian, Alexey, and
David to pci/misc for v5.2, thanks!
