Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EED51E162
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359636AbiEFVzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355406AbiEFVzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:55:09 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1766C6FA13;
        Fri,  6 May 2022 14:51:24 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id y11so5625004ilp.4;
        Fri, 06 May 2022 14:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0H4j188mYRcN8sQWXRd1WWvL0ISYSoT0RTO3h++GtuQ=;
        b=Vs2xhVj9PYXBDuBS0f/ikVUFzjYnQTstwaezXEJpVlnAHME/7NP/hlzk0r77I20ySs
         gPppbe8iXsA3fkm6wirqG6/KpEgQMZzEvJRNH1DpJ/fvVGJmXp0bgZW5ZmGEGa4DsRHL
         PsYWZLEx0I0WMfErH9FKAxr4J2Lxrk4Q6jzUt+iEFjk8swPqcGHFg4Fg2Ly5dUozuudv
         1jzgFSoJ6B5Oqs0pVGrQN4lTC0Z+fguPgkVqN5C63ymuKD/gZeA6SB9ZzNpmom36nIvE
         TS/82RFqct3zkg+N2NmmF0Boj11IW2A+wUPy2El35nuI56Zl0GrGD8XeRfM75+LZU3Ji
         NJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0H4j188mYRcN8sQWXRd1WWvL0ISYSoT0RTO3h++GtuQ=;
        b=0IcJ1YYDZL3szK7g1AzSJHgZxuQo69kx01PgZdtaKTHja3tyVf7ZgBw6GejEhU7g9F
         Re6usAmBu7D0HcZmfIeMmfD+J4onMgFsEgf+pSbb4Cf+CYjFGaum40Ij4rZRjGy7qNOm
         uO1ON7m6Ag8RmrhgRq5ZXw5dciPk5RqMGc7v8Tvcx7icNwQC9EdIxmHuEuJ3QgoAjJRT
         Yzi53dJhtshBWDNPM4qronUHhjF/ycSOh2NePAnze+7uLnYvWJiaWtSoCKfZcZfp603u
         d5BV7gkC1NLIJQTQpsvAryErvX00Qj2HHsr0L5/26Rxbb0HULaZ0mtMLf3c/J8LFZfXG
         1Mrg==
X-Gm-Message-State: AOAM531sdYaCODW42/sCKOSu6lWrsHKGfit+zcrSuyKcmVKZ70LCEIN4
        umtkDkKA4ydJhDbOJUHsyuMpFmwsUCPED6J5OpA=
X-Google-Smtp-Source: ABdhPJy538w8QL1UdWQu61v//rhuRVQiriUv8ahfZNQ3de36b/smTTpb2c3aib/Q6CWeXqjmIThBraihWSea0aQGjDE=
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id
 h2-20020a056e021b8200b002cf199f3b4bmr2090170ili.71.1651873883291; Fri, 06 May
 2022 14:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com>
In-Reply-To: <20220503171437.666326-1-maximmi@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 14:51:12 -0700
Message-ID: <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 0/5] New BPF helpers to accelerate synproxy
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
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
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
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

On Tue, May 3, 2022 at 10:14 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
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
> The last patch exposes the new helpers to TC BPF.
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
> [1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
> [2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
> [3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP
>
> Maxim Mikityanskiy (5):
>   bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
>   bpf: Allow helpers to accept pointers with a fixed size
>   bpf: Add helpers to issue and check SYN cookies in XDP
>   bpf: Add selftests for raw syncookie helpers
>   bpf: Allow the new syncookie helpers to work with SKBs
>

Is it expected that your selftests will fail on s390x? Please check [0]

  [0] https://github.com/kernel-patches/bpf/runs/6277764463?check_suite_focus=true#step:6:6130

>  include/linux/bpf.h                           |  10 +
>  include/net/tcp.h                             |   1 +
>  include/uapi/linux/bpf.h                      |  88 +-
>  kernel/bpf/verifier.c                         |  26 +-
>  net/core/filter.c                             | 128 +++
>  net/ipv4/tcp_input.c                          |   3 +-
>  scripts/bpf_doc.py                            |   4 +
>  tools/include/uapi/linux/bpf.h                |  88 +-
>  tools/testing/selftests/bpf/.gitignore        |   1 +
>  tools/testing/selftests/bpf/Makefile          |   5 +-
>  .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
>  .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
>  tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
>  13 files changed, 1761 insertions(+), 22 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>  create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>  create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
>
> --
> 2.30.2
>
