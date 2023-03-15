Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34696BB65B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjCOOnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjCOOnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:43:18 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F2260D40
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:43:15 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so1240691wmb.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678891394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G/vajOgVJDGRyPsxvLCJVF/iXOTJH808d6bXOCfkt/4=;
        b=Xc/mE1ze/aKwECzjVQuYYFfcwJPstGHaCM8oGgRmksCbJrKA+J0LGug3x42Xewk34o
         j031ICgUVeeq30dUFXMk2tcMZkWmI/ztwTq6Apecy1LA5Vfg7d41PoHxgtig2QLjZIG1
         vK91xzTghoD4d1KqiKRIKkKgaXZaNufR3R1PMfI46kH3D6SWFZq/8bVrfKAm58ymmolF
         AITe9/1pAofnnka0RNKJbYDLzg08SvGFZPI866mi/zJvP8ZQEeWL9MOUHxiLDHLmMYKw
         yJnSlUmLY6kX72ppy27330uJ8FY5cB4a4YYZFoFxkMsbIsV8gnm+Oum2KNjpB/qAWouI
         yBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678891394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G/vajOgVJDGRyPsxvLCJVF/iXOTJH808d6bXOCfkt/4=;
        b=TIPE76Mn3bpZMn1bkFx0tWO5oNDZnO4Xvv81W3eZmPe4HMwNQ4dWYpJ5neem/KfMrN
         vbB6Cz0O5QfG7lvHjgz7vGBiiIrjiELZxtKv2guwXYb900cuhSvTC/IB9bIuViQs2Xhk
         ixp+O6o8kzIpiCKvQKG7pkf7L80y146KYIbvCfpB2MewscND+U1cw6lcoZ77wp2p5ucB
         c9LXqVJtM2UrptjgeZ3aoiUC9U1jXW9J1FuQ29oM0lsOQgY7jPxTLhCyJt59A8Phl7zg
         bJs/4BUsW6C0242DNpnr3mqQGl/kfoOHBumFcnro5z0typh4mNKo3AGQPKCCY8T7PZdh
         X3BA==
X-Gm-Message-State: AO0yUKXSVepY7Azjm2q1vvLf3IHpnMiQ4Lw7HOoM+H70uuGMeMQdTkv2
        jRBn3AE3M8+EKaJULv9a5uNxhw==
X-Google-Smtp-Source: AK7set8RNWBOtRp7eGHGijYKEIg//aBJ8DcuA/QvJ1qGKHco6K1DLauD56YV7b5Z67TmzNwKaX1WFA==
X-Received: by 2002:a05:600c:198e:b0:3eb:2f3b:4477 with SMTP id t14-20020a05600c198e00b003eb2f3b4477mr17709955wmq.28.1678891393663;
        Wed, 15 Mar 2023 07:43:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y16-20020a05600c365000b003ed23845666sm2003884wmq.45.2023.03.15.07.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 07:43:06 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:43:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBHZd6Ldtu+TPE8w@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
 <ZBCWkhRaUztjMapa@nanopsycho>
 <DM6PR11MB4657175A833B5DD7B84D54269BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657175A833B5DD7B84D54269BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 14, 2023 at 07:35:55PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Tuesday, March 14, 2023 4:45 PM
>>
>>[...]
>>
>>
>>>diff --git a/MAINTAINERS b/MAINTAINERS
>>>index edd3d562beee..0222b19af545 100644
>>>--- a/MAINTAINERS
>>>+++ b/MAINTAINERS
>>>@@ -6289,6 +6289,15 @@ F:
>>	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/swit
>>ch-drive
>>> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
>>> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
>>>
>>>+DPLL CLOCK SUBSYSTEM
>>
>>Why "clock"? You don't mention "clock" anywhere else.
>>
>>[...]
>>
>>
>>>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>>>new file mode 100644
>>>index 000000000000..3fc151e16751
>>>--- /dev/null
>>>+++ b/drivers/dpll/dpll_core.c
>>>@@ -0,0 +1,835 @@
>>>+// SPDX-License-Identifier: GPL-2.0
>>>+/*
>>>+ *  dpll_core.c - Generic DPLL Management class support.
>>
>>Why "class" ?
>>
>>[...]
>>
>>
>>>+static int
>>>+dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
>>>+		      struct netlink_ext_ack *extack, bool dump_any_freq)
>>>+{
>>>+	enum dpll_pin_freq_supp fs;
>>>+	struct dpll_pin_ref *ref;
>>>+	unsigned long i;
>>>+	u32 freq;
>>>+
>>>+	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
>>>+		if (ref && ref->ops && ref->dpll)
>>>+			break;
>>>+	}
>>>+	if (!ref || !ref->ops || !ref->dpll)
>>>+		return -ENODEV;
>>>+	if (!ref->ops->frequency_get)
>>>+		return -EOPNOTSUPP;
>>>+	if (ref->ops->frequency_get(pin, ref->dpll, &freq, extack))
>>>+		return -EFAULT;
>>>+	if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY, freq))
>>>+		return -EMSGSIZE;
>>>+	if (!dump_any_freq)
>>>+		return 0;
>>>+	for (fs = DPLL_PIN_FREQ_SUPP_UNSPEC + 1;
>>>+	     fs <= DPLL_PIN_FREQ_SUPP_MAX; fs++) {
>>>+		if (test_bit(fs, &pin->prop.freq_supported)) {
>>>+			if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED,
>>>+			    dpll_pin_freq_value[fs]))
>>
>>This is odd. As I suggested in the yaml patch, better to treat all
>>supported frequencies the same, no matter if it is range or not. The you
>>don't need this weird bitfield.
>>
>>You can have a macro to help driver to assemble array of supported
>>frequencies and ranges.
>>
>
>I understand suggestion on yaml, but here I am confused.
>How do they relate to the supported frequency passed between driver and dpll
>subsystem?
>This bitfield is not visible to the userspace, and sure probably adding macro
>can be useful.

My point is to avoid the bitfield and to treat supported frequencies and
ranges in the same way. It can look similar to this:

in dpll.h:

struct struct dpll_pin_frequency {
	u64 min;
	u64 max;
};

#define DPLL_PIN_FREQUENCY_RANGE(_min, _mac)	\
	{					\
		.min = _min,			\
		.max = _max,			\
	}

#define DPLL_PIN_FREQUENCY(_val) DPLL_PIN_FREQUENCY_RANGE(_val, _val)
#define DPLL_PIN_FREQUENCY_1PPS DPLL_PIN_FREQUENCY(1)
#define DPLL_PIN_FREQUENCY_10MHZ DPLL_PIN_FREQUENCY(1000000)


Then in driver you have:

static const struct dpll_pin_frequency pcp_dpll_pin_freqs[] = {
	DPLL_PIN_FREQUENCY_1PPS,
	DPLL_PIN_FREQUENCY_10MHZ,
	DPLL_PIN_FREQUENCY(4000000),
	DPLL_PIN_FREQUENCY_RANGE(500, 1000),
	DPLL_PIN_FREQUENCY_RANGE(9000, 10000),
};

static const struct dpll_pin_properties pcp_dpll_pin_props = {
	.label = "SMA",
	.frequencies_supported = pcp_dpll_pin_freqs,
	.frequencies_supported_count = ARRAY_SIZE(pcp_dpll_pin_freqs),
	.type = DPLL_PIN_TYPE_EXT,
	.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
};


Then the dpll core could very easily iterate over .frequencies_supported
array and dump the supported values and ranges to user in uniform way.


>
>>
>>>+				return -EMSGSIZE;
>>>+		}
>>>+	}
>>>+	if (pin->prop.any_freq_min && pin->prop.any_freq_max) {
>>>+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MIN,
>>>+				pin->prop.any_freq_min))
>>>+			return -EMSGSIZE;
>>>+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MAX,
>>>+				pin->prop.any_freq_max))
>>>+			return -EMSGSIZE;
>>>+	}
>>>+
>>>+	return 0;
>>>+}
>>>+
>>
>>[...]
>>
>>
>>>+static int
>>>+dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
>>>+			 struct dpll_device *dpll,
>>>+			 struct netlink_ext_ack *extack)
>>>+{
>>>+	struct dpll_pin_ref *ref;
>>>+	int ret;
>>>+
>>>+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>>>+		return -EMSGSIZE;
>>>+	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
>>>+		return -EMSGSIZE;
>>>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
>>>+		return -EMSGSIZE;
>>>+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
>>>+		return -EMSGSIZE;
>>>+	ret = dpll_msg_add_pin_direction(msg, pin, extack);
>>>+	if (ret)
>>>+		return ret;
>>>+	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
>>>+	if (ret && ret != -EOPNOTSUPP)
>>>+		return ret;
>>>+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>>>+	if (!ref)
>>
>>How exactly this can happen? Looks to me like only in case of a bug.
>>WARN_ON() perhaps (put directly into dpll_xa_ref_dpll_find()?
>
>Yes, makes sense.
>
>>
>>
>>>+		return -EFAULT;
>>>+	ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
>>>+	if (ret && ret != -EOPNOTSUPP)
>>>+		return ret;
>>>+	ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
>>>+	if (ret && ret != -EOPNOTSUPP)
>>>+		return ret;
>>>+	ret = dpll_msg_add_pin_parents(msg, pin, extack);
>>>+	if (ret)
>>>+		return ret;
>>>+	if (pin->rclk_dev_name)
>>
>>Use && and single if
>>
>
>Make sense to me.
>
>>
>>>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>>>+				   pin->rclk_dev_name))
>>>+			return -EMSGSIZE;
>>>+
>>>+	return 0;
>>>+}
>>>+
>>
>>[...]
>>
>>
>>>+static int
>>>+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
>>>+		  struct netlink_ext_ack *extack)
>>>+{
>>>+	u32 freq = nla_get_u32(a);
>>>+	struct dpll_pin_ref *ref;
>>>+	unsigned long i;
>>>+	int ret;
>>>+
>>>+	if (!dpll_pin_is_freq_supported(pin, freq))
>>>+		return -EINVAL;
>>>+
>>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>>+		ret = ref->ops->frequency_set(pin, ref->dpll, freq, extack);
>>>+		if (ret)
>>>+			return -EFAULT;
>>
>>return what the op returns: ret
>
>Why would we return here a driver return code, userspace can have this info
>from extack. IMHO return values of dpll subsystem shall be not dependent on
>what is returned from the driver.

Why not to return it? The driver had some problem, errno suggests what
that was. It is completely desired to pass that along and actually,
it's been done like this in the rest of the netlink ops I can think of.
Why would you want to hide it? Extack carries string message,
not related to this directly.


>
>>
>>
>>>+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_FREQUENCY);
>>>+	}
>>>+
>>>+	return 0;
>>>+}
>>>+
>>
>>[...]
>>
>>
>>>+static int
>>>+dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
>>>+		       struct netlink_ext_ack *extack)
>>>+{
>>>+	enum dpll_pin_direction direction = nla_get_u8(a);
>>>+	struct dpll_pin_ref *ref;
>>>+	unsigned long i;
>>>+
>>>+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop.capabilities))
>>>+		return -EOPNOTSUPP;
>>>+
>>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>>+		if (ref->ops->direction_set(pin, ref->dpll, direction, extack))
>>
>>ret = ..
>>if (ret)
>>	return ret;
>>
>>Please use this pattern in other ops call code as well.
>>
>
>This is the same as above (return code by driver) explanation.

Same reply as above.


>
>>
>>>+			return -EFAULT;
>>>+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_DIRECTION);
>>>+	}
>>>+
>>>+	return 0;
>>
>>[...]
>
>Thanks,
>Arkadiusz
