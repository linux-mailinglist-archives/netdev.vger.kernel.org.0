Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2074853E6
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiAEN5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240446AbiAEN5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:57:39 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CA7C061784
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 05:57:39 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d1so97710858ybh.6
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 05:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q8VC82293G3QI/P2kAIl5VJN7S08d7ZmIRunRrjYEoA=;
        b=AqGuah6QksnrhmrxMbulpI/61PSR00Oc4IDmCW5ib4li+2tqhH20IdW7wj6ygAxXL4
         fExIsJBeIIR1MBk3YjW9lY/OTXy4mrmFsciIVZ302iIHr7Q2Z0yh+LITMNHnXXYSeR9p
         iIqngnLfiGBiTr5DBnGRPI1cVoqeTYTAoMAg9pwFlAlATot0V0fA81H9efVSU3NzAs/4
         G8cCRUoBOryU9/Bzk+P2LMJr2Hgop8jq2EO6BJVU8UCeYApqFMA9UdkYwGK06oxyH65h
         qZ0pd7pAbc7mgESxKwMOW6Di+ca3zhC2pjm29G36O/8yKUqbDOHnwZd2rZrhsdxT7EZE
         2KYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q8VC82293G3QI/P2kAIl5VJN7S08d7ZmIRunRrjYEoA=;
        b=zxUsmqF4/TjSqExx4D+PEHKfa4HSeMzEzrUF6noRuyUG+84X4unkJTxC+yy6vIFnBI
         rU3TNGtL7c9CxEPSt9Z4Hctu9Ap8ykQ4xzpdN9lmeORdsdEdQl1q6oCoGKx/X340P3on
         6pqBJqp+ZnL3t0nxik0REMTj+0pXju0xwsdKt2OSnDMQJmw6hsYaVMSMSCydfyWtxefh
         ylh8/Vj+w70hMVwbJlkTZobLFJnEAv52e0fjMt/bBtblRbaWR9oZss8SAygIfeVJHaoB
         oOrJ7mqwi4F71TCeFKMZtrzYOKBx1Kmh4oefHZP8TV2Y60nHPM1jm582DybMPj4J9Bm6
         ITWg==
X-Gm-Message-State: AOAM530u6OGJp8dSCnwlf+hOXRTgvkKtsupFagaILMtee4nIZfIgkCgi
        5bkgZPkLHWQ0k5qKPwBFPa6Uemw/akmnA2ET4U1QWg==
X-Google-Smtp-Source: ABdhPJzWXFwL4M4RioBFZGKwwxrE/9qIDA5084D+/r9nJDVn4FK01peXlX2OqQ8TudAdR2uBavCeTXEOszbm61wDi+Q=
X-Received: by 2002:a25:824c:: with SMTP id d12mr54015007ybn.5.1641391058295;
 Wed, 05 Jan 2022 05:57:38 -0800 (PST)
MIME-Version: 1.0
References: <20220105131849.2559506-1-imagedong@tencent.com> <20220105131849.2559506-3-imagedong@tencent.com>
In-Reply-To: <20220105131849.2559506-3-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 5 Jan 2022 05:57:27 -0800
Message-ID: <CANn89iLMNK0Yo=5LmcV=NMLmAUEZsb1V__V5bY+ZNh347UE-xg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] bpf: selftests: add bind retry for
 post_bind{4, 6}
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 5:21 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> With previous patch, kernel is able to 'put_port' after sys_bind()
> fails. Add the test for that case: rebind another port after
> sys_bind() fails. If the bind success, it means previous bind
> operation is already undoed.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  tools/testing/selftests/bpf/test_sock.c | 166 +++++++++++++++++++++---
>  1 file changed, 146 insertions(+), 20 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
> index e8edd3dd3ec2..68525d68d4e5 100644
> --- a/tools/testing/selftests/bpf/test_sock.c
> +++ b/tools/testing/selftests/bpf/test_sock.c
> @@ -35,12 +35,15 @@ struct sock_test {
>         /* Endpoint to bind() to */
>         const char *ip;
>         unsigned short port;
> +       unsigned short port_retry;
>         /* Expected test result */
>         enum {
>                 LOAD_REJECT,
>                 ATTACH_REJECT,
>                 BIND_REJECT,
>                 SUCCESS,
> +               RETRY_SUCCESS,
> +               RETRY_REJECT
>         } result;
>  };
>
> @@ -60,6 +63,7 @@ static struct sock_test tests[] = {
>                 0,
>                 NULL,
>                 0,
> +               0,
>                 LOAD_REJECT,
>         },


I assume we tried C99 initializers here, and this failed for some reason ?

diff --git a/tools/testing/selftests/bpf/test_sock.c
b/tools/testing/selftests/bpf/test_sock.c
index e8edd3dd3ec2..b57ce9f3eabf 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -54,13 +54,13 @@ static struct sock_test tests[] = {
                        BPF_MOV64_IMM(BPF_REG_0, 1),
                        BPF_EXIT_INSN(),
                },
-               BPF_CGROUP_INET4_POST_BIND,
-               BPF_CGROUP_INET4_POST_BIND,
-               0,
-               0,
-               NULL,
-               0,
-               LOAD_REJECT,
+               .expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+               .attach_type = BPF_CGROUP_INET4_POST_BIND,
+               .domain = 0,
+               .type = 0,
+               .ip = NULL,
+               .port = 0,
+               .result = LOAD_REJECT,
        },
        {
                "bind4 load with invalid access: mark",
