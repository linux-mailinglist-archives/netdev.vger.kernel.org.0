Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0833169665
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 07:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgBWGne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 01:43:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43545 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgBWGne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 01:43:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id r11so6584261wrq.10
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 22:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NfB/s51uIdoGbaxyHKbys1HDOzUI4Z8k8OTFZnsHy68=;
        b=LrtK9lRKXimo5SPkLaCMf6BvAYihnCZg3cnBk5msBtcWCHZ+Fz4M0YrHrEuLP13ACd
         ePwkIAonq48LxXTdhp6c1G4YdG7j3qIzViNWJRdKdMhxffYQxY62D0FUn8kn0s4I2rS1
         Wtpasd5HAzlS9ZmgiuX1pehA8AAzWq0JCyxGwInkdMwPGsSEuCV0rqLD+KKd+joRFEI8
         TVs9LxwdlvY94SrlOe9NapZcLjMnASsQtyJf4fXiPOXSk7ubzn5MeCwRviV1dYjI/C+y
         KT5jbVrltf5Qn51a0LhgksULgadKblB5nscPBGzQ0Kf0iRv81wK45zQMp6pIP+HplL33
         N05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NfB/s51uIdoGbaxyHKbys1HDOzUI4Z8k8OTFZnsHy68=;
        b=ExIiod0rP52NidwrjeOB0FdBNWgEWE/KKvNI8uw6PFl/miYdXcpN8Vu5kxqfhG2dpS
         j9vVzJtaJB+fLsU3KMgnhypVTxCvrUXxkGvgfKj8Udfsnby2IxGKaap0YnWwCi24M9NL
         ablOIa4Ctn1CidrVDETc/hXC11TLWoeZ2QfiL55FR7Ii7DjpeDnDgU0pUQrUgQ+bPCoa
         nrYXRl39lnfPKGkfLgN0B8KPMpPyGuvKDqhy/c1Djd0V2qgYMM85gXOlvndWdjClnBJr
         nHDyThRos+nhU9YxjtTYIn8Vq6fxSjx4IJpimgOmmXKCqwemN5YGZIFd3MBnysnJDd2H
         Rq3Q==
X-Gm-Message-State: APjAAAXt+r8uWnUKLzdARqCfgUdd0d8ZVtOAg7a6hI23XOWTaYJA73uN
        Twd39EBKhFKrm9/vdyMO1lN4QA==
X-Google-Smtp-Source: APXvYqx4K2w89yDxHRYUL98MkKUT2TpPQG/iw0IXd+XoIFfw8QT5lhbZ9UHumj/9Hk0t+EVd1UC23A==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr56212773wru.87.1582440211406;
        Sat, 22 Feb 2020 22:43:31 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id f1sm12197579wro.85.2020.02.22.22.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 22:43:30 -0800 (PST)
Date:   Sun, 23 Feb 2020 07:43:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     madhuparnabhowmik10@gmail.com
Cc:     jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Hold devlink->lock from the
 beginning of devlink_dpipe_table_register()
Message-ID: <20200223064329.GD2228@nanopsycho>
References: <20200222065234.8829-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222065234.8829-1-madhuparnabhowmik10@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 22, 2020 at 07:52:34AM CET, madhuparnabhowmik10@gmail.com wrote:
>From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
>devlink_dpipe_table_find() should be called under either
>rcu_read_lock() or devlink->lock. devlink_dpipe_table_register()
>calls devlink_dpipe_table_find() without holding the lock
>and acquires it later. Therefore hold the devlink->lock
>from the beginning of devlink_dpipe_table_register().
>
>Suggested-by: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>---
> net/core/devlink.c | 15 +++++++++++----
> 1 file changed, 11 insertions(+), 4 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 3e8c94155d93..ba9dd8cb98c3 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6840,22 +6840,29 @@ int devlink_dpipe_table_register(struct devlink *devlink,
> {
> 	struct devlink_dpipe_table *table;
> 
>-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
>+	mutex_lock(&devlink->lock);
>+
>+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
>+		mutex_unlock(&devlink->lock);
> 		return -EEXIST;
>+	}
> 
>-	if (WARN_ON(!table_ops->size_get))
>+	if (WARN_ON(!table_ops->size_get)) {
>+		mutex_unlock(&devlink->lock);
> 		return -EINVAL;
>+	}
> 
> 	table = kzalloc(sizeof(*table), GFP_KERNEL);
>-	if (!table)
>+	if (!table) {
>+		mutex_unlock(&devlink->lock);

Please use "goto unlock" instead of unlocking on multiple places.



> 		return -ENOMEM;
>+	}
> 
> 	table->name = table_name;
> 	table->table_ops = table_ops;
> 	table->priv = priv;
> 	table->counter_control_extern = counter_control_extern;
> 
>-	mutex_lock(&devlink->lock);
> 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
> 	mutex_unlock(&devlink->lock);
> 	return 0;
>-- 
>2.17.1
>
