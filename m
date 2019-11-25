Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F1F10885E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 06:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfKYFeR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Nov 2019 00:34:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfKYFeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 00:34:16 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAP5TQ3D022715
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 21:34:16 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wfny63vwj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 21:34:15 -0800
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 24 Nov 2019 21:34:14 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id CA3B4760FF1; Sun, 24 Nov 2019 21:34:12 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2019-11-24
Date:   Sun, 24 Nov 2019 21:34:12 -0800
Message-ID: <20191125053412.1172278-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-24_04:2019-11-21,2019-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 suspectscore=4 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1034 mlxscore=0 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 27 non-merge commits during the last 4 day(s) which contain
a total of 50 files changed, 2031 insertions(+), 548 deletions(-).

The main changes are:

1) Optimize bpf_tail_call() from retpoline-ed indirect jump to direct jump,
   from Daniel.

2) Support global variables in libbpf, from Andrii.

3) Cleanup selftests with BPF_TRACE_x() macro, from Martin.

4) Fix devmap hash, from Toke.

5) Fix register bounds after 32-bit conditional jumps, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

There are 3 patch sets pending that we still consider for this merge window,
so there could be one more PR shortly.

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, Jakub Kicinski, Jakub 
Sitnicki, John Fastabend, Naresh Kamboju, Tetsuo Handa

----------------------------------------------------------------

The following changes since commit c392bccf2c1075b5d2cc9022d0116a516acb721d:

  powerpc: Add const qual to local_read() parameter (2019-11-24 15:06:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to b553a6ec570044fc1ae300c6fb24f9ce204c5894:

  bpf: Simplify __bpf_arch_text_poke poke type handling (2019-11-24 17:12:11 -0800)

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge branch 'libbpf-global-vars'
      Merge branch 'jmp32-reg-bounds'
      selftests/bpf: Add BPF trampoline performance test
      Merge branch 'optimize-bpf_tail_call'

Andrii Nakryiko (7):
      selftests/bpf: Ensure no DWARF relocations for BPF object files
      libbpf: Refactor relocation handling
      libbpf: Fix various errors and warning reported by checkpatch.pl
      libbpf: Support initialized global variables
      selftests/bpf: Integrate verbose verifier log into test_progs
      libbpf: Fix bpf_object name determination for bpf_object__open_file()
      selftests/bpf: Ensure core_reloc_kernel is reading test_progs's data only

Daniel Borkmann (10):
      bpf, x86: Generalize and extend bpf_arch_text_poke for direct jumps
      bpf: Move bpf_free_used_maps into sleepable section
      bpf: Move owner type, jited info into array auxiliary data
      bpf: Add initial poke descriptor table for jit images
      bpf: Add poke dependency tracking for prog array maps
      bpf: Constant map key tracking for prog array pokes
      bpf, x86: Emit patchable direct jump as tail call
      bpf, testing: Add various tail call test cases
      bpf: Add bpf_jit_blinding_enabled for !CONFIG_BPF_JIT
      bpf: Simplify __bpf_arch_text_poke poke type handling

Jakub Kicinski (1):
      selftests, bpftool: Skip the build test if not in tree

Luc Van Oostenryck (1):
      xsk: Fix xsk_poll()'s return type

Martin KaFai Lau (1):
      bpf: Introduce BPF_TRACE_x helper for the tracing tests

Quentin Monnet (3):
      tools, bpftool: Fix warning on ignored return value for 'read'
      tools, bpf: Fix build for 'make -s tools/bpf O=<dir>'
      selftests, bpftool: Set EXIT trap after usage function

Toke Høiland-Jørgensen (1):
      xdp: Fix cleanup on map free for devmap_hash map type

Yonghong Song (2):
      bpf: Provide better register bounds after jmp32 instructions
      selftests/bpf: Add verifier tests for better jmp32 register bounds

 arch/x86/net/bpf_jit_comp.c                        | 229 +++++++---
 include/linux/bpf.h                                |  60 ++-
 include/linux/bpf_verifier.h                       |   3 +-
 include/linux/filter.h                             |  15 +
 kernel/bpf/arraymap.c                              | 205 ++++++++-
 kernel/bpf/core.c                                  |  73 ++-
 kernel/bpf/devmap.c                                |  74 ++--
 kernel/bpf/map_in_map.c                            |   5 +-
 kernel/bpf/syscall.c                               |  56 +--
 kernel/bpf/trampoline.c                            |   8 +-
 kernel/bpf/verifier.c                              | 139 +++++-
 net/xdp/xsk.c                                      |   8 +-
 tools/bpf/Makefile                                 |   6 +
 tools/bpf/bpftool/btf.c                            |   6 +-
 tools/lib/bpf/bpf_helpers.h                        |  13 -
 tools/lib/bpf/libbpf.c                             | 294 +++++++------
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/bpf_trace_helpers.h    |  58 +++
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   4 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  16 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 487 +++++++++++++++++++++
 .../selftests/bpf/prog_tests/test_overhead.c       | 142 ++++++
 tools/testing/selftests/bpf/progs/fentry_test.c    |  72 +--
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |  27 +-
 tools/testing/selftests/bpf/progs/fexit_test.c     |  83 +---
 tools/testing/selftests/bpf/progs/kfree_skb.c      |  43 +-
 tools/testing/selftests/bpf/progs/tailcall1.c      |  48 ++
 tools/testing/selftests/bpf/progs/tailcall2.c      |  59 +++
 tools/testing/selftests/bpf/progs/tailcall3.c      |  31 ++
 tools/testing/selftests/bpf/progs/tailcall4.c      |  33 ++
 tools/testing/selftests/bpf/progs/tailcall5.c      |  40 ++
 .../selftests/bpf/progs/test_core_reloc_arrays.c   |   4 +-
 .../bpf/progs/test_core_reloc_bitfields_direct.c   |   4 +-
 .../bpf/progs/test_core_reloc_bitfields_probed.c   |   4 +-
 .../bpf/progs/test_core_reloc_existence.c          |   4 +-
 .../selftests/bpf/progs/test_core_reloc_flavors.c  |   4 +-
 .../selftests/bpf/progs/test_core_reloc_ints.c     |   4 +-
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |   8 +-
 .../selftests/bpf/progs/test_core_reloc_misc.c     |   4 +-
 .../selftests/bpf/progs/test_core_reloc_mods.c     |   4 +-
 .../selftests/bpf/progs/test_core_reloc_nesting.c  |   4 +-
 .../bpf/progs/test_core_reloc_primitives.c         |   4 +-
 .../bpf/progs/test_core_reloc_ptr_as_arr.c         |   4 +-
 .../selftests/bpf/progs/test_core_reloc_size.c     |   4 +-
 tools/testing/selftests/bpf/progs/test_overhead.c  |  39 ++
 tools/testing/selftests/bpf/test_bpftool_build.sh  |  30 +-
 tools/testing/selftests/bpf/test_progs.c           |  18 +-
 tools/testing/selftests/bpf/test_progs.h           |  10 +-
 tools/testing/selftests/bpf/test_stub.c            |   4 +
 tools/testing/selftests/bpf/verifier/jmp32.c       |  83 ++++
 50 files changed, 2031 insertions(+), 548 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_trace_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tailcalls.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_overhead.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall2.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall3.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall4.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall5.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_overhead.c
