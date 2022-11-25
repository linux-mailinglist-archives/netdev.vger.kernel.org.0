Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695C06381DF
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 01:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKYAKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 19:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKYAKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 19:10:40 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB2D6D977;
        Thu, 24 Nov 2022 16:10:38 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1oyMIc-000EfA-W7; Fri, 25 Nov 2022 01:10:35 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-11-25
Date:   Fri, 25 Nov 2022 01:10:34 +0100
Message-Id: <20221125001034.29473-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26730/Thu Nov 24 09:18:49 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

Happy Thanksgiving!

The following pull-request contains BPF updates for your *net* tree.

We've added 10 non-merge commits during the last 8 day(s) which contain
a total of 7 files changed, 48 insertions(+), 30 deletions(-).

The main changes are:

1) Several libbpf ringbuf fixes related to probing for its availability, size
   overflows when mmaping a 2G ringbuf and rejection of invalid reservation
   sizes, from Hou Tao.

2) Fix a buggy return pointer in libbpf for attach_raw_tp function, from Jiri Olsa.

3) Fix a local storage BPF map bug where the value's spin lock field can get
   initialized incorrectly, from Xu Kuohai.

4) Two follow-up fixes in kprobe_multi BPF selftests for BPF CI, from Jiri Olsa.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Jiri Olsa

----------------------------------------------------------------

The following changes since commit ed1fe1bebe18884b11e5536b5ac42e3a48960835:

  net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims (2022-11-14 11:30:49 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 8be602dadb2febb5e4cb367bff1162205bcf9905:

  selftests/bpf: Make test_bench_attach serial (2022-11-21 11:52:01 -0800)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Bug fix and test case for special map value field '

Andrii Nakryiko (1):
      Merge branch 'libbpf: Fixes for ring buffer'

Hou Tao (5):
      bpf, perf: Use subprog name when reporting subprog ksymbol
      libbpf: Use page size as max_entries when probing ring buffer map
      libbpf: Handle size overflow for ringbuf mmap
      libbpf: Handle size overflow for user ringbuf mmap
      libbpf: Check the validity of size in user_ring_buffer__reserve()

Jiri Olsa (3):
      libbpf: Use correct return pointer in attach_raw_tp
      selftests/bpf: Filter out default_idle from kprobe_multi bench
      selftests/bpf: Make test_bench_attach serial

Xu Kuohai (2):
      bpf: Do not copy spin lock field from user in bpf_selem_alloc
      bpf: Set and check spin lock value in sk_storage_map_test

 kernel/bpf/bpf_local_storage.c                     |  2 +-
 kernel/events/core.c                               |  2 +-
 tools/lib/bpf/libbpf.c                             |  2 +-
 tools/lib/bpf/libbpf_probes.c                      |  2 +-
 tools/lib/bpf/ringbuf.c                            | 26 ++++++++++++----
 .../selftests/bpf/map_tests/sk_storage_map.c       | 36 ++++++++++++----------
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  8 ++---
 7 files changed, 48 insertions(+), 30 deletions(-)
