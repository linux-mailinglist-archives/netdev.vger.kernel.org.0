Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4CD355DEA
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbhDFV3h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Apr 2021 17:29:37 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:26568 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231138AbhDFV3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:29:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-feItQswIMwqEqG3Jvk2b7A-1; Tue, 06 Apr 2021 17:29:22 -0400
X-MC-Unique: feItQswIMwqEqG3Jvk2b7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C62928189C7;
        Tue,  6 Apr 2021 21:29:20 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E44255C729;
        Tue,  6 Apr 2021 21:29:14 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCHv2 bpf-next 0/5] bpf: Tracing and lsm programs re-attach
Date:   Tue,  6 Apr 2021 23:29:08 +0200
Message-Id: <20210406212913.970917-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

v2 changes:
  - allow re-attach for TRACING and LSM programs
  - add lsm re-attach test

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
 tools/testing/selftests/bpf/prog_tests/fentry_test.c   | 48 ++++++++++++++++++++++++++++++++++++++----------
 tools/testing/selftests/bpf/prog_tests/fexit_test.c    | 48 ++++++++++++++++++++++++++++++++++++++----------
 tools/testing/selftests/bpf/prog_tests/module_attach.c | 23 +++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/test_lsm.c      | 48 ++++++++++++++++++++++++++++++++++++++----------
 6 files changed, 155 insertions(+), 37 deletions(-)

