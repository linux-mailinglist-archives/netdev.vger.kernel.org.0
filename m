Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340D534BC29
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 13:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhC1L1E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 28 Mar 2021 07:27:04 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:29366 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230502AbhC1L0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 07:26:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-6DF-BRUSNIqLEHVfnEDt0Q-1; Sun, 28 Mar 2021 07:26:39 -0400
X-MC-Unique: 6DF-BRUSNIqLEHVfnEDt0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07F2110059C1;
        Sun, 28 Mar 2021 11:26:37 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B560319C66;
        Sun, 28 Mar 2021 11:26:31 +0000 (UTC)
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
Subject: [RFC PATCH bpf-next 0/4] bpf: Tracing programs re-attach
Date:   Sun, 28 Mar 2021 13:26:25 +0200
Message-Id: <20210328112629.339266-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

I'm not sure this was on purpose, but seems as natural
use of the interface, although the only user is the test
for now.

You need to have patch [1] from bpf tree for test module
attach test to pass.

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210326105900.151466-1-jolsa@kernel.org/
---
Jiri Olsa (4):
      bpf: Allow trampoline re-attach
      selftests/bpf: Add re-attach test to fentry_test
      selftests/bpf: Add re-attach test to fexit_test
      selftests/bpf: Test that module can't be unloaded with attached trampoline

 kernel/bpf/syscall.c                                   | 25 +++++++++++++++++++------
 kernel/bpf/trampoline.c                                |  2 +-
 tools/testing/selftests/bpf/prog_tests/fentry_test.c   | 58 +++++++++++++++++++++++++++++++++++++++++++++-------------
 tools/testing/selftests/bpf/prog_tests/fexit_test.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++-------------
 tools/testing/selftests/bpf/prog_tests/module_attach.c | 23 +++++++++++++++++++++++
 5 files changed, 133 insertions(+), 33 deletions(-)

