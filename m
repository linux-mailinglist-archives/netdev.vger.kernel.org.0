Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E487D2DDE97
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 07:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732834AbgLRG0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 01:26:17 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:38584 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726045AbgLRG0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 01:26:16 -0500
X-Greylist: delayed 733 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2020 01:26:12 EST
HMM_SOURCE_IP: 172.18.0.48:52417.348475854
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9?logid-e7086065973b44398e970b1017e4f109 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 319702800CF;
        Fri, 18 Dec 2020 14:11:53 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.48])
        by App0024 with ESMTP id e7086065973b44398e970b1017e4f109 for netdev@vger.kernel.org;
        Fri Dec 18 14:12:02 2020
X-Transaction-ID: e7086065973b44398e970b1017e4f109
X-filter-score:  filter<0>
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   lyl <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, qitiepeng@chinatelecom.cn,
        liyonglong@chinatelecom.cn
Subject: [PATCH] tcp: remove obsolete paramter sysctl_tcp_low_latency
Date:   Fri, 18 Dec 2020 14:11:16 +0800
Message-Id: <1608271876-120934-1-git-send-email-liyonglong@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove tcp_low_latency, since it is not functional After commit
e7942d0633c4 (tcp: remove prequeue support)

Signed-off-by: lyl <liyonglong@chinatelecom.cn>
---
 net/ipv4/sysctl_net_ipv4.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 3e5f4f2..d03e4c0 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -51,9 +51,6 @@
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 
-/* obsolete */
-static int sysctl_tcp_low_latency __read_mostly;
-
 /* Update system visible IP port range */
 static void set_local_port_range(struct net *net, int range[2])
 {
@@ -501,13 +498,6 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
-	{
-		.procname	= "tcp_low_latency",
-		.data		= &sysctl_tcp_low_latency,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
 #ifdef CONFIG_NETLABEL
 	{
 		.procname	= "cipso_cache_enable",
-- 
1.8.3.1

