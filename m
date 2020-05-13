Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB21D066D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 07:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgEMFfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 01:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725977AbgEMFfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 01:35:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2386FC061A0C;
        Tue, 12 May 2020 22:35:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s20so6382842plp.6;
        Tue, 12 May 2020 22:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xKuGTzBt71m8CIHDiDqn23KXHfAjPSHatdr1dMN3hRc=;
        b=RAgYphhM6lKLTBzgKAx5zx6yvuoUwfVoCymWZIgflUs/0LjoFuINBna/wDXzT6s361
         vXaI97zbEJnU7eViR0Apq3Icr8xvQqY8wEeaPO3eAZGzLiuN0qrxjusCno/743PbjDDc
         1lPMePNfi3BggixLBjij0p+j6KEGgk7zKTtPppn7Qkses6ZfnaM6PKEdTJHaQkZ6U3RR
         a2681p03wrnW0L7W7EZA3EgBqtVU0d3WgbuGt/gU16kAOTSHTJ9nG9loAM8kf66BDiY2
         xkCbyyR6c4lbSXd74JUhVyOWf2lvG/XitcT4Z88nlh7FMfTV8kJ/6Z4iep4ICrrpGTw8
         a4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xKuGTzBt71m8CIHDiDqn23KXHfAjPSHatdr1dMN3hRc=;
        b=EF4/8BOwaGIs0RzoSBJkhOJQ/dA/UHXGiMzAOD1b3hSdfdObsp9j/n+Cx63qKelAL/
         RGDSY/zilyNE/qd+c7cbPi6WLSxbZvs0b/l8TQlyZ5FQqqfMlWX150FHZZwUUHp9B7Ua
         OGzlBoDHXcO5meodcVneaELUgVwsTxI3UsG0yMrGALOJPo2pRsArtLLJapFRh+r3WpRE
         tjiviffWHWM3/xQyRT9romeS+Z7McbpCjIi0rmdk4bQQoslUAJKHCXSjIunzvyEi6wLS
         uQaeA+FYC0V26wk+clMEFbVWUfWc17ggup7djmLWSuxwJWZ6wGRmQF43xyGOtgO1/8Nc
         342g==
X-Gm-Message-State: AGi0PuadxNZC+AvSjkTN4XcNVQeYHfIIMHsyoqfy2B0FIjk7tK87WRto
        zDwfJyG/jFcIpqPGvkzh43gInSg=
X-Google-Smtp-Source: APiQypKfvqODuQ4CFxPjmPeTQVxkuOOAoKkkaVAnEo+lH+kR3XTtYOdHg+gLw0Fcr+0cKMQIH8a5FQ==
X-Received: by 2002:a17:90a:8c98:: with SMTP id b24mr23216888pjo.226.1589348107506;
        Tue, 12 May 2020 22:35:07 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2409:4071:5b5:d53:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id 21sm7298563pgc.6.2020.05.12.22.35.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 May 2020 22:35:06 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Wed, 13 May 2020 11:04:57 +0530
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        sfr@canb.auug.org.au, Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net 2/2 RESEND] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
Message-ID: <20200513053457.GA13541@madhuparna-HP-Notebook>
References: <20200509072243.3141-1-frextrite@gmail.com>
 <20200509072243.3141-2-frextrite@gmail.com>
 <20200509141938.028fa959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200512051705.GB9585@madhuparna-HP-Notebook>
 <20200512093231.7ce29f30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512093231.7ce29f30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 09:32:31AM -0700, Jakub Kicinski wrote:
> On Tue, 12 May 2020 10:47:05 +0530 Madhuparna Bhowmik wrote:
> > > >  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
> > > > -#define ipmr_for_each_table(mrt, net) \
> > > > -	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> > > > -				lockdep_rtnl_is_held())
> > > > +#define ipmr_for_each_table(mrt, net)					\
> > > > +	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> > > > +				lockdep_rtnl_is_held() ||		\
> > > > +				lockdep_is_held(&pernet_ops_rwsem))  
> > > 
> > > This is a strange condition, IMHO. How can we be fine with either
> > > lock.. This is supposed to be the writer side lock, one can't have 
> > > two writer side locks..
> > > 
> > > I think what is happening is this:
> > > 
> > > ipmr_net_init() -> ipmr_rules_init() -> ipmr_new_table()
> > > 
> > > ipmr_new_table() returns an existing table if there is one, but
> > > obviously none can exist at init.  So a better fix would be:
> > > 
> > > #define ipmr_for_each_table(mrt, net)					\
> > > 	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> > > 				lockdep_rtnl_is_held() ||		\
> > > 				list_empty(&net->ipv4.mr_tables))
> > >  
> > (adding Stephen)
> > 
> > Hi Jakub,
> > 
> > Thank you for your suggestion about this patch.
> > Here is a stack trace for ipmr.c:
> > 
> > [...]
> 
> Thanks!
> 
> > > Thoughts?  
> > 
> > Do you think a similar fix (the one you suggested) is also applicable
> > in the ip6mr case.
> 
> Yes, looking at the code it seems ip6mr has the exact same flow for
> netns init.

Alright, thanks a lot.
I will send a patch for ip6mr.c soon.

Thank you,
Madhuparna
