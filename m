Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878793DAFEE
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 01:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhG2Xh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 19:37:27 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:62976 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbhG2XhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 19:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627601842; x=1659137842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ue07W/Z0VJ2j1XU1R2r8p3b/MCrZd/T/7jeVdKxGJcM=;
  b=S16MRM1fklNPmclYytwfQYcduToJ80AJjpS31gjMHQ/Od2r8kiiZN8Xn
   N39obe/aQ10vEBxjyzgLXQ7hlaHI940SfnCPVRVDzuchESdSy2a1tE+pP
   GXSxrA5DUdxAp3+ncUm8GA5fAVQJxg+wj4m8MZzDr/NPMTa/O1159bvCx
   A=;
X-IronPort-AV: E=Sophos;i="5.84,280,1620691200"; 
   d="scan'208";a="128930036"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 29 Jul 2021 23:37:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 0818BC01C0;
        Thu, 29 Jul 2021 23:37:19 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 23:37:19 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.164) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 23:37:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/2] BPF iterator for UNIX domain socket.
Date:   Fri, 30 Jul 2021 08:36:43 +0900
Message-ID: <20210729233645.4869-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.164]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BPF iterator support for UNIX domain socket.  The first
patch implements it and the second adds a selftest.


Kuniyuki Iwashima (2):
  bpf: af_unix: Implement BPF iterator for UNIX domain socket.
  selftest/bpf: Implement sample UNIX domain socket iterator program.

 include/linux/btf_ids.h                       |  3 +-
 net/unix/af_unix.c                            | 78 +++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 75 ++++++++++++++++++
 4 files changed, 172 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

-- 
2.30.2

