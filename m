Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D96F3513
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389546AbfKGQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:52:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbfKGQw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 11:52:26 -0500
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C800155E0
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 16:52:25 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id m2so608216lfo.20
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:52:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=acP9fb6exvsZs782cFrwYMpKQr8KtyGllKJtn5n3npM=;
        b=TkvzGh1/aT9hEy/rxYZT5oFlAYcq1hdT8qWy5GavgK3SwaIKN5/IWCWvBC0QzpMkEc
         0pmJiy6HBZQrcF7gYohmOTuhog9f7Ur6Ns5/kxZwW9HLJAl/jD6vohjVs62M6jtS0NZF
         HcKxkHsXQjiRznggQVO9lbmsGMbca8vT+Ih2Jq6Lm+Bqt5Q15+ulJe56lrOPovbaGyhZ
         gkQA3Ev2v2mN8N06HJzKaGTcIrlkKph+AY9ZLUMCcYf6DB/TecwtW768mwb9v1jTJ3Sa
         VgSt6a+rYcvfKN7GuI3a8Wk13K1jPhENyJV5tp8GjnyaS3F9QBUqHDpfB1BbWmTJvU8C
         Egrg==
X-Gm-Message-State: APjAAAWkxfKgBKnc5iYzZYLgndHgDxdJgv3ZpN8dTy89CI5vG9YKkwvM
        et2fChGuuEiqurJje8AWykTqhMfj2IKH4wM4fJnwt73qYmJ0nN16YS4F4mAnDww8LO46TDe/Pqd
        nnWAnYbqK6j+UTjlf
X-Received: by 2002:a2e:6c0c:: with SMTP id h12mr3121106ljc.222.1573145544056;
        Thu, 07 Nov 2019 08:52:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQhCgBbNvPQDprTKqC2YP3/j75gRdIfXR1H9LNM4VEdTOCxxW7PUd2vKh01JN6gnu2bQL9mw==
X-Received: by 2002:a2e:6c0c:: with SMTP id h12mr3121100ljc.222.1573145543912;
        Thu, 07 Nov 2019 08:52:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z26sm1303573lfg.94.2019.11.07.08.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 08:52:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AAD061818B6; Thu,  7 Nov 2019 17:52:22 +0100 (CET)
Subject: [PATCH bpf-next 4/6] libbpf: Use pr_warn() when printing netlink
 errors
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 07 Nov 2019 17:52:22 +0100
Message-ID: <157314554255.693412.241635799002790913.stgit@toke.dk>
In-Reply-To: <157314553801.693412.15522462897300280861.stgit@toke.dk>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The netlink functions were using fprintf(stderr, ) directly to print out
error messages, instead of going through the usual logging macros. This
makes it impossible for the calling application to silence or redirect
those error messages. Fix this by switching to pr_warn() in nlattr.c and
netlink.c.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/netlink.c |    3 ++-
 tools/lib/bpf/nlattr.c  |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index ce3ec81b71c0..a261df9cb488 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -12,6 +12,7 @@
 
 #include "bpf.h"
 #include "libbpf.h"
+#include "libbpf_internal.h"
 #include "nlattr.h"
 
 #ifndef SOL_NETLINK
@@ -43,7 +44,7 @@ int libbpf_netlink_open(__u32 *nl_pid)
 
 	if (setsockopt(sock, SOL_NETLINK, NETLINK_EXT_ACK,
 		       &one, sizeof(one)) < 0) {
-		fprintf(stderr, "Netlink error reporting not supported\n");
+		pr_warn("Netlink error reporting not supported\n");
 	}
 
 	if (bind(sock, (struct sockaddr *)&sa, sizeof(sa)) < 0) {
diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 1e69c0c8d413..8db44bbfc66d 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -8,6 +8,7 @@
 
 #include <errno.h>
 #include "nlattr.h"
+#include "libbpf_internal.h"
 #include <linux/rtnetlink.h>
 #include <string.h>
 #include <stdio.h>
@@ -121,8 +122,8 @@ int libbpf_nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head,
 		}
 
 		if (tb[type])
-			fprintf(stderr, "Attribute of type %#x found multiple times in message, "
-				  "previous attribute is being ignored.\n", type);
+			pr_warn("Attribute of type %#x found multiple times in message, "
+				"previous attribute is being ignored.\n", type);
 
 		tb[type] = nla;
 	}
@@ -181,15 +182,14 @@ int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh)
 
 	if (libbpf_nla_parse(tb, NLMSGERR_ATTR_MAX, attr, alen,
 			     extack_policy) != 0) {
-		fprintf(stderr,
-			"Failed to parse extended error attributes\n");
+		pr_warn("Failed to parse extended error attributes\n");
 		return 0;
 	}
 
 	if (tb[NLMSGERR_ATTR_MSG])
 		errmsg = (char *) libbpf_nla_data(tb[NLMSGERR_ATTR_MSG]);
 
-	fprintf(stderr, "Kernel error message: %s\n", errmsg);
+	pr_warn("Kernel error message: %s\n", errmsg);
 
 	return 0;
 }

