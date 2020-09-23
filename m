Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E700275956
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIWOFP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 10:05:15 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:26075 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbgIWOFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:05:14 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-bnZt6VK9N82OrVMvDVFZTg-1; Wed, 23 Sep 2020 10:05:11 -0400
X-MC-Unique: bnZt6VK9N82OrVMvDVFZTg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A8701007471;
        Wed, 23 Sep 2020 14:05:09 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4981955777;
        Wed, 23 Sep 2020 14:05:04 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Seth Forshee <seth.forshee@canonical.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next 2/2] tools resolve_btfids: Always force HOSTARCH
Date:   Wed, 23 Sep 2020 16:04:59 +0200
Message-Id: <20200923140459.3029213-2-jolsa@kernel.org>
In-Reply-To: <20200923140459.3029213-1-jolsa@kernel.org>
References: <20200923140459.3029213-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seth reported problem with cross builds, that fail
on resolve_btfids build, because we are trying to
build it on cross build arch.

Fixing this by always forcing the host arch.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index a88cd4426398..d3c818b8d8d3 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../scripts/Makefile.include
+include ../../scripts/Makefile.arch
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
@@ -29,6 +30,7 @@ endif
 AR       = $(HOSTAR)
 CC       = $(HOSTCC)
 LD       = $(HOSTLD)
+ARCH     = $(HOSTARCH)
 
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 
-- 
2.26.2

