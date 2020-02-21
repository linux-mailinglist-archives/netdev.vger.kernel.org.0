Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B03E1685C7
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgBUSA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:00:28 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41753 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgBUSA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:00:28 -0500
Received: by mail-pg1-f195.google.com with SMTP id 70so1345890pgf.8;
        Fri, 21 Feb 2020 10:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z+o5vmJ3WcD8niaaOHTfXdBCZlrojxir+QG2cCGfk6A=;
        b=t+zeW3mgrebrV+iIT4eJHk1R4y+Z41nbR+wradhj0hqb96NV391lKQ68T6qY21u2Sx
         oWHwkCU5+FqKAAj/4eISmcMUPtgjWvJvMEBmFQ6LZgvVT0VwSv9bl3Sy+V+Io7W1C7qM
         Fx2n4W4xEaKJ056N6cMdP8Y59n6Xbii3AvMlTH86oZZ9M85e2+aK0/XtFKNJZPAekBdQ
         WbM+XiiAlgCdbRoOh2+JXym7DCe4/MxyokCsO9GOz/OvjaPYH7CjmOs6sqWcFTEOUNSI
         v8uKrVq6Q6hjmxMGCiImrSVQzxjA2aPCs9gtaIFJSUMF6uRDgfrRfxL8LX8+dBBZM2J0
         NJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z+o5vmJ3WcD8niaaOHTfXdBCZlrojxir+QG2cCGfk6A=;
        b=kBhPHhyDo5qNMiJMRN9KWiXZQTCv+fxtoA8/1nPT6K7BYtI5EJRdCaq7KuqdfCb6cR
         jjnqBOqjnuVbvHACFa7hrI2/lSYSdW+Ltj9kcL80PQH822h1nfXGL9yleWoBWpqyhXTx
         F+HVr2/TkB6zOgl8xdoWMyMLBWosuzNGLqRhtB/fBKsvpXp6XsyQ5IHcD0uWYVuc4v4O
         COS/PYHPCDCrULD/MuosRb8fJNTP4s5L5z2nAtEdLeM+s/ZcGJMvGfNvgHkrfSwcOgfw
         NwxLLJsdqhHn/ho9Q/b0UDPSDNFXwvGT0i35wQbZAU8oxa8Kjyur/tmFXC1HBEcCLiIL
         OofQ==
X-Gm-Message-State: APjAAAVFwikEdDw+6NzA3NN3fEpJAXuOp5jV5eY1una2StodVcVCW64f
        4DiL1YlS0tyLCfyuzj8cZg==
X-Google-Smtp-Source: APXvYqxud//iAviYNHnubCd8GZQM6QC6ZR1Dnjwf1LjuLqxAB2/myqBOj/I9u3irWrI/sqnCHK5zdQ==
X-Received: by 2002:a63:2cc9:: with SMTP id s192mr38389623pgs.441.1582308025998;
        Fri, 21 Feb 2020 10:00:25 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:1ee0:fe5e:d03d:769b:c838:c146])
        by smtp.gmail.com with ESMTPSA id p24sm3506364pff.69.2020.02.21.10.00.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 10:00:25 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Fri, 21 Feb 2020 23:30:15 +0530
To:     Jiri Pirko <jiri@resnulli.us>, y@madhuparna-HP-Notebook
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200221180015.GA16779@madhuparna-HP-Notebook>
References: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
 <20200221172008.GA2181@nanopsycho>
 <20200221173533.GA13198@madhuparna-HP-Notebook>
 <20200221175436.GB2181@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221175436.GB2181@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 06:54:36PM +0100, Jiri Pirko wrote:
> Fri, Feb 21, 2020 at 06:35:34PM CET, madhuparnabhowmik10@gmail.com wrote:
> >On Fri, Feb 21, 2020 at 06:20:08PM +0100, Jiri Pirko wrote:
> >> Fri, Feb 21, 2020 at 05:51:41PM CET, madhuparnabhowmik10@gmail.com wrote:
> >> >From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >> >
> >> >list_for_each_entry_rcu() has built-in RCU and lock checking.
> >> >
> >> >Pass cond argument to list_for_each_entry_rcu() to silence
> >> >false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> >> >by default.
> >> >
> >> >Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >> 
> >> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> Thanks.
> >> 
> >> However, there is a callpath where not devlink lock neither rcu read is
> >> taken:
> >> devlink_dpipe_table_register()->devlink_dpipe_table_find()
> >>
> >Hi,
> >
> >Yes I had noticed this, but I was not sure if there is some other lock
> >which is being used.
> >
> >If yes, then can you please tell me which lock is held in this case,
> >and I can add that condition as well to list_for_each_entry_rcu() usage.
> >
> >And if no lock or rcu_read_lock is held then may be we should
> >use rcu_read_lock/unlock here.
> >
> >Let me know what you think about this.
> 
> devlink->lock should be held since the beginning of
> devlink_dpipe_table_register()
>
Alright, I will send a patch with this change soon.
Thank you for the help.

Regards,
Madhuparna
