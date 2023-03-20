Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD76C16CB
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjCTPJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjCTPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:08:46 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FC0158B4;
        Mon, 20 Mar 2023 08:04:14 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id j7so13433650ybg.4;
        Mon, 20 Mar 2023 08:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679324652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfQbiHyuciDYZ6wT1sRsPTIPKxB7RSLYf+crBU68Qi0=;
        b=j8k2+/3VarZSc/NMQHcwhYtJz5zq9bSfVj0k4A+7CeW8eANT8LP5VD7BHmhgHX+BHL
         /w9tVseKnuZ0NocKzEf01YhSTVAMiO3FKqhd82rQjPvCkzAyu/7tHP1ZOPdfdNHyGM40
         uk6Rq1tBGejbFEcol4lOS3uDHR66VPE32/lrvBj6htFlSrzaqqE+K3Mj3wCAuCXWfe6I
         LX2l0cClZPaHrhyh658PZjq1UA80o5B1g0nMBdxA+tPMwYynkzsGkB0MeZP77a1Kg+ca
         q/2oL7S1R29Px19BEeUxK/l3ElXHx1oZcv4b6C3vjnHCIrZSTRuhngXfBG8ewOSUFM0x
         ta3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfQbiHyuciDYZ6wT1sRsPTIPKxB7RSLYf+crBU68Qi0=;
        b=W902NNWLW1Qck8812qwZSjMup2XbCDxLiBQGILCvp4eKH27d+a3xp2D8HCmJe27BqA
         DlwW2Uts2I7+WLFzeS1V0rsF8EOQTF8fxWJXYlhbe7ELkuM8Dopn8QvNgKxAxLJQ2dja
         2BA1Ca5s5W4Nzx1jUOEj9J6pJH410S8fqbRFHkyo32hfZ95fqrNoTic9QzdAVrlk4Vhe
         VnK04y8UAdbD8JLWMfMoH9zbZBOFhOVRBKt3mbaT1gXZqpwl5gG7g4kMgP//II5ttKIQ
         YCPhJ8/oDOTIHkMrsh59fp+DD2noDvDPfBjmIbCSz79Iys1h3dhoz8rvWSMDy7npf6bf
         y1XQ==
X-Gm-Message-State: AO0yUKWbQqyLDCkLTmFJqGWQIGWkvq7r6d/wksBhC4UeAKe2Z9moqpxL
        6g9PESM3f6Jtrqz+jTbGbttEenfnyHEzimn0Lp5SUo3MqdzH/g==
X-Google-Smtp-Source: AK7set+T4SQFGUzShpw9RAeXFNVykJfZsE+AjE5Jgx8IMziSWwoV9OuKg6TnM2XPaYHyIKLIi1W7kJ7lL2bh7xi6vxE=
X-Received: by 2002:a5b:c47:0:b0:ac9:cb97:bd0e with SMTP id
 d7-20020a5b0c47000000b00ac9cb97bd0emr4310434ybr.5.1679324652143; Mon, 20 Mar
 2023 08:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230320105323.187307-1-nunog@fr24.com> <20230320110314.GJ36557@unreal>
 <CAJ8uoz1kbFsttvWNTUdtYcwEa=hQvky2z0Jfn0=9b5v6m_FVXg@mail.gmail.com>
 <20230320134058.GM36557@unreal> <CAJ8uoz2ctdQzG8V+13RUQW0BjK1-L6ckP=HbxcAz2xerYhCsLQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz2ctdQzG8V+13RUQW0BjK1-L6ckP=HbxcAz2xerYhCsLQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Mar 2023 16:04:00 +0100
Message-ID: <CAJ8uoz3XqUOmrUhP0i5GZmYhvDHMB6vd6f68zqN1WcLqSiUcJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: allow remap of fill and/or completion rings
To:     Leon Romanovsky <leon@kernel.org>
Cc:     =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 at 14:45, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> On Mon, 20 Mar 2023 at 14:41, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Mar 20, 2023 at 01:27:18PM +0100, Magnus Karlsson wrote:
> > > On Mon, 20 Mar 2023 at 12:09, Leon Romanovsky <leon@kernel.org> wrote=
:
> > > >
> > > > On Mon, Mar 20, 2023 at 10:53:23AM +0000, Nuno Gon=C3=A7alves wrote=
:
> > > > > The remap of fill and completion rings was frowned upon as they
> > > > > control the usage of UMEM which does not support concurrent use.
> > > > > At the same time this would disallow the remap of this rings

these rings

> > > > > into another process.
> > > > >
> > > > > A possible use case is that the user wants to transfer the socket=
/
> > > > > UMEM ownerwhip to another process (via SYS_pidfd_getfd) and so
> > >
> > > nit: ownership
> > >
> > > > > would need to also remap this rings.

these rings

> > > > >
> > > > > This will have no impact on current usages and just relaxes the
> > > > > remap limitation.
> > > > >
> > > > > Signed-off-by: Nuno Gon=C3=A7alves <nunog@fr24.com>
> > > > > ---
> > > > >  net/xdp/xsk.c | 9 ++++++---
> > > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > index 2ac58b282b5eb..2af4ff64b22bd 100644
> > > > > --- a/net/xdp/xsk.c
> > > > > +++ b/net/xdp/xsk.c
> > > > > @@ -1300,10 +1300,11 @@ static int xsk_mmap(struct file *file, st=
ruct socket *sock,
> > > > >  {
> > > > >       loff_t offset =3D (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> > > > >       unsigned long size =3D vma->vm_end - vma->vm_start;
> > > > > +     int state =3D READ_ONCE(xs->state);
> > >
> > > Reverse Christmas Tree notation here please. Move it one line down to
> > > after the *xs declaration.
> > >
> > > > >       struct xdp_sock *xs =3D xdp_sk(sock->sk);
> > > > >       struct xsk_queue *q =3D NULL;
> > > > >
> > > > > -     if (READ_ONCE(xs->state) !=3D XSK_READY)
> > > > > +     if (!(state =3D=3D XSK_READY || state =3D=3D XSK_BOUND))
> > > >
> > > > This if(..) is actually:
> > > >  if (state !=3D XSK_READY && state !=3D XSK_BOUND)
> > >
> > > Nuno had it like that to start with when he sent the patch privately
> > > to me, but I responded that I prefered the current one. It is easier
> > > to understand if read out aloud IMO.
> >
> > "Not equal" is much easier to understand than "not" of whole expression=
.
>
> Then my brain is wired differently ;-).

Nuno, please prepare a v2 by fixing the now four things above and
reverting this if-expression to what you had before. It is two against
one, so I yield. After that, it is good to go from my point of view.

Thanks!

> > > Do not have any strong feelings either way since the statements are e=
quivalent.
> > >
> > > > Thanks
