Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA4250FF5F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351078AbiDZNoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351088AbiDZNn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:43:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1AC3D4A2;
        Tue, 26 Apr 2022 06:40:46 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Knjfv4Dylz1JBl0;
        Tue, 26 Apr 2022 21:39:51 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 21:40:44 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 21:40:44 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <bjorn@kernel.org>, <luke.r.nels@gmail.com>, <xi.wang@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pulehui@huawei.com>
Subject: [PATCH -next 0/2] Support riscv jit to provide bpf_line_info
Date:   Tue, 26 Apr 2022 22:09:22 +0800
Message-ID: <20220426140924.3308472-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch 1 fix an issue that could not print bpf line info due
to data inconsistency in 32-bit environment.

patch 2 add support for riscv jit to provide bpf_line_info.
Both RV32 and RV64 tests have been passed as like follow:

./test_progs -a btf
#19 btf:OK
Summary: 1/215 PASSED, 0 SKIPPED, 0 FAILED

Pu Lehui (2):
  bpf: Unify data extension operation of jited_ksyms and jited_linfo
  riscv, bpf: Support riscv jit to provide bpf_line_info

 arch/riscv/net/bpf_jit.h                     |  1 +
 arch/riscv/net/bpf_jit_core.c                |  7 ++++++-
 kernel/bpf/syscall.c                         |  5 ++++-
 tools/lib/bpf/bpf_prog_linfo.c               |  8 ++++----
 tools/testing/selftests/bpf/prog_tests/btf.c | 18 +++++++++---------
 5 files changed, 24 insertions(+), 15 deletions(-)

-- 
2.25.1

