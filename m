Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C3B40005B
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhICNUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 09:20:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7272 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235147AbhICNUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 09:20:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183DFQvf025471;
        Fri, 3 Sep 2021 13:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=aNa6euGKbbzFotGoHeMBqUvi/nPAsR4hNMgxIo0D/wM=;
 b=d8IqEUfkjAtYTCUm3JqQp/fkAlpwGsznggGHm4i7J34MLipeUKzeuabqZIfS41pTRktf
 RsYDKOQ87aVuSYhzhptX8Bf/yETEOQMKiztK7RaXlgTLfKWZg/CKQ4v2alSHI8a3HdhL
 wmlN86n8yKehf5aP1fJPxJLa+QawXdD6NBsAV2d2MK3/MaXGDthJs2ClUU74ZpCW4tfX
 ZFRm+oORvSXbybcvt232mC0bsyfEFQSe0/Qc7Ul7xf5gWXRhh2PeBAJSVsnTj41drQPR
 nLYoqJTKTnOmdH09FLt5Cxo0SSGWhIOsrVAoHFjtn9LYA9CQFk0VrgUvCyR1qUA2NSvi 2w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=aNa6euGKbbzFotGoHeMBqUvi/nPAsR4hNMgxIo0D/wM=;
 b=MxO+ZROp993KiffIEpXpbqMwdHFLl8u1d+RoleXqbMjg+jUV/BeGgINLaD5erT7DIvTd
 dYfeAVFBSbFg8AwLWChwFqE/m5uUtPzqwQ3KH1CloQzYbpizZmGpczhjsgJLyUzLqZlc
 SSDgts9iuDyK6Xq64eoil0eVdAad2OvWN1BcubNFHLEM1bh2YIOGaNf4ZNsOgFqyepUJ
 9q/Uj/GBAWGEiT8LBm9B0tiEym624Dh7WrgvGjQXy/q3QIWh6DoKv8F7KInlXut2Kxi9
 fLrhGoJga9amWT0D2PmpAmR/sQyAZSDfwUA//9SW5Pl+l/H5Ba+tvk8DDxBQA2zRusMe GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aug2prsy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 13:19:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183DA0ei179491;
        Fri, 3 Sep 2021 13:19:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 3ate01j2hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 13:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrQANQlE/aPLUQi84MubAgsKNZUKbLCPbySGZ8ksjchQeGBFTIrZbEeUGlW/46t8fPEXwPyGhm+X5nh9rWISm9UmxwhGzoOnqrdBq+uVB5tGXYVwpn/OFJMeDhRp/UtCvwFm72cVVdrHmqCMKU44fWLER+mgnkgUcNZLw50NLJ3FKJBsyhu0Y83KCFG6x1UluinkvToCsGfl/Ma7/S1Zp2oM49uZUaCunfsSu5iRa07X3BW1gNWRBHRdP2udJIgKLKDmkrXfAdTP5seWEvB6fx9oHydUxr50Wc+nIv+T9m0Hj1FfoHFRcI4PpYcqnf+KRD/UQAEezgEWuOcJWfoNfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aNa6euGKbbzFotGoHeMBqUvi/nPAsR4hNMgxIo0D/wM=;
 b=l+HNE8ORxkRuq6iWKKtn/xi0jpFF7DWsm2A3u0SYf7Imm3NXzpw+TpEm381z/ZIfDV69tUD+sClZ5Udgo3vMhcwueewK+wYxH0BAlE0WsTvj4ysJsm3CllqjZy0sb370ouZodhA7tP9FgilH7XAF/eY9L6xsCUuhwZF4U1KClK7gP12Ph7Bq4OgefaLvT9SoxI1pOPYKtBnIs1f9fkBYVLA+cP4WM4N13vJDEXh98gP83aKSaWldLeCJNet8vuhcKZx9SK3WkmtQtEhuLROGme9FKeO3+JoViMpfXie+7TEf4RTB/HRBD/YCPIQarDDBiTpjHtmOaIYXlnQ+N/AQPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNa6euGKbbzFotGoHeMBqUvi/nPAsR4hNMgxIo0D/wM=;
 b=f06YCIFo+vgIJN1HzyuKEqEPTFwWq/c5sfDYGTqwsd3CDlFS3ea+tYTE90ARjxB8h06PTxLH5Wn/FK3H8ajajNgakyYSSjt6Z6s5Z4YIsb1YbFqqHWFayjXMx8LANf4z6VWhLnSLq/g8BBTP6aJAXOWooHDBtRxICD76cbe/HMg=
Authentication-Results: pensando.io; dkim=none (message not signed)
 header.d=none;pensando.io; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1422.namprd10.prod.outlook.com
 (2603:10b6:300:22::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Fri, 3 Sep
 2021 13:19:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 13:19:43 +0000
Date:   Fri, 3 Sep 2021 16:18:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     drivers@pensando.io, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Hubbe <allenbh@pensando.io>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ionic: fix a sleeping in atomic bug
Message-ID: <20210903131856.GA25934@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO4P123CA0066.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::17) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (2a02:6900:8208:1848::11d1) by LO4P123CA0066.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:153::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 13:19:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c711c616-9ca4-44cc-1a64-08d96edd7e2a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB142251347485C20174FF91CC8ECF9@MWHPR10MB1422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qqDRhM3ssNW87HCucVxS6KodbGV8FOhHaI8wVZdboNadbvi6vZoAhbvbvGjfIjDPcUt6Htw7vMwiBh76ohphidm9KMNOfctgHHBED9P3xDKbWBzVMHqtYQOXdxxM9Z6NgJ5Au37mDpb+/G+H2XlZcw5SdAkq8T6wNhn3Z2wzDkTjtlSZNZPae19FheYhSTrMfQxGxn9Dzqv1KXBE7dmG0z4oPrkhHrRVBFDkjCGcn+xKE05CF+vRyGrDAQypM9SEGCcYxwFC1AdgTJPiMywjXySIewMfMcX5TKcm3GB7JJy4IyIvEUnANIUFOGddLqzZuiSZFNd5urA+bUVzpDYJIYdOylw/mx0F9wLmf6RqEMEFtj4CF5lZMqyiiaMid+Pl3I1RiXMNv1wUXP10u4WCmtIUUXSNNAD7gc0oyaNri1yv4VkVtS0C11gHJgpeDRaCY5eo1I69bNPGX3MUAtLHudLN4X6uk/JQzSqSepyiKbDLGGwXQ+Z7wg9nTXSlFl2pUlMKzltG7b9+HTmk1cLyRRIWYkBGs8J+PQ4L5oTntqU6Rw5uv2gugBL0BjqmgrSR51gpH2a/eBpnKwMl5uMJqJ9FnsIGR6cArVyo8N8fJon5Llv5FBCA0BLNljiHHV3plA1IJ1eNh49/ht4Odj+Zbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(396003)(346002)(136003)(316002)(33656002)(83380400001)(33716001)(2906002)(86362001)(4744005)(54906003)(4326008)(8676002)(186003)(6666004)(6916009)(1076003)(38100700002)(44832011)(9686003)(66476007)(8936002)(66556008)(66946007)(52116002)(5660300002)(6496006)(55016002)(478600001)(9576002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AsaG6SltaGsRrHVhb9bLcgCiPJCWxkTH/CWSkrXJaQaCCzX67xcn4s6nhwqi?=
 =?us-ascii?Q?Ax4Uc1gKR/9cWveiDWoQxnpFBBgiUvJk2EXo9qPYYqWcm7MDjSiJxiy5ma+K?=
 =?us-ascii?Q?tC2PKr4xGxOI8zgzZWxrhwxciZZHB9WghxW+FDftmhhV4fX6aoxwierWHOhh?=
 =?us-ascii?Q?9SAw0Qx72g4ncDtJVrJ9KPNRFx0lEXaO85LGLek67x4gDMWe4CS7KCyE2anR?=
 =?us-ascii?Q?Pv3bRYa4b4AO51SjLoaV9OYJYyr5JT+EJtCtQz7z0GhAnR5fFfpEUBTk9TYt?=
 =?us-ascii?Q?kWw88GGXB2OtRdOg7DcacvRX1XETbI6tnh0c9KYshJLkm3tLfkEOlxkKIgxI?=
 =?us-ascii?Q?cl5QQBKga3dcLpvRltHC2iH+HKmSuRk14nU0AqWphLzLWZvmc0Ee5ZsunxPQ?=
 =?us-ascii?Q?8kc8nDvAmGHVsBso4tND+SGjEafgua85NfaLNzDsAaNj8oBBPYN75nEnsbHC?=
 =?us-ascii?Q?TPodqWRsqBJwtcTjtxtaT+U5+BhsWBce6R0hidxhVVAmdqxyx0TdLXGSL8w+?=
 =?us-ascii?Q?51LDy5VHYmMOeylIwClf6ZLC2OhW2a4XQUilwiC2Tb2A02QlG/otnGcsD0TG?=
 =?us-ascii?Q?NG4ViGIMN4PE/uRtiQcqRpNZrS7YzqTfkpPI3Uw8zwNgfIFTn8KppMZTivmX?=
 =?us-ascii?Q?MYW49d/OnLZd2NrgExYJ8EdUqizrFwa2iRxVZuR4nJcSjzun5uHAJD2+sQ15?=
 =?us-ascii?Q?rvNTaaQ+8e88HgA99FmUilIDRTev2uoEho9lo5ggqO4UWKTDlivHDGbgif2d?=
 =?us-ascii?Q?0ZH6wMNQ+KzFkSIca/UY+WSvpS2LB0jjPPIwGODLpd8BPvsHLx1PdG3Kw4Tx?=
 =?us-ascii?Q?5RJ71lp6hJNBYGIC3RGC2qLhsLpdrAk8yBErBxpcbxpmK2mPv/wzucACSOFK?=
 =?us-ascii?Q?/O+E4VOgzgFYw5unqEltmmKSUqvWf/5Zw1RHkY5801hRpBm6x4KjhaM2mKz9?=
 =?us-ascii?Q?pVfSsm2MYqavVjgBSrj5kFrQcHT8nNzIERuVG2nFRVm90FHybZg69Xg7JkUG?=
 =?us-ascii?Q?gGIkoHXB53//yKTVWx1ybgnprUciaSe7jDetus0JhOb+IbLkJ3yVRxdnLQUV?=
 =?us-ascii?Q?wbWFWGa0Y4v5Erys0wmeyFIPAJwxOiUlmLV+yPTqef8UCbYwsDfxKcx3g7KD?=
 =?us-ascii?Q?LveQZIzWAAtseosV/wgCWmpfJxqIjYVwJeRkzYSLzwUvr2AxH1f+laJBJua1?=
 =?us-ascii?Q?DABcI6Q6jvywGhDzs2tg24NpxlvH+QEYFnI9uOFEswOguqQzNemvxZ8+9qG+?=
 =?us-ascii?Q?oMPh4oCi/E3SXVZuEpSsFuLM2wCK3NPbXuTOsYZ+3txF1rAydFbVLWclas0b?=
 =?us-ascii?Q?/zc8JGRccuRM1oX0kONyZyZSajIvNKzLzFz0NiIIRjxDHdtjkSW11os22q5X?=
 =?us-ascii?Q?woByw9w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c711c616-9ca4-44cc-1a64-08d96edd7e2a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 13:19:43.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnzuhLQMHrndbW31aTlvyukqLBz4Zhe5OPqIqSpCtLjKAr3uQVH3g2pr9ITmQHMryR3Gnv85ASdirlzbL+B5dAkShweLEo12ebbt8WmfpmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030082
X-Proofpoint-ORIG-GUID: vjlmfXKm-kpezCap6zNtooUrCJ-6j_I2
X-Proofpoint-GUID: vjlmfXKm-kpezCap6zNtooUrCJ-6j_I2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is holding spin_lock_bh(&lif->rx_filters.lock); so the
allocation needs to be atomic.

Fixes: 969f84394604 ("ionic: sync the filters in the work task")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 7e3a5634c161..25ecfcfa1281 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -318,7 +318,7 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 			if (f->state == IONIC_FILTER_STATE_NEW ||
 			    f->state == IONIC_FILTER_STATE_OLD) {
 				sync_item = devm_kzalloc(dev, sizeof(*sync_item),
-							 GFP_KERNEL);
+							 GFP_ATOMIC);
 				if (!sync_item)
 					goto loop_out;
 
-- 
2.20.1

