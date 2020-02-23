Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3183B16974F
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBWLE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:04:27 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40363 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWLE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:04:27 -0500
Received: by mail-pj1-f65.google.com with SMTP id 12so2788717pjb.5;
        Sun, 23 Feb 2020 03:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=om4f7MVc7Kk4+w+0wroNyFz+6EbbOUYfqD30UnUwIqk=;
        b=tKep900/tlJjVC1CTw0BrMP83obkKmYKmqiYOzqSXTmPQyOrJhOu24H+yRqljXSZ18
         D5H8BkZ3Uirf85lOX2Z1eo1LLLC8HbfVDcw9tGClHpQZW0qb65KVC/25iuKtlzzDGV5X
         bZB9SGwAqiA6A39U3T5p39r8A7Zfh6smCtWH/AmnGvbpBrZUkFOd/qd6Wwt/nOUQXuOE
         iPTtSoWVjSsNhd7VbtRtYtky4DP9uemZr5fSasy+MvjFLJtCbEgYqwkkI+9tU3cw9aNB
         lPq6G2+NTWpsyJfilkKZvq5JLP3Dfwc+JE5ewg7uzJmG4etCCfw/pI6UP0qELnxY0AnJ
         CZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=om4f7MVc7Kk4+w+0wroNyFz+6EbbOUYfqD30UnUwIqk=;
        b=eZOqICJfpo6nHUuEpnVcc9WLhDH2EXDsq8vkZFmU+bKlIC7EGnI/8TVNXdhJDNkkYx
         whngDw3ohFiUqaXqF26JodFMZKw/mImnIBsj2VzVxf4AxmF8RQ6xQ0C6qTb2PTi1Mouv
         bCEnHshn2R9JAaojY3dGA9eHmYe3J4XU4dPDFYkPVSmZ/g1KZWrIVNSWXjAGqiYoZzww
         AvHXz0RVZ7wZeogw/YXO2dqbfpN92MkfC6yLLyoxrfJT8Z5rbAHBklKty9CjEYDVWkCE
         7gUKbg5mHmxswD4rXzMgyW9UVCNWSTKIcYO41UqT1G3TdTU8xUyGKtpul7PqCqXslpVZ
         WKFw==
X-Gm-Message-State: APjAAAUE4QSqz5qUdbnZ4k2TbYdLnOU06heywYvQbfyEhF5X883xldHD
        QFlnREN75l74alIIXwesEQ==
X-Google-Smtp-Source: APXvYqxPpt+EHE/A0V8OL5mRLTRyVUdJzEkkF8DjgaM8xAVR3oGwTUBMypk8vCsioEpJwiUIMw66kA==
X-Received: by 2002:a17:90a:fb4f:: with SMTP id iq15mr14285642pjb.86.1582455866390;
        Sun, 23 Feb 2020 03:04:26 -0800 (PST)
Received: from madhuparna-HP-Notebook ([42.109.138.18])
        by smtp.gmail.com with ESMTPSA id z5sm9324536pfq.3.2020.02.23.03.04.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 Feb 2020 03:04:25 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sun, 23 Feb 2020 16:33:42 +0530
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     madhuparnabhowmik10@gmail.com, jiri@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200223110342.GB2400@madhuparna-HP-Notebook>
References: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
 <20200221172008.GA2181@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221172008.GA2181@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 06:20:08PM +0100, Jiri Pirko wrote:
> Fri, Feb 21, 2020 at 05:51:41PM CET, madhuparnabhowmik10@gmail.com wrote:
> >From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >
> >list_for_each_entry_rcu() has built-in RCU and lock checking.
> >
> >Pass cond argument to list_for_each_entry_rcu() to silence
> >false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> >by default.
> >
> >Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> Thanks.
> 
> However, there is a callpath where not devlink lock neither rcu read is
> taken:
> devlink_dpipe_table_register()->devlink_dpipe_table_find()
> I guess that was not the trace you were seeing, right?
> 
> 
> >---
> > net/core/devlink.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index 4c63c9a4c09e..3e8c94155d93 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -2107,7 +2107,8 @@ devlink_dpipe_table_find(struct list_head *dpipe_tables,
> > {
> > 	struct devlink_dpipe_table *table;
> > 
> >-	list_for_each_entry_rcu(table, dpipe_tables, list) {
> >+	list_for_each_entry_rcu(table, dpipe_tables, list,
> >+				lockdep_is_held(&devlink->lock)) {

Hi Jiri,

I just noticed that this patch does not compile because devlink is
not passed as an argument to devlink_dpipe_table_find() and it is not
even global. I am not sure why I didn't encounter this error before
sending the patch. Anyway, I am sorry about this.
But it seems to be the right lock that should be held and checked for
in devlink_dpipe_table_find(). 
So will it be okay to pass devlink to devlink_dpipe_table_find()?
Anyway devlink_dpipe_table_find() is only called from functions
within devlink.c.

Let me know what you think about this.
Thank you,
Madhuparna


> > 		if (!strcmp(table->name, table_name))
> > 			return table;
> > 	}
> >-- 
> >2.17.1
> >
