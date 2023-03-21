Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A376C2FEE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCULN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjCULNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:13:55 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E633FBB2;
        Tue, 21 Mar 2023 04:13:36 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id e71so16625627ybc.0;
        Tue, 21 Mar 2023 04:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679397215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FU5JVJ+9D5IKP+4Ix/nQDFSU6B0sdw04+DWifxCdsMU=;
        b=PHEQpiV0E4XYsgrwB0FGPU9lV8PpO9eSiNfWV4urD6aDzx3BgEoCkndrGlBmm4YEF+
         +Xib0Bbb/hBPouzZZvznMkO4Ks0L/XR5leeQxiblC4wePl0x/SHQy3umlx7Ob6h7Vchy
         hPjflxfMzaZpy/X99xAWAG8fkJ+TCjqP55WP3ekNGbxUFW0m52hR52/sbQM55qumYVYW
         LqCQcMAfnZTeZxBjqnt5UIvcqCG9kSW6+GXXF+nyaccMxd7+wf+mABwkJ55gi4fWHb6v
         G+TuR0wxmBb58dAVyM/TtCBlj7k/TDkj40EhVf3k3K6ot3bqTBieoXWWRENvCK7cKmtz
         SKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679397215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FU5JVJ+9D5IKP+4Ix/nQDFSU6B0sdw04+DWifxCdsMU=;
        b=jozeUbpebNJHwWXfCCZsvkChMd6atrDkrG9hZanxrZWBW3Ff1aZxHk/Oul/xCGiNqF
         GUEP2kAi915DKnR/QxMvDd3qB5pPQ30Fve7qgBKV3rUKomfc4Sh7EtC1Fh6CN1z5ECCw
         kgLlFaBXyubCTQZh8nURdqGLb39SttpOW7LwesPerbRfhGeehP18ytjGm4+N7tZxydHo
         CyqUtaS0YFSNLv5UGvyHdKbRnWYgi64gpHwYYN4BgVROKbDqwfp2s2/7fC9qUdLkWxQj
         s8oTSP/NTTbWTXMvoYDUkj0I3ZTlVOzroDdag1T912gso/sL7iIDCzPMNs5IHZu18W+L
         60QA==
X-Gm-Message-State: AAQBX9fEQpCh529LeXALir666oMkOEZB7FQGDqideNce339kNl6gQf0p
        ZNuBbWdvKtkJ26cIVyBtYh4KoLvqnGrhg4uUPVc=
X-Google-Smtp-Source: AKy350aKCZlqYxRZWHzB38oGRFyPr1QVUoR1aWiJN45RzcZMA9VAUaFhT37UxudYTrOAQrmVMuUNffs3CjNFZOY4JKA=
X-Received: by 2002:a05:6902:1104:b0:b6a:5594:5936 with SMTP id
 o4-20020a056902110400b00b6a55945936mr1154445ybu.5.1679397215365; Tue, 21 Mar
 2023 04:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230320203732.222345-1-nunog@fr24.com>
In-Reply-To: <20230320203732.222345-1-nunog@fr24.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Mar 2023 12:13:24 +0100
Message-ID: <CAJ8uoz2N4M+FB-ijzTrVm+91yhtqfKKwmPkxjefJrmSeJOocbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2] xsk: allow remap of fill and/or completion rings
To:     =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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

On Mon, 20 Mar 2023 at 21:54, Nuno Gon=C3=A7alves <nunog@fr24.com> wrote:
>
> The remap of fill and completion rings was frowned upon as they
> control the usage of UMEM which does not support concurrent use.
> At the same time this would disallow the remap of these rings
> into another process.
>
> A possible use case is that the user wants to transfer the socket/
> UMEM ownership to another process (via SYS_pidfd_getfd) and so
> would need to also remap these rings.
>
> This will have no impact on current usages and just relaxes the
> remap limitation.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Nuno Gon=C3=A7alves <nunog@fr24.com>
> ---
>  net/xdp/xsk.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 2ac58b282b5eb..e2571ec067526 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -1301,9 +1301,10 @@ static int xsk_mmap(struct file *file, struct sock=
et *sock,
>         loff_t offset =3D (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>         unsigned long size =3D vma->vm_end - vma->vm_start;
>         struct xdp_sock *xs =3D xdp_sk(sock->sk);
> +       int state =3D READ_ONCE(xs->state);
>         struct xsk_queue *q =3D NULL;
>
> -       if (READ_ONCE(xs->state) !=3D XSK_READY)
> +       if (state !=3D XSK_READY && state !=3D XSK_BOUND)
>                 return -EBUSY;
>
>         if (offset =3D=3D XDP_PGOFF_RX_RING) {
> @@ -1314,9 +1315,11 @@ static int xsk_mmap(struct file *file, struct sock=
et *sock,
>                 /* Matches the smp_wmb() in XDP_UMEM_REG */
>                 smp_rmb();
>                 if (offset =3D=3D XDP_UMEM_PGOFF_FILL_RING)
> -                       q =3D READ_ONCE(xs->fq_tmp);
> +                       q =3D READ_ONCE(state =3D=3D XSK_READY ? xs->fq_t=
mp :
> +                                                          xs->pool->fq);
>                 else if (offset =3D=3D XDP_UMEM_PGOFF_COMPLETION_RING)
> -                       q =3D READ_ONCE(xs->cq_tmp);
> +                       q =3D READ_ONCE(state =3D=3D XSK_READY ? xs->cq_t=
mp :
> +                                                          xs->pool->cq);
>         }
>
>         if (!q)
> --
> 2.40.0
>
