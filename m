Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C836763DAD4
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiK3Qhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiK3Qhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:37:36 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1345C4AF00
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:37:29 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ha10so42777422ejb.3
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMYZJBOHc+N9RyfaDYVbWCoat2Zhca9UkSak9LcR5gk=;
        b=wUkE6KonI9Jsgc8LgBKbcIGE2cBJ13D5vH2l4XmNm52s6To/19WWquMdfmeNE8d1lC
         vCuwfWTSlPap5acqL2SYdhMSRs/Mo5tOVrM1voOYLhADNL4yU/d/i0oOOtrPFpgARISU
         1j3cKSL2bQvYyCPNcdiIWfpUitEEYNzWL+cwWcFsmaRAX41QSFZ3rIm0rJpA10PZBUUJ
         VuWTmfPnh1FL2OTkLmWPxTNQpbZLzR8Bf+ydc4FnseuOLZ/7QaZtpQM+oHkJQ4ZjWX11
         i6JGk9z17lHGWh4IHDnS7cf/Wp3ehcYP+A8LyqgXTn/ymm0+bCxTFkFixoOpMRqt+tL9
         9wYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMYZJBOHc+N9RyfaDYVbWCoat2Zhca9UkSak9LcR5gk=;
        b=A6nA04O5oVGZYFRjE7QSQLF8bRYZkK3L0ZyF2jiOhqR+OgHH/i12zpdn1gk7XiyWbY
         /MFYHF4oNJv4+ppW+1i19TfWuxDnl/ns8LcUSQ7QpLd22v0iB4jTrJdw7Wc0pza3QZIR
         FQEurNBwA0COmkN75KsHWs0gpGot2yvMCs9GzkmXtPa+2j/J/NmmrnP0GgrLz56aFXsY
         MPF7NZ8Zm0zPhg8dyun7b6SiUHSobYhaAhDVv4tKgTxmbeHxH+UDUf6GThVKd8hhhFVe
         dmFP7oLvvPkGCwy5XaNl8zO12hPtsqLFvKFfUBeo09n9O7v4UkBLEPYkWF7U7SqPM+In
         B/sg==
X-Gm-Message-State: ANoB5plsVM2ob4ZEWCgtfvGlQJwTJX58wSitK2IRif9CfQuUSK4Y5vI3
        EVxYeHs+DIS42mRXUysPv5QS6w==
X-Google-Smtp-Source: AA0mqf7a3MrPOEDL7JtfijInP1cqek0iblnAVI9LTLF6n7TR493OHBQ+RRwDGI9S4UxfcHKy3Qm/pg==
X-Received: by 2002:a17:906:3e13:b0:78d:502c:aeb5 with SMTP id k19-20020a1709063e1300b0078d502caeb5mr37246465eji.88.1669826247441;
        Wed, 30 Nov 2022 08:37:27 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id a17-20020aa7d751000000b00456c6b4b777sm785671eds.69.2022.11.30.08.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 08:37:26 -0800 (PST)
Date:   Wed, 30 Nov 2022 17:37:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y4eGxb2i7uwdkh1T@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129213724.10119-3-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 10:37:22PM CET, vfedorenko@novek.ru wrote:
>From: Vadim Fedorenko <vadfed@fb.com>

[...]

>+
>+static const struct nla_policy dpll_cmd_device_get_policy[] = {
>+	[DPLLA_ID]		= { .type = NLA_U32 },
>+	[DPLLA_NAME]		= { .type = NLA_STRING,
>+				    .len = DPLL_NAME_LEN },
>+	[DPLLA_DUMP_FILTER]	= { .type = NLA_U32 },
>+	[DPLLA_NETIFINDEX]	= { .type = NLA_U32 },

Only pin has a netdevice not the dpll. Also does not make sense to allow
as an input attr.


>+};
>+
>+static const struct nla_policy dpll_cmd_device_set_policy[] = {
>+	[DPLLA_ID]		= { .type = NLA_U32 },
>+	[DPLLA_NAME]		= { .type = NLA_STRING,
>+				    .len = DPLL_NAME_LEN },
>+	[DPLLA_MODE]		= { .type = NLA_U32 },
>+	[DPLLA_SOURCE_PIN_IDX]	= { .type = NLA_U32 },
>+};
>+
>+static const struct nla_policy dpll_cmd_pin_set_policy[] = {
>+	[DPLLA_ID]		= { .type = NLA_U32 },
>+	[DPLLA_PIN_IDX]		= { .type = NLA_U32 },
>+	[DPLLA_PIN_TYPE]	= { .type = NLA_U32 },
>+	[DPLLA_PIN_SIGNAL_TYPE]	= { .type = NLA_U32 },
>+	[DPLLA_PIN_CUSTOM_FREQ] = { .type = NLA_U32 },
>+	[DPLLA_PIN_STATE]	= { .type = NLA_U32 },
>+	[DPLLA_PIN_PRIO]	= { .type = NLA_U32 },
>+};
>+
>+struct dpll_param {
>+	struct netlink_callback *cb;
>+	struct sk_buff *msg;
>+	struct dpll_device *dpll;
>+	struct dpll_pin *pin;
>+	enum dpll_event_change change_type;
>+};
>+
>+struct dpll_dump_ctx {
>+	int dump_filter;
>+};
>+
>+typedef int (*cb_t)(struct dpll_param *);
>+
>+static struct genl_family dpll_gnl_family;
>+
>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *cb)
>+{
>+	return (struct dpll_dump_ctx *)cb->ctx;
>+}
>+
>+static int dpll_msg_add_id(struct sk_buff *msg, u32 id)
>+{
>+	if (nla_put_u32(msg, DPLLA_ID, id))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_name(struct sk_buff *msg, const char *name)
>+{
>+	if (nla_put_string(msg, DPLLA_NAME, name))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int __dpll_msg_add_mode(struct sk_buff *msg, enum dplla msg_type,
>+			       enum dpll_mode mode)
>+{
>+	if (nla_put_s32(msg, msg_type, mode))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_attr *attr)
>+{
>+	enum dpll_mode m = dpll_attr_mode_get(attr);
>+
>+	if (m == DPLL_MODE_UNSPEC)
>+		return 0;
>+
>+	return __dpll_msg_add_mode(msg, DPLLA_MODE, m);
>+}
>+
>+static int dpll_msg_add_modes_supported(struct sk_buff *msg,
>+					const struct dpll_attr *attr)
>+{
>+	enum dpll_mode i;
>+	int  ret = 0;
>+
>+	for (i = DPLL_MODE_UNSPEC + 1; i <= DPLL_MODE_MAX; i++) {
>+		if (dpll_attr_mode_supported(attr, i)) {
>+			ret = __dpll_msg_add_mode(msg, DPLLA_MODE_SUPPORTED, i);
>+			if (ret)
>+				return -EMSGSIZE;
>+		}
>+	}
>+
>+	return ret;
>+}
>+
>+static int dpll_msg_add_source_pin(struct sk_buff *msg, struct dpll_attr *attr)
>+{
>+	u32 source_idx;
>+
>+	if (dpll_attr_source_idx_get(attr, &source_idx))
>+		return 0;
>+	if (nla_put_u32(msg, DPLLA_SOURCE_PIN_IDX, source_idx))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_netifindex(struct sk_buff *msg, struct dpll_attr *attr)
>+{
>+	unsigned int netifindex; // TODO: Should be u32?
>+
>+	if (dpll_attr_netifindex_get(attr, &netifindex))
>+		return 0;
>+	if (nla_put_u32(msg, DPLLA_NETIFINDEX, netifindex))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_attr *attr)
>+{
>+	enum dpll_lock_status s = dpll_attr_lock_status_get(attr);
>+
>+	if (s == DPLL_LOCK_STATUS_UNSPEC)
>+		return 0;
>+	if (nla_put_s32(msg, DPLLA_LOCK_STATUS, s))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_temp(struct sk_buff *msg, struct dpll_attr *attr)
>+{
>+	s32 temp;
>+
>+	if (dpll_attr_temp_get(attr, &temp))
>+		return 0;
>+	if (nla_put_u32(msg, DPLLA_TEMP, temp))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_idx(struct sk_buff *msg, u32 pin_idx)
>+{
>+	if (nla_put_u32(msg, DPLLA_PIN_IDX, pin_idx))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_description(struct sk_buff *msg,
>+					const char *description)
>+{
>+	if (nla_put_string(msg, DPLLA_PIN_DESCRIPTION, description))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_parent_idx(struct sk_buff *msg, u32 parent_idx)
>+{
>+	if (nla_put_u32(msg, DPLLA_PIN_PARENT_IDX, parent_idx))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int __dpll_msg_add_pin_type(struct sk_buff *msg, enum dplla attr,
>+				   enum dpll_pin_type type)
>+{
>+	if (nla_put_s32(msg, attr, type))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_type(struct sk_buff *msg, const struct dpll_pin_attr *attr)
>+{
>+	enum dpll_pin_type t = dpll_pin_attr_type_get(attr);
>+
>+	if (t == DPLL_PIN_TYPE_UNSPEC)
>+		return 0;
>+
>+	return __dpll_msg_add_pin_type(msg, DPLLA_PIN_TYPE, t);
>+}
>+
>+static int dpll_msg_add_pin_types_supported(struct sk_buff *msg,
>+					    const struct dpll_pin_attr *attr)
>+{
>+	enum dpll_pin_type i;
>+	int ret;
>+
>+	for (i = DPLL_PIN_TYPE_UNSPEC + 1; i <= DPLL_PIN_TYPE_MAX; i++) {
>+		if (dpll_pin_attr_type_supported(attr, i)) {
>+			ret = __dpll_msg_add_pin_type(msg,
>+						      DPLLA_PIN_TYPE_SUPPORTED,
>+						      i);
>+			if (ret)
>+				return ret;
>+		}
>+	}
>+
>+	return 0;
>+}
>+
>+static int __dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>+					  enum dplla attr,
>+					  enum dpll_pin_signal_type type)
>+{
>+	if (nla_put_s32(msg, attr, type))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>+					const struct dpll_pin_attr *attr)
>+{
>+	enum dpll_pin_signal_type t = dpll_pin_attr_signal_type_get(attr);
>+
>+	if (t == DPLL_PIN_SIGNAL_TYPE_UNSPEC)
>+		return 0;
>+
>+	return __dpll_msg_add_pin_signal_type(msg, DPLLA_PIN_SIGNAL_TYPE, t);
>+}
>+
>+static int
>+dpll_msg_add_pin_signal_types_supported(struct sk_buff *msg,
>+					const struct dpll_pin_attr *attr)
>+{
>+	const enum dplla da = DPLLA_PIN_SIGNAL_TYPE_SUPPORTED;
>+	enum dpll_pin_signal_type i;
>+	int ret;
>+
>+	for (i = DPLL_PIN_SIGNAL_TYPE_UNSPEC + 1;
>+	     i <= DPLL_PIN_SIGNAL_TYPE_MAX; i++) {
>+		if (dpll_pin_attr_signal_type_supported(attr, i)) {
>+			ret = __dpll_msg_add_pin_signal_type(msg, da, i);
>+			if (ret)
>+				return ret;
>+		}
>+	}
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_custom_freq(struct sk_buff *msg,
>+					const struct dpll_pin_attr *attr)
>+{
>+	u32 freq;
>+
>+	if (dpll_pin_attr_custom_freq_get(attr, &freq))
>+		return 0;
>+	if (nla_put_u32(msg, DPLLA_PIN_CUSTOM_FREQ, freq))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_states(struct sk_buff *msg,
>+				   const struct dpll_pin_attr *attr)
>+{
>+	enum dpll_pin_state i;
>+
>+	for (i = DPLL_PIN_STATE_UNSPEC + 1; i <= DPLL_PIN_STATE_MAX; i++)
>+		if (dpll_pin_attr_state_enabled(attr, i))
>+			if (nla_put_s32(msg, DPLLA_PIN_STATE, i))
>+				return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int dpll_msg_add_pin_states_supported(struct sk_buff *msg,
>+					     const struct dpll_pin_attr *attr)
>+{
>+	enum dpll_pin_state i;
>+
>+	for (i = DPLL_PIN_STATE_UNSPEC + 1; i <= DPLL_PIN_STATE_MAX; i++)
>+		if (dpll_pin_attr_state_supported(attr, i))
>+			if (nla_put_s32(msg, DPLLA_PIN_STATE_SUPPORTED, i))
>+				return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin_attr *attr)
>+{
>+	u32 prio;
>+
>+	if (dpll_pin_attr_prio_get(attr, &prio))
>+		return 0;
>+	if (nla_put_u32(msg, DPLLA_PIN_PRIO, prio))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct dpll_pin_attr *attr)
>+{
>+	unsigned int netifindex; // TODO: Should be u32?
>+
>+	if (dpll_pin_attr_netifindex_get(attr, &netifindex))
>+		return 0;
>+	if (nla_put_u32(msg, DPLLA_PIN_NETIFINDEX, netifindex))

I was thinking about this. It is problematic. DPLL has no notion of
network namespaces. So if the driver passes ifindex, dpll/user has no
clue in which network namespace it is (ifindexes ovelay in multiple
namespaces).

There is no easy/nice solution. For now, I would go without this and
only have linkage the opposite direction, from netdev to dpll.


>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_msg_add_event_change_type(struct sk_buff *msg,
>+			       enum dpll_event_change event)
>+{
>+	if (nla_put_s32(msg, DPLLA_CHANGE_TYPE, event))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+__dpll_cmd_device_dump_one(struct sk_buff *msg, struct dpll_device *dpll)
>+{
>+	int ret = dpll_msg_add_id(msg, dpll_id(dpll));
>+
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_name(msg, dpll_dev_name(dpll));
>+
>+	return ret;
>+}
>+
>+static int
>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_device *dpll,
>+			struct dpll_pin *pin)
>+{
>+	struct dpll_pin_attr *attr = dpll_pin_attr_alloc();
>+	struct dpll_pin *parent = NULL;
>+	int ret;
>+
>+	if (!attr)
>+		return -ENOMEM;
>+	ret = dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_description(msg, dpll_pin_get_description(pin));
>+	if (ret)
>+		goto out;
>+	parent = dpll_pin_get_parent(pin);
>+	if (parent) {
>+		ret = dpll_msg_add_pin_parent_idx(msg, dpll_pin_idx(dpll,
>+								    parent));
>+		if (ret)
>+			goto out;
>+	}
>+	ret = dpll_pin_get_attr(dpll, pin, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_type(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_types_supported(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_signal_type(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_signal_types_supported(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_custom_freq(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_states(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_states_supported(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_prio(msg, attr);
>+	if (ret)
>+		goto out;
>+	ret = dpll_msg_add_pin_netifindex(msg, attr);
>+	if (ret)
>+		goto out;
>+out:
>+	dpll_pin_attr_free(attr);
>+
>+	return ret;
>+}
>+
>+static int __dpll_cmd_dump_pins(struct sk_buff *msg, struct dpll_device *dpll)
>+{
>+	struct dpll_pin *pin;
>+	struct nlattr *attr;
>+	unsigned long i;
>+	int ret = 0;
>+
>+	for_each_pin_on_dpll(dpll, pin, i) {
>+		attr = nla_nest_start(msg, DPLLA_PIN);
>+		if (!attr) {
>+			ret = -EMSGSIZE;
>+			goto nest_cancel;
>+		}
>+		ret = __dpll_cmd_pin_dump_one(msg, dpll, pin);
>+		if (ret)
>+			goto nest_cancel;
>+		nla_nest_end(msg, attr);
>+	}
>+
>+	return ret;
>+
>+nest_cancel:
>+	nla_nest_cancel(msg, attr);
>+	return ret;
>+}
>+
>+static int
>+__dpll_cmd_dump_status(struct sk_buff *msg, struct dpll_device *dpll)
>+{
>+	struct dpll_attr *attr = dpll_attr_alloc();
>+	int ret = dpll_get_attr(dpll, attr);
>+
>+	if (ret)
>+		return -EAGAIN;
>+	if (dpll_msg_add_source_pin(msg, attr))
>+		return -EMSGSIZE;
>+	if (dpll_msg_add_temp(msg, attr))
>+		return -EMSGSIZE;
>+	if (dpll_msg_add_lock_status(msg, attr))
>+		return -EMSGSIZE;
>+	if (dpll_msg_add_mode(msg, attr))
>+		return -EMSGSIZE;
>+	if (dpll_msg_add_modes_supported(msg, attr))
>+		return -EMSGSIZE;
>+	if (dpll_msg_add_netifindex(msg, attr))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
>+		     int dump_filter)
>+{
>+	int ret;
>+
>+	dpll_lock(dpll);
>+	ret = __dpll_cmd_device_dump_one(msg, dpll);
>+	if (ret)
>+		goto out_unlock;
>+
>+	if (dump_filter & DPLL_DUMP_FILTER_STATUS) {
>+		ret = __dpll_cmd_dump_status(msg, dpll);
>+		if (ret)
>+			goto out_unlock;
>+	}
>+	if (dump_filter & DPLL_DUMP_FILTER_PINS)
>+		ret = __dpll_cmd_dump_pins(msg, dpll);
>+	dpll_unlock(dpll);
>+
>+	return ret;
>+out_unlock:
>+	dpll_unlock(dpll);
>+	return ret;
>+}
>+
>+static enum dpll_pin_type dpll_msg_read_pin_type(struct nlattr *a)
>+{
>+	return nla_get_s32(a);
>+}
>+
>+static enum dpll_pin_signal_type dpll_msg_read_pin_sig_type(struct nlattr *a)
>+{
>+	return nla_get_s32(a);
>+}
>+
>+static u32 dpll_msg_read_pin_custom_freq(struct nlattr *a)
>+{
>+	return nla_get_u32(a);
>+}
>+
>+static enum dpll_pin_state dpll_msg_read_pin_state(struct nlattr *a)
>+{
>+	return nla_get_s32(a);
>+}
>+
>+static u32 dpll_msg_read_pin_prio(struct nlattr *a)
>+{
>+	return nla_get_u32(a);
>+}
>+
>+static u32 dpll_msg_read_dump_filter(struct nlattr *a)
>+{
>+	return nla_get_u32(a);
>+}
>+
>+static int
>+dpll_pin_attr_from_nlattr(struct dpll_pin_attr *pa, struct genl_info *info)
>+{
>+	enum dpll_pin_signal_type st;
>+	enum dpll_pin_state state;
>+	enum dpll_pin_type t;
>+	struct nlattr *a;
>+	int rem, ret = 0;
>+	u32 prio, freq;
>+
>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(a)) {
>+		case DPLLA_PIN_TYPE:
>+			t = dpll_msg_read_pin_type(a);
>+			ret = dpll_pin_attr_type_set(pa, t);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLLA_PIN_SIGNAL_TYPE:
>+			st = dpll_msg_read_pin_sig_type(a);
>+			ret = dpll_pin_attr_signal_type_set(pa, st);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLLA_PIN_CUSTOM_FREQ:
>+			freq = dpll_msg_read_pin_custom_freq(a);
>+			ret = dpll_pin_attr_custom_freq_set(pa, freq);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLLA_PIN_STATE:
>+			state = dpll_msg_read_pin_state(a);
>+			ret = dpll_pin_attr_state_set(pa, state);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLLA_PIN_PRIO:
>+			prio = dpll_msg_read_pin_prio(a);
>+			ret = dpll_pin_attr_prio_set(pa, prio);
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
>+static int dpll_cmd_pin_set(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_pin_attr *old = NULL, *new = NULL, *delta = NULL;
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	struct dpll_pin *pin;
>+	int ret, pin_id;
>+
>+	if (!attrs[DPLLA_PIN_IDX])
>+		return -EINVAL;
>+	pin_id = nla_get_u32(attrs[DPLLA_PIN_IDX]);
>+	old = dpll_pin_attr_alloc();
>+	new = dpll_pin_attr_alloc();
>+	delta = dpll_pin_attr_alloc();
>+	if (!old || !new || !delta) {
>+		ret = -ENOMEM;
>+		goto mem_free;
>+	}
>+	dpll_lock(dpll);
>+	pin = dpll_pin_get_by_idx(dpll, pin_id);
>+	if (!pin) {
>+		ret = -ENODEV;
>+		goto mem_free_unlock;
>+	}
>+	ret = dpll_pin_get_attr(dpll, pin, old);
>+	if (ret)
>+		goto mem_free_unlock;
>+	ret = dpll_pin_attr_from_nlattr(new, info);
>+	if (ret)
>+		goto mem_free_unlock;
>+	ret = dpll_pin_attr_delta(delta, new, old);
>+	dpll_unlock(dpll);
>+	if (!ret)
>+		ret = dpll_pin_set_attr(dpll, pin, delta);
>+	else
>+		ret = -EINVAL;
>+
>+	dpll_pin_attr_free(delta);
>+	dpll_pin_attr_free(new);
>+	dpll_pin_attr_free(old);
>+
>+	return ret;
>+
>+mem_free_unlock:
>+	dpll_unlock(dpll);
>+mem_free:
>+	dpll_pin_attr_free(delta);
>+	dpll_pin_attr_free(new);
>+	dpll_pin_attr_free(old);
>+	return ret;
>+}
>+
>+enum dpll_mode dpll_msg_read_mode(struct nlattr *a)
>+{
>+	return nla_get_s32(a);
>+}
>+
>+u32 dpll_msg_read_source_pin_id(struct nlattr *a)
>+{
>+	return nla_get_u32(a);
>+}
>+
>+static int
>+dpll_attr_from_nlattr(struct dpll_attr *dpll, struct genl_info *info)
>+{
>+	enum dpll_mode m;
>+	struct nlattr *a;
>+	int rem, ret = 0;
>+	u32 source_pin;
>+
>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(a)) {
>+		case DPLLA_MODE:
>+			m = dpll_msg_read_mode(a);
>+
>+			ret = dpll_attr_mode_set(dpll, m);
>+			if (ret)
>+				return ret;
>+			break;
>+		case DPLLA_SOURCE_PIN_IDX:
>+			source_pin = dpll_msg_read_source_pin_id(a);
>+
>+			ret = dpll_attr_source_idx_set(dpll, source_pin);
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
>+static int dpll_cmd_device_set(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_attr *old = NULL, *new = NULL, *delta = NULL;
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	int ret;
>+
>+	old = dpll_attr_alloc();
>+	new = dpll_attr_alloc();
>+	delta = dpll_attr_alloc();
>+	if (!old || !new || !delta) {
>+		ret = -ENOMEM;
>+		goto mem_free;
>+	}
>+	dpll_lock(dpll);
>+	ret = dpll_get_attr(dpll, old);
>+	dpll_unlock(dpll);
>+	if (!ret) {
>+		dpll_attr_from_nlattr(new, info);
>+		ret = dpll_attr_delta(delta, new, old);
>+		if (!ret)
>+			ret = dpll_set_attr(dpll, delta);
>+	}
>+
>+mem_free:
>+	dpll_attr_free(old);
>+	dpll_attr_free(new);
>+	dpll_attr_free(delta);
>+
>+	return ret;
>+}
>+
>+static int
>+dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
>+{
>+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>+	struct dpll_device *dpll;
>+	struct nlattr *hdr;
>+	unsigned long i;
>+	int ret;
>+
>+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
>+			  &dpll_gnl_family, 0, DPLL_CMD_DEVICE_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	for_each_dpll(dpll, i) {
>+		ret = dpll_device_dump_one(dpll, skb, ctx->dump_filter);
>+		if (ret)
>+			break;
>+	}
>+
>+	if (ret)
>+		genlmsg_cancel(skb, hdr);
>+	else
>+		genlmsg_end(skb, hdr);
>+
>+	return ret;
>+}
>+
>+static int dpll_cmd_device_get(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct dpll_device *dpll = info->user_ptr[0];
>+	struct nlattr **attrs = info->attrs;
>+	struct sk_buff *msg;
>+	int dump_filter = 0;
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	if (attrs[DPLLA_DUMP_FILTER])
>+		dump_filter =
>+			dpll_msg_read_dump_filter(attrs[DPLLA_DUMP_FILTER]);
>+
>+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	hdr = genlmsg_put_reply(msg, info, &dpll_gnl_family, 0,
>+				DPLL_CMD_DEVICE_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	ret = dpll_device_dump_one(dpll, msg, dump_filter);
>+	if (ret)
>+		goto out_free_msg;
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
>+
>+out_free_msg:
>+	nlmsg_free(msg);
>+	return ret;
>+
>+}
>+
>+static int dpll_cmd_device_get_start(struct netlink_callback *cb)
>+{
>+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>+	struct nlattr *attr = info->attrs[DPLLA_DUMP_FILTER];
>+
>+	if (attr)
>+		ctx->dump_filter = dpll_msg_read_dump_filter(attr);
>+	else
>+		ctx->dump_filter = 0;
>+
>+	return 0;
>+}
>+
>+static int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+			 struct genl_info *info)
>+{
>+	struct dpll_device *dpll_id = NULL, *dpll_name = NULL;
>+
>+	if (!info->attrs[DPLLA_ID] &&
>+	    !info->attrs[DPLLA_NAME])
>+		return -EINVAL;
>+
>+	if (info->attrs[DPLLA_ID]) {
>+		u32 id = nla_get_u32(info->attrs[DPLLA_ID]);
>+
>+		dpll_id = dpll_device_get_by_id(id);
>+		if (!dpll_id)
>+			return -ENODEV;
>+		info->user_ptr[0] = dpll_id;
>+	}
>+	if (info->attrs[DPLLA_NAME]) {
>+		const char *name = nla_data(info->attrs[DPLLA_NAME]);
>+
>+		dpll_name = dpll_device_get_by_name(name);
>+		if (!dpll_name)
>+			return -ENODEV;
>+
>+		if (dpll_id && dpll_name != dpll_id)
>+			return -EINVAL;
>+		info->user_ptr[0] = dpll_name;
>+	}
>+
>+	return 0;
>+}
>+
>+static const struct genl_ops dpll_ops[] = {
>+	{
>+		.cmd	= DPLL_CMD_DEVICE_GET,
>+		.flags  = GENL_UNS_ADMIN_PERM,
>+		.start	= dpll_cmd_device_get_start,
>+		.dumpit	= dpll_cmd_device_dump,
>+		.doit	= dpll_cmd_device_get,
>+		.policy	= dpll_cmd_device_get_policy,
>+		.maxattr = ARRAY_SIZE(dpll_cmd_device_get_policy) - 1,
>+	},
>+	{
>+		.cmd	= DPLL_CMD_DEVICE_SET,
>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= dpll_cmd_device_set,
>+		.policy	= dpll_cmd_device_set_policy,
>+		.maxattr = ARRAY_SIZE(dpll_cmd_device_set_policy) - 1,
>+	},
>+	{
>+		.cmd	= DPLL_CMD_PIN_SET,
>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= dpll_cmd_pin_set,
>+		.policy	= dpll_cmd_pin_set_policy,
>+		.maxattr = ARRAY_SIZE(dpll_cmd_pin_set_policy) - 1,
>+	},
>+};
>+
>+static struct genl_family dpll_family __ro_after_init = {
>+	.hdrsize	= 0,
>+	.name		= DPLL_FAMILY_NAME,
>+	.version	= DPLL_VERSION,
>+	.ops		= dpll_ops,
>+	.n_ops		= ARRAY_SIZE(dpll_ops),
>+	.mcgrps		= dpll_mcgrps,
>+	.n_mcgrps	= ARRAY_SIZE(dpll_mcgrps),
>+	.pre_doit	= dpll_pre_doit,
>+	.parallel_ops   = true,
>+};
>+
>+static int dpll_event_device_id(struct dpll_param *p)
>+{
>+	int ret = dpll_msg_add_id(p->msg, dpll_id(p->dpll));
>+
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_name(p->msg, dpll_dev_name(p->dpll));
>+
>+	return ret;
>+}
>+
>+static int dpll_event_device_change(struct dpll_param *p)
>+{
>+	int ret = dpll_msg_add_id(p->msg, dpll_id(p->dpll));
>+
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_event_change_type(p->msg, p->change_type);
>+	if (ret)
>+		return ret;
>+	switch (p->change_type)	{
>+	case DPLL_CHANGE_PIN_ADD:
>+	case DPLL_CHANGE_PIN_DEL:
>+	case DPLL_CHANGE_PIN_TYPE:
>+	case DPLL_CHANGE_PIN_SIGNAL_TYPE:
>+	case DPLL_CHANGE_PIN_STATE:
>+	case DPLL_CHANGE_PIN_PRIO:
>+		ret = dpll_msg_add_pin_idx(p->msg, dpll_pin_idx(p->dpll, p->pin));
>+		break;
>+	default:
>+		break;
>+	}
>+
>+	return ret;
>+}
>+
>+static const cb_t event_cb[] = {
>+	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_id,
>+	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_id,
>+	[DPLL_EVENT_DEVICE_CHANGE]	= dpll_event_device_change,
>+};
>+
>+/*
>+ * Generic netlink DPLL event encoding
>+ */
>+static int dpll_send_event(enum dpll_event event, struct dpll_param *p)
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
>+	hdr = genlmsg_put(msg, 0, 0, &dpll_family, 0, event);
>+	if (!hdr)
>+		goto out_free_msg;
>+
>+	ret = event_cb[event](p);
>+	if (ret)
>+		goto out_cancel_msg;
>+
>+	genlmsg_end(msg, hdr);
>+
>+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
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
>+	struct dpll_param p = { .dpll = dpll };
>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
>+}
>+
>+int dpll_notify_device_delete(struct dpll_device *dpll)
>+{
>+	struct dpll_param p = { .dpll = dpll };
>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>+}
>+
>+int dpll_notify_device_change(struct dpll_device *dpll,
>+			      enum dpll_event_change event,
>+			      struct dpll_pin *pin)
>+{
>+	struct dpll_param p = { .dpll = dpll,
>+				.change_type = event,
>+				.pin = pin };

This is odd. Why don't you just pass the object you want to expose the
event for. You should have coupling between the object and send event
function:
dpll_device_notify(dpll, event);
dpll_pin_notify(pin, event);
Then you can avoid this param struct.


>+
>+	return dpll_send_event(DPLL_EVENT_DEVICE_CHANGE, &p);
>+}

[...]


>+/* dplla - Attributes of dpll generic netlink family
>+ *
>+ * @DPLLA_UNSPEC - invalid attribute
>+ * @DPLLA_ID - ID of a dpll device (unsigned int)
>+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH size)
>+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
>+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum dpll_mode)
>+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
>+ *	(unsigned int)
>+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
>+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
>+ * @DPLLA_DUMP_FILTER - filter bitmask (int, sum of DPLL_DUMP_FILTER_* defines)
>+ * @DPLLA_NETIFINDEX - related network interface index
>+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
>+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
>+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by driver
>+ *	(char array of PIN_DESC_LEN size)
>+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
>+ * @DPLLA_PIN_TYPE_SUPPORTED - pin types supported (enum dpll_pin_type)
>+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
>+ *	(enum dpll_pin_signal_type)
>+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
>+ *	(enum dpll_pin_signal_type)
>+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
>+ *	(unsigned int)
>+ * @DPLLA_PIN_STATE - state of pin's capabilities (enum dpll_pin_state)
>+ * @DPLLA_PIN_STATE_SUPPORTED - available pin's capabilities
>+ *	(enum dpll_pin_state)
>+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
>+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
>+ * @DPLLA_CHANGE_TYPE - type of device change event
>+ *	(enum dpll_change_type)
>+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
>+ **/
>+enum dplla {
>+	DPLLA_UNSPEC,
>+	DPLLA_ID,
>+	DPLLA_NAME,
>+	DPLLA_MODE,
>+	DPLLA_MODE_SUPPORTED,
>+	DPLLA_SOURCE_PIN_IDX,
>+	DPLLA_LOCK_STATUS,
>+	DPLLA_TEMP,

Did you consider need for DPLLA_CLOCK_QUALITY? The our device exposes
quality of the clock. SyncE daemon needs to be aware of the clock
quality

Also, how about the clock identification. I recall this being discussed
in the past as well. This is also needed for SyncE daemon.
DPLLA_CLOCK_ID - SyncE has it at 64bit number.


>+	DPLLA_DUMP_FILTER,
>+	DPLLA_NETIFINDEX,

Duplicate, you have it under pin.


>+	DPLLA_PIN,
>+	DPLLA_PIN_IDX,
>+	DPLLA_PIN_DESCRIPTION,
>+	DPLLA_PIN_TYPE,
>+	DPLLA_PIN_TYPE_SUPPORTED,
>+	DPLLA_PIN_SIGNAL_TYPE,
>+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
>+	DPLLA_PIN_CUSTOM_FREQ,
>+	DPLLA_PIN_STATE,
>+	DPLLA_PIN_STATE_SUPPORTED,
>+	DPLLA_PIN_PRIO,
>+	DPLLA_PIN_PARENT_IDX,
>+	DPLLA_CHANGE_TYPE,
>+	DPLLA_PIN_NETIFINDEX,
>+	__DPLLA_MAX,
>+};
>+
>+#define DPLLA_MAX (__DPLLA_MAX - 1)


[...]

