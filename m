Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A549E6C13DE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjCTNp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjCTNpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:45:36 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963126C07;
        Mon, 20 Mar 2023 06:45:18 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-5416b0ab0ecso224895737b3.6;
        Mon, 20 Mar 2023 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679319916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSb4O0PeaHNe3gBc2pcRz8CtU7cfiYwV5urttGac2b0=;
        b=bgh02FDftrt+sddaley3rGdy4OqlNDYBVbU3GNguh/cnKLFKoq81wEV9MG5iS2fnvJ
         0sz+Ef6zmCrdUgCp7rRV3ojvassHZBkBUMx/a06oQ+E/4hCfyJCtkXTUYMOLzFNaDrUY
         uyGD0CiOgsrZHLX3rn1OVElrPO0kN6dBDyaG6mQvp45npbaxX3y52qR8Sx+vAtOOSAdd
         RAtfPfsiG61u+IzoHleOkrodhQcAN1nx0DSqQWb9z7vKLFQT9nhnUoc4KEXR9XOBLe9r
         7qpKeBpaTZMH/eTVVhvP2cYJWjvNjXMxkWjJA7UQVAa49NtaWkoPiT0MUeE/fQ69gk3J
         P31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679319916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bSb4O0PeaHNe3gBc2pcRz8CtU7cfiYwV5urttGac2b0=;
        b=2jcTz9k44kDhzG5UzvOaRzssH3Ws+yRKPudtkFO6afcrGpmzVp+SxqRNHq/0tJsFFU
         Zmlrq9AvYkRNg0v1lgsMna07eO2XtnTTeI4dvJqzVioy9fUvMMMbQzP43pNRrZMVRIVg
         +BWYLK3tWI3d2Oxb0UALD4Q2UwmHJ+m5/1dJ+nASo4EcFMo7V8nNZMDtH4qJmChzPiNo
         i0Z+0LVJCIRiUR30vjpZcuT1RutK9XWPYQXdSiBhuCfYf6o26JN98YwuUmGmwN5fYGu7
         8Z7FH9csg3AbArXXYIaBwIpcII79PRtSHT9hc/+5mhMQ9Trn54KeU8cvX2dVoGGwresp
         semg==
X-Gm-Message-State: AO0yUKU7PORiBs3GDAl36ARd5x3cViutoa05tRHaY04nC1PSUHoUwQl2
        Ftd6c13/g8fp/qISROM11gniBRbHeGNZ+UNK4X4Blnk4mDVjjA==
X-Google-Smtp-Source: AK7set92By9N0r2WjB8v8U0HoFS7LbXZRgxPzy2+9DTwwYD6my7jo4lxlXnDBlrM0Sdt9kxvPfQqR6DpZOmBCdBz/js=
X-Received: by 2002:a81:431b:0:b0:544:94fe:4244 with SMTP id
 q27-20020a81431b000000b0054494fe4244mr10343937ywa.10.1679319914612; Mon, 20
 Mar 2023 06:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230320105323.187307-1-nunog@fr24.com> <20230320110314.GJ36557@unreal>
 <CAJ8uoz1kbFsttvWNTUdtYcwEa=hQvky2z0Jfn0=9b5v6m_FVXg@mail.gmail.com> <20230320134058.GM36557@unreal>
In-Reply-To: <20230320134058.GM36557@unreal>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Mar 2023 14:45:03 +0100
Message-ID: <CAJ8uoz2ctdQzG8V+13RUQW0BjK1-L6ckP=HbxcAz2xerYhCsLQ@mail.gmail.com>
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

On Mon, 20 Mar 2023 at 14:41, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Mar 20, 2023 at 01:27:18PM +0100, Magnus Karlsson wrote:
> > On Mon, 20 Mar 2023 at 12:09, Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Mon, Mar 20, 2023 at 10:53:23AM +0000, Nuno Gon=C3=A7alves wrote:
> > > > The remap of fill and completion rings was frowned upon as they
> > > > control the usage of UMEM which does not support concurrent use.
> > > > At the same time this would disallow the remap of this rings
> > > > into another process.
> > > >
> > > > A possible use case is that the user wants to transfer the socket/
> > > > UMEM ownerwhip to another process (via SYS_pidfd_getfd) and so
> >
> > nit: ownership
> >
> > > > would need to also remap this rings.
> > > >
> > > > This will have no impact on current usages and just relaxes the
> > > > remap limitation.
> > > >
> > > > Signed-off-by: Nuno Gon=C3=A7alves <nunog@fr24.com>
> > > > ---
> > > >  net/xdp/xsk.c | 9 ++++++---
> > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > index 2ac58b282b5eb..2af4ff64b22bd 100644
> > > > --- a/net/xdp/xsk.c
> > > > +++ b/net/xdp/xsk.c
> > > > @@ -1300,10 +1300,11 @@ static int xsk_mmap(struct file *file, stru=
ct socket *sock,
> > > >  {
> > > >       loff_t offset =3D (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> > > >       unsigned long size =3D vma->vm_end - vma->vm_start;
> > > > +     int state =3D READ_ONCE(xs->state);
> >
> > Reverse Christmas Tree notation here please. Move it one line down to
> > after the *xs declaration.
> >
> > > >       struct xdp_sock *xs =3D xdp_sk(sock->sk);
> > > >       struct xsk_queue *q =3D NULL;
> > > >
> > > > -     if (READ_ONCE(xs->state) !=3D XSK_READY)
> > > > +     if (!(state =3D=3D XSK_READY || state =3D=3D XSK_BOUND))
> > >
> > > This if(..) is actually:
> > >  if (state !=3D XSK_READY && state !=3D XSK_BOUND)
> >
> > Nuno had it like that to start with when he sent the patch privately
> > to me, but I responded that I prefered the current one. It is easier
> > to understand if read out aloud IMO.
>
> "Not equal" is much easier to understand than "not" of whole expression.

Then my brain is wired differently ;-).

> > Do not have any strong feelings either way since the statements are equ=
ivalent.
> >
> > > Thanks
