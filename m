Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9929C4380AA
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhJVXfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:35:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31398 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhJVXfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 19:35:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MNSYs3021619;
        Fri, 22 Oct 2021 23:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=j35yrGam9kFx0sdQF8/EFufTO4tusW7M53d8jmIisWA=;
 b=IvZQZdtndduAd0PzmigXCxRMbizg0GV5oP01cE/LzjAHm8DWY4j7+/KT3RSooPSOAorv
 vEpX+G1W7ATJLf02yU003TZTHVpLfs6/6/h5YFYNxUrIjgvbTyuk7+cZZ6VW0t2TVo19
 TXCxepc8rhX13pLp3aKaHYPWS7aUWZ2+DAuuMHXLz+sJNiqwnA4FCf0NpIdAWO006o7w
 POkz/EPimshJteH3+TMoerGwjTwDFwVI5dTpH/rscLL1KPYBg5FIHKyHGXHQDiCAfbIT
 bMNHfvB5TNbacRzy3/me1xmh+4hTxvlug+QE0VgwHBlSkyMKbwoHA8mf4wtSUo5ly2YV YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3buta8bw02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 23:33:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MNFhJX151851;
        Fri, 22 Oct 2021 23:33:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 3br8gyp8bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 23:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2NWfRL0USTVixHYA/fEQOZY78iCFuiQixcOOmyVJh0ww4RnLv9xRnxDPNfqE7OsqyecHm+fWIYLCaNmFFdBazaCVjVm3BffNK8ErXBLPH6jNziHY2RzRJ7jzHkLBIu8OXi2xaJKuWPS6NoEFQvqwqmf6JhVKocAjlGQOv8m5s9b0WEU0rbkOq2m2CNr7fNCVQGi6j3LuLKzHFtGW6IaTWLS+cIydJRjuJhC+4oG2beMy0zgQjjX/gVGBwmN3hwwKmDL0TgrI7vTXjeM8Tf/rVlqnkOA1LT3kDL5G48As+6rhNkVrrSoNh0WYSOtvDC/HGVjTlb5yx1gUj+/9m8SbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j35yrGam9kFx0sdQF8/EFufTO4tusW7M53d8jmIisWA=;
 b=SWX9Haufz8o42/kM9W4PGjnYNufnak0BD56hRM1D0WxnhzxuvHtF5DjZyaatNxHFotiwjtLlfIJy4n0N/DbZoGDeKZXdV14WMse0YvJKy61dK+ZAtcW6+KlbS+DDzaIBiD0XxRZWEdpTaeQxVGqdkUNifvwzCMymQPu3pwZ9ruJl981Wi38pB66GVKVqnxeKbt0g66/bUjx732tSLlXpOjZq4bK9XisAVJnwTHzL48qIWPNwJPBWnTJnkG/zrTM+zfpVtSIwgvN9iFFsYK8gjrzXSlRChZhaU9UPR9b2hpHNBRrc9yj9xvZTpZAprFadooFKUuAKNcb1yu2FEpyqnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j35yrGam9kFx0sdQF8/EFufTO4tusW7M53d8jmIisWA=;
 b=cxISBlFtk1zkov5Kpc394gp6/UMtdFX5ThxbohpZs90TyyBdDAs7KVjkfo+zM6CgtEO75YaCVi8ZdluJyDNYATjt9IITJI48tAutnZClSfsoAHpa5zOtNzY+PSHQKuObVBF+TJzav9GC8Q9xC26+g38g+DWC/+dGBUXWGywZMnM=
Authentication-Results: lists.xenproject.org; dkim=none (message not signed)
 header.d=none;lists.xenproject.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3158.namprd10.prod.outlook.com (2603:10b6:a03:15d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Fri, 22 Oct
 2021 23:33:25 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::2848:63dc:b87:8021]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::2848:63dc:b87:8021%7]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 23:33:25 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, davem@davemloft.net,
        kuba@kernel.org, joe.jin@oracle.com
Subject: [PATCH 1/1] xen/netfront: stop tx queues during live migration
Date:   Fri, 22 Oct 2021 16:31:39 -0700
Message-Id: <20211022233139.31775-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:806:f2::23) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
Received: from localhost.localdomain (138.3.200.16) by SN7PR04CA0018.namprd04.prod.outlook.com (2603:10b6:806:f2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 23:33:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26c685e7-ce8c-48bd-553b-08d995b457ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB3158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3158FEB990C5AA31E1B89540F0809@BYAPR10MB3158.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SisDvnLwwL6WhZhfOzYy6kd2uL6PaEyKZpAmHDad1oe27IyTbSr3N4trrhYSBDFrE5b7J8cpkdxTwEbdGmg9Jb/RbZ6TtCHo6PiSbu0rkYJGX8mpW3q+Azf1JOlXC15T3PRpEP67+XY7vpmYWSp2IuHzjeLhgjRV6oEjF6k/C1TtiB1hyB5fe7j7aI8AoMs1D2BkDxYGUBH6PEDrGhYSl4vbSsWt/Tkr8er7E1GREhWalVjyRit3/6ulu6xp/u1Xku0EhiUm4HybUcbZUGeFudKbIkfGxDkPnraCcXCKbLQKeEYvfcG5UXET8/0NFhMkICKMMyfRSEINdSpQAYa8xy9ZRhFddunP0Al3+jLCZtZMk5o5VTaRfDVeuwQnJpuls/i8DbUqagsxRfOMiTV0BQvH46tNHrCta84PtuRPKSY+LYyZGWf/gNx2Bs2jjflbg2+hL73aF0DGCqV2TuGmUiE0Zm+l8cWm8R2zxb2VaY+s++OM7f8DnQNiOWDoy+zeyfH7EDPtKG+blWsmHAtYI3cvTQ8CuUzCoMoMUHd/Xl+Ww/bDFpVXVUihBtK2o0GQJ0HzzAoL1PzDon0NTfVR2RSOOtfxDr47foPycD4GVBkZNN2R6zevBKeTKlTkGEnb4fR/yFJphqB92/PI1dyMtKHKovRFxBaMXU9IzW0RxAbmOCMm6rMKHr4YfrtizN7dPK/CnHhVgg1tnsPASA410Qg0ByFGv6UdS95bj40tFrKJX2SMpbdGLlU8saioTaRHLF5mpAdq7a0ocF2B+DMTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(107886003)(26005)(966005)(66556008)(6506007)(44832011)(36756003)(8936002)(38100700002)(2616005)(66476007)(83380400001)(38350700002)(6512007)(186003)(508600001)(52116002)(6666004)(86362001)(956004)(66946007)(2906002)(316002)(1076003)(5660300002)(6486002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNzASlzS9QYPAEjSzfC8dNBEI+ugMly4DYOrrlhsh5yDDoFMpamlVZc1MrPR?=
 =?us-ascii?Q?tUSVWOWD8JsyRg/Tb/cjNd+nviFFqcJk/d4qOfTbWgFDyH0WrhHJtCWmalt+?=
 =?us-ascii?Q?Uts0afnIy+F1jKNkOYWCgVaSduZhCq0zDIGGsaR/wB2IXmFmSWIs/rFttUo6?=
 =?us-ascii?Q?LuJXOylpSjO4051m2wTiWl6R3ylO8u4AZFMsDdnqZYQGmmuuwgQ0yeNKgQD5?=
 =?us-ascii?Q?JeiXpZGO0CHYWEqziPiF+XB912lf6vjB/zx2MLMGhJ4T66IVY3evgSTRZI9A?=
 =?us-ascii?Q?FGSnADFn7tS/ydC6cyi4VRubyFnfteOSspZdxsPpNQGVJu2tid7dNPen2+ln?=
 =?us-ascii?Q?36MHdfhR52S+MVHuspw1qeZRMfLdLbr/tM6CW1qJ/Xn2kZ/ns/uGOxM7U+jA?=
 =?us-ascii?Q?7dwJe2Z1IvzqLfo+q+sWCD0YfLjJqoKL3KhmHM035/VIRws7mc6Y3RFfbMf/?=
 =?us-ascii?Q?dULBm3OA/EpzdU0xw7eyB7VlB/owJ+aczqWyViVwnAN21p2RFNcoQwW0GxhQ?=
 =?us-ascii?Q?T061o5Ws4JmDI3CjVERwIe6gobsL9uHEs0H2/TSsXGbxT3XDc0UCj+CDnEdX?=
 =?us-ascii?Q?jhoHcTdo01b7kAt9n2wWM1KgKnqtuOPW237V4fibIv24vZNKRzcWXsb5WOS6?=
 =?us-ascii?Q?/AZnojeovAIBG+ueZb+x6TPVap4ADoCwEbsAcedymIbolSyZoWShHtXcPi0Y?=
 =?us-ascii?Q?GhSqaM7biitwGqfEz68f98nIgEEIMkOmNZ2ckciRrbvhqo05wezpjMy3ncIT?=
 =?us-ascii?Q?RtzC9WzVatm0YzOl6LxM+N32e0bjZUUrBlgxkJNoNjXpbW56IeYv0jrHi4G8?=
 =?us-ascii?Q?2P7H2aCDAjhfjiSlFd2YtMhGt5euiI6AlOAJu38Bc4HcwVfj7QWNVuHp9ds0?=
 =?us-ascii?Q?tvvDEtHTEC2CXaiv37ibRYtbhMfLodh7ekfGrI9uOFSsvfH6+7nBK0k3uziS?=
 =?us-ascii?Q?5s1R6yfIX+hTm72xsWobcgfHYIzkC9xfXaTgpTOxGap2HQdSP9JykvoTBYqS?=
 =?us-ascii?Q?lQeQgyirsSP+HOz/7E7OvzS7waxquxs+yPt1wJ1fxnB5OjZraaQgFLHzzro/?=
 =?us-ascii?Q?VvgeE/dAyCJMWn0d0Y/ieXhRqJCqkvD1VMU3X1k7NbIYVYWeQdaKUIBOAUib?=
 =?us-ascii?Q?7GHwydIYYBbT3TlYrprg9XS7q4BLrLkMU/NFMaW0qPJ+8zJxJZ218WQzw33L?=
 =?us-ascii?Q?BSPiIYbp13sUTUB0OMkTA5GLA08YM+Ytsr/LgvHMA0ZXk1oo/WSlARs9KPIH?=
 =?us-ascii?Q?CVeOnPG6lves749b0xdp8wUhWOfkcd9YdCjmNvGhCdBKnZ6VBtvy1m2u7Emg?=
 =?us-ascii?Q?hi0M1MamwMePKArMtDXA4XPt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c685e7-ce8c-48bd-553b-08d995b457ac
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 23:33:25.1067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dongli.zhang@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3158
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220132
X-Proofpoint-GUID: mMPJ3xou-9Kck0JlV0Jax1ILnkTbs8nf
X-Proofpoint-ORIG-GUID: mMPJ3xou-9Kck0JlV0Jax1ILnkTbs8nf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx queues are not stopped during the live migration. As a result, the
ndo_start_xmit() may access netfront_info->queues which is freed by
talk_to_netback()->xennet_destroy_queues().

This patch is to netif_device_detach() at the beginning of xen-netfront
resuming, and netif_device_attach() at the end of resuming.

     CPU A                                CPU B

 talk_to_netback()
 -> if (info->queues)
        xennet_destroy_queues(info);
    to free netfront_info->queues

                                        xennet_start_xmit()
                                        to access netfront_info->queues

  -> err = xennet_create_queues(info, &num_queues);

The idea is borrowed from virtio-net.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Since I am not able to reproduce the corner case on purpose, I create a
patch to reproduce.
https://raw.githubusercontent.com/finallyjustice/patchset/master/xen-netfront-send-GARP-during-live-migration.patch

 drivers/net/xen-netfront.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e31b98403f31..fc41ba95f81d 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1730,6 +1730,10 @@ static int netfront_resume(struct xenbus_device *dev)
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
+	netif_tx_lock_bh(info->netdev);
+	netif_device_detach(info->netdev);
+	netif_tx_unlock_bh(info->netdev);
+
 	xennet_disconnect_backend(info);
 	return 0;
 }
@@ -2349,6 +2353,10 @@ static int xennet_connect(struct net_device *dev)
 	 * domain a kick because we've probably just requeued some
 	 * packets.
 	 */
+	netif_tx_lock_bh(np->netdev);
+	netif_device_attach(np->netdev);
+	netif_tx_unlock_bh(np->netdev);
+
 	netif_carrier_on(np->netdev);
 	for (j = 0; j < num_queues; ++j) {
 		queue = &np->queues[j];
-- 
2.17.1

