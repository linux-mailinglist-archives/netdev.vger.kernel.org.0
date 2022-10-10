Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF14C5F9FFC
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJJONz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJJONy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:13:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4296413F4D
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:13:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ot12so25229513ejb.1
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gLeu4OTARBRPVkzqrJeMhmE3Jykbkg/mP5JvnMUkyQ0=;
        b=i5ntCQhfMxisA9zoZajtYK+KrWG4//UtSGe3snp9Ns+faatUVjTpJKxt+0hsOHXn0v
         0CJOSvAwG3kaFWHrZC1t+r48ma6Jup2ybPyMtuknbJQiJStEXcqydgUdhlprpJ+NJpJp
         FV1h8mo5syan0Dke+XLv4Y1hxjGqNZ3jtxTQRjL6psnrWipzlue920b1WzxNOA4R28Jo
         Z/xCzOgwNhfN8GOR1SOYG6ti/aFnHoBciWRmcXAKz5uJgMLZpcag34XswV2fYaS2CqVp
         UiqQty6Ueo4SJEpHvrWnXTzHgkEyOnfSqiJzlV6I65MuqVR8iaBL42Mj8NJer5b6rm4u
         xLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLeu4OTARBRPVkzqrJeMhmE3Jykbkg/mP5JvnMUkyQ0=;
        b=B3giMgGz3Mr6n7SZ+bOCz/qINy6dpuYmzA8CI7/WplrcsYKZ73LNjNO0YSLCqW8iFq
         NrVlkcB63jHnvQQZ8LfrfwT49OZjNJG380hSCSm15Wj02dKGY4IaPB1dGPwoxBPaPPrk
         C7zL0GbZLrvjtTg7FILL62qMlcISNhlTwkMTYCV0ULEh/iL5rqlPE1gu7yVT5efEGtlN
         YE8PIyDInYzetnq8DgRTTO/OTQwnySB4pxxfu0pidzDfxITsqgzCSPkgs7r71QjBSKOb
         FHF+clBW8+w7h8eYKheizb0y9lFhUfFM3/+0tPsPpOYySYdwHu8Y9644NMyc1sw9lYFj
         Nvpg==
X-Gm-Message-State: ACrzQf2GdU5AXJR2QhD0JigFcDOgE8S1wXvWk/p4izxsJFjQagi3pYHP
        CiEf6XoEnsMllD9uoXSTQjjNaOhqZlZFL2nl
X-Google-Smtp-Source: AMsMyM7PGxjo43A2kuCiRhIV06KGBSg8zfK7g41RgNKIJaeH8N/cxoDK+vlWsTXsfrRC7P8kbsPzDA==
X-Received: by 2002:a17:907:3e9a:b0:782:72be:7335 with SMTP id hs26-20020a1709073e9a00b0078272be7335mr14478410ejc.630.1665411230686;
        Mon, 10 Oct 2022 07:13:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id lb9-20020a170907784900b0076ff600bf2csm5455045ejc.63.2022.10.10.07.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 07:13:49 -0700 (PDT)
Date:   Mon, 10 Oct 2022 16:13:48 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 3/6] dpll: add support for source selection modes
Message-ID: <Y0QonL0p2i6s4C6m@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-4-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010011804.23716-4-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 10, 2022 at 03:18:01AM CEST, vfedorenko@novek.ru wrote:
>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>Allow to configure dpll device for different source selection modes.
>Allow to configure priority of a sources for autmoatic selection mode.
>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>---
> drivers/dpll/dpll_netlink.c | 170 ++++++++++++++++++++++++++++++++++--
> drivers/dpll/dpll_netlink.h |   2 +
> include/linux/dpll.h        |   7 ++
> include/uapi/linux/dpll.h   |  22 ++++-
> 4 files changed, 192 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>index 6dc92b5b712e..a5779871537a 100644
>--- a/drivers/dpll/dpll_netlink.c
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -23,6 +23,7 @@ static const struct nla_policy dpll_genl_get_policy[] = {
> 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
> 	[DPLLA_DEVICE_NAME]	= { .type = NLA_STRING,
> 				    .len = DPLL_NAME_LENGTH },
>+	[DPLLA_DEVICE_SRC_SELECT_MODE] = { .type = NLA_U32 },
> 	[DPLLA_FLAGS]		= { .type = NLA_U32 },
> };
> 
>@@ -38,13 +39,26 @@ static const struct nla_policy dpll_genl_set_output_policy[] = {
> 	[DPLLA_OUTPUT_TYPE]	= { .type = NLA_U32 },
> };
> 
>+static const struct nla_policy dpll_genl_set_src_select_mode_policy[] = {
>+	[DPLLA_DEVICE_ID]		  = { .type = NLA_U32 },
>+	[DPLLA_DEVICE_SRC_SELECT_MODE] = { .type = NLA_U32 },
>+};
>+
>+static const struct nla_policy dpll_genl_set_source_prio_policy[] = {
>+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
>+	[DPLLA_SOURCE_ID]	= { .type = NLA_U32 },
>+	[DPLLA_SOURCE_PRIO]	= { .type = NLA_U32 },
>+};
>+
> struct param {
> 	struct netlink_callback *cb;
> 	struct dpll_device *dpll;
> 	struct sk_buff *msg;
> 	int dpll_id;
>+	int dpll_src_select_mode;
> 	int dpll_source_id;
> 	int dpll_source_type;
>+	int dpll_source_prio;
> 	int dpll_output_id;
> 	int dpll_output_type;
> 	int dpll_status;
>@@ -84,8 +98,8 @@ static int __dpll_cmd_device_dump_one(struct dpll_device *dpll,
> static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
> 					   struct sk_buff *msg)
> {
>+	int i, ret = 0, type, prio;
> 	struct nlattr *src_attr;
>-	int i, ret = 0, type;
> 
> 	for (i = 0; i < dpll->sources_count; i++) {
> 		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
>@@ -110,6 +124,14 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
> 			}
> 			ret = 0;
> 		}
>+		if (dpll->ops->get_source_prio) {
>+			prio = dpll->ops->get_source_prio(dpll, i);
>+			if (nla_put_u32(msg, DPLLA_SOURCE_PRIO, prio)) {
>+				nla_nest_cancel(msg, src_attr);
>+				ret = -EMSGSIZE;
>+				break;
>+			}
>+		}
> 		nla_nest_end(msg, src_attr);
> 	}
> 
>@@ -154,26 +176,51 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
> static int __dpll_cmd_dump_status(struct dpll_device *dpll,
> 					   struct sk_buff *msg)
> {
>-	int ret;
>+	struct dpll_device_ops *ops = dpll->ops;
>+	int ret, type, attr;
> 
>-	if (dpll->ops->get_status) {
>-		ret = dpll->ops->get_status(dpll);
>+	if (ops->get_status) {
>+		ret = ops->get_status(dpll);
> 		if (nla_put_u32(msg, DPLLA_STATUS, ret))
> 			return -EMSGSIZE;
> 	}
> 
>-	if (dpll->ops->get_temp) {
>-		ret = dpll->ops->get_temp(dpll);
>+	if (ops->get_temp) {
>+		ret = ops->get_temp(dpll);
> 		if (nla_put_u32(msg, DPLLA_TEMP, ret))
> 			return -EMSGSIZE;
> 	}
> 
>-	if (dpll->ops->get_lock_status) {
>-		ret = dpll->ops->get_lock_status(dpll);
>+	if (ops->get_lock_status) {
>+		ret = ops->get_lock_status(dpll);
> 		if (nla_put_u32(msg, DPLLA_LOCK_STATUS, ret))
> 			return -EMSGSIZE;
> 	}
> 
>+	if (ops->get_source_select_mode) {
>+		ret = ops->get_source_select_mode(dpll);
>+		if (nla_put_u32(msg, DPLLA_DEVICE_SRC_SELECT_MODE, ret))
>+			return -EMSGSIZE;
>+	} else {
>+		if (nla_put_u32(msg, DPLLA_DEVICE_SRC_SELECT_MODE,
>+				DPLL_SRC_SELECT_FORCED))
>+			return -EMSGSIZE;
>+	}
>+
>+	if (ops->get_source_select_mode_supported) {
>+		attr = DPLLA_DEVICE_SRC_SELECT_MODE_SUPPORTED;
>+		for (type = 0; type <= DPLL_SRC_SELECT_MAX; type++) {
>+			ret = ops->get_source_select_mode_supported(dpll,
>+								    type);
>+			if (ret && nla_put_u32(msg, attr, type))
>+				return -EMSGSIZE;
>+		}
>+	} else {
>+		if (nla_put_u32(msg, DPLLA_DEVICE_SRC_SELECT_MODE_SUPPORTED,
>+				DPLL_SRC_SELECT_FORCED))
>+			return -EMSGSIZE;
>+	}
>+
> 	return 0;
> }
> 
>@@ -275,6 +322,56 @@ static int dpll_genl_cmd_set_output(struct sk_buff *skb, struct genl_info *info)
> 	return ret;
> }
> 
>+static int dpll_genl_cmd_set_source_prio(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	int ret = 0, src_id, prio;
>+
>+	if (!attrs[DPLLA_SOURCE_ID] ||
>+	    !attrs[DPLLA_SOURCE_PRIO])
>+		return -EINVAL;
>+
>+	if (!dpll->ops->set_source_prio)
>+		return -EOPNOTSUPP;
>+
>+	src_id = nla_get_u32(attrs[DPLLA_SOURCE_ID]);
>+	prio = nla_get_u32(attrs[DPLLA_SOURCE_PRIO]);
>+
>+	mutex_lock(&dpll->lock);
>+	ret = dpll->ops->set_source_prio(dpll, src_id, prio);
>+	mutex_unlock(&dpll->lock);
>+
>+	if (!ret)
>+		dpll_notify_source_prio_change(dpll->id, src_id, prio);
>+
>+	return ret;
>+}
>+
>+static int dpll_genl_cmd_set_select_mode(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	int ret = 0, mode;
>+
>+	if (!attrs[DPLLA_DEVICE_SRC_SELECT_MODE])
>+		return -EINVAL;
>+
>+	if (!dpll->ops->set_source_select_mode)
>+		return -EOPNOTSUPP;
>+
>+	mode = nla_get_u32(attrs[DPLLA_DEVICE_SRC_SELECT_MODE]);
>+
>+	mutex_lock(&dpll->lock);
>+	ret = dpll->ops->set_source_select_mode(dpll, mode);
>+	mutex_unlock(&dpll->lock);
>+
>+	if (!ret)
>+		dpll_notify_source_select_mode_change(dpll->id, mode);
>+
>+	return ret;
>+}
>+
> static int dpll_device_loop_cb(struct dpll_device *dpll, void *data)
> {
> 	struct dpll_dump_ctx *ctx;
>@@ -397,6 +494,20 @@ static const struct genl_ops dpll_genl_ops[] = {
> 		.policy	= dpll_genl_set_output_policy,
> 		.maxattr = ARRAY_SIZE(dpll_genl_set_output_policy) - 1,
> 	},
>+	{
>+		.cmd	= DPLL_CMD_SET_SRC_SELECT_MODE,
>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= dpll_genl_cmd_set_select_mode,
>+		.policy	= dpll_genl_set_src_select_mode_policy,
>+		.maxattr = ARRAY_SIZE(dpll_genl_set_src_select_mode_policy) - 1,
>+	},
>+	{
>+		.cmd	= DPLL_CMD_SET_SOURCE_PRIO,

I don't like the 1 netlink cmd per attr. The commands should be rather
get/set object.


>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= dpll_genl_cmd_set_source_prio,
>+		.policy	= dpll_genl_set_source_prio_policy,
>+		.maxattr = ARRAY_SIZE(dpll_genl_set_source_prio_policy) - 1,
>+	},
> };
> 
> static struct genl_family dpll_gnl_family __ro_after_init = {
>@@ -456,6 +567,26 @@ static int dpll_event_output_change(struct param *p)
> 	return 0;
> }
> 
>+static int dpll_event_source_prio(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_u32(p->msg, DPLLA_SOURCE_ID, p->dpll_source_id) ||
>+	    nla_put_u32(p->msg, DPLLA_SOURCE_PRIO, p->dpll_source_prio))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_select_mode(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_u32(p->msg, DPLLA_DEVICE_SRC_SELECT_MODE,
>+		    p->dpll_src_select_mode))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
> static const cb_t event_cb[] = {
> 	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_create,
> 	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_delete,
>@@ -463,7 +594,10 @@ static const cb_t event_cb[] = {
> 	[DPLL_EVENT_STATUS_UNLOCKED]	= dpll_event_status,
> 	[DPLL_EVENT_SOURCE_CHANGE]	= dpll_event_source_change,
> 	[DPLL_EVENT_OUTPUT_CHANGE]	= dpll_event_output_change,
>+	[DPLL_EVENT_SOURCE_PRIO]        = dpll_event_source_prio,
>+	[DPLL_EVENT_SELECT_MODE]        = dpll_event_select_mode,
> };
>+
> /*
>  * Generic netlink DPLL event encoding
>  */
>@@ -552,6 +686,26 @@ int dpll_notify_output_change(int dpll_id, int output_id, int output_type)
> }
> EXPORT_SYMBOL_GPL(dpll_notify_output_change);
> 
>+int dpll_notify_source_select_mode_change(int dpll_id, int new_mode)
>+{
>+	struct param p =  { .dpll_id = dpll_id,
>+			    .dpll_src_select_mode = new_mode,
>+			    .dpll_event_group = 0 };
>+
>+	return dpll_send_event(DPLL_EVENT_SELECT_MODE, &p);
>+}
>+EXPORT_SYMBOL_GPL(dpll_notify_source_select_mode_change);
>+
>+int dpll_notify_source_prio_change(int dpll_id, int source_id, int prio)
>+{
>+	struct param p =  { .dpll_id = dpll_id, .dpll_source_id = source_id,
>+			    .dpll_source_prio = prio,
>+			    .dpll_event_group = 1 };
>+
>+	return dpll_send_event(DPLL_EVENT_SOURCE_PRIO, &p);
>+}
>+EXPORT_SYMBOL_GPL(dpll_notify_source_prio_change);
>+
> int __init dpll_netlink_init(void)
> {
> 	return genl_register_family(&dpll_gnl_family);
>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>index 5c1d1072e818..a4962fa0c8c2 100644
>--- a/drivers/dpll/dpll_netlink.h
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -5,6 +5,8 @@
> 
> int dpll_notify_device_create(int dpll_id, const char *name);
> int dpll_notify_device_delete(int dpll_id);
>+int dpll_notify_source_prio(int dpll_id, int source_id, int prio);
>+int dpll_notify_select_mode(int dpll_id, int mode);
> 
> int __init dpll_netlink_init(void);
> void dpll_netlink_finish(void);
>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>index 32558965cd41..3fe957a06b90 100644
>--- a/include/linux/dpll.h
>+++ b/include/linux/dpll.h
>@@ -12,12 +12,17 @@ struct dpll_device_ops {
> 	int (*get_status)(struct dpll_device *dpll);
> 	int (*get_temp)(struct dpll_device *dpll);
> 	int (*get_lock_status)(struct dpll_device *dpll);
>+	int (*get_source_select_mode)(struct dpll_device *dpll);
>+	int (*get_source_select_mode_supported)(struct dpll_device *dpll, int type);
> 	int (*get_source_type)(struct dpll_device *dpll, int id);
> 	int (*get_source_supported)(struct dpll_device *dpll, int id, int type);
>+	int (*get_source_prio)(struct dpll_device *dpll, int id);

I don't thing this is a good model to have 1 ops per object attribute.
Did you consider having driver to "register" a source/output with type and
other attributes?



> 	int (*get_output_type)(struct dpll_device *dpll, int id);
> 	int (*get_output_supported)(struct dpll_device *dpll, int id, int type);
> 	int (*set_source_type)(struct dpll_device *dpll, int id, int val);
> 	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
>+	int (*set_source_select_mode)(struct dpll_device *dpll, int mode);
>+	int (*set_source_prio)(struct dpll_device *dpll, int id, int prio);
> };
> 
> struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>@@ -31,4 +36,6 @@ int dpll_notify_status_locked(int dpll_id);
> int dpll_notify_status_unlocked(int dpll_id);
> int dpll_notify_source_change(int dpll_id, int source_id, int source_type);
> int dpll_notify_output_change(int dpll_id, int output_id, int output_type);
>+int dpll_notify_source_select_mode_change(int dpll_id, int source_select_mode);
>+int dpll_notify_source_prio_change(int dpll_id, int source_id, int prio);
> #endif
>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>index fcbea5a5e4d6..f6b674e5cf01 100644
>--- a/include/uapi/linux/dpll.h
>+++ b/include/uapi/linux/dpll.h
>@@ -21,10 +21,13 @@ enum dpll_genl_attr {
> 	DPLLA_UNSPEC,
> 	DPLLA_DEVICE_ID,
> 	DPLLA_DEVICE_NAME,
>+	DPLLA_DEVICE_SRC_SELECT_MODE,
>+	DPLLA_DEVICE_SRC_SELECT_MODE_SUPPORTED,
> 	DPLLA_SOURCE,
> 	DPLLA_SOURCE_ID,
> 	DPLLA_SOURCE_TYPE,
> 	DPLLA_SOURCE_SUPPORTED,
>+	DPLLA_SOURCE_PRIO,
> 	DPLLA_OUTPUT,
> 	DPLLA_OUTPUT_ID,
> 	DPLLA_OUTPUT_TYPE,
>@@ -82,6 +85,8 @@ enum dpll_genl_event {
> 	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */
> 	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */
> 	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */
>+	DPLL_EVENT_SOURCE_PRIO,
>+	DPLL_EVENT_SELECT_MODE,
> 
> 	__DPLL_EVENT_MAX,
> };
>@@ -90,12 +95,27 @@ enum dpll_genl_event {
> /* Commands supported by the dpll_genl_family */
> enum dpll_genl_cmd {
> 	DPLL_CMD_UNSPEC,
>-	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
>+	DPLL_CMD_DEVICE_GET,		/* List of DPLL devices id */
> 	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */
> 	DPLL_CMD_SET_OUTPUT_TYPE,	/* Set the DPLL device output type */
>+	DPLL_CMD_SET_SRC_SELECT_MODE,/* Set mode for selection of a source */
>+	DPLL_CMD_SET_SOURCE_PRIO,	/* Set priority of a source */
> 
> 	__DPLL_CMD_MAX,
> };
> #define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
> 
>+/* Source select modes of dpll */
>+enum dpll_genl_source_select_mode {
>+	DPLL_SRC_SELECT_UNSPEC,

consistency please: "source"/"SOURCE".


>+	DPLL_SRC_SELECT_FORCED,   /* Source forced by DPLL_CMD_SET_SOURCE_TYPE */
>+	DPLL_SRC_SELECT_AUTOMATIC,/* highest prio, valid source, auto selected by dpll */
>+	DPLL_SRC_SELECT_HOLDOVER, /* forced holdover */

I think this is mixing up things a bit. I was under impression this is
to set the mode or souce select. So either user select specific source
by index (not type as you suggest above), or you leave the selection up
to the device (according to prio).

Now holdover is not source select.
Isn't think more like admin state/oper state?
oper state would be the lock status
admin state would be "force-holdover"




>+	DPLL_SRC_SELECT_FREERUN,  /* dpll driven on system clk, no holdover available */
>+	DPLL_SRC_SELECT_NCO,	     /* Set the DPLL device output type */

I don't understand what this "NCO" is, the comment didn't help.


>+
>+	__DPLL_SRC_SELECT_MAX,
>+};
>+#define DPLL_SRC_SELECT_MAX (__DPLL_SRC_SELECT_MAX - 1)
>+
> #endif /* _UAPI_LINUX_DPLL_H */
>-- 
>2.27.0
>
