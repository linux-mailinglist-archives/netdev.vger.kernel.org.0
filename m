Return-Path: <netdev+bounces-9905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F2A72B1B4
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 13:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE1E128132D
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 11:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D268838;
	Sun, 11 Jun 2023 11:42:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FBC2900
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 11:42:29 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62461BD3
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 04:42:24 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f70fc4682aso23483235e9.1
        for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 04:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686483743; x=1689075743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uunh/A1JgdlAxWRop9uWNqDpYYBwdvXxrLWN6SOMhYk=;
        b=eAHgtUPXpAsvd6CkG3hEcQYm22TbATaX2dBX9iZN8Img0Gz+RMiDNvVZN5Ao6gCkGD
         wyxD1evXmspyKcAI/QLSRSx0cNOEOsmaHXAUByQKXiPksB30Lr8AciN7kp+l/l5bIgWH
         mm/OvXAbz6LgOHjp516ULsEVcr+BbSxK3xp4xCmVhWWQOf0sP3y1maVKKFljMFPPwERy
         0yNRNRT3ATxmIeHPOlVo3m8BXxmcbY/KegPaYqLnoFnEnMoW1/gS3tTrQWtncJQ+q9rW
         LLYWB1PTNz/14Lf5PZcI4JzUZ+ZY6fOyTR5S/Xjs47U6x8GMXr1JbfPgk3SzaYQGfl4N
         K8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686483743; x=1689075743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uunh/A1JgdlAxWRop9uWNqDpYYBwdvXxrLWN6SOMhYk=;
        b=lhbKvzmKeGIE6DMJNLciGRcOZZqcwOvCChH4OPv04oZsEsNWM2TeVnJWXQ8QGeEGkt
         VyJslat5r8yP/vmK43dbvxbNU1AJ1NTVckfCCZQbVLjuC5228whIH42ARthcpxGUobnB
         LqDwl/qLfm6zDb6P9awZHCqUtFrNlPPupz5p7wNatSFcKTj8zTZwW8GfYQWsxfzJG53r
         36Z3gCMf+6/miVe9ix/RvunPZE9Y75qhbaRM5JiE3W3oKHtrgiqcsZYLFu02DhknNnrh
         BpBR9BAKAv1cPSt1mAq7DcB0OySGlLKy5jaTOZpCmSphMPnEQoSJj4I5CKRAFqkwYIL3
         7BCA==
X-Gm-Message-State: AC+VfDwMFfSkbMaVi/bZrpTWzx097YfJPVbH9KkVGoMwTqaZvEcQSWxN
	yzk4OTlEHB8jsCidBG4V3lGFtg==
X-Google-Smtp-Source: ACHHUZ6X54I7teGV7jjjXQjoU4XRY6UppsC4jevGjgRE17SHcPi4pY4MDUaTWG/GIfARSl50ZRTvYQ==
X-Received: by 2002:a05:600c:2311:b0:3f6:289:b53b with SMTP id 17-20020a05600c231100b003f60289b53bmr3747553wmo.5.1686483742946;
        Sun, 11 Jun 2023 04:42:22 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i12-20020a05600c290c00b003f7e653c3e3sm8210475wmd.21.2023.06.11.04.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 04:42:22 -0700 (PDT)
Date: Sun, 11 Jun 2023 13:42:20 +0200
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
Subject: Re: [RFC PATCH v8 04/10] dpll: netlink: Add DPLL framework base
 functions
Message-ID: <ZIWzHGt/dbD6kcF0@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-5-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609121853.3607724-5-arkadiusz.kubalewski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Jun 09, 2023 at 02:18:47PM CEST, arkadiusz.kubalewski@intel.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

Arkadiusz, I think it would be appropriate to change the authorship
of this and other patches to you. I believe that you did vast majority
of the lines by now. Vadim, would you mind?


>
>DPLL framework is used to represent and configure DPLL devices
>in systems. Each device that has DPLL and can configure inputs
>and outputs can use this framework.
>
>Implement dpll netlink framework functions for enablement of dpll
>subsytem netlink family.
>
>Co-developed-by: Milena Olech <milena.olech@intel.com>
>Signed-off-by: Milena Olech <milena.olech@intel.com>
>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>---
> drivers/dpll/dpll_netlink.c | 1183 +++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h |   44 ++

Overall, this looks very good. I did take couple of comments below.
Thanks for you work!


> 2 files changed, 1227 insertions(+)
> create mode 100644 drivers/dpll/dpll_netlink.c
> create mode 100644 drivers/dpll/dpll_netlink.h
>
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>new file mode 100644
>index 000000000000..44d9699c9e6c
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -0,0 +1,1183 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ * Generic netlink for DPLL management framework
>+ *
>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>+ *  Copyright (c) 2023 Intel and affiliates
>+ *
>+ */
>+#include <linux/module.h>
>+#include <linux/kernel.h>
>+#include <net/genetlink.h>
>+#include "dpll_core.h"
>+#include "dpll_nl.h"
>+#include <uapi/linux/dpll.h>
>+
>+static int __dpll_pin_change_ntf(struct dpll_pin *pin);

Could you try to reshuffle the code to avoid forward declarations?


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

It is odd to see this helper here and the dpll_msg_add_pin_handle() not.
Introduce dpll_msg_add_pin_handle() here right away and only export it
later on in "netdev: expose DPLL pin handle for netdevice".


>+{
>+	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
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

I'm pretty sure I commented this before. But again, please get the
value the driver op returned and return it.


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

please get the value the driver op returned and return it.


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

please get the value the driver op returned and return it.


>+	if (nla_put_s32(msg, DPLL_A_TEMP, temp))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_prio(struct sk_buff *msg, struct dpll_pin *pin,
>+		      struct dpll_pin_ref *ref,
>+		      struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	struct dpll_device *dpll = ref->dpll;
>+	u32 prio;
>+
>+	if (!ops->prio_get)
>+		return -EOPNOTSUPP;
>+	if (ops->prio_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			  dpll_priv(dpll), &prio, extack))
>+		return -EFAULT;

please get the value the driver op returned and return it.


>+	if (nla_put_u32(msg, DPLL_A_PIN_PRIO, prio))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, struct dpll_pin *pin,
>+			       struct dpll_pin_ref *ref,
>+			       struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	struct dpll_device *dpll = ref->dpll;
>+	enum dpll_pin_state state;
>+
>+	if (!ops->state_on_dpll_get)
>+		return -EOPNOTSUPP;
>+	if (ops->state_on_dpll_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+				   dpll_priv(dpll), &state, extack))
>+		return -EFAULT;

please get the value the driver op returned and return it.


>+	if (nla_put_u8(msg, DPLL_A_PIN_STATE, state))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_direction(struct sk_buff *msg, struct dpll_pin *pin,
>+			   struct dpll_pin_ref *ref,
>+			   struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	struct dpll_device *dpll = ref->dpll;
>+	enum dpll_pin_direction direction;
>+
>+	if (!ops->direction_get)
>+		return -EOPNOTSUPP;
>+	if (ops->direction_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			       dpll_priv(dpll), &direction, extack))
>+		return -EFAULT;

please get the value the driver op returned and return it.


>+	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_freq(struct sk_buff *msg, struct dpll_pin *pin,
>+		      struct dpll_pin_ref *ref, struct netlink_ext_ack *extack,
>+		      bool dump_freq_supported)
>+{
>+	const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+	struct dpll_device *dpll = ref->dpll;
>+	struct nlattr *nest;
>+	u64 freq;
>+	int fs;
>+
>+	if (!ops->frequency_get)
>+		return -EOPNOTSUPP;

Return 0 and avoid the check of -EOPNOTSUPP in the caller.


>+	if (ops->frequency_get(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			       dpll_priv(dpll), &freq, extack))
>+		return -EFAULT;

please get the value the driver op returned and return it.


>+	if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY, sizeof(freq), &freq, 0))
>+		return -EMSGSIZE;
>+	if (!dump_freq_supported)
>+		return 0;
>+	for (fs = 0; fs < pin->prop->freq_supported_num; fs++) {
>+		nest = nla_nest_start(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED);
>+		if (!nest)
>+			return -EMSGSIZE;
>+		freq = pin->prop->freq_supported[fs].min;
>+		if (nla_put_64bit(msg, DPLL_A_PIN_FREQUENCY_MIN, sizeof(freq),
>+				   &freq, 0)) {
>+			nla_nest_cancel(msg, nest);
>+			return -EMSGSIZE;
>+		}
>+		freq = pin->prop->freq_supported[fs].max;
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
>+			 struct dpll_pin_ref *dpll_ref,
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
>+		void *parent_priv;
>+
>+		ppin = ref->pin;
>+		parent_priv = dpll_pin_on_dpll_priv(dpll_ref->dpll, ppin);
>+		if (WARN_ON(!ops->state_on_pin_get))

Wait, so you WARN during user comment on something that driver didn't
fill up? Plese move the check and WARN to the registration function.


>+			return -EFAULT;
>+		ret = ops->state_on_pin_get(pin,
>+					    dpll_pin_on_pin_priv(ppin, pin),
>+					    ppin, parent_priv, &state, extack);
>+		if (ret)
>+			return -EFAULT;

Return ret please.


>+		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
>+		if (!nest)
>+			return -EMSGSIZE;
>+		if (nla_put_u32(msg, DPLL_A_PIN_ID, ppin->id)) {
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
>+		attr = nla_nest_start(msg, DPLL_A_PIN_PARENT);
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
>+		ret = dpll_msg_add_pin_direction(msg, pin, ref, extack);
>+		if (ret)
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

"details"? Sound odd. I don't think that "DPLL_A_PIN_ID" is a detail
for example. Why don't you inline this in the __dpll_cmd_pin_dump_one()
function below?


>+			  struct dpll_pin_ref *ref, struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_properties *prop = pin->prop;
>+	int ret;
>+
>+	if (nla_put_u32(msg, DPLL_A_PIN_ID, pin->id))
>+		return -EMSGSIZE;
>+	if (nla_put_string(msg, DPLL_A_MODULE_NAME, module_name(pin->module)))
>+		return -EMSGSIZE;
>+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(pin->clock_id),
>+			  &pin->clock_id, 0))
>+		return -EMSGSIZE;
>+	if (prop->board_label &&
>+	    nla_put_string(msg, DPLL_A_PIN_BOARD_LABEL, prop->board_label))
>+		return -EMSGSIZE;
>+	if (prop->panel_label &&
>+	    nla_put_string(msg, DPLL_A_PIN_PANEL_LABEL, prop->panel_label))
>+		return -EMSGSIZE;
>+	if (prop->package_label &&
>+	    nla_put_string(msg, DPLL_A_PIN_PACKAGE_LABEL,
>+			   prop->package_label))
>+		return -EMSGSIZE;
>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, prop->type))
>+		return -EMSGSIZE;
>+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, prop->capabilities))
>+		return -EMSGSIZE;
>+	ret = dpll_msg_add_pin_freq(msg, pin, ref, extack, true);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	return 0;
>+}
>+
>+static int
>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
>+			struct netlink_ext_ack *extack)

To be consistent with dpll_device_get_one(), call this function
dpll_pin_get_one() please.


>+{
>+	struct dpll_pin_ref *ref;
>+	int ret;
>+
>+	ref = dpll_xa_ref_dpll_first(&pin->dpll_refs);
>+	if (!ref)
>+		return -EFAULT;

-EINVAL. But it should never happen anyway. Perhaps better to avoid the
check entirely.


>+	ret = dpll_cmd_pin_fill_details(msg, pin, ref, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_pin_parents(msg, pin, ref, extack);
>+	if (ret)
>+		return ret;
>+	if (!xa_empty(&pin->dpll_refs)) {

Drop this check, not needed.


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
>+	if (nla_put_string(msg, DPLL_A_MODULE_NAME, module_name(dpll->module)))
>+		return -EMSGSIZE;
>+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(dpll->clock_id),
>+			  &dpll->clock_id, 0))
>+		return -EMSGSIZE;
>+	ret = dpll_msg_add_temp(msg, dpll, extack);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ret = dpll_msg_add_lock_status(msg, dpll, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_mode(msg, dpll, extack);
>+	if (ret)
>+		return ret;
>+	for (mode = DPLL_MODE_MANUAL; mode <= DPLL_MODE_MAX; mode++)
>+		if (test_bit(mode, &dpll->mode_supported_mask))
>+			if (nla_put_s32(msg, DPLL_A_MODE_SUPPORTED, mode))
>+				return -EMSGSIZE;
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
>+	for (fs = 0; fs < pin->prop->freq_supported_num; fs++)
>+		if (freq >=  pin->prop->freq_supported[fs].min &&

Avoid double space here    ^^


>+		    freq <=  pin->prop->freq_supported[fs].max)

Avoid double space here    ^^


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

Fill a proper extack telling the user what's wrong please.
Could you please check the rest of the cmd attr checks and make sure
the extack is always filled with meaningful message?


>+		return -EINVAL;
>+
>+	xa_for_each(&pin->dpll_refs, i, ref) {
>+		const struct dpll_pin_ops *ops = dpll_pin_ops(ref);
>+		struct dpll_device *dpll = ref->dpll;
>+
>+		if (!ops->frequency_set)
>+			return -EOPNOTSUPP;
>+		ret = ops->frequency_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>+					 dpll, dpll_priv(dpll), freq, extack);
>+		if (ret)
>+			return -EFAULT;

return "ret"


>+		__dpll_pin_change_ntf(pin);
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_on_pin_state_set(struct dpll_pin *pin, u32 parent_idx,
>+			  enum dpll_pin_state state,
>+			  struct netlink_ext_ack *extack)
>+{
>+	struct dpll_pin_ref *parent_ref;
>+	const struct dpll_pin_ops *ops;
>+	struct dpll_pin_ref *dpll_ref;
>+	struct dpll_pin *parent;
>+	unsigned long i;
>+
>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop->capabilities))
>+		return -EOPNOTSUPP;
>+	parent = xa_load(&dpll_pin_xa, parent_idx);
>+	if (!parent)
>+		return -EINVAL;
>+	parent_ref = xa_load(&pin->parent_refs, parent->pin_idx);
>+	if (!parent_ref)
>+		return -EINVAL;
>+	xa_for_each(&parent->dpll_refs, i, dpll_ref) {
>+		ops = dpll_pin_ops(parent_ref);
>+		if (!ops->state_on_pin_set)
>+			return -EOPNOTSUPP;
>+		if (ops->state_on_pin_set(pin,
>+					  dpll_pin_on_pin_priv(parent, pin),
>+					  parent,
>+					  dpll_pin_on_dpll_priv(dpll_ref->dpll,
>+								parent),
>+					  state, extack))
>+			return -EFAULT;

please get the value the driver op returned and return it.

	
>+	}
>+	__dpll_pin_change_ntf(pin);
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
>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop->capabilities))
>+		return -EOPNOTSUPP;
>+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+	if (!ref)
>+		return -EFAULT;

-EINVAL. But looks like this should never happen. Perhaps just
WARN_ON(!ref) and don't check-return.


>+	ops = dpll_pin_ops(ref);
>+	if (!ops->state_on_dpll_set)
>+		return -EOPNOTSUPP;
>+	if (ops->state_on_dpll_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+				   dpll_priv(dpll), state, extack))
>+		return -EINVAL;
>+	__dpll_pin_change_ntf(pin);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
>+		  u32 prio, struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops;
>+	struct dpll_pin_ref *ref;
>+
>+	if (!(DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE & pin->prop->capabilities))
>+		return -EOPNOTSUPP;
>+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+	if (!ref)
>+		return -EFAULT;

Same here.


>+	ops = dpll_pin_ops(ref);
>+	if (!ops->prio_set)
>+		return -EOPNOTSUPP;
>+	if (ops->prio_set(pin, dpll_pin_on_dpll_priv(dpll, pin), dpll,
>+			  dpll_priv(dpll), prio, extack))
>+		return -EINVAL;
>+	__dpll_pin_change_ntf(pin);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_direction_set(struct dpll_pin *pin, struct dpll_device *dpll,
>+		       enum dpll_pin_direction direction,
>+		       struct netlink_ext_ack *extack)
>+{
>+	const struct dpll_pin_ops *ops;
>+	struct dpll_pin_ref *ref;
>+
>+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop->capabilities))
>+		return -EOPNOTSUPP;
>+
>+	ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+	if (!ref)
>+		return -EFAULT;

Same here. This calls for a helper :)


>+	ops = dpll_pin_ops(ref);
>+	if (!ops->direction_set)
>+		return -EOPNOTSUPP;
>+	if (ops->direction_set(pin, dpll_pin_on_dpll_priv(dpll, pin),
>+			       dpll, dpll_priv(dpll), direction,
>+			       extack))
>+		return -EFAULT;

please get the value the driver op returned and return it.


>+	__dpll_pin_change_ntf(pin);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_parent_set(struct dpll_pin *pin, struct nlattr *parent_nest,
>+		    struct netlink_ext_ack *extack)
>+{
>+	struct nlattr *tb[DPLL_A_MAX + 1];
>+	enum dpll_pin_direction direction;
>+	u32 ppin_idx, pdpll_idx, prio;
>+	enum dpll_pin_state state;
>+	struct dpll_pin_ref *ref;
>+	struct dpll_device *dpll;
>+	int ret;
>+
>+	nla_parse_nested(tb, DPLL_A_MAX, parent_nest,
>+			 NULL, extack);
>+	if ((tb[DPLL_A_ID] && tb[DPLL_A_PIN_ID]) ||
>+	    !(tb[DPLL_A_ID] || tb[DPLL_A_PIN_ID])) {
>+		NL_SET_ERR_MSG(extack, "one parent id expected");
>+		return -EINVAL;
>+	}
>+	if (tb[DPLL_A_ID]) {
>+		pdpll_idx = nla_get_u32(tb[DPLL_A_ID]);
>+		dpll = xa_load(&dpll_device_xa, pdpll_idx);
>+		if (!dpll)
>+			return -EINVAL;
>+		ref = xa_load(&pin->dpll_refs, dpll->device_idx);
>+		if (!ref)
>+			return -EINVAL;
>+		if (tb[DPLL_A_PIN_STATE]) {
>+			state = nla_get_u8(tb[DPLL_A_PIN_STATE]);
>+			ret = dpll_pin_state_set(dpll, pin, state, extack);
>+			if (ret)
>+				return ret;
>+		}
>+		if (tb[DPLL_A_PIN_PRIO]) {
>+			prio = nla_get_u8(tb[DPLL_A_PIN_PRIO]);
>+			ret = dpll_pin_prio_set(dpll, pin, prio, extack);
>+			if (ret)
>+				return ret;
>+		}
>+		if (tb[DPLL_A_PIN_DIRECTION]) {
>+			direction = nla_get_u8(tb[DPLL_A_PIN_DIRECTION]);
>+			ret = dpll_pin_direction_set(pin, dpll, direction,
>+						     extack);
>+			if (ret)
>+				return ret;
>+		}
>+	} else if (tb[DPLL_A_PIN_ID]) {
>+		ppin_idx = nla_get_u32(tb[DPLL_A_PIN_ID]);
>+		state = nla_get_u8(tb[DPLL_A_PIN_STATE]);
>+		ret = dpll_pin_on_pin_state_set(pin, ppin_idx, state, extack);
>+		if (ret)
>+			return ret;
>+	}
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_set_from_nlattr(struct dpll_pin *pin, struct genl_info *info)
>+{
>+	int rem, ret = -EINVAL;
>+	struct nlattr *a;
>+
>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(a)) {
>+		case DPLL_A_PIN_FREQUENCY:
>+			ret = dpll_pin_freq_set(pin, a, info->extack);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLL_A_PIN_PARENT:
>+			ret = dpll_pin_parent_set(pin, a, info->extack);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLL_A_PIN_ID:
>+		case DPLL_A_ID:
>+			break;
>+		default:
>+			NL_SET_ERR_MSG_FMT(info->extack,
>+					   "unsupported attribute (%d)",
>+					   nla_type(a));
>+			return -EINVAL;
>+		}
>+	}
>+
>+	return 0;
>+}
>+
>+static struct dpll_pin *
>+dpll_pin_find(u64 clock_id, struct nlattr *mod_name_attr,
>+	      enum dpll_pin_type type, struct nlattr *board_label,
>+	      struct nlattr *panel_label, struct nlattr *package_label)
>+{
>+	bool board_match, panel_match, package_match;
>+	struct dpll_pin *pin_match = NULL, *pin;
>+	const struct dpll_pin_properties *prop;
>+	bool cid_match, mod_match, type_match;
>+	unsigned long i;
>+
>+	xa_for_each(&dpll_pin_xa, i, pin) {
>+		if (xa_empty(&pin->dpll_refs))

This filters out unregistered, right? Could you please introduce a
"REGISTERED" mark and iterate only over list of registered? Similar to
what you have for device.


>+			continue;
>+		prop = pin->prop;
>+		cid_match = clock_id ? pin->clock_id == clock_id : true;
>+		mod_match = mod_name_attr && module_name(pin->module) ?
>+			!nla_strcmp(mod_name_attr,
>+				    module_name(pin->module)) : true;
>+		type_match = type ? prop->type == type : true;
>+		board_match = board_label && prop->board_label ?
>+			!nla_strcmp(board_label, prop->board_label) : true;
>+		panel_match = panel_label && prop->panel_label ?
>+			!nla_strcmp(panel_label, prop->panel_label) : true;
>+		package_match = package_label && prop->package_label ?
>+			!nla_strcmp(package_label,
>+				    prop->package_label) : true;
>+		if (cid_match && mod_match && type_match && board_match &&
>+		    panel_match && package_match) {
>+			if (pin_match)

Double match, rigth? Fillup the extack telling the user what happened.


>+				return NULL;
>+			pin_match = pin;
>+		};
>+	}
>+
>+	return pin_match;
>+}
>+
>+static int
>+dpll_pin_find_from_nlattr(struct genl_info *info, struct sk_buff *skb)
>+{
>+	struct nlattr *attr, *mod_name_attr = NULL, *board_label_attr = NULL,
>+		*panel_label_attr = NULL, *package_label_attr = NULL;
>+	struct dpll_pin *pin = NULL;
>+	enum dpll_pin_type type = 0;
>+	u64 clock_id = 0;
>+	int rem = 0;
>+
>+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(attr)) {
>+		case DPLL_A_CLOCK_ID:
>+			if (clock_id)
>+				return -EINVAL;

Extack


>+			clock_id = nla_get_u64(attr);
>+			break;
>+		case DPLL_A_MODULE_NAME:
>+			if (mod_name_attr)
>+				return -EINVAL;

Extack


>+			mod_name_attr = attr;
>+			break;
>+		case DPLL_A_PIN_TYPE:
>+			if (type)
>+				return -EINVAL;

Extack


>+			type = nla_get_u8(attr);
>+			break;
>+		case DPLL_A_PIN_BOARD_LABEL:
>+			if (board_label_attr)
>+				return -EINVAL;

Extack


>+			board_label_attr = attr;
>+			break;
>+		case DPLL_A_PIN_PANEL_LABEL:
>+			if (panel_label_attr)
>+				return -EINVAL;

Extack


>+			panel_label_attr = attr;
>+			break;
>+		case DPLL_A_PIN_PACKAGE_LABEL:
>+			if (package_label_attr)
>+				return -EINVAL;

Extack

You can use goto with one "duplicate attribute" message.


>+			package_label_attr = attr;
>+			break;
>+		default:
>+			break;
>+		}
>+	}
>+	if (!(clock_id  || mod_name_attr || board_label_attr ||
>+	      panel_label_attr || package_label_attr))
>+		return -EINVAL;
>+	pin = dpll_pin_find(clock_id, mod_name_attr, type, board_label_attr,
>+			    panel_label_attr, package_label_attr);

Error is either "notfound" of "duplicate match". Have the function
dpll_pin_find() return ERR_PTR with -ENODEV / -EINVAL and let
the function dpll_pin_find() also fill-up the proper extack inside.


>+	if (!pin)
>+		return -EINVAL;
>+	if (nla_put_u32(skb, DPLL_A_PIN_ID, pin->id))

Please move this call to the caller. This function should return ERR_PTR
or dpll_pin pointer.


>+		return -EMSGSIZE;
>+	return 0;
>+}
>+
>+int dpll_nl_pin_id_get_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct sk_buff *msg;
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
>+				DPLL_CMD_PIN_ID_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	ret = dpll_pin_find_from_nlattr(info, msg);
>+	if (ret) {
>+		nlmsg_free(msg);
>+		return ret;
>+	}
>+	genlmsg_end(msg, hdr);


This does not seem to be working:
$ sudo ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do device-id-get --json '{"module-name": "mlx5_dpll"}'
{'id': 0}
$ sudo ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do pin-id-get --json '{"module-name": "mlx5_dpll"}'
Traceback (most recent call last):
  File "/mnt/share156/jiri/net-next/./tools/net/ynl/cli.py", line 52, in <module>
    main()
  File "/mnt/share156/jiri/net-next/./tools/net/ynl/cli.py", line 40, in main
    reply = ynl.do(args.do, attrs)
  File "/mnt/share156/jiri/net-next/tools/net/ynl/lib/ynl.py", line 596, in do
    return self._op(method, vals)
  File "/mnt/share156/jiri/net-next/tools/net/ynl/lib/ynl.py", line 567, in _op
    raise NlError(nl_msg)
lib.ynl.NlError: Netlink error: Invalid argument
nl_len = 36 (20) nl_flags = 0x100 nl_type = 2
	error: -22
$ sudo ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do device-id-get --json '{"clock-id": "630763432553410540"}'
{'id': 0}
$ sudo ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do pin-id-get --json '{"clock-id": "630763432553410540"}'
Traceback (most recent call last):
  File "/mnt/share156/jiri/net-next/./tools/net/ynl/cli.py", line 52, in <module>
    main()
  File "/mnt/share156/jiri/net-next/./tools/net/ynl/cli.py", line 40, in main
    reply = ynl.do(args.do, attrs)
  File "/mnt/share156/jiri/net-next/tools/net/ynl/lib/ynl.py", line 596, in do
    return self._op(method, vals)
  File "/mnt/share156/jiri/net-next/tools/net/ynl/lib/ynl.py", line 567, in _op
    raise NlError(nl_msg)
lib.ynl.NlError: Netlink error: Invalid argument
nl_len = 36 (20) nl_flags = 0x100 nl_type = 2
	error: -22



>+
>+	return genlmsg_reply(msg, info);
>+}
>+
>+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_pin *pin = info->user_ptr[0];
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

Same here, also use REGISTERED mark and iterate over them.


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
>+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_pin *pin = info->user_ptr[0];
>+
>+	return dpll_pin_set_from_nlattr(pin, info);
>+}
>+
>+static struct dpll_device *
>+dpll_device_find(u64 clock_id, struct nlattr *mod_name_attr,
>+		 enum dpll_type type)
>+{
>+	struct dpll_device *dpll_match = NULL, *dpll;
>+	bool cid_match, mod_match, type_match;
>+	unsigned long i;
>+
>+	xa_for_each_marked(&dpll_device_xa, i, dpll, DPLL_REGISTERED) {
>+		cid_match = clock_id ? dpll->clock_id == clock_id : true;
>+		mod_match = mod_name_attr && module_name(dpll->module) ?
>+			!nla_strcmp(mod_name_attr,
>+				    module_name(dpll->module)) : true;
>+		type_match = type ? dpll->type == type : true;
>+		if (cid_match && mod_match && type_match) {
>+			if (dpll_match)

Double match, rigth? Fillup the extack telling the user what happened.


>+				return NULL;
>+			dpll_match = dpll;
>+		}
>+	}
>+
>+	return dpll_match;
>+}
>+
>+static int
>+dpll_device_find_from_nlattr(struct genl_info *info, struct sk_buff *skb)
>+{
>+	struct nlattr *attr, *mod_name_attr = NULL;
>+	struct dpll_device *dpll = NULL;
>+	enum dpll_type type = 0;
>+	u64 clock_id = 0;
>+	int rem = 0;
>+
>+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(attr)) {
>+		case DPLL_A_CLOCK_ID:
>+			if (clock_id)
>+				return -EINVAL;

Extack


>+			clock_id = nla_get_u64(attr);
>+			break;
>+		case DPLL_A_MODULE_NAME:
>+			if (mod_name_attr)
>+				return -EINVAL;

Extack


>+			mod_name_attr = attr;
>+			break;
>+		case DPLL_A_TYPE:
>+			if (type)
>+				return -EINVAL;

Extack

You can use goto with one "duplicate attribute" message.


>+			type = nla_get_u8(attr);
>+			break;
>+		default:
>+			break;
>+		}
>+	}
>+
>+	if (!clock_id && !mod_name_attr && !type)
>+		return -EINVAL;
>+	dpll = dpll_device_find(clock_id, mod_name_attr, type);

Error is either "notfound" of "duplicate match". Have the function
dpll_device_find() return ERR_PTR with -ENODEV / -EINVAL and let
the function dpll_device_find() also fill-up the proper extack inside.


>+	if (!dpll)
>+		return -EINVAL;
>+
>+	return dpll_msg_add_dev_handle(skb, dpll);

Please move this call to the caller. This function should return ERR_PTR
or dpll_device pointer.


>+}
>+
>+static int
>+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)

Nit: Please move this function above dpll_device_find() to maintain the
same functions ordering as there is for similar pin functions above.


>+{
>+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
>+	struct nlattr *tb[DPLL_A_MAX + 1];
>+	int ret = 0;

Drop pointless init.


>+
>+	nla_parse(tb, DPLL_A_MAX, genlmsg_data(info->genlhdr),
>+		  genlmsg_len(info->genlhdr), NULL, info->extack);
>+	if (tb[DPLL_A_MODE]) {
>+		ret = ops->mode_set(dpll, dpll_priv(dpll),
>+				    nla_get_u8(tb[DPLL_A_MODE]), info->extack);
>+		if (ret)
>+			return ret;
>+	}
>+
>+	return 0;
>+}
>+
>+int dpll_nl_device_id_get_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct sk_buff *msg;
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
>+				DPLL_CMD_DEVICE_ID_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	ret = dpll_device_find_from_nlattr(info, msg);
>+	if (ret) {
>+		nlmsg_free(msg);
>+		return ret;
>+	}
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
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
>+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+
>+	return dpll_set_from_nlattr(dpll, info);
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

Hmm, did you consider adding xa_for_each_marked_start?


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
>+	mutex_lock(&dpll_lock);
>+	id = nla_get_u32(info->attrs[DPLL_A_ID]);
>+
>+	dpll_id = dpll_device_get_by_id(id);
>+	if (!dpll_id)
>+		goto unlock;
>+	info->user_ptr[0] = dpll_id;
>+	return 0;
>+unlock:
>+	mutex_unlock(&dpll_lock);
>+	return -ENODEV;
>+}
>+
>+void dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		    struct genl_info *info)
>+{
>+	mutex_unlock(&dpll_lock);
>+}
>+
>+int
>+dpll_lock_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		     struct genl_info *info)
>+{
>+	mutex_lock(&dpll_lock);
>+
>+	return 0;
>+}
>+
>+void
>+dpll_unlock_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		   struct genl_info *info)
>+{
>+	mutex_unlock(&dpll_lock);
>+}
>+
>+int dpll_lock_dumpit(struct netlink_callback *cb)
>+{
>+	mutex_lock(&dpll_lock);
>+
>+	return 0;
>+}
>+
>+int dpll_unlock_dumpit(struct netlink_callback *cb)
>+{
>+	mutex_unlock(&dpll_lock);
>+
>+	return 0;
>+}
>+
>+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		      struct genl_info *info)
>+{
>+	int ret;
>+
>+	mutex_lock(&dpll_lock);
>+	if (!info->attrs[DPLL_A_PIN_ID]) {

Use GENL_REQ_ATTR_CHECK(info, DPLL_A_PIN_ID);
If fills-up the extack info about missing attr giving the user info
about what went wrong.


>+		ret = -EINVAL;
>+		goto unlock_dev;
>+	}
>+	info->user_ptr[0] = xa_load(&dpll_pin_xa,
>+				    nla_get_u32(info->attrs[DPLL_A_PIN_ID]));
>+	if (!info->user_ptr[0]) {

Fill-up the extack message please.


>+		ret = -ENODEV;
>+		goto unlock_dev;
>+	}
>+
>+	return 0;
>+
>+unlock_dev:
>+	mutex_unlock(&dpll_lock);
>+	return ret;
>+}
>+
>+void dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+			struct genl_info *info)
>+{
>+	mutex_unlock(&dpll_lock);
>+}
>+
>+static int
>+dpll_device_event_send(enum dpll_cmd event, struct dpll_device *dpll)
>+{
>+	struct sk_buff *msg;
>+	int ret = -EMSGSIZE;

Drop the pointless init.


>+	void *hdr;
>+
>+	if (!xa_get_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED))

WARN_ON? The driver is buggy when he calls this.


>+		return -ENODEV;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
>+	if (!hdr)
>+		goto out_free_msg;

"err_free_msg" so that is clear is an error path.


>+	ret = dpll_device_get_one(dpll, msg, NULL);
>+	if (ret)
>+		goto out_cancel_msg;

Same here, "err_cancel_msg"


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
>+int dpll_device_create_ntf(struct dpll_device *dpll)
>+{
>+	return dpll_device_event_send(DPLL_CMD_DEVICE_CREATE_NTF, dpll);
>+}
>+
>+int dpll_device_delete_ntf(struct dpll_device *dpll)
>+{
>+	return dpll_device_event_send(DPLL_CMD_DEVICE_DELETE_NTF, dpll);
>+}
>+

This is an exported function, documentation commentary perhaps?
I mean, you sometimes have it for static functions, here you don't. Very
odd.

Let's have that for all exported functions please.


>+int dpll_device_change_ntf(struct dpll_device *dpll)
>+{
>+	int ret = -EINVAL;
>+
>+	if (WARN_ON(!dpll))
>+		return ret;

Rely on basic driver sanity and drop this check. don't forget to remove
the ret initialization.


>+
>+	mutex_lock(&dpll_lock);
>+	ret = dpll_device_event_send(DPLL_CMD_DEVICE_CHANGE_NTF, dpll);
>+	mutex_unlock(&dpll_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_change_ntf);
>+
>+static int
>+dpll_pin_event_send(enum dpll_cmd event, struct dpll_pin *pin)
>+{
>+	struct dpll_pin *pin_verify;
>+	struct sk_buff *msg;
>+	int ret = -EMSGSIZE;

Drop the pointless init.


>+	void *hdr;
>+
>+	pin_verify = xa_load(&dpll_pin_xa, pin->id);
>+	if (pin != pin_verify)

I don't follow. What is the purpose for this check? Once you have
REGISTERED mark for pin, you can check it here and be consistent with
dpll_device_event_send()


>+		return -ENODEV;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
>+	if (!hdr)
>+		goto out_free_msg;

"err_free_msg" so that is clear is an error path.


>+	ret = __dpll_cmd_pin_dump_one(msg, pin, NULL);
>+	if (ret)
>+		goto out_cancel_msg;

Same here, "err_cancel_msg"


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
>+int dpll_pin_create_ntf(struct dpll_pin *pin)
>+{
>+	return dpll_pin_event_send(DPLL_CMD_PIN_CREATE_NTF, pin);
>+}
>+
>+int dpll_pin_delete_ntf(struct dpll_pin *pin)
>+{
>+	return dpll_pin_event_send(DPLL_CMD_PIN_DELETE_NTF, pin);
>+}
>+
>+static int __dpll_pin_change_ntf(struct dpll_pin *pin)
>+{
>+	return dpll_pin_event_send(DPLL_CMD_PIN_CHANGE_NTF, pin);
>+}
>+
>+int dpll_pin_change_ntf(struct dpll_pin *pin)
>+{
>+	int ret = -EINVAL;
>+
>+	if (WARN_ON(!pin))
>+		return ret;

Remove this check and expect basic sanity from driver. Also, don't
forget to drop the "ret" initialization.


>+
>+	mutex_lock(&dpll_lock);
>+	ret = __dpll_pin_change_ntf(pin);
>+	mutex_unlock(&dpll_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(dpll_pin_change_ntf);
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
>index 000000000000..b5f9bfc88c9e
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -0,0 +1,44 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2023 Meta Platforms, Inc. and affiliates
>+ *  Copyright (c) 2023 Intel and affiliates
>+ */
>+
>+/**
>+ * dpll_device_create_ntf - notify that the device has been created
>+ * @dpll: registered dpll pointer
>+ *
>+ * Context: caller shall hold dpll_xa_lock.
>+ * Return: 0 if succeeds, error code otherwise.
>+ */
>+int dpll_device_create_ntf(struct dpll_device *dpll);
>+
>+/**
>+ * dpll_device_delete_ntf - notify that the device has been deleted
>+ * @dpll: registered dpll pointer
>+ *
>+ * Context: caller shall hold dpll_xa_lock.
>+ * Return: 0 if succeeds, error code otherwise.
>+ */

Again, I'm going to repeat myself. Please have this kdoc comments once,
in the .c file. Header should not contain this.



>+int dpll_device_delete_ntf(struct dpll_device *dpll);
>+
>+/**
>+ * dpll_pin_create_ntf - notify that the pin has been created
>+ * @pin: registered pin pointer
>+ *
>+ * Context: caller shall hold dpll_xa_lock.
>+ * Return: 0 if succeeds, error code otherwise.
>+ */
>+int dpll_pin_create_ntf(struct dpll_pin *pin);
>+
>+/**
>+ * dpll_pin_delete_ntf - notify that the pin has been deleted
>+ * @pin: registered pin pointer
>+ *
>+ * Context: caller shall hold dpll_xa_lock.
>+ * Return: 0 if succeeds, error code otherwise.
>+ */
>+int dpll_pin_delete_ntf(struct dpll_pin *pin);
>+
>+int __init dpll_netlink_init(void);
>+void dpll_netlink_finish(void);
>-- 
>2.37.3
>

