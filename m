Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8F2A7BC9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgKEK3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgKEK3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:29:16 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BC3C0613CF;
        Thu,  5 Nov 2020 02:29:16 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x23so575613plr.6;
        Thu, 05 Nov 2020 02:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjXiaJJaFcfh/d5Hg7T1ivvJjPLwr7C0xxhr2qpyt5M=;
        b=tu5KQKGOfAq/+kzkyjpohI6vnL31DNuBznHjUzGnMNP9aE7+Fz5h89Wm9deISFwNmW
         0D8990Sm3DsMfVLQ/90XbHJ/q5KAseae61Po/AYZTSYRu0ECZ2bGiVpfD6Hyjq5q1ITX
         bZMTf55h5Pq4LyicjWB6UutcnkCYO/4DOEEApsnnuPqayyepNlUUN3r4bE+fLwFn71Dg
         8Br+7dQ7pHZAYJdEDPAkTfSPpanONzyD17HugJseS5cWvNp35+uHRL7v7UDZzb7s0u1W
         zchoTyQar8q+rs+wKq9Ai/EX8X5+BpI/lh/ywxJMTZRJO51TfG5FjsqSE20JpxX0OoRO
         wmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjXiaJJaFcfh/d5Hg7T1ivvJjPLwr7C0xxhr2qpyt5M=;
        b=dwqK72BdhHXyFRPTws4PkNWWP9VVgNFzkodyXbme1269k2AckOvDsyMjQqXrw0FHm1
         WbYudCL57vczC/h4WRXje/fr8lCt7TXR3sntJyoVLOM5UxHHUcyOLCPrNcDlV9IDGGk1
         le4gDTw0L5RicA29NQatG8gIdIH27MIGvCWX7by3Wy5d1zG/vk+HEg2mLxsW/DazUFJ8
         87g3Wh0MFTIzXWIMt22h37KVUerOT2/t1f881nm7CDmbIzf+KIIp98AvKt24e9AE6Gz1
         iGms3VovImkcBCfCtClY9xl4PwKaj/Yz+lmhAcl9qHgqSOCFMgwyEn/KR55LnKO1Ngq/
         b3Dw==
X-Gm-Message-State: AOAM530vCq04yxLucmsGr5gYQ8KgoYnTl7eAkFu8SGfGP8d/BhWjbnZj
        nyJsDk3zzfWn+anJRv7Gqb2ESWldk+Gr5Nup
X-Google-Smtp-Source: ABdhPJweiqei02sQwGEWSXAXmvB96TXhjMxBPCROkBjzNNCRYD4bKAXypJqKLCTZ4N18nVmQLVEemQ==
X-Received: by 2002:a17:902:6f10:b029:d6:e6f5:1dab with SMTP id w16-20020a1709026f10b02900d6e6f51dabmr1762705plk.1.1604572155623;
        Thu, 05 Nov 2020 02:29:15 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 192sm2050117pfz.200.2020.11.05.02.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:29:14 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next v2 7/9] samples/bpf: use recvfrom() in xdpsock
Date:   Thu,  5 Nov 2020 11:28:10 +0100
Message-Id: <20201105102812.152836-8-bjorn.topel@gmail.com>
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

Start using recvfrom() the rxdrop scenario.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 1149e94ca32f..96d0b6482ac4 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1172,7 +1172,7 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk,
 	}
 }
 
-static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
+static void rx_drop(struct xsk_socket_info *xsk)
 {
 	unsigned int rcvd, i;
 	u32 idx_rx = 0, idx_fq = 0;
@@ -1182,7 +1182,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		return;
 	}
@@ -1193,7 +1193,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 			exit_with_error(-ret);
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.fill_fail_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	}
@@ -1235,7 +1235,7 @@ static void rx_drop_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			rx_drop(xsks[i], fds);
+			rx_drop(xsks[i]);
 
 		if (benchmark_done)
 			break;
-- 
2.27.0

