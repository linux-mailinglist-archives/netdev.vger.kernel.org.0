Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC5A07DC
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfH1Qv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:51:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34231 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfH1Qv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 12:51:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so808743edb.1
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 09:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b9URK1ngA/HRnez4L3uE7FLCpaDMLKSKCkHTd+SHE2M=;
        b=nx4XA9MWsARNJkZpIRgWX8Z9DkbrIzA7m2fRtPq7sYG7c/MJ2Q6b9qebs9fne6xDd1
         M7pRQmgkjUvM7L2YdvnZYnwhpctxX00/8jkhfjOIBXAKSfIOvqe/FGn31h/GlQ3Qhg12
         hOMh0zmT8H6zzd7ACrlM1fPUJkTl+s5/3mon/Nf8BLiqCA4lp45wU4rp+tJ1sXTuVly5
         cDgBU1DTXQZahRR7YSAPIp4+kY8veqCEvPDI7bgqPhkEj+dSO4meWwQT4rwzNqBKsdK4
         ufnmYMK3nkgeWdwcxnEq2ChSsw7dxgcWt7D5LDe6co//s/qgCjpLNUvOVtJ76RrmOqyq
         8ubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9URK1ngA/HRnez4L3uE7FLCpaDMLKSKCkHTd+SHE2M=;
        b=OOOQPxHCGB9XcALmWjJjvktq7Six+mYCSKQ+c1VscxCu05xQ/f3HGk76pqPPuPIHzO
         1M8GmIToJvNziXHEaVP25QqUrhEIJNHh+kYNkPlEK18NuE2bdp2eCABaPPhD99fxfOmg
         gkztEGBtHtRWp/Dvgt+JHqvP9N+R9EwY+MVFq/lUlbFyhbUi7skZd+sG1Du0OoS0vwl8
         2fMhLU4RfdKfb7px3HkMwiTsTDU1vzATas3aSZWC1RhGV4b743yJQ8VbguOvx8mJhJ5q
         mQBwkRo0ER5cH6Tcs+Jco+QdlbC85dteaUnH+k1pWBReg5FuxUgnpGbufYJeyTOcoiFb
         9m3A==
X-Gm-Message-State: APjAAAUtoLz2xM3byKTc9iwScWCnIytJGjn1OYLRxxFPIE+9daFh11g9
        O5MIbvU+AsluY7VEAZTyG2QErNYMNru1erA4HbY3rTnb
X-Google-Smtp-Source: APXvYqzsdb9AT4HylmAjAIl/+2rsKtyzQm9yV7NL0evYv8LBkpqtVXAvfdpVrYRNpIYHZyFLdMQotuEPNSf1KsPVnBM=
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr4138610ejc.204.1567011087629;
 Wed, 28 Aug 2019 09:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190828144829.32570-1-olteanv@gmail.com> <20190828144829.32570-2-olteanv@gmail.com>
 <87a7btqmk7.fsf@intel.com>
In-Reply-To: <87a7btqmk7.fsf@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 28 Aug 2019 19:51:16 +0300
Message-ID: <CA+h21hr7hZShmHfmF8XX3PpCKm_3FkYm=CzkBmyiYezWGR7kLw@mail.gmail.com>
Subject: Re: [PATCH net 1/3] taprio: Fix kernel panic in taprio_destroy
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Wed, 28 Aug 2019 at 19:31, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > taprio_init may fail earlier than this line:
> >
> >       list_add(&q->taprio_list, &taprio_list);
> >
> > i.e. due to the net device not being multi queue.
>
> Good catch.
>
> >
> > Attempting to remove q from the global taprio_list when it is not part
> > of it will result in a kernel panic.
> >
> > Fix it by iterating through the list and removing it only if found.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  net/sched/sch_taprio.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 540bde009ea5..f1eea8c68011 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -1199,12 +1199,17 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
> >
> >  static void taprio_destroy(struct Qdisc *sch)
> >  {
> > -     struct taprio_sched *q = qdisc_priv(sch);
> > +     struct taprio_sched *p, *q = qdisc_priv(sch);
> >       struct net_device *dev = qdisc_dev(sch);
> > +     struct list_head *pos, *tmp;
> >       unsigned int i;
> >
> >       spin_lock(&taprio_list_lock);
> > -     list_del(&q->taprio_list);
> > +     list_for_each_safe(pos, tmp, &taprio_list) {
> > +             p = list_entry(pos, struct taprio_sched, taprio_list);
> > +             if (p == q)
> > +                     list_del(&q->taprio_list);
> > +     }
>
> Personally, I would do things differently, I am thinking: adding the
> taprio instance earlier to the list in taprio_init(), and keeping
> taprio_destroy() the way it is now. But take this more as a suggestion
> :-)
>

While I don't strongly oppose your proposal (keep the list removal
unconditional, but match it better in placement to the list addition),
I think it's rather fragile and I do see this bug recurring in the
future. Anyway if you want to keep it "simpler" I can respin it like
that.

>
> Cheers,
> --
> Vinicius
>

Regards,
-Vladimir
