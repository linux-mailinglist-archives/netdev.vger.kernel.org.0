Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE55C5616EB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiF3J5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiF3J5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:57:12 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AEA433B4;
        Thu, 30 Jun 2022 02:57:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d17so17623230pfq.9;
        Thu, 30 Jun 2022 02:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXGKNFqjx6ViPLlP3sZ0g08p4b3WubIM5Irbg5Iw56I=;
        b=qG9mWdqvS/buWwzCnzBoghPRQQgpejww/s5OxCz2h0bzXH355r+sd5FDGA7UnZsQBR
         DbB5J3GtqSWbgrd5NQZTydjkWPcMa2d04U0PehgbjbW452KgGIB/rvF0r0apBjtk21LW
         BpondeTJ+rlIeSm+eHmXSd+D6xUqt9AYw0J6J6u0rfxBVIZMU1EdhjXbXAvAWnfJ5AjF
         Y2alG+4f607I7N5MOaOaOgSAl5z5Ptw5Vz69qIxkjr6L5EPTW9X2g5KNlFz2iPg5CfPZ
         cjvNWcPbXXXvq/hQrXY+suju6GsUklRlUspmHDRz8nDG8XPY+3Savf2m6Xo7g5pMGEkd
         pQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXGKNFqjx6ViPLlP3sZ0g08p4b3WubIM5Irbg5Iw56I=;
        b=VSIMEz3Wb41kf2/xhtKkjwPO3fapbuPU6bnLltJ3DSblXnN3HpfOQwLzET+ulp84Rk
         QZgHJGX6toLqq1IZ07ThwRxlS8FWITqA61E4WrHFDgSZrYW6R1Z9lUFGYZvu2rtyaPPj
         u6EGl4TkwhV1wK1vOfIulvLOzUXeM5y9iIj5iDwEoqHbDK+pyDrR3jboLF78P10wAXoa
         3PH+I/y3FX0gt50vlPzhFPlNWrryRGlhP99+I3d1GtNQVH6ZZdd4FTVoDJ4Gd179k7VJ
         H4xgywkgEZSxe4XZ9sLV7Cg5Pov1HGvR9QoNdj3PjLOY12AqKu024+Sv++211WTunw5h
         QAIA==
X-Gm-Message-State: AJIora/JUv4LS+laRHO89uj4AKu9BdMjGniQmJsNkg4eU0Eyffy60TTC
        +TLUJ1+9uL+Zu7Y2mM3Rbe+BlkHhHEjLUf6uELo=
X-Google-Smtp-Source: AGRyM1sSirwzflWLjDy6eHuZMMPAcbt5LBKttmLO83+UT74Zd+9pYu2Bpeba6Uw/gEdkFV+0o4iUSbTEZV0zVe/GOXM=
X-Received: by 2002:a05:6a00:225a:b0:525:4d37:6b30 with SMTP id
 i26-20020a056a00225a00b005254d376b30mr14940437pfu.83.1656583030977; Thu, 30
 Jun 2022 02:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com> <20220629143458.934337-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20220629143458.934337-2-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Jun 2022 11:57:00 +0200
Message-ID: <CAJ8uoz1Eo2Lsh0Gu4HED4cr7Ocqsd7=OjAf7wOrnvQ_tMa4Jgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] selftests: xsk: avoid bpf_link probe for
 existing xsk
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 4:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Currently bpf_link probe is done for each call of xsk_socket__create().
> For cases where xsk context was previously created and current socket
> creation uses it, has_bpf_link will be overwritten, where it has already
> been initialized.
>
> Optimize this by moving the query to the xsk_create_ctx() so that when
> xsk_get_ctx() finds a ctx then no further bpf_link probes are needed.

This would be a good optimization to libxdp too.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index eb50c3f336f8..fa13d2c44517 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -958,6 +958,7 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>         ctx->fill = fill;
>         ctx->comp = comp;
>         list_add(&ctx->list, &umem->ctx_list);
> +       ctx->has_bpf_link = xsk_probe_bpf_link();
>         return ctx;
>  }
>
> @@ -1059,7 +1060,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                 }
>         }
>         xsk->ctx = ctx;
> -       xsk->ctx->has_bpf_link = xsk_probe_bpf_link();
>
>         if (rx && !rx_setup_done) {
>                 err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> --
> 2.27.0
>
