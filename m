Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F966D445B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjDCMZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjDCMZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:25:35 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F80F11669;
        Mon,  3 Apr 2023 05:25:30 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5463fa0c2bfso217654617b3.1;
        Mon, 03 Apr 2023 05:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680524729;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wrxNT3T7Ko3Ffo0om2m2atTAcgZ2iipxGV6gZ7LmlEM=;
        b=TRPqrm31yGQxx6HqvbPpJ/mjZckDgoUJnRqoZ9+eXYRshO+N/uP7/N1+sHDDMqyEpr
         9ppAdiHfDdNgNj8UmiFr27EbhQ9DSNYyT4QjzlT20wNCEwWTzjgGy7vpRSP2Czuh+B96
         NFm2QJbZVNHLrcwV1mNW5OC8NrfpM5dr1HftMvnR4DiZA4fmbwi3Sh424Pa6jIktqMCv
         CAxqJcoVyE0chK3VFSjFeYfKhp+jF9Rvn37+kKfYXaci9FI6gXgPYQO/dWUsKURdLIaT
         FL0tmTbpdCDQIL+CWZXcFGNNQE2ihfiHb+mJoxrmSGcavoIMcU57ra08VypRxsIGyXHP
         MxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680524729;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wrxNT3T7Ko3Ffo0om2m2atTAcgZ2iipxGV6gZ7LmlEM=;
        b=HBlRz9TYW6EgHiWLvyXMAZsJ+abBfaAR7f6rnn6ESayoMFP7ryyl/cv5GC4hD1t/dN
         8l/kx/Voo1xf0YJoN6AgGpQ2KaZFmip1BoiArxkRPDuHMzX82CaYTQ9AWiHHayFLz9pI
         /wtIRFgpJmOeDtaTuKuN+H6Umy9Csb3mqc2r18TVuy/rIFyAeRIh27W4aIAbbuYgCriI
         ZiNTlSoErd5ehEEIWFVI8e8EV6a0LSYsXVcbw2RtN18rXzm1f2+aQz3ILQWfG6lue6d3
         qDpEqtSEKjKw8kpVS0Ofn5O8faEsP4/A7mOQI9t1IuRw0Xfkp5eue/nP3gcW/gG68DM7
         raYg==
X-Gm-Message-State: AAQBX9fUNsFZQ0BbzjaSpiji9xScvfLoy7NpjId6ZwktEK3LDkzXYw88
        0kxL0AfOVpVGlm2IAi1W06K9k+oi95kr7/C7+khmsQJzNh8KmxEq
X-Google-Smtp-Source: AKy350bgo3DeUzBwHQucu8jAnInJaNAqvFim+1vy82DIp2k3HaY0dRNVy3D+izvuXktB0K9yMx3dGYUwBk6g2sgx4N4=
X-Received: by 2002:a81:ae60:0:b0:546:5f4d:c002 with SMTP id
 g32-20020a81ae60000000b005465f4dc002mr4303907ywk.10.1680524729206; Mon, 03
 Apr 2023 05:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com> <20230329180502.1884307-8-kal.conley@dectris.com>
In-Reply-To: <20230329180502.1884307-8-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 3 Apr 2023 14:25:18 +0200
Message-ID: <CAJ8uoz2crsRkuCNPxrpBc0oZwgeprboVQW8Zxh-9CWHb_Ze4Hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/10] selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 at 20:12, Kal Conley <kal.conley@dectris.com> wrote:
>
> Add unaligned descriptor test for frame size of 4001. Using an odd frame
> size ensures that the end of the UMEM is not near a page boundary. This
> allows testing descriptors that staddle the end of the UMEM but not a

nit: straddle

> page.
>
> This test used to fail without the previous commit ("xsk: Add check for
> unaligned descriptors that overrun UMEM").
>
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 25 ++++++++++++++++++++++++
>  tools/testing/selftests/bpf/xskxceiver.h |  1 +
>  2 files changed, 26 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 1a4bdd5aa78c..9b9efd0e0a4c 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -69,6 +69,7 @@
>   */
>
>  #define _GNU_SOURCE
> +#include <assert.h>
>  #include <fcntl.h>
>  #include <errno.h>
>  #include <getopt.h>
> @@ -1876,6 +1877,30 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>                 test->ifobj_rx->umem->unaligned_mode = true;
>                 testapp_invalid_desc(test);
>                 break;
> +       case TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME:
> +               if (!hugepages_present(test->ifobj_tx)) {
> +                       ksft_test_result_skip("No 2M huge pages present.\n");
> +                       return;
> +               }
> +               test_spec_set_name(test, "UNALIGNED_INV_DESC_4K1_FRAME_SIZE");
> +               /* Odd frame size so the UMEM doesn't end near a page boundary. */
> +               test->ifobj_tx->umem->frame_size = 4001;
> +               test->ifobj_rx->umem->frame_size = 4001;
> +               test->ifobj_tx->umem->unaligned_mode = true;
> +               test->ifobj_rx->umem->unaligned_mode = true;
> +               /* This test exists to test descriptors that staddle the end of

nit: straddle

> +                * the UMEM but not a page.
> +                */
> +               {
> +                       u64 umem_size = test->ifobj_tx->umem->num_frames *
> +                                       test->ifobj_tx->umem->frame_size;
> +                       u64 page_size = sysconf(_SC_PAGESIZE);
> +
> +                       assert(umem_size % page_size > PKT_SIZE);
> +                       assert(umem_size % page_size < page_size - PKT_SIZE);
> +               }
> +               testapp_invalid_desc(test);

Please put this code in a function that you call. Declare your local
variables in the beginning of that function.

> +               break;
>         case TEST_TYPE_UNALIGNED:
>                 if (!testapp_unaligned(test))
>                         return;
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index cc24ab72f3ff..919327807a4e 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -78,6 +78,7 @@ enum test_type {
>         TEST_TYPE_ALIGNED_INV_DESC,
>         TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
>         TEST_TYPE_UNALIGNED_INV_DESC,
> +       TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME,
>         TEST_TYPE_HEADROOM,
>         TEST_TYPE_TEARDOWN,
>         TEST_TYPE_BIDI,
> --
> 2.39.2
>
