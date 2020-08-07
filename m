Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883DB23EACA
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgHGJq7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Aug 2020 05:46:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37871 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727820AbgHGJq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:46:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-dp9Td0yUN-CSRuKWcwB76w-1; Fri, 07 Aug 2020 05:46:51 -0400
X-MC-Unique: dp9Td0yUN-CSRuKWcwB76w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C13101C8A5;
        Fri,  7 Aug 2020 09:46:49 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1714D6932A;
        Fri,  7 Aug 2020 09:46:45 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v10 bpf-next 11/14] bpf: Update .BTF_ids section in btf.rst with sets info
Date:   Fri,  7 Aug 2020 11:45:56 +0200
Message-Id: <20200807094559.571260-12-jolsa@kernel.org>
In-Reply-To: <20200807094559.571260-1-jolsa@kernel.org>
References: <20200807094559.571260-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updating btf.rst doc with info about BTF_SET_START/END macros.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/btf.rst | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index b5361b8621c9..44dc789de2b4 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -724,6 +724,31 @@ want to define unused entry in BTF_ID_LIST, like::
       BTF_ID_UNUSED
       BTF_ID(struct, task_struct)
 
+The ``BTF_SET_START/END`` macros pair defines sorted list of BTF ID values
+and their count, with following syntax::
+
+  BTF_SET_START(set)
+  BTF_ID(type1, name1)
+  BTF_ID(type2, name2)
+  BTF_SET_END(set)
+
+resulting in following layout in .BTF_ids section::
+
+  __BTF_ID__set__set:
+  .zero 4
+  __BTF_ID__type1__name1__3:
+  .zero 4
+  __BTF_ID__type2__name2__4:
+  .zero 4
+
+The ``struct btf_id_set set;`` variable is defined to access the list.
+
+The ``typeX`` name can be one of following::
+
+   struct, union, typedef, func
+
+and is used as a filter when resolving the BTF ID value.
+
 All the BTF ID lists and sets are compiled in the .BTF_ids section and
 resolved during the linking phase of kernel build by ``resolve_btfids`` tool.
 
-- 
2.25.4

