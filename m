Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CDE169746
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 11:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgBWK4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 05:56:17 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34644 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWK4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 05:56:17 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so3763291pfc.1;
        Sun, 23 Feb 2020 02:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y4VY1Azy1o3PoJqSKPRqaiIxMs3Y8ukCDbObo1HjIMY=;
        b=CPdjVDnfw0/2F2CgiSygZvvIsvU1j06og18Asa17oW35tVg82IHVtWq2lx7oDCIQOB
         Zni8Kpd2RE8QtJFSN9H4Dnnr/u4sQDLwOI0mdDpuhxlUIgnM/rSaQu698VSMknpOuvNK
         VadwWKH4JkLwzcGALIEcpACTDsUTez5TpNtYsfRg2lNKwC5DnhSnbkZsOLSRAYDnsv/p
         KvvXTaBir7a2fcQeKLQBwH8Yk3Zh2GPNHUnBKc1NxUsjsBS7DGsPkKrvdFkaHkwTmUil
         lwIUKQw2FtXyHTEmPVKfs7G2eJrNK5hsP4GD0qDrbnmvpwGxUrMudFHsIvMCfx08Ifsf
         SI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y4VY1Azy1o3PoJqSKPRqaiIxMs3Y8ukCDbObo1HjIMY=;
        b=KA5LTe9ngaubvwJJGHUKGakm+lxWigh02OsiyyzDf0Ov3OW1zfd9Oddyt1JCW5uXFl
         PqHpgu7JgAviP90oomHlJeLwSqbFgFWDFlHSMQqfsNQhYNUB5EnDuWmrsWZJr28/c1T9
         CQYewYXUkpjXNgiLX3btFXIHJjCRbUzd9cJGh4bcQsXjtM0MjMy8iDQn5daz+6sqGkDd
         T196hrdDKyChjRQz6A5B0mJAHE27+rkJkPOVps2xJW06XRw6uxR0kCnsjk3paoc6E7S5
         lt76mqaJs/jbYqxUlclXg4T7Urjqn1jz9EL8I0oyfMRr+u3mG50t5KUFHhrqtWPH0EUX
         UZvA==
X-Gm-Message-State: APjAAAW+/BVR4XZw1BOudEant7P3ofyOu+wknYYbuEMTpX5FzmZu16cu
        GlMOv9AnqU5Nu1/6YuTGWA==
X-Google-Smtp-Source: APXvYqw4YCUB6My3nq+OxFm92OU+rjZrxzEdwhzqqnit1IzAEjHzRdsub2GaWCHQ/aStoHOUt4asXw==
X-Received: by 2002:a63:de54:: with SMTP id y20mr47965037pgi.79.1582455376990;
        Sun, 23 Feb 2020 02:56:16 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:515:9a49:e8ed:fa6e:a613:7ebf])
        by smtp.gmail.com with ESMTPSA id m16sm1446176pfh.60.2020.02.23.02.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 Feb 2020 02:56:16 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sun, 23 Feb 2020 16:26:10 +0530
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     madhuparnabhowmik10@gmail.com, jiri@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Hold devlink->lock from the
 beginning of devlink_dpipe_table_register()
Message-ID: <20200223105610.GA2400@madhuparna-HP-Notebook>
References: <20200222065234.8829-1-madhuparnabhowmik10@gmail.com>
 <20200223064329.GD2228@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223064329.GD2228@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 07:43:29AM +0100, Jiri Pirko wrote:
> Sat, Feb 22, 2020 at 07:52:34AM CET, madhuparnabhowmik10@gmail.com wrote:
> >From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >
> >devlink_dpipe_table_find() should be called under either
> >rcu_read_lock() or devlink->lock. devlink_dpipe_table_register()
> >calls devlink_dpipe_table_find() without holding the lock
> >and acquires it later. Therefore hold the devlink->lock
> >from the beginning of devlink_dpipe_table_register().
> >
> >Suggested-by: Jiri Pirko <jiri@mellanox.com>
> >Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >---
> > net/core/devlink.c | 15 +++++++++++----
> > 1 file changed, 11 insertions(+), 4 deletions(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index 3e8c94155d93..ba9dd8cb98c3 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -6840,22 +6840,29 @@ int devlink_dpipe_table_register(struct devlink *devlink,
> > {
> > 	struct devlink_dpipe_table *table;
> > 
> >-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
> >+	mutex_lock(&devlink->lock);
> >+
> >+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
> >+		mutex_unlock(&devlink->lock);
> > 		return -EEXIST;
> >+	}
> > 
> >-	if (WARN_ON(!table_ops->size_get))
> >+	if (WARN_ON(!table_ops->size_get)) {
> >+		mutex_unlock(&devlink->lock);
> > 		return -EINVAL;
> >+	}
> > 
> > 	table = kzalloc(sizeof(*table), GFP_KERNEL);
> >-	if (!table)
> >+	if (!table) {
> >+		mutex_unlock(&devlink->lock);
> 
> Please use "goto unlock" instead of unlocking on multiple places.
>
Sure, I have sent a new patch.
Thank you,
Madhuparna
> 
> 
> > 		return -ENOMEM;
> >+	}
> > 
> > 	table->name = table_name;
> > 	table->table_ops = table_ops;
> > 	table->priv = priv;
> > 	table->counter_control_extern = counter_control_extern;
> > 
> >-	mutex_lock(&devlink->lock);
> > 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
> > 	mutex_unlock(&devlink->lock);
> > 	return 0;
> >-- 
> >2.17.1
> >
