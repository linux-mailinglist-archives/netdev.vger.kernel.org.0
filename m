Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D481468B
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfEFIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:40:52 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35428 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfEFIkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:40:52 -0400
Received: by mail-qk1-f195.google.com with SMTP id b7so7304227qkl.2;
        Mon, 06 May 2019 01:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dsmV2ykcRa+8zSWcpqYpvl/Vvn4+OyDOGXdXsu4MKuQ=;
        b=LAynFvTLlhZ6phipsCmkx0lVqcXmxFSyOU0JNHfdxurp2kY23u8cVFnMzMVMbzwJRP
         d4HrSCwJzjQFfbfGelYbkSHy4rqRbqZi6qNJ+0sEUfwXlMO+fg2fc1JK8/HjwdsXuwqf
         sSA9ElFKbJQfgIuWKhZ59EnyzEZfD+ylxzy9SuBenTlOWy8WYc0AVtg1wD6waPSOgnUy
         Mss46wi5IZ+AEGi1qoU7MxWCHB9O+FwqPSbGrCClWj+o/CkhcZ6oul3v88bxspSHe2A/
         7vnxyCNOIyAKmVQ3FPu0xUAk5AnUju1Uvffex2y0wpqvuC1deZvyQPi+IowGJjnGB1Mj
         5rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dsmV2ykcRa+8zSWcpqYpvl/Vvn4+OyDOGXdXsu4MKuQ=;
        b=uoFMQmOZiLjQ/pJYgKvuCZZKlkjCYSZHGGBd0VhFTZIov0YvloNoJ+4hOgDQv6+p/e
         sX8RHTr3JcUSsgcL2QVyCUEvKEAbMFY41/6C26ZfbV8Qww0S78lkVSSgF3OdPtwwig4Z
         nMp7W/SmmFtLp/hZrZRj2w70Or4EoT/osA3aQOqmzkXzAW8i8C0YxAxna/8zHPBHapsr
         EpnrQ2gPXR/f6BTMtp4lakwfJStQNQpDAn5XRQxg/ONWSXS6fr/W4gYMJWQMBpP49dP/
         tPw+1/VdXfGWO6Ys8ZsiGXH2aZ/4f2Ua9BwX2fl4f5G5IxmMVwNweztbsmbQi2M6zIXH
         qvLA==
X-Gm-Message-State: APjAAAW6u9p7ZiKXukjcPqVYRUMCp0WwV+p5ZL2QELpg+z5+EONR7Xrt
        q7e2V4OVTBaF47CwlIf8JG5e3US0pNmvxzgabw4=
X-Google-Smtp-Source: APXvYqzo8OKKxa/iTpl1F7TJmH2AZxlLO4ZYXZy7MPUZsbCaDmz93nuKr6A7BItYCJ3iDueHhgvv3acBam/SpzJE/1E=
X-Received: by 2002:a37:a3d8:: with SMTP id m207mr5267633qke.334.1557132050843;
 Mon, 06 May 2019 01:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190430124536.7734-1-bjorn.topel@gmail.com> <20190430124536.7734-2-bjorn.topel@gmail.com>
 <20aaa3f5-fd93-9773-ca8a-40809e9dc981@iogearbox.net>
In-Reply-To: <20aaa3f5-fd93-9773-ca8a-40809e9dc981@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 6 May 2019 10:40:39 +0200
Message-ID: <CAJ+HfNhuHoZ5HEBTOTapg9Mu2vMB1pFvbXXrXbkRo4E7m2nNLQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] libbpf: fix invalid munmap call
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        bpf <bpf@vger.kernel.org>, William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 May 2019 at 10:26, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 04/30/2019 02:45 PM, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > When unmapping the AF_XDP memory regions used for the rings, an
> > invalid address was passed to the munmap() calls. Instead of passing
> > the beginning of the memory region, the descriptor region was passed
> > to munmap.
> >
> > When the userspace application tried to tear down an AF_XDP socket,
> > the operation failed and the application would still have a reference
> > to socket it wished to get rid of.
> >
> > Reported-by: William Tu <u9012063@gmail.com>
> > Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> [...]
> >  out_mmap_tx:
> >       if (tx)
> > -             munmap(xsk->tx,
> > -                    off.tx.desc +
> > +             munmap(tx_map, off.tx.desc +
> >                      xsk->config.tx_size * sizeof(struct xdp_desc));
> >  out_mmap_rx:
> >       if (rx)
> > -             munmap(xsk->rx,
> > -                    off.rx.desc +
> > +             munmap(rx_map, off.rx.desc +
> >                      xsk->config.rx_size * sizeof(struct xdp_desc));
> >  out_socket:
> >       if (--umem->refcount)
> > @@ -684,10 +681,12 @@ int xsk_umem__delete(struct xsk_umem *umem)
> >       optlen =3D sizeof(off);
> >       err =3D getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &op=
tlen);
> >       if (!err) {
> > -             munmap(umem->fill->ring,
> > -                    off.fr.desc + umem->config.fill_size * sizeof(__u6=
4));
> > -             munmap(umem->comp->ring,
> > -                    off.cr.desc + umem->config.comp_size * sizeof(__u6=
4));
> > +             (void)munmap(umem->fill->ring - off.fr.desc,
> > +                          off.fr.desc +
> > +                          umem->config.fill_size * sizeof(__u64));
> > +             (void)munmap(umem->comp->ring - off.cr.desc,
> > +                          off.cr.desc +
> > +                          umem->config.comp_size * sizeof(__u64));
>
> What's the rationale to cast to void here and other places (e.g. below)?
> If there's no proper reason, then lets remove it. Given the patch has alr=
eady
> been applied, please send a follow up. Thanks.
>

The rationale was to make it explicit that the return value is *not*
cared about. If this is not common practice, I'll remove it in a
follow up!

Thank,
Bj=C3=B6rn

> >       }
> >
> >       close(umem->fd);
> > @@ -698,6 +697,7 @@ int xsk_umem__delete(struct xsk_umem *umem)
> >
> >  void xsk_socket__delete(struct xsk_socket *xsk)
> >  {
> > +     size_t desc_sz =3D sizeof(struct xdp_desc);
> >       struct xdp_mmap_offsets off;
> >       socklen_t optlen;
> >       int err;
> > @@ -710,14 +710,17 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >       optlen =3D sizeof(off);
> >       err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &opt=
len);
> >       if (!err) {
> > -             if (xsk->rx)
> > -                     munmap(xsk->rx->ring,
> > -                            off.rx.desc +
> > -                            xsk->config.rx_size * sizeof(struct xdp_de=
sc));
> > -             if (xsk->tx)
> > -                     munmap(xsk->tx->ring,
> > -                            off.tx.desc +
> > -                            xsk->config.tx_size * sizeof(struct xdp_de=
sc));
> > +             if (xsk->rx) {
> > +                     (void)munmap(xsk->rx->ring - off.rx.desc,
> > +                                  off.rx.desc +
> > +                                  xsk->config.rx_size * desc_sz);
> > +             }
> > +             if (xsk->tx) {
> > +                     (void)munmap(xsk->tx->ring - off.tx.desc,
> > +                                  off.tx.desc +
> > +                                  xsk->config.tx_size * desc_sz);
> > +             }
> > +
> >       }
> >
> >       xsk->umem->refcount--;
> >
>
