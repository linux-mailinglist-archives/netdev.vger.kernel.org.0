Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E414A7FE69
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390438AbfHBQQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:16:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41703 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390387AbfHBQQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:16:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so72824444eds.8
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 09:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc
         :content-transfer-encoding;
        bh=yq678WdcyRIfxxz1DjqvitXgUUTXiKqpiBLFlR7X/ao=;
        b=J5OUB74qGq7b2/ibzxcih2qZHgXqBteTmx95ced/ZyqN00DC5mOxDTYKiC/QKDK1LD
         Roetp66a85vdOGabzMr3kYXd0TfKwXCepHWrs0fTkiERptOPXSZwS3dq4Lo6fQt8xNR4
         WCRk812zkJDBWQxKrT4fn94oIBmB2coZaDAZNqOzb00KZDujo/DuX9VSoUG0OAuOIZ7p
         V72pdqpwUpaXsRuZeO3TpIVMQJR0uCBW79i/zl6/KzCYAQn6cswnGEoEqdoZTrWoykBk
         Uu1cTTow/8IhgF49dP9tEpEb9yrPy1yrl99/XvWHS0B+AsrcvOHcdqo/6VWN3qQvWd+t
         cJqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc:content-transfer-encoding;
        bh=yq678WdcyRIfxxz1DjqvitXgUUTXiKqpiBLFlR7X/ao=;
        b=sxnutVirXK8QwvaXPV0Uz2hO9kLh5lypSrGyLdC9545s8zbxEKfP2YLIbSonJsComK
         6qRQma1Ue4sKwUO4hq/cunvtICBN3zl2kC17ih0QGToNQ0RW0pwf8ghGp0d8uMt//d3j
         +GmNZp64xkx3Mh/gFxdEadxxoTgjLhlUGNhUh5UZh5AF161Ku8WEwd51ffuQmZS4QSkB
         +ui/iQdtOTERZjQxwc7oAky37gHmmjk3RFLgSiWqKaB5OFlU08RcUAWJVtJ54ThBoJMP
         PwjNU7zKIreO1XjhLiWMpORNBmucyWi9AcJjj3oDEg+u2anrYZiaalqhm4Ayd9YU5iDp
         EtaQ==
X-Gm-Message-State: APjAAAX5MYF7JfAFEWQAhvDWyjFqCPWf8YQlD+hld0sNN9ZM5wR6aq5j
        3F7KIb83xuxFIHn1y/H3Su9hajC3IDy4t1z57lE=
X-Received: by 2002:a17:906:7cd6:: with SMTP id h22mt13232786ejp.254.1564762577156;
 Fri, 02 Aug 2019 09:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190802125720.22363-1-hslester96@gmail.com>
In-Reply-To: <20190802125720.22363-1-hslester96@gmail.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sat, 3 Aug 2019 00:16:06 +0800
Message-ID: <CANhBUQ3L29NzKEdpK5MvUZh7E97Co_vHRzjH2KaXxx+93_9WWg@mail.gmail.com>
Subject: Re: [PATCH] niu: Use refcount_t for refcount
Cc:     "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuhong Yuan <hslester96@gmail.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=882=E6=97=
=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=888:57=E5=86=99=E9=81=93=EF=BC=9A
>
> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.
>
> Also convert refcount from 0-based to 1-based.

It seems that directly converting refcount from 0-based to
1-based is infeasible.
I am sorry for this mistake.

Regards,
Chuhong

>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  drivers/net/ethernet/sun/niu.c | 6 +++---
>  drivers/net/ethernet/sun/niu.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/ni=
u.c
> index 0bc5863bffeb..5bf096e51db7 100644
> --- a/drivers/net/ethernet/sun/niu.c
> +++ b/drivers/net/ethernet/sun/niu.c
> @@ -9464,7 +9464,7 @@ static struct niu_parent *niu_new_parent(struct niu=
 *np,
>         memcpy(&p->id, id, sizeof(*id));
>         p->plat_type =3D ptype;
>         INIT_LIST_HEAD(&p->list);
> -       atomic_set(&p->refcnt, 0);
> +       refcount_set(&p->refcnt, 1);
>         list_add(&p->list, &niu_parent_list);
>         spin_lock_init(&p->lock);
>
> @@ -9524,7 +9524,7 @@ static struct niu_parent *niu_get_parent(struct niu=
 *np,
>                                         port_name);
>                 if (!err) {
>                         p->ports[port] =3D np;
> -                       atomic_inc(&p->refcnt);
> +                       refcount_inc(&p->refcnt);
>                 }
>         }
>         mutex_unlock(&niu_parent_lock);
> @@ -9552,7 +9552,7 @@ static void niu_put_parent(struct niu *np)
>         p->ports[port] =3D NULL;
>         np->parent =3D NULL;
>
> -       if (atomic_dec_and_test(&p->refcnt)) {
> +       if (refcount_dec_and_test(&p->refcnt)) {
>                 list_del(&p->list);
>                 platform_device_unregister(p->plat_dev);
>         }
> diff --git a/drivers/net/ethernet/sun/niu.h b/drivers/net/ethernet/sun/ni=
u.h
> index 04c215f91fc0..755e6dd4c903 100644
> --- a/drivers/net/ethernet/sun/niu.h
> +++ b/drivers/net/ethernet/sun/niu.h
> @@ -3071,7 +3071,7 @@ struct niu_parent {
>
>         struct niu              *ports[NIU_MAX_PORTS];
>
> -       atomic_t                refcnt;
> +       refcount_t              refcnt;
>         struct list_head        list;
>
>         spinlock_t              lock;
> --
> 2.20.1
>
