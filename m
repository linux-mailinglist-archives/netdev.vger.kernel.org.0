Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58B81500FA
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgBCEjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:39:20 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44214 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgBCEjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:39:20 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so12343747otj.11
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 20:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MMZL9uS3JbVJ2lhDFniRbbl1cpu9QULQN44Jq2JwMCQ=;
        b=fegu5qmCa2bwvsfaoI53q6wdn5DvNXNHMQNHW8r/TWPrtd/d8ORCVJftkEy0GWW97A
         VuFxzJySjD1l47rvcmSqOvc2zNxVNmniaFjE10QWKgNtqER8eRtlKgwx0TaG7RIScfdY
         6MQqKqW+gxY4USTj1pFqYw8GJ1PIphZIyWLaduRMXDKexAbjyaglVGhfsaWSPh3zO9fF
         c3YCibAAdnq3oxDLY0+Nw0P3rwSgz+GcVOzFxDuMwaCdUe2K4KzXLp7aAWujfhvonaBc
         e8w+3/F9ilk3x2RiKaTGl1xnu04GLlfjAiSElUNuJzlugu+ac+N2mKMhsywtldyB32Gc
         PlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MMZL9uS3JbVJ2lhDFniRbbl1cpu9QULQN44Jq2JwMCQ=;
        b=HKqVSJ5pWNuCaz90eX+0RGp62maGFFUTJ08gnwg4gPNXdDiC2vZQTo/qrHkEpzlfrk
         K4rD+EnKzM1x5NpymFPV0rS03/YpjhovJGHKDwzgZ9DCu3u0adiczPRneT1YLVq3vfzK
         l5pf7q/P4CKDbrI3SRs7u2U5HYzTVMwBpHCRyyytzwHa1hLCJQbZC2PIdJoqJcT0asn9
         fN8NUfdLb867sMZ0Z9WTS+vBnXhDzrxQOV4CngBsnS7sbnopw9hfHK7KnKLI3JokeUYJ
         6VEMsZ7ygwoyO9DBvRniqlD2PofB9Cx68sMyFMK55pfqCKD2JLRMHNG1xaVxmbL//rH8
         qpaQ==
X-Gm-Message-State: APjAAAXC7KjSkUWYpAvHLYk/nQBXmUjTji+xDXTZ09bcsuOsF8iw+yNO
        vpC+gtW4APo2xHE7LJqxBFVk/83EmkimWqWj1qgTpCCiL2E=
X-Google-Smtp-Source: APXvYqwdV6yLkKUQfQ8vWKlSw3+E0up3YCWbvYtPbj+Lsa/a1WhwXO27veKjxw1426En7g0uXKKqRNNaBderX1F4Cfo=
X-Received: by 2002:a05:6830:1e64:: with SMTP id m4mr17274167otr.244.1580704757852;
 Sun, 02 Feb 2020 20:39:17 -0800 (PST)
MIME-Version: 1.0
References: <20200202181950.18439-1-xiyou.wangcong@gmail.com> <20200202133047.5deec0e2@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200202133047.5deec0e2@cakuba.hsd1.ca.comcast.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 2 Feb 2020 20:39:06 -0800
Message-ID: <CAM_iQpUu_sY3EFBJQUQ5212Y4=Az6p2G6P+DNa-T_dYLVnrtWA@mail.gmail.com>
Subject: Re: [Patch net] net_sched: fix an OOB access in cls_tcindex
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 2, 2020 at 1:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun,  2 Feb 2020 10:19:50 -0800, Cong Wang wrote:
> > As Eric noticed, tcindex_alloc_perfect_hash() uses cp->hash
> > to compute the size of memory allocation, but cp->hash is
> > set again after the allocation, this caused an out-of-bound
> > access.
> >
> > So we have to move all cp->hash initialization and computation
> > before the memory allocation. Move cp->mask and cp->shift together
> > as cp->hash may need them for computation.
> >
> > Reported-and-tested-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
> > Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/sched/cls_tcindex.c | 38 +++++++++++++++++++-------------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> >
> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index 3d4a1280352f..2ba8c034fce8 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -333,6 +333,25 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >       cp->fall_through = p->fall_through;
> >       cp->tp = tp;
> >
> > +     if (tb[TCA_TCINDEX_HASH])
> > +             cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
> > +
> > +     if (tb[TCA_TCINDEX_MASK])
> > +             cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
> > +
> > +     if (tb[TCA_TCINDEX_SHIFT])
> > +             cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
> > +
> > +     if (!cp->hash) {
> > +             /* Hash not specified, use perfect hash if the upper limit
> > +              * of the hashing index is below the threshold.
> > +              */
> > +             if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
> > +                     cp->hash = (cp->mask >> cp->shift) + 1;
> > +             else
> > +                     cp->hash = DEFAULT_HASH_SIZE;
> > +     }
> > +
> >       if (p->perfect) {
> >               int i;
> >
>                 if (tcindex_alloc_perfect_hash(net, cp) < 0)
>                         goto errout;
>                 for (i = 0; i < cp->hash; i++)
>                         cp->perfect[i].res = p->perfect[i].res;
>                 balloc = 1;
>         }
>
> Wouldn't the loop be a problem now? cp->hash defaulted to previous
> value - s/cp->hash/min(cp->hash, p->hash)/ ?

Yes, good catch!

>
> Also, unrelated, I think the jump to errout1 leaks cp->perfect and exts?

Yes, we should call tcindex_free_perfect_hash(). I will make
a separated patch for this.

Thanks.
