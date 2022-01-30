Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7B34A3556
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 10:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354453AbiA3J3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 04:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiA3J3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 04:29:53 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F025C061714;
        Sun, 30 Jan 2022 01:29:53 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so7753909pjq.3;
        Sun, 30 Jan 2022 01:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tpEvQsSuiYpBjJy3eGHkzJZD+Ume3n8lx1ImopJLRGQ=;
        b=nn0JIniocfx4raCSkUNCrTHItInul+TnBgK+Nzs50i3wc9aEkob2Em/XD2L4iuUSB6
         +W2gONDcWVKBAeMKhMrbmOy+NQaykceuVIpTjSz7HEP+6PjK1DSNnTz5SY8FkHx6vwWV
         hO0ptfJoX+9x9de+2pCk/SRZmWfSRpkjnuLG3pvWid0giJvpBaZQyU9n4Zefj5yg1NVl
         RMODlhUgGu2lqtut8prQhlLXDiKKiits5D2ap6IHte/GTaZf/rzTzfZALbHgbsf7CiCp
         aguK1aZzWX5IqG6jSPt5YEXo2Dr8r3XrOWh/6zMsAMdAStiWh8zCLpm+g7f5G8KVWsMi
         ZBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tpEvQsSuiYpBjJy3eGHkzJZD+Ume3n8lx1ImopJLRGQ=;
        b=GgD4H8yGfsCweaL1Fkj4MM5WM3X5PnA6TnLtwpl6cbwTNidcKLa/zDUoTgSTPGoAUM
         /BG0CAAzeoC/ENmAif2Mg+ncNMgJEluWNl2EoBr2Z5uv6c71RIqNgdoolGp0enLjSLLb
         X063P3fBvEnP+ugIu+EXQ/gAi/BNLvxgmsAOD2NV9u0+2eiiZjSsZ0D5zKyasvs4h5CK
         6X95HF+YkLvWuCBgRAQMWTuHfroPUiNQhraFfPpnGOREF0isoaS/5hkGD4J3V2f8RCNb
         fq1tG5/fRNNsm3x16MX00AT2norXFkoBbcJ1vfz11fZoxYSASPe4xApS8HsiwpKabmSe
         zQHg==
X-Gm-Message-State: AOAM532Jc7iUUaZow8YUsq+tgURhRyDdd0AxYo7twBelWHCxmg16XP5Z
        THBil35DE2K19QDjMEtubvI=
X-Google-Smtp-Source: ABdhPJyGzk/8W/xQcfKS7DGHOkiwapqdHyXfHjy4HSzKOioQd6oz2ecaMPwDFPDCB5z7vm6e29YC2w==
X-Received: by 2002:a17:902:a505:: with SMTP id s5mr16125096plq.157.1643534992605;
        Sun, 30 Jan 2022 01:29:52 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id b4sm15446509pfl.106.2022.01.30.01.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:29:51 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        linux-arm-kernel@lists.infradead.org, Hou Tao <hotforest@gmail.com>
Subject: [PATCH bpf-next v3 0/3] bpf, arm64: enable kfunc call
Date:   Sun, 30 Jan 2022 17:29:14 +0800
Message-Id: <20220130092917.14544-1-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The simple patchset tries to enable kfunc call for arm64. Patch #1 just
overrides bpf_jit_supports_kfunc_call() to enable kfunc call, patch #2
unexports the subtests in ksyms_module.c to fix the confusion in test
output and patch #3 add a test in ksyms_module.c to ensure s32 is
sufficient for kfunc offset.

Change Log:
v3:
  * patch #2: newly-addded to unexport unnecessary subtests
  * patch #3: use kallsyms_find() instead of reimplementing it.
  * patch #3: ensure kfunc call is supported before checking
              whether s32 will be overflowed or not.

v2: https://lore.kernel.org/bpf/20220127071532.384888-1-houtao1@huawei.com/
  * add a test to check whether imm will be overflowed for kfunc call

v1: https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com

Hou Tao (3):
  bpf, arm64: enable kfunc call
  selftests/bpf: do not export subtest as standalone test
  selftests/bpf: check whether s32 is sufficient for kfunc offset

 arch/arm64/net/bpf_jit_comp.c                 |  5 ++
 .../selftests/bpf/prog_tests/ksyms_module.c   | 46 ++++++++++++++++++-
 .../bpf/prog_tests/xdp_adjust_frags.c         |  6 ---
 .../bpf/prog_tests/xdp_adjust_tail.c          |  4 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  4 +-
 .../bpf/prog_tests/xdp_devmap_attach.c        |  2 +-
 6 files changed, 54 insertions(+), 13 deletions(-)

-- 
2.20.1

