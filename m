Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7F24541EC
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhKQHiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 02:38:18 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42780 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231718AbhKQHiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 02:38:17 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH6SVI4031226;
        Wed, 17 Nov 2021 07:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=w7ekLP/nryKi3MBXqaCNGG51DEbvG41yV76wgK6uhHY=;
 b=jMO3qDQmHf8bwe5VAiV53xH4qffWhnho7cUZ0C46/6l/w4sAzCL/LqVtkl6fYIQy2Lsw
 mht67AvAcw8lXUgMMWj/qEwpn5K4qV8lWaw7+2SV8EBxiCgjYw3Z5J8uTqW4LkUm3Je2
 q+i6loQAUfjGtaoPfFMj6xjhwPoUG7v+59TxhMVWVTn7T2N/vXE8RXzSFznFDcJcADQY
 QlsNRBcuzUveEyXAzofbEGXuj3MBNVgiUiNVTFHvAfkgO7+l6zxaYbGE8EFYkizpxFsZ
 VAITh8n20L6bJEO0EFlHF+PbH0kDs2wu4ZpcUlfBirgZfKLTysG7FiLj3r2/7kaJYEAW ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv8793d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 07:35:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH7Kfsa084595;
        Wed, 17 Nov 2021 07:35:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3ca566k6yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 07:35:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U20xZCmWU2kE/ecbgV03Cr23uGuT1F9IDmTZVn6KUoI9uxGHrbiwywEpOB2Lvp3pOIjHLUvjpC/4keXSmopkyYEzrQ7AseZZKBtYPrv7O6RphApIpMnvfbvG1PERnTAqN1OuIHnegK7waqFqWKxktKWNEVeTqSFBCOK6ym+XMixEPu8y0K7ZFszFqykBrPgaEBr8rhG8d2++4eZQwWG6CvJFX+pXxJzzWCgQmR9PdXMToikAIj5uz+k4T7x8ypgv5/9JkHWJL0j/1oq4TQqJtz/x5DJ65rHPRfOqckBYd9wq6SyoJ6RNpdrgMfz0F8GJC+vKxa03kj4KLfEpkkv0BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7ekLP/nryKi3MBXqaCNGG51DEbvG41yV76wgK6uhHY=;
 b=LDWThhP4metNAx2JdLUWnjn6iICBkqcLW5WTO+GHqT63Tj+OzRVUd2JYWdtZeWHifiN/k8+E8/3EDnaXv0IxB9fazif/rKpox3jEeAdDgjNxQtF+fGbjQj4I4p3RX6XiDCd0PQ481JjJbdtXj7OBZEHBopOv6qwliycQNRRYC0DkKvp55J3o571pupNL8eKdTDX9BmggKVY0WeTPdNbXHTJNSj2gEnGFnhTAUAgM8i+YnVd1c7CHqdi0q1zSHlAHEXmdIeqCFdjQJ4INH+ehtpBi3DeOU1DAqrs/05NV78hmPGACCFZCdMespDJN9NZQY2H/rBmaLK8V08gtZ8jX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7ekLP/nryKi3MBXqaCNGG51DEbvG41yV76wgK6uhHY=;
 b=F4hpKsvW13m+iTDrGWIeOsEvy97EZRnNr2+nwH67m5sql/mVfaFcbEXrQDtkVtNEyuC/veB2G2MCFCmIDZI2E6LNfpkVEfzLUWVcZJE9zEd8Ezd7MUzkmt/IzMF6Tk4QD0PJYiG6QRwp+KlnvK1Z9Vd+l+m5iJWqUG49/quOf/c=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1885.namprd10.prod.outlook.com
 (2603:10b6:300:10a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 07:35:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 17 Nov 2021
 07:35:11 +0000
Date:   Wed, 17 Nov 2021 10:34:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Harman Kalra <hkalra@marvell.com>
Cc:     Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bhaskara Budiredla <bbudiredla@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-af: debugfs: don't corrupt user memory
Message-ID: <20211117073454.GD5237@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0105.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0105.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 07:35:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62be5122-3d85-4aaa-684e-08d9a99cc9d8
X-MS-TrafficTypeDiagnostic: MWHPR10MB1885:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1885BB478860E67D9486BE3D8E9A9@MWHPR10MB1885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiBV2wyENPZPIHa9l8qi0N7JyUlvE+3wX1FFud86tcp0vAVC8FqE4A7GESz3avx2rxVVWJpDhRRUKzjdcOYYD0aWt8hRqR7bXZCSYEbbVsEPPNMJcKMWH+jyxyB8/ed95eHY2YGlFnkL6CQE6rCNJVYkDT9s+YBbV6m7dKRrEPpDlWTZ5ZIiIbd+M8ty9IbmIsLB+eSLRP5O/3rnkMYqTI2InBh2WWCAQphqT4M6IwOzSgefLQ9KN2CTs+a3L6SoFebB1R0U0miYF7TQUwsZDKQD6Q/h63YtasobVJBW7jE/+NeyNKZOs53A3VVlBLNIJ9X2wJHLTffCMDps3Mn5VJ7YOYmRamQHYkd3aTn+uxBjCMWcS3I8PYcEk80TId74Bif7vMv6AxiwDDtohmi+ZkuR2kCGF1yT3u/4FG49edQlYjgJRJwg+7obW4F6AS//l+0JKy6P9W+htIlRmcvYNBo9Zt2W958jwS0cUEnYA+P3+eCvymAmVaQzlXWct9bKwln7lhGpNgrlYMo2hJcNR3xw0+QA5ow9147HSQBlQjDBReeTkWe5Oz1Fx+hU2+Y/8F70YpNAJjNH3/uQZGLu9QYjI3T7RZatSTROLoLeepbzCK/g0ox2dEgDM1+TIAFDbRC+JmerLhFPB1qbVPmGjd1dSHxTdz/WJ1KifgpBlEg4xjHLyN1KHFDsAGzFHrZS2L1VS0uMrH05km6x2A+w4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6496006)(52116002)(86362001)(6666004)(33656002)(110136005)(38100700002)(2906002)(5660300002)(54906003)(38350700002)(7416002)(1076003)(4326008)(186003)(9576002)(83380400001)(956004)(8936002)(55016002)(508600001)(9686003)(8676002)(44832011)(316002)(33716001)(66946007)(66476007)(66556008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CGunPYue8jb5OwcZREDMUP8lgkMajePw4TxxsRjfc472otlJU1K/rYerfDSZ?=
 =?us-ascii?Q?Ve4HdnqqG7rOgP2PN95LxOcirLYVdKsuoAQS90dHaP12QGbjeb3vc7k6AMCX?=
 =?us-ascii?Q?dMgB/ND8dGp+Ky3AXOY0ZY/rGAM6t4zeLeB4kolnmMGKrAmdOUWGsbBM2hp9?=
 =?us-ascii?Q?xe60ldYpchYAihIcNSu7k86AW8m9+ZPjVuzCF8L8GFuDSW34GNGAOh42fWUs?=
 =?us-ascii?Q?38Kw/KE/FQori2GlBkPZuGQDfC0Ha4HrOL72PtN6sXk7Mx502/Wjd8jHYaLZ?=
 =?us-ascii?Q?VRVsdBdq2ggQsqIAGyTkNfYbzRJSYKeb9/t0z/s3ULB0YC/TYW5YO18LmR52?=
 =?us-ascii?Q?ah+gW0H59Myh3QCPRbGVaQyOTwQhwx5Whto75SX6PUI2j16qAEeBENqmcl6a?=
 =?us-ascii?Q?tpv7W7+xJaPI2W6Juj6A8aYOOebf+HBTsqn5NtO/d8cq9A7w3W+/vApJ15bE?=
 =?us-ascii?Q?OInxIntGuOax9cwahzPezSd6bihextVAP6dQzQ0miZybNP7AWzl1i5G8mnZb?=
 =?us-ascii?Q?1IbT3+ObnG1CQteSFe54JRlOVuJqX2om6MMyw9JqOhIhnW2lefAHfviAFxaG?=
 =?us-ascii?Q?ErdNY3dxouX84zDGITKfxcDp+isSBlvyJyszSdPuJSCoNuT81PUWibJ0CpxP?=
 =?us-ascii?Q?2wHsowA2xSclE+5IEm/+cnKnF6y042DqAr4iVj8yaetVkTaAsX5jtEQIXmKC?=
 =?us-ascii?Q?yw7ScYaXnpnumpIJNeh22NEziKwOcAkucV9FLz3xO0xfhYhkV7TR6/LwyRNx?=
 =?us-ascii?Q?eOon+zqgrIhYRpAv9bC7WawdOaRLyJFpnbFE99dYoTwVuE0ySn+zXkY+AukG?=
 =?us-ascii?Q?I8tLWOVTw9oZIBJJgaNc/LfvPyVRmsKiHqOAkqG3Vwbw7ZjSoA1T6M7uQqoY?=
 =?us-ascii?Q?LmozfBsqZ8ECUQ9XcY45XbAYwbTf/zPIBLLaTCxu2HjUjDfNXmSVB8oNUP8X?=
 =?us-ascii?Q?7eg93VydCW/qFVRdb9P8ZiCg7H6Z9XJ7ENPmtvIU2XSjhqbxHPJsNQtHlCWz?=
 =?us-ascii?Q?1I6qBddkVSdONYBSk/Jo0ajVFxs9OAgP2Iz9J2/5ggpu210DZXea1GjBX90w?=
 =?us-ascii?Q?6EyV869/tjpBf8yM+xFT4yN1wXC5YYltknpqar/cgsLPL6sN1vqAvrtVVUom?=
 =?us-ascii?Q?uNxTaS1dcD2KTWAiRSthuAXZP+Tqb3DEiBm02Vj3FVAqvOKqwNqcCv79XQR9?=
 =?us-ascii?Q?fjQq/TlBJZHBSqsAOE5KO4oSql2GZmGSbqZ/0gVFzi+gce7LdDAJXJoGNcmd?=
 =?us-ascii?Q?84mpTSrP8ui120nrbjdpQL3qu1IOIA2eD2WzusYR2Miw6EW7q4XsdVAxhZX2?=
 =?us-ascii?Q?hcmnMjI5TvSpPCqUhkFwb7pOXeqFEfR6uYQOA1lDXeHT1bhWJwQ8BpDQ5Hn2?=
 =?us-ascii?Q?6BPIZORtZYS6Hmg16ZV5w+aSX3B1dC5pkG15GUK/3jBAYtpp8N24eGtkD5cZ?=
 =?us-ascii?Q?U8bXVQCXbH2t0sJfPCudvHfUlb7P/+C9JRyFpOWnY9ItKbm8CvRPNjRTLtbX?=
 =?us-ascii?Q?Ixy1y5VJJUWG8z3BuAHAhAWs3VMrwerwAqFs7dy+WLzf6QpAyf1ecPOWgRjn?=
 =?us-ascii?Q?9USccONYx1s5qHHQKcakNX2TTCQMHKjWz83pS/KsRW9bhp9a4seC2Lb3GhE3?=
 =?us-ascii?Q?xxh8jD5JQlTNca4ew5DMrcDXTbD36qyyzLo7qu6n+n8w4Mjkh4RftIQex8F9?=
 =?us-ascii?Q?voGNklLX3QG1+/0GxGxzWLDQMio=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62be5122-3d85-4aaa-684e-08d9a99cc9d8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 07:35:11.7770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azXYZOhZps5GFF+pRlZEQw/z1zAfxQKxvg3+wykb1SZvZBR5MV8565SKBZceyJh4PWzUFfnTDeCDbJeoiJc9pr1nYcQ8arE8DPogUPZjnDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1885
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170034
X-Proofpoint-GUID: U82UlPR-qsYrqsdwaLNkF075N8G_J2dG
X-Proofpoint-ORIG-GUID: U82UlPR-qsYrqsdwaLNkF075N8G_J2dG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user supplies the "count" value to say how big its read buffer is.
The rvu_dbg_lmtst_map_table_display() function does not take the "count"
into account but instead just copies the whole table, potentially
corrupting the user's data.

Introduce the "ret" variable to store how many bytes we can copy.  Also
I changed the type of "off" to size_t to make using min() simpler.

Fixes: 0daa55d033b0 ("octeontx2-af: cn10k: debugfs for dumping LMTST map table")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index c7fd466a0efd..a09a507369ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -236,10 +236,11 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 	u64 lmt_addr, val, tbl_base;
 	int pf, vf, num_vfs, hw_vfs;
 	void __iomem *lmt_map_base;
-	int index = 0, off = 0;
-	int bytes_not_copied;
 	int buf_size = 10240;
+	size_t off = 0;
+	int index = 0;
 	char *buf;
+	int ret;
 
 	/* don't allow partial reads */
 	if (*ppos != 0)
@@ -303,15 +304,17 @@ static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
 	}
 	off +=	scnprintf(&buf[off], buf_size - 1 - off, "\n");
 
-	bytes_not_copied = copy_to_user(buffer, buf, off);
+	ret = min(off, count);
+	if (copy_to_user(buffer, buf, ret))
+		ret = -EFAULT;
 	kfree(buf);
 
 	iounmap(lmt_map_base);
-	if (bytes_not_copied)
-		return -EFAULT;
+	if (ret < 0)
+		return ret;
 
-	*ppos = off;
-	return off;
+	*ppos = ret;
+	return ret;
 }
 
 RVU_DEBUG_FOPS(lmtst_map_table, lmtst_map_table_display, NULL);
-- 
2.20.1

