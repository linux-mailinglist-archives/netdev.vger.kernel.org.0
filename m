Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBB844256A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 03:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhKBCGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:06:09 -0400
Received: from mail-eopbgr1310109.outbound.protection.outlook.com ([40.107.131.109]:50048
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229458AbhKBCGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 22:06:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbrmA0tquhr4/RXV/tuGiYqm92py/JS6dXYjXEEMjHNX+KcjaDFQ7MZ5gaERTuoktWKCq9hmKghHJkwMnCtUOg+FUIjDxW39bX5gfagMSuapUZFdO50lJmlnGXbPPTpQ800EHJdlPkVSzCSMtgsS85SCjhV6J/K343FOZ2AhmrChXtsAdbnXh/AYzhp2eHe6z3t7xEf7C5LT+xDmkQ1708r9kdYreb/z/svAOZEkhQK+inJ6s85X06M51AnRGdPfxTB4VgTkRGFTsX8d4yQEnALWOAjS+gvll99gwn53n8IC1K/wHtFYlZGVTEtAEwOtsr8jxFE/CqNutWYIJl/rpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=029kk31Ba58OHDXIrLOhSqxWX8qxcJEDNi6/updQWzU=;
 b=kNJWSt+s4joLisi0Ed9+Hh4hoS0XWekoE1riSc29ABidqwNSnc4g2hQ31I1ZCKkbJt9HAU0jQ8UVkJ89586QXqncf0crEJwr0d/cHJN2r1y3BTMgD/WinUDgTa/BeS3BDA7LqUnutD25d5Wsa2SuYpGjxljDZppWsJcsg7wTt2b8CT1tRoy7wjWNqxViNWCXVgRbJoH7DdQFdrhUbEkUvNmFuQmy79MxykOO4tXrDvO4sUMd29Leq3M3oPZMDn2SPiDaSAnx+9mwSbPyneWB0Q0q49MqbQ+u8VyHVFfeYBjQ+7ivE3K8PpEUOCpb30lRg+HlNgjXQNVp1ijV1HBHyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=029kk31Ba58OHDXIrLOhSqxWX8qxcJEDNi6/updQWzU=;
 b=h20u+dU/pzo/NPAZ8emb0f9nk7GzTMTPqr6+yc+bGnMQDtbRHv4BEcawnBbq075QLrq/xS4V09Gg4aw/uAEJW2EGoevPePoNKboFCBVq5nRl9B34Jb6qSZtj5Gd1TWA5/8/iTZWLvg/kpOP7/BDdEt7PaBdYhJShjf3+QnYxI3M=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2459.apcprd06.prod.outlook.com (2603:1096:4:66::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Tue, 2 Nov 2021 02:03:29 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 02:03:28 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jiabing.wan@qq.com, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] bnxt_en: avoid newline at end of message in NL_SET_ERR_MSG_MOD
Date:   Mon,  1 Nov 2021 22:03:12 -0400
Message-Id: <20211102020312.16567-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (218.213.202.190) by SG2PR02CA0123.apcprd02.prod.outlook.com (2603:1096:4:188::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 02:03:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adf0e9dd-d48f-457f-739b-08d99da4f610
X-MS-TrafficTypeDiagnostic: SG2PR06MB2459:
X-Microsoft-Antispam-PRVS: <SG2PR06MB245921658319EE126B10E85EAB8B9@SG2PR06MB2459.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8PqZq0slbBKy+YLforbmwoeWwLvVqGVHKuHTaAWi6W8aIICgH9t6h2oWdYgzv8Jhnu2hdqMYJC6tQbtkBQuy3mb5jLCNs0jhAkc/PwV7dAdIcPfH+bqQPq9MVVsYO62s+C4t/zOLligaXHxODRlDp9SLoQSn0EEXIubce+gcvr8MyqJznrO6smXl0a973D5t3RntbZVbHypVCxRbFy2AW+q+mn+3Ueh4X02nfaMXhUueDmEZTB0kUbidQua/Jdz5voMwAqslFt4YXfQXEVppzVIcuNRu8jcVacuOM9Ufb8oWw0YUHLUngP9iig4AyVxOnrxfvRbz6NW/u5yQRSUP9mT7pjIzBMV1bx66N9wfTfic+rgoSVaSAuVRE51Peo9nUDU3PmOTy8sThmAoC9rOyTY0KqHXBvBTftVCQnPHFcjzpSV3bC5BNSNStqKhO2h188U34Y4+JCmTV176JfKPNbGg5YkC5w5WOYHTXV7TgDsBmRd0+3gyMM0xSa+vgFH+bbrXIPgJq7aqzsHAddc8RrqPZ1Xxr+QAvAeGhPcrgmQ8MCDqSIaQwQVOGlBAMk2vPxSSt0c1YvI3lMVS8mlz74/ylAwzz3DPDZPAZJvl/molUCqsuuxq4CtWWagoC2vllBThIM0fy5LzuoPyks/diOxMtBC9O3/EW/rwHgTK0c93AfEmKZLybFqYTJzMGQQoeStVL7sBDCjbBkL2HBhAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(36756003)(508600001)(15650500001)(110136005)(52116002)(1076003)(4744005)(4326008)(83380400001)(38350700002)(38100700002)(6666004)(107886003)(8676002)(2906002)(6512007)(316002)(2616005)(186003)(66476007)(66556008)(6486002)(26005)(8936002)(66946007)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tEE2tU/F1a4ehVFwik2fnnmWncD9u2TEcVBC+GZltdAfymManO/+axwF/Qt6?=
 =?us-ascii?Q?7318GTtTzFxYQ35snnfLJopAd6U2gyAxUdj81MiQPqyWEBhXyBPMIkGLwJm7?=
 =?us-ascii?Q?octvdIVwTW3N6xzwVMar28VPvl+iewCbpaecbalvjKqurDPhC4HX1LMQmZlO?=
 =?us-ascii?Q?ALwQOlxSwkTSDZmMysxOEGsydZoh2qQXrsDXVSvf/P1ZNiryKpm3blVYOSyP?=
 =?us-ascii?Q?huMNqijDKpH2CWBRWCiFBO8EU7LT8kGMDXaQpgS2rlKH0aLgBXr+vY21hV6R?=
 =?us-ascii?Q?e4QZld0mJEnCQz+CMYVVx9kM67+in8bVjFbI/Hrt99LOhipQH75khHfAIEHi?=
 =?us-ascii?Q?zIc22Y33J+G4FyW43lJvwDGndyH8p3ZxAzpMuTa5i0FtwyNrNQ2sjwL52pdJ?=
 =?us-ascii?Q?bbZ3phUsnECZVZWWV+QeWTzx3gGw2vVFAQAC3eQlOvyLbjBpf5emqrOAkJ9/?=
 =?us-ascii?Q?maGwdSp1+4UBvfX7o3MzISFXDlZrDdz3pjY+Ne4DpFZJztOi1Dy0qkt3EWxV?=
 =?us-ascii?Q?1WNjff3qYuhan33216rK5aZiJseP0H5SNKrlXyVrDI+N7r4G4Oy7AM9lUFN+?=
 =?us-ascii?Q?s6RQMelIGcmY17RMPkZokVIO7pI2/szvo7XtteYynMvF+s1v8x/z2yiRqdMG?=
 =?us-ascii?Q?0tqKvSOi+t+sgfxO+RzejgjPETq3DGvcwt+/bs4lSAa5S161FN/B9MoXS//k?=
 =?us-ascii?Q?zBHwd2CrWpdtrpqFYbnkVAlKNJzdHlvkokvsP5ycCCVvsPGDtdxjY3jLnWTz?=
 =?us-ascii?Q?mfi+A/eVPU69Ap7lq5Khgn9hdQ08NHAU1kmGLSDRCyxID8KDkOjMsdijMB5p?=
 =?us-ascii?Q?coXK2+UXiAczkFlhnIXgPHiKoEZp3/34NpqqdtVFS0WwGsd9tyjyKSJSFeH5?=
 =?us-ascii?Q?IWfNzbdyxN7cmlD74spwDRsRivS8g1WY97Cn9MaTsXNChEfZ+ZQFQrC6iRRE?=
 =?us-ascii?Q?5B57ZlyU/IcHssoi1LoVddFooypAczT2lhR/YhUxVLstUVQFyUBmFibM7b4j?=
 =?us-ascii?Q?ApeHAeP8DjR6FQc+e64J+6Jq1fGedWzKXQJTUplt1jbc6WAPCzQPtQSArvRR?=
 =?us-ascii?Q?ATQvCnCqL8enqae90tW5WvBppCRqncQCwwWK12hfkTaS16hhsmy/znuEdZjs?=
 =?us-ascii?Q?iu0TP29aiZPlGLIPQ5c+oKrElAEKNf5jpyrzkmKWAdlsEQVzARFM/5nDfYo6?=
 =?us-ascii?Q?fsJ1Zh6TVuRMlvjAP29Tfugmq1CeXWfoJ7EBtLnfXleedOBHGsta96ub9QQ6?=
 =?us-ascii?Q?VvLP8S3r8aa+w3DPbFgK4P3F9XCnOXjNw39pGR6qko/53cpEisgi7HqfXAPE?=
 =?us-ascii?Q?qoT3L9lqzlZbWZo968w4S4he1OnOedQ8lB21ahn0t9ekYzIgQPAQRZz87ASa?=
 =?us-ascii?Q?FJG8LU10ppSrj/0DTWCQX48XF600MaBaiF+g61/CtSFQplaocdg3EkWSbaZr?=
 =?us-ascii?Q?Yh7410yolP/EYdciE4cOCW9e7448/axfEoUfRW2U2PWS3O9P+aClFW6Dojta?=
 =?us-ascii?Q?arcB4esfNiSGSuLa9m/knNiGFOktotJy+57mLziaQebFiH6APDbFSGjhsm8I?=
 =?us-ascii?Q?unNhxS/rhOplp4XoLPVYzitkVk9VDkgmLCOxnz39fqxl9B//XL0VteKkn6JW?=
 =?us-ascii?Q?k9vmmEI8QGKF2Xe4AMV1IyQ=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf0e9dd-d48f-457f-739b-08d99da4f610
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 02:03:28.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cz20yu12Sc3L6aB3wgmhjUx2p6l1dBCsv+fKnWRYu0r2fJ5UAr+6jmNAM9+Kxp7MU8VSAieHH1sL6yo5RYbFgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c:446:8-56: WARNING
avoid newline at end of message in NL_SET_ERR_MSG_MOD.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index ce790e9b45c3..5c464ea73576 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -443,7 +443,7 @@ static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT: {
 		if (BNXT_PF(bp) && bp->pf.active_vfs) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "reload is unsupported when VFs are allocated\n");
+					   "reload is unsupported when VFs are allocated");
 			return -EOPNOTSUPP;
 		}
 		rtnl_lock();
-- 
2.20.1

