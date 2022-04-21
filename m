Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78D150A06A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiDUNNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiDUNMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:12:36 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9C834BBF;
        Thu, 21 Apr 2022 06:09:45 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id 125so5197634iov.10;
        Thu, 21 Apr 2022 06:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a0DtEwhYObJ33sU3ZolNItRmpv0frGqYvqLtumj/aYA=;
        b=ZVoPqkPWClinBu+1sCzb9cwlYRsJ9ETZ+5QXefY3GldI6EXyGEj5K8OKLkRPCqsGcQ
         S2sGiJbEx3X5EgeDLMEkbdqGHU8Fewc9b9K16dGiacf0NqXJJ7yW9kFAVj889Qx5F6qB
         7yht1rdkcld2qcbmT0nOYa+piLLAs8HCx/anVvOaqRsClXV73jjbRZjMLcd6Ck65i0CU
         vY2dBbnTbCjJ8Ny8IC3jKFGiPNnvfhw8iRlpAhkMk3JhHjczRYqafy0t1y0kWytQv6wG
         kE69wRbAl1YdDXVzL/1C9cnEFSxU3xiOCNholGZZzeHKjQ8JIBcKaDeUc3gFy3nIiT0U
         eEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a0DtEwhYObJ33sU3ZolNItRmpv0frGqYvqLtumj/aYA=;
        b=PJW5Ykio12RLu2B/EHyE/PBPvp8uQqJg7lLnfmMlYdqzj7sh+AsLoTcqWkJy6yM8lZ
         y4qMMfpbUsD6N9Q43wV6P/+ODTdlGilzmsuy+pO/cvAA67aVQeb/BDemniXqFk2eGXro
         LNY8/zi4w1zZSt7yNDyBCf6LY3p9ISkBj/nTPZJuXyhUO7sbhK5lP9W9+UQtOL1Z/Jfh
         UERvLWE7w9VI3mi0jALxLhlAAyDC3L3UjyA7RPXnJybydR+PFaD3yyiKFggFCz8So9qc
         1QrHc6lAycGwTSxRtoQUPyvmcHqMAn8qNhboDrfurBaAUNkEPqRtDyItMzXMOajUibQk
         Jfng==
X-Gm-Message-State: AOAM5322TudFMzAmcPae3Pg4CAlX5ZRz5KBusMAeprVcbTItFXjbZbZY
        RgbCSTnPJWmf4pklpymzh+OImXQ6uNJlpVFEM04=
X-Google-Smtp-Source: ABdhPJzl4sRsq/HyyTl3Co5W+TD1HGEB9xghjLwTaDk1chu1lWVqLUthusZWMWXb3SBFQ+kK/HcbRNgRd5xfEen1qe0=
X-Received: by 2002:a05:6638:2104:b0:326:1e94:efa6 with SMTP id
 n4-20020a056638210400b003261e94efa6mr12833399jaj.234.1650546584701; Thu, 21
 Apr 2022 06:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220421130104.1582053-1-asavkov@redhat.com>
In-Reply-To: <20220421130104.1582053-1-asavkov@redhat.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 21 Apr 2022 21:09:08 +0800
Message-ID: <CALOAHbCX=f09bZ3uO050t==TL9Nm-K+F_s8JntP8BmXZJdGd_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix attach tests retcode checks
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Thu, Apr 21, 2022 at 9:01 PM Artem Savkov <asavkov@redhat.com> wrote:
>
> Switching to libbpf 1.0 API broke test_sock and test_sysctl as they
> check for return of bpf_prog_attach to be exactly -1. Switch the check
> to '< 0' instead.
>
> Fixes: b858ba8c52b6 ("selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>

Reviewed-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  tools/testing/selftests/bpf/test_sock.c   | 2 +-
>  tools/testing/selftests/bpf/test_sysctl.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
> index 6c4494076bbf..810c3740b2cc 100644
> --- a/tools/testing/selftests/bpf/test_sock.c
> +++ b/tools/testing/selftests/bpf/test_sock.c
> @@ -492,7 +492,7 @@ static int run_test_case(int cgfd, const struct sock_test *test)
>                         goto err;
>         }
>
> -       if (attach_sock_prog(cgfd, progfd, test->attach_type) == -1) {
> +       if (attach_sock_prog(cgfd, progfd, test->attach_type) < 0) {
>                 if (test->result == ATTACH_REJECT)
>                         goto out;
>                 else
> diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/selftests/bpf/test_sysctl.c
> index 5bae25ca19fb..57620e7c9048 100644
> --- a/tools/testing/selftests/bpf/test_sysctl.c
> +++ b/tools/testing/selftests/bpf/test_sysctl.c
> @@ -1560,7 +1560,7 @@ static int run_test_case(int cgfd, struct sysctl_test *test)
>                         goto err;
>         }
>
> -       if (bpf_prog_attach(progfd, cgfd, atype, BPF_F_ALLOW_OVERRIDE) == -1) {
> +       if (bpf_prog_attach(progfd, cgfd, atype, BPF_F_ALLOW_OVERRIDE) < 0) {
>                 if (test->result == ATTACH_REJECT)
>                         goto out;
>                 else
> --
> 2.35.1
>


-- 
Regards
Yafang
