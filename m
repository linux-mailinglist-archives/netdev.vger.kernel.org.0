Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9726D641504
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 09:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiLCIrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 03:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLCIrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 03:47:14 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304BE7DA48;
        Sat,  3 Dec 2022 00:47:13 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ha10so16650623ejb.3;
        Sat, 03 Dec 2022 00:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0DY/eXPZKnLig8h3A5XFrfKzNBPdg6tg1YrR81BeIms=;
        b=GVeWwY/G39Fh+8+hftiUzpYVe+noSFZ+tGTsQK7aA4uC+hgs9k1AsoA/9KNKbtVtoh
         2OKgoT2frlIdwQKpmw0jxfp6tLKFmwE8iOxwOB81uDops+yxX6ykbEPNSdS2j4BFRu4g
         0Bp4jNAln30L5Qv4YAFIMMT8dZnf02xWuNfUwqF73zQNJc88qIBJaKaSEEpm6h0D4bTv
         /eq7MSX7nLcDuZU6SQTP6GsqgMeL83ZfK2iprR2oP7TY9tht9mQjgfY6sosBHukL1i4n
         p9Gk1CV63DXUMwYpIVTzReDGmS/lAablhAkmxXwM3B20x7YMtaoW8n08gkrjBvz2swJV
         u6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0DY/eXPZKnLig8h3A5XFrfKzNBPdg6tg1YrR81BeIms=;
        b=45stpY9KxU+XCPtZR5LGdUpcQGXmp5W1obCdl3nsqETV9OLYMTF83ixOpyyTk2YAFV
         kD/M4qlZCwkj9BalCLgEdTdwjwU92vH9nbHEpRjE2JipfCKxYa8qQNSU3QrXrAYgAxgi
         3xYO9PGq33s9Xl63E33d2RIOyjMM2WTfMuCdrLxX/XM5Z+X1QOXVVxjdwiRxRRb+aXqR
         63iA8sMVFqnZjr2A1z04NRTje6XOageVeVnqepaKkB41gFzinT/D7GyymJ/uRGIUEEGm
         rf9CqclTSlFJsJy7XI+bawl6VPnI0b8O9hXaSWLk3N3k+IKS4AH5+fT5B3/t81uP4cG7
         j76w==
X-Gm-Message-State: ANoB5plRCgqPDf6AxFWsMlJiKCe2x6QYl++nHcSZrrvToOvKM+PpMqLV
        YNF2M/jzPqBDYjT0RZYjgWE=
X-Google-Smtp-Source: AA0mqf7RM62hvpDe1Iyas96saMrQdH99h6e2Duf4hvmk/fieEgnjvrkN2VJEKtE2wBFwTUxoO5DfIw==
X-Received: by 2002:a17:907:9951:b0:7b2:7e7a:11c1 with SMTP id kl17-20020a170907995100b007b27e7a11c1mr46466734ejc.684.1670057231439;
        Sat, 03 Dec 2022 00:47:11 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id q26-20020a170906389a00b007bdc2de90e6sm3964200ejd.42.2022.12.03.00.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 00:47:10 -0800 (PST)
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
Subject: [PATCH bpf-next,v6 0/4] xfrm: interface: Add unstable helpers for XFRM metadata
Date:   Sat,  3 Dec 2022 10:46:55 +0200
Message-Id: <20221203084659.1837829-1-eyal.birger@gmail.com>
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

changes in v6: fix sparse warning in patch 2
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
 include/net/xfrm.h                            |  17 +
 net/core/dst.c                                |   8 +-
 net/core/filter.c                             |   9 +
 net/xfrm/Makefile                             |   8 +
 net/xfrm/xfrm_interface_bpf.c                 | 115 ++++++
 ...xfrm_interface.c => xfrm_interface_core.c} |  14 +
 tools/include/uapi/linux/if_link.h            |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x    |   1 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/xfrm_info.c      | 365 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   3 +
 tools/testing/selftests/bpf/progs/xfrm_info.c |  35 ++
 13 files changed, 577 insertions(+), 2 deletions(-)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c

-- 
2.34.1

