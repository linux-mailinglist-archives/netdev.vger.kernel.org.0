Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D33616974A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgBWLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:01:50 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41227 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWLBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:01:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so6992588wrw.8
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 03:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nNPrsHRgMBJ28633rhUatoFgkN3nEJ6CqDkonaiRJ/k=;
        b=1wmQJcbXK3udpuO0gJvSAevchnQrhS2D7iwgDR1V8N3PQ74b1eL7Yrs6PqK3XV3V6M
         ocNPnJS9P/0wS4k7EWEbPX2Yu4Wufml3iccw/opY89TOWUuuY/tnGDCXFec5JCV8iOoR
         74kg3BTywFpFxFn0dpRRgcPLG+87/M+kX3lr6JnYKGSKIXDqp5AWUdgZ0nFrgey07Vty
         f7q3LWvpm8YY6RSJ6xEIfT+YMdme8rU+KeDJ1M6ZcafHdlmL+ccxtOhRcoieEEazU5MM
         SgUVEtJc4CBGTs+vw6M1079J9y214WLO3sz88SdF3hWC9oUwWRYaGQGJithrQ1mnteO6
         TFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNPrsHRgMBJ28633rhUatoFgkN3nEJ6CqDkonaiRJ/k=;
        b=lFkKIcDRi+MAFbaUPdafzkIIvN+g30Q90GWQauYNn2e0/zR6lB/ZXXyBWnKS23yuDR
         u+V2QHURqUKXEKdVzgahcp2KF8RByLlK4ulLvqv2cYsi0Wlp64t6dshhOY+zB+wcF5bt
         9j7/ZOaiNGaVaLS5hfZbxN99auTtYjf93AwXrj0FDMPAtw4yQsyvk4e1/fJl7RCirDrf
         22/LhY6KCTA45L+m5xW+pUBMUhOaVWVo5NhTmJMgQtASkACJtAGhHEFAC2YEZ1q3ywU/
         n694/TMOXlo/GQq1lkIvy6dyQRccTkVFobwMMymArTTX+LQFOKg0hpaE3VSPLyV+MZ0T
         tgnQ==
X-Gm-Message-State: APjAAAU6dJPntdbPdxi98bJvqFgQ0se5B2EgexVUcd1YHDb6QQuNvwdc
        1q9eXhU8ghxE49uYLY7OFwVhtA==
X-Google-Smtp-Source: APXvYqzgEMCZfzOoWDjWUaSpZbFzGH0LqC4DP638gxs1UJpsD7iwLnM7GXZGsNgvTL88KtPUPTvErg==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr4306936wrm.159.1582455707231;
        Sun, 23 Feb 2020 03:01:47 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id x7sm12742129wrq.41.2020.02.23.03.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 03:01:46 -0800 (PST)
Date:   Sun, 23 Feb 2020 12:01:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     madhuparnabhowmik10@gmail.com
Cc:     jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Hold devlink->lock from the
 beginning of devlink_dpipe_table_register()
Message-ID: <20200223110145.GE2228@nanopsycho>
References: <20200223105253.30469-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223105253.30469-1-madhuparnabhowmik10@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Feb 23, 2020 at 11:52:53AM CET, madhuparnabhowmik10@gmail.com wrote:
>From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
>devlink_dpipe_table_find() should be called under either
>rcu_read_lock() or devlink->lock. devlink_dpipe_table_register()
>calls devlink_dpipe_table_find() without holding the lock
>and acquires it later. Therefore hold the devlink->lock
>from the beginning of devlink_dpipe_table_register().
>
>Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>---
> net/core/devlink.c | 25 +++++++++++++++++--------
> 1 file changed, 17 insertions(+), 8 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 4c63c9a4c09e..61a350f59741 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6838,26 +6838,35 @@ int devlink_dpipe_table_register(struct devlink *devlink,
> 				 void *priv, bool counter_control_extern)
> {
> 	struct devlink_dpipe_table *table;
>+	int err = 0;
> 
>-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
>-		return -EEXIST;
>+	mutex_lock(&devlink->lock);
> 
>-	if (WARN_ON(!table_ops->size_get))
>-		return -EINVAL;
>+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
>+		err = -EEXIST;
>+		goto unlock;
>+	}
>+
>+	if (WARN_ON(!table_ops->size_get)) {
>+		err = -EINVAL;
>+		goto unlock;
>+	}


Put this check out of the lock please.


> 
> 	table = kzalloc(sizeof(*table), GFP_KERNEL);
>-	if (!table)
>-		return -ENOMEM;
>+	if (!table) {
>+		err = -ENOMEM;
>+		goto unlock;
>+	}
> 
> 	table->name = table_name;
> 	table->table_ops = table_ops;
> 	table->priv = priv;
> 	table->counter_control_extern = counter_control_extern;
> 
>-	mutex_lock(&devlink->lock);
> 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
>+unlock:
> 	mutex_unlock(&devlink->lock);
>-	return 0;
>+	return err;
> }
> EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
> 
>-- 
>2.17.1
>
