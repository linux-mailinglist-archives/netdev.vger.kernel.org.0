Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B050DE515B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633073AbfJYQhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:37:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:52446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbfJYQhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:37:19 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO2aT-0003aQ-AP; Fri, 25 Oct 2019 18:37:17 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 0/5] Fix BPF probe memory helpers
Date:   Fri, 25 Oct 2019 18:37:06 +0200
Message-Id: <cover.1572010897.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds probe_read_{user,kernel}(), probe_read_str_{user,kernel}()
helpers, fixes probe_write_user() helper and selftests. For details please
see individual patches.

Thanks!

Daniel Borkmann (5):
  uaccess: Add non-pagefault user-space write function
  bpf: Make use of probe_user_write in probe write helper
  bpf: Add probe_read_{user,kernel} and probe_read_str_{user,kernel} helpers
  bpf, samples: Use bpf_probe_read_user where appropriate
  bpf, testing: Add selftest to read/write sockaddr from user space

 include/linux/uaccess.h                       |  12 ++
 include/uapi/linux/bpf.h                      | 119 ++++++++++-----
 kernel/trace/bpf_trace.c                      | 139 ++++++++++++------
 mm/maccess.c                                  |  45 +++++-
 samples/bpf/map_perf_test_kern.c              |   4 +-
 samples/bpf/test_map_in_map_kern.c            |   4 +-
 samples/bpf/test_probe_write_user_kern.c      |   2 +-
 tools/include/uapi/linux/bpf.h                | 119 ++++++++++-----
 .../selftests/bpf/prog_tests/probe_user.c     |  80 ++++++++++
 .../selftests/bpf/progs/test_probe_user.c     |  33 +++++
 10 files changed, 426 insertions(+), 131 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c

-- 
2.21.0

