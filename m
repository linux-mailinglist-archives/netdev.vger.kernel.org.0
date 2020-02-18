Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7204B162E09
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgBRSOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:14:05 -0500
Received: from foss.arm.com ([217.140.110.172]:58186 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgBRSOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 13:14:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65A9331B;
        Tue, 18 Feb 2020 10:14:03 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8412E3F68F;
        Tue, 18 Feb 2020 10:13:59 -0800 (PST)
Date:   Tue, 18 Feb 2020 18:13:56 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 00/11] Removing Calxeda platform support
Message-ID: <20200218181356.09ae0779@donnerap.cambridge.arm.com>
In-Reply-To: <20200218171321.30990-1-robh@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 11:13:10 -0600
Rob Herring <robh@kernel.org> wrote:

Hi,

> Calxeda has been defunct for 6 years now. Use of Calxeda servers carried
> on for some time afterwards primarily as distro builders for 32-bit ARM.
> AFAIK, those systems have been retired in favor of 32-bit VMs on 64-bit
> hosts.
> 
> The other use of Calxeda Midway I'm aware of was testing 32-bit ARM KVM
> support as there are few or no other systems with enough RAM and LPAE. Now
> 32-bit KVM host support is getting removed[1].
> 
> While it's not much maintenance to support, I don't care to convert the
> Calxeda DT bindings to schema nor fix any resulting errors in the dts files
> (which already don't exactly match what's shipping in firmware).

While every kernel maintainer seems always happy to take patches with a negative diffstat, I wonder if this is really justification enough to remove a perfectly working platform. I don't really know about any active users, but experience tells that some platforms really are used for quite a long time, even if they are somewhat obscure. N900 or Netwinder, anyone?

So to not give the impression that actually *everyone* (from that small subset of people actively reading the kernel list) is happy with that, I think that having support for at least Midway would be useful. On the one hand it's a decent LPAE platform (with memory actually exceeding 4GB), and on the other hand it's something with capable I/O (SATA) and networking, so one can actually stress test the system. Which is the reason I was using that for KVM testing, but even with that probably going away now there remain still some use cases, and be it for general ARM(32) testing.

I don't particularly care about the more optional parts like EDAC, cpuidle, or cpufreq, but I wonder if keeping in at least the rather small SATA and XGMAC drivers and basic platform support is feasible.
If YAML DT bindings are used as an excuse, I am more than happy to convert those over.

And if anyone has any particular gripes with some code, maybe there is a way to fix that instead of removing it? I was always wondering if we could get rid of the mach-highbank directory, for instance. I think most of it is Highbank (Cortex-A9) related.

Cheers,
Andre

> 
> Rob
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20200210141324.21090-1-maz@kernel.org/
> 
> Rob Herring (11):
>   vfio: Remove Calxeda XGMAC reset driver
>   ata: Remove Calxeda AHCI driver
>   cpuidle: Remove Calxeda driver
>   cpufreq: Remove Calxeda driver
>   EDAC: Remove Calxeda drivers
>   iommu: arm-smmu: Remove Calxeda secure mode quirk
>   net: Remove Calxeda XGMAC driver
>   clk: Remove Calxeda driver
>   ARM: Remove Calxeda platform support
>   ARM: dts: Remove Calxeda platforms
>   dt-bindings: Remove Calxeda platforms bindings
> 
>  .../devicetree/bindings/arm/calxeda.yaml      |   22 -
>  .../devicetree/bindings/arm/calxeda/l2ecc.txt |   15 -
>  .../devicetree/bindings/ata/sata_highbank.txt |   44 -
>  .../devicetree/bindings/clock/calxeda.txt     |   17 -
>  .../memory-controllers/calxeda-ddr-ctrlr.txt  |   16 -
>  .../devicetree/bindings/net/calxeda-xgmac.txt |   18 -
>  .../bindings/phy/calxeda-combophy.txt         |   17 -
>  MAINTAINERS                                   |   14 -
>  arch/arm/Kconfig                              |    2 -
>  arch/arm/Kconfig.debug                        |   12 +-
>  arch/arm/Makefile                             |    1 -
>  arch/arm/boot/dts/Makefile                    |    3 -
>  arch/arm/boot/dts/ecx-2000.dts                |  103 -
>  arch/arm/boot/dts/ecx-common.dtsi             |  230 --
>  arch/arm/boot/dts/highbank.dts                |  161 --
>  arch/arm/configs/multi_v7_defconfig           |    5 -
>  arch/arm/mach-highbank/Kconfig                |   19 -
>  arch/arm/mach-highbank/Makefile               |    4 -
>  arch/arm/mach-highbank/core.h                 |   18 -
>  arch/arm/mach-highbank/highbank.c             |  175 --
>  arch/arm/mach-highbank/pm.c                   |   49 -
>  arch/arm/mach-highbank/smc.S                  |   25 -
>  arch/arm/mach-highbank/sysregs.h              |   75 -
>  arch/arm/mach-highbank/system.c               |   22 -
>  drivers/ata/Kconfig                           |    9 -
>  drivers/ata/Makefile                          |    1 -
>  drivers/ata/sata_highbank.c                   |  635 ------
>  drivers/clk/Makefile                          |    1 -
>  drivers/clk/clk-highbank.c                    |  329 ---
>  drivers/cpufreq/Kconfig.arm                   |   10 -
>  drivers/cpufreq/Makefile                      |    3 +-
>  drivers/cpufreq/cpufreq-dt-platdev.c          |    3 -
>  drivers/cpufreq/highbank-cpufreq.c            |  106 -
>  drivers/cpuidle/Kconfig.arm                   |    7 -
>  drivers/cpuidle/Makefile                      |    1 -
>  drivers/cpuidle/cpuidle-calxeda.c             |   72 -
>  drivers/edac/Kconfig                          |   14 -
>  drivers/edac/Makefile                         |    3 -
>  drivers/edac/highbank_l2_edac.c               |  142 --
>  drivers/edac/highbank_mc_edac.c               |  272 ---
>  drivers/iommu/arm-smmu-impl.c                 |   43 -
>  drivers/net/ethernet/Kconfig                  |    1 -
>  drivers/net/ethernet/Makefile                 |    1 -
>  drivers/net/ethernet/calxeda/Kconfig          |    9 -
>  drivers/net/ethernet/calxeda/Makefile         |    2 -
>  drivers/net/ethernet/calxeda/xgmac.c          | 1927 -----------------
>  drivers/vfio/platform/reset/Kconfig           |    8 -
>  drivers/vfio/platform/reset/Makefile          |    2 -
>  .../reset/vfio_platform_calxedaxgmac.c        |   74 -
>  49 files changed, 2 insertions(+), 4740 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/calxeda.yaml
>  delete mode 100644 Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
>  delete mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt
>  delete mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
>  delete mode 100644 Documentation/devicetree/bindings/memory-controllers/calxeda-ddr-ctrlr.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/calxeda-xgmac.txt
>  delete mode 100644 Documentation/devicetree/bindings/phy/calxeda-combophy.txt
>  delete mode 100644 arch/arm/boot/dts/ecx-2000.dts
>  delete mode 100644 arch/arm/boot/dts/ecx-common.dtsi
>  delete mode 100644 arch/arm/boot/dts/highbank.dts
>  delete mode 100644 arch/arm/mach-highbank/Kconfig
>  delete mode 100644 arch/arm/mach-highbank/Makefile
>  delete mode 100644 arch/arm/mach-highbank/core.h
>  delete mode 100644 arch/arm/mach-highbank/highbank.c
>  delete mode 100644 arch/arm/mach-highbank/pm.c
>  delete mode 100644 arch/arm/mach-highbank/smc.S
>  delete mode 100644 arch/arm/mach-highbank/sysregs.h
>  delete mode 100644 arch/arm/mach-highbank/system.c
>  delete mode 100644 drivers/ata/sata_highbank.c
>  delete mode 100644 drivers/clk/clk-highbank.c
>  delete mode 100644 drivers/cpufreq/highbank-cpufreq.c
>  delete mode 100644 drivers/cpuidle/cpuidle-calxeda.c
>  delete mode 100644 drivers/edac/highbank_l2_edac.c
>  delete mode 100644 drivers/edac/highbank_mc_edac.c
>  delete mode 100644 drivers/net/ethernet/calxeda/Kconfig
>  delete mode 100644 drivers/net/ethernet/calxeda/Makefile
>  delete mode 100644 drivers/net/ethernet/calxeda/xgmac.c
>  delete mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> 
> 
> base-commit: 11a48a5a18c63fd7621bb050228cebf13566e4d8
> --
> 2.20.1

