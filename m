Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C4D6BF243
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCQUT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCQUT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:19:26 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC01E2B2BA;
        Fri, 17 Mar 2023 13:19:24 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i5so6521003pla.2;
        Fri, 17 Mar 2023 13:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679084364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nhKuiF4yOlwvdXcqUz6oqVKPkA7LG9Jwlt+JVQtyZLg=;
        b=m65RCSVYs/VqFfDXWUeN9nMF5Ao2s1UgHBJdALbFDbGAiThYtY1P1ss8raKseGs7XV
         +Qfqz9tVbkJuPHD+Lg+dI5y0jeblJ7LZw341dDVR+BCCyW4HDPnw442LFKJf2Io01p8v
         XbNhK5SEwjL/Wc4Zs2/xzEIvwXP2Nx0NXfJT1rN9X2WqhrjfCk5LPWIOT6ELEkInkwHB
         5Jv5hvbOkomVmAtZ0WYNEZyfrSduRZh0Ku23CH3e8AE/t5EYGzdj4Dmh5do/6ywVrOij
         M7u5S7gFDgMXcWzqV9jrmsjh4PzHYT8LnmlZSb1IYppjF/LuOwNKy2ZYmxkjsEkXwDCl
         3DiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nhKuiF4yOlwvdXcqUz6oqVKPkA7LG9Jwlt+JVQtyZLg=;
        b=QmZx047O8XHD06VN4XEXr4EhW9huJSKzWqnvDnw/lWtfTMSTwO0ohkECAwgORYieWL
         G01YIPhemfo1quUcOyERguYPMOy950v2zVCToUK+6CShnUNKEBJZ3B4xpNzt8oaN3WjP
         ln8LCEcCVDpraBwSJJ4AgXUbu4PcpHSwEUf1jOgPTIX0ylJ29l8pbV2CuPcs03hYn+4R
         XYSu1kAmz+V9M0mSg+uAGlakqj//fOgdYShpfQ/4+dB7mh+GnsNSzP3rNZFOfU/nxAw5
         PZyHZGmZn8Za+F+mxiL5OSuQhbb3rvtfZk6qR3qk/uVjA43IEWsiEQvmgVqA5RP1mkTz
         SbiA==
X-Gm-Message-State: AO0yUKVhJABeJgzXDyLqqxSOZ5NPZ9i0T1v83cbqjZ4RpXs/PFO73YDu
        n37esJLhfQrtUsaD0B4gA+BZZspq5Dg=
X-Google-Smtp-Source: AK7set/ZJYKP2FdyuBphzCY1ZYL54BSctXMZ6fNg9qcKhV5W2Xz7MjE2fmW44pPuAQHb+CbM9MhspQ==
X-Received: by 2002:a17:902:eccc:b0:19a:6acc:1de2 with SMTP id a12-20020a170902eccc00b0019a6acc1de2mr9634610plh.35.1679084364229;
        Fri, 17 Mar 2023 13:19:24 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id t187-20020a635fc4000000b0050be5236546sm1888411pgb.59.2023.03.17.13.19.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Mar 2023 13:19:23 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/4] bpf: Add detection of kfuncs.
Date:   Fri, 17 Mar 2023 13:19:16 -0700
Message-Id: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexei Starovoitov <ast@kernel.org>

Allow BPF programs detect at load time whether particular kfunc exists.

Patch 1: Allow ld_imm64 to point to kfunc in the kernel.
Patch 2: Fix relocation of kfunc in ld_imm64 insn when kfunc is in kernel module.
Patch 3: Introduce bpf_ksym_exists() macro.
Patch 4: selftest.

NOTE: detection of kfuncs from light skeleton is not supported yet.

Alexei Starovoitov (4):
  bpf: Allow ld_imm64 instruction to point to kfunc.
  libbpf: Fix relocation of kfunc ksym in ld_imm64 insn.
  libbpf: Introduce bpf_ksym_exists() macro.
  selftests/bpf: Add test for bpf_ksym_exists().

 kernel/bpf/verifier.c                         | 17 ++++++++++------
 tools/lib/bpf/bpf_helpers.h                   |  3 +++
 tools/lib/bpf/libbpf.c                        |  6 ++++++
 .../selftests/bpf/progs/task_kfunc_success.c  | 20 ++++++++++++++++++-
 4 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.34.1

