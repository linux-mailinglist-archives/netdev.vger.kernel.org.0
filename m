Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F39E75AF6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 00:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfGYWwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 18:52:46 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:35170 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfGYWwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 18:52:45 -0400
Received: by mail-pf1-f201.google.com with SMTP id r142so31819452pfc.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 15:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DgAXQIdA0ZhiJ+xsheYT6VV9/xgThvpc7H+hWpWWals=;
        b=Z+b/bGhRGPiEr7jhNeoEliqMlHbZtMWeT6oR9aAmNAfg3zihXrHrIG0e2I8bdrRR4z
         mJughnLma8eXEITUZPgDD4EIF/ZbdBuKQaAWn5HFgjxpVU/WTjI7En3/vqrQ2imEsRzi
         DYFwCPQXIFD+ltMPHODkscT7xGTqBm1rnInUxOqkmHZSw0/8qXa4DTRz8bAGyTLPgwMW
         JOCM1/EByu3hI2/Nt+sBN0qX/npziImmxt9H0o+BgPoQqvkfnojUDI8gJWUFsGBWJxVV
         kTJIqlsqV5UshEzLs9vi8eUSrfl6UiYtuiuPrCQGlUTJw89gNgLTTwtte4x4yjfBqrS3
         1z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DgAXQIdA0ZhiJ+xsheYT6VV9/xgThvpc7H+hWpWWals=;
        b=TQnDI1/KPD4YaiCN9y3G6UMlqxvIeng32GCCvJwZYJkzs5aBshVsBfbVWQVKfEW/lL
         4gBdVdNd3TiWvsAysb6Yx/O+m7HGnxvluHKaBo9ylyglOWI29QMkS1Bz+OLydMTr2cSA
         TzhNay7zSPBknrJ6/rqCs6tstmfbnoTaOxeD/ab9RffUqBQ0V8BlylYJIJhYm8IXysqP
         OKDtZNcP20i0JNWVLT2Wsn6/Rl3WBzFiE8J3gs0QnzF+SJM9hU+IELmwOCocVHrwkLun
         6KFyNYnjtGvXXS6Q11JSzTv0rOLy0GKEphjPI+7eM2K2wnmFOr9+lGEUvScTwMq///CM
         obWA==
X-Gm-Message-State: APjAAAWnwgXniCYPTCR0YFSTdvifDVFdiE9kMvlsMZPNqCLRhI9fGTSf
        7dAl4BChO8C+4mqH66OK60CAxKmG4omvq+a4hQK2+xlOS/FafSZKt/VrY0ICBMF6EsHaCu20IYC
        OUJe+AKsUYdX9hhS+fJSRWk9/FkSj9ew1b2yHNG8nOR21b4ysRvQCrw==
X-Google-Smtp-Source: APXvYqywSlusS3kT7pdugZP6FYyE64YryoLfEc2VX+H5iycxuT1/zBr3TIiXIPi4jVFlf3CLM2yjoEU=
X-Received: by 2002:a65:44cb:: with SMTP id g11mr42780890pgs.288.1564095164486;
 Thu, 25 Jul 2019 15:52:44 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:52:28 -0700
In-Reply-To: <20190725225231.195090-1-sdf@google.com>
Message-Id: <20190725225231.195090-5-sdf@google.com>
Mime-Version: 1.0
References: <20190725225231.195090-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next v3 4/7] tools/bpf: sync bpf_flow_keys flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export bpf_flow_keys flags to tools/libbpf/selftests.

Acked-by: Petar Penkov <ppenkov@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65..2e4b0848d795 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3504,6 +3504,10 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
+#define BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
+#define BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL		(1U << 1)
+#define BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
+
 struct bpf_flow_keys {
 	__u16	nhoff;
 	__u16	thoff;
@@ -3525,6 +3529,7 @@ struct bpf_flow_keys {
 			__u32	ipv6_dst[4];	/* in6_addr; network order */
 		};
 	};
+	__u32	flags;
 };
 
 struct bpf_func_info {
-- 
2.22.0.709.g102302147b-goog

