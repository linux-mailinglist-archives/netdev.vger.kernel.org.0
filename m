Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E2652BD3
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 04:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbiLUDeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 22:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLUDeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 22:34:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4767F1FCFF
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 19:34:03 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 4so14290209plj.3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 19:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZckNp/SxSb41wyWcqGUpv2efaBxW8UzQQeYvh9J6sKs=;
        b=TrAGnHEdoZ50fbI2KnrvEVP5JIEE13G2+DIJ9m/ZX80HcTHKvIIZ8JiIvLWYGYAbsZ
         dU7cnT5k1pepFmf6dmvXX47T2AAxY78vrct+X56maOG+qsrfgZg2e99OXopn5vaBwx6y
         i5WYeGkBjsIF0rAArtsNlPVtiSNUidjMops3z26A+aGZbfTSP/lyTZ757Z4MPVGBoc8X
         hiSGWwQd8a++33BeQI/jxXxCCIgaxPq80khUaVEWvLcALhU+9gZHZi8MZMDNllJHWHVx
         15k2C1NeEHUSkLE7Tfp53vYC2XcSzasdtZM/dJ93OrRxp54oqJovz/ntGFIXIBPSwh/p
         DyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZckNp/SxSb41wyWcqGUpv2efaBxW8UzQQeYvh9J6sKs=;
        b=fB8nzEPwmbKmIGrQW56VZSiyHbzepp8K5aN0vWP4ymMcrTetiGL295BPugmPgT6HL2
         qJ0YFDdlq4eVn8S+LVpoOSi99vPnhqlHB28fnGQ9x09R3n9kI2fT/Fy6KeEpxkgvwb4i
         1oWN0uK/bFaDJlFdHPKTwS7R7ti9XeqlPFL/2ht/8AHzqMfi5OpO0RDBtUYlQwNaMMDk
         5JefI37uS6zysvbN/ivOnewT0/grK2fyJ4qRAVKT1qlkiQI/lvth4BRXPM6l2GFSoJd6
         nausxtPhyiX0CMk8eVGUZloPeHYdH3vJUI4dO2GeafwuwkQrtuKardm3QX5XYmY01IOx
         nNBg==
X-Gm-Message-State: AFqh2kpIjm0D/tRRAsIk1XaQkoKdRw/0NTZhHmMYZgBRhocUzgteDx5s
        WPBNUXcf4npbJneHYwRPk6I=
X-Google-Smtp-Source: AMrXdXtdvzB/HHJJUc0fiC/ka3HDnhIQ6jgizN4Zmd/UZlZ4hQc5H5UgSySY3vLr39XDzkgbg3OIOg==
X-Received: by 2002:a17:902:b402:b0:188:d434:9c67 with SMTP id x2-20020a170902b40200b00188d4349c67mr450528plr.32.1671593642809;
        Tue, 20 Dec 2022 19:34:02 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ja5-20020a170902efc500b001873aa85e1fsm10105657plb.305.2022.12.20.19.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 19:34:01 -0800 (PST)
Date:   Wed, 21 Dec 2022 11:33:56 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] bonding: fix lockdep splat in bond_miimon_commit()
Message-ID: <Y6J+pOX5hAupkge2@Laptop-X1>
References: <20221220130831.1480888-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220130831.1480888-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 01:08:31PM +0000, Eric Dumazet wrote:
> bond_miimon_commit() is run while RTNL is held, not RCU.
> 
> WARNING: suspicious RCU usage
> 6.1.0-syzkaller-09671-g89529367293c #0 Not tainted
> -----------------------------
> drivers/net/bonding/bond_main.c:2704 suspicious rcu_dereference_check() usage!
> 
> Fixes: e95cc44763a4 ("bonding: do failover when high prio link up")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> ---
>  drivers/net/bonding/bond_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index b4c65783960a5aa14de5d64aeea190f02a04be44..0363ce597661422b82a7d33ef001151b275f9ada 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2654,10 +2654,12 @@ static void bond_miimon_link_change(struct bonding *bond,
>  
>  static void bond_miimon_commit(struct bonding *bond)
>  {
> -	struct slave *slave, *primary;
> +	struct slave *slave, *primary, *active;
>  	bool do_failover = false;
>  	struct list_head *iter;
>  
> +	ASSERT_RTNL();
> +
>  	bond_for_each_slave(bond, slave, iter) {
>  		switch (slave->link_new_state) {
>  		case BOND_LINK_NOCHANGE:
> @@ -2700,8 +2702,8 @@ static void bond_miimon_commit(struct bonding *bond)
>  
>  			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
>  
> -			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary ||
> -			    slave->prio > rcu_dereference(bond->curr_active_slave)->prio)
> +			active = rtnl_dereference(bond->curr_active_slave);
> +			if (!active || slave == primary || slave->prio > active->prio)
>  				do_failover = true;

Hi Eric,

Thanks for the fix. I have some silly questions.

Is there an easy way or tool that could find if the functions is holding via
RTNL lock or RCU lock, except review all the call chains? I have faced
this issue in commit 9b80ccda233f ("bonding: fix missed rcu protection"),
which we though the function is under RTNL, while there is a call chain that
not hold rcu lock. Adding ASSERT_RTNL() could find it during running. I just
want to know if there is another way that we could find it in code review.


Another questions is, I'm still a little confused with the mixing usage of
rcu_access_pointer() and rtnl_dereference() under RTNL. e.g.

In bond_miimon_commit() we use rcu_access_pointer() to check the pointers.
                case BOND_LINK_DOWN:
                        if (slave == rcu_access_pointer(bond->curr_active_slave))
                                do_failover = true;

In bond_ab_arp_commit() we use rtnl_dereference() to check the pointer

                case BOND_LINK_DOWN:
                        if (slave == rtnl_dereference(bond->curr_active_slave)) {
                                RCU_INIT_POINTER(bond->current_arp_slave, NULL);
                                do_failover = true;
                        }
                case BOND_LINK_FAIL:
                        if (rtnl_dereference(bond->curr_active_slave))
                                RCU_INIT_POINTER(bond->current_arp_slave, NULL);

Does it matter to use which one? Should we change to rcu_access_pointer()
if there is no dereference?

Thanks
Hangbin
