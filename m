Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CCF114835
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfLEUit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfLEUit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 15:38:49 -0500
Received: from localhost (mobile-166-170-221-197.mycingular.net [166.170.221.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B455D205F4;
        Thu,  5 Dec 2019 20:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575578328;
        bh=K7c3qaYFnXWMMqmwVGrwX7rG4+uwWtUsCcODfBtRF1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=NWmiSx+ex1TjiKC4MaIx3xgvijveWrSbxbs+XjqnQh8NtXiBsDxOC54dxgdSCwY2Q
         JFbBLgr1/UwBKIqUKv7MLbUuUhoa33JyMTyHQS/JVBgESXzRhy4V3aJStQ6g6aSYgd
         BMEn5r9MAm2BdXlEKpf1Z9W0pYFSQT6+AX76sG20=
Date:   Thu, 5 Dec 2019 14:38:45 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        phil@raspberrypi.org, jeremy.linton@arm.com,
        linux-pci@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH v4 8/8] linux/log2.h: Use roundup/dow_pow_two() on 64bit
 calculations
Message-ID: <20191205203845.GA243596@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203114743.1294-9-nsaenzjulienne@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject contains a couple typos: it's missing "of" and it's
missing the "n" on "down".

On Tue, Dec 03, 2019 at 12:47:41PM +0100, Nicolas Saenz Julienne wrote:
> The function now is safe to use while expecting a 64bit value. Use it
> where relevant.

Please include the function names ("roundup_pow_of_two()",
"rounddown_pow_of_two()") in the changelog so it is self-contained and
doesn't depend on the subject.

> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

With the nits above and below addressed,

Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# drivers/pci

> ---
>  drivers/acpi/arm64/iort.c                        | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/en_clock.c    | 3 ++-
>  drivers/of/device.c                              | 3 ++-
>  drivers/pci/controller/cadence/pcie-cadence-ep.c | 3 ++-
>  drivers/pci/controller/cadence/pcie-cadence.c    | 3 ++-
>  drivers/pci/controller/pcie-brcmstb.c            | 3 ++-
>  drivers/pci/controller/pcie-rockchip-ep.c        | 5 +++--
>  kernel/dma/direct.c                              | 2 +-
>  8 files changed, 15 insertions(+), 9 deletions(-)

> --- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
> +++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
> @@ -10,6 +10,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/sizes.h>
> +#include <linux/log2.h>
>  
>  #include "pcie-cadence.h"
>  
> @@ -65,7 +66,7 @@ static int cdns_pcie_ep_set_bar(struct pci_epc *epc, u8 fn,
>  	 * roundup_pow_of_two() returns an unsigned long, which is not suited
>  	 * for 64bit values.
>  	 */

Please remove the comment above since it no longer applies.

> -	sz = 1ULL << fls64(sz - 1);
> +	sz = roundup_pow_of_two(sz);
>  	aperture = ilog2(sz) - 7; /* 128B -> 0, 256B -> 1, 512B -> 2, ... */
>  
>  	if ((flags & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
> diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
> index cd795f6fc1e2..b1689f725b41 100644
> --- a/drivers/pci/controller/cadence/pcie-cadence.c
> +++ b/drivers/pci/controller/cadence/pcie-cadence.c
> @@ -4,6 +4,7 @@
>  // Author: Cyrille Pitchen <cyrille.pitchen@free-electrons.com>
>  
>  #include <linux/kernel.h>
> +#include <linux/log2.h>
>  
>  #include "pcie-cadence.h"
>  
> @@ -15,7 +16,7 @@ void cdns_pcie_set_outbound_region(struct cdns_pcie *pcie, u8 fn,
>  	 * roundup_pow_of_two() returns an unsigned long, which is not suited
>  	 * for 64bit values.
>  	 */

Same here.

> -	u64 sz = 1ULL << fls64(size - 1);
> +	u64 sz = roundup_pow_of_two(size);
>  	int nbits = ilog2(sz);
>  	u32 addr0, addr1, desc0, desc1;
>  
> --- a/drivers/pci/controller/pcie-rockchip-ep.c
> +++ b/drivers/pci/controller/pcie-rockchip-ep.c
> @@ -16,6 +16,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pci-epf.h>
>  #include <linux/sizes.h>
> +#include <linux/log2.h>
>  
>  #include "pcie-rockchip.h"
>  
> @@ -70,7 +71,7 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
>  					 u32 r, u32 type, u64 cpu_addr,
>  					 u64 pci_addr, size_t size)
>  {
> -	u64 sz = 1ULL << fls64(size - 1);
> +	u64 sz = roundup_pow_of_two(size);
>  	int num_pass_bits = ilog2(sz);
>  	u32 addr0, addr1, desc0, desc1;
>  	bool is_nor_msg = (type == AXI_WRAPPER_NOR_MSG);
> @@ -176,7 +177,7 @@ static int rockchip_pcie_ep_set_bar(struct pci_epc *epc, u8 fn,
>  	 * roundup_pow_of_two() returns an unsigned long, which is not suited
>  	 * for 64bit values.
>  	 */

And here.

> -	sz = 1ULL << fls64(sz - 1);
> +	sz = roundup_pow_of_two(sz);
>  	aperture = ilog2(sz) - 7; /* 128B -> 0, 256B -> 1, 512B -> 2, ... */
>  
>  	if ((flags & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 6af7ae83c4ad..056886c4efec 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -53,7 +53,7 @@ u64 dma_direct_get_required_mask(struct device *dev)
>  {
>  	u64 max_dma = phys_to_dma_direct(dev, (max_pfn - 1) << PAGE_SHIFT);
>  
> -	return (1ULL << (fls64(max_dma) - 1)) * 2 - 1;
> +	return rounddown_pow_of_two(max_dma) * 2 - 1;

Personally I would probably make this one a separate patch since it's
qualitatively different than the others and it would avoid the slight
awkwardness of the non-greppable "roundup/down_pow_of_two()"
construction in the commit subject.

But it's fine either way.

>  }
>  
>  static gfp_t __dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
> -- 
> 2.24.0
> 
