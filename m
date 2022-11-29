Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0D363C0DF
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiK2NVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiK2NVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:21:30 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9512E6AA;
        Tue, 29 Nov 2022 05:21:29 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ud5so33728856ejc.4;
        Tue, 29 Nov 2022 05:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BEXWF8wgzcW7ZxjWPkx8+f4d2FRc8kR6F94i8AKGlUg=;
        b=HK/K2+2FWyjoqylZx2+vJVjnkw1p19ppDmICsC1ofo5sLP3pBdzAd53N7Nnos/UxGx
         lqoPx63RqsxGc27X3QJbvWN6EhGuGlTam88Pht0puI8VI3FzYn7ACSpVh3ltZeMIMHfq
         ClKTPuMNTb21oCLjT4AC2thFqyM9oHWbEiO2C+nvR6T9Csu5Q0YcA8NIkgqmjv95vKY3
         2LWcbybG8S063IHIFERLvBKl6pLKjkI7DUZgF2GcCK4ItO074s/HbG1jVAo3Z1ZS648N
         FYqW2b0k30dZIkjQbPZPrEZl26YadVRHlxTipuedQ1P2hZstWKYBJKpBiYv+/0MDaVM8
         GQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BEXWF8wgzcW7ZxjWPkx8+f4d2FRc8kR6F94i8AKGlUg=;
        b=g37hgP1aEO5aNLfsCKLaLBWYHVY4LrYQhigkMMQ4ChYQcUYMV1rosF8zlIscCv01y3
         iw4/7PS9PJOwJnnGUkMGPfazm27NEzIdNV8+LGvu17gt3sr9U8eWqamj3nBLI7hVzEXc
         B30+xnqZIHZ8GxcLHNwKK3I2E2ma2EmXv1xzXpl/1+6FgR4PTbBMN5/54ebPnT3iRcW8
         fkVfernDSiS6AeXCgya3HbmfushAOIZnjuUdpiDGtwfZ8ekVGTcSNKC+gLMPms35q5WN
         AceZ+9jY9uR6TP9Mc5bqw8gfbrE8QjrdgC73JhovbM619i6NEwVC99q1k5CVT3xBhkyy
         EV3g==
X-Gm-Message-State: ANoB5pmyBaMBbFN4Z8U9Et1D/mnC82hVckc9rIeS8k+yb3XPvGT3XQJ8
        JftE2UDVtcLBQ49/6kstxaM=
X-Google-Smtp-Source: AA0mqf6RtGGkq6T8Wnu1E/U7OSSnj6Hov/AcUY+iag3ZCepKSrzMTbng17pYZEAnBUOf4iOa6neuXQ==
X-Received: by 2002:a17:906:c18c:b0:7b2:8a6e:c569 with SMTP id g12-20020a170906c18c00b007b28a6ec569mr48548337ejz.582.1669728087975;
        Tue, 29 Nov 2022 05:21:27 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id v25-20020aa7d9d9000000b00458a03203b1sm6252632eds.31.2022.11.29.05.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 05:21:27 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v2 0/3] xfrm: interface: Add unstable helpers for XFRM metadata
Date:   Tue, 29 Nov 2022 15:20:15 +0200
Message-Id: <20221129132018.985887-1-eyal.birger@gmail.com>
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

Eyal Birger (3):
  xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
  xfrm: interface: Add unstable helpers for setting/getting XFRM
    metadata from TC-BPF
  selftests/bpf: add xfrm_info tests

 include/net/dst_metadata.h                    |   1 +
 include/net/xfrm.h                            |  20 +
 net/core/dst.c                                |   8 +-
 net/xfrm/Makefile                             |   8 +
 net/xfrm/xfrm_interface_bpf.c                 | 100 +++++
 ...xfrm_interface.c => xfrm_interface_core.c} |  15 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/test_xfrm_info.c | 343 ++++++++++++++++++
 .../selftests/bpf/progs/test_xfrm_info_kern.c |  74 ++++
 9 files changed, 569 insertions(+), 2 deletions(-)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c

-- 
2.34.1

