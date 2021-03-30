Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDDE34EB91
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3PIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbhC3PIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:08:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6CBC061574;
        Tue, 30 Mar 2021 08:08:13 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m12so24283286lfq.10;
        Tue, 30 Mar 2021 08:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kizS2arIJixY618Db2OznQ3jK6lFDcDTI8/S3Ak8qoo=;
        b=PLv7bzr0G973AHLoGvHXBDLeN7ud8eOF3bXnY+1bX1sy5hfkrBGD06wKOGd+gAtdlI
         +qtlRKKZuCsWZP0Pp2bQj4D/s1kWVc7+91qIoBNK63nAw5QYY+ah5TOVq9MT/uy0yK54
         /v4HVkrBf2XlCUIXtWKT6NmVa8wiHANYNaeWbvXUw+b/KX4aWL0bGQjJi7ipqiSJ1LgB
         WhrSpg246KHJoUgkG5m6GrSyx++3luUuk5Av7iv17uvsxkdGvbbgDEOMxdMYx4SrTgwK
         xmdlpZZ6QvydguxSV2kd083YLiMj97sjpS3WggA44D/eIZapUqez42pE6J+0jPOUBP1K
         jL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kizS2arIJixY618Db2OznQ3jK6lFDcDTI8/S3Ak8qoo=;
        b=lNJUAZ7/JNBMCxtuSQFT1CEscbZYqKN86J2lG6H3KW+2Vg1P6UgxE1id+/JN8/zcDD
         laGdOSuBSjf8kqJB22qpNbPlELMMbWsygWUoTQWn2065avfEj1r9uCSBlnpwlAWtow3c
         6PFeL34VgukmtPkikISo1ydonQ6uC/LLJpAcuCP1zsk14Ve8A0Ji2ZlGIuCgUVq5l9z2
         4+iq2hgceIbTMvmmzIazs4H4acb8ZsWYx6ugIglZeQ75JG7ZaozSnZ1C8WfbAXlEMTva
         v2pWwa7bwhrPTX15UPki7DwLDqxYpQLcQMl/df9CMiUgaMnzKJYYqoWDa590e+AiclJN
         EG0Q==
X-Gm-Message-State: AOAM532kkf8uRB/g6PprziyZeXRQ+z6QcDgk+m3aQN3T5CoIpSHVVA6I
        b4JU1BsoCfRboVhg2BOqx30X8xQ37QtiqnZJDGg=
X-Google-Smtp-Source: ABdhPJzCBNmPRHrSV1/tGsfzdA98s5V0/b97UrVajZBZuXtsyOZM493IcravlBiChxJaVQKjmH+wAqgkFQV70FxISZM=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr20815237lfq.214.1617116891953;
 Tue, 30 Mar 2021 08:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210330113419.4616-1-ciara.loftus@intel.com> <20210330113419.4616-3-ciara.loftus@intel.com>
In-Reply-To: <20210330113419.4616-3-ciara.loftus@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 08:08:00 -0700
Message-ID: <CAADnVQ+jr2WG4FF3GoPt==tOkOb72bd7Zhkk5iy4omCJ3=qLJQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf 2/3] libbpf: restore umem state after socket create failure
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>, bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 5:06 AM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> If the call to xsk_socket__create fails, the user may want to retry the
> socket creation using the same umem. Ensure that the umem is in the
> same state on exit if the call fails by:
> 1. ensuring the umem _save pointers are unmodified.
> 2. not unmapping the set of umem rings that were set up with the umem
> during xsk_umem__create, since those maps existed before the call to
> xsk_socket__create and should remain in tact even in the event of
> failure.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 443b0cfb45e8..d4991ddff05a 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -743,21 +743,23 @@ static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
>         return NULL;
>  }
>
> -static void xsk_put_ctx(struct xsk_ctx *ctx)
> +static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
>  {
>         struct xsk_umem *umem = ctx->umem;
>         struct xdp_mmap_offsets off;
>         int err;
>
>         if (--ctx->refcount == 0) {
> -               err = xsk_get_mmap_offsets(umem->fd, &off);
> -               if (!err) {
> -                       munmap(ctx->fill->ring - off.fr.desc,
> -                              off.fr.desc + umem->config.fill_size *
> -                              sizeof(__u64));
> -                       munmap(ctx->comp->ring - off.cr.desc,
> -                              off.cr.desc + umem->config.comp_size *
> -                              sizeof(__u64));
> +               if (unmap) {
> +                       err = xsk_get_mmap_offsets(umem->fd, &off);
> +                       if (!err) {
> +                               munmap(ctx->fill->ring - off.fr.desc,
> +                                      off.fr.desc + umem->config.fill_size *
> +                               sizeof(__u64));
> +                               munmap(ctx->comp->ring - off.cr.desc,
> +                                      off.cr.desc + umem->config.comp_size *
> +                               sizeof(__u64));
> +                       }

The whole function increases indent, since it changes anyway
could you write it as:
{
if (--ctx->refcount)
  return;
if (!unmap)
  goto out_free;
err = xsk_get
if (err)
 goto out_free;
munmap();
out_free:
list_del
free
}

other than this it looks fine to me.
Bjorn, Magnus,
please review.

>                 }
>
>                 list_del(&ctx->list);
> @@ -797,8 +799,6 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>         memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
>         ctx->ifname[IFNAMSIZ - 1] = '\0';
>
> -       umem->fill_save = NULL;
> -       umem->comp_save = NULL;
>         ctx->fill = fill;
>         ctx->comp = comp;
>         list_add(&ctx->list, &umem->ctx_list);
> @@ -854,6 +854,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         struct xsk_socket *xsk;
>         struct xsk_ctx *ctx;
>         int err, ifindex;
> +       bool unmap = umem->fill_save != fill;
>
>         if (!umem || !xsk_ptr || !(rx || tx))
>                 return -EFAULT;
> @@ -994,6 +995,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         }
>
>         *xsk_ptr = xsk;
> +       umem->fill_save = NULL;
> +       umem->comp_save = NULL;
>         return 0;
>
>  out_mmap_tx:
> @@ -1005,7 +1008,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                 munmap(rx_map, off.rx.desc +
>                        xsk->config.rx_size * sizeof(struct xdp_desc));
>  out_put_ctx:
> -       xsk_put_ctx(ctx);
> +       xsk_put_ctx(ctx, unmap);
>  out_socket:
>         if (--umem->refcount)
>                 close(xsk->fd);
> @@ -1071,7 +1074,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>                 }
>         }
>
> -       xsk_put_ctx(ctx);
> +       xsk_put_ctx(ctx, true);
>
>         umem->refcount--;
>         /* Do not close an fd that also has an associated umem connected
> --
> 2.17.1
>
