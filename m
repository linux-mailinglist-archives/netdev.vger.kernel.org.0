Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB527DE84
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 04:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgI3C2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 22:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbgI3C2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 22:28:08 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DFDC061755;
        Tue, 29 Sep 2020 19:28:07 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id m5so243566lfp.7;
        Tue, 29 Sep 2020 19:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUfEpw7X1G1+6Fq/FvfW4rElhh8ieZOdIb5C6ZI1b70=;
        b=OFyWx6O7rbcK+UhaL69VMj/ErjnRDsDx9W2RaKn6DO3pbuVuR+M2gPR1OsX9uv+mKt
         SijSAEjT6S1jqUokRL60JNww+n3ELZ5PYfiRrrxVCuu5CgmI4/90l9T8+9IwHOlSz63q
         QDSFbKs6NYhaTBrOzQKSlRCl1diRwtf8UTRRqzFQzH70bKT4Ldbmk8bID+TArz2cP3p3
         f5voUI15l5VS7FgefRWfaNqQR88VEWOZrDtJPSEVhIjwfCu5ZpQZWPYH8cDMGlRSJ1+F
         inawNCxiB2Sp33p3+5vGcJ+5WJw43xlurWxecUiwGMTE2h8ai+o8IciOxfUGqYmvd9re
         oeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUfEpw7X1G1+6Fq/FvfW4rElhh8ieZOdIb5C6ZI1b70=;
        b=GgJNPRCHDLVIJ7Qh6c1Fvc8ubd5UkwudPeYoeI7o/+MvXDqceULJ008hBb6pMbdlWQ
         Ms9KxLHsB+f2SB2W68MJLsCd/+4bm/1y05mrHb3aj+Cov7G8lajdFWPE5WpjWHZUsyKA
         nEJgI0w02o/tVCQ2nZEgieYR9c1ImtuFNJiS7hlqwWPo+b7agF5s0z1l4GRjQA0T4XAN
         NWw3BiZPEa5D4nv1KRL1zQK8m3be9aR9FF/c1+Dfinuz2ZYaDqUqYg6KbFz/onlpkJ4c
         brxiOQOyMgKylNyL30iqyO9V+n2BnfcchBD8sqDCk3fDncYmmISve/CcmCxL1DO82DiM
         3Plg==
X-Gm-Message-State: AOAM533wbmo5PxxWM/ORrkVxHHno4uXuCjTrn8jfaPCELWpjDFY7g4sz
        AUNXtPjup/PV3h/hRQRlGvmbBOhGUAycsCnNJIiKbnaeUN7lmgqZ
X-Google-Smtp-Source: ABdhPJzZAxEohwpc/os/gL/otbXuwFGmNZlfAOd5jy85hIxnLKCLfMYuj9MwxwijWIOY+KASe8CaTba5yJ03qpWrRUc=
X-Received: by 2002:a05:6512:31d2:: with SMTP id j18mr75425lfe.316.1601432885878;
 Tue, 29 Sep 2020 19:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg>
 <20200928024938.97121-1-bigclouds@163.com> <CAPaK2r8DnR_dcZ8E9w0mvDbK2KiWCt+JswO=-tqvbWb2RibaYw@mail.gmail.com>
In-Reply-To: <CAPaK2r8DnR_dcZ8E9w0mvDbK2KiWCt+JswO=-tqvbWb2RibaYw@mail.gmail.com>
From:   yue longguang <yuelongguang@gmail.com>
Date:   Wed, 30 Sep 2020 10:27:55 +0800
Message-ID: <CAPaK2r-jJf4z28S+h=pbaP4MN5QhG_HMDFA3RZbyhRQeALmhRQ@mail.gmail.com>
Subject: Re: [PATCH v5] ipvs: adjust the debug info in function set_tcp_state
To:     Julian Anastasov <ja@ssi.bg>, "longguang.yue" <bigclouds@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julian, Pablo, Simon,  Hi,  ping

On Tue, Sep 29, 2020 at 10:15 AM yue longguang <yuelongguang@gmail.com> wrote:
>
> I sincerely apologize for the trouble which takes up much of your
> time. If the last patch does not work , would you please fix it?
> thanks
>
> On Mon, Sep 28, 2020 at 10:51 AM longguang.yue <bigclouds@163.com> wrote:
> >
> > Outputting client,virtual,dst addresses info when tcp state changes,
> > which makes the connection debug more clear
> >
> > Signed-off-by: longguang.yue <bigclouds@163.com>
> > ---
> >  net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > index dc2e7da2742a..7da51390cea6 100644
> > --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > @@ -539,8 +539,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
> >         if (new_state != cp->state) {
> >                 struct ip_vs_dest *dest = cp->dest;
> >
> > -               IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] %s:%d->"
> > -                             "%s:%d state: %s->%s conn->refcnt:%d\n",
> > +               IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] c:%s:%d v:%s:%d "
> > +                             "d:%s:%d state: %s->%s conn->refcnt:%d\n",
> >                               pd->pp->name,
> >                               ((state_off == TCP_DIR_OUTPUT) ?
> >                                "output " : "input "),
> > @@ -548,10 +548,12 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
> >                               th->fin ? 'F' : '.',
> >                               th->ack ? 'A' : '.',
> >                               th->rst ? 'R' : '.',
> > -                             IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> > -                             ntohs(cp->dport),
> >                               IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> >                               ntohs(cp->cport),
> > +                             IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> > +                             ntohs(cp->vport),
> > +                             IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> > +                             ntohs(cp->dport),
> >                               tcp_state_name(cp->state),
> >                               tcp_state_name(new_state),
> >                               refcount_read(&cp->refcnt));
> > --
> > 2.20.1 (Apple Git-117)
> >
