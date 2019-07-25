Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC93752B5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389175AbfGYPd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:33:58 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:35508 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389125AbfGYPd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:33:57 -0400
Received: by mail-vs1-f73.google.com with SMTP id 66so8130354vsp.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kCJBSP0++BkIRS8UIK5zEBUXqgfh3zWN44O45srvAnM=;
        b=CK/FKzbKEB2RwBpklhJ+q5UQoPNaAcNGGdaQLi/8ofpGngIegXpN+zfxmR7EGyUl+o
         IylfjIn9Lo6G8oL+QGh6CRZSnYv29EjQTVUqyE9xP2bQB/t1If/hbM9R7P787CVaXRQo
         QNYjsQqmu3fnIlQYRTkPs0Ns54pzcQJS7nd/UUYbOuSQ3Pq9868mONdpdzCFLELxyzz7
         UNCqRExP36scQGHqDcSubm8GIa/C3eaHwsFN9zfr7zHMTc9Z2E/ugFP2evRdWviChOwV
         mblWdqnbT2rd4GBCANqZ+MtmIkjUWtatwlxZOr8mQqj2792ywe1UMdHMzzLFTSTso0m7
         Tl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kCJBSP0++BkIRS8UIK5zEBUXqgfh3zWN44O45srvAnM=;
        b=c5xHuzrbtfyp9MRU3Ta2H67jT3aNyxohiY2XYVNyaPKbtQ4aNa2Iz8zK1pqZHLDLUv
         ZjIfOI20XMLvLQzxuKz0CLMymWHzi236+uHsov24L0/zjXehLGX5vPfn0bvA4EqYjxOt
         hUS+GWRmkhDNvEuNJwoyl3yg9dtF0sT1596qQKpGi2kObiyGf0J6XyPdzeA3fYfyxhYj
         kebLrEYOnCa7E2DLzRLyTgrvKLHecLV5U4/n1+7vXPIB7yy6RJG7pblged8hGb6Yn6LL
         zhSI++h4BQ7s9Ypq6iWcW/aTrWJ50GZgguukE4Xk7reR/QT7msYrhyaUf+tY4fNt+hxw
         xbuw==
X-Gm-Message-State: APjAAAUZXX/DYWeKtTLQd6UC9HSaWMtNjMa7UQ7ZAVIZV5YnmGvCBAb0
        3yv8SHXNgl1ELUJzBjXgU5jX4Jeyn5N+mUecO43jGr3xTQsKzGqUwAfGWz66l45fcI7jbTxVH2v
        pDSIuhCpeWl1fKSbi9+GsB2/G6ntpRAas7TjOUNiE6d18lspxpQfcUw==
X-Google-Smtp-Source: APXvYqxlbDRaSWg3h0K0/giWqpcn+ZyJSvC7FKVVpDCzicE/ysjWyJw0c1Mx0Vutk7NKt2sQJ2xQ3/I=
X-Received: by 2002:ab0:18a6:: with SMTP id t38mr22503847uag.83.1564068836333;
 Thu, 25 Jul 2019 08:33:56 -0700 (PDT)
Date:   Thu, 25 Jul 2019 08:33:39 -0700
In-Reply-To: <20190725153342.3571-1-sdf@google.com>
Message-Id: <20190725153342.3571-5-sdf@google.com>
Mime-Version: 1.0
References: <20190725153342.3571-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next v2 4/7] tools/bpf: sync bpf_flow_keys flags
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export bpf_flow_keys flags to tools/libbpf/selftests.

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
index 4e455018da65..a0e1c891b56f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3504,6 +3504,10 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
+#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
+#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	(1U << 1)
+#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
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
2.22.0.657.g960e92d24f-goog

