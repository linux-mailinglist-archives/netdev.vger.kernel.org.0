Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5951F27609B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIWS5z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 14:57:55 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:47950 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726600AbgIWS5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:57:52 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-Cg6JPIpSM66tKcBYPu80Ag-1; Wed, 23 Sep 2020 14:57:44 -0400
X-MC-Unique: Cg6JPIpSM66tKcBYPu80Ag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3280800135;
        Wed, 23 Sep 2020 18:57:42 +0000 (UTC)
Received: from krava.redhat.com (ovpn-112-117.ams2.redhat.com [10.36.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1371F3782;
        Wed, 23 Sep 2020 18:57:39 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Seth Forshee <seth.forshee@canonical.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv3 bpf-next 2/2] tools resolve_btfids: Always force HOSTARCH
Date:   Wed, 23 Sep 2020 20:57:35 +0200
Message-Id: <20200923185735.3048198-2-jolsa@kernel.org>
In-Reply-To: <20200923185735.3048198-1-jolsa@kernel.org>
References: <20200923185735.3048198-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seth reported problem with cross builds, that fail
on resolve_btfids build, because we are trying to
build it on cross build arch.

Fixing this by always forcing the host arch.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
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

