Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54137549321
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379215AbiFMN7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380467AbiFMN67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:58:59 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59358BD31;
        Mon, 13 Jun 2022 04:37:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z14so604954pjb.4;
        Mon, 13 Jun 2022 04:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V6PseXy2x281yW3ux49iTm5SxTlq+D4xccCjsrNRk8o=;
        b=jm4W9XsbwsSRKQHIkLv8vIY97nT4LD4GY9lsq+XsecSfl8jv14SH3eexr6RIpomksO
         Z2GeQrgD3BJTe9n13p91WgBaW3UxVLQKvMFxjDcugufhINla9LWOSOiFGfLvaoFR0PD8
         H1xnkuymZrJRDCdLiA9NYBWwvaSfhPVN1hF3QbFMlQ9drijFPAHbTvSFvWAF6x1BSr7e
         1B1rt0Xy67gShM1O5/gvVmlgSOajtZYLUPRKvRdOMu6XdrpqbVzXuWHJSMbiUd7fZUGi
         CNTBjqnWmsk9QrsJxP+GkUxqkMhjogn0lvNWc53iZCFOfYOxZSlEEUvn4ebeyZePH/yE
         ESZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V6PseXy2x281yW3ux49iTm5SxTlq+D4xccCjsrNRk8o=;
        b=mo9vzVxloJZR96wJCnPrqojWY1qWFPBh1nH5MUqVVdhVxuLth7nhaRTlBfGDpVActY
         JxSa06QWqfmkqBMmO/ZhU/bPuF0q9Uq4iA4fVVZHmz8Wck0U8E0NkTHloXnwzCV0uQlQ
         iFu6mr7O3JxgtW3w/xtDzaZFSg0l3xTWaY4Ps/lqv+Ull0QE9MG3rGd49uHlMNjmLaU6
         R8Wf7YToaMkA4v1BIyy1XCWjLK26StvFdSGTSrhVox3Zk9BwOIiTNLyLbqw8aEiUJTwB
         /B0mJULLYL+u11jCwt3WoYotQdJFgD9VJTyoQPEUuEKNWI0zEgsTBjyt8CgYIHYALNx3
         LATA==
X-Gm-Message-State: AOAM532yS9za4CzqmYMjShn2bjxUjIUhqrAXfaAnpPBva5xDoyCquciv
        yfDovlvc0fo6sIx1q0zQjYHmyXQNipoNu22TWGLmBfoQOAkAAw==
X-Google-Smtp-Source: ABdhPJwiBkSqH44oX35ICf7hshF77Pk4JuT8WV/zCuHPydHlthQtPefbuaen4545939rkcQN6Vutwrj46PLzo/rnHBw=
X-Received: by 2002:a17:90b:350d:b0:1e6:7780:6c92 with SMTP id
 ls13-20020a17090b350d00b001e677806c92mr15364658pjb.46.1655120260918; Mon, 13
 Jun 2022 04:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-11-maciej.fijalkowski@intel.com>
In-Reply-To: <20220610150923.583202-11-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Jun 2022 13:37:30 +0200
Message-ID: <CAJ8uoz1ENfOwXUdzGnnVqTj2NUzFGAgRCv0CeYev0_PcGT6iSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] selftests: xsk: add support for zero copy testing
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

On Fri, Jun 10, 2022 at 5:20 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Introduce new mode to xdpxceiver responsible for testing AF_XDP zero
> copy support of driver that serves underlying physical device. When
> setting up test suite, determine whether driver has ZC support or not by
> trying to bind XSK ZC socket to the interface. If it succeeded,
> interpret it as ZC support being in place and do softirq and busy poll
> tests for zero copy mode.
>
> Note that Rx dropped tests are skipped since ZC path is not touching
> rx_dropped stat at all.

Great to be able to test zero-copy drivers. Thank you! Some small
comments below.

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 80 ++++++++++++++++++++++--
>  tools/testing/selftests/bpf/xdpxceiver.h |  2 +
>  2 files changed, 77 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index a2aa652d0bb8..beef8d694fa6 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -124,9 +124,20 @@ static void __exit_with_error(int error, const char *file, const char *func, int
>  }
>
>  #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
> -
> -#define mode_string(test) (test)->ifobj_tx->xdp_flags & XDP_FLAGS_SKB_MODE ? "SKB" : "DRV"
>  #define busy_poll_string(test) (test)->ifobj_tx->busy_poll ? "BUSY-POLL " : ""
> +static char *mode_string(struct test_spec *test)
> +{
> +       switch (test->mode) {
> +       case TEST_MODE_SKB:
> +               return "SKB";
> +       case TEST_MODE_DRV:
> +               return "DRV";
> +       case TEST_MODE_ZC:
> +               return "ZC";
> +       default:
> +               return "BOGUS";
> +       }
> +}
>
>  static void report_failure(struct test_spec *test)
>  {
> @@ -317,6 +328,53 @@ static int __xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_i
>         return xsk_socket__create(&xsk->xsk, ifobject->ifname, 0, umem->umem, rxr, txr, &cfg);
>  }
>
> +static bool ifobj_zc_avail(struct ifobject *ifobject)
> +{
> +       size_t umem_sz = DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE;
> +       int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> +       struct xsk_socket_info *xsk;
> +       struct xsk_umem_info *umem;
> +       bool zc_avail = false;
> +       void *bufs;
> +       int ret;
> +
> +       bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
> +       if (bufs == MAP_FAILED)
> +               exit_with_error(errno);
> +
> +       umem = calloc(1, sizeof(struct xsk_umem_info));
> +       if (!umem) {
> +               munmap(bufs, umem_sz);
> +               exit_with_error(-ENOMEM);
> +       }
> +       umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
> +       ret = xsk_configure_umem(umem, bufs, umem_sz);
> +       if (ret)
> +               exit_with_error(-ret);
> +
> +       xsk = calloc(1, sizeof(struct xsk_socket_info));
> +       if (!xsk)
> +               goto out;
> +       ifobject->xdp_flags = 0;

This is redundant.

> +       ifobject->xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +       ifobject->xdp_flags |= XDP_FLAGS_DRV_MODE;
> +       ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
> +       ifobject->rx_on = true;
> +       xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> +       ret = __xsk_configure_socket(xsk, umem, ifobject, false);
> +       if (!ret)
> +               zc_avail = true;
> +
> +       ifobject->xdp_flags = 0;

Why this assignment?

> +       xsk_socket__delete(xsk->xsk);
> +       free(xsk);
> +out:
> +       munmap(umem->buffer, umem_sz);
> +       xsk_umem__delete(umem->umem);
> +       free(umem);
> +       return zc_avail;
> +}
> +
>  static struct option long_options[] = {
>         {"interface", required_argument, 0, 'i'},
>         {"busy-poll", no_argument, 0, 'b'},
> @@ -483,9 +541,14 @@ static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>                 else
>                         ifobj->xdp_flags |= XDP_FLAGS_DRV_MODE;
>
> -               ifobj->bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
> +               ifobj->bind_flags = XDP_USE_NEED_WAKEUP;
> +               if (mode == TEST_MODE_ZC)
> +                       ifobj->bind_flags |= XDP_ZEROCOPY;
> +               else
> +                       ifobj->bind_flags |= XDP_COPY;
>         }
>
> +       test->mode = mode;
>         __test_spec_init(test, ifobj_tx, ifobj_rx);
>  }
>
> @@ -1543,6 +1606,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  {
>         switch (type) {
>         case TEST_TYPE_STATS_RX_DROPPED:
> +               if (mode == TEST_MODE_ZC) {
> +                       ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
> +                       return;
> +               }
>                 testapp_stats_rx_dropped(test);
>                 break;
>         case TEST_TYPE_STATS_TX_INVALID_DESCS:
> @@ -1723,8 +1790,11 @@ int main(int argc, char **argv)
>         init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
>                    worker_testapp_validate_rx);
>
> -       if (is_xdp_supported(ifobj_tx))
> -               modes++;
> +       if (is_xdp_supported(ifobj_tx)) {
> +               modes++;
> +               if (ifobj_zc_avail(ifobj_tx))
> +                       modes++;
> +       }
>
>         test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
>         tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index 12b792004163..a86331c6b0c5 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -61,6 +61,7 @@
>  enum test_mode {
>         TEST_MODE_SKB,
>         TEST_MODE_DRV,
> +       TEST_MODE_ZC,
>         TEST_MODE_MAX
>  };
>
> @@ -162,6 +163,7 @@ struct test_spec {
>         u16 current_step;
>         u16 nb_sockets;
>         bool fail;
> +       enum test_mode mode;
>         char name[MAX_TEST_NAME_SIZE];
>  };
>
> --
> 2.27.0
>
