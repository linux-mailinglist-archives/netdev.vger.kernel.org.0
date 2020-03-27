Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D94D195A6C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgC0P7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:50914 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbgC0P7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:14 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO3-0007mt-Bk; Fri, 27 Mar 2020 16:59:11 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 0/7] Various improvements to cgroup helpers
Date:   Fri, 27 Mar 2020 16:58:49 +0100
Message-Id: <cover.1585323121.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds various straight-forward helper improvements and additions to BPF
cgroup based connect(), sendmsg(), recvmsg() and bind-related hooks which
would allow to implement more fine-grained policies and improve current load
balancer limitations we're seeing. For details please see individual patches.
I've tested them on Kubernetes & Cilium and also added selftests for the small
verifier extension. Thanks!

Daniel Borkmann (7):
  bpf: enable retrieval of socket cookie for bind/post-bind hook
  bpf: enable perf event rb output for bpf cgroup progs
  bpf: add netns cookie and enable it for bpf cgroup hooks
  bpf: allow to retrieve cgroup v1 classid from v2 hooks
  bpf: enable bpf cgroup hooks to retrieve cgroup v2 and ancestor id
  bpf: enable retrival of pid/tgid/comm from bpf cgroup hooks
  bpf: add selftest cases for ctx_or_null argument type

 include/linux/bpf.h                        |   2 +
 include/net/cls_cgroup.h                   |   7 +-
 include/net/net_namespace.h                |  10 ++
 include/uapi/linux/bpf.h                   |  35 ++++++-
 kernel/bpf/core.c                          |   1 +
 kernel/bpf/helpers.c                       |  18 ++++
 kernel/bpf/verifier.c                      |  16 ++--
 net/core/filter.c                          | 106 ++++++++++++++++++++-
 net/core/net_namespace.c                   |  15 +++
 tools/include/uapi/linux/bpf.h             |  35 ++++++-
 tools/testing/selftests/bpf/verifier/ctx.c | 105 ++++++++++++++++++++
 11 files changed, 336 insertions(+), 14 deletions(-)

-- 
2.21.0

