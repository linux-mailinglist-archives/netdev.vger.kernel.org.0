Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B167B25FFD1
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgIGQia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730946AbgIGQiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:38:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74FEC061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:38:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so2123966wmi.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jWk4nkLLyrHboAdsfa8uYQwdthzQYMkDhW9EJWZBW7A=;
        b=CPg9ttNwJtUWrqYC1wKGCBWzVe2egQVfJ8W5ZkiYQrjdyJd6VIO7HH1Gx11+EtBUNa
         I2zxjdpE2PiboglqaM0TmZ7GWZDd0G7C3015kTXb4d3WG2cdhMGyWOI9KtlhRNBQf4VF
         lkJNfF2oQCwP8Hlvk5vFvZmXBNSsvGabP0VnjrmLsplryVW7TrJZ3UxIPQMLsazu4/wi
         Ev4/CtXjEl+tAvAovxSUr1nqHk5KNpXfvbHWLdMOFfuj980YT9h3nPwJkd00BsUOEujN
         kaqrJr5b/tU0zX7FedE/yN7zJVLFGcy3uZVZSAqtRsOkLifSDEZV63N5uC8rUghXQ2QV
         2ENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jWk4nkLLyrHboAdsfa8uYQwdthzQYMkDhW9EJWZBW7A=;
        b=Y+rjAfxJ6m2HRs0UURR9U36qewqHhVGoJ3YoxyKhFZLem+/I+Qm7ybkRCqRkoTmRbv
         XsibA/cE/e+D/w7AubTR3+qvVelWbFrR0O1ECQi7Np4Y9Lxmpec3LDwJFFTsPcDc0C/6
         yyRpm35rHiEGTfqC44GDfcHfzaW9ejYIxaCKYMCXBgj//G8F4OiU8rxQRyNPx9/aWupL
         HacNfdlV2GlqYAuGGIb36h+8T/wVr6uSNEl51jPBEiAsLGBBROGNIyPe5JOwcJ7hNC9c
         xpEOiwN8RjmFpebbU9HGDGV8ovpVmO2T+J+gFYi0EX4kJpUlGbqHahCPBsu7ZHmhHL8m
         HUAA==
X-Gm-Message-State: AOAM532MqHFM3BOPTyA0ZQCRKO5MsOeapZcEuza+WSsacbyQRYX1YuJx
        hzXQic0yQUG9xetYlczwK9W+YA==
X-Google-Smtp-Source: ABdhPJzUSSCGWpdzfRI7CKoAPaKEGnKwtAHBZ4ctXUKJ09MYzd3BxcddK4erW9ay29vF+o1sw6QTCg==
X-Received: by 2002:a1c:c910:: with SMTP id f16mr184459wmb.82.1599496686477;
        Mon, 07 Sep 2020 09:38:06 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.17])
        by smtp.gmail.com with ESMTPSA id g12sm26546580wro.89.2020.09.07.09.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:38:06 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/3] tools: bpftool: print built-in features, automate some of the documentation
Date:   Mon,  7 Sep 2020 17:38:01 +0100
Message-Id: <20200907163804.29244-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two changes for bpftool in this series.

The first one is a modification to the "version" command, to have it print
the status (compiled or not) of some of the optional features for bpftool.
This is to help determine if a bpftool binary is able to, for example,
disassemble JIT-compiled programs.

The last two patches try to automate the generation of some repetitive
sections in the man pages for bpftool, namely the description of the
options shared by all commands, and the "see also" section. The objective
is to make it easier to maintain the pages and to reduce the risk of
omissions when adding the documentation for new commands.

v2:
- Fix incorrect JSON output.
- Use "echo -n" instead of "printf" in Makefile to avoid the risk of
  passing and evaluating formatting strings.

Quentin Monnet (3):
  tools: bpftool: print optional built-in features along with version
  tools: bpftool: include common options from separate file
  tools: bpftool: automate generation for "SEE ALSO" sections in man
    pages

 tools/bpf/bpftool/Documentation/Makefile      | 14 ++++++--
 .../bpf/bpftool/Documentation/bpftool-btf.rst | 34 +-----------------
 .../bpftool/Documentation/bpftool-cgroup.rst  | 33 +----------------
 .../bpftool/Documentation/bpftool-feature.rst | 33 +----------------
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 33 +----------------
 .../bpftool/Documentation/bpftool-iter.rst    | 27 +-------------
 .../bpftool/Documentation/bpftool-link.rst    | 34 +-----------------
 .../bpf/bpftool/Documentation/bpftool-map.rst | 33 +----------------
 .../bpf/bpftool/Documentation/bpftool-net.rst | 34 +-----------------
 .../bpftool/Documentation/bpftool-perf.rst    | 34 +-----------------
 .../bpftool/Documentation/bpftool-prog.rst    | 34 +-----------------
 .../Documentation/bpftool-struct_ops.rst      | 35 +------------------
 tools/bpf/bpftool/Documentation/bpftool.rst   | 34 +-----------------
 .../bpftool/Documentation/common_options.rst  | 22 ++++++++++++
 tools/bpf/bpftool/main.c                      | 26 ++++++++++++--
 15 files changed, 70 insertions(+), 390 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/common_options.rst

-- 
2.25.1

