Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2244102CA
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhIRB5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:57:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15434 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhIRB5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 21:57:21 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HBDMS0QXdzQlnL;
        Sat, 18 Sep 2021 09:51:48 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 09:55:56 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 18 Sep
 2021 09:55:55 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 0/3] add support for writable bare tracepoint
Date:   Sat, 18 Sep 2021 10:09:55 +0800
Message-ID: <20210918020958.1167652-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The patchset series supports writable context for bare tracepoint.

The main idea comes from patchset "writable contexts for bpf raw
tracepoints" [1], but it only supports normal tracepoint with
associated trace event under tracefs. Now we want to add a
bare tracepoint in VFS layer, and update file::f_mode for specific
files. The reason using bare tracepoint is that it doesn't form
a ABI and we can change it freely. So add support for it in BPF.

Any comments are welcome.

[1]: https://lore.kernel.org/lkml/20190426184951.21812-1-mmullins@fb.com

Change log:
v2:
  * rebase on bpf-next tree
  * address comments from Yonghong Song
  * rename bpf_testmode_test_writable_ctx::ret as early_ret to reflect
    its purpose better.

v1:
  * https://www.spinics.net/lists/bpf/msg46221.html

Hou Tao (3):
  bpf: support writable context for bare tracepoint
  libbpf: support detecting and attaching of writable tracepoint program
  bpf/selftests: add test for writable bare tracepoint

 include/trace/bpf_probe.h                     | 19 +++++++---
 tools/lib/bpf/libbpf.c                        |  4 +++
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
 .../selftests/bpf/prog_tests/module_attach.c  | 36 +++++++++++++++++++
 .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
 7 files changed, 99 insertions(+), 4 deletions(-)

-- 
2.29.2

