Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBA10ACD7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfK0Jsy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 04:48:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42766 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726655AbfK0Jsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 04:48:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-NFXHfLVYNiSAs2jPeVzGOA-1; Wed, 27 Nov 2019 04:48:49 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD0380183D;
        Wed, 27 Nov 2019 09:48:47 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B627E5D6C8;
        Wed, 27 Nov 2019 09:48:38 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
Date:   Wed, 27 Nov 2019 10:48:34 +0100
Message-Id: <20191127094837.4045-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: NFXHfLVYNiSAs2jPeVzGOA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding support to link bpftool with libbpf dynamically,
and config change for perf.

It's now possible to use:
  $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1

which will detect libbpf devel package with needed version,
and if found, link it with bpftool.

It's possible to use arbitrary installed libbpf:
  $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/

I based this change on top of Arnaldo's perf/core, because
it contains libbpf feature detection code as dependency.
It's now also synced with latest bpf-next, so Toke's change
applies correctly.

Also available in:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  libbpf/dyn

thanks,
jirka


---
Jiri Olsa (2):
      perf tools: Allow to specify libbpf install directory
      bpftool: Allow to link libbpf dynamically

Toke Høiland-Jørgensen (1):
      libbpf: Export netlink functions used by bpftool

 tools/bpf/bpftool/Makefile        | 40 +++++++++++++++++++++++++++++++++++++++-
 tools/build/feature/test-libbpf.c |  9 +++++++++
 tools/lib/bpf/libbpf.h            | 22 +++++++++++++---------
 tools/lib/bpf/libbpf.map          |  7 +++++++
 tools/lib/bpf/nlattr.h            | 15 ++++++++++-----
 tools/perf/Makefile.config        | 27 ++++++++++++++++++++-------
 6 files changed, 98 insertions(+), 22 deletions(-)

