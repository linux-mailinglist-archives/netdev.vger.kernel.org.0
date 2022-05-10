Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FC522809
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 02:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiEJX76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239165AbiEJX7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:59:47 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2979D245622;
        Tue, 10 May 2022 16:59:46 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id y11so401410ilp.4;
        Tue, 10 May 2022 16:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5+/7AqLahlqgJLPyZPFZRgN5KrtHdAiASNn8Z0Zak9g=;
        b=U5MfSqCtkkUgBOqJKJ9jbCEVyj+sGK2vQ2wjUnOHKcdwKzbxQWiUwWDPUnzap6tV50
         eZlAZVorOiAysru1yrjE5mm2HaUrZYTUHUIqfgct12VNq5EcAof/sSaaGe9rXl7/X/H5
         r9BI1ywlJlrqMtXEd/uQ9lOfxoT+VxHxLgBPOp3kIoqDDKoXYUD4Gm9URmcrfcZGZ28P
         sFHVFvzKU0p11prpWCrUVQsbtBQCSBSibxXF95kcZ9UArcQTG117SlEJ+Qbwvqnva36X
         bH5fqeIMZINtAlhbJPnGNYpBjFj55XxpkFHS34eG2XFoMzarhsddJtuwg+a0X6INrD0g
         iOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5+/7AqLahlqgJLPyZPFZRgN5KrtHdAiASNn8Z0Zak9g=;
        b=1d7ThCexOfKKC9aVlqaurH7rUDHbHA6iutfwXLiKb39IYzSdrsRodbWITihXmnTpFJ
         6JHHB4HyOlXb9robulXaTanQaYilqrcprwB3AsgazM7lGSIWxQgPW1rIg+oiY4AVs1a6
         TXqWjA43eHJW7Isy6Qu4HuyZPEI3gCh1Svnz7S6xmtgNG7iFSr0IOaW/QxkS+/22cnPa
         b7AA0/PsXxX8wzcwrKnTVLl3UTIvL+uKVvZhAWCyzcrvJgRspfUVdwQUYeeqfr6jbCVh
         x8pN5bcIecX3rpx+a6qDuaVz4nWXdG6hpA4nnE5Bwg5eonptMbJ9TxeVDTi9thgzHH1a
         KxAw==
X-Gm-Message-State: AOAM5323Rib16x1ASEnFkl1C0Ww2PjVymlVXLOJUh02sreiUJHpCIQqX
        v7P5Gp13V1qvJcC+Uq03V9uOgFU/fLuZgklKB0U=
X-Google-Smtp-Source: ABdhPJwMsl29IMrQPQhpH42NWAlqRpyvuhP4i7KsfHqx2CFEzt5O1tWmjzNtsAQa1JW0rZgAicO3elopdr2Sg0Ro1YQ=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr10424392ilb.305.1652227185421; Tue, 10
 May 2022 16:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
 <a330e7d6-e064-5734-4430-9d7a3d141c04@nvidia.com>
In-Reply-To: <a330e7d6-e064-5734-4430-9d7a3d141c04@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 May 2022 16:59:34 -0700
Message-ID: <CAEf4BzYnVK_1J_m-W8UxfFZNhZ1BpbRs=zQWwN3eejvSBJRrXw@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:21 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2022-05-07 00:51, Andrii Nakryiko wrote:
> > On Tue, May 3, 2022 at 10:14 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >>
> >> The first patch of this series is a documentation fix.
> >>
> >> The second patch allows BPF helpers to accept memory regions of fixed
> >> size without doing runtime size checks.
> >>
> >> The two next patches add new functionality that allows XDP to
> >> accelerate iptables synproxy.
> >>
> >> v1 of this series [1] used to include a patch that exposed conntrack
> >> lookup to BPF using stable helpers. It was superseded by series [2] by
> >> Kumar Kartikeya Dwivedi, which implements this functionality using
> >> unstable helpers.
> >>
> >> The third patch adds new helpers to issue and check SYN cookies without
> >> binding to a socket, which is useful in the synproxy scenario.
> >>
> >> The fourth patch adds a selftest, which includes an XDP program and a
> >> userspace control application. The XDP program uses socketless SYN
> >> cookie helpers and queries conntrack status instead of socket status.
> >> The userspace control application allows to tune parameters of the XDP
> >> program. This program also serves as a minimal example of usage of the
> >> new functionality.
> >>
> >> The last patch exposes the new helpers to TC BPF.
> >>
> >> The draft of the new functionality was presented on Netdev 0x15 [3].
> >>
> >> v2 changes:
> >>
> >> Split into two series, submitted bugfixes to bpf, dropped the conntrack
> >> patches, implemented the timestamp cookie in BPF using bpf_loop, dropped
> >> the timestamp cookie patch.
> >>
> >> v3 changes:
> >>
> >> Moved some patches from bpf to bpf-next, dropped the patch that changed
> >> error codes, split the new helpers into IPv4/IPv6, added verifier
> >> functionality to accept memory regions of fixed size.
> >>
> >> v4 changes:
> >>
> >> Converted the selftest to the test_progs runner. Replaced some
> >> deprecated functions in xdp_synproxy userspace helper.
> >>
> >> v5 changes:
> >>
> >> Fixed a bug in the selftest. Added questionable functionality to support
> >> new helpers in TC BPF, added selftests for it.
> >>
> >> v6 changes:
> >>
> >> Wrap the new helpers themselves into #ifdef CONFIG_SYN_COOKIES, replaced
> >> fclose with pclose and fixed the MSS for IPv6 in the selftest.
> >>
> >> v7 changes:
> >>
> >> Fixed the off-by-one error in indices, changed the section name to
> >> "xdp", added missing kernel config options to vmtest in CI.
> >>
> >> v8 changes:
> >>
> >> Properly rebased, dropped the first patch (the same change was applied
> >> by someone else), updated the cover letter.
> >>
> >> v9 changes:
> >>
> >> Fixed selftests for no_alu32.
> >>
> >> [1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
> >> [2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
> >> [3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP
> >>
> >> Maxim Mikityanskiy (5):
> >>    bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
> >>    bpf: Allow helpers to accept pointers with a fixed size
> >>    bpf: Add helpers to issue and check SYN cookies in XDP
> >>    bpf: Add selftests for raw syncookie helpers
> >>    bpf: Allow the new syncookie helpers to work with SKBs
> >>
> >
> > Is it expected that your selftests will fail on s390x? Please check [0]
>
> I see it fails with:
>
> test_synproxy:FAIL:ethtool -K tmp0 tx off unexpected error: 32512 (errno 2)
>
> errno 2 is ENOENT, probably the ethtool binary is missing from the s390x
> image? When reviewing v6, you said you added ethtool to the CI image.
> Maybe it was added to x86_64 only? Could you add it to s390x?
>

Could be that it was outdated in s390x, but with [0] just merged in it
should have pretty recent one.

  [0] https://github.com/libbpf/ci/pull/16

> [1]:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220422172422.4037988-6-maximmi@nvidia.com/
>
> >    [0] https://github.com/kernel-patches/bpf/runs/6277764463?check_suite_focus=true#step:6:6130
> >
> >>   include/linux/bpf.h                           |  10 +
> >>   include/net/tcp.h                             |   1 +
> >>   include/uapi/linux/bpf.h                      |  88 +-
> >>   kernel/bpf/verifier.c                         |  26 +-
> >>   net/core/filter.c                             | 128 +++
> >>   net/ipv4/tcp_input.c                          |   3 +-
> >>   scripts/bpf_doc.py                            |   4 +
> >>   tools/include/uapi/linux/bpf.h                |  88 +-
> >>   tools/testing/selftests/bpf/.gitignore        |   1 +
> >>   tools/testing/selftests/bpf/Makefile          |   5 +-
> >>   .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
> >>   .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
> >>   tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
> >>   13 files changed, 1761 insertions(+), 22 deletions(-)
> >>   create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
> >>   create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> >>   create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
> >>
> >> --
> >> 2.30.2
> >>
>
