Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C289DAC2D3
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405264AbfIFXK5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 19:10:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405246AbfIFXK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:10:57 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86NArA7020976
        for <netdev@vger.kernel.org>; Fri, 6 Sep 2019 16:10:56 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uu8mdxdd9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 16:10:56 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 6 Sep 2019 16:10:54 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2A6CF760B80; Fri,  6 Sep 2019 16:10:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <luto@amacapital.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/4] CAP_BPF and CAP_TRACING
Date:   Fri, 6 Sep 2019 16:10:49 -0700
Message-ID: <20190906231053.1276792-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_11:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 suspectscore=1 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxlogscore=922 clxscore=1034 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060226
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3->v4:
- rebase and typo fixes
- split selftests into separate patch
- update perf* docs with CAP_TRACING
- add a note to commit log that existing unpriv bpf behavior is not changing

v2->v3:
- dropped ftrace and kallsyms from CAP_TRACING description.
  In the future these mechanisms can start using it too.
- added CAP_SYS_ADMIN backward compatibility.

Alexei Starovoitov (4):
  capability: introduce CAP_BPF and CAP_TRACING
  bpf: implement CAP_BPF
  perf: implement CAP_TRACING
  selftests/bpf: use CAP_BPF and CAP_TRACING in tests

 Documentation/admin-guide/perf-security.rst |  4 +-
 Documentation/admin-guide/sysctl/kernel.rst | 10 ++---
 arch/powerpc/perf/core-book3s.c             |  4 +-
 arch/x86/events/intel/bts.c                 |  2 +-
 arch/x86/events/intel/core.c                |  2 +-
 arch/x86/events/intel/p4.c                  |  2 +-
 include/linux/capability.h                  | 18 ++++++++
 include/uapi/linux/capability.h             | 49 ++++++++++++++++++++-
 kernel/bpf/arraymap.c                       |  2 +-
 kernel/bpf/cgroup.c                         |  2 +-
 kernel/bpf/core.c                           |  4 +-
 kernel/bpf/hashtab.c                        |  4 +-
 kernel/bpf/lpm_trie.c                       |  2 +-
 kernel/bpf/queue_stack_maps.c               |  2 +-
 kernel/bpf/reuseport_array.c                |  2 +-
 kernel/bpf/stackmap.c                       |  2 +-
 kernel/bpf/syscall.c                        | 32 ++++++++------
 kernel/bpf/verifier.c                       |  2 +-
 kernel/events/core.c                        | 14 +++---
 kernel/events/hw_breakpoint.c               |  2 +-
 kernel/trace/bpf_trace.c                    |  2 +-
 kernel/trace/trace_event_perf.c             |  4 +-
 net/core/bpf_sk_storage.c                   |  2 +-
 net/core/filter.c                           | 10 +++--
 security/selinux/include/classmap.h         |  4 +-
 tools/testing/selftests/bpf/test_verifier.c | 46 +++++++++++++++----
 26 files changed, 165 insertions(+), 64 deletions(-)

-- 
2.20.0

