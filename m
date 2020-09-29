Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266FE27D6AA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgI2TSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2TSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 15:18:00 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2E6B20774;
        Tue, 29 Sep 2020 19:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601407079;
        bh=PLMuI+7JwmyKjVAkvcqBqwoVrHNBT4ni6xGWmeifoYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=X0kP0I0BynDjfCk7pnD/tkidsBXkZug2YUb36AOE3pMrxRUrnQeoMu28d9yC2YW7b
         xhNo+fDttkvJ2uV8DOsz2byVe2ZzCs+Blv2WUFOOByPSCY8BC+VkwdyPOmHQ0PRnf6
         93MxDNHiXdqXbQ8Zi77eHo+5P63M5CAziPA50g+I=
Date:   Tue, 29 Sep 2020 14:17:56 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] PCI: Rename d3_delay in the pci_dev struct to align with
 PCI specification
Message-ID: <20200929191756.GA2562898@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200730210848.1578826-1-kw@linux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 09:08:48PM +0000, Krzysztof Wilczyński wrote:
> Rename PCI-related variable "d3_delay" to "d3hot_delay" in the pci_dev
> struct to better align with the PCI Firmware specification (see PCI
> Firmware Specification, Revision 3.2, Section 4.6.9, p. 73).
> 
> The pci_dev struct already contains variable "d3cold_delay", thus
> renaming "d3_delay" to "d3hot_delay" reduces ambiguity as PCI devices
> support two variants of the D3 power state: D3hot and D3cold.
> 
> Also, rename other constants and variables, and updates code comments
> and documentation to ensure alignment with the PCI specification.
> 
> There is no change to the functionality.
> 
> Signed-off-by: Krzysztof Wilczyński <kw@linux.com>

Applied to pci/pm for v5.10, thanks!

> ---
>  Documentation/power/pci.rst                   |  2 +-
>  arch/x86/pci/fixup.c                          |  2 +-
>  arch/x86/pci/intel_mid_pci.c                  |  2 +-
>  drivers/hid/intel-ish-hid/ipc/ipc.c           |  2 +-
>  drivers/net/ethernet/marvell/sky2.c           |  2 +-
>  drivers/pci/pci-acpi.c                        |  6 +-
>  drivers/pci/pci.c                             | 14 ++--
>  drivers/pci/pci.h                             |  4 +-
>  drivers/pci/quirks.c                          | 68 +++++++++----------
>  .../staging/media/atomisp/pci/atomisp_v4l2.c  |  2 +-
>  include/linux/pci.h                           |  2 +-
>  include/uapi/linux/pci_regs.h                 |  2 +-
>  12 files changed, 54 insertions(+), 54 deletions(-)
> 
> diff --git a/Documentation/power/pci.rst b/Documentation/power/pci.rst
> index 1831e431f725..b04fb18cc4e2 100644
> --- a/Documentation/power/pci.rst
> +++ b/Documentation/power/pci.rst
> @@ -320,7 +320,7 @@ that these callbacks operate on::
>  	unsigned int	d2_support:1;	/* Low power state D2 is supported */
>  	unsigned int	no_d1d2:1;	/* D1 and D2 are forbidden */
>  	unsigned int	wakeup_prepared:1;  /* Device prepared for wake up */
> -	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
> +	unsigned int	d3hot_delay;	/* D3hot->D0 transition time in ms */
>  	...
>    };
>  
> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index 0c67a5a94de3..9e3d9cc6afc4 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -587,7 +587,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0xa26d, pci_invalid_bar);
>  static void pci_fixup_amd_ehci_pme(struct pci_dev *dev)
>  {
>  	dev_info(&dev->dev, "PME# does not work under D3, disabling it\n");
> -	dev->pme_support &= ~((PCI_PM_CAP_PME_D3 | PCI_PM_CAP_PME_D3cold)
> +	dev->pme_support &= ~((PCI_PM_CAP_PME_D3hot | PCI_PM_CAP_PME_D3cold)
>  		>> PCI_PM_CAP_PME_SHIFT);
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x7808, pci_fixup_amd_ehci_pme);
> diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
> index 00c62115f39c..979f310b67d4 100644
> --- a/arch/x86/pci/intel_mid_pci.c
> +++ b/arch/x86/pci/intel_mid_pci.c
> @@ -322,7 +322,7 @@ static void pci_d3delay_fixup(struct pci_dev *dev)
>  	 */
>  	if (type1_access_ok(dev->bus->number, dev->devfn, PCI_DEVICE_ID))
>  		return;
> -	dev->d3_delay = 0;
> +	dev->d3hot_delay = 0;
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_d3delay_fixup);
>  
> diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
> index 8f8dfdf64833..a45ac7fa417b 100644
> --- a/drivers/hid/intel-ish-hid/ipc/ipc.c
> +++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
> @@ -755,7 +755,7 @@ static int _ish_hw_reset(struct ishtp_device *dev)
>  	csr |= PCI_D3hot;
>  	pci_write_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, csr);
>  
> -	mdelay(pdev->d3_delay);
> +	mdelay(pdev->d3hot_delay);
>  
>  	csr &= ~PCI_PM_CTRL_STATE_MASK;
>  	csr |= PCI_D0;
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
> index fe54764caea9..ce7a94060a96 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -5104,7 +5104,7 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	INIT_WORK(&hw->restart_work, sky2_restart);
>  
>  	pci_set_drvdata(pdev, hw);
> -	pdev->d3_delay = 300;
> +	pdev->d3hot_delay = 300;
>  
>  	return 0;
>  
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 7224b1e5f2a8..c54588ad2d9c 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -1167,7 +1167,7 @@ static struct acpi_device *acpi_pci_find_companion(struct device *dev)
>   * @pdev: the PCI device whose delay is to be updated
>   * @handle: ACPI handle of this device
>   *
> - * Update the d3_delay and d3cold_delay of a PCI device from the ACPI _DSM
> + * Update the d3hot_delay and d3cold_delay of a PCI device from the ACPI _DSM
>   * control method of either the device itself or the PCI host bridge.
>   *
>   * Function 8, "Reset Delay," applies to the entire hierarchy below a PCI
> @@ -1206,8 +1206,8 @@ static void pci_acpi_optimize_delay(struct pci_dev *pdev,
>  		}
>  		if (elements[3].type == ACPI_TYPE_INTEGER) {
>  			value = (int)elements[3].integer.value / 1000;
> -			if (value < PCI_PM_D3_WAIT)
> -				pdev->d3_delay = value;
> +			if (value < PCI_PM_D3HOT_WAIT)
> +				pdev->d3hot_delay = value;
>  		}
>  	}
>  	ACPI_FREE(obj);
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index c9338f914a0e..5e5d15a96fe1 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -49,7 +49,7 @@ EXPORT_SYMBOL(isa_dma_bridge_buggy);
>  int pci_pci_problems;
>  EXPORT_SYMBOL(pci_pci_problems);
>  
> -unsigned int pci_pm_d3_delay;
> +unsigned int pci_pm_d3hot_delay;
>  
>  static void pci_pme_list_scan(struct work_struct *work);
>  
> @@ -66,10 +66,10 @@ struct pci_pme_device {
>  
>  static void pci_dev_d3_sleep(struct pci_dev *dev)
>  {
> -	unsigned int delay = dev->d3_delay;
> +	unsigned int delay = dev->d3hot_delay;
>  
> -	if (delay < pci_pm_d3_delay)
> -		delay = pci_pm_d3_delay;
> +	if (delay < pci_pm_d3hot_delay)
> +		delay = pci_pm_d3hot_delay;
>  
>  	if (delay)
>  		msleep(delay);
> @@ -2878,7 +2878,7 @@ void pci_pm_init(struct pci_dev *dev)
>  	}
>  
>  	dev->pm_cap = pm;
> -	dev->d3_delay = PCI_PM_D3_WAIT;
> +	dev->d3hot_delay = PCI_PM_D3HOT_WAIT;
>  	dev->d3cold_delay = PCI_PM_D3COLD_WAIT;
>  	dev->bridge_d3 = pci_bridge_d3_possible(dev);
>  	dev->d3cold_allowed = true;
> @@ -2903,7 +2903,7 @@ void pci_pm_init(struct pci_dev *dev)
>  			 (pmc & PCI_PM_CAP_PME_D0) ? " D0" : "",
>  			 (pmc & PCI_PM_CAP_PME_D1) ? " D1" : "",
>  			 (pmc & PCI_PM_CAP_PME_D2) ? " D2" : "",
> -			 (pmc & PCI_PM_CAP_PME_D3) ? " D3hot" : "",
> +			 (pmc & PCI_PM_CAP_PME_D3hot) ? " D3hot" : "",
>  			 (pmc & PCI_PM_CAP_PME_D3cold) ? " D3cold" : "");
>  		dev->pme_support = pmc >> PCI_PM_CAP_PME_SHIFT;
>  		dev->pme_poll = true;
> @@ -4601,7 +4601,7 @@ static int pci_af_flr(struct pci_dev *dev, int probe)
>   *
>   * NOTE: This causes the caller to sleep for twice the device power transition
>   * cooldown period, which for the D0->D3hot and D3hot->D0 transitions is 10 ms
> - * by default (i.e. unless the @dev's d3_delay field has a different value).
> + * by default (i.e. unless the @dev's d3hot_delay field has a different value).
>   * Moreover, only devices in D0 can be reset by this function.
>   */
>  static int pci_pm_reset(struct pci_dev *dev, int probe)
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 6d3f75867106..70e699e2e264 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -44,7 +44,7 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
>  int pci_bus_error_reset(struct pci_dev *dev);
>  
>  #define PCI_PM_D2_DELAY         200
> -#define PCI_PM_D3_WAIT          10
> +#define PCI_PM_D3HOT_WAIT       10
>  #define PCI_PM_D3COLD_WAIT      100
>  #define PCI_PM_BUS_WAIT         50
>  
> @@ -177,7 +177,7 @@ extern struct mutex pci_slot_mutex;
>  
>  extern raw_spinlock_t pci_lock;
>  
> -extern unsigned int pci_pm_d3_delay;
> +extern unsigned int pci_pm_d3hot_delay;
>  
>  #ifdef CONFIG_PCI_MSI
>  void pci_no_msi(void);
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 812bfc32ecb8..b09215b75b10 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1846,7 +1846,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_PXHV,	quirk_pci
>   */
>  static void quirk_intel_pcie_pm(struct pci_dev *dev)
>  {
> -	pci_pm_d3_delay = 120;
> +	pci_pm_d3hot_delay = 120;
>  	dev->no_d1d2 = 1;
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x25e2, quirk_intel_pcie_pm);
> @@ -1873,12 +1873,12 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
>  
>  static void quirk_d3hot_delay(struct pci_dev *dev, unsigned int delay)
>  {
> -	if (dev->d3_delay >= delay)
> +	if (dev->d3hot_delay >= delay)
>  		return;
>  
> -	dev->d3_delay = delay;
> +	dev->d3hot_delay = delay;
>  	pci_info(dev, "extending delay after power-on from D3hot to %d msec\n",
> -		 dev->d3_delay);
> +		 dev->d3hot_delay);
>  }
>  
>  static void quirk_radeon_pm(struct pci_dev *dev)
> @@ -3374,36 +3374,36 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0152, disable_igfx_irq);
>   * PCI devices which are on Intel chips can skip the 10ms delay
>   * before entering D3 mode.
>   */
> -static void quirk_remove_d3_delay(struct pci_dev *dev)
> -{
> -	dev->d3_delay = 0;
> -}
> -/* C600 Series devices do not need 10ms d3_delay */
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0412, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0c00, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0c0c, quirk_remove_d3_delay);
> -/* Lynxpoint-H PCH devices do not need 10ms d3_delay */
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c02, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c18, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c1c, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c20, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c22, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c26, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c2d, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c31, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c3a, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c3d, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c4e, quirk_remove_d3_delay);
> -/* Intel Cherrytrail devices do not need 10ms d3_delay */
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2280, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2298, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x229c, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b0, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b5, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b7, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b8, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22d8, quirk_remove_d3_delay);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22dc, quirk_remove_d3_delay);
> +static void quirk_remove_d3hot_delay(struct pci_dev *dev)
> +{
> +	dev->d3hot_delay = 0;
> +}
> +/* C600 Series devices do not need 10ms d3hot_delay */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0412, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0c00, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0c0c, quirk_remove_d3hot_delay);
> +/* Lynxpoint-H PCH devices do not need 10ms d3hot_delay */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c02, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c18, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c1c, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c20, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c22, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c26, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c2d, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c31, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c3a, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c3d, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x8c4e, quirk_remove_d3hot_delay);
> +/* Intel Cherrytrail devices do not need 10ms d3hot_delay */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2280, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2298, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x229c, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b0, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b5, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b7, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22b8, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22d8, quirk_remove_d3hot_delay);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x22dc, quirk_remove_d3hot_delay);
>  
>  /*
>   * Some devices may pass our check in pci_intx_mask_supported() if
> diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
> index a000a1e316f7..beba430a197e 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
> @@ -1573,7 +1573,7 @@ static int atomisp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
>  	spin_lock_init(&isp->lock);
>  
>  	/* This is not a true PCI device on SoC, so the delay is not needed. */
> -	pdev->d3_delay = 0;
> +	pdev->d3hot_delay = 0;
>  
>  	pci_set_drvdata(pdev, isp);
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 34c1c4f45288..cd9abbbc55e3 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -373,7 +373,7 @@ struct pci_dev {
>  						      user sysfs */
>  	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
>  						   bit manually */
> -	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
> +	unsigned int	d3hot_delay;	/* D3hot->D0 transition time in ms */
>  	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
>  
>  #ifdef CONFIG_PCIEASPM
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index f9701410d3b5..49f15c37e771 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -246,7 +246,7 @@
>  #define  PCI_PM_CAP_PME_D0	0x0800	/* PME# from D0 */
>  #define  PCI_PM_CAP_PME_D1	0x1000	/* PME# from D1 */
>  #define  PCI_PM_CAP_PME_D2	0x2000	/* PME# from D2 */
> -#define  PCI_PM_CAP_PME_D3	0x4000	/* PME# from D3 (hot) */
> +#define  PCI_PM_CAP_PME_D3hot	0x4000	/* PME# from D3 (hot) */
>  #define  PCI_PM_CAP_PME_D3cold	0x8000	/* PME# from D3 (cold) */
>  #define  PCI_PM_CAP_PME_SHIFT	11	/* Start of the PME Mask in PMC */
>  #define PCI_PM_CTRL		4	/* PM control and status register */
> -- 
> 2.27.0
> 
