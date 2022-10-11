Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5360E5FAA35
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJKBhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJKBhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:37:15 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62EE263C;
        Mon, 10 Oct 2022 18:37:14 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id nb11so28332982ejc.5;
        Mon, 10 Oct 2022 18:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b+Yl2DZ+J6gAjW0kiUvsxuGh/xCs2Xbm/tBRea3AtWc=;
        b=R4yirgRrxViNfYXko3FMHsvyhmv4eskQeQf/KbKB9IAspHNWQ+s+pLbamp4onNRNQN
         P0k1CE/RZ5CAE1mwjFHTitnNyWs6rwOoXyx+QJUmPQgPGojOg7dzKh7BC0sDW7JvztjY
         O129kYQB1NccdWkgIL6C11SA35kaR5fnpGjGhib4BVaddc42cAH7rAAhF0/gCGP5/IdL
         6DS7AEU+0FZRIqf1F19j3lXMP0jinh1wN3fb0iFvYBZVTYl9fme5lRLpdaxfoTiGA69L
         UqKDQSr30ztJZyZx97Btv52UtMjcMO9TXqsRHWx6AShdqB4OuzkmnHBRHZfJZ+l5wLZu
         V1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b+Yl2DZ+J6gAjW0kiUvsxuGh/xCs2Xbm/tBRea3AtWc=;
        b=mOIw5N/aMdsQY7czy464uxTsPfWBhJ5ShdxvR+dBqHUvrgKIC0Tk7Nj25HkKLCpaCr
         ZzfpJuPb/T9++h08P9FXmmb7XJhBMvGHuS8JN6Z3bZnbAvsna29n9OrEGXdc+on2kfZc
         iL+LEBNL22EhNCamWd0X9f8B+sCqCVSF/Yeq7i2ylLP9XnGoHnHQHpdRf7ADsTv7xGzY
         FKhmFB/4uiaW5fO5bh3tYqRNJhuGFYNQTHB2nV0Z+BdyQr/1VYkswKEBejWPfqKHrMck
         D6Vv1jt5bI3LlbdRoFS2NIZ1jD7+qs6aNjz3y/Q+XbDZgamsI57/dg7mxA+JSZT/m7pe
         DrfA==
X-Gm-Message-State: ACrzQf3pN01WVJlzskIQ9aT1gwwGsAxQkcOCHhre8fWEpRcAvXl9Tq6R
        BCE1HSwmvWW5KjTu6b3RXofb6u6HFGW51xa33aY=
X-Google-Smtp-Source: AMsMyM7p0SeQ0HEE3ryTc47S4y6Bmboqi6K/MY7qqJOcxwu3pSGzqa86fnSFDG6XlqPYL/zesyfFYmane2NtoJD0lo8=
X-Received: by 2002:a17:907:3fa9:b0:782:ed33:df8d with SMTP id
 hr41-20020a1709073fa900b00782ed33df8dmr17287226ejc.745.1665452233208; Mon, 10
 Oct 2022 18:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221010142553.776550-1-xukuohai@huawei.com>
In-Reply-To: <20221010142553.776550-1-xukuohai@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Oct 2022 18:37:00 -0700
Message-ID: <CAEf4Bzbt1_J=bzsSmO-xX=Ubi9UeGj8swQT7c1pZt_ay1npZhw@mail.gmail.com>
Subject: Re: [PATCH bpf v3 0/6] Fix bugs found by ASAN when running selftests
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
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
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
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

On Mon, Oct 10, 2022 at 7:08 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>

Thanks for the fixes! I left a few comments in a few patches, please
address those. But also
please provide a commit message, even if a single line one. Kernel
style dictates that the commit message shouldn't be empty.

And I think none of these fixes are critical enough to go to bpf tree,
please target bpf-next for next revision. Thanks.


> v3:
> - Fix error failure of case test_xdp_adjust_tail_grow exposed by this series
>
> v2: https://lore.kernel.org/bpf/20221010070454.577433-1-xukuohai@huaweicloud.com
> - Rebase and fix conflict
>
> v1: https://lore.kernel.org/bpf/20221009131830.395569-1-xukuohai@huaweicloud.com
>
> Xu Kuohai (6):
>   libbpf: Fix use-after-free in btf_dump_name_dups
>   libbpf: Fix memory leak in parse_usdt_arg()
>   selftests/bpf: Fix memory leak caused by not destroying skeleton
>   selftest/bpf: Fix memory leak in kprobe_multi_test
>   selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
>   selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
>
>  tools/lib/bpf/btf_dump.c                      | 47 +++++++++++----
>  tools/lib/bpf/usdt.c                          | 59 +++++++++++--------
>  .../bpf/prog_tests/kprobe_multi_test.c        | 17 +++---
>  .../selftests/bpf/prog_tests/map_kptr.c       |  3 +-
>  .../selftests/bpf/prog_tests/tracing_struct.c |  3 +-
>  .../bpf/prog_tests/xdp_adjust_tail.c          |  7 ++-
>  6 files changed, 86 insertions(+), 50 deletions(-)
>
> --
> 2.30.2
>
