Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2054C271
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 09:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344062AbiFOHJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 03:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350237AbiFOHJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 03:09:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675FD4889A;
        Wed, 15 Jun 2022 00:09:38 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r5so3884241pgr.3;
        Wed, 15 Jun 2022 00:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=83CVEHvqNE/X4RTxQ8uCPMP2LL5z+2Kjinm2UOsurpY=;
        b=gU+z/EOiUx+sHTA7FrbTdBPSHwEXS+uRwwrAocFf5ngy6hjHYuSE/kkNlt5AhU5i8X
         P5Rl0wLlRN16NmgLLYVXhpTATm5G+egSvWeUoxgMzCjlrc1SffXKPQPaMc3wS0f8ugZX
         WX8zWTdA6r74q3blYTlfCm8J2Qnwb2abulzBNgGbgCDbdpWDmodoKARx3SD+KHso1ueY
         pOA7iRNOU9rxzWtWB0TTIjdqb0p7yoF5GTM2kj2mjn7NbZ5LIHDKAn8kQL2vqDedP+72
         s2aXGG7p9R9Lx8O0ZZmpvtFvcgUIqi0b9fMyvBHCygxcIB+0a8Ur1IOKhucDlnPT4FOd
         I2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=83CVEHvqNE/X4RTxQ8uCPMP2LL5z+2Kjinm2UOsurpY=;
        b=y4yxu3ANDZbrHvL8TzNWe4W2wMIdhtYfGfKb/LaEWPKGNLkjiV7FQu+3r0Bu3C4UcD
         E9z3hZldJZct503MqRu73Hj63vMK3N5HGEIyPCfZhsq8fq/oRqXzFaNlWaXvfQuLHRuE
         0GtaJPshokgcPmlwKQbZYoDexjTsVsNyGIFoiODyH9BWbtihbGTzvKIOEq5epHRi8/Nx
         r+qNN1Cza5GfG0zWi8PzGsBBbpeK+zagKqLtRmxs4RMqOHgNAp0z9Bz6ImzgIVO9CDKz
         8IQx37DmYX5vBLxYjYe9qIZDl6EecpOco9EHoMpIVCx8xY5ryChBkFUGLrKhNm1OY9Dk
         f4GQ==
X-Gm-Message-State: AOAM531iF9xqJzlPOwWnwsTutZQ1eyaqDDqVVRv6hW7ReCgnwQdsKLWP
        zPHhVqSAw+GUUm+w6vRRLDrHLNLvNzGMVMge7mhjfwBEMxUxOw==
X-Google-Smtp-Source: ABdhPJzhMpdSm6KU8QYTrBekAgg+Ua1wNLMUgGnp9nSArnJ4LsQTnUe9MnyDEbK4OQvPHhVcFn+Txv+/yfGJ6UXwoqQ=
X-Received: by 2002:a62:de84:0:b0:51b:e34b:ed2e with SMTP id
 h126-20020a62de84000000b0051be34bed2emr8570897pfg.86.1655276977807; Wed, 15
 Jun 2022 00:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com> <20220614174749.901044-11-maciej.fijalkowski@intel.com>
In-Reply-To: <20220614174749.901044-11-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 15 Jun 2022 09:09:26 +0200
Message-ID: <CAJ8uoz3=qFvvmuVM5hdvRp2mUnTh8P_UGhkueUxZ+LNN-bmuqQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/10] selftests: xsk: add support for zero
 copy testing
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

On Tue, Jun 14, 2022 at 7:51 PM Maciej Fijalkowski
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

And again, thanks for working on this. This feature will be very
useful to increase test coverage.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 76 ++++++++++++++++++++++--
>  tools/testing/selftests/bpf/xdpxceiver.h |  2 +
>  2 files changed, 74 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index ade9d87e7a7c..66bfb365b656 100644
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
> @@ -317,6 +328,51 @@ static int __xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_i
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
> +       ifobject->xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +       ifobject->xdp_flags |= XDP_FLAGS_DRV_MODE;
> +       ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
> +       ifobject->rx_on = true;
> +       xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> +       ret = __xsk_configure_socket(xsk, umem, ifobject, false);
> +       if (!ret)
> +               zc_avail = true;
> +
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
> @@ -483,9 +539,14 @@ static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
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
> @@ -1543,6 +1604,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
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
> @@ -1721,8 +1786,11 @@ int main(int argc, char **argv)
>         init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
>                    worker_testapp_validate_rx);
>
> -       if (is_xdp_supported(ifobj_tx))
> +       if (is_xdp_supported(ifobj_tx)) {
>                 modes++;
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
