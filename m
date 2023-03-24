Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12A6C7B67
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjCXJ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjCXJ3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:29:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C0A18AB9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:29:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id eh3so5188603edb.11
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679650143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXJ1YNbcC6sxgPer8ae1FszGABSLQrMdlXHnXNm+WPE=;
        b=FjoPg5qeIqGeU/oBTXgxVJ9niW0CzJwZ8jIubenpszHugo9uwYCcLWH+0Jt+iU7CiZ
         +c4htM12XFHfXR3ZlXkKSWyN2XBvy2TrbNTLl6t1G8qv+wcPWd+XSuyAinIkQRi7BhyC
         6KYNzlW+BkJAWOetzY5BXNluhWp1ZPj8LVl+lpxtlurajvmXMmS1reN8pmDmtKa/Pwg4
         tZAZugGThN+niFOcz/bA9ZlGLueLKMNu+gXRT4+gcMKA3GotKbj9oWvm7LlJnXfiosit
         KOsnSeWqf8KG+wBCJysD+BsuqtHFOBLHKaOnwKaFfRTsoFZDgDwH6FlIxBmxEPYLYxgp
         2bLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679650143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXJ1YNbcC6sxgPer8ae1FszGABSLQrMdlXHnXNm+WPE=;
        b=5fA1B96R+bt8Cvv3cU4Ejnj82OGhHttwN4Q/50LYosh+bepbTj11palyMAkHAuzMpf
         LcW5DdKVK8rMRw9+KDBB7U6fwBWLauh+/plhNGE5ArIIzXSUn3yk7iO7s0G2QW+vc7iq
         p+yaNokqScKOIdTHRHczCxpJP2WAQUZGwMXkAZ0jjXLGK1GNeLlksSUFHfG5SZ6lxfj1
         0iS9wcWkm/B90R7DxWAcEDRE5EzQ1WN2ctQHhGLU45MTHGzJnrp6grOoRqfjvT3HmUzu
         qRPr2WY4EX+5oIX7Ao3TVPuKoyeX/9w4pN8sPhd+5D7OU/tr1bPs8D0Qcsfcuxcm/TTD
         C8bA==
X-Gm-Message-State: AAQBX9cKSgFoz3AY1GSz+CR2sueSmoPNsQJlkwmLdQZj5HGDyEgrut9/
        mfogvmfX6lklRty9Qkm171cpGg==
X-Google-Smtp-Source: AKy350YHIauhajDhC/4NuJPejujuV/yRpYwlD7rIGrAi2xdw0atMEnHnUWicJHGrCkmTZ2PLnlp6pA==
X-Received: by 2002:a50:ef01:0:b0:4fb:de7d:b05a with SMTP id m1-20020a50ef01000000b004fbde7db05amr1764298eds.40.1679650143228;
        Fri, 24 Mar 2023 02:29:03 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o2-20020a509b02000000b004faa1636758sm10376879edi.68.2023.03.24.02.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 02:29:02 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:29:01 +0100
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
Message-ID: <ZB1tXZZp+g5o7wRM@nanopsycho>
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


>+static int
>+dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin *pin,
>+			   struct netlink_ext_ack *extack)
>+{
>+	enum dpll_pin_direction direction;
>+	struct dpll_pin_ref *ref;
>+	unsigned long i;
>+
>+	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
>+		if (ref && ref->ops && ref->dpll)
>+			break;
>+	}
>+	if (!ref || !ref->ops || !ref->dpll)
>+		return -ENODEV;
>+	if (!ref->ops->direction_get)
>+		return -EOPNOTSUPP;
>+	if (ref->ops->direction_get(pin, ref->dpll, &direction, extack))
>+		return -EFAULT;
>+	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
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

Checking for "ref" is nonsense here, as xa_for_each fills it up
for every iteration.

ref->dpll is always filled. Also pointless check.

Does it make sense to register with ops==NULL? I think we should
forbid it and make this just xa_find(0) to get the first item in the
xarray.

I'm doing this in my patch, as it is dependency on some other patch I do
in this area.


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

Why -EOPNOTSUPP here is not ok, as for the others below?


>+		return ret;
>+	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>+	if (!ref)

How this can happen? I don't think it could.


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
>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>+				   pin->rclk_dev_name))
>+			return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int
>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
>+			struct netlink_ext_ack *extack, bool dump_dpll)
>+{
>+	int ret;
>+
>+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>+		return -EMSGSIZE;
>+	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
>+		return -EMSGSIZE;
>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
>+		return -EMSGSIZE;
>+	ret = dpll_msg_add_pin_direction(msg, pin, extack);
>+	if (ret)
>+		return ret;
>+	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
>+	if (ret && ret != -EOPNOTSUPP)
>+		return ret;
>+	ret = dpll_msg_add_pins_on_pin(msg, pin, extack);
>+	if (ret)
>+		return ret;
>+	if (!xa_empty(&pin->dpll_refs) && dump_dpll) {

How dpll refs could be empty? I don't think it is possible.

Overall, whole the code has very odd habit of checking for conditions
that are obviously impossible to happen. Only confuses reader as he
naturally expects that the check is there for a reason.



>+		ret = dpll_msg_add_pin_dplls(msg, pin, extack);
>+		if (ret)
>+			return ret;
>+	}
>+	if (pin->rclk_dev_name)
>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>+				   pin->rclk_dev_name))
>+			return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
