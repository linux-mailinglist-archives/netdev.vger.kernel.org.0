Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1501F491A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgFIVtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgFIVtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:49:04 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574EBC05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 14:49:04 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m21so17540827eds.13
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 14:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dF+RQ0AQoP42Ff+qtYJONpy5p7iRkssBS+Qb7xcQPb4=;
        b=WyzmLb5SHrusklbUivTJLgHqRqnRqMxkpynwwTr3vbBJiY6c7PmcAEIIIvP2jlHn6B
         mZwe2OOpQoB3n3VcfW5KVnwFuOM1x+srCuMxz5iJjpGg4WKloGOQp9oFUSx04T8ZmSKR
         +4GJ7DTuahDB9EhglmBziGz/xDhPcnwhLos0OryPrLEwh9QgwtvC3gKB8wZ3SOADGhFM
         KWszOiOj/3MgGRj8POFzDeNzXiDjnC5qI56jh12gAEuVwMzsAgIx3nZhLKEJo9WZXfEA
         OJSYTUELmgqymgcl8RsPJmsaUdTb+H7K9spydxz6F8uCXlX5GkKk/K7xTley7ISL2JWu
         E1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dF+RQ0AQoP42Ff+qtYJONpy5p7iRkssBS+Qb7xcQPb4=;
        b=ufXrdqTYYDh8M5WrkwOdFFhMQgiyVYB+gODfJsRE9F7hi8FDlAZ8G7EJf5kq/K1R3T
         EhbDErOhlRR6D0KKjn33coT99cTlm2BO7ciRBVjYPr8BjIV3nmROaCSjnctJkCjq//bg
         K7+QJtIaXSHYpN5tfkraU12U6WzJt2VRobwaSFZRpaCL0ZmUQzKbb5cyAOHnylCWZ0wi
         NKxF9+Us4aj5QBd21xL4igKiAUjAJW2/yod6tJpjBbXcDvzNIDp5VR40HQvV7/q7lck0
         yAPBfKlWDM8Bc1Wo1Qd++cCFFYObcJp3z48kWctpY4i8AJaJRAp/YMVUvPetYxw2EFi4
         nzog==
X-Gm-Message-State: AOAM5303cY3CsKFFpAhFw/mv7BY9f+tGUBHaZchJuyEm1EbyOQ9C5sho
        5FwO6aA/Lzlx/Mgd3IpHBUuIQlGj64Aou4biHISvLQ==
X-Google-Smtp-Source: ABdhPJzbVOtjVZ79aGfP2Lwa/ckHUcZ4Mr+zJirQEkN0p/xLAj8D/4/tCBcmX7Ur2OZQfbfkbGZpgqEbiStWTsnkvUA=
X-Received: by 2002:aa7:c944:: with SMTP id h4mr28309011edt.383.1591739342882;
 Tue, 09 Jun 2020 14:49:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200609101935.5716b3bd@hermes.lan> <20200609.113633.1866761141966326637.davem@davemloft.net>
 <4d664ff641dbf3aeab1ecd5eacda220dab9d7d17.camel@intel.com> <20200609.123858.466960203090925019.davem@davemloft.net>
In-Reply-To: <20200609.123858.466960203090925019.davem@davemloft.net>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 9 Jun 2020 14:48:51 -0700
Message-ID: <CAPcyv4jr9F_0q4S-LSvHzJK7mamLW-m1Skgw7cXvkZYNtStyxA@mail.gmail.com>
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration support
To:     David Miller <davem@davemloft.net>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        amitc@mellanox.com, david@protonic.nl, linville@tuxdriver.com,
        marex@denx.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        petrm@mellanox.com, hkallweit1@gmail.com, kernel@pengutronix.de,
        christian.herber@nxp.com, mkubecek@suse.cz, kuba@kernel.org,
        o.rempel@pengutronix.de, Netdev <netdev@vger.kernel.org>,
        mkl@pengutronix.de, f.fainelli@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 12:57 PM David Miller <davem@davemloft.net> wrote:
>
> From: "Williams, Dan J" <dan.j.williams@intel.com>
> Date: Tue, 9 Jun 2020 19:30:50 +0000
>
> > On Tue, 2020-06-09 at 11:36 -0700, David Miller wrote:
> >> From: Stephen Hemminger <stephen@networkplumber.org>
> >> Date: Tue, 9 Jun 2020 10:19:35 -0700
> >>
> >> > Yes, words do matter and convey a lot of implied connotation and
> >> > meaning.
> >>
> >> What is your long term plan?  Will you change all of the UAPI for
> >> bonding for example?
> >
> > The long term plan in my view includes talking with standards bodies to
> > move new content to, for example, master/subordinate. In other words,
> > practical forward steps, not retroactively changing interfaces.
>
> When that knowledge is established legitimately in standards and
> transferred into common knowledge of these technologies, yes then
> please come present your proposals.

Our hands are not completely tied by the specifications, as a
community we have a non-zero level of influence over standards bodies,
even direct participation in some. So we could do something stronger
than passively wait for standards to catch up. For example, deprecate
our consideration of future specifications that include this language
and set a cut off date.

I understand the confusion that arises from using terminology
differently from the specification, but at the same time when
specification language actively hurts kernel code maintainability we
change it. For example, when I did the first iteration of what
eventually became libnvdimm Ingo rightly reacted to the naming being
too ACPI specification centric and wanting more kernel-centric naming.

If the common kernel name for what was formerly called a "slave"
device is a "subordinate" device then the confusion is lessened, only
one common kernel translation to consider.

> But right now using different words will create confusion.
>
> I also find master/subordinate an interesting proposal, what if master
> is a triggering term?  Why only slave?

"slave" has a direct connection to human suffering deployed at global scale.

One way I think about this is consider we have our first ever Linux
Plumbers on the African continent, and you had a choice about giving a
talk about how the git master branch operates, or a talk about slave
devices which one would you feel more immediately comfortable leading?
Any hesitation you would feel freely using the word slave with a
predominantly black audience is a similar speed bump a contributor
might feel needing to consume that term to get their job done.

Explaining "no, not that connotation of slave" does not scale as much
as transitioning to another term.

> I know people feel something needs to change, but do that moving
> forward for the technologies themselves.

This is the start of a process that the kernel community can take an
active role to lead, we have it within our control to not wait for the
lowest common denominator to catch up.

> Not how we implement support
> for a technology which is established already.
>
> Plant the seed, don't chop the tree down.

I appreciate the engagement.
