Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96125E321
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgIDU5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgIDU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 16:57:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D6EC061247
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 13:57:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c15so8497785wrs.11
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s2VbCfmfs/2EKPhU6uZ6dyMExo1mi3OXRSsv4NCSYQE=;
        b=j9ngwIedSaoYiq0eW5bXcwSkf0Vu3hKWRNw+lJX8H9alkpcwzkJd7WoXOOYvpxMmF8
         57gmGz/YyVFhi+cB1dPhcBG4Pl73OlaJnGfR7h9aSNQ2Zi8SGGB4Srv+orgR/YSIhbuJ
         YKi7InR/JeLZgXlu17YaSmdizrVjGGiimGn6MM9zF2fefMSlhSukaLlP4duFYp+HUYVD
         g6xn5YthgzIxgsAIy4g7LIo43spm4eaU3w5lGqEAx1jkOcyGx06/k3mjzCOt5oFDwkoG
         m6j/MWFnVTSgQoEptzgea4ZsZaGpN80wiACDxeYmW5iRp2S3EWKTR9JSLgt1djVKdib7
         fjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s2VbCfmfs/2EKPhU6uZ6dyMExo1mi3OXRSsv4NCSYQE=;
        b=AD7og64JtPjCmUPaE62mSJwfx7XH6QHBJzf5Zupdcw3qAwQDTKPhAiDQ3vhxvEXh6k
         QfDdAaetYasGeYDqUASVBaJWkwW4SJp9/26F010IfSutgYpDfMe4hy18pp469eciZwnn
         EW/TesAmye3ikAgGq15mGbr0quJ26pub0KNZDPsGu1Bh6jGmFL/LDZYiCHp6RhcFXK2Z
         Nr986W6932aF8EB2qTQeVXQq7KCkFXRZA3y/2/PZijwOFNgMUguP5Ubk9CKm8JheRW1d
         7cTVI7n0yYeBxnAP3lmm3QRU37ecd0o4mbnQrdOGk4EfDmB73IikTnOGZSgq7IP1WJNd
         Op3Q==
X-Gm-Message-State: AOAM530xuZU3VFQvgB0PiQBLcDcvcbcoEUh/uBl7DsixXPpIMg+N+ihz
        ZKrYytHGgenjFjqM2/DXU42cUw==
X-Google-Smtp-Source: ABdhPJzffKSbbyulDjS5IdK2q00UuTG/fAXD41vOAAQ1/E+3KStJE7tT6bAIAk0gOxfNewbg9J14ew==
X-Received: by 2002:a5d:560d:: with SMTP id l13mr9054061wrv.49.1599253030911;
        Fri, 04 Sep 2020 13:57:10 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.177])
        by smtp.gmail.com with ESMTPSA id u17sm12985395wmm.4.2020.09.04.13.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 13:57:10 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/3] tools: bpftool: print built-in features, automate some of the documentation
Date:   Fri,  4 Sep 2020 21:56:54 +0100
Message-Id: <20200904205657.27922-1-quentin@isovalent.com>
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
 tools/bpf/bpftool/main.c                      | 22 ++++++++++++
 15 files changed, 68 insertions(+), 388 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/common_options.rst

-- 
2.25.1

