Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A5E66AF9B
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjAOHQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjAOHQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:21 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AFCB474;
        Sat, 14 Jan 2023 23:16:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id v3so17624754pgh.4;
        Sat, 14 Jan 2023 23:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R9CHFhBMgqNJEnQ3chqPAxmsVXAr4YKXK2i1ZVINvLg=;
        b=XqSRSVCvFkKBeAg26jNKZVupLRr127JM0zvt31D8riSgiKoCef8OyxVO/MgTCf10HI
         rl/u8XCUNe8mXXKLR+C6QiK10Vts7dQHO5gaSvhCul8DDnt0/PZ+JRiClBPUpIjqtmq8
         AQKgan0xpubim8DE9ZMXHrXSBUxiAPleXxa3t6VVU4TZQpwE0EAafzQ96ntbxkU3oV8y
         0dhqf/UyNtmkcAiWXdlAiD/sUCE4/d6DIWceu1/GF5lWGBWW9HdlXkZM1QgFsKHR4Ayi
         1yqRZEdKH/mVV24dUVHsMm3AYT4ROsU0h33NppAK5WhO+eD16yAa2bJWSByCTQ6eAXaE
         j3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R9CHFhBMgqNJEnQ3chqPAxmsVXAr4YKXK2i1ZVINvLg=;
        b=BVzusJhGezH8RpInle2kzaXtNCxtfiRUbbNb0IFFhHvAPSCn68dzarGFf85M8xeja3
         hdcrZ0GRBs6+OQcQz/awH49Zf93N26aSdIPytdrOxJ7v6m7/1c1Wq7iKmbXil7qdH41a
         JtT/oMJRNpaoge0dO4maTeARgh8eAxKzbSyPKhLJ5Hq0FrxidVhf/idqb43TIDybmhXS
         E3AXX136K3SzifnBaMtN3OO5W02fduELEUgqF0Uj9eTcQzMJ4x0lFtPKTndbwhc5J+YG
         1WOhcnIPnmOoNJeK8ZnatVOybkgB3LWDtxvfSD61BQpS6GqKAX9Xr+tzJTtDeLPtO99A
         Iu6A==
X-Gm-Message-State: AFqh2kqrN2pIG/d18NPV1sONFQxSmYodSrQIBKn4/33L/ijtq1HKAeSQ
        11pU+Lv9m2SfL/2euMuBVg==
X-Google-Smtp-Source: AMrXdXszIws8hT8PC5OgCSCGyO/cNbwHz4TqDFvYlfgKsdr+p3rrlv+eDZATeo9juG3Gem8DLR4+6w==
X-Received: by 2002:a05:6a00:1f09:b0:58b:48f5:ea28 with SMTP id be9-20020a056a001f0900b0058b48f5ea28mr15682433pfb.27.1673766979579;
        Sat, 14 Jan 2023 23:16:19 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:19 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 00/10] samples/bpf: modernize BPF functionality test programs
Date:   Sun, 15 Jan 2023 16:16:03 +0900
Message-Id: <20230115071613.125791-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are many programs under samples/bpf to test the
various functionality of BPF that have been developed for a long time.
However, the kernel (BPF) has changed a lot compared to the 2016 when
some of these test programs were first introduced.

Therefore, some of these programs use the deprecated function of BPF,
and some programs no longer work normally due to changes in the API.

To list some of the kernel changes that this patch set is focusing on,
- legacy BPF map declaration syntax support had been dropped [1]
- bpf_trace_printk() always append newline at the end [2]
- deprecated styled BPF section header (bpf_load style) [3] 
- urandom_read tracepoint is removed (used for testing overhead) [4]
- ping sends packet with SOCK_DGRAM instead of SOCK_RAW [5]*
- use "vmlinux.h" instead of including individual headers

In addition to this, this patchset tries to modernize the existing
testing scripts a bit. And for network-related testing programs,
a separate header file was created and applied. (To use the 
Endianness conversion function from xdp_sample and bunch of constants)

[1]: https://github.com/libbpf/libbpf/issues/282
[2]: commit ac5a72ea5c89 ("bpf: Use dedicated bpf_trace_printk event instead of trace_printk()")
[3]: commit ceb5dea56543 ("samples: bpf: Remove bpf_load loader completely")
[4]: commit 14c174633f34 ("random: remove unused tracepoints")
[5]: https://lwn.net/Articles/422330/

*: This is quite old, but I'm not sure why the code was initially
   developed to filter only SOCK_RAW.

Daniel T. Lee (10):
  samples/bpf: ensure ipv6 is enabled before running tests
  samples/bpf: refactor BPF functionality testing scripts
  samples/bpf: fix broken lightweight tunnel testing
  samples/bpf: fix broken cgroup socket testing
  samples/bpf: replace broken overhead microbenchmark with
    fib_table_lookup
  samples/bpf: replace legacy map with the BTF-defined map
  samples/bpf: split common macros to net_shared.h
  samples/bpf: replace BPF programs header with net_shared.h
  samples/bpf: use vmlinux.h instead of implicit headers in BPF test
    program
  samples/bpf: change _kern suffix to .bpf with BPF test programs

 samples/bpf/Makefile                          | 14 +++---
 ...lwt_len_hist_kern.c => lwt_len_hist.bpf.c} | 29 +++--------
 samples/bpf/lwt_len_hist.sh                   |  4 +-
 samples/bpf/net_shared.h                      | 32 ++++++++++++
 .../{sock_flags_kern.c => sock_flags.bpf.c}   | 24 ++++-----
 samples/bpf/tc_l2_redirect.sh                 |  3 ++
 samples/bpf/test_cgrp2_sock.sh                | 16 +++---
 samples/bpf/test_cgrp2_sock2.sh               |  9 +++-
 ...st_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c} | 34 ++++---------
 samples/bpf/test_cgrp2_tc.sh                  |  8 +--
 samples/bpf/test_lwt_bpf.c                    | 50 ++++++++-----------
 samples/bpf/test_lwt_bpf.sh                   | 19 ++++---
 ...ap_in_map_kern.c => test_map_in_map.bpf.c} |  7 +--
 samples/bpf/test_map_in_map_user.c            |  2 +-
 ...robe_kern.c => test_overhead_kprobe.bpf.c} |  6 +--
 ...w_tp_kern.c => test_overhead_raw_tp.bpf.c} |  4 +-
 ...rhead_tp_kern.c => test_overhead_tp.bpf.c} | 29 +++++++----
 samples/bpf/test_overhead_user.c              | 34 ++++++++-----
 samples/bpf/xdp_sample.bpf.h                  | 22 +-------
 19 files changed, 179 insertions(+), 167 deletions(-)
 rename samples/bpf/{lwt_len_hist_kern.c => lwt_len_hist.bpf.c} (75%)
 create mode 100644 samples/bpf/net_shared.h
 rename samples/bpf/{sock_flags_kern.c => sock_flags.bpf.c} (66%)
 rename samples/bpf/{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c} (70%)
 rename samples/bpf/{test_map_in_map_kern.c => test_map_in_map.bpf.c} (97%)
 rename samples/bpf/{test_overhead_kprobe_kern.c => test_overhead_kprobe.bpf.c} (92%)
 rename samples/bpf/{test_overhead_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} (82%)
 rename samples/bpf/{test_overhead_tp_kern.c => test_overhead_tp.bpf.c} (61%)

-- 
2.34.1

