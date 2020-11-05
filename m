Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC0D2A7BC4
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgKEK3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKEK3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:29:04 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0E3C0613CF;
        Thu,  5 Nov 2020 02:29:04 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 10so1144260pfp.5;
        Thu, 05 Nov 2020 02:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBa77MmCFN0T1+VtUx1HDnNMT2/Xv5NhXqq896ClIPA=;
        b=FHg4fGeatDUqCffVP36y1CuuIEMORtXfpf9gxR4uh7SMFpFDy/2ix1LRwXRkjE0bBo
         DvpfGmAkZTLPobKe75fLiw1yTAzM8e+Ns1+TfGZNWiZ6ENQ9Nme/uNmjDA7RXBxPB5xe
         TbykhLAeoGjZ2SmRNlfgWIRRLiRt7U1PhpH3a47s0ECBLHJKgXzCg+4u/kB3dg1A4pdn
         nV9nTvjX+ex7fYUGsXYQ9pQEUC+g65ryt8F0cb1iJao4gVf1PpZtLfxny1WlDoD48WdX
         jndxBLDCzprkgSny6Rp/DUXWfKpzqqMe5utrRs2eeYRgW8JlTYzcTPezkVliF8Ff/JpN
         PfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBa77MmCFN0T1+VtUx1HDnNMT2/Xv5NhXqq896ClIPA=;
        b=Vqkoe7vVHT+Jabw4bMZfHRU5nz8WBBFIpbr+0IIPWKs/JNXbhuDlubFuWP9BykPhAR
         9Sp3pWTlT9JF7jICKMO3hAjoU7cNpAjy2Bl7SJaFuE2pysWCkQ4wt8pLCW5edAntIVbY
         rxuTM+gnUM9zD+a5O/ANRHxKjuU2gvQLSQTFlsSDPLEaJTbYdjZ/2JCTQxf3juc0xRR3
         5x2RpIwjc5LgJ8G/uoEE8ZJp/wmIdv0cV/UKgl6dgBhGeWhmwkhgyfjkm/wuJwhY9NB8
         63TS/gE5Um2TR4yqlmmA443Pir8RgxWJUjdOHP5kzfPEagvh12VMB5GLrJG54eQ+E5vS
         27LQ==
X-Gm-Message-State: AOAM533V+uaWF4ZSrx+k3UREvvvayR/8Zg+KYmfYnrfbIlhaFuVVvwfi
        pvhlFY30AcObk6VIcdcf2PUJ2my96SdSCrdI
X-Google-Smtp-Source: ABdhPJwDC8auIg61mIgZESl4abBUHxxmScdtxOTlhH3feYBhtCObnRv1/YdpIB2hW4nAn7lN7EIcxg==
X-Received: by 2002:a63:da47:: with SMTP id l7mr1771055pgj.417.1604572143367;
        Thu, 05 Nov 2020 02:29:03 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 192sm2050117pfz.200.2020.11.05.02.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:29:02 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next v2 5/9] xsk: add busy-poll support for {recv,send}msg()
Date:   Thu,  5 Nov 2020 11:28:08 +0100
Message-Id: <20201105102812.152836-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201105102812.152836-1-bjorn.topel@gmail.com>
References: <20201105102812.152836-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Wire-up XDP socket busy-poll support for recvmsg() and sendmsg().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2e5b9f27c7a3..da649b4f377c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
+#include <net/busy_poll.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
@@ -472,6 +473,9 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
 	pool = xs->pool;
 	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
 		return __xsk_sendmsg(sk);
@@ -493,6 +497,9 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
 	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
 		return xsk_wakeup(xs, XDP_WAKEUP_RX);
 	return 0;
-- 
2.27.0

