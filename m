Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0071854F04B
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 06:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380012AbiFQEjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 00:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiFQEjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 00:39:15 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B94A5C35D;
        Thu, 16 Jun 2022 21:39:10 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x5so4681862edi.2;
        Thu, 16 Jun 2022 21:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCQ0Od0tcwJbvHdyyHIfxbGAHrqBA+XAak6iXg8kQ0E=;
        b=ihbD6OvPl6LT4redci0P+Jkfk4DyCsIGqF4w/P+dRK0zJOa+xhWE2bcRMUcmGb9YxF
         B/OL90/U065R8mCuHuzW0kuj7C0t/y/9qkXRRkgm90feXUXna6SRKd33qm+H9G98DZsZ
         gIhW2XFle5jCoitKXJ4dHMExLAbwTrunrxP2Nd1uqBql+6nKsocRWVS/RuixI4owZKmP
         ZUDPqvbfxuCx0K92adji7fndgkP3h7QRbl5iDPCLJEPmIQj/9VA+HpHPNXPCo5ROwtd6
         /uGeFLw822g7m0Cp7lM1/hqx56bMfHrcDkxAhIweNnzxYl5zqsXV7NUXu15kBr8ahoOS
         KEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCQ0Od0tcwJbvHdyyHIfxbGAHrqBA+XAak6iXg8kQ0E=;
        b=nx9UJ70ih0mI3i75KtqtujjrrWwqZcf9Cn1GUxt5VzNq5HzOJ/dDfquXnf48gEAjaY
         3HPKflZgE4nMDnLZZP9FwDD5jvTzUDXDdu/LvMfiqq8Ezklj8QCWmLgPTulFUGSb6Px2
         23PNRSEjxg56jGSOjpoZBaMLdGLVUdxjMo5IgYeMsERZtc8+J+gyJDmfg5wHGOb90Sr+
         8l1Y2rURK8Y1HkSzq0ntteBludbzjTxZYsEdI9j+IdPVLWp9uFdJiJvTyIxLsROzHhwe
         kEmjFQl+Hmy6/IuLSwA3eFEezZOIuyNWEqkCil0cRB8tD99EnWZufLXytNzhPXJ/3sDo
         kQjg==
X-Gm-Message-State: AJIora+rzULlKuScPVOAM/nNqknUL2zmV0Ssv0mf8pbkSOoVG/bcrULN
        xdsr5qfAGgNUv92npPTFPLrAqLP9B/TdL3rXIs8=
X-Google-Smtp-Source: AGRyM1sJUjTLrrA5uQ1nu7507WovaGSCZ6Lgw7F/iNrUMVbJlZD90bNqpIN4Lt+N+8ThvvJeekhfx9m6ewEWVQKgA9s=
X-Received: by 2002:a05:6402:56:b0:431:6f7b:533 with SMTP id
 f22-20020a056402005600b004316f7b0533mr10180371edu.333.1655440748678; Thu, 16
 Jun 2022 21:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220615134847.3753567-1-maximmi@nvidia.com>
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Jun 2022 21:38:57 -0700
Message-ID: <CAADnVQKR1BJPdW6U+HUhoS5k-6YSJs5w1HBF6Gg7oaVjsqqVOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 0/6] New BPF helpers to accelerate synproxy
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
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

On Wed, Jun 15, 2022 at 6:49 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> The first patch of this series is a documentation fix.
>
> The second patch allows BPF helpers to accept memory regions of fixed
> size without doing runtime size checks.
>
> The two next patches add new functionality that allows XDP to
> accelerate iptables synproxy.
>
> v1 of this series [1] used to include a patch that exposed conntrack
> lookup to BPF using stable helpers. It was superseded by series [2] by
> Kumar Kartikeya Dwivedi, which implements this functionality using
> unstable helpers.
>
> The third patch adds new helpers to issue and check SYN cookies without
> binding to a socket, which is useful in the synproxy scenario.
>
> The fourth patch adds a selftest, which includes an XDP program and a
> userspace control application. The XDP program uses socketless SYN
> cookie helpers and queries conntrack status instead of socket status.
> The userspace control application allows to tune parameters of the XDP
> program. This program also serves as a minimal example of usage of the
> new functionality.
>
> The last two patches expose the new helpers to TC BPF and extend the
> selftest.
>
> The draft of the new functionality was presented on Netdev 0x15 [3].
>
> v2 changes:
>
> Split into two series, submitted bugfixes to bpf, dropped the conntrack
> patches, implemented the timestamp cookie in BPF using bpf_loop, dropped
> the timestamp cookie patch.
>
> v3 changes:
>
> Moved some patches from bpf to bpf-next, dropped the patch that changed
> error codes, split the new helpers into IPv4/IPv6, added verifier
> functionality to accept memory regions of fixed size.
>
> v4 changes:
>
> Converted the selftest to the test_progs runner. Replaced some
> deprecated functions in xdp_synproxy userspace helper.
>
> v5 changes:
>
> Fixed a bug in the selftest. Added questionable functionality to support
> new helpers in TC BPF, added selftests for it.
>
> v6 changes:
>
> Wrap the new helpers themselves into #ifdef CONFIG_SYN_COOKIES, replaced
> fclose with pclose and fixed the MSS for IPv6 in the selftest.
>
> v7 changes:
>
> Fixed the off-by-one error in indices, changed the section name to
> "xdp", added missing kernel config options to vmtest in CI.
>
> v8 changes:
>
> Properly rebased, dropped the first patch (the same change was applied
> by someone else), updated the cover letter.
>
> v9 changes:
>
> Fixed selftests for no_alu32.
>
> v10 changes:
>
> Selftests for s390x were blacklisted due to lack of support of kfunc,
> rebased the series, split selftests to separate commits, created
> ARG_PTR_TO_FIXED_SIZE_MEM and packed arg_size, addressed the rest of
> comments.

Applied.
Please follow up with a patch to add:
CONFIG_NETFILTER_SYNPROXY=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_SYNPROXY=y
CONFIG_IP_NF_RAW=y

to selftests/bpf/config.

Otherwise folks will not know what to enable when they see
test_synproxy:FAIL:iptables -t raw -I PREROUTING         -i tmp1 -p
tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 256
(errno 22)
