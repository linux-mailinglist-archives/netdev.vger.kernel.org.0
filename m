Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A426C5F9BBD
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiJJJSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 05:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJJJSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 05:18:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D011CB37
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 02:18:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g27so15011697edf.11
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 02:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P28XwJDjt+5FMihgLuMYtc4kKSgxdk5eVdULVNV/m+I=;
        b=j9F9syh+B/gLyWwplvjbN86VV9yFVWmuUTbCuy/KN7v+4AKAAjUtZaLEPOOb2hRYn0
         7HRn6KiiWqt6fMVf+REdcIQm/e+yoj5+Koi67Nbux6E/j3a2YT+1TNfDao7W1f3GxrX7
         GdA1a3bqkhZth8HRntWG+MjkaLry7mlJAWtjdxHVI+FFmnm8qsMgFwFHtLlZ+FLMdRTE
         1qAiIgKHCLKZKwZQcr7ieGS5cs/0WeK9WvZN5AtpWppPgoQoXo3WHeUs2Yqe+ODJRnn3
         FFlS9SJbTtJbKcc+1Lq/9hiZrv1nqaYUttNcdSEf4IsLnphiNamcuAlBARhXbRj2XbGn
         3Zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P28XwJDjt+5FMihgLuMYtc4kKSgxdk5eVdULVNV/m+I=;
        b=56LUMYt1cJpCIAxb0VE/zJyv8JGEaqMPmHRSljeSttIgZzdob37P2YSSV0GQ2X4Ms7
         P+DARhQ9kJuCyADj12CuozwYiA2GszPeMnqQD/kK4tHmRB4c01UtUJa1anIb0Hb1coSO
         BOkrgu5fLUMPiAKtrbD3XhDh+iYbJAyBOOczh0zHflh8gP/6Yk32GdMa2f/kButqqijm
         Vyl5ig72emzY0UaB4cfazSIIjFytUpfROOV9C+HL1WP1zlw+ipBXr5J+JCpE+sAskLNO
         t4S4sTxjbv+CaFT/aN4N08lWzIhHFXqvE30g0KEz4vN1dWMjBjimCR/zVCx/hTtixTFi
         dRdg==
X-Gm-Message-State: ACrzQf1Kht0VEMHcJ3o4Y2ir2unc+40dFigjFrUQyStk+Z8bRJcfz/b6
        HN0pqgjT2jqGPTd8nXxm1oZpEw==
X-Google-Smtp-Source: AMsMyM7TlcV9jv8JiJhbCbfALcfq5YjacKBifIUoINGIGVnZ4XsV+ow5aNY4s+JM+YBCUIhnRfyp4g==
X-Received: by 2002:a05:6402:510c:b0:45b:eb90:89c5 with SMTP id m12-20020a056402510c00b0045beb9089c5mr7665037edd.35.1665393490416;
        Mon, 10 Oct 2022 02:18:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906538800b0077f324979absm5010767ejo.67.2022.10.10.02.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 02:18:09 -0700 (PDT)
Date:   Mon, 10 Oct 2022 11:18:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Message-ID: <Y0PjULbYQf1WbI9w@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-2-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010011804.23716-2-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>From: Vadim Fedorenko <vadfed@fb.com>
>
>DPLL framework is used to represent and configure DPLL devices
>in systems. Each device that has DPLL and can configure sources
>and outputs can use this framework.
>
>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>Co-developed-by: Jakub Kicinski <kuba@kernel.org>
>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>---
> MAINTAINERS                 |   8 +
> drivers/Kconfig             |   2 +
> drivers/Makefile            |   1 +
> drivers/dpll/Kconfig        |   7 +
> drivers/dpll/Makefile       |   7 +
> drivers/dpll/dpll_core.c    | 177 +++++++++++++++
> drivers/dpll/dpll_core.h    |  41 ++++
> drivers/dpll/dpll_netlink.c | 417 ++++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h |   7 +
> include/linux/dpll.h        |  29 +++
> include/uapi/linux/dpll.h   | 101 +++++++++
> 11 files changed, 797 insertions(+)
> create mode 100644 drivers/dpll/Kconfig
> create mode 100644 drivers/dpll/Makefile
> create mode 100644 drivers/dpll/dpll_core.c
> create mode 100644 drivers/dpll/dpll_core.h
> create mode 100644 drivers/dpll/dpll_netlink.c
> create mode 100644 drivers/dpll/dpll_netlink.h
> create mode 100644 include/linux/dpll.h
> create mode 100644 include/uapi/linux/dpll.h
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 9ca84cb5ab4a..e2f4fede937f 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -6301,6 +6301,14 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
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
>index 19ee995bd0ae..a3e00294a995 100644
>--- a/drivers/Kconfig
>+++ b/drivers/Kconfig
>@@ -239,4 +239,6 @@ source "drivers/peci/Kconfig"
> 
> source "drivers/hte/Kconfig"
> 
>+source "drivers/dpll/Kconfig"
>+
> endmenu
>diff --git a/drivers/Makefile b/drivers/Makefile
>index 057857258bfd..78a68f1621cc 100644
>--- a/drivers/Makefile
>+++ b/drivers/Makefile
>@@ -188,3 +188,4 @@ obj-$(CONFIG_COUNTER)		+= counter/
> obj-$(CONFIG_MOST)		+= most/
> obj-$(CONFIG_PECI)		+= peci/
> obj-$(CONFIG_HTE)		+= hte/
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
>index 000000000000..0748c80097e4
>--- /dev/null
>+++ b/drivers/dpll/Makefile
>@@ -0,0 +1,7 @@
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# Makefile for DPLL drivers.
>+#
>+
>+obj-$(CONFIG_DPLL)          += dpll_sys.o
>+dpll_sys-y                  += dpll_core.o dpll_netlink.o
>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>new file mode 100644
>index 000000000000..7fdee145e82c
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.c
>@@ -0,0 +1,177 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ *  dpll_core.c - Generic DPLL Management class support.
>+ *
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
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
>+static DEFINE_MUTEX(dpll_device_xa_lock);
>+static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
>+#define DPLL_REGISTERED XA_MARK_1
>+
>+#define ASSERT_DPLL_REGISTERED(d)                                           \
>+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>+#define ASSERT_DPLL_NOT_REGISTERED(d)                                      \
>+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>+
>+
>+int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *),
>+			 void *data)

Probably better to avoid this "cb" indirection here.
Perhaps in a similar way devlinks_xa_for_each_registered_get() is done?


>+{
>+	struct dpll_device *dpll;
>+	unsigned long index;
>+	int ret = 0;
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_for_each_start(&dpll_device_xa, index, dpll, id) {
>+		if (!xa_get_mark(&dpll_device_xa, index, DPLL_REGISTERED))
>+			continue;
>+		ret = cb(dpll, data);
>+		if (ret)
>+			break;
>+	}
>+	mutex_unlock(&dpll_device_xa_lock);
>+
>+	return ret;
>+}
>+
>+struct dpll_device *dpll_device_get_by_id(int id)
>+{
>+	struct dpll_device *dpll = NULL;
>+
>+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
>+		dpll = xa_load(&dpll_device_xa, id);
>+	return dpll;
>+}
>+
>+struct dpll_device *dpll_device_get_by_name(const char *name)
>+{
>+	struct dpll_device *dpll, *ret = NULL;
>+	unsigned long index;
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>+		if (!strcmp(dev_name(&dpll->dev), name)) {
>+			ret = dpll;
>+			break;
>+		}
>+	}
>+	mutex_unlock(&dpll_device_xa_lock);
>+
>+	return ret;
>+}
>+
>+void *dpll_priv(struct dpll_device *dpll)
>+{
>+	return dpll->priv;
>+}
>+EXPORT_SYMBOL_GPL(dpll_priv);
>+
>+static void dpll_device_release(struct device *dev)
>+{
>+	struct dpll_device *dpll;
>+
>+	dpll = to_dpll_device(dev);
>+
>+	dpll_device_unregister(dpll);
>+	dpll_device_free(dpll);
>+}
>+
>+static struct class dpll_class = {
>+	.name = "dpll",
>+	.dev_release = dpll_device_release,
>+};
>+
>+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>+				      int sources_count, int outputs_count, void *priv)
>+{
>+	struct dpll_device *dpll;
>+	int ret;
>+
>+	dpll = kzalloc(sizeof(*dpll), GFP_KERNEL);
>+	if (!dpll)
>+		return ERR_PTR(-ENOMEM);
>+
>+	mutex_init(&dpll->lock);
>+	dpll->ops = ops;
>+	dpll->dev.class = &dpll_class;
>+	dpll->sources_count = sources_count;
>+	dpll->outputs_count = outputs_count;
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b, GFP_KERNEL);
>+	if (ret)
>+		goto error;
>+	dev_set_name(&dpll->dev, "%s%d", name ? name : "dpll", dpll->id);
>+	mutex_unlock(&dpll_device_xa_lock);
>+	dpll->priv = priv;
>+
>+	return dpll;
>+
>+error:
>+	mutex_unlock(&dpll_device_xa_lock);
>+	kfree(dpll);
>+	return ERR_PTR(ret);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_alloc);
>+
>+void dpll_device_free(struct dpll_device *dpll)
>+{
>+	if (!dpll)
>+		return;
>+
>+	mutex_destroy(&dpll->lock);
>+	kfree(dpll);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_free);
>+
>+void dpll_device_register(struct dpll_device *dpll)
>+{
>+	ASSERT_DPLL_NOT_REGISTERED(dpll);
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>+	mutex_unlock(&dpll_device_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_register);
>+
>+void dpll_device_unregister(struct dpll_device *dpll)
>+{
>+	ASSERT_DPLL_REGISTERED(dpll);
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_erase(&dpll_device_xa, dpll->id);
>+	mutex_unlock(&dpll_device_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_unregister);
>+
>+static int __init dpll_init(void)
>+{
>+	int ret;
>+
>+	ret = dpll_netlink_init();
>+	if (ret)
>+		goto error;
>+
>+	ret = class_register(&dpll_class);
>+	if (ret)
>+		goto unregister_netlink;
>+
>+	return 0;
>+
>+unregister_netlink:
>+	dpll_netlink_finish();
>+error:
>+	mutex_destroy(&dpll_device_xa_lock);
>+	return ret;
>+}
>+subsys_initcall(dpll_init);
>diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
>new file mode 100644
>index 000000000000..4b6fc9eb228f
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.h
>@@ -0,0 +1,41 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+#ifndef __DPLL_CORE_H__
>+#define __DPLL_CORE_H__
>+
>+#include <linux/dpll.h>
>+
>+#include "dpll_netlink.h"
>+
>+/**
>+ * struct dpll_device - structure for a DPLL device
>+ * @id:		unique id number for each edvice
>+ * @dev:	&struct device for this dpll device
>+ * @sources_count:	amount of input sources this dpll_device supports
>+ * @outputs_count:	amount of outputs this dpll_device supports
>+ * @ops:	operations this &dpll_device supports
>+ * @lock:	mutex to serialize operations
>+ * @priv:	pointer to private information of owner
>+ */
>+struct dpll_device {
>+	int id;
>+	struct device dev;
>+	int sources_count;
>+	int outputs_count;
>+	struct dpll_device_ops *ops;
>+	struct mutex lock;
>+	void *priv;
>+};
>+
>+#define to_dpll_device(_dev) \
>+	container_of(_dev, struct dpll_device, dev)
>+
>+int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *),
>+			  void *data);
>+struct dpll_device *dpll_device_get_by_id(int id);
>+struct dpll_device *dpll_device_get_by_name(const char *name);
>+void dpll_device_unregister(struct dpll_device *dpll);
>+#endif
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>new file mode 100644
>index 000000000000..31966e0eec3a
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -0,0 +1,417 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ * Generic netlink for DPLL management framework
>+ *
>+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ *
>+ */
>+#include <linux/module.h>
>+#include <linux/kernel.h>
>+#include <net/genetlink.h>
>+#include "dpll_core.h"
>+
>+#include <uapi/linux/dpll.h>
>+
>+static const struct genl_multicast_group dpll_genl_mcgrps[] = {
>+	{ .name = DPLL_CONFIG_DEVICE_GROUP_NAME, },
>+	{ .name = DPLL_CONFIG_SOURCE_GROUP_NAME, },
>+	{ .name = DPLL_CONFIG_OUTPUT_GROUP_NAME, },
>+	{ .name = DPLL_MONITOR_GROUP_NAME,  },
>+};
>+
>+static const struct nla_policy dpll_genl_get_policy[] = {
>+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
>+	[DPLLA_DEVICE_NAME]	= { .type = NLA_STRING,
>+				    .len = DPLL_NAME_LENGTH },
>+	[DPLLA_FLAGS]		= { .type = NLA_U32 },
>+};
>+
>+static const struct nla_policy dpll_genl_set_source_policy[] = {
>+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
>+	[DPLLA_SOURCE_ID]	= { .type = NLA_U32 },
>+	[DPLLA_SOURCE_TYPE]	= { .type = NLA_U32 },
>+};
>+
>+static const struct nla_policy dpll_genl_set_output_policy[] = {
>+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
>+	[DPLLA_OUTPUT_ID]	= { .type = NLA_U32 },
>+	[DPLLA_OUTPUT_TYPE]	= { .type = NLA_U32 },
>+};
>+
>+struct param {

Namespace prefix please	.


>+	struct netlink_callback *cb;
>+	struct dpll_device *dpll;
>+	struct sk_buff *msg;



>+	int dpll_id;
>+	int dpll_source_id;
>+	int dpll_source_type;
>+	int dpll_output_id;
>+	int dpll_output_type;

I don't see where you use these 5.


>+};
>+
>+struct dpll_dump_ctx {
>+	struct dpll_device *dev;
>+	int flags;
>+	int pos_idx;



>+	int pos_src_idx;
>+	int pos_out_idx;

You don't use these 2.


>+};
>+
>+typedef int (*cb_t)(struct param *);
>+
>+static struct genl_family dpll_gnl_family;
>+
>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *cb)
>+{
>+	return (struct dpll_dump_ctx *)cb->ctx;
>+}
>+
>+static int __dpll_cmd_device_dump_one(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	if (nla_put_u32(msg, DPLLA_DEVICE_ID, dpll->id))
>+		return -EMSGSIZE;
>+
>+	if (nla_put_string(msg, DPLLA_DEVICE_NAME, dev_name(&dpll->dev)))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	struct nlattr *src_attr;
>+	int i, ret = 0, type;
>+
>+	for (i = 0; i < dpll->sources_count; i++) {
>+		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
>+		if (!src_attr) {
>+			ret = -EMSGSIZE;
>+			break;
>+		}
>+		type = dpll->ops->get_source_type(dpll, i);
>+		if (nla_put_u32(msg, DPLLA_SOURCE_ID, i) ||
>+		    nla_put_u32(msg, DPLLA_SOURCE_TYPE, type)) {
>+			nla_nest_cancel(msg, src_attr);
>+			ret = -EMSGSIZE;
>+			break;
>+		}
>+		if (dpll->ops->get_source_supported) {
>+			for (type = 0; type <= DPLL_TYPE_MAX; type++) {
>+				ret = dpll->ops->get_source_supported(dpll, i, type);

Okay, this looks weird to me. This implicates that it is possible to
have for example:
source index 0 of type 10 
source index 0 of type 11 
Both possible.

However, from how I understand this, each source if of certain fixed type.
Either it is:
SyncE port
1pps external input (SMA)
10MHZ external input (SMA)
internal oscilator (free-running)
GNSS (GPS)

So for example:
index 0, type: 1pps external input (SMA)
index 1, type: 10MHZ external input (
index 2, type: SyncE port, netdev ifindex: 20
index 3, type: SyncE port, netdev ifindex: 30

So 4 "source" objects, each of different type.
In this case I can imagine that the netlink API might look something
like:
-> DPLL_CMD_SOURCE_GET - dump
     ATTR_DEVICE_ID X

<- DPLL_CMD_SOURCE_GET

     ATTR_DEVICE_ID X
     ATTR_SOURCE_INDEX 0
     ATTR_SOURCE_TYPE EXT_1PPS
     
     ATTR_DEVICE_ID X
     ATTR_SOURCE_INDEX 1
     ATTR_SOURCE_TYPE EXT_10MHZ
     
     ATTR_DEVICE_ID X
     ATTR_SOURCE_INDEX 2
     ATTR_SOURCE_TYPE SYNCE_ETH_PORT
     ATTR_SOURCE_NETDEV_IFINDEX 20

     ATTR_DEVICE_ID X
     ATTR_SOURCE_INDEX 3
     ATTR_SOURCE_TYPE SYNCE_ETH_PORT
     ATTR_SOURCE_NETDEV_IFINDEX 30

You see kernel would dump 4 source objects.



>+				if (ret && nla_put_u32(msg, DPLLA_SOURCE_SUPPORTED, type)) {
>+					ret = -EMSGSIZE;
>+					break;
>+				}
>+			}
>+			ret = 0;
>+		}
>+		nla_nest_end(msg, src_attr);
>+	}
>+
>+	return ret;
>+}
>+
>+static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	struct nlattr *out_attr;
>+	int i, ret = 0, type;
>+
>+	for (i = 0; i < dpll->outputs_count; i++) {
>+		out_attr = nla_nest_start(msg, DPLLA_OUTPUT);
>+		if (!out_attr) {
>+			ret = -EMSGSIZE;
>+			break;
>+		}
>+		type = dpll->ops->get_output_type(dpll, i);
>+		if (nla_put_u32(msg, DPLLA_OUTPUT_ID, i) ||
>+		    nla_put_u32(msg, DPLLA_OUTPUT_TYPE, type)) {
>+			nla_nest_cancel(msg, out_attr);
>+			ret = -EMSGSIZE;
>+			break;
>+		}
>+		if (dpll->ops->get_output_supported) {
>+			for (type = 0; type <= DPLL_TYPE_MAX; type++) {
>+				ret = dpll->ops->get_output_supported(dpll, i, type);
>+				if (ret && nla_put_u32(msg, DPLLA_OUTPUT_SUPPORTED, type)) {

This I believe is similar to sources, see my comment above.

I believe we should have separate commands to GET and SET outputs and
sources. That would make the object separation clear and will also help
event model. See below I suggestion how output netlink API may look
like (comment in header file near enum dpll_genl_cmd definition).


>+					ret = -EMSGSIZE;
>+					break;
>+				}
>+			}
>+			ret = 0;
>+		}
>+		nla_nest_end(msg, out_attr);
>+	}
>+
>+	return ret;
>+}
>+
>+static int __dpll_cmd_dump_status(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	int ret;
>+
>+	if (dpll->ops->get_status) {
>+		ret = dpll->ops->get_status(dpll);
>+		if (nla_put_u32(msg, DPLLA_STATUS, ret))
>+			return -EMSGSIZE;
>+	}
>+
>+	if (dpll->ops->get_temp) {
>+		ret = dpll->ops->get_temp(dpll);
>+		if (nla_put_u32(msg, DPLLA_TEMP, ret))
>+			return -EMSGSIZE;
>+	}
>+
>+	if (dpll->ops->get_lock_status) {
>+		ret = dpll->ops->get_lock_status(dpll);
>+		if (nla_put_u32(msg, DPLLA_LOCK_STATUS, ret))
>+			return -EMSGSIZE;
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
>+		     u32 portid, u32 seq, int flags)
>+{
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	hdr = genlmsg_put(msg, portid, seq, &dpll_gnl_family, 0,
>+			  DPLL_CMD_DEVICE_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	mutex_lock(&dpll->lock);
>+	ret = __dpll_cmd_device_dump_one(dpll, msg);
>+	if (ret)
>+		goto out_unlock;
>+
>+	if (flags & DPLL_FLAG_SOURCES && dpll->ops->get_source_type) {
>+		ret = __dpll_cmd_dump_sources(dpll, msg);
>+		if (ret)
>+			goto out_unlock;
>+	}
>+
>+	if (flags & DPLL_FLAG_OUTPUTS && dpll->ops->get_output_type) {
>+		ret = __dpll_cmd_dump_outputs(dpll, msg);
>+		if (ret)
>+			goto out_unlock;
>+	}
>+
>+	if (flags & DPLL_FLAG_STATUS) {
>+		ret = __dpll_cmd_dump_status(dpll, msg);
>+		if (ret)
>+			goto out_unlock;
>+	}
>+	mutex_unlock(&dpll->lock);
>+	genlmsg_end(msg, hdr);
>+
>+	return 0;
>+
>+out_unlock:
>+	mutex_unlock(&dpll->lock);
>+	genlmsg_cancel(msg, hdr);
>+
>+	return ret;
>+}
>+
>+static int dpll_genl_cmd_set_source(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	int ret = 0, src_id, type;

Enums.

>+
>+	if (!attrs[DPLLA_SOURCE_ID] ||
>+	    !attrs[DPLLA_SOURCE_TYPE])
>+		return -EINVAL;
>+
>+	if (!dpll->ops->set_source_type)
>+		return -EOPNOTSUPP;
>+
>+	src_id = nla_get_u32(attrs[DPLLA_SOURCE_ID]);
>+	type = nla_get_u32(attrs[DPLLA_SOURCE_TYPE]);


This looks odd to me. The user should just pass the index of source to
select. Type should be static, and non-changeable.


>+
>+	mutex_lock(&dpll->lock);
>+	ret = dpll->ops->set_source_type(dpll, src_id, type);
>+	mutex_unlock(&dpll->lock);
>+
>+	return ret;
>+}
>+
>+static int dpll_genl_cmd_set_output(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	int ret = 0, out_id, type;

Enums.


>+
>+	if (!attrs[DPLLA_OUTPUT_ID] ||
>+	    !attrs[DPLLA_OUTPUT_TYPE])
>+		return -EINVAL;
>+
>+	if (!dpll->ops->set_output_type)
>+		return -EOPNOTSUPP;
>+
>+	out_id = nla_get_u32(attrs[DPLLA_OUTPUT_ID]);
>+	type = nla_get_u32(attrs[DPLLA_OUTPUT_TYPE]);

Same here, passing type here looks wrong.



>+
>+	mutex_lock(&dpll->lock);
>+	ret = dpll->ops->set_output_type(dpll, out_id, type);
>+	mutex_unlock(&dpll->lock);
>+
>+	return ret;
>+}
>+
>+static int dpll_device_loop_cb(struct dpll_device *dpll, void *data)
>+{
>+	struct dpll_dump_ctx *ctx;
>+	struct param *p = (struct param *)data;
>+
>+	ctx = dpll_dump_context(p->cb);
>+
>+	ctx->pos_idx = dpll->id;
>+
>+	return dpll_device_dump_one(dpll, p->msg, 0, 0, ctx->flags);
>+}
>+
>+static int
>+dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
>+{
>+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>+	struct param p = { .cb = cb, .msg = skb };
>+
>+	return for_each_dpll_device(ctx->pos_idx, dpll_device_loop_cb, &p);
>+}
>+
>+static int
>+dpll_genl_cmd_device_get_id(struct sk_buff *skb, struct genl_info *info)

Just "get", no "id" here.


>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	struct sk_buff *msg;
>+	int flags = 0;
>+	int ret;
>+
>+	if (attrs[DPLLA_FLAGS])
>+		flags = nla_get_u32(attrs[DPLLA_FLAGS]);
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	ret = dpll_device_dump_one(dpll, msg, info->snd_portid, info->snd_seq,
>+				   flags);
>+	if (ret)
>+		goto out_free_msg;
>+
>+	return genlmsg_reply(msg, info);
>+
>+out_free_msg:
>+	nlmsg_free(msg);
>+	return ret;
>+
>+}
>+
>+static int dpll_genl_cmd_start(struct netlink_callback *cb)
>+{
>+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>+
>+	ctx->dev = NULL;
>+	if (info->attrs[DPLLA_FLAGS])
>+		ctx->flags = nla_get_u32(info->attrs[DPLLA_FLAGS]);
>+	else
>+		ctx->flags = 0;
>+	ctx->pos_idx = 0;
>+	ctx->pos_src_idx = 0;
>+	ctx->pos_out_idx = 0;
>+	return 0;
>+}
>+
>+static int dpll_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
>+						 struct genl_info *info)
>+{
>+	struct dpll_device *dpll_id = NULL, *dpll_name = NULL;
>+
>+	if (!info->attrs[DPLLA_DEVICE_ID] &&
>+	    !info->attrs[DPLLA_DEVICE_NAME])
>+		return -EINVAL;
>+
>+	if (info->attrs[DPLLA_DEVICE_ID]) {
>+		u32 id = nla_get_u32(info->attrs[DPLLA_DEVICE_ID]);
>+
>+		dpll_id = dpll_device_get_by_id(id);
>+		if (!dpll_id)
>+			return -ENODEV;
>+		info->user_ptr[0] = dpll_id;

struct dpll_device *dpll should be stored here.


>+	}
>+	if (info->attrs[DPLLA_DEVICE_NAME]) {

You define new API, have one clear handle for devices. Either name or
ID. Having both is messy.


>+		const char *name = nla_data(info->attrs[DPLLA_DEVICE_NAME]);
>+
>+		dpll_name = dpll_device_get_by_name(name);
>+		if (!dpll_name)
>+			return -ENODEV;
>+
>+		if (dpll_id && dpll_name != dpll_id)
>+			return -EINVAL;
>+		info->user_ptr[0] = dpll_name;

struct dpll_device *dpll should be stored here.



>+	}
>+
>+	return 0;
>+}
>+
>+static const struct genl_ops dpll_genl_ops[] = {
>+	{
>+		.cmd	= DPLL_CMD_DEVICE_GET,
>+		.flags  = GENL_UNS_ADMIN_PERM,
>+		.start	= dpll_genl_cmd_start,
>+		.dumpit	= dpll_cmd_device_dump,
>+		.doit	= dpll_genl_cmd_device_get_id,
>+		.policy	= dpll_genl_get_policy,
>+		.maxattr = ARRAY_SIZE(dpll_genl_get_policy) - 1,
>+	},
>+	{
>+		.cmd	= DPLL_CMD_SET_SOURCE_TYPE,
>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= dpll_genl_cmd_set_source,
>+		.policy	= dpll_genl_set_source_policy,
>+		.maxattr = ARRAY_SIZE(dpll_genl_set_source_policy) - 1,
>+	},
>+	{
>+		.cmd	= DPLL_CMD_SET_OUTPUT_TYPE,
>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= dpll_genl_cmd_set_output,
>+		.policy	= dpll_genl_set_output_policy,
>+		.maxattr = ARRAY_SIZE(dpll_genl_set_output_policy) - 1,
>+	},
>+};
>+
>+static struct genl_family dpll_gnl_family __ro_after_init = {
>+	.hdrsize	= 0,
>+	.name		= DPLL_FAMILY_NAME,
>+	.version	= DPLL_VERSION,
>+	.ops		= dpll_genl_ops,
>+	.n_ops		= ARRAY_SIZE(dpll_genl_ops),
>+	.mcgrps		= dpll_genl_mcgrps,
>+	.n_mcgrps	= ARRAY_SIZE(dpll_genl_mcgrps),
>+	.pre_doit	= dpll_pre_doit,

Have  .parallel_ops   = true,
You have dpll->lock, you don't need genl, to protect you.


>+};
>+
>+int __init dpll_netlink_init(void)
>+{
>+	return genl_register_family(&dpll_gnl_family);
>+}
>+
>+void dpll_netlink_finish(void)
>+{
>+	genl_unregister_family(&dpll_gnl_family);
>+}
>+
>+void __exit dpll_netlink_fini(void)
>+{
>+	dpll_netlink_finish();
>+}
>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>new file mode 100644
>index 000000000000..e2d100f59dd6
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -0,0 +1,7 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+int __init dpll_netlink_init(void);
>+void dpll_netlink_finish(void);
>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>new file mode 100644
>index 000000000000..9d49b19d03d9
>--- /dev/null
>+++ b/include/linux/dpll.h
>@@ -0,0 +1,29 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+#ifndef __DPLL_H__
>+#define __DPLL_H__
>+
>+struct dpll_device;
>+
>+struct dpll_device_ops {
>+	int (*get_status)(struct dpll_device *dpll);
>+	int (*get_temp)(struct dpll_device *dpll);
>+	int (*get_lock_status)(struct dpll_device *dpll);
>+	int (*get_source_type)(struct dpll_device *dpll, int id);
>+	int (*get_source_supported)(struct dpll_device *dpll, int id, int type);
>+	int (*get_output_type)(struct dpll_device *dpll, int id);
>+	int (*get_output_supported)(struct dpll_device *dpll, int id, int type);
>+	int (*set_source_type)(struct dpll_device *dpll, int id, int val);
>+	int (*set_output_type)(struct dpll_device *dpll, int id, int val);

All int should be enums, when they are really enums. Makes things much
nicer and easier to see what's what.



>+};
>+
>+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>+				      int sources_count, int outputs_count, void *priv);
>+void dpll_device_register(struct dpll_device *dpll);
>+void dpll_device_unregister(struct dpll_device *dpll);
>+void dpll_device_free(struct dpll_device *dpll);
>+void *dpll_priv(struct dpll_device *dpll);
>+#endif
>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>new file mode 100644
>index 000000000000..fcbea5a5e4d6
>--- /dev/null
>+++ b/include/uapi/linux/dpll.h
>@@ -0,0 +1,101 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>+#ifndef _UAPI_LINUX_DPLL_H
>+#define _UAPI_LINUX_DPLL_H
>+
>+#define DPLL_NAME_LENGTH	20
>+
>+/* Adding event notification support elements */
>+#define DPLL_FAMILY_NAME		"dpll"
>+#define DPLL_VERSION			0x01
>+#define DPLL_CONFIG_DEVICE_GROUP_NAME  "config"
>+#define DPLL_CONFIG_SOURCE_GROUP_NAME  "source"
>+#define DPLL_CONFIG_OUTPUT_GROUP_NAME  "output"
>+#define DPLL_MONITOR_GROUP_NAME        "monitor"

What is exactly the reason for multiple multicast groups? Why you don't
use one?


>+
>+#define DPLL_FLAG_SOURCES	1
>+#define DPLL_FLAG_OUTPUTS	2
>+#define DPLL_FLAG_STATUS	4

I think it is more common to use either 0x prefix or (1<<X) expression
But I don't think these flags are needed at all, if you have per-object
messages.


>+
>+/* Attributes of dpll_genl_family */
>+enum dpll_genl_attr {

I don't see need for "genl" here.
Also, it is common to have consistency betwee enum name and members name.
For example:

enum dpll_attr {
	DPLL_ATTR_UNSPEC,
	DPLL_ATTR_DEVICE_ID,

	...
}
This applies to all enums in this file.


>+	DPLLA_UNSPEC,
>+	DPLLA_DEVICE_ID,
>+	DPLLA_DEVICE_NAME,
>+	DPLLA_SOURCE,
>+	DPLLA_SOURCE_ID,

"ID" sounds a bit odd. I think "index" would be more suitable.


>+	DPLLA_SOURCE_TYPE,
>+	DPLLA_SOURCE_SUPPORTED,
>+	DPLLA_OUTPUT,
>+	DPLLA_OUTPUT_ID,
>+	DPLLA_OUTPUT_TYPE,
>+	DPLLA_OUTPUT_SUPPORTED,
>+	DPLLA_STATUS,
>+	DPLLA_TEMP,
>+	DPLLA_LOCK_STATUS,
>+	DPLLA_FLAGS,
>+
>+	__DPLLA_MAX,
>+};
>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>+
>+/* DPLL status provides information of device status */
>+enum dpll_genl_status {
>+	DPLL_STATUS_NONE,
>+	DPLL_STATUS_CALIBRATING,
>+	DPLL_STATUS_LOCKED,
>+
>+	__DPLL_STATUS_MAX,
>+};
>+#define DPLL_STATUS_MAX (__DPLL_STATUS_MAX - 1)
>+
>+/* DPLL signal types used as source or as output */
>+enum dpll_genl_signal_type {
>+	DPLL_TYPE_EXT_1PPS,
>+	DPLL_TYPE_EXT_10MHZ,
>+	DPLL_TYPE_SYNCE_ETH_PORT,
>+	DPLL_TYPE_INT_OSCILLATOR,
>+	DPLL_TYPE_GNSS,
>+
>+	__DPLL_TYPE_MAX,
>+};
>+#define DPLL_TYPE_MAX (__DPLL_TYPE_MAX - 1)
>+
>+/* DPLL lock status provides information of source used to lock the device */
>+enum dpll_genl_lock_status {
>+	DPLL_LOCK_STATUS_UNLOCKED,
>+	DPLL_LOCK_STATUS_EXT_1PPS,
>+	DPLL_LOCK_STATUS_EXT_10MHZ,
>+	DPLL_LOCK_STATUS_SYNCE,
>+	DPLL_LOCK_STATUS_INT_OSCILLATOR,
>+	DPLL_LOCK_STATUS_GNSS,

I find it a bit odd and redundant to have lock status here as a separate
enum. You have a souce selected (either autoselected or manualy
selected). Then the status is either:
"UNLOCKED"
"LOCKED"
"HOLDOVER"

Or something similar. The point is, don't have the "source type" as a
part of lock status.


>+
>+	__DPLL_LOCK_STATUS_MAX,
>+};
>+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
>+
>+/* Events of dpll_genl_family */
>+enum dpll_genl_event {
>+	DPLL_EVENT_UNSPEC,
>+	DPLL_EVENT_DEVICE_CREATE,		/* DPLL device creation */
>+	DPLL_EVENT_DEVICE_DELETE,		/* DPLL device deletion */
>+	DPLL_EVENT_STATUS_LOCKED,		/* DPLL device locked to source */
>+	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */

Again, redundant I belive. There should be one event,
inside the message there should be and ATTR of the lock state.

Also, I believe there are 2 options:
1) follow the existing netlink models and have:
DPLL_EVENT_DEVICE_NEW
  - sent for new device
  - sent for change with device
DPLL_EVENT_DEVICE_DEL
  - sent for removed device
2)
DPLL_EVENT_DEVICE_NEW
  - sent for new device
DPLL_EVENT_DEVICE_DEL
  - sent for removed device
DPLL_EVENT_DEVICE_CHANGE
  - sent for change with device

Bot options work fine I belive. The point is, you don't want to have
"cmd" per one attr change. Changed the device, attrs are passed in one
message.



>+	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */

Similar here, source of device changed, should be just one attr in
device message, see above.


>+	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */


>+
>+	__DPLL_EVENT_MAX,
>+};
>+#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
>+
>+/* Commands supported by the dpll_genl_family */
>+enum dpll_genl_cmd {
>+	DPLL_CMD_UNSPEC,
>+	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
>+	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */

This is confusing, you select "source", not "type".

Please be consistent in naming:
DPLL_CMD_*_GET/SET

Also, to be consistend with other netlink interfaces, we don't need
cmd per action, rather there should be OBJ_GET (can dump) and OBJ_SET
commands, like this:
   
   DPLL_CMD_DEVICE_GET (can dump all present devices)
   	ATTR_SOURCE_SELECT_MODE (current one)
   	ATTR_SOURCE_INDEX (currect one)
   DPLL_CMD_DEVICE_SET
   	ATTR_SOURCE_INDEX (to set)
   DPLL_CMD_DEVICE_SET
   	ATTR_SOURCE_SELECT_MODE (to set)


>+	DPLL_CMD_SET_OUTPUT_TYPE,	/* Set the DPLL device output type */

Similar to what I suggested for "source", we should
enable to select the OUTPUT, the type should be static. Also instead,
I belive we should have a list of outputs and basically just allow
enable/disable individual outputs:
   DPLL_CMD_OUTPUT_GET (can dump the list of available outputs)
	ATTR_ENABLED (or "CONNECTED" or whatever) of type bool
   DPLL_CMD_OUTPUT_SET
	ATTR_ENABLED (or "CONNECTED" or whatever) of type bool

This is suitable for SyncE for example, when you have multiple netdev ports
that are connected as "outputs", you can enable exactly those you you want.
Example:
# To list the available outputs:
-> DPLL_CMD_OUTPUT_GET - dump
     ATTR_DEVICE_ID X

<- DPLL_CMD_OUTPUT_GET
     ATTR_DEVICE_ID X
     ATTR_OUTPUT_INDEX 0
     ATTR_OUTPUT_TYPE SYNCE_ETH_PORT
     ATTR_OUTPUT_NETDEV_IFINDEX 20
     ATTR_OUTPUT_ENABLED 0
     
     ATTR_DEVICE_ID X
     ATTR_OUTPUT_INDEX 1
     ATTR_OUTPUT_TYPE SYNCE_ETH_PORT
     ATTR_OUTPUT_NETDEV_IFINDEX 30
     ATTR_OUTPUT_ENABLED 0

# Now enable output with index 0
-> DPLL_CMD_OUTPUT_SET
     ATTR_DEVICE_ID X
     ATTR_OUTPUT_INDEX 0
     ATTR_OUTPUT_ENABLED 1


>+
>+	__DPLL_CMD_MAX,
>+};
>+#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
>+
>+#endif /* _UAPI_LINUX_DPLL_H */
>-- 
>2.27.0
>
