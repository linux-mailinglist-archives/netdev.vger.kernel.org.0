Return-Path: <netdev+bounces-9800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E242272A9E4
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CF8A1C20B2D
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DF2A930;
	Sat, 10 Jun 2023 07:29:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E8A8836
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:29:14 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9D330F1
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:29:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5147e40bbbbso3787687a12.3
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686382149; x=1688974149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bCfVesusrgmkFpfwFyl6x8mUi/bS1gyIJl7RpzLtqYI=;
        b=DgsvCr4h7jZghI7GnDzpuinzURUb58Kgrb1BOfJW2yHNfgF48+whfAxpMs8Fv3zPCf
         HzAD2IUEPfvws4agIH3imeW72C0qF8hUh4UKQ0SB2pOZEqcAeI0gnQ568HcLJ6xeOqAc
         2KKqdcwWDXdd8LaGqCmEXYtNahqx5Ep+LYNh15bjSfwJmHA4JjsBJhi4j5j6m21J0QAg
         rixg4jL6mlT0cI1Gx9E2ctbfKr7q59LcDqlt3CPUKcrUn5fSNfVqEreKaZ757CKOzIA1
         hTnL2TzWnuH2H2rogdSQdSTgsfAPcQrdC8zWj4gdq6pPuykQjriBOqr+UYvOs+SJCx7o
         AENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686382149; x=1688974149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCfVesusrgmkFpfwFyl6x8mUi/bS1gyIJl7RpzLtqYI=;
        b=XnBVT7dH41Phf5z2PweYyk2auqQzFeIckng1Ru/cFXj6cRszXk0y7AuYHVj9IbfZiQ
         enYs+7iSijLWVobLXgpSc/hIGeRLKtoEwrdhkKI74wmAKDvSkM1QRW0SmRe0F3lj6qzo
         232gV/ui01j0Udl3AUs2ZRKoKHXpnaFrUaPaD5wqgz3NhP7RF7ZQnDZdScZWkZcSaZko
         jJj/e0GlfxrqDoanbqUqbYWk8w/b0ZBGaqAThZf3h9JFlG8/yISy+snMnCODRwUHvUS6
         Fhk/++lYth03SGWkSqLW2n3ptNFCUKEzLO/1bIVFaRey7x7MCfkEFIFylMHEpkhn8y4G
         xMOg==
X-Gm-Message-State: AC+VfDzShsB813+gf1RK4bvE3l+k6xVAj7Vnhm0YeYEZuhuzktpdBQeg
	pzZkBszGbE9LhkBONHVhT2k0aA==
X-Google-Smtp-Source: ACHHUZ5NatzZlIx+OQ4kzbAOdyjlfaNiTBKgd8AUnu2eAYgPO5zNQOEu3+k0VSOdEJlu9zm6knajjw==
X-Received: by 2002:aa7:d703:0:b0:514:95e8:566c with SMTP id t3-20020aa7d703000000b0051495e8566cmr515118edq.42.1686382149280;
        Sat, 10 Jun 2023 00:29:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id dy28-20020a05640231fc00b0050bc6c04a66sm2574299edb.40.2023.06.10.00.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 00:29:08 -0700 (PDT)
Date: Sat, 10 Jun 2023 09:29:07 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: kuba@kernel.org, vadfed@meta.com, jonathan.lemon@gmail.com,
	pabeni@redhat.com, corbet@lwn.net, davem@davemloft.net,
	edumazet@google.com, vadfed@fb.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, saeedm@nvidia.com, leon@kernel.org,
	richardcochran@gmail.com, sj@kernel.org, javierm@redhat.com,
	ricardo.canuelo@collabora.com, mst@redhat.com, tzimmermann@suse.de,
	michal.michalik@intel.com, gregkh@linuxfoundation.org,
	jacek.lawrynowicz@linux.intel.com, airlied@redhat.com,
	ogabbay@kernel.org, arnd@arndb.de, nipun.gupta@amd.com,
	axboe@kernel.dk, linux@zary.sk, masahiroy@kernel.org,
	benjamin.tissoires@redhat.com, geert+renesas@glider.be,
	milena.olech@intel.com, kuniyu@amazon.com, liuhangbin@gmail.com,
	hkallweit1@gmail.com, andy.ren@getcruise.com, razor@blackwall.org,
	idosch@nvidia.com, lucien.xin@gmail.com, nicolas.dichtel@6wind.com,
	phil@nwl.cc, claudiajkang@gmail.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, poros@redhat.com,
	mschmidt@redhat.com, linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev
Subject: Re: [RFC PATCH v8 05/10] dpll: api header: Add DPLL framework base
 functions
Message-ID: <ZIQmQ1NLFSPADVlA@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-6-arkadiusz.kubalewski@intel.com>
 <ZIQlhyXJAtcp1Fjr@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIQlhyXJAtcp1Fjr@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sat, Jun 10, 2023 at 09:25:59AM CEST, jiri@resnulli.us wrote:
>Fri, Jun 09, 2023 at 02:18:48PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>
>>DPLL framework is used to represent and configure DPLL devices
>>in systems. Each device that has DPLL and can configure sources
>>and outputs can use this framework. Netlink interface is used to
>>provide configuration data and to receive notification messages
>>about changes in the configuration or status of DPLL device.
>>Inputs and outputs of the DPLL device are represented as special
>>objects which could be dynamically added to and removed from DPLL
>>device.
>>
>>Add kernel api header, make dpll subsystem available to device drivers.
>>
>>Add/update makefiles/Kconfig to allow compilation of dpll subsystem.
>>
>>Co-developed-by: Milena Olech <milena.olech@intel.com>
>>Signed-off-by: Milena Olech <milena.olech@intel.com>
>>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>---
>> MAINTAINERS           |   8 +++
>> drivers/Kconfig       |   2 +
>> drivers/Makefile      |   1 +
>> drivers/dpll/Kconfig  |   7 ++
>> drivers/dpll/Makefile |   9 +++
>> include/linux/dpll.h  | 144 ++++++++++++++++++++++++++++++++++++++++++
>> 6 files changed, 171 insertions(+)
>> create mode 100644 drivers/dpll/Kconfig
>> create mode 100644 drivers/dpll/Makefile
>> create mode 100644 include/linux/dpll.h
>>
>>diff --git a/MAINTAINERS b/MAINTAINERS
>>index 288d9a5edb9d..0e69429ecc55 100644
>>--- a/MAINTAINERS
>>+++ b/MAINTAINERS
>>@@ -6306,6 +6306,14 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
>> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
>> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
>> 
>>+DPLL CLOCK SUBSYSTEM
>>+M:	Vadim Fedorenko <vadfed@fb.com>
>>+L:	netdev@vger.kernel.org
>>+S:	Maintained
>
>I think status should be rather "Supported":
>"Supported:   Someone is actually paid to look after this."
>
>Also, I think that it would be good to have Arkadiusz Kubalewski
>listed here, as he is the one that knows the subsystem by heart.
>
>Also, if you don't mind, I would be happy as a co-maintainer of the
>subsystem to be listed here, as I helped to shape the code and
>interfaces and I also know it pretty good.
>
>
>
>>+F:	drivers/dpll/*
>>+F:	include/net/dpll.h
>>+F:	include/uapi/linux/dpll.h
>>+
>> DRBD DRIVER
>> M:	Philipp Reisner <philipp.reisner@linbit.com>
>> M:	Lars Ellenberg <lars.ellenberg@linbit.com>
>>diff --git a/drivers/Kconfig b/drivers/Kconfig
>>index 514ae6b24cb2..ce5f63918eba 100644
>>--- a/drivers/Kconfig
>>+++ b/drivers/Kconfig
>>@@ -243,4 +243,6 @@ source "drivers/hte/Kconfig"
>> 
>> source "drivers/cdx/Kconfig"
>> 
>>+source "drivers/dpll/Kconfig"
>>+
>> endmenu
>>diff --git a/drivers/Makefile b/drivers/Makefile
>>index 7241d80a7b29..6fea42a6dd05 100644
>>--- a/drivers/Makefile
>>+++ b/drivers/Makefile
>>@@ -195,3 +195,4 @@ obj-$(CONFIG_PECI)		+= peci/
>> obj-$(CONFIG_HTE)		+= hte/
>> obj-$(CONFIG_DRM_ACCEL)		+= accel/
>> obj-$(CONFIG_CDX_BUS)		+= cdx/
>>+obj-$(CONFIG_DPLL)		+= dpll/
>>diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
>>new file mode 100644
>>index 000000000000..a4cae73f20d3
>>--- /dev/null
>>+++ b/drivers/dpll/Kconfig
>>@@ -0,0 +1,7 @@
>>+# SPDX-License-Identifier: GPL-2.0-only
>>+#
>>+# Generic DPLL drivers configuration
>>+#
>>+
>>+config DPLL
>>+  bool
>>diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>>new file mode 100644
>>index 000000000000..2e5b27850110
>>--- /dev/null
>>+++ b/drivers/dpll/Makefile
>>@@ -0,0 +1,9 @@
>>+# SPDX-License-Identifier: GPL-2.0
>>+#
>>+# Makefile for DPLL drivers.
>>+#
>>+
>>+obj-$(CONFIG_DPLL)      += dpll.o
>>+dpll-y                  += dpll_core.o
>>+dpll-y                  += dpll_netlink.o
>>+dpll-y                  += dpll_nl.o
>>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>>new file mode 100644
>>index 000000000000..a18bcaa13553
>>--- /dev/null
>>+++ b/include/linux/dpll.h
>>@@ -0,0 +1,144 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>>+ *  Copyright (c) 2023 Intel and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_H__
>>+#define __DPLL_H__
>>+
>>+#include <uapi/linux/dpll.h>
>>+#include <linux/device.h>
>>+#include <linux/netlink.h>
>>+
>>+struct dpll_device;
>>+struct dpll_pin;
>>+
>>+struct dpll_device_ops {
>>+	int (*mode_get)(const struct dpll_device *dpll, void *dpll_priv,
>>+			enum dpll_mode *mode, struct netlink_ext_ack *extack);
>>+	int (*mode_set)(const struct dpll_device *dpll, void *dpll_priv,
>>+			const enum dpll_mode mode,
>>+			struct netlink_ext_ack *extack);
>>+	bool (*mode_supported)(const struct dpll_device *dpll, void *dpll_priv,
>>+			       const enum dpll_mode mode,
>>+			       struct netlink_ext_ack *extack);
>>+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
>>+				  void *dpll_priv,
>>+				  u32 *pin_idx,
>>+				  struct netlink_ext_ack *extack);
>>+	int (*lock_status_get)(const struct dpll_device *dpll, void *dpll_priv,
>>+			       enum dpll_lock_status *status,
>>+			       struct netlink_ext_ack *extack);
>>+	int (*temp_get)(const struct dpll_device *dpll, void *dpll_priv,
>>+			s32 *temp, struct netlink_ext_ack *extack);
>>+};
>>+
>>+struct dpll_pin_ops {
>>+	int (*frequency_set)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     const u64 frequency,
>>+			     struct netlink_ext_ack *extack);
>>+	int (*frequency_get)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     u64 *frequency, struct netlink_ext_ack *extack);
>>+	int (*direction_set)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     const enum dpll_pin_direction direction,
>>+			     struct netlink_ext_ack *extack);
>>+	int (*direction_get)(const struct dpll_pin *pin, void *pin_priv,
>>+			     const struct dpll_device *dpll, void *dpll_priv,
>>+			     enum dpll_pin_direction *direction,
>>+			     struct netlink_ext_ack *extack);
>>+	int (*state_on_pin_get)(const struct dpll_pin *pin, void *pin_priv,
>>+				const struct dpll_pin *parent_pin,
>>+				void *parent_pin_priv,
>>+				enum dpll_pin_state *state,
>>+				struct netlink_ext_ack *extack);
>>+	int (*state_on_dpll_get)(const struct dpll_pin *pin, void *pin_priv,
>>+				 const struct dpll_device *dpll,
>>+				 void *dpll_priv, enum dpll_pin_state *state,
>>+				 struct netlink_ext_ack *extack);
>>+	int (*state_on_pin_set)(const struct dpll_pin *pin, void *pin_priv,
>>+				const struct dpll_pin *parent_pin,
>>+				void *parent_pin_priv,
>>+				const enum dpll_pin_state state,
>>+				struct netlink_ext_ack *extack);
>>+	int (*state_on_dpll_set)(const struct dpll_pin *pin, void *pin_priv,
>>+				 const struct dpll_device *dpll,
>>+				 void *dpll_priv,
>>+				 const enum dpll_pin_state state,
>>+				 struct netlink_ext_ack *extack);
>>+	int (*prio_get)(const struct dpll_pin *pin,  void *pin_priv,
>>+			const struct dpll_device *dpll,  void *dpll_priv,
>>+			u32 *prio, struct netlink_ext_ack *extack);
>>+	int (*prio_set)(const struct dpll_pin *pin, void *pin_priv,
>>+			const struct dpll_device *dpll, void *dpll_priv,
>>+			const u32 prio, struct netlink_ext_ack *extack);
>>+};
>>+
>>+struct dpll_pin_frequency {
>>+	u64 min;
>>+	u64 max;
>>+};
>>+
>>+#define DPLL_PIN_FREQUENCY_RANGE(_min, _max)	\
>>+	{					\
>>+		.min = _min,			\
>>+		.max = _max,			\
>>+	}
>>+
>>+#define DPLL_PIN_FREQUENCY(_val) DPLL_PIN_FREQUENCY_RANGE(_val, _val)
>>+#define DPLL_PIN_FREQUENCY_1PPS \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_1_HZ)
>>+#define DPLL_PIN_FREQUENCY_10MHZ \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_10_MHZ)
>>+#define DPLL_PIN_FREQUENCY_IRIG_B \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_10_KHZ)
>>+#define DPLL_PIN_FREQUENCY_DCF77 \
>>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_77_5_KHZ)
>>+
>>+struct dpll_pin_properties {
>>+	const char *board_label;
>>+	const char *panel_label;
>>+	const char *package_label;
>>+	enum dpll_pin_type type;
>>+	unsigned long capabilities;
>>+	u32 freq_supported_num;
>>+	struct dpll_pin_frequency *freq_supported;
>>+};
>>+
>>+struct dpll_device
>>+*dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module);
>>+
>>+void dpll_device_put(struct dpll_device *dpll);
>>+
>>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>>+			 const struct dpll_device_ops *ops, void *priv);
>>+
>>+void dpll_device_unregister(struct dpll_device *dpll,
>>+			    const struct dpll_device_ops *ops, void *priv);
>>+
>>+struct dpll_pin
>>+*dpll_pin_get(u64 clock_id, u32 dev_driver_id, struct module *module,
>>+	      const struct dpll_pin_properties *prop);
>>+
>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      const struct dpll_pin_ops *ops, void *priv);
>>+
>>+void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>>+			 const struct dpll_pin_ops *ops, void *priv);
>>+
>>+void dpll_pin_put(struct dpll_pin *pin);
>>+
>>+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
>>+			     const struct dpll_pin_ops *ops, void *priv);
>>+
>>+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
>>+				const struct dpll_pin_ops *ops, void *priv);
>>+
>>+int dpll_device_change_ntf(struct dpll_device *dpll);
>>+
>>+int dpll_pin_change_ntf(struct dpll_pin *pin);
>
>Why exactly did you split this into a separate patch? To me, it does not
>make any sense. Please squash this header addition to the 

..Hit send be mistake.

Please squash this header addition to the patch where you actually
introcude the functions. Since you define a lot of structures here, I
believe that without this patch things are not compilable and breat
dissection. Makes me wonder why you did this split...


>
>
>>+
>>+#endif
>>-- 
>>2.37.3
>>

