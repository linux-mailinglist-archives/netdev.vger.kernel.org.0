Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E557B5483F5
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 12:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiFMJwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbiFMJwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:52:43 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2333C183BD;
        Mon, 13 Jun 2022 02:52:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x138so5258384pfc.12;
        Mon, 13 Jun 2022 02:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MBjL1OPYG8G6Z4dtlSvqrtUXrI+Xt//bESmLt9lZ3MI=;
        b=AFjybpxDUVtMIbovoUc2T6LB3LDINPSL/gahhyHY7cMCJ0E7A6y1q5HSc+ejkCELUf
         xFn22zTUDDnNmgU718/fEJtOO7yfPaDI3N1Vd3wBYr+b5AYaZecC9uBaMI82/F4PXt+N
         Cq4ZJSX2JuvuZWIOaxnb2iy4H09DDRDyU9ZO7xZU7W6mUel4YHB88/PwUEsbKB3aQ18m
         62Vp8o8SncIjdj60S5MuybKgmdXg3FN65GBgufF8d7Httab5LTg8uEesJHdtxGhTWozY
         km65tGvfI4qx5px32H8S8ULPvDFiYs7Ki9xvFxmiadK7BKyHgu2L/vH3L5OTmz0uWHXp
         Bi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MBjL1OPYG8G6Z4dtlSvqrtUXrI+Xt//bESmLt9lZ3MI=;
        b=U0sdhE5OojiDDv1cJmjEtWg8uUPALNoqvPZZoDwPZF72eSLKHjCNXPpin+OgfrqjKY
         S1+bDztlLoXdjhA7ti74T2u9b4OgVQ9LoDVbA4U1KbWVDjyExO+wCYtZ41oZdWgjxz/7
         gM5JkxVh5PFxPU5xaNkB7C0DvCTCVr/NDsKiyT+uQvs5kjqFC+9AplMqXhlnOeEpCxGp
         OCf3ycrR2QtlQ+Ni0T2uGZ2bZZEzUr515eDugHniyhMCZ6rbFk9QvTxM/SqcfQHa3wOL
         jNX1P3sJ1GoUA+LwUncF6H5XEbd3XwR5C7z2+zFC4jVokD9IvMhxkXQLSxpiUWWpAJl2
         dp6A==
X-Gm-Message-State: AOAM531Ksh8buygx9Dl9t8r8TTvHfRynVvXM2h2BZaWNT3MC7DfN6gHK
        fkyh0sI+UC/XBRwN6qYqa2YHE2iUz2FQAxwiq4o=
X-Google-Smtp-Source: ABdhPJwY6AKD0xdt1PDOp78Mk6ZNAUdL82DZ6wZvjQSVy0/wtbITfA0TRStvZgwbtNPB8OFtYJHe0zBazH26473Q5vo=
X-Received: by 2002:a63:fd58:0:b0:405:1ff7:3ffe with SMTP id
 m24-20020a63fd58000000b004051ff73ffemr8449351pgj.156.1655113961531; Mon, 13
 Jun 2022 02:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-7-maciej.fijalkowski@intel.com>
In-Reply-To: <20220610150923.583202-7-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Jun 2022 11:52:30 +0200
Message-ID: <CAJ8uoz0fLSWdSTCYNWZAspmoGUaYJmRsz4aA-f=40UopBZuW5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/10] selftests: xsk: introduce default Rx pkt stream
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
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

On Fri, Jun 10, 2022 at 5:15 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> In order to prepare xdpxceiver for physical device testing, let us
> introduce default Rx pkt stream. Reason for doing it is that physical
> device testing will use a UMEM with a doubled size where half of it will
> be used by Tx and other half by Rx. This means that pkt addresses will
> differ for Tx and Rx streams. Rx thread will initialize the
> xsk_umem_info::base_addr that is added here so that pkt_set(), when
> working on Rx UMEM will add this offset and second half of UMEM space
> will be used. Note that currently base_addr is 0 on both sides. Future
> commit will do the mentioned initialization.
>
> Previously, veth based testing worked on separate UMEMs, so single
> default stream was fine.

Make sense.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 74 +++++++++++++++---------
>  tools/testing/selftests/bpf/xdpxceiver.h |  4 +-
>  2 files changed, 51 insertions(+), 27 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 2499075fad82..ad6c92c31026 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -428,15 +428,16 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>                 ifobj->use_poll = false;
>                 ifobj->use_fill_ring = true;
>                 ifobj->release_rx = true;
> -               ifobj->pkt_stream = test->pkt_stream_default;
>                 ifobj->validation_func = NULL;
>
>                 if (i == 0) {
>                         ifobj->rx_on = false;
>                         ifobj->tx_on = true;
> +                       ifobj->pkt_stream = test->tx_pkt_stream_default;
>                 } else {
>                         ifobj->rx_on = true;
>                         ifobj->tx_on = false;
> +                       ifobj->pkt_stream = test->rx_pkt_stream_default;
>                 }
>
>                 memset(ifobj->umem, 0, sizeof(*ifobj->umem));
> @@ -460,12 +461,15 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>  static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>                            struct ifobject *ifobj_rx, enum test_mode mode)
>  {
> -       struct pkt_stream *pkt_stream;
> +       struct pkt_stream *tx_pkt_stream;
> +       struct pkt_stream *rx_pkt_stream;
>         u32 i;
>
> -       pkt_stream = test->pkt_stream_default;
> +       tx_pkt_stream = test->tx_pkt_stream_default;
> +       rx_pkt_stream = test->rx_pkt_stream_default;
>         memset(test, 0, sizeof(*test));
> -       test->pkt_stream_default = pkt_stream;
> +       test->tx_pkt_stream_default = tx_pkt_stream;
> +       test->rx_pkt_stream_default = rx_pkt_stream;
>
>         for (i = 0; i < MAX_INTERFACES; i++) {
>                 struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
> @@ -526,16 +530,17 @@ static void pkt_stream_delete(struct pkt_stream *pkt_stream)
>  static void pkt_stream_restore_default(struct test_spec *test)
>  {
>         struct pkt_stream *tx_pkt_stream = test->ifobj_tx->pkt_stream;
> +       struct pkt_stream *rx_pkt_stream = test->ifobj_rx->pkt_stream;
>
> -       if (tx_pkt_stream != test->pkt_stream_default) {
> +       if (tx_pkt_stream != test->tx_pkt_stream_default) {
>                 pkt_stream_delete(test->ifobj_tx->pkt_stream);
> -               test->ifobj_tx->pkt_stream = test->pkt_stream_default;
> +               test->ifobj_tx->pkt_stream = test->tx_pkt_stream_default;
>         }
>
> -       if (test->ifobj_rx->pkt_stream != test->pkt_stream_default &&
> -           test->ifobj_rx->pkt_stream != tx_pkt_stream)
> +       if (rx_pkt_stream != test->rx_pkt_stream_default) {
>                 pkt_stream_delete(test->ifobj_rx->pkt_stream);
> -       test->ifobj_rx->pkt_stream = test->pkt_stream_default;
> +               test->ifobj_rx->pkt_stream = test->rx_pkt_stream_default;
> +       }
>  }
>
>  static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
> @@ -558,7 +563,7 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
>
>  static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, u64 addr, u32 len)
>  {
> -       pkt->addr = addr;
> +       pkt->addr = addr + umem->base_addr;
>         pkt->len = len;
>         if (len > umem->frame_size - XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 2 - umem->frame_headroom)
>                 pkt->valid = false;
> @@ -597,22 +602,29 @@ static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
>
>         pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
>         test->ifobj_tx->pkt_stream = pkt_stream;
> +       pkt_stream = pkt_stream_generate(test->ifobj_rx->umem, nb_pkts, pkt_len);
>         test->ifobj_rx->pkt_stream = pkt_stream;
>  }
>
> -static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int offset)
> +static void __pkt_stream_replace_half(struct ifobject *ifobj, u32 pkt_len,
> +                                     int offset)
>  {
> -       struct xsk_umem_info *umem = test->ifobj_tx->umem;
> +       struct xsk_umem_info *umem = ifobj->umem;
>         struct pkt_stream *pkt_stream;
>         u32 i;
>
> -       pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
> -       for (i = 1; i < test->pkt_stream_default->nb_pkts; i += 2)
> +       pkt_stream = pkt_stream_clone(umem, ifobj->pkt_stream);
> +       for (i = 1; i < ifobj->pkt_stream->nb_pkts; i += 2)
>                 pkt_set(umem, &pkt_stream->pkts[i],
>                         (i % umem->num_frames) * umem->frame_size + offset, pkt_len);
>
> -       test->ifobj_tx->pkt_stream = pkt_stream;
> -       test->ifobj_rx->pkt_stream = pkt_stream;
> +       ifobj->pkt_stream = pkt_stream;
> +}
> +
> +static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int offset)
> +{
> +       __pkt_stream_replace_half(test->ifobj_tx, pkt_len, offset);
> +       __pkt_stream_replace_half(test->ifobj_rx, pkt_len, offset);
>  }
>
>  static void pkt_stream_receive_half(struct test_spec *test)
> @@ -654,7 +666,8 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
>         return pkt;
>  }
>
> -static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts, u32 nb_pkts)
> +static void __pkt_stream_generate_custom(struct ifobject *ifobj,
> +                                        struct pkt *pkts, u32 nb_pkts)
>  {
>         struct pkt_stream *pkt_stream;
>         u32 i;
> @@ -663,15 +676,20 @@ static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts,
>         if (!pkt_stream)
>                 exit_with_error(ENOMEM);
>
> -       test->ifobj_tx->pkt_stream = pkt_stream;
> -       test->ifobj_rx->pkt_stream = pkt_stream;
> -
>         for (i = 0; i < nb_pkts; i++) {
> -               pkt_stream->pkts[i].addr = pkts[i].addr;
> +               pkt_stream->pkts[i].addr = pkts[i].addr + ifobj->umem->base_addr;
>                 pkt_stream->pkts[i].len = pkts[i].len;
>                 pkt_stream->pkts[i].payload = i;
>                 pkt_stream->pkts[i].valid = pkts[i].valid;
>         }
> +
> +       ifobj->pkt_stream = pkt_stream;
> +}
> +
> +static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts, u32 nb_pkts)
> +{
> +       __pkt_stream_generate_custom(test->ifobj_tx, pkts, nb_pkts);
> +       __pkt_stream_generate_custom(test->ifobj_rx, pkts, nb_pkts);
>  }
>
>  static void pkt_dump(void *pkt, u32 len)
> @@ -1641,7 +1659,8 @@ static bool is_xdp_supported(struct ifobject *ifobject)
>
>  int main(int argc, char **argv)
>  {
> -       struct pkt_stream *pkt_stream_default;
> +       struct pkt_stream *rx_pkt_stream_default;
> +       struct pkt_stream *tx_pkt_stream_default;
>         struct ifobject *ifobj_tx, *ifobj_rx;
>         int modes = TEST_MODE_SKB + 1;
>         u32 i, j, failed_tests = 0;
> @@ -1675,10 +1694,12 @@ int main(int argc, char **argv)
>                 modes++;
>
>         test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
> -       pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> -       if (!pkt_stream_default)
> +       tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> +       rx_pkt_stream_default = pkt_stream_generate(ifobj_rx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> +       if (!tx_pkt_stream_default || !rx_pkt_stream_default)
>                 exit_with_error(ENOMEM);
> -       test.pkt_stream_default = pkt_stream_default;
> +       test.tx_pkt_stream_default = tx_pkt_stream_default;
> +       test.rx_pkt_stream_default = rx_pkt_stream_default;
>
>         ksft_set_plan(modes * TEST_TYPE_MAX);
>
> @@ -1692,7 +1713,8 @@ int main(int argc, char **argv)
>                                 failed_tests++;
>                 }
>
> -       pkt_stream_delete(pkt_stream_default);
> +       pkt_stream_delete(tx_pkt_stream_default);
> +       pkt_stream_delete(rx_pkt_stream_default);
>         ifobject_delete(ifobj_tx);
>         ifobject_delete(ifobj_rx);
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index 8f672b0fe0e1..ccfc829b2e5e 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -95,6 +95,7 @@ struct xsk_umem_info {
>         u32 frame_headroom;
>         void *buffer;
>         u32 frame_size;
> +       u32 base_addr;
>         bool unaligned_mode;
>  };
>
> @@ -155,7 +156,8 @@ struct ifobject {
>  struct test_spec {
>         struct ifobject *ifobj_tx;
>         struct ifobject *ifobj_rx;
> -       struct pkt_stream *pkt_stream_default;
> +       struct pkt_stream *tx_pkt_stream_default;
> +       struct pkt_stream *rx_pkt_stream_default;
>         u16 total_steps;
>         u16 current_step;
>         u16 nb_sockets;
> --
> 2.27.0
>
