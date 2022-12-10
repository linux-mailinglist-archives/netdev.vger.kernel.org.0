Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2849648EA1
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLJM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 07:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLJM23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 07:28:29 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0676813F8A
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:28:29 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so10983816pjp.1
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=khaFcQPgARo1xpJyDK3o+f2PSJeT9FNZ3ZSgfSykN5E=;
        b=etD3+wZhpv5OqXPxUx+n5uvDC8vc8uCS5Ru+xsEPz963oXbnFkOiW87hi6F92ZF34G
         IpAenyrFIL9/C6G+r0D1n7fuYNG/JjS4QzJRJjYtO5edrKNaY+ciFUaf5HDq3x6v2kOh
         X9PSm4Sw2OFpLoIP6FJnfS5FEk+Bgi3AbQ/iYcSL2lB8jcax5/TjsYmkIaegy5te1dSG
         DVFHF01AI5CXQf4NjrPqvhbB20/hSKYI0FeIk0yL/enJsNchV0AjVJH6N8R82L5EbWwl
         G38aqlskHQGhHD/pWIBDW9NscprFcDvgycHS534Y4KuVHL5VsmVMEEFrEeVyzvKPeVnI
         e18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=khaFcQPgARo1xpJyDK3o+f2PSJeT9FNZ3ZSgfSykN5E=;
        b=iXNPmNuPOAJlPRxZJQSlK58o6mRNyQIqcCXhY85aW0Z91JQPwafoEYw4HKciJCbelk
         dtq8v5Y9HaOMQWh73YKXc/DRTlIa/FcgrDpAtiS8xrhHyPa/Y7Bd10U4OKE9ccFRtTH+
         skrv5XHN9TZn9j9GQmBrL2zFXGE4XMu9wNyA3jITBpBOVS7/BPyw7nVAeSZRtvFn7flV
         h6/zZ/N2LgXSHVW2H/qsiWPbvXk/Xr2Y01JPJEbCiaRsfcZj4xKTJn8OigHx46Mlvnsb
         dBdBLwUEOPeHbv4ZfEWcyFbi+CPz9Kyxa8xbMO3y7xLnmNXNBSouYDdoLqvfJfxv0DZq
         AO0A==
X-Gm-Message-State: ANoB5pnw5Jo4Mv43hjzA2eVOpB1tU2mUuiI+2qw69Wm6Tz59opYVgCQI
        Rp4H04zDllBprcIIhELNkqLWc7ItJKe4L2j5
X-Google-Smtp-Source: AA0mqf5m1zWi9OIQJgluU5RVlG2dLgOHcszOKN3THswP3AIuHcitzdeosDvopxkTKG0WZ9iBG+mfJw==
X-Received: by 2002:a17:902:cec4:b0:189:eec5:ff71 with SMTP id d4-20020a170902cec400b00189eec5ff71mr14280179plg.44.1670675308495;
        Sat, 10 Dec 2022 04:28:28 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902dac600b00189a50d2a3esm2887719plx.241.2022.12.10.04.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 04:28:27 -0800 (PST)
Date:   Sat, 10 Dec 2022 20:28:20 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, liali <liali@redhat.com>
Subject: Re: [PATCH net 1/3] bonding: access curr_active_slave with
 rtnl_dereference
Message-ID: <Y5R7ZDfKkZKZe9j1@Laptop-X1>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
 <20221209101305.713073-2-liuhangbin@gmail.com>
 <CANn89iK8TEtpZa67-FfR6KFKAj_HCdtn3573Z9Cd7PG26WP3iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK8TEtpZa67-FfR6KFKAj_HCdtn3573Z9Cd7PG26WP3iA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 12:58:59AM +0100, Eric Dumazet wrote:
> On Fri, Dec 9, 2022 at 11:13 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > Looks commit 4740d6382790 ("bonding: add proper __rcu annotation for
> > curr_active_slave") missed rtnl_dereference for curr_active_slave
> > in bond_miimon_commit().
> >
> > Fixes: 4740d6382790 ("bonding: add proper __rcu annotation for curr_active_slave")
> 
> 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  drivers/net/bonding/bond_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index b9a882f182d2..2b6cc4dbb70e 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -2689,7 +2689,7 @@ static void bond_miimon_commit(struct bonding *bond)
> >
> >                         bond_miimon_link_change(bond, slave, BOND_LINK_UP);
> >
> > -                       if (!bond->curr_active_slave || slave == primary)
> > +                       if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)
> 
> We do not dereference the pointer here.
> 
> If this is fixing a sparse issue, then use the correct RCU helper for this.
> 
> ( rcu_access_pointer())

Hmm... I saw in 4740d6382790 ("bonding: add proper __rcu annotation for
 curr_active_slave") there are also some dereference like that. Should I also
fix them at the same time? e.g.

@@ -2607,8 +2612,8 @@ static void bond_ab_arp_commit(struct bonding *bond)

                case BOND_LINK_UP:
                        trans_start = dev_trans_start(slave->dev);
-                       if (bond->curr_active_slave != slave ||
-                           (!bond->curr_active_slave &&
+                       if (rtnl_dereference(bond->curr_active_slave) != slave ||
+                           (!rtnl_dereference(bond->curr_active_slave) &&

Thanks
Hangbin
