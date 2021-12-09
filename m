Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFC346E573
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhLIJZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236067AbhLIJZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:25:40 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29F7C061A72
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 01:22:06 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j3so8574166wrp.1
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 01:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MTOnfkZY8CBRwH1AHz5th507aRv/FFnDH2cUFSg6uGQ=;
        b=dk1bbrQx1CBw/5WYiHQqsIIcQUEUI7KgTP8xxkDEWU9zyXwMHUx0uvAT68WVY1m94S
         +/7xjxdlhqMmlq+hbCwk0wu5tW62uwY5UQqI0ZiryPali/BkwSXWsbvcwfca9QIMQ571
         8ixe+whtP99NMKmP2Mvq4nSoRR7+djcjv4x4e2NuBgqDbhUXnD4ffOKlwUumMySfCZ/L
         qhvAAmOhJ5zJn3gXRjHHArr839gKadzwRaMyxcQjhPOskwYuiTKn5Wh77CCAc3IHE4VY
         wivFio5TQ82iT+Cc/TDW/7/TqYbt9kZNkWHfHxXdxJlGvTlvzXA5g6aETzegIi02wNNK
         uwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MTOnfkZY8CBRwH1AHz5th507aRv/FFnDH2cUFSg6uGQ=;
        b=sl3d8LXDRzyeP/Opu9Sm/FGKYEmrbU14om/Wf6jGsuDHc8nr3Bz2m2eUTGAQA9hzBe
         TFEC6iYBLdO/cAEYqPnCM2PTGrFN166eHG5e7J5yJScwZlX1APwH+yTtYO5w9Z/VsguB
         rCnKIgBBDpbWyWLaq2cw01Jvza4Sq+xDgVPL3Xv0ej6fqxsmfBk6Q+wIKqukEUGyCyui
         qEAHl+bsAHXCOMFT47Sn6/aHR4K4kQ7S8XyqfnnOqRaT5Zsj1duRO5Un9b0KD1VxHvZU
         qi1kMFTxYmMGJW3CeK9Pi5nYIVQRiOAZ6CtF9+4DopSACxA9v3629ZxPAiIMbJ7o29aY
         JYEQ==
X-Gm-Message-State: AOAM532eaj0DGzupAmlKyajy58cM92VBfuKW00ysVfXTyVXv88EfSsbS
        QrNewS8ZfUssAX46gQhrHgW3oA==
X-Google-Smtp-Source: ABdhPJyCvQyVPWTYy/xPjzdlIgg5B5w8V9A0ghTOZ6dq0p9Y7CHeyVECOMe3m/p6jE2DhzRIfMhh8Q==
X-Received: by 2002:adf:c605:: with SMTP id n5mr5224846wrg.564.1639041725408;
        Thu, 09 Dec 2021 01:22:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p2sm8507951wmq.23.2021.12.09.01.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 01:22:05 -0800 (PST)
Date:   Thu, 9 Dec 2021 10:22:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shay Drory <shayd@nvidia.com>, g@nanopsycho
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v3 4/7] devlink: Add new "event_eq_size" generic
 device param
Message-ID: <YbHKvDY9qbo1rwgd@nanopsycho>
References: <20211208141722.13646-1-shayd@nvidia.com>
 <20211208141722.13646-5-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208141722.13646-5-shayd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 08, 2021 at 03:17:19PM CET, shayd@nvidia.com wrote:
>Add new device generic parameter to determine the size of the
>asynchronous control events EQ.
>
>For example, to reduce event EQ size to 64, execute:
>$ devlink dev param set pci/0000:06:00.0 \
>              name event_eq_size value 64 cmode driverinit
>$ devlink dev reload pci/0000:06:00.0
>
>Signed-off-by: Shay Drory <shayd@nvidia.com>
>Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>---
> Documentation/networking/devlink/devlink-params.rst | 3 +++
> include/net/devlink.h                               | 4 ++++
> net/core/devlink.c                                  | 5 +++++
> 3 files changed, 12 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>index cd9342305a13..0eddee6e66f3 100644
>--- a/Documentation/networking/devlink/devlink-params.rst
>+++ b/Documentation/networking/devlink/devlink-params.rst
>@@ -132,3 +132,6 @@ own name.
>    * - ``io_eq_size``
>      - u16
>      - Control the size of I/O completion EQs.
>+   * - ``event_eq_size``
>+     - u16

And this.


>+     - Control the size of asynchronous control events EQ.
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index b5f4acd0e0cd..8d5349d2fb68 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -460,6 +460,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
> 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
>+	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -515,6 +516,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
> #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
> 
>+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
>+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 0d4e63d11585..d9f3c994e704 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4471,6 +4471,11 @@ static const struct devlink_param devlink_param_generic[] = {
> 		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
>+		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>2.21.3
>
