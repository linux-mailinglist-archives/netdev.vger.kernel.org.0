Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561C43E3562
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhHGMtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:49:47 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:54316 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231922AbhHGMtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 08:49:47 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 177CnJk0023018;
        Sat, 7 Aug 2021 05:49:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=kLJdvlv/f3zw5M/3OxV2gYYIPqXDHuJExpTn4PnOHxo=;
 b=PyDG73KMhRqeApbuFEIfIYU80PbyqsQkSiyMeR+6DqiQf3LfKLYBM+Cl3nGh3mE14UYd
 OcP1BxTNPDZ3hH+jtc2Khdjt9OSA4r9QTjeGlxcDlG2Kq+N2l6f73o3eQM6xfe4ohXIP
 xY1j7WQc59W4B++jzMdDQoIXvRToHNoGNw3Tfu8hTjUThtZhBVPVHpf4QgKu5WdffVBI
 N8EEMlElldBcZKMcWIQ211wmmCADbI1m11d5AVN51K1bY1VEnTpcmaqABRtfje9lnjdG
 VQg/wAUG0Zj4lcPJCF0d6pkC2RqaXfsQvM8MyG3RjPbilTuoOXUfmt5UZWWDRdfnlp1f gw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a9nf3r4er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Aug 2021 05:49:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhTX5Jf3epvEpIwjxt6rdCrt/wr3ilCl35Bh0a9XMf1k83LnvqzUa5tuKrWYUFexhnVMWBh13wUVfIQYlBvh3qKyWP9gCF6pmF8nJPLjHmX3UXXbdBmmYwVo/oLfK8RhZULNtx++gTBYAQbyxyDxTBAV/Ug7/waiIP6+N5E+JUG68Ht1s8loy8KmBDW3m8f5w8jNDFim705rvLtnD3PvNv0ZRSkNzRFqKCJY9JpYurrfHQEW6ZDJ/fstbZasADX0+REQfq9b8pgHtamA9UqQZUc9KjAmiTvAkYFI/OYnQ/Y6b4SLreLJO/9v1ZUt2RRV4pmUFHbq3B6UkXgqLz1hMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLJdvlv/f3zw5M/3OxV2gYYIPqXDHuJExpTn4PnOHxo=;
 b=f4tKOIvWvkGejVB8lmt49+/8I54zeH7QKTaw3ZM8slRX0DQm5DP+ak/Vd5F4TeQLeEV8/WTUVq41LFRFAWnto2F6HtVKjYTGQYTSmKhgKBSNtD5CfBDj4Ie+vHfzTvgDPQ6wlUyMXAz4CHTbFP7R5TWCk4Yp9cXXADglVGm8ZVpAc3Jw1swmHz5WLmxroSD5Pn/C8LGHSVIhnPgyfMzpTsjvMwTSkM4wxwH6crjxwkNpzoMkX+BpM6ZGE5a9Wqpfe2Zeilb1PtEsAd41j+P+enqMsBNspBhEcKLHSAE3IDumLMcScS51nKPCWLM89Wd1AvJDslcpQbv8CTj0k4W7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM5PR1101MB2139.namprd11.prod.outlook.com (2603:10b6:4:56::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.19; Sat, 7 Aug 2021 12:49:16 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d%5]) with mapi id 15.20.4394.019; Sat, 7 Aug 2021
 12:49:16 +0000
From:   Jun Miao <jun.miao@windriver.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@windriver.com
Subject: [PATCH] atm: horizon: Fix spelling mistakes in TX comment
Date:   Sat,  7 Aug 2021 20:49:03 +0800
Message-Id: <20210807124903.1237510-1-jun.miao@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0053.apcprd04.prod.outlook.com
 (2603:1096:202:14::21) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp7.wrs.com (60.247.85.82) by HK2PR04CA0053.apcprd04.prod.outlook.com (2603:1096:202:14::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sat, 7 Aug 2021 12:49:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0b2eeda-dc1a-475e-448f-08d959a1c425
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1101MB213906FBDC5802ACFF93BF7A8EF49@DM5PR1101MB2139.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9YTAv8o57eaEXyx+yKTIEGUmgrwI6UHLXGzrRs2+l7w0X2QyMf1vvhcOIu9M7z4590MaEUI9SklaGy08iiB9mVBwGR+cVH3Wmj65RuFZlvZ06ekfilCl6dFNgh4q5I08nz9BYNe4dxFXkdKLylyv75jQlgqRsOPE1wwk1r36BFfVJrYYas1jPpwqjnr81JGd8RXHVjEQxu7qf+UD88Qd+/hbGxAaWR00ZQjD5Gus9WMhyD8d9t8R9kSe/E+JppbWi/yGf1sUf91rdcO2CLy7CNGUQ/iy63arijOVoJnrQ1o5isxgo76LLsJCnIaE8puYYrNpP83MirZ6n8myrkbwJguEz2ZbTrbA44DBYEPYe4P7CplNfjzQ47qoAWY8tmFIp9hwxfy8CWOcOiIFOgrioSdQjgofjhz77ehgaK59vTFASLLoqxLB+LLQMyR2YNhozcu9+TZbLbfi1J8PvLQ3sbIhGvPu1n2RVYsmbvr4B27x63kNtkmfIkgzQiMMY5BbAeO6+HWM2YJ09AUK3y8zxz7j596gCDeOtUaiFVSyW8v6sGXS/gutZLzQUzXxbfRsGC1q4HMdPRVxciPtyJapuLXOuilqt65oYAC1+/I44Hmf7dHCt1YH63OQbPBLmqDrQbhvrc89W8tpA18WvKAxXrYaMzHjfvEdOvi3f85VyhOmOdjlXFL6yx8wuUlOcRCG/VHlIjm9A4Snj/igdhhupkftCS41CS+mf3+/lDpSp1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(346002)(396003)(366004)(2616005)(86362001)(956004)(2906002)(6486002)(44832011)(26005)(478600001)(316002)(66476007)(4326008)(6512007)(8936002)(66556008)(186003)(8676002)(107886003)(36756003)(38350700002)(38100700002)(6506007)(52116002)(66946007)(83380400001)(6916009)(5660300002)(6666004)(1076003)(169013001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KsPqrJ5GprF64TMaF/FxD25FDHb9FI1VLkdW+gU4gygrWfmEkX9pOt8E+UfF?=
 =?us-ascii?Q?5uSm+Pnuc1Ew5MJDyW7xLSb8SHiUnRHB3OqBgd+VjcbrAHrtGwSuPhGPhVvq?=
 =?us-ascii?Q?I03ut2pNoFrCXnRE/SNR0b7LYJ3Y3UT7J5pWiDdNdBLi7s0gEQjKol+PTMBI?=
 =?us-ascii?Q?Km5UKN/bBA/mRyRaqHeo99q/tZ89dYTYlZigXMfYzp/Gey9olTJGPCRyY7ef?=
 =?us-ascii?Q?ttgnpO/nhlXcgWVmvRebSNYSZyXD05Wtq+mjflFP2NtqYyYF3uEBYGQ+BB53?=
 =?us-ascii?Q?/AI3oCCXD1lNllsdVG45ivioLQD1rpkCONu/xRT0bPf1xLpzvf1JX6pVAuMI?=
 =?us-ascii?Q?bSu9rHL3KJWDuH7VlsL+0Q1yy48SVzXRpj3daGOqQAYJjQ7Rt23FNEnQ7U+u?=
 =?us-ascii?Q?5MNK7CO789MWu8Mohf8BgzZUrhIoG/sdlBqHXa8Ceic1/BLdLew/OW6MD+sk?=
 =?us-ascii?Q?hWDSJLfjHwAa+T1FCtjdgawkGVLAX7tHp+VhIFpz/FGONkOIH1v5YyEEEoGE?=
 =?us-ascii?Q?HiaODWSIGchXd20vge/xnq9haqaXnE8igL4cBKDUmGDofVTjs7+IhpcOKfSE?=
 =?us-ascii?Q?IfLzbEWicvVzc0R11Xi1+iD3BLrPnDBV2ZoGQ5Um0UhzedB482gXnC5IhfVr?=
 =?us-ascii?Q?KA0e75zjU5lH1MLVNuec3Y0NqDDkDjXDK2AacCSE3AL/9dYhR04tqHfwSIG5?=
 =?us-ascii?Q?4ekPI4IhINaAsl/+JVe2EEkPS5csOPO2MTlFSsDybdFKKl6wUZhBtQ6THga4?=
 =?us-ascii?Q?A/JwABzFnWNbuVeIXix7VamhaSwDWv2OHg0Ssjx2n+Gp938JQfnU9J038UGW?=
 =?us-ascii?Q?+6J11f41CgNrAxyii3IT741YmdCh1rjiHHTBIkJ0ksOuJ9gzY+cO/OCN9tHR?=
 =?us-ascii?Q?tT1Hg8MA5j3td4o/5raCvNs1A5EK98EAqeYsNJyfAQ9GWKLsIw45kpUYqkao?=
 =?us-ascii?Q?61HQzKFXjYGre53lxLz79UK36tkzEovU8EkRqfxDsbrRm42dMbCt14QtVrtH?=
 =?us-ascii?Q?fGo3lxGytXcaYOYvlPMHjzb+e7UU91U0GqbnGwI8VoN9WebbfwQu4amef3au?=
 =?us-ascii?Q?87jcx4CZ9kg5XIxx/mdXvhQbH/GP+6VQa6Kq5XATWcVOO52kZX8DS2/IAmMU?=
 =?us-ascii?Q?r4rDhlezdoYQUZVCZelT9hwwa5Syfx7WCuLyZ6z5vkFv69Kv3yQdAtn+aZD1?=
 =?us-ascii?Q?EWZv6a0vyYI/ljSGO1Y0dDrR7/fWUBMN2OKRONyX9pyYj6/FNf28J5iFfgTn?=
 =?us-ascii?Q?AfLDH/z42Xni9bj7hnGbqxv5dG3x3URo/ozXZa1t0ZaVfz2dnV8nQYCpSs9h?=
 =?us-ascii?Q?ZZKU1ghn3FIT/rdHos76dUdJ?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b2eeda-dc1a-475e-448f-08d959a1c425
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2021 12:49:16.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7SAZxjO46q0EoYTqzAhT44A2NRqvyVC355xF3byhdKZw1AgGdvI4KaQeLcMcLHEr2EwrB76QZGshfa72gs9KWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2139
X-Proofpoint-GUID: zMT6iXzmcJZOBlXBk_Kkbo0XtpsqOSUq
X-Proofpoint-ORIG-GUID: zMT6iXzmcJZOBlXBk_Kkbo0XtpsqOSUq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-07_04,2021-08-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1011 suspectscore=0
 adultscore=0 mlxlogscore=611 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108070088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's "mustn't", not "musn't", meaning "shall not".
Let's fix that.

Signed-off-by: Jun Miao <jun.miao@windriver.com>
---
 drivers/atm/horizon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 4f2951cbe69c..9ee494bc5c51 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
   
   // Part of the job is done by atm_pcr_goal which gives us a PCR
   // specification which says: EITHER grab the maximum available PCR
-  // (and perhaps a lower bound which we musn't pass), OR grab this
+  // (and perhaps a lower bound which we mustn't pass), OR grab this
   // amount, rounding down if you have to (and perhaps a lower bound
-  // which we musn't pass) OR grab this amount, rounding up if you
-  // have to (and perhaps an upper bound which we musn't pass). If any
+  // which we mustn't pass) OR grab this amount, rounding up if you
+  // have to (and perhaps an upper bound which we mustn't pass). If any
   // bounds ARE passed we fail. Note that rounding is only rounding to
   // match device limitations, we do not round down to satisfy
   // bandwidth availability even if this would not violate any given
-- 
2.32.0

