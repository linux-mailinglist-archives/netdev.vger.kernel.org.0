Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987E037F354
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 09:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhEMHGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 03:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhEMHGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 03:06:13 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246F8C061574;
        Thu, 13 May 2021 00:05:03 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i13so20992152pfu.2;
        Thu, 13 May 2021 00:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzUSYDjjAKiwp5x1xutKq1gCviJbrkJ0wZc9lREap7o=;
        b=jZFOorO14TiDfX+wPeHyADJ5Yk9E8p+gA6Un5SmTTMimdrULR7JrjdW2IyW+ZUizik
         V13aC66dhz9GJNCJp++3iSX5jk9bgP0fWlmFtRhVVNuxwq+R4la5dS4AgiMg6alC2VTv
         FsrmrX5oS3hCHMCTas4yypxJS8+KeZ3ryEGWQrVf0WSENm4/x/srdkJ9RR0hDhsdjfxx
         XtFAI7g6SDDfDYL16USGd2CJYQo0wXLRTeR1mUhTz8Tl107Ufyw0GxiiRaSNtPlrfK3X
         dYRPtRavNFNRyuVdLSsddvkgUKx7yuf7b2MqiQ/EiBtGCRHGjaXtDyrwsfKUBQwpL1KY
         BVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzUSYDjjAKiwp5x1xutKq1gCviJbrkJ0wZc9lREap7o=;
        b=PxqCpJtnvHE31STMlyPV90i1VVqPZKFec+9xpeNOm6kA32psJmF4+SHGg5cJK8r85y
         BHi2WGvJcJGg3+/7wDD4QYxo1kTBwDAz2/db1oNZTcVmY/5YhcV5x6Se/Th6+itc1FIl
         HKwoRcix1OMjUVRr81bLTFWE1fh7aInHInl/BlJln2BYezrQw7USMuI0UY0xeQtDwdW0
         nCju0ATqrdVK9CCO/5ZlIT3KtcH8hgToI6SlEdvZR9byj3Ycz8OkefW2qyC92RAgPAQu
         7lFNXinPq3SBgOLJ8JbQYbL525mRxic+ilh/q3asuwtuWBXShSVSvsy8Vu985f/S7wgM
         wYog==
X-Gm-Message-State: AOAM533NtozMcu1dk93ua6SiCtGEUtv0Bazx1ZlDNG84iAzx0zFb8f6W
        394P0sO5vmtu6BHv7J0g+VpBUR9DQH/ERw==
X-Google-Smtp-Source: ABdhPJxcRgWggd1xeWvQR+cyH0wEzFiyxwAC3JPka4laSW/S8+N1O16ZTkwzZQDUx+goqFnhA7EaGQ==
X-Received: by 2002:a63:9350:: with SMTP id w16mr39857776pgm.53.1620889502480;
        Thu, 13 May 2021 00:05:02 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n11sm1355227pfu.121.2021.05.13.00.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 00:05:01 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RESEND v11 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Thu, 13 May 2021 15:04:43 +0800
Message-Id: <20210513070447.1878448-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous 2 maps implementation[1]. The reason is that Daniel thinks
the exclude map implementation is missing proper bond support in XDP
context. And there is a plan to add native XDP bonding support. Adding a
exclude map in the helper also increases the complexity of verifier and has
drawback of performance.

The new implementation just add two new flags BPF_F_BROADCAST and
BPF_F_EXCLUDE_INGRESS to extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

The patchv10 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210423020019.2333192-1-liuhangbin@gmail.com

v11:
a) Use unlikely() when checking if this is for broadcast redirecting.
b) Fix a tracepoint NULL pointer issue Jesper found
c) Remove BPF_F_REDIR_MASK and just use OR flags to make the reader more
   clear about what's flags we are using
d) Add the performace number with multi veth interfaces in patch 01
   description.
e) remove some sleeps to reduce the testing time in patch04. Re-struct the
   test and make clear what flags we are testing.

v10: use READ/WRITE_ONCE when read/write map instead of xchg()
v9: Update patch 01 commit description
v8: use hlist_for_each_entry_rcu() when looping the devmap hash ojbs
v7: No need to free xdpf in dev_map_enqueue_clone() if xdpf_clone failed.
v6: Fix a skb leak in the error path for generic XDP
v5: Just walk the map directly to get interfaces as get_next_key() of devmap
    hash may restart looping from the first key if the device get removed.
    After update the performace has improved 10% compired with v4.
v4: Fix flags never cleared issue in patch 02. Update selftest to cover this.
v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02


Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  20 ++
 include/linux/filter.h                        |  18 +-
 include/net/xdp.h                             |   1 +
 include/trace/events/xdp.h                    |   6 +-
 include/uapi/linux/bpf.h                      |  16 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 306 +++++++++++++++---
 net/core/filter.c                             |  37 ++-
 net/core/xdp.c                                |  29 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  88 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  16 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  94 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 204 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 226 +++++++++++++
 18 files changed, 1310 insertions(+), 65 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

