Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFED376DD
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfFFOgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:36:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:33364 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbfFFOgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:36:06 -0400
Received: from [178.197.249.21] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYtUq-00049f-1z; Thu, 06 Jun 2019 16:36:04 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     kafai@fb.com, rdna@fb.com, m@lambda.lt, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Date:   Thu,  6 Jun 2019 16:35:13 +0200
Message-Id: <20190606143517.25710-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25472/Thu Jun  6 10:09:59 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please refer to the patch 1/4 as the main patch with the details
on the current sendmsg hook API limitations and proposal to fix
it in order to work with basic applications like DNS. Remaining
patches are the usual uapi and tooling updates as well as test
cases. Thanks a lot!

v1 -> v2:
  - Split off uapi header sync and bpftool bits (Martin, Alexei)
  - Added missing bpftool doc and bash completion as well

Daniel Borkmann (4):
  bpf: fix unconnected udp hooks
  bpf: sync tooling uapi header
  bpf, bpftool: enable recvmsg attach types
  bpf: add further msg_name rewrite tests to test_sock_addr

 include/linux/bpf-cgroup.h                    |   8 +
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/syscall.c                          |   8 +
 kernel/bpf/verifier.c                         |  12 +-
 net/core/filter.c                             |   2 +
 net/ipv4/udp.c                                |   4 +
 net/ipv6/udp.c                                |   4 +
 .../bpftool/Documentation/bpftool-cgroup.rst  |   6 +-
 .../bpftool/Documentation/bpftool-prog.rst    |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   5 +-
 tools/bpf/bpftool/cgroup.c                    |   5 +-
 tools/bpf/bpftool/prog.c                      |   3 +-
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/testing/selftests/bpf/test_sock_addr.c  | 213 ++++++++++++++++--
 14 files changed, 250 insertions(+), 26 deletions(-)

-- 
2.17.1

