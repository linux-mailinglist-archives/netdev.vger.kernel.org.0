Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53823076C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfEaDzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:55:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36988 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfEaDyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:01 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so7035968iok.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=10rk4EeLLsyvC1xr0GY9e+fZm4KSUy7ctXT9DRu7iCc=;
        b=By6kOwqpQoQ6Pj1mdyn8FcvtdxEXLA8rMl78y73Of1bl59K2HDANnnp9YDwoVGDFcp
         tIpC2nAniY8+5gQNtYQyEs0+wuV8EJdOtKfAKWRqMLZgU+M7QysRUj5pGct+2f2kUOjt
         JNAAmN9b6HQvYqHYnPvGjR4PPsBwT4bgZaQLc5HGPjtVukKymB12EONSAAymTEwmTz5u
         +auYKFI8ZnC4/DpwaZIb5F+9HI382QR1GNO/rTIQlBdtgilS5jar0cUfPS7ldWj43qYt
         h3roOuN618qKPiQpXTCqtaCuHCESpwM0UdB3KtUybA6pjjapx6G58I5Ri12RgMmJVWPa
         0Lrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=10rk4EeLLsyvC1xr0GY9e+fZm4KSUy7ctXT9DRu7iCc=;
        b=f8dYVBk9o0Rys0nvveJUhBQVe1701L5DTK6opqDEejYXqHcMadQ8iJoREkoUByANPC
         E5zwKuTRwl2a3BEDW2xhb7Nun81aihFXQb5zCFky1rvupAo2CATw2Nfi559fQvhPSjBE
         XtQPfS+EFwNBGcuMhlJTyqamvtP4jOHUl3OZNFV6UXNHE8eI1URm+CDTKYIvpW1Qy6rU
         nYykhWWe2v+knVIvIXLIH+zuEQqt8xWQHX7yPQT41xAKABpmuZu/dyJfBgBKG3bhoJBP
         32WpPeEp9Hko5G3lnRnHOqqV2taqKY5OXErzkAUE4IW5/fmFtS57LiQW+j3Y6OwYhOeS
         y4bQ==
X-Gm-Message-State: APjAAAUIHqD/ikMlMaQEuUWMbYQUEV5ZAbmNopRiYDDppzb5fACCLJ+R
        mtIRxs5/WMI2rSD4wPnIuWjPmg==
X-Google-Smtp-Source: APXvYqw8hf4NbhNTDtUbd6ZrC1m/WSbL9r1af8m2dHtRtQHbSMnuyqW7Oy3YbaBroyVd75bSOoI/4Q==
X-Received: by 2002:a5d:870e:: with SMTP id u14mr5025257iom.44.1559274839357;
        Thu, 30 May 2019 20:53:59 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.53.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:53:58 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 03/17] soc: qcom: ipa: main code
Date:   Thu, 30 May 2019 22:53:34 -0500
Message-Id: <20190531035348.7194-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
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
    fields less than 32 bits located within these registers.

Each file includes some documentation that provides a little more
overview of how the code is organized and used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h      | 131 ++++++
 drivers/net/ipa/ipa_main.c | 921 +++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_reg.h  | 279 +++++++++++
 3 files changed, 1331 insertions(+)
 create mode 100644 drivers/net/ipa/ipa.h
 create mode 100644 drivers/net/ipa/ipa_main.c
 create mode 100644 drivers/net/ipa/ipa_reg.h

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
new file mode 100644
index 000000000000..c580254d1e0e
--- /dev/null
+++ b/drivers/net/ipa/ipa.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_H_
+#define _IPA_H_
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/notifier.h>
+#include <linux/pm_wakeup.h>
+
+#include "gsi.h"
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
+ * @pdev:		Platform device
+ * @smp2p:		SMP2P information
+ * @clock:		IPA clocking information
+ * @suspend_ref:	Whether clock reference preventing suspend taken
+ * @route_virt:		Virtual address of routing table
+ * @route_addr:		DMA address for routing table
+ * @filter_virt:	Virtual address of filter table
+ * @filter_addr:	DMA address for filter table
+ * @interrupt:		IPA Interrupt information
+ * @uc_loaded:		Non-zero when microcontroller has reported it's ready
+ * @ipa_phys:		Physical address of IPA memory space
+ * @ipa_virt:		Virtual address for IPA memory space
+ * @reg_virt:		Virtual address used for IPA register access
+ * @shared_phys:	Physical address of memory space shared with modem
+ * @shared_virt:	Virtual address of memory space shared with modem
+ * @shared_offset:	Additional offset used for shared memory
+ * @wakeup:		Wakeup source information
+ * @filter_support:	Bit mask indicating endpoints that support filtering
+ * @initialized:	Bit mask indicating endpoints initialized
+ * @set_up:		Bit mask indicating endpoints set up
+ * @enabled:		Bit mask indicating endpoints enabled
+ * @suspended:		Bit mask indicating endpoints suspended
+ * @endpoint:		Array of endpoint information
+ * @endpoint_map:	Mapping of GSI channel to IPA endpoint information
+ * @command_endpoint:	Endpoint used for command TX
+ * @default_endpoint:	Endpoint used for default route RX
+ * @modem_netdev:	Network device structure used for modem
+ * @setup_complete:	Flag indicating whether setup stage has completed
+ * @qmi:		QMI information
+ */
+struct ipa {
+	struct gsi gsi;
+	struct platform_device *pdev;
+	struct ipa_smp2p *smp2p;
+	struct ipa_clock *clock;
+	atomic_t suspend_ref;
+
+	void *route_virt;
+	dma_addr_t route_addr;
+	void *filter_virt;
+	dma_addr_t filter_addr;
+
+	struct ipa_interrupt *interrupt;
+	u32 uc_loaded;
+
+	phys_addr_t reg_phys;
+	void __iomem *reg_virt;
+	phys_addr_t shared_phys;
+	void *shared_virt;
+	u32 shared_offset;
+
+	struct wakeup_source wakeup;
+
+	/* Bit masks indicating endpoint state */
+	u32 filter_support;
+	u32 initialized;
+	u32 set_up;
+	u32 enabled;
+	u32 suspended;
+
+	struct ipa_endpoint endpoint[IPA_ENDPOINT_MAX];
+	struct ipa_endpoint *endpoint_map[GSI_CHANNEL_MAX];
+	struct ipa_endpoint *command_endpoint;	/* TX */
+	struct ipa_endpoint *default_endpoint;	/* Default route RX */
+
+	struct net_device *modem_netdev;
+	u32 setup_complete;
+
+	struct ipa_qmi qmi;
+};
+
+/**
+ * ipa_setup() - Perform IPA setup
+ * @ipa:		IPA pointer
+ *
+ * IPA initialization is broken into stages:  init; config; setup; and
+ * sometimes enable.  (These have inverses exit, deconfig, teardown, and
+ * disable.)  Activities performed at the init stage can be done without
+ * requiring any access to hardware.  For IPA, activities performed at the
+ * config stage require the IPA clock to be running, because they involve
+ * access to IPA registers.  The setup stage is performed only after the
+ * GSI hardware is ready (more on this below).  And finally IPA endpoints
+ * can be enabled once they're successfully set up.
+ *
+ * This function, @ipa_setup(), starts the setup stage.
+ *
+ * In order for the GSI hardware to be functional it needs firmware to be
+ * loaded (in addition to some other low-level initialization).  This early
+ * GSI initialization can be done either by Trust Zone or by the modem.  If
+ * it's done by Trust Zone, the AP loads the GSI firmware and supplies it to
+ * Trust Zone to verify and install.  The AP knows when this completes, and
+ * whether it was successful.  In this case the AP proceeds to setup once it
+ * knows GSI is ready.
+ *
+ * If the modem performs early GSI initialization, the AP needs to know when
+ * this has occurred.  An SMP2P interrupt is used for this purpose, and
+ * receipt of that interrupt triggers the call to ipa_setup().
+ */
+int ipa_setup(struct ipa *ipa);
+
+#endif /* _IPA_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
new file mode 100644
index 000000000000..bd3f258b3b02
--- /dev/null
+++ b/drivers/net/ipa/ipa_main.c
@@ -0,0 +1,921 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
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
+#include "ipa_mem.h"
+#include "ipa_netdev.h"
+#include "ipa_smp2p.h"
+#include "ipa_uc.h"
+#include "ipa_interrupt.h"
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
+ * connection of the modem to external (e.g. LTE) networks.  The IPA can
+ * provide protocol checksum calculation, offloading this work from the AP.
+ * The IPA is able to provide additional functionality, including routing,
+ * filtering, and NAT support, but that more advanced functionality is not
+ * currently supported.
+ *
+ * Certain resources--including routing tables and filter tables--are still
+ * defined in this driver, because they must be initialized even when the
+ * advanced hardware features are not used.
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
+#define IPA_TABLE_ALIGN		128		/* Minimum table alignment */
+#define IPA_TABLE_ENTRY_SIZE	sizeof(u64)	/* Holds a physical address */
+#define IPA_FILTER_SIZE		8		/* Filter descriptor size */
+#define IPA_ROUTE_SIZE		8		/* Route descriptor size */
+
+/* Backward compatibility register value to use for SDM845 */
+#define IPA_BCR_REG_VAL		0x0000003b
+
+/* The name of the main firmware file relative to /lib/firmware */
+#define IPA_FWS_PATH		"ipa_fws.mdt"
+#define IPA_PAS_ID		15
+
+/**
+ * ipa_filter_tuple_zero() - Zero an endpoints filter tuple
+ * @endpoint_id:	Endpoint whose filter tuple should be zeroed
+ *
+ * Endpoint must be for AP (not modem) and support filtering. Updates the
+ * filter masks values without changing routing ones.
+ */
+static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
+{
+	enum ipa_endpoint_id endpoint_id = endpoint->endpoint_id;
+	u32 offset;
+	u32 val;
+
+	offset = IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(endpoint_id);
+
+	val = ioread32(endpoint->ipa->reg_virt + offset);
+
+	/* Zero all filter-related fields, preserving the rest */
+	u32_replace_bits(val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_filter_hash_tuple_config(struct ipa *ipa)
+{
+	u32 ep_mask = ipa->filter_support;
+
+	while (ep_mask) {
+		enum ipa_endpoint_id endpoint_id = __ffs(ep_mask);
+		struct ipa_endpoint *endpoint;
+
+		ep_mask ^= BIT(endpoint_id);
+
+		endpoint = &ipa->endpoint[endpoint_id];
+		if (endpoint->ee_id != GSI_EE_MODEM)
+			ipa_filter_tuple_zero(endpoint);
+	}
+}
+
+/**
+ * ipa_route_tuple_zero() - Zero a routing table entry tuple
+ * @route_id:	Identifier for routing table entry to be zeroed
+ *
+ * Updates the routing table values without changing filtering ones.
+ */
+static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
+{
+	u32 offset = IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(route_id);
+	u32 val;
+
+	val = ioread32(ipa->reg_virt + offset);
+
+	/* Zero all route-related fields, preserving the rest */
+	u32_replace_bits(val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
+
+	iowrite32(val, ipa->reg_virt + offset);
+}
+
+static void ipa_route_hash_tuple_config(struct ipa *ipa)
+{
+	u32 route_mask;
+	u32 modem_mask;
+
+	BUILD_BUG_ON(!IPA_SMEM_MODEM_RT_COUNT);
+	BUILD_BUG_ON(IPA_SMEM_RT_COUNT < IPA_SMEM_MODEM_RT_COUNT);
+	BUILD_BUG_ON(IPA_SMEM_RT_COUNT >= BITS_PER_LONG);
+
+	/* Compute a mask representing non-modem routing table entries */
+	route_mask = GENMASK(IPA_SMEM_RT_COUNT - 1, 0);
+	modem_mask = GENMASK(IPA_SMEM_MODEM_RT_INDEX_MAX,
+			     IPA_SMEM_MODEM_RT_INDEX_MIN);
+	route_mask &= ~modem_mask;
+
+	while (route_mask) {
+		u32 route_id = __ffs(route_mask);
+
+		route_mask ^= BIT(route_id);
+
+		ipa_route_tuple_zero(ipa, route_id);
+	}
+}
+
+/**
+ * ipa_route_setup() - Initialize an empty routing table
+ * @ipa:	IPA pointer
+ *
+ * Each entry in the routing table contains the DMA address of a route
+ * descriptor.  A special zero descriptor is allocated that represents "no
+ * route" and this function initializes all its entries to point at that
+ * zero route.  The zero route is allocated with the table, immediately past
+ * its end.
+ *
+ * @Return:	0 if successful or -ENOMEM
+ */
+static int ipa_route_setup(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	u64 zero_route_addr;
+	dma_addr_t addr;
+	u32 route_id;
+	size_t size;
+	u64 *virt;
+
+	BUILD_BUG_ON(!IPA_ROUTE_SIZE);
+	BUILD_BUG_ON(sizeof(*virt) != IPA_TABLE_ENTRY_SIZE);
+
+	/* Allocate the routing table, with enough space at the end of the
+	 * table to hold the zero route descriptor.  Initialize all filter
+	 * table entries to point to the zero route.
+	 */
+	size = IPA_SMEM_RT_COUNT * IPA_TABLE_ENTRY_SIZE;
+	virt = dma_alloc_coherent(dev, size + IPA_ROUTE_SIZE, &addr,
+				   GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+	ipa->route_virt = virt;
+	ipa->route_addr = addr;
+
+	/* Zero route is immediately after the route table */
+	zero_route_addr = addr + size;
+
+	for (route_id = 0; route_id < IPA_SMEM_RT_COUNT; route_id++)
+		*virt++ = zero_route_addr;
+
+	ipa_cmd_route_config_ipv4(ipa, size);
+	ipa_cmd_route_config_ipv6(ipa, size);
+
+	ipa_route_hash_tuple_config(ipa);
+
+	/* Configure default route for exception packets */
+	ipa_endpoint_default_route_setup(ipa->default_endpoint);
+
+	return 0;
+}
+
+/**
+ * ipa_route_teardown() - Inverse of ipa_route_setup().
+ * @ipa:	IPA pointer
+ */
+static void ipa_route_teardown(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	size_t size;
+
+	ipa_endpoint_default_route_teardown(ipa->default_endpoint);
+
+	size = IPA_SMEM_RT_COUNT * IPA_TABLE_ENTRY_SIZE;
+	size += IPA_ROUTE_SIZE;
+
+	dma_free_coherent(dev, size, ipa->route_virt, ipa->route_addr);
+	ipa->route_virt = NULL;
+	ipa->route_addr = 0;
+}
+
+/**
+ * ipa_filter_setup() - Initialize an empty filter table
+ * @ipa:	IPA pointer
+ *
+ * The filter table consists of a bitmask representing which endpoints support
+ * filtering, followed by one table entry for each set bit in the mask.  Each
+ * entry in the filter table contains the DMA address of a filter descriptor.
+ * A special zero descriptor is allocated that represents "no filter" and this
+ * function initializes all its entries to point at that zero filter.  The
+ * zero filter is allocated with the table, immediately past its end.
+ *
+ * @Return:	0 if successful or a negative error code
+ */
+static int ipa_filter_setup(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	u64 zero_filter_addr;
+	u32 filter_count;
+	dma_addr_t addr;
+	size_t size;
+	u64 *virt;
+	u32 i;
+
+	BUILD_BUG_ON(!IPA_FILTER_SIZE);
+
+	/* Allocate the filter table, with an extra slot for the bitmap.  Also
+	 * allocate enough space at the end of the table to hold the zero
+	 * filter descriptor.  Initialize all filter table entries point to
+	 * that.
+	 */
+	filter_count = hweight32(ipa->filter_support);
+	size = (filter_count + 1) * IPA_TABLE_ENTRY_SIZE;
+	virt = dma_alloc_coherent(dev, size + IPA_FILTER_SIZE, &addr,
+				   GFP_KERNEL);
+	if (!virt)
+		goto err_clear_filter_support;
+	ipa->filter_virt = virt;
+	ipa->filter_addr = addr;
+
+	/* Zero filter is immediately after the filter table */
+	zero_filter_addr = addr + size;
+
+	/* Save the filter table bitmap.  The "soft" bitmap value must be
+	 * converted to the hardware representation by shifting it left one
+	 * position.  (Bit 0 represents global filtering, which is possible
+	 * but not used.)
+	 */
+	*virt++ = ipa->filter_support << 1;
+
+	/* Now point every entry in the table at the empty filter */
+	for (i = 0; i < filter_count; i++)
+		*virt++ = zero_filter_addr;
+
+	ipa_cmd_filter_config_ipv4(ipa, size);
+	ipa_cmd_filter_config_ipv6(ipa, size);
+
+	ipa_filter_hash_tuple_config(ipa);
+
+	return 0;
+
+err_clear_filter_support:
+	ipa->filter_support = 0;
+
+	return -ENOMEM;
+}
+
+/**
+ * ipa_filter_teardown() - Inverse of ipa_filter_setup().
+ * @ipa:	IPA pointer
+ */
+static void ipa_filter_teardown(struct ipa *ipa)
+{
+	u32 filter_count = hweight32(ipa->filter_support);
+	struct device *dev = &ipa->pdev->dev;
+	size_t size;
+
+	size = (filter_count + 1) * IPA_TABLE_ENTRY_SIZE;
+	size += IPA_FILTER_SIZE;
+
+	dma_free_coherent(dev, size, ipa->filter_virt, ipa->filter_addr);
+	ipa->filter_virt = NULL;
+	ipa->filter_addr = 0;
+	ipa->filter_support = 0;
+}
+
+/**
+ * ipa_suspend_handler() - Handle the suspend interrupt
+ * @ipa:	IPA pointer
+ * @interrupt:	Interrupt type.
+ *
+ * When in suspended state, the IPA can trigger a resume by sending a SUSPEND
+ * IPA interrupt.
+ */
+static void ipa_suspend_handler(struct ipa *ipa,
+				enum ipa_interrupt_id interrupt_id)
+{
+	/* Take a a single clock reference to prevent suspend.  All
+	 * endpoints will be resumed as a result.  This reference will
+	 * be dropped when we get a power management suspend request.
+	 */
+	if (!atomic_xchg(&ipa->suspend_ref, 1))
+		ipa_clock_get(ipa->clock);
+
+	/* Acknowledge/clear the suspend interrupt on all endpoints */
+	ipa_interrupt_suspend_clear_all(ipa->interrupt);
+}
+
+/* Remoteproc callbacks for SSR events: prepare, start, stop, unprepare */
+int ipa_ssr_prepare(struct rproc_subdev *subdev)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipa_ssr_prepare);
+
+int ipa_ssr_start(struct rproc_subdev *subdev)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipa_ssr_start);
+
+void ipa_ssr_stop(struct rproc_subdev *subdev, bool crashed)
+{
+}
+EXPORT_SYMBOL_GPL(ipa_ssr_stop);
+
+void ipa_ssr_unprepare(struct rproc_subdev *subdev)
+{
+}
+EXPORT_SYMBOL_GPL(ipa_ssr_unprepare);
+
+/**
+ * ipa_setup() - Set up IPA hardware
+ * @ipa:	IPA pointer
+ *
+ * Perform initialization that requires issuing immediate commands using the
+ * command TX endpoint.  This cannot be run until early initialization
+ * (including loading GSI firmware) is complete.
+ */
+int ipa_setup(struct ipa *ipa)
+{
+	struct ipa_endpoint *rx_endpoint;
+	struct ipa_endpoint *tx_endpoint;
+	int ret;
+
+	dev_dbg(&ipa->pdev->dev, "%s() started\n", __func__);
+
+	ret = gsi_setup(&ipa->gsi);
+	if (ret)
+		return ret;
+
+	ipa->interrupt = ipa_interrupt_setup(ipa);
+	if (IS_ERR(ipa->interrupt)) {
+		ret = PTR_ERR(ipa->interrupt);
+		goto err_gsi_teardown;
+	}
+	ipa_interrupt_add(ipa->interrupt, IPA_INTERRUPT_TX_SUSPEND,
+			  ipa_suspend_handler);
+
+	ipa_uc_setup(ipa);
+
+	ipa_endpoint_setup(ipa);
+
+	/* We need to use the AP command out endpoint to perform other
+	 * initialization, so we set that up first.
+	 */
+	ret = ipa_endpoint_enable_one(ipa->command_endpoint);
+	if (ret)
+		goto err_endpoint_teardown;
+
+	ret = ipa_smem_setup(ipa);
+	if (ret)
+		goto err_command_disable;
+
+	ret = ipa_route_setup(ipa);
+	if (ret)
+		goto err_smem_teardown;
+
+	ret = ipa_filter_setup(ipa);
+	if (ret)
+		goto err_route_teardown;
+
+	ret = ipa_endpoint_enable_one(ipa->default_endpoint);
+	if (ret)
+		goto err_filter_teardown;
+
+	rx_endpoint = &ipa->endpoint[IPA_ENDPOINT_AP_MODEM_RX];
+	tx_endpoint = &ipa->endpoint[IPA_ENDPOINT_AP_MODEM_TX];
+	ipa->modem_netdev = ipa_netdev_setup(ipa, rx_endpoint, tx_endpoint);
+	if (IS_ERR(ipa->modem_netdev)) {
+		ret = PTR_ERR(ipa->modem_netdev);
+		goto err_default_disable;
+	}
+
+	ipa->setup_complete = 1;
+
+	dev_info(&ipa->pdev->dev, "IPA driver setup completed successfully\n");
+
+	return 0;
+
+err_default_disable:
+	ipa_endpoint_disable_one(ipa->default_endpoint);
+err_filter_teardown:
+	ipa_filter_teardown(ipa);
+err_route_teardown:
+	ipa_route_teardown(ipa);
+err_smem_teardown:
+	ipa_smem_teardown(ipa);
+err_command_disable:
+	ipa_endpoint_disable_one(ipa->command_endpoint);
+err_endpoint_teardown:
+	ipa_endpoint_teardown(ipa);
+	ipa_uc_teardown(ipa);
+	ipa_interrupt_remove(ipa->interrupt, IPA_INTERRUPT_TX_SUSPEND);
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
+	ipa_netdev_teardown(ipa->modem_netdev);
+	ipa_endpoint_disable_one(ipa->default_endpoint);
+	ipa_filter_teardown(ipa);
+	ipa_route_teardown(ipa);
+	ipa_smem_teardown(ipa);
+	ipa_endpoint_disable_one(ipa->command_endpoint);
+	ipa_endpoint_teardown(ipa);
+	ipa_uc_teardown(ipa);
+	ipa_interrupt_remove(ipa->interrupt, IPA_INTERRUPT_TX_SUSPEND);
+	ipa_interrupt_teardown(ipa->interrupt);
+	gsi_teardown(&ipa->gsi);
+}
+
+/**
+ * ipa_hardware_config() - Primitive hardware initialization
+ * @ipa:	IPA pointer
+ */
+static void ipa_hardware_config(struct ipa *ipa)
+{
+	u32 val;
+
+	/* SDM845 has IPA version 3.5.1 */
+	val = IPA_BCR_REG_VAL;
+	iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
+
+	val = u32_encode_bits(8, GEN_QMB_0_MAX_WRITES_FMASK);
+	val |= u32_encode_bits(4, GEN_QMB_1_MAX_WRITES_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_WRITES_OFFSET);
+
+	val = u32_encode_bits(8, GEN_QMB_0_MAX_READS_FMASK);
+	val |= u32_encode_bits(12, GEN_QMB_1_MAX_READS_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_READS_OFFSET);
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
+	/* Values we program above are the same as the power-on reset values */
+}
+
+static void ipa_resource_config_src_one(struct ipa *ipa,
+					const struct ipa_resource_src *resource)
+{
+	u32 offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET;
+	u32 stride = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_STRIDE;
+	enum ipa_resource_type_src n = resource->type;
+	const struct ipa_resource_limits *xlimits;
+	const struct ipa_resource_limits *ylimits;
+	u32 val;
+
+	xlimits = &resource->limits[IPA_RESOURCE_GROUP_LWA_DL];
+	ylimits = &resource->limits[IPA_RESOURCE_GROUP_UL_DL];
+
+	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
+	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
+	val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
+	val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+
+	iowrite32(val, ipa->reg_virt + offset + n * stride);
+}
+
+static void ipa_resource_config_dst_one(struct ipa *ipa,
+					const struct ipa_resource_dst *resource)
+{
+	u32 offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET;
+	u32 stride = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_STRIDE;
+	enum ipa_resource_type_dst n = resource->type;
+	const struct ipa_resource_limits *xlimits;
+	const struct ipa_resource_limits *ylimits;
+	u32 val;
+
+	xlimits = &resource->limits[IPA_RESOURCE_GROUP_LWA_DL];
+	ylimits = &resource->limits[IPA_RESOURCE_GROUP_UL_DL];
+
+	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
+	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
+	val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
+	val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+
+	iowrite32(val, ipa->reg_virt + offset + n * stride);
+}
+
+static void
+ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
+{
+	const struct ipa_resource_src *resource_src;
+	const struct ipa_resource_dst *resource_dst;
+	u32 i;
+
+	resource_src = data->resource_src;
+	resource_dst = data->resource_dst;
+
+	for (i = 0; i < data->resource_src_count; i++)
+		ipa_resource_config_src_one(ipa, &resource_src[i]);
+
+	for (i = 0; i < data->resource_dst_count; i++)
+		ipa_resource_config_dst_one(ipa, &resource_dst[i]);
+}
+
+static void ipa_resource_deconfig(struct ipa *ipa)
+{
+	/* Nothing to do */
+}
+
+static void ipa_idle_indication_cfg(struct ipa *ipa,
+				    u32 enter_idle_debounce_thresh,
+				    bool const_non_idle_enable)
+{
+	u32 val;
+
+	val = u32_encode_bits(enter_idle_debounce_thresh,
+			      ENTER_IDLE_DEBOUNCE_THRESH_FMASK);
+	if (const_non_idle_enable)
+		val |= CONST_NON_IDLE_ENABLE_FMASK;
+
+	iowrite32(val, ipa->reg_virt + IPA_REG_IDLE_INDICATION_CFG_OFFSET);
+}
+
+/**
+ * ipa_dcd_config() - Enable dynamic clock division on IPA
+ *
+ * Configures when the IPA signals it is idle to the global clock
+ * controller, which can respond by scalling down the clock to
+ * save power.
+ */
+static void ipa_dcd_config(struct ipa *ipa)
+{
+	/* Recommended values for IPA 3.5 according to IPA HPG */
+	ipa_idle_indication_cfg(ipa, 256, false);
+}
+
+static void ipa_dcd_deconfig(struct ipa *ipa)
+{
+	/* Power-on reset values */
+	ipa_idle_indication_cfg(ipa, 0, true);
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
+	u32 val;
+	int ret;
+
+	/* Get a clock reference to allow initialization.  This reference
+	 * is held after initialization completes, and won't get dropped
+	 * unless/until a system suspend request arrives.
+	 */
+	atomic_set(&ipa->suspend_ref, 1);
+	ipa_clock_get(ipa->clock);
+
+	ipa_hardware_config(ipa);
+
+	/* Ensure we support the number of endpoints supplied by hardware */
+	val = ioread32(ipa->reg_virt + IPA_REG_ENABLED_PIPES_OFFSET);
+	if (val > IPA_ENDPOINT_MAX) {
+		ret = -EINVAL;
+		goto err_hardware_deconfig;
+	}
+
+	ret = ipa_smem_config(ipa);
+	if (ret)
+		goto err_hardware_deconfig;
+
+	/* Assign resource limitation to each group */
+	ipa_resource_config(ipa, data->resource_data);
+
+	/* Note enabling dynamic clock division must not be
+	 * attempted for IPA hardware versions prior to 3.5.
+	 */
+	ipa_dcd_config(ipa);
+
+	return 0;
+
+err_hardware_deconfig:
+	ipa_hardware_deconfig(ipa);
+	ipa_clock_put(ipa->clock);
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
+	ipa_dcd_deconfig(ipa);
+	ipa_resource_deconfig(ipa);
+	ipa_smem_deconfig(ipa);
+	ipa_hardware_deconfig(ipa);
+
+	ipa_clock_put(ipa->clock);
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
+		dev_err(dev, "memory-region not specified\n");
+		return -EINVAL;
+	}
+
+	ret = of_address_to_resource(node, 0, &res);
+	if (ret)
+		return ret;
+
+	ret = request_firmware(&fw, IPA_FWS_PATH, dev);
+	if (ret)
+		return ret;
+
+	phys = res.start;
+	size = (size_t)resource_size(&res);
+	virt = memremap(phys, size, MEMREMAP_WC);
+	if (!virt) {
+		ret = -ENOMEM;
+		goto out_release_firmware;
+	}
+
+	ret = qcom_mdt_load(dev, fw, IPA_FWS_PATH, IPA_PAS_ID,
+			    virt, phys, size, NULL);
+	if (!ret)
+		ret = qcom_scm_pas_auth_and_reset(IPA_PAS_ID);
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
+	{ },
+};
+
+/**
+ * ipa_probe() - IPA platform driver probe function
+ * @pdev:	Platform device pointer
+ *
+ * @Return:	0 if successful, or a negative error code (possibly
+ *		EPROBE_DEFER)
+ *
+ * This is the main entry point for the IPA driver.  When successful, it
+ * initializes the IPA hardware for use.
+ *
+ * Initialization proceeds in several stages.  The "init" stage involves
+ * activities that can be initialized without access to the IPA hardware.
+ * The "setup" stage requires the IPA clock to be active so IPA registers
+ * can beaccessed, but does not require access to the GSI layer.  The
+ * "setup" stage requires access to GSI, and includes initialization that's
+ * performed by issuing IPA immediate commands.
+ */
+static int ipa_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct ipa_data *data;
+	struct ipa *ipa;
+	bool modem_init;
+	int ret;
+
+	/* We assume we're working on 64-bit hardware */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_64BIT));
+	BUILD_BUG_ON(ARCH_DMA_MINALIGN % IPA_TABLE_ALIGN);
+
+	data = of_device_get_match_data(dev);
+
+	modem_init = of_property_read_bool(dev->of_node, "modem-init");
+
+	/* If we need Trust Zone, make sure it's ready */
+	if (!modem_init)
+		if (!qcom_scm_is_available())
+			return -EPROBE_DEFER;
+
+	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
+	if (!ipa)
+		return -ENOMEM;
+	ipa->pdev = pdev;
+	dev_set_drvdata(dev, ipa);
+
+	/* Initialize the clock and interconnects early.  They might
+	 * not be ready when we're probed, so might return -EPROBE_DEFER.
+	 */
+	atomic_set(&ipa->suspend_ref, 0);
+
+	ipa->clock = ipa_clock_init(ipa);
+	if (IS_ERR(ipa->clock)) {
+		ret = PTR_ERR(ipa->clock);
+		goto err_free_ipa;
+	}
+
+	ret = ipa_mem_init(ipa);
+	if (ret)
+		goto err_clock_exit;
+
+	ret = gsi_init(&ipa->gsi, pdev, data->endpoint_data_count,
+		       data->endpoint_data);
+	if (ret)
+		goto err_mem_exit;
+
+	ipa->smp2p = ipa_smp2p_init(ipa, modem_init);
+	if (IS_ERR(ipa->smp2p)) {
+		ret = PTR_ERR(ipa->smp2p);
+		goto err_gsi_exit;
+	}
+
+	ret = ipa_endpoint_init(ipa, data->endpoint_data_count,
+				data->endpoint_data);
+	if (ret)
+		goto err_smp2p_exit;
+	ipa->command_endpoint = &ipa->endpoint[IPA_ENDPOINT_AP_COMMAND_TX];
+	ipa->default_endpoint = &ipa->endpoint[IPA_ENDPOINT_AP_LAN_RX];
+
+	/* Create a wakeup source. */
+	wakeup_source_init(&ipa->wakeup, "ipa");
+
+	/* Proceed to real initialization */
+	ret = ipa_config(ipa, data);
+	if (ret)
+		goto err_endpoint_exit;
+
+	dev_info(dev, "IPA driver initialized");
+
+	/* If the modem is verifying and loading firmware, we're
+	 * done.  We will receive an SMP2P interrupt when it is OK
+	 * to proceed with the setup phase (involving issuing
+	 * immediate commands after GSI is initialized).
+	 */
+	if (modem_init)
+		return 0;
+
+	/* Otherwise we need to load the firmware and have Trust
+	 * Zone validate and install it.  If that succeeds we can
+	 * proceed with setup.
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
+err_endpoint_exit:
+	wakeup_source_remove(&ipa->wakeup);
+	ipa_endpoint_exit(ipa);
+err_smp2p_exit:
+	ipa_smp2p_exit(ipa->smp2p);
+err_gsi_exit:
+	gsi_exit(&ipa->gsi);
+err_mem_exit:
+	ipa_mem_exit(ipa);
+err_clock_exit:
+	ipa_clock_exit(ipa->clock);
+err_free_ipa:
+	kfree(ipa);
+
+	return ret;
+}
+
+static int ipa_remove(struct platform_device *pdev)
+{
+	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
+
+	ipa_smp2p_disable(ipa->smp2p);
+	if (ipa->setup_complete)
+		ipa_teardown(ipa);
+
+	ipa_deconfig(ipa);
+	wakeup_source_remove(&ipa->wakeup);
+	ipa_endpoint_exit(ipa);
+	ipa_smp2p_exit(ipa->smp2p);
+	ipa_mem_exit(ipa);
+	ipa_clock_exit(ipa->clock);
+	kfree(ipa);
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
+int ipa_suspend(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	ipa_clock_put(ipa->clock);
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
+int ipa_resume(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	/* This clock reference will keep the IPA out of suspend
+	 * until we get a power management suspend request.
+	 */
+	atomic_set(&ipa->suspend_ref, 1);
+	ipa_clock_get(ipa->clock);
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
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
new file mode 100644
index 000000000000..8d04db6f7b00
--- /dev/null
+++ b/drivers/net/ipa/ipa_reg.h
@@ -0,0 +1,279 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_REG_H_
+#define _IPA_REG_H_
+
+#include <linux/bits.h>
+
+/**
+ * DOC: IPA Registers
+ *
+ * IPA registers are located within the "ipa" address space defined by
+ * Device Tree.  The offset of each register within that space is specified
+ * by symbols defined below.  The address space is mapped to virtual memory
+ * space in ipa_mem_init().  All IPA registers are 32 bits wide.
+ *
+ * Certain register types are duplicated for a number of instances of
+ * something.  For example, each IPA endpoint has an set of registers
+ * defining its configuration.  The offset to an endpoint's set of registers
+ * is computed based on an "base" offset plus an additional "stride" offset
+ * that's dependent on the endpoint's ID.  For such registers, the offset
+ * is computed by a function-like macro that takes a parameter used in
+ * the computation.
+ *
+ * The offset of a register dependent on execution environment is computed
+ * by a macro that is supplied a parameter "ee".  The "ee" value is a member
+ * of the gsi_ee enumerated type.
+ *
+ * The offset of a register dependent on endpoint id is computed by a macro
+ * that is supplied a parameter "ep".  The "ep" value must be less than
+ * IPA_ENDPOINT_MAX.
+ *
+ * The offset of registers related to hashed filter and router tables is
+ * computed by a macro that is supplied a parameter "er".  The "er" represents
+ * an endpoint ID for filters, or a route ID for routes.  For filters, the
+ * endpoint ID must be less than IPA_ENDPOINT_MAX, but is further restricted
+ * because not all endpoints support filtering.  For routes, the route ID
+ * must be less than IPA_SMEM_RT_COUNT.
+ *
+ * Some registers encode multiple fields within them.  For these, each field
+ * has a symbol below definining a mask that defines both the position and
+ * width of the field within its register.
+ */
+
+#define IPA_REG_ENABLED_PIPES_OFFSET			0x00000038
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
+
+#define IPA_REG_STATE_AGGR_ACTIVE_OFFSET		0x0000010c
+
+#define IPA_REG_BCR_OFFSET				0x000001d0
+
+#define IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET	0x000001e8
+
+#define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
+#define PIPE_BITMAP_FMASK			GENMASK(19, 0)
+
+#define IPA_REG_IDLE_INDICATION_CFG_OFFSET		0x00000220
+#define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
+#define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
+
+#define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET	0x00000400
+#define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_STRIDE	0x0020
+#define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET	0x00000500
+#define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_STRIDE	0x0020
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
+#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(ep) \
+					(0x00000820 + 0x0070 * (ep))
+#define MODE_FMASK				GENMASK(2, 0)
+#define DEST_PIPE_INDEX_FMASK			GENMASK(8, 4)
+#define BYTE_THRESHOLD_FMASK			GENMASK(27, 12)
+#define PIPE_REPLICATION_EN_FMASK		GENMASK(28, 28)
+#define PAD_EN_FMASK				GENMASK(29, 29)
+#define HDR_FTCH_DISABLE_FMASK			GENMASK(30, 30)
+
+#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(ep) \
+					(0x00000834 + 0x0070 * (ep))
+#define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
+#define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
+#define PACKET_OFFSET_LOCATION_FMASK		GENMASK(13, 8)
+#define MAX_PACKET_LEN_FMASK			GENMASK(31, 16)
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
+#define FILTER_HASH_UNDEFINED1_FMASK		GENMASK(15, 7)
+#define IPA_REG_ENDP_FILTER_HASH_MSK_ALL	GENMASK(15, 0)
+
+#define ROUTER_HASH_MSK_SRC_ID_FMASK		GENMASK(16, 16)
+#define ROUTER_HASH_MSK_SRC_IP_FMASK		GENMASK(17, 17)
+#define ROUTER_HASH_MSK_DST_IP_FMASK		GENMASK(18, 18)
+#define ROUTER_HASH_MSK_SRC_PORT_FMASK		GENMASK(19, 19)
+#define ROUTER_HASH_MSK_DST_PORT_FMASK		GENMASK(20, 20)
+#define ROUTER_HASH_MSK_PROTOCOL_FMASK		GENMASK(21, 21)
+#define ROUTER_HASH_MSK_METADATA_FMASK		GENMASK(22, 22)
+#define ROUTER_HASH_UNDEFINED2_FMASK		GENMASK(31, 23)
+#define IPA_REG_ENDP_ROUTER_HASH_MSK_ALL	GENMASK(31, 16)
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
+
+#define IPA_REG_SUSPEND_IRQ_EN_OFFSET \
+				IPA_REG_SUSPEND_IRQ_EN_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_SUSPEND_IRQ_EN_EE_N_OFFSET(ee) \
+					(0x00003034 + 0x1000 * (ee))
+
+#define IPA_REG_SUSPEND_IRQ_CLR_OFFSET \
+				IPA_REG_SUSPEND_IRQ_CLR_EE_N_OFFSET(GSI_EE_AP)
+#define IPA_REG_SUSPEND_IRQ_CLR_EE_N_OFFSET(ee) \
+					(0x00003038 + 0x1000 * (ee))
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
+	IPA_MBIM_16 = 0,
+	IPA_HDLC    = 1,
+	IPA_TLP	    = 2,
+	IPA_RNDIS   = 3,
+	IPA_GENERIC = 4,
+	IPA_QCMAP   = 6,
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
+ */
+enum ipa_seq_type {
+	IPA_SEQ_DMA_ONLY			= 0x00,
+	IPA_SEQ_PKT_PROCESS_NO_DEC_UCP		= 0x02,
+	IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP	= 0x04,
+	IPA_SEQ_DMA_DEC				= 0x11,
+	IPA_SEQ_DMA_COMP_DECOMP			= 0x20,
+	IPA_SEQ_INVALID				= 0xff,
+};
+
+#endif /* _IPA_REG_H_ */
-- 
2.20.1

