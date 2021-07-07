Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D93BE1A1
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 05:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhGGDzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 23:55:37 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:10321 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhGGDzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 23:55:31 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GKQPm5D5jz76Ln;
        Wed,  7 Jul 2021 11:48:28 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 7 Jul 2021 11:52:48 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [bpf-next 0/3] potential memleak and use after free in bpf verifier
Date:   Wed, 7 Jul 2021 04:38:08 +0000
Message-ID: <20210707043811.5349-1-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading the code of bpf verifier, I found these two issues.
Patch 1 move the bpf_prog_clone_free function into filter.h, so
we can use it in other file. Patch 2 fix memleak in an error
handling path in bpf_patch_insn_data function.
Patch 3 fix a use after free in bpf_check function.

He Fengqing (3):
  bpf: Move bpf_prog_clone_free into filter.h file
  bpf: Fix a memory leak in an error handling path in
    'bpf_patch_insn_data()'
  bpf: Fix a use after free in bpf_check()

 include/linux/filter.h | 17 ++++++++++++-
 kernel/bpf/core.c      | 27 +++++---------------
 kernel/bpf/verifier.c  | 58 ++++++++++++++++++++++++++++++++----------
 net/core/filter.c      |  2 +-
 4 files changed, 68 insertions(+), 36 deletions(-)

-- 
2.25.1

