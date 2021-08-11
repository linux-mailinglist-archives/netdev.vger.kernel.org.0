Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2243E9AAE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhHKWHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:07:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40822 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232166AbhHKWH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:07:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BM6gl4026570;
        Wed, 11 Aug 2021 22:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PepAZ9Bjso1S2+vDy9m0jEMWG0HFMTm8m5TOcuEZZAA=;
 b=ebT6vwY4Vtc5+/X5VCzAu03bGZm4KW46b799tanbola7KJ3xG2R2tHEWeSwiFL2eYhZd
 jm0TIE9YFa//4RRckvai3BYeKcbq35ZYw6l70i+ujt0cH6n7jWvhyBRuoReO0lDIzIGt
 UcMZL6ob+sormGwzlmGjjxEuKvabzLxWiqzQJcx/B9DwDdlQinQe1TJZyfYCBj/oyGKv
 OeJJIwExrxVMs6dO3dzUQ+GAwVRwJ5HryPFyInnmK+m0MNgrdMvjgr9clJJ4wpVspvmh
 2VlkyFQrVpWvvfrnaFYTptIy9Cff9H4HgRwHMyMKJYYVAZycHS0XGgHC3ekylErYU9Tr sA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PepAZ9Bjso1S2+vDy9m0jEMWG0HFMTm8m5TOcuEZZAA=;
 b=zThC/Z8dogCmtlVO8qYorE9taCYbt1GG17Zsixt6Z1BBxmS5lwIkLSt+SO9wz38qYsql
 AEK4WcNczKsD8IvrBdh2sGV/d85sboL+xo2RTMSzkLw7V8skxcV0k1NsysVkqfImEkSi
 1w44dkhfyBdYp3H2KsmB56U2M0UVY9qe2Ub8O0baYkA/Mrlud//Jm1uIsJlsPXTWTEb6
 02YvnPNqtYehogxVdyTmxFDDuiobeaa/29k8b/LTjec+2n/maQkxRICbQtWoPBB3Zp+Z
 aEzYSQq/wJn/32Zkt5PD/fWJ4zzl6VQv7eWZECpr1mpCQoOI+0N3MiPpco1sqxM3GIJw pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3abt44bvv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 22:07:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17BM0lsR093734;
        Wed, 11 Aug 2021 22:07:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3accras9tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 22:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWSSLy8mQ8NgH7Hokvh6OC+mdsyrhP0czOUZAkiGWkbmwESYpoZAazxg+ISdWK4SlrafP2MHCeerNWaiTGQj0K1mQ/sZnAkG9YF3nQcrBn4llvi0Y8WxmTREpAfcI3FQqwQvn0vbMu8V2YaBQPSWnXRK9DaZOTX1GKHBKrHqywtS53wv3+N8E0JdXUTm5ysFlDRkkUzVAnkVgs3d7PJV1xQml4/sVkKqOOuwQgOldVUFUcdHzXIE8oxvPFduDQxcPI5/2ofLkBMUeV6ivG6gTwMhCBov7W5ROoGcsrSP0o2E/RvK5iDbuBaWymYofIFDO1sf/SEQQ5Dh831vna3vXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PepAZ9Bjso1S2+vDy9m0jEMWG0HFMTm8m5TOcuEZZAA=;
 b=BcxLRbxiH2wTVRyT7TJ4slNk6D8E6PHc29+4MO6BKn2N6j4vFgkkA77sbSchYC+k2XKuQKgoKc9gBY1ddqhlqWrtcM5V7iPxb0UQ0BFG+MHQeKPooEqejm3LFI5oqxc9VWBDhgJKETcZ5TBZzptrRRw7bTtgRKk+CSYsCzb9jEDYa0US+khgfhgj1QJ0gw8xNLcPfXg7pTrTgExnN0et4L4jTVAta6rqHgwt7JtdUzszw2WjfKbEetRDVn9gUFTEglUokOsv1clJfywQdgta5lisdb3/GevXbiva3rGydW+oAeZTC8ZkYaVWyyH8eqr3q/yczGq63S84BMrns4Ifyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PepAZ9Bjso1S2+vDy9m0jEMWG0HFMTm8m5TOcuEZZAA=;
 b=FiNoJRY3hcNH3D0zXkBBmFsaboKfXf5sCpwhIGNR2Z8wV4cTVVmbYq2WWOSwBUahGhrFWBUDW/rcX4Uv+Oer1meMydpkNu7yC4dlUo86hQDi3/Gci8X5/mC/k5Nu7uMCGubrzku1t2zLaW85Jd0AHdfafHBWNncVoX5mhjPbCyo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3032.namprd10.prod.outlook.com (2603:10b6:a03:82::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 11 Aug
 2021 22:06:59 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 22:06:59 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, viro@zeniv.linux.org.uk,
        rao.shoaib@oracle.com, edumazet@google.com
Subject: [PATCH] af_unix: fix holding spinlock in oob handling
Date:   Wed, 11 Aug 2021 15:06:52 -0700
Message-Id: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by BYAPR05CA0106.namprd05.prod.outlook.com (2603:10b6:a03:e0::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Wed, 11 Aug 2021 22:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 739f3032-a3b5-4260-2f32-08d95d145750
X-MS-TrafficTypeDiagnostic: BYAPR10MB3032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3032654577AF3CB3B42014DAEFF89@BYAPR10MB3032.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:254;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3xGsgrsI15Qrppt0Y4iatfPSwocveqZ996fUaXVQ4eq4mblBpyMbq9Kfl19+qrE7jRvuofndSbRQ2OkmvAMazhIEYNWJWuMQsmYHKEwTMUlLGwSF9v0PAK4Cf2wrG19woPAFUwDEq5xCBOtk+wMYgS33hXLqyuEZgZ0EWBuLNkedDUE5PtkscOXv8fG7JfjRLpyNZxzPSzreki/Vd20mlZftw/bEFZghIDPg5HyemzBzVsVY2ZPKB6TyxRejm6JTKtWfOP3d9cIEZWWklOYigL9vd1tkrnz8V0icYtOFwzFGqlT0MGhLWy5V44eOBn65peT+pCQdcYrF6ICRG+7PSBlLhKHfT3gZQpotac7J2EUcXnBgiTaQFhUiGy6yesgkXXECM5hoGSSbYk5SvN+he/n0qkHKbDgie/dKsKFtkdFjyHPZVcbu4c8gDA04Psd2JblHILf1RSdrbYlNyHlWKVJSkYUA9ER00zn4w9Rjw92GlhEpL/lsPA4VxdYcsUyvQlLUzkNPxeylqgVDQdwPwZBwQhA2SIvNqHa4tcIXJmpID6IvL7ckvsL4/z9EofzeyJCndoDh+wyDg1xt2OnxcQyUDVojrE4ji310NtFRnZwBUk9SfzCbJiVXOqU0RFMP6meqKtdgX/gSqWsAQ0vRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(316002)(36756003)(66946007)(52116002)(478600001)(186003)(38100700002)(6666004)(7696005)(2616005)(1076003)(6486002)(5660300002)(8676002)(8936002)(86362001)(83380400001)(66476007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yTz3MPNdH/LAyDjZqW8S/WmNYw45Z4+MF18VCA1C1Jjk7k4bfUgcU8WMv2Kv?=
 =?us-ascii?Q?769e2gR+ypkM7yG8fId4W0nyCN1fgnNw82pA7xUHzbTmvt5L/+AWdWlUsLkU?=
 =?us-ascii?Q?RNSTNENhYP6PNoXRSNflzP6pWR0v8vM75PeLpvRAwdLwxenue/XLQcrB/A0+?=
 =?us-ascii?Q?X+ovhXisQoLTQLSqpclOG6oKWFJAQ91ZQ3wEJ65Z22zdVhRiPAhFjSCX8RVP?=
 =?us-ascii?Q?KDI/BznwoCY6nQKNpSe+BBDyIzJv6ZlC6df05hEdoTU0D16kVxk87uKsu+Lk?=
 =?us-ascii?Q?75eBZQaKDmTk7tdcwGL2sIUsRt2leCD1Vt3jA/37FXPNuXg3D6NIzcpNhQyx?=
 =?us-ascii?Q?tov7YhkxflV7/M7sbE/7SP/wcGYFzTXgDdLp93ihSFd/oT52hzn4K6KSeqTl?=
 =?us-ascii?Q?XjfEYnSHSbEWSeBxZlE+bCP8eri5LMfF+1A9yNgELtg+VtLWv6M2EPO07D9t?=
 =?us-ascii?Q?NaZssK9737/RDuCLt7GJ8wOE23FbTlGwohGN6/gyV3bujXf59NetKRIesoPl?=
 =?us-ascii?Q?q4teBwGxRjFd06TXHcN6oIDNS5y62x8864Du8nuMdrX2sbklmrIBgsFeAdJv?=
 =?us-ascii?Q?vTDgt/x0XDFCAl45db4P9ipQEXGjDnUFVpBVCq2zHJBRSCKq0n4myPo5DfXn?=
 =?us-ascii?Q?AasiQEPzAb/dKq9XHcCPpWMlKrYRgSfmveO1/m0iEYDzgs+EDxjK0ewGUHbk?=
 =?us-ascii?Q?3RZfKbJuM1kkSbY8ey9+b2bSqbSaQOIqLBVyE0J85C3hqfpYsiJZiWhiL9BI?=
 =?us-ascii?Q?VSoJziFPFbjLwvJtZgxHPY7yd8SbG9uzrHSh31pMb2ih5Mc0woM++uQBWM3Q?=
 =?us-ascii?Q?M917S/LexDaoO1HzIHLR8/oxzol5cF2n4ou5r3G17Z9yIXqHGgw9s+cyObXI?=
 =?us-ascii?Q?qBQFmHdTBgMi/HEYbjfcpvc0eeZhsWEHX9SjOwLSK985WPZyndJ0BORcXOXI?=
 =?us-ascii?Q?ozQWcO2wXm7y0+UFa0xGfA4s1zt8FEtxj86gmPREqC/6T7JVVouWXY+52iEk?=
 =?us-ascii?Q?HXW/Rn/83PiT000kv3yUmAEI6j6lM21veLdJkBurSwNo3lwSvwJIfbSrkoFE?=
 =?us-ascii?Q?ETBw1LfjXmEt9mO9trPcEjL53Qo/lIe3DbMx7rWwAGVakxcATLqWtMohVtjL?=
 =?us-ascii?Q?M1qZvplabOjUFgo+CuMzA1SJ9Bu8mgPyiYmoHCoyMiIgoB/PkYIgoVw/IhCV?=
 =?us-ascii?Q?Bb25tTGiJVBtGf2vh35P4Q/t5XOvvvU4u47XeOongBmMWCoZGAKEXiHm6meA?=
 =?us-ascii?Q?jy3Y9L/8B7tEY3sJrVWv+LP4jr722kapVlPgD0RUV1qX9inX6c9SxTRzI306?=
 =?us-ascii?Q?vFWX2KfWgjgacLPN5TwwNO1wBynVaPz/zAkqXJ9QQaIy5FIUkneyRrjI71KA?=
 =?us-ascii?Q?oESTd64=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739f3032-a3b5-4260-2f32-08d95d145750
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 22:06:59.6760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYMO9WYSSftX5w9Rm0R6b04mo3Wy6cOOLuRyEFaKa+K51EhB2PAnZxpIix6WK3v3xCHoCZyvmg9iGfrVW3JekA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3032
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10073 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110150
X-Proofpoint-ORIG-GUID: QzJmFk1VnTs0VM0hvW_WiHf1uFmIcA80
X-Proofpoint-GUID: QzJmFk1VnTs0VM0hvW_WiHf1uFmIcA80
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

syzkaller found that OOB code was holding spinlock
while calling a function in which it could sleep.

Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com

Fixes: 314001f0bf92 ("af_unix: Add OOB support")

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/unix/af_unix.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 00d8b08cdbe1..a626e52c629a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2362,19 +2362,37 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
 	int chunk = 1;
+	struct sk_buff *oob_skb;
 
-	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb)
+	mutex_lock(&u->iolock);
+	unix_state_lock(sk);
+
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
@@ -2434,13 +2452,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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

