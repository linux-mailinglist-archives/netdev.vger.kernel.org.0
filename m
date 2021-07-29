Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B978E3DADCF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhG2Ujj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhG2Ujf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 16:39:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEAEC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 13:39:31 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m9Cmx-0000FL-Gj; Thu, 29 Jul 2021 22:37:55 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m9Cmm-0003dI-P9; Thu, 29 Jul 2021 22:37:44 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m9Cmm-0004JO-Lr; Thu, 29 Jul 2021 22:37:44 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>, kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Russell Currey <ruscur@russell.cc>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Michael Buesch <m@bues.ch>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        xen-devel@lists.xenproject.org, linux-usb@vger.kernel.org
Subject: [PATCH v1 4/5] PCI: Adapt all code locations to not use struct pci_dev::driver directly
Date:   Thu, 29 Jul 2021 22:37:39 +0200
Message-Id: <20210729203740.1377045-5-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
References: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=9L+xMpEBAe+EMrTNszE9gpsj0FkwASarXVYcMu+YsdI=; m=G3t4EAjyOjy3F8ef7TOQklRyeKO15tgc41ovGVIn+a4=; p=SZP1SyRbrr31KQGoy989zb3WcUmfzy84Rx/2F/dHMUk=; g=5b1eeed154e55475902017b902263456fa929072
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmEDEYEACgkQwfwUeK3K7AmJMgf8D/V rGCXHUN8HfhKFE/zf8yoQF2icy+zfIsa90DgYdFC1luxthMdZtjW4fJmJeVJGIjsQ98rqD8ZZH46M bZdq72GLx2jA3ff4ra7w4Gx1RG2yXazSlQQibJ3zz9GpreECzUwyzOYdKYg+CiW7ewAK68c52vD8x aowtfphlSLTBS6xvPzx41WtcKr+q5CTOC8vMSz4jaCeDuc4DFS1DISa5xJsizRU5ksye6OxrEgM6G R3BmUzVwM6kYLa9/PHJpdTgIn7zW3e5tumHID6Cr3cTDI0vKKPxTp6dXB5lmsrD752rNyWZJTGqSm ODVS8ghei95agH6BgmMF5AB9TN9C9dw==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prepares removing the driver member of struct pci_dev which holds the
same information than struct pci_dev::dev->driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/powerpc/include/asm/ppc-pci.h            |  3 +-
 arch/powerpc/kernel/eeh_driver.c              | 12 ++++---
 arch/x86/events/intel/uncore.c                |  2 +-
 arch/x86/kernel/probe_roms.c                  |  2 +-
 drivers/bcma/host_pci.c                       |  6 ++--
 drivers/crypto/hisilicon/qm.c                 |  2 +-
 drivers/crypto/qat/qat_common/adf_aer.c       |  2 +-
 drivers/message/fusion/mptbase.c              |  4 +--
 drivers/misc/cxl/guest.c                      | 21 +++++------
 drivers/misc/cxl/pci.c                        | 25 +++++++------
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  3 +-
 .../ethernet/marvell/prestera/prestera_pci.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  2 +-
 drivers/pci/iov.c                             | 23 +++++++-----
 drivers/pci/pci-driver.c                      | 28 ++++++++-------
 drivers/pci/pci.c                             | 10 +++---
 drivers/pci/pcie/err.c                        | 35 ++++++++++---------
 drivers/pci/xen-pcifront.c                    |  4 +--
 drivers/ssb/pcihost_wrapper.c                 |  7 ++--
 drivers/usb/host/xhci-pci.c                   |  3 +-
 21 files changed, 113 insertions(+), 85 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-pci.h b/arch/powerpc/include/asm/ppc-pci.h
index 2b9edbf6e929..63938c156c57 100644
--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@ -57,7 +57,8 @@ void eeh_sysfs_remove_device(struct pci_dev *pdev);
 
 static inline const char *eeh_driver_name(struct pci_dev *pdev)
 {
-	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
+	struct pci_driver *pdrv;
+	return (pdev && (pdrv = pci_driver_of_dev(pdev))) ? pdrv->name : "<null>";
 }
 
 #endif /* CONFIG_EEH */
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 3eff6a4888e7..0fc712a8775e 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -104,13 +104,14 @@ static bool eeh_edev_actionable(struct eeh_dev *edev)
  */
 static inline struct pci_driver *eeh_pcid_get(struct pci_dev *pdev)
 {
-	if (!pdev || !pdev->driver)
+	struct pci_driver *pdrv;
+	if (!pdev || !(pdrv = pci_driver_of_dev(pdev)))
 		return NULL;
 
-	if (!try_module_get(pdev->driver->driver.owner))
+	if (!try_module_get(pdrv->driver.owner))
 		return NULL;
 
-	return pdev->driver;
+	return pdrv;
 }
 
 /**
@@ -122,10 +123,11 @@ static inline struct pci_driver *eeh_pcid_get(struct pci_dev *pdev)
  */
 static inline void eeh_pcid_put(struct pci_dev *pdev)
 {
-	if (!pdev || !pdev->driver)
+	struct pci_driver *pdrv;
+	if (!pdev || !(pdrv = pci_driver_of_dev(pdev)))
 		return;
 
-	module_put(pdev->driver->driver.owner);
+	module_put(pdrv->driver.owner);
 }
 
 /**
diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 9bf4dbbc26e2..14eb141b6cf2 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1176,7 +1176,7 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	 * PCI slot and func to indicate the uncore box.
 	 */
 	if (id->driver_data & ~0xffff) {
-		struct pci_driver *pci_drv = pdev->driver;
+		struct pci_driver *pci_drv = pci_driver_of_dev(pdev);
 
 		pmu = uncore_pci_find_dev_pmu(pdev, pci_drv->id_table);
 		if (pmu == NULL)
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 9e1def3744f2..55bfafec9684 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -80,7 +80,7 @@ static struct resource video_rom_resource = {
  */
 static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
 {
-	struct pci_driver *drv = pdev->driver;
+	struct pci_driver *drv = pci_driver_of_dev(pdev);
 	const struct pci_device_id *id;
 
 	if (pdev->vendor == vendor && pdev->device == device)
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 69c10a7b7c61..f9bfae87ebd9 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -161,6 +161,7 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *id)
 {
 	struct bcma_bus *bus;
+	struct pci_driver *pdrv;
 	int err = -ENOMEM;
 	const char *name;
 	u32 val;
@@ -176,8 +177,9 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 		goto err_kfree_bus;
 
 	name = dev_name(&dev->dev);
-	if (dev->driver && dev->driver->name)
-		name = dev->driver->name;
+	pdrv = pci_driver_of_dev(dev);
+	if (pdrv && pdrv->name)
+		name = pdrv->name;
 	err = pci_request_regions(dev, name);
 	if (err)
 		goto err_pci_disable;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 1d67f94a1d56..303cc546f466 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3003,7 +3003,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	};
 	int ret;
 
-	ret = strscpy(interface.name, pdev->driver->name,
+	ret = strscpy(interface.name, pci_driver_of_dev(pdev)->name,
 		      sizeof(interface.name));
 	if (ret < 0)
 		return -ENAMETOOLONG;
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index d2ae293d0df6..162c2b9ef93d 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -185,7 +185,7 @@ static const struct pci_error_handlers adf_err_handler = {
 int adf_enable_aer(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
-	struct pci_driver *pdrv = pdev->driver;
+	struct pci_driver *pdrv = pci_driver_of_dev(pdev);
 
 	pdrv->err_handler = &adf_err_handler;
 	pci_enable_pcie_error_reporting(pdev);
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7f7abc9069f7..181e2927a719 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -838,8 +838,8 @@ mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
 
 	/* call per pci device probe entry point */
 	list_for_each_entry(ioc, &ioc_list, list) {
-		id = ioc->pcidev->driver ?
-		    ioc->pcidev->driver->id_table : NULL;
+		struct pci_driver *pdrv = pci_driver_of_dev(ioc->pcidev);
+		id = pdrv ?  pdrv->id_table : NULL;
 		if (dd_cbfunc->probe)
 			dd_cbfunc->probe(ioc->pcidev, id);
 	 }
diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index 186308f1f8eb..99b969b182b5 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -25,28 +25,29 @@ static void pci_error_handlers(struct cxl_afu *afu,
 		return;
 
 	list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-		if (!afu_dev->driver)
+		struct pci_driver *afu_drv = pci_driver_of_dev(afu_dev);
+		if (!afu_drv)
 			continue;
 
 		switch (bus_error_event) {
 		case CXL_ERROR_DETECTED_EVENT:
 			afu_dev->error_state = state;
 
-			if (afu_dev->driver->err_handler &&
-			    afu_dev->driver->err_handler->error_detected)
-				afu_dev->driver->err_handler->error_detected(afu_dev, state);
+			if (afu_drv->err_handler &&
+			    afu_drv->err_handler->error_detected)
+				afu_drv->err_handler->error_detected(afu_dev, state);
 		break;
 		case CXL_SLOT_RESET_EVENT:
 			afu_dev->error_state = state;
 
-			if (afu_dev->driver->err_handler &&
-			    afu_dev->driver->err_handler->slot_reset)
-				afu_dev->driver->err_handler->slot_reset(afu_dev);
+			if (afu_drv->err_handler &&
+			    afu_drv->err_handler->slot_reset)
+				afu_drv->err_handler->slot_reset(afu_dev);
 		break;
 		case CXL_RESUME_EVENT:
-			if (afu_dev->driver->err_handler &&
-			    afu_dev->driver->err_handler->resume)
-				afu_dev->driver->err_handler->resume(afu_dev);
+			if (afu_drv->err_handler &&
+			    afu_drv->err_handler->resume)
+				afu_drv->err_handler->resume(afu_dev);
 		break;
 		}
 	}
diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 2ba899f5659f..1cf39275029f 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -1805,13 +1805,14 @@ static pci_ers_result_t cxl_vphb_error_detected(struct cxl_afu *afu,
 		return result;
 
 	list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-		if (!afu_dev->driver)
+		struct pci_driver *afu_drv = pci_driver_of_dev(afu_dev);
+		if (!afu_drv)
 			continue;
 
 		afu_dev->error_state = state;
 
-		if (afu_dev->driver->err_handler)
-			afu_result = afu_dev->driver->err_handler->error_detected(afu_dev,
+		if (afu_drv->err_handler)
+			afu_result = afu_drv->err_handler->error_detected(afu_dev,
 										  state);
 		/* Disconnect trumps all, NONE trumps NEED_RESET */
 		if (afu_result == PCI_ERS_RESULT_DISCONNECT)
@@ -2003,6 +2004,8 @@ static pci_ers_result_t cxl_pci_slot_reset(struct pci_dev *pdev)
 			continue;
 
 		list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
+			struct pci_driver *afu_drv;
+
 			/* Reset the device context.
 			 * TODO: make this less disruptive
 			 */
@@ -2028,12 +2031,13 @@ static pci_ers_result_t cxl_pci_slot_reset(struct pci_dev *pdev)
 			 * shouldn't start new work until we call
 			 * their resume function.
 			 */
-			if (!afu_dev->driver)
+			afu_drv = pci_driver_of_dev(afu_dev);
+			if (!afu_drv)
 				continue;
 
-			if (afu_dev->driver->err_handler &&
-			    afu_dev->driver->err_handler->slot_reset)
-				afu_result = afu_dev->driver->err_handler->slot_reset(afu_dev);
+			if (afu_drv->err_handler &&
+			    afu_drv->err_handler->slot_reset)
+				afu_result = afu_drv->err_handler->slot_reset(afu_dev);
 
 			if (afu_result == PCI_ERS_RESULT_DISCONNECT)
 				result = PCI_ERS_RESULT_DISCONNECT;
@@ -2074,9 +2078,10 @@ static void cxl_pci_resume(struct pci_dev *pdev)
 			continue;
 
 		list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-			if (afu_dev->driver && afu_dev->driver->err_handler &&
-			    afu_dev->driver->err_handler->resume)
-				afu_dev->driver->err_handler->resume(afu_dev);
+			struct pci_driver *afu_drv = pci_driver_of_dev(afu_dev);
+			if (afu_drv && afu_drv->err_handler &&
+			    afu_drv->err_handler->resume)
+				afu_drv->err_handler->resume(afu_dev);
 		}
 	}
 	spin_unlock(&adapter->afu_list_lock);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82061ab6930f..833d35e9ed4a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -593,8 +593,7 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 		return;
 	}
 
-	strncpy(drvinfo->driver, h->pdev->driver->name,
-		sizeof(drvinfo->driver));
+	strncpy(drvinfo->driver, pci_driver_of_dev(h->pdev)->name, sizeof(drvinfo->driver));
 	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';
 
 	strncpy(drvinfo->bus_info, pci_name(h->pdev),
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..180999c2165e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -720,7 +720,7 @@ static int prestera_fw_load(struct prestera_fw *fw)
 static int prestera_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	const char *driver_name = pdev->driver->name;
+	const char *driver_name = pci_driver_of_dev(pdev)->name;
 	struct prestera_fw *fw;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 13b0259f7ea6..d3c1ca840fa7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1876,7 +1876,7 @@ static void mlxsw_pci_cmd_fini(struct mlxsw_pci *mlxsw_pci)
 
 static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	const char *driver_name = pdev->driver->name;
+	const char *driver_name = pci_driver_of_dev(pdev)->name;
 	struct mlxsw_pci *mlxsw_pci;
 	int err;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1b482446536d..5c25f6af3f62 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
 {
 	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
 
-	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->driver, pci_driver_of_dev(pdev)->name, sizeof(drvinfo->driver));
 	nfp_net_get_nspinfo(app, nsp_version);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%s %s %s %s", vnic_version, nsp_version,
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..7c6f0c466df8 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -164,13 +164,14 @@ static ssize_t sriov_vf_total_msix_show(struct device *dev,
 					char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_driver *pdrv = pci_driver_of_dev(pdev);
 	u32 vf_total_msix = 0;
 
 	device_lock(dev);
-	if (!pdev->driver || !pdev->driver->sriov_get_vf_total_msix)
+	if (!pdrv || !pdrv->sriov_get_vf_total_msix)
 		goto unlock;
 
-	vf_total_msix = pdev->driver->sriov_get_vf_total_msix(pdev);
+	vf_total_msix = pdrv->sriov_get_vf_total_msix(pdev);
 unlock:
 	device_unlock(dev);
 	return sysfs_emit(buf, "%u\n", vf_total_msix);
@@ -183,6 +184,7 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 {
 	struct pci_dev *vf_dev = to_pci_dev(dev);
 	struct pci_dev *pdev = pci_physfn(vf_dev);
+	struct pci_driver *pdrv;
 	int val, ret;
 
 	ret = kstrtoint(buf, 0, &val);
@@ -193,13 +195,14 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 		return -EINVAL;
 
 	device_lock(&pdev->dev);
-	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
+	pdrv = pci_driver_of_dev(pdev);
+	if (!pdrv || !pdrv->sriov_set_msix_vec_count) {
 		ret = -EOPNOTSUPP;
 		goto err_pdev;
 	}
 
 	device_lock(&vf_dev->dev);
-	if (vf_dev->driver) {
+	if (pci_driver_of_dev(vf_dev)) {
 		/*
 		 * A driver is already attached to this VF and has configured
 		 * itself based on the current MSI-X vector count. Changing
@@ -209,7 +212,7 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 		goto err_dev;
 	}
 
-	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
+	ret = pdrv->sriov_set_msix_vec_count(vf_dev, val);
 
 err_dev:
 	device_unlock(&vf_dev->dev);
@@ -376,6 +379,7 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_driver *pdrv;
 	int ret;
 	u16 num_vfs;
 
@@ -392,14 +396,15 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 		goto exit;
 
 	/* is PF driver loaded */
-	if (!pdev->driver) {
+	pdrv = pci_driver_of_dev(pdev);
+	if (!pdrv) {
 		pci_info(pdev, "no driver bound to device; cannot configure SR-IOV\n");
 		ret = -ENOENT;
 		goto exit;
 	}
 
 	/* is PF driver loaded w/callback */
-	if (!pdev->driver->sriov_configure) {
+	if (!pdrv->sriov_configure) {
 		pci_info(pdev, "driver does not support SR-IOV configuration via sysfs\n");
 		ret = -ENOENT;
 		goto exit;
@@ -407,7 +412,7 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 
 	if (num_vfs == 0) {
 		/* disable VFs */
-		ret = pdev->driver->sriov_configure(pdev, 0);
+		ret = pdrv->sriov_configure(pdev, 0);
 		goto exit;
 	}
 
@@ -419,7 +424,7 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 		goto exit;
 	}
 
-	ret = pdev->driver->sriov_configure(pdev, num_vfs);
+	ret = pdrv->sriov_configure(pdev, num_vfs);
 	if (ret < 0)
 		goto exit;
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 7dff574bb2fa..740d5bf5d411 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -443,7 +443,7 @@ static int pci_device_probe(struct device *dev)
 static int pci_device_remove(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct pci_driver *drv = pci_driver_of_dev(pci_dev);
 
 	if (drv->remove) {
 		pm_runtime_get_sync(dev);
@@ -480,7 +480,7 @@ static int pci_device_remove(struct device *dev)
 static void pci_device_shutdown(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct pci_driver *drv = pci_driver_of_dev(pci_dev);
 
 	pm_runtime_resume(dev);
 
@@ -576,7 +576,7 @@ static int pci_pm_reenable_device(struct pci_dev *pci_dev)
 static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct pci_driver *drv = pci_driver_of_dev(pci_dev);
 
 	if (drv && drv->suspend) {
 		pci_power_t prev = pci_dev->current_state;
@@ -617,7 +617,7 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 static int pci_legacy_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct pci_driver *drv = pci_driver_of_dev(pci_dev);
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
@@ -636,7 +636,7 @@ static void pci_pm_default_suspend(struct pci_dev *pci_dev)
 
 static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
 {
-	struct pci_driver *drv = pci_dev->driver;
+	struct pci_driver *drv = pci_driver_of_dev(pci_dev);
 	bool ret = drv && (drv->suspend || drv->resume);
 
 	/*
@@ -1224,16 +1224,17 @@ static int pci_pm_restore(struct device *dev)
 static int pci_pm_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *pdrv = pci_driver_of_dev(pci_dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	pci_power_t prev = pci_dev->current_state;
 	int error;
 
 	/*
-	 * If pci_dev->driver is not set (unbound), we leave the device in D0,
+	 * If pdrv is not set (unbound), we leave the device in D0,
 	 * but it may go to D3cold when the bridge above it runtime suspends.
 	 * Save its config space in case that happens.
 	 */
-	if (!pci_dev->driver) {
+	if (!pdrv) {
 		pci_save_state(pci_dev);
 		return 0;
 	}
@@ -1279,6 +1280,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 static int pci_pm_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *pdrv = pci_driver_of_dev(pci_dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	pci_power_t prev_state = pci_dev->current_state;
 	int error = 0;
@@ -1290,7 +1292,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 	 */
 	pci_restore_standard_config(pci_dev);
 
-	if (!pci_dev->driver)
+	if (!pdrv)
 		return 0;
 
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
@@ -1310,13 +1312,14 @@ static int pci_pm_runtime_resume(struct device *dev)
 static int pci_pm_runtime_idle(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *pdrv = pci_driver_of_dev(pci_dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	/*
-	 * If pci_dev->driver is not set (unbound), the device should
+	 * If pdrv is not set (unbound), the device should
 	 * always remain in D0 regardless of the runtime PM status
 	 */
-	if (!pci_dev->driver)
+	if (!pdrv)
 		return 0;
 
 	if (!pm)
@@ -1423,8 +1426,9 @@ static struct pci_driver pci_compat_driver = {
  */
 struct pci_driver *pci_dev_driver(const struct pci_dev *dev)
 {
-	if (dev->driver)
-		return dev->driver;
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
+	if (pdrv)
+		return pdrv;
 	else {
 		int i;
 		for (i = 0; i <= PCI_ROM_RESOURCE; i++)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index aacf575c15cf..9565f6c1bd4f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5069,11 +5069,12 @@ EXPORT_SYMBOL_GPL(pci_dev_unlock);
 
 static void pci_dev_save_and_disable(struct pci_dev *dev)
 {
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
 	const struct pci_error_handlers *err_handler =
-			dev->driver ? dev->driver->err_handler : NULL;
+			pdrv ? pdrv->err_handler : NULL;
 
 	/*
-	 * dev->driver->err_handler->reset_prepare() is protected against
+	 * pdrv->err_handler->reset_prepare() is protected against
 	 * races with ->remove() by the device lock, which must be held by
 	 * the caller.
 	 */
@@ -5100,13 +5101,14 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
 
 static void pci_dev_restore(struct pci_dev *dev)
 {
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
 	const struct pci_error_handlers *err_handler =
-			dev->driver ? dev->driver->err_handler : NULL;
+			pdrv ? pdrv->err_handler : NULL;
 
 	pci_restore_state(dev);
 
 	/*
-	 * dev->driver->err_handler->reset_done() is protected against
+	 * err_handler->reset_done() is protected against
 	 * races with ->remove() by the device lock, which must be held by
 	 * the caller.
 	 */
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index b576aa890c76..5b2b7b2972dd 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -51,12 +51,12 @@ static int report_error_detected(struct pci_dev *dev,
 {
 	pci_ers_result_t vote;
 	const struct pci_error_handlers *err_handler;
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
 
 	device_lock(&dev->dev);
 	if (!pci_dev_set_io_state(dev, state) ||
-		!dev->driver ||
-		!dev->driver->err_handler ||
-		!dev->driver->err_handler->error_detected) {
+		!pdrv || !pdrv->err_handler ||
+		!pdrv->err_handler->error_detected) {
 		/*
 		 * If any device in the subtree does not have an error_detected
 		 * callback, PCI_ERS_RESULT_NO_AER_DRIVER prevents subsequent
@@ -70,7 +70,7 @@ static int report_error_detected(struct pci_dev *dev,
 			vote = PCI_ERS_RESULT_NONE;
 		}
 	} else {
-		err_handler = dev->driver->err_handler;
+		err_handler = pdrv->err_handler;
 		vote = err_handler->error_detected(dev, state);
 	}
 	pci_uevent_ers(dev, vote);
@@ -93,14 +93,15 @@ static int report_mmio_enabled(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote, *result = data;
 	const struct pci_error_handlers *err_handler;
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
 
 	device_lock(&dev->dev);
-	if (!dev->driver ||
-		!dev->driver->err_handler ||
-		!dev->driver->err_handler->mmio_enabled)
+	if (!pdrv ||
+		!pdrv->err_handler ||
+		!pdrv->err_handler->mmio_enabled)
 		goto out;
 
-	err_handler = dev->driver->err_handler;
+	err_handler = pdrv->err_handler;
 	vote = err_handler->mmio_enabled(dev);
 	*result = merge_result(*result, vote);
 out:
@@ -112,14 +113,15 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote, *result = data;
 	const struct pci_error_handlers *err_handler;
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
 
 	device_lock(&dev->dev);
-	if (!dev->driver ||
-		!dev->driver->err_handler ||
-		!dev->driver->err_handler->slot_reset)
+	if (!pdrv ||
+		!pdrv->err_handler ||
+		!pdrv->err_handler->slot_reset)
 		goto out;
 
-	err_handler = dev->driver->err_handler;
+	err_handler = pdrv->err_handler;
 	vote = err_handler->slot_reset(dev);
 	*result = merge_result(*result, vote);
 out:
@@ -130,15 +132,16 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
 static int report_resume(struct pci_dev *dev, void *data)
 {
 	const struct pci_error_handlers *err_handler;
+	struct pci_driver *pdrv = pci_driver_of_dev(dev);
 
 	device_lock(&dev->dev);
 	if (!pci_dev_set_io_state(dev, pci_channel_io_normal) ||
-		!dev->driver ||
-		!dev->driver->err_handler ||
-		!dev->driver->err_handler->resume)
+		!pdrv ||
+		!pdrv->err_handler ||
+		!pdrv->err_handler->resume)
 		goto out;
 
-	err_handler = dev->driver->err_handler;
+	err_handler = pdrv->err_handler;
 	err_handler->resume(dev);
 out:
 	pci_uevent_ers(dev, PCI_ERS_RESULT_RECOVERED);
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index b7a8f3a1921f..c80c57371dd8 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -599,12 +599,12 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	result = PCI_ERS_RESULT_NONE;
 
 	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
-	if (!pcidev || !pcidev->driver) {
+	pdrv = pci_driver_of_dev(pcidev);
+	if (!pcidev || !pdrv) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
 		pci_dev_put(pcidev);
 		return result;
 	}
-	pdrv = pcidev->driver;
 
 	if (pdrv) {
 		if (pdrv->err_handler && pdrv->err_handler->error_detected) {
diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
index 410215c16920..229329b9e51c 100644
--- a/drivers/ssb/pcihost_wrapper.c
+++ b/drivers/ssb/pcihost_wrapper.c
@@ -68,6 +68,7 @@ static int ssb_pcihost_probe(struct pci_dev *dev,
 			     const struct pci_device_id *id)
 {
 	struct ssb_bus *ssb;
+	struct pci_driver *pdrv;
 	int err = -ENOMEM;
 	const char *name;
 	u32 val;
@@ -79,8 +80,10 @@ static int ssb_pcihost_probe(struct pci_dev *dev,
 	if (err)
 		goto err_kfree_ssb;
 	name = dev_name(&dev->dev);
-	if (dev->driver && dev->driver->name)
-		name = dev->driver->name;
+	
+	pdrv = pci_driver_of_dev(dev);
+	if (pdrv && pdrv->name)
+		name = pdrv->name;
 	err = pci_request_regions(dev, name);
 	if (err)
 		goto err_pci_disable;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18c2bbddf080..d8a6ef602a46 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -100,10 +100,11 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
 static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 {
 	struct pci_dev                  *pdev = to_pci_dev(dev);
+	struct pci_driver               *pdrv = pci_driver_of_dev(pdev);
 	struct xhci_driver_data         *driver_data;
 	const struct pci_device_id      *id;
 
-	id = pci_match_id(pdev->driver->id_table, pdev);
+	id = pci_match_id(pdrv->id_table, pdev);
 
 	if (id && id->driver_data) {
 		driver_data = (struct xhci_driver_data *)id->driver_data;
-- 
2.30.2

