Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48EA26FC47
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgIRMNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgIRMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:13:08 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224FFC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:13:08 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n13so5799004edo.10
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=le+49qeMoYWRiEHhru6tG/8VGXjg9SNJqhqTvJk1qpk=;
        b=0BiUsPGSnuJXW5JQTU39UHmRTLNDfi7jJOSkypi0tNCA15smhA9ME1h/R1UaO/4xbq
         kyo1f63q6EMOhHU00lzjtcfngDzP2/2W2TBdUkwY0mz5bvAG9SOvrNUeu1BACNTzJrDT
         LYnmlDWwtuMkhNeyW1iozuM+niWWT2PDQrWPQmxox3rJQ+cG51CIKreVGpj5qDDhmY7L
         saILPzlkN6DBgSea4r12W38ZqQk2tkFzGFUkzvdx2sMo3zZkIzaAXQKtcOQDVgdFfLKd
         UghQ+HS14l/6qlNkwu+x0nb5mNiKoIfQTf3IRhUrlJzGqAHRknR3FjdZ3DaVwZv8P4eH
         rvrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=le+49qeMoYWRiEHhru6tG/8VGXjg9SNJqhqTvJk1qpk=;
        b=cv/FWUDOe8eewNjBnn0BF5GgNcwNR9tTXEyRRcplYY2CL4MnCsNnGPUsmgZRT0zYq5
         7AXfjsohwhymHsMPqPmN9CAjfZ185OmeFMK/EEr74BRe68uIDvmxwAMT2CJbd+n5Jcl7
         oDTaUnTU2qM7v/VksP3iM3e2c4vZDKPEe2Yh3/PS23f/cFb4JvJ++WhlDN09nrQVLauX
         jxAOzIn3ixtE3TjJjvrIouMrENip2FMwPBt3kZ+I3uCu3bIc7o1RAnAPKTRZdVnRGka0
         m/XqnOgv1NM05HENcp91/qIR6fnCGart+XbkH6PaCSypFsDkt3d1pyTobtQNdevWPREK
         BRTw==
X-Gm-Message-State: AOAM530eHmfYoz2dk5N1rmxZimDmYyzvH7dFPfePJ2oV1TjDu0HGCvVd
        QTuGL+4XhtqRQM09tL+AOhoGfQ==
X-Google-Smtp-Source: ABdhPJyKjkptyqJsAy01GKrydbIkNu2sZeVapOZjiUlBmUdqZEUCrEEHBOKj+j5rztEhjWWwOnBb+g==
X-Received: by 2002:a50:f687:: with SMTP id d7mr39719908edn.353.1600431186848;
        Fri, 18 Sep 2020 05:13:06 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id h64sm2084555edd.50.2020.09.18.05.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:13:06 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: [PATCH bpf-next v3 0/5] bpf: add MPTCP subflow support
Date:   Fri, 18 Sep 2020 14:10:45 +0200
Message-Id: <20200918121046.190240-6-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
References: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

v2 -> v3:
- minor modifications in new MPTCP selftests (Song). More details in patch notes.
- rebase on latest bpf-next
- the new is_mptcp field in bpf_tcp_sock is left as an __u32 to keep cohesion 
with the is_fullsock field from bpf_sock_ops. Also it seems easier with a __u32 
on the verifier side.

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
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 118 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/mptcp.c     |  48 +++++++
 tools/testing/selftests/bpf/verifier/sock.c   |  63 ++++++++++
 15 files changed, 473 insertions(+), 6 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp.c

-- 
2.28.0

