Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF963AD3E
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiK1QFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiK1QFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:05:22 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFE31F2E2;
        Mon, 28 Nov 2022 08:05:21 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m19so14831679edj.8;
        Mon, 28 Nov 2022 08:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VcZwO2BYwA0HYKtnUpGOJMeOkj2UteUeqGK9/mCZ7sg=;
        b=GYCSlaGixTxRbLgl1HBMvKudVmF+HIbOg/6p/o1VmJokmMB6pKS2yfbCSFzSN3gBBF
         x6RkiG8pdnI1M5zlkJ/xnp3eOkZSV5Av++kNKW2OW5KuWQFGj1bjHSRweZCUZ+FJEyMe
         ZwLEifmKfCgXz4NSDgcwSZ2HmZqjfdjI/VLWEPCxZAcjy+DhE+mqMBXUZ78UleqWpnWL
         lWI5Z9hrPgnMI/3g2MO2VRaoxKMoJvTIz6C0E9VsBmH/XMJW+bOHLoNBjMc0TUq4UFLZ
         rL8hx7cHaoiP0/CiVwANl7ZZjB+fv5si9GZ19gZ8Yg2bWje9VlZQv073snLss9To9DMl
         AaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VcZwO2BYwA0HYKtnUpGOJMeOkj2UteUeqGK9/mCZ7sg=;
        b=dmGx07sGIteJUdJ0J76OGifningBI4yz18ggKQSzeujmioR4E0z6BQoF2oixcmNiT8
         fKHV6f2mG2kKr//uPy0IEsc2JziRofqxmzk3rwoy+y4OxH+RIp1z/zr51AOtr0qi4CUD
         EKpO4OLzvrPGpStN6xAKLmjhailrBARfo8Ilzyl/EW3xCMXVqhEgv+ooGUhU9pJZiQlz
         SZwWdvRLuEeFOzSB1XhjyhyMEYOaFjAFBFjRO56/PMFfBWOg0i5XHSWz4Dyd/xZ98RCi
         LtJYaa+KC6B/9TyakzFCT+OW3Gu6y6KBJuZGjbeOqw0WHQknDps8to5I9byNHuNMfF/V
         FQJg==
X-Gm-Message-State: ANoB5pnlU346G5mB67mc5noXHtv/tomxViTdqoUiXVZkP1HtaNslwGNZ
        gx0O0a8MqZWgsMl1zmn+XnU=
X-Google-Smtp-Source: AA0mqf5FGSkgk19KLsCxe+qrEwpOc8/60ZgsEyB8ITs52qcuL4cEc3Iv4JbZoFBsFhYPq0o/+pBVfg==
X-Received: by 2002:aa7:c54c:0:b0:469:10c6:19d2 with SMTP id s12-20020aa7c54c000000b0046910c619d2mr33051772edr.243.1669651520001;
        Mon, 28 Nov 2022 08:05:20 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id w21-20020a170906385500b0077a201f6d1esm5127264ejc.87.2022.11.28.08.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:05:19 -0800 (PST)
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
Subject: [PATCH ipsec-next 0/3] xfrm: interface: Add unstable helpers for XFRM metadata
Date:   Mon, 28 Nov 2022 18:04:58 +0200
Message-Id: <20221128160501.769892-1-eyal.birger@gmail.com>
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
 net/core/dst.c                                |   4 +
 net/xfrm/Makefile                             |   8 +
 net/xfrm/xfrm_interface_bpf.c                 |  92 +++++
 ...xfrm_interface.c => xfrm_interface_core.c} |  15 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/test_xfrm_info.c | 342 ++++++++++++++++++
 .../selftests/bpf/progs/test_xfrm_info_kern.c |  74 ++++
 9 files changed, 558 insertions(+)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c

-- 
2.34.1

