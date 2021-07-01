Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A583B8B43
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbhGAAc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbhGAAc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 20:32:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD3C061756;
        Wed, 30 Jun 2021 17:29:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o18so3793478pgu.10;
        Wed, 30 Jun 2021 17:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9x5BchN3NyN4XOrBBibcJFStLPbLfDkegNtVEHEhvow=;
        b=SOFrt3F5qaV4q0jBm86IO4GW5WMzQUAdG8f4Nd44/crdr4wwS6ErUOjaxhkucA9EdK
         8oHc14WEhWq4YHWJlWbTLfMQpuXLgEr0rXz5lPcbhEoG2z1xXighHhOZTSta4vOnDpUM
         rUZmZOLGG3nMSmX5fQd2Fzs+Fyx8B6kSUQTYTxSMmXw4noZXdhNMO42Ar4ltV91XXN6K
         ov6pPvkr2ok5JGRCIr6nMfoul5B6B6nffSv5d5wSagQXXWlokahyBFrTt7EkE9nthuPw
         Gf4iNKBnHJLdba/V1Qx9mdnfeK1QCnjXES5X/7uBqa0lF+xlQk5LJ6jZl+1Fswb+Zls1
         2v/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9x5BchN3NyN4XOrBBibcJFStLPbLfDkegNtVEHEhvow=;
        b=ZZ3SowUsORmoYSlPC/qYnDW5n6jDLvlP7MSXd+Ddfw/Y2TZ+2LZirINuqJ5b6jWmgl
         UBMlTZqNlnhm5+k2CcBKhwW/RrZOYReIniTziTQFGpKeuqUt+KOVcAQnBwxoDZsaPcQA
         Sf05MNmOz4bYJ77HWsaGrJZcrloIT3HKPgisgNePwMN6NZ1T4yXFPX++/OHaYadxgesD
         L4eL791rvsgYTX9l0NEhru0/HrsRkGeirRRfVmSQHVoltAG0oTJrXIrXnXnOYDbyGpTV
         dSgIli71UPdF/qpcP0B3Y4zChChebYJpw9a4dDWuzUJ4ZpT/VsyAG9mrl6oSb5+byIww
         AG0w==
X-Gm-Message-State: AOAM533Tvjqbm7HFUNMHnIvhJL8ZTJD/iTxan2+CiONrpFPYd1TCqtom
        GFbe/AfzRIITPXOBaiL6kg4gR9icH3o=
X-Google-Smtp-Source: ABdhPJwT8aN3kYUd29I/p9mBW+gydx4/N2b8b2Esc7F4ySKx8vyFGuA16reoJ0Xm2RQLuePzsbV6Xg==
X-Received: by 2002:a05:6a00:c85:b029:311:bfe1:e407 with SMTP id a5-20020a056a000c85b0290311bfe1e407mr1090611pfv.77.1625099396244;
        Wed, 30 Jun 2021 17:29:56 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:6f6:e6a8:37a6:1da7:fbc7])
        by smtp.gmail.com with ESMTPSA id e4sm22498596pfa.29.2021.06.30.17.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 17:29:55 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v5 0/5] Generic XDP improvements
Date:   Thu,  1 Jul 2021 05:57:54 +0530
Message-Id: <20210701002759.381983-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series makes some improvements to generic XDP mode and brings it
closer to native XDP. Patch 1 splits out generic XDP processing into reusable
parts, patch 2 adds pointer friendly wrappers for bitops (not have to cast back
and forth the address of local pointer to unsigned long *), patch 3 implements
generic cpumap support (details in commit) and patch 4 allows devmap bpf prog
execution before generic_xdp_tx is called.

Patch 5 just updates a couple of selftests to adapt to changes in behavior (in
that specifying devmap/cpumap prog fd in generic mode is now allowed).

Changelog:
----------
v4 -> v5
v4: https://lore.kernel.org/bpf/20210628114746.129669-1-memxor@gmail.com
 * Add comments and examples for new bitops macros (Alexei)

v3 -> v4
v3: https://lore.kernel.org/bpf/20210622202835.1151230-1-memxor@gmail.com
 * Add detach now that attach of XDP program succeeds (Toke)
 * Clean up the test to use new ASSERT macros

v2 -> v3
v2: https://lore.kernel.org/bpf/20210622195527.1110497-1-memxor@gmail.com
 * list_for_each_entry -> list_for_each_entry_safe (due to deletion of skb)

v1 -> v2
v1: https://lore.kernel.org/bpf/20210620233200.855534-1-memxor@gmail.com
 * Move __ptr_{set,clear,test}_bit to bitops.h (Toke)
   Also changed argument order to match the bit op they wrap.
 * Remove map value size checking functions for cpumap/devmap (Toke)
 * Rework prog run for skb in cpu_map_kthread_run (Toke)
 * Set skb->dev to dst->dev after devmap prog has run
 * Don't set xdp rxq that will be overwritten in cpumap prog run

Kumar Kartikeya Dwivedi (5):
  net: core: split out code to run generic XDP prog
  bitops: add non-atomic bitops for pointers
  bpf: cpumap: implement generic cpumap
  bpf: devmap: implement devmap prog execution for generic XDP
  bpf: tidy xdp attach selftests

 include/linux/bitops.h                        |  50 ++++++++
 include/linux/bpf.h                           |  10 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  10 +-
 include/linux/typecheck.h                     |   9 ++
 kernel/bpf/cpumap.c                           | 115 +++++++++++++++---
 kernel/bpf/devmap.c                           |  49 ++++++--
 net/core/dev.c                                | 103 ++++++++--------
 net/core/filter.c                             |   6 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  43 +++----
 .../bpf/prog_tests/xdp_devmap_attach.c        |  39 +++---
 11 files changed, 299 insertions(+), 137 deletions(-)

-- 
2.31.1

