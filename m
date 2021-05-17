Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290B7386D40
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhEQWyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbhEQWyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:54:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA30CC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v12so8049442wrq.6
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OIxCv4gcjdTZUvS1RQgn5xV32FqkoMM0p8QDWf9iYFA=;
        b=Mylik8qViMlANQMP0dBzfLKLCRVYAEH8ZdBZgJooBr2p6b7+lcPozRkb3/7053wu+a
         zWYwPmbs+O5CArhMPAIKiDsRY/NgVn7SHwSuaFnO8KX/upvpBlzq6KPVL0mwuOfyP4jM
         dzxb5lCWY+BeBObrYtlA/HyhFVx9aftdhQZ58YgpEGDX/+z/szNFcamTschDBaThNyEc
         yl/+QIIjaKYfp8RYxowFxwQS/sj0uXK3cTHvam51bN5MJsLG6O/6Ta4xqDqXPqr53E0E
         n40oXFR8sss4luepQTktXvC15HFph9Y6R530ccMxNqU1Alxb3xeybtvsAJIGCmcgW4AZ
         xTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OIxCv4gcjdTZUvS1RQgn5xV32FqkoMM0p8QDWf9iYFA=;
        b=IN1zUNmnjcqvi0di5ais8ImieGs1ujDtyvJOG8l+5PczvcypvJRdawPXCOMIVi/7YE
         UTTX/VD9Gd4yijcy+PVKT975Hee8LIcDrsgiNqjHbqXQ854tLkEmLjAS3k2aTbPt5SQh
         NiEVZThVTHhLphbSYXGYE4cttks25AglJTyFkPgD00zk6h8nVFRKpQo/pBDtnZ0ceGKM
         6Ug19J1laQw/pJ7qAChSjzJ3uSOJ24OoShIEyT6CHkmWMawYBqRIdI9GnHNeE3pwdNZJ
         gZxDhHPi7/MNBHu/2dp6i3+Lfk36clehjZKgC34ZUfE5iZ13xJcSl5ML1xu0Gy8/iW6i
         vo3Q==
X-Gm-Message-State: AOAM5306bmn+gB/yTADFmsIx201QcQ5ZL8kDyC4sWb4mkCzrX6sMAiIm
        qnmpg9v7TJSQ5lonAhuBSVGRmA==
X-Google-Smtp-Source: ABdhPJydULz+L0n7RUP0ZCn3K9Xox0J05VkTXCkrARxws1c+Fd1qnDJv5iQqL5XYINJfvtH9RWb7nQ==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr2521415wrs.360.1621292000458;
        Mon, 17 May 2021 15:53:20 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id s5sm16225001wmh.37.2021.05.17.15.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:19 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 00/11] bpfilter
Date:   Tue, 18 May 2021 02:52:57 +0400
Message-Id: <20210517225308.720677-1-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset is based on the patches from David S. Miller [1] and Daniel
Borkmann [2].

The main goal of the patchset is to prepare bpfilter for iptables'
configuration blob parsing and code generation.

The patchset introduces data structures and code for matches, targets, rules
and tables.

It seems inconvenient to continue to use the same blob internally in bpfilter
in parts other than the blob parsing. That is why a superstructure with native
types is introduced. It provides a more convenient way to iterate over the blob
and limit the crazy structs widespread in the bpfilter code.

In this patchset version existing blob's correctness checking that is done by
the iptables kernel part is not reproduced. It will be added in the next
iteration.

Also the current version misses handling of counters. Postpone its
implementation until the code generation phase as it's not clear yet how to
better handle them.

The rough plan for the code generation.

It seems reasonable to assume that the first rules should cover most of the
packet flow.  This is why they are critical from the performance point of view.
At the same time a number of user defined rules might be pretty large. Also
there is a limit on size and complexity of a BPF program introduced by the
verifier.

There are two approaches how to handle iptables' rules in generated BPF programs.

The first approach is to generate a BPF program that is an equivalent to a set
of rules on a rule by rule basis. This approach should give the best
performance. The drawback is the limitation from the verifier on size and
complexity of BPF program.

The second approach is to use an internal representation of rules stored in a
BPF map and use bpf_for_each_map_elem() helper to iterate over them. In this case
the helper's callback is a BPF function that is able to process any valid
rule.

Combination of the two approaches should give most of the benefits - a
heuristic should help to select a small subset of the rules for code generation
on a rule by rule basis. All other rules are cold and it should be possible to
store them in an internal form in a BPF map. The rules will be handled by
bpf_for_each_map_elem().  This should remove the limit on the number of
supported rules.

During development it was useful to use statically linked sanitizers in
bpfilter usermode helper. Also it is possible to use fuzzers but it's not clear
if it is worth adding them to the test infrastructure - because there are no
other fuzzers under tools/testing/selftests currently.

Patch 1 adds definitions of the used types.
Patch 2 adds logging facility to bpfilter.
Patch 3 adds IO functions.
Patch 4 adds bpfilter header to tools
Patch 5 adds an associative map.
Patches 6/7/8/9 adds code for matches, targets, rules and table.
Patch 10 handles hooked setsockopt(2) calls.
Patch 11 uses prepared code in main().

Here is the example:

# dmesg  | tail -n 2
[   23.636102] bpfilter: Loaded bpfilter_umh pid 181
[   23.658529] bpfilter: started
# /usr/sbin/iptables-legacy -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
# /usr/sbin/iptables-legacy -A INPUT -p udp --dport 23 -j DROP
# /usr/sbin/iptables-legacy -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
DROP       udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:23

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
# /usr/sbin/iptables-legacy -F
# /usr/sbin/iptables-legacy -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
#


1. https://lore.kernel.org/patchwork/patch/902785/
2. https://lore.kernel.org/patchwork/patch/902783/

Dmitrii Banshchikov (11):
  bpfilter: Add types for usermode helper
  bpfilter: Add logging facility
  bpfilter: Add IO functions
  tools: Add bpfilter usermode helper header
  bpfilter: Add map container
  bpfilter: Add struct match
  bpfilter: Add struct target
  bpfilter: Add struct rule
  bpfilter: Add struct table
  bpfilter: Add handling of setsockopt() calls
  bpfilter: Handle setsockopts

 include/uapi/linux/bpfilter.h                 | 155 ++++++++
 net/bpfilter/Makefile                         |   3 +-
 net/bpfilter/bflog.c                          |  29 ++
 net/bpfilter/bflog.h                          |  24 ++
 net/bpfilter/context.c                        | 176 +++++++++
 net/bpfilter/context.h                        |  27 ++
 net/bpfilter/io.c                             |  77 ++++
 net/bpfilter/io.h                             |  18 +
 net/bpfilter/main.c                           |  99 ++---
 net/bpfilter/map-common.c                     |  64 ++++
 net/bpfilter/map-common.h                     |  19 +
 net/bpfilter/match-ops-map.h                  |  48 +++
 net/bpfilter/match.c                          |  73 ++++
 net/bpfilter/match.h                          |  34 ++
 net/bpfilter/rule.c                           | 128 +++++++
 net/bpfilter/rule.h                           |  27 ++
 net/bpfilter/sockopt.c                        | 357 ++++++++++++++++++
 net/bpfilter/sockopt.h                        |  14 +
 net/bpfilter/table-map.h                      |  41 ++
 net/bpfilter/table.c                          | 167 ++++++++
 net/bpfilter/table.h                          |  33 ++
 net/bpfilter/target-ops-map.h                 |  49 +++
 net/bpfilter/target.c                         | 112 ++++++
 net/bpfilter/target.h                         |  34 ++
 tools/include/uapi/linux/bpfilter.h           | 179 +++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   6 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  31 ++
 .../selftests/bpf/bpfilter/bpfilter_util.h    |  39 ++
 .../testing/selftests/bpf/bpfilter/test_io.c  | 100 +++++
 .../testing/selftests/bpf/bpfilter/test_map.c |  63 ++++
 .../selftests/bpf/bpfilter/test_match.c       |  63 ++++
 .../selftests/bpf/bpfilter/test_rule.c        |  55 +++
 .../selftests/bpf/bpfilter/test_target.c      |  85 +++++
 33 files changed, 2382 insertions(+), 47 deletions(-)
 create mode 100644 net/bpfilter/bflog.c
 create mode 100644 net/bpfilter/bflog.h
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/context.h
 create mode 100644 net/bpfilter/io.c
 create mode 100644 net/bpfilter/io.h
 create mode 100644 net/bpfilter/map-common.c
 create mode 100644 net/bpfilter/map-common.h
 create mode 100644 net/bpfilter/match-ops-map.h
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 net/bpfilter/rule.c
 create mode 100644 net/bpfilter/rule.h
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/sockopt.h
 create mode 100644 net/bpfilter/table-map.h
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h
 create mode 100644 net/bpfilter/target-ops-map.h
 create mode 100644 net/bpfilter/target.c
 create mode 100644 net/bpfilter/target.h
 create mode 100644 tools/include/uapi/linux/bpfilter.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpfilter/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_io.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_map.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c

-- 
2.25.1

