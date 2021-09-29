Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EA741C125
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244962AbhI2I5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244963AbhI2I47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 04:56:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE44C061762
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 01:55:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVVL8-0001if-2j; Wed, 29 Sep 2021 10:53:22 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVVL1-0004fa-GN; Wed, 29 Sep 2021 10:53:15 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mVVL1-0000Ow-C0; Wed, 29 Sep 2021 10:53:15 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-pci@vger.kernel.org,
        kernel@pengutronix.de, Alexander Duyck <alexanderduyck@fb.com>,
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
Subject: [PATCH v5 00/11] PCI: Drop duplicated tracking of a pci_dev's bound driver
Date:   Wed, 29 Sep 2021 10:52:55 +0200
Message-Id: <20210929085306.2203850-1-u.kleine-koenig@pengutronix.de>
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

this is v5 of the quest to drop the "driver" member from struct pci_dev
which tracks the same data (apart from a constant offset) as dev.driver.

Changes since v4:
 - split some changes out of "PCI: replace pci_dev::driver usage that
   gets the driver name" and reworked them a bit as suggested by Bjorn.
 - Add a line break in
   drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c to please
   checkpatch --strict and Simon Horman.
 - Fixed a build problem in "crypto: qat - simplify adf_enable_aer()",
   thanks to Giovanni Cabiddu for spotting and a suggested fix.

I didn't replace :: by . as suggested by Bjorn as I'm unsure if his
preference is stronger than mine.

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

 arch/powerpc/include/asm/ppc-pci.h            |  5 --
 arch/powerpc/kernel/eeh.c                     |  8 +++
 arch/powerpc/kernel/eeh_driver.c              | 10 +--
 arch/x86/events/intel/uncore.c                |  2 +-
 arch/x86/kernel/probe_roms.c                  |  2 +-
 drivers/bcma/host_pci.c                       |  6 +-
 drivers/crypto/hisilicon/qm.c                 |  2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  7 +--
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  7 +--
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  7 +--
 drivers/crypto/qat/qat_common/adf_aer.c       | 10 +--
 .../crypto/qat/qat_common/adf_common_drv.h    |  3 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  7 +--
 drivers/message/fusion/mptbase.c              |  7 +--
 drivers/message/fusion/mptbase.h              |  2 +-
 drivers/message/fusion/mptctl.c               |  4 +-
 drivers/message/fusion/mptlan.c               |  2 +-
 drivers/misc/cxl/guest.c                      | 24 ++++---
 drivers/misc/cxl/pci.c                        | 30 +++++----
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  2 +-
 .../ethernet/marvell/prestera/prestera_pci.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  3 +-
 drivers/pci/iov.c                             | 25 +++++---
 drivers/pci/pci-driver.c                      | 45 ++++++-------
 drivers/pci/pci.c                             |  4 +-
 drivers/pci/pcie/err.c                        | 36 ++++++-----
 drivers/pci/xen-pcifront.c                    | 63 +++++++++----------
 drivers/ssb/pcihost_wrapper.c                 |  6 +-
 drivers/usb/host/xhci-pci.c                   |  2 +-
 include/linux/pci.h                           |  1 -
 31 files changed, 161 insertions(+), 175 deletions(-)

Range-diff against v4:
 1:  8d064bbc74b0 =  1:  c2b53ab26a6b PCI: Simplify pci_device_remove()
 2:  966b49c308b4 =  2:  2c733e1d5186 PCI: Drop useless check from pci_device_probe()
 3:  ce710d6e8a1b =  3:  547ca5a7aa16 xen/pci: Drop some checks that are always true
 -:  ------------ >  4:  40eb07353844 bcma: simplify reference to the driver's name
 -:  ------------ >  5:  bab59c1dff6d powerpc/eeh: Don't use driver member of struct pci_dev and further cleanups
 -:  ------------ >  6:  abd70de9782d ssb: Simplify determination of driver name
 4:  3e4e6994a59d !  7:  735845bd26b9 PCI: replace pci_dev::driver usage that gets the driver name
    @@ Metadata
     Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
     
      ## Commit message ##
    -    PCI: replace pci_dev::driver usage that gets the driver name
    +    PCI: Replace pci_dev::driver usage that gets the driver name
     
         struct pci_dev::driver holds (apart from a constant offset) the same
         data as struct pci_dev::dev->driver. With the goal to remove struct
    @@ Commit message
     
         Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
     
    - ## arch/powerpc/include/asm/ppc-pci.h ##
    -@@ arch/powerpc/include/asm/ppc-pci.h: void eeh_sysfs_remove_device(struct pci_dev *pdev);
    - 
    - static inline const char *eeh_driver_name(struct pci_dev *pdev)
    - {
    --	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
    -+	if (pdev) {
    -+		const char *drvstr = dev_driver_string(&pdev->dev);
    -+
    -+		if (strcmp(drvstr, ""))
    -+			return drvstr;
    -+	}
    -+
    -+	return "<null>";
    - }
    - 
    - #endif /* CONFIG_EEH */
    -
    - ## drivers/bcma/host_pci.c ##
    -@@ drivers/bcma/host_pci.c: static int bcma_host_pci_probe(struct pci_dev *dev,
    - 	if (err)
    - 		goto err_kfree_bus;
    - 
    --	name = dev_name(&dev->dev);
    --	if (dev->driver && dev->driver->name)
    --		name = dev->driver->name;
    -+	name = dev_driver_string(&dev->dev);
    -+	if (!strcmp(name, ""))
    -+		name = dev_name(&dev->dev);
    -+
    - 	err = pci_request_regions(dev, name);
    - 	if (err)
    - 		goto err_pci_disable;
    -
      ## drivers/crypto/hisilicon/qm.c ##
     @@ drivers/crypto/hisilicon/qm.c: static int qm_alloc_uacce(struct hisi_qm *qm)
      	};
    @@ drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: nfp_get_drvinfo(struct nfp
      	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
      
     -	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
    -+	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvinfo->driver));
    ++	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev),
    ++		sizeof(drvinfo->driver));
      	nfp_net_get_nspinfo(app, nsp_version);
      	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
      		 "%s %s %s %s", vnic_version, nsp_version,
    -
    - ## drivers/ssb/pcihost_wrapper.c ##
    -@@ drivers/ssb/pcihost_wrapper.c: static int ssb_pcihost_probe(struct pci_dev *dev,
    - 	err = pci_enable_device(dev);
    - 	if (err)
    - 		goto err_kfree_ssb;
    --	name = dev_name(&dev->dev);
    --	if (dev->driver && dev->driver->name)
    --		name = dev->driver->name;
    -+
    -+	name = dev_driver_string(&dev->dev);
    -+	if (*name == '\0')
    -+		name = dev_name(&dev->dev);
    -+
    - 	err = pci_request_regions(dev, name);
    - 	if (err)
    - 		goto err_pci_disable;
 5:  574b743327b8 =  8:  1e58019165b9 scsi: message: fusion: Remove unused parameter of mpt_pci driver's probe()
 6:  674c6efd3dab !  9:  dea72a470141 crypto: qat - simplify adf_enable_aer()
    @@ drivers/crypto/qat/qat_4xxx/adf_drv.c: static struct pci_driver adf_driver = {
      	.probe = adf_probe,
      	.remove = adf_remove,
      	.sriov_configure = adf_sriov_configure,
    -+	.err_handler = adf_err_handler,
    ++	.err_handler = &adf_err_handler,
      };
      
      module_pci_driver(adf_driver);
    @@ drivers/crypto/qat/qat_c3xxx/adf_drv.c: static struct pci_driver adf_driver = {
      	.probe = adf_probe,
      	.remove = adf_remove,
      	.sriov_configure = adf_sriov_configure,
    -+	.err_handler = adf_err_handler,
    ++	.err_handler = &adf_err_handler,
      };
      
      static void adf_cleanup_pci_dev(struct adf_accel_dev *accel_dev)
    @@ drivers/crypto/qat/qat_c62x/adf_drv.c: static struct pci_driver adf_driver = {
      	.probe = adf_probe,
      	.remove = adf_remove,
      	.sriov_configure = adf_sriov_configure,
    -+	.err_handler = adf_err_handler,
    ++	.err_handler = &adf_err_handler,
      };
      
      static void adf_cleanup_pci_dev(struct adf_accel_dev *accel_dev)
    @@ drivers/crypto/qat/qat_common/adf_common_drv.h: void adf_ae_fw_release(struct ad
      int adf_ae_stop(struct adf_accel_dev *accel_dev);
      
     -int adf_enable_aer(struct adf_accel_dev *accel_dev);
    ++extern const struct pci_error_handlers adf_err_handler;
     +void adf_enable_aer(struct adf_accel_dev *accel_dev);
      void adf_disable_aer(struct adf_accel_dev *accel_dev);
      void adf_reset_sbr(struct adf_accel_dev *accel_dev);
    @@ drivers/crypto/qat/qat_dh895xcc/adf_drv.c: static struct pci_driver adf_driver =
      	.probe = adf_probe,
      	.remove = adf_remove,
      	.sriov_configure = adf_sriov_configure,
    -+	.err_handler = adf_err_handler,
    ++	.err_handler = &adf_err_handler,
      };
      
      static void adf_cleanup_pci_dev(struct adf_accel_dev *accel_dev)
 7:  0e022deb0f75 = 10:  b4165dda38ea PCI: Replace pci_dev::driver usage by pci_dev::dev.driver
 8:  edd9d24df02a = 11:  d93a138bd7ab PCI: Drop duplicated tracking of a pci_dev's bound driver

base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
-- 
2.30.2

