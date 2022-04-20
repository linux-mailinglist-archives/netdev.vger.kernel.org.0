Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A915092A3
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355095AbiDTW2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354703AbiDTW2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:28:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02293EF1D;
        Wed, 20 Apr 2022 15:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650493513; x=1682029513;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r9LY3WFLduSnTQMkiS5Ws8Iy2E6GlTrLZPKg8LD099s=;
  b=bh/qdViDZlbHh3oJd/C62B+JepMOKuFA8dCE8wIvBy2ID35wYozPgHTY
   MoPsZitC3tkYEqsige8LfFjUeyRHauBtss4BUBtX6L8y9bOWkB4OY24vI
   e+YL9WegYO5ekK9yR/SsXZD3WmOjaNHDDA2AcsCdCLrtmoIGxawNOE/sg
   5mxI/QMd4VY9vD+ob8+TSeT9NOKVe7fQgQUC9vekpcyBvbLoh7w71VGGs
   3LtURBOpMV9EFyqv7JXSejO8V/2ZGTbVScq4FR2n2/XVQ04qCs7ma6eR0
   6id2XOELQTk7rXr4Wn0zSB4GMJSzfmuVzvhB8Sd9rnNeBKYuq/KbHrKe3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289277574"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="289277574"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="555422577"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.100.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:25:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev
Subject: [PATCH bpf-next 0/7] bpf: mptcp: Support for mptcp_sock and is_mptcp
Date:   Wed, 20 Apr 2022 15:24:52 -0700
Message-Id: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello BPF maintainers -

I'm one of the MPTCP subsystem maintainers. We have a MPTCP mailing list
and git repo, and have so far been upstreaming all of our commits
through the net-next and net trees. This is our first patch set for
bpf-next.

Our larger BPF-related project right now is implementing BPF-based
packet scheduling for MPTCP. One MPTCP connection may aggregate multiple
TCP "subflows", and the packet scheduler chooses which of those subflows
to use for each outgoing packet. So far we have been focusing on
BPF-based TCP congestion control code as a template.

This patch set adds BPF access to the is_mptcp flag in tcp_sock and
access to mptcp_sock structures, along with associated self tests. You
may recognize some of the code from earlier
(https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
but it has been reworked quite a bit.

Our current plan for MPTCP-related BPF patches is to continue doing
initial review on the MPTCP mailing list, and then upstream those
changes through the mailing lists to the bpf-next or bpf trees as
appropriate. This has worked well for net-next and net so far, but if
you'd prefer to handle MPTCP/BPF changes differently we can discuss
alternatives of course!

Thanks,

Mat


Geliang Tang (5):
  bpf: add bpf_skc_to_mptcp_sock_proto
  selftests: bpf: test bpf_skc_to_mptcp_sock
  selftests: bpf: verify token of struct mptcp_sock
  selftests: bpf: verify ca_name of struct mptcp_sock
  selftests: bpf: verify first of struct mptcp_sock

Nicolas Rybowski (2):
  bpf: expose is_mptcp flag to bpf_tcp_sock
  selftests: bpf: add MPTCP test base

 MAINTAINERS                                   |   2 +
 include/linux/btf_ids.h                       |   3 +-
 include/net/mptcp.h                           |   6 +
 include/uapi/linux/bpf.h                      |   8 +
 net/core/filter.c                             |  26 +-
 net/mptcp/Makefile                            |   4 +
 net/mptcp/bpf.c                               |  22 ++
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |   8 +
 .../testing/selftests/bpf/bpf_mptcp_helpers.h |  17 ++
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   4 +
 tools/testing/selftests/bpf/config            |   1 +
 tools/testing/selftests/bpf/network_helpers.c |  43 ++-
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 258 ++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  76 ++++++
 16 files changed, 474 insertions(+), 10 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c


base-commit: c7655df434de1dab1af1b1ba2aad757b15e25b83
-- 
2.36.0

