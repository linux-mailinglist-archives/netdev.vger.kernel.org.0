Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB49B401780
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 10:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbhIFIGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 04:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240524AbhIFIEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 04:04:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC14EC0617AF;
        Mon,  6 Sep 2021 01:03:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fs6so3776831pjb.4;
        Mon, 06 Sep 2021 01:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oqkiNgpbcHxiMem52GJfPa+oCf4Ivn8zPQL81258VJE=;
        b=OREHjphfgu5QhlFKzul2AwQB2Ex6gFv29yi3aTXkoTID/FYtBXMV+1JYjOOabJzjd7
         OfBmwu8vcdLxsxekvXlQBaNX+5Ls5feeKabjoC64Ox0SRGWIiCIci9M/KEm2eTnMyAbC
         xegezARmJWtERMIte/AMziW5qKmhJ9O91UJ95dS/fvEPki17Wcx5eI2EwCiMQ/5Z9PBR
         0OO8C3R1njhCOy/VmbeqVkJyhgiNhdQqWaMu3785SxpvSQZV9bv31f5UlYDLg2ZbTjAc
         tDmdh1S21lF28msSBaQJUt+V6f5m0eOdRonkqC7AGghz6tXundwGOTkE1Cq9tXl19Dhn
         VZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oqkiNgpbcHxiMem52GJfPa+oCf4Ivn8zPQL81258VJE=;
        b=q50Ld/+iByNiYXxIiVj1TvpuLQUPkd4kyTbMdXIPm2zKNqPJHDwDeryazm2gnXBLaH
         rZp0XPbj+fcfMc8eJ0n8EM37oYpYib2sSKB5V1+F59e+Fj587DaJjFQbmBtlvx4lLC86
         wIGainBYN9hqqnSpHFyPzcM5Y/t6UehHrQGsf9uQKjfJxgMybv3ZoKvpNZ87Jg0JOWlh
         CLH7tiAQ7owLlPPvs9dcusnbIVq4/K2kRst4emLgPPxg21SZ9UjyOcpAXJK8fW/ryPcQ
         toXuQme/WLVtEX3Shc/8A5bRw1BEReCog9r0WuFQxxyyhmUDEQ8byDKWdxkRcJChcJxw
         +8tQ==
X-Gm-Message-State: AOAM530Cdd1kxViFUAITVRkD5RnqinLSvvKqiRCDAVW6yyV99h/Rh9OC
        FmLvinIo0kyqnFkwuEIIkNpyV0pTdKbOfr/NwxM=
X-Google-Smtp-Source: ABdhPJxDQDLThQU+H4j80pLbMT5Zvx3pcm23+qEAE91MCfNYVgIUyJWWCKtBrgvRBAz8jD6iTZt4yD1XKFsGGCAS5p8=
X-Received: by 2002:a17:90b:400c:: with SMTP id ie12mr12384496pjb.112.1630915380182;
 Mon, 06 Sep 2021 01:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
 <20210901104732.10956-18-magnus.karlsson@gmail.com> <YTJBdg9S1QEvPVZY@localhost.localdomain>
In-Reply-To: <YTJBdg9S1QEvPVZY@localhost.localdomain>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 6 Sep 2021 10:02:49 +0200
Message-ID: <CAJ8uoz2Zckgz_=uHGMV-hfthwi6BE+6eaQkTZhGWSxqzNAkZ=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 17/20] selftests: xsk: add test for unaligned mode
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 3, 2021 at 3:37 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Sep 01, 2021 at 12:47:29PM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Add a test for unaligned mode in which packet buffers can be placed
> > anywhere within the umem. Some packets are made to straddle page
> > boundraries in order to check for correctness. On the Tx side, buffers
>
> boundaries
>
> > are now allocated according to the addresses found in the packet
> > stream. Thus, the placement of buffers can be controlled with the
> > boolean use_addr_for_fill in the packet stream.
> >
> > One new pkt_stream insterface is introduced: pkt_stream_replace_half()
>
> interface
>
> > that replaces every other packet in the default packet stream with the
> > specified new packet.
>
> Can you describe the introduction of DEFAULT_OFFSET ?

Will fix both.

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xdpxceiver.c | 125 ++++++++++++++++++-----
> >  tools/testing/selftests/bpf/xdpxceiver.h |   4 +
> >  2 files changed, 106 insertions(+), 23 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index d4aad4833754..a24068993cc3 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -19,7 +19,7 @@
> >   * Virtual Ethernet interfaces.
> >   *
> >   * For each mode, the following tests are run:
> > - *    a. nopoll - soft-irq processing
> > + *    a. nopoll - soft-irq processing in run-to-completion mode
> >   *    b. poll - using poll() syscall
> >   *    c. Socket Teardown
> >   *       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
> > @@ -45,6 +45,7 @@
> >   *       Configure sockets at indexes 0 and 1, run a traffic on queue ids 0,
> >   *       then remove xsk sockets from queue 0 on both veth interfaces and
> >   *       finally run a traffic on queues ids 1
> > + *    g. unaligned mode
> >   *
> >   * Total tests: 12
> >   *
> > @@ -243,6 +244,9 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
> >       };
> >       int ret;
> >
> > +     if (umem->unaligned_mode)
> > +             cfg.flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> > +
> >       ret = xsk_umem__create(&umem->umem, buffer, size,
> >                              &umem->fq, &umem->cq, &cfg);
> >       if (ret)
> > @@ -252,19 +256,6 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
> >       return 0;
> >  }
> >
> > -static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
> > -{
> > -     int ret, i;
> > -     u32 idx = 0;
> > -
> > -     ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
> > -     if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> > -             exit_with_error(-ret);
> > -     for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
> > -             *xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * umem->frame_size;
> > -     xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > -}
> > -
> >  static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
> >                               struct ifobject *ifobject, u32 qid)
> >  {
> > @@ -487,7 +478,8 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
> >
> >       pkt_stream->nb_pkts = nb_pkts;
> >       for (i = 0; i < nb_pkts; i++) {
> > -             pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
> > +             pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size +
> > +                     DEFAULT_OFFSET;
> >               pkt_stream->pkts[i].len = pkt_len;
> >               pkt_stream->pkts[i].payload = i;
>
> Probably we need to init use_addr_for_fill to false by default in here as
> pkt_stream is malloc'd.

I will use calloc here, instead of in patch #19. Was fixed too late in
the patch set.

> >
> > @@ -500,6 +492,12 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
> >       return pkt_stream;
> >  }
> >
> > +static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info *umem,
> > +                                        struct pkt_stream *pkt_stream)
> > +{
> > +     return pkt_stream_generate(umem, pkt_stream->nb_pkts, pkt_stream->pkts[0].len);
> > +}
> > +
> >  static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
> >  {
> >       struct pkt_stream *pkt_stream;
> > @@ -507,8 +505,22 @@ static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
> >       pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
> >       test->ifobj_tx->pkt_stream = pkt_stream;
> >       test->ifobj_rx->pkt_stream = pkt_stream;
> > +}
> >
> > -     pkt_stream_delete(pkt_stream);
> > +static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, u32 offset)
> > +{
> > +     struct xsk_umem_info *umem = test->ifobj_tx->umem;
> > +     struct pkt_stream *pkt_stream;
> > +     u32 i;
> > +
> > +     pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
> > +     for (i = 0; i < test->pkt_stream_default->nb_pkts; i += 2) {
> > +             pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size + offset;
> > +             pkt_stream->pkts[i].len = pkt_len;
> > +     }
> > +
> > +     test->ifobj_tx->pkt_stream = pkt_stream;
> > +     test->ifobj_rx->pkt_stream = pkt_stream;
> >  }
> >
> >  static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
> > @@ -572,9 +584,9 @@ static void pkt_dump(void *pkt, u32 len)
> >       fprintf(stdout, "---------------------------------------\n");
> >  }
> >
> > -static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *desc)
> > +static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
> >  {
> > -     void *data = xsk_umem__get_data(buffer, desc->addr);
> > +     void *data = xsk_umem__get_data(buffer, addr);
> >       struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
> >
> >       if (!pkt) {
> > @@ -588,10 +600,10 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *d
> >               if (opt_pkt_dump)
> >                       pkt_dump(data, PKT_SIZE);
> >
> > -             if (pkt->len != desc->len) {
> > +             if (pkt->len != len) {
> >                       ksft_test_result_fail
> >                               ("ERROR: [%s] expected length [%d], got length [%d]\n",
> > -                                     __func__, pkt->len, desc->len);
> > +                                     __func__, pkt->len, len);
> >                       return false;
> >               }
> >
> > @@ -673,7 +685,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
> >
> >                       orig = xsk_umem__extract_addr(addr);
> >                       addr = xsk_umem__add_offset_to_addr(addr);
> > -                     if (!is_pkt_valid(pkt, xsk->umem->buffer, desc))
> > +                     if (!is_pkt_valid(pkt, xsk->umem->buffer, addr, desc->len))
> >                               return;
> >
> >                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
> > @@ -817,13 +829,16 @@ static void tx_stats_validate(struct ifobject *ifobject)
> >
> >  static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
> >  {
> > +     int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> >       u32 i;
> >
> >       ifobject->ns_fd = switch_namespace(ifobject->nsname);
> >
> > +     if (ifobject->umem->unaligned_mode)
> > +             mmap_flags |= MAP_HUGETLB;
> > +
> >       for (i = 0; i < test->nb_sockets; i++) {
> >               u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
> > -             int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> >               u32 ctr = 0;
> >               void *bufs;
> >
> > @@ -881,6 +896,32 @@ static void *worker_testapp_validate_tx(void *arg)
> >       pthread_exit(NULL);
> >  }
> >
> > +static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
> > +{
> > +     u32 idx = 0, i;
> > +     int ret;
> > +
> > +     ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
> > +     if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> > +             exit_with_error(ENOSPC);
>
> -ENOSPC?

Without the minus sign is correct here. Though I would prefer to not
use exit_with_error at all except for in the main function, this would
require a lot of surgery and is left as an exercise for later patch
sets.

> > +     for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++) {
> > +             u64 addr;
> > +
> > +             if (pkt_stream->use_addr_for_fill) {
> > +                     struct pkt *pkt = pkt_stream_get_pkt(pkt_stream, i);
> > +
> > +                     if (!pkt)
> > +                             break;
> > +                     addr = pkt->addr;
> > +             } else {
> > +                     addr = (i % umem->num_frames) * umem->frame_size + DEFAULT_OFFSET;
> > +             }
> > +
> > +             *xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
> > +     }
> > +     xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > +}
