Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9047E15109C
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 20:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgBCT67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 14:58:59 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43521 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgBCT67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 14:58:59 -0500
Received: by mail-oi1-f196.google.com with SMTP id p125so15977620oif.10;
        Mon, 03 Feb 2020 11:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BmohpHCjIq9+chn6leBdsiG1usxcQIIK/dXJdjoXWPg=;
        b=PvsWLNrz0lHlb2+2kVEf2pwV/TizuSmB41RqZHYosaNycHkAx8v72d/t224QlPmgKv
         zb6ZNvNrJ1NIBvK72yldA79QXcSPCbT8m2kqcxh8N99SFAGiiHy8Aw/oZYA5UPw+zkrh
         Gheu3XjMf62B9S7GWrdMWdLlBp4T76G45TGrdbhtmBI4f0/n9vlzBde/cWNq62tNjMOK
         Ib6vBoGXQ6q9BtLARRWdMn92RItARsxydAGP7RvDTxGoEJA4+9+/8zGg+clIoCMk5+1s
         BMPDKVkiYBbEqJtwZmcjsofBDb0SKI/Yzvm2h7q2JdIZ39qRrCAgOQPfi4nQmjCrE09J
         WFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmohpHCjIq9+chn6leBdsiG1usxcQIIK/dXJdjoXWPg=;
        b=pL3zoTZGZk6KGrx5GgWIpj7PsDs5zev4l7fuxPcVdc0l85C71FONupA13/KFnol+9g
         cA4Z141H6kvGRsWd999egfw3ou+6Pef//hczIrglqnsmdnq+PNJb3XRMIyl3PO13d8o3
         KsWRQDBAQlNxx8qsU0lM+CDIiPuG312zOt10yUfrDwYSAiDRA4LB0dO9NTmdAsAArY8z
         /hHrFAH2RVmyy+ow00jN7Lk/QKGfcZ3iVFkqOeALkEfitJstSmhhMPPnvLeCTwshlisg
         NBi86wC9xIjjwhJbUDcgiYitB8U0SjwzTEZg0Zv6L0VkTDuEbuBxInlkZ42O2e1x6AWZ
         ZKfQ==
X-Gm-Message-State: APjAAAX17V8pg+v9SOSXBIZ+3jV2umoomot46mphxU2vKo4WtEcTYXpm
        Eb3fNMf+OwIP3vy4LjAkXttevnbbdgKuK4+Usk4=
X-Google-Smtp-Source: APXvYqykPtXOUjCIXrNKF10ltdfIkcjOcKhB5uft5Xsbm38UAyEEjYVQRciKIW9RvlyLH/a5KNEl4RS77WrhJMUj89o=
X-Received: by 2002:aca:f08:: with SMTP id 8mr530912oip.60.1580759938556; Mon,
 03 Feb 2020 11:58:58 -0800 (PST)
MIME-Version: 1.0
References: <20200131065647.joonbg3wzcw26x3b@kili.mountain>
 <CAM_iQpUYv9vEVpYc-WfMNfCc9QaBzmTYs66-GEfwOKiqOXHxew@mail.gmail.com> <20200203083853.GH11068@kadam>
In-Reply-To: <20200203083853.GH11068@kadam>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 3 Feb 2020 11:58:47 -0800
Message-ID: <CAM_iQpWu=EuAj709=wL0ZgbLvFgBbaaVZcMjYm0ZmTeLJ7nkCg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: prevent a use after free
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 12:39 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Sat, Feb 01, 2020 at 11:38:43AM -0800, Cong Wang wrote:
> > On Thu, Jan 30, 2020 at 10:57 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > >
> > > The code calls kfree_skb(skb); and then re-uses "skb" on the next line.
> > > Let's re-order these lines to solve the problem.
> > >
> > > Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > ---
> > >  net/sched/sch_fq_pie.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
> > > index bbd0dea6b6b9..78472e0773e9 100644
> > > --- a/net/sched/sch_fq_pie.c
> > > +++ b/net/sched/sch_fq_pie.c
> > > @@ -349,9 +349,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
> > >         while (sch->q.qlen > sch->limit) {
> > >                 struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
> > >
> > > -               kfree_skb(skb);
> > >                 len_dropped += qdisc_pkt_len(skb);
> > >                 num_dropped += 1;
> > > +               kfree_skb(skb);
> >
> > Or even better: use rtnl_kfree_skbs().
>
> Why is that better?

Because it is designed to be used in this scenario,
as it defers the free after RTNL unlock which is after
sch_tree_unlock() too.

Thanks.
