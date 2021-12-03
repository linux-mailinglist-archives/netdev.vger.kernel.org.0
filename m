Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53DB467476
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351346AbhLCKHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:07:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48640 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350895AbhLCKHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:07:04 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B38iSZN025635;
        Fri, 3 Dec 2021 10:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=f1IgcxWKB8jf0BwJ1JeTfFj8TvQl897DMhf+fGWlNFY=;
 b=QvnWNlBzLyjMhh+ab7lMZkj9zLzCd1+bTs1syYus5ej1hMT7zyV3E7fgRLOmr4VD1Z5j
 snPKHasrXoblUrXxsOveBxeahMVw9szgzywNLLiaFhsvYhW8T+3P13cB2DdmkOl5ISj6
 yoF7QLKioDhNrAxESOTDCl7ANOq+bi6KVVWzA00kXxFyxSN6ZCbQ/jE7j+rDzBEsBDfX
 awYRC16TnsD3dVJQcxZCyf97x+jLHGyEYpHGIJP4VhJz1SpIGwP7YwlCjkgyk0Yas5eM
 Ehl6mEQFbtfIVqD5he+g3W88v/69Cy+RCbExPAz1ZuilyO0HyKis3FoEJzj3q0DUSYGZ gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cpasyw7cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 10:03:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B39uRkt148994;
        Fri, 3 Dec 2021 10:03:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3cke4w0qk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 10:03:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVZOtdG+jPWXc45b5+kOmzGJcg2fl3wWeiEH19l4+xryYXVOdy5F1oaoRO8Ls8tC8vaDwi7ZkkBPim2hn8rK42cl66JHyrhT2bH3xjM1fY458x42gjQHKyEmcseAPGLnJEC+QZZAULn41na2K51SXVOLJEH2ib0Ee8jHzmhtEegjLwxxJlHvvYJQSrCtXOx5Gk7XJFngCAnd8+m1am/xc20QpkeWiTShaq2SDCsb/pt/iDxD40Km3ytpYekIHVCWWYc2mCsEU8uJYCpVLNjyh4bIonI0wkuQVp1MWZcz4W5CxKp6562hxolYoyrdbYriuDfO3GlkiNK2pKZ1Pi7p6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1IgcxWKB8jf0BwJ1JeTfFj8TvQl897DMhf+fGWlNFY=;
 b=QF7mSTXsfM8+6Oq5GNFbSsmFkt9DqLyKzbmmypnvQam87M8dlAhNkBA/LP/Ux6V6M6MRPz6ukwSPTMfA2uNLfw7xF9JAw2/BW+CuS/PDKOxYgXAjZTA7g+769KM8GBs/SjF8XhFTObzPfQcqohdcKzuyc1k44e5akHLnTgKo5ccnvSkLqa2SUbZRquOIAT+WnkPuHKAPePmxZxuHBa/W6NoiA9VtKHvMm7SNWJRvqPOCxX4dhHLqCSIiy78UUxLQH8WlAGmdS4vrowWLVg4oVVDcKhIvOGBjAGAFg97ZwA7NEPlspXITml3OXi0tTUxVJbhxGyMbX0MySrABEqlGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1IgcxWKB8jf0BwJ1JeTfFj8TvQl897DMhf+fGWlNFY=;
 b=c6hPxE2XIt9kgk0EmBGxd/mI7l3HGYAqVM6gkLCYIvijS8NyJG26uDwhveqIaEvwFcGC55n8sh616ouQSNFeFwbhuVjf3UAXCSY18tmAx9DO3vK9i85UPoYrdPGzwANirGMZrM4u9gh4F78MdiMh30XPZd9+f6J+pIjx3ZRy17w=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5677.namprd10.prod.outlook.com
 (2603:10b6:303:18b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 10:03:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.027; Fri, 3 Dec 2021
 10:03:14 +0000
Date:   Fri, 3 Dec 2021 13:03:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     GR-Linux-NIC-Dev@marvell.com, Ron Mercer <ron.mercer@qlogic.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/qla3xxx: fix an error code in ql_adapter_up()
Message-ID: <20211203100300.GF2480@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0130.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0130.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 3 Dec 2021 10:03:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd72984d-4fd9-40f1-05aa-08d9b6441f31
X-MS-TrafficTypeDiagnostic: MW4PR10MB5677:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5677821F26C2AB62323312C18E6A9@MW4PR10MB5677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Tw6oxU7T6IiCpaOLurZ0DypUOCSrfU/v88k9/l9BkyTFJTB32nKbIR1qbDZWOqCCUE3DtjGn1lHDkyhTYjo5q+k/T1YhgmCOi4HD74MlPQGTAtiucC2YOpUMbC8rn6o4/RiSRzIi9Bx1oOxfBlwby22bLSQPEKzsTtA3QEi1gE1zCKvCuATyk0Qe1jITlL9S0IaZGyRkTCdYQmoXNGEr0XtfCdfG5izqHPcATzWNxLeSiYrOXWAvENGs99zOJVfdlZH7w/KXOQ1Qu309g3XV9LkuaIVeOLCdReRz9LA78SB2hliA3uDSeu2t/Qd1FRqs6dmT9NcoXj9XcFn08UmcnJW0roCV0zUICeiwvTxmp1NV85UnGZXVQJ0w66y61/obHy8rVHqYbjvKinNcWWhs2VRHTwCYuFx0VxgA9Oecm26je1wsI7b3scwUz5nWB1vL/UeZyz4/f3A5+OCjBWtf+EqbZEh76Z3lJaF7LZTZJc1kNhgjkPqSAvSl3oOcxkK7ayVG91ylmyyzUEFsxfX//iJKLL3k3IN1oAqytslnSlpQi3Qe9grlbKNwwE0QHYIH3zqcVzhyVe64KqWiS6X4jmKZ94A06y8ti9uPUjCOD7lLN11wF0MoCk9KAwpK7A3fy9FAC9ZaTLeqCUKwf0YRxNu8p5wckxvSNnz+IYQODCs+MxgJBFNcLV92vauUaEq1zi2WuDXoEAFXoac/3T8EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(26005)(86362001)(9686003)(8936002)(55016003)(4326008)(66556008)(6666004)(52116002)(66946007)(9576002)(2906002)(38350700002)(33656002)(44832011)(33716001)(186003)(38100700002)(316002)(54906003)(6496006)(6916009)(956004)(66476007)(1076003)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qc5jSTs/H2yPalJbmCfCg1EYZiI6JRcvJlfc0mtw6Bb2Il/c+DSc9OND5lY2?=
 =?us-ascii?Q?nGqFEYttGaNGKdPq2kavdlKB6WyE1Yas+CpPMCp/VT7aIAM2d0On+6+apXZB?=
 =?us-ascii?Q?OAkpiW7uFb57apEY+zcyAP+yT7R+6cQB154FScDDbx+xQgZcDFOcCYk2/Whs?=
 =?us-ascii?Q?kKIX1w36ztw/d9sxZzronWs7BKG2PaoBofBAlOK1pbyDLbXvz5hIkaP5UqV3?=
 =?us-ascii?Q?f5El17SY3/28cbt9VPgtX9wXC9bKQOF7tFuH8yTOR2GH3GQLnAikhinmhKzl?=
 =?us-ascii?Q?MDmETT31cb8DcIOHoAjrtoBBC87ozyp53K+snFAPk5FZADGGYdIMy8xwJxbm?=
 =?us-ascii?Q?H75PuvAqx0IheaUii07jHOB9ntaYFD8bsGE/5Qq+HTKdXRfD8f0wYqMnNaSm?=
 =?us-ascii?Q?piwerY4tI1VV1SrGorZPjhKsw7CfgWsMHboPJwfdMIUucMomGJFAsnEELJYe?=
 =?us-ascii?Q?qdNuBLSfJZtHKPRXXHVOajjDkORbZNRkvdy6u9jVSbKp+LMmk2NemqFclFtK?=
 =?us-ascii?Q?MvQcCHTGBPkcT+wQDaBjRHepdHa0PV7UiVZ2R6kDx70c7zNA+H+YYOSJ6mhZ?=
 =?us-ascii?Q?a9GuN4L/zGuxFsAHLm5ClMeOVExkB2WiXj6Kl7IpmeBZNLePHTcqR/K/9c3d?=
 =?us-ascii?Q?CnQvB7678r4GJtN5j7RlVfus2QaloLz5L2s+gmBN21ycmv3dag+y68ammslW?=
 =?us-ascii?Q?sxo7dsExd/7IPQyuNcBHzEwR2DlSwKd1lKY4+cKTl8V4q9hq+gC4OWOffDDB?=
 =?us-ascii?Q?BmDbyL+ORDcFymIWXtaf9NvbdP4D5Uosn0lm6w7ixTWLdQa/Rk/MR63BLstu?=
 =?us-ascii?Q?Ho2Z6X4pA9rRQnRFAj+ECExg4DDiTW26JDelw3Kd2UzXy0sh18PsEz0kEOr3?=
 =?us-ascii?Q?eyY/79jM2ox98uwaWuoy4tff1bhb9ezD6YvewEIOO2NYdchQ2jAqBMej8Lul?=
 =?us-ascii?Q?BDyCN/b3bgdWhtUTriREEIvgHjhmJ/Q+i9hNA4vB9pyOXA7jrKYPQfrGAUG6?=
 =?us-ascii?Q?WK8IJEJdSBP3Zlr8corH/lYZqD77xCOhN16ylZBgcUNmc4AUbpybf08JTDX1?=
 =?us-ascii?Q?CzjOVsTY03arhg6tGxdPxdEm47oE2w5Iq0pbnKUu26uijaWVr/CPjYd9TzAw?=
 =?us-ascii?Q?qdDH6RoiWA/q6jGAP8KaKi9cNgJ7fVgZSMOIA5yCEkZYnPr03j7kBil2pXr2?=
 =?us-ascii?Q?5GDxlzee1FuZl4OHrlfERm40k6tFSv1ivBBKoVO1WN+rVTOC2ZFVHAH4K0H6?=
 =?us-ascii?Q?dDfPtN2sg9fEyy7vUziGawCXPQVTV3c+hFoUHwi+Eo4q4qt3wkVIaRlejOor?=
 =?us-ascii?Q?w04UnT9BjJAm77mq5RD6MkFIUdt7TKh49cU6sKGEG90ky92Sslo9iH6j17W/?=
 =?us-ascii?Q?3gkByV88pPHj1HHGqnmcLESNjrdBRUyCg/acIUkUhs9xep/PcS2cy1NRDlps?=
 =?us-ascii?Q?sWHh9G65fVFQGFWSBTuPJsU3GBRIo+HUINHoWx1PU1+Ir6TjBHuoLi4HTaY2?=
 =?us-ascii?Q?SrGiTNmzST2dG85QAmsKT1wfarhBkH3wj9zkbl5BuYhVnTwg1PC2zofoPJF5?=
 =?us-ascii?Q?Tl0tVGcHewD3uNk7wCw0b7b3HXr77pfrcicG/sUGOtrVjsfhS1VEgTepGbfV?=
 =?us-ascii?Q?eT1drXvyWLrnK+h19Kb/eVg6viKSZpdfiaVmbpcveFopW0cMU3MdJXWqlqrj?=
 =?us-ascii?Q?1Mr71g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd72984d-4fd9-40f1-05aa-08d9b6441f31
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 10:03:14.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnVgAg4b6zCHV2rbtZstV/0Nz/ssuRo/NwB9ZxOve6RW63AIy1n8fIwo5LPK9Q6sFQ1tJJGgBtM1mcBsOIne7Ch4VPNaQF2+XMOtSRxM5/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030062
X-Proofpoint-GUID: PZ5gEMW6-UFLsCzWn6-UNL19Q8mYpM8C
X-Proofpoint-ORIG-GUID: PZ5gEMW6-UFLsCzWn6-UNL19Q8mYpM8C
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ql_wait_for_drvr_lock() fails and returns false, then this
function should return an error code instead of returning success.

Fixes: 5a4faa873782 ("[PATCH net-next] qla3xxx NIC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 1e6d72adfe43..0642cc27094b 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3480,20 +3480,20 @@ static int ql_adapter_up(struct ql3_adapter *qdev)
 
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 
-	err = ql_wait_for_drvr_lock(qdev);
-	if (err) {
-		err = ql_adapter_initialize(qdev);
-		if (err) {
-			netdev_err(ndev, "Unable to initialize adapter\n");
-			goto err_init;
-		}
-		netdev_err(ndev, "Releasing driver lock\n");
-		ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
-	} else {
+	if (!ql_wait_for_drvr_lock(qdev)) {
 		netdev_err(ndev, "Could not acquire driver lock\n");
+		err = -ENODEV;
 		goto err_lock;
 	}
 
+	err = ql_adapter_initialize(qdev);
+	if (err) {
+		netdev_err(ndev, "Unable to initialize adapter\n");
+		goto err_init;
+	}
+	netdev_err(ndev, "Releasing driver lock\n");
+	ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
+
 	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 
 	set_bit(QL_ADAPTER_UP, &qdev->flags);
-- 
2.20.1

