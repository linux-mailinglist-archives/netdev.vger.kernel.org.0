Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89796D338E
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDATeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDATeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:34:06 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE3F1A971
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:34:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d17so25539532wrb.11
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 12:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680377643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T8nk4QZgWJg4nXeLh4FKwCEMlZL89Q2/gxR+wnUlYKE=;
        b=HGKGh54YFhrvPb37yH8hOS5CsqeTujyV4VL3WbkXqVVrUDuuVS7v90zKoJMmRRdeaa
         eGde5sjydMFGflefdX1gjRpbpA8Ef5k8g5MedMHSnytb2/pU57TWhqccC0lzljcR7jyT
         hu9oW2uNzKlsPDcK8AX+juNDSJKqo4W4DS0RE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680377643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T8nk4QZgWJg4nXeLh4FKwCEMlZL89Q2/gxR+wnUlYKE=;
        b=7BTuwosIPYSpHNljzleee7iONBGxTtQWONLxFTt/PsWnlz0RROq83RBAJrJry+NFRr
         vDv5IjNNJ1K/kgbBDYsHNDFCHBJGkAXvVVXDg5jGcRmokVZQlq9ARItTZmzBfRlGXZcu
         08kMZnuzCVCDFCbEZJdwmOTv06FvoEYkjjr2WYCxIsIhIg095jC5o4x0u5xCt8ETo+x9
         57tHQe8JsxODopiuFzResXJYsQbkJEU6FT8qDkTnxTW5x0NHKcq5X4ZeR2VBkXVFt589
         7UeuSe0E6T22fpg2T2DDHNH7mD7Qlw5NBt7o31+S0pJ7CHEPqs48ZfBqlYNPUiGDmzjX
         IuKA==
X-Gm-Message-State: AAQBX9eTApewykLHiuVFwOcuhLSYjfjjvqiOZb+hH6eHbF5591O492dK
        qA0u7QH5mBOlaJVDbZ3f0HWcyA==
X-Google-Smtp-Source: AKy350Y5D0ExAXEkg5rfqePCtbRp8sfXIZ7hSLc+dGA9E1RgAyvEH+GV0tJZXYvCamlzuZrbySxjjw==
X-Received: by 2002:a5d:538d:0:b0:2cf:e023:5915 with SMTP id d13-20020a5d538d000000b002cfe0235915mr21430570wrv.61.1680377643121;
        Sat, 01 Apr 2023 12:34:03 -0700 (PDT)
Received: from workstation.ehrig.io (tmo-065-106.customers.d1-online.com. [80.187.65.106])
        by smtp.gmail.com with ESMTPSA id b5-20020a5d4b85000000b002c559843748sm5600416wrt.10.2023.04.01.12.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:34:02 -0700 (PDT)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
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
Subject: [PATCH bpf-next 0/3] Add FOU support for externally controlled ipip devices
Date:   Sat,  1 Apr 2023 22:33:25 +0200
Message-Id: <cover.1680379518.git.cehrig@cloudflare.com>
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

Christian Ehrig (3):
  ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip
    devices
  bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
  selftests/bpf: Test FOU kfuncs for externally controlled ipip devices

 include/net/fou.h                             |   2 +
 include/net/ip_tunnels.h                      |  27 ++--
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/fou_bpf.c                            | 118 ++++++++++++++++++
 net/ipv4/fou_core.c                           |   5 +
 net/ipv4/ip_tunnel.c                          |  22 +++-
 net/ipv4/ipip.c                               |   1 +
 net/ipv6/sit.c                                |   2 +-
 .../selftests/bpf/progs/test_tunnel_kern.c    | 117 +++++++++++++++++
 tools/testing/selftests/bpf/test_tunnel.sh    |  81 ++++++++++++
 10 files changed, 360 insertions(+), 17 deletions(-)
 create mode 100644 net/ipv4/fou_bpf.c

-- 
2.39.2

