Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C452F4DD579
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiCRHtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiCRHs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:48:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1852BAE66;
        Fri, 18 Mar 2022 00:47:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22I3fwYi028916;
        Fri, 18 Mar 2022 07:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Y8q6JY4S6Qh3NaqbQUkDnemYNyHiC4YeH5ke7mbgvtM=;
 b=u+/D0c/kbxNRvlh3puLAWdqw7cve50uq76W0K9WSsiOLbdIlgS7GV1FYXLdxF2hRCFyY
 fR8YHME7yG6fjcPGJWZfZ8iD0fvX4Z18qmQm4n8etknk/KBxIfDxWFlWpc6kcGwXBZTB
 CwJKtaQvbSv6I4U4QrNPRnyabGHykQfcIyWPswVhH7eZ+B89ZKi6GDlhmcLR7d1A8O6u
 SCBv67KzzPlh3GG3L5Gtp7T/jCLUva2auoPkm4N4BHgWjX9nAnP803vwKvCKBKl9snVO
 aywUJwiNNGRERwUxMykcPTzM7fvGCjXPQQjzKt6YtOcTIkaB1fVeXmrO4HqWbQoSSX/c Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5xwtyds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 07:47:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22I7g8A5099704;
        Fri, 18 Mar 2022 07:47:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3et64mq2v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 07:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYcuhMyNytAsICvDxKZHY7jZnh3sd9iT8Q/gFeGZBk76K34x2FcbkIB3Zscmc6jJUdI1b7N3JpXUPASvHR2OWWcL192Mzatc7uuwk95O/UBS1WugfG6vnqIwV+tgi3YK/tDiluIaE1yxl7BDTjmpL2u66JUs76ncy60IDlQAwq18VwTrk96gMy4MJfow+BqqjutB4MdXIgMKElcOFTo8NI8nB+pLUr8zQKCDoOIdPNFBfoXZvm92J0I/R3nJM0PLO1g9rbZjAkhWZZDd8FAm0p3n4WtUF6ETfkqEKkmtLG8Qj86jIzAd6UhU4M/lTaIt699r7hyZ1Mb9i07pYHKUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8q6JY4S6Qh3NaqbQUkDnemYNyHiC4YeH5ke7mbgvtM=;
 b=S03sadvx3MGPG5IKY3o1FOVT3tAxq1SfYlMkd06EtMP7AlsZXUnpNZBFWHJNwcAf/PzyV7MbYqmVZiW/yJW/aCQaWBV8piCas2wf+AMPhFfQzeEgQ2YsyzAzDZhWPh+ZuFcWuz5gZDQ2XPEnk0DWT8eRnu/Ku1SS1V5FDq+OY56rXejCSIKWHEEMe66nL+AyWbSbwUAeg47SskOmhH4+JQJL8RfDBZlo4J/f1s6qqAUGw5xnaqHX4lXhrnc0k5u5m/DvO42s35uBQCH0BWSpe+sIgG/DKmB+JLPiZYZ/uZLoa3MN6V71JsUgcqVYcw++yB6o6LPLgsQQavUpDqclFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8q6JY4S6Qh3NaqbQUkDnemYNyHiC4YeH5ke7mbgvtM=;
 b=lXpvdi4aRUNFGJUd+FWehHhxzAhIT96Ywwnn6BqmWr4U5V+2xJatIhJjaDOX0OWda/is9PJeLh9BgE9NMbIQKfEZW7+DdjLF1Y/GOf5Cr4jlTn4eQn2LQgC99uaZmkAKKf3LuXboewE8i/JhW0DHwynKclJPuZluRr0OBIWHSRM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1836.namprd10.prod.outlook.com
 (2603:10b6:3:10c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 07:47:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 07:47:34 +0000
Date:   Fri, 18 Mar 2022 10:47:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net-next] ptp: ocp: use snprintf() in ptp_ocp_verify()
Message-ID: <20220318074723.GA6617@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0153.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb317f4-f3ce-4dcb-89f0-08da08b390a6
X-MS-TrafficTypeDiagnostic: DM5PR10MB1836:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB18361791C9B8474A761601AA8E139@DM5PR10MB1836.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+2MNUdapkOtXN2lrrbG/7tTDRLHI1Szyj/d90ikp/yS3dqCNioQfCI+olnHWsJg3CV/v6in/ThGRrsCENiFaUK6NWiYm+OEUzRJSFGVcQovfkpnoRV5VHvw7SLulV3QXmiOrbAEv1W7EttLZ/TzOlZlRWalNF2yiIa0DYri29F8YvlYtWkfSv+VN3tz11FSMkfit5tKa5z25HmbLhDvyLYPHTlJbgHHqY3IQcmXW002KSGFa9UX6a5C5atN/coSu3WeaLrWqpsgSxbZmJk5wgZMwDsEe1JvraOkd5/2mSY0lnTJZlbHCuIvT/tUStkViOiHXkFb7LwB3OMcUhYxfFwrHFmpAAza5e9r1B+abkjL2fQr31nrLryWaSAeoGyx9stiDM9UTy+rTKN/82/20AfmTUmSfVOQmbLt+pr97IxzEcxeH9FF2r5OVPZhEuF53XzHPIMXv/6uFx1mLgKVzRWpa9fr0hDxdTmsDqeOudaCCCVkyuqn2CRGH7VLuvuPDLleuqujt/ELpWu2YeK7Q/tusBrsEM1fwQjFb/tk3mtNIhISSrqsH1xI4OUOjPiu5RBciByuCahtODTsgAUY3Ly8X3gsNyrgfh9HJdBP2kSqBoGHUBbPG3hxzUX5gAV8vORT0ca5mF6x+WwvAqmWMi1tq0yraOsMPD8Ve+ovejW4O/h3vHWUycZEKntpwxMVrcfzyoziRkzMbqONFOV18w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(316002)(8936002)(66556008)(66476007)(8676002)(66946007)(4326008)(38100700002)(83380400001)(2906002)(6916009)(5660300002)(44832011)(508600001)(6666004)(6506007)(52116002)(33716001)(33656002)(9686003)(6512007)(186003)(86362001)(26005)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JIbWzxwcs4FR6FCXtVtsrCwp3vDQSHDk3WZ97/FcLY/+yoQC0OzCTqLtGl33?=
 =?us-ascii?Q?HFiho/o4qcTyLoRyrbF2ZNUoz3Ubwqs2/r9lHx4e7aJAD9hUsh5WDIIDZs2d?=
 =?us-ascii?Q?ib0Q5i/UHzGxklbJXqtaC96lPEevBOpsPigP8t9zmCzflxv+vApJ04kfk2jJ?=
 =?us-ascii?Q?5vcF31qaIECY0OAmMe8NjZ279dD8JJEB3cZreOtbtZ7p3yErSUzFI/XpKNg2?=
 =?us-ascii?Q?n4w16itl6glp6lJNvoiVhR1JXzpn2KcmOtdFE+aLFY0TdSb0naqLU00KwX5L?=
 =?us-ascii?Q?DLcTBYnSk1mK6qY5i3917JHZm+YIsVRm0G24WJaEQbZTQW3CmjQd6yx1E4ee?=
 =?us-ascii?Q?jTv55E4qiNqNAS3V4XIZApQXgIHZV2qVRX8onA4kvoEnoxWpmmFZi/z1/Ij6?=
 =?us-ascii?Q?NEvBmwqHfpzMxE3lSJC4Ayhi+I8+J0kJnspiw4BBmbp7F1jObsgSDLsT/WDV?=
 =?us-ascii?Q?IyJ+43P5EC4u2l6rrF3xeBhTgxWWM6hQBKVeoAgEfVOJG3yU63AIr6TOj2z/?=
 =?us-ascii?Q?gxd8Mn7wz4FCbOUfZH8ZhMm3MtT4obzc8riDPPLXbsIf6rTZG48OYMlzA9Su?=
 =?us-ascii?Q?ljCALdj6QL1g3DBR0n4BIf4VTzypV9f9I7T7KZT3B8tqX867MpahNq17frCE?=
 =?us-ascii?Q?OBvZL4w1H8aRkX8NFUBCXwZLnXT55qdHwxcI1NWHw/++FnGNPux1QfSv3vGi?=
 =?us-ascii?Q?arvxx11Yjk/MZVH0QSWFGHRuJZmZpxEMRz9gBp5nSkSSnRpEA5U7eG5wQflq?=
 =?us-ascii?Q?dZwMbcTolae603HkWpf8w8fkLUZiMKbI6c1JBigRA44pKD3NzMJAwqQD5TWn?=
 =?us-ascii?Q?GRp6O6Cypdy1HcyTkyVNR3o10xD7tV3He5FETqg0RaU2OIy23QjLCZ9Rgj51?=
 =?us-ascii?Q?VAi2/UOVRaQVbhc1HfED7XWuBMxSfKGzU0X+UVnz+0DwnODBM3JNnN9Pbg4/?=
 =?us-ascii?Q?mfNm9pvPsM9uuiMXBXHRjtF+KN70kDVWEnkis1oEDs/oOBQKoePSLb2XjFdj?=
 =?us-ascii?Q?Eh29jPZwa2hJSFrd2hidP/OVKYHCmCf+rKAFm+VHTRBboQNGcQ44vyeCDvtU?=
 =?us-ascii?Q?f9HQ2RDhOqQyoV2tfqAmG+hwSYJPC9yV0UgYgilUrn5R298hrSdbIOALuQj+?=
 =?us-ascii?Q?bVZ38i7fT3l0vjx+SBqelea1596ICz1pLg1fONlpCPKflakFfLtwm8K7pkji?=
 =?us-ascii?Q?ZwrdVo2tvdaYnrdV9Tdnu0fnP9iZmAKMmX2+FXIrjwgd/WMC9zN9TJio9Buv?=
 =?us-ascii?Q?urmtJH6NSA5dKvJpN8pXLQb9prrvyl1VTOwAw9vXDslL/NeKoNxXMIuXfkYp?=
 =?us-ascii?Q?8SO4hiEXbu2N1IK34oka8bp9bqMc2413fNlzu7cR9hGrfORUxnaBIWhAeeYg?=
 =?us-ascii?Q?pwvrQf9t08p9z4d4XnJf0YHKjfyMNymmrIyi8YKL/YO91EcnPBTQSnC3Um0O?=
 =?us-ascii?Q?KTdb8wYww4Iz/oRMZkpu1DweVS68RtEOL+6GSqUk9eAT8ISifOD62w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb317f4-f3ce-4dcb-89f0-08da08b390a6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 07:47:34.6597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCOV+ETO0WRwEJ0FbakhmO4FOVTtmJqIKifWgoDvxi128bs7ZI4ZBzAUvHoc9pj9nYl769rJ4ccDUCzHyCEbI5YPubcnO5n5gxbrV2tqgck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1836
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180040
X-Proofpoint-GUID: RfwAmRV6OMiKW_9Ap9dQKfQ8mWqtv6YJ
X-Proofpoint-ORIG-GUID: RfwAmRV6OMiKW_9Ap9dQKfQ8mWqtv6YJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is fine, but it's easier to review if we use snprintf()
instead of sprintf().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: re-spin the patch based on the latest tree.  It turns out that the
code is not buggy so don't make the buffer larger and don't add a Fixes
tag.

 drivers/ptp/ptp_ocp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d64a1ce5f5bc..c3d0fcf609e3 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -972,7 +972,7 @@ ptp_ocp_verify(struct ptp_clock_info *ptp_info, unsigned pin,
 
 	switch (func) {
 	case PTP_PF_NONE:
-		sprintf(buf, "IN: None");
+		snprintf(buf, sizeof(buf), "IN: None");
 		break;
 	case PTP_PF_EXTTS:
 		/* Allow timestamps, but require sysfs configuration. */
@@ -982,9 +982,9 @@ ptp_ocp_verify(struct ptp_clock_info *ptp_info, unsigned pin,
 		 * channels 1..4 are the frequency generators.
 		 */
 		if (chan)
-			sprintf(buf, "OUT: GEN%d", chan);
+			snprintf(buf, sizeof(buf), "OUT: GEN%d", chan);
 		else
-			sprintf(buf, "OUT: PHC");
+			snprintf(buf, sizeof(buf), "OUT: PHC");
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.20.1

