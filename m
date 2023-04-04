Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D0D6D58C6
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjDDG2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbjDDG2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:28:05 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E49C173F;
        Mon,  3 Apr 2023 23:27:58 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i6so37476363ybu.8;
        Mon, 03 Apr 2023 23:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680589677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lzWN5mh4zjKBZuiFgyH01Fx6pM7fAr76VE1bFCrLAFI=;
        b=Oj5/jF3QUtvmOAGyfveHAHWJ7xxodGK7Ikzf4AU/tl7uoZb9RCrSm/Asv4kbIY0Q2A
         cKCaT3jCz/0QKRPp3rFtwSmPurEI/vkmxW8SR8YtLzQs11UPDE7QMkO/fNkFZ/yQCgBA
         Zt6tfz4G/61dzTQ9GZeYpMwZ5pbzvnB/gkwRc6QHGSZVD38vD0ABIADNilV+s8AtLdGw
         tmmeDiQ/u4fBsyg3h4sgWQqmoPRlR/Fnv6VT4mMTo++eDfzHt6TAjiRyGEleuzR+Vk/A
         /g0UdQPQu6BYEFekSqgOPoHxB5lLYNG+DIBOoDplHVuYUU6IJtSFP5jvM/nqTQ66hv2i
         8Ifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lzWN5mh4zjKBZuiFgyH01Fx6pM7fAr76VE1bFCrLAFI=;
        b=3hXfSS6iapTWc02rXTJvFzNKDPOl0tBgmTSmx6XU+8OMGQHBjLQCpWxmIF1r+YMawy
         f+Rli/RrJYgMabZ5iFdUrdb+IqzWbnNWaHPliYCcgt9AL3JIlaWYz4NhuUV83lgo3t2V
         MIgmts/dCS53a1Eqak2dS/hyOM+xNxgCAMS6obwgLJuq0cOgiy/i5JN+txUI66DTZ7DT
         1GDYMgM/TTOHMWdA6ajozpwTeqPJaEwc1NOR52hG4Wy26w13qzBhGGMqz5XiJ9DKI9K2
         Ql66wL7BaeulOEX9m4QStNm+DgTPh54t6rtLugSGQbIN6uwHzEaXkMjAK7od88jWQqWG
         HFPA==
X-Gm-Message-State: AAQBX9eiRl8aZrYJ1Hwp9an4vAu014seysJ3ohay7aCimH2xalide3Ym
        Ffsbe/u4VQbvO02s61vuerW8RbRK1bHJxuaS0/s=
X-Google-Smtp-Source: AKy350ZcJPFzls7MRlRH+dlf6brGLsson0bLOy8vu2pC+W7UqBj1ShnvivhrW6T5IgUqnFhzc434Sd2sE444ABAQb/o=
X-Received: by 2002:a25:74c4:0:b0:b6a:2590:6c63 with SMTP id
 p187-20020a2574c4000000b00b6a25906c63mr1082914ybc.2.1680589677566; Mon, 03
 Apr 2023 23:27:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230403145047.33065-1-kal.conley@dectris.com> <20230403145047.33065-3-kal.conley@dectris.com>
In-Reply-To: <20230403145047.33065-3-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 08:27:46 +0200
Message-ID: <CAJ8uoz31-=tvN_eCfxYRS8bWkgFSj=BE6oy5uLmq6UmTGys4ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests: xsk: Add test case for packets at
 end of UMEM
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
> Add test case to testapp_invalid_desc for valid packets at the end of
> the UMEM.

Thanks.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 3956f5db84f3..34a1f32fe752 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1662,6 +1662,8 @@ static void testapp_invalid_desc(struct test_spec *test)
>                 {-2, PKT_SIZE, 0, false},
>                 /* Packet too large */
>                 {0x2000, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
> +               /* Up to end of umem allowed */
> +               {umem_size - PKT_SIZE, PKT_SIZE, 0, true},
>                 /* After umem ends */
>                 {umem_size, PKT_SIZE, 0, false},
>                 /* Straddle the end of umem */
> @@ -1675,16 +1677,17 @@ static void testapp_invalid_desc(struct test_spec *test)
>
>         if (test->ifobj_tx->umem->unaligned_mode) {
>                 /* Crossing a page boundrary allowed */
> -               pkts[6].valid = true;
> +               pkts[7].valid = true;
>         }
>         if (test->ifobj_tx->umem->frame_size == XSK_UMEM__DEFAULT_FRAME_SIZE / 2) {
>                 /* Crossing a 2K frame size boundrary not allowed */
> -               pkts[7].valid = false;
> +               pkts[8].valid = false;
>         }
>
>         if (test->ifobj_tx->shared_umem) {
>                 pkts[4].addr += umem_size;
>                 pkts[5].addr += umem_size;
> +               pkts[6].addr += umem_size;
>         }
>
>         pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
> --
> 2.39.2
>
