Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97B71B4913
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDVPtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgDVPtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:49:13 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98C6C03C1A9;
        Wed, 22 Apr 2020 08:49:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so2986433wrb.8;
        Wed, 22 Apr 2020 08:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vnfwoXnphqirL/zemb5hnX750nZxVPUecJ0hHU3ef1M=;
        b=sy17quxPDAqC971oJnpVTauJYWE2GFiCrcUdjR6glSHrY2Rlgz9eB2bvp49+rj60g0
         Plq+S8KTeBslgUIn/9PJNPqY8hfahNkWBJw6VJ11Y0ryOESkAqRFwNiSWx3JMY4mXrXG
         H6TRIDtVxp89wPUsQ8xmQAeZ949Rly1y6HWEsXiUYXZqKxTn23Y0oXCtpB+mM6PDHWpY
         3EWCSUy7bOGIHWfAkN/dnWuzLtJa3X3etcvWVa8eKGhZVdAaL9TqCBVBD+1djW998BQS
         0acRp6Jf2OlxSFwT2uXDl1IDtJQ73GfL8w6oZMRmiT5VmjJ4NhUFgyYw/h/lYXXti5PG
         Rs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vnfwoXnphqirL/zemb5hnX750nZxVPUecJ0hHU3ef1M=;
        b=lTyzWHwRu8DQoG8oeOUATuNXGGKpRjL+oMcDNB3tmFl70S4nlgHT2SY8ZQpN2zycaH
         el25fi+enlk6TbkcQhUjSMQFld8JwP5sDNeWAlM//9TH/RtLhHjer1a/C6Wx3W3KT1Vn
         pM3HqfPy0/hThLu0twVlHcjampw7FadAWHiaMhVa1jtjb+L+JA+deluQbXUkctEFYq1/
         v4E0zCze4J5V2UDYg353AZmccuGswoO6/8xhUVO42Uy8cVQ7SbSyFtyPaE0JYS+zvo4U
         cvQXz3qCx/m6af2FzDL09N+TED8UoVb1Odfr68PEibB8Tr8kAXhroED4Lsb65YY9dqIx
         Y/Mw==
X-Gm-Message-State: AGi0Puat1ESD+/OgGLVzW5YDs20uwvlTrgUMhgv+hdcKd4nl1/BqufYG
        rHM1dlFjDjr8t7B6cBs+BKDmjR4WUjrErJdf+A0=
X-Google-Smtp-Source: APiQypIcLJ0ShE/L7PH23qrwMG4fq0gGIhBoFzTJyHq6C2vR+HGb7NIPh67NfxgQTQEDeDzN6Dxy+AZcPUSeI182hPk=
X-Received: by 2002:a5d:4447:: with SMTP id x7mr30116510wrr.299.1587570550705;
 Wed, 22 Apr 2020 08:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200421143149.45108-1-yuehaibing@huawei.com> <20200422093344.GY13121@gauss3.secunet.de>
 <1650fd55-dd70-f687-88b6-d32a04245915@huawei.com> <CADvbK_cEgKCEGRJU1v=FAdFNoh3TzD+cZLiKUtsMLHJh3JqOfg@mail.gmail.com>
In-Reply-To: <CADvbK_cEgKCEGRJU1v=FAdFNoh3TzD+cZLiKUtsMLHJh3JqOfg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 22 Apr 2020 23:54:03 +0800
Message-ID: <CADvbK_d83W0g2MKRcW=_2Nx=bm35jAQj-QB-2J5ww=j6LCY7WQ@mail.gmail.com>
Subject: Re: [PATCH] xfrm: policy: Only use mark as policy lookup key
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, kuba@kernel.org,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:41 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Wed, Apr 22, 2020 at 8:18 PM Yuehaibing <yuehaibing@huawei.com> wrote:
> >
> > On 2020/4/22 17:33, Steffen Klassert wrote:
> > > On Tue, Apr 21, 2020 at 10:31:49PM +0800, YueHaibing wrote:
> > >> While update xfrm policy as follow:
> > >>
> > >> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> > >>  priority 1 mark 0 mask 0x10
> > >> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> > >>  priority 2 mark 0 mask 0x00
> > >> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> > >>  priority 2 mark 0 mask 0x10
> > >>
> > >> We get this warning:
> > >>
> > >> WARNING: CPU: 0 PID: 4808 at net/xfrm/xfrm_policy.c:1548
> > >> Kernel panic - not syncing: panic_on_warn set ...
> > >> CPU: 0 PID: 4808 Comm: ip Not tainted 5.7.0-rc1+ #151
> > >> Call Trace:
> > >> RIP: 0010:xfrm_policy_insert_list+0x153/0x1e0
> > >>  xfrm_policy_inexact_insert+0x70/0x330
> > >>  xfrm_policy_insert+0x1df/0x250
> > >>  xfrm_add_policy+0xcc/0x190 [xfrm_user]
> > >>  xfrm_user_rcv_msg+0x1d1/0x1f0 [xfrm_user]
> > >>  netlink_rcv_skb+0x4c/0x120
> > >>  xfrm_netlink_rcv+0x32/0x40 [xfrm_user]
> > >>  netlink_unicast+0x1b3/0x270
> > >>  netlink_sendmsg+0x350/0x470
> > >>  sock_sendmsg+0x4f/0x60
> > >>
> > >> Policy C and policy A has the same mark.v and mark.m, so policy A is
> > >> matched in first round lookup while updating C. However policy C and
> > >> policy B has same mark and priority, which also leads to matched. So
> > >> the WARN_ON is triggered.
> > >>
> > >> xfrm policy lookup should only be matched when the found policy has the
> > >> same lookup keys (mark.v & mark.m) no matter priority.
> > >>
> > >> Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
> > >> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > >> ---
> > >>  net/xfrm/xfrm_policy.c | 16 +++++-----------
> > >>  1 file changed, 5 insertions(+), 11 deletions(-)
> > >>
> > >> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> > >> index 297b2fd..67d0469 100644
> > >> --- a/net/xfrm/xfrm_policy.c
> > >> +++ b/net/xfrm/xfrm_policy.c
> > >> @@ -1436,13 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
> > >>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> > >>                                 struct xfrm_policy *pol)
> > >>  {
> > >> -    u32 mark = policy->mark.v & policy->mark.m;
> > >> -
> > >> -    if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> > >> -            return true;
> > >> -
> > >> -    if ((mark & pol->mark.m) == pol->mark.v &&
> > >> -        policy->priority == pol->priority)
> > >
> > > If you remove the priority check, you can't insert policies with matching
> > > mark and different priorities anymore. This brings us back the old bug.
> >
> > Yes, this is true.
> >
> > >
> > > I plan to apply the patch from Xin Long, this seems to be the right way
> > > to address this problem.
> >
> > That still brings an issue, update like this:
> >
> > policy A (mark.v = 1, mark.m = 0, priority = 1)
> > policy B (mark.v = 1, mark.m = 0, priority = 1)
> >
> > A and B will all in the list.
> I think this is another issue even before:
> 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and
> different priorities")
>
> >
> > So should do this:
> >
> >  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >                                    struct xfrm_policy *pol)
> >  {
> > -       u32 mark = policy->mark.v & policy->mark.m;
> > -
> > -       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> > -               return true;
> > -
> > -       if ((mark & pol->mark.m) == pol->mark.v &&
> > +       if ((policy->mark.v & policy->mark.m) == (pol->mark.v & pol->mark.m) &&
> >             policy->priority == pol->priority)
> >                 return true;
> "mark.v & mark.m" looks weird to me, it should be:
> ((something & mark.m) == mark.v)
>
> So why should we just do this here?:
*shouldn't, sorry ;D

> (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m &&
>  policy->priority == pol->priority)
>
> >
> >
> >
> > >
> > > .
> > >
> >
