Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964336B9A30
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCNPqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjCNPp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:45:58 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8785290D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:45:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h17so763347wrt.8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678808724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hlyp7nrREyg/a0hHUvwNjxDQM8a9Yo9MGnyhTjJAXJ4=;
        b=noeaJDguqKfIh08cy+5zlHvWFslWScBjda+n6hdS13WrqLSjWFT3TFB5MnvHfB3mfn
         6aaiXE6S5ZgLmqEXXQqXS/OF4AI9JWdrdUQtzsZtSqHJwSrq4orjPHqnZAoEveGi97H1
         iFDVwXz7PzUQ2EI564GoRaReRoTS/DYHJX8T7YNSqfWEps1Q8mc0RGj2kFQlc5uxYvTW
         hWq4g8jWVdr8YBJdRobqGcbG/1QDdPhq1ujcfJ9Zi329cLV0oYOjpW6Xr+QJf2Dx+ilt
         6uI/BLW9kKbXyxN3H8oxjrjhAxVL56BL6hgYq4CV/WBA8ex7ScCLbnjJ2TBqeZpafa8t
         YL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hlyp7nrREyg/a0hHUvwNjxDQM8a9Yo9MGnyhTjJAXJ4=;
        b=UzMt+vSUK/yS0uv3Qe3qn63eJadtfs/IBjHqBjOezm4hz70nvIpwFIOJFbkOxdiUvn
         eVeGTsA0FrE964nL5wX9hSqSguoQKnnYH5VFbPS38A4gh8gBL8ajebbW+FZDryFjuJ0/
         nSeDnI6Zr2yGVqtrJM0qOAkfQf7HwEGL54HwrOq+GPDvwmJf+xvhfZ0l54u5TKBUvo7L
         +w8izkv5xC2O8uAvA1nDdjquiZE5KgvBrABqG6qUMkeh3KGuJD/wZPJyPP7jXbTl/6Q7
         TLWcj2aE+W/0t9vUctRKj5a3NgC9MNZcfZx/QTwJJZMGW7zoKuLjnAXVXvJvzhm868oU
         7O5Q==
X-Gm-Message-State: AO0yUKUqmIwTllM1zx0dxQbDCq1tpq5lkGNojqfeR4vcfbjqpcdxmhCF
        CSKAueVGJqGPxjy+ap4Messvtw==
X-Google-Smtp-Source: AK7set9kOQSCt1nILgCoCuDKCZW+ZbwUmc5Jc2ebbeLxsp+0MErUKCOweY8716ROMkP894uRtiidSA==
X-Received: by 2002:a5d:408e:0:b0:2c9:b9bf:e20c with SMTP id o14-20020a5d408e000000b002c9b9bfe20cmr11747197wrp.2.1678808723716;
        Tue, 14 Mar 2023 08:45:23 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m6-20020adff386000000b002c5493a17efsm2345919wro.25.2023.03.14.08.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:45:23 -0700 (PDT)
Date:   Tue, 14 Mar 2023 16:45:22 +0100
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
Message-ID: <ZBCWkhRaUztjMapa@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>diff --git a/MAINTAINERS b/MAINTAINERS
>index edd3d562beee..0222b19af545 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -6289,6 +6289,15 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
> 
>+DPLL CLOCK SUBSYSTEM

Why "clock"? You don't mention "clock" anywhere else.

[...]


>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>new file mode 100644
>index 000000000000..3fc151e16751
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.c
>@@ -0,0 +1,835 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ *  dpll_core.c - Generic DPLL Management class support.

Why "class" ?

[...]


>+static int
>+dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
>+		      struct netlink_ext_ack *extack, bool dump_any_freq)
>+{
>+	enum dpll_pin_freq_supp fs;
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+	u32 freq;
>+
>+	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
>+		if (ref && ref->ops && ref->dpll)
>+			break;
>+	}
>+	if (!ref || !ref->ops || !ref->dpll)
>+		return -ENODEV;
>+	if (!ref->ops->frequency_get)
>+		return -EOPNOTSUPP;
>+	if (ref->ops->frequency_get(pin, ref->dpll, &freq, extack))
>+		return -EFAULT;
>+	if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY, freq))
>+		return -EMSGSIZE;
>+	if (!dump_any_freq)
>+		return 0;
>+	for (fs = DPLL_PIN_FREQ_SUPP_UNSPEC + 1;
>+	     fs <= DPLL_PIN_FREQ_SUPP_MAX; fs++) {
>+		if (test_bit(fs, &pin->prop.freq_supported)) {
>+			if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED,
>+			    dpll_pin_freq_value[fs]))

This is odd. As I suggested in the yaml patch, better to treat all
supported frequencies the same, no matter if it is range or not. The you
don't need this weird bitfield.

You can have a macro to help driver to assemble array of supported
frequencies and ranges.


>+				return -EMSGSIZE;
>+		}
>+	}
>+	if (pin->prop.any_freq_min && pin->prop.any_freq_max) {
>+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MIN,
>+				pin->prop.any_freq_min))
>+			return -EMSGSIZE;
>+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MAX,
>+				pin->prop.any_freq_max))
>+			return -EMSGSIZE;
>+	}
>+
>+	return 0;
>+}
>+

[...]


>+static int
>+dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
>+			 struct dpll_device *dpll,
>+			 struct netlink_ext_ack *extack)
>+{
>+	struct dpll_pin_ref *ref;
>+	int ret;
>+
>+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>+		return -EMSGSIZE;
>+	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
>+		return -EMSGSIZE;
>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
>+		return -EMSGSIZE;
>+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
>+		return -EMSGSIZE;
>+	ret = dpll_msg_add_pin_direction(msg, pin, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>+	if (!ref)

How exactly this can happen? Looks to me like only in case of a bug.
WARN_ON() perhaps (put directly into dpll_xa_ref_dpll_find()?


>+		return -EFAULT;
>+	ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ret = dpll_msg_add_pin_parents(msg, pin, extack);
>+	if (ret)
>+		return ret;
>+	if (pin->rclk_dev_name)

Use && and single if


>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>+				   pin->rclk_dev_name))
>+			return -EMSGSIZE;
>+
>+	return 0;
>+}
>+

[...]


>+static int
>+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
>+		  struct netlink_ext_ack *extack)
>+{
>+	u32 freq = nla_get_u32(a);
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+	int ret;
>+
>+	if (!dpll_pin_is_freq_supported(pin, freq))
>+		return -EINVAL;
>+
>+	xa_for_each(&pin->dpll_refs, i, ref) {
>+		ret = ref->ops->frequency_set(pin, ref->dpll, freq, extack);
>+		if (ret)
>+			return -EFAULT;

return what the op returns: ret


>+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_FREQUENCY);
>+	}
>+
>+	return 0;
>+}
>+

[...]


>+static int
>+dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
>+		       struct netlink_ext_ack *extack)
>+{
>+	enum dpll_pin_direction direction = nla_get_u8(a);
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop.capabilities))
>+		return -EOPNOTSUPP;
>+
>+	xa_for_each(&pin->dpll_refs, i, ref) {
>+		if (ref->ops->direction_set(pin, ref->dpll, direction, extack))

ret = ..
if (ret)
	return ret;

Please use this pattern in other ops call code as well.


>+			return -EFAULT;
>+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_DIRECTION);
>+	}
>+
>+	return 0;

[...]
