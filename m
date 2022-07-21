Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E918657D297
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiGUR34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiGUR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:29:37 -0400
Received: from mail-pl1-x663.google.com (mail-pl1-x663.google.com [IPv6:2607:f8b0:4864:20::663])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2288B493
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:29:09 -0700 (PDT)
Received: by mail-pl1-x663.google.com with SMTP id f11so2457709plr.4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=+P31FTPNB8V0k21MVDKyx8VI7HowShxBIfm+M0GTEZY=;
        b=o0zS5yCNP6C6az5d7NOZxow+NM24SDqk/LsQ+ZZJtoJTFBdAfcrTFP7P44x6uwGsvn
         e5/jwh/2txJ8Vd3f6t3MO2h4ovPWCvzV0CwX1L7pyt3K3I6IgPNvdJLJ4lU7tHxiEZto
         ie7PlaAmxBi8PA8AwXks6+EzwOzIlj2HYi+331m6vgVRiQKR4Ep6oUg81e9Cb25emhyo
         nK25z5ir865nirPmq/vXbn/Uj/CVfXfPFe2PtGW6w2gw4nsOse61yK0/5jSC0ANOyKXH
         gMYApuES5ooSIj8ODpcrsf19rtIfQUefjZiCPW1h5Ld8bK0qJjsYGUgIziPNlrOuLMS6
         NWIQ==
X-Gm-Message-State: AJIora8eavf+aJ/Nnq+CXydiSN6eavYrJVDtHxg9yNdXKXxQzeMBRyn+
        o2Gd6IiDcNXVZK9QAG0VgubIvlKhD6aw947diZxm/yvnm3w72g==
X-Google-Smtp-Source: AGRyM1vRI/j+rdEgx0PVy7Vtc7UbN5pGJjOERzqLO0NkuuyIP2wbB/K17x+Yi+R1mmbTdylBV7I9WzNPYRe+
X-Received: by 2002:a17:90a:9418:b0:1f1:e251:cabf with SMTP id r24-20020a17090a941800b001f1e251cabfmr12457370pjo.79.1658424549053;
        Thu, 21 Jul 2022 10:29:09 -0700 (PDT)
Received: from riotgames.com ([163.116.128.208])
        by smtp-relay.gmail.com with ESMTPS id jj18-20020a170903049200b0016be4c3dde9sm168549plb.28.2022.07.21.10.29.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 10:29:09 -0700 (PDT)
X-Relaying-Domain: riotgames.com
Received: by mail-qk1-f198.google.com with SMTP id bi37-20020a05620a31a500b006b5ef0afedaso1803122qkb.22
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+P31FTPNB8V0k21MVDKyx8VI7HowShxBIfm+M0GTEZY=;
        b=Ekrd4Hg07fW1w/qzWbZcOZWG1GlLx4XCur5UhgnR8lTUpu9OW5QAGIyKOkEA8VRr9e
         TyA3/MvfK7keqtZRtYEaAv0UJkWRuyCtSCfCy2LiYuUIcNVkOXTkNof8b8yq7Xt7+s/K
         tFiQItNFZEZ6lO5he8m5q1xB1fNqEEuR3m7lI=
X-Received: by 2002:a05:622a:1346:b0:31d:23e8:ac05 with SMTP id w6-20020a05622a134600b0031d23e8ac05mr33843684qtk.207.1658424546317;
        Thu, 21 Jul 2022 10:29:06 -0700 (PDT)
X-Received: by 2002:a05:622a:1346:b0:31d:23e8:ac05 with SMTP id
 w6-20020a05622a134600b0031d23e8ac05mr33843658qtk.207.1658424546020; Thu, 21
 Jul 2022 10:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134245.2450-1-memxor@gmail.com>
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Thu, 21 Jul 2022 10:28:54 -0700
Message-ID: <CAC1LvL3dh+cdSPcLNZso9RSdOJfZjTZmpb6wC8e1UFcsEYbpvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 00/13] New nf_conntrack kfuncs for insertion,
 changing timeout, status
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
x-netskope-inspected: true
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 6:43 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Introduce the following new kfuncs:
> - bpf_{xdp,skb}_ct_alloc
> - bpf_ct_insert_entry
> - bpf_ct_{set,change}_timeout
> - bpf_ct_{set,change}_status
>
> The setting of timeout and status on allocated or inserted/looked up CT
> is same as the ctnetlink interface, hence code is refactored and shared
> with the kfuncs. It is ensured allocated CT cannot be passed to kfuncs
> that expected inserted CT, and vice versa. Please see individual patches
> for details.
>

Is it expected that using these helpers and the kernel's conntrack to manage
connection state from XDP will outperform using maps and eBPF timers (for XDP
use cases that don't have a userspace component that also needs the information
in conntrack)? Have you done any benchmarking on the performance of using
conntrack from XDP?

Thanks!
--Zvi

> Changelog:
> ----------
> v6 -> v7:
> v6: https://lore.kernel.org/bpf/20220719132430.19993-1-memxor@gmail.com
>
> * Use .long to encode flags (Alexei)
> * Fix description of KF_RET_NULL in documentation (Toke)
>
> v5 -> v6:
> v5: https://lore.kernel.org/bpf/20220623192637.3866852-1-memxor@gmail.com
>
> * Introduce kfunc flags, rework verifier to work with them
> * Add documentation for kfuncs
> * Add comment explaining TRUSTED_ARGS kfunc flag (Alexei)
> * Fix missing offset check for trusted arguments (Alexei)
> * Change nf_conntrack test minimum delta value to 8
>
> v4 -> v5:
> v4: https://lore.kernel.org/bpf/cover.1653600577.git.lorenzo@kernel.org
>
> * Drop read-only PTR_TO_BTF_ID approach, use struct nf_conn___init (Alexei)
> * Drop acquire release pair code that is no longer required (Alexei)
> * Disable writes into nf_conn, use dedicated helpers (Florian, Alexei)
> * Refactor and share ctnetlink code for setting timeout and status
> * Do strict type matching on finding __ref suffix on argument to
> prevent passing nf_conn___init as nf_conn (offset = 0, match on walk)
> * Remove bpf_ct_opts parameter from bpf_ct_insert_entry
> * Update selftests for new additions, add more negative tests
>
> v3 -> v4:
> v3: https://lore.kernel.org/bpf/cover.1652870182.git.lorenzo@kernel.org
>
> * split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
> bpf_ct_insert_entry
> * add verifier code to properly populate/configure ct entry
> * improve selftests
>
> v2 -> v3:
> v2: https://lore.kernel.org/bpf/cover.1652372970.git.lorenzo@kernel.org
>
> * add bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc helpers
> * remove conntrack dependency from selftests
> * add support for forcing kfunc args to be referenced and related selftests
>
> v1 -> v2:
> v1: https://lore.kernel.org/bpf/1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org
>
> * add bpf_ct_refresh_timeout kfunc selftest
>
> Kumar Kartikeya Dwivedi (10):
> bpf: Introduce 8-byte BTF set
> tools/resolve_btfids: Add support for 8-byte BTF sets
> bpf: Switch to new kfunc flags infrastructure
> bpf: Add support for forcing kfunc args to be trusted
> bpf: Add documentation for kfuncs
> net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
> net: netfilter: Add kfuncs to set and change CT timeout
> selftests/bpf: Add verifier tests for trusted kfunc args
> selftests/bpf: Add negative tests for new nf_conntrack kfuncs
> selftests/bpf: Fix test_verifier failed test in unprivileged mode
>
> Lorenzo Bianconi (3):
> net: netfilter: Add kfuncs to allocate and insert CT
> net: netfilter: Add kfuncs to set and change CT status
> selftests/bpf: Add tests for new nf_conntrack kfuncs
>
> Documentation/bpf/index.rst | 1 +
> Documentation/bpf/kfuncs.rst | 170 ++++++++
> include/linux/bpf.h | 3 +-
> include/linux/btf.h | 65 ++--
> include/linux/btf_ids.h | 68 +++-
> include/net/netfilter/nf_conntrack_core.h | 19 +
> kernel/bpf/btf.c | 123 +++---
> kernel/bpf/verifier.c | 14 +-
> net/bpf/test_run.c | 75 ++--
> net/ipv4/bpf_tcp_ca.c | 18 +-
> net/ipv4/tcp_bbr.c | 24 +-
> net/ipv4/tcp_cubic.c | 20 +-
> net/ipv4/tcp_dctcp.c | 20 +-
> net/netfilter/nf_conntrack_bpf.c | 365 +++++++++++++-----
> net/netfilter/nf_conntrack_core.c | 62 +++
> net/netfilter/nf_conntrack_netlink.c | 54 +--
> tools/bpf/resolve_btfids/main.c | 40 +-
> .../selftests/bpf/bpf_testmod/bpf_testmod.c | 10 +-
> .../testing/selftests/bpf/prog_tests/bpf_nf.c | 64 ++-
> .../testing/selftests/bpf/progs/test_bpf_nf.c | 85 +++-
> .../selftests/bpf/progs/test_bpf_nf_fail.c | 134 +++++++
> .../selftests/bpf/verifier/bpf_loop_inline.c | 1 +
> tools/testing/selftests/bpf/verifier/calls.c | 53 +++
> 23 files changed, 1139 insertions(+), 349 deletions(-)
> create mode 100644 Documentation/bpf/kfuncs.rst
> create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
>
> --
> 2.34.1
>
