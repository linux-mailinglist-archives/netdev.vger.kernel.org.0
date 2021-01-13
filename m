Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0E52F41B5
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbhAMCWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbhAMCWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 21:22:53 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D48C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:22:12 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n16so2793215wmc.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Qvcp9Xh2/bR0nA22guXu2hGM+5H7mgw8biV6uITvpE=;
        b=XRvEgD8iZEpzfkgU+zSafKyL8+wmLbvWk8alDwA0NdXEGDGcwj5ulaJBHY5Er14lbD
         sJXGxSAe6Leul0UazgHsXHs9knxU6O6nwtpEAgtor7PdZhR9k3a/DDBKbAyA0Wz8KF8u
         7gqdW/ECHlOhOHhVvOBtJjrQ0tcsoMUQL5econCBPqPOWTNSeSWir3dfJV7RoXJIy8Ej
         7KC5gWirpsl6B+qWRuMQO2VqpA1OGuUYvCF2UgsZgfjKBdUtw/yDA05ph/cMfG/7aNud
         1PdCR9C46dj3z69taoUSC+Y82waXhnVOnXZXcrzBOHdbNJC8FKe7BASYneF2Gy2CuxdP
         JjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Qvcp9Xh2/bR0nA22guXu2hGM+5H7mgw8biV6uITvpE=;
        b=g9ym7Wd1c2YwySNYaClX4674Ltp20nveIAD5O/gUnBNpjWEzqX0BvDQiLw00yt8Hox
         9a3UR3ZbDYVOWn2AfjLrVz4c/QtdeazjXZY2K9ijl0KxfsKeuQdHaaNhYKpA9IU6q8li
         Yo/oOcTTDQCl6JaKYxVBIG0Tb7amM3zVVHWiwRoKm1l3ld2QqVYqCAYX7Tm00+JXcOxJ
         dvo6whFJNdMJqeQv6xjF9piaPhQMnJsdWUh1rrw0P4sBtCuxkC0r5Uo84OmKLfPI3NLr
         ri8OkaBMgZ4qHHBG/D/HwTa2wStIfOo5k8goqCJm9nA4WQJF/0VGaSL7NQ32kWJ0MeY9
         JAzw==
X-Gm-Message-State: AOAM531GLLC5qVv7JF8IUqO8OnwegpJX70Yau1xylfzk5Jl6CBQ+vtKm
        ojDx4qksLP2gRX1oxk5f63bM2EbJWXUeIR/5Kng=
X-Google-Smtp-Source: ABdhPJwOj9xexfTamReje18ZzTzjAQ1ISDMXjKWiy3ZCJOigZzCvzfzaKaX7dv/eFkJAZmlUQXyiixzNgxSjV5TrRYE=
X-Received: by 2002:a1c:2483:: with SMTP id k125mr102339wmk.67.1610504531620;
 Tue, 12 Jan 2021 18:22:11 -0800 (PST)
MIME-Version: 1.0
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
 <CADvbK_dvG9LNTTxh9R4QYO_0UHjKTvxaccb2AingaAzyXpzp4g@mail.gmail.com> <CAM_iQpW6m8xaTyi4Czi7BKFfv-oWkhJni9LUa8ETs1AorKdSVQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW6m8xaTyi4Czi7BKFfv-oWkhJni9LUa8ETs1AorKdSVQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 13 Jan 2021 10:22:00 +0800
Message-ID: <CADvbK_dpay5Cajn+Q+tTi00rBi_yvPCUETrtB+CiXE_WdsRUQA@mail.gmail.com>
Subject: Re: [Patch net] cls_flower: call nla_ok() before nla_next()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 1:43 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 3:52 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 10:56 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > fl_set_enc_opt() simply checks if there are still bytes left to parse,
> > > but this is not sufficent as syzbot seems to be able to generate
> > > malformatted netlink messages. nla_ok() is more strict so should be
> > > used to validate the next nlattr here.
> > >
> > > And nla_validate_nested_deprecated() has less strict check too, it is
> > > probably too late to switch to the strict version, but we can just
> > > call nla_ok() too after it.
> > >
> > > Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> > > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > > Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> > > Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Xin Long <lucien.xin@gmail.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/sched/cls_flower.c | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > > index 1319986693fc..e265c443536e 100644
> > > --- a/net/sched/cls_flower.c
> > > +++ b/net/sched/cls_flower.c
> > > @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > >
> > >                 nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > >                 msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > > +               if (!nla_ok(nla_opt_msk, msk_depth))
> > > +                       return -EINVAL;
> > >         }
> > I think it's better to also add  NL_SET_ERR_MSG(extack, xxxx);
> > for this error return, like all the other places in this function.
>
> I think ext message is primarily for end users who usually can not
> generate malformat netlink messages.
>
> On the other hand, the nla_validate_nested_deprecated() right above
> the quoted code does not set ext message either.
nla_validate_nested_deprecated(..., extack), it's already done inside
when returns error, no?
