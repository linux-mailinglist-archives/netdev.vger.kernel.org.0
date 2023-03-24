Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88256C7EC5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjCXNac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 09:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCXNab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:30:31 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF501702;
        Fri, 24 Mar 2023 06:30:29 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r187so2129752ybr.6;
        Fri, 24 Mar 2023 06:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679664628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TWgGtgtUJ5ulwzvO8r2Booz+DyAosWcUpTNzBogezc=;
        b=A/w6LUcRP3gszxeyOCYcmTA4JZs95onD5n6II3XlBaPu7AxM4WHXVfLdO24epn+6Hh
         GnzOtpaiapAGXliF6nEDbzoW5oOBCkr3uh2RH86Y1Qg8Fxry6cIwzjPF6eBBmh+1t/Cd
         u9JDYwIDfYvoP4DFTs02+Nl/Ra6l/PrsuIWZW9WT3pgiTO6gSG8t5BlCGkIWj7gQ/ZNV
         Ciiz4UwOY9mdRGrIH1aCgXRtaPspowj0ydagvf1725me7M/NjkkvmJy1B9O3REFiUsuF
         ftaRkqLzuK9hcquJ7uRjiq3NWMmNXuXmEukQBGerxuOV5YFcnuLawYOFMViMTA+PdUpN
         /XwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679664628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9TWgGtgtUJ5ulwzvO8r2Booz+DyAosWcUpTNzBogezc=;
        b=y7vG9iB0VTth6IKP/74IycTzeMXigAYXEcXjaUlT7MdJHh+Jtmn3zXDY0E3IZ53WHj
         bepTX8XRH4vpLy+4CRO7s24nCRRz0PKJZ52uuuE9N6d4CK8OxBOs6DdL1Hhqqwqnzypm
         bAbeJzbU1NxByAatc2tjr5iYIRnPNmoW9ifErMuH6Pvuy/SRrBT6lOtkw5ahjEor211s
         5ZuqC/M39sK3rDKFHoc+9oVF8FOXYNIjGIB++nnM+3bhbj2HCpegZJuNC9JWa6e7N7PI
         1bMNjAyo9RUSJ+KsedlxGyXwmwocCamemfheNMlg8UTvv7nT2WS5Qs4ExwXSENrENvzL
         K9jw==
X-Gm-Message-State: AAQBX9cneZDmHI7vvndHqUQpFpZIlOJvLS9XRl/uLRv9fAV8AAKnMfmR
        55UEG88uHgWXobzknq9KrFNM9eL2nkqkV11bm4OWxdxoS0IFnw==
X-Google-Smtp-Source: AKy350Z1hreagQzRf7/46Sy45VdI9BuAnvYTW7Qj6dgzg60RNtaU3V0OjAd9byIINANDWw4C05aa8OqDT5n8AED/c4Y=
X-Received: by 2002:a05:6902:1247:b0:b78:4b00:7772 with SMTP id
 t7-20020a056902124700b00b784b007772mr268828ybu.5.1679664628254; Fri, 24 Mar
 2023 06:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230324100222.13434-1-nunog@fr24.com> <ZB2VNg7yVxAjJEMV@boxer>
In-Reply-To: <ZB2VNg7yVxAjJEMV@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 24 Mar 2023 14:30:17 +0100
Message-ID: <CAJ8uoz3f1=MPiranw7iU0DWNuBka4g7hNn5POgoFVHbOkun8OQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next V4] xsk: allow remap of fill and/or completion rings
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 at 13:22, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Mar 24, 2023 at 10:02:22AM +0000, Nuno Gon=C3=A7alves wrote:
> > The remap of fill and completion rings was frowned upon as they
> > control the usage of UMEM which does not support concurrent use.
> > At the same time this would disallow the remap of these rings
> > into another process.
> >
> > A possible use case is that the user wants to transfer the socket/
> > UMEM ownership to another process (via SYS_pidfd_getfd) and so
> > would need to also remap these rings.
> >
> > This will have no impact on current usages and just relaxes the
> > remap limitation.
> >
> > Signed-off-by: Nuno Gon=C3=A7alves <nunog@fr24.com>
> > ---
> > V3 -> V4: Remove undesired format changes
> > V2 -> V3: Call READ_ONCE for each variable and not for the ternary oper=
ator
> > V1 -> V2: Format and comment changes
>
> thanks, it now looks good to me, i applied this locally and it builds, so=
:
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
> but i am giving a last call to Magnus since he was acking this before.

I have already acked it, but I can do it twice.
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> >
> >  net/xdp/xsk.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 2ac58b282b5eb..cc1e7f15fa731 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -1301,9 +1301,10 @@ static int xsk_mmap(struct file *file, struct so=
cket *sock,
> >       loff_t offset =3D (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> >       unsigned long size =3D vma->vm_end - vma->vm_start;
> >       struct xdp_sock *xs =3D xdp_sk(sock->sk);
> > +     int state =3D READ_ONCE(xs->state);
> >       struct xsk_queue *q =3D NULL;
> >
> > -     if (READ_ONCE(xs->state) !=3D XSK_READY)
> > +     if (state !=3D XSK_READY && state !=3D XSK_BOUND)
> >               return -EBUSY;
> >
> >       if (offset =3D=3D XDP_PGOFF_RX_RING) {
> > @@ -1314,9 +1315,11 @@ static int xsk_mmap(struct file *file, struct so=
cket *sock,
> >               /* Matches the smp_wmb() in XDP_UMEM_REG */
> >               smp_rmb();
> >               if (offset =3D=3D XDP_UMEM_PGOFF_FILL_RING)
> > -                     q =3D READ_ONCE(xs->fq_tmp);
> > +                     q =3D state =3D=3D XSK_READY ? READ_ONCE(xs->fq_t=
mp) :
> > +                                              READ_ONCE(xs->pool->fq);
> >               else if (offset =3D=3D XDP_UMEM_PGOFF_COMPLETION_RING)
> > -                     q =3D READ_ONCE(xs->cq_tmp);
> > +                     q =3D state =3D=3D XSK_READY ? READ_ONCE(xs->cq_t=
mp) :
> > +                                              READ_ONCE(xs->pool->cq);
> >       }
> >
> >       if (!q)
> > --
> > 2.40.0
> >
