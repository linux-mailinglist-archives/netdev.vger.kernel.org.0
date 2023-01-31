Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1197682E97
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjAaOBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjAaOBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:01:11 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2A351404
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:00:35 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q10so14299908wrm.4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T2wl14Hb6rHlvCuYAJHW0jYNwEn6LfUk4MgToW+y2Bs=;
        b=j6OoteBcSeZnJHnoQ6Pdr+7djstgtd+rFt4fr4bw0Wk9xsrosgM4cDtf5EOfepzZUu
         omH5o0cuGIdd/kbgIuDOgq6tQXJm4Eu8QI+M8zOdJyUDrrpbu9EUwu7YzBOWjGng5bgs
         8dAEbh+TE16+8wHjNI9PEFtIRsZZc4z7Jm7UlgzVCoERAyVu42kvoZlwykAa37T6Blqb
         MCA1BlQ44RnrJNq9SVdQ7lFbm84euRf3ud4kW35JzPpAqF1jAJx+1ppvDyLoFcFMEAYa
         Purh178jBna7lPYrG74VLsQ6Hrcs+Sd9qksz2WneB9+cF6BMqyKfy1KAr5FfaL2X1QwV
         8YOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2wl14Hb6rHlvCuYAJHW0jYNwEn6LfUk4MgToW+y2Bs=;
        b=atghL3nBV2yNK2+lULxx6hljBlHBfGiNvlg9VFoqZgfozuTwxC57SvdQCLDOmzLyaP
         CezaE35wIR//vFanHYYcsa3bW6ZxeR76JS7wrTlCpI9Fq+8U+JbN4nixryZg/XyweUfp
         rMUDKO4F5ErAGCJ0AwBx78m0PNpVp5KOogfERL3XStLoVO7YSVNyMrmOZG7Z6uiJawo/
         ZLfvn+1Syv31Oycv0YSF4yUOAjRYwGlOncpcn/gZ8kq0OJmQGXosWhvvaLkXZkZP0d6E
         Z/pEGtPmI/xE8FtU03+hbcqt18+3DFE2v+YZi+oiLdnJSy4L7simpq3BPYOranfpjDeK
         9VWg==
X-Gm-Message-State: AFqh2krozLgnaG+Foxo5zZz77/XZTGOfBtIo9xXtt0+iVoN/M7q/a4Cs
        OOROEWdKccMY/zQ/AH0huLpCaA==
X-Google-Smtp-Source: AMrXdXt8p0thLcLxlvTYt3BQ+njWJE3FR3J48upHm32Ss4v4BVi5Lu1UiEYuPwusG4UKEQnBRUHlBA==
X-Received: by 2002:a5d:6b03:0:b0:2bd:e87a:7fb7 with SMTP id v3-20020a5d6b03000000b002bde87a7fb7mr46964199wrw.26.1675173633895;
        Tue, 31 Jan 2023 06:00:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f28-20020a5d58fc000000b002be5401ef5fsm15338278wrd.39.2023.01.31.06.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:00:32 -0800 (PST)
Date:   Tue, 31 Jan 2023 15:00:31 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Message-ID: <Y9ke/+0z3r6WOjWn@nanopsycho>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-2-vadfed@meta.com>
 <Y8l63RF8DQz3i0LY@nanopsycho>
 <DM6PR11MB46575F782A66620E1A2D04229BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB46575F782A66620E1A2D04229BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 27, 2023 at 07:12:41PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Thursday, January 19, 2023 6:16 PM
>>
>>Tue, Jan 17, 2023 at 07:00:48PM CET, vadfed@meta.com wrote:

[...]


>>>+struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
>>
>>Hmm, don't you want to put an owner module as an arg here as well? I
>>don't see how could 2 modules sanely work with the same dpll instance.
>>
>
>Sorry, I don't get it.
>How the driver that needs to find a dpll would know the owner module?

Something like:
dpll = dpll_device_get(ops, THIS_MODULE, ...)
if (IS_ERR(dpll))
	..


>The idea of this is to let another driver instance to find a dpll device
>already registered in OS.
>The driver that is searching dpll device is not the same as the one that has
>created the device, otherwise it wouldn't make any sense?

You have to distinguish driver/driver_instance. It it is not the same
driver(module), something is seriously wrong here.


>
>>
>>>+						enum dpll_type type, u8 idx)
>>>+{
>>>+	struct dpll_device *dpll, *ret = NULL;
>>>+	unsigned long index;
>>>+
>>>+	mutex_lock(&dpll_device_xa_lock);
>>>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>>>+		if (dpll->clock_id == clock_id) {
>>>+			if (dpll->type == type) {
>>>+				if (dpll->dev_driver_idx == idx) {
>>>+					ret = dpll;
>>>+					break;
>>>+				}
>>>+			}
>>>+		}
>>>+	}
>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>+
>>>+	return ret;
>>>+}
>>>+EXPORT_SYMBOL_GPL(dpll_device_get_by_clock_id);
>>>+
>>>+static void dpll_device_release(struct device *dev)
>>>+{
>>>+	struct dpll_device *dpll;
>>>+
>>>+	mutex_lock(&dpll_device_xa_lock);
>>>+	dpll = to_dpll_device(dev);
>>>+	dpll_device_unregister(dpll);
>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>+	dpll_device_free(dpll);
>>>+}
>>>+
>>>+static struct class dpll_class = {
>>>+	.name = "dpll",
>>>+	.dev_release = dpll_device_release,
>>
>>Why do you want to do this? Why the driver cannot do
>>dpll_device_unregister/free() manually. I think it makes things easier
>>to read then to rely on dev garbage collector.
>>
>
>This was in the first version submitted by Vadim.
>I think we can remove it, unless someone has different view?

Cool.


>
>>
>>>+};
>>>+
>>>+struct dpll_device
>>>+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
>>>+		   const u64 clock_id, enum dpll_clock_class clock_class,
>>>+		   u8 dev_driver_idx, void *priv, struct device *parent)
>>>+{
>>>+	struct dpll_device *dpll;
>>>+	int ret;
>>>+
>>>+	dpll = kzalloc(sizeof(*dpll), GFP_KERNEL);
>>>+	if (!dpll)
>>>+		return ERR_PTR(-ENOMEM);
>>>+
>>>+	mutex_init(&dpll->lock);
>>>+	dpll->ops = ops;
>>>+	dpll->dev.class = &dpll_class;
>>>+	dpll->parent = parent;
>>>+	dpll->type = type;
>>>+	dpll->dev_driver_idx = dev_driver_idx;
>>>+	dpll->clock_id = clock_id;
>>>+	dpll->clock_class = clock_class;
>>>+
>>>+	mutex_lock(&dpll_device_xa_lock);
>>>+	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll,
>>>+		       xa_limit_16b, GFP_KERNEL);
>>>+	if (ret)
>>>+		goto error;
>>>+	dev_set_name(&dpll->dev, "dpll_%s_%d_%d", dev_name(parent), type,
>>>+		     dev_driver_idx);
>>>+	dpll->priv = priv;
>>>+	xa_init_flags(&dpll->pins, XA_FLAGS_ALLOC);
>>>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>
>>What is exactly the point of using this mark?
>>
>
>I think this can be also removed now, as there is no separated alloc/register
>for newly created dpll device.

Cool.


>
>>
>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>+	dpll_notify_device_create(dpll);
>>>+
>>>+	return dpll;
>>>+
>>>+error:
>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>+	kfree(dpll);
>>>+	return ERR_PTR(ret);
>>>+}
>>>+EXPORT_SYMBOL_GPL(dpll_device_alloc);

[...]


>>>+			return -EEXIST;
>>>+	}
>>>+
>>>+	ret = xa_alloc(pins, &pin->idx, pin, xa_limit_16b, GFP_KERNEL);
>>>+	if (!ret)
>>>+		xa_set_mark(pins, pin->idx, PIN_REGISTERED);
>>
>>What is exactly the point of having this mark?
>>
>
>Think this could be now removed, we got rid of separated alloc/register for
>dpll device.

Cool.


>
>>
>>>+
>>>+	return ret;
>>>+}
>>>+
>>>+static int dpll_pin_ref_add(struct dpll_pin *pin, struct dpll_device
>>>*dpll,
>>>+			    struct dpll_pin_ops *ops, void *priv)
>>>+{
>>>+	struct dpll_pin_ref *ref, *pos;
>>>+	unsigned long index;
>>>+	u32 idx;
>>>+
>>>+	ref = kzalloc(sizeof(struct dpll_pin_ref), GFP_KERNEL);
>>>+	if (!ref)
>>>+		return -ENOMEM;
>>>+	ref->dpll = dpll;
>>>+	ref->ops = ops;
>>>+	ref->priv = priv;
>>>+	if (!xa_empty(&pin->ref_dplls)) {
>>
>>Pointless check. Just do iterate.
>>
>
>Sure, will do.
>
>>
>>>+		xa_for_each(&pin->ref_dplls, index, pos) {
>>>+			if (pos->dpll == ref->dpll)
>>>+				return -EEXIST;
>>>+		}
>>>+	}
>>>+
>>>+	return xa_alloc(&pin->ref_dplls, &idx, ref, xa_limit_16b,
>>>GFP_KERNEL);
>>>+}
>>>+
>>>+static void dpll_pin_ref_del(struct dpll_pin *pin, struct dpll_device
>>>*dpll)
>>>+{
>>>+	struct dpll_pin_ref *pos;
>>>+	unsigned long index;
>>>+
>>>+	xa_for_each(&pin->ref_dplls, index, pos) {
>>>+		if (pos->dpll == dpll) {
>>>+			WARN_ON_ONCE(pos != xa_erase(&pin->ref_dplls, index));
>>>+			break;
>>>+		}
>>>+	}
>>>+}
>>>+
>>>+static int pin_deregister_from_xa(struct xarray *xa_pins, struct dpll_pin
>>>*pin)
>>
>>1) dpll_ prefix
>
>Sure, will do.
>
>>2) "deregister" is odd name
>
>Rodger that, will fix.
>
>>3) why don't you have it next to dpll_alloc_pin_on_xa() as it is a
>>   symmetric function?
>
>Will do.
>
>>4) Why exactly just xa_erase() would not do?
>
>Might do, but need to rethink this :)

Great :)


>
>>
>>>+{
>>>+	struct dpll_pin *pos;
>>>+	unsigned long index;
>>>+
>>>+	xa_for_each(xa_pins, index, pos) {
>>>+		if (pos == pin) {
>>>+			WARN_ON_ONCE(pos != xa_erase(xa_pins, index));
>>
>>You have an odd pattern of functions getting pin as an arg then
>>doing lookup for the same pin. I have to be missing to see some
>>black magic here :O
>>
>
>The black magic was done to target correct pin in case pin index differs
>between dplls it was registered with. It would depend on the way shared pins
>are going to be allocated.
>If mixed pins approach is allowed (shared + non-shared pins) on any dpll, we
>would end up in situation where pin index for the same physical pin on multiple
>devices may be different, depending on registering pins order.
>
>As desribed in below comments, I can see here one simple solution: allow kernel
>module (which registers a pin with dpll) to control/assign pin index.
>The kernel module would only need take care of them being unique, when
>registers with first dpll - which seems not a problem. This way we would also
>be albe to get rid of searching pin function (as indexes would be known for all
>driver instances), different driver instances would use that index to share a
>pin.
>Also all the blackmagic like you described wouldn't be needed, thus simplifing
>a dpll subsystem.

Good.


>
>>
>>>+			return 0;
>>>+		}
>>>+	}
>>>+
>>>+	return -ENXIO;
>>>+}
>>>+
>>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>>+		      struct dpll_pin_ops *ops, void *priv)
>>>+{
>>>+	int ret;
>>>+
>>>+	if (!pin || !ops)
>>>+		return -EINVAL;
>>>+
>>>+	mutex_lock(&dpll->lock);
>>>+	ret = dpll_alloc_pin_on_xa(&dpll->pins, pin);
>>>+	if (!ret) {
>>>+		ret = dpll_pin_ref_add(pin, dpll, ops, priv);
>>>+		if (ret)
>>>+			pin_deregister_from_xa(&dpll->pins, pin);
>>>+	}
>>>+	mutex_unlock(&dpll->lock);
>>>+	if (!ret)
>>>+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_ADD);
>>>+
>>>+	return ret;
>>>+}
>>>+EXPORT_SYMBOL_GPL(dpll_pin_register);
>>>+
>>>+struct dpll_pin *dpll_pin_get_by_idx_from_xa(struct xarray *xa_pins, int
>>>idx)
>>>+{
>>>+	struct dpll_pin *pos;
>>>+	unsigned long index;
>>>+
>>>+	xa_for_each_marked(xa_pins, index, pos, PIN_REGISTERED) {
>>>+		if (pos->idx == idx)
>>>+			return pos;
>>>+	}
>>>+
>>>+	return NULL;
>>>+}
>>>+
>>>+/**
>>>+ * dpll_pin_get_by_idx - find a pin by its index
>>>+ * @dpll: dpll device pointer
>>>+ * @idx: index of pin
>>>+ *
>>>+ * Allows multiple driver instances using one physical DPLL to find
>>>+ * and share pin already registered with existing dpll device.
>>>+ *
>>>+ * Return: pointer if pin was found, NULL otherwise.
>>>+ */
>>>+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx)
>>>+{
>>>+	return dpll_pin_get_by_idx_from_xa(&dpll->pins, idx);
>>>+}
>>>+
>>>+	struct dpll_pin
>>>+*dpll_pin_get_by_description(struct dpll_device *dpll, const char
>>>*description)
>>>+{
>>>+	struct dpll_pin *pos, *pin = NULL;
>>>+	unsigned long index;
>>>+
>>>+	xa_for_each(&dpll->pins, index, pos) {
>>>+		if (!strncmp(pos->description, description,
>>>+			     DPLL_PIN_DESC_LEN)) {
>>>+			pin = pos;
>>>+			break;
>>>+		}
>>>+	}
>>>+
>>>+	return pin;
>>>+}
>>>+
>>>+int
>>>+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
>>>+			 struct dpll_device *dpll,
>>>+			 const char *shared_pin_description,
>>
>>I don't follow why you need to pass the string. You have struct dpll_pin
>>* in the driver. Pass that instead, avoid string to refer to kernel
>>object. But this is something I wrote multiple times.
>>
>
>I wrote this so many times :) Separated driver instances doesn't have the pin
>object pointer by default (unless they share it through some unwanted static/
>global contatiners). They need to somehow target a pin, right now only unique
>attributes on dpll/pin pair are a description and index.
>Desription is a constant, index depends on the order of initialization and is
>internal for a dpll device.
>Previously there were a function to obtain a pin index by its description, then
>register with obtained index, now this is merged into one function.
>
>Altough I agree this is still not best aproach.
>I will fix by: fallback to targeting a pin to be shared by its index, with one
>slight design change, the pin index would have to be given by the driver
>instance which registers it with the first dpll.
>All the other separated driver instances which are using that pin will have to
>know the index assigned to the pin that is going to be shared, which seems
>like a best approach to fix this issue.

>
>>
>>>+			 struct dpll_pin_ops *ops, void *priv)
>>>+{
>>>+	struct dpll_pin *pin;
>>>+	int ret;
>>>+
>>>+	mutex_lock(&dpll_pin_owner->lock);
>>>+	pin = dpll_pin_get_by_description(dpll_pin_owner,
>>>+					  shared_pin_description);
>>>+	if (!pin) {
>>>+		ret = -EINVAL;
>>>+		goto unlock;
>>>+	}
>>>+	ret = dpll_pin_register(dpll, pin, ops, priv);
>>>+unlock:
>>>+	mutex_unlock(&dpll_pin_owner->lock);
>>>+
>>>+	return ret;
>>
>>I don't understand why there should be a separate function to register
>>the shared pin. As I see it, there is a pin object that could be
>>registered with 2 or more dpll devices. What about having:
>>
>>pin = dpll_pin_alloc(desc, type, ops, priv)
>>dpll_pin_register(dpll_1, pin);
>>dpll_pin_register(dpll_2, pin);
>>dpll_pin_register(dpll_3, pin);
>>
>
>IMHO your example works already, but it would possible only if the same driver
>instance initializes all dplls.

It should be only one instance of dpll to be shared between driver
instances as I wrote in the reply to the "ice" part. There might he some
pins created alongside with this.

My point is, the first driver instance which creates dpll registers also
the pins. The other driver instance does not do anything, just gets
reference to the dpll.

On cleanup path, the last driver instance tearing down would unregister
dpll pins (Could be done automatically by dpll_device_put()).

There might be some other pins (Synce) created per driver instance
(per-PF). You have to distinguish these 2 groups.


>dpll_shared_pin_register is designed for driver instances without the pin

I think we need to make sure the terms are correct "sharing" is between
multiple dpll instances. However, if 2 driver instances are sharing the
same dpll instance, this instance has pins. There is no sharing unless
there is another dpll instance in picture. Correct?


>object.
> 
>>Then one pin will we in 3 xa_arrays for 3 dplls.
>>
>
>As we can see dpll_shared_pin_register is a fancy wrapper for
>dpll_pin_register. So yeah, that's the point :) Just separated driver instances
>sharing a pin are a issue, will fix with the approach described above (pin
>index given by the registering driver instance).

Yeah, driver instances and dpll instances are not the same thing. I dpll
instance per physical dpll. Driver instances should share them.


>
>>
>>>+}
>>>+EXPORT_SYMBOL_GPL(dpll_shared_pin_register);

[...]


>>>+/**
>>>+ * dpll_pin_parent - provide pin's parent pin if available
>>>+ * @pin: registered pin pointer
>>>+ *
>>>+ * Return: pointer to aparent if found, NULL otherwise.
>>>+ */
>>>+struct dpll_pin *dpll_pin_parent(struct dpll_pin *pin)
>>
>>What exactly is the reason of having one line helpers to access struct
>>fields for a struct which is known to the caller? Unneccesary
>>boilerplate code. Please remove these. For pin and for dpll_device as
>>well.
>>
>
>Actually dpll_pin is defined in dpll_core.c, so it is not known to the caller
>yet. About dpll_device, yes it is known. And we need common approach here, thus
>we need a fix. I know this is kernel code, full of hacks and performance related
>bad-design stuff, so will fix as suggested.

You are in the same code, just multiple files. Share the structs in .h
files internally. Externally (to the drivers), the struct geometry
should be hidden so the driver does not do some unwanted magic.


>
>>
>>
>>>+{
>>>+	return pin->parent_pin;
>>>+}
>>>+

[...]


>>>+static int dpll_msg_add_pin_modes(struct sk_buff *msg,
>>>+				   const struct dpll_device *dpll,
>>>+				   const struct dpll_pin *pin)
>>>+{
>>>+	enum dpll_pin_mode i;
>>>+	bool active;
>>>+
>>>+	for (i = DPLL_PIN_MODE_UNSPEC + 1; i <= DPLL_PIN_MODE_MAX; i++) {
>>>+		if (dpll_pin_mode_active(dpll, pin, i, &active))
>>>+			return 0;
>>>+		if (active)
>>>+			if (nla_put_s32(msg, DPLLA_PIN_MODE, i))
>>
>>Why this is signed?
>>
>
>Because enums are signed.

You use negative values in enums? Don't do that here. Have all netlink
atrributes unsigned please.


>
>>
>>>+				return -EMSGSIZE;
>>>+	}
>>>+
>>>+	return 0;
>>>+}
>>>+

[...]


>>>+static struct genl_family dpll_family __ro_after_init = {
>>>+	.hdrsize	= 0,
>>
>>No need for static.
>>
>
>Sorry, don't get it, why it shall be non-static?

Static is already zeroed, you don't need to zero it again.


>
>>
>>>+	.name		= DPLL_FAMILY_NAME,
>>>+	.version	= DPLL_VERSION,
>>>+	.ops		= dpll_ops,
>>>+	.n_ops		= ARRAY_SIZE(dpll_ops),
>>>+	.mcgrps		= dpll_mcgrps,
>>>+	.n_mcgrps	= ARRAY_SIZE(dpll_mcgrps),
>>>+	.pre_doit	= dpll_pre_doit,
>>>+	.parallel_ops   = true,
>>>+};

[...]


>>>+
>>>+#define DPLL_FILTER_PINS	1
>>>+#define DPLL_FILTER_STATUS	2
>>
>>Why again do we need any filtering here?
>>
>
>A way to reduce output generated by dump/get requests. Assume the userspace
>want to have specific information instead of everything in one packet.
>They might be not needed after we introduce separated "get pin" command.

That's right, not needed.


>
>>
>>>+
>>>+/* dplla - Attributes of dpll generic netlink family
>>>+ *
>>>+ * @DPLLA_UNSPEC - invalid attribute
>>>+ * @DPLLA_ID - ID of a dpll device (unsigned int)
>>>+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH
>>size)
>>>+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
>>>+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum
>>dpll_mode)
>>>+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
>>
>>IDX
>>
>
>Sure, will fix.
>
>>
>>>+ *	(unsigned int)
>>>+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
>>>+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
>>
>>Hmm, wouldn't it be better to have it as 1/10 of Celsius degree for
>>example?
>>
>
>As we are not using it, I don't have any strong opinon on this, but seems
>resonable to me, will add a divider into uAPI like:
>
>#define DPLL_TEMP_DIVIDER	10

Okay.


>
>>
>>>+ * @DPLLA_CLOCK_ID - Unique Clock Identifier of dpll (u64)
>>>+ * @DPLLA_CLOCK_CLASS - clock quality class of dpll (enum
>>dpll_clock_class)
>>>+ * @DPLLA_FILTER - filter bitmask for filtering get and dump requests
>>>(int,
>>>+ *	sum of DPLL_DUMP_FILTER_* defines)
>>>+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
>>>+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
>>>+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by
>>>driver
>>>+ *	(char array of PIN_DESC_LEN size)
>>>+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
>>>+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
>>>+ *	(enum dpll_pin_signal_type)
>>>+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
>>>+ *	(enum dpll_pin_signal_type)
>>>+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for
>>>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
>>>+ *	(unsigned int)
>>>+ * @DPLLA_PIN_MODE - state of pin's capabilities (enum dpll_pin_mode)
>>>+ * @DPLLA_PIN_MODE_SUPPORTED - available pin's capabilities
>>>+ *	(enum dpll_pin_mode)
>>>+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
>>>+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
>>>+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
>>>+ * @DPLLA_CHANGE_TYPE - type of device change event
>>>+ *	(enum dpll_change_type)
>>>+ **/
>>>+enum dplla {
>>>+	DPLLA_UNSPEC,
>>>+	DPLLA_ID,
>>>+	DPLLA_NAME,
>>>+	DPLLA_MODE,
>>>+	DPLLA_MODE_SUPPORTED,
>>>+	DPLLA_SOURCE_PIN_IDX,
>>>+	DPLLA_LOCK_STATUS,
>>>+	DPLLA_TEMP,
>>>+	DPLLA_CLOCK_ID,
>>>+	DPLLA_CLOCK_CLASS,
>>>+	DPLLA_FILTER,
>>>+	DPLLA_PIN,
>>>+	DPLLA_PIN_IDX,
>>>+	DPLLA_PIN_DESCRIPTION,
>>>+	DPLLA_PIN_TYPE,
>>>+	DPLLA_PIN_SIGNAL_TYPE,
>>>+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
>>>+	DPLLA_PIN_CUSTOM_FREQ,
>>>+	DPLLA_PIN_MODE,
>>>+	DPLLA_PIN_MODE_SUPPORTED,
>>>+	DPLLA_PIN_PRIO,
>>>+	DPLLA_PIN_PARENT_IDX,
>>>+	DPLLA_PIN_NETIFINDEX,
>>
>>I believe we cannot have this right now. The problem is, ifindexes may
>>overlay between namespaces. So ifindex without namespace means nothing.
>>I don't see how this can work from the dpll side.
>>
>
>I am a bit confused, as it seemed we already had an agreement on v4 discussion
>on this. And now again you highligheted it with the same reasoning as
>previously. Has anything changed on that matter?

Not sure what we discussed, but ifindex alone is not enough as ifindexes
from multiple namespaces overlap.


>
>>Lets assign dpll_pin pointer to netdev and expose it over RT netlink in
>>a similar way devlink_port is exposed. That should be enough for the
>>user to find a dpll instance for given netdev.
>>
>>It does not have to be part of this set strictly, but I would like to
>>have it here, so the full picture could be seen.
>>
>
>A "full picture" is getting broken if we would go with another place to keep
>the reference between pin and device that produces its signal.
>
>Why don't we add an 'struct device *' argument for dpll_pin_alloc, create
>new attribute with dev_name macro similary to the current name of dpll device
>name, something like: DPLLA_PIN_RCLK_DEVICE (string).
>This way any device (not only netdev) would be able to add a pin and point to
>a device which produces its signal.

Okay, that sounds good.


>
>>
>>
>>>+	DPLLA_CHANGE_TYPE,
>>>+	__DPLLA_MAX,
>>>+};
>>>+
>>>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>>>+
>>>+/* dpll_lock_status - DPLL status provides information of device status
>>>+ *
>>>+ * @DPLL_LOCK_STATUS_UNSPEC - unspecified value
>>>+ * @DPLL_LOCK_STATUS_UNLOCKED - dpll was not yet locked to any valid (or
>>is in
>>>+ *	DPLL_MODE_FREERUN/DPLL_MODE_NCO modes)
>>>+ * @DPLL_LOCK_STATUS_CALIBRATING - dpll is trying to lock to a valid
>>signal
>>>+ * @DPLL_LOCK_STATUS_LOCKED - dpll is locked
>>>+ * @DPLL_LOCK_STATUS_HOLDOVER - dpll is in holdover state - lost a valid
>>lock
>>>+ *	or was forced by DPLL_MODE_HOLDOVER mode)
>>>+ **/
>>>+enum dpll_lock_status {
>>>+	DPLL_LOCK_STATUS_UNSPEC,
>>>+	DPLL_LOCK_STATUS_UNLOCKED,
>>>+	DPLL_LOCK_STATUS_CALIBRATING,
>>>+	DPLL_LOCK_STATUS_LOCKED,
>>>+	DPLL_LOCK_STATUS_HOLDOVER,
>>>+
>>>+	__DPLL_LOCK_STATUS_MAX,
>>>+};
>>>+
>>>+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
>>>+
>>>+/* dpll_pin_type - signal types
>>>+ *
>>>+ * @DPLL_PIN_TYPE_UNSPEC - unspecified value
>>>+ * @DPLL_PIN_TYPE_MUX - mux type pin, aggregates selectable pins
>>>+ * @DPLL_PIN_TYPE_EXT - external source
>>>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT - ethernet port PHY's recovered clock
>>>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR - device internal oscillator
>>>+ * @DPLL_PIN_TYPE_GNSS - GNSS recovered clock
>>>+ **/
>>>+enum dpll_pin_type {
>>>+	DPLL_PIN_TYPE_UNSPEC,
>>>+	DPLL_PIN_TYPE_MUX,
>>>+	DPLL_PIN_TYPE_EXT,
>>>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>>>+	DPLL_PIN_TYPE_GNSS,
>>>+
>>>+	__DPLL_PIN_TYPE_MAX,
>>>+};
>>>+
>>>+#define DPLL_PIN_TYPE_MAX (__DPLL_PIN_TYPE_MAX - 1)
>>>+
>>>+/* dpll_pin_signal_type - signal types
>>>+ *
>>>+ * @DPLL_PIN_SIGNAL_TYPE_UNSPEC - unspecified value
>>>+ * @DPLL_PIN_SIGNAL_TYPE_1_PPS - a 1Hz signal
>>>+ * @DPLL_PIN_SIGNAL_TYPE_10_MHZ - a 10 MHz signal
>>
>>Why we need to have 1HZ and 10MHZ hardcoded as enums? Why can't we work
>>with HZ value directly? For example, supported freq:
>>1, 10000000
>>or:
>>1, 1000
>>
>>freq set 10000000
>>freq set 1
>>
>>Simple and easy.
>>
>
>AFAIR, we wanted to have most commonly used frequencies as enums + custom_freq
>for some exotic ones (please note that there is also possible 2PPS, which is
>0.5 Hz).

In this exotic case, user might add divider netlink attribute to divide
the frequency pass in the attr. No problem.


>This was design decision we already agreed on.
>The userspace shall get definite list of comonly used frequencies that can be
>used with given HW, it clearly enums are good for this.

I don't see why. Each instance supports a set of frequencies. It would
pass the values to the userspace.

I fail to see the need to have some fixed values listed in enums. Mixing
approaches for a single attribute is wrong. In ethtool we also don't
have enum values for 10,100,1000mbits etc. It's just a number.


>
>>
>>>+ * @DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ - custom frequency signal, value
>>defined
>>>+ *	with pin's DPLLA_PIN_SIGNAL_TYPE_CUSTOM_FREQ attribute
>>>+ **/
>>>+enum dpll_pin_signal_type {
>>>+	DPLL_PIN_SIGNAL_TYPE_UNSPEC,
>>>+	DPLL_PIN_SIGNAL_TYPE_1_PPS,
>>>+	DPLL_PIN_SIGNAL_TYPE_10_MHZ,
>>>+	DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ,
>>>+
>>>+	__DPLL_PIN_SIGNAL_TYPE_MAX,
>>>+};
>>>+
>>>+#define DPLL_PIN_SIGNAL_TYPE_MAX (__DPLL_PIN_SIGNAL_TYPE_MAX - 1)
>>>+
>>>+/* dpll_pin_mode - available pin states
>>>+ *
>>>+ * @DPLL_PIN_MODE_UNSPEC - unspecified value
>>>+ * @DPLL_PIN_MODE_CONNECTED - pin connected
>>>+ * @DPLL_PIN_MODE_DISCONNECTED - pin disconnected
>>>+ * @DPLL_PIN_MODE_SOURCE - pin used as an input pin
>>>+ * @DPLL_PIN_MODE_OUTPUT - pin used as an output pin
>>>+ **/
>>>+enum dpll_pin_mode {
>>>+	DPLL_PIN_MODE_UNSPEC,
>>>+	DPLL_PIN_MODE_CONNECTED,
>>>+	DPLL_PIN_MODE_DISCONNECTED,
>>>+	DPLL_PIN_MODE_SOURCE,
>>>+	DPLL_PIN_MODE_OUTPUT,
>>
>>I don't follow. I see 2 enums:
>>CONNECTED/DISCONNECTED
>>SOURCE/OUTPUT
>>why this is mangled together? How is it supposed to be working. Like a
>>bitarray?
>>
>
>The userspace shouldn't worry about bits, it recieves a list of attributes.
>For current/active mode: DPLLA_PIN_MODE, and for supported modes:
>DPLLA_PIN_MODE_SUPPORTED. I.e.
>
>	DPLLA_PIN_IDX			0
>	DPLLA_PIN_MODE			1,3
>	DPLLA_PIN_MODE_SUPPORTED	1,2,3,4

I believe that mixing apples and oranges in a single attr is not correct.
Could you please split to separate attrs as drafted below?

>
>The reason for existance of both DPLL_PIN_MODE_CONNECTED and
>DPLL_PIN_MODE_DISCONNECTED, is that the user must request it somehow,
>and bitmask is not a way to go for userspace.

What? See nla_bitmap.

Anyway, why can't you have:
DPLLA_PIN_CONNECTED     u8 1/0 (bool)
DPLLA_PIN_DIRECTION     enum { SOURCE/OUTPUT }
DPLLA_PIN_CAPS          nla_bitfield(CAN_CHANGE_CONNECTED, CAN_CHANGE_DIRECTION)

We can use the capabilitis bitfield eventually for other purposes as
well, it is going to be handy I'm sure.



>
>
>>
>>>+
>>>+	__DPLL_PIN_MODE_MAX,
>>>+};
>>>+

[...]


>>>+/**
>>>+ * dpll_mode - Working-modes a dpll can support. Modes differentiate how
>>>+ * dpll selects one of its sources to syntonize with a source.
>>>+ *
>>>+ * @DPLL_MODE_UNSPEC - invalid
>>>+ * @DPLL_MODE_MANUAL - source can be only selected by sending a request
>>to dpll
>>>+ * @DPLL_MODE_AUTOMATIC - highest prio, valid source, auto selected by
>>dpll
>>>+ * @DPLL_MODE_HOLDOVER - dpll forced into holdover mode
>>>+ * @DPLL_MODE_FREERUN - dpll driven on system clk, no holdover available
>>>+ * @DPLL_MODE_NCO - dpll driven by Numerically Controlled Oscillator
>>
>>Why does the user care which oscilator is run internally. It's freerun,
>>isn't it? If you want to expose oscilator type, you should do it
>>elsewhere.
>>
>
>In NCO user might change frequency of an output, in freerun cannot.

How this could be done?


[...]

