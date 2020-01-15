Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E70513C8FB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAOQQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:16:46 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34166 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgAOQQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:16:45 -0500
Received: by mail-yb1-f193.google.com with SMTP id l7so3135909ybp.1
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 08:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8L6+wg/Y1qHF9hdUOy3ipRHjbg+g4CRuXgJQHDmfs4=;
        b=cFgwOBL6xVBFsuFfwHqziXydHAekAssrBSnEivLl2xu3ad1CBf1OwYrk4IQHl4sHyv
         hkZNTp4jY/Bntvj4fRvptRm4prTE5WK+gwT7Lb1NR5ri5nOIoM0alhTRNDveN26WtQDG
         Uhi03KBIrsw+oIhrDP6eOIDYKjBqe1D9dMorM1YZ7aoKiGik1tO4kqZ10AJ5DGznZN5k
         0IR15+nPuYSPno0tckOAJKQde//2Q0DlMnMdACHG36rE5/n3mm/XVMjeURnYbQqgWcOK
         7wyJaIafjsIrzDrENVN32Dpq68MJzqmbNisUCQgTUMYUV4z31yBlzlMTsaaWkg0O6a9E
         6PbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8L6+wg/Y1qHF9hdUOy3ipRHjbg+g4CRuXgJQHDmfs4=;
        b=Uxs9vzwNvP9brn6PhaUaoAgGJGsFIyPh8iao2u5E519cZgPAwhktslgo61z/zriHcB
         zcYce4/hmgYUYUN7yaDw3wiigL9CdmdvwIFWA+iwcarKKMIBuiPEjVBznFdQ0PMPdd4J
         +SHn1wZPZ/T7TdUJrpPNL9Mn6wbmSIkvvh8eodNCjUM0OT7613mL0nHPoM1jnGBHiilu
         Y5Q28LIA1njmQsb2y7l0H4cy11i7gI69m8a76sxLo0QZ8kWzWYxTqqO3P4DX39jVscVm
         ooXU4wE4A+xzPgYrNKp2UZKdF1lehtpXiYzT8iCaQ8JHSeMJuBiTIkZAhYKpZaY/3C5X
         Mv4g==
X-Gm-Message-State: APjAAAVJ+0jPEEXb97wkMS5jyYZNmkUXmpB9pmVNf8wUabb7Tf434Fu/
        LCJZaPkTm5/vwjsT3Jt/JSUkIn9GTm+T2QvR/guPjGWg
X-Google-Smtp-Source: APXvYqynuAKBS4OfxHgQotMO8C8cTgUpWvQlOrAeetwfodFU7xTTWxhHQ+cechuj6p7O/FCNIQJ2ZXVO5vDdDz3SQP4=
X-Received: by 2002:a05:6902:6c4:: with SMTP id m4mr23166678ybt.274.1579105004467;
 Wed, 15 Jan 2020 08:16:44 -0800 (PST)
MIME-Version: 1.0
References: <20200115155803.4573-1-edumazet@google.com> <f46117ffa869ca3ba7671b2dc38b6435b39b9c7a.camel@redhat.com>
In-Reply-To: <f46117ffa869ca3ba7671b2dc38b6435b39b9c7a.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Jan 2020 08:16:32 -0800
Message-ID: <CANn89iKjQR+xTGPbgSMjtxOQrKXUOFbwKqs_i95rfxtAgQAdkQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] net/sched: act_ife: initalize ife->metalist earlier
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 8:07 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
>   On Wed, 2020-01-15 at 07:58 -0800, Eric Dumazet wrote:
> > It seems better to init ife->metalist earlier in tcf_ife_init()
> > to avoid the following crash :
>
> hi Eric, thanks for following up!
>
> [...]
> > ---
> > v2: addressed Davide feedback.
> >  net/sched/act_ife.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
> > index 5e6379028fc392031f4b84599f666a2c61f071d2..ab748701374f65028c79cb789d065305430ea4c5 100644
> > --- a/net/sched/act_ife.c
> > +++ b/net/sched/act_ife.c
> > @@ -537,6 +537,9 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
> >       }
> >
> >       ife = to_ife(*a);
> > +     if (ret = ACT_P_CREATED)
> > +             INIT_LIST_HEAD(&ife->metalist);
> > +
>
> I didn't test the hunk above, but I think there is a typo, this assigns
> 'ret' rather than checking if it's equal to ACT_P_CREATED.
>
> It should be something like:
>
>         if (ret == ACT_P_CREATED)
>                 INIT_LIST_HEAD(&ife->metalist);
>
> correct?

Oh well, I should probably not attempt doing code changes in a bus ;)
Thanks, v3 will fix this.
