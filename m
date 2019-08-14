Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829E98D4C1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfHNNci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:32:38 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46179 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfHNNch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 09:32:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id j15so16491973qtl.13;
        Wed, 14 Aug 2019 06:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JuExSWsBtfAM5/29pBQpPsbNhQp3pZxTJtDhhkS2oNE=;
        b=nQgN303e8SJv5otTtuvGf/lH9GHy1WKTL2cScOMOG3BhpfoAKksBRYdw9d9WLmX+eg
         XQegHTCfaaTCB1g3zN0h9BZ2gLV0VvwgMUpKtzvjUT/zhSK4oImrXu4/nhgwO48TGu8R
         zJBv5BqYRytIN4OOA0Ao+V42xj571m9Zi0RGZradkKB7dlRiwf2fMRCQkrPMZf+LmHMz
         z0SXpNQXqaGWGUmYpC0kAcmpbPUOqZvP3Z+uFMdmFMf2ZQKMnEvw9o0ZlTXrSvba+Q+2
         gb5PZlyQZRFvaABgy6BSV+OYmDk2OiFhQlk5FsPAaxGc0gqF5wWXoQrLOVtgpGF8XlFt
         hbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=JuExSWsBtfAM5/29pBQpPsbNhQp3pZxTJtDhhkS2oNE=;
        b=S9hzZYbTe5bBTJ20a/2Ha9hW5h0kfKs+CT4CVnDe4M+QLb0cA0kCVGph1PAgNW94qa
         m1/7RFuBpW/27Fwr417hlJxKz5D2MNYekkkQkJLu0JzdRcl0qNfkHitlqwdfw0PT/guM
         V1j6bx9OGECxalASxyhtneitRH7fFP8sGGOCNq09iFUZxq51C7aFEpXMzlg+P5Nma8xa
         kJyiJca6A72ECrls/WReB9/JBhSgAFqKjkZ9VGYN9UtDvhJwLnqAoENtFHCf61r3y1XM
         QOBEDQWHA7dJeB22Eoc9J53c4cfqxvhVRapBjS3jHWcaIC/BEKpsBF+mPTx8Qni2jpsZ
         x08Q==
X-Gm-Message-State: APjAAAU9pWBwyZ3opzht6weQxOBRKVW7L0aUQ4wAGp4oVwHE5Rw6OayV
        vPnRvEUvauDNEb7Fo2vOzZF0wxP49Iz8Z2r/qxTDb7C0
X-Google-Smtp-Source: APXvYqwftTZEQiFz68w3xUjf6UBOlrVY9j2B4qm77zeGbcpioedpyueIrbxwowjWeL+ozjGXmQcm4DOImaUs5M0EExo=
X-Received: by 2002:a0c:f643:: with SMTP id s3mr2535550qvm.79.1565789556060;
 Wed, 14 Aug 2019 06:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org> <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
 <20190814092403.GA4142@khorivan> <20190814115659.GC4142@khorivan>
In-Reply-To: <20190814115659.GC4142@khorivan>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 14 Aug 2019 15:32:24 +0200
Message-ID: <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get __NR_mmap2
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 at 13:57, Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Wed, Aug 14, 2019 at 12:24:05PM +0300, Ivan Khoronzhuk wrote:
> >On Tue, Aug 13, 2019 at 04:38:13PM -0700, Andrii Nakryiko wrote:
> >
> >Hi, Andrii
> >
> >>On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
> >><ivan.khoronzhuk@linaro.org> wrote:
> >>>
> >>>That's needed to get __NR_mmap2 when mmap2 syscall is used.
> >>>
> >>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >>>---
> >>> tools/lib/bpf/xsk.c | 1 +
> >>> 1 file changed, 1 insertion(+)
> >>>
> >>>diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >>>index 5007b5d4fd2c..f2fc40f9804c 100644
> >>>--- a/tools/lib/bpf/xsk.c
> >>>+++ b/tools/lib/bpf/xsk.c
> >>>@@ -12,6 +12,7 @@
> >>> #include <stdlib.h>
> >>> #include <string.h>
> >>> #include <unistd.h>
> >>>+#include <asm/unistd.h>
> >>
> >>asm/unistd.h is not present in Github libbpf projection. Is there any
> >
> >Look on includes from
> >tools/lib/bpf/libpf.c
> >tools/lib/bpf/bpf.c
> >
> >That's how it's done... Copping headers to arch/arm will not
> >solve this, it includes both of them anyway, and anyway it needs
> >asm/unistd.h inclusion here, only because xsk.c needs __NR_*
> >
> >
>
> There is one more radical solution for this I can send, but I'm not sure =
how it
> can impact on other syscals/arches...
>
> Looks like:
>
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 9312066a1ae3..8b2f8ff7ce44 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -113,6 +113,7 @@ override CFLAGS +=3D -Werror -Wall
>  override CFLAGS +=3D -fPIC
>  override CFLAGS +=3D $(INCLUDES)
>  override CFLAGS +=3D -fvisibility=3Dhidden
> +override CFLAGS +=3D -D_FILE_OFFSET_BITS=3D64
>

Hmm, isn't this glibc-ism? Does is it work for, say, musl or bionic?

If this is portable, and works on 32-, and 64-bit archs, I'm happy
with the patch. :-)


Bj=C3=B6rn

>  ifeq ($(VERBOSE),1)
>    Q =3D
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index f2fc40f9804c..ff2d03b8380d 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -75,23 +75,6 @@ struct xsk_nl_info {
>         int fd;
>  };
>
> -/* For 32-bit systems, we need to use mmap2 as the offsets are 64-bit.
> - * Unfortunately, it is not part of glibc.
> - */
> -static inline void *xsk_mmap(void *addr, size_t length, int prot, int fl=
ags,
> -                            int fd, __u64 offset)
> -{
> -#ifdef __NR_mmap2
> -       unsigned int page_shift =3D __builtin_ffs(getpagesize()) - 1;
> -       long ret =3D syscall(__NR_mmap2, addr, length, prot, flags, fd,
> -                          (off_t)(offset >> page_shift));
> -
> -       return (void *)ret;
> -#else
> -       return mmap(addr, length, prot, flags, fd, offset);
> -#endif
> -}
> -
>  int xsk_umem__fd(const struct xsk_umem *umem)
>  {
>         return umem ? umem->fd : -EINVAL;
> @@ -211,10 +194,9 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, voi=
d *umem_area, __u64 size,
>                 goto out_socket;
>         }
>
> -       map =3D xsk_mmap(NULL, off.fr.desc +
> -                      umem->config.fill_size * sizeof(__u64),
> -                      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
> -                      umem->fd, XDP_UMEM_PGOFF_FILL_RING);
> +       map =3D mmap(NULL, off.fr.desc + umem->config.fill_size * sizeof(=
__u64),
> +                  PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ume=
m->fd,
> +                  XDP_UMEM_PGOFF_FILL_RING);
>         if (map =3D=3D MAP_FAILED) {
>                 err =3D -errno;
>                 goto out_socket;
> @@ -228,10 +210,9 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, voi=
d *umem_area, __u64 size,
>         fill->ring =3D map + off.fr.desc;
>         fill->cached_cons =3D umem->config.fill_size;
>
> -       map =3D xsk_mmap(NULL,
> -                      off.cr.desc + umem->config.comp_size * sizeof(__u6=
4),
> -                      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
> -                      umem->fd, XDP_UMEM_PGOFF_COMPLETION_RING);
> +       map =3D mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(=
__u64),
> +                  PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, ume=
m->fd,
> +                  XDP_UMEM_PGOFF_COMPLETION_RING);
>         if (map =3D=3D MAP_FAILED) {
>                 err =3D -errno;
>                 goto out_mmap;
> @@ -552,11 +533,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr,=
 const char *ifname,
>         }
>
>         if (rx) {
> -               rx_map =3D xsk_mmap(NULL, off.rx.desc +
> -                                 xsk->config.rx_size * sizeof(struct xdp=
_desc),
> -                                 PROT_READ | PROT_WRITE,
> -                                 MAP_SHARED | MAP_POPULATE,
> -                                 xsk->fd, XDP_PGOFF_RX_RING);
> +               rx_map =3D mmap(NULL, off.rx.desc +
> +                             xsk->config.rx_size * sizeof(struct xdp_des=
c),
> +                             PROT_READ | PROT_WRITE, MAP_SHARED | MAP_PO=
PULATE,
> +                             xsk->fd, XDP_PGOFF_RX_RING);
>                 if (rx_map =3D=3D MAP_FAILED) {
>                         err =3D -errno;
>                         goto out_socket;
> @@ -571,11 +551,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr,=
 const char *ifname,
>         xsk->rx =3D rx;
>
>         if (tx) {
> -               tx_map =3D xsk_mmap(NULL, off.tx.desc +
> -                                 xsk->config.tx_size * sizeof(struct xdp=
_desc),
> -                                 PROT_READ | PROT_WRITE,
> -                                 MAP_SHARED | MAP_POPULATE,
> -                                 xsk->fd, XDP_PGOFF_TX_RING);
> +               tx_map =3D mmap(NULL, off.tx.desc +
> +                             xsk->config.tx_size * sizeof(struct xdp_des=
c),
> +                             PROT_READ | PROT_WRITE, MAP_SHARED | MAP_PO=
PULATE,
> +                             xsk->fd, XDP_PGOFF_TX_RING);
>                 if (tx_map =3D=3D MAP_FAILED) {
>                         err =3D -errno;
>                         goto out_mmap_rx;
>
>
> If maintainers are ready to accept this I can send.
> What do you say?
>
> --
> Regards,
> Ivan Khoronzhuk
