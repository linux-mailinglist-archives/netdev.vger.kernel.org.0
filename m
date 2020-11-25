Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BA32C3A71
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 09:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgKYIBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 03:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKYIBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 03:01:04 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155A1C0613D4;
        Wed, 25 Nov 2020 00:00:55 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id e8so1583759pfh.2;
        Wed, 25 Nov 2020 00:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R6bj5k93ILC33b5weERAxxA9VSG1mRSLslj8OKwpnZk=;
        b=jaRVsO9wkotKUcE9N+4DT46nevjEADFVjPXEZNaKlWnSGHhnN5j7/urPp3qFopgyzR
         bcNEuVVkhFmnX4V3aKts8eScnHUhggiftgG93d8nryUz6/VGCHvHPk3ezjfk7+UfiI7K
         zj35nB+96MTiJb2+sqtz+5xIOS0DBxPc3nj3VV2KRc6rmDYHkUQn8dFwj8vuJwq/5qF+
         zmiWpBHTbfOfLtY0k8QM+GXUn2prOIekdmIACNbSUUwTSD53oYIFyuaKfdyzQ8yFg2Q6
         q1NXTrz62/bNFyv7Gp2Lf3jzv/41eeFFdMgr23e/vf+LMjIUEs6dbgJVHgRldB+jr/21
         CQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R6bj5k93ILC33b5weERAxxA9VSG1mRSLslj8OKwpnZk=;
        b=TaNQAQcDPadN+77m8fFX2BfcMqS+KLFC96lsFtZpepWi8FtNAQdxXWt2iPgCQE3q81
         adf+yuHt2uQUg+pJ6QZU//f4wfZ8PNVLhI1u1FEsWQtsnhF5yaBtkFihm91Dk9VzSPoJ
         vNkINkTNfaFPX5KlyA/Lj+2vtd0pkkRulEBzcz3Tvxnw/7O7QkKiGE9piIysUSn54CBK
         Asmm8VEvN+QfKM+UpUcEvFB2ScfLGOw9BZWUCaRfvWt9IrEcYZcH42P5WNYvJulDA32f
         TgAmiNwfzb8nE2k7wQwPaGoY6UsJdI3HGgeGVharFkWUDbmTXVzikpoRUKQCakOahWAB
         AqCw==
X-Gm-Message-State: AOAM530JBziAl6I+zdVGBEVuFQ49cf96kwjnNpcQY81KmuggmhQ5ANZ6
        8D3mWJC0uVCaPUt+QSB9im242hhR2yim4Oe2Rx8=
X-Google-Smtp-Source: ABdhPJxrJZjWAKuJx2W/ebbuv1AKgFR8/KaJIBisKTIyiTRjd0fUicapDzcDYqmlGqShC6qo5fOIVIJ9dykAgJM1p+0=
X-Received: by 2002:a62:445:0:b029:196:61fc:2756 with SMTP id
 66-20020a6204450000b029019661fc2756mr2116352pfe.12.1606291254422; Wed, 25 Nov
 2020 00:00:54 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-9-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-9-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 09:00:43 +0100
Message-ID: <CAJ8uoz2URCA=Q40dmhiiu3_ri4P4R04x+stH6f2HrarChZBQyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/10] samples/bpf: use recvfrom() in xdpsock/l2fwd
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 9:33 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Start using recvfrom() the l2fwd scenario, instead of poll() which is
> more expensive and need additional knobs for busy-polling.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  samples/bpf/xdpsock_user.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index f90111b95b2e..24aa7511c4c8 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1098,8 +1098,7 @@ static void kick_tx(struct xsk_socket_info *xsk)
>         exit_with_error(errno);
>  }
>
> -static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
> -                                    struct pollfd *fds)
> +static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
>  {
>         struct xsk_umem_info *umem =3D xsk->umem;
>         u32 idx_cq =3D 0, idx_fq =3D 0;
> @@ -1134,7 +1133,7 @@ static inline void complete_tx_l2fwd(struct xsk_soc=
ket_info *xsk,
>                                 exit_with_error(-ret);
>                         if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
>                                 xsk->app_stats.fill_fail_polls++;
> -                               ret =3D poll(fds, num_socks, opt_timeout)=
;
> +                               recvfrom(xsk_socket__fd(xsk->xsk), NULL, =
0, MSG_DONTWAIT, NULL, NULL);
>                         }
>                         ret =3D xsk_ring_prod__reserve(&umem->fq, rcvd, &=
idx_fq);
>                 }
> @@ -1331,19 +1330,19 @@ static void tx_only_all(void)
>                 complete_tx_only_all();
>  }
>
> -static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
> +static void l2fwd(struct xsk_socket_info *xsk)
>  {
>         unsigned int rcvd, i;
>         u32 idx_rx =3D 0, idx_tx =3D 0;
>         int ret;
>
> -       complete_tx_l2fwd(xsk, fds);
> +       complete_tx_l2fwd(xsk);
>
>         rcvd =3D xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
>         if (!rcvd) {
>                 if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
>                         xsk->app_stats.rx_empty_polls++;
> -                       ret =3D poll(fds, num_socks, opt_timeout);
> +                       recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_D=
ONTWAIT, NULL, NULL);
>                 }
>                 return;
>         }
> @@ -1353,7 +1352,7 @@ static void l2fwd(struct xsk_socket_info *xsk, stru=
ct pollfd *fds)
>         while (ret !=3D rcvd) {
>                 if (ret < 0)
>                         exit_with_error(-ret);
> -               complete_tx_l2fwd(xsk, fds);
> +               complete_tx_l2fwd(xsk);
>                 if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
>                         xsk->app_stats.tx_wakeup_sendtos++;
>                         kick_tx(xsk);
> @@ -1388,22 +1387,20 @@ static void l2fwd_all(void)
>         struct pollfd fds[MAX_SOCKS] =3D {};
>         int i, ret;
>
> -       for (i =3D 0; i < num_socks; i++) {
> -               fds[i].fd =3D xsk_socket__fd(xsks[i]->xsk);
> -               fds[i].events =3D POLLOUT | POLLIN;
> -       }
> -
>         for (;;) {
>                 if (opt_poll) {
> -                       for (i =3D 0; i < num_socks; i++)
> +                       for (i =3D 0; i < num_socks; i++) {
> +                               fds[i].fd =3D xsk_socket__fd(xsks[i]->xsk=
);
> +                               fds[i].events =3D POLLOUT | POLLIN;
>                                 xsks[i]->app_stats.opt_polls++;
> +                       }
>                         ret =3D poll(fds, num_socks, opt_timeout);
>                         if (ret <=3D 0)
>                                 continue;
>                 }
>
>                 for (i =3D 0; i < num_socks; i++)
> -                       l2fwd(xsks[i], fds);
> +                       l2fwd(xsks[i]);
>
>                 if (benchmark_done)
>                         break;
> --
> 2.27.0
>
