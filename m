Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF2F690D69
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjBIPom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjBIPoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:44:18 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A41F65660
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id dr8so7507366ejc.12
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNhlImrbcyyA3aOWoJ4bCR98Sw0/TarBltnda5ZH4o0=;
        b=2DX8upXew+ivvqfB8ftQtISe0fhl6krJ6Joq/djm12jzd3E8SWVf67k6IatqbWqI8Z
         isDb55TAbfRAGAnrC5BrolxrYbnU20VXs71s+0SvAYrLKUfNu1Fh6pLLV9WbOulwMMrL
         jni3sSUTnBRK9QsM4cjFtEOkgOUtSJNYWaUDE5CH/zRg3BrNw4GaRoeQpYRmXm7M5xjk
         BveKOmcqhp8UolmW2GmBk8BZV9C7N7F467tYvgufHBHkTwSjo38RCE2v3dFETOupuiPT
         jESjLD7C/U24bn8IERq3hAB9XnUFL9wfH1qQDoheFltHKdZ01IIhfKsly/TSb64SVQ/4
         WaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNhlImrbcyyA3aOWoJ4bCR98Sw0/TarBltnda5ZH4o0=;
        b=TvoErXINYLgM5RnT5Z6zpSlzB1a5ucEIZsyNCBajOQ9TifKQ22hiP2kTm0LK6WZ83R
         hM9xCADg5gD4sEo4LYujJftAziTnqmOSqQcIKGePTS8cK5tmNkpv0VmuZPvoCCXdoc7k
         ySOE0knMVKe91kc2hv/0JCQOnzd9wS1No04g2NebWLhDw6zlDpFs5x0KtpsFQlfBJVtJ
         rOXwgfJ27w7gYekgpC5EP9UV4OYtvR/omZmE0aIED/JFADparP6F+2TV+9z2a5cFcZcn
         W0B1Uo84OrFax4KbHaF1O9SEA6snd0ZT/+1NkOCzg/SKqwn+Us6L0GNqgsE/8VYlvNa4
         /SEQ==
X-Gm-Message-State: AO0yUKXW4W115FT7o3dZrL/Ngi/DxzkyPranto5MHBDECDkZh4FnhRHl
        GWTc/Xpbd5QNXZn7RZg55h7GtLNuFTBnO22zd6A=
X-Google-Smtp-Source: AK7set8NU2ecXTTZ5FUwOiOEC9UrMC3RBU4LwTTCf7uA/ZH2PbfrZ4iYbFd2pp3IWUa++uvjVfWrPw==
X-Received: by 2002:a17:907:a45:b0:8af:1a8c:f13f with SMTP id be5-20020a1709070a4500b008af1a8cf13fmr7599950ejc.71.1675957405681;
        Thu, 09 Feb 2023 07:43:25 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s20-20020a170906061400b0088ba2de323csm1005815ejb.181.2023.02.09.07.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:24 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 6/7] devlink: allow to call devl_param_driverinit_value_get() without holding instance lock
Date:   Thu,  9 Feb 2023 16:43:07 +0100
Message-Id: <20230209154308.2984602-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

If the driver maintains following basic sane behavior, the
devl_param_driverinit_value_get() function could be called without
holding instance lock:

1) Driver ensures a call to devl_param_driverinit_value_get() cannot
   race with registering/unregistering the parameter with
   the same parameter ID.
2) Driver ensures a call to devl_param_driverinit_value_get() cannot
   race with devl_param_driverinit_value_set() call with
   the same parameter ID.
3) Driver ensures a call to devl_param_driverinit_value_get() cannot
   race with reload operation.

By the nature of params usage, these requirements should be
trivially achievable. If the driver for some off reason
is not able to comply, it has to take the devlink->lock while
calling devl_param_driverinit_value_get().

Remove the lock assertion and add comment describing
the locking requirements.

This fixes a splat in mlx5 driver introduced by the commit
referenced in the "Fixes" tag.

Lore: https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/
Reported-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 075935f0ae0f ("devlink: protect devlink param list by instance lock")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 805c2b7ff468..775adcaa8824 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9624,14 +9624,23 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
  *
  *	This function should be used by the driver to get driverinit
  *	configuration for initialization after reload command.
+ *
+ *	Note that lockless call of this function relies on the
+ *	driver to maintain following basic sane behavior:
+ *	1) Driver ensures a call to this function cannot race with
+ *	   registering/unregistering the parameter with the same parameter ID.
+ *	2) Driver ensures a call to this function cannot race with
+ *	   devl_param_driverinit_value_set() call with the same parameter ID.
+ *	3) Driver ensures a call to this function cannot race with
+ *	   reload operation.
+ *	If the driver is not able to comply, it has to take the devlink->lock
+ *	while calling this.
  */
 int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				    union devlink_param_value *val)
 {
 	struct devlink_param_item *param_item;
 
-	lockdep_assert_held(&devlink->lock);
-
 	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 		return -EOPNOTSUPP;
 
-- 
2.39.0

