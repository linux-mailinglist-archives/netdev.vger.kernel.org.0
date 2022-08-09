Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7D658D390
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiHIGIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbiHIGIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:08:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E181175B8;
        Mon,  8 Aug 2022 23:08:47 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660025326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1VkAw1xF+UahkRCVjT6R8UphZj9L/W44DG4qgQ9C9kQ=;
        b=Ys0QESHods3FACRsKWcek22EgvHEiu9eVxFxFWJdaCjSN3QqloRe4o3sDwZmxPfx7m2699
        j/It62ALcuj+/b3IWxrw1dYGh2luV4I2lmOT5/hoc7dOpbTuJZi9KIIzdSDpk1u071j66H
        Hg9JMRKRdIqO13to6Veu+KuyR9W5gJF7T5TVvfKMqcHlYlBOtfXfddigu4umqtvTuU35YH
        d5DF3Ahi2l/pCuW5BfR1DnK5IeDE/MMYnTpiA8tnOikfR2eMqA8cxr3cvKb08kWbAQGgaM
        Nuw8ERe4oA+NowsmUkncQT1LnWV5GSeuY4BPijUoE4r8fQoyBnr1nQFIMbLVDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660025326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1VkAw1xF+UahkRCVjT6R8UphZj9L/W44DG4qgQ9C9kQ=;
        b=DB3rf+EDScjkZGsGcg1mVSGkZhehY+PAKnLF4jGxjFNAyPqIyj+B+el9BX4uCcEsRO96Ag
        4WNX0k9A5iG1r+Bw==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH bpf-next v2 0/2] Add BPF-helper for accessing CLOCK_TAI
Date:   Tue,  9 Aug 2022 08:08:01 +0200
Message-Id: <20220809060803.5773-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

add a BPF-helper for accessing CLOCK_TAI. Use cases for such a BPF helper
include functionalities such as Tx launch time (e.g. ETF and TAPRIO Qdiscs),
timestamping and policing.

Patch #1 - Introduce BPF helper
Patch #2 - Add test case (skb based)

Changes since v1:

 * Update changelog (Alexei Starovoitov)
 * Add test case (Alexei Starovoitov, Andrii Nakryiko)
 * Add missing function prototype (netdev ci)

Previous versions:

 * v1: https://lore.kernel.org/r/20220606103734.92423-1-kurt@linutronix.de/

Jesper Dangaard Brouer (1):
  bpf: Add BPF-helper for accessing CLOCK_TAI

Kurt Kanzenbach (1):
  selftests/bpf: Add BPF-helper test for CLOCK_TAI access

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      | 13 ++++
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 14 ++++
 tools/include/uapi/linux/bpf.h                | 13 ++++
 .../selftests/bpf/prog_tests/time_tai.c       | 74 +++++++++++++++++++
 .../selftests/bpf/progs/test_time_tai.c       | 24 ++++++
 7 files changed, 140 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/time_tai.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_time_tai.c

-- 
2.30.2

