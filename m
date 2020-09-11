Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B62661E9
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIKPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIKPM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:12:58 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9745C06136C
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:32 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c10so10185729edk.6
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b0QD34+bxOAz0p5Ruf1S0pwezgoC99GUrOiFTRHr1WU=;
        b=s7+XJKuz3oEy3pnN/elhmjMP3fwttIcgzseKr38icNThXbOY0LirJo1to8ih0eNwQA
         1KVmgArwT9O0ardNtiHkXQr8ohGLQ3earWaQz2bNkJyavHpjUOfqH+Rutql5evnZd+Wh
         ElzqI1mWKCmB58u26vkRGzBC30VJZaPuMrtCYlhX61qRdr1KXozuXbPHYa6PCfyjzIaD
         fvfOOfdUXUj4+OUuH2PQ2U1nJ34ARaYMY27CZuB+H1DB8Dwubq3h+SEl5oAvEQ3z2Pde
         LMYbLS+kf5N+T2N3Psx1V3ZEDhgWCrTGE48hCzhGy1NvpqiM/I1E80W0/usazP+4Lz07
         5TWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0QD34+bxOAz0p5Ruf1S0pwezgoC99GUrOiFTRHr1WU=;
        b=UfBLHE9STImZNp/3tTlnnHvMRLjNwDsAnDkVtOSPJFmaQcZ69KYz1PBxwhZTEMqEnS
         7vg5Q1dva58mpnnbIXPdfk5q0YXQbRrVYzyWU13qErGeq4Ef3QeT7J7+30QtmoCvjBE/
         91HUPueTa8XJPTSMncXgldJS0DbWGQ7TlJLZVIbrSlMBOAL3eoKkT3tFbyDC/vWKJArX
         thQCqyLkSXl/PQGuX7LbLCOYoSBoXh6DUdmUzey/L8o1HVXCRNKmSGJ0OHSKQlaB6sCJ
         yhR0KaD5+NG7FKPkl5S6aDi34PoiQGx+H9gfwCWUH1mEU5O2okOb38ZpljJdy45VQnZM
         Pv5g==
X-Gm-Message-State: AOAM533+bcuiWpOjsmATo+11M0OLAL1viffBLxirrx6hifW71GlTgwwG
        70K1Auu1XkmI6xv6eEUZ+h54WcBHrJ6BMtjm
X-Google-Smtp-Source: ABdhPJyNl/jj9IvK4T0bkJprq/8BXcKllYou73+Al1l1qxTjRLji8C3rkP9NSSxO0s2oL8lobF2CFA==
X-Received: by 2002:a05:6402:1710:: with SMTP id y16mr2416437edu.197.1599834691462;
        Fri, 11 Sep 2020 07:31:31 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id y21sm1716261eju.46.2020.09.11.07.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 07:31:30 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 0/5] bpf: add MPTCP subflow support
Date:   Fri, 11 Sep 2020 16:30:21 +0200
Message-Id: <20200911143022.414783-6-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously it was not possible to make a distinction between plain TCP
sockets and MPTCP subflow sockets on the BPF_PROG_TYPE_SOCK_OPS hook.

This patch series now enables a fine control of subflow sockets. In its
current state, it allows to put different sockopt on each subflow from a
same MPTCP connection (socket mark, TCP congestion algorithm, ...) using
BPF programs.

It should also be the basis of exposing MPTCP-specific fields through BPF.

v1 -> v2:
- add basic mandatory selftests for the new helper and is_mptcp field (Alexei)
- rebase on latest bpf-next

Nicolas Rybowski (5):
  bpf: expose is_mptcp flag to bpf_tcp_sock
  mptcp: attach subflow socket to parent cgroup
  bpf: add 'bpf_mptcp_sock' structure and helper
  bpf: selftests: add MPTCP test base
  bpf: selftests: add bpf_mptcp_sock() verifier tests

 include/linux/bpf.h                           |  33 +++++
 include/uapi/linux/bpf.h                      |  15 +++
 kernel/bpf/verifier.c                         |  30 +++++
 net/core/filter.c                             |  13 +-
 net/mptcp/Makefile                            |   2 +
 net/mptcp/bpf.c                               |  72 +++++++++++
 net/mptcp/subflow.c                           |  27 ++++
 scripts/bpf_helpers_doc.py                    |   2 +
 tools/include/uapi/linux/bpf.h                |  15 +++
 tools/testing/selftests/bpf/config            |   1 +
 tools/testing/selftests/bpf/network_helpers.c |  37 +++++-
 tools/testing/selftests/bpf/network_helpers.h |   3 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 119 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/mptcp.c     |  48 +++++++
 tools/testing/selftests/bpf/verifier/sock.c   |  63 ++++++++++
 15 files changed, 474 insertions(+), 6 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp.c

-- 
2.28.0

