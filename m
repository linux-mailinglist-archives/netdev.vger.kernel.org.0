Return-Path: <netdev+bounces-3018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E98EB70509F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8786D281818
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A6A200D0;
	Tue, 16 May 2023 14:25:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B15C1EA8E;
	Tue, 16 May 2023 14:25:54 +0000 (UTC)
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7927EF0;
	Tue, 16 May 2023 07:25:43 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-556f2c24a28so18054967b3.1;
        Tue, 16 May 2023 07:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684247143; x=1686839143;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=muC3hDONOvSr3lrEwcSpPZ6YTBa111QjrpCvkj7h3dw=;
        b=YGSo1pN/LKVSHLsaQqWGLlFVHRtSeiYWRO6V1yml2zmyT8YT8J8wYrTo/OREPVy0kc
         5G3ybr208iQEjaxC/BGpTsyD1mNJnDUXpsx5uRFl2wBWM6Wfzvf9W/hM7tXs/aQ9r+nw
         J0DEAe/PwzomMWCT8GX5eIeOfRxwciRnLtd0CdsA1E/pmk8P+PcOygf7rNcH73EqfMyo
         +CrBRP3xOoqZ0CoUShNM25+At6BovJ/jIDsbRhjZ3hPVP1G+6+pKQ5Yd4R3mlJnMZT27
         aRMD+mjG7i4mfy2Y/93KhCl4AEIQ4N96eEOL+d1dBd6AeRBUQu+2Z87epbUN/YI2/Elu
         nY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247143; x=1686839143;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=muC3hDONOvSr3lrEwcSpPZ6YTBa111QjrpCvkj7h3dw=;
        b=UgAaDARnGB95xV2JRqqGHsVXX2J/mS7HLpKQDiRe/M2E3PnTAro9Q+pFQu6KNWgdqk
         O+7prPrCdKE6AGgryl+84cWpaK6W22eLP3tQLijIiQCmLDSUH6T1dLpCn4LlrSp9vvNd
         JHe2gn4KQ+ixuYmWtiqf73iFcwljnMRiHRLpibboXpkkWP0hJajKlNXfFB2j1QcYFteZ
         9JzLMWoudhYSXjvtxCImN1ZbBSE/wDqDQbBGkHRecbuzobUmA6DpyqWykPGhzPJnfOZf
         sXegBqvoa+FRd2Xoq1+AFK5z3MHy11JpI42dkuzXdaG6nEsRcz+32JD70jd+YS5GCYMW
         lEvw==
X-Gm-Message-State: AC+VfDzwCwH6jS+4jRQ0KGj25jhF/lcB0w0afTFi0iioHS6yuqxVC5FR
	SgaBMmY0PgCBuwoRYSw85CmTS5R33DPJkbjqL5o=
X-Google-Smtp-Source: ACHHUZ7ggh5WuV9RvI1esPAtYkvecabCE51vbjlOSc6awiYsQef8eC/Sd63VfNQWc/xB/M2GLplqBbnstB1V5YE/Qjc=
X-Received: by 2002:a81:7016:0:b0:55a:80b5:6ad1 with SMTP id
 l22-20020a817016000000b0055a80b56ad1mr2346979ywc.5.1684247142425; Tue, 16 May
 2023 07:25:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
 <20230516103109.3066-8-magnus.karlsson@gmail.com> <ZGN98qXSvzggA1Yu@boxer>
In-Reply-To: <ZGN98qXSvzggA1Yu@boxer>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 16 May 2023 16:25:30 +0200
Message-ID: <CAJ8uoz0dGgi2K0G_QdGO6iVLtQSfP296Hi9dcBeFVUhtd4=9Jg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/10] selftests/xsx: test for huge pages only once
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, yhs@fb.com, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, 
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, 
	haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 16 May 2023 at 14:58, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, May 16, 2023 at 12:31:06PM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Test for hugepages only once at the beginning of the execution of the
> > whole test suite, instead of before each test that needs huge
> > pages. These are the tests that use unaligned mode. As more unaligned
> > tests will be added, so the current system just does not scale.
> >
> > With this change, there are now three possible outcomes of a test run:
> > fail, pass, or skip. To simplify the handling of this, the function
> > testapp_validate_traffic() now returns this value to the main loop. As
> > this function is used by nearly all tests, it meant a small change to
> > most of them.
>
> I don't get the need for that change. Why couldn't we just store the
> retval to test_spec and then check it in run_pkt_test() just like we check
> test->fail currently? Am i missing something?

I think it is nicer to have the test return fail/pass/skip, just like
most functions return non-zero if there is an error, instead of using
a variable embedded in a struct. But maybe it is too much for a single
patch. How about breaking out the void -> int conversion of the return
value in one patch and then have the "remember unaligned mode" in a
separate one? The first one is just a means to be able to reach the
second one. What do you think?

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 186 +++++++++++------------
> >  tools/testing/selftests/bpf/xskxceiver.h |   2 +
> >  2 files changed, 94 insertions(+), 94 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > index d488d859d3a2..f0d929cb730a 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -1413,6 +1413,12 @@ static int testapp_validate_traffic(struct test_spec *test)
> >       struct ifobject *ifobj_rx = test->ifobj_rx;
> >       struct ifobject *ifobj_tx = test->ifobj_tx;
> >
> > +     if ((ifobj_rx->umem->unaligned_mode && !ifobj_rx->unaligned_supp) ||
> > +         (ifobj_tx->umem->unaligned_mode && !ifobj_tx->unaligned_supp)) {
> > +             ksft_test_result_skip("No huge pages present.\n");
> > +             return TEST_SKIP;
> > +     }
> > +
> >       xsk_attach_xdp_progs(test, ifobj_rx, ifobj_tx);
> >       return __testapp_validate_traffic(test, ifobj_rx, ifobj_tx);
> >  }
> > @@ -1422,16 +1428,18 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
> >       return __testapp_validate_traffic(test, ifobj, NULL);
> >  }
> >
> > -static void testapp_teardown(struct test_spec *test)
> > +static int testapp_teardown(struct test_spec *test)
> >  {
> >       int i;
> >
> >       test_spec_set_name(test, "TEARDOWN");
> >       for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
> >               if (testapp_validate_traffic(test))
> > -                     return;
> > +                     return TEST_FAILURE;
> >               test_spec_reset(test);
> >       }
> > +
> > +     return TEST_PASS;
> >  }
> >
> >  static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
> > @@ -1446,20 +1454,23 @@ static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
> >       *ifobj2 = tmp_ifobj;
> >  }
> >
> > -static void testapp_bidi(struct test_spec *test)
> > +static int testapp_bidi(struct test_spec *test)
> >  {
> > +     int res;
> > +
> >       test_spec_set_name(test, "BIDIRECTIONAL");
> >       test->ifobj_tx->rx_on = true;
> >       test->ifobj_rx->tx_on = true;
> >       test->total_steps = 2;
> >       if (testapp_validate_traffic(test))
> > -             return;
> > +             return TEST_FAILURE;
> >
> >       print_verbose("Switching Tx/Rx vectors\n");
> >       swap_directions(&test->ifobj_rx, &test->ifobj_tx);
> > -     __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> > +     res = __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> >
> >       swap_directions(&test->ifobj_rx, &test->ifobj_tx);
> > +     return res;
> >  }
> >
> >  static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
> > @@ -1476,115 +1487,94 @@ static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj
> >               exit_with_error(errno);
> >  }
> >
> > -static void testapp_bpf_res(struct test_spec *test)
> > +static int testapp_bpf_res(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "BPF_RES");
> >       test->total_steps = 2;
> >       test->nb_sockets = 2;
> >       if (testapp_validate_traffic(test))
> > -             return;
> > +             return TEST_FAILURE;
> >
> >       swap_xsk_resources(test->ifobj_tx, test->ifobj_rx);
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_headroom(struct test_spec *test)
> > +static int testapp_headroom(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "UMEM_HEADROOM");
> >       test->ifobj_rx->umem->frame_headroom = UMEM_HEADROOM_TEST_SIZE;
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_stats_rx_dropped(struct test_spec *test)
> > +static int testapp_stats_rx_dropped(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "STAT_RX_DROPPED");
> > +     if (test->mode == TEST_MODE_ZC) {
> > +             ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
> > +             return TEST_SKIP;
> > +     }
> > +
> >       pkt_stream_replace_half(test, MIN_PKT_SIZE * 4, 0);
> >       test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
> >               XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 3;
> >       pkt_stream_receive_half(test);
> >       test->ifobj_rx->validation_func = validate_rx_dropped;
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_stats_tx_invalid_descs(struct test_spec *test)
> > +static int testapp_stats_tx_invalid_descs(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "STAT_TX_INVALID");
> >       pkt_stream_replace_half(test, XSK_UMEM__INVALID_FRAME_SIZE, 0);
> >       test->ifobj_tx->validation_func = validate_tx_invalid_descs;
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_stats_rx_full(struct test_spec *test)
> > +static int testapp_stats_rx_full(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "STAT_RX_FULL");
> >       pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
> >       test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
> >                                                        DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
> > -     if (!test->ifobj_rx->pkt_stream)
> > -             exit_with_error(ENOMEM);
> >
> >       test->ifobj_rx->xsk->rxqsize = DEFAULT_UMEM_BUFFERS;
> >       test->ifobj_rx->release_rx = false;
> >       test->ifobj_rx->validation_func = validate_rx_full;
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_stats_fill_empty(struct test_spec *test)
> > +static int testapp_stats_fill_empty(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
> >       pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
> >       test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
> >                                                        DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
> > -     if (!test->ifobj_rx->pkt_stream)
> > -             exit_with_error(ENOMEM);
> >
> >       test->ifobj_rx->use_fill_ring = false;
> >       test->ifobj_rx->validation_func = validate_fill_empty;
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -/* Simple test */
> > -static bool hugepages_present(struct ifobject *ifobject)
> > +static int testapp_unaligned(struct test_spec *test)
> >  {
> > -     size_t mmap_sz = 2 * ifobject->umem->num_frames * ifobject->umem->frame_size;
> > -     void *bufs;
> > -
> > -     bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
> > -                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB, -1, 0);
> > -     if (bufs == MAP_FAILED)
> > -             return false;
> > -
> > -     mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
> > -     munmap(bufs, mmap_sz);
> > -     return true;
> > -}
> > -
> > -static bool testapp_unaligned(struct test_spec *test)
> > -{
> > -     if (!hugepages_present(test->ifobj_tx)) {
> > -             ksft_test_result_skip("No 2M huge pages present.\n");
> > -             return false;
> > -     }
> > -
> >       test_spec_set_name(test, "UNALIGNED_MODE");
> >       test->ifobj_tx->umem->unaligned_mode = true;
> >       test->ifobj_rx->umem->unaligned_mode = true;
> >       /* Let half of the packets straddle a 4K buffer boundary */
> >       pkt_stream_replace_half(test, MIN_PKT_SIZE, -MIN_PKT_SIZE / 2);
> > -     testapp_validate_traffic(test);
> >
> > -     return true;
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_single_pkt(struct test_spec *test)
> > +static int testapp_single_pkt(struct test_spec *test)
> >  {
> >       struct pkt pkts[] = {{0, MIN_PKT_SIZE, 0, true}};
> >
> >       pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_invalid_desc(struct test_spec *test)
> > +static int testapp_invalid_desc(struct test_spec *test)
> >  {
> >       struct xsk_umem_info *umem = test->ifobj_tx->umem;
> >       u64 umem_size = umem->num_frames * umem->frame_size;
> > @@ -1626,10 +1616,10 @@ static void testapp_invalid_desc(struct test_spec *test)
> >       }
> >
> >       pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_xdp_drop(struct test_spec *test)
> > +static int testapp_xdp_drop(struct test_spec *test)
> >  {
> >       struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
> >       struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
> > @@ -1639,10 +1629,10 @@ static void testapp_xdp_drop(struct test_spec *test)
> >                              skel_rx->maps.xsk, skel_tx->maps.xsk);
> >
> >       pkt_stream_receive_half(test);
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_xdp_metadata_count(struct test_spec *test)
> > +static int testapp_xdp_metadata_count(struct test_spec *test)
> >  {
> >       struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
> >       struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
> > @@ -1663,10 +1653,10 @@ static void testapp_xdp_metadata_count(struct test_spec *test)
> >       if (bpf_map_update_elem(bpf_map__fd(data_map), &key, &count, BPF_ANY))
> >               exit_with_error(errno);
> >
> > -     testapp_validate_traffic(test);
> > +     return testapp_validate_traffic(test);
> >  }
> >
> > -static void testapp_poll_txq_tmout(struct test_spec *test)
> > +static int testapp_poll_txq_tmout(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "POLL_TXQ_FULL");
> >
> > @@ -1674,14 +1664,14 @@ static void testapp_poll_txq_tmout(struct test_spec *test)
> >       /* create invalid frame by set umem frame_size and pkt length equal to 2048 */
> >       test->ifobj_tx->umem->frame_size = 2048;
> >       pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> > -     testapp_validate_traffic_single_thread(test, test->ifobj_tx);
> > +     return testapp_validate_traffic_single_thread(test, test->ifobj_tx);
> >  }
> >
> > -static void testapp_poll_rxq_tmout(struct test_spec *test)
> > +static int testapp_poll_rxq_tmout(struct test_spec *test)
> >  {
> >       test_spec_set_name(test, "POLL_RXQ_EMPTY");
> >       test->ifobj_rx->use_poll = true;
> > -     testapp_validate_traffic_single_thread(test, test->ifobj_rx);
> > +     return testapp_validate_traffic_single_thread(test, test->ifobj_rx);
> >  }
> >
> >  static int xsk_load_xdp_programs(struct ifobject *ifobj)
> > @@ -1698,6 +1688,22 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
> >       xsk_xdp_progs__destroy(ifobj->xdp_progs);
> >  }
> >
> > +/* Simple test */
> > +static bool hugepages_present(void)
> > +{
> > +     size_t mmap_sz = 2 * DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE;
> > +     void *bufs;
> > +
> > +     bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
> > +                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, MAP_HUGE_2MB);
> > +     if (bufs == MAP_FAILED)
> > +             return false;
> > +
> > +     mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
> > +     munmap(bufs, mmap_sz);
> > +     return true;
> > +}
> > +
> >  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
> >                      thread_func_t func_ptr)
> >  {
> > @@ -1713,94 +1719,87 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
> >               printf("Error loading XDP program\n");
> >               exit_with_error(err);
> >       }
> > +
> > +     if (hugepages_present())
> > +             ifobj->unaligned_supp = true;
> >  }
> >
> >  static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
> >  {
> > +     int ret = TEST_SKIP;
> > +
> >       switch (type) {
> >       case TEST_TYPE_STATS_RX_DROPPED:
> > -             if (mode == TEST_MODE_ZC) {
> > -                     ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
> > -                     return;
> > -             }
> > -             testapp_stats_rx_dropped(test);
> > +             ret = testapp_stats_rx_dropped(test);
> >               break;
> >       case TEST_TYPE_STATS_TX_INVALID_DESCS:
> > -             testapp_stats_tx_invalid_descs(test);
> > +             ret = testapp_stats_tx_invalid_descs(test);
> >               break;
> >       case TEST_TYPE_STATS_RX_FULL:
> > -             testapp_stats_rx_full(test);
> > +             ret = testapp_stats_rx_full(test);
> >               break;
> >       case TEST_TYPE_STATS_FILL_EMPTY:
> > -             testapp_stats_fill_empty(test);
> > +             ret = testapp_stats_fill_empty(test);
> >               break;
> >       case TEST_TYPE_TEARDOWN:
> > -             testapp_teardown(test);
> > +             ret = testapp_teardown(test);
> >               break;
> >       case TEST_TYPE_BIDI:
> > -             testapp_bidi(test);
> > +             ret = testapp_bidi(test);
> >               break;
> >       case TEST_TYPE_BPF_RES:
> > -             testapp_bpf_res(test);
> > +             ret = testapp_bpf_res(test);
> >               break;
> >       case TEST_TYPE_RUN_TO_COMPLETION:
> >               test_spec_set_name(test, "RUN_TO_COMPLETION");
> > -             testapp_validate_traffic(test);
> > +             ret = testapp_validate_traffic(test);
> >               break;
> >       case TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT:
> >               test_spec_set_name(test, "RUN_TO_COMPLETION_SINGLE_PKT");
> > -             testapp_single_pkt(test);
> > +             ret = testapp_single_pkt(test);
> >               break;
> >       case TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME:
> >               test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
> >               test->ifobj_tx->umem->frame_size = 2048;
> >               test->ifobj_rx->umem->frame_size = 2048;
> >               pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
> > -             testapp_validate_traffic(test);
> > +             ret = testapp_validate_traffic(test);
> >               break;
> >       case TEST_TYPE_RX_POLL:
> >               test->ifobj_rx->use_poll = true;
> >               test_spec_set_name(test, "POLL_RX");
> > -             testapp_validate_traffic(test);
> > +             ret = testapp_validate_traffic(test);
> >               break;
> >       case TEST_TYPE_TX_POLL:
> >               test->ifobj_tx->use_poll = true;
> >               test_spec_set_name(test, "POLL_TX");
> > -             testapp_validate_traffic(test);
> > +             ret = testapp_validate_traffic(test);
> >               break;
> >       case TEST_TYPE_POLL_TXQ_TMOUT:
> > -             testapp_poll_txq_tmout(test);
> > +             ret = testapp_poll_txq_tmout(test);
> >               break;
> >       case TEST_TYPE_POLL_RXQ_TMOUT:
> > -             testapp_poll_rxq_tmout(test);
> > +             ret = testapp_poll_rxq_tmout(test);
> >               break;
> >       case TEST_TYPE_ALIGNED_INV_DESC:
> >               test_spec_set_name(test, "ALIGNED_INV_DESC");
> > -             testapp_invalid_desc(test);
> > +             ret = testapp_invalid_desc(test);
> >               break;
> >       case TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME:
> >               test_spec_set_name(test, "ALIGNED_INV_DESC_2K_FRAME_SIZE");
> >               test->ifobj_tx->umem->frame_size = 2048;
> >               test->ifobj_rx->umem->frame_size = 2048;
> > -             testapp_invalid_desc(test);
> > +             ret = testapp_invalid_desc(test);
> >               break;
> >       case TEST_TYPE_UNALIGNED_INV_DESC:
> > -             if (!hugepages_present(test->ifobj_tx)) {
> > -                     ksft_test_result_skip("No 2M huge pages present.\n");
> > -                     return;
> > -             }
> >               test_spec_set_name(test, "UNALIGNED_INV_DESC");
> >               test->ifobj_tx->umem->unaligned_mode = true;
> >               test->ifobj_rx->umem->unaligned_mode = true;
> > -             testapp_invalid_desc(test);
> > +             ret = testapp_invalid_desc(test);
> >               break;
> >       case TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME: {
> >               u64 page_size, umem_size;
> >
> > -             if (!hugepages_present(test->ifobj_tx)) {
> > -                     ksft_test_result_skip("No 2M huge pages present.\n");
> > -                     return;
> > -             }
> >               test_spec_set_name(test, "UNALIGNED_INV_DESC_4K1_FRAME_SIZE");
> >               /* Odd frame size so the UMEM doesn't end near a page boundary. */
> >               test->ifobj_tx->umem->frame_size = 4001;
> > @@ -1814,27 +1813,26 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
> >               umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
> >               assert(umem_size % page_size > MIN_PKT_SIZE);
> >               assert(umem_size % page_size < page_size - MIN_PKT_SIZE);
> > -             testapp_invalid_desc(test);
> > +             ret = testapp_invalid_desc(test);
> >               break;
> >       }
> >       case TEST_TYPE_UNALIGNED:
> > -             if (!testapp_unaligned(test))
> > -                     return;
> > +             ret = testapp_unaligned(test);
> >               break;
> >       case TEST_TYPE_HEADROOM:
> > -             testapp_headroom(test);
> > +             ret = testapp_headroom(test);
> >               break;
> >       case TEST_TYPE_XDP_DROP_HALF:
> > -             testapp_xdp_drop(test);
> > +             ret = testapp_xdp_drop(test);
> >               break;
> >       case TEST_TYPE_XDP_METADATA_COUNT:
> > -             testapp_xdp_metadata_count(test);
> > +             ret = testapp_xdp_metadata_count(test);
> >               break;
> >       default:
> >               break;
> >       }
> >
> > -     if (!test->fail)
> > +     if (ret == TEST_PASS)
> >               ksft_test_result_pass("PASS: %s %s%s\n", mode_string(test), busy_poll_string(test),
> >                                     test->name);
> >       pkt_stream_restore_default(test);
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> > index be4664a38d74..00862732e751 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > @@ -30,6 +30,7 @@
> >  #define TEST_PASS 0
> >  #define TEST_FAILURE -1
> >  #define TEST_CONTINUE 1
> > +#define TEST_SKIP 2
> >  #define MAX_INTERFACES 2
> >  #define MAX_INTERFACE_NAME_CHARS 16
> >  #define MAX_SOCKETS 2
> > @@ -148,6 +149,7 @@ struct ifobject {
> >       bool release_rx;
> >       bool shared_umem;
> >       bool use_metadata;
> > +     bool unaligned_supp;
> >       u8 dst_mac[ETH_ALEN];
> >       u8 src_mac[ETH_ALEN];
> >  };
> > --
> > 2.34.1
> >

