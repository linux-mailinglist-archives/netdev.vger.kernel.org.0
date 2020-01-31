Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C041E14F528
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 00:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAaXQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 18:16:57 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40655 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgAaXQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 18:16:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id i6so8216996otr.7;
        Fri, 31 Jan 2020 15:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIqBKezgXhXL90yR7nhgfKyJZrF/7eCQqHs4sIvrb6E=;
        b=lznRo42sacALxBqosqRP5maTPg+i+/TJGaD97Vd3bqA9JHhikGYyrjxldD4ToksAh6
         xxqA038tY6l2EmxvUry1IiNpZWZ97vVqw5ATVNAqsV7U9azJuaGYH5F1uLgyGsmXJ1cm
         71l3XFijuuHD8deOZGmSdZbuldw+mOUXmG+D+ycboqadtMDMsznMldH3w3hqE/b2wLAG
         Iz7XX38SyciIXU+cjRIJcGBmwtwRWa4BYDvSOdEjr3xe9zAZPgSo1UVcUC2HypGPsiz2
         J+gzbTKR/Dq6e4cAuJ8RfWc617kWqoUxcXpajpdU64CEc+wtIkkJoGb1mYyaTceNote0
         Rb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIqBKezgXhXL90yR7nhgfKyJZrF/7eCQqHs4sIvrb6E=;
        b=jVAhat/70sSZHRBxnZzcT5UlqXu9QcDbNYSkET8ssU2hUz6XccQb9muJJ/Caez6BWF
         esLsmdLjeve1p/qk/yRqaNEmi8DJp8aXdQ8uCezmzt6O3BagbRAXbLOAMnMXXu1LIDC+
         +4Fo9ps6G0kATJ1wblok9475YpEeIgvsFsg2USjeKTjLJ/0uOVOHSs91v1+KpDQ3GtNj
         iZ+0KflHpzAeKnESJUzbjH+WIZJBGQ7Fg9GblO2Y0sy/srlTVjNdDJ6BsyCH8pRzk2bk
         3OaNF/axFl3Gy/GW1AzmWsAy+gUKN3nY2VVuZ0+Fkw8KQHrc7Y+164TpR+XZtf69DIc8
         XG8Q==
X-Gm-Message-State: APjAAAUPzb4a6eXhBhMGovi4oNeUgXRojIXPvFAr5HVkCIA8Pbpy8WG4
        ZrNXicTmDr7I3Rudp7mGnSkWRr1iNXwyYyaLjLw=
X-Google-Smtp-Source: APXvYqyGH1ahqLNQYwiaB6NeLizJhLjMfhxNw+lMoADveUTmSTGDzWDxxnB3+MIcIckJUFO7OkTOsqTlDWAY/TdlqfY=
X-Received: by 2002:a9d:664a:: with SMTP id q10mr8949883otm.298.1580512615853;
 Fri, 31 Jan 2020 15:16:55 -0800 (PST)
MIME-Version: 1.0
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-4-xiyou.wangcong@gmail.com> <20200131220807.GJ795@breakpoint.cc>
In-Reply-To: <20200131220807.GJ795@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 Jan 2020 15:16:44 -0800
Message-ID: <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com>
Subject: Re: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
To:     Florian Westphal <fw@strlen.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 2:08 PM Florian Westphal <fw@strlen.de> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > The user-specified hashtable size is unbound, this could
> > easily lead to an OOM or a hung task as we hold the global
> > mutex while allocating and initializing the new hashtable.
> >
> > The max value is derived from the max value when chosen by
> > the kernel.
> >
> > Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/netfilter/xt_hashlimit.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> > index 57a2639bcc22..6327134c5886 100644
> > --- a/net/netfilter/xt_hashlimit.c
> > +++ b/net/netfilter/xt_hashlimit.c
> > @@ -272,6 +272,8 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
> >  }
> >  static void htable_gc(struct work_struct *work);
> >
> > +#define HASHLIMIT_MAX_SIZE 8192
> > +
> >  static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
> >                        const char *name, u_int8_t family,
> >                        struct xt_hashlimit_htable **out_hinfo,
> > @@ -290,7 +292,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
> >               size = (nr_pages << PAGE_SHIFT) / 16384 /
> >                      sizeof(struct hlist_head);
> >               if (nr_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
> > -                     size = 8192;
> > +                     size = HASHLIMIT_MAX_SIZE;
> >               if (size < 16)
> >                       size = 16;
> >       }
> > @@ -848,6 +850,8 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
> >
> >       if (cfg->gc_interval == 0 || cfg->expire == 0)
> >               return -EINVAL;
> > +     if (cfg->size > HASHLIMIT_MAX_SIZE)
> > +             return -ENOMEM;
>
> Hmm, won't that break restore of rulesets that have something like
>
> --hashlimit-size 10000?
>
> AFAIU this limits the module to vmalloc requests of only 64kbyte.
> I'm not opposed to a limit (or a cap), but 64k seems a bit low to me.

8192 is from the current code which handles kernel-chosen size
(that is cfg->size==0), I personally have no idea what the max
should be. :)

Please suggest a number.

Thanks.
