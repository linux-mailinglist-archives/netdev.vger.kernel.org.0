Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2012337232D
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhECWsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:48:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:38900 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECWsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 18:48:30 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ldhLg-000CIn-9n; Tue, 04 May 2021 00:47:32 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-05-04
Date:   Tue,  4 May 2021 00:47:31 +0200
Message-Id: <20210503224731.6963-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26159/Mon May  3 13:09:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 4 day(s) which contain
a total of 6 files changed, 52 insertions(+), 30 deletions(-).

The main changes are:

1) Fix libbpf overflow when processing BPF ring buffer in case of extreme
   application behavior, from Brendan Jackman.

2) Fix potential data leakage of uninitialized BPF stack under speculative
   execution, from Daniel Borkmann.

3) Fix off-by-one when validating xsk pool chunks, from Xuan Zhuo.

4) Fix snprintf BPF selftest with a pid filter to avoid racing its output
   test buffer, from Florent Revest.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, John Fastabend, Magnus Karlsson, 
Piotr Krysiuk

----------------------------------------------------------------

The following changes since commit d4eecfb28b963493a8701f271789ff04e92ae205:

  net: dsa: ksz: ksz8863_smi_probe: set proper return value for ksz_switch_alloc() (2021-04-29 15:54:35 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to ac31565c21937eee9117e43c9cd34f557f6f1cb8:

  xsk: Fix for xp_aligned_validate_desc() when len == chunk_size (2021-05-04 00:28:06 +0200)

----------------------------------------------------------------
Brendan Jackman (1):
      libbpf: Fix signed overflow in ringbuf_process_ring

Daniel Borkmann (2):
      bpf: Fix masking negation logic upon negative dst register
      bpf: Fix leakage of uninitialized bpf stack under speculation

Florent Revest (1):
      selftests/bpf: Fix the snprintf test

Xuan Zhuo (1):
      xsk: Fix for xp_aligned_validate_desc() when len == chunk_size

 include/linux/bpf_verifier.h                      |  5 ++--
 kernel/bpf/verifier.c                             | 33 ++++++++++++-----------
 net/xdp/xsk_queue.h                               |  7 +++--
 tools/lib/bpf/ringbuf.c                           | 30 ++++++++++++++-------
 tools/testing/selftests/bpf/prog_tests/snprintf.c |  2 ++
 tools/testing/selftests/bpf/progs/test_snprintf.c |  5 ++++
 6 files changed, 52 insertions(+), 30 deletions(-)
