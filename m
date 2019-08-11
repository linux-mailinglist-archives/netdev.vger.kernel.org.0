Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B438289375
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 21:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfHKT6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 15:58:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:38216 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfHKT6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 15:58:38 -0400
Received: from 231.45.193.178.dynamic.wline.res.cust.swisscom.ch ([178.193.45.231] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hwtz8-0007lw-DS; Sun, 11 Aug 2019 21:58:34 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-08-11
Date:   Sun, 11 Aug 2019 21:58:34 +0200
Message-Id: <20190811195834.3430-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25538/Sun Aug 11 10:18:30 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) x64 JIT code generation fix for backward-jumps to 1st insn, from Alexei.

2) Fix buggy multi-closing of BTF file descriptor in libbpf, from Andrii.

3) Fix libbpf_num_possible_cpus() to make it thread safe, from Takshak.

4) Fix bpftool to dump an error if pinning fails, from Jakub.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 0a062ba725cdad3b167782179ee914a8402a0184:

  Merge tag 'mlx5-fixes-2019-07-25' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-07-26 14:26:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 4f7aafd78aeaf18a4f6dea9415df60e745c9dfa7:

  Merge branch 'bpf-bpftool-pinning-error-msg' (2019-08-09 17:38:53 +0200)

----------------------------------------------------------------
Alexei Starovoitov (2):
      bpf: fix x64 JIT code generation for jmp to 1st insn
      selftests/bpf: tests for jmp to 1st insn

Andrii Nakryiko (2):
      libbpf: fix erroneous multi-closing of BTF FD
      libbpf: set BTF FD for prog only when there is supported .BTF.ext data

Daniel Borkmann (1):
      Merge branch 'bpf-bpftool-pinning-error-msg'

Jakub Kicinski (2):
      tools: bpftool: fix error message (prog -> object)
      tools: bpftool: add error message on pin failure

Takshak Chahande (1):
      libbpf : make libbpf_num_possible_cpus function thread safe

 arch/x86/net/bpf_jit_comp.c                   |  9 ++++----
 tools/bpf/bpftool/common.c                    |  8 +++++--
 tools/lib/bpf/libbpf.c                        | 33 +++++++++++++++------------
 tools/testing/selftests/bpf/verifier/loops1.c | 28 +++++++++++++++++++++++
 4 files changed, 57 insertions(+), 21 deletions(-)
