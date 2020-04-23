Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E401B54BC
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDWGcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWGcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 02:32:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB92C03C1AB;
        Wed, 22 Apr 2020 23:32:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x18so5406375wrq.2;
        Wed, 22 Apr 2020 23:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ZbTT0YcGRULImg856cow5gF7U7Q53SAFSQKSQBQUd8=;
        b=qEYCqvTdHmucZ7MjfnFSxRXOCrV+80NVreci5DVFYIIxzxkwRYdcGzvvXDm2LhvCg+
         q7/jt8dDpaH/5wpJenXy8rYMIvu45LD9S3BAcyZceLDBLjChuqhzS1JGatimzGkVoBk7
         q6Ny5UtyEQX6ViXpFXOJHn4qjzSUCxR4LMIzlKtTY1JIqE8rkS3euKH3doMak0xJKIRJ
         DnDuzNCqutLFjNQBT4SI0mRgbgM2Ri8p2fn6OXqAHDrMyGJBHozb8MM48VRHQFEQR4lN
         2Ee6iBj/zycZ4lmKp1TqgsXCpKxo0Xl6YAnnknhVdM7LZZn7uAYdUJ1dax+vSCpHBxZ0
         SY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ZbTT0YcGRULImg856cow5gF7U7Q53SAFSQKSQBQUd8=;
        b=GxINfXhX7xcY9Rb9PbcK23kTDLxx0x4T0JsAa77rsNvSKFVimloIJGbVsLNg/Ukl4R
         3oeSdLiGpd24GetoXpL5D6v64RZiK3LqkZZ0oApvwnoXvia/LD46c2xpDx98VX3BPmZI
         oKqcRgfK0VZ5NJMX86CmTk3nKxE1nsz1/pD9+XeXJiXALVWfXpE8WUtnNHTK+6PMutnT
         zZKreZX90mKHPm2qO9p5njz/OUtKpslCfUTpAFvUrfKdUy22KzNROg+vgAKTtVkoGgR/
         aHKmyIJMiCVIy1Ltn2SzlV7mm0T9DnXcsPRE+SZU64SaqfMvg9pp24cg6sdrhNzjI45i
         Ur5A==
X-Gm-Message-State: AGi0PuaV/2e3GkCD+24x98GoEC8LE0wi2ArP3//+6nYhxaEn3op5kPqs
        EbQF7ZOFy6MwvVMgpdzdoWcrbbnbsfMzm2yx4r4=
X-Google-Smtp-Source: APiQypIQzhzMi2A+UBMP8LKISR78uKk0Bzcn3kKvVlgwH/nrsyEZG4rxDxejM+tdRmFL84flU3n4LzaPUfKtVk7kwHA=
X-Received: by 2002:a5d:4447:: with SMTP id x7mr2996814wrr.299.1587623538643;
 Wed, 22 Apr 2020 23:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200421143149.45108-1-yuehaibing@huawei.com> <20200422093344.GY13121@gauss3.secunet.de>
 <1650fd55-dd70-f687-88b6-d32a04245915@huawei.com> <CADvbK_cEgKCEGRJU1v=FAdFNoh3TzD+cZLiKUtsMLHJh3JqOfg@mail.gmail.com>
 <02a56d2c-8d27-f53a-d9e3-c25bd03677c8@huawei.com>
In-Reply-To: <02a56d2c-8d27-f53a-d9e3-c25bd03677c8@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 23 Apr 2020 14:37:14 +0800
Message-ID: <CADvbK_cScGYRuZfJPoQ+oQKRUk-cr6nOAdTX9cU7MKtw0DUEaA@mail.gmail.com>
Subject: Re: [PATCH] xfrm: policy: Only use mark as policy lookup key
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, kuba@kernel.org,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 10:26 AM Yuehaibing <yuehaibing@huawei.com> wrote:
>
> On 2020/4/22 23:41, Xin Long wrote:
> > On Wed, Apr 22, 2020 at 8:18 PM Yuehaibing <yuehaibing@huawei.com> wrote:
> >>
> >> On 2020/4/22 17:33, Steffen Klassert wrote:
> >>> On Tue, Apr 21, 2020 at 10:31:49PM +0800, YueHaibing wrote:
> >>>> While update xfrm policy as follow:
> >>>>
> >>>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> >>>>  priority 1 mark 0 mask 0x10
> >>>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> >>>>  priority 2 mark 0 mask 0x00
> >>>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> >>>>  priority 2 mark 0 mask 0x10
> >>>>
> >>>> We get this warning:
> >>>>
> >>>> WARNING: CPU: 0 PID: 4808 at net/xfrm/xfrm_policy.c:1548
> >>>> Kernel panic - not syncing: panic_on_warn set ...
> >>>> CPU: 0 PID: 4808 Comm: ip Not tainted 5.7.0-rc1+ #151
> >>>> Call Trace:
> >>>> RIP: 0010:xfrm_policy_insert_list+0x153/0x1e0
> >>>>  xfrm_policy_inexact_insert+0x70/0x330
> >>>>  xfrm_policy_insert+0x1df/0x250
> >>>>  xfrm_add_policy+0xcc/0x190 [xfrm_user]
> >>>>  xfrm_user_rcv_msg+0x1d1/0x1f0 [xfrm_user]
> >>>>  netlink_rcv_skb+0x4c/0x120
> >>>>  xfrm_netlink_rcv+0x32/0x40 [xfrm_user]
> >>>>  netlink_unicast+0x1b3/0x270
> >>>>  netlink_sendmsg+0x350/0x470
> >>>>  sock_sendmsg+0x4f/0x60
> >>>>
> >>>> Policy C and policy A has the same mark.v and mark.m, so policy A is
> >>>> matched in first round lookup while updating C. However policy C and
> >>>> policy B has same mark and priority, which also leads to matched. So
> >>>> the WARN_ON is triggered.
> >>>>
> >>>> xfrm policy lookup should only be matched when the found policy has the
> >>>> same lookup keys (mark.v & mark.m) no matter priority.
> >>>>
> >>>> Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
> >>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> >>>> ---
> >>>>  net/xfrm/xfrm_policy.c | 16 +++++-----------
> >>>>  1 file changed, 5 insertions(+), 11 deletions(-)
> >>>>
> >>>> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> >>>> index 297b2fd..67d0469 100644
> >>>> --- a/net/xfrm/xfrm_policy.c
> >>>> +++ b/net/xfrm/xfrm_policy.c
> >>>> @@ -1436,13 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
> >>>>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >>>>                                 struct xfrm_policy *pol)
> >>>>  {
> >>>> -    u32 mark = policy->mark.v & policy->mark.m;
> >>>> -
> >>>> -    if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> >>>> -            return true;
> >>>> -
> >>>> -    if ((mark & pol->mark.m) == pol->mark.v &&
> >>>> -        policy->priority == pol->priority)
> >>>
> >>> If you remove the priority check, you can't insert policies with matching
> >>> mark and different priorities anymore. This brings us back the old bug.
> >>
> >> Yes, this is true.
> >>
> >>>
> >>> I plan to apply the patch from Xin Long, this seems to be the right way
> >>> to address this problem.
> >>
> >> That still brings an issue, update like this:
> >>
> >> policy A (mark.v = 1, mark.m = 0, priority = 1)
> >> policy B (mark.v = 1, mark.m = 0, priority = 1)
> >>
> >> A and B will all in the list.
> > I think this is another issue even before:
> > 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and
> > different priorities")
> >
> >>
> >> So should do this:
> >>
> >>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >>                                    struct xfrm_policy *pol)
> >>  {
> >> -       u32 mark = policy->mark.v & policy->mark.m;
> >> -
> >> -       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> >> -               return true;
> >> -
> >> -       if ((mark & pol->mark.m) == pol->mark.v &&
> >> +       if ((policy->mark.v & policy->mark.m) == (pol->mark.v & pol->mark.m) &&
> >>             policy->priority == pol->priority)
> >>                 return true;
> > "mark.v & mark.m" looks weird to me, it should be:
> > ((something & mark.m) == mark.v)
> >
> > So why should we just do this here?:
> > (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m &&
> >  policy->priority == pol->priority)
>
>
> This leads to this issue:
>
>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir in mark 0x00000001 mask 0x00000005
>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir in mark 0x00000001 mask 0x00000003
>
> the two policies will be in list, which should not be allowed.
I think these are two different policies.
For instance:
mark = 0x1234567b will match the 1st one only.
mark = 0x1234567d will match the 2st one only

So these should have been allowed, no?

I'm actually confused now.
does the mask work against its own value, or the other value?
as 'A == (mark.v&mark.m)' and '(A & mark.m) == mark.v' are different things.

This can date back to Jamal's xfrm by MARK:

https://lwn.net/Articles/375829/

where it does 'm->v & m->m' in xfrm_mark_get() and
'policy->mark.v & policy->mark.m' in xfrm_policy_insert() while
it does '(A & pol->mark.m) == pol->mark.v' in other places.

Now I'm thinking 'm->v & m->m' is meaningless, by which if we get
a value != m->v, it means this mark can never be matched by any.

  policy A (mark.v = 1, mark.m = 0, priority = 1)
  policy B (mark.v = 1, mark.m = 0, priority = 1)

So probably we should avoid this case by check m->v == (m->v & m->m)
when adding a new policy.

wdyt?

>
> >
> >>
> >>
> >>
> >>>
> >>> .
> >>>
> >>
> >
> > .
> >
>
