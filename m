Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DA72C8FBC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388445AbgK3VNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388399AbgK3VNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 16:13:22 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E2DC061A47
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:12:03 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id lt17so24718995ejb.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7SSb9LpNKOTHcMgqPZmthF8hilSqFmQSWg6jVF9HDS0=;
        b=DLeusId18xwDKgQY4e8SSzN0FDKHLRnxfWU2kbPqMNIQ0npMsn/FM2ghy0AbyfL1JU
         7oYw+ORX8WLGWLg3f6rnuAt+yLnD2VyLlTXRfkJYmbtc4XwTb1UGVMnVDe90k88++rgL
         NmlmIjqigAzgO8PYcbsLSUiHEEPVhfFZQ2J6EO4i7GLHkP+0Q7MOta1HGkBj5xavadYI
         HSbP/tVSx9vhujlwUjujBVMTdzDgi2pnPLhYBYn6VbD6j2w9EL/xI4IeOvgzYLomf8JA
         HbPqPFaU0/3taCtAEFke+bZW1pCpdxD5ZxIIuf73tluWQAbrt9OxC17ywM2Y85zVR1LY
         u9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7SSb9LpNKOTHcMgqPZmthF8hilSqFmQSWg6jVF9HDS0=;
        b=nRf8fUA8vMIa5hk36iW6oI4C6zcEjus6md3SGMS+z93sKZkoJSEAplGIaVQxLw7wjx
         0hUG3J4V2pCDFvX5X/5TObkx3YOFQ4iQ5pplM+gSBFjxm7hXjYYznIkeVaX9PSn1IlZw
         scup6VzG0ZY9pF9BUtfrtFFwmEbPdmxHGGDS0jibDBBpBuPw5ZTmmjvv97AT1nje1ZpV
         92o2hLFPStBIx5V/gzXaGr4ntK/crHrez2PPLHpef0ic7GFz5tfkpUpMKVdgPftW9EFi
         CHt/XzzDbcWuh+yeYrVxXeT4FunGTw34SRgW9J6ITWR6wAKmRgQmuYyo86kUnzmfZS3G
         xEiA==
X-Gm-Message-State: AOAM5333qIH4aVSAEGUf+6Aj3/fZYMRBJAVh4jr230brW8iye7tHDO/P
        Cyz/7AhHzZYrTwQ8SsamC9o=
X-Google-Smtp-Source: ABdhPJxysgG+8198Q15y3pgK5c8+7WcqdbxCpnq5Dkw5Vp6lLbNLoY2rroGNFouOW9uJBaqFa1vXMw==
X-Received: by 2002:a17:906:5847:: with SMTP id h7mr22210317ejs.124.1606770720725;
        Mon, 30 Nov 2020 13:12:00 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id z24sm1132868ejc.47.2020.11.30.13.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 13:11:59 -0800 (PST)
Date:   Mon, 30 Nov 2020 23:11:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130211158.37ay2uvdwcnegw45@skbuf>
References: <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf>
 <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf>
 <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf>
 <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
 <20201130205053.mb6ouveu3nsts3np@skbuf>
 <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 10:00:16PM +0100, Eric Dumazet wrote:
> On Mon, Nov 30, 2020 at 9:50 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Mon, Nov 30, 2020 at 09:43:01PM +0100, Eric Dumazet wrote:
> > > Understood, but really dev_base_lock can only be removed _after_ we
> > > convert all usages to something else (mutex based, and preferably not
> > > the global RTNL)
> >
> > Sure.
> > A large part of getting rid of dev_base_lock seems to be just:
> > - deleting the bogus usage from mlx4 infiniband and friends
> > - converting procfs, sysfs and friends to netdev_lists_mutex
> > - renaming whatever is left into something related to the RFC 2863
> >   operstate.
> >
> > > Focusing on dev_base_lock seems a distraction really.
> >
> > Maybe.
> > But it's going to be awkward to explain in words what the locking rules
> > are, when the read side can take optionally the dev_base_lock, RCU, or
> > netdev_lists_lock, and the write side can take optionally the dev_base_lock,
> > RTNL, or netdev_lists_lock. Not to mention that anybody grepping for
> > dev_base_lock will see the current usage and not make a lot out of it.
> >
> > I'm not really sure how to order this rework to be honest.
>
> We can not have a mix of RCU /rwlock/mutex. It must be one, because of
> bonding/teaming.
>
> So all existing uses of rwlock / RCU need to be removed.
>
> This is probably not trivial.

Now, "it's going to look nasty" is one thing, whereas "it won't work" is
completely different. I think it would work though, so could you expand
on why you're saying we can't have the mix? dev_change_name(),
list_netdevice() and unlist_netdevice() just need to take one more layer
of locking. The new netdev_lists_mutex would serve as a temporary
alternative to the RTNL mutex. Then we could gradually replace more and
more of the RTNL mutex with netdev_lists_mutex. The bonding driver can
certainly use the netdev_lists_mutex. It guarantees protection against
the three functions mentioned above, and it is sleepable, and it is not
the RTNL mutex. So can procfs and sysfs. Am I missing something?

> Perhaps you could add a temporary ndo_get_sleepable_stats64() so that
> drivers can be converted one at a time.

Yeah, been there, Jakub doesn't like it.
