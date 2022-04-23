Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744D850CAF2
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiDWOE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiDWOEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:04:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C53DBF59;
        Sat, 23 Apr 2022 07:01:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c12so16969563plr.6;
        Sat, 23 Apr 2022 07:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H3CJvqG5s6/hMko5YEaZXZn/sObbb3sfE0IRGAk5o8E=;
        b=UgeesNcGviRFqNGb7Z5B+GN6MnXKUWTFFttkPALGHubFVtZgAHaHjcpk+Rr/q/qCwj
         9puIAkeVq/QciPULw0pJw47JgllTETP4zdBLJIX4NUpRyuV6JMcmc+fCtG9zBHHhd8p+
         grQwkC8St00QRPNZXBmMdN767seNvSf0Z2mxLNbEIykvygkNDEfFuQUAlXNyIsyD03wn
         L86/JMtYC0Pfybo7ffI+nZZwmgZATWDXPrqGrRAvivDsR9DppjTqjk2DxZhSTjQHBLyk
         5qit3u0M4lkxfTZ+pqKH7EU2/Iu5C9PntvvOtGOip24KwnLMheMrvAD0IVlnFe+2DuuF
         Wvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H3CJvqG5s6/hMko5YEaZXZn/sObbb3sfE0IRGAk5o8E=;
        b=v4sdpgiMRpsaUpWFXroam8GO14ifgR2iG7rNMQVxHS5JZAC+F2omBrESHPWAWouKwI
         ZJxfrcBr/w/6Ii1QK7Vorpm1gBKr09ShbFHQ/xJeayfV9+zW2osELpw8Xg76tr+90DGv
         i2Bpz1m8SM9jdf8porZM8BKgNhm1OcV3ZO7npx0BOXROxV9gkCSjuXu0W9jHy+36iCoj
         Ku4bGJH1w269yPI6QyoRJn5yFIwezQvF1JVGzeQRV0OQ+y9vU1vKXSWdjWCIExRwOZL9
         RfCjzoDKO+tvTX5q9vKzSN6vf8vC4Fb/OT3u871c/uQp7UPfjBrR0UiIN/k0c3nKjvj6
         z+hw==
X-Gm-Message-State: AOAM530BgYQYy13zcVpQ7rDbf/Kg3ElYzTZoi8VrYItWkycNjggPY+Qg
        sDulA8ZnTnJR84lz4ats6jY=
X-Google-Smtp-Source: ABdhPJzCQzYgB6gnZ0FDpbZJujROM2lSqmH2Hfbhy0ATqoN5sUnbto7snxFYmA/a+0uDswL6LZhGUQ==
X-Received: by 2002:a17:902:6a8a:b0:156:8ff6:daf0 with SMTP id n10-20020a1709026a8a00b001568ff6daf0mr9535201plk.117.1650722513717;
        Sat, 23 Apr 2022 07:01:53 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:1e2f:5400:3ff:fef5:fd57])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a77c600b001cd4989fedcsm9282071pjs.40.2022.04.23.07.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:01:53 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 0/4] bpf: Generate helpers for pinning through bpf object skeleton 
Date:   Sat, 23 Apr 2022 14:00:54 +0000
Message-Id: <20220423140058.54414-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there're helpers for allowing to open/load/attach BPF object
through BPF object skeleton. Let's also add helpers for pinning through
BPF object skeleton. It could simplify BPF userspace code which wants to
pin the progs into bpffs.

After this change, with command 'bpftool gen skeleton XXX.bpf.o', the
helpers for pinning BPF prog will be generated in BPF object skeleton.

The new helpers are named with __{pin, unpin}_prog, because it only pins
bpf progs. If the user also wants to pin bpf maps, he can use
LIBBPF_PIN_BY_NAME.

Yafang Shao (4):
  libbpf: Define DEFAULT_BPFFS
  libbpf: Add helpers for pinning bpf prog through bpf object skeleton
  bpftool: Fix incorrect return in generated detach helper
  bpftool: Generate helpers for pinning prog through bpf object skeleton

 tools/bpf/bpftool/gen.c     | 18 ++++++++++-
 tools/lib/bpf/bpf_helpers.h |  2 +-
 tools/lib/bpf/libbpf.c      | 61 ++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h      | 10 ++++--
 tools/lib/bpf/libbpf.map    |  2 ++
 5 files changed, 88 insertions(+), 5 deletions(-)

-- 
2.17.1

