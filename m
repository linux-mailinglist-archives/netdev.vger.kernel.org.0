Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563FC168D04
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 07:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgBVG4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 01:56:14 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39344 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgBVG4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 01:56:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id 84so2460198pfy.6;
        Fri, 21 Feb 2020 22:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P1m+5CvuP9WCDPeB2rpqQfl3ZDcAcnZi8bxAc6P+hRk=;
        b=dPURgE2Lm4GaZRYbjxHDP2B3otEz+xUJEcA5i3LVcJjawKYEdOuzaftuH86Hvn+z2u
         p/HVStoCr46D2r7vAdKIPPtDTw4Ri6UvouwJXuUMdRnjZR1uRFWRzplttwg9dEQVxU19
         1NG0zIrux8y1zMOTymtU3BKJ784cQOyQRz5msCWx/YsIFqY961KYxuzX3vGbVwouhQQz
         ik8FgDZLGYnmcK/wYxvm6zW8PFY+Z5VTTRXJXHAH5fTCVu26af795nwaVHxInjqxlJoD
         Ypo8gnLH4AqjLeMSFFSB4nCkVEYNbTnuLJM9gTLI/IxYz+6WNlc5FJztHC4QepS+LQ0x
         j1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P1m+5CvuP9WCDPeB2rpqQfl3ZDcAcnZi8bxAc6P+hRk=;
        b=pFFGm2OYdezz9RIN+NiokpC6oFQTjf9OFow8vQtWIj+gdssLPpLkI3TOqOZuwm4TQK
         XsIW0URTXLn+HqYBJ7IPFPrRq6drpQI1HJxIt/Cc/6ntsclADWbbWgNkcVFtpl1hN6iB
         qDTWnpIdPSqdyjaiZrJrnJjeU9oj8KBa8EEvh24iUNw+fVBEcqbkE0SXl1er8gGekshk
         MZwFvNPHd749kbNvxAatidVyWnzuWDZ5Hd6z2i0eS9Ub10JtCQ9w3otpuRolZJ6+HeS1
         7fmgLFGTFZ0JNn9VDvitX7SriNPIexrYmUL764IICEuUc8as5tquxf/5A9v5yZa7sGVU
         drAg==
X-Gm-Message-State: APjAAAUkumCcKlqbo6Zze+Bkro+jhTEBPHNY4NdYVv04XTDOXyizJsJq
        8Oa+vO8heBsATRbUaHAOdw==
X-Google-Smtp-Source: APXvYqwowHvFtBe6LpkACUng2s38E8ahG4DvKaIDLCfgUrVAiTcya7q3HI8cDbC0aT0bMh1HGsTSXA==
X-Received: by 2002:aa7:9359:: with SMTP id 25mr41508430pfn.188.1582354573071;
        Fri, 21 Feb 2020 22:56:13 -0800 (PST)
Received: from madhuparna-HP-Notebook ([42.109.147.216])
        by smtp.gmail.com with ESMTPSA id z127sm4456084pgb.64.2020.02.21.22.56.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 22:56:12 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sat, 22 Feb 2020 12:25:36 +0530
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     madhuparnabhowmik10@gmail.com, jiri@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Hold devlink->lock from the
 beginning of devlink_dpipe_table_register()
Message-ID: <20200222065536.GA9143@madhuparna-HP-Notebook>
References: <20200221180943.17415-1-madhuparnabhowmik10@gmail.com>
 <20200222062640.GA2228@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222062640.GA2228@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 22, 2020 at 07:26:40AM +0100, Jiri Pirko wrote:
> Fri, Feb 21, 2020 at 07:09:43PM CET, madhuparnabhowmik10@gmail.com wrote:
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
> > net/core/devlink.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index 3e8c94155d93..d54e1f156b6f 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -6840,6 +6840,8 @@ int devlink_dpipe_table_register(struct devlink *devlink,
> > {
> > 	struct devlink_dpipe_table *table;
> > 
> >+	mutex_lock(&devlink->lock);
> >+
> > 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
> > 		return -EEXIST;
> 
> You have to handle the error path.
>
Sure, I have sent the updated patch.

Thank you,
Madhuparna
> 
> > 
> >@@ -6855,7 +6857,6 @@ int devlink_dpipe_table_register(struct devlink *devlink,
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
