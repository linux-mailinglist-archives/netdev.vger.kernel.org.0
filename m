Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2A42107B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238681AbhJDNoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbhJDNnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 09:43:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3C9C028B90
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 06:00:49 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mXNZO-00054e-PH; Mon, 04 Oct 2021 14:59:50 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mXNZF-0000Kt-4h; Mon, 04 Oct 2021 14:59:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mXNZE-0000ay-Vr; Mon, 04 Oct 2021 14:59:40 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org, kernel@pengutronix.de,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jack Xu <jack.xu@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        qat-linux@intel.com, x86@kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's bound driver
Date:   Mon,  4 Oct 2021 14:59:24 +0200
Message-Id: <20211004125935.2300113-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v6 of the quest to drop the "driver" member from struct pci_dev
which tracks the same data (apart from a constant offset) as dev.driver.

Changes since v5:
 - Some Acks added
 - Some fixes in "PCI: Replace pci_dev::driver usage by
   pci_dev::dev.driver" to properly handle that
   to_pci_driver(X) is wrong if X is NULL.
   This should fix the problem reported by Ido Schimmel.

Full range diff below.

This patch stack survived an allmodconfig build on arm64, m68k, powerpc,
riscv, s390, sparc64 and x86_64 on top of v5.15-rc3.

Best regards
Uwe

Uwe Kleine-König (11):
  PCI: Simplify pci_device_remove()
  PCI: Drop useless check from pci_device_probe()
  xen/pci: Drop some checks that are always true
  bcma: simplify reference to the driver's name
  powerpc/eeh: Don't use driver member of struct pci_dev and further
    cleanups
  ssb: Simplify determination of driver name
  PCI: Replace pci_dev::driver usage that gets the driver name
  scsi: message: fusion: Remove unused parameter of mpt_pci driver's
    probe()
  crypto: qat - simplify adf_enable_aer()
  PCI: Replace pci_dev::driver usage by pci_dev::dev.driver
  PCI: Drop duplicated tracking of a pci_dev's bound driver

 arch/powerpc/include/asm/ppc-pci.h            |  5 -
 arch/powerpc/kernel/eeh.c                     |  8 ++
 arch/powerpc/kernel/eeh_driver.c              | 10 +-
 arch/x86/events/intel/uncore.c                |  2 +-
 arch/x86/kernel/probe_roms.c                  | 10 +-
 drivers/bcma/host_pci.c                       |  6 +-
 drivers/crypto/hisilicon/qm.c                 |  2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  7 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  7 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  7 +-
 drivers/crypto/qat/qat_common/adf_aer.c       | 10 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  3 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  7 +-
 drivers/message/fusion/mptbase.c              |  7 +-
 drivers/message/fusion/mptbase.h              |  2 +-
 drivers/message/fusion/mptctl.c               |  4 +-
 drivers/message/fusion/mptlan.c               |  2 +-
 drivers/misc/cxl/guest.c                      | 24 +++--
 drivers/misc/cxl/pci.c                        | 30 +++---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  2 +-
 .../ethernet/marvell/prestera/prestera_pci.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  3 +-
 drivers/pci/iov.c                             | 33 +++++--
 drivers/pci/pci-driver.c                      | 96 ++++++++++---------
 drivers/pci/pci.c                             |  4 +-
 drivers/pci/pcie/err.c                        | 36 +++----
 drivers/pci/xen-pcifront.c                    | 63 ++++++------
 drivers/ssb/pcihost_wrapper.c                 |  6 +-
 drivers/usb/host/xhci-pci.c                   |  2 +-
 include/linux/pci.h                           |  1 -
 31 files changed, 208 insertions(+), 195 deletions(-)

Range-diff against v5:
 -:  ------------ >  1:  c2b53ab26a6b PCI: Simplify pci_device_remove()
 -:  ------------ >  2:  2c733e1d5186 PCI: Drop useless check from pci_device_probe()
 -:  ------------ >  3:  547ca5a7aa16 xen/pci: Drop some checks that are always true
 -:  ------------ >  4:  40eb07353844 bcma: simplify reference to the driver's name
 -:  ------------ >  5:  bab59c1dff6d powerpc/eeh: Don't use driver member of struct pci_dev and further cleanups
 1:  abd70de9782d !  6:  92f4d61bbac3 ssb: Simplify determination of driver name
    @@ Commit message
         This has the upside of not requiring the driver member of struct pci_dev
         which is about to be removed and being simpler.
     
    +    Acked-by: Michael Büsch <m@bues.ch>
         Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
     
      ## drivers/ssb/pcihost_wrapper.c ##
 2:  735845bd26b9 !  7:  6303f03ab2aa PCI: Replace pci_dev::driver usage that gets the driver name
    @@ Commit message
         driver name by dev_driver_string() which implicitly makes use of struct
         pci_dev::dev->driver.
     
    +    Acked-by: Simon Horman <simon.horman@corigine.com> (for NFP)
         Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
     
      ## drivers/crypto/hisilicon/qm.c ##
 3:  1e58019165b9 =  8:  658a6c00ec96 scsi: message: fusion: Remove unused parameter of mpt_pci driver's probe()
 4:  dea72a470141 =  9:  aceaf5321603 crypto: qat - simplify adf_enable_aer()
 5:  b4165dda38ea ! 10:  80648d999985 PCI: Replace pci_dev::driver usage by pci_dev::dev.driver
    @@ arch/x86/kernel/probe_roms.c: static struct resource video_rom_resource = {
      static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
      {
     -	struct pci_driver *drv = pdev->driver;
    -+	struct pci_driver *drv = to_pci_driver(pdev->dev.driver);
      	const struct pci_device_id *id;
      
      	if (pdev->vendor == vendor && pdev->device == device)
    + 		return true;
    + 
    +-	for (id = drv ? drv->id_table : NULL; id && id->vendor; id++)
    +-		if (id->vendor == vendor && id->device == device)
    +-			break;
    ++	if (pdev->dev.driver) {
    ++		struct pci_driver *drv = to_pci_driver(pdev->dev.driver);
    ++		for (id = drv->id_table; id && id->vendor; id++)
    ++			if (id->vendor == vendor && id->device == device)
    ++				break;
    ++	}
    + 
    + 	return id && id->vendor;
    + }
     
      ## drivers/misc/cxl/guest.c ##
     @@ drivers/misc/cxl/guest.c: static void pci_error_handlers(struct cxl_afu *afu,
    @@ drivers/pci/iov.c: static ssize_t sriov_vf_total_msix_show(struct device *dev,
      
      	device_lock(dev);
     -	if (!pdev->driver || !pdev->driver->sriov_get_vf_total_msix)
    -+	pdrv = to_pci_driver(dev->driver);
    -+	if (!pdrv || !pdrv->sriov_get_vf_total_msix)
    ++	if (!dev->driver)
      		goto unlock;
      
     -	vf_total_msix = pdev->driver->sriov_get_vf_total_msix(pdev);
    ++	pdrv = to_pci_driver(dev->driver);
    ++	if (!pdrv->sriov_get_vf_total_msix)
    ++		goto unlock;
    ++
     +	vf_total_msix = pdrv->sriov_get_vf_total_msix(pdev);
      unlock:
      	device_unlock(dev);
    @@ drivers/pci/iov.c: static ssize_t sriov_vf_msix_count_store(struct device *dev,
      
      	device_lock(&pdev->dev);
     -	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
    ++	if (!pdev->dev.driver) {
    ++		ret = -EOPNOTSUPP;
    ++		goto err_pdev;
    ++	}
    ++
     +	pdrv = to_pci_driver(pdev->dev.driver);
    -+	if (!pdrv || !pdrv->sriov_set_msix_vec_count) {
    ++	if (!pdrv->sriov_set_msix_vec_count) {
      		ret = -EOPNOTSUPP;
      		goto err_pdev;
      	}
    @@ drivers/pci/pci-driver.c: static void pci_device_remove(struct device *dev)
      {
      	struct pci_dev *pci_dev = to_pci_dev(dev);
     -	struct pci_driver *drv = pci_dev->driver;
    -+	struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
      
      	pm_runtime_resume(dev);
      
    +-	if (drv && drv->shutdown)
    +-		drv->shutdown(pci_dev);
    ++	if (pci_dev->dev.driver) {
    ++		struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
    ++
    ++		if (drv->shutdown)
    ++			drv->shutdown(pci_dev);
    ++	}
    + 
    + 	/*
    + 	 * If this is a kexec reboot, turn off Bus Master bit on the
     @@ drivers/pci/pci-driver.c: static int pci_pm_reenable_device(struct pci_dev *pci_dev)
      static int pci_legacy_suspend(struct device *dev, pm_message_t state)
      {
      	struct pci_dev *pci_dev = to_pci_dev(dev);
     -	struct pci_driver *drv = pci_dev->driver;
    -+	struct pci_driver *drv = to_pci_driver(dev->driver);
      
    - 	if (drv && drv->suspend) {
    - 		pci_power_t prev = pci_dev->current_state;
    +-	if (drv && drv->suspend) {
    +-		pci_power_t prev = pci_dev->current_state;
    +-		int error;
    ++	if (dev->driver) {
    ++		struct pci_driver *drv = to_pci_driver(dev->driver);
    + 
    +-		error = drv->suspend(pci_dev, state);
    +-		suspend_report_result(drv->suspend, error);
    +-		if (error)
    +-			return error;
    ++		if (drv->suspend) {
    ++			pci_power_t prev = pci_dev->current_state;
    ++			int error;
    + 
    +-		if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
    +-		    && pci_dev->current_state != PCI_UNKNOWN) {
    +-			pci_WARN_ONCE(pci_dev, pci_dev->current_state != prev,
    +-				      "PCI PM: Device state not saved by %pS\n",
    +-				      drv->suspend);
    ++			error = drv->suspend(pci_dev, state);
    ++			suspend_report_result(drv->suspend, error);
    ++			if (error)
    ++				return error;
    ++
    ++			if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
    ++			    && pci_dev->current_state != PCI_UNKNOWN) {
    ++				pci_WARN_ONCE(pci_dev, pci_dev->current_state != prev,
    ++					      "PCI PM: Device state not saved by %pS\n",
    ++					      drv->suspend);
    ++			}
    + 		}
    + 	}
    + 
     @@ drivers/pci/pci-driver.c: static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
      static int pci_legacy_resume(struct device *dev)
      {
      	struct pci_dev *pci_dev = to_pci_dev(dev);
     -	struct pci_driver *drv = pci_dev->driver;
    -+	struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
      
      	pci_fixup_device(pci_fixup_resume, pci_dev);
      
    +-	return drv && drv->resume ?
    +-			drv->resume(pci_dev) : pci_pm_reenable_device(pci_dev);
    ++	if (pci_dev->dev.driver) {
    ++		struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
    ++
    ++		if (drv->resume)
    ++			return drv->resume(pci_dev);
    ++	}
    ++
    ++	return pci_pm_reenable_device(pci_dev);
    + }
    + 
    + /* Auxiliary functions used by the new power management framework */
     @@ drivers/pci/pci-driver.c: static void pci_pm_default_suspend(struct pci_dev *pci_dev)
      
      static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
      {
     -	struct pci_driver *drv = pci_dev->driver;
    -+	struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
    - 	bool ret = drv && (drv->suspend || drv->resume);
    +-	bool ret = drv && (drv->suspend || drv->resume);
    ++	struct pci_driver *drv;
    ++	bool ret;
    ++
    ++	if (!pci_dev->dev.driver)
    ++		return false;
    ++
    ++	drv = to_pci_driver(pci_dev->dev.driver);
    ++	ret = drv && (drv->suspend || drv->resume);
      
      	/*
    + 	 * Legacy PM support is used by default, so warn if the new framework is
     @@ drivers/pci/pci-driver.c: static int pci_pm_runtime_suspend(struct device *dev)
      	int error;
      
 6:  d93a138bd7ab = 11:  2686d69bca17 PCI: Drop duplicated tracking of a pci_dev's bound driver

base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
-- 
2.30.2

