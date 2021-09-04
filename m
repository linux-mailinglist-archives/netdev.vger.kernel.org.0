Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3715F4008B5
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350576AbhIDAUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:20:31 -0400
Received: from novek.ru ([213.148.174.62]:52842 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233759AbhIDAUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 20:20:31 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 41F26503E99;
        Sat,  4 Sep 2021 03:16:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 41F26503E99
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1630714580; bh=9JqPq7peRsY4mNFr+fTClCX+mFwFyqd195f1blXNxe0=;
        h=From:To:Cc:Subject:Date:From;
        b=UZRYXhVF1iji+HCnTBAPcX0D12Ul7WGh7NJ/vOBrntzdCpc2dEMnW9YZR58xXUCmt
         UlPIbSCAQGq0xn6xSBYirYLb0lcyfWVLSe3GDRTcpBq0kfEaQ6kgtFrmrnfYnfHpYD
         qSnuml9KMVASpHh0YrDO7sgZPZ/NQHOmlqL6+l7g=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/2] add hwtstamp to __sk_buff
Date:   Sat,  4 Sep 2021 03:18:59 +0300
Message-Id: <20210904001901.16771-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds hardware timestamps to __sk_buff. The first patch
implements feature, the second one adds a selftest.

v1 -> v2:

* Fixed bpf_skb_is_valid_access() to provide correct access to field
* Added explicit test to deny access to padding area
* Added verifier selftest to check for denied access to padding area

Vadim Fedorenko (2):
  bpf: add hardware timestamp field to __sk_buff
  selftests/bpf: test new __sk_buff field hwtstamp

 include/uapi/linux/bpf.h                      |  2 +
 lib/test_bpf.c                                |  1 +
 net/bpf/test_run.c                            |  8 +++
 net/core/filter.c                             | 21 +++++++
 tools/include/uapi/linux/bpf.h                |  2 +
 .../selftests/bpf/prog_tests/skb_ctx.c        |  1 +
 .../selftests/bpf/progs/test_skb_ctx.c        |  2 +
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 60 +++++++++++++++++++
 8 files changed, 97 insertions(+)

-- 
2.18.4

