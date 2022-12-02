Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED386403E4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiLBJ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiLBJ7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:59:34 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C095BD8AC;
        Fri,  2 Dec 2022 01:59:33 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f18so7013481wrj.5;
        Fri, 02 Dec 2022 01:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UTPrzoP+SGh03HmopNhpASmjnce6kJFYd8daB4Hq44k=;
        b=dWNeN3Y0oPlCIUgSBFx8GW/Ql6s3KxAxFhykMmbkE3STNifQY6qf9lHOxXwMxWhFqc
         b/j8GDO7D8TzoSTFmlkQXD8XkVA6jEJfPvWnGO8HGZTC2+YULheWuTkIhnsJYhy4MbEx
         qQmCPamdemAZ8red5Dn7c2syo0haTu5SBlyPRFq+xJeHkMb3hNqe+PTWsWlEOTDyzCBu
         BWRj1u3fiN+XVYnj0ClTWNyy5FJTbAkLIK8tFd4l44kxsOZQiQ9vrgliKr/cCtAROh/m
         Ogjc8DPEVJjn2YaIujZ1gXdb1IKI7YJG0LqGAwvXeIAc/v7Q52iMcQnFEk4i6tRW/YRU
         h+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UTPrzoP+SGh03HmopNhpASmjnce6kJFYd8daB4Hq44k=;
        b=UmyHw3zZDE5OvWjTRjbUz/j2+hozqI5KcEQA9JqNn0yQRvLFdIAsm8j451GY939KX5
         lqfhH32+e7KyKbrptHFWYM3TJDUWUiHzCkdfTansjnizepwWSguoAWCEcFRXTuRES8zB
         L8XTH/D9fJjeEacNy2k1dijOs+w2ZVimW8UKgcBmQru/5Hm5JvBf12jHYTl7JVePy3yx
         D887gjWR60ciesf8WLFdC0OnzH+18eNZ4Xx8hfxa+3fmmpUgrynKQrHUan9Rn0LlLDpb
         LMhuzg/IhnXsgM3/d32OvHd3ULBk7iuVXUvLHem12euShvqQ4y+p44HROUCAloH6Yv9M
         580A==
X-Gm-Message-State: ANoB5pnJgz/AsJ5rKNCtWEpJY0OIJ8s3LEPYjk9ADTHea+RaoRE8iyaf
        E6voTlkPTJvR4T+0WRaLE84=
X-Google-Smtp-Source: AA0mqf5JNyIxpO047SssifwoiMQqHBpwCbrswENFnMYaNs5Nk//LWEVpKaquqXTd4GbhqwQIZRpBxQ==
X-Received: by 2002:a5d:4dd0:0:b0:241:fa43:d982 with SMTP id f16-20020a5d4dd0000000b00241fa43d982mr26246364wru.134.1669975171806;
        Fri, 02 Dec 2022 01:59:31 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id s1-20020adfdb01000000b002420a2cdc96sm6517851wri.70.2022.12.02.01.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:59:31 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v4 0/4] xfrm: interface: Add unstable helpers for XFRM metadata
Date:   Fri,  2 Dec 2022 11:59:16 +0200
Message-Id: <20221202095920.1659332-1-eyal.birger@gmail.com>
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

Series changes in v3:
  - tag bpf-next tree instead of ipsec-next
  - add IFLA_XFRM_COLLECT_METADATA sync patch

Eyal Birger (4):
  xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
  xfrm: interface: Add unstable helpers for setting/getting XFRM
    metadata from TC-BPF
  tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
  selftests/bpf: add xfrm_info tests

 include/net/dst_metadata.h                    |   1 +
 include/net/xfrm.h                            |  20 +
 net/core/dst.c                                |   8 +-
 net/xfrm/Makefile                             |   8 +
 net/xfrm/xfrm_interface_bpf.c                 | 123 ++++++
 ...xfrm_interface.c => xfrm_interface_core.c} |  15 +
 tools/include/uapi/linux/if_link.h            |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x    |   1 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/xfrm_info.c      | 365 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   3 +
 tools/testing/selftests/bpf/progs/xfrm_info.c |  35 ++
 12 files changed, 580 insertions(+), 2 deletions(-)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c

-- 
2.34.1

