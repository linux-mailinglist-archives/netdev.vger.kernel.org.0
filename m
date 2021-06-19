Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824BA3AD8C9
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhFSI7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:59:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4902 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233868AbhFSI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:58:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J8toHH027410;
        Sat, 19 Jun 2021 08:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Nj95XxTFl31lfumy5AiHyIhD+P2N1IS9/7ZeQQWTl6c=;
 b=V3WgPelvvRlOxjdwblaPGeZTlNsFvseu1bWy9Wl8l1CUQf8edDaFlyQJy5t3JiFSjsAY
 s2LSDknUS+UN1M1HEnLgtTN1+aOIrdhzRFmgFigvvmruOdqmNzH+zuzccxnnn81E/hml
 OLDlKtKWvWM+4OGcOHGofQcjRYSvSMyI1l9+kf4GXAMNvU21kZ2ZoFkI9v69hqnq7QRY
 ckFwWVGLc810QPVdtenEHtQKdHHco3gzwmvVaVzGOfO1D2TDVBEq6aUXPlU3wb+QOGp0
 jd2Pm51PScXQjs+2qqE2sCBnBYb+fbL4t71/AgccCDTfBSnUWueKtO1Lv1U/ielIE2Bq 5w== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39986qr8q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:29 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J8uTV8139034;
        Sat, 19 Jun 2021 08:56:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3998d2jqrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b05sgZeBlL/UugXcWvBDVkBd7HmCOloQjsxBumR2D2Z9HhRBXveCiDgE2DEuISMsfJQj2PgS8TRQUE1OgUfs4xXKvIYesL3CSE9JrHo84AYyF9VY/AO/MenPfs9+oiL2D4dMLAmIZTzwwG87nehjwNUdQg7srUmeLB/zBNPNobvdR8ENQ9Ab7iaPlJExWEO1djNnfg8PchptDiXkWdp7f0ldL8VKGg583dx1EwKPtxcagEAZIeyiP9ACXBesmKhIdEh7LtE2JhYx5n4Vh+Ge0qlW3frXFRmrL1XVHzT+HkGut6L+stvmPcOKD+XwkdaocXuFo9YX9om2kLXJP82xKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nj95XxTFl31lfumy5AiHyIhD+P2N1IS9/7ZeQQWTl6c=;
 b=OyQ1CqYPtYbfSVH6Frzf7HFryB4xwupkuF1PR4uP2CVLyAnf9D89YyBwoJ1g58h+feKv8kl/8g/k/lGK3kj8UW9FOpvhUeZKMIX9yidYxttHKyAEBDcLyrCNKuBUXjvEypEoLPQR/PnmyEto5gkjUozY+KFVwnVdTGbwR38+0LuuZhJPuiW2YlkdGdkvxcFXtzj49PYaVk17QJN65504wiXEbJreQYGuXigXw945SeIfHz/FXVDSubr7uOtRu1mMHN6SIkPTJISLAD8QZI3S5/LtrebHiEbBSmAGDOsf0ePMFLwxlbvNHLT4JVUldwXqML+dr5lT8QLRol3nBuTajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nj95XxTFl31lfumy5AiHyIhD+P2N1IS9/7ZeQQWTl6c=;
 b=D2Znqzrq+LF5EPrMw83ag4+x1NzBp5C5AQMuqia6WI5FimY9aTpeiOVpVXsicik1ixfytaxaFHUtRdzeatfdYDKOGHinXH7aDA+SjezTiOe7AOk5JG/sS++CTGbf9RKoF9lREF8K5VxOxcbgGSZfOxFrr24nVONlcJRGIGgzuns=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3357.namprd10.prod.outlook.com (2603:10b6:208:12e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 08:56:25 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4242.023; Sat, 19 Jun 2021
 08:56:25 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 2/3] selftests/bpf: add ASSERT_STRNEQ() variant for test_progs
Date:   Sat, 19 Jun 2021 09:56:07 +0100
Message-Id: <1624092968-5598-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com>
References: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: DU2PR04CA0245.eurprd04.prod.outlook.com
 (2603:10a6:10:28e::10) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0245.eurprd04.prod.outlook.com (2603:10a6:10:28e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Sat, 19 Jun 2021 08:56:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ca54129-f0f1-4e20-81a5-08d933001e94
X-MS-TrafficTypeDiagnostic: MN2PR10MB3357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3357F6B7150A1B7FABBFFBB0EF0C9@MN2PR10MB3357.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:65;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWv0OKW5y74GjqZqP8P5ZGdDyxr/4J5FQsP9fnoZ0OY3iJid9taHdVZuGf8wleUK5y/x9SWmsbhGXuk2Xw06ljCc4y3CkIWmRbY36IygxfLrRugCJUg1eud+IULFfyj3d9Bwd8G4I9iHFaIc06UTMXSbmKln4clHhArnKemfANCMxQZogaiWrKe9Kxqheo/YwwLssh6kClnyKss6wSNtzfljMr0z2LzMkxO6RItZzezkgW/hZ+U7d/WAWPI2c9g4p/0DDLGkYzXqEn2sBGjr+TzggkEFlxoscVFOuE+PClnwwAqkEQfhNfw7dH9dj6ImFsz/Ajt/74Kg9+xoTbxmBV3l+Giaj7NaQzTx6qUB9sCP0pJkoTHsWRKQfhufmUcVlzDBrpJfg7apL+bIPgxBk2G8wuejfIIhVX9HCLSOYe/EKtWehOccDMLBCObJMdzhRDbuwDTcqhpKzhIdwKxvfJeJ1XnGo16xwrdTC24DFVsIonJK6UCLtOgETcfQv9Pa4S7UE7Nt1egih0q/BU2YMuU6j8HMnKVUBPPFsoF15UbUfAptHdRHUzMO4BVtd+zpu4u4ivgO412S6+JfJmNaqjIo3C2IjphjICEuv0LXJ//r2CKms68LQBJAjT5j/Ay+UZV1rLF+vaDW/2SLj2owTz7bFQynGh7u35DvIPxOPuSSLbBUuxnksbMFdPqbW3QE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(478600001)(5660300002)(4326008)(26005)(52116002)(44832011)(86362001)(4744005)(66946007)(6486002)(16526019)(186003)(66476007)(66556008)(6506007)(2616005)(956004)(107886003)(316002)(36756003)(7416002)(6512007)(8676002)(2906002)(38350700002)(6666004)(8936002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ouwbMnQT5H4dHVWHOX3O2iVPL6lkEBCWgiZq+kRdc+wiht+wp7sjAbl99ALv?=
 =?us-ascii?Q?NydyvNVZs+fXvT80sMpJtiyeEwSKia5K7LjMtYa+j2Am6MePoCouBw48DYNZ?=
 =?us-ascii?Q?H/GRtpyZ3XU73lsv3EbRit55ZGMOq3q13G4+W54xm6T0ywnzXV0tcIMU1jey?=
 =?us-ascii?Q?ig+q7focacUWdHb5azMpYyjhUGSMskYB7KliZxqm5PoCmmcxHeCO7NWqg098?=
 =?us-ascii?Q?k6oKQj67frHTdAesdwFOeJDKUGYC3AR/JIF8/ry0YY7hPyqaGHPw16YnF0Zw?=
 =?us-ascii?Q?9t7eeBpm4UqZ5AH/iaI289pZ48utaCsU8tnpsIlPfPinLQq6gCXItoK8rvEB?=
 =?us-ascii?Q?Y1QNSEPCo0utuZtcK92dmm08Mg73ZLj0sNBKYJteKn0ZLSqQUeIV37342EYn?=
 =?us-ascii?Q?ySYvYDEAA5z207tawOXVaMPWByuBSTqw6Zc5ws1Gi1Fbi7QQ0ZkYm1H84jP2?=
 =?us-ascii?Q?2K2sbAa8/E8f0YOUXDjJSuj1jySJA120Riwt1gGcUWylYWjEDNC4MbFP2uBp?=
 =?us-ascii?Q?iqfew09fyuDCJnviTgPeP+YBIvlAARvNms8r0MERABjbUfzL6DtfoO+n4xTo?=
 =?us-ascii?Q?Q8LMWZqEmUNUVpKFfSbtyXXNL7g6oJjnsFVpMa5LWtYMIDYbCkOJNqdU66yG?=
 =?us-ascii?Q?7NiOF/xUAFemnTDm29nKoaEsTke/xwz9QuR/kmZ3e9Bj7OQe+CLQjAjizo34?=
 =?us-ascii?Q?wRiggjvKV9+QTYF1SXq1XsLTtigYB0OC/ndwYcN0CR7CYuSOdJEFvUdidehN?=
 =?us-ascii?Q?eDuHRo5BfwmT1tpXyHiGtLsBq5qYD00ajyvRmWjGWIV2ElTxF/tqB37E9quB?=
 =?us-ascii?Q?qCk1CEghumgXpxDRfgMiFKtMjexE5E7hKPR/YzBHBd0P3Tacbmkyg6TnQu7q?=
 =?us-ascii?Q?+Z+qT2ap4LeiKWXY8v7JHSgy+YF8QxOOS6lrsh7i6HBdMSOAdjfh/yYt0Hhg?=
 =?us-ascii?Q?BFa4QMA77miB/WBwSCvKy+DB6UGOvrxI0wOQ3NQKK/0OFu358MhcbdYyZSNO?=
 =?us-ascii?Q?wpgzhKltmqKnBAHlcAh8Hw+fJR4eK4gcM+5SjHVGg3pcemABukKXb1gWTyrU?=
 =?us-ascii?Q?eLxBVTi4D/4U6KZM6mdni5IU0Ba7j+bDNtCczAE33FSeGSrSAWCwzhmAdUnw?=
 =?us-ascii?Q?VpuAtQesYwRRat+YkmALg343haG1UyxCQn/5apDZlc6F94Gxylbnw+/Y+XbI?=
 =?us-ascii?Q?jDyeGFS++eSiC9MfXPAKW3RCph9hNY/vd5HHJUhVTMBPgKDy+iUPMlWb4dW1?=
 =?us-ascii?Q?fgsl2Ok+zgTZ1UQaQH2zPSbs3HxepVpocjPvapn0pUmezGPJkRJcwEAefUqp?=
 =?us-ascii?Q?hNHuvnVJO25FigasMcGEasEx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca54129-f0f1-4e20-81a5-08d933001e94
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 08:56:25.7543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0ryNaVIC40pwaz5kUthwA1RmJgOI2qhIbVz25x9vHwu73LlyQnFpq9cQmOlOuzytuPVaFc4Ep0+dl4fy7sN3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3357
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190058
X-Proofpoint-ORIG-GUID: quki5WoGLKBhkfgJCPVHEuHM6XcM2cXZ
X-Proofpoint-GUID: quki5WoGLKBhkfgJCPVHEuHM6XcM2cXZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will support strncmp()-style string comparisons.

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/test_progs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 8ef7f33..d2944da 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -221,6 +221,18 @@ struct test_env {
 	___ok;								\
 })
 
+#define ASSERT_STRNEQ(actual, expected, len, name) ({			\
+	static int duration = 0;					\
+	const char *___act = actual;					\
+	const char *___exp = expected;					\
+	size_t ___len = len;						\
+	bool ___ok = strncmp(___act, ___exp, ___len) == 0;		\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual '%s' != expected '%s'\n",		\
+	      (name), ___act, ___exp);					\
+	___ok;								\
+})
+
 #define ASSERT_OK(res, name) ({						\
 	static int duration = 0;					\
 	long long ___res = (res);					\
-- 
1.8.3.1

