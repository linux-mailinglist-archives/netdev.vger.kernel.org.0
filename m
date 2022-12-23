Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF09A654BE2
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 05:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiLWEHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 23:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiLWEHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 23:07:22 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415AB23395
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:07:21 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 7so2613711pga.1
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uuRoS5f+F8qdvavLV7QeHdX9SfeSfZjDpTq44MsniBI=;
        b=aiUbit8nI0Qh4akK1B2FcpZRewpESB9clKE6W9Ij7/1o+mfp2SHvkXg77KT1mSyuyR
         C3d0IUJBgzATy99SRRcCEA4+DjOx7b3yzdg29oMjrzXrp+d0akP9AX3JaGw64u60ACzf
         Ps1PT5MW7U0LG3VlHVEn/6ivGo144GHPab2/g5qLFTBN8HHn+W65o4WkIWqSWZoCKQFA
         VzN9jWczmvBIZjaPBNFRzHytLmNrG5qKIZvcYSPhFHt89r0QNRmFAiQHlewyeUlwp+zg
         I8NvByhaiA1xUwxmFUs1oY7seKIMEGfGiccVn/Oh8HhBbT1MH8j1Miqu2Mu//5Zq48YM
         foQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuRoS5f+F8qdvavLV7QeHdX9SfeSfZjDpTq44MsniBI=;
        b=QPTudjILdb2/jiH47xVWbDdZ5rTFw/y83GbvHJT0AFZa3Kkd8CbAvHNBz2d9hRRh1a
         tILCalETUihfwuZuxWfam87SLKA5lYe7G3jRSfPAplZhHHrQOf2R1ktxeV4QkvOB75Cz
         yGBOnOu4M9ePV6pRgzH1asO4QlgEOV/M9//221vQFTiUqUhN8D8EIuLSXNpos20tH9XN
         sO5ObpseTCjdkd5Hl5WZQYIUg48xdk759kZPnnA+WrRY0hRseuQIyaiSqlA9CqpT//yX
         M+zpdLF6nEboi4iIR1NgOSiVCHKnwcOwHVps8RPDhDne0PzSJmEBFTR9Eti9svDnrr2u
         lwiw==
X-Gm-Message-State: AFqh2kpqjwYc5DfNpsRiCs0cmAUsTuczZs8j2DIxUBec+1lp1BySzoQX
        BYvjQ0GZ4Ojtf4UWEXht53C2Myzm5Jye51tCHjvVGQ==
X-Google-Smtp-Source: AMrXdXtHF3+xazC2Hrx5AjudWDyWXqDOqdnnxfEKkohBiAQlDSqR35HrJ5Gn7v/a+YtZ6xbiMno6mXfQshK/aEWCwjw=
X-Received: by 2002:a63:1e11:0:b0:490:afd1:55b2 with SMTP id
 e17-20020a631e11000000b00490afd155b2mr411193pge.112.1671768440589; Thu, 22
 Dec 2022 20:07:20 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com> <20221220222043.3348718-18-sdf@google.com>
 <95e79329-b7c9-550b-290e-e5e4ea6e7a01@linux.dev>
In-Reply-To: <95e79329-b7c9-550b-290e-e5e4ea6e7a01@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 22 Dec 2022 20:07:08 -0800
Message-ID: <CAKH8qBscxiYcZY1u-xyTzypU-GfFQe4mW519RzYi6bXx19x4rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 17/17] selftests/bpf: Simple program to dump
 XDP RX metadata
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 4:53 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> > To be used for verification of driver implementations. Note that
> > the skb path is gone from the series, but I'm still keeping the
> > implementation for any possible future work.
> >
> > $ xdp_hw_metadata <ifname>
> >
> > On the other machine:
> >
> > $ echo -n xdp | nc -u -q1 <target> 9091 # for AF_XDP
> > $ echo -n skb | nc -u -q1 <target> 9092 # for skb
> >
> > Sample output:
> >
> >    # xdp
> >    xsk_ring_cons__peek: 1
> >    0x19f9090: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> >    rx_timestamp_supported: 1
> >    rx_timestamp: 1667850075063948829
> >    0x19f9090: complete idx=8 addr=8000
> >
> >    # skb
> >    found skb hwtstamp = 1668314052.854274681
> >
> > Decoding:
> >    # xdp
> >    rx_timestamp=1667850075.063948829
> >
> >    $ date -d @1667850075
> >    Mon Nov  7 11:41:15 AM PST 2022
> >    $ date
> >    Mon Nov  7 11:42:05 AM PST 2022
> >
> >    # skb
> >    $ date -d @1668314052
> >    Sat Nov 12 08:34:12 PM PST 2022
> >    $ date
> >    Sat Nov 12 08:37:06 PM PST 2022
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   tools/testing/selftests/bpf/.gitignore        |   1 +
> >   tools/testing/selftests/bpf/Makefile          |   6 +-
> >   .../selftests/bpf/progs/xdp_hw_metadata.c     |  81 ++++
> >   tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 ++++++++++++++++++
> >   4 files changed, 492 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >   create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
> >
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> > index 07d2d0a8c5cb..01e3baeefd4f 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -46,3 +46,4 @@ test_cpp
> >   xskxceiver
> >   xdp_redirect_multi
> >   xdp_synproxy
> > +xdp_hw_metadata
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index e6cbc04a7920..b7d5d3aa554e 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -83,7 +83,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> >       test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> > -     xskxceiver xdp_redirect_multi xdp_synproxy veristat
> > +     xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata
> >
> >   TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
> >   TEST_GEN_FILES += liburandom_read.so
> > @@ -241,6 +241,9 @@ $(OUTPUT)/test_maps: $(TESTING_HELPERS)
> >   $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
> >   $(OUTPUT)/xsk.o: $(BPFOBJ)
> >   $(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> > +$(OUTPUT)/xdp_hw_metadata: $(OUTPUT)/xsk.o $(OUTPUT)/xdp_hw_metadata.skel.h
> > +$(OUTPUT)/xdp_hw_metadata: $(OUTPUT)/network_helpers.o
> > +$(OUTPUT)/xdp_hw_metadata: LDFLAGS += -static
>
>
> This test binary fails to build for llvm.  gcc looks fine though.  The CI tests
> cannot be run on this set because of this.  Please take a look:
>
> https://github.com/kernel-patches/bpf/actions/runs/3745257032/jobs/6359527599#step:11:2202

Ugh, again, I was hoping I fixed it :-(

clang: error: cannot specify -o when generating multiple output files

Will give it another try; for some reason can't reproduce locally
(LLVM version 16.0.0git)

> I only have minor comments on the set.  Looking forward to v6.

Thank you for another round of reviews! I'll probably keep quiet next
week to give us some family time during holidays and will publish v6
early January. Happy holidays!
