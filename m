Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B892399EA0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFCKQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFCKQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:16:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246EFC06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 03:14:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l2so5262459wrw.6
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r6wujZEx4w3Wb9eZZ+VBAhoM8LZYydULFabamzp2QUI=;
        b=YhsEKkbmyHNpmmSO98nNtBGUlS85W1ixzrSEeuSq+SMUHoFD7PunUmSDaApSt5nQZj
         1SgxFC8EtTfM4morLPh2mWTbJA0yJCYDgBFksyKcZ3hCJKMlG2+CGtk9pwaSYpRvo0Ip
         XGDa1QG8pqL6wa909huzCnQ8Wjk4ulys2YhnHaY8IELkRZ6OBtIhHjFJFG/+tCN5ELHW
         vXyjX5Jt9hm3r5dWDf9/D8l+A3u4RZhg6DT9AIJg8D8mbPcLdj6hBNOv4f/mCP7QXyIG
         J8R3QJRqJXjo0cGSq5r6Jq7Mh4okXIyRv3wuO+7if05Qs1QvzpFQpw9I+jwUNOZruCKP
         +gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r6wujZEx4w3Wb9eZZ+VBAhoM8LZYydULFabamzp2QUI=;
        b=L/JDTexZB4otipdQvq0+g8MeReS44cCniIOjqJ6kXAoNhyvUZQfn/1lqFqpQ8LO1lj
         cvCdL7/P8cKAOjJ8Ie7RE17isIY5Hq++RjVbT/0lBsaDP2RjVxI+ydXC4VuyTbwJJU11
         XyxMouByIvB1paUL6QVRfmKfHvFdzZXkwH7kzAOkLsnbq/oVC/RQmzK6Qs2shH1r9Nog
         pIya4MSYMFfVJ+vEh+Y/pVJ+6+faceWtiAk3GTXrGUFExgcaubOJuzPOZJFWT3nN7kP7
         TWze0NJXf2b++Om/tQVdwCJZyM7r2+G5kxwbj2XDADs5rswSDa0TaWhC/DfLvLM1I4ce
         Merg==
X-Gm-Message-State: AOAM532MJo85aI5ie9t8rl0d3XBy1DhalscpIpgQCXfoHSYj2FUqsiK4
        J/5CPGGGdYUcysRZxMa4Kydg9g==
X-Google-Smtp-Source: ABdhPJyphhboD4vU1BbfeFdodj1tWM0gh7FOhZ081teffSyvKKio440OZl8evPsQh5/Qb6O0KBVpLw==
X-Received: by 2002:adf:bc02:: with SMTP id s2mr12116547wrg.87.1622715280642;
        Thu, 03 Jun 2021 03:14:40 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id p20sm5091044wmq.10.2021.06.03.03.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:14:40 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 00/10] bpfilter
Date:   Thu,  3 Jun 2021 14:14:15 +0400
Message-Id: <20210603101425.560384-1-me@ubique.spb.ru>
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
targets, rules and tables.

The current version misses handling of counters. Postpone its
implementation until the code generation phase as it's not clear
yet how to better handle them.

Beside that there is no support of net namespaces at all.

In the next iteration basic code generation shall be introduced.

The rough plan for the code generation.

It seems reasonable to assume that the first rules should cover
most of the packet flow.  This is why they are critical from the
performance point of view.  At the same time number of user
defined rules might be pretty large. Also there is a limit on
size and complexity of a BPF program introduced by the verifier.

There are two approaches how to handle iptables' rules in
generated BPF programs.

The first approach is to generate a BPF program that is an
equivalent to a set of rules on a rule by rule basis. This
approach should give the best performance. The drawback is the
limitation from the verifier on size and complexity of BPF
program.

The second approach is to use an internal representation of rules
stored in a BPF map and use bpf_for_each_map_elem() helper to
iterate over them. In this case the helper's callback is a BPF
function that is able to process any valid rule.

Combination of the two approaches should give most of the
benefits - a heuristic should help to select a small subset of
the rules for code generation on a rule by rule basis. All other
rules are cold and it should be possible to store them in an
internal form in a BPF map. The rules will be handled by
bpf_for_each_map_elem().  This should remove the limit on the
number of supported rules.

During development it was useful to use statically linked
sanitizers in bpfilter usermode helper. Also it is possible to
use fuzzers but it's not clear if it is worth adding them to the
test infrastructure - because there are no other fuzzers under
tools/testing/selftests currently.

Patch 1 adds definitions of the used types.
Patch 2 adds logging to bpfilter.
Patch 3 adds bpfilter header to tools
Patch 4 adds an associative map.
Patches 5/6/7/8 add code for matches, targets, rules and table.
Patch 9 handles hooked setsockopt(2) calls.
Patch 10 uses prepared code in main().

Here is an example:
% dmesg  | tail -n 2
[   23.636102] bpfilter: Loaded bpfilter_umh pid 181
[   23.658529] bpfilter: started
% /usr/sbin/iptables-legacy -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
% /usr/sbin/iptables-legacy -A INPUT -p udp --dport 23 -j DROP
% /usr/sbin/iptables-legacy -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
DROP       udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:23

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
% /usr/sbin/iptables-legacy -F
% /usr/sbin/iptables-legacy -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
%

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

Dmitrii Banshchikov (10):
  bpfilter: Add types for usermode helper
  bpfilter: Add logging facility
  tools: Add bpfilter usermode helper header
  bpfilter: Add map container
  bpfilter: Add struct match
  bpfilter: Add struct target
  bpfilter: Add struct rule
  bpfilter: Add struct table
  bpfilter: Add handling of setsockopt() calls
  bpfilter: Handle setsockopts

 .clang-format                                 |   2 +-
 include/uapi/linux/bpfilter.h                 | 155 +++++++
 net/bpfilter/Makefile                         |   3 +-
 net/bpfilter/context.c                        | 181 ++++++++
 net/bpfilter/context.h                        |  46 ++
 net/bpfilter/main.c                           | 123 ++++--
 net/bpfilter/map-common.c                     |  64 +++
 net/bpfilter/map-common.h                     |  19 +
 net/bpfilter/match.c                          |  49 +++
 net/bpfilter/match.h                          |  33 ++
 net/bpfilter/rule.c                           | 163 +++++++
 net/bpfilter/rule.h                           |  32 ++
 net/bpfilter/sockopt.c                        | 409 ++++++++++++++++++
 net/bpfilter/sockopt.h                        |  14 +
 net/bpfilter/table.c                          | 339 +++++++++++++++
 net/bpfilter/table.h                          |  39 ++
 net/bpfilter/target.c                         | 118 +++++
 net/bpfilter/target.h                         |  49 +++
 net/bpfilter/xt_udp.c                         |  33 ++
 tools/include/uapi/linux/bpfilter.h           | 179 ++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   5 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  30 ++
 .../selftests/bpf/bpfilter/bpfilter_util.h    |  39 ++
 .../testing/selftests/bpf/bpfilter/test_map.c |  63 +++
 .../selftests/bpf/bpfilter/test_match.c       |  63 +++
 .../selftests/bpf/bpfilter/test_rule.c        |  55 +++
 .../selftests/bpf/bpfilter/test_target.c      |  85 ++++
 27 files changed, 2346 insertions(+), 44 deletions(-)
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/context.h
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
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_map.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c

-- 
2.25.1

