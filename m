Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F18A43D628
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJ0WC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:02:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39178 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229879AbhJ0WC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:02:26 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RKcYu5004983;
        Wed, 27 Oct 2021 21:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=a9tt8manzyL+GgYKLD3HxypH0YHYkEsUdFSUa/VZLyQ=;
 b=qJfN1/+QPjIjyqBj8NV8zgCqRbL9O2WFyLOGRfGmWe24cXDuCbleZkJl3k6uzwLVErRk
 NiQST9BbfE7TtJkF/iofrN7mnoTkm/sYxNYS9pG07jv/2oEmPNGFpYz5wfYu1Wc57iaY
 QXgcQsE/b21u1zHhTMDUHkV+F0Cb/HeKiJSTvUBAoRH+St3myRpa2z4Z5sfhjXPmvpg2
 E0wA9lX5kI5Wedj0qI0Puozi92gFTW+5WRjHAQl5Tve6RV0g/iI5n58yVCkvlzwMCUjO
 /HgoEvkDsbVCig5oUilp2kZpx8LTQinui1iFwgbtKmM/fscwErDmsE95W2yKm8zET22W 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj5vfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 21:59:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RLtJdN084040;
        Wed, 27 Oct 2021 21:59:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 3bx4gaktjs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 21:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kthla5eW22AXUwtTeuYfMDVoTw7Eu52LFRsGCxvk2cpduBqQj+a8iSnbTCA99YZ35eMZvcGqoBAfIecIRVFIQ5DPVhpL9MSBttuLuwZAMPtvXtRfmNxTD64l7btiUl/vxk6R4dsyj6VFEJUWnayyzGPWADKEuM4IgHKtHiTodTmWuupHZCUavvkvDyDWzwY4SJDq8spsAnlk9jUraVsS0IBJqLvnOxOYLpP8vxA8SXEONEC8ioTfU0WSYBzJrcXeHbHxfaLL14CUHxs1iiMy3Ufnxs6EmGsSqxUlgpLJZEDm+fqaXHvbSE+oBion6mBscCW9EB1wWj4RQq3FBk3Rig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9tt8manzyL+GgYKLD3HxypH0YHYkEsUdFSUa/VZLyQ=;
 b=PxAw1YBShxHZUXDd5SrbcxTL3U4oAoJyI9tBPOOxlZM9mVeLhrSWw8myzjmKJgz65OobcvAgQZyH2vcyP3LVlNBWSLVhiS0SIGAr1R+Oqy5o6EpSFXuh8q1WgI6pu0VvP3lMO9t0pv7lHqmDE51bpdsW/iqGxaQYLJzr6GZ3PSys+JEqR9CGv9Kz/qEV50u1QzrhCw0ASuP9PN90BJvnQFZYOlJ48LUA/LffVMHsn+88vD3ybcL526Ka10ayQj4CvJhF/zNYQiAC7Jrw2VPb66s26uRuUF7KO2RxbZxBMCliivasWAOJ7E+3re/TFxN8ZR8LXzpWfKsGOLsNOk9ozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9tt8manzyL+GgYKLD3HxypH0YHYkEsUdFSUa/VZLyQ=;
 b=yD5aglFOotfaA9U41uz4Y4s7fJBUuerrWpDuenG4RL2vuTxJJSeFhW8CqMq0gf6GE1tLhsocBA1YjDyOgGciqdT4zzpeBGX7rU9VwJTP2W3ePr/hSoh6rYXW5ZvlQyzGOAayOfqz0fnVTOSfhSp0Mjvv7pA5gYYf1OQumYnF1Ug=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by SJ0PR10MB4558.namprd10.prod.outlook.com (2603:10b6:a03:2d8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 21:59:37 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03%6]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 21:59:37 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Vakul Garg <vakul.garg@nxp.com>
Cc:     netdev@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH net v2 2/2] net/tls: Fix flipped sign in async_wait.err assignment
Date:   Wed, 27 Oct 2021 17:59:21 -0400
Message-Id: <20211027215921.1187090-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211027215921.1187090-1-daniel.m.jordan@oracle.com>
References: <20211027215921.1187090-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0386.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::31) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0386.namprd13.prod.outlook.com (2603:10b6:208:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Wed, 27 Oct 2021 21:59:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 531d770a-bc6b-4684-e902-08d9999511b2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4558:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4558F5FBB512E75FEABF253ED9859@SJ0PR10MB4558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CnBOKqvbQqTPpD8AaldAl56FyxwoMw5AOpAJ0M3WxNClkh+cocGKw/4K1488sRryJgsE7ar7QI1VIzd/j2JNDZg1zbD3cjpk5dA8AR/R0mf8Zm5YsnIKptbMkpkZS/5l2koy+O+5qUZO+VCj/ONms7dGPBUVIu1QXLbG5WvEc4bAUWI9Ovv2oQUYw0NHZu2OxdGN3rERDG4muduBAKTlaOhbBWALx3lfbDtQ8VQCuH0mofH4YdKnUo8LreCq2afEovMZJQhoXobpeN9mbKvmMykTz6sVwgHRkAHHYsnS+KLff3e5xFP262jAMSqsHIqdze5sQ5gAobq/7hilZ1LL9GXD2i4iAUfvRANkmqg2n6+2aUJ+tQTkU9vFzejQfShW3birwRhhFyHDy9es3zaeU+njetQ87gA7bKdzeeFCZf6fXIa0BjqOWvxY6d4k2vSXuT3km4yxYdEw6Z2rftB9o5KKHdq64sVNZy0MA6ivD8oo+PSUXgVrzS1JTyylSrOJUuMWsPNiADx2HhZXM7X9B8vRrWW/Gg5NIRk9btVToKt0fQL9GoGHFIR6gde21cJ3ZNSspKPOJm1yakOMe6CmZX8O//ktVC0Wxf+gzSAmrU+DjUQuZ2PxHpSY5IygST7GVBDn0+z6VsG7Xlm1604JTivGOyo6n0tvq9WNCatLUPJctHeWp3cpDiPq+/RMMFq9uahqjN2QRfZqbzKayr/HNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(956004)(4744005)(4326008)(6512007)(26005)(66476007)(83380400001)(6486002)(52116002)(5660300002)(6506007)(36756003)(2616005)(1076003)(107886003)(38100700002)(66556008)(66946007)(2906002)(316002)(8676002)(110136005)(6666004)(38350700002)(103116003)(86362001)(8936002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRXqv18SCRNwUKsoZycT+3QyRL2k+oa3tDze5Cm4Ha7j9NEowAoW4mrvKupv?=
 =?us-ascii?Q?8he1iwEZjjq+z/Nl3b5kzn9ina3THJHquUIitxRd0Xmt1rUUeNmAyVwiIEI8?=
 =?us-ascii?Q?oZ4Eht1Aumxnbc8UHI1tpWZSJRkKSw99xdI1khhvhnXxaI9tkDuKeM8ZYY+L?=
 =?us-ascii?Q?a880xeDRnZ5BIKDdQokYRBZ4s0oNINdYjqSVOIAMVZKwZil6rLKWbNTMpapG?=
 =?us-ascii?Q?PPovpd1pvhZPkKy3eT/lf91t2ikbwi+guei7H4n5gOm5nVjININ2HVGzYqnT?=
 =?us-ascii?Q?1dY9WBbUJdiFghPPohzHRix/FmCguSRKTt2F/JhlWZZqRB870tmii8PpA5c1?=
 =?us-ascii?Q?rZTQoUvsMQQbC8nb5taU2s3L85NOpenwbp0fOvQ+lc5DAJEGHKfGO4ss6StZ?=
 =?us-ascii?Q?NNubGDP9D1qUELIh/b+tptDjw4/Xi8BClGNi0NGtnie4hGfp4GCSMfqrof53?=
 =?us-ascii?Q?2GuqBYgM9judoTkgJTUPfzyk4AQ+MZyTb9pSdEm/ShgcSXl1ZERjr43AYQ27?=
 =?us-ascii?Q?F6eL4s8Jmx3icofAnJX1n1rB8pdq/3cZpAFHLJBfxgXcA5CBK5LyGFhiaiWI?=
 =?us-ascii?Q?QMbiPDCgIidPSi9z0GNdA2Wslfg+YjXNuZuR0oxLmE2lElVTV/cbccnAWh3A?=
 =?us-ascii?Q?9zx9clu55oUatYuL0fd3emD4cdbx+bfhBYQW2rQ9+yAsPPE2w5bUTLU7VPZx?=
 =?us-ascii?Q?eiTkdNSi9YRiIa9grj1hCX9unCK+kabOLje24Shxu5Z7ofx47IlmKrnMh6ti?=
 =?us-ascii?Q?Ox9aXSWRl/NzK7o5U8mjjYQjrP3sRBo6xlJRDd31E5R69bxMhrt3fWJVip00?=
 =?us-ascii?Q?UNxl7Q1kfzGQwBqmyeILznwptMPYeXJcjmwh+Gkggqx04zEfwWfPl9Zg5Bfs?=
 =?us-ascii?Q?v6qa67igGjDdOFrpq2AFJ25+s1W7g5Q5hsEIpdcBcL1OnNVTBx5KM43M0sD2?=
 =?us-ascii?Q?qDLy3gaYesqzDVyARuIj2viIb9gWiPBQ0Y4R6UiNpPxlqFl0gO4Z0fYDbRym?=
 =?us-ascii?Q?87kV8KIS7TBLMN1jW3iYpA+k3DoSpNk1pTpRPaOSydm+dZMwtvbQleee6IWk?=
 =?us-ascii?Q?dhPiPOZpztlQcyDSIiaYmVSupY2MxAaSKTFfTdHHARQ/RdhqxGW196iBmt2P?=
 =?us-ascii?Q?WQTzwVxtY3vEzGfWbcr+7C16nppKt2ljbG1NY6jYEV0siwT1xaZb51lXYvvJ?=
 =?us-ascii?Q?LhiiyBoQkoHfuJatnCKJ+oaCAAMA2uFlVOxXSI0+QWmJMyPULgtwNOZpQR7s?=
 =?us-ascii?Q?LuLne4fcwbin0dMbPa282QSYag5UZwHLEsmHYwOH05ptLe+7HaJbHKkOsv9z?=
 =?us-ascii?Q?z6RECSRF7ApQ3y9p7HncxSCjiP047NK0uxbNiZuIE6KWEhFwnkopFg/j0MZR?=
 =?us-ascii?Q?FlMu2a12iNLEYA3sbGubfUoO3wD9mWMUvdLfFTAlsYu6iUzwkCOV2obJk6Es?=
 =?us-ascii?Q?8NbULq//vmPLLokCeB4+M9DVMdrJ5m62R168OxbHeNkuTKN4/QmS0vkd2rKg?=
 =?us-ascii?Q?Lit37I3gZquAXUDFBHqwihyoevV4yPhX68a9cJenJQ35Ei2VpO1FHsll3TAk?=
 =?us-ascii?Q?UwAK6gsO+ZKHptmW1JlCnEZVIVrnSWgc2sVqE6HAw4/9OrSgaMkhBGHEd+B6?=
 =?us-ascii?Q?c5lEuh7Z4oy4TxKlM5utjYZTdA6A/hIPpr98kSNeMe4WsBjJDCjXxiqIWkcs?=
 =?us-ascii?Q?4BLaRPcjWWkoTBSYMkeRWvzUE3M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531d770a-bc6b-4684-e902-08d9999511b2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 21:59:37.7629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXrPgy9ktHGsQU4bhrqC5uhlz5SAMEsdwFqCH7/nsVAke9BQ+6pUNyXF5dpWFV+md6jLzB6wPQjPS8lAYGoFdAc2kMCOFcbGG1tmSKu6z6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4558
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270121
X-Proofpoint-GUID: RuYy1NWguHWujikRXzP90NyApMgGmgvP
X-Proofpoint-ORIG-GUID: RuYy1NWguHWujikRXzP90NyApMgGmgvP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_err contains a positive number, yet async_wait.err wants the
opposite.  Fix the missed sign flip, which Jakub caught by inspection.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1644f8baea19..1b08b877a890 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -459,7 +459,7 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
 
 		/* If err is already set on socket, return the same code */
 		if (sk->sk_err) {
-			ctx->async_wait.err = sk->sk_err;
+			ctx->async_wait.err = -sk->sk_err;
 		} else {
 			ctx->async_wait.err = err;
 			tls_err_abort(sk, err);
-- 
2.33.0

