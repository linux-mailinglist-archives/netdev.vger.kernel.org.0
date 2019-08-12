Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F08BE8A438
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfHLRZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:25:53 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37278 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHLRZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:25:53 -0400
Received: by mail-qk1-f194.google.com with SMTP id s14so7115835qkm.4;
        Mon, 12 Aug 2019 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h9Fd8ad52H/DXc3EHqrRcl7UWFQ+n2opqsuoNUk+fj4=;
        b=gk6B7+x9JvpjciKJE8+BS6x1209RGxdCQ44W6xZlmXchN8q7r8y3dolOfjdqPhIoT5
         ufjIpCSqId54VkRVRJ1HSMeNrF8rQD24rMQlXlrRQ3QNuuVpoSwneieUQnN1vnHjwEcS
         sGSeY+aQxvuWkDll+X6gHoffejn6FFaeXJh81vlB7i5Bwt6k9VvfJNlPbhZP1Kr5n8DE
         cpDrVb+oFXVs1lKnfiZbSDieh2bsDTOY/l+VtjLRwQS8wEzCZPb6iQtz/HyZFb4TfmhB
         kwJeg0n5TfAW/6NhZ5qz0ODzo9frvlE3Vr3qf2qE6ug6C2dtrgRq436Gy8AKz4yokKo0
         0HUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h9Fd8ad52H/DXc3EHqrRcl7UWFQ+n2opqsuoNUk+fj4=;
        b=qU8ElZoI4SsW76qc153t9auAorP8IK3skAXw6X1UQkJbw3hZqbtY83qIZ9GDOc9bN5
         q6lTf8G+lUbEtNUPpeYwjtUGHtZGZouQW3WehtQ6pmkJMrdr85Vc8IeoBsfFVOXU2D8a
         L+1MOvCI/cvaMMiGaz/SHkq4TUl1cVXWGMryIOK/4Qiz1tqvAjHBirLKc6hDLhGibzFH
         9Q5nJF1rrF+G2uHECa4P8naijkno9rENMcNghfcXjjQ0sIYs9zkpOt3U99YylTHz9NgZ
         EIunyqqPqBY3DCQTDBaFGRkLRZz+kvFjkcXqLhQI9PXWE/rRczpXB16WFT6RLIiC73+e
         AlWg==
X-Gm-Message-State: APjAAAVD9uoZhizLFA+O1pkubzabhLFWUQkr6frK7aR0oLL8dJazLDFk
        HeGkwldfJBIAvd7UtDfro9A6WblTEBLkBRLEOvsb9QuW9YY=
X-Google-Smtp-Source: APXvYqwz9YRUN6iViaNMwZ7Dentim6bctiDMDgoDYqetEvemutV+2Q5yO0XBRlXmXNGSc+7j3MSoRmPkaV9WfUwtj1g=
X-Received: by 2002:a37:f902:: with SMTP id l2mr2639584qkj.218.1565630751660;
 Mon, 12 Aug 2019 10:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190802081154.30962-1-bjorn.topel@gmail.com> <20190802081154.30962-2-bjorn.topel@gmail.com>
 <5ad56a5e-a189-3f56-c85c-24b6c300efd9@iogearbox.net>
In-Reply-To: <5ad56a5e-a189-3f56-c85c-24b6c300efd9@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 12 Aug 2019 19:25:40 +0200
Message-ID: <CAJ+HfNhO+xSs25aPat9WjC75W6_Kgfq=GU+YCEcoZw-GCjZdEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 at 14:28, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
[...]
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 59b57d708697..c3447bad608a 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -362,6 +362,50 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
> >       dev_put(dev);
> >   }
> >
> > +static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> > +                                           struct xdp_sock ***map_entr=
y)
> > +{
> > +     struct xsk_map *map =3D NULL;
> > +     struct xsk_map_node *node;
> > +
> > +     *map_entry =3D NULL;
> > +
> > +     spin_lock_bh(&xs->map_list_lock);
> > +     node =3D list_first_entry_or_null(&xs->map_list, struct xsk_map_n=
ode,
> > +                                     node);
> > +     if (node) {
> > +             WARN_ON(xsk_map_inc(node->map));
>
> Can you elaborate on the refcount usage here and against what scenario it=
 is protecting?
>

Thanks for having a look!

First we access the map_list (under the lock) and pull out the map
which we intend to clean. In order to clear the map entry, we need to
a reference to the map. However, when the map_list_lock is released,
there's a window where the map entry can be cleared and the map can be
destroyed, and making the "map", which is used in
xsk_delete_from_maps, stale. To guarantee existence the additional
refinc is required. Makes sense?

> Do we pretend it never fails on the bpf_map_inc() wrt the WARN_ON(),
> why that (what makes it different from the xsk_map_node_alloc() inc
> above where we do error out)?

Hmm, given that we're in a cleanup (socket release), we can't really
return any error. What would be a more robust way? Retrying? AFAIK the
release ops return an int, but it's not checked/used.

> > +             map =3D node->map;
> > +             *map_entry =3D node->map_entry;
> > +     }
> > +     spin_unlock_bh(&xs->map_list_lock);
> > +     return map;
> > +}
> > +
> > +static void xsk_delete_from_maps(struct xdp_sock *xs)
> > +{
> > +     /* This function removes the current XDP socket from all the
> > +      * maps it resides in. We need to take extra care here, due to
> > +      * the two locks involved. Each map has a lock synchronizing
> > +      * updates to the entries, and each socket has a lock that
> > +      * synchronizes access to the list of maps (map_list). For
> > +      * deadlock avoidance the locks need to be taken in the order
> > +      * "map lock"->"socket map list lock". We start off by
> > +      * accessing the socket map list, and take a reference to the
> > +      * map to guarantee existence. Then we ask the map to remove
> > +      * the socket, which tries to remove the socket from the
> > +      * map. Note that there might be updates to the map between
> > +      * xsk_get_map_list_entry() and xsk_map_try_sock_delete().
> > +      */

I tried to clarify here, but I obviously need to do a better job. :-)


Bj=C3=B6rn
