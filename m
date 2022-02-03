Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173E84A882A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352059AbiBCP6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:58:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:33446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242285AbiBCP6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:58:17 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFeUx-000Gce-W9; Thu, 03 Feb 2022 16:58:16 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2022-02-03
Date:   Thu,  3 Feb 2022 16:58:15 +0100
Message-Id: <20220203155815.25689-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26442/Thu Feb  3 10:22:25 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 6 non-merge commits during the last 10 day(s) which contain
a total of 7 files changed, 11 insertions(+), 236 deletions(-).

The main changes are:

1) Fix BPF ringbuf to allocate its area with VM_MAP instead of VM_ALLOC
   flag which otherwise trips over KASAN, from Hou Tao.

2) Fix unresolved symbol warning in resolve_btfids due to LSM callback
   rename, from Alexei Starovoitov.

3) Fix a possible race in inc_misses_counter() when IRQ would trigger
   during counter update, from He Fengqing.

4) Fix tooling infra for cross-building with clang upon probing whether
   gcc provides the standard libraries, from Jean-Philippe Brucker.

5) Fix silent mode build for resolve_btfids, from Nathan Chancellor.

6) Drop unneeded and outdated lirc.h header copy from tooling infra as
   BPF does not require it anymore, from Sean Young.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, John Fastabend, Nathan Chancellor, Shuah Khan

----------------------------------------------------------------

The following changes since commit e52984be9a522fb55c8f3e3df860d464d6658585:

  Merge tag 'linux-can-fixes-for-5.17-20220124' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can (2022-01-24 12:17:58 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 7f3bdbc3f13146eb9d07de81ea71f551587a384b:

  tools/resolve_btfids: Do not print any commands when building silently (2022-02-03 16:28:49 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Fix renaming task_getsecid_subj->current_getsecid_subj.

He Fengqing (1):
      bpf: Fix possible race in inc_misses_counter

Hou Tao (1):
      bpf: Use VM_MAP instead of VM_ALLOC for ringbuf

Jean-Philippe Brucker (1):
      tools: Ignore errors from `which' when searching a GCC toolchain

Nathan Chancellor (1):
      tools/resolve_btfids: Do not print any commands when building silently

Sean Young (1):
      tools headers UAPI: remove stale lirc.h

 kernel/bpf/bpf_lsm.c                               |   2 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/trampoline.c                            |   5 +-
 tools/bpf/resolve_btfids/Makefile                  |   6 +-
 tools/include/uapi/linux/lirc.h                    | 229 ---------------------
 tools/scripts/Makefile.include                     |   2 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   1 -
 7 files changed, 11 insertions(+), 236 deletions(-)
 delete mode 100644 tools/include/uapi/linux/lirc.h
