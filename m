Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1523FADCA
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhH2Sh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhH2ShS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:18 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B4C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:25 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id bk29so13225720qkb.8
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ni00cSGodRLx8IK0PeLFVUdcqTzBNl3tmS2sCMe1tTk=;
        b=imR65DyZFNUwuHugwqAq4ysdP55FIgATpDozvR7O/Bb+26L9vP6Rx0FA6ynlwf6fE8
         rdlBrjNeSnj1dVkB9OB20BIw8J3aP8CTpX76d/1i2M1oYZSwUyH0SWCpbXleAyI0PbN7
         Zgltr1wDJ19yQBoMCsOoViD7MEkwSoMABhmM/sERwuJ58YSS1rcpc/g/HbUOY3bJD3dL
         LBZqOjUIIIlLVPOkgGtU4UJpUZ3t3jehtThoASceoerN3IwQZrgQbGAzE0+0OU2Q7/W+
         RNBtrRKgXK1EVWzyE0bhMWw3eLrMbAHadp9dUIfMsxcMJwl3bjWnWpddAj7Z5k+R5edw
         vD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ni00cSGodRLx8IK0PeLFVUdcqTzBNl3tmS2sCMe1tTk=;
        b=pCdMpPVITs04NbXOgGcF6/7jr8ynaOZdN1g6e5bxTNcfb1DuGUq4zmy9Y3mXYaRFV0
         Ptk6rvcE/XCuxmnY0++Uy1fLGzf87LQgcvWdk4y//VrikKDAW2zmdkLlDDLEY271RuO7
         QDmUle1uYwQ6HmMufFyC5nYT8DN/qauphlrho8TVoO4yJpgmqEcLOzoSg+y2a3LlXbI7
         usnMxIoOoIw6arT6noDJk7oqd1GyAyUerlqHwWWC1mbtDhB0I+WMB3HMTFVUsjbq0CpT
         lLP3MEIvUeZSUr2Rn57zKzRdSasLCq+P4oGHTlOl+d1NRQm/r9IUVI1uzzcmNI35qRgh
         B5Cg==
X-Gm-Message-State: AOAM530AgaXFtPF7sEydZgFkLHeXTSKekbRbcAePeKAEDcmAq2aj22yw
        OwNSypos7zO8qu1cOqSO3sMVxw==
X-Google-Smtp-Source: ABdhPJy+XPE/k/oyztEyfisbLE6mVkUV/KYeLKx6X4KO4c0I1h9yDaXjHbkUo6ds7AsMoPcH+nfO9A==
X-Received: by 2002:a37:8e44:: with SMTP id q65mr18907636qkd.372.1630262184111;
        Sun, 29 Aug 2021 11:36:24 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id j184sm9766950qkd.74.2021.08.29.11.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:23 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 00/13] bpfilter
Date:   Sun, 29 Aug 2021 22:35:55 +0400
Message-Id: <20210829183608.2297877-1-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset is based on the patches from David S. Miller [1] and
Daniel Borkmann [2].

The main goal of the patchset is to prepare bpfilter for
iptables' configuration blob parsing and code generation.

The patchset introduces data structures and code for matches,
targets, rules and tables. Beside that the code generation
is introduced.

The first version of the code generation supports only "inline"
mode - all chains and their rules emit instructions in linear
approach. The plan for the code generation is to introduce a
bpf_map_for_each subprogram that will handle all rules that
aren't generated in inline mode due to verifier's limit. This
shall allow to handle arbitrary large rule sets.

Things that are not implemented yet:
  1) The process of switching from the previous BPF programs to the
     new set isn't atomic.
  2) The code generation for FORWARD chain isn't supported
  3) Counters setsockopts() are not handled
  4) No support of device ifindex - it's hardcoded
  5) No helper subprog for counters update

Another problem is using iptables' blobs for tests and filter
table initialization. While it saves lines something more
maintainable should be done here.

The plan for the next iteration:
  1) Handle large rule sets via bpf_map_for_each
  2) Add a helper program for counters update
  3) Handle iptables' counters setsockopts()
  4) Handle ifindex
  5) Add TCP match

Patch 1 adds definitions of the used types.
Patch 2 adds logging to bpfilter.
Patch 3 adds bpfilter header to tools
Patch 4 adds an associative map.
Patch 5 adds code generation basis
Patches 6/7/8/9 add code for matches, targets, rules and table.
Patch 10 adds code generation for table
Patch 11 handles hooked setsockopt(2) calls.
Patch 12 adds filter table
Patch 13 uses prepared code in main().

And here are some performance tests.

The environment consists of two machines(sender and receiver)
connected with 10Gbps link via switch.  The sender uses DPDK to
simulate QUIC packets(89 bytes long) from random IP. The switch
measures the generated traffic to be about 7066377568 bits/sec,
9706553 packets/sec.

The receiver is a 2 socket 2680v3 + HT and uses either iptables,
nft or bpfilter to filter out UDP traffic.

Two tests were made. Two rulesets(default policy was to ACCEPT)
were used in each test:

```
iptables -A INPUT -p udp -m udp --dport 1500 -j DROP
```
and
```
iptables -A INPUT -s 1.1.1.1/32 -p udp -m udp --dport 1000 -j DROP
iptables -A INPUT -s 2.2.2.2/32 -p udp -m udp --dport 2000 -j DROP
...
iptables -A INPUT -s 31.31.31.31/32 -p udp -m udp --dport 31000 -j DROP
iptables -A INPUT -p udp -m udp --dport 1500 -j DROP
```

The first test measures performance of the receiver via stress-ng
[3] in bogo-ops. The upper-bound(there are no firewall and no
traffic) value for bogo-ops is 8148-8210. The lower bound value
(there is traffic but no firewall) is 6567-6643.
The stress-ng command used: stress-ng -t60 -c48 --metrics-brief.

The second test measures the number the of dropped packets. The
receiver keeps only 1 CPU online and disables all
others(maxcpus=1 and set number of cores per socket to 1 in
BIOS). The number of the dropped packets is collected via
iptables-legacy -nvL, iptables -nvL and bpftool map dump id.

Test 1: bogo-ops(the more the better)
            iptables            nft        bpfilter
  1 rule:  6474-6554      6483-6515       7996-8008
32 rules:  6374-6433      5761-5804       7997-8042


Test 2: number of dropped packets(the more the better)
            iptables            nft         bpfilter
  1 rule:  234M-241M           220M            900M+
32 rules:  186M-196M        97M-98M            900M+


Please let me know if you see a gap in the testing environment.

v1 -> v2
Maps:
  * Use map_upsert instead of separate map_insert and map_update
Matches:
  * Add a new virtual call - gen_inline. The call is used for
  * inline generating of a rule's match.
Targets:
  * Add a new virtual call - gen_inline. The call is used for inline
    generating of a rule's target.
Rules:
  * Add code generation for rules
Table:
  * Add struct table_ops
  * Add map for table_ops
  * Add filter table
  * Reorganize the way filter table is initialized
Sockopts:
  * Install/uninstall BPF programs while handling
    IPT_SO_SET_REPLACE
Code generation:
  * Add first version of the code generation
Dependencies:
  * Add libbpf

v0 -> v1
IO:
  * Use ssize_t in pvm_read, pvm_write for total_bytes
  * Move IO functions into sockopt.c and main.c
Logging:
  * Use LOGLEVEL_EMERG, LOGLEVEL_NOTICE, LOGLEVE_DEBUG
    while logging to /dev/kmsg
  * Prepend log message with <n> where n is log level
  * Conditionally enable BFLOG_DEBUG messages
  * Merge bflog.{h,c} into context.h
Matches:
  * Reorder fields in struct match_ops for tight packing
  * Get rid of struct match_ops_map
  * Rename udp_match_ops to xt_udp
  * Use XT_ALIGN macro
  * Store payload size in match size
  * Move udp match routines into a separate file
Targets:
  * Reorder fields in struct target_ops for tight packing
  * Get rid of struct target_ops_map
  * Add comments for convert_verdict function
Rules:
  * Add validation
Tables:
  * Combine table_map and table_list into table_index
  * Add validation
Sockopts:
  * Handle IPT_SO_GET_REVISION_TARGET

1. https://lore.kernel.org/patchwork/patch/902785/
2. https://lore.kernel.org/patchwork/patch/902783/
3. https://kernel.ubuntu.com/~cking/stress-ng/stress-ng.pdf

Dmitrii Banshchikov (13):
  bpfilter: Add types for usermode helper
  bpfilter: Add logging facility
  tools: Add bpfilter usermode helper header
  bpfilter: Add map container
  bpfilter: Add codegen infrastructure
  bpfilter: Add struct match
  bpfilter: Add struct target
  bpfilter: Add struct rule
  bpfilter: Add struct table
  bpfilter: Add table codegen
  bpfilter: Add handling of setsockopt() calls
  bpfilter: Add filter table
  bpfilter: Handle setsockopts

 include/uapi/linux/bpfilter.h                 | 154 +++
 net/bpfilter/Makefile                         |  16 +-
 net/bpfilter/codegen.c                        | 903 ++++++++++++++++++
 net/bpfilter/codegen.h                        | 189 ++++
 net/bpfilter/context.c                        | 138 +++
 net/bpfilter/context.h                        |  47 +
 net/bpfilter/filter-table.c                   | 246 +++++
 net/bpfilter/filter-table.h                   |  17 +
 net/bpfilter/main.c                           | 126 ++-
 net/bpfilter/map-common.c                     |  50 +
 net/bpfilter/map-common.h                     |  18 +
 net/bpfilter/match.c                          |  49 +
 net/bpfilter/match.h                          |  36 +
 net/bpfilter/rule.c                           | 239 +++++
 net/bpfilter/rule.h                           |  34 +
 net/bpfilter/sockopt.c                        | 441 +++++++++
 net/bpfilter/sockopt.h                        |  14 +
 net/bpfilter/table.c                          | 346 +++++++
 net/bpfilter/table.h                          |  54 ++
 net/bpfilter/target.c                         | 184 ++++
 net/bpfilter/target.h                         |  52 +
 net/bpfilter/xt_udp.c                         |  96 ++
 tools/include/uapi/linux/bpfilter.h           | 178 ++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   8 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  59 ++
 .../selftests/bpf/bpfilter/bpfilter_util.h    |  79 ++
 .../selftests/bpf/bpfilter/test_codegen.c     | 293 ++++++
 .../testing/selftests/bpf/bpfilter/test_map.c |  63 ++
 .../selftests/bpf/bpfilter/test_match.c       |  61 ++
 .../selftests/bpf/bpfilter/test_rule.c        |  55 ++
 .../selftests/bpf/bpfilter/test_target.c      |  85 ++
 .../selftests/bpf/bpfilter/test_xt_udp.c      |  41 +
 32 files changed, 4327 insertions(+), 44 deletions(-)
 create mode 100644 net/bpfilter/codegen.c
 create mode 100644 net/bpfilter/codegen.h
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/context.h
 create mode 100644 net/bpfilter/filter-table.c
 create mode 100644 net/bpfilter/filter-table.h
 create mode 100644 net/bpfilter/map-common.c
 create mode 100644 net/bpfilter/map-common.h
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 net/bpfilter/rule.c
 create mode 100644 net/bpfilter/rule.h
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/sockopt.h
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h
 create mode 100644 net/bpfilter/target.c
 create mode 100644 net/bpfilter/target.h
 create mode 100644 net/bpfilter/xt_udp.c
 create mode 100644 tools/include/uapi/linux/bpfilter.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpfilter/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_codegen.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_map.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_xt_udp.c

-- 
2.25.1

