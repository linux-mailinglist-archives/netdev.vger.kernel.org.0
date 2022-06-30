Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123645616F7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiF3J6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiF3J6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:58:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992AD2018A;
        Thu, 30 Jun 2022 02:58:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c4so16573651plc.8;
        Thu, 30 Jun 2022 02:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xfzenFqA9Vwg5uNtj1N+nI++1QDQcQqPhoU5IckAxg=;
        b=msdwMK2lw+/4SwF5GYAY/SoPNNUF+SgYRbNF+qVOwj3yIlHpizleeEHO3iV8m4AiJn
         94E++qt4RzwhcFXD1CyV0CimUQYKH9M+42TmuGtjw1p5+XCLI1Lzq++3Bf8zoFWoygYh
         dMRB0FXm972yHyl4ATX7MRBB6DxVrVK/cZkS2ahzDcAyOqL5jbfuPqjCAU09ciH1MYLn
         Qefvoi8+lQAZQDIE8/bN9xaVy+KiMb3aO/7B0RVezoHa+5OAsuzJI9fcRncOIl2lKqum
         53ZPdTV77qB071vCpyf+eI7rDJm9y7AkdqujlkiF8v5dMkeIccqsJz2gpCKjLwuHbD3Q
         DtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xfzenFqA9Vwg5uNtj1N+nI++1QDQcQqPhoU5IckAxg=;
        b=mdIVQZsJwOLf5E73agF245Qhm24/kWkv9fG4CekzgzjCVB/g0Rg7f7lAzfp6suIQNL
         qvS/6Or944ZNbTeo3PZbZ8D4IgrAbrocwbsizUH52iMIuMmJqMELIV3EMNKtqEfRqBtU
         okysSWvG+7ll0szUlSrEnXz3E+r6CrSBJRGAMDAn21XziC/LB4F+aEh3wDmtn9ubQmPx
         +pVb8UM/+Z1T3ElN2N4aCHuHV9vzVa8q7aWtioEEcwddv/pQEV9vLGOUWw6ycApZuX8c
         aRLzFzZt1IPHbEakHnJs4ICifS+aBgsQppl1PaPXcONVwLrnYPKh8qtxHhG/Wi2wJOtv
         cvOg==
X-Gm-Message-State: AJIora+seozoxNX4fPmLQSz8K+FfP10+sHHf1stCKngEb1qdZvnr97DG
        25DxMYs/u7j9COYQ0vuO/fOy/D4MLLGQDHRcKJo=
X-Google-Smtp-Source: AGRyM1sVy4VuS6f4fxi7OIVdShM1YH0oB07qwucf+3S0NXGNy+kMTMGPn/CwfQuQ6s905p5478C8MPbknaMStV/n2us=
X-Received: by 2002:a17:90b:1651:b0:1ec:f091:3559 with SMTP id
 il17-20020a17090b165100b001ecf0913559mr9433363pjb.206.1656583115109; Thu, 30
 Jun 2022 02:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com> <20220629143458.934337-5-maciej.fijalkowski@intel.com>
In-Reply-To: <20220629143458.934337-5-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Jun 2022 11:58:24 +0200
Message-ID: <CAJ8uoz2Jc1=O4-BJ52QgijgD5fR3As+CXLRpeync=25hc-NDoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests: xsk: destroy BPF resources only
 when ctx refcount drops to 0
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

On Wed, Jun 29, 2022 at 4:39 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Currently, xsk_socket__delete frees BPF resources regardless of ctx
> refcount. Xdpxceiver has a test to verify whether underlying BPF
> resources would not be wiped out after closing XSK socket that was bound
> to interface with other active sockets. From library's xsk part
> perspective it also means that the internal xsk context is shared and
> its refcount is bumped accordingly.
>
> After a switch to loading XDP prog based on previously opened XSK
> socket, mentioned xdpxceiver test fails with:
> not ok 16 [xdpxceiver.c:swap_xsk_resources:1334]: ERROR: 9/"Bad file descriptor
>
> which means that in swap_xsk_resources(), xsk_socket__delete() released
> xskmap which in turn caused a failure of xsk_socket__update_xskmap().
>
> To fix this, when deleting socket, decrement ctx refcount before
> releasing BPF resources and do so only when refcount dropped to 0 which
> means there are no more active sockets for this ctx so BPF resources can
> be freed safely.

Please fix this in libxdp too as the bug is present there also.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xsk.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index db911127720e..95ce5cd572bb 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -1156,8 +1156,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                 goto out_mmap_tx;
>         }
>
> -       ctx->prog_fd = -1;
> -
>         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
>                 err = __xsk_setup_xdp_prog(xsk, NULL);
>                 if (err)
> @@ -1238,7 +1236,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>
>         ctx = xsk->ctx;
>         umem = ctx->umem;
> -       if (ctx->prog_fd != -1) {
> +
> +       xsk_put_ctx(ctx, true);
> +
> +       if (!ctx->refcount) {
>                 xsk_delete_bpf_maps(xsk);
>                 close(ctx->prog_fd);
>                 if (ctx->has_bpf_link)
> @@ -1257,7 +1258,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>                 }
>         }
>
> -       xsk_put_ctx(ctx, true);
>
>         umem->refcount--;
>         /* Do not close an fd that also has an associated umem connected
> --
> 2.27.0
>
