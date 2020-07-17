Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E692240B7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgGQQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgGQQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:40:45 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A452C0619D3
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 09:40:45 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id e4so8515920oib.1
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 09:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XyLnyg1PcEtr0b26BjQvtEbRpMQtLSFLG4TqM/P0nok=;
        b=YItJGESL/JxBEjr1lXcZSeopPzPrS0gePs+2ubjOp58adcU8NoHR2FI4aAT9EnAK3m
         /tX5StfrDG23ITdKK0MlBI3D+ScZunDC5VMA86gHUF9gyOzcSmBRf3RiagD1Phax2FBO
         fSZiUNS+dUqhIm39s5EWUrniElEdqI7wEwBmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XyLnyg1PcEtr0b26BjQvtEbRpMQtLSFLG4TqM/P0nok=;
        b=ACftA664rwpnBjMPXBbV+TYqfDqqpYE0smN+FTy/OWrEAy+SDREpjM/fUTKCeGqlwa
         pcNUDsncqU+ZD5KUHK7hsRvjtmHyh3ZyPL40ZJB7+zoNsrgiUlhPTk3BrFznah92KB7d
         62i2cBUNx9RZ/e0MskJ1viJKQpkPnptEb/kFIa126D5q3k2GM3RkUjiSm39KY2s46HIw
         uChC7SVevlhKzFdy25ARcvRJWUcPofo/RC5nXClrOk3kTCzkOEh8+xAdmH3boluJDLxv
         DUV0kPSBgiGUp82X1n3hyOx63vs4kcTcYXPoEeGO9T7P6TC6uiP+kp61LwAAtrpXXUA4
         sDyw==
X-Gm-Message-State: AOAM531B+GtXgW9Gp19krxGbgo06qyRqSlziEb3JxHM74levIgpXpLcZ
        zKtBKINmvGb+TQiEcWMupY20pHJJva8s6gfeJ9pWMQ==
X-Google-Smtp-Source: ABdhPJxX1eJJ4ArSE4X3pCInxM8Z6JZ9XLZIfg5+vSuRreXx8U5GWCQ1+yx+TpK5ZnT8smmxuN5pFFA+KjTBN6HEGRM=
X-Received: by 2002:a05:6808:34e:: with SMTP id j14mr2864388oie.110.1595004044743;
 Fri, 17 Jul 2020 09:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200717103536.397595-1-jakub@cloudflare.com>
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 17 Jul 2020 17:40:33 +0100
Message-ID: <CACAyw9_6FGzFxN9OfhGpYLNFQafPb-t_mv5E6tc5Qpzm0nwmWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/15] Run a BPF program on socket lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 at 11:35, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Changelog
> =========
> v4 -> v5:
> - Enforce BPF prog return value to be SK_DROP or SK_PASS. (Andrii)
> - Simplify prog runners now that only SK_DROP/PASS can be returned.
> - Enable bpf_perf_event_output from the start. (Andrii)
> - Drop patch
>   "selftests/bpf: Rename test_sk_lookup_kern.c to test_ref_track_kern.c"
> - Remove tests for narrow loads from context at an offset wider in size
>   than target field, while we are discussing how to fix it:
>   https://lore.kernel.org/bpf/20200710173123.427983-1-jakub@cloudflare.com/
> - Rebase onto recent bpf-next (bfdfa51702de)
> - Other minor changes called out in per-patch changelogs,
>   see patches: 2, 4, 6, 13-15
> - Carried over Andrii's Acks where nothing changed.
>
> v3 -> v4:
> - Reduce BPF prog return codes to SK_DROP/SK_PASS (Lorenz)
> - Default to drop on illegal return value from BPF prog (Lorenz)
> - Extend bpf_sk_assign to accept NULL socket pointer.
> - Switch to saner return values and add docs for new prog_array API (Andrii)
> - Add support for narrow loads from BPF context fields (Yonghong)
> - Fix broken build when IPv6 is compiled as a module (kernel test robot)
> - Fix null/wild-ptr-deref on BPF context access
> - Rebase to recent bpf-next (eef8a42d6ce0)
> - Other minor changes called out in per-patch changelogs,
>   see patches 1-2, 4, 6, 8, 10-12, 14, 16
>
> v2 -> v3:
> - Switch to link-based program attachment
> - Support for multi-prog attachment
> - Ability to skip reuseport socket selection
> - Code on RX path is guarded by a static key
> - struct in6_addr's are no longer copied into BPF prog context
> - BPF prog context is initialized as late as possible
> - Changes called out in patches 1-2, 4, 6, 8, 10-14, 16
> - Patches dropped:
>   01/17 flow_dissector: Extract attach/detach/query helpers
>   03/17 inet: Store layer 4 protocol in inet_hashinfo
>   08/17 udp: Store layer 4 protocol in udp_table
>
> v1 -> v2:
> - Changes called out in patches 2, 13-15, 17
> - Rebase to recent bpf-next (b4563facdcae)
>
> RFCv2 -> v1:
>
> - Switch to fetching a socket from a map and selecting a socket with
>   bpf_sk_assign, instead of having a dedicated helper that does both.
> - Run reuseport logic on sockets selected by BPF sk_lookup.
> - Allow BPF sk_lookup to fail the lookup with no match.
> - Go back to having just 2 hash table lookups in UDP.
>
> RFCv1 -> RFCv2:
>
> - Make socket lookup redirection map-based. BPF program now uses a
>   dedicated helper and a SOCKARRAY map to select the socket to redirect to.
>   A consequence of this change is that bpf_inet_lookup context is now
>   read-only.
> - Look for connected UDP sockets before allowing redirection from BPF.
>   This makes connected UDP socket work as expected in the presence of
>   inet_lookup prog.
> - Share the code for BPF_PROG_{ATTACH,DETACH,QUERY} with flow_dissector,
>   the only other per-netns BPF prog type.
>
> Overview
> ========
>
> This series proposes a new BPF program type named BPF_PROG_TYPE_SK_LOOKUP,
> or BPF sk_lookup for short.
>
> BPF sk_lookup program runs when transport layer is looking up a listening
> socket for a new connection request (TCP), or when looking up an
> unconnected socket for a packet (UDP).
>
> This serves as a mechanism to overcome the limits of what bind() API allows
> to express. Two use-cases driving this work are:
>
>  (1) steer packets destined to an IP range, fixed port to a single socket
>
>      192.0.2.0/24, port 80 -> NGINX socket
>
>  (2) steer packets destined to an IP address, any port to a single socket
>
>      198.51.100.1, any port -> L7 proxy socket
>
> In its context, program receives information about the packet that
> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
> address 4-tuple.
>
> To select a socket BPF program fetches it from a map holding socket
> references, like SOCKMAP or SOCKHASH, calls bpf_sk_assign(ctx, sk, ...)
> helper to record the selection, and returns SK_PASS code. Transport layer
> then uses the selected socket as a result of socket lookup.
>
> Alternatively, program can also fail the lookup (SK_DROP), or let the
> lookup continue as usual (SK_PASS without selecting a socket).
>
> This lets the user match packets with listening (TCP) or receiving (UDP)
> sockets freely at the last possible point on the receive path, where we
> know that packets are destined for local delivery after undergoing
> policing, filtering, and routing.
>
> Program is attached to a network namespace, similar to BPF flow_dissector.
> We add a new attach type, BPF_SK_LOOKUP, for this. Multiple programs can be
> attached at the same time, in which case their return values are aggregated
> according the rules outlined in patch #4 description.
>
> Series structure
> ================
>
> Patches are organized as so:
>
>  1: enables multiple link-based prog attachments for bpf-netns
>  2: introduces sk_lookup program type
>  3-4: hook up the program to run on ipv4/tcp socket lookup
>  5-6: hook up the program to run on ipv6/tcp socket lookup
>  7-8: hook up the program to run on ipv4/udp socket lookup
>  9-10: hook up the program to run on ipv6/udp socket lookup
>  11-13: libbpf & bpftool support for sk_lookup
>  14-15: verifier and selftests for sk_lookup
>
> Patches are also available on GH:
>
>   https://github.com/jsitnicki/linux/commits/bpf-inet-lookup-v5
>
> Follow-up work
> ==============
>
> I'll follow up with below items, which IMHO don't block the review:
>
> - benchmark results for udp6 small packet flood scenario,
> - user docs for new BPF prog type, Documentation/bpf/prog_sk_lookup.rst,
> - timeout for accept() in tests after extending network_helper.[ch].
>
> Thanks to the reviewers for their feedback to this patch series:
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Marek Majkowski <marek@cloudflare.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
>
> -jkbs

Phew, I have to admit that at the patch that adds 2k lines of tests my
eyes glazed over a bit, but other than that: thank you for your hard
work!

For the series:
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>

>
> [RFCv1] https://lore.kernel.org/bpf/20190618130050.8344-1-jakub@cloudflare.com/
> [RFCv2] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> [v1] https://lore.kernel.org/bpf/20200511185218.1422406-18-jakub@cloudflare.com/
> [v2] https://lore.kernel.org/bpf/20200506125514.1020829-1-jakub@cloudflare.com/
> [v3] https://lore.kernel.org/bpf/20200702092416.11961-1-jakub@cloudflare.com/
> [v4] https://lore.kernel.org/bpf/20200713174654.642628-1-jakub@cloudflare.com/
>
> Jakub Sitnicki (15):
>   bpf, netns: Handle multiple link attachments
>   bpf: Introduce SK_LOOKUP program type with a dedicated attach point
>   inet: Extract helper for selecting socket from reuseport group
>   inet: Run SK_LOOKUP BPF program on socket lookup
>   inet6: Extract helper for selecting socket from reuseport group
>   inet6: Run SK_LOOKUP BPF program on socket lookup
>   udp: Extract helper for selecting socket from reuseport group
>   udp: Run SK_LOOKUP BPF program on socket lookup
>   udp6: Extract helper for selecting socket from reuseport group
>   udp6: Run SK_LOOKUP BPF program on socket lookup
>   bpf: Sync linux/bpf.h to tools/
>   libbpf: Add support for SK_LOOKUP program type
>   tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type
>   selftests/bpf: Add verifier tests for bpf_sk_lookup context access
>   selftests/bpf: Tests for BPF_SK_LOOKUP attach point
>
>  include/linux/bpf-netns.h                     |    3 +
>  include/linux/bpf.h                           |    4 +
>  include/linux/bpf_types.h                     |    2 +
>  include/linux/filter.h                        |  147 ++
>  include/uapi/linux/bpf.h                      |   77 +
>  kernel/bpf/core.c                             |   55 +
>  kernel/bpf/net_namespace.c                    |  127 +-
>  kernel/bpf/syscall.c                          |    9 +
>  kernel/bpf/verifier.c                         |   13 +-
>  net/core/filter.c                             |  183 +++
>  net/ipv4/inet_hashtables.c                    |   60 +-
>  net/ipv4/udp.c                                |   93 +-
>  net/ipv6/inet6_hashtables.c                   |   66 +-
>  net/ipv6/udp.c                                |   97 +-
>  scripts/bpf_helpers_doc.py                    |    9 +-
>  .../bpftool/Documentation/bpftool-prog.rst    |    2 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |    2 +-
>  tools/bpf/bpftool/common.c                    |    1 +
>  tools/bpf/bpftool/prog.c                      |    3 +-
>  tools/include/uapi/linux/bpf.h                |   77 +
>  tools/lib/bpf/libbpf.c                        |    3 +
>  tools/lib/bpf/libbpf.h                        |    2 +
>  tools/lib/bpf/libbpf.map                      |    2 +
>  tools/lib/bpf/libbpf_probes.c                 |    3 +
>  tools/testing/selftests/bpf/network_helpers.c |   58 +-
>  tools/testing/selftests/bpf/network_helpers.h |    2 +
>  .../selftests/bpf/prog_tests/sk_lookup.c      | 1282 +++++++++++++++++
>  .../selftests/bpf/progs/test_sk_lookup.c      |  641 +++++++++
>  .../selftests/bpf/verifier/ctx_sk_lookup.c    |  492 +++++++
>  29 files changed, 3418 insertions(+), 97 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup.c
>  create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
>
> --
> 2.25.4
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
