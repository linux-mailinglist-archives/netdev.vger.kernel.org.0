Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AEB5EF504
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiI2MNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiI2MNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:13:13 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3C1D62E1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 05:13:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b2so2370734eja.6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 05:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TWfYOVwvTRjWIA4RZEYSetTqYlpxzdA06vkMaN0uTAs=;
        b=RxLKg96cFC1EkxlWDFl4LbMEt9bdRg5LiNPsPGcBgKZWK1w9mCdTCU7sZk+JOHU8Cc
         TTOY19OKOX/tEVso1kFDmG00+Zs3IP3bE1SWGArS8mHc6TstgZDdC5shFIlsYQ/gSGLW
         otoAXcmOknNHVEA67gy2QyXDJ+lZEXKAe920LZz6nfoWiL7rKiVi9myLfH7AoHhnHJD9
         3yT+EbKi99wt+itd67V1+TDDYcYA7OGenH/CklhwdzWWVB0kaAGykOdT1nX/woS6qIh/
         IS9TvQ1GWp3km8aA4l2Xt/1g+lbtMwAMD0PTagc3/QTdnc4H64qxxLACF91npztENo7U
         7B8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TWfYOVwvTRjWIA4RZEYSetTqYlpxzdA06vkMaN0uTAs=;
        b=tIATdYBwdZpGQr0cenODPQ9+waOvieQpmNob3XIKnLnJVfxB962250C+gtWy8v/Jqg
         WeeSvkBUCLenZnVdoGYKbGjNED/j/5kNyai/9rS+jZX+VQMJIaWqCOD/OjlvCsTuqpFS
         nt0NsrfoptPGtfoRAOakzQjkPfMh1O3yd6obKs8pOBdfY371KEbREvYnF01U+KL7OdJU
         yjFRJj7lXWy1qZ70trNx3pJKb/4Xfg7nuHRkcniqJHb8uwI6CBzlLgqW9fsKOdamtdB2
         Xcc6MXmvMgEOE6He8zuW1e0nD3WzXPYRKb0fy97TexCU/41oHEYiYpQQqkJJBujMqtAf
         bQfQ==
X-Gm-Message-State: ACrzQf2eWl1R5hgCQ1MAGD4Q3UW57AZSpc8QzdpoG6GdWQRI3o+vG1/1
        ZKifLlN11e2YOZEnXPWRyso8SA==
X-Google-Smtp-Source: AMsMyM7oIIds9bRKxxMofnuB8GvqPVD5b7xk843c5yUZpTNxUSmi9iSoDCac+QpzbJFPef3sVq5xKg==
X-Received: by 2002:a17:907:a079:b0:770:78cb:6650 with SMTP id ia25-20020a170907a07900b0077078cb6650mr2420390ejc.515.1664453587896;
        Thu, 29 Sep 2022 05:13:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r8-20020aa7da08000000b00456f2dbb379sm5282523eds.62.2022.09.29.05.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 05:13:07 -0700 (PDT)
Date:   Thu, 29 Sep 2022 14:13:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dpll: add netlink events
Message-ID: <YzWL0QpCYDEwtj5P@nanopsycho>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220626192444.29321-3-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jun 26, 2022 at 09:24:43PM CEST, vfedorenko@novek.ru wrote:
>From: Vadim Fedorenko <vadfed@fb.com>
>
>Add netlink interface to enable notification of users about
>events in DPLL framework. Part of this interface should be
>used by drivers directly, i.e. lock status changes.

I don't get why this is a separate patch. I believe it should be
squashed to the previous one, making it easier to review as a whole
thing.


>
>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>---
> drivers/dpll/dpll_core.c    |   2 +
> drivers/dpll/dpll_netlink.c | 141 ++++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h |   7 ++
> 3 files changed, 150 insertions(+)
>
>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>index dc0330e3687d..387644aa910e 100644
>--- a/drivers/dpll/dpll_core.c
>+++ b/drivers/dpll/dpll_core.c
>@@ -97,6 +97,8 @@ struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_c
> 	mutex_unlock(&dpll_device_xa_lock);
> 	dpll->priv = priv;
> 
>+	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
>+
> 	return dpll;
> 
> error:
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>index e15106f30377..4b1684fcf41e 100644
>--- a/drivers/dpll/dpll_netlink.c
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -48,6 +48,8 @@ struct param {
> 	int dpll_source_type;
> 	int dpll_output_id;
> 	int dpll_output_type;
>+	int dpll_status;
>+	const char *dpll_name;
> };
> 
> struct dpll_dump_ctx {
>@@ -239,6 +241,8 @@ static int dpll_genl_cmd_set_source(struct param *p)
> 	ret = dpll->ops->set_source_type(dpll, src_id, type);
> 	mutex_unlock(&dpll->lock);
> 
>+	dpll_notify_source_change(dpll->id, src_id, type);
>+
> 	return ret;
> }
> 
>@@ -262,6 +266,8 @@ static int dpll_genl_cmd_set_output(struct param *p)
> 	ret = dpll->ops->set_source_type(dpll, out_id, type);
> 	mutex_unlock(&dpll->lock);
> 
>+	dpll_notify_source_change(dpll->id, out_id, type);
>+
> 	return ret;
> }
> 
>@@ -438,6 +444,141 @@ static struct genl_family dpll_gnl_family __ro_after_init = {
> 	.pre_doit	= dpll_pre_doit,
> };
> 
>+static int dpll_event_device_create(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_string(p->msg, DPLLA_DEVICE_NAME, p->dpll_name))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_device_delete(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_status(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+		nla_put_u32(p->msg, DPLLA_LOCK_STATUS, p->dpll_status))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_source_change(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_u32(p->msg, DPLLA_SOURCE_ID, p->dpll_source_id) ||
>+		nla_put_u32(p->msg, DPLLA_SOURCE_TYPE, p->dpll_source_type))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_event_output_change(struct param *p)
>+{
>+	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>+	    nla_put_u32(p->msg, DPLLA_OUTPUT_ID, p->dpll_output_id) ||
>+		nla_put_u32(p->msg, DPLLA_OUTPUT_TYPE, p->dpll_output_type))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static cb_t event_cb[] = {
>+	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_create,
>+	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_delete,
>+	[DPLL_EVENT_STATUS_LOCKED]	= dpll_event_status,
>+	[DPLL_EVENT_STATUS_UNLOCKED]	= dpll_event_status,
>+	[DPLL_EVENT_SOURCE_CHANGE]	= dpll_event_source_change,
>+	[DPLL_EVENT_OUTPUT_CHANGE]	= dpll_event_output_change,
>+};
>+/*
>+ * Generic netlink DPLL event encoding
>+ */
>+static int dpll_send_event(enum dpll_genl_event event,
>+				   struct param *p)

"struct param". Can't you please maintain some namespace for
function/struct names?


>+{
>+	struct sk_buff *msg;
>+	int ret = -EMSGSIZE;
>+	void *hdr;
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	p->msg = msg;
>+
>+	hdr = genlmsg_put(msg, 0, 0, &dpll_gnl_family, 0, event);
>+	if (!hdr)
>+		goto out_free_msg;
>+
>+	ret = event_cb[event](p);
>+	if (ret)
>+		goto out_cancel_msg;
>+
>+	genlmsg_end(msg, hdr);
>+
>+	genlmsg_multicast(&dpll_gnl_family, msg, 0, 1, GFP_KERNEL);
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
>+int dpll_notify_device_create(int dpll_id, const char *name)
>+{
>+	struct param p = { .dpll_id = dpll_id, .dpll_name = name };
>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);

Just do that automatically in register() and avoid the need to rely on
drivers to be so good to do it themselves. They won't.


>+}
>+
>+int dpll_notify_device_delete(int dpll_id)
>+{
>+	struct param p = { .dpll_id = dpll_id };
>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>+}
>+
>+int dpll_notify_status_locked(int dpll_id)

For all notification functions called from the driver, please use struct
dpll as an arg.


>+{
>+	struct param p = { .dpll_id = dpll_id, .dpll_status = 1 };
>+
>+	return dpll_send_event(DPLL_EVENT_STATUS_LOCKED, &p);
>+}
>+
>+int dpll_notify_status_unlocked(int dpll_id)
>+{
>+	struct param p = { .dpll_id = dpll_id, .dpll_status = 0 };
>+
>+	return dpll_send_event(DPLL_EVENT_STATUS_UNLOCKED, &p);
>+}
>+
>+int dpll_notify_source_change(int dpll_id, int source_id, int source_type)
>+{
>+	struct param p =  { .dpll_id = dpll_id, .dpll_source_id = source_id,
>+						.dpll_source_type = source_type };
>+
>+	return dpll_send_event(DPLL_EVENT_SOURCE_CHANGE, &p);
>+}
>+
>+int dpll_notify_output_change(int dpll_id, int output_id, int output_type)
>+{
>+	struct param p =  { .dpll_id = dpll_id, .dpll_output_id = output_id,
>+						.dpll_output_type = output_type };
>+
>+	return dpll_send_event(DPLL_EVENT_OUTPUT_CHANGE, &p);
>+}
>+
> int __init dpll_netlink_init(void)
> {
> 	return genl_register_family(&dpll_gnl_family);
>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>index e2d100f59dd6..0dc81320f982 100644
>--- a/drivers/dpll/dpll_netlink.h
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -3,5 +3,12 @@
>  *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>  */
> 
>+int dpll_notify_device_create(int dpll_id, const char *name);
>+int dpll_notify_device_delete(int dpll_id);
>+int dpll_notify_status_locked(int dpll_id);
>+int dpll_notify_status_unlocked(int dpll_id);
>+int dpll_notify_source_change(int dpll_id, int source_id, int source_type);
>+int dpll_notify_output_change(int dpll_id, int output_id, int output_type);

Why these are not returning void? Does driver care about the return
value? Why?


>+
> int __init dpll_netlink_init(void);
> void dpll_netlink_finish(void);
>-- 
>2.27.0
>
