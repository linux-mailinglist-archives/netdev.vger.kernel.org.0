Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0135CC35
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbhDLQ1i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 12:27:38 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:46924 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244297AbhDLQZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:25:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-xCfcqp_7ObyxpbgdmtugIw-1; Mon, 12 Apr 2021 12:25:16 -0400
X-MC-Unique: xCfcqp_7ObyxpbgdmtugIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ADC891270;
        Mon, 12 Apr 2021 16:25:15 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F3006A034;
        Mon, 12 Apr 2021 16:25:03 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCHv4 bpf-next 0/5] bpf: Tracing and lsm programs re-attach
Date:   Mon, 12 Apr 2021 18:24:57 +0200
Message-Id: <20210412162502.1417018-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
while adding test for pinning the module while there's
trampoline attach to it, I noticed that we don't allow
link detach and following re-attach for trampolines.
Adding that for tracing and lsm programs.

You need to have patch [1] from bpf tree for test module
attach test to pass.

v4 changes:
  - fix wrong cleanup goto jump reported by Julia

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210326105900.151466-1-jolsa@kernel.org/
---
Jiri Olsa (5):
      bpf: Allow trampoline re-attach for tracing and lsm programs
      selftests/bpf: Add re-attach test to fentry_test
      selftests/bpf: Add re-attach test to fexit_test
      selftests/bpf: Add re-attach test to lsm test
      selftests/bpf: Test that module can't be unloaded with attached trampoline

 kernel/bpf/syscall.c                                   | 23 +++++++++++++++++------
 kernel/bpf/trampoline.c                                |  2 +-
 tools/testing/selftests/bpf/prog_tests/fentry_test.c   | 51 ++++++++++++++++++++++++++++++++++++---------------
 tools/testing/selftests/bpf/prog_tests/fexit_test.c    | 51 ++++++++++++++++++++++++++++++++++++---------------
 tools/testing/selftests/bpf/prog_tests/module_attach.c | 23 +++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/test_lsm.c      | 48 ++++++++++++++++++++++++++++++++++++++----------
 tools/testing/selftests/bpf/test_progs.h               |  2 +-
 7 files changed, 152 insertions(+), 48 deletions(-)

