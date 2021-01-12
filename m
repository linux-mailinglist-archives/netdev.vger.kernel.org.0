Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90372F3771
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbhALRoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbhALRoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:44:17 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08678C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 09:43:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id j1so1790852pld.3
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 09:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzmIqEmiAsBQeGRuZXDrmfW3VJTtFNWm4pArIga4sc0=;
        b=CPoxrWdosO7Iaqn3diWVwEu3TgMcAKnLqPCx8aAIb2PF/FfFNYV+FVrA1yfz22GA2q
         Wc3oEo0K+5CrnWPE30RWzEluBD5DOzscuj8odr4gZoHW0prJ2hZLJujYtYVExeokAm3I
         /xZjEQf4WFiCQjq0hbgaYJOjjoMvPNkSh+0GVfSmdaYO41RYoV7zeZOefP2DYvm5/fKo
         MlaY1iqwePXiWi2tpUWPYq2FjjrBXXOMHZjy3zZJNgpYega1pfcewOekjW4k4DR/qktj
         s0HC/b0yTl/HU+K4OWHEnUNqawaPGzQL8gCXkmgacJItIpIjlt5qkwyFuNJ4oSefTeeL
         s0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzmIqEmiAsBQeGRuZXDrmfW3VJTtFNWm4pArIga4sc0=;
        b=JenbEb3HEWZV7EV+ESugj4+YpulcKJqzCefz1Uf5wCRxnAVSnW0ZoEtJ2EqSJD14Ds
         Z4cLmtlC2rizLdfZ1gJhaF4s66cKyyHbDBXxlt3lfrt8q1yDxkNGcxPWd4lGWTrBPDVb
         9MHf/u6hwMg/tjScn5LZkBPei7VxlyVtCeeoILHoTGOExiGzXwnEkJLXbcrhJiqzXMul
         z08kQiHPgmJXwcUuhs4CoZyUgh6LOjvIEZtcrk+rxpIbz1fVZ1ly9l/COVfhslp2sCS3
         JGnMUQF5eqdSOQybCWPG9uKcHPKVQJ7IagfiU25K7Ht8CsTtCPA/w2shpwLPCbIxPVHt
         LIVA==
X-Gm-Message-State: AOAM530Q0MZ6bkZJO7cUsMvibp/gPeWcHt8NxwLCEChNdYnbfkFo7tk7
        qyypfugQI7Aph1QIITCPWTg1NIVU1pluE89GdVQ=
X-Google-Smtp-Source: ABdhPJxBFM6eocolBUl5ywDD3Z1WOKJq7FI8yHr4IKIMNjMB0EBBZaBTjbPd3pSk2OvhGadRCZCyYWPtfrDwbP+aTsA=
X-Received: by 2002:a17:90a:f2ce:: with SMTP id gt14mr179141pjb.215.1610473416583;
 Tue, 12 Jan 2021 09:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com> <CADvbK_dvG9LNTTxh9R4QYO_0UHjKTvxaccb2AingaAzyXpzp4g@mail.gmail.com>
In-Reply-To: <CADvbK_dvG9LNTTxh9R4QYO_0UHjKTvxaccb2AingaAzyXpzp4g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 12 Jan 2021 09:43:25 -0800
Message-ID: <CAM_iQpW6m8xaTyi4Czi7BKFfv-oWkhJni9LUa8ETs1AorKdSVQ@mail.gmail.com>
Subject: Re: [Patch net] cls_flower: call nla_ok() before nla_next()
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:52 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 10:56 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > fl_set_enc_opt() simply checks if there are still bytes left to parse,
> > but this is not sufficent as syzbot seems to be able to generate
> > malformatted netlink messages. nla_ok() is more strict so should be
> > used to validate the next nlattr here.
> >
> > And nla_validate_nested_deprecated() has less strict check too, it is
> > probably too late to switch to the strict version, but we can just
> > call nla_ok() too after it.
> >
> > Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> > Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Xin Long <lucien.xin@gmail.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/sched/cls_flower.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index 1319986693fc..e265c443536e 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> >
> >                 nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> >                 msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > +               if (!nla_ok(nla_opt_msk, msk_depth))
> > +                       return -EINVAL;
> >         }
> I think it's better to also add  NL_SET_ERR_MSG(extack, xxxx);
> for this error return, like all the other places in this function.

I think ext message is primarily for end users who usually can not
generate malformat netlink messages.

On the other hand, the nla_validate_nested_deprecated() right above
the quoted code does not set ext message either.

Thanks.
