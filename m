Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC266C6667
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCWLSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjCWLSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:18:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F43A40D5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:18:15 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r11so84866732edd.5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679570294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPA325lCxqgm887i5ttVzt/fB6jUQ63KGiDpovS0f/o=;
        b=JPNsfetXACjkonXIzy8K5bnwsD6xXMOVVb9xmHIjpqJqlQOG859+ixzCVM5y+h0R3f
         lO+UYY0huO/oIB7due8D3KYiiddll1Y8/+EIHcVt9GNlQM0+C5wELtagHUNVEvCzzlds
         Glqleyeb9cMELTcMDknRGwCpF25yy9F06EqFjx3NpV6lpXnN0BlBf58haerkqxeHl1OA
         pan4/qOQ39sktQq0Zxr79SiVDpR4rdQAf4WzCTHRMRhG6hiFfN4mH+g100Xu5BtkaGqm
         wnyf+/7QoR9RxbRDwmchNhoYI+gx3zdsXzNkS4B5uEv94q7/MtBPgBSuN2ZadtSqlHBa
         Yd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679570294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPA325lCxqgm887i5ttVzt/fB6jUQ63KGiDpovS0f/o=;
        b=5bl6JP3T2ROz5mOEAe7dahhGzjui7K6EH4d6Imd+ROeFyHaZpVjjirNgFxsIc8Rz9z
         xyjvjaIzWMh0wE6lskDehg8cztBRpMbJ/mKLhfgyEyv9Ruk3sXNLQ2rGODwdfLjfkDAs
         lvYNfcUv02Ia2E5b3UFwrgs2r931c173+3q2g9q3WHAJVWYUc5F1mk0PPEfcwQxrnxs4
         cX3q552pdBL6r+fZYxCcB5RSG7KKEcF32JYOajQBSKze6eQB7KSjrt2HmZ3sjYobcmjU
         PN8zej3D+UEAUT9UgcSuDnu1CSkmfr+1YgQwWq5b2bZypKZCUrmZ3ene2EHP+nBrj7cY
         KCVA==
X-Gm-Message-State: AO0yUKVClQ6RGvPa/lMadZ7xo3fYwVeGmyVGN+3sLoWMTOMZG1N/QFNE
        12hbe6tFSGFc0/YLuclwNwUweA==
X-Google-Smtp-Source: AK7set80UQLrMbHiMmL7+4uApt0hu/3zP6lD6DrfmnWeWFdMGkjoIwUMDvWcwscRvkZVpYyxfS+R5A==
X-Received: by 2002:a17:907:105b:b0:932:cec7:6801 with SMTP id oy27-20020a170907105b00b00932cec76801mr10571633ejb.54.1679570293923;
        Thu, 23 Mar 2023 04:18:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id md12-20020a170906ae8c00b008e68d2c11d8sm8555287ejb.218.2023.03.23.04.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:18:13 -0700 (PDT)
Date:   Thu, 23 Mar 2023 12:18:12 +0100
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
Message-ID: <ZBw1dID2U9D7wMyy@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>+/**
>+ * dpll_xa_ref_pin_del - remove reference of a pin from xarray
>+ * @xa_pins: dpll_pin_ref xarray holding pins
>+ * @pin: pointer to a pin
>+ *
>+ * Decrement refcount of existing pin reference on given xarray.
>+ * If all references are dropped, delete the reference and free its memory.
>+ *

Hmm, came to think about this, why do you do func docs even for static
function? It is customary to do that for exported function. For static
ones, not really needed.


>+ * Return:
>+ * * 0 on success
>+ * * -EINVAL if reference to a pin was not found
>+ */
>+static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin)

Have this to return void, you don't check the return value anywhere.


>+{
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	xa_for_each(xa_pins, i, ref) {
>+		if (ref->pin == pin) {
>+			if (refcount_dec_and_test(&ref->refcount)) {
>+				xa_erase(xa_pins, i);
>+				kfree(ref);
>+			}
>+			return 0;
>+		}
>+	}
>+
>+	return -EINVAL;
>+}

[...]


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

Every caller of this function does fill the first arg by:
&pin->dpll_refs
Could you please change it to "struct dpll_pin *pin" and get the xarray
pointer in this function?

The same applies to other functions passing xarray pointer, like:
dpll_xa_ref_dpll_add
dpll_xa_ref_dpll_del
dpll_xa_ref_pin_find

The point is, always better and easier to read to pass
"struct dpll_device *" and "struct dpll_pin *" as function args.
Passing "struct xarray *" makes the reader uncertain about what
is going on.



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
>+

[...]


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

You return more than that. Do you really need to list the error
possiblities in the func docs?


>+ */
>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>+			 struct dpll_device_ops *ops, void *priv,
>+			 struct device *owner)

[...]


>+static int
>+__dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>+		    struct dpll_pin_ops *ops, void *priv,
>+		    const char *rclk_device_name)
>+{
>+	int ret;
>+
>+	if (rclk_device_name && !pin->rclk_dev_name) {
>+		pin->rclk_dev_name = kstrdup(rclk_device_name, GFP_KERNEL);
>+		if (!pin->rclk_dev_name)
>+			return -ENOMEM;
>+	}

Somewhere here, please add a check:
dpll->module == pin->module dpll->clock_id && pin->clock_id
For sanity sake.


>+	ret = dpll_xa_ref_pin_add(&dpll->pin_refs, pin, ops, priv);
>+	if (ret)
>+		goto rclk_free;
>+	ret = dpll_xa_ref_dpll_add(&pin->dpll_refs, dpll, ops, priv);
>+	if (ret)
>+		goto ref_pin_del;
>+	else
>+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_IDX);

Pointless else.


>+
>+	return ret;
>+
>+ref_pin_del:
>+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin);
>+rclk_free:
>+	kfree(pin->rclk_dev_name);
>+	return ret;
>+}

[...]


>+int
>+dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
>+			 struct dpll_pin_ops *ops, void *priv,
>+			 struct device *rclk_device)
>+{
>+	struct dpll_pin_ref *ref;
>+	unsigned long i, stop;
>+	int ret;
>+
>+	if (WARN_ON(!pin || !parent))
>+		return -EINVAL;
>+	if (WARN_ON(parent->prop.type != DPLL_PIN_TYPE_MUX))
>+		return -EPERM;
>+	mutex_lock(&dpll_pin_xa_lock);
>+	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv);
>+	if (ret)
>+		goto unlock;
>+	refcount_inc(&pin->refcount);
>+	xa_for_each(&parent->dpll_refs, i, ref) {
>+		mutex_lock(&dpll_device_xa_lock);
>+		ret = __dpll_pin_register(ref->dpll, pin, ops, priv,

Why exactly do you need to register the pin over to the dpll of a
parent? Isn't it enough to have the pin registered on a parent?
I mean, there is no direct connection between pin and dpll, the parent
is in the middle. So prio setup, and other things does not make sense to
configure on this child pin, isn't it?

Btw, what is stopping the driver from:
dpll register
pin1 register on dpll
pin2 register on pin1
pin1 unregister
?
The you would have pin2 registered to dpll incorrectly.


>+					  rclk_device ?
>+					  dev_name(rclk_device) : NULL);
>+		mutex_unlock(&dpll_device_xa_lock);
>+		if (ret) {
>+			stop = i;
>+			goto dpll_unregister;
>+		}
>+		dpll_pin_parent_notify(ref->dpll, pin, parent, DPLL_A_PIN_IDX);
>+	}
>+	mutex_unlock(&dpll_pin_xa_lock);
>+
>+	return ret;
>+
>+dpll_unregister:
>+	xa_for_each(&parent->dpll_refs, i, ref) {
>+		if (i < stop) {
>+			mutex_lock(&dpll_device_xa_lock);
>+			__dpll_pin_unregister(ref->dpll, pin);
>+			mutex_unlock(&dpll_device_xa_lock);
>+		}
>+	}
>+	refcount_dec(&pin->refcount);
>+	dpll_xa_ref_pin_del(&pin->parent_refs, parent);
>+unlock:
>+	mutex_unlock(&dpll_pin_xa_lock);
>+	return ret;
>+}

[...]


>+static int
>+dpll_pin_on_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
>+			  u32 parent_idx, enum dpll_pin_state state,
>+			  struct netlink_ext_ack *extack)
>+{
>+	struct dpll_pin_ref *ref;
>+	struct dpll_pin *parent;
>+
>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))

Hmm, why is this capabilities are any good for internal purposes? I
understand the need to expose it to the user, but internally in kernel,
if the driver implements some _set() op, it is good enough indication of
a support of a certain setter. You can check if the relevant _set()
is not null and expose the appropriate capability to the user.



>+		return -EOPNOTSUPP;
>+	parent = dpll_pin_get_by_idx(dpll, parent_idx);

I don't follow. Why do you need dpll pointer to get the parent pin?
The same handle as pin should be used, you have clock_id and driver name
(in next patchsets implementation) that should be enough.
Pin is a separate entity, attached 0:N dplls.

Please remove dpll pointer from here. Also, please remove
dpll->pins_ref, as you are using this array only for this lookup (here
and in dpll_pin_pre_doit())


>+	if (!parent)
>+		return -EINVAL;
>+	ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
>+	if (!ref)
>+		return -EINVAL;
>+	if (!ref->ops || !ref->ops->state_on_pin_set)
>+		return -EOPNOTSUPP;
>+	if (ref->ops->state_on_pin_set(pin, parent, state, extack))
>+		return -EFAULT;
>+	dpll_pin_parent_notify(dpll, pin, parent, DPLL_A_PIN_STATE);
>+
>+	return 0;
>+}
>+
>+static int
>+dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
>+		   enum dpll_pin_state state,
>+		   struct netlink_ext_ack *extack)
>+{
>+	struct dpll_pin_ref *ref;
>+
>+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
>+		return -EOPNOTSUPP;
>+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>+	if (!ref)
>+		return -EFAULT;
>+	if (!ref->ops || !ref->ops->state_on_dpll_set)
>+		return -EOPNOTSUPP;
>+	if (ref->ops->state_on_dpll_set(pin, ref->dpll, state, extack))
>+		return -EINVAL;
>+	dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_STATE);
>+
>+	return 0;
>+}

[...]


>+static int
>+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
>+{
>+	struct nlattr *attr;
>+	enum dpll_mode mode;
>+	int rem, ret = 0;
>+
>+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
>+			  genlmsg_len(info->genlhdr), rem) {
>+		switch (nla_type(attr)) {
>+		case DPLL_A_MODE:
>+			mode = nla_get_u8(attr);
>+
>+			if (!dpll->ops || !dpll->ops->mode_set)

Remove the pointless check of ops. This cannot happen (checked in
dpll_device_register())


>+				return -EOPNOTSUPP;
>+			ret = dpll->ops->mode_set(dpll, mode, info->extack);
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

[...]
