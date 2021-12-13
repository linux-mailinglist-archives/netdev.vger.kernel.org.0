Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853484732A8
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 18:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbhLMRGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 12:06:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29142 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232507AbhLMRGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 12:06:16 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDG0Tsa026256;
        Mon, 13 Dec 2021 17:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=NX9vVaaNlt3nId4A3FBA3PCK2wc5QkanAxO8J2t3NSU=;
 b=ysPxBKmScT+iIjSIeEnZbDGQcVmyfoYUwpa4IreNJrEuWg7jpA5S/A8QXrJYzbGDcDuU
 iKtwQRALnNKOCCMG0eTokNZI9i6PovWTjg4gpi4LF6EvMqr7AXXDH409Bp+giFDgHLE5
 G6PZSJRmiXVqVyU3IQNHAILNHhp4Zq0Lries8HNhgcnfY6hIvvApylFgKfZMgsXnYots
 9JfXBHe2ET5qIcGCucBGIlQBNfmY/hQfserf1ld3g1JM9Gg2JlcolUBR+w6DKTIxhZcv
 8BgxdPhTbERMaq65hxqZliiu9mGyU3PppZrSATSppIfWDSaTKmlnrVOglPQH7lLLS0PE Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nf9aum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 17:06:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BDH0TiS019464;
        Mon, 13 Dec 2021 17:06:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3cvkt38b1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 17:06:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OA+LdDphcKghn16UNGKnR9HPJCwdXG1ijv2KvBYA9whGKLIbQnqzmL+CiyDDZhP+d4aWTcgX+qySzAVS59CWhAbYde5d0dwQU5z8VgvnbWczRaoncYlduE9Jq89yeZaBKnFWE2yVvcY+hNDu7UpzLHIXLpwgbTN+kgiz7Ofjmy0MiGMyG+aoeV0xWQa3lTb5+sa7cSO4nlnSOLpmtLLPasnIVOPq1I5CdA64qsavFhb95E17llM6OG0czhr6bp9AFl2sefzoeO9NrILyWY/1g7oXpVCIjqa4qpCX2xALZpr2r3z47tUR/RnG1DMuw9cp5V7I22Sq92nAP5K/wzeIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NX9vVaaNlt3nId4A3FBA3PCK2wc5QkanAxO8J2t3NSU=;
 b=N8qthHMXx5Mh3vSLMD0nkzynNjhz+vmo4jJJpC85pj5v7Y6mgM1LuK5WwVvB43p+grll/ZSXg35kLVNpYxmaZBHc52HXRhkO74dDDRUJbGDrVDu2T+XK9Ip1DefI2xGMVMVRLUkWjU4Xsbb4dZdVNlNVeJ5TfYnVPShUdwza/6qImMWAHkq862bMl1z9eJ4gP1EVZ6h0O9g0Rtl8pUL6FXh4oZXDU6xwqvLIii0iqCvwnFjhhPK2Fh5WY3joYS7h9Q4uqSN60QRSXRVadevag/cBqcIumXLA1ltPP1hlBh0y78x7szsbagb89mxbgCA1YYrS/ZZ8H0Of3IoE+tguAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NX9vVaaNlt3nId4A3FBA3PCK2wc5QkanAxO8J2t3NSU=;
 b=k2x2KCY175AZzgGHw9891FuHIeAQ2LuTm0rNHtfqvJQGX/wsLdELh0Uym1LSkLvcPhPA9SWiqveyx3lps5ARn/a5+q3ufz8TZqeL1E+K9hMPNaK9i/+YjWL2Gi993vBjtYSig2HeDSG8Qr4piYwec9v066hROvKc/vlUqAACR6k=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN8PR10MB3203.namprd10.prod.outlook.com (2603:10b6:408:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 17:06:09 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%8]) with mapi id 15.20.4778.018; Mon, 13 Dec 2021
 17:06:09 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     kuba@kernel.org
Cc:     george.kennedy@oracle.com, stephen@networkplumber.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] tun: avoid double free in tun_free_netdev
Date:   Mon, 13 Dec 2021 12:04:11 -0500
Message-Id: <1639415051-10245-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:806:22::7) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76ba7da4-fad9-4921-4e4d-08d9be5adb71
X-MS-TrafficTypeDiagnostic: BN8PR10MB3203:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3203D7FCE91B66A55A9D4BCFE6749@BN8PR10MB3203.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JKu5nz0Hz4gRWgwZZuFZgNSsh7/X2D1eIkCyKfYPjYDeditYuOlxtDFtXDxbGIckMh7hDtpYEPHhV0pxs6UTyGVs2iV/nFz9uvSOLqmVqhK3jNtxkMNwPYzAXG86Sc5DR4s4bYTyglvhDscjMQCACOoGBj1oSwIgjzy3DPflIs+7QN9hbCOeu0zHCMkiKvk7GGMbHPN466QdhbTcwXm0LpngH5nGWecHA4st5GB86p7gyqvt39vdNK519bkK6qsbia7gCCkfdXwSXYeUtQoo0gKDljavZp6AAnK9pp0EjeexK8QaeZXqTxPfMwN8hyJnjDK5I6rTq32ad3QvWWr+x6Xe7KJWuq3PItTzrlHgARak8wJlwdnM0DhJnCFnbAcvHxLOp4CRXILUiKfrtSNFTsNAwJoSJCxxQhfKIszLbIaODRUTM8/bMgLpTChVB4ptcpo6msp06Q+aqZkjy9DLlHi1zv6uSmy8/ia/ZFPwmOiINDtqOYO2l7kjJq//lZkni80eH6OUXAilM6MyKTfdY57nInh9FEaFTJaRVRSRLMNe0dCyx2uNpV3A7QMhTuWrXTAMYOiBlo8BLXYzI33l3e8Nfdr8liM9SxR4UJNJaAilpN9FU08P9CKKvyEnK0xicySWZY9r2jh+Olsa8kJn9TUo5GXAZcsZDzyXpdJztxVWHaQg3lYCDmUzWhiai1yvwc5OKL+5GRxnfUlDFqSNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(8936002)(6506007)(52116002)(66476007)(4326008)(38100700002)(66556008)(508600001)(6512007)(26005)(66946007)(83380400001)(8676002)(86362001)(6916009)(6486002)(5660300002)(6666004)(186003)(316002)(2906002)(44832011)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RpjQasoKQm412OQKRgC0Zg6eC9bsXoKHT2ruo6xn6d3y2MqYzFKw2t06oVDc?=
 =?us-ascii?Q?P7Pi586ewVtIkKY2AfXlVVqYD4fqUowkxJLuBsJbmQy3v/fFLYJX+3Vbz9M+?=
 =?us-ascii?Q?0NXbsk2P32mTCGgVb+iSiYDllCpxoJ/X3AraA3CDa5wWoEQMIP3ame3G17dl?=
 =?us-ascii?Q?C3X64YKPSky/hzzcoQxZu6RBLOdntaucdnL2xNIrBCqBZlQaSdAVIGAeVxOZ?=
 =?us-ascii?Q?B9rx/StFUmll6ih3fTzH5Xlkw12MuQ1AM7azJ8yOzZPYrpVkbXGkcT+xXrxM?=
 =?us-ascii?Q?CmCajym6CVYoZFqu4icbsM9NzwLAGDUA/rxQ3QSH/Z01IXFsfyr4w77dGQTR?=
 =?us-ascii?Q?g9kiq4ezBHCAY3EKVWU0nfhBYFnpAYHBowyQD6nPW3Eu60rzyU+Z/0QCoxCN?=
 =?us-ascii?Q?tnmTA1XR8w/uk726bT/cV5Tk0JkTVwoOr6EY9jOoPLZwvsBnUeChxwmMv64O?=
 =?us-ascii?Q?rBFpmK9U2ZneQd0SmjWNGS3w8u+DVGPHtEjrMgBlqb+So2+53pUv5vP6rhRs?=
 =?us-ascii?Q?efMWfSQPyWY1ayMbnqVMcrjP+pJ1Jyz55PJ5xU0Afs2+bFf4MUQh2uP+1mKS?=
 =?us-ascii?Q?HNYF2goqvWW2VJCWX6GO0IaOutpe08AGldPeHpWQBVllqeVqYyle/gky8qSr?=
 =?us-ascii?Q?+EDX5jIKyneOpy89kexqT0lydNgaQ1zJRwVW7PslT1ACD46wovZ1whx9g8kC?=
 =?us-ascii?Q?zZunOg8+rZmV0gpZ834GO8NVzLboZ1Y/ESCakD0XSOB2xuk5CT5vztyJJf/G?=
 =?us-ascii?Q?UzTuZSljvM0BY2bHgsxsO7r+QNGqSd9RP/rHyPR3yvMUJzDzeb53QWIgYPMX?=
 =?us-ascii?Q?TwQhaQu5ZowCVbL5floiw+WnMHpcNMZmAKQH39r6RQMtlYtSJbQtK8q1bSUB?=
 =?us-ascii?Q?f1UKpUGD3hxVHgEI4W4OKQiGZA4VkM1PJOBp86aBEi9IPvyGBg0q3OzZ4KsI?=
 =?us-ascii?Q?eWjL0MfiyjKJrH+MwwanuqXnSm+AabN1LKd03xoDUPRxwzCXVuLqHv7Fl6yZ?=
 =?us-ascii?Q?E+WA3PjVwicZ8EZDLasIS6ygFrPK//6HQkb7iqRKW5UzjA0kcBN6NA5uv/AA?=
 =?us-ascii?Q?NTgqNj47UIAQDFP8RCM79HzQt4Qw2D/xcpEg4DoKA2IiBz8X4GQTtZ051VlN?=
 =?us-ascii?Q?xFlpWjdAVvfGTkdO4kYfBpOymg+SFv5LXCcu9JqLANKIanf6C9fDl+7Xqptp?=
 =?us-ascii?Q?y00X1VyyBX+WKfsCwzmzpl4sPnDGJ5htk/wG/mFBM2A0SAk4JKlrZw4sBMeM?=
 =?us-ascii?Q?Abq4wNdYbuElUE3Q6KI1VpAWbZR3deb8+KL0Mcyw0GhBJWahMZQwhpkmt3kM?=
 =?us-ascii?Q?YQBj9qR9PRnVB7odcFNRL2AyAoG2bBrqBZIlV7lfVMmpghTjiAu6wjsbsQYU?=
 =?us-ascii?Q?OPWHG+3pvo23CR4xUx3Ulm4mf4qaV6aGuRONU08rfwlvACHOFQlArZ2g4DpL?=
 =?us-ascii?Q?qsh7dTmLbzq2ZzINjhvMaKajWrfQKFrmpBQM0He+GeSN1991+gZHvE9hzl39?=
 =?us-ascii?Q?uG5QKiPfgGwUh8awNM9uXrPYrFlnetOp+z3Drl0geEaoefQ59ePLjPYb8FiU?=
 =?us-ascii?Q?6kxfhrhKA6DZI4szJW3VZxWaNEr1x25VX5zHESlxpeQMFmtCO8y0yr0fcsjm?=
 =?us-ascii?Q?Z2NszImcfNexseGtscpOpwWh6ytIQiO+jQAsOjTcJZMtWoJKcCEncSelyJ4/?=
 =?us-ascii?Q?ekYjkQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ba7da4-fad9-4921-4e4d-08d9be5adb71
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 17:06:08.9636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dspwLVn8kgUycjBVfVAWP/0wldy6sxSuA7mYuG6NvTt9WHoo6q0SM+wZUxpfgEw85q5nqCbVoeigQNncwqhbtgk21D65my1VAEoaE63xvYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3203
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=943 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130109
X-Proofpoint-ORIG-GUID: GVrwQISYgGh8n3WnXQNHWuzPYXc-ZAen
X-Proofpoint-GUID: GVrwQISYgGh8n3WnXQNHWuzPYXc-ZAen
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid double free in tun_free_netdev() by checking if
dev->reg_state is NETREG_UNREGISTERING in the tun_set_iff()
error paths. If dev->reg_state is NETREG_UNREGISTERING that means
the destructor will be called later.

BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605

CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
Hardware name: Red Hat KVM, BIOS
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
 print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
 kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
 ____kasan_slab_free mm/kasan/common.c:346 [inline]
 __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook mm/slub.c:1749 [inline]
 slab_free mm/slub.c:3513 [inline]
 kfree+0xac/0x2d0 mm/slub.c:4561
 selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
 security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
 tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
 netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
 rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
 __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
 tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
Jakub, decided to go the less code churn route and just
check for dev->reg_state is NETREG_UNREGISTERING.

 drivers/net/tun.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1572878..9ab530a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2206,10 +2206,6 @@ static void tun_free_netdev(struct net_device *dev)
 	BUG_ON(!(list_empty(&tun->disabled)));
 
 	free_percpu(dev->tstats);
-	/* We clear tstats so that tun_set_iff() can tell if
-	 * tun_free_netdev() has been called from register_netdevice().
-	 */
-	dev->tstats = NULL;
 
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
@@ -2770,18 +2766,15 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 err_detach:
 	tun_detach_all(dev);
-	/* We are here because register_netdevice() has failed.
-	 * If register_netdevice() already called tun_free_netdev()
-	 * while dealing with the error, dev->stats has been cleared.
-	 */
-	if (!dev->tstats)
-		goto err_free_dev;
-
 err_free_flow:
-	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
+	/* if NETREG_UNREGISTERING, destructor will be called later */
+	if (dev->reg_state != NETREG_UNREGISTERING) {
+		tun_flow_uninit(tun);
+		security_tun_dev_free_security(tun->security);
+	}
 err_free_stat:
-	free_percpu(dev->tstats);
+	if (dev->reg_state != NETREG_UNREGISTERING)
+		free_percpu(dev->tstats);
 err_free_dev:
 	free_netdev(dev);
 	return err;
-- 
1.8.3.1

