Return-Path: <netdev+bounces-9520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94987299A6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 173D81C2112B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7F11643B;
	Fri,  9 Jun 2023 12:22:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDDB16436
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:22:00 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E612D72;
	Fri,  9 Jun 2023 05:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686313316; x=1717849316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9CriNJFuqJGyU2nYSkzF/FQkUQXpHMfSkIHHB7T0wdc=;
  b=j66Bb5DsJYDrO+h2D9f70gOp3sTP6+zI9s1IMj+WRdRmF1961Ueac1xP
   U5zOyKZJwoI6xScrJyJq6nnX3xcl64iXX+YV3fG0j/GnIvZGq/oiRPyUL
   VHEpx7CzKXPQmUa4dol70hYfQZKyjaue2fCkIK9Kw0qNv7GORL/fgRqXd
   hPKkOBhROI+BAxpU7kyJhwWEF0Qc1iZQN6rekrXP5EyM3KizAuY7Df3YL
   KEhmmMjL8NZOIPkQ8c3c+j8QZd1Iu2zqdFENspO7wGDlF2AcsFFDeCmY+
   pE4lgXutOLVict+KxfQiuqqajzsBk+RbyGrz5HHFduDHAyxgKBDp5Q27X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337220150"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337220150"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="710348539"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="710348539"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2023 05:21:34 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: kuba@kernel.org,
	jiri@resnulli.us,
	arkadiusz.kubalewski@intel.com,
	vadfed@meta.com,
	jonathan.lemon@gmail.com,
	pabeni@redhat.com
Cc: corbet@lwn.net,
	davem@davemloft.net,
	edumazet@google.com,
	vadfed@fb.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	richardcochran@gmail.com,
	sj@kernel.org,
	javierm@redhat.com,
	ricardo.canuelo@collabora.com,
	mst@redhat.com,
	tzimmermann@suse.de,
	michal.michalik@intel.com,
	gregkh@linuxfoundation.org,
	jacek.lawrynowicz@linux.intel.com,
	airlied@redhat.com,
	ogabbay@kernel.org,
	arnd@arndb.de,
	nipun.gupta@amd.com,
	axboe@kernel.dk,
	linux@zary.sk,
	masahiroy@kernel.org,
	benjamin.tissoires@redhat.com,
	geert+renesas@glider.be,
	milena.olech@intel.com,
	kuniyu@amazon.com,
	liuhangbin@gmail.com,
	hkallweit1@gmail.com,
	andy.ren@getcruise.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	lucien.xin@gmail.com,
	nicolas.dichtel@6wind.com,
	phil@nwl.cc,
	claudiajkang@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	poros@redhat.com,
	mschmidt@redhat.com,
	linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev
Subject: [RFC PATCH v8 04/10] dpll: netlink: Add DPLL framework base functions
Date: Fri,  9 Jun 2023 14:18:47 +0200
Message-Id: <20230609121853.3607724-5-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

DPLL framework is used to represent and configure DPLL devices
in systems. Each device that has DPLL and can configure inputs
and outputs can use this framework.

Implement dpll netlink framework functions for enablement of dpll
subsytem netlink family.

Co-developed-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Milena Olech <milena.olech@intel.com>
Co-developed-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 drivers/dpll/dpll_netlink.c | 1183 +++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |   44 ++
 2 files changed, 1227 insertions(+)
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
new file mode 100644
index 000000000000..44d9699c9e6c
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.c
@@ -0,0 +1,1183 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic netlink for DPLL management framework
+ *
+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
+ *  Copyright (c) 2023 Intel and affiliates
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <net/genetlink.h>
+#include "dpll_core.h"
+#include "dpll_nl.h"
+#include <uapi/linux/dpll.h>
+
+static int __dpll_pin_change_ntf(struct dpll_pin *pin);
+
+struct dpll_dump_ctx {
+	unsigned long idx;
+};
+
+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *cb)
+{
+	return (struct dpll_dump_ctx *)cb->ctx;
+}
+
+static int
+dpll_msg_add_dev_handle(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_mode(struct sk_buff *msg, struct dpll_device *dpll,
+		  struct netlink_ext_ack *extack)
+{
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
+	enum dpll_mode mode;
+
+	if (WARN_ON(!ops->mode_get))
+		return -EOPNOTSUPP;
+	if (ops->mode_get(dpll, dpll_priv(dpll), &mode, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_MODE, mode))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_device *dpll,
+			 struct netlink_ext_ack *extack)
+{
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
+	enum dpll_lock_status status;
+
+	if (WARN_ON(!ops->lock_status_get))
+		return -EOPNOTSUPP;
+	if (ops->lock_status_get(dpll, dpll_priv(dpll), &status, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_LOCK_STATUS, status))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll,
+		  struct netlink_ext_ack *extack)
+{
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
+	s32 temp;
+
+	if (!ops->temp_get)
+		return -EOPNOTSUPP;
+	if (ops->temp_get(dpll, dpll_priv(dpll), &temp, extack))
+		return -EFAULT;
+	if (nla_put_s32(msg, DPLL_A_TEMP, temp))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_prio(struct sk_buff *msg, struct dpll_pin *pin,
+		      struct dpll_pin_ref *ref,
+		      struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+	struct dpll_device *dpll = ref->dpll;
+	u32 prio;
+
+	if (!ops->prio_get)
+		return -EOPNOTSUPP;
+	if (ops->prio_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
+			  dpll_priv(dpll), &prio, extack))
+		return -EFAULT;
+	if (nla_put_u32(msg, DPLL_A_PIN_PRIO, prio))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, struct dpll_pin *pin,
+			       struct dpll_pin_ref *ref,
+			       struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+	struct dpll_device *dpll = ref->dpll;
+	enum dpll_pin_state state;
+
+	if (!ops->state_on_dpll_get)
+		return -EOPNOTSUPP;
+	if (ops->state_on_dpll_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
+				   dpll_priv(dpll), &state, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_PIN_STATE, state))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_direction(struct sk_buff *msg, struct dpll_pin *pin,
+			   struct dpll_pin_ref *ref,
+			   struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+	struct dpll_device *dpll = ref->dpll;
+	enum dpll_pin_direction direction;
+
+	if (!ops->direction_get)
+		return -EOPNOTSUPP;
+	if (ops->direction_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
+			       dpll_priv(dpll), &direction, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_freq(struct sk_buff *msg, struct dpll_pin *pin,
+		      struct dpll_pin_ref *ref, struct netlink_ext_ack *extack,
+		      bool dump_freq_supported)
+{
+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+	struct dpll_device *dpll = ref->dpll;
+	struct nlattr *nest;
+	u64 freq;
+	int fs;
+
+	if (!ops->frequency_get)
+		return -EOPNOTSUPP;
+	if (ops->frequency_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
+			       dpll_priv(dpll), &freq, extack))
+		return -EFAULT;
+	if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY, sizeof(freq), &freq, 0))
+		return -EMSGSIZE;
+	if (!dump_freq_supported)
+		return 0;
+	for (fs = 0; fs < pin->prop->freq_supported_num; fs++) {
+		nest = nla_nest_start(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED);
+		if (!nest)
+			return -EMSGSIZE;
+		freq = pin->prop->freq_supported[fs].min;
+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MIN, sizeof(freq),
+				   &freq, 0)) {
+			nla_nest_cancel(msg, nest);
+			return -EMSGSIZE;
+		}
+		freq = pin->prop->freq_supported[fs].max;
+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MAX, sizeof(freq),
+				   &freq, 0)) {
+			nla_nest_cancel(msg, nest);
+			return -EMSGSIZE;
+		}
+		nla_nest_end(msg, nest);
+	}
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_parents(struct sk_buff *msg, struct dpll_pin *pin,
+			 struct dpll_pin_ref *dpll_ref,
+			 struct netlink_ext_ack *extack)
+{
+	enum dpll_pin_state state;
+	struct dpll_pin_ref *ref;
+	struct dpll_pin *ppin;
+	struct nlattr *nest;
+	unsigned long index;
+	int ret;
+
+	xa_for_each(&pin->parent_refs, index, ref) {
+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+		void *parent_priv;
+
+		ppin = ref->pin;
+		parent_priv = dpll_pin_on_dpll_priv(dpll_ref->dpll, ppin);
+		if (WARN_ON(!ops->state_on_pin_get))
+			return -EFAULT;
+		ret = ops->state_on_pin_get(pin,
+					    dpll_pin_on_pin_priv(ppin, pin),
+					    ppin, parent_priv, &state, extack);
+		if (ret)
+			return -EFAULT;
+		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
+		if (!nest)
+			return -EMSGSIZE;
+		if (nla_put_u32(msg, DPLL_A_PIN_ID, ppin->id)) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		nla_nest_end(msg, nest);
+	}
+
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(msg, nest);
+	return ret;
+}
+
+static int
+dpll_msg_add_pin_dplls(struct sk_buff *msg, struct dpll_pin *pin,
+		       struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	struct nlattr *attr;
+	unsigned long index;
+	int ret;
+
+	xa_for_each(&pin->dpll_refs, index, ref) {
+		attr = nla_nest_start(msg, DPLL_A_PIN_PARENT);
+		if (!attr)
+			return -EMSGSIZE;
+		ret = dpll_msg_add_dev_handle(msg, ref->dpll);
+		if (ret)
+			goto nest_cancel;
+		ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
+		if (ret && ret != -EOPNOTSUPP)
+			goto nest_cancel;
+		ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
+		if (ret && ret != -EOPNOTSUPP)
+			goto nest_cancel;
+		ret = dpll_msg_add_pin_direction(msg, pin, ref, extack);
+		if (ret)
+			goto nest_cancel;
+		nla_nest_end(msg, attr);
+	}
+
+	return 0;
+
+nest_cancel:
+	nla_nest_end(msg, attr);
+	return ret;
+}
+
+static int
+dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
+			  struct dpll_pin_ref *ref, struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_properties *prop = pin->prop;
+	int ret;
+
+	if (nla_put_u32(msg, DPLL_A_PIN_ID, pin->id))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, DPLL_A_MODULE_NAME, module_name(pin->module)))
+		return -EMSGSIZE;
+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(pin->clock_id),
+			  &pin->clock_id, 0))
+		return -EMSGSIZE;
+	if (prop->board_label &&
+	    nla_put_string(msg, DPLL_A_PIN_BOARD_LABEL, prop->board_label))
+		return -EMSGSIZE;
+	if (prop->panel_label &&
+	    nla_put_string(msg, DPLL_A_PIN_PANEL_LABEL, prop->panel_label))
+		return -EMSGSIZE;
+	if (prop->package_label &&
+	    nla_put_string(msg, DPLL_A_PIN_PACKAGE_LABEL,
+			   prop->package_label))
+		return -EMSGSIZE;
+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, prop->type))
+		return -EMSGSIZE;
+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, prop->capabilities))
+		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_freq(msg, pin, ref, extack, true);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	return 0;
+}
+
+static int
+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
+			struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	int ret;
+
+	ref = dpll_xa_ref_dpll_first(&pin->dpll_refs);
+	if (!ref)
+		return -EFAULT;
+	ret = dpll_cmd_pin_fill_details(msg, pin, ref, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_parents(msg, pin, ref, extack);
+	if (ret)
+		return ret;
+	if (!xa_empty(&pin->dpll_refs)) {
+		ret = dpll_msg_add_pin_dplls(msg, pin, extack);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+dpll_device_get_one(struct dpll_device *dpll, struct sk_buff *msg,
+		    struct netlink_ext_ack *extack)
+{
+	enum dpll_mode mode;
+	int ret;
+
+	ret = dpll_msg_add_dev_handle(msg, dpll);
+	if (ret)
+		return ret;
+	if (nla_put_string(msg, DPLL_A_MODULE_NAME, module_name(dpll->module)))
+		return -EMSGSIZE;
+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(dpll->clock_id),
+			  &dpll->clock_id, 0))
+		return -EMSGSIZE;
+	ret = dpll_msg_add_temp(msg, dpll, extack);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	ret = dpll_msg_add_lock_status(msg, dpll, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_mode(msg, dpll, extack);
+	if (ret)
+		return ret;
+	for (mode = DPLL_MODE_MANUAL; mode <= DPLL_MODE_MAX; mode++)
+		if (test_bit(mode, &dpll->mode_supported_mask))
+			if (nla_put_s32(msg, DPLL_A_MODE_SUPPORTED, mode))
+				return -EMSGSIZE;
+	if (nla_put_u8(msg, DPLL_A_TYPE, dpll->type))
+		return -EMSGSIZE;
+
+	return ret;
+}
+
+static bool dpll_pin_is_freq_supported(struct dpll_pin *pin, u32 freq)
+{
+	int fs;
+
+	for (fs = 0; fs < pin->prop->freq_supported_num; fs++)
+		if (freq >=  pin->prop->freq_supported[fs].min &&
+		    freq <=  pin->prop->freq_supported[fs].max)
+			return true;
+	return false;
+}
+
+static int
+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
+		  struct netlink_ext_ack *extack)
+{
+	u64 freq = nla_get_u64(a);
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+	int ret;
+
+	if (!dpll_pin_is_freq_supported(pin, freq))
+		return -EINVAL;
+
+	xa_for_each(&pin->dpll_refs, i, ref) {
+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
+		struct dpll_device *dpll = ref->dpll;
+
+		if (!ops->frequency_set)
+			return -EOPNOTSUPP;
+		ret = ops->frequency_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
+					 dpll, dpll_priv(dpll), freq, extack);
+		if (ret)
+			return -EFAULT;
+		__dpll_pin_change_ntf(pin);
+	}
+
+	return 0;
+}
+
+static int
+dpll_pin_on_pin_state_set(struct dpll_pin *pin, u32 parent_idx,
+			  enum dpll_pin_state state,
+			  struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *parent_ref;
+	const struct dpll_pin_ops *ops;
+	struct dpll_pin_ref *dpll_ref;
+	struct dpll_pin *parent;
+	unsigned long i;
+
+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop->capabilities))
+		return -EOPNOTSUPP;
+	parent = xa_load(&dpll_pin_xa, parent_idx);
+	if (!parent)
+		return -EINVAL;
+	parent_ref = xa_load(&pin->parent_refs, parent->pin_idx);
+	if (!parent_ref)
+		return -EINVAL;
+	xa_for_each(&parent->dpll_refs, i, dpll_ref) {
+		ops = dpll_pin_ops(parent_ref);
+		if (!ops->state_on_pin_set)
+			return -EOPNOTSUPP;
+		if (ops->state_on_pin_set(pin,
+					  dpll_pin_on_pin_priv(parent, pin),
+					  parent,
+					  dpll_pin_on_dpll_priv(dpll_ref->dpll,
+								parent),
+					  state, extack))
+			return -EFAULT;
+	}
+	__dpll_pin_change_ntf(pin);
+
+	return 0;
+}
+
+static int
+dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
+		   enum dpll_pin_state state,
+		   struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_ops *ops;
+	struct dpll_pin_ref *ref;
+
+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop->capabilities))
+		return -EOPNOTSUPP;
+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
+	if (!ref)
+		return -EFAULT;
+	ops = dpll_pin_ops(ref);
+	if (!ops->state_on_dpll_set)
+		return -EOPNOTSUPP;
+	if (ops->state_on_dpll_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
+				   dpll_priv(dpll), state, extack))
+		return -EINVAL;
+	__dpll_pin_change_ntf(pin);
+
+	return 0;
+}
+
+static int
+dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
+		  u32 prio, struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_ops *ops;
+	struct dpll_pin_ref *ref;
+
+	if (!(DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE & pin->prop->capabilities))
+		return -EOPNOTSUPP;
+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
+	if (!ref)
+		return -EFAULT;
+	ops = dpll_pin_ops(ref);
+	if (!ops->prio_set)
+		return -EOPNOTSUPP;
+	if (ops->prio_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
+			  dpll_priv(dpll), prio, extack))
+		return -EINVAL;
+	__dpll_pin_change_ntf(pin);
+
+	return 0;
+}
+
+static int
+dpll_pin_direction_set(struct dpll_pin *pin, struct dpll_device *dpll,
+		       enum dpll_pin_direction direction,
+		       struct netlink_ext_ack *extack)
+{
+	const struct dpll_pin_ops *ops;
+	struct dpll_pin_ref *ref;
+
+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop->capabilities))
+		return -EOPNOTSUPP;
+
+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
+	if (!ref)
+		return -EFAULT;
+	ops = dpll_pin_ops(ref);
+	if (!ops->direction_set)
+		return -EOPNOTSUPP;
+	if (ops->direction_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
+			       dpll, dpll_priv(dpll), direction,
+			       extack))
+		return -EFAULT;
+	__dpll_pin_change_ntf(pin);
+
+	return 0;
+}
+
+static int
+dpll_pin_parent_set(struct dpll_pin *pin, struct nlattr *parent_nest,
+		    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[DPLL_A_MAX + 1];
+	enum dpll_pin_direction direction;
+	u32 ppin_idx, pdpll_idx, prio;
+	enum dpll_pin_state state;
+	struct dpll_pin_ref *ref;
+	struct dpll_device *dpll;
+	int ret;
+
+	nla_parse_nested(tb, DPLL_A_MAX, parent_nest,
+			 NULL, extack);
+	if ((tb[DPLL_A_ID] && tb[DPLL_A_PIN_ID]) ||
+	    !(tb[DPLL_A_ID] || tb[DPLL_A_PIN_ID])) {
+		NL_SET_ERR_MSG(extack, "one parent id expected");
+		return -EINVAL;
+	}
+	if (tb[DPLL_A_ID]) {
+		pdpll_idx = nla_get_u32(tb[DPLL_A_ID]);
+		dpll = xa_load(&dpll_device_xa, pdpll_idx);
+		if (!dpll)
+			return -EINVAL;
+		ref = xa_load(&pin->dpll_refs, dpll->device_idx);
+		if (!ref)
+			return -EINVAL;
+		if (tb[DPLL_A_PIN_STATE]) {
+			state = nla_get_u8(tb[DPLL_A_PIN_STATE]);
+			ret = dpll_pin_state_set(dpll, pin, state, extack);
+			if (ret)
+				return ret;
+		}
+		if (tb[DPLL_A_PIN_PRIO]) {
+			prio = nla_get_u8(tb[DPLL_A_PIN_PRIO]);
+			ret = dpll_pin_prio_set(dpll, pin, prio, extack);
+			if (ret)
+				return ret;
+		}
+		if (tb[DPLL_A_PIN_DIRECTION]) {
+			direction = nla_get_u8(tb[DPLL_A_PIN_DIRECTION]);
+			ret = dpll_pin_direction_set(pin, dpll, direction,
+						     extack);
+			if (ret)
+				return ret;
+		}
+	} else if (tb[DPLL_A_PIN_ID]) {
+		ppin_idx = nla_get_u32(tb[DPLL_A_PIN_ID]);
+		state = nla_get_u8(tb[DPLL_A_PIN_STATE]);
+		ret = dpll_pin_on_pin_state_set(pin, ppin_idx, state, extack);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+dpll_pin_set_from_nlattr(struct dpll_pin *pin, struct genl_info *info)
+{
+	int rem, ret = -EINVAL;
+	struct nlattr *a;
+
+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(a)) {
+		case DPLL_A_PIN_FREQUENCY:
+			ret = dpll_pin_freq_set(pin, a, info->extack);
+			if (ret)
+				return ret;
+			break;
+		case DPLL_A_PIN_PARENT:
+			ret = dpll_pin_parent_set(pin, a, info->extack);
+			if (ret)
+				return ret;
+			break;
+		case DPLL_A_PIN_ID:
+		case DPLL_A_ID:
+			break;
+		default:
+			NL_SET_ERR_MSG_FMT(info->extack,
+					   "unsupported attribute (%d)",
+					   nla_type(a));
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static struct dpll_pin *
+dpll_pin_find(u64 clock_id, struct nlattr *mod_name_attr,
+	      enum dpll_pin_type type, struct nlattr *board_label,
+	      struct nlattr *panel_label, struct nlattr *package_label)
+{
+	bool board_match, panel_match, package_match;
+	struct dpll_pin *pin_match = NULL, *pin;
+	const struct dpll_pin_properties *prop;
+	bool cid_match, mod_match, type_match;
+	unsigned long i;
+
+	xa_for_each(&dpll_pin_xa, i, pin) {
+		if (xa_empty(&pin->dpll_refs))
+			continue;
+		prop = pin->prop;
+		cid_match = clock_id ? pin->clock_id == clock_id : true;
+		mod_match = mod_name_attr && module_name(pin->module) ?
+			!nla_strcmp(mod_name_attr,
+				    module_name(pin->module)) : true;
+		type_match = type ? prop->type == type : true;
+		board_match = board_label && prop->board_label ?
+			!nla_strcmp(board_label, prop->board_label) : true;
+		panel_match = panel_label && prop->panel_label ?
+			!nla_strcmp(panel_label, prop->panel_label) : true;
+		package_match = package_label && prop->package_label ?
+			!nla_strcmp(package_label,
+				    prop->package_label) : true;
+		if (cid_match && mod_match && type_match && board_match &&
+		    panel_match && package_match) {
+			if (pin_match)
+				return NULL;
+			pin_match = pin;
+		};
+	}
+
+	return pin_match;
+}
+
+static int
+dpll_pin_find_from_nlattr(struct genl_info *info, struct sk_buff *skb)
+{
+	struct nlattr *attr, *mod_name_attr = NULL, *board_label_attr = NULL,
+		*panel_label_attr = NULL, *package_label_attr = NULL;
+	struct dpll_pin *pin = NULL;
+	enum dpll_pin_type type = 0;
+	u64 clock_id = 0;
+	int rem = 0;
+
+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(attr)) {
+		case DPLL_A_CLOCK_ID:
+			if (clock_id)
+				return -EINVAL;
+			clock_id = nla_get_u64(attr);
+			break;
+		case DPLL_A_MODULE_NAME:
+			if (mod_name_attr)
+				return -EINVAL;
+			mod_name_attr = attr;
+			break;
+		case DPLL_A_PIN_TYPE:
+			if (type)
+				return -EINVAL;
+			type = nla_get_u8(attr);
+			break;
+		case DPLL_A_PIN_BOARD_LABEL:
+			if (board_label_attr)
+				return -EINVAL;
+			board_label_attr = attr;
+			break;
+		case DPLL_A_PIN_PANEL_LABEL:
+			if (panel_label_attr)
+				return -EINVAL;
+			panel_label_attr = attr;
+			break;
+		case DPLL_A_PIN_PACKAGE_LABEL:
+			if (package_label_attr)
+				return -EINVAL;
+			package_label_attr = attr;
+			break;
+		default:
+			break;
+		}
+	}
+	if (!(clock_id  || mod_name_attr || board_label_attr ||
+	      panel_label_attr || package_label_attr))
+		return -EINVAL;
+	pin = dpll_pin_find(clock_id, mod_name_attr, type, board_label_attr,
+			    panel_label_attr, package_label_attr);
+	if (!pin)
+		return -EINVAL;
+	if (nla_put_u32(skb, DPLL_A_PIN_ID, pin->id))
+		return -EMSGSIZE;
+	return 0;
+}
+
+int dpll_nl_pin_id_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	struct nlattr *hdr;
+	int ret;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
+				DPLL_CMD_PIN_ID_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	ret = dpll_pin_find_from_nlattr(info, msg);
+	if (ret) {
+		nlmsg_free(msg);
+		return ret;
+	}
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_pin *pin = info->user_ptr[0];
+	struct sk_buff *msg;
+	struct nlattr *hdr;
+	int ret;
+
+	if (!pin)
+		return -ENODEV;
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
+				DPLL_CMD_PIN_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+	ret = __dpll_cmd_pin_dump_one(msg, pin, info->extack);
+	if (ret) {
+		nlmsg_free(msg);
+		return ret;
+	}
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
+	struct dpll_pin *pin;
+	struct nlattr *hdr;
+	unsigned long i;
+	int ret = 0;
+
+	xa_for_each_start(&dpll_pin_xa, i, pin, ctx->idx) {
+		if (xa_empty(&pin->dpll_refs))
+			continue;
+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq,
+				  &dpll_nl_family, NLM_F_MULTI,
+				  DPLL_CMD_PIN_GET);
+		if (!hdr) {
+			ret = -EMSGSIZE;
+			break;
+		}
+		ret = __dpll_cmd_pin_dump_one(skb, pin, cb->extack);
+		if (ret) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		}
+		genlmsg_end(skb, hdr);
+	}
+	if (ret == -EMSGSIZE) {
+		ctx->idx = i;
+		return skb->len;
+	}
+	return ret;
+}
+
+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_pin *pin = info->user_ptr[0];
+
+	return dpll_pin_set_from_nlattr(pin, info);
+}
+
+static struct dpll_device *
+dpll_device_find(u64 clock_id, struct nlattr *mod_name_attr,
+		 enum dpll_type type)
+{
+	struct dpll_device *dpll_match = NULL, *dpll;
+	bool cid_match, mod_match, type_match;
+	unsigned long i;
+
+	xa_for_each_marked(&dpll_device_xa, i, dpll, DPLL_REGISTERED) {
+		cid_match = clock_id ? dpll->clock_id == clock_id : true;
+		mod_match = mod_name_attr && module_name(dpll->module) ?
+			!nla_strcmp(mod_name_attr,
+				    module_name(dpll->module)) : true;
+		type_match = type ? dpll->type == type : true;
+		if (cid_match && mod_match && type_match) {
+			if (dpll_match)
+				return NULL;
+			dpll_match = dpll;
+		}
+	}
+
+	return dpll_match;
+}
+
+static int
+dpll_device_find_from_nlattr(struct genl_info *info, struct sk_buff *skb)
+{
+	struct nlattr *attr, *mod_name_attr = NULL;
+	struct dpll_device *dpll = NULL;
+	enum dpll_type type = 0;
+	u64 clock_id = 0;
+	int rem = 0;
+
+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(attr)) {
+		case DPLL_A_CLOCK_ID:
+			if (clock_id)
+				return -EINVAL;
+			clock_id = nla_get_u64(attr);
+			break;
+		case DPLL_A_MODULE_NAME:
+			if (mod_name_attr)
+				return -EINVAL;
+			mod_name_attr = attr;
+			break;
+		case DPLL_A_TYPE:
+			if (type)
+				return -EINVAL;
+			type = nla_get_u8(attr);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!clock_id && !mod_name_attr && !type)
+		return -EINVAL;
+	dpll = dpll_device_find(clock_id, mod_name_attr, type);
+	if (!dpll)
+		return -EINVAL;
+
+	return dpll_msg_add_dev_handle(skb, dpll);
+}
+
+static int
+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
+{
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
+	struct nlattr *tb[DPLL_A_MAX + 1];
+	int ret = 0;
+
+	nla_parse(tb, DPLL_A_MAX, genlmsg_data(info->genlhdr),
+		  genlmsg_len(info->genlhdr), NULL, info->extack);
+	if (tb[DPLL_A_MODE]) {
+		ret = ops->mode_set(dpll, dpll_priv(dpll),
+				    nla_get_u8(tb[DPLL_A_MODE]), info->extack);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int dpll_nl_device_id_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	struct nlattr *hdr;
+	int ret;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
+				DPLL_CMD_DEVICE_ID_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	ret = dpll_device_find_from_nlattr(info, msg);
+	if (ret) {
+		nlmsg_free(msg);
+		return ret;
+	}
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+	struct sk_buff *msg;
+	struct nlattr *hdr;
+	int ret;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
+				DPLL_CMD_DEVICE_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	ret = dpll_device_get_one(dpll, msg, info->extack);
+	if (ret) {
+		nlmsg_free(msg);
+		return ret;
+	}
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+
+	return dpll_set_from_nlattr(dpll, info);
+}
+
+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
+	struct dpll_device *dpll;
+	struct nlattr *hdr;
+	unsigned long i;
+	int ret = 0;
+
+	xa_for_each_start(&dpll_device_xa, i, dpll, ctx->idx) {
+		if (!xa_get_mark(&dpll_device_xa, i, DPLL_REGISTERED))
+			continue;
+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq, &dpll_nl_family,
+				  NLM_F_MULTI, DPLL_CMD_DEVICE_GET);
+		if (!hdr) {
+			ret = -EMSGSIZE;
+			break;
+		}
+		ret = dpll_device_get_one(dpll, skb, cb->extack);
+		if (ret) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		}
+		genlmsg_end(skb, hdr);
+	}
+	if (ret == -EMSGSIZE) {
+		ctx->idx = i;
+		return skb->len;
+	}
+	return ret;
+}
+
+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		  struct genl_info *info)
+{
+	struct dpll_device *dpll_id = NULL;
+	u32 id;
+
+	if (!info->attrs[DPLL_A_ID])
+		return -EINVAL;
+
+	mutex_lock(&dpll_lock);
+	id = nla_get_u32(info->attrs[DPLL_A_ID]);
+
+	dpll_id = dpll_device_get_by_id(id);
+	if (!dpll_id)
+		goto unlock;
+	info->user_ptr[0] = dpll_id;
+	return 0;
+unlock:
+	mutex_unlock(&dpll_lock);
+	return -ENODEV;
+}
+
+void dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		    struct genl_info *info)
+{
+	mutex_unlock(&dpll_lock);
+}
+
+int
+dpll_lock_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		     struct genl_info *info)
+{
+	mutex_lock(&dpll_lock);
+
+	return 0;
+}
+
+void
+dpll_unlock_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		   struct genl_info *info)
+{
+	mutex_unlock(&dpll_lock);
+}
+
+int dpll_lock_dumpit(struct netlink_callback *cb)
+{
+	mutex_lock(&dpll_lock);
+
+	return 0;
+}
+
+int dpll_unlock_dumpit(struct netlink_callback *cb)
+{
+	mutex_unlock(&dpll_lock);
+
+	return 0;
+}
+
+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		      struct genl_info *info)
+{
+	int ret;
+
+	mutex_lock(&dpll_lock);
+	if (!info->attrs[DPLL_A_PIN_ID]) {
+		ret = -EINVAL;
+		goto unlock_dev;
+	}
+	info->user_ptr[0] = xa_load(&dpll_pin_xa,
+				    nla_get_u32(info->attrs[DPLL_A_PIN_ID]));
+	if (!info->user_ptr[0]) {
+		ret = -ENODEV;
+		goto unlock_dev;
+	}
+
+	return 0;
+
+unlock_dev:
+	mutex_unlock(&dpll_lock);
+	return ret;
+}
+
+void dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+			struct genl_info *info)
+{
+	mutex_unlock(&dpll_lock);
+}
+
+static int
+dpll_device_event_send(enum dpll_cmd event, struct dpll_device *dpll)
+{
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	if (!xa_get_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED))
+		return -ENODEV;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
+	if (!hdr)
+		goto out_free_msg;
+	ret = dpll_device_get_one(dpll, msg, NULL);
+	if (ret)
+		goto out_cancel_msg;
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
+
+	return 0;
+
+out_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+out_free_msg:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+int dpll_device_create_ntf(struct dpll_device *dpll)
+{
+	return dpll_device_event_send(DPLL_CMD_DEVICE_CREATE_NTF, dpll);
+}
+
+int dpll_device_delete_ntf(struct dpll_device *dpll)
+{
+	return dpll_device_event_send(DPLL_CMD_DEVICE_DELETE_NTF, dpll);
+}
+
+int dpll_device_change_ntf(struct dpll_device *dpll)
+{
+	int ret = -EINVAL;
+
+	if (WARN_ON(!dpll))
+		return ret;
+
+	mutex_lock(&dpll_lock);
+	ret = dpll_device_event_send(DPLL_CMD_DEVICE_CHANGE_NTF, dpll);
+	mutex_unlock(&dpll_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_device_change_ntf);
+
+static int
+dpll_pin_event_send(enum dpll_cmd event, struct dpll_pin *pin)
+{
+	struct dpll_pin *pin_verify;
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	pin_verify = xa_load(&dpll_pin_xa, pin->id);
+	if (pin != pin_verify)
+		return -ENODEV;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
+	if (!hdr)
+		goto out_free_msg;
+	ret = __dpll_cmd_pin_dump_one(msg, pin, NULL);
+	if (ret)
+		goto out_cancel_msg;
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
+
+	return 0;
+
+out_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+out_free_msg:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+int dpll_pin_create_ntf(struct dpll_pin *pin)
+{
+	return dpll_pin_event_send(DPLL_CMD_PIN_CREATE_NTF, pin);
+}
+
+int dpll_pin_delete_ntf(struct dpll_pin *pin)
+{
+	return dpll_pin_event_send(DPLL_CMD_PIN_DELETE_NTF, pin);
+}
+
+static int __dpll_pin_change_ntf(struct dpll_pin *pin)
+{
+	return dpll_pin_event_send(DPLL_CMD_PIN_CHANGE_NTF, pin);
+}
+
+int dpll_pin_change_ntf(struct dpll_pin *pin)
+{
+	int ret = -EINVAL;
+
+	if (WARN_ON(!pin))
+		return ret;
+
+	mutex_lock(&dpll_lock);
+	ret = __dpll_pin_change_ntf(pin);
+	mutex_unlock(&dpll_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_change_ntf);
+
+int __init dpll_netlink_init(void)
+{
+	return genl_register_family(&dpll_nl_family);
+}
+
+void dpll_netlink_finish(void)
+{
+	genl_unregister_family(&dpll_nl_family);
+}
+
+void __exit dpll_netlink_fini(void)
+{
+	dpll_netlink_finish();
+}
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
new file mode 100644
index 000000000000..b5f9bfc88c9e
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
+ *  Copyright (c) 2023 Intel and affiliates
+ */
+
+/**
+ * dpll_device_create_ntf - notify that the device has been created
+ * @dpll: registered dpll pointer
+ *
+ * Context: caller shall hold dpll_xa_lock.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_device_create_ntf(struct dpll_device *dpll);
+
+/**
+ * dpll_device_delete_ntf - notify that the device has been deleted
+ * @dpll: registered dpll pointer
+ *
+ * Context: caller shall hold dpll_xa_lock.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_device_delete_ntf(struct dpll_device *dpll);
+
+/**
+ * dpll_pin_create_ntf - notify that the pin has been created
+ * @pin: registered pin pointer
+ *
+ * Context: caller shall hold dpll_xa_lock.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_create_ntf(struct dpll_pin *pin);
+
+/**
+ * dpll_pin_delete_ntf - notify that the pin has been deleted
+ * @pin: registered pin pointer
+ *
+ * Context: caller shall hold dpll_xa_lock.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_pin_delete_ntf(struct dpll_pin *pin);
+
+int __init dpll_netlink_init(void);
+void dpll_netlink_finish(void);
-- 
2.37.3


