Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5786414B3
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiLCHa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiLCHa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:30:56 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C568325E;
        Fri,  2 Dec 2022 23:30:55 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i15so994943edf.2;
        Fri, 02 Dec 2022 23:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V0AWLw8A7YQscoY2fX89Zhr2PiKLJbVIvg5SZ8dE2ic=;
        b=A423ZBUhziRAES2fMtmZpi6htvGrYHRoqVKt+3N8oaKThLRxBUrFej6V3nTyKGHO9W
         Cx4avk3ef0Nn64KNh7j5DoyA2J3ixJ/GWCd+MU0QRa7NY/TsfZr/CRTxhsTJkDgVN/Ha
         JWJXKeuh6RAj1HED/XPVMoLxuX7XFXq4mRFZ+JeuLDvyydm8P2SIb+EBYAcV3PGQ2Mrs
         YdZYDlXSUSLfLrkRWrXEZLrizCktNgnvllQuWi8POneDStRumKOlSmncBxTZNZnBar1q
         vENT1r4V9h/b3e0wMjR21sVgR7AQMhvIG7mrzoWsyH85OuVUXRHTK/u1OjL6Cfhg3bYG
         WmtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V0AWLw8A7YQscoY2fX89Zhr2PiKLJbVIvg5SZ8dE2ic=;
        b=lWZYPdQwRMEeFg0q6tQ8n1d0dkperp3tOTFU7zkPkdAo6xWZoD2G7B83DTQ/cNjFd1
         K1UgDWjgCj8PkfUKqjocMBcv42Snv9+WDx20Gw1vuZmiZorAgYtTKWQkDZNw1OFwkGwh
         52Pvg4iIfJLrFjqr7HQXQ6Q4LRilShQBx+2pj7ZKslPWniTYIwzSHZjTy6N8jSttr0s5
         bBy2reupQAT632Vn+dAogSWLJJmOUe0JxKID4hnssrgnBuKFtJFVTAUzK9iA1MPLz4Pn
         GVHpHLxttlugsfqVmmXpgKiHcpgrz2e75APY5qgt5FAAQMzpyHvZOxtG5+bdexs6qdjU
         88Sg==
X-Gm-Message-State: ANoB5plZc4E6IokMEnebcUlJDlLObbJJVo1XyIEdYjL+KozTUr5GRskn
        S8hbn5msrj7MELeJIrmGfQE=
X-Google-Smtp-Source: AA0mqf7RJPhwJm9Osdla/j+18T4aDB0R8/gHRvo5XbQz1eBhp8CrQDcYuRF0SqS3UMX+uqkYxAzsgg==
X-Received: by 2002:aa7:c98e:0:b0:46c:2cf2:e89f with SMTP id c14-20020aa7c98e000000b0046c2cf2e89fmr5425044edt.267.1670052654137;
        Fri, 02 Dec 2022 23:30:54 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402074400b0046267f8150csm3772709edy.19.2022.12.02.23.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 23:30:53 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com, jtoppins@redhat.com,
        kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v5 0/4] xfrm: interface: Add unstable helpers for XFRM metadata
Date:   Sat,  3 Dec 2022 09:30:31 +0200
Message-Id: <20221203073035.1798108-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds xfrm metadata helpers using the unstable kfunc
call interface for the TC-BPF hooks.

This allows steering traffic towards different IPsec connections based
on logic implemented in bpf programs.

The helpers are integrated into the xfrm_interface module. For this
purpose the main functionality of this module is moved to
xfrm_interface_core.c.

---

changes in v5:
  - avoid cleanup of percpu dsts as detailed in patch 2
changes in v3:
  - tag bpf-next tree instead of ipsec-next
  - add IFLA_XFRM_COLLECT_METADATA sync patch

Eyal Birger (4):
  xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
  xfrm: interface: Add unstable helpers for setting/getting XFRM
    metadata from TC-BPF
  tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
  selftests/bpf: add xfrm_info tests

 include/net/dst_metadata.h                    |   1 +
 include/net/xfrm.h                            |  15 +
 net/core/dst.c                                |   8 +-
 net/core/filter.c                             |   4 +
 net/xfrm/Makefile                             |   8 +
 net/xfrm/xfrm_interface_bpf.c                 | 117 ++++++
 ...xfrm_interface.c => xfrm_interface_core.c} |  14 +
 tools/include/uapi/linux/if_link.h            |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x    |   1 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/xfrm_info.c      | 365 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   3 +
 tools/testing/selftests/bpf/progs/xfrm_info.c |  35 ++
 13 files changed, 572 insertions(+), 2 deletions(-)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c

-- 
2.34.1

