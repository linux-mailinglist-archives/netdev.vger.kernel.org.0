Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFC3EBBBE
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhHMR7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:59:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57536 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232099AbhHMR7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 13:59:00 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DHp3kH014214;
        Fri, 13 Aug 2021 17:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=JpnVS62znf4tFm678DES7TS+oKd94vvvYLcvWAi9w3EzsSbhg04UwmzX2jv7+IkbMFHK
 ifAmfO6Wk3ctNZIOPI3k3naPXdMAQS7ZRcUYAEttc67b/1IBsGXeTEnYnJc+Qu/85UPx
 R55ZzEI2N+tCpVWRYO6m8qWBcPRKyQwuS3J3JYADVDPefR0AP8ZeYdADpI2ZT6KruEEu
 HMnBbaYzuMRf0tKJlex1xkqqzwHMe6HMm9K0qdl28QQl+W+NcxbJLE4T2ier4Zdhai1t
 y5EJssYAhVN0u1S0+8bJuWN2gJyHzKXhgSInVxKgaybH4LVIihUxqhysaVp7krSGYYdw hQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=o/9sUTsje06DPdB+IIsPkC+Y8QEEtIx+Yebed68j1ClB6kpE8jgYjgMRJYtzPQ50UqHC
 1F1DEfPgtX9wY5+01HGIt65szQlMh+0e/SyiL5YMlc8ZjRWHuJoIQ9pQaEA9OSU8NMJJ
 wIB5/CqQijCY4GSmfRfUtVvnU8+yVCq5QEH0a5dJsK92d/bHJQ+MrSLpbKqQ1Dlgg8xC
 faISX9nHhkExg+wooqbUXjSU+RX3xm5gbFS2v/kDJZ9HWDVH4GTFCljFZw/mfYUGTDDB
 JWLs1EKmScmy+QQnt4X8qLGYRuh+fXG7bJsmD1KR1fZKcSLUglNKzwogeNbNqYqv5+/q Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p40q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:58:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DHoKuY022840;
        Fri, 13 Aug 2021 17:58:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by userp3030.oracle.com with ESMTP id 3abjwb35ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiePvwAWEibX7qJ4gkFKij6wa8nnm+Mc2y1OxV0hpQpBDlNQH4zwBK38B2HtLI3tw4ii8xM2Y/kk0RNhdNhPjWNCBhzMvaa5DJhI3SSINp6cM+TTP6k+VFxCDC3ZhGV3IfuecxvRAQ0dSH0wzjVY4RM+FPTdlnysDgYEcn9h8bRLdSr2LfggBpGt0NmX37iGny7D5nb1R4yZywQ2OehKvHT99HslqYGY9QvtZPcUcwztV+tcwzbWORNYze9aZEXLyBw8JRvkRTM4d6pYDNizIBM4AhW6dSktSBd/p3Q5BOSRAPZv3JWMqda4hRijfjpqR90T7j7wYFXF8EFApq7q0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=oKsT16papWOw5i2FkPf/9zuVNGUU6fXqbWYAr6Q/apilKXX14kBk4LMuXLYwvY8zRK4IGlT75h8+qo5MgYsPM+khWFEQXoWbkamIEQvr9UYlRqsogXkr8Z+c+3QKEp6yzQi+7urwo0MZCXtGOztCAo1VkyZnwSHpTSRgkpTEilU+DcIYk/Kn4IFFRBHMWSZd/P5XEhH8Ppp1rDiauNrz9WnnCuXVB2j+arapoNFNAcdkaXoXcTCgAOEMp+WrYT2UrFxgV4WUjJ5CPrMSYSpPVmKDOrrBd9Jo8dCjQ53VWgmaska2cz0x5kwzDUZHFZJ8yU0MvLsHNH1Ar9YNNjhygA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=YkCCaCeWxzVS0CmLaEckraqGNb7NatPUDkq9LBBGt+WHtd4EgCVWYUHI84u0JfHKKPgqX2SC+8ZcgRA9oi3ttByyl3OM8bExmUfvuMRDeQ7jdoI9+4EViXPBuN5eW/W69/G0t0o3BZ9gcQSXqwqV9oWfI+WQOartAxFu/EB+T0A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4655.namprd10.prod.outlook.com (2603:10b6:a03:2df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Fri, 13 Aug
 2021 17:58:24 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.020; Fri, 13 Aug 2021
 17:58:24 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, rao.shoaib@oracle.com,
        viro@zeniv.linux.org.uk, edumazet@google.com
Subject: [PATCH v2 1/1] af_unix: fix holding spinlock in oob handling
Date:   Fri, 13 Aug 2021 10:58:16 -0700
Message-Id: <20210813175816.647225-2-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210813175816.647225-1-Rao.Shoaib@oracle.com>
References: <20210813175816.647225-1-Rao.Shoaib@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0151.namprd04.prod.outlook.com
 (2603:10b6:806:125::6) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SN7PR04CA0151.namprd04.prod.outlook.com (2603:10b6:806:125::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Fri, 13 Aug 2021 17:58:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ce3dcd6-3fb3-470b-bbb7-08d95e83f238
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB465539F69B654410E70E3C58EFFA9@SJ0PR10MB4655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2h56GkG734mBkou2FgSYN+MNDI3oyu+wjP3Yrn8eG5DmGTljYy5h8HyJC3fXh1TPOz+cK3sSBphuTXM7d3johcWckWKwmooLVur0CWlWYQo/OLMhrZa1bVZ1rq8OgndUNKhjDUGeFYvSswXKmpzIiUBphtjFSQaa/eyD73rLj+nrQsRvUS6tTR4zrOpIA+dZ82jCP/vgUiOKSihVoxtLQ9nwu75N1BV/1sn7pmGveGYkI/tcs8xP0RZT23mRLnmDIu2O6jUW1vidsAJW+j4YgI5M84PzqoiQ0HZ/W/W5BW2J0mD/v8k1vOOhrAfF21z1K8DU1Cfz6CStgafJFGucE7j3/1wMn7wAI6d9ody9RJCYxZe6ZvaBrK0v4rpEKv5oJGE2JwylA6t4hK7gQ0bBgFYevAjZrAcTxtbMUHa6HrpbFu0y0wzXAeO/x1vOWThClKMy1QAdf0dZ+UVI4WTI2+/k6/+H8LF7t/hbX1MRoUk3RbGoBflePR+Sf5B/LDpdGJOA77v9Jj88/dgAcnzjWK5RpDgrBN5DLmR6P25HWsSXFZGjRgub1Uefakhvow25OQOEujFnFxFlu2DjxHugxw8spuXrJ+ydh+GAUTRKFUpMBxLFApaSbt0pb0gmXuctzTJFile953I1bv096jdbLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(346002)(396003)(36756003)(1076003)(478600001)(38100700002)(6666004)(86362001)(8676002)(186003)(8936002)(7696005)(5660300002)(6486002)(316002)(52116002)(66946007)(2906002)(66556008)(66476007)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kQSkQAiDnzBXCeJIox8Snj6rrfMw8vNZTsGwiMWamhXS3JksWD0j2XrOnwEB?=
 =?us-ascii?Q?5o9N9BoZ+gidDAOtFcRE7Y2NRxMNU8C2Tq9+bxeBv8o1who2oeTXSlRA//iB?=
 =?us-ascii?Q?tXykAdSOqO+eqpXIK/H57UhgTamDP5I25sC0EcYVpCateAlifDADQLb/VbC+?=
 =?us-ascii?Q?gSNI7+XvYSEqUKWricpDsl3nq0f+hW9Ict4n6yDjibr71VmePh8Wa10B5raU?=
 =?us-ascii?Q?ayGwhSohtMxgd4v8ly0Et0ZelVxWh0cxqK09u2q/PrwP+aFXbO2gZKWRG87m?=
 =?us-ascii?Q?mKtjz3njLVFPceSQziWewu3XJ/Wz0qrixG32XlFDPpHp2NqrXl+uVbhfercZ?=
 =?us-ascii?Q?haL2MuyOEEzuc4bz6bwkcW39REIkiU+BR/qlneSbdrLwH/DIsZQNp6xhV6b6?=
 =?us-ascii?Q?5AQ24Z683p2KB36eFwjpzkaoc4QhWjbOMO4mR4G+F2WP0Otw6BanPTk9cGKO?=
 =?us-ascii?Q?SDwTntk56gxJNmq+PmCnzlho5wmugpbzDGbdGBqUhTpu+7soA+WPpCyq03WH?=
 =?us-ascii?Q?UfjHf3yLb4GbZu1CaP7I2gYo04xF3hHrMUWP8/eW//ffbgdgC/tkk1zBSCzm?=
 =?us-ascii?Q?F8mJgI1IRtfhllqC0QNLW3Ix+bfxSisu7ilcBhVSlwiq+4C/GJ4bOWRjltlL?=
 =?us-ascii?Q?IH9oGqBv15M6CnR3dgrUt8fgm3ecSnKliYwNZ8xJu4/eYplNt6Ema7mrHEds?=
 =?us-ascii?Q?IuQe9LPMpfethrwBiu9oRqFa+h7H3IjadEY6+RPAetYp8Jbi2lLKNN+ks65z?=
 =?us-ascii?Q?xns9JygotWZMx22DLa/4TJXTzez4xXoIIjmU0XRKCLWeJdlE+vN/W2oXU6b4?=
 =?us-ascii?Q?kiFjno8Dwd41eixqaRJjAP045nW0u6u8Kw5tEEpAyNLxy02lGu3qObXmk25t?=
 =?us-ascii?Q?eFIBriN421dK/7zi033bKMXZ7flD7d97qCJ+U/lEbCiXIwdY7TMjTOW3xy7w?=
 =?us-ascii?Q?yY1J1fNzhEM4GUBJGxJKXTry50JiqaNWwC72QzT/dvyOTbje8AmOiTUh1inA?=
 =?us-ascii?Q?JrUMmjIBFXO+1BjtzyW4KtbXKFlt95KnA3InXvr8edOav8XRm/txVwy6ds1n?=
 =?us-ascii?Q?yTyFfRPgBRGYWwPii/+kn0qgGTPHIWjDGoXMhCgP+Dsb5wiHngOZtCab9mrq?=
 =?us-ascii?Q?gMud+LtaZa0NOiku8yspsadqKDTws8ljE6uwfRvmvqphF1/X72SJA8NEEEeo?=
 =?us-ascii?Q?kDMRQai2bW+i8Z+XOEU7K1pFWEWbY47jwqGT05cRBCcjRPQqtoCQ82IUb3sK?=
 =?us-ascii?Q?6G/+fmJGf9geHFbXKc4oUy/BBwisSl/8O79Hc9nngqjz0JPZke1W7IFcQqzw?=
 =?us-ascii?Q?RVmQijE2GwmHwUsVXnksMEi5og81arnI6EeATnKzaMELSDcK9nO5Z2Yg5g5R?=
 =?us-ascii?Q?c1hNzTU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce3dcd6-3fb3-470b-bbb7-08d95e83f238
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 17:58:24.8530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz2TvFpah2VC8kpE2PuzUOjr9Pw5KRxyrhPG7Q0NzPrDVW++WtKwXP1jGQhOEJucLIN3UIk1+zuPH60Hb/4YCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4655
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130106
X-Proofpoint-GUID: 8gR7l4uq1zcbkOr1FMsCPoIyDMht20jr
X-Proofpoint-ORIG-GUID: 8gR7l4uq1zcbkOr1FMsCPoIyDMht20jr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

syzkaller found that OOB code was holding spinlock
while calling a function in which it could sleep.
Also addressed comments from edumazet@google.com.

Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/unix/af_unix.c | 47 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 00d8b08cdbe1..0f59fed993d8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1891,7 +1891,6 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 		return err;
 
 	skb_put(skb, 1);
-	skb->len = 1;
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
 	if (err) {
@@ -1900,11 +1899,19 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	}
 
 	unix_state_lock(other);
+
+	if (sock_flag(other, SOCK_DEAD) ||
+	    (other->sk_shutdown & RCV_SHUTDOWN)) {
+		unix_state_unlock(other);
+		kfree_skb(skb);
+		return -EPIPE;
+	}
+
 	maybe_add_creds(skb, sock, other);
 	skb_get(skb);
 
 	if (ousk->oob_skb)
-		kfree_skb(ousk->oob_skb);
+		consume_skb(ousk->oob_skb);
 
 	ousk->oob_skb = skb;
 
@@ -2362,19 +2369,37 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
 	int chunk = 1;
+	struct sk_buff *oob_skb;
+
+	mutex_lock(&u->iolock);
+	unix_state_lock(sk);
 
-	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb)
+	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb) {
+		unix_state_unlock(sk);
+		mutex_unlock(&u->iolock);
 		return -EINVAL;
+	}
 
-	chunk = state->recv_actor(u->oob_skb, 0, chunk, state);
-	if (chunk < 0)
-		return -EFAULT;
+	oob_skb = u->oob_skb;
 
 	if (!(state->flags & MSG_PEEK)) {
-		UNIXCB(u->oob_skb).consumed += 1;
-		kfree_skb(u->oob_skb);
 		u->oob_skb = NULL;
 	}
+
+	unix_state_unlock(sk);
+
+	chunk = state->recv_actor(oob_skb, 0, chunk, state);
+
+	if (!(state->flags & MSG_PEEK)) {
+		UNIXCB(oob_skb).consumed += 1;
+		kfree_skb(oob_skb);
+	}
+
+	mutex_unlock(&u->iolock);
+
+	if (chunk < 0)
+		return -EFAULT;
+
 	state->msg->msg_flags |= MSG_OOB;
 	return 1;
 }
@@ -2434,13 +2459,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	if (unlikely(flags & MSG_OOB)) {
 		err = -EOPNOTSUPP;
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-		mutex_lock(&u->iolock);
-		unix_state_lock(sk);
-
 		err = unix_stream_recv_urg(state);
-
-		unix_state_unlock(sk);
-		mutex_unlock(&u->iolock);
 #endif
 		goto out;
 	}
-- 
2.27.0

