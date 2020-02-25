Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3256D16C064
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgBYMJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:09:39 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36260 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbgBYMJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:09:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so6805809pgu.3;
        Tue, 25 Feb 2020 04:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mqwfc2KPcVYiVKPkQxYVO7vDegBEMXoJ1E0hLY/tEvs=;
        b=QvpUiAYt/81/K3o5p9SEGp2S+oMZT+pF5G/IgKwJ3lkCNIGGhE/nqbrDprw6OJGudw
         DUsN/CNkCmL2wqEET9mky2iuKALEg4gRZPHXjbe4mDJGEFhJ8ZlmL+35JSi4sbKu7+ym
         bXdvae1ucylvR/2yo/6NFm7kVpAx2Ft2uX2ENpIxVC/i2YISkNdFAgUAGz/5Ypm36D9D
         LBpyOYtWig9hLKlZ09ncVhBxPnKYi2nK6R4tGVHmUkvyzlngfHidSMEFW5Hzx4tGTi/h
         OWGfE8fn6cQTUGLapsaPo39dImC5ITRM7AsE00N4g2ZNcVba4ZwRXvZQy+IondWafLuJ
         uLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mqwfc2KPcVYiVKPkQxYVO7vDegBEMXoJ1E0hLY/tEvs=;
        b=SEADDwq04uNK5AGDop93xJlxHlS3XW3J+/Uym/0H7J12Htbb1tyZd+ldL0CRDat21X
         6vwsCvMKoR4vE3koxi5ZivAOuyC/ZWkzOX5XbSmlvEVNpiYaY2uck/TFHz9iyV4RuZVy
         uJh6KCQvzK8mxNxkH/1FbU8ezWnlH9aZcSQdyPCzL6pHYLfHvPGlGMRjs2HVEiTjXmeo
         bmy+ZdLA2kmlYBiCTlM5EP17oGsckoNpfVBN2EBrmN13xa95w043QCXUvKf9/p7oJsrw
         mZOphkhNEdwiMZ6hU6hLpl+FlGVsub+6JbQI2OaN/ZiW8vg8PUpWYubH/7PvcDvWnzHF
         u6ng==
X-Gm-Message-State: APjAAAUOshflN2igIfDHbeV+SgG31NL9BPQS+ogEOApCS8arTujS6lvn
        Yt/XNaO4Z1PbTd7ST4hz/A==
X-Google-Smtp-Source: APXvYqw2IDOcub20k/JBZx9cp2o1QdYEKf3jJ3rBWjrY04ClE4F+LPbgluh8uCOp28IxecK5bd73nA==
X-Received: by 2002:aa7:8587:: with SMTP id w7mr57040697pfn.39.1582632577377;
        Tue, 25 Feb 2020 04:09:37 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:1ee1:f355:e8e5:803b:cde8:bccc])
        by smtp.gmail.com with ESMTPSA id e6sm16685944pfh.32.2020.02.25.04.09.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Feb 2020 04:09:36 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Tue, 25 Feb 2020 17:39:08 +0530
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     madhuparnabhowmik10@gmail.com, jiri@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200225120908.GA29836@madhuparna-HP-Notebook>
References: <20200224093013.25700-1-madhuparnabhowmik10@gmail.com>
 <20200224105209.GB16270@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224105209.GB16270@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 11:52:09AM +0100, Jiri Pirko wrote:
> Mon, Feb 24, 2020 at 10:30:13AM CET, madhuparnabhowmik10@gmail.com wrote:
> >From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >
> >list_for_each_entry_rcu() has built-in RCU and lock checking.
> >
> >Pass cond argument to list_for_each_entry_rcu() to silence
> >false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.
> >
> >The devlink->lock is held when devlink_dpipe_table_find()
> >is called in non RCU read side section. Therefore, pass struct devlink
> >to devlink_dpipe_table_find() for lockdep checking.
> >
> >Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >---
> > net/core/devlink.c | 18 +++++++++---------
> > 1 file changed, 9 insertions(+), 9 deletions(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index e82750bdc496..dadf5fa79bb1 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -2103,11 +2103,11 @@ static int devlink_dpipe_entry_put(struct sk_buff *skb,
> > 
> > static struct devlink_dpipe_table *
> > devlink_dpipe_table_find(struct list_head *dpipe_tables,
> >-			 const char *table_name)
> >+			 const char *table_name, struct devlink *devlink)
> > {
> > 	struct devlink_dpipe_table *table;
> >-
> >-	list_for_each_entry_rcu(table, dpipe_tables, list) {
> >+	list_for_each_entry_rcu(table, dpipe_tables, list,
> >+				lockdep_is_held(&devlink->lock)) {
> > 		if (!strcmp(table->name, table_name))
> > 			return table;
> > 	}
> >@@ -2226,7 +2226,7 @@ static int devlink_nl_cmd_dpipe_entries_get(struct sk_buff *skb,
> > 
> > 	table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
> > 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
> >-					 table_name);
> >+					 table_name, devlink);
> > 	if (!table)
> > 		return -EINVAL;
> > 
> >@@ -2382,7 +2382,7 @@ static int devlink_dpipe_table_counters_set(struct devlink *devlink,
> > 	struct devlink_dpipe_table *table;
> > 
> > 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
> >-					 table_name);
> >+					 table_name, devlink);
> > 	if (!table)
> > 		return -EINVAL;
> > 
> >@@ -6814,7 +6814,7 @@ bool devlink_dpipe_table_counter_enabled(struct devlink *devlink,
> > 
> > 	rcu_read_lock();
> > 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
> >-					 table_name);
> >+					 table_name, devlink);
> > 	enabled = false;
> > 	if (table)
> > 		enabled = table->counters_enabled;
> >@@ -6845,7 +6845,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
> > 
> > 	mutex_lock(&devlink->lock);
> > 
> >-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
> >+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name, devlink)) {
> 
> Run scripts/checkpatch.pl on your patch. You are breaking 80-cols limit
> here.
>
Sure, I will take care of this and send the updated patch soon.

Thank you,
Madhuparna
> Otherwise, the patch looks fine.
> 
> > 		err = -EEXIST;
> > 		goto unlock;
> > 	}
> >@@ -6881,7 +6881,7 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
> > 
> > 	mutex_lock(&devlink->lock);
> > 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
> >-					 table_name);
> >+					 table_name, devlink);
> > 	if (!table)
> > 		goto unlock;
> > 	list_del_rcu(&table->list);
> >@@ -7038,7 +7038,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
> > 
> > 	mutex_lock(&devlink->lock);
> > 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
> >-					 table_name);
> >+					 table_name, devlink);
> > 	if (!table) {
> > 		err = -EINVAL;
> > 		goto out;
> >-- 
> >2.17.1
> >
