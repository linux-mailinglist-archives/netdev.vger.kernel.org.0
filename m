Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91B4728F6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 09:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfGXHVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 03:21:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34538 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGXHVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 03:21:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so45763210wrm.1;
        Wed, 24 Jul 2019 00:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nm3bCHJrt6Bj7/j5tsZ8s5l28Yo/EjdUqE850Jtwxxs=;
        b=ryiIEjokkXOl9ZPl3NuqzVFUOxVwmO/GB9+yljRQG7E1lHWUkQdwbXEIxmPMCXveFd
         e6UjTJZVyKKOATOoeTvXGxH4kXdXFXuAJ7BeqReAna38Iaz3S6om0hoTGkJq14NW0Qet
         iWZXUbKDKNxXAZJt/aAgisOw2cLdl/DAeP59GCChkLC3iYl/UZ8UfLbGErZE8Tiu1Gjc
         XxkfGXHrXJ2lYraTvYo0YX1MbkrI+f73s33f9gWSYgD14+QX6Dm76Rnt8P+Uj6S6TRyj
         G30uyT4WhW14rcqSoFPgpMCGyl9UGoW8vzIpD1X8kqY4lkz6aZs+a8gxb7V1MyyAYolJ
         SFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nm3bCHJrt6Bj7/j5tsZ8s5l28Yo/EjdUqE850Jtwxxs=;
        b=uYWMdvPCE0pnfn2WRtTyduIVvdjvXX/D7Ly4Ulud1jhtoDgZD6jT/HWw7gh4gOqCBD
         QsZlhCRpNjaHqxwDqlZwyXL8jRRRrTfs0UpoAhpYgoKOR9GHdFoW4w8/DIkkTgkq+fgX
         64rK7IPVHSRcNo4cW62YYuGARwPcwtbkJp1eJIrHckBV0RiamZX+x7tclXHZpNz7UrEc
         zpyvolGGxAGnYu0Bfx2GWp1zCjASnEdvxvdzJfA+5ZGTHUimrWbu4cei45vCsHA+5UwO
         s0mm/YzwcnY+8yTE81uW8WFb2XJNlPDANBO1Fzpd5KV36SKx2HjMdLLxvZBocvnRWOIU
         I/MA==
X-Gm-Message-State: APjAAAWcEL2R4kttwKOTJPBrWYe8kriTaaOvfBll3zTfCatXnTmCp/Ln
        DXQUtdEyKgR7LDkrtHDk2OqKc3VZAyOTXsAmVSS5WMay
X-Google-Smtp-Source: APXvYqzLcufz6oTE57Ecr9QsG8JbkwC6GPYoLXAuiiEcjz5DEILutLTTsNTIxUGoZkfCUCLdU+FUEqgDcAZFXFuLgsw=
X-Received: by 2002:a5d:494d:: with SMTP id r13mr10790622wrs.152.1563952883202;
 Wed, 24 Jul 2019 00:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1563817029.git.lucien.xin@gmail.com> <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain>
In-Reply-To: <20190723152449.GB8419@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 24 Jul 2019 15:21:12 +0800
Message-ID: <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > sctp_inet_connect(), the latter has done addr_size check with size
> > of sa_family_t.
> >
> > In the next patch to clean up __sctp_connect(), we will remove
> > addr_size check with size of sa_family_t from __sctp_connect()
> > for the 1st address.
> >
> > So before doing that, __sctp_setsockopt_connectx() should do
> > this check first, as sctp_inet_connect() does.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/socket.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index aa80cda..5f92e4a 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> >                __func__, sk, addrs, addrs_size);
> >
> > -     if (unlikely(addrs_size <= 0))
> > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> I don't think this is what you want to check for here.  sa_family_t is
> an unsigned short, and addrs_size is the number of bytes in the addrs
> array.  The addrs array should be at least the size of one struct
> sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> sizeof(struct sockaddr)
sizeof(struct sockaddr) is not the right value to check either.

The proper check will be done later in __sctp_connect():

        af = sctp_get_af_specific(daddr->sa.sa_family);
        if (!af || af->sockaddr_len > addrs_size)
                return -EINVAL;

So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
just to make sure daddr->sa.sa_family is accessible. the same
check is also done in sctp_inet_connect().

>
> Neil
>
> >               return -EINVAL;
> >
> >       kaddrs = memdup_user(addrs, addrs_size);
> > --
> > 2.1.0
> >
> >
