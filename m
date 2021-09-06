Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED540176E
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbhIFIB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 04:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhIFIBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 04:01:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45400C061575;
        Mon,  6 Sep 2021 01:00:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so3780264pjc.3;
        Mon, 06 Sep 2021 01:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D/RYpiu45Y06Qm/sLy8nQ/AnuaSLV5tqMOb1n5eENQc=;
        b=Jb0sm2P4eunUQzrfJ8DxxHOhe3AEkpredl1thO85T7S/3aWDo/j+nx5YARzdiAYRkZ
         3lt2PICz34E21p8hkKdYg2fcsnAS+M9EBnOcr5qYaxHX60a2pjl3tP3YLa3YHhS9kf/f
         SoAb81FxV4PjF4fICOLPLWMx6uciWBA125xwt0ibnPrQYFkJfDnf1Rnbun+X3Am5Bb1W
         Zm5oF9AuyhTOzmNaUnE3M+9wuBZKEfyYSNIO+xfdL9+bLztBjAJRu6szR+ND2xHdDODv
         4xXRqw6E6yhq4xYkgQBemyImwn0PVwCod8RkymDJtnKW0eIam84BC/IhdrZ2x/gn/N3C
         nPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D/RYpiu45Y06Qm/sLy8nQ/AnuaSLV5tqMOb1n5eENQc=;
        b=Hosb/rVlJn7KuJffRPLD5mr56iePcqtxC457OPPNtQMeaHGmBmIuNISt8kO0eo4SnR
         uo66Cp5LLOyBHKqe8k/boKDwoXN1vPH93bZNjWOjjkyT6zADv4eLDkGLV3IE80CwEKSP
         fdhlxDFaz9gz5ENli6pbFbFmxi+FhNGzGZXn/semvjRM3zQ1gDMiMCfMlMDMdkOf0Wkq
         QDraFRlyFPnOpGS0nIy8ujjrb5q8bieT8NHz1WMrx+0gxKUGb9VEXc4DgfGAL3QFqCdw
         jCZw+gEeFT6ST/piLDO6zmBfB/T+UtYblzqVvpBiYQKLJMZZihZSFDo4EdOkcxe8DDqe
         57kg==
X-Gm-Message-State: AOAM531cnQl/uyVS/K8OND7UF9PoBaFbpi5xXAeB099J7I87b3CWrupj
        X6eS4wOMDRgiegazPx1fAiPKGUB0bihgqEUEgiw=
X-Google-Smtp-Source: ABdhPJzI51d3+fdoUHkLtutZrZkMS2XLXRMY2UyWGLJDCeRJ9sTmvuFZ/o+PUIp2c0RrUJ3tXeE1hIAWbz8dfoAdr0Q=
X-Received: by 2002:a17:90a:5583:: with SMTP id c3mr12562903pji.133.1630915220686;
 Mon, 06 Sep 2021 01:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
 <20210901104732.10956-17-magnus.karlsson@gmail.com> <YTI4Ucn+6/uWLezP@localhost.localdomain>
In-Reply-To: <YTI4Ucn+6/uWLezP@localhost.localdomain>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 6 Sep 2021 10:00:09 +0200
Message-ID: <CAJ8uoz3i6hnh+Nu8UB6QJWWJDTrH30_Te4jWQnrtqL83D_A23Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 16/20] selftests: xsk: introduce replacing the
 default packet stream
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

On Fri, Sep 3, 2021 at 3:04 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Sep 01, 2021 at 12:47:28PM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Introduce the concept of a default packet stream that is the set of
> > packets sent by most tests. Then add the ability to replace it for a
> > test that would like to send or receive something else through the use
> > of the function pkt_stream_replace() and then restored with
> > pkt_stream_restore_default(). These are then used to convert the
> > STAT_TX_INVALID_TEST to use these new APIs.
>
> s/STAT_TX_INVALID_TEST/STAT_TEST_TX_INVALID

Will fix.

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xdpxceiver.c | 67 +++++++++++++++++-------
> >  tools/testing/selftests/bpf/xdpxceiver.h |  1 +
> >  2 files changed, 50 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index 09d2854c10e6..d4aad4833754 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -390,6 +390,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
> >               ifobj->umem = &ifobj->umem_arr[0];
> >               ifobj->xsk = &ifobj->xsk_arr[0];
> >               ifobj->use_poll = false;
> > +             ifobj->pkt_stream = test->pkt_stream_default;
> >
> >               if (i == 0) {
> >                       ifobj->rx_on = false;
> > @@ -418,9 +419,12 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
> >  static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
> >                          struct ifobject *ifobj_rx, enum test_mode mode)
> >  {
> > +     struct pkt_stream *pkt_stream;
> >       u32 i;
> >
> > +     pkt_stream = test->pkt_stream_default;
> >       memset(test, 0, sizeof(*test));
> > +     test->pkt_stream_default = pkt_stream;
> >
> >       for (i = 0; i < MAX_INTERFACES; i++) {
> >               struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
> > @@ -455,6 +459,19 @@ static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
> >       return &pkt_stream->pkts[pkt_nb];
> >  }
> >
> > +static void pkt_stream_delete(struct pkt_stream *pkt_stream)
> > +{
> > +     free(pkt_stream->pkts);
> > +     free(pkt_stream);
> > +}
> > +
> > +static void pkt_stream_restore_default(struct test_spec *test)
> > +{
> > +     pkt_stream_delete(test->ifobj_tx->pkt_stream);
>
> I suppose that streams are the same for both tx and rx ifobjs hence it's
> enough to call the delete op a single time.

At this point in time, yes. But this has to change as we develop more tests.

> > +     test->ifobj_tx->pkt_stream = test->pkt_stream_default;
> > +     test->ifobj_rx->pkt_stream = test->pkt_stream_default;
> > +}
> > +
> >  static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
> >  {
> >       struct pkt_stream *pkt_stream;
> > @@ -483,6 +500,17 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
> >       return pkt_stream;
> >  }
> >
> > +static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
> > +{
> > +     struct pkt_stream *pkt_stream;
> > +
> > +     pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
> > +     test->ifobj_tx->pkt_stream = pkt_stream;
> > +     test->ifobj_rx->pkt_stream = pkt_stream;
> > +
> > +     pkt_stream_delete(pkt_stream);
>
> Shouldn't this be deleting the stream that got replaced? You're assigning
> pkt_stream to ifobjs and then immediately free it.
>
> I'd say that we should drop this call to pkt_stream_delete() in here
> unless I'm missing something, pkt_stream_restore_default() will free the
> currently assigned pkt stream and bring back the default one to the
> ifobjs.

That is indeed a bug and should be removed.

> > +}
> > +
> >  static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
> >  {
> >       struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
> > @@ -557,7 +585,7 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *d
> >       if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
> >               u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
> >
> > -             if (opt_pkt_dump && test_type != TEST_TYPE_STATS)
> > +             if (opt_pkt_dump)
> >                       pkt_dump(data, PKT_SIZE);
> >
> >               if (pkt->len != desc->len) {
> > @@ -598,9 +626,6 @@ static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
> >       unsigned int rcvd;
> >       u32 idx;
> >
> > -     if (!xsk->outstanding_tx)
> > -             return;
> > -
> >       if (xsk_ring_prod__needs_wakeup(&xsk->tx))
> >               kick_tx(xsk);
> >
> > @@ -831,6 +856,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
> >
> >  static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
> >  {
> > +     print_verbose("Destroying socket\n");
> >       xsk_socket__delete(ifobj->xsk->xsk);
> >       xsk_umem__delete(ifobj->umem->umem);
> >  }
> > @@ -878,9 +904,6 @@ static void *worker_testapp_validate_rx(void *arg)
> >       else
> >               receive_pkts(ifobject->pkt_stream, ifobject->xsk, &fds);
> >
> > -     if (test_type == TEST_TYPE_TEARDOWN)
> > -             print_verbose("Destroying socket\n");
> > -
> >       if (test->total_steps == test->current_step)
> >               testapp_cleanup_xsk_res(ifobject);
> >       pthread_exit(NULL);
> > @@ -890,19 +913,11 @@ static void testapp_validate_traffic(struct test_spec *test)
> >  {
> >       struct ifobject *ifobj_tx = test->ifobj_tx;
> >       struct ifobject *ifobj_rx = test->ifobj_rx;
> > -     struct pkt_stream *pkt_stream;
> >       pthread_t t0, t1;
> >
> >       if (pthread_barrier_init(&barr, NULL, 2))
> >               exit_with_error(errno);
> >
> > -     if (stat_test_type == STAT_TEST_TX_INVALID)
> > -             pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, DEFAULT_PKT_CNT,
> > -                                              XSK_UMEM__INVALID_FRAME_SIZE);
> > -     else
> > -             pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> > -     ifobj_tx->pkt_stream = pkt_stream;
> > -     ifobj_rx->pkt_stream = pkt_stream;
> >       test->current_step++;
> >
> >       /*Spawn RX thread */
> > @@ -982,7 +997,9 @@ static void testapp_bpf_res(struct test_spec *test)
> >
> >  static void testapp_stats(struct test_spec *test)
> >  {
> > -     for (int i = 0; i < STAT_TEST_TYPE_MAX; i++) {
> > +     int i;
> > +
> > +     for (i = 0; i < STAT_TEST_TYPE_MAX; i++) {
> >               test_spec_reset(test);
> >               stat_test_type = i;
> >
> > @@ -991,21 +1008,27 @@ static void testapp_stats(struct test_spec *test)
> >                       test_spec_set_name(test, "STAT_RX_DROPPED");
> >                       test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
> >                               XDP_PACKET_HEADROOM - 1;
> > +                     testapp_validate_traffic(test);
> >                       break;
> >               case STAT_TEST_RX_FULL:
> >                       test_spec_set_name(test, "STAT_RX_FULL");
> >                       test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
> > +                     testapp_validate_traffic(test);
> >                       break;
> >               case STAT_TEST_TX_INVALID:
> >                       test_spec_set_name(test, "STAT_TX_INVALID");
> > -                     continue;
> > +                     pkt_stream_replace(test, DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
> > +                     testapp_validate_traffic(test);
> > +
> > +                     pkt_stream_restore_default(test);
> > +                     break;
> >               case STAT_TEST_RX_FILL_EMPTY:
> >                       test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
> > +                     testapp_validate_traffic(test);
> >                       break;
> >               default:
> >                       break;
> >               }
> > -             testapp_validate_traffic(test);
> >       }
> >
> >       /* To only see the whole stat set being completed unless an individual test fails. */
> > @@ -1106,6 +1129,7 @@ int main(int argc, char **argv)
> >  {
> >       struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> >       struct ifobject *ifobj_tx, *ifobj_rx;
> > +     struct pkt_stream *pkt_stream_default;
>
> rct broken by a little?
>
> >       struct test_spec test;
> >       u32 i, j;
> >
> > @@ -1133,6 +1157,12 @@ int main(int argc, char **argv)
> >       init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
> >                  worker_testapp_validate_rx);
> >
> > +     test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
> > +     pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> > +     if (!pkt_stream_default)
> > +             exit_with_error(ENOMEM);
>
> I missed this probably while reviewing previous set, but to be consistent
> with 083be682d976 ("selftests: xsk: Return correct error codes") this
> probably should have -ENOMEM as an arg?

Have eliminated exit_with_error from most of the functions I have been
touching, but not from the main function. Want the error to be printed
out before exiting the program, so kept it at this level.

> > +     test.pkt_stream_default = pkt_stream_default;
> > +
> >       ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
> >
> >       for (i = 0; i < TEST_MODE_MAX; i++)
> > @@ -1142,6 +1172,7 @@ int main(int argc, char **argv)
> >                       usleep(USLEEP_MAX);
> >               }
> >
> > +     pkt_stream_delete(pkt_stream_default);
> >       ifobject_delete(ifobj_tx);
> >       ifobject_delete(ifobj_rx);
> >
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> > index c5baa7c5f560..e27fe348ae50 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.h
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> > @@ -132,6 +132,7 @@ struct ifobject {
> >  struct test_spec {
> >       struct ifobject *ifobj_tx;
> >       struct ifobject *ifobj_rx;
> > +     struct pkt_stream *pkt_stream_default;
> >       u16 total_steps;
> >       u16 current_step;
> >       u16 nb_sockets;
> > --
> > 2.29.0
> >
