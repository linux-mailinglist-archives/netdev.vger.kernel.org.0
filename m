Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8175C6C11DE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjCTM1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCTM1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:27:31 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C9A136CD;
        Mon, 20 Mar 2023 05:27:30 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p203so12744586ybb.13;
        Mon, 20 Mar 2023 05:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679315249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEWbXljd1LYRG11sK5UVV91jB+l41ceppJXLBhPyZxQ=;
        b=FTPKdoiLdpUQsq2vQl5IKRAVgwMNUI1flmBqN7gYqic7JA2v/Np4j7zs2SI6P7MbRW
         p6cttJLoS09/tKkccZmaOF94ngoeK33UeOpNiuh1Lq++BqZFUOBnU7XTi/VcWH563Vcy
         tU3nTkq9RvFFJnMxJIlgZN50OjZRYYtH3B87Drch88wRxE5X4KTOio9kKXdq4kwlT9BE
         frkC0SBb9oqdQgn5qHqzxbubdyOqSMyF5rP++1zQtY+XWsPgCXLxNMri2ngHA8Qk1ZvQ
         e/Dds216cAcgv9YTFhy5biev081VNaFDG+dSWGIRRZPog/B6Uvh/RQqtS92E3EBm5uwH
         CG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679315249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jEWbXljd1LYRG11sK5UVV91jB+l41ceppJXLBhPyZxQ=;
        b=KrKhhKj1gHlWJPUUImtTZzYxBzCNUEkFEyHZJv5o6qfJswzj6ctc28D/dDQ6pUGGT6
         BMCSBZu2DTXHYpR9SveWQJQCfvPLiYTfX2+vG+JtiYgGRk8qhDa5uIEbtPe8dLt5cHBS
         LmVcrIELENJLtBzc/ViJfSEx8TaNeG77jc9OVRIiaZsCl4gKBtMJZukem/fEoRN/MJg+
         YY/tZlO8po0u2J1Pd46EdGnCRdYSB7QwRt8PKZ0F6oPwMvd5GGRwTQwmBtDE86XB3aNK
         K3mvN+C7Dht4iP/TKAntThnknOaca5z8E8yKCQdZDL6w4BRIE38s+ZETA3Y+ArvvxzUR
         kQ4A==
X-Gm-Message-State: AO0yUKXYguMsJ8KXKmWhajX79flB1vV4HcAsqQ20q+i+oURt0kAu++69
        3qhTM3Kdz3NiRNWL0/126bQZ3vfYje2Igjs2/jpe4ty/89W6iw==
X-Google-Smtp-Source: AK7set9pZovo83jqHjzR1vy8u86GSRGshQ8PDPcM0IIgYtzkdqssKUj9bv4LrnAXJJI7c+BA2rlyBUwwEojj487jmQw=
X-Received: by 2002:a05:6902:723:b0:b6a:2590:6c63 with SMTP id
 l3-20020a056902072300b00b6a25906c63mr4953728ybt.2.1679315249522; Mon, 20 Mar
 2023 05:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230320105323.187307-1-nunog@fr24.com> <20230320110314.GJ36557@unreal>
In-Reply-To: <20230320110314.GJ36557@unreal>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Mar 2023 13:27:18 +0100
Message-ID: <CAJ8uoz1kbFsttvWNTUdtYcwEa=hQvky2z0Jfn0=9b5v6m_FVXg@mail.gmail.com>
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

On Mon, 20 Mar 2023 at 12:09, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Mar 20, 2023 at 10:53:23AM +0000, Nuno Gon=C3=A7alves wrote:
> > The remap of fill and completion rings was frowned upon as they
> > control the usage of UMEM which does not support concurrent use.
> > At the same time this would disallow the remap of this rings
> > into another process.
> >
> > A possible use case is that the user wants to transfer the socket/
> > UMEM ownerwhip to another process (via SYS_pidfd_getfd) and so

nit: ownership

> > would need to also remap this rings.
> >
> > This will have no impact on current usages and just relaxes the
> > remap limitation.
> >
> > Signed-off-by: Nuno Gon=C3=A7alves <nunog@fr24.com>
> > ---
> >  net/xdp/xsk.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 2ac58b282b5eb..2af4ff64b22bd 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -1300,10 +1300,11 @@ static int xsk_mmap(struct file *file, struct s=
ocket *sock,
> >  {
> >       loff_t offset =3D (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> >       unsigned long size =3D vma->vm_end - vma->vm_start;
> > +     int state =3D READ_ONCE(xs->state);

Reverse Christmas Tree notation here please. Move it one line down to
after the *xs declaration.

> >       struct xdp_sock *xs =3D xdp_sk(sock->sk);
> >       struct xsk_queue *q =3D NULL;
> >
> > -     if (READ_ONCE(xs->state) !=3D XSK_READY)
> > +     if (!(state =3D=3D XSK_READY || state =3D=3D XSK_BOUND))
>
> This if(..) is actually:
>  if (state !=3D XSK_READY && state !=3D XSK_BOUND)

Nuno had it like that to start with when he sent the patch privately
to me, but I responded that I prefered the current one. It is easier
to understand if read out aloud IMO. Do not have any strong feelings
either way since the statements are equivalent.

> Thanks
