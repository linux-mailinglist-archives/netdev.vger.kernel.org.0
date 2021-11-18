Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8780D455A1A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbhKRL0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:26:16 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33148 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343675AbhKRLZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:25:46 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIB2BqD031723;
        Thu, 18 Nov 2021 11:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=V5KGzWUWHgjyUj7nJdCweMmnHCW7ar3Cu0ajlToJueY=;
 b=0ACTgUAUx6Mne66IokOr/+zbnmybXvFsGnY3gAd28naLBrcAYu/WZk9I65HEX5qicfyo
 Bs3ZouM2kt19Ns7YHdKXkFhUsbndmgwT4yHzFzFz+nEPjyShPIAyhqYlomnwaGKC1yrT
 VPH14MA2n3Fmujy15ozb0ng6n92sxz7GaNDYBGF9LFbvSu5c7r4rUtb8vj0epJVPem2M
 JCkEYirj56DrTYoFE3nmE3yFVsfVij6YeU5PTozbfRIekbtRKx+7OrOhTl9RWVk4vwvj
 rMC5XnpPNltE3byQCfVvzdprZLbgw/9vuRTMon65nfTwbaXGZ+5o8mFvCx1lAmtX+BSf Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2ajpdfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 11:22:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AIBB8ki101897;
        Thu, 18 Nov 2021 11:22:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 3caq4vug56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 11:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQzOsvK0uigRJsdGSoh8Olb1jFqjFAqdY8yrEzAxGX1DF3OYK+K3XbRY7DikiQmjEjPpN9LVq4fHrdtqfzv+pmhAr8xjxziYTXY8hgSb9AggqsT+94jb7BIPGUb558qcw4e3+UhIHlVRGoMEO/u/9xb4i/6ik4BzB4krKTQ3hbz7Qn0Phf1Cx5YbM9FemFe3deIvhW3Fo8TfUa8KE9oVGOlIpT4uHhkbGf9z8fQuGDQH0tjrJM3MWdQ51LUKtssEBXHslgluo18JJVF8dXvgatWvOeLgODv7P9YQohELi7BXTtFvb35hGanKvc+XfCRSVbCp6rXujTb/mAXEg6JsAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5KGzWUWHgjyUj7nJdCweMmnHCW7ar3Cu0ajlToJueY=;
 b=eCx1jPljEK6NWX6h5eicWTZ/y14yDqa42bfUu7c0SXzEVmP7Iw2Ldd5IIDasz/6GK+g8gqYzmrrCxZTxAGsntMxvKTJIOaCOWgWxKVIXsfWAe5Yvw9MPjXiXrVtPyrVZN6AcxCY8kIHwDuIYq+TogksWsGAWpkFCWogDiEUYyxxIhCTae+58YlmOdGUHxVmFhU/bEahdGKn1PafKoOzFlUN+SfeAsyNlrR3lCtAbNsyHwsNGWknKtjFek0jtaWiTh5gK0e1moPDEzelg9yjDyDDiGUlYdoZu7rFtfoW9pmuRC9Njy4fNagnypiGa5e1AoR15QEsP4iN8bL5VcNcmfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5KGzWUWHgjyUj7nJdCweMmnHCW7ar3Cu0ajlToJueY=;
 b=Suj2C4wQnKy+NZiwfbT/1O2/PFNeUUYgU2S9KNfCl3FtURZyh1R5YByZy1K5pt5sU6E4wGQIVrUIgp9atwNGewtJcV5mNFKDhTct32yoqCdlQAYymJhiQ8oOb7sOQ1dA+PhlRgLvsBAMZHmvfI4LBYSJk5Fh7iLg87a15M00vjs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4402.namprd10.prod.outlook.com
 (2603:10b6:303:99::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 11:22:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Thu, 18 Nov 2021
 11:22:39 +0000
Date:   Thu, 18 Nov 2021 14:22:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] ptp: ocp: Fix a couple NULL vs IS_ERR() checks
Message-ID: <20211118112211.GF1147@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Thu, 18 Nov 2021 11:22:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfad2c83-839b-4192-575e-08d9aa85bad0
X-MS-TrafficTypeDiagnostic: CO1PR10MB4402:
X-Microsoft-Antispam-PRVS: <CO1PR10MB44022C04DA9AAEE8630AC8D18E9B9@CO1PR10MB4402.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vscRoYur5IiFEbFghxFHqdU9dN3bgmV2XOoHF2GuGS4edzo3W65g0L5S654z0Pyek+zJMP/MUqGvMV73TY98PwNZ+BwTgNOflWgzFnUbBur/1fjyUxksg23OzZKx4sJuxdaBI95dX2SqfNM6BYTF9JX08xC+GsUdGgsmebKuzh/2HT3+SpqUdF8XPoclbLhTpBzEH2yGI4CaCRfrEzNUD3iYjW7t5Q1fliy5mu7zHyFTmDQR01Vaqih/yqPN3T/tr/b6kmzqFDU+fGCUf6n0TNu7Es8UXgszaa/MCG2F9FMMJJbMCKnfCq8CpIoxa56XAUidKon2xz7saJh8XhI26yFMFjH1/rvW/5r/8PlZfd7esHa6GUCF2XAY0q/aq09zufCoGZGab2SoQKMecPm0Mz2s6HY13wEE08eBM+dC7MqXyXAJpTcMMXLvwoGN+/3f5CZnQZqPOC/4tQQ+VBIB/zlDH3hSQ4iq9ep4gFie21LV87/MgObNFNc8p9yUl3hCDCfyfOGrt0pGOTkSwDSMv1BtPkRTKKWSXcgRay8rgNBBd2bOt9wYx7mDwEWnPYg0pv5peCS2eNqMDDioyXmGvESqjrnTLDZDeJcWViILE+CuBFa6Zi7Z+odP8UlPRdUA5XWHM7vkxNR7Hj9kWkNhAHwpgPTkdrhmfEIWdHISczOTdm5mkpiq5wQ9+nHo3i/xJkVvuka2IreFOBpyHm7DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(33716001)(1076003)(186003)(8676002)(508600001)(52116002)(44832011)(86362001)(316002)(6496006)(66556008)(66946007)(66476007)(38100700002)(956004)(55016002)(9686003)(5660300002)(4744005)(6666004)(33656002)(38350700002)(9576002)(83380400001)(110136005)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c3AkgMAtCkNJl556Cw6OYykAQxm7JxcRUCtcw0qh1coi17UBAJ3KZrpuQP/4?=
 =?us-ascii?Q?qRHuB0ad8BWXzuXowi8GzMXNmksSsmZyIoIo2P2pF0y/vDbp6u3VkZvGNy3n?=
 =?us-ascii?Q?+7xRVJ2FRS9eMhX9BgEnYEGgLvHFrHWg/jaYctj2WJP8zQVqz4H8pCakyXem?=
 =?us-ascii?Q?VcNLzCWeT4DBmakTIV4Tud5amVsoT79JPdg2KssLQ7u3ekjijkFo+OvoGeCb?=
 =?us-ascii?Q?TE8b5uilLQrDnsTCfdzUXDSzbKz/UIYNJkHwqKKJWNKQteFnVc7GNf5ISG4p?=
 =?us-ascii?Q?kQVygII5nWw8dwm8HZ7GXtYF88dq32qDXemsHIay+ZcHam3LENjwLyn+HZ6/?=
 =?us-ascii?Q?ZueOpxp/eYtHP46YbKuHcQK1Ao8krVolc7dpaiBUgvRdmCVcYj0GNGKm5JJm?=
 =?us-ascii?Q?A7sAiS7G1FPJi18e08zeYjgCPSNG42apLKK6ekG2bs4CGTstqUJrFOmNNJb5?=
 =?us-ascii?Q?VAP5Y33aNJPGx3M3BCY3gGGcvJsfjNSJUDOjAeLqmKoRY6kCYf4z9eSvyQJe?=
 =?us-ascii?Q?bIgYSuLWMxJxaFaCsssJTqL2alrV4snIVbmD6vV9VzvgxQTPNGmAFCCYCdTh?=
 =?us-ascii?Q?m/D8wmR/cEZCrNhacaFyHcjnKljiv1/lsQStoRaSc+URXVLK/WjftFdk5GDU?=
 =?us-ascii?Q?XK54ZOQJGAxemFGEfkDxpa/+yaoiI85wlC1+ktaXINlreZi6nJUY4yTc5WlV?=
 =?us-ascii?Q?/qn+Cy3PkoffRjb8dVv8r8XvenM13luAWwrsZAugqsKergZRE2KIZDsghI8S?=
 =?us-ascii?Q?HElzPETh0Ue1p0fCyNh89vJ8QNRD02mz4DVB38a39YH+vDf4Ds42tX96OM3G?=
 =?us-ascii?Q?7YGWEMExaCN63hzV7SygJ/A2zSiC/NJOAz3ry2SlajIoXVoUIKACpH+/lRjA?=
 =?us-ascii?Q?O8xKr+5YLdRYEXdGxAk1ORtH2vlqfpxTwF+RJtBnBjmZ9/h05+7FuflhLV4S?=
 =?us-ascii?Q?NQU41Pt7Fjp5D+3W1CWuFLFf/NOHuw9QXk8jJxyF6o5/oC/Z42OgMqSCjZBY?=
 =?us-ascii?Q?p1Cfo2dhmob8YwGBmcf64Oiyq952qEgIuYu+ZBlfgytfqWlYo9Gva7xurgIc?=
 =?us-ascii?Q?6FvN1v4jvpPcvnycir7NvGjM2TjfZtUHKNy4VHfVam90lo3muNYwFbRWyyHd?=
 =?us-ascii?Q?2z/J33YGt2vqqzCCEmvNk8I5qq05IZb9++KJTPPVHKaaXNOeQpEN3DD6ayKx?=
 =?us-ascii?Q?9YZU6KsDm7DXG65OYex0OT15Odo8LalJqDr2ioROguEBy3PyQ2LN0+XoKye6?=
 =?us-ascii?Q?/u45PJb0wgBybRqDEG4gxC1pgTtNsM/HDVOwbg4rfdeaOT5i45AKZr+uVNyZ?=
 =?us-ascii?Q?3w2VzqRPb6o3C/PxdEv7AT0518nKT0hlwY+cuA5iDan9u4N5Np6WGgvF+amy?=
 =?us-ascii?Q?pjGqoiULkaQCe4wKqsXzvQRVsD6p1MbjQj8gllESyiUXLZm6gmGaCwmDatQV?=
 =?us-ascii?Q?7yZM17L2g9pyqnbFC+1MVkj0UkachodA5XZ403+vI5YmJDmGzjyG31OOcFaT?=
 =?us-ascii?Q?i0DAP2C1QuvIaeg07wJS0MtnbLj3ETovGu9u97ivf7bmD2gwhkLtJi33y7Rj?=
 =?us-ascii?Q?2XHen6vlPw5PcbpSdw0bSjtTMUWvnsOVBqfdrG0qjYYZz4jtAZQYqeNjYs3X?=
 =?us-ascii?Q?eHiSCOSynpUyaIFBAhPodLbaUWXBdDADED8J3PfAhy7DtIw/r1u8A1VhcuIq?=
 =?us-ascii?Q?pxr6QrZdWTlA+sy0U4vqY6GppBA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfad2c83-839b-4192-575e-08d9aa85bad0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 11:22:39.6481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ueJclR+C+ZZ004cIdLAVh8fUglPW/tdpRIxdI/4sLAUogCbWPE2olFoK2KSNOzrYYxokHivuv9FbPPNZV+hI7loyAAjcINEoMOIb3xnSlbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4402
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180066
X-Proofpoint-GUID: wMGY11KLAxluiD52qxAZ2pJxLQJyLcCE
X-Proofpoint-ORIG-GUID: wMGY11KLAxluiD52qxAZ2pJxLQJyLcCE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ptp_ocp_get_mem() function does not return NULL, it returns error
pointers.

Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/ptp/ptp_ocp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 34f943c8c9fd..0f1b5a7d2a89 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1304,10 +1304,11 @@ ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r)
 	if (!ext)
 		return -ENOMEM;
 
-	err = -EINVAL;
 	ext->mem = ptp_ocp_get_mem(bp, r);
-	if (!ext->mem)
+	if (IS_ERR(ext->mem)) {
+		err = PTR_ERR(ext->mem);
 		goto out;
+	}
 
 	ext->bp = bp;
 	ext->info = r->extra;
@@ -1371,8 +1372,8 @@ ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r)
 	void __iomem *mem;
 
 	mem = ptp_ocp_get_mem(bp, r);
-	if (!mem)
-		return -EINVAL;
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
 
 	bp_assign_entry(bp, r, mem);
 
-- 
2.20.1

