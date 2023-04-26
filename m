Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21E6EF07A
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbjDZIvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240184AbjDZIvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:51:33 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC0D40F4;
        Wed, 26 Apr 2023 01:51:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f27a9c7970so6138219f8f.2;
        Wed, 26 Apr 2023 01:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682499091; x=1685091091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hSMr42fxTWyyNAG5/aU9KwCRtGwIQIyKAkulVMr9X74=;
        b=pn3Z4+DzRyrUv+n2f07SYhiXYVC5MwiWUGGC6hrzNclD2hGT3ia8Gkl5dUjBIHEp/s
         lecGJdL9K2dEyZsrSEAnc3lMA9e7mbfqPPhDPNqIBXtIAEXHaLy+prS3vOWvkoXIFPys
         6TG5WRBDot9jtSO0DCK5sfzPRPKpu9L45+10xtWd7Qc0zgIKxTeabukTFxvrU2dflf61
         302RE0J5epZlL0Bh7V7HYkx8KL7VBaTDhWOrwXvLeFHikY+LQCCfxn4jtVTi1gHxf7t7
         tf0MjXd49yo0++Y2jIEy+Fyu7taYS3i2t/zrwfeMCv+ufr3M15Z6kTvRTjY1kYSkZtGv
         I6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682499091; x=1685091091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hSMr42fxTWyyNAG5/aU9KwCRtGwIQIyKAkulVMr9X74=;
        b=lujh47+oMTvqeAJxBKrpas+gV8fjdiu4TMLPq+p2RenDS+bcFXnY0YhH8ae94Ajyyl
         yWqF2IKtUU/b52U7Odf4gMgzyzzf9QdC6U8KuuaqquHG4Dfbn8uiUFAksddIwGvq++oQ
         Oih2ZIuj8j3dB7bLtYcp9oaV6C88Mfg1WzD198YP+ntfwBHuZRbnAKfVUuUGpHWEZQWl
         aJ00gN7lDdirtWImZGRmtJkP4HdvfOzqS/8e3PpCV1eVWyji+bfwUHPHIXtKY6kUudAd
         ItTNaWM8IVjWaKC9OBnPU4Hqj8R9z9Qcui+4Y+1C1tnERe94oQRudNUMtID9SY9Rgy8l
         HApg==
X-Gm-Message-State: AAQBX9cYFEv4J7ZbJyFCOu115YM6LP0PpD1mN4aAuRnp9x/UOrlOWXtQ
        OSywjzAbXTFkgc2kffWBB9o=
X-Google-Smtp-Source: AKy350YLfM67FsA6sKVyWaH7hmGiGrS4KkSmYE0OxKnVxty373+iARlq35uodKWHpoO3KDHFSxKOzg==
X-Received: by 2002:adf:ed07:0:b0:2f5:7079:599e with SMTP id a7-20020adfed07000000b002f57079599emr14183045wro.12.1682499090569;
        Wed, 26 Apr 2023 01:51:30 -0700 (PDT)
Received: from localhost.localdomain ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id q11-20020a5d574b000000b003049d7b9f4csm1229838wrw.32.2023.04.26.01.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 01:51:29 -0700 (PDT)
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
Subject: [PATCH bpf,v3 0/4] Socket lookup BPF API from tc/xdp ingress does not respect VRF bindings.
Date:   Wed, 26 Apr 2023 11:51:18 +0300
Message-Id: <20230426085122.376768-1-gilad9366@gmail.com>
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

 net/core/filter.c                             | 132 +++++--
 .../bpf/prog_tests/vrf_socket_lookup.c        | 327 ++++++++++++++++++
 .../selftests/bpf/progs/vrf_socket_lookup.c   |  88 +++++
 3 files changed, 526 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/vrf_socket_lookup.c

-- 
2.34.1

