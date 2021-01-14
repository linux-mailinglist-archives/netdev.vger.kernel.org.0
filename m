Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F82F5B35
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbhANHWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbhANHWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:22:07 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5806C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:21:26 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c12so2821312pfo.10
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NnD8McVk9rV3fLCHjE+nl1JnefXHNVHCuqm/SkguEL8=;
        b=YGjOkUDlcsE2EADiTNCwlzfQ01K6oC4UaL0OuS52qljPo9joT+yDWE0SXSuiQn+CjC
         ZRYTFW6h1LqcJFzujlQbocTtb5tgOAIt1NKBs04NlclvLOhXYXALYTV/MavTHIsUvjyE
         tp9qwurYhNwAoEgLumI6l8qz4idlafitSi1bnLAP3Er2qVn+gDpEHMDAlFBPGe2fgHpC
         iFZ6Ca5tuSenQBn0h3lqhVRGoCctLz9kPffhlVa67JDhyKC2MFcCKQu7gFcymtB8JGzu
         GtFEQKT/n9os4CXxwExSpkw8jts2QlmndV7hhovGwpMToTp+1zHc+JAtR6H5zMacvFDc
         4YdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NnD8McVk9rV3fLCHjE+nl1JnefXHNVHCuqm/SkguEL8=;
        b=ByAnlfyIcM/G+JOIkmhkEJ+pqZTAEAwz7p0hUqUhd2XbGaSHOfV2usXgNhyKQfr8XL
         rm2ZIW8EY3YcLTd+wPc659xdUJfJsX2RiSfjL2V/coPldF64J/8QXoh1Fis/MY0gecdq
         7kFkL0g3kvtKajYIgak5p6Z0f3zipukQdGUqwxXOxOKIeK0DN1okwXHMCOc1paqpcXNM
         H/4i0zdTFrcuIYnFLXpz4y3JUhvGtrEOjIN1mb8OPGn+C6aeL97oyO+HoLExBg8SOwtu
         TSSlX6KuVKx0YqyHZjThyyHjFjhg2UKr6n6PhgxbyPnSMmi7DXly+zrCIw7c6Pod68TX
         V4dA==
X-Gm-Message-State: AOAM533nBdwJPP+S/2ZCrWw/Y6t3EuAII4S/cunvOO5vWxnLSIyJBua4
        72Luxhebz9L1ylwb2SBIcKqw/AYe9OdjUzjzis0=
X-Google-Smtp-Source: ABdhPJxUKOJ3istfJLF5DhSqKtj+emJMlUnA6MPBaHCpDOFp7iyJtbXA2yctGFXuCobRjk0wqu+Juj+USBidKzhN4gQ=
X-Received: by 2002:a05:6a00:88b:b029:19c:780e:1cd with SMTP id
 q11-20020a056a00088bb029019c780e01cdmr6160376pfj.64.1610608886373; Wed, 13
 Jan 2021 23:21:26 -0800 (PST)
MIME-Version: 1.0
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
 <CADvbK_dvG9LNTTxh9R4QYO_0UHjKTvxaccb2AingaAzyXpzp4g@mail.gmail.com>
 <CAM_iQpW6m8xaTyi4Czi7BKFfv-oWkhJni9LUa8ETs1AorKdSVQ@mail.gmail.com> <CADvbK_dpay5Cajn+Q+tTi00rBi_yvPCUETrtB+CiXE_WdsRUQA@mail.gmail.com>
In-Reply-To: <CADvbK_dpay5Cajn+Q+tTi00rBi_yvPCUETrtB+CiXE_WdsRUQA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 13 Jan 2021 23:21:15 -0800
Message-ID: <CAM_iQpWfG69zQ0dp=eL9_0_02BrjOevpc-Dn9tnDxXJwAUYs6g@mail.gmail.com>
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

On Tue, Jan 12, 2021 at 6:22 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Wed, Jan 13, 2021 at 1:43 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 3:52 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 10:56 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > fl_set_enc_opt() simply checks if there are still bytes left to parse,
> > > > but this is not sufficent as syzbot seems to be able to generate
> > > > malformatted netlink messages. nla_ok() is more strict so should be
> > > > used to validate the next nlattr here.
> > > >
> > > > And nla_validate_nested_deprecated() has less strict check too, it is
> > > > probably too late to switch to the strict version, but we can just
> > > > call nla_ok() too after it.
> > > >
> > > > Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> > > > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > > > Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> > > > Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> > > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > Cc: Xin Long <lucien.xin@gmail.com>
> > > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > ---
> > > >  net/sched/cls_flower.c | 8 +++++---
> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > > > index 1319986693fc..e265c443536e 100644
> > > > --- a/net/sched/cls_flower.c
> > > > +++ b/net/sched/cls_flower.c
> > > > @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > > >
> > > >                 nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > > >                 msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > > > +               if (!nla_ok(nla_opt_msk, msk_depth))
> > > > +                       return -EINVAL;
> > > >         }
> > > I think it's better to also add  NL_SET_ERR_MSG(extack, xxxx);
> > > for this error return, like all the other places in this function.
> >
> > I think ext message is primarily for end users who usually can not
> > generate malformat netlink messages.
> >
> > On the other hand, the nla_validate_nested_deprecated() right above
> > the quoted code does not set ext message either.
> nla_validate_nested_deprecated(..., extack), it's already done inside
> when returns error, no?

Yeah, seems fair.

Thanks.
