Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E448351088
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfFXPbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:31:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46684 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFXPbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:31:31 -0400
Received: by mail-qk1-f193.google.com with SMTP id x18so10020782qkn.13;
        Mon, 24 Jun 2019 08:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rw7Ix2QAqLxTiUw5AmV1AKBnYuLcc6WLLs23EmfkFCk=;
        b=WD8QA4tGbiHfidk/A4VQDka4j6W/lOjOh+MlD1a+QSUpY6l3wk6XAnmOij3UFXbR4/
         FR5NFLouGvkeC1aNGg21mKhYWJitJuI9TcvHfoseeqadTk2YAiwdvoMab7NNtNbSX98v
         OvmUQ2O9m63lcHXCyJjUyxiVVp4hUWG+uQa2vQt8a1gS2yy58T170jCPrAnocOzgxVWI
         axtDjwPwGbHYQ8PPdw/jffxGytlmV9alC8ARNeTbkKrkG98GoDWZEk+qURvWfit7zp8+
         Vp9HQ4OM8zw7bFU9Y6geUIUcNP/nK7JCmewKnO9DAzwqG9ampk9kORFJX88D/tiTXmMQ
         MQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rw7Ix2QAqLxTiUw5AmV1AKBnYuLcc6WLLs23EmfkFCk=;
        b=YvDPUsNgFgOjOltEM2pK7MUmf41s9HEzavDQYKodMUnDYdtLnQWeD6IvO1G5KSnPlZ
         fVbvSsRe81zwj1rnkDUadgRaHK1ONkhPSZOTBEl/5ABQi31tW7b0NbPUlKm3xetQiZDe
         wjLOpVqvYZPDFkAJZiyST0wF+ugcmQMxqC1i7N63FJYHSLUP7XDlAim0LhHMTdWfaUHV
         1G4fiRXRrRxcP5EGYXNN5S9MU7BSzVJg7QxWHvNRGtZlfqlN95Yga8Yd1Ju4EZq2Sj3d
         XI66IwoAnM36Xj1jWGUjSfPlkHFGgJX91b76VgLcQ0yNQr4ysYC52GRNw4l5c6VNgG60
         JLUw==
X-Gm-Message-State: APjAAAVdEvuFq72WgUk8IOWkk3xxOPk2w+rEtnojcAeOFKv2V1+8UOaD
        jAVdzvZBzg9ql9rvu64jug1w9tQ8wHO0rJwcBSg=
X-Google-Smtp-Source: APXvYqx4V4RU9M+lFiMybe2PmHblR9vuN7NRlzY0nhX947XJwvuX07AHd6CaqhhB02e2GXNZE59rumVxnW+sjlR+MBw=
X-Received: by 2002:a37:9e4b:: with SMTP id h72mr120267915qke.297.1561390290029;
 Mon, 24 Jun 2019 08:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-9-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-9-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 17:31:19 +0200
Message-ID: <CAJ+HfNi=QtGEGq=4PaxEMUrBxsSg8JsJcQHik_8WGVdAawJHKA@mail.gmail.com>
Subject: Re: [PATCH 08/11] samples/bpf: add unaligned chunks mode support to xdpsock
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch adds support for the unaligned chunks mode. The addition of th=
e
> unaligned chunks option will allow users to run the application with more
> relaxed chunk placement in the XDP umem.
>
> Unaligned chunks mode can be used with the '-u' or '--unaligned' command
> line options.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  samples/bpf/xdpsock_user.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index d08ee1ab7bb4..e26f43382d01 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -67,6 +67,8 @@ static int opt_ifindex;
>  static int opt_queue;
>  static int opt_poll;
>  static int opt_interval =3D 1;
> +static u32 opt_umem_flags;
> +static int opt_unaligned_chunks;
>  static u32 opt_xdp_bind_flags;
>  static __u32 prog_id;
>
> @@ -276,14 +278,21 @@ static size_t gen_eth_frame(struct xsk_umem_info *u=
mem, u64 addr)
>  static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
>  {
>         struct xsk_umem_info *umem;
> +       struct xsk_umem_config umem_cfg;
>         int ret;
>
>         umem =3D calloc(1, sizeof(*umem));
>         if (!umem)
>                 exit_with_error(errno);
>
> +       umem_cfg.fill_size =3D XSK_RING_PROD__DEFAULT_NUM_DESCS;
> +       umem_cfg.comp_size =3D XSK_RING_CONS__DEFAULT_NUM_DESCS;
> +       umem_cfg.frame_size =3D XSK_UMEM__DEFAULT_FRAME_SIZE;
> +       umem_cfg.frame_headroom =3D XSK_UMEM__DEFAULT_FRAME_HEADROOM;
> +       umem_cfg.flags =3D opt_umem_flags;
> +
>         ret =3D xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &u=
mem->cq,
> -                              NULL);
> +                              &umem_cfg);
>         if (ret)
>                 exit_with_error(-ret);
>
> @@ -346,6 +355,7 @@ static struct option long_options[] =3D {
>         {"interval", required_argument, 0, 'n'},
>         {"zero-copy", no_argument, 0, 'z'},
>         {"copy", no_argument, 0, 'c'},
> +       {"unaligned", no_argument, 0, 'u'},
>         {0, 0, 0, 0}
>  };
>
> @@ -365,6 +375,7 @@ static void usage(const char *prog)
>                 "  -n, --interval=3Dn     Specify statistics update inter=
val (default 1 sec).\n"
>                 "  -z, --zero-copy      Force zero-copy mode.\n"
>                 "  -c, --copy           Force copy mode.\n"
> +               "  -u, --unaligned      Enable unaligned chunk placement\=
n"
>                 "\n";
>         fprintf(stderr, str, prog);
>         exit(EXIT_FAILURE);
> @@ -377,7 +388,7 @@ static void parse_command_line(int argc, char **argv)
>         opterr =3D 0;
>
>         for (;;) {
> -               c =3D getopt_long(argc, argv, "Frtli:q:psSNn:cz", long_op=
tions,
> +               c =3D getopt_long(argc, argv, "Frtli:q:psSNn:czu", long_o=
ptions,
>                                 &option_index);
>                 if (c =3D=3D -1)
>                         break;
> @@ -417,9 +428,14 @@ static void parse_command_line(int argc, char **argv=
)
>                 case 'c':
>                         opt_xdp_bind_flags |=3D XDP_COPY;
>                         break;
> +               case 'u':
> +                       opt_umem_flags |=3D XDP_UMEM_UNALIGNED_CHUNKS;
> +                       opt_unaligned_chunks =3D 1;
> +                       break;
>                 case 'F':
>                         opt_xdp_flags &=3D ~XDP_FLAGS_UPDATE_IF_NOEXIST;
>                         break;
> +
>                 default:
>                         usage(basename(argv[0]));
>                 }
> --
> 2.17.1
>
