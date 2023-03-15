Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C36BB011
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjCOMPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCOMO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:14:58 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05E672B06
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:14:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j2so17087145wrh.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678882492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVvKsx++1bGMRXlqXKWhGNeR1+rCra1IHnccMD5UV28=;
        b=J9dcqCHhKEqWFlXqV9VBXYk0sOTSi3rn8++4PNSR33yrIx6+1HXq4avdp329Lw7sqy
         HydiGh/Xr66v3+rcbp6QGhAgwNQGuTxTiU8KoH1y7VcjL45PRZ2TfbZ4vPKGib3OJpLX
         zjm8kTt09NwhE4Q83puCXTpHP+tjve51gGVL1+3MgVXYA88MBmYU6evDnZqTg95eUugt
         P049isUxWEUbrfUUvbA40t001S22nxbID0zlpF6u7jXPEa7JxDYf1KcEL/s8La/JUptC
         u2Nu2fORXkNwvByGCk+rgNV6RGvVULdi52nAFMVQAL4LlYbKLg/B71ZgbQH01UlXugg+
         kR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678882492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVvKsx++1bGMRXlqXKWhGNeR1+rCra1IHnccMD5UV28=;
        b=QlEhStta3rSIwnR+EpwqFVt97nZDACqcv71+iQydN4HElvVgNaun8dv/5iv7wfGsz8
         UxxMY8nu7YXaekVMFuOMrNwSqbRPE+7vFcTjK4G09daVBdVN5rNh9mF1meXQKVhx6zs3
         XqlRCJxhDDaR4FKZD3NZpKRDyEh+wgzCndzlX5nsu5WVPo5W4zgyd3Kp0j/p4CAGiAvc
         YCPuV3wkdpK0PZicJ3uxWPQKdUGwZ/2dtf2dOPbgJYfITDGg1TWwlTFkYou+Qx5mdBYq
         KJ0Y5sYvXRDVkw//WL6LO5uDWSDkpeTda8CCa7yPc6mJOyA6cTgGCPYDz0I2rwK9EP32
         JKXQ==
X-Gm-Message-State: AO0yUKVEN8INgTivhDM4MyxlUAZ6hJJ2Xi1NSNoYGK19hLVx6bXQhh0w
        kOcYpxn5wie6Fhzr+mPgmJLEuA==
X-Google-Smtp-Source: AK7set/f9GF0J45cZlQWr4h/YKNvuUQJkVE/LHyiECOrt7cl3fxGD2+2J/nASEgSch3srvkKMzcqwg==
X-Received: by 2002:a5d:66ce:0:b0:2ca:a36e:3441 with SMTP id k14-20020a5d66ce000000b002caa36e3441mr1764869wrw.15.1678882491983;
        Wed, 15 Mar 2023 05:14:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm4435031wrc.41.2023.03.15.05.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 05:14:51 -0700 (PDT)
Date:   Wed, 15 Mar 2023 13:14:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
        mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBG2ubNAX9cGxr8b@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
 <ZA9Nbll8+xHt4ygd@nanopsycho>
 <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
 <DM6PR11MB4657DD414669235610D3112E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657DD414669235610D3112E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 14, 2023 at 05:43:18PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>Sent: Tuesday, March 14, 2023 12:00 AM
>>
>
>[...]
>
>>>> +
>>>> +/**
>>>> + * dpll_device_get - find existing or create new dpll device
>>>> + * @clock_id: clock_id of creator
>>>> + * @dev_driver_id: id given by dev driver
>>>> + * @module: reference to registering module
>>>> + *
>>>> + * Get existing object of a dpll device, unique for given arguments.
>>>> + * Create new if doesn't exist yet.
>>>> + *
>>>> + * Return:
>>>> + * * valid dpll_device struct pointer if succeeded
>>>> + * * ERR_PTR of an error
>>>> + */
>>>> +struct dpll_device *
>>>> +dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module)
>>>> +{
>>>> +	struct dpll_device *dpll, *ret = NULL;
>>>> +	unsigned long index;
>>>> +
>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>> +	xa_for_each(&dpll_device_xa, index, dpll) {
>>>> +		if (dpll->clock_id == clock_id &&
>>>> +		    dpll->dev_driver_id == dev_driver_id &&
>>>
>>> Why you need "dev_driver_id"? clock_id is here for the purpose of
>>> identification, isn't that enough for you.
>>
>>dev_driver_id is needed to provide several DPLLs from one device. In ice
>>driver
>>implementation there are 2 different DPLLs - to recover from PPS input and
>>to
>>recover from Sync-E. I believe there is only one clock, that's why clock id
>>is
>>the same for both of them. But Arkadiusz can tell more about it.
>
>Yes, exactly.
>One driver can have multiple dplls with the same clock id.
>Actually dev_driver_id makes dpll objects unique.
>
>>>
>>> Plus, the name is odd. "dev_driver" should certainly be avoided.
>>
>>Simply id doesn't tell anything either. dpll_dev_id?
>
>Looks good to me.

Let's call this "device_index" and "pin_index" for the pin getter as I
suggested in the other email.


>
>>
>>>> +		    dpll->module == module) {
>>>> +			ret = dpll;
>>>> +			refcount_inc(&ret->refcount);
>>>> +			break;
>>>> +		}
>>>> +	}
>>>> +	if (!ret)
>>>> +		ret = dpll_device_alloc(clock_id, dev_driver_id, module);
>>>> +	mutex_unlock(&dpll_device_xa_lock);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(dpll_device_get);
>>>> +
>>>> +/**
>>>> + * dpll_device_put - decrease the refcount and free memory if possible
>>>> + * @dpll: dpll_device struct pointer
>>>> + *
>>>> + * Drop reference for a dpll device, if all references are gone, delete
>>>> + * dpll device object.
>>>> + */
>>>> +void dpll_device_put(struct dpll_device *dpll)
>>>> +{
>>>> +	if (!dpll)
>>>> +		return;
>>>
>>> Remove this check. The driver should not call this with NULL.
>>
>>Well, netdev_put() has this kind of check. As well as spi_dev_put() or
>>i2c_put_adapter() at least. Not sure I would like to avoid a bit of safety.
>>
>
>I agree, IMHO it is better to have safety checks :)

IDK, we should rely on basic driver sanity. Let least put a WARN_ON() to
these checks. But try to reduce them at least.



>
>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>> +	if (refcount_dec_and_test(&dpll->refcount)) {
>>>> +		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
>>>
>>> ASSERT_DPLL_NOT_REGISTERED(dpll);
>>
>>Good point!
>>
>
>Yes, great point!
>
>>>> +		xa_destroy(&dpll->pin_refs);
>>>> +		xa_erase(&dpll_device_xa, dpll->id);
>>>> +		kfree(dpll);
>>>> +	}
>>>> +	mutex_unlock(&dpll_device_xa_lock);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(dpll_device_put);
>>>> +
>>>> +/**
>>>> + * dpll_device_register - register the dpll device in the subsystem
>>>> + * @dpll: pointer to a dpll
>>>> + * @type: type of a dpll
>>>> + * @ops: ops for a dpll device
>>>> + * @priv: pointer to private information of owner
>>>> + * @owner: pointer to owner device
>>>> + *
>>>> + * Make dpll device available for user space.
>>>> + *
>>>> + * Return:
>>>> + * * 0 on success
>>>> + * * -EINVAL on failure
>>>> + */
>>>> +int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>>>> +			 struct dpll_device_ops *ops, void *priv,
>>>> +			 struct device *owner)
>>>> +{
>>>> +	if (WARN_ON(!ops || !owner))
>>>> +		return -EINVAL;
>>>> +	if (WARN_ON(type <= DPLL_TYPE_UNSPEC || type > DPLL_TYPE_MAX))
>>>> +		return -EINVAL;
>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>> +	if (ASSERT_DPLL_NOT_REGISTERED(dpll)) {
>>>> +		mutex_unlock(&dpll_device_xa_lock);
>>>> +		return -EEXIST;
>>>> +	}
>>>> +	dpll->dev.bus = owner->bus;
>>>> +	dpll->parent = owner;
>>>> +	dpll->type = type;
>>>> +	dpll->ops = ops;
>>>> +	dev_set_name(&dpll->dev, "%s_%d", dev_name(owner),
>>>> +		     dpll->dev_driver_id);
>>>
>>> This is really odd. As a result, the user would see something like:
>>> pci/0000:01:00.0_1
>>> pci/0000:01:00.0_2
>>>
>>> I have to say it is confusing. In devlink, is bus/name and the user
>>> could use this info to look trough sysfs. Here, 0000:01:00.0_1 is not
>>> there. Also, "_" might have some meaning on some bus. Should not
>>> concatename dev_name() with anything.
>>>
>>> Thinking about this some more, the module/clock_id tuple should be
>>> uniqueue and stable. It is used for dpll_device_get(), it could be used
>>> as the user handle, can't it?
>>> Example:
>>> ice/c92d02a7129f4747
>>> mlx5/90265d8bf6e6df56
>>>
>>> If you really need the "dev_driver_id" (as I believe clock_id should be
>>> enough), you can put it here as well:
>>> ice/c92d02a7129f4747/1
>>> ice/c92d02a7129f4747/2
>>>
>>
>>Looks good, will change it
>
>Makes sense to me.

Good. Fits the mlx5 model nicely.


>
>>
>>> This would also be beneficial for mlx5, as mlx5 with 2 PFs would like to
>>> share instance of DPLL equally, there is no "one clock master". >
>>>> +	dpll->priv = priv;
>>>> +	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>>> +	mutex_unlock(&dpll_device_xa_lock);
>>>> +	dpll_notify_device_create(dpll);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(dpll_device_register);
>>>> +
>>>> +/**
>>>> + * dpll_device_unregister - deregister dpll device
>>>> + * @dpll: registered dpll pointer
>>>> + *
>>>> + * Deregister device, make it unavailable for userspace.
>>>> + * Note: It does not free the memory
>>>> + */
>>>> +void dpll_device_unregister(struct dpll_device *dpll)
>>>> +{
>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>> +	ASSERT_DPLL_REGISTERED(dpll);
>>>> +	xa_clear_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>>> +	mutex_unlock(&dpll_device_xa_lock);
>>>> +	dpll_notify_device_delete(dpll);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(dpll_device_unregister);
>>>> +
>>>> +/**
>>>> + * dpll_pin_alloc - allocate the memory for dpll pin
>>>> + * @clock_id: clock_id of creator
>>>> + * @dev_driver_id: id given by dev driver
>>>> + * @module: reference to registering module
>>>> + * @prop: dpll pin properties
>>>> + *
>>>> + * Return:
>>>> + * * valid allocated dpll_pin struct pointer if succeeded
>>>> + * * ERR_PTR of an error
>>>
>>> Extra "*"'s
>>
>>Ok, I can re-format the comments across the files.
>
>This is expected on enumerating return values in kernel-docs:
>https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html#Return%20values

Ah, okay. I missed that. Sorry.


>
>>
>>>> + */
>>>> +struct dpll_pin *
>>>> +dpll_pin_alloc(u64 clock_id, u8 device_drv_id,	struct module
>>*module,
>>>
>>> Odd whitespace.
>>>
>>> Also, func should be static.
>>>
>>
>>Fixed.
>>
>>>
>>>> +	       const struct dpll_pin_properties *prop)
>>>> +{
>>>> +	struct dpll_pin *pin;
>>>> +	int ret;
>>>> +
>>>> +	pin = kzalloc(sizeof(*pin), GFP_KERNEL);
>>>> +	if (!pin)
>>>> +		return ERR_PTR(-ENOMEM);
>>>> +	pin->dev_driver_id = device_drv_id;
>>>
>>> Name inconsistency: driver/drv
>>> you have it on multiple places
>>>
>>
>>Changed it every where, thanks for spotting.
>>
>>>
>>>> +	pin->clock_id = clock_id;
>>>> +	pin->module = module;
>>>> +	refcount_set(&pin->refcount, 1);
>>>> +	if (WARN_ON(!prop->description)) {
>>>> +		ret = -EINVAL;
>>>> +		goto release;
>>>> +	}
>>>> +	pin->prop.description = kstrdup(prop->description, GFP_KERNEL);
>>>> +	if (!pin->prop.description) {
>>>> +		ret = -ENOMEM;
>>>> +		goto release;
>>>> +	}
>>>> +	if (WARN_ON(prop->type <= DPLL_PIN_TYPE_UNSPEC ||
>>>> +		    prop->type > DPLL_PIN_TYPE_MAX)) {
>>>> +		ret = -EINVAL;
>>>> +		goto release;
>>>> +	}
>>>> +	pin->prop.type = prop->type;
>>>> +	pin->prop.capabilities = prop->capabilities;
>>>> +	pin->prop.freq_supported = prop->freq_supported;
>>>> +	pin->prop.any_freq_min = prop->any_freq_min;
>>>> +	pin->prop.any_freq_max = prop->any_freq_max;
>>>
>>> Make sure that the driver maintains prop (static const) and just save
>>> the pointer. Prop does not need to be something driver needs to change.
>>>
>>
>>What's the difference? For ptp_ocp, we have the same configuration for all
>>ext pins and the allocator only changes the name of the pin. Properties of
>>the DPLL pins are stored within the pin object, not the driver, in this
>>case.
>>Not sure if the pointer way is much better...
>>
>
>I also don't feel it.
>Dpll subsystem directly using memory of different driver doesn't look like a
>great design.

Wait. This is done all the time in kernel. Almost every ops for example.
Lots of other examples like that as well:
git grep "static const struct" drivers/net/


>
>>>
>>>> +	xa_init_flags(&pin->dpll_refs, XA_FLAGS_ALLOC);
>>>> +	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
>>>> +	ret = xa_alloc(&dpll_pin_xa, &pin->idx, pin,
>>>> +		       xa_limit_16b, GFP_KERNEL);
>>>> +release:
>>>> +	if (ret) {
>>>> +		xa_destroy(&pin->dpll_refs);
>>>> +		xa_destroy(&pin->parent_refs);
>>>> +		kfree(pin->prop.description);
>>>> +		kfree(pin->rclk_dev_name);
>>>> +		kfree(pin);
>>>> +		return ERR_PTR(ret);
>>>> +	}
>>>> +
>>>> +	return pin;
>>>> +}
>>>> +
>>>> +/**
>>>> + * dpll_pin_get - find existing or create new dpll pin
>>>> + * @clock_id: clock_id of creator
>>>> + * @dev_driver_id: id given by dev driver
>>>> + * @module: reference to registering module
>>>> + * @prop: dpll pin properties
>>>> + *
>>>> + * Get existing object of a pin (unique for given arguments) or create
>>>>new
>>>> + * if doesn't exist yet.
>>>> + *
>>>> + * Return:
>>>> + * * valid allocated dpll_pin struct pointer if succeeded
>>>> + * * ERR_PTR of an error
>>>
>>> This is one example, I'm pretty sure that there are others, when you
>>> have text inconsistencies in func doc for the same function in .c and .h
>>> Have it please only on one place. .c is the usual place.
>>>
>>
>>Yep, will clear .h files.
>>
>
>There might be some issues, and certainly makes sense to have them in one
>place.
>
>>>
>>>> + */
>>>> +struct dpll_pin *
>>>> +dpll_pin_get(u64 clock_id, u32 device_drv_id, struct module *module,
>>>
>>> Again, why do you need this device_drv_id? Clock id should be enough.
>>>
>>I explained the reason earlier, but the naming is fixed.
>
>Yes, this device_drv_id is id of a pin not a dpll device id.
>Maybe worth to rename it to make it more clear.

Yeah, device_index and pin_index


>
>>
>>>
>>>> +	     const struct dpll_pin_properties *prop)
>>>> +{
>>>> +	struct dpll_pin *pos, *ret = NULL;
>>>> +	unsigned long index;
>>>> +
>>>> +	mutex_lock(&dpll_pin_xa_lock);
>>>> +	xa_for_each(&dpll_pin_xa, index, pos) {
>>>> +		if (pos->clock_id == clock_id &&
>>>> +		    pos->dev_driver_id == device_drv_id &&
>>>> +		    pos->module == module) {
>>>
>>> Compare prop as well.
>>>
>>> Can't the driver_id (pin index) be something const as well? I think it
>>> should. And therefore it could be easily put inside.
>>>
>>
>>I think clock_id + dev_driver_id + module should identify the pin exactly.
>
>Yes, they should be unique for a single pin object, and enough for getting
>pin reference.
>Basically if driver would call twice this with different props, it would be
>broken.
>We could have props compared here as well.

Let's leave it as it is for now, it's ok.


>
>>And
>>now I think that *prop is not needed here at all. Arkadiusz, any thoughts?
>
>As dpll_pin_alloc is having them assigned to a pin object, thus had to put it
>here. Not sure how to solve it differently.
>Jiri's suggestion to put dev_driver_id inside of pin props would also work
>AFAIU.

Let's have it as device_get()/pin_get() args as you have it right now.
Makes more sense as the prop could be static const as I described in the
other email.


>
>[...]
>
>>>> +
>>>> +/**
>>>> + * dpll_pin_register - register the dpll pin in the subsystem
>>>> + * @dpll: pointer to a dpll
>>>> + * @pin: pointer to a dpll pin
>>>> + * @ops: ops for a dpll pin ops
>>>> + * @priv: pointer to private information of owner
>>>> + * @rclk_device: pointer to recovered clock device
>>>> + *
>>>> + * Return:
>>>> + * * 0 on success
>>>> + * * -EINVAL - missing dpll or pin
>>>> + * * -ENOMEM - failed to allocate memory
>>>> + */
>>>> +int
>>>> +dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>>> +		  struct dpll_pin_ops *ops, void *priv,
>>>> +		  struct device *rclk_device)
>>>
>>> Wait a second, what is this "struct device *"? Looks very odd.
>>>
>>>
>>>> +{
>>>> +	const char *rclk_name = rclk_device ? dev_name(rclk_device) : NULL;
>>>
>>> If you need to store something here, store the pointer to the device
>>> directly. But this rclk_device seems odd to me.
>>> Dev_name is in case of PCI device for example 0000:01:00.0? That alone
>>> is incomplete. What should it server for?
>>>
>>
>>Well, these questions go to Arkadiusz...
>>
>
>If pin is able to recover signal from some device this shall convey that
>device struct pointer.
>Name of that device is later passed to the user with DPLL_A_PIN_RCLK_DEVICE
>attribute.
>Sure we can have pointer to device and use dev_name (each do/dump) on netlink
>part. But isn't it better to have the name ready to use there?
>
>It might be incomplete only if one device would have some kind of access to
>a different bus? I don't think it is valid use case.

Very valid as I explained in the other email.


>
>Basically the driver will refer only to the devices handled by that driver,
>which means if dpll is on some bus, also all the pins are there, didn't notice
>the need to have bus here as well.
>
>[...]
>
>>>> +struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx)
>>>> +{
>>>> +	struct dpll_pin_ref *pos;
>>>> +	unsigned long i;
>>>> +
>>>> +	xa_for_each(&dpll->pin_refs, i, pos) {
>>>> +		if (pos && pos->pin && pos->pin->dev_driver_id == idx)
>>>
>>> How exactly pos->pin could be NULL?
>>>
>
>I believe if proper synchronization in place it shall not be NULL, I left it
>after fixing some issue with access to the pin that was already removed..

Then don't check it here.


>
>>> Also, you are degrading the xarray to a mere list here with lookup like
>>> this. Why can't you use the pin index coming from driver and
>>> insert/lookup based on this index?
>>>
>>Good point. We just have to be sure, that drivers provide 0-based indexes
>>for their pins. I'll re-think it.
>>
>
>After quick thinking, it might be doable, storing pin being registered on
>dpll->pin_refs under given by driver pin's dev_driver_idx or whatever it would
>be named.

Yep.


>
>>
>>>
>>>> +			return pos->pin;
>>>> +	}
>>>> +
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> +/**
>>>> + * dpll_priv - get the dpll device private owner data
>>>> + * @dpll:	registered dpll pointer
>>>> + *
>>>> + * Return: pointer to the data
>>>> + */
>>>> +void *dpll_priv(const struct dpll_device *dpll)
>>>> +{
>>>> +	return dpll->priv;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(dpll_priv);
>>>> +
>>>> +/**
>>>> + * dpll_pin_on_dpll_priv - get the dpll device private owner data
>>>> + * @dpll:	registered dpll pointer
>>>> + * @pin:	pointer to a pin
>>>> + *
>>>> + * Return: pointer to the data
>>>> + */
>>>> +void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
>>>
>>> IIUC, you use this helper from dpll ops in drivers to get per dpll priv.
>>> Just pass the priv directly to the op and avoid need for this helper,
>>> no? Same goes to the rest of the priv helpers.
>>>
>
>No strong opinion, probably doable.

It is better for the driver writer to actually see right away that
there is a priv so he can use it and not need to get the priv from
some place else (using pin index * lookup). Very nice example where
this would work is the last patch of this set, where Vadim does not
use priv at all.


>
>>>
>>>> +			    const struct dpll_pin *pin)
>>>> +{
>>>> +	struct dpll_pin_ref *ref;
>>>> +
>>>> +	ref = dpll_xa_ref_pin_find((struct xarray *)&dpll->pin_refs, pin);
>>>
>>> Why cast is needed here? You have this on multiple places.
>>>
>
>`const` of struct dpll_pin *pin makes a warning/error there, there is something
>broken on xarray implementation of for_each I believe.

Either fix it or avoid using const arg. Cast's like this always smell
and should be avoided.


>
>[...]
>
>>>> +
>>>> +static int
>>>> +dpll_msg_add_pins_on_pin(struct sk_buff *msg, struct dpll_pin *pin,
>>>> +			 struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct dpll_pin_ref *ref = NULL;
>>>
>>> Why this needs to be initialized?
>>>
>>No need, fixed.
>>
>>
>>>
>>>> +	enum dpll_pin_state state;
>>>> +	struct nlattr *nest;
>>>> +	unsigned long index;
>>>> +	int ret;
>>>> +
>>>> +	xa_for_each(&pin->parent_refs, index, ref) {
>>>> +		if (WARN_ON(!ref->ops->state_on_pin_get))
>>>> +			return -EFAULT;
>>>> +		ret = ref->ops->state_on_pin_get(pin, ref->pin, &state,
>>>> +						 extack);
>>>> +		if (ret)
>>>> +			return -EFAULT;
>>>> +		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
>>>> +		if (!nest)
>>>> +			return -EMSGSIZE;
>>>> +		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>>>> +				ref->pin->dev_driver_id)) {
>>>> +			ret = -EMSGSIZE;
>>>> +			goto nest_cancel;
>>>> +		}
>>>> +		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
>>>> +			ret = -EMSGSIZE;
>>>> +			goto nest_cancel;
>>>> +		}
>>>> +		nla_nest_end(msg, nest);
>>>> +	}
>>>
>>> How is this function different to dpll_msg_add_pin_parents()?
>>> Am I lost? To be honest, this x_on_pin/dpll, parent, refs dance is quite
>>> hard to follow for me :/
>>>
>>> Did you get lost here as well? If yes, this needs some serious think
>>> through :)
>>>
>>
>>Let's re-think it again. Arkadiuzs, do you have clear explanation of the
>>relationship between these things?
>>
>
>No, it is just leftover I didn't catch, we can leave one function and use it in
>both cases. Sorry about that, great catch!
>
>>>
>>>> +
>>>> +	return 0;
>>>> +
>>>> +nest_cancel:
>>>> +	nla_nest_cancel(msg, nest);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int
>>>> +dpll_msg_add_pin_dplls(struct sk_buff *msg, struct dpll_pin *pin,
>>>> +		       struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct dpll_pin_ref *ref;
>>>> +	struct nlattr *attr;
>>>> +	unsigned long index;
>>>> +	int ret;
>>>> +
>>>> +	xa_for_each(&pin->dpll_refs, index, ref) {
>>>> +		attr = nla_nest_start(msg, DPLL_A_DEVICE);
>>>> +		if (!attr)
>>>> +			return -EMSGSIZE;
>>>> +		ret = dpll_msg_add_dev_handle(msg, ref->dpll);
>>>> +		if (ret)
>>>> +			goto nest_cancel;
>>>> +		ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
>>>> +		if (ret && ret != -EOPNOTSUPP)
>>>> +			goto nest_cancel;
>>>> +		ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
>>>> +		if (ret && ret != -EOPNOTSUPP)
>>>> +			goto nest_cancel;
>>>> +		nla_nest_end(msg, attr);
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +
>>>> +nest_cancel:
>>>> +	nla_nest_end(msg, attr);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int
>>>> +dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
>>>> +			 struct dpll_device *dpll,
>>>> +			 struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct dpll_pin_ref *ref;
>>>> +	int ret;
>>>> +
>>>> +	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>>>
>>> Is it "ID" or "INDEX" (IDX). Please make this consistent in the whole
>>> code.
>>>
>>
>>I believe it's INDEX which is provided by the driver. I'll think about
>>renaming,
>>but suggestions are welcome.
>
>Yes, confusing a bit, I agree we need a fix of this.
>Isn't it that dpll has an INDEX assigned by dpll subsystem on its allocation
>and pin have ID given by the driver?

Driver should provice the device_index and pin_index in appropriate
_get() functions. I think it is better to spell out "index". "idx" looks
a bit odd. Either way, please unify the name all along the code, netlink
included.

ID is your odd dual-handle construct, which I don't see a need for and
only adds confusions. Better to remove it.


>
>[...]
>
>>>> +static int
>>>> +dpll_pin_set_from_nlattr(struct dpll_device *dpll,
>>>> +			 struct dpll_pin *pin, struct genl_info *info)
>>>> +{
>>>> +	enum dpll_pin_state state = DPLL_PIN_STATE_UNSPEC;
>>>> +	u32 parent_idx = PIN_IDX_INVALID;
>>>
>>> You just need this PIN_IDX_INVALID define internally in this function,
>>> change the flow to avoid a need for it.
>>>
>>
>>I'll re-think it, thanks.
>>
>>>
>>>> +	int rem, ret = -EINVAL;
>>>> +	struct nlattr *a;
>>>> +
>>>> +	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>>> +			  genlmsg_len(info->genlhdr), rem) {
>>>
>>> This is odd. Why you iterace over attrs? Why don't you just access them
>>> directly, like attrs[DPLL_A_PIN_FREQUENCY] for example?
>>>
>>
>>I had some unknown crashes when I was using such access. I might have lost
>>some
>>checks, will try it again.
>>
>>>
>>>> +		switch (nla_type(a)) {
>>>> +		case DPLL_A_PIN_FREQUENCY:
>>>> +			ret = dpll_pin_freq_set(pin, a, info->extack);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +			break;
>>>> +		case DPLL_A_PIN_DIRECTION:
>>>> +			ret = dpll_pin_direction_set(pin, a, info->extack);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +			break;
>>>> +		case DPLL_A_PIN_PRIO:
>>>> +			ret = dpll_pin_prio_set(dpll, pin, a, info->extack);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +			break;
>>>> +		case DPLL_A_PIN_PARENT_IDX:
>>>> +			parent_idx = nla_get_u32(a);
>>>> +			break;
>>>> +		case DPLL_A_PIN_STATE:
>>>> +			state = nla_get_u8(a);
>>>> +			break;
>>>> +		default:
>>>> +			break;
>>>> +		}
>>>> +	}
>>>> +	if (state != DPLL_PIN_STATE_UNSPEC) {
>>>
>>> Again, change the flow to:
>>> 	if (attrs[DPLL_A_PIN_STATE]) {
>>>
>>> and avoid need for this value set/check.
>>>
>>
>>Yep, will try.
>
>Yes, this shall work now, as long as there are no multiple nested attributes
>coming from userspace.
>
>[...]
>
>>>> +void dpll_pin_post_doit(const struct genl_split_ops *ops, struct
>>>>sk_buff *skb,
>>>> +			struct genl_info *info)
>>>> +{
>>>> +	mutex_unlock(&dpll_pin_xa_lock);
>>>> +	dpll_post_doit(ops, skb, info);
>>>> +}
>>>> +
>>>> +int dpll_pin_pre_dumpit(struct netlink_callback *cb)
>>>> +{
>>>> +	mutex_lock(&dpll_pin_xa_lock);
>>>
>>> ABBA deadlock here, see dpll_pin_register() for example where the lock
>>> taking order is opposite.
>>>
>>
>>Now I see an ABBA deadlock here, as well as in function before. Not sure
>>how to
>>solve it here. Any thoughts?
>>
>
>Not really, this is why it is there :(
>A single global lock for whole dpll subsystem?

Either that or per-instance/device lock.


>
>>>
>>>> +
>>>> +	return dpll_pre_dumpit(cb);
>>>> +}
>>>> +
>>>> +int dpll_pin_post_dumpit(struct netlink_callback *cb)
>>>> +{
>>>> +	mutex_unlock(&dpll_pin_xa_lock);
>>>> +
>>>> +	return dpll_post_dumpit(cb);
>>>> +}
>>>> +
>>>> +static int
>>>> +dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
>>>> +			 struct dpll_pin *pin, struct dpll_pin *parent,
>>>> +			 enum dplla attr)
>>>> +{
>>>> +	int ret = dpll_msg_add_dev_handle(msg, dpll);
>>>> +	struct dpll_pin_ref *ref = NULL;
>>>> +	enum dpll_pin_state state;
>>>> +
>>>> +	if (ret)
>>>> +		return ret;
>>>> +	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>>>> +		return -EMSGSIZE;
>>>
>>> I don't really understand why you are trying figure something new and
>>> interesting with the change notifications. This object mix and random
>>> attrs fillup is something very wrong and makes userspace completely
>>> fuzzy about what it is getting. And yet it is so simple:
>>> You have 2 objects, dpll and pin, please just have:
>>> dpll_notify()
>>> dpll_pin_notify()
>>> and share the attrs fillup code with pin_get() and dpll_get() callbacks.
>>> No need for any smartness. Have this dumb and simple.
>>>
>>> Think about it more as about "object-state-snapshot" than "atomic-change"
>>
>>But with full object-snapshot user space app will lose the information
>>about
>>what exactly has changed. The reason to have this event is to provide the
>>attributes which have changed. Otherwise, the app should have full snapshot
>>and
>>compare all attributes to figure out changes and that's might not be great
>>idea.
>>
>
>I agree that from functional perspective it is better to have on userspace a
>reason of the notification.

I would like to understand why exactly is it better.
But anyway, I was thinking about it a bit more and it might make
sense only the added/changed/deleted attribute to safe some msg space
and getting/parsing cycles. However, it is questionable how much does it
actually save. But you apparently strongly want it, so lets have it

But, the format of the message should be exactly the same as for GET.
Meaning, if some nested attr changes/is added/is removed, the msg should
contain the proper nest same as for the same attr in GET msg. Think of
it as if you assemble the whole GET msg for an object and filter out
things that did not change.

Also need to emphasize strict objects separation, same as for GET.

Also, you have to distinguish between attr being added/removed or the
whole object being added/removed. The userspace has to understand
difference.

So you would have events like:
DEVICE_ADDED
DEVICE_REMOVED
DEVICE_ATTRS_ADDED
DEVICE_ATTRS_CHANGED
DEVICE_ATTRS_REMOVED
PIN_ADDED
PIN_REMOVED
PIN_ATTRS_ADDED
PIN_ATTRS_CHANGED
PIN_ATTRS_REMOVED

This scenario I can imagine working in a sane way.

Makes sense?

Btw, with the whole object snapshot scenario you just have:
DEVICE_NEW (sent for creation and change)
DEVICE_DEL
PIN_NEW (sent for creation and change)
PIN_DEL
And you are fine with it. This is how it's usually done in Netlink.
In fact, do you have examples in kernel code of what you are suggesting?



>
>[...]
>
>Thank you,
>Arkadiusz
>
