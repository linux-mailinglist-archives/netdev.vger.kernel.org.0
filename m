Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CEB1C42EB
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgEDRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbgEDRed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:34:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BB0C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:34:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s8so272700ybj.9
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QB9t+sbZGHzJpv3tHbtJBJi6NaCwuRD6QoQ/50SYO+I=;
        b=mQAxxswoDxCw20mFH0wR0ejJhENcKxqhrqjjTnAYnJ4up+anjt4yH0hwr8uLqh09BW
         Vw1fKKCFFKs+TqQWpcKcxeJKL93KjBU/0H4WB6jMoh9pEbyDv6OLph51hJiA9u9oqL48
         oFcJJhRbHtybzEQQpWEDi8z0HzACfCOX1U9FIEwK/SPopJ9bgTB5SR3i2lXcT+t+4G98
         L4Feb1xVJZ15L0jH5pODZDPiaMDFxFIVIL/Soi7XfyK+BLXl1Ds98yD7jKRHk47p8r0Y
         cWUEHtQxWlpyx2+IYzt9samVxpQH39WlQ0xBUqChKRpfFBNWrohT2mP5piGTFiXhci/T
         mlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QB9t+sbZGHzJpv3tHbtJBJi6NaCwuRD6QoQ/50SYO+I=;
        b=o4fs6pPu2aXgVmkeNNlMisXBL5dqQRR26hDjbG/3AUNm+jCksxDBsPHBBhZv5rYWj4
         DMbqrTZPQ+kPXWNzz+UL5dpdYOAbGcg9rxnyp1gtTzuG3cvZSnLBFptCtdhvWrpYifFK
         z0n58BQQdzrvwik/H4GFxcpDLQzjD/YusJbP1e6ASsjwZT3Dj73loQmqXhiSX4GRQwvx
         yz5zybx5nMyqtUhpsxQqK2g5OTAZETWoUBZyMl0q3slahlFKEpw1LKdCcLaNm4Je5+qn
         2ruCk0IRmrllZrqSDkt7HmFe9ZwpMeX60fLVrNZyI0TRPsTftSv1eXvGc+SgKfU6E9fE
         G9pg==
X-Gm-Message-State: AGi0PuZtQOj6mwSKUcBipDr+hfSnYpPaI1C5vxy7BmDppd4+kyJqUwdE
        D8h1DvCW3z8P3SOYdcBc3l+lhbIdldkVcJ2Zs49TQpjlB5spKW0SRFuklllt2gCx2HhVHL/VNWx
        7yN/CAH4F7Gvc2rcMj1l+FVQYvHXHYFEgYAjE0oUNowL8gYfxS1gOkA==
X-Google-Smtp-Source: APiQypJrPqEuNCfO7K2PJONthu5nSiOEmR5jy3vAk6e5G9y74P+xXRzrFl8girUlxrHwp+Evk6+PEHE=
X-Received: by 2002:a25:f206:: with SMTP id i6mr460384ybe.415.1588613671955;
 Mon, 04 May 2020 10:34:31 -0700 (PDT)
Date:   Mon,  4 May 2020 10:34:26 -0700
Message-Id: <20200504173430.6629-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next 0/4] bpf: allow any port in bpf_bind helper
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to have a tighter control on what ports we bind to in
the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
connect() becomes slightly more expensive.

The series goes like this:
1. selftests: move existing helpers that make it easy to create
   listener threads into common test_progs part
2. selftests: make sure the helpers above don't get stuck forever
   in case the tests fails
3. do small refactoring of __inet{,6}_bind() flags to make it easy
   to extend them with the additional flags
4. remove the restriction on port being zero in bpf_bind() helper;
   add new bind flag to prevent POST_BIND hook from being called

Cc: Andrey Ignatov <rdna@fb.com>

Stanislav Fomichev (4):
  selftests/bpf: generalize helpers to control backround listener
  selftests/bpf: adopt accept_timeout from sockmap_listen
  net: refactor arguments of inet{,6}_bind
  bpf: allow any port in bpf_bind helper

 include/net/inet_common.h                     |   8 +-
 include/net/ipv6_stubs.h                      |   2 +-
 net/core/filter.c                             |  15 +-
 net/ipv4/af_inet.c                            |  20 ++-
 net/ipv6/af_inet6.c                           |  22 +--
 .../bpf/prog_tests/connect_force_port.c       | 104 +++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c |  34 ----
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 115 +-----------
 .../selftests/bpf/progs/connect_force_port4.c |  28 +++
 .../selftests/bpf/progs/connect_force_port6.c |  28 +++
 tools/testing/selftests/bpf/test_progs.c      | 165 ++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h      |   7 +
 12 files changed, 372 insertions(+), 176 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c

-- 
2.26.2.526.g744177e7f7-goog
