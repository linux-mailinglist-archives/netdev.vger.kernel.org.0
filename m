Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1EE34A3A5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhCZJGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCZJGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 05:06:41 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE73C0613AA;
        Fri, 26 Mar 2021 02:06:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e33so4150762pgm.13;
        Fri, 26 Mar 2021 02:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CG4MBxk/8UQdAMJ1ResB6Dc1p7f11By6rlIZT5iTQq4=;
        b=UFfyz9GDhcOdF7oIxtieNdW1b6TnZwQO9fXABayJUUBIWEZq+XOXD3mEnkO3A+djXa
         pXpu7p3YOEV4BexUbU2kMdVZFDyKtCsTF6czyXlEKUQtCJuk48t+hBAGqNsnN2gcq2iY
         mtsoJ0UkjBN6YN9f5duYnWei7R+vne3WfBJop8219m0PAnriyvhXjJedGPD3+9EoYWBq
         VuyNFPM8zwoW2QkytgQNqX31RDFwccl1xJ3iiBbd1+B8omUsU6BVcJXNJXZ+LGid9rjr
         sUhGEspNexMp4PEztDsHXBC9C7PfykgUpWcmjCPA4GfQonxEYK3wugxZPR7rEkQMMkN6
         41CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CG4MBxk/8UQdAMJ1ResB6Dc1p7f11By6rlIZT5iTQq4=;
        b=F61gx1uzvXSaQ0uqZFZw6dLs49sa1SegBb2c5R+9Ojgli2n/0pfwKTTWhp0BzKprcY
         RuMLf5IRDCQ7V9Z+Iq4I6L6pjFKKMXWeciJdGXgMnZC6I22zd4yN5VMz4XOxt16w6t5d
         lb6Zsno5ZHoZVm+CjjtJuowXkX7MSgOimEu08hqlcjERsr1KHlZGJAKM7dAmZHFK7iL6
         KJZQO4KQKH5zJ0GRzyZ/cLbTiiyfhSCbCrnXkLWrX2y2yF1oJ+HiTpqRN9nixBsNCqYy
         JB/u8I38k90tw0ovaLIqTvfAe/rQYPbMBA+qudrIDgSh8It/mfWa7GcteeYuPBpLG02y
         O7vg==
X-Gm-Message-State: AOAM531DKrBHpjoR03f0Lajr+55FFaMhxH7a4M5OnwE4Nmw5D0xRv6Sr
        5+Pvoj5L3bBUEtWjW9nPXZqYDOsOVuKicRdLBOg=
X-Google-Smtp-Source: ABdhPJyBYVXroVhv0jnZdkT+55Q0v4lvKb7YTBMPNCtizHf+TnHv0RzDbiO9ifz+VvW4+AI3P+j5Y+FYU+2VkwpvRtg=
X-Received: by 2002:a65:6483:: with SMTP id e3mr983638pgv.208.1616749600733;
 Fri, 26 Mar 2021 02:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210324141337.29269-1-ciara.loftus@intel.com> <20210324141337.29269-3-ciara.loftus@intel.com>
In-Reply-To: <20210324141337.29269-3-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 26 Mar 2021 10:06:29 +0100
Message-ID: <CAJ8uoz2Om5HdaWSN6UG5Os2GMQCtJ8dRqB_QN4Lw=kbm6fEe1g@mail.gmail.com>
Subject: Re: [PATCH bpf 2/3] libbpf: restore umem state after socket create failure
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 3:46 PM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> If the call to socket_create fails, the user may want to retry the
> socket creation using the same umem. Ensure that the umem is in the
> same state on exit if the call failed by restoring the _save pointers
> and not unmapping the set of umem rings if those pointers are non NULL.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 443b0cfb45e8..ec3c23299329 100644
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
>                 }

By not unmapping these rings we actually leave more state after a
failed socket creation. So how about skipping this logic (and
everything below) and always unmap the rings at failure as before, but
we move the fill_save = NULL and comp_save = NULL from xsk_create_ctx
to the end of xsk_socket__create_shared just before the "return 0"
where we know that the whole operation has succeeded. This way the
mappings would be redone during the next xsk_socket__create and if
someone decides not to retry (for some reason) we do not leave two
mappings behind. Would simplify things. What do you think?

>
>                 list_del(&ctx->list);
> @@ -854,6 +856,9 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         struct xsk_socket *xsk;
>         struct xsk_ctx *ctx;
>         int err, ifindex;
> +       struct xsk_ring_prod *fsave = umem->fill_save;
> +       struct xsk_ring_cons *csave = umem->comp_save;
> +       bool unmap = !fsave;
>
>         if (!umem || !xsk_ptr || !(rx || tx))
>                 return -EFAULT;
> @@ -1005,7 +1010,9 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                 munmap(rx_map, off.rx.desc +
>                        xsk->config.rx_size * sizeof(struct xdp_desc));
>  out_put_ctx:
> -       xsk_put_ctx(ctx);
> +       umem->fill_save = fsave;
> +       umem->comp_save = csave;
> +       xsk_put_ctx(ctx, unmap);
>  out_socket:
>         if (--umem->refcount)
>                 close(xsk->fd);
> @@ -1071,7 +1078,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
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
