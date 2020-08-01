Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4110B235434
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 21:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHATqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 15:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgHATqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 15:46:24 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BCCC06174A;
        Sat,  1 Aug 2020 12:46:23 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ed14so15704056qvb.2;
        Sat, 01 Aug 2020 12:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujYsQMCZbecD6bJOJC4Hkc6cL1ixRi2Hw1s2+qYZ8Ac=;
        b=HIEyUOLPHv84IyjfJfi3d8BatiT6NbFRFo4ij+cTD9CJeCkKTEmiTauwNMEbVi8j5H
         WUZk8m1BLwfiRWVb/wKvdceJhb+sY6NCjWQVGC56HCCpLqP8zDWFjm4kNyQhRqidxJK/
         GrbwW9CqiPTw3gwxE4WQTnfvh5FV2F6v/RG3ky/Ehr3oRjhInC6MwSGDAT8Tu7+ySwQB
         7TPBs+ODPpzT1BgGkvhTYQNjj3SRHZGocz9wc2pyerSBVQd9LsATV+T2rl2ZZV8DS4t6
         Ad5bWemDX+rR3mc/tjNrx1Skb3x52oGEei/Dj7QD3NQ8w8GxHtqhJ8E/YQtdDX0rIWBJ
         OVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujYsQMCZbecD6bJOJC4Hkc6cL1ixRi2Hw1s2+qYZ8Ac=;
        b=HpN+mWIJyZcxs6qyrW+HwJ9rhkc9BcZVwqNgSfWyEx+ioDe847+yQmxiYU6RhChNWg
         /bzb1aCgCOsUagDWLq18jr+QFOFnmxacevECEOb7sxXECe4JCNpqImQS6df1mLCHIQ3R
         vsY4WDjRL7ZPJ8EyAjSXY4qr7zYQ1Cx0u8l2ppd1Q9gQxqJcrtiEn3Kk0+b/wfzgbapJ
         +4fbDH8v6bsnD8LquXC2Ji9bqaoNSNTN5kBQVfg4evroAEdDDVArZQ8KzaNaGwmxj1M6
         G66r6pJtmHf0nxopRmp1ltKMABFdUc+ZDPpGJda5F+nQ3eK1AwMWdkhASQSxaI8ruO1k
         hUpQ==
X-Gm-Message-State: AOAM532wEaNNawhoa2A4TSyHHpERAxlIpPYL+SJBYoSEqQOTxqoSpMNa
        SgI6hn2GuhmmGKbIKEdbxg==
X-Google-Smtp-Source: ABdhPJzDVgh81xMg4udcLC8TIzADu8oMa6/Aiz82VsTpmlIIxc01ZpgOmmLKGcMXX1gdukgbZPM0XA==
X-Received: by 2002:a0c:d7c9:: with SMTP id g9mr10286039qvj.83.1596311183058;
        Sat, 01 Aug 2020 12:46:23 -0700 (PDT)
Received: from localhost.localdomain (146-115-88-66.s3894.c3-0.sbo-ubr1.sbo.ma.cable.rcncustomer.com. [146.115.88.66])
        by smtp.gmail.com with ESMTPSA id q17sm7791343qte.61.2020.08.01.12.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 12:46:22 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Hans Wippel <hwippel@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] net/smc: Prevent kernel-infoleak in __smc_diag_dump()
Date:   Sat,  1 Aug 2020 15:44:40 -0400
Message-Id: <20200801194440.246747-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__smc_diag_dump() is potentially copying uninitialized kernel stack memory
into socket buffers, since the compiler may leave a 4-byte hole near the
beginning of `struct smcd_diag_dmbinfo`. Fix it by initializing `dinfo`
with memset().

Cc: stable@vger.kernel.org
Fixes: 4b1b7d3b30a6 ("net/smc: add SMC-D diag support")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Reference: https://lwn.net/Articles/417989/

$ pahole -C "smcd_diag_dmbinfo" net/smc/smc_diag.o
struct smcd_diag_dmbinfo {
	__u32                      linkid;               /*     0     4 */

	/* XXX 4 bytes hole, try to pack */

	__u64                      peer_gid __attribute__((__aligned__(8))); /*     8     8 */
	__u64                      my_gid __attribute__((__aligned__(8))); /*    16     8 */
	__u64                      token __attribute__((__aligned__(8))); /*    24     8 */
	__u64                      peer_token __attribute__((__aligned__(8))); /*    32     8 */

	/* size: 40, cachelines: 1, members: 5 */
	/* sum members: 36, holes: 1, sum holes: 4 */
	/* forced alignments: 4, forced holes: 1, sum forced holes: 4 */
	/* last cacheline: 40 bytes */
} __attribute__((__aligned__(8)));
$ _

 net/smc/smc_diag.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index e1f64f4ba236..da9ba6d1679b 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -170,13 +170,15 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	    (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) &&
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_connection *conn = &smc->conn;
-		struct smcd_diag_dmbinfo dinfo = {
-			.linkid = *((u32 *)conn->lgr->id),
-			.peer_gid = conn->lgr->peer_gid,
-			.my_gid = conn->lgr->smcd->local_gid,
-			.token = conn->rmb_desc->token,
-			.peer_token = conn->peer_token
-		};
+		struct smcd_diag_dmbinfo dinfo;
+
+		memset(&dinfo, 0, sizeof(dinfo));
+
+		dinfo.linkid = *((u32 *)conn->lgr->id);
+		dinfo.peer_gid = conn->lgr->peer_gid;
+		dinfo.my_gid = conn->lgr->smcd->local_gid;
+		dinfo.token = conn->rmb_desc->token;
+		dinfo.peer_token = conn->peer_token;
 
 		if (nla_put(skb, SMC_DIAG_DMBINFO, sizeof(dinfo), &dinfo) < 0)
 			goto errout;
-- 
2.25.1

