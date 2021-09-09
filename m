Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E444405F34
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 00:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbhIIWFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 18:05:43 -0400
Received: from novek.ru ([213.148.174.62]:36502 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233941AbhIIWFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 18:05:42 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D6537501DE0;
        Fri, 10 Sep 2021 01:01:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D6537501DE0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1631224876; bh=knI9zL7DHmbbRa50b0ja/vn66zhetdcKtlmDiBTy9bg=;
        h=From:To:Cc:Subject:Date:From;
        b=r1dTqGZw+egwE0jTgz1YvNcdaOk8J2xQZQmiaqWOQs3vcs3vB3trlfl8+wbyX2cFB
         nTXSmMz/IrkSpSemB4GdFxl0SzJBwgk0NerRvgWnO4v7yCP/BsKnJea4T1LCBRwosD
         D8NdET8dDHbbEKeE8xYiHoeeQ7SrxuN1DL6ZLLJk=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/2] add hwtstamp to __sk_buff
Date:   Fri, 10 Sep 2021 01:04:07 +0300
Message-Id: <20210909220409.8804-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds hardware timestamps to __sk_buff. The first patch
implements feature, the second one adds a selftest.

v2 -> v3:
* rebase on bpf-next

v1 -> v2:

* Fixed bpf_skb_is_valid_access() to provide correct access to field
* Added explicit test to deny access to padding area
* Added verifier selftest to check for denied access to padding area

Acked-by: Martin KaFai Lau <kafai@fb.com>

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

