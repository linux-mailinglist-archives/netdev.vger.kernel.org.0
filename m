Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC86E6C32FB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjCUNfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjCUNfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:35:01 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE6B4391A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:34:58 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso9484102wmo.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679405697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GrENT+Bmj91DUGrS8eAgiWjucLYxnLyFAeYYdHsziOc=;
        b=BdM/UtBOYA+F5CIZlXubGB/bS37BhYp0OyWo8Fa0tepR3GFBm988Qn22OBX2ihoz+G
         x2ZUJKC4Xz7b1hKmzW1uMuqaD2OuszbJIsBE/Oiz+1vsJFt9a8nKXNU8kj/D/dFuwwA/
         lVV69WzmLLw7F+tcT1CESaXrJ7CdnzEt8zjxgHy/KRVduuMIL3Mgd2K+fS3aLmdCayRj
         eQOtiYsMLmP24jgS/nKaA/pgO+e6hukVCODkKAPNvqsSIhKPKPyXx/nNplLWu5sRXW/+
         5UGmHz/1/aLZwmTNRH9yCEsX8snFQNN7wZRe3mpQAdGi37QVYiopC4++G50rT29Nolff
         3I9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrENT+Bmj91DUGrS8eAgiWjucLYxnLyFAeYYdHsziOc=;
        b=Mk8K61pJPDU8yOYPqdiO5Rjl43KuIT8hnp1QnpJBw+ujNdkUYaFox+3ySsIsrxOkLq
         OYoolq0Bm2MJ1wJE78Mz+3Axm18geBJnLWomTOuaesP22H4UhMuso4sfPdw47c+UDbwF
         gwLxpCnJxPMnrmsMPB5jndSEP32AJYZyo/GxkXx6+vn67vfUrueJngvJo8arojx8PZhJ
         Mn+vJORwZF6mcnR/bmdKmEbghmNuNQyVbKqR7ARW/QN2+n7Vl7MINLfBG63C2HiOi/ED
         hsu1BErnQpMUoomawAqyubQ1eWxK/nvSW8x6gUN9HU2euLwf7ULXHa4Ip/IkeElqNzxN
         D7Gg==
X-Gm-Message-State: AO0yUKVAOzLRCInjRLmsO4HtQeXaC+12ELk49PkjjGCdJBlZbtpzdHqg
        q/0vFXFvAKF/Siz0ZJgYFpiOlQ==
X-Google-Smtp-Source: AK7set/otdogiOsl2XYCUC7V1wbfsXSVyEvekWorAgLY37lUAh2OB176uEHSDWtn3rp/IPkAuyqJdQ==
X-Received: by 2002:a05:600c:295:b0:3ed:492f:7f37 with SMTP id 21-20020a05600c029500b003ed492f7f37mr2313076wmk.10.1679405697267;
        Tue, 21 Mar 2023 06:34:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g14-20020a05600c310e00b003eddf30bab6sm7625547wmo.27.2023.03.21.06.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 06:34:56 -0700 (PDT)
Date:   Tue, 21 Mar 2023 14:34:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBmyfzr/VLsLVp7Y@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]

>+static int
>+dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
>+			 struct dpll_pin *pin, struct dpll_pin *parent,
>+			 enum dplla attr)
>+{
>+	int ret = dpll_msg_add_dev_handle(msg, dpll);
>+	struct dpll_pin_ref *ref = NULL;
>+	enum dpll_pin_state state;
>+
>+	if (ret)
>+		return ret;
>+	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>+		return -EMSGSIZE;
>+
>+	switch (attr) {
>+	case DPLL_A_MODE:
>+		ret = dpll_msg_add_mode(msg, dpll, NULL);
>+		break;
>+	case DPLL_A_SOURCE_PIN_IDX:
>+		ret = dpll_msg_add_source_pin_idx(msg, dpll, NULL);
>+		break;
>+	case DPLL_A_LOCK_STATUS:
>+		ret = dpll_msg_add_lock_status(msg, dpll, NULL);

On top of what I wrote about the notifications, I found another two
issues:
1) You don't take any lock calling this from drivers. You need to hold
   the xarray locks you have now.

   I have to repear, I think that we definitelly need to convert the
   overall locking scheme to have this per-instance, in a similar way
   we did that for devlink. I noted this in another email, but wanted
   to say that again.

2) You have possible race condition:
   1) -> driver gets a state change event
   2) -> driver calls into this function
   3) -> this code does call the driver op to get the state, driver
         queries the state again

   Between 1) and 3) state can easily change, multiple times. That might
   lead to oddities observed by the user (like getting a notification
   of change with the original values)

   I see only 1 solutions to this:
   Pass the value of changed item from the driver here and just pass
   it on over netlink without doing calling into driver again.


>+		break;
>+	case DPLL_A_TEMP:
>+		ret = dpll_msg_add_temp(msg, dpll, NULL);
>+		break;
>+	case DPLL_A_PIN_FREQUENCY:
>+		ret = dpll_msg_add_pin_freq(msg, pin, NULL, false);
>+		break;
>+	case DPLL_A_PIN_PRIO:
>+		ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>+		if (!ref)
>+			return -EFAULT;
>+		ret = dpll_msg_add_pin_prio(msg, pin, ref, NULL);
>+		break;
>+	case DPLL_A_PIN_STATE:
>+		if (parent) {
>+			ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
>+			if (!ref)
>+				return -EFAULT;
>+			if (!ref->ops || !ref->ops->state_on_pin_get)
>+				return -EOPNOTSUPP;
>+			ret = ref->ops->state_on_pin_get(pin, parent, &state,
>+							 NULL);
>+			if (ret)
>+				return ret;
>+			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>+					parent->dev_driver_id))
>+				return -EMSGSIZE;
>+		} else {
>+			ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
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

Please change the function names to "register/unregister" to be
consistent with the rest of the code.


>+{
>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_DELETE, dpll);
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

The driver should be aware of netlink attributes. Should be
abstracted out.

just have per-item notification like:
dpll_pin_state_notify()
dpll_pin_prio_notify()
...

Then you can easily pass changed value that would allow solution to
the issue 2) I described above.



>+{
>+	return dpll_send_event_change(dpll, pin, NULL, attr);
>+}
>+

[...]
