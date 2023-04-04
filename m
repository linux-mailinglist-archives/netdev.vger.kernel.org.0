Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D8F6D58C0
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbjDDG0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjDDG0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:26:47 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F1819BF;
        Mon,  3 Apr 2023 23:26:46 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5491fa028adso99257297b3.10;
        Mon, 03 Apr 2023 23:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680589605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W4uNHmMt7Ws5Uah4Jl5aAqQS63Y/YU5rFIc2W/o+vMk=;
        b=Nq4e4ll0yw4HQTz5WuLZyxBmGMcbgx5W/upOV3cUgJP4PnUgPoVN+IaPvgk65Q4Rqu
         pbHmHOfiHc9lUwuuvUqwMhYM1JNVKCHAPwHAPv54g6VYM0BX9CGOgrmPPiuuwGLpUYEq
         Y39TjwFG2262t+pmjM4eA9UpbTvh8EB31L/3TDdgutTWUjoW7UaB0JzdmgX8zfUb9qBe
         HkJQ86lSE6AGBOopenPoRm63bdyT3uayvwn041FRPg4mwlCEUR8A7TUwM6l4Am8ij6sx
         +E85g+heyeh3SS7knaINXD5dH7zbnaMcaBCQvUxAE1HdRNFEuveFrKHkZrCKTotOj6rh
         wRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W4uNHmMt7Ws5Uah4Jl5aAqQS63Y/YU5rFIc2W/o+vMk=;
        b=omiIH+p3s2atbD5jKyDV4t+ZXyx8dL19kHTupty1dJoaox+pjNL4jZmZHcvoNFi09K
         edtO9qJWkSCzTMImLCluUCsQk9+DzPB3pBNs7GtjA/X9vMi0ktbz9TPxWIITlMiZj4sU
         y8Nk+A4yyZKukcIbs1F1YbYfq8KyOHss771NC0f0+V1wHZJ8/jg9HXbzsd/Te19AC5un
         H1K1ZlTB7ARSMwcr7JDSdIwtSyMrz8AgQuyVyIeJCmTSsMzl9uqoNDpyZCCMCEAu40IC
         B0DGJRxTWOTZ8/6mUco9ph0Tnd29h+7crjNFW6w4NJt3tLZeLKsOOO0uAuXDsysFCEjW
         z2eQ==
X-Gm-Message-State: AAQBX9fm0cvNBFnBStDu0I97sSmlj5SF1x1eje4SchsigANr3ZEqsE0i
        vbzZzLfmVFjXTuJXFqOWMIuR36KXASxw58lRq+I=
X-Google-Smtp-Source: AKy350bpEI38oRymOMCyBUHz7DjGSR94OFCytrUim5NwwX+uUHPrkWnLZ3e3FE5WzHtkDk4+0SwpgzrekwKOE34N38s=
X-Received: by 2002:a81:a804:0:b0:549:1e80:41f9 with SMTP id
 f4-20020a81a804000000b005491e8041f9mr844611ywh.10.1680589605352; Mon, 03 Apr
 2023 23:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230403145047.33065-1-kal.conley@dectris.com> <20230403145047.33065-2-kal.conley@dectris.com>
In-Reply-To: <20230403145047.33065-2-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 08:26:34 +0200
Message-ID: <CAJ8uoz3HkNJZBy8bE-6-C2Hv25c230nED1Nw_eK43x5bmQBfGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] selftests: xsk: Use correct UMEM size in testapp_invalid_desc
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 3 Apr 2023 at 16:52, Kal Conley <kal.conley@dectris.com> wrote:
>
> Avoid UMEM_SIZE macro in testapp_invalid_desc which is incorrect when
> the frame size is not XSK_UMEM__DEFAULT_FRAME_SIZE. Also remove the
> macro since it's no longer being used.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 909f0e28207c ("selftests: xsk: Add tests for 2K frame size")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 9 +++++----
>  tools/testing/selftests/bpf/xskxceiver.h | 1 -
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index b65e0645b0cd..3956f5db84f3 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1652,6 +1652,7 @@ static void testapp_single_pkt(struct test_spec *test)
>
>  static void testapp_invalid_desc(struct test_spec *test)
>  {
> +       u64 umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
>         struct pkt pkts[] = {
>                 /* Zero packet address allowed */
>                 {0, PKT_SIZE, 0, true},
> @@ -1662,9 +1663,9 @@ static void testapp_invalid_desc(struct test_spec *test)
>                 /* Packet too large */
>                 {0x2000, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
>                 /* After umem ends */
> -               {UMEM_SIZE, PKT_SIZE, 0, false},
> +               {umem_size, PKT_SIZE, 0, false},
>                 /* Straddle the end of umem */
> -               {UMEM_SIZE - PKT_SIZE / 2, PKT_SIZE, 0, false},
> +               {umem_size - PKT_SIZE / 2, PKT_SIZE, 0, false},
>                 /* Straddle a page boundrary */
>                 {0x3000 - PKT_SIZE / 2, PKT_SIZE, 0, false},
>                 /* Straddle a 2K boundrary */
> @@ -1682,8 +1683,8 @@ static void testapp_invalid_desc(struct test_spec *test)
>         }
>
>         if (test->ifobj_tx->shared_umem) {
> -               pkts[4].addr += UMEM_SIZE;
> -               pkts[5].addr += UMEM_SIZE;
> +               pkts[4].addr += umem_size;
> +               pkts[5].addr += umem_size;
>         }
>
>         pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index bdb4efedf3a9..cc24ab72f3ff 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -53,7 +53,6 @@
>  #define THREAD_TMOUT 3
>  #define DEFAULT_PKT_CNT (4 * 1024)
>  #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
> -#define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
>  #define RX_FULL_RXQSIZE 32
>  #define UMEM_HEADROOM_TEST_SIZE 128
>  #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
> --
> 2.39.2
>
