Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5DF3F23BC
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 01:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhHSXhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 19:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhHSXg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 19:36:58 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0920CC061760
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:36:22 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id h133so5615069oib.7
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HTR1NAMnxq8tF5WhlJMpotqIGROeP6GqPvumdcju0fo=;
        b=MOe0Xa5k++pyt5Bm2ing/pbqT0IawY7nGsBZmbMlHPjnYPM1WrHVKWCMIr7HQhtCJq
         OX6dGUUq9zlTj1tO7r6hyQu1oNrmJvT3/RqeDXmJf0wZi9neVohctcYj/z0nVCuDyLU5
         uVWz/XpZjWrcHsAiHuoAMTq4xh1+ub6Wjho6DQcXQGNSmlicUeR8CJMuV7CUdx+pTq3n
         zdR/EJevxLLwqj50b/QBw7u8mvDdc3xb9j4oizi0ZuRDj3ZkMgvj4beZCQar+zO6fU7G
         qIeFzfLtvOy9UghbjQmaIPjHB0N7bza7buN5JPqmyCFnpkvW0ZTvIQZqp2IWcNPitIx5
         CotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HTR1NAMnxq8tF5WhlJMpotqIGROeP6GqPvumdcju0fo=;
        b=hXbsUfxcDZI932mBb95K4YoTdRTBsuLqA2ViVEvuRcSwLc5MsKLUWbOWgGsVOZpukN
         DIWh614p+tP865PfzCUPhID648FyVaO9LzRmIo+Jd5N+OL+ZW3JsS5CvX389zTaJz1xK
         my1naci0Sq83pr0fRVvaDZh/RGyd01HAoBPaCLtjX4FEWPsUatKMLVF19XM+Aoe3nqHf
         //U7uau3b1KXFcRXArZ8+7SZqaZO7jaF/CwBVqq0gRaxxzu/R+Pt3YE+W1MqFBRy6P6Y
         MQC0E0OFP25RXKXkPi6mPBqQIW20/z18X/ROxYhSB66+JGDoH/LSUUqSl1gpMeQmeYNu
         322g==
X-Gm-Message-State: AOAM5319k+QfkjkaMhnpOiSFg4rd9pFH0Yo7WM6bwyhD5dahPj8rGc+Q
        O/5gWJIqmiFi/IWxmLVdcPrwug==
X-Google-Smtp-Source: ABdhPJwkI1cWOTvjEK/I228vAx5ccb8Ct2GItdTUAVPg5QglnTuNyRrVow9whuDHmMaZY1eXTyR9Lg==
X-Received: by 2002:aca:3e45:: with SMTP id l66mr897856oia.79.1629416181184;
        Thu, 19 Aug 2021 16:36:21 -0700 (PDT)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id v19sm948301oic.31.2021.08.19.16.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 16:36:20 -0700 (PDT)
Date:   Thu, 19 Aug 2021 16:37:43 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 01/15] power: add power sequencer subsystem
Message-ID: <YR7rR6d4nSRea1oX@ripper>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
 <20210817005507.1507580-2-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817005507.1507580-2-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 16 Aug 17:54 PDT 2021, Dmitry Baryshkov wrote:

> Basing on MMC's pwrseq support code, add separate power sequencer
> subsystem. It will be used by other drivers to handle device power up
> requirements.
> 

Some more background to why we need a pwrseq framework wouldn't hurt.

[..]
> diff --git a/drivers/power/pwrseq/core.c b/drivers/power/pwrseq/core.c
> new file mode 100644
> index 000000000000..20485cae29aa
> --- /dev/null
> +++ b/drivers/power/pwrseq/core.c
> @@ -0,0 +1,411 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Copyright 2021 (c) Linaro Ltd.
> +// Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> +//
> +// Based on phy-core.c:
> +// Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com

The typical format is:

// SPDX using C++ style comment
/*
 * Copyright stuff using C style comment
 */

> +
> +#include <linux/device.h>
> +#include <linux/idr.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pwrseq/consumer.h>
> +#include <linux/pwrseq/driver.h>
> +#include <linux/slab.h>
> +
> +#define	to_pwrseq(a)	(container_of((a), struct pwrseq, dev))

No need for the extra parenthesis around container_of()

> +
> +static DEFINE_IDA(pwrseq_ida);
> +static DEFINE_MUTEX(pwrseq_provider_mutex);
> +static LIST_HEAD(pwrseq_provider_list);
> +
> +struct pwrseq_provider {
> +	struct device		*dev;
> +	struct module		*owner;
> +	struct list_head	list;
> +	void			*data;
> +	struct pwrseq * (*of_xlate)(void *data, struct of_phandle_args *args);
> +};
> +
> +void pwrseq_put(struct device *dev, struct pwrseq *pwrseq)
> +{
> +	device_link_remove(dev, &pwrseq->dev);
> +
> +	module_put(pwrseq->owner);
> +	put_device(&pwrseq->dev);
> +}
> +EXPORT_SYMBOL_GPL(pwrseq_put);
> +
> +static struct pwrseq_provider *of_pwrseq_provider_lookup(struct device_node *node)
> +{
> +	struct pwrseq_provider *pwrseq_provider;
> +
> +	list_for_each_entry(pwrseq_provider, &pwrseq_provider_list, list) {
> +		if (pwrseq_provider->dev->of_node == node)
> +			return pwrseq_provider;
> +	}
> +
> +	return ERR_PTR(-EPROBE_DEFER);
> +}
> +
> +static struct pwrseq *_of_pwrseq_get(struct device *dev, const char *id)
> +{
> +	struct pwrseq_provider *pwrseq_provider;
> +	struct pwrseq *pwrseq;
> +	struct of_phandle_args args;
> +	char prop_name[64]; /* 64 is max size of property name */
> +	int ret;
> +
> +	snprintf(prop_name, 64, "%s-pwrseq", id);

sizeof(prop_name), to avoid giving others a chance to "fix" it later?

> +	ret = of_parse_phandle_with_args(dev->of_node, prop_name, "#pwrseq-cells", 0, &args);
> +	if (ret) {
> +		struct device_node *dn;
> +
> +		/*
> +		 * Parsing failed. Try locating old bindings for mmc-pwrseq,
> +		 * which did not use #pwrseq-cells.
> +		 */
> +		if (strcmp(id, "mmc"))
> +			return ERR_PTR(-ENODEV);
> +
> +		dn = of_parse_phandle(dev->of_node, prop_name, 0);
> +		if (!dn)
> +			return ERR_PTR(-ENODEV);
> +
> +		args.np = dn;
> +		args.args_count = 0;
> +	}
> +
> +	mutex_lock(&pwrseq_provider_mutex);
> +	pwrseq_provider = of_pwrseq_provider_lookup(args.np);
> +	if (IS_ERR(pwrseq_provider) || !try_module_get(pwrseq_provider->owner)) {
> +		pwrseq = ERR_PTR(-EPROBE_DEFER);
> +		goto out_unlock;
> +	}
> +
> +	if (!of_device_is_available(args.np)) {
> +		dev_warn(pwrseq_provider->dev, "Requested pwrseq is disabled\n");
> +		pwrseq = ERR_PTR(-ENODEV);
> +		goto out_put_module;
> +	}
> +
> +	pwrseq = pwrseq_provider->of_xlate(pwrseq_provider->data, &args);
> +
> +out_put_module:
> +	module_put(pwrseq_provider->owner);
> +
> +out_unlock:
> +	mutex_unlock(&pwrseq_provider_mutex);
> +	of_node_put(args.np);
> +
> +	return pwrseq;
> +}
> +
[..]
> +int pwrseq_pre_power_on(struct pwrseq *pwrseq)
> +{
> +	if (pwrseq && pwrseq->ops->pre_power_on)
> +		return pwrseq->ops->pre_power_on(pwrseq);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pwrseq_pre_power_on);
> +
> +int pwrseq_power_on(struct pwrseq *pwrseq)

Wouldn't it make sense to refcount the power on/off operations and at
least warn about unbalanced disables?

My concern is related to the qca-driver's reliance on the regulator
framework to refcount the on/off of the shared resources and additional
power_off from either the WiFi or BT client would result in the other
client getting its power disabled unexpectedly - which might be
annoying to debug.

> +{
> +	if (pwrseq && pwrseq->ops->power_on)
> +		return pwrseq->ops->power_on(pwrseq);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pwrseq_power_on);
> +
> +void pwrseq_power_off(struct pwrseq *pwrseq)
> +{
> +	if (pwrseq && pwrseq->ops->power_off)
> +		pwrseq->ops->power_off(pwrseq);
> +}
> +EXPORT_SYMBOL_GPL(pwrseq_power_off);
> +
> +void pwrseq_reset(struct pwrseq *pwrseq)
> +{
> +	if (pwrseq && pwrseq->ops->reset)
> +		pwrseq->ops->reset(pwrseq);
> +}
> +EXPORT_SYMBOL_GPL(pwrseq_reset);
> +

Regards,
Bjorn
