Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FCF3665D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfFEVJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:09:20 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54365 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFEVJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:09:19 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mzyi6-1gfIjz2ufO-00x3RO; Wed, 05 Jun 2019 23:09:09 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] net: ipv4: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 23:09:05 +0200
Message-Id: <1559768945-19902-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:FI0Z/aONPpinWMUlRZog2OlNbE+caT1p0Vy5HyyhH4m5TaVKl4/
 GGy693hIOJSLfHoeDPPSNZjcETKbNVMXBDgBFrMg4q0AoN6oIJRMpk8bLfwBcO0byjl/b17
 kpcPOyEODLBJQU6SJ5Yxgz6NhVhpy7kXaOYrVwE2YYrE/fyRLrGf5/ilUoQMnBQObZ8Y+S1
 cFYhg1n9kAqo/vaUupEVg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MECoi/W3gPo=:XP6XmOoCC2ibIBGSr2f35U
 ua5cQ+YdkyTKaJGIuyUcTubx5XOAU71/nDWKx57Kn+NQ3q2PYORMK0iTL7f1BpOZviJ6Jps+m
 IsFDCaG2XuNjPKV7LOkbcvEkIPUylYCyTrBpmqSwxJ4GO4XTD2UVFmnn6l/RPn0AwtIqg0VWk
 XOWsvMJ3gA9vm6fyS73IxkvK3Moqlc6ostE0Jay0o3UX7MisGfVwXIy23Ur+ZEqpZbmhfmRh9
 qlKSaA35+KFqQOPc/NVfRD4pOgGZQj+UnnoPNjxvsRbFXPbTfrl35GMagacGpBO57vBYZJ2z3
 /VWqA9VOt5SR8kIOL5DCxYOjfjI7EtMfjYjO/9nxp5taRZuGsoQPQrrv3LsWnbvXkBStiCNaG
 VHsvnkmSSxu0sNcqSxx8tLY4LAX/3WUlpupE5+cX9PdfB++aNwB7ekgP3aOkEzMEMu7BulJZR
 3RG+0toh2WK/M//2GJAxIJGeJtqeA39PsoBM+m05u+9BPf7jZe1sWdFeH+et66EsLFNS8iOFF
 orxfIGzicl2gto8aeGwywQEYNevh5lrELUpyv9tyV5kqxwrKvMZ2Gf5/V2T4L1FjfPgs6xrZs
 i49iDMI+Mv1z/QjOCzuYyE3J0TBKOFxBl/d3UV47vCmXXcECv02iXlrzywMze3lNHW6rbNM5x
 Zt8OdIpMgf1qwE1UdILfE/soSeHdoGK0ybPL4+YTTDuCRJk3zOXs5mK+1Sbhym8nJjnnSpTor
 n8XMPIavyV8KQhqYc1HyDwQrU2AAE19+HD1iRA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra unlikely() call
around IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/ipv4/fib_semantics.c   | 2 +-
 net/ipv4/inet_hashtables.c | 2 +-
 net/ipv4/udp.c             | 2 +-
 net/ipv4/udp_offload.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b804106..cd35bd0 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1295,7 +1295,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		goto failure;
 	fi->fib_metrics = ip_fib_metrics_init(fi->fib_net, cfg->fc_mx,
 					      cfg->fc_mx_len, extack);
-	if (unlikely(IS_ERR(fi->fib_metrics))) {
+	if (IS_ERR(fi->fib_metrics)) {
 		err = PTR_ERR(fi->fib_metrics);
 		kfree(fi);
 		return ERR_PTR(err);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c450307..9782486 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -316,7 +316,7 @@ struct sock *__inet_lookup_listener(struct net *net,
 				    saddr, sport, htonl(INADDR_ANY), hnum,
 				    dif, sdif);
 done:
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1891443..8983afe 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -478,7 +478,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 					  htonl(INADDR_ANY), hnum, dif, sdif,
 					  exact_dif, hslot2, skb);
 	}
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 06b3e2c..0112f64 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -208,7 +208,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		gso_skb->destructor = NULL;
 
 	segs = skb_segment(gso_skb, features);
-	if (unlikely(IS_ERR_OR_NULL(segs))) {
+	if (IS_ERR_OR_NULL(segs)) {
 		if (copy_dtor)
 			gso_skb->destructor = sock_wfree;
 		return segs;
-- 
1.9.1

