Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ED55AF2EF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiIFRlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiIFRlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:41:37 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47D6260E;
        Tue,  6 Sep 2022 10:41:35 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4MMWmS6PPPz9xFgS;
        Wed,  7 Sep 2022 00:58:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwA34JNSfRdjftYoAA--.8234S2;
        Tue, 06 Sep 2022 18:03:26 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, houtao1@huawei.com,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 0/7] bpf: Add fd modes check for map iter and extend libbpf
Date:   Tue,  6 Sep 2022 19:02:54 +0200
Message-Id: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwA34JNSfRdjftYoAA--.8234S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4kWryxAr1fAw4rWr4kZwb_yoW8uw4Dpr
        Z3Gryakr1FvFWI9F9rGrsIyryfJa4xW3y5G3Z7Jr15Zry5XF4DArW8GF43Gry3u3s3W3Z3
        Zr4Ykr9xGw17uFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x
        0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
        F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4I
        kC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7Cj
        xVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvE
        x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjxUsfMaUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAHBF1jj4KtRwABsa
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Add a missing fd modes check in map iterators, potentially causing
unauthorized map writes by eBPF programs attached to the iterator. Use this
patch set as an opportunity to start a discussion with the cgroup
developers about whether a security check is missing or not for their
iterator.

Also, extend libbpf with the _opts variant of bpf_*_get_fd_by_id(). Only
bpf_map_get_fd_by_id_opts() is really useful in this patch set, to ensure
that the creation of a map iterator fails with a read-only fd.

Add all variants in this patch set for symmetry with
bpf_map_get_fd_by_id_opts(), and because all the variants share the same
opts structure. Also, add all the variants here, to shrink the patch set
fixing map permissions requested by bpftool, so that the remaining patches
are only about the latter.

Finally, extend the bpf_iter test with the read-only fd check, and test
each _opts variant of bpf_*_get_fd_by_id().

Roberto Sassu (7):
  bpf: Add missing fd modes check for map iterators
  libbpf: Define bpf_get_fd_opts and introduce
    bpf_map_get_fd_by_id_opts()
  libbpf: Introduce bpf_prog_get_fd_by_id_opts()
  libbpf: Introduce bpf_btf_get_fd_by_id_opts()
  libbpf: Introduce bpf_link_get_fd_by_id_opts()
  selftests/bpf: Ensure fd modes are checked for map iters and destroy
    links
  selftests/bpf: Add tests for _opts variants of libbpf

 include/linux/bpf.h                           |   2 +-
 kernel/bpf/inode.c                            |   2 +-
 kernel/bpf/map_iter.c                         |   3 +-
 kernel/bpf/syscall.c                          |   8 +-
 net/core/bpf_sk_storage.c                     |   3 +-
 net/core/sock_map.c                           |   3 +-
 tools/lib/bpf/bpf.c                           |  47 +++++-
 tools/lib/bpf/bpf.h                           |  16 ++
 tools/lib/bpf/libbpf.map                      |  10 +-
 tools/lib/bpf/libbpf_version.h                |   2 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       |  34 +++-
 .../bpf/prog_tests/libbpf_get_fd_opts.c       | 145 ++++++++++++++++++
 .../bpf/progs/test_libbpf_get_fd_opts.c       |  49 ++++++
 13 files changed, 309 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c

-- 
2.25.1

