Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4102C90E2
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgK3WVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbgK3WVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:21:22 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00D1C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:20:35 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id d7so4673309iok.1
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gEG1/n/RFGX1/XHZCnegNUGNFaspyjlWndkreZ2Xkak=;
        b=bFV5RyxTgTdfm7fI9TJK3aBUTqiTrfE6k7gUA4fs4PEDe031BB+YXpsN1a5hkNaLss
         Q8ZmWISuyHA33J+QK0Dd4O8170MwVOv7MHHpluX+o2htZHg8Foxr7vq3qxJQNIdH/wxc
         /RfSwS7CJXW1xXkf6DUMfoWOncoDAolu9CIt7Vu8GViDUE50Qv3QzQO0Iq+vejgAWLm7
         vv05yiz9eQ8gnEI5/fwOIQVJJvzuHXKBq751w8S8WfiOXqekytbqxC8DYOhxzAApGtoz
         QdYAdQMxP1nd6iaH0jI/3fcY54RYnRnX3HEI+nN9rMZyVNt4GW2xmNaA7Y3MvCU9QIe5
         e5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gEG1/n/RFGX1/XHZCnegNUGNFaspyjlWndkreZ2Xkak=;
        b=nXP7QZN4KqghNT+yFhL7G5H/z5VP/UWlEQUSSJ65wUDwr/OBSnBHVfTygpl0DuVGHX
         Y7aOqqHHiVDJ1XJ0nw0YBiTMsWvrs+PC2nsVZBZJC/zq6VWTNrOQnHfsPGPERJ6r8wHO
         Rczq7kmWw7RAfBQmicjtuxrvSbZg+PZOaPEbWia84HhCQEmoW5yrC5685Mp40dtNOdeW
         l1lHF89jkSSGKGWsiVSkISnax8jz6CXm9QE6AP2P6bPnr5Tuy29na8ILhuUtRrxBM6ex
         OSBOs7feKP0K/4sPOrTDYcrJnvS0GPgw1DAptk7X0lmesm4mg2NrPjLWZQOG+dBDo19a
         3ErQ==
X-Gm-Message-State: AOAM530puwt80gCAlt+vLfAJCsAB8cGLCoh1X9ezLHwucioKbdIICYoP
        +LSlj81IrnP1BxM8CA1f65abdF8SseUjzap8u3jKbg==
X-Google-Smtp-Source: ABdhPJxw2WFT0G0XeNZaxrZcJuzEjarbv9gud3JxM5MZw/onOTxAQJBpDsU3swKGra2vzH0LT3W1p/TrTVOFj161A5U=
X-Received: by 2002:a02:7821:: with SMTP id p33mr20667818jac.53.1606774835178;
 Mon, 30 Nov 2020 14:20:35 -0800 (PST)
MIME-Version: 1.0
References: <20201130194617.kzfltaqccbbfq6jr@skbuf> <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf> <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf> <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
 <20201130205053.mb6ouveu3nsts3np@skbuf> <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
 <20201130211158.37ay2uvdwcnegw45@skbuf> <CANn89iJGA8qWBJ97nnNGNOuLNUYF5WPnL+qi722KYCD7kvKyCg@mail.gmail.com>
 <20201130215322.7arp3scumobdnvtz@skbuf>
In-Reply-To: <20201130215322.7arp3scumobdnvtz@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 23:20:23 +0100
Message-ID: <CANn89i+rZx4vex5N1RQE=y3uzd9yCjHOu5_6phUpZGyVmfUPOg@mail.gmail.com>
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

On Mon, Nov 30, 2020 at 10:53 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 10:46:00PM +0100, Eric Dumazet wrote:
> > You can not use dev_base_lock() or RCU and call an ndo_get_stats64()
> > that could sleep.
> >
> > You can not for example start changing bonding, since bond_get_stats()
> > could be called from non-sleepable context (net/core/net-procfs.c)
> >
> > I am still referring to your patch adding :
> >
> > +       if (!rtnl_locked)
> > +               rtnl_lock();
> >
> > This is all I said.
>
> Ah, ok, well I didn't show you all the patches, did I?


Have you sent them during Thanksgiving perhaps ?

I suggest you follow normal submission process, sending patch series
rather than inlining multiple patches in one email, this is becoming
hard to follow.
