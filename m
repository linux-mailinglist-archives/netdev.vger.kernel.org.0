Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AB56F4769
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjEBPiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjEBPiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:38:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E397FE7
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 08:38:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-956ff2399c9so796279666b.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 08:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683041891; x=1685633891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HqBvu3y1oZ5T4qQAwfo4Qy7DNtQp0rBQJB5KCscfGW4=;
        b=MyssGTnNQwmNZYvn/8AnHggceFVju88dan7+ndN8OLoduk5/MDRviXGQS6EJH85oKl
         HwSnlZ/t+qMWXo2+ZcTqCJrLikcBZldGnkIYKflTpX+LMl01oDvbBmx717ztE5IyDxsL
         pj72cfLX433/BWAli+SZiHPTC/9/28YJmIn9OrcTdlP91Mp5dVAadH9cE/jAmzELcQIa
         0YvOkSnJ29QoBRA7Ty1oPIJBDkA9BpKFAWEhfL26a5PvBs9gcNUP6vbUIc4Xk7AyM8+p
         eoLPbLPbKO9v/OKSVkhCOYFeKYhPbo6swfO2gGN9wjygwHP6aLYqqB0+ig+CLftIG2DF
         srTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683041891; x=1685633891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqBvu3y1oZ5T4qQAwfo4Qy7DNtQp0rBQJB5KCscfGW4=;
        b=IBPdeaHezASd11+VLCHM3lDXEKXBM64NnDsl6g5Gqy07tu4f5olEK7dmkvJmGg45i9
         iFA6jMNhrO/5u1c5FE1FqdEqbZQnsBWCqN5a7Fxza3nCfo0nSV3zulgZy978fphDrh6P
         wxzuNhSbaLxKp4zmKKMfpKT8o4QNgTrVe5rg6jVZ51xQqlxqsCrhzCoMSIye2EMk8yKa
         8f0t5koyLu7y3cvvLIydcFkGd69guHnWx/pP48mzJk4q5CVqXNg6qSCElp6rF1VZBut2
         L1t0H4L7xwQ52yBkiS+dJtSkmkIjndNDlPfpvElpwqIygW43UU5oAseYaUrzQKcBfVO3
         DHnw==
X-Gm-Message-State: AC+VfDzj9BOSxrqjht9OvC/psENqRTcYXI4+FGgoW1XcFSd+DbkR1fDk
        IaeZApfkXU+uo6PwTtCzqHMUcA==
X-Google-Smtp-Source: ACHHUZ4NUcVd7WpTyZoHk3jMD+SfKMP/LdJFukGqwX6D4HyQXqD2Q78lmV4GwT23S6uK4wsUIgzvHw==
X-Received: by 2002:a17:906:dac8:b0:94e:d3e8:ec3e with SMTP id xi8-20020a170906dac800b0094ed3e8ec3emr315842ejb.46.1683041890695;
        Tue, 02 May 2023 08:38:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fh22-20020a1709073a9600b0094efc389980sm16107887ejc.58.2023.05.02.08.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:38:10 -0700 (PDT)
Date:   Tue, 2 May 2023 17:38:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Message-ID: <ZFEuYEqZwJZ+aApI@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>
>DPLL framework is used to represent and configure DPLL devices
>in systems. Each device that has DPLL and can configure sources
>and outputs can use this framework. Netlink interface is used to
>provide configuration data and to receive notification messages
>about changes in the configuration or status of DPLL device.
>Inputs and outputs of the DPLL device are represented as special
>objects which could be dynamically added to and removed from DPLL
>device.
>
>Co-developed-by: Milena Olech <milena.olech@intel.com>
>Signed-off-by: Milena Olech <milena.olech@intel.com>
>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>---
> MAINTAINERS                 |   8 +
> drivers/Kconfig             |   2 +
> drivers/Makefile            |   1 +
> drivers/dpll/Kconfig        |   7 +
> drivers/dpll/Makefile       |  10 +
> drivers/dpll/dpll_core.c    | 939 ++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_core.h    | 113 +++++
> drivers/dpll/dpll_netlink.c | 972 ++++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h |  27 +
> include/linux/dpll.h        | 274 ++++++++++
> include/uapi/linux/dpll.h   |   2 +
> 11 files changed, 2355 insertions(+)
> create mode 100644 drivers/dpll/Kconfig
> create mode 100644 drivers/dpll/Makefile
> create mode 100644 drivers/dpll/dpll_core.c
> create mode 100644 drivers/dpll/dpll_core.h
> create mode 100644 drivers/dpll/dpll_netlink.c
> create mode 100644 drivers/dpll/dpll_netlink.h
> create mode 100644 include/linux/dpll.h
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index ebd26b3ca90e..710976c0737e 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -6302,6 +6302,14 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
> 
>+DPLL CLOCK SUBSYSTEM
>+M:	Vadim Fedorenko <vadfed@fb.com>
>+L:	netdev@vger.kernel.org
>+S:	Maintained
>+F:	drivers/dpll/*
>+F:	include/net/dpll.h
>+F:	include/uapi/linux/dpll.h
>+
> DRBD DRIVER
> M:	Philipp Reisner <philipp.reisner@linbit.com>
> M:	Lars Ellenberg <lars.ellenberg@linbit.com>
>diff --git a/drivers/Kconfig b/drivers/Kconfig
>index 968bd0a6fd78..453df9e1210d 100644
>--- a/drivers/Kconfig
>+++ b/drivers/Kconfig
>@@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
> 
> source "drivers/hte/Kconfig"
> 
>+source "drivers/dpll/Kconfig"
>+
> endmenu
>diff --git a/drivers/Makefile b/drivers/Makefile
>index 20b118dca999..9ffb554507ef 100644
>--- a/drivers/Makefile
>+++ b/drivers/Makefile
>@@ -194,3 +194,4 @@ obj-$(CONFIG_MOST)		+= most/
> obj-$(CONFIG_PECI)		+= peci/
> obj-$(CONFIG_HTE)		+= hte/
> obj-$(CONFIG_DRM_ACCEL)		+= accel/
>+obj-$(CONFIG_DPLL)		+= dpll/
>diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
>new file mode 100644
>index 000000000000..a4cae73f20d3
>--- /dev/null
>+++ b/drivers/dpll/Kconfig
>@@ -0,0 +1,7 @@
>+# SPDX-License-Identifier: GPL-2.0-only
>+#
>+# Generic DPLL drivers configuration
>+#
>+
>+config DPLL
>+  bool
>diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>new file mode 100644
>index 000000000000..803bb5db7793
>--- /dev/null
>+++ b/drivers/dpll/Makefile
>@@ -0,0 +1,10 @@
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# Makefile for DPLL drivers.
>+#
>+
>+obj-$(CONFIG_DPLL)      += dpll.o
>+dpll-y                  += dpll_core.o
>+dpll-y                  += dpll_netlink.o
>+dpll-y                  += dpll_nl.o
>+
>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>new file mode 100644
>index 000000000000..8a2370740026
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.c
>@@ -0,0 +1,939 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ *  dpll_core.c - Generic DPLL Management class support.
>+ *
>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>+ *  Copyright (c) 2023 Intel Corporation.
>+ */
>+
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+
>+#include <linux/device.h>
>+#include <linux/err.h>
>+#include <linux/slab.h>
>+#include <linux/string.h>
>+
>+#include "dpll_core.h"
>+
>+DEFINE_MUTEX(dpll_xa_lock);

Why this is called "xa_lock"? It protects much more than that. Call it
dpll_big_lock while you are at it.


>+
>+DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
>+DEFINE_XARRAY_FLAGS(dpll_pin_xa, XA_FLAGS_ALLOC);
>+
>+#define ASSERT_DPLL_REGISTERED(d)                                          \
>+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>+#define ASSERT_DPLL_NOT_REGISTERED(d)                                      \
>+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>+
>+/**
>+ * dpll_device_get_by_id - find dpll device by it's id
>+ * @id: id of searched dpll
>+ *
>+ * Return:
>+ * * dpll_device struct if found
>+ * * NULL otherwise
>+ */
>+struct dpll_device *dpll_device_get_by_id(int id)
>+{
>+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
>+		return xa_load(&dpll_device_xa, id);
>+
>+	return NULL;
>+}
>+
>+/**
>+ * dpll_device_get_by_name - find dpll device by it's id

"by name" instead of "by id" ?


>+ * @bus_name: bus name of searched dpll
>+ * @dev_name: dev name of searched dpll
>+ *
>+ * Return:
>+ * * dpll_device struct if found
>+ * * NULL otherwise
>+ */
>+struct dpll_device *
>+dpll_device_get_by_name(const char *bus_name, const char *device_name)
>+{
>+	struct dpll_device *dpll, *ret = NULL;
>+	unsigned long i;
>+
>+	xa_for_each_marked(&dpll_device_xa, i, dpll, DPLL_REGISTERED) {
>+		if (!strcmp(dev_bus_name(&dpll->dev), bus_name) &&
>+		    !strcmp(dev_name(&dpll->dev), device_name)) {
>+			ret = dpll;
>+			break;
>+		}
>+	}
>+
>+	return ret;
>+}
>+
>+static struct dpll_pin_registration *
>+dpll_pin_registration_find(struct dpll_pin_ref *ref,
>+			   const struct dpll_pin_ops *ops, void *priv)
>+{
>+	struct dpll_pin_registration *reg;
>+
>+	list_for_each_entry(reg, &ref->registration_list, list) {
>+		if (reg->ops == ops && reg->priv == priv)
>+			return reg;
>+	}
>+	return NULL;
>+}
>+
>+/**
>+ * dpll_xa_ref_pin_add - add pin reference to a given xarray
>+ * @xa_pins: dpll_pin_ref xarray holding pins
>+ * @pin: pin being added
>+ * @ops: ops for a pin
>+ * @priv: pointer to private data of owner
>+ *
>+ * Allocate and create reference of a pin and enlist a registration
>+ * structure storing ops and priv pointers of a caller registant.
>+ *
>+ * Return:
>+ * * 0 on success
>+ * * -ENOMEM on failed allocation
>+ */
>+static int
>+dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
>+		    const struct dpll_pin_ops *ops, void *priv)
>+{
>+	struct dpll_pin_registration *reg;
>+	struct dpll_pin_ref *ref;
>+	bool ref_exists = false;
>+	unsigned long i;
>+	int ret;
>+
>+	xa_for_each(xa_pins, i, ref) {
>+		if (ref->pin != pin)
>+			continue;
>+		reg = dpll_pin_registration_find(ref, ops, priv);
>+		if (reg) {
>+			refcount_inc(&ref->refcount);
>+			return 0;
>+		}
>+		ref_exists = true;
>+		break;
>+	}
>+
>+	if (!ref_exists) {
>+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
>+		if (!ref)
>+			return -ENOMEM;
>+		ref->pin = pin;
>+		INIT_LIST_HEAD(&ref->registration_list);
>+		ret = xa_insert(xa_pins, pin->pin_idx, ref, GFP_KERNEL);
>+		if (ret) {
>+			kfree(ref);
>+			return ret;
>+		}
>+		refcount_set(&ref->refcount, 1);
>+	}
>+
>+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
>+	if (!reg) {
>+		if (!ref_exists)
>+			kfree(ref);
>+		return -ENOMEM;
>+	}
>+	reg->ops = ops;
>+	reg->priv = priv;
>+	if (ref_exists)
>+		refcount_inc(&ref->refcount);
>+	list_add_tail(&reg->list, &ref->registration_list);
>+
>+	return 0;
>+}
>+
>+/**
>+ * dpll_xa_ref_pin_del - remove reference of a pin from xarray
>+ * @xa_pins: dpll_pin_ref xarray holding pins
>+ * @pin: pointer to a pin
>+ *
>+ * Decrement refcount of existing pin reference on given xarray.
>+ * If all registrations are lifted delete the reference and free its memory.
>+ *
>+ * Return:
>+ * * 0 on success
>+ * * -EINVAL if reference to a pin was not found
>+ */
>+static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin,
>+			       const struct dpll_pin_ops *ops, void *priv)
>+{
>+	struct dpll_pin_registration *reg;
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	xa_for_each(xa_pins, i, ref) {
>+		if (ref->pin != pin)
>+			continue;
>+		reg = dpll_pin_registration_find(ref, ops, priv);
>+		if (WARN_ON(!reg))
>+			return -EINVAL;
>+		if (refcount_dec_and_test(&ref->refcount)) {
>+			list_del(&reg->list);
>+			kfree(reg);
>+			xa_erase(xa_pins, i);
>+			WARN_ON(!list_empty(&ref->registration_list));
>+			kfree(ref);
>+		}
>+		return 0;
>+	}
>+
>+	return -EINVAL;
>+}
>+
>+/**
>+ * dpll_xa_ref_dpll_add - add dpll reference to a given xarray
>+ * @xa_dplls: dpll_pin_ref xarray holding dplls
>+ * @dpll: dpll being added
>+ * @ops: pin-reference ops for a dpll
>+ * @priv: pointer to private data of owner
>+ *
>+ * Allocate and create reference of a dpll-pin ops or increase refcount
>+ * on existing dpll reference on given xarray.
>+ *
>+ * Return:
>+ * * 0 on success
>+ * * -ENOMEM on failed allocation
>+ */
>+static int
>+dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
>+		     const struct dpll_pin_ops *ops, void *priv)
>+{
>+	struct dpll_pin_registration *reg;
>+	struct dpll_pin_ref *ref;
>+	bool ref_exists = false;
>+	unsigned long i;
>+	int ret;
>+
>+	xa_for_each(xa_dplls, i, ref) {
>+		if (ref->dpll != dpll)
>+			continue;
>+		reg = dpll_pin_registration_find(ref, ops, priv);
>+		if (reg) {
>+			refcount_inc(&ref->refcount);
>+			return 0;
>+		}
>+		ref_exists = true;
>+		break;
>+	}
>+
>+	if (!ref_exists) {
>+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
>+		if (!ref)
>+			return -ENOMEM;
>+		ref->dpll = dpll;
>+		INIT_LIST_HEAD(&ref->registration_list);
>+		ret = xa_insert(xa_dplls, dpll->device_idx, ref, GFP_KERNEL);
>+		if (ret) {
>+			kfree(ref);
>+			return ret;
>+		}
>+		refcount_set(&ref->refcount, 1);
>+	}
>+
>+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
>+	if (!reg) {
>+		if (!ref_exists)
>+			kfree(ref);
>+		return -ENOMEM;
>+	}
>+	reg->ops = ops;
>+	reg->priv = priv;
>+	if (ref_exists)
>+		refcount_inc(&ref->refcount);
>+	list_add_tail(&reg->list, &ref->registration_list);
>+
>+	return 0;
>+}
>+
>+/**
>+ * dpll_xa_ref_dpll_del - remove reference of a dpll from xarray
>+ * @xa_dplls: dpll_pin_ref xarray holding dplls
>+ * @dpll: pointer to a dpll to remove
>+ *
>+ * Decrement refcount of existing dpll reference on given xarray.
>+ * If all references are dropped, delete the reference and free its memory.
>+ */
>+static void
>+dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll,
>+		     const struct dpll_pin_ops *ops, void *priv)
>+{
>+	struct dpll_pin_registration *reg;
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	xa_for_each(xa_dplls, i, ref) {
>+		if (ref->dpll != dpll)
>+			continue;
>+		reg = dpll_pin_registration_find(ref, ops, priv);
>+		if (WARN_ON(!reg))
>+			return;
>+		if (refcount_dec_and_test(&ref->refcount)) {
>+			list_del(&reg->list);
>+			kfree(reg);
>+			xa_erase(xa_dplls, i);
>+			WARN_ON(!list_empty(&ref->registration_list));
>+			kfree(ref);
>+		}
>+		return;
>+	}
>+}
>+
>+/**
>+ * dpll_xa_ref_dpll_find - find dpll reference on xarray
>+ * @xa_dplls: dpll_pin_ref xarray holding dplls
>+ * @dpll: pointer to a dpll
>+ *
>+ * Search for dpll-pin ops reference struct of a given dpll on given xarray.
>+ *
>+ * Return:
>+ * * pin reference struct pointer on success
>+ * * NULL - reference to a pin was not found
>+ */
>+struct dpll_pin_ref *
>+dpll_xa_ref_dpll_find(struct xarray *xa_refs, const struct dpll_device *dpll)
>+{
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	xa_for_each(xa_refs, i, ref) {
>+		if (ref->dpll == dpll)
>+			return ref;
>+	}
>+
>+	return NULL;
>+}
>+
>+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs)
>+{
>+	struct dpll_pin_ref *ref;
>+	unsigned long i = 0;
>+
>+	ref = xa_find(xa_refs, &i, ULONG_MAX, XA_PRESENT);
>+	WARN_ON(!ref);
>+	return ref;
>+}
>+
>+/**
>+ * dpll_device_alloc - allocate the memory for dpll device
>+ * @clock_id: clock_id of creator
>+ * @device_idx: id given by dev driver
>+ * @module: reference to registering module
>+ *
>+ * Allocates memory and initialize dpll device, hold its reference on global
>+ * xarray.
>+ *
>+ * Return:
>+ * * dpll_device struct pointer if succeeded
>+ * * ERR_PTR(X) - failed allocation
>+ */
>+static struct dpll_device *
>+dpll_device_alloc(const u64 clock_id, u32 device_idx, struct module *module)
>+{
>+	struct dpll_device *dpll;
>+	int ret;
>+
>+	dpll = kzalloc(sizeof(*dpll), GFP_KERNEL);
>+	if (!dpll)
>+		return ERR_PTR(-ENOMEM);
>+	refcount_set(&dpll->refcount, 1);
>+	INIT_LIST_HEAD(&dpll->registration_list);
>+	dpll->device_idx = device_idx;
>+	dpll->clock_id = clock_id;
>+	dpll->module = module;
>+	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b,
>+		       GFP_KERNEL);
>+	if (ret) {
>+		kfree(dpll);
>+		return ERR_PTR(ret);
>+	}
>+	xa_init_flags(&dpll->pin_refs, XA_FLAGS_ALLOC);
>+
>+	return dpll;
>+}
>+
>+/**
>+ * dpll_device_get - find existing or create new dpll device
>+ * @clock_id: clock_id of creator
>+ * @device_idx: idx given by device driver
>+ * @module: reference to registering module
>+ *
>+ * Get existing object of a dpll device, unique for given arguments.
>+ * Create new if doesn't exist yet.
>+ *
>+ * Return:
>+ * * valid dpll_device struct pointer if succeeded
>+ * * ERR_PTR of an error
>+ */
>+struct dpll_device *
>+dpll_device_get(u64 clock_id, u32 device_idx, struct module *module)
>+{
>+	struct dpll_device *dpll, *ret = NULL;
>+	unsigned long index;
>+
>+	mutex_lock(&dpll_xa_lock);
>+	xa_for_each(&dpll_device_xa, index, dpll) {
>+		if (dpll->clock_id == clock_id &&
>+		    dpll->device_idx == device_idx &&
>+		    dpll->module == module) {
>+			ret = dpll;
>+			refcount_inc(&ret->refcount);
>+			break;
>+		}
>+	}
>+	if (!ret)
>+		ret = dpll_device_alloc(clock_id, device_idx, module);
>+	mutex_unlock(&dpll_xa_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_get);
>+
>+/**
>+ * dpll_device_put - decrease the refcount and free memory if possible
>+ * @dpll: dpll_device struct pointer
>+ *
>+ * Drop reference for a dpll device, if all references are gone, delete
>+ * dpll device object.
>+ */
>+void dpll_device_put(struct dpll_device *dpll)
>+{
>+	if (!dpll)
>+		return;
>+	mutex_lock(&dpll_xa_lock);
>+	if (refcount_dec_and_test(&dpll->refcount)) {
>+		ASSERT_DPLL_NOT_REGISTERED(dpll);
>+		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
>+		xa_destroy(&dpll->pin_refs);
>+		xa_erase(&dpll_device_xa, dpll->id);
>+		WARN_ON(!list_empty(&dpll->registration_list));
>+		kfree(dpll);
>+	}
>+	mutex_unlock(&dpll_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_put);
>+
>+static struct dpll_device_registration *
>+dpll_device_registration_find(struct dpll_device *dpll,
>+			      const struct dpll_device_ops *ops, void *priv)
>+{
>+	struct dpll_device_registration *reg;
>+
>+	list_for_each_entry(reg, &dpll->registration_list, list) {
>+		if (reg->ops == ops && reg->priv == priv)
>+			return reg;
>+	}
>+	return NULL;
>+}
>+
>+/**
>+ * dpll_device_register - register the dpll device in the subsystem
>+ * @dpll: pointer to a dpll
>+ * @type: type of a dpll
>+ * @ops: ops for a dpll device
>+ * @priv: pointer to private information of owner
>+ * @owner: pointer to owner device
>+ *
>+ * Make dpll device available for user space.
>+ *
>+ * Return:
>+ * * 0 on success
>+ * * -EINVAL on failure

From what I see, this function returns "-EEXIST" as well. Btw, what
benefit this "table" brings? Perhaps could be avoided in the whole code?


>+ */
>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>+			 const struct dpll_device_ops *ops, void *priv,
>+			 struct device *owner)
>+{
>+	struct dpll_device_registration *reg;
>+	bool first_registration = false;
>+
>+	if (WARN_ON(!ops || !owner))
>+		return -EINVAL;
>+	if (WARN_ON(type <= DPLL_TYPE_UNSPEC || type > DPLL_TYPE_MAX))
>+		return -EINVAL;
>+
>+	mutex_lock(&dpll_xa_lock);
>+	reg = dpll_device_registration_find(dpll, ops, priv);
>+	if (reg) {
>+		mutex_unlock(&dpll_xa_lock);
>+		return -EEXIST;
>+	}
>+
>+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
>+	if (!reg) {
>+		mutex_unlock(&dpll_xa_lock);
>+		return -EEXIST;
>+	}
>+	reg->ops = ops;
>+	reg->priv = priv;
>+
>+	dpll->dev.bus = owner->bus;

This is definitelly odd. You basicall take PCI bus for example and
pretend some other device to be there. Why exactly this dev is needed at
all? I don't see the need, you only abuse it to store strings you
expose over Netlink.

Please remove dpll->dev entirely. Expose module_name, clock_id and
device_idx directly over Netlink as separate attributes.


>+	dpll->parent = owner;


You don't use dpll->parent. Please remove and remove also "owner" arg of
this function.



>+	dpll->type = type;
>+	dev_set_name(&dpll->dev, "%s/%llx/%d", module_name(dpll->module),
>+		     dpll->clock_id, dpll->device_idx);
>+
>+	first_registration = list_empty(&dpll->registration_list);
>+	list_add_tail(&reg->list, &dpll->registration_list);
>+	if (!first_registration) {
>+		mutex_unlock(&dpll_xa_lock);
>+		return 0;
>+	}
>+
>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>+	mutex_unlock(&dpll_xa_lock);
>+	dpll_notify_device_create(dpll);
>+
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_register);
>+
>+/**
>+ * dpll_device_unregister - deregister dpll device
>+ * @dpll: registered dpll pointer
>+ * @ops: ops for a dpll device
>+ * @priv: pointer to private information of owner
>+ *
>+ * Deregister device, make it unavailable for userspace.
>+ * Note: It does not free the memory
>+ */
>+void dpll_device_unregister(struct dpll_device *dpll,
>+			    const struct dpll_device_ops *ops, void *priv)
>+{
>+	struct dpll_device_registration *reg;
>+
>+	mutex_lock(&dpll_xa_lock);
>+	ASSERT_DPLL_REGISTERED(dpll);
>+
>+	reg = dpll_device_registration_find(dpll, ops, priv);
>+	if (WARN_ON(!reg)) {
>+		mutex_unlock(&dpll_xa_lock);
>+		return;
>+	}
>+	list_del(&reg->list);
>+	kfree(reg);
>+
>+	if (!list_empty(&dpll->registration_list)) {
>+		mutex_unlock(&dpll_xa_lock);
>+		return;
>+	}
>+	xa_clear_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>+	mutex_unlock(&dpll_xa_lock);
>+	dpll_notify_device_delete(dpll);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_unregister);
>+
>+/**
>+ * dpll_pin_alloc - allocate the memory for dpll pin
>+ * @clock_id: clock_id of creator
>+ * @pin_idx: idx given by dev driver
>+ * @module: reference to registering module
>+ * @prop: dpll pin properties
>+ *
>+ * Return:
>+ * valid allocated dpll_pin struct pointer if succeeded
>+ * ERR_PTR of an error
>+ */
>+static struct dpll_pin *
>+dpll_pin_alloc(u64 clock_id, u8 pin_idx, struct module *module,

DPLL_A_PIN_IDX is u32, in struct dpll_pin it is u32.
Why here you have only u8? Please sync.


>+	       const struct dpll_pin_properties *prop)
>+{
>+	struct dpll_pin *pin;
>+	int ret, fs_size;
>+
>+	pin = kzalloc(sizeof(*pin), GFP_KERNEL);
>+	if (!pin)
>+		return ERR_PTR(-ENOMEM);
>+	pin->pin_idx = pin_idx;
>+	pin->clock_id = clock_id;
>+	pin->module = module;
>+	refcount_set(&pin->refcount, 1);
>+	if (WARN_ON(!prop->label)) {
>+		ret = -EINVAL;
>+		goto err;
>+	}
>+	pin->prop.label = kstrdup(prop->label, GFP_KERNEL);
>+	if (!pin->prop.label) {
>+		ret = -ENOMEM;
>+		goto err;
>+	}
>+	if (WARN_ON(prop->type <= DPLL_PIN_TYPE_UNSPEC ||
>+		    prop->type > DPLL_PIN_TYPE_MAX)) {
>+		ret = -EINVAL;
>+		goto err;
>+	}
>+	pin->prop.type = prop->type;
>+	pin->prop.capabilities = prop->capabilities;

Just assing the prop pointer to pin->prop and you are done, no. Why you
need to copy the internals? Driver should behave and pass static const
pointer here (it is common in cases like this).


>+	if (prop->freq_supported_num) {
>+		fs_size = sizeof(*pin->prop.freq_supported) *
>+			  prop->freq_supported_num;
>+		pin->prop.freq_supported = kzalloc(fs_size, GFP_KERNEL);
>+		if (!pin->prop.freq_supported) {
>+			ret = -ENOMEM;
>+			goto err;
>+		}
>+		memcpy(pin->prop.freq_supported, prop->freq_supported, fs_size);
>+		pin->prop.freq_supported_num = prop->freq_supported_num;
>+	}
>+	xa_init_flags(&pin->dpll_refs, XA_FLAGS_ALLOC);
>+	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
>+	ret = xa_alloc(&dpll_pin_xa, &pin->id, pin, xa_limit_16b, GFP_KERNEL);
>+	if (ret)
>+		goto err;
>+	return pin;
>+err:
>+	xa_destroy(&pin->dpll_refs);
>+	xa_destroy(&pin->parent_refs);
>+	kfree(pin->prop.label);
>+	kfree(pin->rclk_dev_name);
>+	kfree(pin);
>+	return ERR_PTR(ret);
>+}
>+
>+/**
>+ * dpll_pin_get - find existing or create new dpll pin
>+ * @clock_id: clock_id of creator
>+ * @pin_idx: idx given by dev driver
>+ * @module: reference to registering module
>+ * @prop: dpll pin properties
>+ *
>+ * Get existing object of a pin (unique for given arguments) or create new
>+ * if doesn't exist yet.
>+ *
>+ * Return:
>+ * * valid allocated dpll_pin struct pointer if succeeded
>+ * * ERR_PTR of an error
>+ */
>+struct dpll_pin *
>+dpll_pin_get(u64 clock_id, u32 pin_idx, struct module *module,
>+	     const struct dpll_pin_properties *prop)
>+{
>+	struct dpll_pin *pos, *ret = NULL;
>+	unsigned long i;
>+
>+	xa_for_each(&dpll_pin_xa, i, pos) {
>+		if (pos->clock_id == clock_id &&
>+		    pos->pin_idx == pin_idx &&
>+		    pos->module == module) {
>+			ret = pos;
>+			refcount_inc(&ret->refcount);
>+			break;
>+		}
>+	}
>+	if (!ret)
>+		ret = dpll_pin_alloc(clock_id, pin_idx, module, prop);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_get);
>+
>+/**
>+ * dpll_pin_put - decrease the refcount and free memory if possible
>+ * @dpll: dpll_device struct pointer
>+ *
>+ * Drop reference for a pin, if all references are gone, delete pin object.
>+ */
>+void dpll_pin_put(struct dpll_pin *pin)
>+{
>+	if (!pin)
>+		return;
>+	if (refcount_dec_and_test(&pin->refcount)) {
>+		xa_destroy(&pin->dpll_refs);
>+		xa_destroy(&pin->parent_refs);
>+		xa_erase(&dpll_pin_xa, pin->id);
>+		kfree(pin->prop.label);
>+		kfree(pin->prop.freq_supported);
>+		kfree(pin->rclk_dev_name);
>+		kfree(pin);
>+	}
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_put);
>+
>+static int
>+__dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>+		    const struct dpll_pin_ops *ops, void *priv,
>+		    const char *rclk_device_name)
>+{
>+	int ret;
>+
>+	if (WARN_ON(!ops))
>+		return -EINVAL;
>+
>+	if (rclk_device_name && !pin->rclk_dev_name) {
>+		pin->rclk_dev_name = kstrdup(rclk_device_name, GFP_KERNEL);
>+		if (!pin->rclk_dev_name)
>+			return -ENOMEM;
>+	}
>+	ret = dpll_xa_ref_pin_add(&dpll->pin_refs, pin, ops, priv);
>+	if (ret)
>+		goto rclk_free;
>+	ret = dpll_xa_ref_dpll_add(&pin->dpll_refs, dpll, ops, priv);
>+	if (ret)
>+		goto ref_pin_del;
>+	else
>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_IDX);
>+
>+	return ret;
>+
>+ref_pin_del:
>+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
>+rclk_free:
>+	kfree(pin->rclk_dev_name);
>+	return ret;
>+}
>+
>+/**
>+ * dpll_pin_register - register the dpll pin in the subsystem
>+ * @dpll: pointer to a dpll
>+ * @pin: pointer to a dpll pin
>+ * @ops: ops for a dpll pin ops
>+ * @priv: pointer to private information of owner
>+ * @rclk_device: pointer to recovered clock device
>+ *
>+ * Return:
>+ * * 0 on success
>+ * * -EINVAL - missing dpll or pin

Incorrect.


>+ * * -ENOMEM - failed to allocate memory
>+ */
>+int
>+dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>+		  const struct dpll_pin_ops *ops, void *priv,
>+		  struct device *rclk_device)
>+{
>+	const char *rclk_name = rclk_device ? dev_name(rclk_device) : NULL;
>+	int ret;
>+
>+	mutex_lock(&dpll_xa_lock);

You have to make sure that dpll and pin are created with same module and
clock_id. Check and WARN_ON& bail out here.


>+	ret = __dpll_pin_register(dpll, pin, ops, priv, rclk_name);
>+	mutex_unlock(&dpll_xa_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_register);
>+
>+static void
>+__dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>+		      const struct dpll_pin_ops *ops, void *priv)
>+{
>+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
>+	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv);
>+}
>+
>+/**
>+ * dpll_pin_unregister - deregister dpll pin from dpll device
>+ * @dpll: registered dpll pointer
>+ * @pin: pointer to a pin
>+ * @ops: ops for a dpll pin
>+ * @priv: pointer to private information of owner
>+ *
>+ * Note: It does not free the memory
>+ */
>+void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>+			 const struct dpll_pin_ops *ops, void *priv)
>+{
>+	if (WARN_ON(xa_empty(&dpll->pin_refs)))
>+		return;
>+
>+	mutex_lock(&dpll_xa_lock);
>+	__dpll_pin_unregister(dpll, pin, ops, priv);
>+	mutex_unlock(&dpll_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_unregister);
>+
>+/**
>+ * dpll_pin_on_pin_register - register a pin with a parent pin
>+ * @parent: pointer to a parent pin
>+ * @pin: pointer to a pin
>+ * @ops: ops for a dpll pin
>+ * @priv: pointer to private information of owner
>+ * @rclk_device: pointer to recovered clock device
>+ *
>+ * Register a pin with a parent pin, create references between them and
>+ * between newly registered pin and dplls connected with a parent pin.
>+ *
>+ * Return:
>+ * * 0 on success
>+ * * -EINVAL missing pin or parent
>+ * * -ENOMEM failed allocation
>+ * * -EPERM if parent is not allowed
>+ */
>+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
>+			     const struct dpll_pin_ops *ops, void *priv,
>+			     struct device *rclk_device)
>+{
>+	struct dpll_pin_ref *ref;
>+	unsigned long i, stop;
>+	int ret;
>+
>+	if (WARN_ON(parent->prop.type != DPLL_PIN_TYPE_MUX))
>+		return -EINVAL;
>+	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv);
>+	if (ret)
>+		goto unlock;
>+	refcount_inc(&pin->refcount);
>+	xa_for_each(&parent->dpll_refs, i, ref) {
>+		mutex_lock(&dpll_xa_lock);
>+		ret = __dpll_pin_register(ref->dpll, pin, ops, priv,
>+					  rclk_device ?
>+					  dev_name(rclk_device) : NULL);
>+		mutex_unlock(&dpll_xa_lock);
>+		if (ret) {
>+			stop = i;
>+			goto dpll_unregister;
>+		}
>+		dpll_pin_parent_notify(ref->dpll, pin, parent, DPLL_A_PIN_IDX);
>+	}
>+
>+	return ret;
>+
>+dpll_unregister:
>+	xa_for_each(&parent->dpll_refs, i, ref) {
>+		if (i < stop) {
>+			mutex_lock(&dpll_xa_lock);
>+			__dpll_pin_unregister(ref->dpll, pin, ops, priv);
>+			mutex_unlock(&dpll_xa_lock);
>+		}
>+	}
>+	refcount_dec(&pin->refcount);
>+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
>+unlock:
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_register);
>+
>+/**
>+ * dpll_pin_on_pin_unregister - deregister dpll pin from a parent pin
>+ * @parent: pointer to a parent pin
>+ * @pin: pointer to a pin
>+ * @ops: ops for a dpll pin
>+ * @priv: pointer to private information of owner
>+ *
>+ * Note: It does not free the memory
>+ */
>+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
>+				const struct dpll_pin_ops *ops, void *priv)
>+{
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	mutex_lock(&dpll_xa_lock);
>+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
>+	refcount_dec(&pin->refcount);
>+	xa_for_each(&pin->dpll_refs, i, ref) {
>+		__dpll_pin_unregister(ref->dpll, pin, ops, priv);
>+		dpll_pin_parent_notify(ref->dpll, pin, parent,
>+				       DPLL_A_PIN_IDX);
>+	}
>+	mutex_unlock(&dpll_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_unregister);
>+
>+static struct dpll_device_registration *
>+dpll_device_registration_first(struct dpll_device *dpll)
>+{
>+	struct dpll_device_registration *reg;
>+
>+	reg = list_first_entry_or_null((struct list_head *) &dpll->registration_list,
>+				       struct dpll_device_registration, list);
>+	WARN_ON(!reg);
>+	return reg;
>+}
>+
>+/**
>+ * dpll_priv - get the dpll device private owner data
>+ * @dpll:      registered dpll pointer
>+ *
>+ * Return: pointer to the data
>+ */
>+void *dpll_priv(const struct dpll_device *dpll)

I don't see where you call this with const *. Avoid const here which
will allow you to remove the cast below.


>+{
>+	struct dpll_device_registration *reg;
>+
>+	reg = dpll_device_registration_first((struct dpll_device *) dpll);
>+	return reg->priv;
>+}
>+
>+const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll)
>+{
>+	struct dpll_device_registration *reg;
>+
>+	reg = dpll_device_registration_first(dpll);
>+	return reg->ops;
>+}
>+
>+static struct dpll_pin_registration *
>+dpll_pin_registration_first(struct dpll_pin_ref *ref)
>+{
>+	struct dpll_pin_registration *reg;
>+
>+	reg = list_first_entry_or_null(&ref->registration_list,
>+				       struct dpll_pin_registration, list);
>+	WARN_ON(!reg);
>+	return reg;
>+}
>+
>+/**
>+ * dpll_pin_on_dpll_priv - get the dpll device private owner data
>+ * @dpll:      registered dpll pointer
>+ * @pin:       pointer to a pin
>+ *
>+ * Return: pointer to the data
>+ */
>+void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
>+			    const struct dpll_pin *pin)
>+{
>+	struct dpll_pin_registration *reg;
>+	struct dpll_pin_ref *ref;
>+
>+	ref = xa_load((struct xarray *)&dpll->pin_refs, pin->pin_idx);

IDK, this sort of "unconst" cast always spells. Could you please
avoid them in the entire code?


>+	if (!ref)
>+		return NULL;
>+	reg = dpll_pin_registration_first(ref);
>+	return reg->priv;
>+}
>+
>+/**
>+ * dpll_pin_on_pin_priv - get the dpll pin private owner data
>+ * @parent: pointer to a parent pin
>+ * @pin: pointer to a pin
>+ *
>+ * Return: pointer to the data
>+ */
>+void *dpll_pin_on_pin_priv(const struct dpll_pin *parent,
>+			   const struct dpll_pin *pin)
>+{
>+	struct dpll_pin_registration *reg;
>+	struct dpll_pin_ref *ref;
>+
>+	ref = xa_load((struct xarray *)&pin->parent_refs, parent->pin_idx);
>+	if (!ref)
>+		return NULL;
>+	reg = dpll_pin_registration_first(ref);
>+	return reg->priv;
>+}
>+
>+const struct dpll_pin_ops *dpll_pin_ops(struct dpll_pin_ref *ref)
>+{
>+	struct dpll_pin_registration *reg;
>+
>+	reg = dpll_pin_registration_first(ref);
>+	return reg->ops;
>+}
>+
>+static int __init dpll_init(void)
>+{
>+	int ret;
>+
>+	ret = dpll_netlink_init();
>+	if (ret)
>+		goto error;
>+
>+	return 0;
>+
>+error:
>+	mutex_destroy(&dpll_xa_lock);
>+	return ret;
>+}
>+subsys_initcall(dpll_init);
>diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
>new file mode 100644
>index 000000000000..e905c1088568
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.h
>@@ -0,0 +1,113 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+#ifndef __DPLL_CORE_H__
>+#define __DPLL_CORE_H__
>+
>+#include <linux/dpll.h>
>+#include <linux/list.h>
>+#include <linux/refcount.h>
>+#include "dpll_netlink.h"
>+
>+#define DPLL_REGISTERED		XA_MARK_1
>+
>+struct dpll_device_registration {
>+	struct list_head list;
>+	const struct dpll_device_ops *ops;
>+	void *priv;
>+};
>+
>+/**
>+ * struct dpll_device - structure for a DPLL device
>+ * @id:			unique id number for each device
>+ * @dev_driver_id:	id given by dev driver
>+ * @clock_id:		unique identifier (clock_id) of a dpll
>+ * @module:		module of creator
>+ * @dev:		struct device for this dpll device
>+ * @parent:		parent device
>+ * @ops:		operations this &dpll_device supports
>+ * @lock:		mutex to serialize operations
>+ * @type:		type of a dpll
>+ * @pins:		list of pointers to pins registered with this dpll
>+ * @mode_supported_mask: mask of supported modes
>+ * @refcount:		refcount
>+ * @priv:		pointer to private information of owner
>+ **/
>+struct dpll_device {
>+	u32 id;
>+	u32 device_idx;
>+	u64 clock_id;
>+	struct module *module;
>+	struct device dev;
>+	struct device *parent;
>+	enum dpll_type type;
>+	struct xarray pin_refs;
>+	unsigned long mode_supported_mask;
>+	refcount_t refcount;
>+	struct list_head registration_list;
>+};
>+
>+/**
>+ * struct dpll_pin - structure for a dpll pin
>+ * @idx:		unique idx given by alloc on global pin's XA
>+ * @dev_driver_id:	id given by dev driver
>+ * @clock_id:		clock_id of creator
>+ * @module:		module of creator
>+ * @dpll_refs:		hold referencees to dplls that pin is registered with
>+ * @pin_refs:		hold references to pins that pin is registered with
>+ * @prop:		properties given by registerer
>+ * @rclk_dev_name:	holds name of device when pin can recover clock from it
>+ * @refcount:		refcount
>+ **/
>+struct dpll_pin {
>+	u32 id;
>+	u32 pin_idx;
>+	u64 clock_id;
>+	struct module *module;
>+	struct xarray dpll_refs;
>+	struct xarray parent_refs;
>+	struct dpll_pin_properties prop;
>+	char *rclk_dev_name;
>+	refcount_t refcount;
>+};
>+
>+struct dpll_pin_registration {
>+	struct list_head list;
>+	const struct dpll_pin_ops *ops;
>+	void *priv;
>+};
>+
>+/**
>+ * struct dpll_pin_ref - structure for referencing either dpll or pins
>+ * @dpll:		pointer to a dpll
>+ * @pin:		pointer to a pin
>+ * @registration_list	list of ops and priv data registered with the ref
>+ * @refcount:		refcount
>+ **/
>+struct dpll_pin_ref {
>+	union {
>+		struct dpll_device *dpll;
>+		struct dpll_pin *pin;
>+	};
>+	struct list_head registration_list;
>+	refcount_t refcount;
>+};
>+
>+void *dpll_priv(const struct dpll_device *dpll);
>+void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
>+			    const struct dpll_pin *pin);
>+void *dpll_pin_on_pin_priv(const struct dpll_pin *parent,
>+			   const struct dpll_pin *pin);
>+
>+const struct dpll_device_ops *dpll_device_ops(struct dpll_device *dpll);
>+struct dpll_device *dpll_device_get_by_id(int id);
>+struct dpll_device *dpll_device_get_by_name(const char *bus_name,
>+					    const char *dev_name);
>+const struct dpll_pin_ops *dpll_pin_ops(struct dpll_pin_ref *ref);
>+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs);
>+extern struct xarray dpll_device_xa;
>+extern struct xarray dpll_pin_xa;
>+extern struct mutex dpll_xa_lock;
>+#endif
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>new file mode 100644
>index 000000000000..1eb0b4a2fce4
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -0,0 +1,972 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ * Generic netlink for DPLL management framework
>+ *
>+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates

It's 2023. You still live in the past :)



>+ *
>+ */
>+#include <linux/module.h>
>+#include <linux/kernel.h>
>+#include <net/genetlink.h>
>+#include "dpll_core.h"
>+#include "dpll_nl.h"
>+#include <uapi/linux/dpll.h>
>+
>+struct dpll_dump_ctx {
>+	unsigned long idx;
>+};
>+
>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *cb)
>+{
>+	return (struct dpll_dump_ctx *)cb->ctx;
>+}
>+
>+static int
>+dpll_msg_add_dev_handle(struct sk_buff *msg, struct dpll_device *dpll)
>+{
>+	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
>+		return -EMSGSIZE;
>+	if (nla_put_string(msg, DPLL_A_BUS_NAME, dev_bus_name(&dpll->dev)))
>+		return -EMSGSIZE;
>+	if (nla_put_string(msg, DPLL_A_DEV_NAME, dev_name(&dpll->dev)))

In this version, only ID is a handle.


>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_mode(struct sk_buff *msg, struct dpll_device *dpll,
>+		  struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
>+	enum dpll_mode mode;
>+
>+	if (WARN_ON(!ops->mode_get))
>+		return -EOPNOTSUPP;
>+	if (ops->mode_get(dpll, dpll_priv(dpll), &mode, extack))
>+		return -EFAULT;
>+	if (nla_put_u8(msg, DPLL_A_MODE, mode))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_device *dpll,
>+			 struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
>+	enum dpll_lock_status status;
>+
>+	if (WARN_ON(!ops->lock_status_get))
>+		return -EOPNOTSUPP;
>+	if (ops->lock_status_get(dpll, dpll_priv(dpll), &status, extack))
>+		return -EFAULT;
>+	if (nla_put_u8(msg, DPLL_A_LOCK_STATUS, status))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll,
>+		  struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
>+	s32 temp;
>+
>+	if (!ops->temp_get)
>+		return -EOPNOTSUPP;
>+	if (ops->temp_get(dpll, dpll_priv(dpll), &temp, extack))
>+		return -EFAULT;
>+	if (nla_put_s32(msg, DPLL_A_TEMP, temp))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin *pin,
>+		      struct dpll_pin_ref *ref,
>+		      struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	const struct dpll_device *dpll = ref->dpll;
>+	u32 prio;
>+
>+	if (!ops->prio_get)
>+		return -EOPNOTSUPP;
>+	if (ops->prio_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			  dpll_priv(dpll), &prio, extack))
>+		return -EFAULT;
>+	if (nla_put_u32(msg, DPLL_A_PIN_PRIO, prio))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, const struct dpll_pin *pin,
>+			       struct dpll_pin_ref *ref,
>+			       struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	const struct dpll_device *dpll = ref->dpll;
>+	enum dpll_pin_state state;
>+
>+	if (!ops->state_on_dpll_get)
>+		return -EOPNOTSUPP;
>+	if (ops->state_on_dpll_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+				   dpll_priv(dpll), &state, extack))
>+		return -EFAULT;
>+	if (nla_put_u8(msg, DPLL_A_PIN_STATE, state))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin *pin,
>+			   struct dpll_pin_ref *ref,
>+			   struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	const struct dpll_device *dpll = ref->dpll;
>+	enum dpll_pin_direction direction;
>+
>+	if (!ops->direction_get)
>+		return -EOPNOTSUPP;
>+	if (ops->direction_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			       dpll_priv(dpll), &direction, extack))
>+		return -EFAULT;
>+	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
>+		      struct dpll_pin_ref *ref, struct netlink_ext_ack *extack,
>+		      bool dump_freq_supported)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	const struct dpll_device *dpll = ref->dpll;
>+	struct nlattr *nest;
>+	u64 freq;
>+	int fs;
>+
>+	if (!ops->frequency_get)
>+		return -EOPNOTSUPP;
>+	if (ops->frequency_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			       dpll_priv(dpll), &freq, extack))
>+		return -EFAULT;
>+	if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY, sizeof(freq), &freq, 0))
>+		return -EMSGSIZE;
>+	if (!dump_freq_supported)
>+		return 0;
>+	for (fs = 0; fs < pin->prop.freq_supported_num; fs++) {
>+		nest = nla_nest_start(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED);
>+		if (!nest)
>+			return -EMSGSIZE;
>+		freq = pin->prop.freq_supported[fs].min;
>+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MIN, sizeof(freq),
>+				   &freq, 0)) {
>+			nla_nest_cancel(msg, nest);
>+			return -EMSGSIZE;
>+		}
>+		freq = pin->prop.freq_supported[fs].max;
>+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MAX, sizeof(freq),
>+				   &freq, 0)) {
>+			nla_nest_cancel(msg, nest);
>+			return -EMSGSIZE;
>+		}
>+		nla_nest_end(msg, nest);
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_parents(struct sk_buff *msg, struct dpll_pin *pin,
>+			 struct netlink_ext_ack *extack)
>+{
>+	enum dpll_pin_state state;
>+	struct dpll_pin_ref *ref;
>+	struct dpll_pin *ppin;
>+	struct nlattr *nest;
>+	unsigned long index;
>+	int ret;
>+
>+	xa_for_each(&pin->parent_refs, index, ref) {
>+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+
>+		ppin = ref->pin;
>+
>+		if (WARN_ON(!ops->state_on_pin_get))
>+			return -EFAULT;
>+		ret = ops->state_on_pin_get(pin,
>+					    dpll_pin_on_pin_priv(ppin, pin),
>+					    ppin, &state, extack);
>+		if (ret)
>+			return -EFAULT;
>+		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
>+		if (!nest)
>+			return -EMSGSIZE;
>+		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX, ppin->pin_idx)) {
>+			ret = -EMSGSIZE;
>+			goto nest_cancel;
>+		}
>+		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
>+			ret = -EMSGSIZE;
>+			goto nest_cancel;
>+		}
>+		nla_nest_end(msg, nest);
>+	}
>+
>+	return 0;
>+
>+nest_cancel:
>+	nla_nest_cancel(msg, nest);
>+	return ret;
>+}
>+
>+static int
>+dpll_msg_add_pin_dplls(struct sk_buff *msg, struct dpll_pin *pin,
>+		       struct netlink_ext_ack *extack)
>+{
>+	struct dpll_pin_ref *ref;
>+	struct nlattr *attr;
>+	unsigned long index;
>+	int ret;
>+
>+	xa_for_each(&pin->dpll_refs, index, ref) {
>+		attr = nla_nest_start(msg, DPLL_A_DEVICE);
>+		if (!attr)
>+			return -EMSGSIZE;
>+		ret = dpll_msg_add_dev_handle(msg, ref->dpll);
>+		if (ret)
>+			goto nest_cancel;
>+		ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
>+		if (ret && ret != -EOPNOTSUPP)
>+			goto nest_cancel;
>+		ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
>+		if (ret && ret != -EOPNOTSUPP)
>+			goto nest_cancel;
>+		nla_nest_end(msg, attr);
>+	}
>+
>+	return 0;
>+
>+nest_cancel:
>+	nla_nest_end(msg, attr);
>+	return ret;
>+}
>+
>+static int
>+dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
>+			  struct dpll_pin_ref *ref, struct netlink_ext_ack *extack)
>+{
>+	int ret;
>+
>+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->pin_idx))
>+		return -EMSGSIZE;
>+	if (nla_put_string(msg, DPLL_A_PIN_LABEL, pin->prop.label))
>+		return -EMSGSIZE;
>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
>+		return -EMSGSIZE;
>+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
>+		return -EMSGSIZE;
>+	ret = dpll_msg_add_pin_direction(msg, pin, ref, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_pin_freq(msg, pin, ref, extack, true);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	if (pin->rclk_dev_name)
>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>+				   pin->rclk_dev_name))
>+			return -EMSGSIZE;
>+	return 0;
>+}
>+
>+static int
>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
>+			struct netlink_ext_ack *extack)
>+{
>+	struct dpll_pin_ref *ref;
>+	int ret;
>+
>+	ref = dpll_xa_ref_dpll_first(&pin->dpll_refs);
>+	if (!ref)
>+		return -EFAULT;
>+	ret = dpll_cmd_pin_fill_details(msg, pin, ref, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_pin_parents(msg, pin, extack);
>+	if (ret)
>+		return ret;
>+	if (!xa_empty(&pin->dpll_refs)) {
>+		ret = dpll_msg_add_pin_dplls(msg, pin, extack);
>+		if (ret)
>+			return ret;
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_device_get_one(struct dpll_device *dpll, struct sk_buff *msg,
>+		    struct netlink_ext_ack *extack)
>+{
>+	enum dpll_mode mode;
>+	int ret;
>+
>+	ret = dpll_msg_add_dev_handle(msg, dpll);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_temp(msg, dpll, extack);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ret = dpll_msg_add_lock_status(msg, dpll, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_mode(msg, dpll, extack);
>+	if (ret)
>+		return ret;
>+	for (mode = DPLL_MODE_UNSPEC + 1; mode <= DPLL_MODE_MAX; mode++)
>+		if (test_bit(mode, &dpll->mode_supported_mask))
>+			if (nla_put_s32(msg, DPLL_A_MODE_SUPPORTED, mode))
>+				return -EMSGSIZE;
>+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(dpll->clock_id),
>+			  &dpll->clock_id, 0))
>+		return -EMSGSIZE;
>+	if (nla_put_u8(msg, DPLL_A_TYPE, dpll->type))
>+		return -EMSGSIZE;
>+
>+	return ret;
>+}
>+
>+static bool dpll_pin_is_freq_supported(struct dpll_pin *pin, u32 freq)
>+{
>+	int fs;
>+
>+	for (fs = 0; fs < pin->prop.freq_supported_num; fs++)
>+		if (freq >=  pin->prop.freq_supported[fs].min &&
>+		    freq <=  pin->prop.freq_supported[fs].max)
>+			return true;
>+	return false;
>+}
>+
>+static int
>+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
>+		  struct netlink_ext_ack *extack)
>+{
>+	u64 freq = nla_get_u64(a);
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+	int ret;
>+
>+	if (!dpll_pin_is_freq_supported(pin, freq))
>+		return -EINVAL;
>+
>+	xa_for_each(&pin->dpll_refs, i, ref) {
>+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+		struct dpll_device *dpll = ref->dpll;
>+
>+		ret = ops->frequency_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>+					 dpll, dpll_priv(dpll), freq, extack);
>+		if (ret)
>+			return -EFAULT;
>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_FREQUENCY);
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_on_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
>+			  u32 parent_idx, enum dpll_pin_state state,
>+			  struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops;
>+	struct dpll_pin_ref *pin_ref, *parent_ref;
>+
>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
>+		return -EOPNOTSUPP;
>+	parent_ref = xa_load(&pin->parent_refs, parent_idx);
>+	       //	dpll_pin_get_by_idx(dpll, parent_idx);

Leftover?



>+	if (!parent_ref)
>+		return -EINVAL;
>+	pin_ref = xa_load(&dpll->pin_refs, pin->pin_idx);
>+	if (!pin_ref)
>+		return -EINVAL;
>+	ops = dpll_pin_ops(pin_ref);
>+	if (!ops->state_on_pin_set)
>+		return -EOPNOTSUPP;
>+	if (ops->state_on_pin_set(pin_ref->pin,
>+				  dpll_pin_on_pin_priv(parent_ref->pin,
>+						       pin_ref->pin),
>+				  parent_ref->pin, state, extack))
>+		return -EFAULT;
>+	dpll_pin_parent_notify(dpll, pin_ref->pin, parent_ref->pin,
>+			       DPLL_A_PIN_STATE);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
>+		   enum dpll_pin_state state,
>+		   struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops;
>+	struct dpll_pin_ref *ref;
>+
>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
>+		return -EOPNOTSUPP;
>+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+	if (!ref)
>+		return -EFAULT;
>+	ops = dpll_pin_ops(ref);
>+	if (!ops->state_on_dpll_set)
>+		return -EOPNOTSUPP;
>+	if (ops->state_on_dpll_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+				   dpll_priv(dpll), state, extack))
>+		return -EINVAL;
>+	dpll_pin_notify(dpll, pin, DPLL_A_PIN_STATE);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
>+		  struct nlattr *prio_attr, struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops;
>+	struct dpll_pin_ref *ref;
>+	u32 prio = nla_get_u8(prio_attr);
>+
>+	if (!(DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE & pin->prop.capabilities))
>+		return -EOPNOTSUPP;
>+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+	if (!ref)
>+		return -EFAULT;
>+	ops = dpll_pin_ops(ref);
>+	if (!ops->prio_set)
>+		return -EOPNOTSUPP;
>+	if (ops->prio_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			  dpll_priv(dpll), prio, extack))
>+		return -EINVAL;
>+	dpll_pin_notify(dpll, pin, DPLL_A_PIN_PRIO);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
>+		       struct netlink_ext_ack *extack)
>+{
>+	enum dpll_pin_direction direction = nla_get_u8(a);
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop.capabilities))
>+		return -EOPNOTSUPP;
>+
>+	xa_for_each(&pin->dpll_refs, i, ref) {
>+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+		struct dpll_device *dpll = ref->dpll;
>+
>+		if (ops->direction_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>+				       dpll, dpll_priv(dpll), direction,
>+				       extack))
>+			return -EFAULT;
>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_DIRECTION);
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_set_from_nlattr(struct dpll_device *dpll,
>+			 struct dpll_pin *pin, struct genl_info *info)
>+{
>+	enum dpll_pin_state state = DPLL_PIN_STATE_UNSPEC;
>+	bool parent_present = false;
>+	int rem, ret = -EINVAL;
>+	struct nlattr *a;
>+	u32 parent_idx;
>+
>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(a)) {
>+		case DPLL_A_PIN_FREQUENCY:
>+			ret = dpll_pin_freq_set(pin, a, info->extack);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLL_A_PIN_DIRECTION:
>+			ret = dpll_pin_direction_set(pin, a, info->extack);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLL_A_PIN_PRIO:
>+			ret = dpll_pin_prio_set(dpll, pin, a, info->extack);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLL_A_PIN_PARENT_IDX:

See my comment for dpll_pin_pre_doit(), please change this to
PIN_PARENT_ID and use uniqueue xarray id handle for parent pin.


>+			parent_present = true;
>+			parent_idx = nla_get_u32(a);
>+			break;
>+		case DPLL_A_PIN_STATE:
>+			state = nla_get_u8(a);
>+			break;
>+		default:
>+			break;
>+		}


Why do you have to iterate here? Why simple
	if (attr_x)
		ret = dpll_pin_x_set()

is not enough?

Is it because of state? if yes:
	if (attr_state)
		if (attr_parent)
			dpll_pin_on_pin_state_set()
		else
			dpll_pin_state_set()




>+	}
>+	if (state != DPLL_PIN_STATE_UNSPEC) {
>+		if (!parent_present) {
>+			ret = dpll_pin_state_set(dpll, pin, state,
>+						 info->extack);
>+			if (ret)
>+				return ret;
>+		} else {
>+			ret = dpll_pin_on_pin_state_set(dpll, pin, parent_idx,
>+							state, info->extack);
>+			if (ret)
>+				return ret;
>+		}
>+	}
>+
>+	return ret;
>+}
>+
>+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct dpll_pin *pin = info->user_ptr[1];
>+
>+	return dpll_pin_set_from_nlattr(dpll, pin, info);
>+}
>+
>+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_pin *pin = info->user_ptr[1];
>+	struct sk_buff *msg;
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	if (!pin)
>+		return -ENODEV;
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
>+				DPLL_CMD_PIN_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+	ret = __dpll_cmd_pin_dump_one(msg, pin, info->extack);
>+	if (ret) {
>+		nlmsg_free(msg);
>+		return ret;
>+	}
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
>+}
>+
>+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
>+{
>+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>+	struct dpll_pin *pin;
>+	struct nlattr *hdr;
>+	unsigned long i;
>+	int ret = 0;
>+
>+	xa_for_each_start(&dpll_pin_xa, i, pin, ctx->idx) {
>+		if (xa_empty(&pin->dpll_refs))
>+			continue;
>+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
>+				  cb->nlh->nlmsg_seq,
>+				  &dpll_nl_family, NLM_F_MULTI,
>+				  DPLL_CMD_PIN_GET);
>+		if (!hdr) {
>+			ret = -EMSGSIZE;
>+			break;
>+		}
>+		ret = __dpll_cmd_pin_dump_one(skb, pin, cb->extack);
>+		if (ret) {
>+			genlmsg_cancel(skb, hdr);
>+			break;
>+		}
>+		genlmsg_end(skb, hdr);
>+	}
>+	if (ret == -EMSGSIZE) {
>+		ctx->idx = i;
>+		return skb->len;
>+	}
>+	return ret;
>+}
>+
>+static int
>+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
>+{
>+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
>+	struct nlattr *attr;
>+	enum dpll_mode mode;
>+	int rem, ret = 0;
>+
>+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(attr)) {
>+		case DPLL_A_MODE:

Again, why loop? I don't see any sane reason, is there any?



>+			mode = nla_get_u8(attr);
>+
>+			ret = ops->mode_set(dpll, dpll_priv(dpll), mode,
>+					    info->extack);
>+			if (ret)
>+				return ret;
>+			break;
>+		default:
>+			break;
>+		}
>+	}
>+
>+	return ret;
>+}
>+
>+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+
>+	return dpll_set_from_nlattr(dpll, info);
>+}
>+
>+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct sk_buff *msg;
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
>+				DPLL_CMD_DEVICE_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	ret = dpll_device_get_one(dpll, msg, info->extack);
>+	if (ret) {
>+		nlmsg_free(msg);
>+		return ret;
>+	}
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
>+}
>+
>+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
>+{
>+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>+	struct dpll_device *dpll;
>+	struct nlattr *hdr;
>+	unsigned long i;
>+	int ret = 0;
>+
>+	xa_for_each_start(&dpll_device_xa, i, dpll, ctx->idx) {
>+		if (!xa_get_mark(&dpll_device_xa, i, DPLL_REGISTERED))
>+			continue;
>+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
>+				  cb->nlh->nlmsg_seq, &dpll_nl_family,
>+				  NLM_F_MULTI, DPLL_CMD_DEVICE_GET);
>+		if (!hdr) {
>+			ret = -EMSGSIZE;
>+			break;
>+		}
>+		ret = dpll_device_get_one(dpll, skb, cb->extack);
>+		if (ret) {
>+			genlmsg_cancel(skb, hdr);
>+			break;
>+		}
>+		genlmsg_end(skb, hdr);
>+	}
>+	if (ret == -EMSGSIZE) {
>+		ctx->idx = i;
>+		return skb->len;
>+	}
>+	return ret;
>+}
>+
>+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		  struct genl_info *info)
>+{
>+	struct dpll_device *dpll_id = NULL;
>+	u32 id;
>+
>+	if (!info->attrs[DPLL_A_ID])
>+		return -EINVAL;
>+
>+	mutex_lock(&dpll_xa_lock);
>+	id = nla_get_u32(info->attrs[DPLL_A_ID]);
>+
>+	dpll_id = dpll_device_get_by_id(id);
>+	if (!dpll_id)
>+		goto unlock;
>+	info->user_ptr[0] = dpll_id;
>+	return 0;
>+unlock:
>+	mutex_unlock(&dpll_xa_lock);
>+	return -ENODEV;
>+}
>+
>+void dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		    struct genl_info *info)
>+{
>+	mutex_unlock(&dpll_xa_lock);
>+}
>+
>+int dpll_pre_dumpit(struct netlink_callback *cb)
>+{
>+	mutex_lock(&dpll_xa_lock);
>+
>+	return 0;
>+}
>+
>+int dpll_post_dumpit(struct netlink_callback *cb)
>+{
>+	mutex_unlock(&dpll_xa_lock);
>+
>+	return 0;
>+}
>+
>+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		      struct genl_info *info)
>+{
>+	int ret = dpll_pre_doit(ops, skb, info);
>+	struct dpll_pin_ref *pin_ref;
>+	struct dpll_device *dpll;
>+
>+	if (ret)
>+		return ret;
>+	dpll = info->user_ptr[0];
>+	if (!info->attrs[DPLL_A_PIN_IDX]) {
>+		ret = -EINVAL;
>+		goto unlock_dev;
>+	}
>+	pin_ref = xa_load(&dpll->pin_refs,
>+			  nla_get_u32(info->attrs[DPLL_A_PIN_IDX]));

This is inconsistent, also incorrect.

You use DPLL_A_ID that is stored in dpll_device_xa as a handle for device.
That is fine if we consider Jakub's desire to have this randomly
generated id as a handle (I find is questinable, but can live with it).

But pins are independent on a single DPLL and could be attached to
multiple ones. Using a single DPLL_A_ID as handle here (dpll_pre_doit)
for all operations is plain wrong.

For example for frequency or direction set, you don't need it in code as
you iterate over all attacheds DPLL devices. Confusing to require DPLL
device handle for that operation when you change setup for all of them.
That is wrong.

Also, you have global dpll_pin_xa. Yet you don't expose this ID over
netlink. To be consistent with device handle, you should:
1) expose pin->id over DPLL_A_PIN_ID
2) use this DPLL_A_PIN_ID as a sole pin handle for dpll_pin_xa lookup.

For DPLL-PIN tuple operations (prio_set and state_on_dpll_set)
you should process the dpll device handle (DPLL_A_ID) where it is needed
In the similar way you process parent id now where is it needed
(state_on_pin_set)

For GET/DUMP command, this does not also make sense.
Check out __dpll_cmd_pin_dump_one()

You just use the "first dpll" for the handle. Just use the pin->id as I
suggested above.

Makes sense?

Please make sure you maintain the same handle attrs in the notification
messages as well.



>+	if (!pin_ref) {
>+		ret = -ENODEV;
>+		goto unlock_dev;
>+	}
>+	info->user_ptr[1] = pin_ref->pin;
>+
>+	return 0;
>+
>+unlock_dev:
>+	mutex_unlock(&dpll_xa_lock);
>+	return ret;
>+}
>+
>+void dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+			struct genl_info *info)
>+{
>+	dpll_post_doit(ops, skb, info);
>+}
>+
>+int dpll_pin_pre_dumpit(struct netlink_callback *cb)
>+{
>+	return dpll_pre_dumpit(cb);
>+}
>+
>+int dpll_pin_post_dumpit(struct netlink_callback *cb)
>+{
>+	return dpll_post_dumpit(cb);
>+}
>+
>+static int
>+dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
>+			 struct dpll_pin *pin, struct dpll_pin *parent,
>+			 enum dplla attr)
>+{
>+	int ret = dpll_msg_add_dev_handle(msg, dpll);
>+	struct dpll_pin_ref *ref = NULL;

Pointless init.


>+	enum dpll_pin_state state;
>+
>+	if (ret)
>+		return ret;
>+	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin->pin_idx))
>+		return -EMSGSIZE;
>+
>+	switch (attr) {
>+	case DPLL_A_MODE:
>+		ret = dpll_msg_add_mode(msg, dpll, NULL);
>+		break;
>+	case DPLL_A_LOCK_STATUS:
>+		ret = dpll_msg_add_lock_status(msg, dpll, NULL);
>+		break;
>+	case DPLL_A_TEMP:
>+		ret = dpll_msg_add_temp(msg, dpll, NULL);
>+		break;
>+	case DPLL_A_PIN_FREQUENCY:
>+		ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+		if (!ref)
>+			return -EFAULT;
>+		ret = dpll_msg_add_pin_freq(msg, pin, ref, NULL, false);
>+		break;
>+	case DPLL_A_PIN_PRIO:
>+		ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+		if (!ref)
>+			return -EFAULT;
>+		ret = dpll_msg_add_pin_prio(msg, pin, ref, NULL);

Why exactly did you ignore my request I put in the previous version
review asking to maintain the same nesting scheme for GET cmd and
notification messages? Honestly, the silent ignores I'm getting
all along the review of this patchset is very frustrating. Please don't
do it. Either ack and change or provide exaplanation why your code is
fine.

So could you please fix this?
Again, please make sure that the notification messages have attributes
in exactly the same place as GET cmd (think of it as the rest of the
attrs in the message is filtered out). Makes possible to use the same
userspace parsing code both messages.



>+		break;
>+	case DPLL_A_PIN_STATE:
>+		if (parent) {
>+			const struct dpll_pin_ops *ops;
>+			void *priv = dpll_pin_on_pin_priv(parent, pin);
>+
>+			ref = xa_load(&pin->parent_refs, parent->pin_idx);
>+			if (!ref)
>+				return -EFAULT;
>+			ops = dpll_pin_ops(ref);
>+			if (!ops->state_on_pin_get)
>+				return -EOPNOTSUPP;
>+			ret = ops->state_on_pin_get(pin, priv, parent,
>+						    &state, NULL);
>+			if (ret)
>+				return ret;
>+			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>+					parent->pin_idx))
>+				return -EMSGSIZE;
>+		} else {
>+			ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+			if (!ref)
>+				return -EFAULT;
>+			ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref,
>+							     NULL);
>+			if (ret)
>+				return ret;
>+		}
>+		break;
>+	default:
>+		break;
>+	}
>+
>+	return ret;
>+}
>+
>+static int
>+dpll_send_event_create(enum dpll_event event, struct dpll_device *dpll)
>+{
>+	struct sk_buff *msg;
>+	int ret = -EMSGSIZE;
>+	void *hdr;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
>+	if (!hdr)
>+		goto out_free_msg;
>+
>+	ret = dpll_msg_add_dev_handle(msg, dpll);
>+	if (ret)
>+		goto out_cancel_msg;
>+	genlmsg_end(msg, hdr);
>+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
>+
>+	return 0;
>+
>+out_cancel_msg:
>+	genlmsg_cancel(msg, hdr);
>+out_free_msg:
>+	nlmsg_free(msg);
>+
>+	return ret;
>+}
>+
>+static int
>+dpll_send_event_change(struct dpll_device *dpll, struct dpll_pin *pin,
>+		       struct dpll_pin *parent, enum dplla attr)
>+{
>+	struct sk_buff *msg;
>+	int ret = -EMSGSIZE;
>+	void *hdr;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0,
>+			  DPLL_EVENT_DEVICE_CHANGE);
>+	if (!hdr)
>+		goto out_free_msg;
>+
>+	ret = dpll_event_device_change(msg, dpll, pin, parent, attr);
>+	if (ret)
>+		goto out_cancel_msg;
>+	genlmsg_end(msg, hdr);
>+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
>+
>+	return 0;
>+
>+out_cancel_msg:
>+	genlmsg_cancel(msg, hdr);
>+out_free_msg:
>+	nlmsg_free(msg);
>+
>+	return ret;
>+}
>+
>+int dpll_notify_device_create(struct dpll_device *dpll)
>+{
>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_CREATE, dpll);
>+}
>+
>+int dpll_notify_device_delete(struct dpll_device *dpll)
>+{
>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_DELETE, dpll);

Quite odd. Consider rename of dpll_send_event_create()


>+}
>+
>+int dpll_device_notify(struct dpll_device *dpll, enum dplla attr)
>+{
>+	if (WARN_ON(!dpll))
>+		return -EINVAL;
>+
>+	return dpll_send_event_change(dpll, NULL, NULL, attr);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_notify);
>+
>+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>+		    enum dplla attr)
>+{
>+	return dpll_send_event_change(dpll, pin, NULL, attr);
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_notify);
>+
>+int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>+			   struct dpll_pin *parent, enum dplla attr)
>+{
>+	return dpll_send_event_change(dpll, pin, parent, attr);
>+}
>+
>+int __init dpll_netlink_init(void)
>+{
>+	return genl_register_family(&dpll_nl_family);
>+}
>+
>+void dpll_netlink_finish(void)
>+{
>+	genl_unregister_family(&dpll_nl_family);
>+}
>+
>+void __exit dpll_netlink_fini(void)
>+{
>+	dpll_netlink_finish();
>+}
>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>new file mode 100644
>index 000000000000..952e0335595e
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -0,0 +1,27 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+/**
>+ * dpll_notify_device_create - notify that the device has been created
>+ * @dpll: registered dpll pointer
>+ *
>+ * Return: 0 if succeeds, error code otherwise.
>+ */
>+int dpll_notify_device_create(struct dpll_device *dpll);
>+
>+
>+/**
>+ * dpll_notify_device_delete - notify that the device has been deleted
>+ * @dpll: registered dpll pointer
>+ *
>+ * Return: 0 if succeeds, error code otherwise.
>+ */
>+int dpll_notify_device_delete(struct dpll_device *dpll);
>+
>+int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>+			   struct dpll_pin *parent, enum dplla attr);
>+
>+int __init dpll_netlink_init(void);
>+void dpll_netlink_finish(void);
>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>new file mode 100644
>index 000000000000..5194efaf55a8
>--- /dev/null
>+++ b/include/linux/dpll.h
>@@ -0,0 +1,274 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>+ *  Copyright (c) 2023 Intel and affiliates
>+ */
>+
>+#ifndef __DPLL_H__
>+#define __DPLL_H__
>+
>+#include <uapi/linux/dpll.h>
>+#include <linux/device.h>
>+#include <linux/netlink.h>
>+
>+struct dpll_device;
>+struct dpll_pin;
>+
>+struct dpll_device_ops {
>+	int (*mode_get)(const struct dpll_device *dpll, void *dpll_priv,
>+			enum dpll_mode *mode, struct netlink_ext_ack *extack);
>+	int (*mode_set)(const struct dpll_device *dpll, void *dpll_priv,
>+			const enum dpll_mode mode,
>+			struct netlink_ext_ack *extack);
>+	bool (*mode_supported)(const struct dpll_device *dpll, void *dpll_priv,
>+			       const enum dpll_mode mode,
>+			       struct netlink_ext_ack *extack);
>+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
>+				  void *dpll_priv,
>+				  u32 *pin_idx,
>+				  struct netlink_ext_ack *extack);
>+	int (*lock_status_get)(const struct dpll_device *dpll, void *dpll_priv,
>+			       enum dpll_lock_status *status,
>+			       struct netlink_ext_ack *extack);
>+	int (*temp_get)(const struct dpll_device *dpll, void *dpll_priv,
>+			s32 *temp, struct netlink_ext_ack *extack);
>+};
>+
>+struct dpll_pin_ops {
>+	int (*frequency_set)(const struct dpll_pin *pin, void *pin_priv,
>+			     const struct dpll_device *dpll, void *dpll_priv,
>+			     const u64 frequency,
>+			     struct netlink_ext_ack *extack);
>+	int (*frequency_get)(const struct dpll_pin *pin, void *pin_priv,
>+			     const struct dpll_device *dpll, void *dpll_priv,
>+			     u64 *frequency, struct netlink_ext_ack *extack);
>+	int (*direction_set)(const struct dpll_pin *pin, void *pin_priv,
>+			     const struct dpll_device *dpll, void *dpll_priv,
>+			     const enum dpll_pin_direction direction,
>+			     struct netlink_ext_ack *extack);
>+	int (*direction_get)(const struct dpll_pin *pin, void *pin_priv,
>+			     const struct dpll_device *dpll, void *dpll_priv,
>+			     enum dpll_pin_direction *direction,
>+			     struct netlink_ext_ack *extack);
>+	int (*state_on_pin_get)(const struct dpll_pin *pin, void *pin_priv,
>+				const struct dpll_pin *parent_pin,
>+				enum dpll_pin_state *state,
>+				struct netlink_ext_ack *extack);
>+	int (*state_on_dpll_get)(const struct dpll_pin *pin, void *pin_priv,
>+				 const struct dpll_device *dpll,
>+				 void *dpll_priv, enum dpll_pin_state *state,
>+				 struct netlink_ext_ack *extack);
>+	int (*state_on_pin_set)(const struct dpll_pin *pin, void *pin_priv,
>+				const struct dpll_pin *parent_pin,
>+				const enum dpll_pin_state state,
>+				struct netlink_ext_ack *extack);
>+	int (*state_on_dpll_set)(const struct dpll_pin *pin, void *pin_priv,
>+				 const struct dpll_device *dpll,
>+				 void *dpll_priv,
>+				 const enum dpll_pin_state state,
>+				 struct netlink_ext_ack *extack);
>+	int (*prio_get)(const struct dpll_pin *pin,  void *pin_priv,
>+			const struct dpll_device *dpll,  void *dpll_priv,
>+			u32 *prio, struct netlink_ext_ack *extack);
>+	int (*prio_set)(const struct dpll_pin *pin, void *pin_priv,
>+			const struct dpll_device *dpll, void *dpll_priv,
>+			const u32 prio, struct netlink_ext_ack *extack);
>+};
>+
>+struct dpll_pin_frequency {
>+	u64 min;
>+	u64 max;
>+};
>+
>+#define DPLL_PIN_FREQUENCY_RANGE(_min, _max)	\
>+	{					\
>+		.min = _min,			\
>+		.max = _max,			\
>+	}
>+
>+#define DPLL_PIN_FREQUENCY(_val) DPLL_PIN_FREQUENCY_RANGE(_val, _val)
>+#define DPLL_PIN_FREQUENCY_1PPS \
>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_1_HZ)
>+#define DPLL_PIN_FREQUENCY_10MHZ \
>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_10_MHZ)
>+#define DPLL_PIN_FREQUENCY_IRIG_B \
>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_10_KHZ)
>+#define DPLL_PIN_FREQUENCY_DCF77 \
>+	DPLL_PIN_FREQUENCY(DPLL_PIN_FREQUENCY_77_5_KHZ)
>+
>+struct dpll_pin_properties {
>+	const char *label;
>+	enum dpll_pin_type type;
>+	unsigned long capabilities;
>+	u32 freq_supported_num;
>+	struct dpll_pin_frequency *freq_supported;
>+};
>+
>+/**
>+ * dpll_device_get - find or create dpll_device object
>+ * @clock_id: a system unique number for a device
>+ * @dev_driver_id: index of dpll device on parent device
>+ * @module: register module
>+ *
>+ * Returns:
>+ * * pointer to initialized dpll - success
>+ * * NULL - memory allocation fail
>+ */
>+struct dpll_device
>+*dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module);
>+
>+/**
>+ * dpll_device_put - caller drops reference to the device, free resources
>+ * @dpll: dpll device pointer
>+ *
>+ * If all dpll_device_get callers drops their reference, the dpll device
>+ * resources are freed.
>+ */
>+void dpll_device_put(struct dpll_device *dpll);
>+
>+/**
>+ * dpll_device_register - register device, make it visible in the subsystem.
>+ * @dpll: reference previously allocated with dpll_device_get
>+ * @type: type of dpll
>+ * @ops: callbacks
>+ * @priv: private data of registerer
>+ * @owner: device struct of the owner
>+ *
>+ */
>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>+			 const struct dpll_device_ops *ops, void *priv,
>+			 struct device *owner);
>+
>+/**
>+ * dpll_device_unregister - deregister registered dpll
>+ * @dpll: pointer to dpll
>+ * @ops: ops for a dpll device
>+ * @priv: pointer to private information of owner
>+ *
>+ * Unregister the dpll from the subsystem, make it unavailable for netlink
>+ * API users.
>+ */
>+void dpll_device_unregister(struct dpll_device *dpll,
>+			    const struct dpll_device_ops *ops, void *priv);
>+
>+/**
>+ * dpll_pin_get - get reference or create new pin object
>+ * @clock_id: a system unique number of a device
>+ * @@dev_driver_id: index of dpll device on parent device
>+ * @module: register module
>+ * @pin_prop: constant properities of a pin
>+ *
>+ * find existing pin with given clock_id, @dev_driver_id and module, or create new
>+ * and returen its reference.
>+ *
>+ * Returns:
>+ * * pointer to initialized pin - success
>+ * * NULL - memory allocation fail
>+ */
>+struct dpll_pin
>+*dpll_pin_get(u64 clock_id, u32 dev_driver_id, struct module *module,
>+	      const struct dpll_pin_properties *prop);
>+
>+/**
>+ * dpll_pin_register - register pin with a dpll device
>+ * @dpll: pointer to dpll object to register pin with
>+ * @pin: pointer to allocated pin object being registered with dpll
>+ * @ops: struct with pin ops callbacks
>+ * @priv: private data pointer passed when calling callback ops
>+ * @rclk_device: pointer to device struct if pin is used for recovery of a clock
>+ * from that device
>+ *
>+ * Register previously allocated pin object with a dpll device.
>+ *
>+ * Return:
>+ * * 0 - if pin was registered with a parent pin,
>+ * * -ENOMEM - failed to allocate memory,
>+ * * -EEXIST - pin already registered with this dpll,
>+ * * -EBUSY - couldn't allocate id for a pin.
>+ */

I don't follow. In one of the previous version reviews I asked if you
can have the function docs only in one place, preferably in .c. But you
have there here in .h as well. Why? They are inconsistent. Could you
please remove them from .h?



>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>+		      const struct dpll_pin_ops *ops, void *priv,
>+		      struct device *rclk_device);

As I asked in the previous version, could you please remove this rclk_device
pointer. This is replaced by my patch allowing to expose dpll pin for
netdev over RTnetlink.



>+
>+/**
>+ * dpll_pin_unregister - deregister pin from a dpll device
>+ * @dpll: pointer to dpll object to deregister pin from
>+ * @pin: pointer to allocated pin object being deregistered from dpll
>+ * @ops: ops for a dpll pin ops
>+ * @priv: pointer to private information of owner
>+ *
>+ * Deregister previously registered pin object from a dpll device.
>+ *
>+ */
>+void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
>+			 const struct dpll_pin_ops *ops, void *priv);
>+
>+/**
>+ * dpll_pin_put - drop reference to a pin acquired with dpll_pin_get
>+ * @pin: pointer to allocated pin
>+ *
>+ * Pins shall be deregistered from all dpll devices before putting them,
>+ * otherwise the memory won't be freed.
>+ */
>+void dpll_pin_put(struct dpll_pin *pin);
>+
>+/**
>+ * dpll_pin_on_pin_register - register a pin to a muxed-type pin
>+ * @parent: parent pin pointer
>+ * @pin: pointer to allocated pin object being registered with a parent pin
>+ * @ops: struct with pin ops callbacks
>+ * @priv: private data pointer passed when calling callback ops
>+ * @rclk_device: pointer to device struct if pin is used for recovery of a clock
>+ * from that device
>+ *
>+ * In case of multiplexed pins, allows registring them under a single
>+ * parent pin.
>+ *
>+ * Return:
>+ * * 0 - if pin was registered with a parent pin,
>+ * * -ENOMEM - failed to allocate memory,
>+ * * -EEXIST - pin already registered with this parent pin,
>+ */
>+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
>+			     const struct dpll_pin_ops *ops, void *priv,
>+			     struct device *rclk_device);
>+
>+/**
>+ * dpll_pin_on_pin_register - register a pin to a muxed-type pin
>+ * @parent: parent pin pointer
>+ * @pin: pointer to allocated pin object being registered with a parent pin
>+ * @ops: struct with pin ops callbacks
>+ * @priv: private data pointer passed when calling callback ops
>+ * @rclk_device: pointer to device struct if pin is used for recovery of a clock
>+ * from that device
>+ *
>+ * In case of multiplexed pins, allows registring them under a single
>+ * parent pin.
>+ *
>+ * Return:
>+ * * 0 - if pin was registered with a parent pin,
>+ * * -ENOMEM - failed to allocate memory,
>+ * * -EEXIST - pin already registered with this parent pin,
>+ */
>+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
>+				const struct dpll_pin_ops *ops, void *priv);
>+
>+/**
>+ * dpll_device_notify - notify on dpll device change
>+ * @dpll: dpll device pointer
>+ * @attr: changed attribute
>+ *
>+ * Broadcast event to the netlink multicast registered listeners.
>+ *
>+ * Return:
>+ * * 0 - success
>+ * * negative - error
>+ */
>+int dpll_device_notify(struct dpll_device *dpll, enum dplla attr);
>+
>+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>+		    enum dplla attr);
>+
>+
>+
>+#endif
>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>index e188bc189754..75eeaa4396eb 100644
>--- a/include/uapi/linux/dpll.h
>+++ b/include/uapi/linux/dpll.h
>@@ -111,6 +111,8 @@ enum dpll_pin_direction {
> 
> #define DPLL_PIN_FREQUENCY_1_HZ		1
> #define DPLL_PIN_FREQUENCY_10_MHZ	10000000
>+#define DPLL_PIN_FREQUENCY_10_KHZ	10000
>+#define DPLL_PIN_FREQUENCY_77_5_KHZ	77500
> 
> /**
>  * enum dpll_pin_state - defines possible states of a pin, valid values for
>-- 
>2.34.1
>
