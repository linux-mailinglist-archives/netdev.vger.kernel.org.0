Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74842574491
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiGNFhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGNFhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 01:37:00 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41EB22B05;
        Wed, 13 Jul 2022 22:36:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t3so1063561edd.0;
        Wed, 13 Jul 2022 22:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CWS2/pkKxWXJS8wyltb9pzyjJfiWopl4FGSuwFA8WpI=;
        b=PI0SwpRgEBu2khJUo/eGU6pJVb91ib41gjE141aSfOyQklggdqFlslwdUbkjHtSu/m
         Deacg1xvD9i1SsOftZvCyLLXc3mq8BR5SnZQJubdLSXOgO5jUnsNF00UushEwaWFCiny
         iPIW/6hpl/g5ccmwtPn8xAvUhgzQGk4qkU5Wy5vb+7WZApxhblDJy89UJ0slwzewy1mp
         j0cB8Ir8DfPVDLtYFny8yL9yInYglBNqlveeMeT4gR3A49Jr+QSXQh82ObBdfj1zXf/z
         UtZ3lfV4RsLfI8Lpha3/exUMXYRvU5MDHGJfrvb+BKBOQ83pX5qVsMBwRIASpzJ7yI4W
         vufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CWS2/pkKxWXJS8wyltb9pzyjJfiWopl4FGSuwFA8WpI=;
        b=LqVh41JqnvnPCg2rPNQB+mhn+AKEgjnMjsTUiU2AtTnG1pdMcuFWf/WUz99YnRAZ4Z
         yiEVOy133CVbBMkgOOcEfDcZ4HEe19bwIoUCYiTMCvgq+NDYEBjMVvH5MVFoeooMagl4
         TRhsRlpovHVy9FpSFJnz9IzAxt0urQmHc6rIbxtZCGPftEgQcSQJUI4g6tsSmhsaT7Df
         aoD3GWidbXR9WE+lnSLEWbOecavAKhctXOYolbkOiAB2M0hkkWBST0slukp4+GfTq6eb
         u0GXe3r+K4U1qaxA9vSe5Kt0cQLKrWz56z6LRNwRfMbhF0qJPh1qBXbz/5zZhKixesXh
         eYqg==
X-Gm-Message-State: AJIora/Ll5D3Rtv2tUmuh4AgGRmTJVBBUHME+Zta+abwV/ofT638sjZK
        RmSCGN3Fes2PcH60/yLWjCQoWSP93LCK4W8xkK0=
X-Google-Smtp-Source: AGRyM1uWCccFXBvQ5knaC29I4jIC5XhZ4n4moTXqZ/A/u7kQM8aDMfG2BMf/kJgugp19EloN5bQkq2s/XoStJ6AsQHk=
X-Received: by 2002:a05:6402:50d2:b0:43a:8487:8a09 with SMTP id
 h18-20020a05640250d200b0043a84878a09mr9979195edb.232.1657777017256; Wed, 13
 Jul 2022 22:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <20220713111430.134810-15-toke@redhat.com>
In-Reply-To: <20220713111430.134810-15-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 22:36:46 -0700
Message-ID: <CAEf4BzZN2kBafJPQKaM4Pakf=PSYGiVzq53ED0NCRZ+DkaZHKA@mail.gmail.com>
Subject: Re: [RFC PATCH 14/17] libbpf: Add support for querying dequeue programs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Add support to libbpf for reading the dequeue program ID from netlink whe=
n
> querying for installed XDP programs. No additional support is needed to
> install dequeue programs, as they are just using a new mode flag for the
> regular XDP program installation mechanism.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.h  | 1 +
>  tools/lib/bpf/netlink.c | 8 ++++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index e4d5353f757b..b15ff90279cb 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -906,6 +906,7 @@ struct bpf_xdp_query_opts {
>         __u32 drv_prog_id;      /* output */
>         __u32 hw_prog_id;       /* output */
>         __u32 skb_prog_id;      /* output */
> +       __u32 dequeue_prog_id;  /* output */

can't do that, you have to put it after attach_mode to preserve
backwards/forward compat

>         __u8 attach_mode;       /* output */
>         size_t :0;
>  };
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index 6c013168032d..64a9aceb9c9c 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -32,6 +32,7 @@ struct xdp_link_info {
>         __u32 drv_prog_id;
>         __u32 hw_prog_id;
>         __u32 skb_prog_id;
> +       __u32 dequeue_prog_id;
>         __u8 attach_mode;
>  };
>
> @@ -354,6 +355,10 @@ static int get_xdp_info(void *cookie, void *msg, str=
uct nlattr **tb)
>                 xdp_id->info.hw_prog_id =3D libbpf_nla_getattr_u32(
>                         xdp_tb[IFLA_XDP_HW_PROG_ID]);
>
> +       if (xdp_tb[IFLA_XDP_DEQUEUE_PROG_ID])
> +               xdp_id->info.dequeue_prog_id =3D libbpf_nla_getattr_u32(
> +                       xdp_tb[IFLA_XDP_DEQUEUE_PROG_ID]);
> +
>         return 0;
>  }
>
> @@ -391,6 +396,7 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct =
bpf_xdp_query_opts *opts)
>         OPTS_SET(opts, drv_prog_id, xdp_id.info.drv_prog_id);
>         OPTS_SET(opts, hw_prog_id, xdp_id.info.hw_prog_id);
>         OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
> +       OPTS_SET(opts, dequeue_prog_id, xdp_id.info.dequeue_prog_id);
>         OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
>
>         return 0;
> @@ -415,6 +421,8 @@ int bpf_xdp_query_id(int ifindex, int flags, __u32 *p=
rog_id)
>                 *prog_id =3D opts.hw_prog_id;
>         else if (flags & XDP_FLAGS_SKB_MODE)
>                 *prog_id =3D opts.skb_prog_id;
> +       else if (flags & XDP_FLAGS_DEQUEUE_MODE)
> +               *prog_id =3D opts.dequeue_prog_id;
>         else
>                 *prog_id =3D 0;
>
> --
> 2.37.0
>
