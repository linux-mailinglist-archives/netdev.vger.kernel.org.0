Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509A86F133D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbjD1Ia1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjD1Ia0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:30:26 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB8A1FF5;
        Fri, 28 Apr 2023 01:30:24 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-2f46348728eso5865003f8f.3;
        Fri, 28 Apr 2023 01:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682670623; x=1685262623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G8j8x1czFzbvnPpaqEQLo1L76++NMRFD2shHcwHxLUU=;
        b=CQrX71h2KdPGHmMC6Yx1OtTjt0w1hSC+cw5fdTpteVc96A7C55XiWCfJHS9B5ZybMO
         nilR69FLts5ua45Y52yTXmUMWJI/SR9H3sw7HcX0fl7ni3zHXUXdSt2SS43/QXbfcwiv
         gwZC0p6HR9n4zzG881/JB8DJJ63QyKba8GBWGMfPtx6C6rdvH8Atr8jM6TuM6y7FuoJe
         qQR8dC3P9ntwU+r/fNt2XSNGQQnjMkI49tbRKPtxTU79oS87e+QttZWoCmzX3CCqMGNS
         zo7nSgyb3WonbezPi49rX097grFKCPBbXloErmmMXWqXBHyQ98GR0jUNgmLP6ZFT9OhM
         MKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682670623; x=1685262623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G8j8x1czFzbvnPpaqEQLo1L76++NMRFD2shHcwHxLUU=;
        b=VPBzwFIveBuxObJqeps1RTsCuAGjTUcU2EKHsk3srxUzgAP/81CKA5XfanBZ/flPb2
         +hWZfxK3rI/Fm+GMXOZrs+/K5IuPKx/hupr5gu0dOi+z4QvAQXfuNVRIDD8UP9pV3bci
         xWWfqBjt82Ol99xL/IwpXGCCEzBSVU6eQVscDKjqJR0lraPq3oKvgMp0lGJLPwtI2ip9
         KnMp9vuZN+5ilocHO7yr9fV5wl9JOkz07HUj6/uxQgcK9xhROuUJTSgbRgPIvxY3ZYbK
         Qkdo8h62brY2sLRpnwgxhMUE/7WOMcBpDpjkjYZaXlCP49P7prT5eoxUCPWHNcotOoJk
         QTfQ==
X-Gm-Message-State: AC+VfDyVWTWW6RpkHpmXHE9pxWveQeGGae83vCeZ3jx2DafdkVmjAYWS
        bJ8R+NH7qBLpw2tlt3Z/pXQ=
X-Google-Smtp-Source: ACHHUZ7t4Pa+5LMDFE+3V45onw/khpEwW8BLFwn1t4HnrcWVDti9VslkHftTYvWaWaqDw/C93+h4tQ==
X-Received: by 2002:a5d:634e:0:b0:2fa:6929:eb81 with SMTP id b14-20020a5d634e000000b002fa6929eb81mr3207396wrw.31.1682670622808;
        Fri, 28 Apr 2023 01:30:22 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([2a0d:6fc2:43e5:9b00:5000:8721:8779:7e1])
        by smtp.gmail.com with ESMTPSA id n12-20020a7bc5cc000000b003f17329f7f2sm23540545wmk.38.2023.04.28.01.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 01:30:22 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v4 0/4] Socket lookup BPF API from tc/xdp ingress does not respect VRF bindings.
Date:   Fri, 28 Apr 2023 11:30:03 +0300
Message-Id: <20230428083007.148364-1-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling socket lookup from L2 (tc, xdp), VRF boundaries aren't
respected. This patchset fixes this by regarding the incoming device's
VRF attachment when performing the socket lookups from tc/xdp.

The first two patches are coding changes which factor out the tc helper's
logic which was shared with cg/sk_skb (which operate correctly).

This refactoring is needed in order to avoid affecting the cgroup/sk_skb
flows as there does not seem to be a strict criteria for discerning which
flow the helper is called from based on the net device or packet
information.

The third patch contains the actual bugfix.

The fourth patch adds bpf tests for these lookup functions.
---
v4: - Move dev_sdif() to include/linux/netdevice.h as suggested by Stanislav Fomichev
    - Remove SYS and SYS_NOFAIL duplicate definitions

v3: - Rename bpf_l2_sdif() to dev_sdif() as suggested by Stanislav Fomichev
    - Added xdp tests as suggested by Daniel Borkmann
    - Use start_server() to avoid duplicate code as suggested by Stanislav Fomichev

v2: Fixed uninitialized var in test patch (4).

Gilad Sever (4):
  bpf: factor out socket lookup functions for the TC hookpoint.
  bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC
    hookpoint
  bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
  selftests/bpf: Add vrf_socket_lookup tests

 include/linux/netdevice.h                     |   9 +
 net/core/filter.c                             | 123 +++++--
 .../bpf/prog_tests/vrf_socket_lookup.c        | 312 ++++++++++++++++++
 .../selftests/bpf/progs/vrf_socket_lookup.c   |  88 +++++
 4 files changed, 511 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/vrf_socket_lookup.c

-- 
2.34.1

