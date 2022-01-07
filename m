Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4EE487366
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 08:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiAGHNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 02:13:47 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46980 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230430AbiAGHNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 02:13:46 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20738vuM016696;
        Fri, 7 Jan 2022 07:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=y1/1IYj4VZR12tlsBXeTnPhSnhePaIuDaoRg3ngQA68=;
 b=kus4a5AVpCADMI1Zn/InG28DFHXxrHdiNLAfYytAM/N/Sajc7O9H4P87kJqFLSBIGnH+
 DBl3sYg0x0MRv/DnxiFINE6FxB5ZRuti/0ZZ2JKkD/WfCx43UcOiyZ0SYPuiTL1CdC4U
 l7r7Ycgb8HLgYewXbumSM3ox2InwiTievCQcFJuqOg8EC/x+tX4CbRedRNz/YScspdsa
 gIbnshSHTxb9hFIULasZah7/mjV9r+GcN/arTeFpy9C1gNgfnXFwTX7BHjCFRDVJAXxQ
 T2D8gX4AFWn6eJSHZXN81LaENgZqO9nlqC9rtlWHynGFFrtZJtrr7+8/pH6iqBV6vCEd iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v899eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 07:13:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20775tXv110685;
        Fri, 7 Jan 2022 07:13:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3030.oracle.com with ESMTP id 3de4vxawdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 07:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffbrSgvnS8LdBxVyQPcXADbG9H2XUbT5qvGOQfn8it6teUHrORUlJEmom2yL+7hOKklhqRKiyV2Qg70Uq+kBarY8XIIQ2kNWcUxc8KpjLAf2j/hyGFvvXExsyNSV+JWUjVNSYY4OdVBIZf37WY+RA2G0o7vH3KDsJ99YeKawqpwqnbnMDW9PEjr7kmJohUuEXWrqykHYsTRDIlfemTSOELGVPgQ3LsDceJtjx18seAYgLbjokuOA41azC6qEo0RMPRxNOvRb/25MUz2SSgZ7wJMB0M6ZnHTD71cb68zt4ngM6i0OaQDELExdJJlhfN00WimIPBg1yVAvv9LgPsJbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1/1IYj4VZR12tlsBXeTnPhSnhePaIuDaoRg3ngQA68=;
 b=VQltpOXN8GSFojUgJQJ/Zp//PJ3jXXK//v4gtQOVvENmAGoOvOe2ooLixZQuJw/L0lrZkUH7ugSq+kuWRaBkpfiHuMzp+Gupha50hlRoO4ss80x+mrjw0Xl4390WUMN4NdgVuGUoD+ILbE/GAFXztn+DwwEvive9vJFIP64LTO9Gpvxhqd1VYEnJ1ppEjJwYPFV8kdhMMNCj4XVPvHb/4B9RkUky7Me2tBu3HNBSJ6juJWpuoVLa67jlxaz+W7urixeaL9/QiQYCDvBlmqatifZwQyOFc5PMlgnk5e1ZF8aAqMGi8CCPPQkxvkTijbYKqh5Wa4gWayuC1kbzKp2REA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1/1IYj4VZR12tlsBXeTnPhSnhePaIuDaoRg3ngQA68=;
 b=UUYQ6po5DiLi9b/iylE8NOoqFoVSJYBFcLNA6djuBIP9DwatNSUtCG0pA47sl3F9SdoqdjWOXaLURwt95QlLNMYCBkORWM5ohKjm8PjXAiO+FET55f2La5kVZNfviCrvKlUZ5UxfzeXIMex23hZsANkhyzdau6qrOOTKJ73Yfhk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5679.namprd10.prod.outlook.com
 (2603:10b6:303:18d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Fri, 7 Jan
 2022 07:13:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 07:13:23 +0000
Date:   Fri, 7 Jan 2022 10:13:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joerg Reuter <jreuter@yaina.de>, Christoph Hellwig <hch@lst.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] ax25: uninitialized variable in ax25_setsockopt()
Message-ID: <20220107071312.GB22086@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0070.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae486d20-eb80-4846-e4db-08d9d1ad30f4
X-MS-TrafficTypeDiagnostic: MW4PR10MB5679:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB56791C8B1EBEE49D8CEBBB858E4D9@MW4PR10MB5679.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gvkKRcc5CLh1o7Vve1REgWYg4D3YcUCwqcVzIZeTj6qTOinGk8riQZi0i7e3+tsiR9s5UDRWhGMhZG0FpjCYDjzLWPzrs4tNP/hXV40RwaRKsfDUSBNegtzvMOaCWRxe4GuV6wWeiOCA3qzvUXmE0lusEtO6rY0rBfrwKh4BxWCPLaZhfOGDvq610SGou2frRhvKAqmUxzBW2juiL8j4AQkCTSzLBVxMQmWnChm5TOG8MapKld/1ySG5jWuQILNvZ9qcqgehMbJxCwR1qeMPXslwN6PY3rlQcjT31bvnobbaeQbSQ+F8EZRxbOSkzt7PT981+YuqPZNaSJV+nDFznUq65lYpAjOAwasXl8RZQYS7wuf+fuvtd5GLYSICR9rc3ofpL57M+XTqvsi66yhFl/AsLb6rrQiArE6QsuSNswSbd1ZQeN39O8qqhFgbcNfMFtZ2daOqqHQPeHnruvHRJxA1506UvXVyZRStsNTknAfe4FSwCHu5IUNKwj6yTAyufebJJRr/CPx6lX9bg5EEl/jiZzX8dZQJKQSxeWnP67CaVLg1Vhgn9dIzqPAzup4nhCUFHPjBp5fKRLZ87Oh7iEFGa89ZXyGrkmSpKvx+AWO/dYK4IP+3NulU5LM0qyEtUJiL9PBhQw9LumIXEX1bwPP6rn06DquGhDqITUQBtGfBmMNPehXTxF2uGiO4l72w2c7aVI9MCJnm7Xnj6AKUfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66556008)(66946007)(6506007)(83380400001)(2906002)(33656002)(54906003)(9686003)(66476007)(1076003)(26005)(33716001)(110136005)(6512007)(8676002)(5660300002)(86362001)(44832011)(4326008)(316002)(38350700002)(508600001)(52116002)(6486002)(186003)(38100700002)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8XdTl4jgmmP1L7FaUmP5mX18dtD34ZrodzksFNXW5lAluRFI+6WwOq+Fv8hX?=
 =?us-ascii?Q?uaAYs7TDVD5G1BYo3w8w9ZgRryqMofUWRIcOUdLp2bR38y+arv1fDIWSs7S+?=
 =?us-ascii?Q?yqgRC20nbrjfG+nxgfO8DDCey333nVrEyCHvTkIh1APzEyh879D17mB9CPmk?=
 =?us-ascii?Q?JXkpn/oeYi4nfqgvKdDMfrpbWjZ9j2F/H9WnQlMXR0hSeA9IBvUrvUeMXMSB?=
 =?us-ascii?Q?TwgzV/Jo6pvfx9iReQIALR6y5X2M2fUBzyoAGT8/YNNQqm8gfG8yd4agwNMy?=
 =?us-ascii?Q?W/plCHrBAWWTUEgVAXzrIH1NLUpu+b5pAoPsBii0OulHOSedCx0t+PECv9qf?=
 =?us-ascii?Q?V29k9V2To6ud+zC3WV/H2VyTmKhVYEb2xuJshtJX3+JZZ8bpmVRiJFujCJfH?=
 =?us-ascii?Q?mQItWJvNytmPzvRucUkZxfc50z8nRICfgoRtQ1v44/TrXfQtl7FZ7yBlTaKV?=
 =?us-ascii?Q?pQSPFLGFGrKThwsxtHpiimDLZlf5sKMhd+Y2yFK2PJBAWvpyYaWuaBtK+mLE?=
 =?us-ascii?Q?2l2RMbpjJq/5s1yePFlfPHvZ+SYmrRWP9fXbFC+vyGPi2Sn54SNrmoJ2tn4O?=
 =?us-ascii?Q?QYoe+2Yt+tWcPYobjHV3B0feyIxxqcTVk5+Fb676ggyvxOnsM7f2HlmirMiJ?=
 =?us-ascii?Q?ABZKv3a/nkuXZutvFssSsp5z9e2DQMsaBqXIOfgOQ2An2yHjEks5mKf4EOP9?=
 =?us-ascii?Q?yF2Rw/jgCIPXh35Bi9sAwwbsO5vIWQlbc6tRKftLSLUlh9PHphaD3wj9Q6QE?=
 =?us-ascii?Q?bJx+KRi+7k06mrFIxvDjQx7PFFMi/GKYuu4VTxSdQ3wTGd716MonxvMdBkQ8?=
 =?us-ascii?Q?ogMPWIF6FZIO4MZRIz5vESKkdphf1EDkDLyi+mvQzbHkiLWLCYEg/+jMrb5U?=
 =?us-ascii?Q?70DDOnZ/B9WQHjyQR4ieJN3JCVNy1hDdX69JVWI/SzNamUjUeVlCQSEfyMLq?=
 =?us-ascii?Q?zYWgIzL2f1Oa0N7qxStEsAJ6tjbFbWHv15RaH2F+cwohcD3Lh2BHZeNPf4cw?=
 =?us-ascii?Q?5M2cMDs3OMmRY9LdR0eDc1ieBb/YGwRpagZp/sPhoX7xqiPL1t5WNOOX1Y+D?=
 =?us-ascii?Q?M6N5zJztQA5oiAOtwmpCKTSWERMjkN8bqsEB23lmMXuEYJ7CLVXqyGckmx0a?=
 =?us-ascii?Q?fyDEv7USi5MwSTUd6YaTkt2ciEZd2N1UK8YfghbUTUljURxzpfUNd9a8rhuw?=
 =?us-ascii?Q?rklmPHOZiuueD+w5HsHG5w6bKBHtMlnfwd5sywfjAwb3l+QKk8QOcueU+WJL?=
 =?us-ascii?Q?Kc/zPt4N29Xpt65CVJ84arteTe3UhP8c/YAclYVGvR0+lRVueKViCb7ZGjzk?=
 =?us-ascii?Q?XuLKyfoHRwP8yyquYG8zNGbrbObTySk4+tq6JnKrLgF++U55D0jzAvTDubBm?=
 =?us-ascii?Q?Y7bPvDsV8g/vbqcDEbK37/1FGP/J+KBmBTEHXqKBWBGDH4tiD+h89DuRjIC+?=
 =?us-ascii?Q?OXq2NyadI894X+bdMqH2S5f4mrpWStflhaI1tp9uQZFtXXXDh5PZVgVlspk7?=
 =?us-ascii?Q?Q1rjzpAJDnXwisAo++pbOH84PWwr4uCzFCHS0vS0L75yXsMM+z3xxZpJHHhf?=
 =?us-ascii?Q?7/Jpmw0zpzOF+iEaLmztDuvCfKzjHVRp409Vq6VpGBHdPd+HsXin/G5ucCeQ?=
 =?us-ascii?Q?CAK/708fH2dMbAwP6Mv1RjFYHJ7G8oNkxWmRvcYXjPjbk575xhX36cJ6J4VH?=
 =?us-ascii?Q?QJw2vNVvxfit8GzYDKwHN1cL2Jw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae486d20-eb80-4846-e4db-08d9d1ad30f4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 07:13:23.3038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KWHoTSaEDik2J+uxXd63+lFoJ3denRM9nGiO3cZ1xysnMehNYLJHSOj8i4OemT5tiDq67U9bwbB7tj8k3HltBSg9UHk/wjzy6IDzqj8pB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5679
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070051
X-Proofpoint-ORIG-GUID: vd1CU4wMeeZ6g0g9uVhE9rQuyAa2AiCY
X-Proofpoint-GUID: vd1CU4wMeeZ6g0g9uVhE9rQuyAa2AiCY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "opt" variable is unsigned long but we only copy 4 bytes from
the user so the lower 4 bytes are uninitialized.

I have changed the integer overflow checks from ULONG to UINT as well.
This is a slight API change but I don't expect it to break anything.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/ax25/af_ax25.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cfca99e295b8..02f43f3e2c56 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -536,7 +536,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 	ax25_cb *ax25;
 	struct net_device *dev;
 	char devname[IFNAMSIZ];
-	unsigned long opt;
+	unsigned int opt;
 	int res = 0;
 
 	if (level != SOL_AX25)
@@ -568,7 +568,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T1:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -577,7 +577,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T2:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -593,7 +593,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T3:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -601,7 +601,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_IDLE:
-		if (opt > ULONG_MAX / (60 * HZ)) {
+		if (opt > UINT_MAX / (60 * HZ)) {
 			res = -EINVAL;
 			break;
 		}
-- 
2.20.1

