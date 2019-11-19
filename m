Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958691022E8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfKSLSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:53 -0500
Received: from foss.arm.com ([217.140.110.172]:50972 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfKSLSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 06:18:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38842FEC;
        Tue, 19 Nov 2019 03:18:52 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F07D3F703;
        Tue, 19 Nov 2019 03:18:51 -0800 (PST)
Date:   Tue, 19 Nov 2019 11:18:49 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     maz@kernel.org, linux-kernel@vger.kernel.org,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, Robin Murphy <robin.murphy@arm.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/6] Raspberry Pi 4 PCIe support
Message-ID: <20191119111848.GR43905@e119886-lin.cambridge.arm.com>
References: <20191112155926.16476-1-nsaenzjulienne@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112155926.16476-1-nsaenzjulienne@suse.de>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 04:59:19PM +0100, Nicolas Saenz Julienne wrote:
> This series aims at providing support for Raspberry Pi 4's PCIe
> controller, which is also shared with the Broadcom STB family of
> devices.
> 
> There was a previous attempt to upstream this some years ago[1] but was
> blocked as most STB PCIe integrations have a sparse DMA mapping[2] which
> is something currently not supported by the kernel.  Luckily this is not
> the case for the Raspberry Pi 4.
> 
> Note that the driver code is to be based on top of Rob Herring's series
> simplifying inbound and outbound range parsing.
> 
> [1] https://patchwork.kernel.org/cover/10605933/
> [2] https://patchwork.kernel.org/patch/10605957/
> 

What happened to patch 3? I can't see it on the list or in patchwork?

Thanks,

Andrew Murray

> ---
> 
> Changes since v1:
>   - add generic rounddown/roundup_pow_two64() patch
>   - Add MAINTAINERS patch
>   - Fix Kconfig
>   - Cleanup probe, use up to date APIs, exit on MSI failure
>   - Get rid of linux,pci-domain and other unused constructs
>   - Use edge triggered setup for MSI
>   - Cleanup MSI implementation
>   - Fix multiple cosmetic issues
>   - Remove supend/resume code
> 
> Jim Quinlan (3):
>   dt-bindings: PCI: Add bindings for brcmstb's PCIe device
>   PCI: brcmstb: add Broadcom STB PCIe host controller driver
>   PCI: brcmstb: add MSI capability
> 
> Nicolas Saenz Julienne (3):
>   linux/log2.h: Add roundup/rounddown_pow_two64() family of functions
>   ARM: dts: bcm2711: Enable PCIe controller
>   MAINTAINERS: Add brcmstb PCIe controller
> 
>  .../bindings/pci/brcm,stb-pcie.yaml           |  110 ++
>  MAINTAINERS                                   |    4 +
>  arch/arm/boot/dts/bcm2711.dtsi                |   46 +
>  drivers/net/ethernet/mellanox/mlx4/en_clock.c |    3 +-
>  drivers/pci/controller/Kconfig                |    9 +
>  drivers/pci/controller/Makefile               |    1 +
>  drivers/pci/controller/pcie-brcmstb.c         | 1179 +++++++++++++++++
>  drivers/pci/controller/pcie-cadence-ep.c      |    7 +-
>  drivers/pci/controller/pcie-cadence.c         |    7 +-
>  drivers/pci/controller/pcie-rockchip-ep.c     |    9 +-
>  include/linux/log2.h                          |   52 +
>  kernel/dma/direct.c                           |    3 +-
>  12 files changed, 1412 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
>  create mode 100644 drivers/pci/controller/pcie-brcmstb.c
> 
> -- 
> 2.24.0
> 
