Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49702C3AC7
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 09:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKYITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 03:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKYITi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 03:19:38 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E8C0613D4;
        Wed, 25 Nov 2020 00:19:37 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t21so1771421pgl.3;
        Wed, 25 Nov 2020 00:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jTLK4cLAxA/XS0Nq4yv/x34FWL5/aBTIiA8zXaWICdI=;
        b=Tu9w8gevlxmrBHCQz8twX6pUmil2avzxU3XcBVgGzNRzVwvv92xyJDN9OgGQ7KfFBc
         w7VRoMiBE9wfCi/kUddY+vToyKo7AQQJVRovvF7DtgZmMkK6EgWRl+FNWQxRyHakoXsY
         F1Dfh9vmMyuPHyHDchEs2zDZNICKK45koLm84CAJOhBy96Ro+EYot9ZCWovySlztQKil
         4cr80pr2WkGh/QJ4jgSBNhAHwHtx3NQnlSn0GOsSlUsZcsfF86XXlEB8STXqI/uk5yWm
         QghErVpjNYHrww8PbOyOgHauMBEyI/D14Rs3HHHcKy6pfFc8F/rMgPCjFLPFcsL4Q/eY
         Ov+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jTLK4cLAxA/XS0Nq4yv/x34FWL5/aBTIiA8zXaWICdI=;
        b=dh96Z/QPjeWS2wIwwOhMMFVkYJ29x1FC93Ti6+lLBaaVOugqW6VcZsncaV7993CIiX
         0UKJarBrUUDWz3g7NdhD5Fu0Zplhru31WK/HbjyP1y5vPU6d9+I++9ehjun1MV4KnIZy
         OPFJ2A9mGaSqboygCi8NxD4mgFUvhn4bZ7cF6WWG60B4YN0peCYoVFs6Knk8PWfMZF5G
         FiTeyA6Nq1azGRVWYSV1ZCBejQlnPnlCihQVxRWUw2xSqskg3xLyHe8Y72dCFv5t5WoA
         aB4yyhV6+BidBrqY/Mun3PCu2GiBgXPr9ZHKESWHPoR1BUqERtCDS3h7W6ZMwpw8Z5Gj
         TLjw==
X-Gm-Message-State: AOAM531Y5q5hIHgqaDdi10VBhF1nGMhh/S1MXSoPEFYZA4CQCxXd2f0F
        AgaeF63kl22HMEKfdGUiW24fL1fjk107NdVr5lY=
X-Google-Smtp-Source: ABdhPJyDdnykLYkIIAF9P8oP1ozLL3G3XwMz4GrEsY4TsrMYRfG3HwAUgtJMJcYwyhWapGZvAzD/9PQgNMYjS32Yeo0=
X-Received: by 2002:a65:6a50:: with SMTP id o16mr2163723pgu.292.1606292377416;
 Wed, 25 Nov 2020 00:19:37 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-10-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-10-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 09:19:26 +0100
Message-ID: <CAJ8uoz3BmTUX8vENTjX5QseTJ4ftP8KgHypiieQHsQ1Lzso8Xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 09/10] samples/bpf: add busy-poll support to xdpsock
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
> Add a new option to xdpsock, 'B', for busy-polling. This option will
> also set the batching size, 'b' option, to the busy-poll budget.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  samples/bpf/xdpsock_user.c | 40 +++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 24aa7511c4c8..cb1eaee8a32b 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -95,6 +95,7 @@ static int opt_timeout =3D 1000;
>  static bool opt_need_wakeup =3D true;
>  static u32 opt_num_xsks =3D 1;
>  static u32 prog_id;
> +static bool opt_busy_poll;
>
>  struct xsk_ring_stats {
>         unsigned long rx_npkts;
> @@ -911,6 +912,7 @@ static struct option long_options[] =3D {
>         {"quiet", no_argument, 0, 'Q'},
>         {"app-stats", no_argument, 0, 'a'},
>         {"irq-string", no_argument, 0, 'I'},
> +       {"busy-poll", no_argument, 0, 'B'},
>         {0, 0, 0, 0}
>  };
>
> @@ -949,6 +951,7 @@ static void usage(const char *prog)
>                 "  -Q, --quiet          Do not display any stats.\n"
>                 "  -a, --app-stats      Display application (syscall) sta=
tistics.\n"
>                 "  -I, --irq-string     Display driver interrupt statisti=
cs for interface associated with irq-string.\n"
> +               "  -B, --busy-poll      Busy poll.\n"
>                 "\n";
>         fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
>                 opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
> @@ -964,7 +967,7 @@ static void parse_command_line(int argc, char **argv)
>         opterr =3D 0;
>
>         for (;;) {
> -               c =3D getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:=
s:P:xQaI:",
> +               c =3D getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:=
s:P:xQaI:B",
>                                 long_options, &option_index);
>                 if (c =3D=3D -1)
>                         break;
> @@ -1062,7 +1065,9 @@ static void parse_command_line(int argc, char **arg=
v)
>                                 fprintf(stderr, "ERROR: Failed to get irq=
s for %s\n", opt_irq_str);
>                                 usage(basename(argv[0]));
>                         }
> -
> +                       break;
> +               case 'B':
> +                       opt_busy_poll =3D 1;
>                         break;
>                 default:
>                         usage(basename(argv[0]));
> @@ -1131,7 +1136,7 @@ static inline void complete_tx_l2fwd(struct xsk_soc=
ket_info *xsk)
>                 while (ret !=3D rcvd) {
>                         if (ret < 0)
>                                 exit_with_error(-ret);
> -                       if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
> +                       if (opt_busy_poll || xsk_ring_prod__needs_wakeup(=
&umem->fq)) {
>                                 xsk->app_stats.fill_fail_polls++;
>                                 recvfrom(xsk_socket__fd(xsk->xsk), NULL, =
0, MSG_DONTWAIT, NULL, NULL);
>                         }
> @@ -1177,7 +1182,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
>
>         rcvd =3D xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
>         if (!rcvd) {
> -               if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
> +               if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->um=
em->fq)) {
>                         xsk->app_stats.rx_empty_polls++;
>                         recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_D=
ONTWAIT, NULL, NULL);
>                 }
> @@ -1188,7 +1193,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
>         while (ret !=3D rcvd) {
>                 if (ret < 0)
>                         exit_with_error(-ret);
> -               if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
> +               if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->um=
em->fq)) {
>                         xsk->app_stats.fill_fail_polls++;
>                         recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_D=
ONTWAIT, NULL, NULL);
>                 }
> @@ -1340,7 +1345,7 @@ static void l2fwd(struct xsk_socket_info *xsk)
>
>         rcvd =3D xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
>         if (!rcvd) {
> -               if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
> +               if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->um=
em->fq)) {
>                         xsk->app_stats.rx_empty_polls++;
>                         recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_D=
ONTWAIT, NULL, NULL);
>                 }
> @@ -1353,7 +1358,7 @@ static void l2fwd(struct xsk_socket_info *xsk)
>                 if (ret < 0)
>                         exit_with_error(-ret);
>                 complete_tx_l2fwd(xsk);
> -               if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
> +               if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->tx=
)) {
>                         xsk->app_stats.tx_wakeup_sendtos++;
>                         kick_tx(xsk);
>                 }
> @@ -1458,6 +1463,24 @@ static void enter_xsks_into_map(struct bpf_object =
*obj)
>         }
>  }
>
> +static void apply_setsockopt(struct xsk_socket_info *xsk)
> +{
> +       int sock_opt;
> +
> +       if (!opt_busy_poll)
> +               return;
> +
> +       sock_opt =3D 1;
> +       if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_PREFER_BU=
SY_POLL,
> +                      (void *)&sock_opt, sizeof(sock_opt)) < 0)
> +               exit_with_error(errno);
> +
> +       sock_opt =3D 20;
> +       if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL=
,
> +                      (void *)&sock_opt, sizeof(sock_opt)) < 0)
> +               exit_with_error(errno);
> +}
> +
>  int main(int argc, char **argv)
>  {
>         struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
> @@ -1499,6 +1522,9 @@ int main(int argc, char **argv)
>         for (i =3D 0; i < opt_num_xsks; i++)
>                 xsks[num_socks++] =3D xsk_configure_socket(umem, rx, tx);
>
> +       for (i =3D 0; i < opt_num_xsks; i++)
> +               apply_setsockopt(xsks[i]);
> +
>         if (opt_bench =3D=3D BENCH_TXONLY) {
>                 gen_eth_hdr_data();
>
> --
> 2.27.0
>
