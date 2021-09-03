Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB43FF6F8
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241586AbhIBWRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:17:11 -0400
Received: from novek.ru ([213.148.174.62]:60332 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhIBWRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 18:17:10 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D1F19500549;
        Fri,  3 Sep 2021 01:12:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D1F19500549
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1630620782; bh=KNQjZbtXquHQ4V93076S6OZRbMnpHc7vfvGqQCcVcNg=;
        h=From:To:Cc:Subject:Date:From;
        b=eM0vVXtMv/i1VIr7+rudyMWB7WkGuMNA/6KNI32Xadb0c3fQ3KoU7XGpU/rlKzNWL
         r0X3OaRFAEkVnIUQWQ5SaEaGJoJCbQhCTZVNvXhFvPPlOC1Oc4p+EgWv22QATODSQT
         mdMYPqU3wQZYQ0h2c28S/8ceQgObyVSIB5xrbczA=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/2] add hwtstamp to __sk_buff
Date:   Fri,  3 Sep 2021 01:15:49 +0300
Message-Id: <20210902221551.15566-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds hardware timestamps to __sk_buff. The first patch
implements feature, the second one adds a selftest.

Vadim Fedorenko (2):
  bpf: add hardware timestamp field to __sk_buff
  selftests/bpf: test new __sk_buff field hwtstamp

 include/uapi/linux/bpf.h                      |  2 +
 lib/test_bpf.c                                |  1 +
 net/bpf/test_run.c                            |  8 ++++
 net/core/filter.c                             | 11 +++++
 tools/include/uapi/linux/bpf.h                |  2 +
 .../selftests/bpf/prog_tests/skb_ctx.c        |  1 +
 .../selftests/bpf/progs/test_skb_ctx.c        |  2 +
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 47 +++++++++++++++++++
 8 files changed, 74 insertions(+)

-- 
2.18.4

