Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707726D4318
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjDCLNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjDCLND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:13:03 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848A11659
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:12:30 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d17so28903922wrb.11
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680520347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XDScleNPhVPO54kxOKxQumxr8xmhVAhL3xX9seLkjNI=;
        b=HgabHVAEwxuQvMaYMbnLI6gcoQaR6MCVEcwO9KWwr+XCrszcTScNEkOgZh53S7rCGL
         lx0H65pMjpwzz2zOZTxxF+i5WB9RciFYT1s/ORth0tyPdpo60cphbJb08QY15hQC5tnv
         LJ5cMuSNL6e4s38Qa4zvct2xAA6wj31Zvg8Nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDScleNPhVPO54kxOKxQumxr8xmhVAhL3xX9seLkjNI=;
        b=tztJ/8XXLfDRJd5FrG3qVOkGnSAvnxdozaghhqoUQyZR2kCA9Fe0Cq4W4LpSktQQBp
         Hh9ZE87mrdSN9l4CY0Dqvgr6Fj0J0DCe90q9c8EFGyHcyyayL8Mq3HkgDwMKPELIHOGp
         hUuUJixNtHE8uMUIb2HTrJovn6Zpo2zDQcsS2p96BAuCnccond2PzjTiB4cXbvu0wugH
         vf5fY3DeNeV68s4OOvkiDtqUmntcfBjluTjCFTObORLRF7MHZKiT+gjqwYz171LmRm0q
         geoueOQdHwrB9D/V4gNASJZFf9rbKPeJX5TvSSwtwkKYhRjn2OLMneCNrOW5IynKkTMI
         tX7Q==
X-Gm-Message-State: AAQBX9c0CuqIMgLbf+TV1cvwAkrVQZVLBml0QHsnEKwd/i4CHIc3ZVdT
        RrVyl3F2iTS4yCicm4UIu1oL2g==
X-Google-Smtp-Source: AKy350Yqx4cRtTXF3KLY6laEarBP/P2dxp+d9gjJUyfNwHScLSUEItjpvdB0n5IwC7szeH8JhB2hnQ==
X-Received: by 2002:a5d:67cd:0:b0:2d7:babe:104c with SMTP id n13-20020a5d67cd000000b002d7babe104cmr25864956wrw.15.1680520347373;
        Mon, 03 Apr 2023 04:12:27 -0700 (PDT)
Received: from workstation.ehrig.io (tmo-066-125.customers.d1-online.com. [80.187.66.125])
        by smtp.gmail.com with ESMTPSA id y11-20020adffa4b000000b002c7066a6f77sm9505517wrr.31.2023.04.03.04.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:12:26 -0700 (PDT)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Mykola Lysenko <mykolal@fb.com>, netdev@vger.kernel.org,
        Paul Chaignon <paul@isovalent.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 0/3] Add FOU support for externally controlled ipip devices
Date:   Mon,  3 Apr 2023 14:12:06 +0200
Message-Id: <cover.1680520500.git.cehrig@cloudflare.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for using FOU or GUE encapsulation with
an ipip device operating in collect-metadata mode and a set of kfuncs
for controlling encap parameters exposed to a BPF tc-hook.

BPF tc-hooks allow us to read tunnel metadata (like remote IP addresses)
in the ingress path of an externally controlled tunnel interface via
the bpf_skb_get_tunnel_{key,opt} bpf-helpers. Packets can then be
redirected to the same or a different externally controlled tunnel
interface by overwriting metadata via the bpf_skb_set_tunnel_{key,opt}
helpers and a call to bpf_redirect. This enables us to redirect packets
between tunnel interfaces - and potentially change the encapsulation
type - using only a single BPF program.

Today this approach works fine for a couple of tunnel combinations.
For example: redirecting packets between Geneve and GRE interfaces or
GRE and plain ipip interfaces. However, redirecting using FOU or GUE is
not supported today. The ip_tunnel module does not allow us to egress
packets using additional UDP encapsulation from an ipip device in
collect-metadata mode.

Patch 1 lifts this restriction by adding a struct ip_tunnel_encap to
the tunnel metadata. It can be filled by a new BPF kfunc introduced
in Patch 2 and evaluated by the ip_tunnel egress path. This will allow
us to use FOU and GUE encap with externally controlled ipip devices.

Patch 2 introduces two new BPF kfuncs: bpf_skb_{set,get}_fou_encap.
These helpers can be used to set and get UDP encap parameters from the
BPF tc-hook doing the packet redirect.

Patch 3 adds BPF tunnel selftests using the two kfuncs.

---
v2:
 - Fixes for checkpatch.pl
 - Fixes for kernel test robot

Christian Ehrig (3):
  ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip
    devices
  bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
  selftests/bpf: Test FOU kfuncs for externally controlled ipip devices

 include/net/fou.h                             |   2 +
 include/net/ip_tunnels.h                      |  28 +++--
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/fou_bpf.c                            | 119 ++++++++++++++++++
 net/ipv4/fou_core.c                           |   5 +
 net/ipv4/ip_tunnel.c                          |  22 +++-
 net/ipv4/ipip.c                               |   1 +
 net/ipv6/sit.c                                |   2 +-
 .../selftests/bpf/progs/test_tunnel_kern.c    | 117 +++++++++++++++++
 tools/testing/selftests/bpf/test_tunnel.sh    |  81 ++++++++++++
 10 files changed, 362 insertions(+), 17 deletions(-)
 create mode 100644 net/ipv4/fou_bpf.c

-- 
2.39.2

