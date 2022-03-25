Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C404E7D4D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiCYUhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiCYUhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:37:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8634710780D
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 13:36:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c23so9404569plo.0
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 13:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Emd/HGQ57f4JkVHbOiHNLwTEo/Oa19/GIbShZ2V2bh0=;
        b=BuCEUFhJva4yY81htIZCMYRvqXI9JtWl9NdLs2sLWYPFPidbkS9w5HDQYK0kNcP4x1
         SMhqVkVR0V/gwgk3U+11qK+t9DGUo/6q+oCO0SVcds1wDEjSOMmr7CGuMhRgSM6z8vSL
         gS7doJa5BwgulcMwbXgB8sK1kk3aeYhtIzILjEyibZIwV65ZMC3yM/t2q/h1AQfKp1NT
         qMcrtmA5zhbOFf5/AyBZtaBLlp92WAtckDQZmKb50xCCTq0zdWEsklmMoFL0Egt0bciN
         G+jgBjV+3du53eAUqpxmKvPQYqFASOniDqwHgHgiX9xtZ9rUtt3DlVO7G/QAT4K8MfLZ
         049w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Emd/HGQ57f4JkVHbOiHNLwTEo/Oa19/GIbShZ2V2bh0=;
        b=HbFmIdIWWSafrBz5+zTP4Kd2zyxXBQecuAk33FD+hxkEBynvlWa/ZVBcJDtn+lU+jz
         5OcpwDLkN87+WD/JtLRyoqmzOtRnlch2K1OQKISUp0pj4ARxMgIXPQClJ7cWT6xM96ie
         7NbE5quKVBr5XJVt4vp9EwGydT1YSCHQ77atG01Bd7YV/L8t1KPqyK6qFZt9CcUpsbvi
         JeFB7nr40AZqwGL54VfHtmcwKw99mAGmD7ZbefimvG5Elp8UAP/Su/6rBEkWKtFqMwzw
         z1xtS5x7TonBxYzoBZ6dBGpVJTd+vTq2wB0kUlIn+53byp2pekZzmBRPHC2rNhL/5QN1
         OehQ==
X-Gm-Message-State: AOAM530Wx4JTY3B21/o6JrPFR38gROS5V9SxFILgGxnTHrkuiiL5Itrn
        a2huGPrLKl8QI/qmWULAfhCpYg==
X-Google-Smtp-Source: ABdhPJxU8odwDhvBAksm4qaqwuo0z345MIT9U1J6wUZryuylxyyr76kghZAParNG259ykhVgZU7uFw==
X-Received: by 2002:a17:902:a581:b0:154:8c7d:736a with SMTP id az1-20020a170902a58100b001548c7d736amr13687879plb.74.1648240569769;
        Fri, 25 Mar 2022 13:36:09 -0700 (PDT)
Received: from google.com (249.189.233.35.bc.googleusercontent.com. [35.233.189.249])
        by smtp.gmail.com with ESMTPSA id t2-20020a056a0021c200b004faa4646fc1sm7770294pfj.36.2022.03.25.13.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 13:36:09 -0700 (PDT)
Date:   Fri, 25 Mar 2022 20:36:05 +0000
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
Message-ID: <Yj4ntUejxaPhrM5b@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
 <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
 <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
 <YjpGlRvcg72zNo8s@google.com>
 <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
 <Yjzpo3TfZxtKPMAG@google.com>
 <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
 <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
 <Yj4FFIXi//ivQC3X@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj4FFIXi//ivQC3X@google.com>
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

On 03/25/2022, William McVicker wrote:
> On 03/25/2022, Johannes Berg wrote:
> > On Fri, 2022-03-25 at 09:49 -0700, Jakub Kicinski wrote:
> > > On Fri, 25 Mar 2022 13:04:23 +0100 Johannes Berg wrote:
> > > > So we can avoid the potential deadlock in cfg80211 in a few ways:
> > > > 
> > > >  1) export rtnl_lock_unregistering_all() or maybe a variant after
> > > >     refactoring the two versions, to allow cfg80211 to use it, that way
> > > >     netdev_run_todo() can never have a non-empty todo list
> > > > 
> > > >  2) export __rtnl_unlock() so cfg80211 can avoid running
> > > >     netdev_run_todo() in the unlock, personally I like this less because
> > > >     it might encourage random drivers to use it
> > > > 
> > > >  3) completely rework cfg80211's locking, adding a separate mutex for
> > > >     the wiphy list so we don't need to acquire the RTNL at all here
> > > >     (unless the ops need it, but there's no issue if we don't drop it),
> > > >     something like https://p.sipsolutions.net/27d08e1f5881a793.txt
> > > > 
> > > > 
> > > > I think I'm happy with 3) now (even if it took a couple of hours), so I
> > > > think we can go with it, just need to go through all the possibilities.
> > > 
> > > I like 3) as well. FWIW a few places (e.g. mlx5, devlink, I think I've
> > > seen more) had been converting to xarray for managing the "registered"
> > > objects. It may be worth looking into if you're re-doing things, anyway.
> > > 
> > 
> > That's not a bad idea, but I think I wouldn't want to backport that, so
> > separately :) I don't think that fundamentally changes the locking
> > properties though.
> > 
> > 
> > Couple of more questions I guess: First, are we assuming that the
> > cfg80211 code *is* actually broken, even if it looks like nothing can
> > cause the situation, due to the empty todo list?
> 
> I'm able to reproduce this issue pretty easily with a Pixel 6 when I add
> support to allow vendor commands to request for the RTNL. For this case, I just
> delay unlocking the RTNL until nl80211_vendor_cmds() at which point I check the
> flags to see if I should unlock before calling doit(). That allows me to run my
> tests again and hit this issue. I imagine that I could hit this issue without
> any changes if I re-work my vendor ops to not need the RTNL.
> 
> > 
> > Given that we have rtnl_lock_unregistering() (and also
> > rtnl_lock_unregistering_all()), it looks like we *do* in fact at least
> > not want to make an assumption that no user of __rtnl_unlock() can have
> > added a todo item.
> > 
> > I mean, there's technically yet *another* thing we could do - something
> > like this:
> > 
> > [this doesn't compile, need to suitably make net_todo_list non-static]
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -95,6 +95,7 @@ void __rtnl_unlock(void)
> >  
> >         defer_kfree_skb_list = NULL;
> >  
> > +       WARN_ON(!list_empty(&net_todo_list));
> >         mutex_unlock(&rtnl_mutex);
> >  
> >         while (head) {
> > 
> > and actually that would allow us to get rid of rtnl_lock_unregistering()
> > and rtnl_lock_unregistering_all() simply because we'd actually guarantee
> > the invariant that when the RTNL is freshly locked, the list is empty
> > (by guaranteeing that it's always empty when it's unlocked, since it can
> > only be added to under RTNL).
> > 
> > With some suitable commentary, that might also be a reasonable thing?
> > __rtnl_unlock() is actually rather pretty rare, and not exported.
> > 
> > 
> > However, if you don't like that ...
> > 
> > I've been testing with this patch, to make lockdep complain:
> > 
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9933,6 +9933,11 @@ void netdev_run_todo(void)
> >         if (!list_empty(&list))
> >                 rcu_barrier();
> >  
> > +#ifdef CONFIG_LOCKDEP
> > +       rtnl_lock();
> > +       __rtnl_unlock();
> > +#endif
> > +
> >         while (!list_empty(&list)) {
> >                 struct net_device *dev
> >                         = list_first_entry(&list, struct net_device, todo_list);
> > 
> > 
> > That causes lockdep to complain for cfg80211 even if the list *is* in
> > fact empty.
> > 
> > Would you be open to adding something like that? Perhaps if I don't just
> > do the easy rtnl_lock/unlock, but try to find the corresponding lockdep-
> > only things to do there, to cause lockdep to do things without really
> > locking? OTOH, the locking overhead of the RTNL we just unlocked is
> > probably minimal, vs. the actual work *lockdep* is doing to track all
> > this ...
> > 
> > Thanks,
> > johannes
> 
> Let me know if you'd like me to test any patches out.
> 
> Thanks,
> Will

Hi Johannes,

I found that my wlan driver is using the vendor commands to create/delete NAN
interfaces for this Android feature called Wi-Fi aware [1]. Basically, this
features allows users to discover other nearby devices and allows them to
connect directly with one another over a local network. To get my driver
working again, I first had to allow the kernel to let my driver request for the
RTNL lock for these NAN create/delete interface vendor commands. With that
I got the following code path:


Thread 1                         Thread 2
 nl80211_pre_doit():
   rtnl_lock()
   wiphy_lock()                   nl80211_pre_doit():
                                    rtnl_lock() // blocked by Thread 1
 nl80211_vendor_cmd():
   doit()
     cfg80211_unregister_netdevice()
   rtnl_unlock():
     netdev_run_todo():
       __rtnl_unlock()
                                    <got RTNL lock>
                                    wiphy_lock() // blocked by Thread 1
       rtnl_lock(); // DEADLOCK
 nl80211_post_doit():
   wiphy_unlock();


Since I'm unlocking the RTNL inside nl80211_vendor_cmd() after calling doit()
instead of waiting till post_doit(), I get into the situation you mentioned
where the net_todo_list is not empty when calling rtnl_unlock. So I decided to
drop the rtnl_unlock() in nl80211_vendor_cmd() and defer that until
nl80211_post_doit() after calling wiphy_unlock(). With this change, I haven't
been able to reproduce the deadlock. So it's possible that we aren't actually
able to hit this deadlock in nl80211_pre_doit() with the existing code since,
as you mentioned, one wouldn't be able to call unregister_netdevice() without
having the RTNL lock.

Sorry if I sent you down a rabbit hole with the first code path scenario.

Thanks,
Will

[1] https://developer.android.com/guide/topics/connectivity/wifi-aware
