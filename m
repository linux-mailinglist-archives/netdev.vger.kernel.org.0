Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6473436A91
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhJUSdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:33:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10314 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUSdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 14:33:36 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LHu7Jo003115;
        Thu, 21 Oct 2021 18:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=76O3TeBsCQbL3rrFYVZyyjfapl/D7428uZBRM6bqrmg=;
 b=G5e9awyafNbetQkHNgkqQ+sH9zo08Fhu+6YKK/NeMhY3je60dkDosYMSMYLXYWm4L3lv
 4c6V4M3z/8PTYH4HiNTWBk7Jb+HOoBkc//FToSGlzOZPKAYMrT9IAaRA7vQzmy4v33dg
 a3QRwGnuPev+v4yaLNqD9lrCzfzpWZ+EQXq+VcO4XvPbosK2G+ZHb/+Z1V8Ozz1eR6Pa
 tnOxD9+WoPWP58KhUmt7xRHO1oXzvuC16YP/jqTs13YPZiocZ/JYQZYv3EY87LSicpmv
 a7PR7AXk7al5FQ9s6dCZgsR5YWIuDz4nrineRoMGl+D21FcULSBJ+K/Sd1FqQjdpbIny ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw501xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 18:31:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LIFgjv192001;
        Thu, 21 Oct 2021 18:30:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by userp3020.oracle.com with ESMTP id 3br8gwh9r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 18:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkBGaLqrSJddsOTZ9m4VPD0uG1Fjql/WXMRgor1/jk17HVeugR/9zmXfP16xlP5oP4ZBzw0uyIbfRO37D4YpHETe61hPCOgYoQg8Xvyu3vJje45y5YYgXS6z3CTgRPylTH5/oApqOv/pmoX0bCos+wdF5/TjGwidQv203R3az4BRbPUM1Amh1tRZE+pU3tQIva4D5VXnn8iD0SUaGSa+i4IaKSv1XlnyHmKWH4lRBIs/3DHAZ0Nf7AykHsKC5sWzIsZggzylgi29MZ4ktgeBhGFyPx5goJM6yf+EzJxO54Wf8brxVOM6xEei47O/b3zgotbwN/UuOKleJRkSpqaAlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76O3TeBsCQbL3rrFYVZyyjfapl/D7428uZBRM6bqrmg=;
 b=FJub+tGBbA9UmRYtGFtAU9k1L0M7nZsaLdhFhDyK58Z+GGvC6sR2h6OSJvKQ9KWV5bogYrVGmZFq7RMUnGaI/hqaEibgVlfhdOlOhnlgyKHcGl5nJMlprbViSITzGvI0x0O0w+cM3d/7i7O35b4toBDFjlMlH1YfDxdjXNORaWLpuPBG/EuvOe0g0gk/+UonjPKKRuFo8Ojzt/RIClj1miGD7JmawdgvuW9d2c+si4K+j/zwUPh9Dtmi9j6+EQfSV/iGV1UrdL4CZkyVmIq9b0yQRdX8/VkggE4LV4eMUuCTxZAIwB+qW1DhGdA87TUCYeXfWhGl8YZlBTb1pFbZ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76O3TeBsCQbL3rrFYVZyyjfapl/D7428uZBRM6bqrmg=;
 b=f9ZOAk59w2FiDLOyhcyyO86cdKLMgVTAtt4fysK8wkiJzJCtx/p4Rj3U/vesBvltUCdaOlaPkpJaEB3ogyHJO/pY2NWdxhYOBQEtphu3utMTkW6L7muWGBsos1kDLITe6SE46zGFh2v4vKlmRtquzjOTlEy8g5/erb+j9in7na0=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Thu, 21 Oct
 2021 18:30:56 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03%6]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 18:30:56 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Vakul Garg <vakul.garg@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] net/tls: Fix flipped sign in tls_err_abort() calls
Date:   Thu, 21 Oct 2021 14:30:43 -0400
Message-Id: <20211021183043.837139-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0079.namprd02.prod.outlook.com
 (2603:10b6:208:51::20) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from localhost.localdomain (98.229.125.203) by BL0PR02CA0079.namprd02.prod.outlook.com (2603:10b6:208:51::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Thu, 21 Oct 2021 18:30:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d4833b5-f878-4f9f-ee19-08d994c0ebfb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3270:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3270CF634378D83C80EBCD25D9BF9@BYAPR10MB3270.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ea8oA4EC1eM8oChK1pVCI7GJFo1aBYVo3WQZdP91DuX7PZczx7NXSIPQLrvw4nGN9+Bpkyi02cgmg73iqIZHlH8tX71zHfAWfFb/9CWpR7+PIHKjFTfwPlp9SPi7ijzFDxEArfRMEMhoQ7iDeoP26rH1YVYbCGqEtCQPm6yZO3UwsmEaQZdtsV2RV4ZoCxq9WFAQ69BKuySTbzSp9g/GOJPyIx+KhVFlxKT0uiq51UrChTXZEQ+jqqW8rC6E/O0jMlk7wXwg9nMMXH6e7p6vLoVakempoxoGwE3PEgPSSo7mQXtO/sH88tHMZNnZ6To7+VquWJ+phzFYxTJ2GICPrR8H2Z5DGJ01My5ISiDJaI+8HJWUrYtL++Y/u2K7Jm/GdJ7NPXogOLuaoXdp6guguhK8Rrwvjbn0FGVns7Udij66T+POUGXaaHfUFzGpX2M9GBEJbJ6eyJ3f87YwZB0J9eYooVz0wu44O57jOmJjRYSFHf/dn4G35JaTaOf1Jbfu/QhU2zvEfQxD/vOGRsvIzR65nGARmkzF/FdG8woAANY/lHhNwo7XExAUvt7GpIUZL9qFkOVcE4A6dEC/AFtuvZ81vfF/h37BM+5iHwrg9vckqQPQWuNy3TUc/PQuPmxFocbLqEy2q0cMNrvkQzdXpFYGWDpRp224vjRZQI+MbbWDRsMRLbn8eL0+jHwLsKSmYxFdcvo40bJCglmtUnJFvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(956004)(6512007)(6486002)(38350700002)(8936002)(2616005)(103116003)(36756003)(8676002)(38100700002)(52116002)(26005)(6506007)(1076003)(83380400001)(107886003)(86362001)(2906002)(110136005)(508600001)(66946007)(316002)(66556008)(186003)(4326008)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Wx6lsA8rnGSXoL4ueBXPkD6cgNaqHkPqEF/EDK7Ts65yTCVEgPpSzTlpQYk?=
 =?us-ascii?Q?o6DdD0Bjv1M5fHHbkfLRjamYzaiOs+P7a9+schFQe4KBQZ4wBzyYSjZK6tdh?=
 =?us-ascii?Q?GOtK7k4cg5uVGoNGaa2bZlMXMmRSkBo5HxNy/cETnTfYyL7EW+oQ3QxHQdLx?=
 =?us-ascii?Q?Wt5A2xFsd+JvfrRwl5iY/ZDDj2i0jRZDXCXeoioF+HnLBozH2incP4AI209P?=
 =?us-ascii?Q?iz/ibzH+0/DfSjeKYsX53vaGKDfL3hyTbU2YSBbrsqwf6kNlPIKwQMSCsrTu?=
 =?us-ascii?Q?IJC+wBTwVR55ebvIFQ3Lhyeczp6IRTEpkhjIhJvJOWCp6uTh/KZjGNeKicTQ?=
 =?us-ascii?Q?xA3yR+hD+w909hYD5QOBwfMruytm4bU89e7G1G01pPmBzI9mfB/bJrE+mK6r?=
 =?us-ascii?Q?QkVEZHcbN0Ap72Du+HPIbKG1vFCoa8D2RFPph+9dN6yj8fZphdYedF8KE2dR?=
 =?us-ascii?Q?jo+7QrNuXL3VQcKrFEP6uFi0gZEG1WzruVT2b1ZPp81t1c/X33GR2LwRbz/V?=
 =?us-ascii?Q?pPakHA+FBXvwHAJGBeIVeemPqPAwFI/uorGxDZxQyTTIbWgc8YJ80vd39aGz?=
 =?us-ascii?Q?b25KeycnGCvF+bTzEkIIWAlW6CViphJQugrsV8EqUTkHHcanvcyly9v2dOsY?=
 =?us-ascii?Q?67H7uk14jqsE/pzfIU0r+QooXjAeSPsr4gSJ0x2k8uzDOyfgI+jxz49Rx0lp?=
 =?us-ascii?Q?anhbivwUZ45LqaVNKwCFhQrMl9bpkH0tDpR5PVHQaWrtp3+OkRQtxQqE+I8Y?=
 =?us-ascii?Q?6Tdr6FnVu56iGPe+3HQz7VP1peCsnPA20KEP4OLuQUx3q34JB8fOe2g/8w7K?=
 =?us-ascii?Q?vFhS9uaIDPLAm4vaCr6PA1UnksSeMtWoesRFpcFPH/BjDfEo6A9R/3TKwBlJ?=
 =?us-ascii?Q?fGH85MiZd3gZ0rePlJe+owMu13cR0xsU39MbDk5o2xlF8JX8JPuDxRn8Tnja?=
 =?us-ascii?Q?wcA1p35qYM2vwE0d8V/XPfUiyjkaurrlOhuWbS1cocWl+HGaJT3xN3Zlt5bY?=
 =?us-ascii?Q?VMEHkyuSugbiuDWlAB7ysp3+eeEMTQCLa8xzdepPPCgg9jWRoD+FUyBic7LH?=
 =?us-ascii?Q?4hp/B+sync7bWnK9wqHECuPjQLFGmmzWmjzhqpMt2o2Yv8tv8pbDwk09WS4n?=
 =?us-ascii?Q?TfbRD6WOPRGrPY/JLWNij+K9MisNajJt9pZP55STJ6L4160nuiPmcRpJDJv9?=
 =?us-ascii?Q?SlqmvWpoJytUMX4toyENGQ+/+1AJtgmYPCsUcQhAv36JiHyI/LwQHui+SzbN?=
 =?us-ascii?Q?looYWPjVUmf5hVhtVSYcT6bs1OqbY8cD1NF8bF6WkXXfN9dCgv5bAexef/6c?=
 =?us-ascii?Q?NnVvwewwgMrOuFOIiekGBwmq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4833b5-f878-4f9f-ee19-08d994c0ebfb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 18:30:56.4583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daniel.m.jordan@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3270
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210092
X-Proofpoint-GUID: yt-dRxa_pW4psLl4_QrAk74B7rNuy5oW
X-Proofpoint-ORIG-GUID: yt-dRxa_pW4psLl4_QrAk74B7rNuy5oW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_err appears to expect a positive value, a convention that ktls
doesn't always follow and that leads to memory corruption in other code.
For instance,

    [task1]
    tls_encrypt_done(..., err=<negative error from crypto request>)
      tls_err_abort(.., err)
        sk->sk_err = err;

    [task2]
    splice_from_pipe_feed
      ...
        tls_sw_do_sendpage
          if (sk->sk_err) {
            ret = -sk->sk_err;  // ret is positive

    splice_from_pipe_feed (continued)
      ret = actor(...)  // ret is still positive and interpreted as bytes
                        // written, resulting in underflow of buf->len and
                        // sd->len, leading to huge buf->offset and bogus
                        // addresses computed in later calls to actor()

Fix all tls_err_abort() callers to pass a negative error code
consistently and centralize the error-prone sign flip there, throwing in
a warning to catch future misuse.

Cc: stable@vger.kernel.org
Fixes: c46234ebb4d1e ("tls: RX path for ktls")
Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

I could be wrong about sk->sk_err expecting a positive value, but at
least the sign of the error code is inconsistent.  Open to suggestions.

 include/net/tls.h | 7 +++++--
 net/tls/tls_sw.c  | 8 ++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index be4b3e1cac46..206505df2f1c 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -36,6 +36,7 @@
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
+#include <linux/bug.h>
 #include <linux/crypto.h>
 #include <linux/socket.h>
 #include <linux/tcp.h>
@@ -468,7 +469,9 @@ static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 
 static inline void tls_err_abort(struct sock *sk, int err)
 {
-	sk->sk_err = err;
+	WARN_ON_ONCE(err >= 0);
+	/* sk->sk_err should contain a positive error code. */
+	sk->sk_err = -err;
 	sk_error_report(sk);
 }
 
@@ -512,7 +515,7 @@ static inline void tls_advance_record_sn(struct sock *sk,
 					 struct cipher_context *ctx)
 {
 	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	if (prot->version != TLS_1_3_VERSION &&
 	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 4feb95e34b64..9705262749e6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -419,7 +419,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	return rc;
 }
@@ -763,7 +763,7 @@ static int tls_push_record(struct sock *sk, int flags,
 			       msg_pl->sg.size + prot->tail_size, i);
 	if (rc < 0) {
 		if (rc != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			if (split) {
 				tls_ctx->pending_open_record_frags = true;
 				tls_merge_open_record(sk, rec, tmp, orig_end);
@@ -1827,7 +1827,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
 					 &chunk, &zc, async_capable);
 		if (err < 0 && err != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
 		}
 
@@ -2007,7 +2007,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		}
 
 		if (err < 0) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
 		ctx->decrypted = 1;
-- 
2.27.0

