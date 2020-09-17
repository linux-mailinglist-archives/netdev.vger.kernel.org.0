Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED95A26D5A2
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgIQIGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgIQIGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 04:06:37 -0400
Received: from mail.kernel.org (ip5f5ad5d2.dynamic.kabel-deutschland.de [95.90.213.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD22D221E8;
        Thu, 17 Sep 2020 08:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600329870;
        bh=mYwYOXWHk8m9yb3WuJTI/V6/GmciN+v4xy+Pzj/6yrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmhcMPOapbbfMbgpTrJy+WRPRaosnbfTglGznVwZt+kUxXqP2o+VvO5EXbptacD6J
         mPrcWfom7WQb7eK9NEMfh3/Ot66XLheBK3+ecYyddkRJUMWpQWO5e9izKNPmakk0c9
         9z0F9ZCADzLLWKZQVAlFcBgv8iQ973wB1aJFDiGo=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kIou4-0051LU-Ai; Thu, 17 Sep 2020 10:04:28 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 3/3] docs: bpf: ringbuf.rst: fix a broken cross-reference
Date:   Thu, 17 Sep 2020 10:04:27 +0200
Message-Id: <442b27cc035ab7f9e5e000f2ac44ce88ea8b16a6.1600328701.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1600328701.git.mchehab+huawei@kernel.org>
References: <cover.1600328701.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sphinx warns about a broken cross-reference:

	Documentation/bpf/ringbuf.rst:194: WARNING: Unknown target name: "bench_ringbufs.c".

It seems that the original idea were to add a reference for this file:

	tools/testing/selftests/bpf/benchs/bench_ringbufs.c

However, this won't work as such file is not part of the
documentation output dir. It could be possible to use
an extension like interSphinx in order to make external
references to be pointed to some website (like kernel.org),
where the file is stored, but currently we don't use it.

It would also be possible to include this file as a
literal include, placing it inside Documentation/bpf.

For now, let's take the simplest approach: just drop
the "_" markup at the end of the reference. This
should solve the warning, and it sounds quite obvious
that the file to see is at the Kernel tree.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/bpf/ringbuf.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/ringbuf.rst b/Documentation/bpf/ringbuf.rst
index 4d4f3bcb1477..6a615cd62bda 100644
--- a/Documentation/bpf/ringbuf.rst
+++ b/Documentation/bpf/ringbuf.rst
@@ -197,7 +197,7 @@ a self-pacing notifications of new data being availability.
 being available after commit only if consumer has already caught up right up to
 the record being committed. If not, consumer still has to catch up and thus
 will see new data anyways without needing an extra poll notification.
-Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c_) show that
+Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c) show that
 this allows to achieve a very high throughput without having to resort to
 tricks like "notify only every Nth sample", which are necessary with perf
 buffer. For extreme cases, when BPF program wants more manual control of
-- 
2.26.2

