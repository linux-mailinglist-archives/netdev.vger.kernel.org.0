Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74562C8F94
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387549AbgK3VBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbgK3VBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 16:01:09 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344FDC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:00:29 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n14so8491192iom.10
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eTIUDT/AXze8zLIy/6iuivJR2lWy5FUmo4bA26c5RMo=;
        b=F5Y00HIOgWDjqcC6JelYSH6V5BVQuq8D3yXpsIZeNSsAsmLeXoey7AyidKVwaFbpoE
         oHFpNdXSc4gvESsg+lqAYZqFr83FcgUTWAVd+mjXVKruX0CpFxl/JNZHXWBxCVj+VaPX
         waIpUETcdlNHxr+xUUniwVyjuk3/O0EuIKa+bNoLd9DeLJPonTWlwlNn1uXsX3OMqpgp
         dJs7bqAROgrg+ZJmDyRoaSVEhl1ACIcEWDn50W1NhoQ6GGHQX8K+NBMsrScBO8KesjBK
         AGgcqZFlibpMJyF3vS0CEca7pqgKy0KqWj4aaHj0ywn+bRN9ji2xh2TzJ3egbokj3yc6
         R27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eTIUDT/AXze8zLIy/6iuivJR2lWy5FUmo4bA26c5RMo=;
        b=i01TtuopLttNz3OSB+yCwMdpIglqAjamAVcQQZDhZio+BrkSa2HdnWenJSy+cEb9G7
         jIn7U0jewhWBPpwqFXcq7ARvee9zJfjiC5D+adt2x5o0sByr/JWe3ORBrWS0AlzU0+we
         47J2jEDXAfX/a8ARxRFJTkMneJ3uS8byc5k4IRNX2Qt4xoTHJpbMiNAyXL0brWMz+lY8
         yKWNfp/vu+CdgAR+D/+t34wM9MVoD3en4XCAsN/Y4J21Fe6SBB5n8LTTTebhbGEJ5dx/
         ANHzqQBmkFEZweLzeneXIv1foSN6nwCoqtAZL2QROr5dVN/W91RHoMk1c5vDimiiiwoK
         Wqnw==
X-Gm-Message-State: AOAM530EpoCjcSx0OUcyTPoFHuGWqQobFyP+3LGhahNYxbflrnaYcf6r
        UyVFacDCwWBbZ8MBUnDh+RlJCm1iyihJSxUVijzRgA==
X-Google-Smtp-Source: ABdhPJz+hIWq9y327Wu2egCJifrbhQqVPHIIx0HiquaHkPyLqyP19JEVMBQstAOIXhVkyyy+i4Y1rYkFv6Bzy46MAgE=
X-Received: by 2002:a6b:6418:: with SMTP id t24mr17879350iog.145.1606770028326;
 Mon, 30 Nov 2020 13:00:28 -0800 (PST)
MIME-Version: 1.0
References: <20201130184828.x56bwxxiwydsxt3k@skbuf> <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf> <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf> <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf> <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf> <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
 <20201130205053.mb6ouveu3nsts3np@skbuf>
In-Reply-To: <20201130205053.mb6ouveu3nsts3np@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 22:00:16 +0100
Message-ID: <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 9:50 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 09:43:01PM +0100, Eric Dumazet wrote:
> > Understood, but really dev_base_lock can only be removed _after_ we
> > convert all usages to something else (mutex based, and preferably not
> > the global RTNL)
>
> Sure.
> A large part of getting rid of dev_base_lock seems to be just:
> - deleting the bogus usage from mlx4 infiniband and friends
> - converting procfs, sysfs and friends to netdev_lists_mutex
> - renaming whatever is left into something related to the RFC 2863
>   operstate.
>
> > Focusing on dev_base_lock seems a distraction really.
>
> Maybe.
> But it's going to be awkward to explain in words what the locking rules
> are, when the read side can take optionally the dev_base_lock, RCU, or
> netdev_lists_lock, and the write side can take optionally the dev_base_lock,
> RTNL, or netdev_lists_lock. Not to mention that anybody grepping for
> dev_base_lock will see the current usage and not make a lot out of it.
>
> I'm not really sure how to order this rework to be honest.

We can not have a mix of RCU /rwlock/mutex. It must be one, because of
bonding/teaming.

So all existing uses of rwlock / RCU need to be removed.

This is probably not trivial.

Perhaps you could add a temporary ndo_get_sleepable_stats64() so that
drivers can be converted one at a time.
