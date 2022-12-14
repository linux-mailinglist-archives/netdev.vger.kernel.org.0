Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F352564C775
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbiLNKyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbiLNKx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:53:58 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88690E64;
        Wed, 14 Dec 2022 02:53:56 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e13so21941196edj.7;
        Wed, 14 Dec 2022 02:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vKrnMOKYut5GEKB9cEABe1KQmlkVrveumwUrMQRECmI=;
        b=B8plWnkgTm6Zj9IjyxHyiUuM4Jjn/iGzhbr4ey66BsI6jneCWaVbyDSM2EjEVnGnXq
         qBI35BHPP0TM9D15EMEjlLM5IWjyJFIh2gp1QJdFCi+UtEwlNJVHtswgUKfxic3+sw6K
         KVDJzS3NMFSMpBkrAWrr3RbL2F6U1QsrML9JH7g/+ZtUv2YJYI1Di5FjNd7X399ouRWH
         V+sbLTpp+39P3P/K8uBDIWVvPP9V1UtOWuUlLoM72f1Sm+PIDyrvT1ZThQB2tS9FzLei
         Oj4PZ+8YwO5G9071cJHsU76NR2GPYe6SKBxZOJSzYXxixByShN27m6fN7wwMG3ggyWBN
         0K0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vKrnMOKYut5GEKB9cEABe1KQmlkVrveumwUrMQRECmI=;
        b=CxZ7YMbb2VosE6WpYTosPrPXiGlpda5VAu1p+KhHWU3VZ9BMc6m4HwaJTRkW3Bfa1w
         opYFM4Las0xdCx5TUY9rhCyvetFxt1FG1R7INQfq9tAOJaihA7QWBsK4ZflHiSjZDKOF
         vn6Jb+YFqjb/q0ANPFKA1pKlMt1bdKWuZtu7IvpgoMzbmxtW20mPmSYyB0RavN5Jh84t
         +VNQ69hTxU5h0Eljjjt7gKL0kuEoLBC0LQrDJ22xJnYNQpOAOCqxPmvxG01XaiZtmlQr
         +eV6O2drHkVxaXM1ajARcybpiS8fKixEFvbpoI+VAtyec/kuONnxk06rZOb6efTkCGP/
         lo4A==
X-Gm-Message-State: ANoB5pn2UtR589esmfhJOxJ/sTG/RMi5c2bip2A/pDeRnOoOtLUm6yCv
        qTL6yNRd/uD6C6v4xE9CdXTpTBnP+Z4PVPJVRR4=
X-Google-Smtp-Source: AA0mqf5PYLm09GUqP6qGVHeJvfK67mkxo9HHPL8tdYgUSSG1Lk6kjxfuhJu+sDiVsElG4i/32u0kb33QnJ7RDrEfcdI=
X-Received: by 2002:a50:fe87:0:b0:46d:5a5c:e3bf with SMTP id
 d7-20020a50fe87000000b0046d5a5ce3bfmr8184686edt.142.1671015234912; Wed, 14
 Dec 2022 02:53:54 -0800 (PST)
MIME-Version: 1.0
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-14-magnus.karlsson@gmail.com> <Y5dSjs6AJYr6KqQK@boxer>
In-Reply-To: <Y5dSjs6AJYr6KqQK@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 14 Dec 2022 11:53:43 +0100
Message-ID: <CAJ8uoz25MkczfwKKR3_TZb56f6ZqMPEy6ZFSr0JZFNui7AtXvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/15] selftests/xsk: merge dual and single
 thread dispatchers
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        yhs@fb.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 5:12 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Dec 06, 2022 at 10:08:24AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Make the thread dispatching code common by unifying the dual and
> > single thread dispatcher code. This so we do not have to add code in
> > two places in upcoming commits.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 120 ++++++++++-------------
> >  1 file changed, 54 insertions(+), 66 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > index 522dc1d69c17..0457874c0995 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -1364,85 +1364,61 @@ static void handler(int signum)
> >       pthread_exit(NULL);
> >  }
> >
> > -static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
> > -                                               enum test_type type)
> > +static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj_rx,
> > +                                   struct ifobject *ifobj_tx)
> >  {
> > -     bool old_shared_umem = ifobj->shared_umem;
> > -     pthread_t t0;
> > -
> > -     if (pthread_barrier_init(&barr, NULL, 2))
> > -             exit_with_error(errno);
> > -
> > -     test->current_step++;
> > -     if (type == TEST_TYPE_POLL_RXQ_TMOUT)
> > -             pkt_stream_reset(ifobj->pkt_stream);
> > -     pkts_in_flight = 0;
> > -
> > -     test->ifobj_rx->shared_umem = false;
> > -     test->ifobj_tx->shared_umem = false;
> > -
> > -     signal(SIGUSR1, handler);
> > -     /* Spawn thread */
> > -     pthread_create(&t0, NULL, ifobj->func_ptr, test);
> > -
> > -     if (type != TEST_TYPE_POLL_TXQ_TMOUT)
> > -             pthread_barrier_wait(&barr);
> > -
> > -     if (pthread_barrier_destroy(&barr))
> > -             exit_with_error(errno);
> > -
> > -     pthread_kill(t0, SIGUSR1);
> > -     pthread_join(t0, NULL);
> > -
> > -     if (test->total_steps == test->current_step || test->fail) {
> > -             xsk_socket__delete(ifobj->xsk->xsk);
> > -             xsk_clear_xskmap(ifobj->xskmap);
> > -             testapp_clean_xsk_umem(ifobj);
> > -     }
> > -
> > -     test->ifobj_rx->shared_umem = old_shared_umem;
> > -     test->ifobj_tx->shared_umem = old_shared_umem;
> > -
> > -     return !!test->fail;
> > -}
> > -
> > -static int testapp_validate_traffic(struct test_spec *test)
> > -{
> > -     struct ifobject *ifobj_tx = test->ifobj_tx;
> > -     struct ifobject *ifobj_rx = test->ifobj_rx;
> >       pthread_t t0, t1;
> >
> > -     if (pthread_barrier_init(&barr, NULL, 2))
> > -             exit_with_error(errno);
> > +     if (ifobj_tx)
> > +             if (pthread_barrier_init(&barr, NULL, 2))
> > +                     exit_with_error(errno);
> >
> >       test->current_step++;
> >       pkt_stream_reset(ifobj_rx->pkt_stream);
> >       pkts_in_flight = 0;
> >
> > +     signal(SIGUSR1, handler);
> >       /*Spawn RX thread */
> >       pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> >
> > -     pthread_barrier_wait(&barr);
> > -     if (pthread_barrier_destroy(&barr))
> > -             exit_with_error(errno);
> > +     if (ifobj_tx) {
> > +             pthread_barrier_wait(&barr);
> > +             if (pthread_barrier_destroy(&barr))
> > +                     exit_with_error(errno);
> >
> > -     /*Spawn TX thread */
> > -     pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > +             /*Spawn TX thread */
> > +             pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> >
> > -     pthread_join(t1, NULL);
> > -     pthread_join(t0, NULL);
> > +             pthread_join(t1, NULL);
> > +     }
> > +
> > +     if (!ifobj_tx)
> > +             pthread_kill(t0, SIGUSR1);
> > +     else
> > +             pthread_join(t0, NULL);
> >
> >       if (test->total_steps == test->current_step || test->fail) {
> > -             xsk_socket__delete(ifobj_tx->xsk->xsk);
> > +             if (ifobj_tx)
> > +                     xsk_socket__delete(ifobj_tx->xsk->xsk);
> >               xsk_socket__delete(ifobj_rx->xsk->xsk);
> >               testapp_clean_xsk_umem(ifobj_rx);
> > -             if (!ifobj_tx->shared_umem)
> > +             if (ifobj_tx && !ifobj_tx->shared_umem)
> >                       testapp_clean_xsk_umem(ifobj_tx);
> >       }
> >
> >       return !!test->fail;
> >  }
> >
> > +static int testapp_validate_traffic(struct test_spec *test)
> > +{
> > +     return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> > +}
> > +
> > +static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
> > +{
> > +     return __testapp_validate_traffic(test, ifobj, NULL);
>
> One minor comment here is that for single thread we either spawn Rx or Tx
> thread, whereas reading the code one could tell that single threaded test
> works only on Rx.
>
> Maybe rename to ifobj1 ifobj2 from ifobj_rx ifobj_rx? everything within is
> generic, like, we have func_ptr, not tx_func_ptr, so this won't look odd
> with ifobj1 as a name.

Makes sense. Will do this.

> > +}
> > +
> >  static void testapp_teardown(struct test_spec *test)
> >  {
> >       int i;
> > @@ -1684,6 +1660,26 @@ static void testapp_xdp_drop(struct test_spec *test)
> >       ifobj->xskmap = ifobj->def_prog->maps.xsk;
> >  }
> >
> > +static void testapp_poll_txq_tmout(struct test_spec *test)
> > +{
> > +     test_spec_set_name(test, "POLL_TXQ_FULL");
> > +
> > +     test->ifobj_tx->use_poll = true;
> > +     /* create invalid frame by set umem frame_size and pkt length equal to 2048 */
> > +     test->ifobj_tx->umem->frame_size = 2048;
> > +     pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> > +     testapp_validate_traffic_single_thread(test, test->ifobj_tx);
> > +
> > +     pkt_stream_restore_default(test);
> > +}
> > +
> > +static void testapp_poll_rxq_tmout(struct test_spec *test)
> > +{
> > +     test_spec_set_name(test, "POLL_RXQ_EMPTY");
> > +     test->ifobj_rx->use_poll = true;
> > +     testapp_validate_traffic_single_thread(test, test->ifobj_rx);
> > +}
> > +
> >  static int xsk_load_xdp_programs(struct ifobject *ifobj)
> >  {
> >       ifobj->def_prog = xsk_def_prog__open_and_load();
> > @@ -1799,18 +1795,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
> >               testapp_validate_traffic(test);
> >               break;
> >       case TEST_TYPE_POLL_TXQ_TMOUT:
> > -             test_spec_set_name(test, "POLL_TXQ_FULL");
> > -             test->ifobj_tx->use_poll = true;
> > -             /* create invalid frame by set umem frame_size and pkt length equal to 2048 */
> > -             test->ifobj_tx->umem->frame_size = 2048;
> > -             pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> > -             testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
> > -             pkt_stream_restore_default(test);
> > +             testapp_poll_txq_tmout(test);
> >               break;
> >       case TEST_TYPE_POLL_RXQ_TMOUT:
> > -             test_spec_set_name(test, "POLL_RXQ_EMPTY");
> > -             test->ifobj_rx->use_poll = true;
> > -             testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
> > +             testapp_poll_rxq_tmout(test);
> >               break;
> >       case TEST_TYPE_ALIGNED_INV_DESC:
> >               test_spec_set_name(test, "ALIGNED_INV_DESC");
> > --
> > 2.34.1
> >
