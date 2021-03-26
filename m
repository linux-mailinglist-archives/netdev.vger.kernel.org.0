Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B580B34AB57
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhCZPUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhCZPUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:20:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65C3C0613AA;
        Fri, 26 Mar 2021 08:20:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso2614064pjb.3;
        Fri, 26 Mar 2021 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7D+Cse3ihNc2ZaOg4zGslx+pgmOZh0mOWA/8iPjSLc=;
        b=lDRkROCjICUL+OUkcWeggCCT9NbAguxFs33jdM3s8zFv/oJ499T2aNCS4FitTYqVZy
         919kgAIAGWbfwKD3Ld7AbbUCF0gd5ZTWOnPMs4qQDaz/MXwzC95U30DRcCKma2STJ1CU
         9Ea1hVM9RCDOa4vAzVV+mrRinsOaGDZU7Wv9LRdinXDS8CU9Y5ZVI1xSeJTaRGxaKNx2
         Sz41tVp4reQT4Ejls3YqmGcy+zmnO8eoqbiBBk6JcY1fV56Gycfo/7QCuJrSuTHSL11H
         1kjAdDwlCHbeyY9cpYIPhN/eD0WOKDOcHxYW0lAq3nagnXwwG25xA8iTtVXIewfPa3qI
         dO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7D+Cse3ihNc2ZaOg4zGslx+pgmOZh0mOWA/8iPjSLc=;
        b=Se9RjK7Q0uxY6HjBUFFiaTumHZ03/FK3sCrOnJcxPjtr5KeNPtR2CWJVPMVvCcYvpa
         CQYG9Eyy2BRN9oo2ad+2iKXBh2hgOYUiwrnKWUfO4OZKnmgmeLhlKAa0lh3BqhOjGeoW
         AJe9CZps4F24TAcg/1nEmblB5LYDM08qbcGgFX9X+W/XQid1SB9n9BZJbg851CY7kzMw
         sIqygFr5cY167dG/lMlHPalpk72OrhRZYO/0JBErJNMI+55rz5zTD29fXbJsiy6N8wnJ
         AY9Nr+g/jJv+WhZaDI1Ph3otcVfW2Ai1z4v6gNwfBJAs5FVAVuiHkVir9qH2DQy9uiyR
         vZdw==
X-Gm-Message-State: AOAM5333Z7xX/lnuvlWGT0SyxeoBQJMzcO9lm/H9QrSfw173Qiucffq9
        oE1fp5CYoMzxnFKaF6t5EE1PgLyd4nGADxZAPV1oOkcJeBavcg==
X-Google-Smtp-Source: ABdhPJxfQ/9aJD046Od0IZgd/ZNMnxOtdAX2YxJ2H+DwFDlb/wtmnR1E0RHRVRvIuRxehLfjFnQjQC/hdn+wdlkHnmo=
X-Received: by 2002:a17:90b:e01:: with SMTP id ge1mr14660176pjb.117.1616772021421;
 Fri, 26 Mar 2021 08:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210324141337.29269-1-ciara.loftus@intel.com>
 <20210324141337.29269-3-ciara.loftus@intel.com> <CAJ8uoz2Om5HdaWSN6UG5Os2GMQCtJ8dRqB_QN4Lw=kbm6fEe1g@mail.gmail.com>
 <57b4dcd5cc4544e380442dad0588a84d@intel.com>
In-Reply-To: <57b4dcd5cc4544e380442dad0588a84d@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 26 Mar 2021 16:20:10 +0100
Message-ID: <CAJ8uoz1PSwJkpZ80YgPbSan19QPmt3gSmwvd7JT+epTF7z4phg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/3] libbpf: restore umem state after socket create failure
To:     "Loftus, Ciara" <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 3:56 PM Loftus, Ciara <ciara.loftus@intel.com> wrote:
>
> >
> > On Wed, Mar 24, 2021 at 3:46 PM Ciara Loftus <ciara.loftus@intel.com>
> > wrote:
> > >
> > > If the call to socket_create fails, the user may want to retry the
> > > socket creation using the same umem. Ensure that the umem is in the
> > > same state on exit if the call failed by restoring the _save pointers
> > > and not unmapping the set of umem rings if those pointers are non NULL.
> > >
> > > Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and
> > devices")
> > >
> > > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > > ---
> > >  tools/lib/bpf/xsk.c | 29 ++++++++++++++++++-----------
> > >  1 file changed, 18 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index 443b0cfb45e8..ec3c23299329 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -743,21 +743,23 @@ static struct xsk_ctx *xsk_get_ctx(struct
> > xsk_umem *umem, int ifindex,
> > >         return NULL;
> > >  }
> > >
> > > -static void xsk_put_ctx(struct xsk_ctx *ctx)
> > > +static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
> > >  {
> > >         struct xsk_umem *umem = ctx->umem;
> > >         struct xdp_mmap_offsets off;
> > >         int err;
> > >
> > >         if (--ctx->refcount == 0) {
> > > -               err = xsk_get_mmap_offsets(umem->fd, &off);
> > > -               if (!err) {
> > > -                       munmap(ctx->fill->ring - off.fr.desc,
> > > -                              off.fr.desc + umem->config.fill_size *
> > > -                              sizeof(__u64));
> > > -                       munmap(ctx->comp->ring - off.cr.desc,
> > > -                              off.cr.desc + umem->config.comp_size *
> > > -                              sizeof(__u64));
> > > +               if (unmap) {
> > > +                       err = xsk_get_mmap_offsets(umem->fd, &off);
> > > +                       if (!err) {
> > > +                               munmap(ctx->fill->ring - off.fr.desc,
> > > +                                      off.fr.desc + umem->config.fill_size *
> > > +                               sizeof(__u64));
> > > +                               munmap(ctx->comp->ring - off.cr.desc,
> > > +                                      off.cr.desc + umem->config.comp_size *
> > > +                               sizeof(__u64));
> > > +                       }
> > >                 }
> >
> > By not unmapping these rings we actually leave more state after a
> > failed socket creation. So how about skipping this logic (and
>
> In the case of the _save rings, the maps existed before the call to
> xsk_socket__create. They were created during xsk_umem__create.
> So we should preserve these maps in event of failure.
> I was using the wrong condition to trigger the unmap in v1 however.
> We should unmap 'fill' only if
>         umem->fill_save != fill
> I will update this in a v2.

Ahh, you are correct. There are two ways these rings can get allocated
so that has to be taken care of. Please ignore my comment.

> > everything below) and always unmap the rings at failure as before, but
> > we move the fill_save = NULL and comp_save = NULL from xsk_create_ctx
> > to the end of xsk_socket__create_shared just before the "return 0"
> > where we know that the whole operation has succeeded. This way the
>
> I think moving these still makes sense and will add this in the next rev.
>
> Thanks for the feedback and suggestions!
>
> Ciara
>
> > mappings would be redone during the next xsk_socket__create and if
> > someone decides not to retry (for some reason) we do not leave two
> > mappings behind. Would simplify things. What do you think?
>
> >
> > >
> > >                 list_del(&ctx->list);
> > > @@ -854,6 +856,9 @@ int xsk_socket__create_shared(struct xsk_socket
> > **xsk_ptr,
> > >         struct xsk_socket *xsk;
> > >         struct xsk_ctx *ctx;
> > >         int err, ifindex;
> > > +       struct xsk_ring_prod *fsave = umem->fill_save;
> > > +       struct xsk_ring_cons *csave = umem->comp_save;
> > > +       bool unmap = !fsave;
> > >
> > >         if (!umem || !xsk_ptr || !(rx || tx))
> > >                 return -EFAULT;
> > > @@ -1005,7 +1010,9 @@ int xsk_socket__create_shared(struct xsk_socket
> > **xsk_ptr,
> > >                 munmap(rx_map, off.rx.desc +
> > >                        xsk->config.rx_size * sizeof(struct xdp_desc));
> > >  out_put_ctx:
> > > -       xsk_put_ctx(ctx);
> > > +       umem->fill_save = fsave;
> > > +       umem->comp_save = csave;
> > > +       xsk_put_ctx(ctx, unmap);
> > >  out_socket:
> > >         if (--umem->refcount)
> > >                 close(xsk->fd);
> > > @@ -1071,7 +1078,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >                 }
> > >         }
> > >
> > > -       xsk_put_ctx(ctx);
> > > +       xsk_put_ctx(ctx, true);
> > >
> > >         umem->refcount--;
> > >         /* Do not close an fd that also has an associated umem connected
> > > --
> > > 2.17.1
> > >
