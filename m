Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFDB2F5B31
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbhANHVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbhANHVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:21:22 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02327C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:20:35 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id w1so4231126pjc.0
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJ2YOHopXuKHCPzPIIVesMY6QGra3kzovxy06NQxG8k=;
        b=CB7haX2sQa7GtTynoLQygO7Uoml90EvpVgRAF/TswMo51GijJufj0Z5gzIahyWnq00
         VJ+kJnRpPq3VMaXLCijJiDoFTwHTNQt7QJrWE98GeZw8j00NDedLpjdX7568ePYSiQ0N
         djuqVGX1yIRLAczNNjWKAyCFLJW/HgIU4X3Kmxgao0qLTSfZ57YA0sJrPsOKnX3fd+t4
         zRZN8fT8HLlNmbj5FIjV4zIBjb0purDNj2DFp/pVtybcbhpSH4jefeRJXSVQndHfhDuV
         P4eYR9zq0cdREflYHt3vb/xqKIJvLlqdso0R/aKEAhxVDIHq70R/fsYnsfCqCz9wXoh3
         gtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJ2YOHopXuKHCPzPIIVesMY6QGra3kzovxy06NQxG8k=;
        b=fJhjbgk4P6FZS3/DPW0TH9fgbc4/B4HqLQw5ht4Mkd4HFQLFw7+zu+FdOqHERNtylU
         DmLUmN2GxLcKnIXBuB9dr3LjBrNq64kM1xhkPkZbonp8aGP/cPmA2fyQz+s124Q4kI3e
         O5ZF/9gbS/UlWEbTJTztVJ5MiAklEK0pWG7gxzB/7neoChcVqoLoY/7lK3dDeEgUHVxy
         l/9JPj+okX/NeRBrqFZnbb7qpWnn3TGKGKrzwrryndk52G4OiUV+cN++vEwlTptrZJZM
         EEmQGgUWUlf7Xjt+IbcWYNybuBNW5VI2yCAA6L/VCP8Cz0caoz1KzvCJJ0v5t/0R6djW
         /HWA==
X-Gm-Message-State: AOAM531TCxAr/1ZdnivvNM6fFwqW6iJocUJegscLu/0BJtWK+hk/PO4U
        EOvCzMp/yHNrHEr4LBR9PwirOkQxQVFnuxgdLqg=
X-Google-Smtp-Source: ABdhPJxXfCet4NJFj23AmDGzUQTSiF1EqmsZ2aQyJbPBSa+00zps6CUJUsFT8PyvNkRGTSBE//K6qJN4e/FQK8Pv0fQ=
X-Received: by 2002:a17:90a:f98c:: with SMTP id cq12mr3581835pjb.191.1610608835367;
 Wed, 13 Jan 2021 23:20:35 -0800 (PST)
MIME-Version: 1.0
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com> <20210112173813.17861ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112173813.17861ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 13 Jan 2021 23:20:24 -0800
Message-ID: <CAM_iQpUuwpm_uQ76SY+Vz=FN+xq_bhUTScn8NcRNfcn8xehQgQ@mail.gmail.com>
Subject: Re: [Patch net] cls_flower: call nla_ok() before nla_next()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 5:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 11 Jan 2021 18:55:48 -0800 Cong Wang wrote:
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
>
> Thanks for keeping up with the syzbot bugs!
>
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index 1319986693fc..e265c443536e 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> >
> >               nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> >               msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> > +             if (!nla_ok(nla_opt_msk, msk_depth))
> > +                     return -EINVAL;
>
> Can we just add another call to nla_validate_nested_deprecated()
> here instead of having to worry about each attr individually?

No, we can not parse the nested attr here because different key types
have different attributes.

> See below..
>
> >       }
> >
> >       nla_for_each_attr(nla_opt_key, nla_enc_key,
> > @@ -1308,7 +1310,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> >                               return -EINVAL;
> >                       }
> >
> > -                     if (msk_depth)
> > +                     if (nla_ok(nla_opt_msk, msk_depth))
> >                               nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>
> Should we not error otherwise? if msk_depth && !nla_ok() then the
> message is clearly misformatted. If we don't error out we'll keep
> reusing the same mask over and over, while the intention of this
> code was to have mask per key AFAICT.

Yeah, erroring out sounds better. Will change this in v2.

Thanks!
