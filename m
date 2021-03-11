Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA134336D4C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCKHsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhCKHsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 02:48:37 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4F5C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 23:48:36 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso12563631wma.4
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 23:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nwm91IEvGZkfgj6uykvylon1QZQCNxzxbiY5K8O34LY=;
        b=yU9DAiFa2TkSrssKRlV/oe64MfnSCDt5bGeZlI8QlvPII/nnSYNbYL/JNCNA5WRmKn
         ecVvupcdqkCE8qzHmUByckuXumDKloLXGmmDOIBnUUwCbXbMfocuXtE+nWYC0gHSHgTY
         W1r1C/q6yVAzXdd2S8Nk3txh49K2iuKBvhWvgVrb/USyEaENxkoocL7SryVQRMVn0veG
         vKxuR8SN2c0jyLzfCxaz88qlim8/ud3Z0Iup5MRgtx3+gf8y8N0cQYsnC0/xGY/A7Kgt
         aDza9pS3raUCmPBoLDuMtzzLIxw2vK0DjFPS7LSOrNH7QSKSbM5lwjTZmK5At4yh4kLp
         wB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nwm91IEvGZkfgj6uykvylon1QZQCNxzxbiY5K8O34LY=;
        b=TG51NmtawAqaYwYCtImSoQa5a7rzI9BHs5MCdDIPuN1GBvWlQXMVPgrOq6csgw/Rer
         xF55szKGQoG91KGfwcufmgvZpggkbGKsy4ro3NvzxfWRfa4HlXyD9xF4gmJCWOZAONTV
         xuNR0R7Ml4Hcqe3jCMrvh9JLQKhsozv6Y0DxUVw9eUXxhtsutFmaqYs9D/F2KMR4lxuH
         kB448Gew8WWGd0imtF9kpbd/Er2KDOMkPX2OP2mmjFvnFanXsxuF0ioQcI96UMEu0m+h
         8LfWMTjaK079juPJI5aLxY3cPfRHg68X/v7x4EGtXAM6pDD8TJCPUQBpkCqHtai3bwv0
         6Q8w==
X-Gm-Message-State: AOAM532iiKNrvvsjGNu7cvbFoh4QdR5TKuy6OflUxpQB4rU6QrWK5ALf
        4lwjAPXI5c2IypAbiWTjOeof9A==
X-Google-Smtp-Source: ABdhPJxUBpOXo/ZviotdcV6STOilHvFMyIYK/s4g02gx+WDKCAUhjO5UxM5VQAdN2tbLIjiy4xFxVQ==
X-Received: by 2002:a7b:c1c9:: with SMTP id a9mr6690425wmj.145.1615448914939;
        Wed, 10 Mar 2021 23:48:34 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b17sm2347781wrt.17.2021.03.10.23.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 23:48:34 -0800 (PST)
Date:   Thu, 11 Mar 2021 08:48:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     f242ed68-d31b-527d-562f-c5a35123861a@intel.com
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC net-next v2 2/3] devlink: health: add remediation type
Message-ID: <20210311074833.GO4652@nanopsycho.orion>
References: <20210311032613.1533100-1-kuba@kernel.org>
 <20210311032613.1533100-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311032613.1533100-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 11, 2021 at 04:26:12AM CET, kuba@kernel.org wrote:
>Currently devlink health does not give user any clear information
>of what kind of remediation ->recover callback will perform. This
>makes it difficult to understand the impact of enabling auto-
>-remediation, and the severity of the error itself.
>
>To allow users to make more informed decision add a new remediation
>type attribute.
>
>Note that we only allow one remediation type per reporter, this
>is intentional. devlink health is not built for mixing issues
>of different severity into one reporter since it only maintains
>one dump, of the first event and a single error counter.
>Nudging vendors towards categorizing issues beyond coarse
>groups is an added bonus.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> include/net/devlink.h        |  2 ++
> include/uapi/linux/devlink.h | 25 +++++++++++++++++++++++++
> net/core/devlink.c           |  7 ++++++-
> 3 files changed, 33 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index b424328af658..72b37769761f 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -659,6 +659,7 @@ struct devlink_health_reporter;
> /**
>  * struct devlink_health_reporter_ops - Reporter operations
>  * @name: reporter name
>+ * remedy: severity of the remediation required
>  * @recover: callback to recover from reported error
>  *           if priv_ctx is NULL, run a full recover
>  * @dump: callback to dump an object
>@@ -669,6 +670,7 @@ struct devlink_health_reporter;
> 
> struct devlink_health_reporter_ops {
> 	char *name;
>+	enum devlink_health_remedy remedy;
> 	int (*recover)(struct devlink_health_reporter *reporter,
> 		       void *priv_ctx, struct netlink_ext_ack *extack);
> 	int (*dump)(struct devlink_health_reporter *reporter,
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 41a6ea3b2256..8cd1508b525b 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -534,6 +534,9 @@ enum devlink_attr {
> 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
> 
> 	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
>+
>+	DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,	/* u32 */
>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>@@ -620,4 +623,26 @@ enum devlink_health_state {
> 	DL_HEALTH_STATE_ERROR,
> };
> 
>+/**
>+ * enum devlink_health_reporter_remedy - severity of remediation procedure
>+ * @DL_HEALTH_REMEDY_NONE: transient error, no remediation required
>+ * @DL_HEALTH_REMEDY_KICK: device stalled, processing will be re-triggered
>+ * @DL_HEALTH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
>+ *			will be reset
>+ * @DL_HEALTH_REMEDY_RESET: full device reset, will result in temporary
>+ *			unavailability of the device, device configuration
>+ *			should not be lost
>+ * @DL_HEALTH_REMEDY_REINIT: device will be reinitialized and configuration lost
>+ *
>+ * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
>+ * by the severity of the remediation.
>+ */
>+enum devlink_health_remedy {
>+	DL_HEALTH_REMEDY_NONE = 1,
>+	DL_HEALTH_REMEDY_KICK,
>+	DL_HEALTH_REMEDY_COMP_RESET,
>+	DL_HEALTH_REMEDY_RESET,
>+	DL_HEALTH_REMEDY_REINIT,

It is nice if enum name and values are consistent:
enum something {
	SOMETHING_*


>+};
>+
> #endif /* _UAPI_LINUX_DEVLINK_H_ */
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 8e4e4bd7bb36..09d77d43ff63 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
> {
> 	struct devlink_health_reporter *reporter;
> 
>-	if (WARN_ON(graceful_period && !ops->recover))
>+	if (WARN_ON(graceful_period && !ops->recover) ||
>+	    WARN_ON(ops->recover && !ops->remedy))
> 		return ERR_PTR(-EINVAL);
> 
> 	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
>@@ -6265,6 +6266,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
> 	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
> 			   reporter->ops->name))
> 		goto reporter_nest_cancel;
>+	if (reporter->ops->remedy &&
>+	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
>+			reporter->ops->remedy))
>+		goto reporter_nest_cancel;
> 	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
> 		       reporter->health_state))
> 		goto reporter_nest_cancel;
>-- 
>2.29.2
>
