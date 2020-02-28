Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E511174223
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgB1WmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:42:18 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46018 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgB1WmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:42:18 -0500
Received: by mail-yw1-f67.google.com with SMTP id d206so4890163ywa.12
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ztByHnzYUMZdmRwzBHllgxXTQ466kpKswoRroUwNrEQ=;
        b=iqg9O/6HmZIalsqkZUbZvforVThMs3gHKiIkDBHuHebbmox9gE8MNMOaIXG76IHcRO
         sj2yQUbM/noNcUJWhHncWqS4KOkRByjUE4j6KVYuf6ONtQ/DYv5xAzNoHtudAeypgYua
         wcZAlKdZfk6Et0auvveoYT6IGorGRro9Ou5opoUplkGrHFplRS0SAn+2p6gyeE8Z33Rq
         k1FsOLzyTeRQ+t9LYLhJ/mRNnZfxagJVqwaB80H30t+caiN55miRBp4N6Wvk/BmnyskI
         MVxazya5U21cDTXmd422VRNSPpb0dTnByBm7rc3VJcQEk5+WTs1CEzz6Boj9qGxUk7ib
         2Ohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztByHnzYUMZdmRwzBHllgxXTQ466kpKswoRroUwNrEQ=;
        b=pC4NyEywfKmOUlg0Gm2GMKjKMwCHuOhCdweuO5YkTUV4fIOdKdc8/6eSGFYDDhioMU
         UCfjKu50Hb3rOya3xfoUEaG1Sv8E3xT0SK6ISNpHcOVi2k3S3BQgV0pW7f1Bk19v+35F
         /S+nTllvm1k/+BE1OHNXqCd8Mle4J1TB8FsVALs+NXF7voXT76G5MAbonXDBSHULk0PH
         QHVNO8yn5IjUOgOz35prJej7AN62ycudq1QUDW2cb+x86wIwr5d6dvKtzRfGz8QOvVBd
         IZJVMA5xHMXZvBGvGefFuHiqN+6MFmayZ+Rjg2f+lY3ltW/etRikRj6w3iu4txGQTLvx
         cuhg==
X-Gm-Message-State: APjAAAUKncpYimImCOAYrCdLo+WVOSrW6MJZeULTWBO6gNdl+b5VZc1o
        skY3OLuEeYl+7FTIAEs8k5ktPw==
X-Google-Smtp-Source: APXvYqyjkQjiZEkxPrmpS3By46PGNUa4/DLZ8t9/E/CzVNqzp7fhh2EdQvh/Bgu6UvIjsWqqjdUe8w==
X-Received: by 2002:a5b:106:: with SMTP id 6mr6283072ybx.83.1582929735566;
        Fri, 28 Feb 2020 14:42:15 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d188sm4637830ywe.50.2020.02.28.14.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:42:15 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/17] soc: qcom: ipa: main code
Date:   Fri, 28 Feb 2020 16:41:50 -0600
Message-Id: <20200228224204.17746-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228224204.17746-1-elder@linaro.org>
References: <20200228224204.17746-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch includes three source files that represent some basic "main
program" code for the IPA driver.  They are:
  - "ipa.h" defines the top-level IPA structure which represents an IPA
     device throughout the code.
  - "ipa_main.c" contains the platform driver probe function, along with
    some general code used during initialization.
  - "ipa_reg.h" defines the offsets of the 32-bit registers used for the
    IPA device, along with masks that define the position and width of
    fields within these registers.
  - "version.h" defines some symbolic IPA version numbers.

Each file includes some documentation that provides a little more
overview of how the code is organized and used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h         | 148 ++++++
 drivers/net/ipa/ipa_main.c    | 954 ++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_reg.c     |  38 ++
 drivers/net/ipa/ipa_reg.h     | 476 +++++++++++++++++
 drivers/net/ipa/ipa_version.h |  23 +
 5 files changed, 1639 insertions(+)
 create mode 100644 drivers/net/ipa/ipa.h
 create mode 100644 drivers/net/ipa/ipa_main.c
 create mode 100644 drivers/net/ipa/ipa_reg.c
 create mode 100644 drivers/net/ipa/ipa_reg.h
 create mode 100644 drivers/net/ipa/ipa_version.h

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
new file mode 100644
index 000000000000..23fb29889e5a
--- /dev/null
+++ b/drivers/net/ipa/ipa.h
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#ifndef _IPA_H_
+#define _IPA_H_
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/notifier.h>
+#include <linux/pm_wakeup.h>
+
+#include "ipa_version.h"
+#include "gsi.h"
+#include "ipa_mem.h"
+#include "ipa_qmi.h"
+#include "ipa_endpoint.h"
+#include "ipa_interrupt.h"
+
+struct clk;
+struct icc_path;
+struct net_device;
+struct platform_device;
+
+struct ipa_clock;
+struct ipa_smp2p;
+struct ipa_interrupt;
+
+/**
+ * struct ipa - IPA information
+ * @gsi:		Embedded GSI structure
+ * @version:		IPA hardware version
+ * @pdev:		Platform device
+ * @modem_rproc:	Remoteproc handle for modem subsystem
+ * @smp2p:		SMP2P information
+ * @clock:		IPA clocking information
+ * @suspend_ref:	Whether clock reference preventing suspend taken
+ * @table_addr:		DMA address of filter/route table content
+ * @table_virt:		Virtual address of filter/route table content
+ * @interrupt:		IPA Interrupt information
+ * @uc_loaded:		true after microcontroller has reported it's ready
+ * @reg_addr:		DMA address used for IPA register access
+ * @reg_virt:		Virtual address used for IPA register access
+ * @mem_addr:		DMA address of IPA-local memory space
+ * @mem_virt:		Virtual address of IPA-local memory space
+ * @mem_offset:		Offset from @mem_virt used for access to IPA memory
+ * @mem_size:		Total size (bytes) of memory at @mem_virt
+ * @mem:		Array of IPA-local memory region descriptors
+ * @zero_addr:		DMA address of preallocated zero-filled memory
+ * @zero_virt:		Virtual address of preallocated zero-filled memory
+ * @zero_size:		Size (bytes) of preallocated zero-filled memory
+ * @wakeup_source:	Wakeup source information
+ * @available:		Bit mask indicating endpoints hardware supports
+ * @filter_map:		Bit mask indicating endpoints that support filtering
+ * @initialized:	Bit mask indicating endpoints initialized
+ * @set_up:		Bit mask indicating endpoints set up
+ * @enabled:		Bit mask indicating endpoints enabled
+ * @endpoint:		Array of endpoint information
+ * @channel_map:	Mapping of GSI channel to IPA endpoint
+ * @name_map:		Mapping of IPA endpoint name to IPA endpoint
+ * @setup_complete:	Flag indicating whether setup stage has completed
+ * @modem_state:	State of modem (stopped, running)
+ * @modem_netdev:	Network device structure used for modem
+ * @qmi:		QMI information
+ */
+struct ipa {
+	struct gsi gsi;
+	enum ipa_version version;
+	struct platform_device *pdev;
+	struct rproc *modem_rproc;
+	struct ipa_smp2p *smp2p;
+	struct ipa_clock *clock;
+	atomic_t suspend_ref;
+
+	dma_addr_t table_addr;
+	__le64 *table_virt;
+
+	struct ipa_interrupt *interrupt;
+	bool uc_loaded;
+
+	dma_addr_t reg_addr;
+	void __iomem *reg_virt;
+
+	dma_addr_t mem_addr;
+	void *mem_virt;
+	u32 mem_offset;
+	u32 mem_size;
+	const struct ipa_mem *mem;
+
+	dma_addr_t zero_addr;
+	void *zero_virt;
+	size_t zero_size;
+
+	struct wakeup_source *wakeup_source;
+
+	/* Bit masks indicating endpoint state */
+	u32 available;		/* supported by hardware */
+	u32 filter_map;
+	u32 initialized;
+	u32 set_up;
+	u32 enabled;
+
+	struct ipa_endpoint endpoint[IPA_ENDPOINT_MAX];
+	struct ipa_endpoint *channel_map[GSI_CHANNEL_COUNT_MAX];
+	struct ipa_endpoint *name_map[IPA_ENDPOINT_COUNT];
+
+	bool setup_complete;
+
+	atomic_t modem_state;		/* enum ipa_modem_state */
+	struct net_device *modem_netdev;
+	struct ipa_qmi qmi;
+};
+
+/**
+ * ipa_setup() - Perform IPA setup
+ * @ipa:		IPA pointer
+ *
+ * IPA initialization is broken into stages:  init; config; and setup.
+ * (These have inverses exit, deconfig, and teardown.)
+ *
+ * Activities performed at the init stage can be done without requiring
+ * any access to IPA hardware.  Activities performed at the config stage
+ * require the IPA clock to be running, because they involve access
+ * to IPA registers.  The setup stage is performed only after the GSI
+ * hardware is ready (more on this below).  The setup stage allows
+ * the AP to perform more complex initialization by issuing "immediate
+ * commands" using a special interface to the IPA.
+ *
+ * This function, @ipa_setup(), starts the setup stage.
+ *
+ * In order for the GSI hardware to be functional it needs firmware to be
+ * loaded (in addition to some other low-level initialization).  This early
+ * GSI initialization can be done either by Trust Zone on the AP or by the
+ * modem.
+ *
+ * If it's done by Trust Zone, the AP loads the GSI firmware and supplies
+ * it to Trust Zone to verify and install.  When this completes, if
+ * verification was successful, the GSI layer is ready and ipa_setup()
+ * implements the setup phase of initialization.
+ *
+ * If the modem performs early GSI initialization, the AP needs to know
+ * when this has occurred.  An SMP2P interrupt is used for this purpose,
+ * and receipt of that interrupt triggers the call to ipa_setup().
+ */
+int ipa_setup(struct ipa *ipa);
+
+#endif /* _IPA_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
new file mode 100644
index 000000000000..d6e7f257e99d
--- /dev/null
+++ b/drivers/net/ipa/ipa_main.c
@@ -0,0 +1,954 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/bug.h>
+#include <linux/io.h>
+#include <linux/firmware.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/remoteproc.h>
+#include <linux/qcom_scm.h>
+#include <linux/soc/qcom/mdt_loader.h>
+
+#include "ipa.h"
+#include "ipa_clock.h"
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_cmd.h"
+#include "ipa_reg.h"
+#include "ipa_mem.h"
+#include "ipa_table.h"
+#include "ipa_modem.h"
+#include "ipa_uc.h"
+#include "ipa_interrupt.h"
+#include "gsi_trans.h"
+
+/**
+ * DOC: The IP Accelerator
+ *
+ * This driver supports the Qualcomm IP Accelerator (IPA), which is a
+ * networking component found in many Qualcomm SoCs.  The IPA is connected
+ * to the application processor (AP), but is also connected (and partially
+ * controlled by) other "execution environments" (EEs), such as a modem.
+ *
+ * The IPA is the conduit between the AP and the modem that carries network
+ * traffic.  This driver presents a network interface representing the
+ * connection of the modem to external (e.g. LTE) networks.
+ *
+ * The IPA provides protocol checksum calculation, offloading this work
+ * from the AP.  The IPA offers additional functionality, including routing,
+ * filtering, and NAT support, but that more advanced functionality is not
+ * currently supported.  Despite that, some resources--including routing
+ * tables and filter tables--are defined in this driver because they must
+ * be initialized even when the advanced hardware features are not used.
+ *
+ * There are two distinct layers that implement the IPA hardware, and this
+ * is reflected in the organization of the driver.  The generic software
+ * interface (GSI) is an integral component of the IPA, providing a
+ * well-defined communication layer between the AP subsystem and the IPA
+ * core.  The GSI implements a set of "channels" used for communication
+ * between the AP and the IPA.
+ *
+ * The IPA layer uses GSI channels to implement its "endpoints".  And while
+ * a GSI channel carries data between the AP and the IPA, a pair of IPA
+ * endpoints is used to carry traffic between two EEs.  Specifically, the main
+ * modem network interface is implemented by two pairs of endpoints:  a TX
+ * endpoint on the AP coupled with an RX endpoint on the modem; and another
+ * RX endpoint on the AP receiving data from a TX endpoint on the modem.
+ */
+
+/* The name of the GSI firmware file relative to /lib/firmware */
+#define IPA_FWS_PATH		"ipa_fws.mdt"
+#define IPA_PAS_ID		15
+
+/**
+ * ipa_suspend_handler() - Handle the suspend IPA interrupt
+ * @ipa:	IPA pointer
+ * @irq_id:	IPA interrupt type (unused)
+ *
+ * When in suspended state, the IPA can trigger a resume by sending a SUSPEND
+ * IPA interrupt.
+ */
+static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
+{
+	/* Take a a single clock reference to prevent suspend.  All
+	 * endpoints will be resumed as a result.  This reference will
+	 * be dropped when we get a power management suspend request.
+	 */
+	if (!atomic_xchg(&ipa->suspend_ref, 1))
+		ipa_clock_get(ipa);
+
+	/* Acknowledge/clear the suspend interrupt on all endpoints */
+	ipa_interrupt_suspend_clear_all(ipa->interrupt);
+}
+
+/**
+ * ipa_setup() - Set up IPA hardware
+ * @ipa:	IPA pointer
+ *
+ * Perform initialization that requires issuing immediate commands on
+ * the command TX endpoint.  If the modem is doing GSI firmware load
+ * and initialization, this function will be called when an SMP2P
+ * interrupt has been signaled by the modem.  Otherwise it will be
+ * called from ipa_probe() after GSI firmware has been successfully
+ * loaded, authenticated, and started by Trust Zone.
+ */
+int ipa_setup(struct ipa *ipa)
+{
+	struct ipa_endpoint *exception_endpoint;
+	struct ipa_endpoint *command_endpoint;
+	int ret;
+
+	/* IPA v4.0 and above don't use the doorbell engine. */
+	ret = gsi_setup(&ipa->gsi, ipa->version == IPA_VERSION_3_5_1);
+	if (ret)
+		return ret;
+
+	ipa->interrupt = ipa_interrupt_setup(ipa);
+	if (IS_ERR(ipa->interrupt)) {
+		ret = PTR_ERR(ipa->interrupt);
+		goto err_gsi_teardown;
+	}
+	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
+			  ipa_suspend_handler);
+
+	ipa_uc_setup(ipa);
+
+	ipa_endpoint_setup(ipa);
+
+	/* We need to use the AP command TX endpoint to perform other
+	 * initialization, so we enable first.
+	 */
+	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
+	ret = ipa_endpoint_enable_one(command_endpoint);
+	if (ret)
+		goto err_endpoint_teardown;
+
+	ret = ipa_mem_setup(ipa);
+	if (ret)
+		goto err_command_disable;
+
+	ret = ipa_table_setup(ipa);
+	if (ret)
+		goto err_mem_teardown;
+
+	/* Enable the exception handling endpoint, and tell the hardware
+	 * to use it by default.
+	 */
+	exception_endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
+	ret = ipa_endpoint_enable_one(exception_endpoint);
+	if (ret)
+		goto err_table_teardown;
+
+	ipa_endpoint_default_route_set(ipa, exception_endpoint->endpoint_id);
+
+	/* We're all set.  Now prepare for communication with the modem */
+	ret = ipa_modem_setup(ipa);
+	if (ret)
+		goto err_default_route_clear;
+
+	ipa->setup_complete = true;
+
+	dev_info(&ipa->pdev->dev, "IPA driver setup completed successfully\n");
+
+	return 0;
+
+err_default_route_clear:
+	ipa_endpoint_default_route_clear(ipa);
+	ipa_endpoint_disable_one(exception_endpoint);
+err_table_teardown:
+	ipa_table_teardown(ipa);
+err_mem_teardown:
+	ipa_mem_teardown(ipa);
+err_command_disable:
+	ipa_endpoint_disable_one(command_endpoint);
+err_endpoint_teardown:
+	ipa_endpoint_teardown(ipa);
+	ipa_uc_teardown(ipa);
+	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
+	ipa_interrupt_teardown(ipa->interrupt);
+err_gsi_teardown:
+	gsi_teardown(&ipa->gsi);
+
+	return ret;
+}
+
+/**
+ * ipa_teardown() - Inverse of ipa_setup()
+ * @ipa:	IPA pointer
+ */
+static void ipa_teardown(struct ipa *ipa)
+{
+	struct ipa_endpoint *exception_endpoint;
+	struct ipa_endpoint *command_endpoint;
+
+	ipa_modem_teardown(ipa);
+	ipa_endpoint_default_route_clear(ipa);
+	exception_endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
+	ipa_endpoint_disable_one(exception_endpoint);
+	ipa_table_teardown(ipa);
+	ipa_mem_teardown(ipa);
+	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
+	ipa_endpoint_disable_one(command_endpoint);
+	ipa_endpoint_teardown(ipa);
+	ipa_uc_teardown(ipa);
+	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
+	ipa_interrupt_teardown(ipa->interrupt);
+	gsi_teardown(&ipa->gsi);
+}
+
+/* Configure QMB Core Master Port selection */
+static void ipa_hardware_config_comp(struct ipa *ipa)
+{
+	u32 val;
+
+	/* Nothing to configure for IPA v3.5.1 */
+	if (ipa->version == IPA_VERSION_3_5_1)
+		return;
+
+	val = ioread32(ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
+
+	if (ipa->version == IPA_VERSION_4_0) {
+		val &= ~IPA_QMB_SELECT_CONS_EN_FMASK;
+		val &= ~IPA_QMB_SELECT_PROD_EN_FMASK;
+		val &= ~IPA_QMB_SELECT_GLOBAL_EN_FMASK;
+	} else  {
+		val |= GSI_MULTI_AXI_MASTERS_DIS_FMASK;
+	}
+
+	val |= GSI_MULTI_INORDER_RD_DIS_FMASK;
+	val |= GSI_MULTI_INORDER_WR_DIS_FMASK;
+
+	iowrite32(val, ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
+}
+
+/* Configure DDR and PCIe max read/write QSB values */
+static void ipa_hardware_config_qsb(struct ipa *ipa)
+{
+	u32 val;
+
+	/* QMB_0 represents DDR; QMB_1 represents PCIe (not present in 4.2) */
+	val = u32_encode_bits(8, GEN_QMB_0_MAX_WRITES_FMASK);
+	if (ipa->version == IPA_VERSION_4_2)
+		val |= u32_encode_bits(0, GEN_QMB_1_MAX_WRITES_FMASK);
+	else
+		val |= u32_encode_bits(4, GEN_QMB_1_MAX_WRITES_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_WRITES_OFFSET);
+
+	if (ipa->version == IPA_VERSION_3_5_1) {
+		val = u32_encode_bits(8, GEN_QMB_0_MAX_READS_FMASK);
+		val |= u32_encode_bits(12, GEN_QMB_1_MAX_READS_FMASK);
+	} else {
+		val = u32_encode_bits(12, GEN_QMB_0_MAX_READS_FMASK);
+		if (ipa->version == IPA_VERSION_4_2)
+			val |= u32_encode_bits(0, GEN_QMB_1_MAX_READS_FMASK);
+		else
+			val |= u32_encode_bits(12, GEN_QMB_1_MAX_READS_FMASK);
+		/* GEN_QMB_0_MAX_READS_BEATS is 0 */
+		/* GEN_QMB_1_MAX_READS_BEATS is 0 */
+	}
+	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_READS_OFFSET);
+}
+
+static void ipa_idle_indication_cfg(struct ipa *ipa,
+				    u32 enter_idle_debounce_thresh,
+				    bool const_non_idle_enable)
+{
+	u32 offset;
+	u32 val;
+
+	val = u32_encode_bits(enter_idle_debounce_thresh,
+			      ENTER_IDLE_DEBOUNCE_THRESH_FMASK);
+	if (const_non_idle_enable)
+		val |= CONST_NON_IDLE_ENABLE_FMASK;
+
+	offset = ipa_reg_idle_indication_cfg_offset(ipa->version);
+	iowrite32(val, ipa->reg_virt + offset);
+}
+
+/**
+ * ipa_hardware_dcd_config() - Enable dynamic clock division on IPA
+ *
+ * Configures when the IPA signals it is idle to the global clock
+ * controller, which can respond by scalling down the clock to
+ * save power.
+ */
+static void ipa_hardware_dcd_config(struct ipa *ipa)
+{
+	/* Recommended values for IPA 3.5 according to IPA HPG */
+	ipa_idle_indication_cfg(ipa, 256, false);
+}
+
+static void ipa_hardware_dcd_deconfig(struct ipa *ipa)
+{
+	/* Power-on reset values */
+	ipa_idle_indication_cfg(ipa, 0, true);
+}
+
+/**
+ * ipa_hardware_config() - Primitive hardware initialization
+ * @ipa:	IPA pointer
+ */
+static void ipa_hardware_config(struct ipa *ipa)
+{
+	u32 granularity;
+	u32 val;
+
+	/* Fill in backward-compatibility register, based on version */
+	val = ipa_reg_bcr_val(ipa->version);
+	iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
+
+	if (ipa->version != IPA_VERSION_3_5_1) {
+		/* Enable open global clocks (hardware workaround) */
+		val = GLOBAL_FMASK;
+		val |= GLOBAL_2X_CLK_FMASK;
+		iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
+
+		/* Disable PA mask to allow HOLB drop (hardware workaround) */
+		val = ioread32(ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+		val &= ~PA_MASK_EN;
+		iowrite32(val, ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+	}
+
+	ipa_hardware_config_comp(ipa);
+
+	/* Configure system bus limits */
+	ipa_hardware_config_qsb(ipa);
+
+	/* Configure aggregation granularity */
+	val = ioread32(ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
+	granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
+	val = u32_encode_bits(granularity, AGGR_GRANULARITY);
+	iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
+
+	/* Disable hashed IPv4 and IPv6 routing and filtering for IPA v4.2 */
+	if (ipa->version == IPA_VERSION_4_2)
+		iowrite32(0, ipa->reg_virt + IPA_REG_FILT_ROUT_HASH_EN_OFFSET);
+
+	/* Enable dynamic clock division */
+	ipa_hardware_dcd_config(ipa);
+}
+
+/**
+ * ipa_hardware_deconfig() - Inverse of ipa_hardware_config()
+ * @ipa:	IPA pointer
+ *
+ * This restores the power-on reset values (even if they aren't different)
+ */
+static void ipa_hardware_deconfig(struct ipa *ipa)
+{
+	/* Mostly we just leave things as we set them. */
+	ipa_hardware_dcd_deconfig(ipa);
+}
+
+#ifdef IPA_VALIDATION
+
+/* # IPA resources used based on version (see IPA_RESOURCE_GROUP_COUNT) */
+static int ipa_resource_group_count(struct ipa *ipa)
+{
+	switch (ipa->version) {
+	case IPA_VERSION_3_5_1:
+		return 3;
+
+	case IPA_VERSION_4_0:
+	case IPA_VERSION_4_1:
+		return 4;
+
+	case IPA_VERSION_4_2:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+static bool ipa_resource_limits_valid(struct ipa *ipa,
+				      const struct ipa_resource_data *data)
+{
+	u32 group_count = ipa_resource_group_count(ipa);
+	u32 i;
+	u32 j;
+
+	if (!group_count)
+		return false;
+
+	/* Return an error if a non-zero resource group limit is specified
+	 * for a resource not supported by hardware.
+	 */
+	for (i = 0; i < data->resource_src_count; i++) {
+		const struct ipa_resource_src *resource;
+
+		resource = &data->resource_src[i];
+		for (j = group_count; j < IPA_RESOURCE_GROUP_COUNT; j++)
+			if (resource->limits[j].min || resource->limits[j].max)
+				return false;
+	}
+
+	for (i = 0; i < data->resource_dst_count; i++) {
+		const struct ipa_resource_dst *resource;
+
+		resource = &data->resource_dst[i];
+		for (j = group_count; j < IPA_RESOURCE_GROUP_COUNT; j++)
+			if (resource->limits[j].min || resource->limits[j].max)
+				return false;
+	}
+
+	return true;
+}
+
+#else /* !IPA_VALIDATION */
+
+static bool ipa_resource_limits_valid(struct ipa *ipa,
+				      const struct ipa_resource_data *data)
+{
+	return true;
+}
+
+#endif /* !IPA_VALIDATION */
+
+static void
+ipa_resource_config_common(struct ipa *ipa, u32 offset,
+			   const struct ipa_resource_limits *xlimits,
+			   const struct ipa_resource_limits *ylimits)
+{
+	u32 val;
+
+	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
+	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
+	val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
+	val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+
+	iowrite32(val, ipa->reg_virt + offset);
+}
+
+static void ipa_resource_config_src_01(struct ipa *ipa,
+				       const struct ipa_resource_src *resource)
+{
+	u32 offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+
+	ipa_resource_config_common(ipa, offset,
+				   &resource->limits[0], &resource->limits[1]);
+}
+
+static void ipa_resource_config_src_23(struct ipa *ipa,
+				       const struct ipa_resource_src *resource)
+{
+	u32 offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+
+	ipa_resource_config_common(ipa, offset,
+				   &resource->limits[2], &resource->limits[3]);
+}
+
+static void ipa_resource_config_dst_01(struct ipa *ipa,
+				       const struct ipa_resource_dst *resource)
+{
+	u32 offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+
+	ipa_resource_config_common(ipa, offset,
+				   &resource->limits[0], &resource->limits[1]);
+}
+
+static void ipa_resource_config_dst_23(struct ipa *ipa,
+				       const struct ipa_resource_dst *resource)
+{
+	u32 offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+
+	ipa_resource_config_common(ipa, offset,
+				   &resource->limits[2], &resource->limits[3]);
+}
+
+static int
+ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
+{
+	u32 i;
+
+	if (!ipa_resource_limits_valid(ipa, data))
+		return -EINVAL;
+
+	for (i = 0; i < data->resource_src_count; i++) {
+		ipa_resource_config_src_01(ipa, &data->resource_src[i]);
+		ipa_resource_config_src_23(ipa, &data->resource_src[i]);
+	}
+
+	for (i = 0; i < data->resource_dst_count; i++) {
+		ipa_resource_config_dst_01(ipa, &data->resource_dst[i]);
+		ipa_resource_config_dst_23(ipa, &data->resource_dst[i]);
+	}
+
+	return 0;
+}
+
+static void ipa_resource_deconfig(struct ipa *ipa)
+{
+	/* Nothing to do */
+}
+
+/**
+ * ipa_config() - Configure IPA hardware
+ * @ipa:	IPA pointer
+ *
+ * Perform initialization requiring IPA clock to be enabled.
+ */
+static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
+{
+	int ret;
+
+	/* Get a clock reference to allow initialization.  This reference
+	 * is held after initialization completes, and won't get dropped
+	 * unless/until a system suspend request arrives.
+	 */
+	atomic_set(&ipa->suspend_ref, 1);
+	ipa_clock_get(ipa);
+
+	ipa_hardware_config(ipa);
+
+	ret = ipa_endpoint_config(ipa);
+	if (ret)
+		goto err_hardware_deconfig;
+
+	ret = ipa_mem_config(ipa);
+	if (ret)
+		goto err_endpoint_deconfig;
+
+	ipa_table_config(ipa);
+
+	/* Assign resource limitation to each group */
+	ret = ipa_resource_config(ipa, data->resource_data);
+	if (ret)
+		goto err_table_deconfig;
+
+	ret = ipa_modem_config(ipa);
+	if (ret)
+		goto err_resource_deconfig;
+
+	return 0;
+
+err_resource_deconfig:
+	ipa_resource_deconfig(ipa);
+err_table_deconfig:
+	ipa_table_deconfig(ipa);
+	ipa_mem_deconfig(ipa);
+err_endpoint_deconfig:
+	ipa_endpoint_deconfig(ipa);
+err_hardware_deconfig:
+	ipa_hardware_deconfig(ipa);
+	ipa_clock_put(ipa);
+	atomic_set(&ipa->suspend_ref, 0);
+
+	return ret;
+}
+
+/**
+ * ipa_deconfig() - Inverse of ipa_config()
+ * @ipa:	IPA pointer
+ */
+static void ipa_deconfig(struct ipa *ipa)
+{
+	ipa_modem_deconfig(ipa);
+	ipa_resource_deconfig(ipa);
+	ipa_table_deconfig(ipa);
+	ipa_mem_deconfig(ipa);
+	ipa_endpoint_deconfig(ipa);
+	ipa_hardware_deconfig(ipa);
+	ipa_clock_put(ipa);
+	atomic_set(&ipa->suspend_ref, 0);
+}
+
+static int ipa_firmware_load(struct device *dev)
+{
+	const struct firmware *fw;
+	struct device_node *node;
+	struct resource res;
+	phys_addr_t phys;
+	ssize_t size;
+	void *virt;
+	int ret;
+
+	node = of_parse_phandle(dev->of_node, "memory-region", 0);
+	if (!node) {
+		dev_err(dev, "DT error getting \"memory-region\" property\n");
+		return -EINVAL;
+	}
+
+	ret = of_address_to_resource(node, 0, &res);
+	if (ret) {
+		dev_err(dev, "error %d getting \"memory-region\" resource\n",
+			ret);
+		return ret;
+	}
+
+	ret = request_firmware(&fw, IPA_FWS_PATH, dev);
+	if (ret) {
+		dev_err(dev, "error %d requesting \"%s\"\n", ret, IPA_FWS_PATH);
+		return ret;
+	}
+
+	phys = res.start;
+	size = (size_t)resource_size(&res);
+	virt = memremap(phys, size, MEMREMAP_WC);
+	if (!virt) {
+		dev_err(dev, "unable to remap firmware memory\n");
+		ret = -ENOMEM;
+		goto out_release_firmware;
+	}
+
+	ret = qcom_mdt_load(dev, fw, IPA_FWS_PATH, IPA_PAS_ID,
+			    virt, phys, size, NULL);
+	if (ret)
+		dev_err(dev, "error %d loading \"%s\"\n", ret, IPA_FWS_PATH);
+	else if ((ret = qcom_scm_pas_auth_and_reset(IPA_PAS_ID)))
+		dev_err(dev, "error %d authenticating \"%s\"\n", ret,
+			IPA_FWS_PATH);
+
+	memunmap(virt);
+out_release_firmware:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static const struct of_device_id ipa_match[] = {
+	{
+		.compatible	= "qcom,sdm845-ipa",
+		.data		= &ipa_data_sdm845,
+	},
+	{
+		.compatible	= "qcom,sc7180-ipa",
+		.data		= &ipa_data_sc7180,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ipa_match);
+
+static phandle of_property_read_phandle(const struct device_node *np,
+					const char *name)
+{
+        struct property *prop;
+        int len = 0;
+
+        prop = of_find_property(np, name, &len);
+        if (!prop || len != sizeof(__be32))
+                return 0;
+
+        return be32_to_cpup(prop->value);
+}
+
+/* Check things that can be validated at build time.  This just
+ * groups these things BUILD_BUG_ON() calls don't clutter the rest
+ * of the code.
+ * */
+static void ipa_validate_build(void)
+{
+#ifdef IPA_VALIDATE
+	/* We assume we're working on 64-bit hardware */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_64BIT));
+
+	/* Code assumes the EE ID for the AP is 0 (zeroed structure field) */
+	BUILD_BUG_ON(GSI_EE_AP != 0);
+
+	/* There's no point if we have no channels or event rings */
+	BUILD_BUG_ON(!GSI_CHANNEL_COUNT_MAX);
+	BUILD_BUG_ON(!GSI_EVT_RING_COUNT_MAX);
+
+	/* GSI hardware design limits */
+	BUILD_BUG_ON(GSI_CHANNEL_COUNT_MAX > 32);
+	BUILD_BUG_ON(GSI_EVT_RING_COUNT_MAX > 31);
+
+	/* The number of TREs in a transaction is limited by the channel's
+	 * TLV FIFO size.  A transaction structure uses 8-bit fields
+	 * to represents the number of TREs it has allocated and used.
+	 */
+	BUILD_BUG_ON(GSI_TLV_MAX > U8_MAX);
+
+	/* Exceeding 128 bytes makes the transaction pool *much* larger */
+	BUILD_BUG_ON(sizeof(struct gsi_trans) > 128);
+
+	/* This is used as a divisor */
+	BUILD_BUG_ON(!IPA_AGGR_GRANULARITY);
+#endif /* IPA_VALIDATE */
+}
+
+/**
+ * ipa_probe() - IPA platform driver probe function
+ * @pdev:	Platform device pointer
+ *
+ * @Return:	0 if successful, or a negative error code (possibly
+ *		EPROBE_DEFER)
+ *
+ * This is the main entry point for the IPA driver.  Initialization proceeds
+ * in several stages:
+ *   - The "init" stage involves activities that can be initialized without
+ *     access to the IPA hardware.
+ *   - The "config" stage requires the IPA clock to be active so IPA registers
+ *     can be accessed, but does not require the use of IPA immediate commands.
+ *   - The "setup" stage uses IPA immediate commands, and so requires the GSI
+ *     layer to be initialized.
+ *
+ * A Boolean Device Tree "modem-init" property determines whether GSI
+ * initialization will be performed by the AP (Trust Zone) or the modem.
+ * If the AP does GSI initialization, the setup phase is entered after
+ * this has completed successfully.  Otherwise the modem initializes
+ * the GSI layer and signals it has finished by sending an SMP2P interrupt
+ * to the AP; this triggers the start if IPA setup.
+ */
+static int ipa_probe(struct platform_device *pdev)
+{
+	struct wakeup_source *wakeup_source;
+	struct device *dev = &pdev->dev;
+	const struct ipa_data *data;
+	struct ipa_clock *clock;
+	struct rproc *rproc;
+	bool modem_alloc;
+	bool modem_init;
+	struct ipa *ipa;
+	phandle phandle;
+	bool prefetch;
+	int ret;
+
+	ipa_validate_build();
+
+	/* If we need Trust Zone, make sure it's available */
+	modem_init = of_property_read_bool(dev->of_node, "modem-init");
+	if (!modem_init)
+		if (!qcom_scm_is_available())
+			return -EPROBE_DEFER;
+
+	/* We rely on remoteproc to tell us about modem state changes */
+	phandle = of_property_read_phandle(dev->of_node, "modem-remoteproc");
+	if (!phandle) {
+		dev_err(dev, "DT missing \"modem-remoteproc\" property\n");
+		return -EINVAL;
+	}
+
+	rproc = rproc_get_by_phandle(phandle);
+	if (!rproc)
+		return -EPROBE_DEFER;
+
+	/* The clock and interconnects might not be ready when we're
+	 * probed, so might return -EPROBE_DEFER.
+	 */
+	clock = ipa_clock_init(dev);
+	if (IS_ERR(clock)) {
+		ret = PTR_ERR(clock);
+		goto err_rproc_put;
+	}
+
+	/* No more EPROBE_DEFER.  Get our configuration data */
+	data = of_device_get_match_data(dev);
+	if (!data) {
+		/* This is really IPA_VALIDATE (should never happen) */
+		dev_err(dev, "matched hardware not supported\n");
+		ret = -ENOTSUPP;
+		goto err_clock_exit;
+	}
+
+	/* Create a wakeup source. */
+	wakeup_source = wakeup_source_register(dev, "ipa");
+	if (!wakeup_source) {
+		/* The most likely reason for failure is memory exhaustion */
+		ret = -ENOMEM;
+		goto err_clock_exit;
+	}
+
+	/* Allocate and initialize the IPA structure */
+	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
+	if (!ipa) {
+		ret = -ENOMEM;
+		goto err_wakeup_source_unregister;
+	}
+
+	ipa->pdev = pdev;
+	dev_set_drvdata(dev, ipa);
+	ipa->modem_rproc = rproc;
+	ipa->clock = clock;
+	atomic_set(&ipa->suspend_ref, 0);
+	ipa->wakeup_source = wakeup_source;
+	ipa->version = data->version;
+
+	ret = ipa_reg_init(ipa);
+	if (ret)
+		goto err_kfree_ipa;
+
+	ret = ipa_mem_init(ipa, data->mem_count, data->mem_data);
+	if (ret)
+		goto err_reg_exit;
+
+	/* GSI v2.0+ (IPA v4.0+) uses prefetch for the command channel */
+	prefetch = ipa->version != IPA_VERSION_3_5_1;
+	/* IPA v4.2 requires the AP to allocate channels for the modem */
+	modem_alloc = ipa->version == IPA_VERSION_4_2;
+
+	ret = gsi_init(&ipa->gsi, pdev, prefetch, data->endpoint_count,
+		       data->endpoint_data, modem_alloc);
+	if (ret)
+		goto err_mem_exit;
+
+	/* Result is a non-zero mask endpoints that support filtering */
+	ipa->filter_map = ipa_endpoint_init(ipa, data->endpoint_count,
+					    data->endpoint_data);
+	if (!ipa->filter_map) {
+		ret = -EINVAL;
+		goto err_gsi_exit;
+	}
+
+	ret = ipa_table_init(ipa);
+	if (ret)
+		goto err_endpoint_exit;
+
+	ret = ipa_modem_init(ipa, modem_init);
+	if (ret)
+		goto err_table_exit;
+
+	ret = ipa_config(ipa, data);
+	if (ret)
+		goto err_modem_exit;
+
+	dev_info(dev, "IPA driver initialized");
+
+	/* If the modem is doing early initialization, it will trigger a
+	 * call to ipa_setup() call when it has finished.  In that case
+	 * we're done here.
+	 */
+	if (modem_init)
+		return 0;
+
+	/* Otherwise we need to load the firmware and have Trust Zone validate
+	 * and install it.  If that succeeds we can proceed with setup.
+	 */
+	ret = ipa_firmware_load(dev);
+	if (ret)
+		goto err_deconfig;
+
+	ret = ipa_setup(ipa);
+	if (ret)
+		goto err_deconfig;
+
+	return 0;
+
+err_deconfig:
+	ipa_deconfig(ipa);
+err_modem_exit:
+	ipa_modem_exit(ipa);
+err_table_exit:
+	ipa_table_exit(ipa);
+err_endpoint_exit:
+	ipa_endpoint_exit(ipa);
+err_gsi_exit:
+	gsi_exit(&ipa->gsi);
+err_mem_exit:
+	ipa_mem_exit(ipa);
+err_reg_exit:
+	ipa_reg_exit(ipa);
+err_kfree_ipa:
+	kfree(ipa);
+err_wakeup_source_unregister:
+	wakeup_source_unregister(wakeup_source);
+err_clock_exit:
+	ipa_clock_exit(clock);
+err_rproc_put:
+	rproc_put(rproc);
+
+	return ret;
+}
+
+static int ipa_remove(struct platform_device *pdev)
+{
+	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
+	struct rproc *rproc = ipa->modem_rproc;
+	struct ipa_clock *clock = ipa->clock;
+	struct wakeup_source *wakeup_source;
+	int ret;
+
+	wakeup_source = ipa->wakeup_source;
+
+	if (ipa->setup_complete) {
+		ret = ipa_modem_stop(ipa);
+		if (ret)
+			return ret;
+
+		ipa_teardown(ipa);
+	}
+
+	ipa_deconfig(ipa);
+	ipa_modem_exit(ipa);
+	ipa_table_exit(ipa);
+	ipa_endpoint_exit(ipa);
+	gsi_exit(&ipa->gsi);
+	ipa_mem_exit(ipa);
+	ipa_reg_exit(ipa);
+	kfree(ipa);
+	wakeup_source_unregister(wakeup_source);
+	ipa_clock_exit(clock);
+	rproc_put(rproc);
+
+	return 0;
+}
+
+/**
+ * ipa_suspend() - Power management system suspend callback
+ * @dev:	IPA device structure
+ *
+ * @Return:	Zero
+ *
+ * Called by the PM framework when a system suspend operation is invoked.
+ */
+static int ipa_suspend(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	ipa_clock_put(ipa);
+	atomic_set(&ipa->suspend_ref, 0);
+
+	return 0;
+}
+
+/**
+ * ipa_resume() - Power management system resume callback
+ * @dev:	IPA device structure
+ *
+ * @Return:	Always returns 0
+ *
+ * Called by the PM framework when a system resume operation is invoked.
+ */
+static int ipa_resume(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	/* This clock reference will keep the IPA out of suspend
+	 * until we get a power management suspend request.
+	 */
+	atomic_set(&ipa->suspend_ref, 1);
+	ipa_clock_get(ipa);
+
+	return 0;
+}
+
+static const struct dev_pm_ops ipa_pm_ops = {
+	.suspend_noirq	= ipa_suspend,
+	.resume_noirq	= ipa_resume,
+};
+
+static struct platform_driver ipa_driver = {
+	.probe	= ipa_probe,
+	.remove	= ipa_remove,
+	.driver	= {
+		.name		= "ipa",
+		.owner		= THIS_MODULE,
+		.pm		= &ipa_pm_ops,
+		.of_match_table	= ipa_match,
+	},
+};
+
+module_platform_driver(ipa_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Qualcomm IP Accelerator device driver");
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
new file mode 100644
index 000000000000..e6147a1cd787
--- /dev/null
+++ b/drivers/net/ipa/ipa_reg.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/io.h>
+
+#include "ipa.h"
+#include "ipa_reg.h"
+
+int ipa_reg_init(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	struct resource *res;
+
+	/* Setup IPA register memory  */
+	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
+					   "ipa-reg");
+	if (!res) {
+		dev_err(dev, "DT error getting \"ipa-reg\" memory property\n");
+		return -ENODEV;
+	}
+
+	ipa->reg_virt = ioremap(res->start, resource_size(res));
+	if (!ipa->reg_virt) {
+		dev_err(dev, "unable to remap \"ipa-reg\" memory\n");
+		return -ENOMEM;
+	}
+	ipa->reg_addr = res->start;
+
+	return 0;
+}
+
+void ipa_reg_exit(struct ipa *ipa)
+{
+	iounmap(ipa->reg_virt);
+}
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
new file mode 100644
index 000000000000..3b8106aa277a
--- /dev/null
+++ b/drivers/net/ipa/ipa_reg.h
@@ -0,0 +1,476 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#ifndef _IPA_REG_H_
+#define _IPA_REG_H_
+
+#include <linux/bitfield.h>
+
+#include "ipa_version.h"
+
+struct ipa;
+
+/**
+ * DOC: IPA Registers
+ *
+ * IPA registers are located within the "ipa-reg" address space defined by
+ * Device Tree.  The offset of each register within that space is specified
+ * by symbols defined below.  The address space is mapped to virtual memory
+ * space in ipa_mem_init().  All IPA registers are 32 bits wide.
+ *
+ * Certain register types are duplicated for a number of instances of
+ * something.  For example, each IPA endpoint has an set of registers
+ * defining its configuration.  The offset to an endpoint's set of registers
+ * is computed based on an "base" offset, plus an endpoint's ID multiplied
+ * and a "stride" value for the register.  For such registers, the offset is
+ * computed by a function-like macro that takes a parameter used in the
+ * computation.
+ *
+ * Some register offsets depend on execution environment.  For these an "ee"
+ * parameter is supplied to the offset macro.  The "ee" value is a member of
+ * the gsi_ee enumerated type.
+ *
+ * The offset of a register dependent on endpoint id is computed by a macro
+ * that is supplied a parameter "ep".  The "ep" value is assumed to be less
+ * than the maximum endpoint value for the current hardware, and that will
+ * not exceed IPA_ENDPOINT_MAX.
+ *
+ * The offset of registers related to filter and route tables is computed
+ * by a macro that is supplied a parameter "er".  The "er" represents an
+ * endpoint ID for filters, or a route ID for routes.  For filters, the
+ * endpoint ID must be less than IPA_ENDPOINT_MAX, but is further restricted
+ * because not all endpoints support filtering.  For routes, the route ID
+ * must be less than IPA_ROUTE_MAX.
+ *
+ * The offset of registers related to resource types is computed by a macro
+ * that is supplied a parameter "rt".  The "rt" represents a resource type,
+ * which is is a member of the ipa_resource_type_src enumerated type for
+ * source endpoint resources or the ipa_resource_type_dst enumerated type
+ * for destination endpoint resources.
+ *
+ * Some registers encode multiple fields within them.  For these, each field
+ * has a symbol below defining a field mask that encodes both the position
+ * and width of the field within its register.
+ *
+ * In some cases, different versions of IPA hardware use different offset or
+ * field mask values.  In such cases an inline_function(ipa) is used rather
+ * than a MACRO to define the offset or field mask to use.
+ *
+ * Finally, some registers hold bitmasks representing endpoints.  In such
+ * cases the @available field in the @ipa structure defines the "full" set
+ * of valid bits for the register.
+ */
+
+#define IPA_REG_ENABLED_PIPES_OFFSET			0x00000038
+
+#define IPA_REG_COMP_CFG_OFFSET				0x0000003c
+#define ENABLE_FMASK				GENMASK(0, 0)
+#define GSI_SNOC_BYPASS_DIS_FMASK		GENMASK(1, 1)
+#define GEN_QMB_0_SNOC_BYPASS_DIS_FMASK		GENMASK(2, 2)
+#define GEN_QMB_1_SNOC_BYPASS_DIS_FMASK		GENMASK(3, 3)
+#define IPA_DCMP_FAST_CLK_EN_FMASK		GENMASK(4, 4)
+#define IPA_QMB_SELECT_CONS_EN_FMASK		GENMASK(5, 5)
+#define IPA_QMB_SELECT_PROD_EN_FMASK		GENMASK(6, 6)
+#define GSI_MULTI_INORDER_RD_DIS_FMASK		GENMASK(7, 7)
+#define GSI_MULTI_INORDER_WR_DIS_FMASK		GENMASK(8, 8)
+#define GEN_QMB_0_MULTI_INORDER_RD_DIS_FMASK	GENMASK(9, 9)
+#define GEN_QMB_1_MULTI_INORDER_RD_DIS_FMASK	GENMASK(10, 10)
+#define GEN_QMB_0_MULTI_INORDER_WR_DIS_FMASK	GENMASK(11, 11)
+#define GEN_QMB_1_MULTI_INORDER_WR_DIS_FMASK	GENMASK(12, 12)
+#define GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS_FMASK	GENMASK(13, 13)
+#define GSI_SNOC_CNOC_LOOP_PROT_DISABLE_FMASK	GENMASK(14, 14)
+#define GSI_MULTI_AXI_MASTERS_DIS_FMASK		GENMASK(15, 15)
+#define IPA_QMB_SELECT_GLOBAL_EN_FMASK		GENMASK(16, 16)
+#define IPA_ATOMIC_FETCHER_ARB_LOCK_DIS_FMASK	GENMASK(20, 17)
+
+#define IPA_REG_CLKON_CFG_OFFSET			0x00000044
+#define RX_FMASK				GENMASK(0, 0)
+#define PROC_FMASK				GENMASK(1, 1)
+#define TX_WRAPPER_FMASK			GENMASK(2, 2)
+#define MISC_FMASK				GENMASK(3, 3)
+#define RAM_ARB_FMASK				GENMASK(4, 4)
+#define FTCH_HPS_FMASK				GENMASK(5, 5)
+#define FTCH_DPS_FMASK				GENMASK(6, 6)
+#define HPS_FMASK				GENMASK(7, 7)
+#define DPS_FMASK				GENMASK(8, 8)
+#define RX_HPS_CMDQS_FMASK			GENMASK(9, 9)
+#define HPS_DPS_CMDQS_FMASK			GENMASK(10, 10)
+#define DPS_TX_CMDQS_FMASK			GENMASK(11, 11)
+#define RSRC_MNGR_FMASK				GENMASK(12, 12)
+#define CTX_HANDLER_FMASK			GENMASK(13, 13)
+#define ACK_MNGR_FMASK				GENMASK(14, 14)
+#define D_DCPH_FMASK				GENMASK(15, 15)
+#define H_DCPH_FMASK				GENMASK(16, 16)
+#define DCMP_FMASK				GENMASK(17, 17)
+#define NTF_TX_CMDQS_FMASK			GENMASK(18, 18)
+#define TX_0_FMASK				GENMASK(19, 19)
+#define TX_1_FMASK				GENMASK(20, 20)
+#define FNR_FMASK				GENMASK(21, 21)
+#define QSB2AXI_CMDQ_L_FMASK			GENMASK(22, 22)
+#define AGGR_WRAPPER_FMASK			GENMASK(23, 23)
+#define RAM_SLAVEWAY_FMASK			GENMASK(24, 24)
+#define QMB_FMASK				GENMASK(25, 25)
+#define WEIGHT_ARB_FMASK			GENMASK(26, 26)
+#define GSI_IF_FMASK				GENMASK(27, 27)
+#define GLOBAL_FMASK				GENMASK(28, 28)
+#define GLOBAL_2X_CLK_FMASK			GENMASK(29, 29)
+
+#define IPA_REG_ROUTE_OFFSET				0x00000048
+#define ROUTE_DIS_FMASK				GENMASK(0, 0)
+#define ROUTE_DEF_PIPE_FMASK			GENMASK(5, 1)
+#define ROUTE_DEF_HDR_TABLE_FMASK		GENMASK(6, 6)
+#define ROUTE_DEF_HDR_OFST_FMASK		GENMASK(16, 7)
+#define ROUTE_FRAG_DEF_PIPE_FMASK		GENMASK(21, 17)
+#define ROUTE_DEF_RETAIN_HDR_FMASK		GENMASK(24, 24)
+
+#define IPA_REG_SHARED_MEM_SIZE_OFFSET			0x00000054
+#define SHARED_MEM_SIZE_FMASK			GENMASK(15, 0)
+#define SHARED_MEM_BADDR_FMASK			GENMASK(31, 16)
+
+#define IPA_REG_QSB_MAX_WRITES_OFFSET			0x00000074
+#define GEN_QMB_0_MAX_WRITES_FMASK		GENMASK(3, 0)
+#define GEN_QMB_1_MAX_WRITES_FMASK		GENMASK(7, 4)
+
+#define IPA_REG_QSB_MAX_READS_OFFSET			0x00000078
+#define GEN_QMB_0_MAX_READS_FMASK		GENMASK(3, 0)
+#define GEN_QMB_1_MAX_READS_FMASK		GENMASK(7, 4)
+/* The next two fields are present for IPA v4.0 and above */
+#define GEN_QMB_0_MAX_READS_BEATS_FMASK		GENMASK(23, 16)
+#define GEN_QMB_1_MAX_READS_BEATS_FMASK		GENMASK(31, 24)
+
+static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
+{
+	if (version == IPA_VERSION_3_5_1)
+		return 0x0000010c;
+
+	return 0x000000b4;
+}
+/* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
+
+/* The next register is present for IPA v4.2 and above */
+#define IPA_REG_FILT_ROUT_HASH_EN_OFFSET		0x00000148
+#define IPV6_ROUTER_HASH_EN			GENMASK(0, 0)
+#define IPV6_FILTER_HASH_EN			GENMASK(4, 4)
+#define IPV4_ROUTER_HASH_EN			GENMASK(8, 8)
+#define IPV4_FILTER_HASH_EN			GENMASK(12, 12)
+
+static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
+{
+	if (version == IPA_VERSION_3_5_1)
+		return 0x0000090;
+
+	return 0x000014c;
+}
+
+#define IPV6_ROUTER_HASH_FLUSH			GENMASK(0, 0)
+#define IPV6_FILTER_HASH_FLUSH			GENMASK(4, 4)
+#define IPV4_ROUTER_HASH_FLUSH			GENMASK(8, 8)
+#define IPV4_FILTER_HASH_FLUSH			GENMASK(12, 12)
+
+#define IPA_REG_BCR_OFFSET				0x000001d0
+#define BCR_CMDQ_L_LACK_ONE_ENTRY		BIT(0)
+#define BCR_TX_NOT_USING_BRESP			BIT(1)
+#define BCR_SUSPEND_L2_IRQ			BIT(3)
+#define BCR_HOLB_DROP_L2_IRQ			BIT(4)
+#define BCR_DUAL_TX				BIT(5)
+
+/* Backward compatibility register value to use for each version */
+static inline u32 ipa_reg_bcr_val(enum ipa_version version)
+{
+	if (version == IPA_VERSION_3_5_1)
+		return BCR_CMDQ_L_LACK_ONE_ENTRY | BCR_TX_NOT_USING_BRESP |
+		       BCR_SUSPEND_L2_IRQ | BCR_HOLB_DROP_L2_IRQ | BCR_DUAL_TX;
+
+	if (version == IPA_VERSION_4_0 || version == IPA_VERSION_4_1)
+		return BCR_CMDQ_L_LACK_ONE_ENTRY | BCR_SUSPEND_L2_IRQ |
+		       BCR_HOLB_DROP_L2_IRQ | BCR_DUAL_TX;
+
+	return 0x00000000;
+}
+
+
+#define IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET	0x000001e8
+
+#define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
+/* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
+
+#define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
+#define AGGR_GRANULARITY			GENMASK(8, 4)
+/* Compute the value to use in the AGGR_GRANULARITY field representing
+ * the given number of microseconds (up to 1 millisecond).
+ *	x = (32 * usec) / 1000 - 1
+ */
+static inline u32 ipa_aggr_granularity_val(u32 microseconds)
+{
+	/* assert(microseconds >= 16); (?) */
+	/* assert(microseconds <= 1015); */
+
+	return DIV_ROUND_CLOSEST(32 * microseconds, 1000) - 1;
+}
+
+#define IPA_REG_TX_CFG_OFFSET				0x000001fc
+/* The first three fields are present for IPA v3.5.1 only */
+#define TX0_PREFETCH_DISABLE			GENMASK(0, 0)
+#define TX1_PREFETCH_DISABLE			GENMASK(1, 1)
+#define PREFETCH_ALMOST_EMPTY_SIZE		GENMASK(4, 2)
+/* The next fields are present for IPA v4.0 and above */
+#define PREFETCH_ALMOST_EMPTY_SIZE_TX0		GENMASK(5, 2)
+#define DMAW_SCND_OUTSD_PRED_THRESHOLD		GENMASK(9, 6)
+#define DMAW_SCND_OUTSD_PRED_EN			GENMASK(10, 10)
+#define DMAW_MAX_BEATS_256_DIS			GENMASK(11, 11)
+#define PA_MASK_EN				GENMASK(12, 12)
+#define PREFETCH_ALMOST_EMPTY_SIZE_TX1		GENMASK(16, 13)
+/* The last two fields are present for IPA v4.2 and above */
+#define SSPND_PA_NO_START_STATE			GENMASK(18, 18)
+#define SSPND_PA_NO_BQ_STATE			GENMASK(19, 19)
+
+#define IPA_REG_FLAVOR_0_OFFSET				0x00000210
+#define BAM_MAX_PIPES_FMASK			GENMASK(4, 0)
+#define BAM_MAX_CONS_PIPES_FMASK		GENMASK(12, 8)
+#define BAM_MAX_PROD_PIPES_FMASK		GENMASK(20, 16)
+#define BAM_PROD_LOWEST_FMASK			GENMASK(27, 24)
+
+static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
+{
+	if (version == IPA_VERSION_4_2)
+		return 0x00000240;
+
+	return 0x00000220;
+}
+
+#define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
+#define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
+
+#define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
+					(0x00000400 + 0x0020 * (rt))
+#define IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
+					(0x00000404 + 0x0020 * (rt))
+#define IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
+					(0x00000408 + 0x0020 * (rt))
+#define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
+					(0x00000500 + 0x0020 * (rt))
+#define IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
+					(0x00000504 + 0x0020 * (rt))
+#define IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
+					(0x00000508 + 0x0020 * (rt))
+#define X_MIN_LIM_FMASK				GENMASK(5, 0)
+#define X_MAX_LIM_FMASK				GENMASK(13, 8)
+#define Y_MIN_LIM_FMASK				GENMASK(21, 16)
+#define Y_MAX_LIM_FMASK				GENMASK(29, 24)
+
+#define IPA_REG_ENDP_INIT_CTRL_N_OFFSET(ep) \
+					(0x00000800 + 0x0070 * (ep))
+#define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
+#define ENDP_DELAY_FMASK			GENMASK(1, 1)
+
+#define IPA_REG_ENDP_INIT_CFG_N_OFFSET(ep) \
+					(0x00000808 + 0x0070 * (ep))
+#define FRAG_OFFLOAD_EN_FMASK			GENMASK(0, 0)
+#define CS_OFFLOAD_EN_FMASK			GENMASK(2, 1)
+#define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
+#define CS_GEN_QMB_MASTER_SEL_FMASK		GENMASK(8, 8)
+
+#define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
+					(0x00000810 + 0x0070 * (ep))
+#define HDR_LEN_FMASK				GENMASK(5, 0)
+#define HDR_OFST_METADATA_VALID_FMASK		GENMASK(6, 6)
+#define HDR_OFST_METADATA_FMASK			GENMASK(12, 7)
+#define HDR_ADDITIONAL_CONST_LEN_FMASK		GENMASK(18, 13)
+#define HDR_OFST_PKT_SIZE_VALID_FMASK		GENMASK(19, 19)
+#define HDR_OFST_PKT_SIZE_FMASK			GENMASK(25, 20)
+#define HDR_A5_MUX_FMASK			GENMASK(26, 26)
+#define HDR_LEN_INC_DEAGG_HDR_FMASK		GENMASK(27, 27)
+#define HDR_METADATA_REG_VALID_FMASK		GENMASK(28, 28)
+
+#define IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(ep) \
+					(0x00000814 + 0x0070 * (ep))
+#define HDR_ENDIANNESS_FMASK			GENMASK(0, 0)
+#define HDR_TOTAL_LEN_OR_PAD_VALID_FMASK	GENMASK(1, 1)
+#define HDR_TOTAL_LEN_OR_PAD_FMASK		GENMASK(2, 2)
+#define HDR_PAYLOAD_LEN_INC_PADDING_FMASK	GENMASK(3, 3)
+#define HDR_TOTAL_LEN_OR_PAD_OFFSET_FMASK	GENMASK(9, 4)
+#define HDR_PAD_TO_ALIGNMENT_FMASK		GENMASK(13, 10)
+
+#define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(ep) \
+					(0x00000818 + 0x0070 * (ep))
+
+#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(ep) \
+					(0x00000820 + 0x0070 * (ep))
+#define MODE_FMASK				GENMASK(2, 0)
+#define DEST_PIPE_INDEX_FMASK			GENMASK(8, 4)
+#define BYTE_THRESHOLD_FMASK			GENMASK(27, 12)
+#define PIPE_REPLICATION_EN_FMASK		GENMASK(28, 28)
+#define PAD_EN_FMASK				GENMASK(29, 29)
+#define HDR_FTCH_DISABLE_FMASK			GENMASK(30, 30)
+
+#define IPA_REG_ENDP_INIT_AGGR_N_OFFSET(ep) \
+					(0x00000824 +  0x0070 * (ep))
+#define AGGR_EN_FMASK				GENMASK(1, 0)
+#define AGGR_TYPE_FMASK				GENMASK(4, 2)
+#define AGGR_BYTE_LIMIT_FMASK			GENMASK(9, 5)
+#define AGGR_TIME_LIMIT_FMASK			GENMASK(14, 10)
+#define AGGR_PKT_LIMIT_FMASK			GENMASK(20, 15)
+#define AGGR_SW_EOF_ACTIVE_FMASK		GENMASK(21, 21)
+#define AGGR_FORCE_CLOSE_FMASK			GENMASK(22, 22)
+#define AGGR_HARD_BYTE_LIMIT_ENABLE_FMASK	GENMASK(24, 24)
+
+#define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(ep) \
+					(0x0000082c +  0x0070 * (ep))
+#define HOL_BLOCK_EN_FMASK			GENMASK(0, 0)
+
+/* The next register is valid only for RX (IPA producer) endpoints */
+#define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(ep) \
+					(0x00000830 +  0x0070 * (ep))
+/* The next fields are present for IPA v4.2 only */
+#define BASE_VALUE_FMASK			GENMASK(4, 0)
+#define SCALE_FMASK				GENMASK(12, 8)
+
+#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(ep) \
+					(0x00000834 + 0x0070 * (ep))
+#define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
+#define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
+#define PACKET_OFFSET_LOCATION_FMASK		GENMASK(13, 8)
+#define MAX_PACKET_LEN_FMASK			GENMASK(31, 16)
+
+#define IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(ep) \
+					(0x00000838 + 0x0070 * (ep))
+#define RSRC_GRP_FMASK				GENMASK(1, 0)
+
+#define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(ep) \
+					(0x0000083c + 0x0070 * (ep))
+#define HPS_SEQ_TYPE_FMASK			GENMASK(3, 0)
+#define DPS_SEQ_TYPE_FMASK			GENMASK(7, 4)
+#define HPS_REP_SEQ_TYPE_FMASK			GENMASK(11, 8)
+#define DPS_REP_SEQ_TYPE_FMASK			GENMASK(15, 12)
+
+#define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
+					(0x00000840 + 0x0070 * (ep))
+#define STATUS_EN_FMASK				GENMASK(0, 0)
+#define STATUS_ENDP_FMASK			GENMASK(5, 1)
+#define STATUS_LOCATION_FMASK			GENMASK(8, 8)
+/* The next field is present for IPA v4.0 and above */
+#define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
+
+/* "er" is either an endpoint id (for filters) or a route id (for routes) */
+#define IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(er) \
+					(0x0000085c + 0x0070 * (er))
+#define FILTER_HASH_MSK_SRC_ID_FMASK		GENMASK(0, 0)
+#define FILTER_HASH_MSK_SRC_IP_FMASK		GENMASK(1, 1)
+#define FILTER_HASH_MSK_DST_IP_FMASK		GENMASK(2, 2)
+#define FILTER_HASH_MSK_SRC_PORT_FMASK		GENMASK(3, 3)
+#define FILTER_HASH_MSK_DST_PORT_FMASK		GENMASK(4, 4)
+#define FILTER_HASH_MSK_PROTOCOL_FMASK		GENMASK(5, 5)
+#define FILTER_HASH_MSK_METADATA_FMASK		GENMASK(6, 6)
+#define IPA_REG_ENDP_FILTER_HASH_MSK_ALL	GENMASK(6, 0)
+
+#define ROUTER_HASH_MSK_SRC_ID_FMASK		GENMASK(16, 16)
+#define ROUTER_HASH_MSK_SRC_IP_FMASK		GENMASK(17, 17)
+#define ROUTER_HASH_MSK_DST_IP_FMASK		GENMASK(18, 18)
+#define ROUTER_HASH_MSK_SRC_PORT_FMASK		GENMASK(19, 19)
+#define ROUTER_HASH_MSK_DST_PORT_FMASK		GENMASK(20, 20)
+#define ROUTER_HASH_MSK_PROTOCOL_FMASK		GENMASK(21, 21)
+#define ROUTER_HASH_MSK_METADATA_FMASK		GENMASK(22, 22)
+#define IPA_REG_ENDP_ROUTER_HASH_MSK_ALL	GENMASK(22, 16)
+
+#define IPA_REG_IRQ_STTS_OFFSET	\
+				IPA_REG_IRQ_STTS_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_IRQ_STTS_EE_N_OFFSET(ee) \
+					(0x00003008 + 0x1000 * (ee))
+
+#define IPA_REG_IRQ_EN_OFFSET \
+				IPA_REG_IRQ_EN_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_IRQ_EN_EE_N_OFFSET(ee) \
+					(0x0000300c + 0x1000 * (ee))
+
+#define IPA_REG_IRQ_CLR_OFFSET \
+				IPA_REG_IRQ_CLR_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_IRQ_CLR_EE_N_OFFSET(ee) \
+					(0x00003010 + 0x1000 * (ee))
+
+#define IPA_REG_IRQ_UC_OFFSET \
+				IPA_REG_IRQ_UC_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_IRQ_UC_EE_N_OFFSET(ee) \
+					(0x0000301c + 0x1000 * (ee))
+
+#define IPA_REG_IRQ_SUSPEND_INFO_OFFSET \
+				IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(ee) \
+					(0x00003030 + 0x1000 * (ee))
+/* ipa->available defines the valid bits in the SUSPEND_INFO register */
+
+#define IPA_REG_SUSPEND_IRQ_EN_OFFSET \
+				IPA_REG_SUSPEND_IRQ_EN_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_SUSPEND_IRQ_EN_EE_N_OFFSET(ee) \
+					(0x00003034 + 0x1000 * (ee))
+/* ipa->available defines the valid bits in the SUSPEND_IRQ_EN register */
+
+#define IPA_REG_SUSPEND_IRQ_CLR_OFFSET \
+				IPA_REG_SUSPEND_IRQ_CLR_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_SUSPEND_IRQ_CLR_EE_N_OFFSET(ee) \
+					(0x00003038 + 0x1000 * (ee))
+/* ipa->available defines the valid bits in the SUSPEND_IRQ_CLR register */
+
+/** enum ipa_cs_offload_en - checksum offload field in ENDP_INIT_CFG_N */
+enum ipa_cs_offload_en {
+	IPA_CS_OFFLOAD_NONE	= 0,
+	IPA_CS_OFFLOAD_UL	= 1,
+	IPA_CS_OFFLOAD_DL	= 2,
+	IPA_CS_RSVD
+};
+
+/** enum ipa_aggr_en - aggregation type field in ENDP_INIT_AGGR_N */
+enum ipa_aggr_en {
+	IPA_BYPASS_AGGR		= 0,
+	IPA_ENABLE_AGGR		= 1,
+	IPA_ENABLE_DEAGGR	= 2,
+};
+
+/** enum ipa_aggr_type - aggregation type field in in_ENDP_INIT_AGGR_N */
+enum ipa_aggr_type {
+	IPA_MBIM_16	= 0,
+	IPA_HDLC	= 1,
+	IPA_TLP		= 2,
+	IPA_RNDIS	= 3,
+	IPA_GENERIC	= 4,
+	IPA_COALESCE	= 5,
+	IPA_QCMAP	= 6,
+};
+
+/** enum ipa_mode - mode field in ENDP_INIT_MODE_N */
+enum ipa_mode {
+	IPA_BASIC			= 0,
+	IPA_ENABLE_FRAMING_HDLC		= 1,
+	IPA_ENABLE_DEFRAMING_HDLC	= 2,
+	IPA_DMA				= 3,
+};
+
+/**
+ * enum ipa_seq_type - HPS and DPS sequencer type fields in in ENDP_INIT_SEQ_N
+ * @IPA_SEQ_DMA_ONLY:		only DMA is performed
+ * @IPA_SEQ_PKT_PROCESS_NO_DEC_UCP:
+ *	packet processing + no decipher + microcontroller (Ethernet Bridging)
+ * @IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP:
+ *	second packet processing pass + no decipher + microcontroller
+ * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
+ * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
+ * @IPA_SEQ_INVALID:		invalid sequencer type
+ *
+ * The values defined here are broken into 4-bit nibbles that are written
+ * into fields of the INIT_SEQ_N endpoint registers.
+ */
+enum ipa_seq_type {
+	IPA_SEQ_DMA_ONLY			= 0x0000,
+	IPA_SEQ_PKT_PROCESS_NO_DEC_UCP		= 0x0002,
+	IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP	= 0x0004,
+	IPA_SEQ_DMA_DEC				= 0x0011,
+	IPA_SEQ_DMA_COMP_DECOMP			= 0x0020,
+	IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP	= 0x0806,
+	IPA_SEQ_INVALID				= 0xffff,
+};
+
+int ipa_reg_init(struct ipa *ipa);
+void ipa_reg_exit(struct ipa *ipa);
+
+#endif /* _IPA_REG_H_ */
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
new file mode 100644
index 000000000000..85449df0f512
--- /dev/null
+++ b/drivers/net/ipa/ipa_version.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+#ifndef _IPA_VERSION_H_
+#define _IPA_VERSION_H_
+
+/**
+ * enum ipa_version
+ *
+ * Defines the version of IPA (and GSI) hardware present on the platform.
+ * It seems this might be better defined elsewhere, but having it here gets
+ * it where it's needed.
+ */
+enum ipa_version {
+	IPA_VERSION_3_5_1,	/* GSI version 1.3.0 */
+	IPA_VERSION_4_0,	/* GSI version 2.0 */
+	IPA_VERSION_4_1,	/* GSI version 2.1 */
+	IPA_VERSION_4_2,	/* GSI version 2.2 */
+};
+
+#endif /* _IPA_VERSION_H_ */
-- 
2.20.1

