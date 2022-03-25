Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A574E7B6E
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiCYTpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiCYTog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:44:36 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A9638F70F
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:16:18 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id kk12so6957724qvb.13
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HJYoFqClYnz+wdN3BZY0xOUstF7EqA2bCMGoKxryv/U=;
        b=DiUDBMw13VCabtCiw+vw1MzcIzSmw1aSC87hgQlyMM6sesI4Zzzbddw9xxLgKqjI/m
         NVKwgwBFNfjC6atuk4JAb+VjkqMJqOuVM5BcxvOd7JoNLANl9Iagy/5iXchEtbku1+bX
         xVabghlhysHmHOrjUkSwJgB5JaybbWk9aZGKrscTuTDGoCpqCJJ3pPdSGEecfHdQCHSo
         MdDHReKwKAxgAW0C5I17SwRCnm1d6xt2Q//p4ihSQqQaVSED3jhmIM69o0xm945Q+8Xb
         GfW1Ln6mYsdcLWKokPaUZ5n3QGSCCUniTOeDwFaLC9T+m0D1ERUu6cNwm3OkamLkCqzr
         pazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HJYoFqClYnz+wdN3BZY0xOUstF7EqA2bCMGoKxryv/U=;
        b=brwsvayrag3KJI+g0lf/Js9b/J+BkKwV7+dtZmN5jmnm2m3/GOMAuITVTbSg4Xvr7W
         tBnceCpk7xswLykD6R0E3KImDm6RDWvWWsK6/6YabuaE1RL8j0iRbnAkzviBM+Hr27uf
         UX0UfCVLi+Z4q1cvCMefiOaXFD1kV34+asKZ1m8n0t6oFTump2pH7UTFeQraxsOsZBY2
         n+uKc96SqHqZUHlCG6Nu46fnplgXjA1TUdPW7nTDJ824s5zf88T/HV3PHkauK1dS2DZb
         A51cFswJALi6lfjBocOseRCkFQNXj9qn6oAyL1kHycXxEFNTCN8dFswxvzT1iWPnMaYY
         mPFQ==
X-Gm-Message-State: AOAM5300LAWZEyarnbRvDvOmeZz4KOvV32vFo4mwyNAkchziChJpDVRz
        JYeeioUKUs8uVadw2PD5isDOD19D2V+Kng==
X-Google-Smtp-Source: ABdhPJzdx+JZeNHp+KPtO/wdRkQkL6TPpEDq/CBq5CAe/wFyqK3XZpxvNIOUdhxxMPMOmxT08Ohjmw==
X-Received: by 2002:a17:902:d2c7:b0:154:5aa1:a55b with SMTP id n7-20020a170902d2c700b001545aa1a55bmr12913770plc.5.1648231704705;
        Fri, 25 Mar 2022 11:08:24 -0700 (PDT)
Received: from google.com (249.189.233.35.bc.googleusercontent.com. [35.233.189.249])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm6012843pgj.85.2022.03.25.11.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 11:08:23 -0700 (PDT)
Date:   Fri, 25 Mar 2022 18:08:20 +0000
From:   William McVicker <willmcvicker@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <Yj4FFIXi//ivQC3X@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
 <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
 <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
 <YjpGlRvcg72zNo8s@google.com>
 <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
 <Yjzpo3TfZxtKPMAG@google.com>
 <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
 <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/25/2022, Johannes Berg wrote:
> On Fri, 2022-03-25 at 09:49 -0700, Jakub Kicinski wrote:
> > On Fri, 25 Mar 2022 13:04:23 +0100 Johannes Berg wrote:
> > > So we can avoid the potential deadlock in cfg80211 in a few ways:
> > > 
> > >  1) export rtnl_lock_unregistering_all() or maybe a variant after
> > >     refactoring the two versions, to allow cfg80211 to use it, that way
> > >     netdev_run_todo() can never have a non-empty todo list
> > > 
> > >  2) export __rtnl_unlock() so cfg80211 can avoid running
> > >     netdev_run_todo() in the unlock, personally I like this less because
> > >     it might encourage random drivers to use it
> > > 
> > >  3) completely rework cfg80211's locking, adding a separate mutex for
> > >     the wiphy list so we don't need to acquire the RTNL at all here
> > >     (unless the ops need it, but there's no issue if we don't drop it),
> > >     something like https://p.sipsolutions.net/27d08e1f5881a793.txt
> > > 
> > > 
> > > I think I'm happy with 3) now (even if it took a couple of hours), so I
> > > think we can go with it, just need to go through all the possibilities.
> > 
> > I like 3) as well. FWIW a few places (e.g. mlx5, devlink, I think I've
> > seen more) had been converting to xarray for managing the "registered"
> > objects. It may be worth looking into if you're re-doing things, anyway.
> > 
> 
> That's not a bad idea, but I think I wouldn't want to backport that, so
> separately :) I don't think that fundamentally changes the locking
> properties though.
> 
> 
> Couple of more questions I guess: First, are we assuming that the
> cfg80211 code *is* actually broken, even if it looks like nothing can
> cause the situation, due to the empty todo list?

I'm able to reproduce this issue pretty easily with a Pixel 6 when I add
support to allow vendor commands to request for the RTNL. For this case, I just
delay unlocking the RTNL until nl80211_vendor_cmds() at which point I check the
flags to see if I should unlock before calling doit(). That allows me to run my
tests again and hit this issue. I imagine that I could hit this issue without
any changes if I re-work my vendor ops to not need the RTNL.

> 
> Given that we have rtnl_lock_unregistering() (and also
> rtnl_lock_unregistering_all()), it looks like we *do* in fact at least
> not want to make an assumption that no user of __rtnl_unlock() can have
> added a todo item.
> 
> I mean, there's technically yet *another* thing we could do - something
> like this:
> 
> [this doesn't compile, need to suitably make net_todo_list non-static]
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -95,6 +95,7 @@ void __rtnl_unlock(void)
>  
>         defer_kfree_skb_list = NULL;
>  
> +       WARN_ON(!list_empty(&net_todo_list));
>         mutex_unlock(&rtnl_mutex);
>  
>         while (head) {
> 
> and actually that would allow us to get rid of rtnl_lock_unregistering()
> and rtnl_lock_unregistering_all() simply because we'd actually guarantee
> the invariant that when the RTNL is freshly locked, the list is empty
> (by guaranteeing that it's always empty when it's unlocked, since it can
> only be added to under RTNL).
> 
> With some suitable commentary, that might also be a reasonable thing?
> __rtnl_unlock() is actually rather pretty rare, and not exported.
> 
> 
> However, if you don't like that ...
> 
> I've been testing with this patch, to make lockdep complain:
> 
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9933,6 +9933,11 @@ void netdev_run_todo(void)
>         if (!list_empty(&list))
>                 rcu_barrier();
>  
> +#ifdef CONFIG_LOCKDEP
> +       rtnl_lock();
> +       __rtnl_unlock();
> +#endif
> +
>         while (!list_empty(&list)) {
>                 struct net_device *dev
>                         = list_first_entry(&list, struct net_device, todo_list);
> 
> 
> That causes lockdep to complain for cfg80211 even if the list *is* in
> fact empty.
> 
> Would you be open to adding something like that? Perhaps if I don't just
> do the easy rtnl_lock/unlock, but try to find the corresponding lockdep-
> only things to do there, to cause lockdep to do things without really
> locking? OTOH, the locking overhead of the RTNL we just unlocked is
> probably minimal, vs. the actual work *lockdep* is doing to track all
> this ...
> 
> Thanks,
> johannes

Let me know if you'd like me to test any patches out.

Thanks,
Will
