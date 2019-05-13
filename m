Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80751AE87
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 02:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfEMAPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 20:15:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:37124 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfEMAPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 20:15:41 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPycz-00076N-Qn; Mon, 13 May 2019 02:15:37 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-05-13
Date:   Mon, 13 May 2019 02:15:37 +0200
Message-Id: <20190513001537.16720-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25447/Sun May 12 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix out of bounds backwards jumps due to a bug in dead code
   removal, from Daniel.

2) Fix libbpf users by detecting unsupported BTF kernel features
   and sanitize them before load, from Andrii.

3) Fix undefined behavior in narrow load handling of context
   fields, from Krzesimir.

4) Various BPF uapi header doc/man page fixes, from Quentin.

5) Misc .gitignore fixups to exclude built files, from Kelsey.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit daf3ddbe11a2ff74c95bc814df8e5fe3201b4cb5:

  net: phy: realtek: add missing page operations (2019-05-10 15:20:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to e2f7fc0ac6957cabff4cecf6c721979b571af208:

  bpf: fix undefined behavior in narrow load handling (2019-05-13 02:05:50 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      libbpf: detect supported kernel BTF features and sanitize BTF

Daniel Borkmann (3):
      bpf: fix out of bounds backwards jmps due to dead code removal
      bpf: add various test cases for backward jumps
      Merge branch 'bpf-uapi-doc-fixes'

Kelsey Skunberg (1):
      selftests: bpf: Add files generated after build to .gitignore

Krzesimir Nowak (1):
      bpf: fix undefined behavior in narrow load handling

Quentin Monnet (4):
      bpf: fix script for generating man page on BPF helpers
      bpf: fix recurring typo in documentation for BPF helpers
      bpf: fix minor issues in documentation for BPF helpers.
      tools: bpf: synchronise BPF UAPI header with tools

 include/uapi/linux/bpf.h                    | 145 +++++++++++----------
 kernel/bpf/core.c                           |   4 +-
 kernel/bpf/verifier.c                       |   2 +-
 scripts/bpf_helpers_doc.py                  |   8 +-
 tools/include/uapi/linux/bpf.h              | 145 +++++++++++----------
 tools/lib/bpf/libbpf.c                      | 130 ++++++++++++++++++-
 tools/lib/bpf/libbpf_internal.h             |  27 ++++
 tools/lib/bpf/libbpf_probes.c               |  73 ++++++-----
 tools/testing/selftests/bpf/.gitignore      |   2 +
 tools/testing/selftests/bpf/verifier/jump.c | 195 ++++++++++++++++++++++++++++
 10 files changed, 551 insertions(+), 180 deletions(-)
 create mode 100644 tools/lib/bpf/libbpf_internal.h
