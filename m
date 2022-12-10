Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485DD649009
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 18:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLJRlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 12:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLJRlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 12:41:14 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDB1639D
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 09:41:13 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3b48b139b46so92043317b3.12
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 09:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=POM/Z3J7Q0eTF2PFSBZeJLfrtp00ZJPExFXrsCWco7Q=;
        b=Pn1ZcfCdkRVcnyGtOH+5MrEXyhRCaDtLZTMCqAJVk8Z3TZ4mTILfGVsbII07UuEUJs
         FHLVqfLhUCySkPA7KEfJGjc4OqXm+eDzKUtCJ9UuR/AKiq6rVyopzVjXCFHmdK+Cboml
         Jsq1oVksgGzwLDlBMsepE6bOGqF+VLue4KX4FnxbpMo8rVl6wE3WDXDCTn3entv8NErL
         bV5BQ3FVWDLnJ75+W4+SgnAuOdtaGHVBCRXa4NAtJKQaLtT1eVdQold2iFFrRSx+RNv5
         KIM6YBNCdMe4kYRrFjVBOd3C6Umy1mcxJMZxj7BSW2Kp61/TiGgFktIo3ZvTysAD/7rL
         Eoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POM/Z3J7Q0eTF2PFSBZeJLfrtp00ZJPExFXrsCWco7Q=;
        b=7be3KQoTbdaT8mQwMMQ94T8JlBfHyCnV1GIS9WAu93MwNhN5EEAwmQWe17Vt+uJrm5
         2kw/8BqR1GYtyjhHsgWaKJzPB4YMKfMGCAcGEQxCs8eh3uNOXXhJz0aOC6SRMUoBJyC8
         CoUdpPP4E4jQ58c8597mkYLke04Tcn7CO4q+nQpUF4coLjwRBJl19gx96/rPVwgiXJPZ
         0AfNhyBIfjvR6sQuRfM43IVgWwGCCSFTtwBXV6XrJ7i/lrmb8JvBCRoZQLQVspbIB4zp
         yisgLMItT57PAqympWxItGqH4Ex8zlhPcVuOnR4uUT8IwIKLYSFyuN4OVC1N5xCXkrLq
         uhbg==
X-Gm-Message-State: ANoB5plG/idrUY6fLl9S3ZNCQwo9qlLm/YCOhqqVk3wXRjg04+IYtmxB
        sisED/enbcWYUNJPeqeCcAFPsaNbDWIRPMG4BNTyxQ==
X-Google-Smtp-Source: AA0mqf5yBg8SNuLi0dQ9esoOMvB61cnXs907zTktuSNLbvQn7tYLMqJnruNmEt0kO9Hp2AEI5tN8SRsbBQeZxy6fy6A=
X-Received: by 2002:a81:16d1:0:b0:3bf:1589:6ba6 with SMTP id
 200-20020a8116d1000000b003bf15896ba6mr56143514yww.255.1670694072652; Sat, 10
 Dec 2022 09:41:12 -0800 (PST)
MIME-Version: 1.0
References: <20221209101305.713073-1-liuhangbin@gmail.com> <20221209101305.713073-2-liuhangbin@gmail.com>
 <CANn89iK8TEtpZa67-FfR6KFKAj_HCdtn3573Z9Cd7PG26WP3iA@mail.gmail.com> <Y5R7ZDfKkZKZe9j1@Laptop-X1>
In-Reply-To: <Y5R7ZDfKkZKZe9j1@Laptop-X1>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 10 Dec 2022 18:41:01 +0100
Message-ID: <CANn89iKh3M+mL_Yh_oAX0T6b9mAu6_JZKZwunH377bJNusuTKA@mail.gmail.com>
Subject: Re: [PATCH net 1/3] bonding: access curr_active_slave with rtnl_dereference
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, liali <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 1:28 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Sat, Dec 10, 2022 at 12:58:59AM +0100, Eric Dumazet wrote:
> > On Fri, Dec 9, 2022 at 11:13 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >
> > > Looks commit 4740d6382790 ("bonding: add proper __rcu annotation for
> > > curr_active_slave") missed rtnl_dereference for curr_active_slave
> > > in bond_miimon_commit().
> > >
> > > Fixes: 4740d6382790 ("bonding: add proper __rcu annotation for curr_active_slave")
> >
> >
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > > ---
> > >  drivers/net/bonding/bond_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > > index b9a882f182d2..2b6cc4dbb70e 100644
> > > --- a/drivers/net/bonding/bond_main.c
> > > +++ b/drivers/net/bonding/bond_main.c
> > > @@ -2689,7 +2689,7 @@ static void bond_miimon_commit(struct bonding *bond)
> > >
> > >                         bond_miimon_link_change(bond, slave, BOND_LINK_UP);
> > >
> > > -                       if (!bond->curr_active_slave || slave == primary)
> > > +                       if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)
> >
> > We do not dereference the pointer here.
> >
> > If this is fixing a sparse issue, then use the correct RCU helper for this.
> >
> > ( rcu_access_pointer())
>
> Hmm... I saw in 4740d6382790 ("bonding: add proper __rcu annotation for
>  curr_active_slave") there are also some dereference like that. Should I also
> fix them at the same time? e.g.

There is no 'fix' really. I do not see any reason to change this part.

It is merely a matter of repeating or not the fact that RTNL (or
another lock) is held.

>
> @@ -2607,8 +2612,8 @@ static void bond_ab_arp_commit(struct bonding *bond)
>
>                 case BOND_LINK_UP:
>                         trans_start = dev_trans_start(slave->dev);
> -                       if (bond->curr_active_slave != slave ||
> -                           (!bond->curr_active_slave &&
> +                       if (rtnl_dereference(bond->curr_active_slave) != slave ||
> +                           (!rtnl_dereference(bond->curr_active_slave) &&
>

At the time of commit  4740d6382790 we wanted to make sure the
bond->curr_slave_lock
was taken, because it was the assertion at that time.

Then later, bond_deref_active_protected() has been removed, because
curr_slave_lock has been removed.

$ git log --oneline --reverse
b25bd2515ea32cf5ddd5fd5a2a93b8c9dd875e4f..8c0bc550288d81e9ad8a2ed9136a72140b9ef507
86e749866d7c6b0ee1f9377cf7142f2690596a05 bonding: 3ad: clean up
curr_slave_lock usage
62c5f5185397f4bd8e5defe6fcb86420deeb2b38 bonding: alb: remove curr_slave_lock
1c72cfdc96e63bf975cab514c4ca4d8a661ba0e6 bonding: clean curr_slave_lock use
b743562819bd97cc7c282e870896bae8016b64b5 bonding: convert
curr_slave_lock to a spinlock and rename it
4bab16d7c97498e91564231b922d49f52efaf7d4 bonding: alb: convert to
bond->mode_lock
e470259fa1bd7ce5a375b16c5ec97cc0e83b058d bonding: 3ad: convert to
bond->mode_lock
8c0bc550288d81e9ad8a2ed9136a72140b9ef507 bonding: adjust locking comments


Now, you post a patch for bond_miimon_commit() which already has :

if (slave == rcu_access_pointer(bond->curr_active_slave))
      goto do_failover;

So really it is a matter of consistency in _this_ function, which is
run under RTNL for sure.

It is also a patch for net-next tree, because it fixes no bug.

I would not add a Fixes: tag to avoid dealing with useless backports.
