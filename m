Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB161D57FE
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgEORcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEORcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:32:32 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8676EC061A0C;
        Fri, 15 May 2020 10:32:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id a4so1293687pgc.0;
        Fri, 15 May 2020 10:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P2liv/v5gGAbAXRC5wH9YqGp61s9iKxdvcJaWcNx2xI=;
        b=EFUl3Ny9v1ssnFYet/IY2nrQxrC9c+gWpJee7y88As8n4LPfqAPwlEQdJWzyRuUb6M
         PRBTBD/WT8rn/Y+664lEdVNB7LnuTsd4K3yDSVHrDyqoNaHJDufny6XjdYWywWE1f1AR
         lRFejuJhavb9I3HE57zR4rJIyfaklMiIY9Ubu5m5RyFFzdLIlKLIPvHHwV+/Ki2xhLWT
         PuSKkXRantAxB/MdJb3bLYpwzAANEYW52Z6QMIQvr/hHlC9dalgxSU2uh+N+49JMr3dm
         Exh04ckMwJknnq1vDOnDmuGMmVDbCHlK6spCmuzdZKdmCUZ8AtwJ/C3T5HWrk2iknP+J
         kVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P2liv/v5gGAbAXRC5wH9YqGp61s9iKxdvcJaWcNx2xI=;
        b=ED/DOFvDcgsXQkXdL4jaOgWqy1W/fwkJ+n17eYG1LOQ1QTGfVkVKKkAq+BMV7yuBCh
         7/+qyUl5zMgDlcxi04NiZsz+fiJ84v9HDnipaeNHJbumWQD2oLRcAdLxlENq+WcjqYvj
         ooEXIL8vTRbsEYnSY1f/oT4QAaLDP2pyDYY48ZeCdbdSgVMRhDSKkU6N0RWMPI5mRDpB
         q6Apt5dI4fIthjMk3bZTcWNt6Clt5JSBmLwNWV5x8ueyEgTzbzdbFFN3jV6qtKXwUyxt
         LPka7+r0sz2PNo2cwDhGISsdpbDxVCmXWxnSifyhpfYAa236i2t9zTsKdcMnaFimvWyE
         aLGg==
X-Gm-Message-State: AOAM533wg0cLbpSxtvdEYU2ogU9gzv0H7J5BmquLBMBQ7AMGH4doasHs
        i/O4ByrhWzfagPV0mUSNyQ==
X-Google-Smtp-Source: ABdhPJzSEkIOxA36uUdnBtaPh/TxKnkcEpGTptKP6IMTPEESS1uDkbS6RRk64N9TzCJONrdkUmVxWg==
X-Received: by 2002:a62:35c1:: with SMTP id c184mr4652752pfa.120.1589563951981;
        Fri, 15 May 2020 10:32:31 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2409:4071:5b5:d53:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id z190sm2427311pfz.84.2020.05.15.10.32.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 May 2020 10:32:30 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Fri, 15 May 2020 23:02:20 +0530
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     madhuparnabhowmik10@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, frextrite@gmail.com, joel@joelfernandes.org,
        paulmck@kernel.org, cai@lca.pw
Subject: Re: [PATCH net] ipv6: Fix suspicious RCU usage warning in ip6mr
Message-ID: <20200515173219.GA25207@madhuparna-HP-Notebook>
References: <20200514070204.3108-1-madhuparnabhowmik10@gmail.com>
 <20200514094008.6421ea71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514094008.6421ea71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 09:40:08AM -0700, Jakub Kicinski wrote:
> On Thu, 14 May 2020 12:32:04 +0530 madhuparnabhowmik10@gmail.com wrote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > This patch fixes the following warning:
> > 
> > =============================
> > WARNING: suspicious RCU usage
> > 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> > -----------------------------
> > net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> > 
> > ipmr_new_table() returns an existing table, but there is no table at
> > init. Therefore the condition: either holding rtnl or the list is empty
> > is used.
> > 
> > Fixes: d13fee049f ("Default enable RCU list lockdep debugging with .."): WARNING: suspicious RCU usage
> 
> 	Fixes tag: Fixes: d13fee049f ("Default enable RCU list lockdep debugging with .."): WARNING: suspicious RCU usage
> 	Has these problem(s):
> 		- Target SHA1 does not exist
>
I got this report: https://lkml.org/lkml/2020/5/12/1358

That's why I used this SHA1 with the fixes tag.

> I think the message at the end is confusing automation, could you use
> the standard Fixes tag format, please?
>
Sure, I will do that.
> > Reported-by: kernel test robot <lkp@intel.com>
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > ---
> >  net/ipv6/ip6mr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> > index 65a54d74acc1..fbe282bb8036 100644
> > --- a/net/ipv6/ip6mr.c
> > +++ b/net/ipv6/ip6mr.c
> > @@ -98,7 +98,7 @@ static void ipmr_expire_process(struct timer_list *t);
> >  #ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
> >  #define ip6mr_for_each_table(mrt, net) \
> >  	list_for_each_entry_rcu(mrt, &net->ipv6.mr6_tables, list, \
> > -				lockdep_rtnl_is_held())
> > +				lockdep_rtnl_is_held() ||  list_empty(&net->ipv6.mr6_tables))
> 
> double space, line over 80 chars

Okay, I will make these changes and send the patch.

Regards,
Madhuparna
> 
> >  static struct mr_table *ip6mr_mr_table_iter(struct net *net,
> >  					    struct mr_table *mrt)
> 
> Other than these nits looks good, thanks!
