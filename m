Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCBF235694
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 13:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgHBLPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 07:15:48 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52331 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728263AbgHBLPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 07:15:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0U4Tqfqn_1596366940;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4Tqfqn_1596366940)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:40 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        quentin@isovalent.com, kuba@kernel.org, toke@redhat.com,
        tklauser@distanz.ch, tianjia.zhang@linux.alibaba.com,
        jolsa@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianjia.zhang@alibaba.com
Subject: [PATCH] tools/bpf/bpftool: Fix wrong return value in do_dump()
Date:   Sun,  2 Aug 2020 19:15:40 +0800
Message-Id: <20200802111540.5384-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of btf_id does not exist, a negative error code -ENOENT
should be returned.

Fixes: c93cc69004df3 ("bpftool: add ability to dump BTF types")
Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 tools/bpf/bpftool/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index faac8189b285..c2f1fd414820 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -596,7 +596,7 @@ static int do_dump(int argc, char **argv)
 			goto done;
 		}
 		if (!btf) {
-			err = ENOENT;
+			err = -ENOENT;
 			p_err("can't find btf with ID (%u)", btf_id);
 			goto done;
 		}
-- 
2.26.2

