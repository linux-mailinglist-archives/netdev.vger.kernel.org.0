Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5861648E99
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 13:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiLJMXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 07:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJMXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 07:23:40 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2C419C1D
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:23:39 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 62so5248361pgb.13
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HyYsO7GA6hNl0DeJ1s8HT2CUCWV4okfF/q80rQzBuT8=;
        b=Q23nrkof/39j2MUl2ImZ4omGGfgG0HpynzV5nIj1BwdnnQV2gL3ieY5V4mzPNaJmQ+
         frzYvpNAH7LvFgKBowbsk/3GVwyf++uGhAb7MoLqYmSvYVcrvFIspW7ihOarOHE2/LVP
         74EFUZ0nbnFQEIARVTsCnBju1PLegAe+IVpReE8falWUEqtNq5NF/z3HQ6rbF0Cp/eDB
         10915fWdk4xq+oqGTTbtbCzl74JnejLZ/DhEFr9a+dFsOiWEVcqzAnrbYISzXACA5e0o
         YqIN9ND7luI4DvtB7NdZrZLxDDPeqndHLnRdE91exPeavJAvtmbd2IqTKWAPLwPz3idV
         HVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HyYsO7GA6hNl0DeJ1s8HT2CUCWV4okfF/q80rQzBuT8=;
        b=ctcgtbxUMDvuKTzd6pAfO5/RjFbD71Ad0yAxynVrmQB31ofGGMIJh/hGmcAdBspJoj
         NQsbbTdNL5XXMM9hWCwAYkPvhWKUPdH1j8mK2H0F3Ira1vXFSqhMI50LQSLlZBKayRJO
         ZKrcHDH9RcCHVBerP9+3YDefzkkIzkmO49mzf4vW5hmL+KCODYrQHHNn9r09sjouBX9q
         t56R1Z0WsNiD8a6u9gcvF1cVaw/nyX5cYcPWE+aM5140kT8rT67Z1CbYEoTvgHQZnRNk
         ODISSqCiwRBzcBD0K23Cu5ZvOE3jIzMEk9+4buZH3+T2kSXlKfNyzOKe16P7FVZaE1D6
         XqQA==
X-Gm-Message-State: ANoB5pl6R2xkrQtgJBslXwBcP/lCfsPBOSpg3GD5Job4l0SljyRgvps1
        jajRBn6UUaDI/ugE9XdjZ9Y=
X-Google-Smtp-Source: AA0mqf5HOQ9PwAC2Izq3rVqGU+a4xhzf8qNzoKKCHGXyszzWfZZV+XugKDO2ZBOkjE0yKwFUqXiOTw==
X-Received: by 2002:a05:6a00:24cf:b0:576:1747:8525 with SMTP id d15-20020a056a0024cf00b0057617478525mr11969539pfv.15.1670675018980;
        Sat, 10 Dec 2022 04:23:38 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b00561d79f1064sm2686644pfb.57.2022.12.10.04.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 04:23:37 -0800 (PST)
Date:   Sat, 10 Dec 2022 20:23:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>
Subject: Re: [PATCH net 2/3] bonding: do failover when high prio link up
Message-ID: <Y5R6Qy+j6xlVgzUh@Laptop-X1>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
 <20221209101305.713073-3-liuhangbin@gmail.com>
 <Y5PM1z1SEdWFgkui@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5PM1z1SEdWFgkui@x130>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 04:03:35PM -0800, Saeed Mahameed wrote:
> On 09 Dec 18:13, Hangbin Liu wrote:
> > Currently, when a high prio link enslaved, or when current link down,
> > the high prio port could be selected. But when high prio link up, the
> > new active slave reselection is not triggered. Fix it by checking link's
> > prio when getting up.
> > 
> > Reported-by: Liang Li <liali@redhat.com>
> > Fixes: 0a2ff7cc8ad4 ("Bonding: add per-port priority for failover re-selection")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > drivers/net/bonding/bond_main.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index 2b6cc4dbb70e..dc6af790ff1e 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -2689,7 +2689,8 @@ static void bond_miimon_commit(struct bonding *bond)
> > 
> > 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
> > 
> > -			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)
> > +			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary ||
> > +			    slave->prio > rtnl_dereference(bond->curr_active_slave)->prio)
> > 				goto do_failover;
> 
> I am not really familiar with this prio logic, seems to be new. Anyway, what
> if one of the next slaves has higher prio than this slave and the
> current active ? I see that the loop over all the slaves continues even
> after the failover,
> but why would you do all these failovers until you settle on the highest
> prio one ?

Thanks, this makes sense to me. I will fix it.

Hangbin
> 
> shouldn't you do something similar to bond_choose_primary_or_current()
> outside the loop, once you've updated all the slaves link states
> 
> Please let me know if I am wandering in the wrong directions
> Anyway, LGTM:
> 
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> 
> 
> 
> 
> 
> 
> 
