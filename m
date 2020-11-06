Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947EA2A91C3
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgKFIrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:47:45 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:63913 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgKFIrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:47:45 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id F2A94666AB2;
        Fri,  6 Nov 2020 16:47:41 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] trace: Fix passing zero to 'PTR_ERR' warning
Date:   Fri,  6 Nov 2020 16:47:32 +0800
Message-Id: <1604652452-11494-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGE4YGUNOT09KGUhNVkpNS09NTklPTUlDT0pVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTY6Mww6CT8iLx0KDUILTAsJ
        OChPCTNVSlVKTUtPTU5JT01ISU1IVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKQkxDNwY+
X-HM-Tid: 0a759cbd72669373kuwsf2a94666ab2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix smatch warning.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4517c8b..2cb9c45
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1198,7 +1198,7 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 	*btf = bpf_get_btf_vmlinux();
 
 	if (IS_ERR_OR_NULL(*btf))
-		return PTR_ERR(*btf);
+		return PTR_ERR_OR_ZERO(*btf);
 
 	if (ptr->type_id > 0)
 		*btf_id = ptr->type_id;
-- 
2.7.4

