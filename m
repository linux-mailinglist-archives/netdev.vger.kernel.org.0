Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5011F40DBE1
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbhIPN4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:56:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64640 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237820AbhIPN4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:56:44 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GDhssU031045;
        Thu, 16 Sep 2021 13:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=pZXGNZ3mOtEcJxo05PY8o4KapNueSfCsIvH2QwFbtQA=;
 b=FQ0vL11KZwZOxKEmXnEJu3pL64SiR0X4aprAKZWos58x/t0lZDovdr2GEdNfcYyD7CtN
 rah0GGXz9VQ6LtUQvunltDXNTn9siekm1HxOQ2iUFss1r+eBzmnZB2n9in3z7DaPDTy3
 oiolex85nrpE+vwh00mjtrY3V2zo4bXXEGKqlM/jNSgsibmIVbrL3DomCeZR+6Up4vUl
 kpcw7pMFiagQrwuQRGNx7TjCLaek91tQpXuQ4JDT2iEJSIpT5tMeauYmFaeb3VmWkS/z
 Dmj+ikUu9a7SA79vGtn4heSFVY0tS35e1mH6IW6wsQ3FK8l/T9PDEWLN8d5u7Au/PAvs WA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=pZXGNZ3mOtEcJxo05PY8o4KapNueSfCsIvH2QwFbtQA=;
 b=fR/8RLD2IY8fSObsNplGgtQGDmI0fWjSubO+yIYcZVLhXA63SeUA+Zsvi603DJs9W9eo
 rhfiUeS7Wmsl0OFK8YLlGwxW3wtp0Bqd3zmO0autSTLRFsl04w5CVCTWX5Brs5EdEA9b
 tyEY4W2rdMyWtj0l4jfGgaNQam9FnIef0fdg/tuPEMGRv2xBsGzv53dUDzFs/ahOlmlI
 HoJGjuBpeSHtsejVQXieTThcBw0agxN/R2w/zwyGRpNpl57IiN7DcjD6DnC5kLFG7AdU
 5N3zr4PR2tdc+ht17Kl/A/BK8EcmhH5YlXSydF0ViCC2yFJHWQ9MDIXJPTkLIv7rIIGy 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnht7ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:54:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GDogJn035123;
        Thu, 16 Sep 2021 13:54:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3020.oracle.com with ESMTP id 3b0m99cdbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MP3PHk/QO6hSHsOZfxxDDzvwdSAn2niC+LhRhvCAXoAotgkTF6wXy1rGNcJSS5qzL0b4L7IFRUgmexRwdTsgOMrNN1/+b4dCrdVuleFyEPtkayhvbTGQfSLJJrmPg9vgMZqWMSGn6iy+a8LX6NJnRhmj5NkjEq8cQirgJD0H+GIHByq5oHk/Z/kgEZWBT0F+ah9sYj8b+fAgNpbtrTXT4RmWfcCecQXs7FVCOnZpglg5DgcG4KAC4Ck2W0yls8T1aCnQghS9B0ISr/SLQtO1TFPwN9y6Xn8OmnLlV3N3eZmy0X0ITXEFpxWr+qaSmkR6wbaSOLdpQ6IXaZgGpCj+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pZXGNZ3mOtEcJxo05PY8o4KapNueSfCsIvH2QwFbtQA=;
 b=b8vFXkRJ4Fog7hqejyFEmgfhS59snWr/+t71U7ILNgM6EgIC19gIMSiYfTFkw7vJzJ/qiiZIXauOCbOKMfiUaM/rjlU0/2XylOwXYMFMHYKe6wjwJYBylIQYkL+UOYpIQTfwVMX0r1ELz6GXNmZiqaKXlDwHstTLMhA867XWkVPGuMvwhtIBaZuagq5LOhGuvxCOhavuhrULO54hnm/Ip3YLPYgUesRxu2zbmH31Gn+uiVIPZDUhHEGu4XEGUC4761yVLqQweYUyi0r+fLZGxdj7WMYx1X9brzVlmbgrzSqNaU3sfpK+M2Lc50FvX8B+zkp/GYPTKpbkb4wiMfSGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZXGNZ3mOtEcJxo05PY8o4KapNueSfCsIvH2QwFbtQA=;
 b=h+BUFfsc7Wmi3kBiznnXshx/Nv1L13CPe8GdO4Ynjb0QUIR5RegHf2n6YM3L0+QlOd6KMpd8+9GKSD0dOgmcJxUV2xXPNK7CrfM3eRUNRraKdjclhcssWJI+Wmanf5TuNuoazgSvwC4woVsGydS8vdiFBdxiFwoclt1F+MJmo6U=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4642.namprd10.prod.outlook.com
 (2603:10b6:303:6f::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 13:54:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 13:54:26 +0000
Date:   Thu, 16 Sep 2021 16:54:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] qede: cleanup printing in qede_log_probe()
Message-ID: <20210916135415.GH25094@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 13:54:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9551aa7-fd85-41cc-7240-08d979197f1b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4642:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4642D1221DC959BECE336C968EDC9@CO1PR10MB4642.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xWvgwC+HOxOAEcKAIaDyjRVermqMJUkZaMsNz9VUnpcuG/h8H1xrG6bb1d32Ekrhbm8g/5oOLvdXipB0xJRKIIAXEKu7fsmyUIRJZf0PTpd3WskuKLPQdCHPkwUWIKh8VHBkccMUOqX20B+Cyl26i7LNAYOplM3E8AqGFyKKDOUN85eRE115ypQuAkYQ428ZDKjjtsNW7kUilhoLzJJvdxYBMeAwSO20WDt1chyScPCNSP+qW+B8fhPd55PuQLL22WKXsGd9wYLQa63atufVE+Ad5UOk/13nNAeYfxtWDPt+PIMqv3yNXu0Puz7zhzs0oMMTEDcQ8DojgMkqrFfVeHkk9oTx4a1NIqT6tKwPbjvixp6jkvwJPph3+QjzawWQ0iZTpfkr3x3Hm7jNJKQS1mx3jdHasDzhNstAm6Z8Chr/nGMmikWw43fBdbws17FpTsLCQq/qRLL+ZIEnOIpe1ajNmHiIRHgFyQ/MttYXdD8jV5WdVduYjqOUaByZ73UBafbw8j4L2qztppCBjOqatGKt58cyoF0pws2ohJvegnnFM1j4NT5YgHXwFT4ZQrS4Z9Fk3VyxxJNrZhREdUOe9HeiKr+hH557KxVa/vwJgO8th+bd6dapC0GaJJdqTawnZ59XSL34g84asMzJHdUjXhLcP0t1/CWUn3M0gg6zA+D1qiayJrvEvT+AUbJu0mHIDEQYZszdDiCSduEs8w4AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(66556008)(26005)(5660300002)(6666004)(38350700002)(2906002)(66476007)(66946007)(44832011)(33656002)(6496006)(956004)(54906003)(508600001)(86362001)(316002)(52116002)(8676002)(33716001)(6916009)(9576002)(83380400001)(8936002)(186003)(9686003)(4326008)(1076003)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cE3Wi6N3KPSvZirQZaZuCwn6GZ2UcYhD7+g1DQFo4DRQqAecB7ceVuGA6mMe?=
 =?us-ascii?Q?WU4knYYEWov3iK7FJrWRtfaEG65zY3qjNNm/QkgnWUhjQqkvBmCT9fgQN6B/?=
 =?us-ascii?Q?mQeaUMQSp0RzP2BUUKD5P/yQZ8Xq+Vjyxpeae8zkou3VhyIkeQteiw9baqe6?=
 =?us-ascii?Q?HgNsAOP+LKFJRicpHObQYAT1nz1XNm1+p0NvaYKw3Fba0wRfMO2FWQX+pGDh?=
 =?us-ascii?Q?aen03OUzeU3bxOWCFivSFR1FowR+TbQUwukQHOMA0E9p3EIQiSGjhz0tcgdt?=
 =?us-ascii?Q?lK3DvXUuJVW6Canz4QDwFJkee+WJgeysxDr+KeoNrVn6SWbwNsx7M1c1eBpd?=
 =?us-ascii?Q?4nPeLdJ6RDG3ftTsTmrvnMQccklD54y28MLyI2+2YcmWwG3P+iw1arSPKbN9?=
 =?us-ascii?Q?iJc3L+s0pi/MSAPAON0ZBLaCVHDqUAXplJvb6Tqe+gHAuMQFvzG9dJx0u8c2?=
 =?us-ascii?Q?t7w8HNgDGGzyBwjWe9/ueiIVdxhGwh9CSn6FrL8Ra968BhS1e+GDJxd1ik6v?=
 =?us-ascii?Q?hT8OIVKoagPH/ETqqWep7MidpIDc8E0dDCAtwVQMH0Oi9VVNEHKf61EJZCT4?=
 =?us-ascii?Q?KfBksQFS6CIL3Ax+sgeXakWjwJSRwJe/tcT33JHTJnjFFSwTp/cp3fOoXY5r?=
 =?us-ascii?Q?ABkEOpQl4hw8U7hTY4t5i+zNlhGSjd4CgPF8PHikTVcLbyJoUFxFpFUHX4Cg?=
 =?us-ascii?Q?LpXjTdHAZhu90/hrvmkEuprimjpSEXOAW1gRwJsB0UmF8C4VheqjGLBEvrlH?=
 =?us-ascii?Q?Z+salvrqtvFygmEmATxgdwbLXilu2H6t8O4NyY1MOw0ACSwCfJ/XB3WxzEWf?=
 =?us-ascii?Q?3hjAiBCtzm45E0CEBAlyk55gcVqE6+pfbRnD6JdLiVleIDlRUyMwfFMEF1JX?=
 =?us-ascii?Q?tNfEhvHAr4vitTW2lh+TZKksi0mqqThMCtDIXs/sHY+onnRBejqXpqYN62dq?=
 =?us-ascii?Q?o9VZ8KjDqdXoUWurPJeVS8nMgL13Y/lgS5XCxmc4zJgHNtYOY/3yRAWKaAyq?=
 =?us-ascii?Q?nWYm6EaL6qzCOSSstKo8jmObTzPfPgXmojHEfzHyZ870JvqHxLqANf8/fkgD?=
 =?us-ascii?Q?ULDKuQaTx20nV6o0G8NfE7KjzEC56KsZndDA7Lw41c3AIE93aQHqtsDwwU5o?=
 =?us-ascii?Q?v6hpmLCgSuBouGln1mhjDanmitFzqKKZt4uUIsHhYPRI/GAIXtxVe6SbbuVO?=
 =?us-ascii?Q?fAdu8csCmN8PkjuoO6kxcOqZNplyGS0Lns+/FdtvxCcLXCCS8LYCZ8whBF/E?=
 =?us-ascii?Q?hpdN//8+0HppOxZ7brVe1DHTfvEvtXrqa8U4Zy4ZRpo42npcRohaqJHjoVtd?=
 =?us-ascii?Q?aTBXJUo4Jo4RnwyDVx1C+KWj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9551aa7-fd85-41cc-7240-08d979197f1b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 13:54:26.4313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykdUP+qEKPQFsgWfTelpw/nqKGyIf7P3f6NqFmZdjyfg4lHqvY8VPG1VZ6vUBy1ZrksVo3f+RyFgq/4rGZhWpJichlxJsufjKiPRrnbR2JQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4642
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10109 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160089
X-Proofpoint-GUID: F5gM3S39GHlBPCKthbe-5dipFU-ffHdq
X-Proofpoint-ORIG-GUID: F5gM3S39GHlBPCKthbe-5dipFU-ffHdq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code use strlen(buf) to find the number of characters printed.
That's sort of ugly and unnecessary because we can just use the
return from scnprintf() instead.

Also since strlen() does not count the NUL terminator, that means
"QEDE_FW_VER_STR_SIZE - strlen(buf)" is never going to be zero so
that condition can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9837bdb89cd4..e188ff5277a5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1087,9 +1087,9 @@ static void qede_log_probe(struct qede_dev *edev)
 {
 	struct qed_dev_info *p_dev_info = &edev->dev_info.common;
 	u8 buf[QEDE_FW_VER_STR_SIZE];
-	size_t left_size;
+	int off;
 
-	snprintf(buf, QEDE_FW_VER_STR_SIZE,
+	off = scnprintf(buf, QEDE_FW_VER_STR_SIZE,
 		 "Storm FW %d.%d.%d.%d, Management FW %d.%d.%d.%d",
 		 p_dev_info->fw_major, p_dev_info->fw_minor, p_dev_info->fw_rev,
 		 p_dev_info->fw_eng,
@@ -1102,9 +1102,8 @@ static void qede_log_probe(struct qede_dev *edev)
 		 (p_dev_info->mfw_rev & QED_MFW_VERSION_0_MASK) >>
 		 QED_MFW_VERSION_0_OFFSET);
 
-	left_size = QEDE_FW_VER_STR_SIZE - strlen(buf);
-	if (p_dev_info->mbi_version && left_size)
-		snprintf(buf + strlen(buf), left_size,
+	if (p_dev_info->mbi_version)
+		off += scnprintf(buf + off, sizeof(buf) - off,
 			 " [MBI %d.%d.%d]",
 			 (p_dev_info->mbi_version & QED_MBI_VERSION_2_MASK) >>
 			 QED_MBI_VERSION_2_OFFSET,
-- 
2.20.1

