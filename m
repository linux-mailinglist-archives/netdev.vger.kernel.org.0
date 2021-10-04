Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6046B4208B3
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 11:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhJDJu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 05:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbhJDJux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 05:50:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0304AC061745;
        Mon,  4 Oct 2021 02:49:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q201so3343875pgq.12;
        Mon, 04 Oct 2021 02:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lGemrg4Muom6Cfwgs/hNeDxOfo3YFnX0lyDjrzWFdew=;
        b=B6Yd5CW5y64BXu3J4iKJ7Y5Y4qZHeUYSCYqxXpr3cYEZY/bxZXCIGilyVmgmpU6TBn
         waaE0cTRTWsOL7VJqVFEubGhHnacDxFh3xY2b0VlVaCjFUcvdHdY4/mbX7rdZRZPB2/B
         iA/gSRBl5M8hCDl2hTvCX7g5kvqJPCJfNp88/SLVhJHHOZKsoBc3EVbV9H88Veaz19/v
         C9i+6RtOBpjv29UU0ydIFuGFx/skbkGAZYSD3AqxWVZAsfzSsgP770luZxZafSrPIour
         fGQSk44YkdpF6bNe9rMA9i2J6SbXTfpn8tSOU8a0s8QB5WbbqWSaY4OAHhjL/5NXjurj
         k9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lGemrg4Muom6Cfwgs/hNeDxOfo3YFnX0lyDjrzWFdew=;
        b=dxvWnda4gOuOHW7BoOrLoCssjhhcp6c3FB5B4A3F2lv2AFmCFXB0ChCXTD0HERfv8n
         /j46D6l2wKwWTd66rAvKmh373absck7sV2yZQGLgMbLWS9Q3EDhnqYmf8oBvS+JrLWyW
         nqs64gOieJY+YiEJJExze1pI3SgSZuav6V87rQr9dpnzIVZ0OlhQtAbEzG3WXdhBtuUY
         BK5NH6ij0ZP8MJ0nA2cr/21cA05Hm+cXXzCi0vC+aVdyU37HUfQjv81JDquVR7bu91SB
         8MNaHyIyaFHY9tEyoiMGvk1tQwHTmHjYIAprRqZ2oevOm36HPxgh5EKBUMtWOfj5WIHb
         s87w==
X-Gm-Message-State: AOAM530TOl88MsKtUWecQqwM8fl5710Rv8+QOBr0S4GNmgRSVgLu5kzE
        ZlaSIYcYCTXV0ni729aemu4=
X-Google-Smtp-Source: ABdhPJwTXRNKqy3DHTvRLD3ayH1kyzlN+ZUiRpH355pRFZkFMR2LLGFkg0UzdNidkPTqLchKa+vNJA==
X-Received: by 2002:a63:bf4a:: with SMTP id i10mr10039386pgo.196.1633340944609;
        Mon, 04 Oct 2021 02:49:04 -0700 (PDT)
Received: from localhost ([27.102.113.79])
        by smtp.gmail.com with ESMTPSA id t9sm14715062pjq.20.2021.10.04.02.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:49:04 -0700 (PDT)
From:   Hou Tao <hotforest@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next v5 0/3] add support for writable bare tracepoint
Date:   Mon,  4 Oct 2021 17:48:54 +0800
Message-Id: <20211004094857.30868-1-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Hi,

The patchset series supports writable context for bare tracepoint.

The main idea comes from patchset "writable contexts for bpf raw
tracepoints" [1], but it only supports normal tracepoint with
associated trace event under tracefs. Now we have one use case
in which we add bare tracepoint in VFS layer, and update
file::f_mode for specific files. The reason using bare tracepoint
is that it doesn't form a ABI and we can change it freely. So
add support for it in BPF.

Comments are always welcome.

[1]: https://lore.kernel.org/lkml/20190426184951.21812-1-mmullins@fb.com

Change log:
v5:
 * rebased on bpf-next
 * patch 1: add Acked-by tag
 * patch 2: handle invalid section name, make prefixes array being const

v4: https://www.spinics.net/lists/bpf/msg47021.html
 * rebased on bpf-next
 * update patch 2 to add support for writable raw tracepoint attachment
   in attach_raw_tp().
 * update patch 3 to add Acked-by tag

v3: https://www.spinics.net/lists/bpf/msg46824.html
  * use raw_tp.w instead of raw_tp_writable as section
    name of writable tp
  * use ASSERT_XXX() instead of CHECK()
  * define a common macro for "/sys/kernel/bpf_testmod"

v2: https://www.spinics.net/lists/bpf/msg46356.html 
  * rebase on bpf-next tree
  * address comments from Yonghong Song
  * rename bpf_testmode_test_writable_ctx::ret as early_ret to reflect
    its purpose better.

v1: https://www.spinics.net/lists/bpf/msg46221.html


Hou Tao (3):
  bpf: support writable context for bare tracepoint
  libbpf: support detecting and attaching of writable tracepoint program
  bpf/selftests: add test for writable bare tracepoint

 include/trace/bpf_probe.h                     | 19 +++++++---
 tools/lib/bpf/libbpf.c                        | 26 +++++++++++---
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
 .../selftests/bpf/prog_tests/module_attach.c  | 35 +++++++++++++++++++
 .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
 tools/testing/selftests/bpf/test_progs.c      |  4 +--
 tools/testing/selftests/bpf/test_progs.h      |  2 ++
 9 files changed, 119 insertions(+), 11 deletions(-)

-- 
2.20.1

