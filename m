Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6245F9FCF
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJJOIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJJOIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:08:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF296EF07;
        Mon, 10 Oct 2022 07:08:02 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MmLH41Tn8zmVBm;
        Mon, 10 Oct 2022 22:03:28 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 10 Oct
 2022 22:07:59 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH bpf v3 0/6] Fix bugs found by ASAN when running selftests
Date:   Mon, 10 Oct 2022 10:25:47 -0400
Message-ID: <20221010142553.776550-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
- Fix error failure of case test_xdp_adjust_tail_grow exposed by this series

v2: https://lore.kernel.org/bpf/20221010070454.577433-1-xukuohai@huaweicloud.com
- Rebase and fix conflict

v1: https://lore.kernel.org/bpf/20221009131830.395569-1-xukuohai@huaweicloud.com

Xu Kuohai (6):
  libbpf: Fix use-after-free in btf_dump_name_dups
  libbpf: Fix memory leak in parse_usdt_arg()
  selftests/bpf: Fix memory leak caused by not destroying skeleton
  selftest/bpf: Fix memory leak in kprobe_multi_test
  selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
  selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c

 tools/lib/bpf/btf_dump.c                      | 47 +++++++++++----
 tools/lib/bpf/usdt.c                          | 59 +++++++++++--------
 .../bpf/prog_tests/kprobe_multi_test.c        | 17 +++---
 .../selftests/bpf/prog_tests/map_kptr.c       |  3 +-
 .../selftests/bpf/prog_tests/tracing_struct.c |  3 +-
 .../bpf/prog_tests/xdp_adjust_tail.c          |  7 ++-
 6 files changed, 86 insertions(+), 50 deletions(-)

-- 
2.30.2

