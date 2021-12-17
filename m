Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692E447944E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbhLQSuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:50:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27652 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234059AbhLQSuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:50:20 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHGXphG005180;
        Fri, 17 Dec 2021 18:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=tjvUJrJwjwrPbylADWYXEGRby1frnpVOW0h2l/TR65U=;
 b=R8W7H3VG/lMxsJ8xAR28V2vmPswgEYhHUHyIXoFjETodaNCynhruCymCKFMnWfjJEIc3
 D9peZjsFA3LWmAub1c+X3ydlhVNmoHnDO7GfBQGztlJczAvt/yU4cm/6StjrX1CzRe8g
 sYL0tiVRUNDx6f+c2FNOxZUdCrMbZoM+uENYHT5f+WbDrjStQQcWpA1icjlPpSXN24KD
 ef4ZLrtslYFg5djhpTSjGLxEEvt5xAZt9k2U8fYuDYlSHxKCu79OuzqSjitj5uizutr7
 zKcEOvDcd9hGRTLixUrKbBl6X4ACiZ/GSMgx/LiMu+oQqNb2K77Q2x9BcwdiS9ae3h59 vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknc6ht0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 18:50:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BHIkjYx118999;
        Fri, 17 Dec 2021 18:50:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3cvh444tu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 18:50:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrNDIiZrchezrBFdolAKnUbswsaFzxr5Vte0Lmbr5cJX/uvbMMMq1IbopjPTabsUzKinlf9MI91OB82ZMeQgxbC4YUtmZgswNiQrKehHAQrpMp+2MA+u8lTLoUpE0PgDlvgRw2tK3ObZ+E7STaVfwMWB9xl5MvPEkP2qxfZsjco76Aafwhh3woBZ6kHhMVyy0iYC8sIJ+7hM8fIViUTgAJoy7OYr8GVQmUFSs0u0loVSPIT90dpxYVq63k0hfGkoKF/Ft+14kduzYq2TFftWyyJPqAc8kBSvizFR0tpOx9BqCKbnUH6ClPin6vu7urmnwsrN0aGnqMpAJ1Mxl38WBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjvUJrJwjwrPbylADWYXEGRby1frnpVOW0h2l/TR65U=;
 b=DSKT+TSchK76HV5PueJlOpdRcAKjIwi6QIPq1yV76hdf013FF2lG83q6YTL2qXroCsD8mDilzsNduerw2qM3T5oZUl60xkP4HR87dIsBlhmnS+TG+5GWrsfZd1ilx1CyWQr74JKvsXocqbVnCRLcJ9Kq3Z5FmdtR+qJIG1wFpaBNOB2xKMlKRs6UJBkiUkTGZK287pHSrITinlAzQMglTV1o+iFWOUno4YPkZI2nNZfpjXW8BXBbrrGdfP4dk/S+8yadjvl2LnTfNbtCYTppXja1rGUdVm0aEsT63Q2IkXajAITMVU9dNcJ+d1thvNrg8n888RGHShTeX/ectEvf6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjvUJrJwjwrPbylADWYXEGRby1frnpVOW0h2l/TR65U=;
 b=JK92chhBH7WHiyPaDEioNGOofxRF35UkOhKbQaGnDhwfBVvGVKIorRupL57GSVviZIMT0zUJKzEA31mp0NZP8yxXG2iDXkm+k4CkscyDSIGVZbnIhd6WUQAtoUcYLq0pu9VjepYojON+cWJxja8BSofbaoPei+829IgZ/HAS5qU=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1634.namprd10.prod.outlook.com (2603:10b6:405:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 18:50:00 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%8]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 18:50:00 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     sdf@google.com, ast@kernel.org, daniel@iogearbox.net
Cc:     george.kennedy@oracle.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: check size before calling kvmalloc
Date:   Fri, 17 Dec 2021 13:48:04 -0500
Message-Id: <1639766884-1210-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0020.prod.exchangelabs.com (2603:10b6:804:2::30)
 To BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 748f2587-b617-42e9-ebec-08d9c18e0777
X-MS-TrafficTypeDiagnostic: BN6PR10MB1634:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1634A2155DA9EA1E8FB62CA1E6789@BN6PR10MB1634.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DC+noNEygsNXZ7GQufI48z2E8pin6JonniDqGqQLfoKcdHwOXnTOM/8fq6HSJA5f4vsdR3gmUCQsQLwCzk6zFYMD2shgSxv8BIVWdZ7dc/QF8TCG4Adft4cK2mRjo+7Z9uMUvSFs5mly32ElGPADeWW4vRFDHd94ODV/Ei0p4u6rIdWkunqp+hiEnEBa2p7S7TY1VpykKEk6uj4l+eXeTrWQ090FzRvrMULszpDsXvrRUcPKQQhE3dRXCyNniZ54ZpdGW2DBdxTS+682MoYUSOn1ogRe8yiFjw5UmCu6m75bZicEfokczd3p4W+RpLkDcAbZ2ZQBWTzKOthNxm3WhOeVOEuU2P+tZgaKrpdIc1I9CTyBNYIA7/aD11KjZ2smuNaeO/8QbdP16V8yf5fTbthauBfavXIAqvBdouJFjr/jVKsm7xPJyLGd4I6aJVKI56SYVcBQO+Yh62be8smKCn4/nO7pYwyDMc/KBI9mtM9/alJph6axLE1yZ8cOeUNqKF+rDluqha06YIv5jbNiX3BlqP1YfTeGDuK/xNl4pFIGhDo1fy1n/H2i+E+duk+Le/Kz2/P3+TwV4npoV4FaxhB1PNUYryAK6BpFPQbyscOG4F83YQB5Nb+lGM1MXCA8BYOQCzuZQBG59GeSeHHLxkAl8y7OJc31NZuNrdX+Tlgr0DLyeoKf3Ji2GTq29bcW3vU0IcEDqQELMPFLW9TdFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(83380400001)(5660300002)(508600001)(4326008)(66556008)(2906002)(66476007)(66946007)(186003)(26005)(8676002)(316002)(52116002)(6486002)(2616005)(38100700002)(38350700002)(86362001)(6506007)(8936002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gD9uy23N/ZpISZpVc1g01uLegijGMjeVEhCsvNrPNPUFtZbr2VkRRRr1owsh?=
 =?us-ascii?Q?o5Y91MmuuB+wgUI23XaEVGicjKb0OQUB2au+740BILCn25q7HQbeZ6LQXUOT?=
 =?us-ascii?Q?kb9tUlldK3kqnoU4gQ0ZEqKIlpekpL4CrNvt9USJUpfHcboEfOo9KSTS301A?=
 =?us-ascii?Q?SudNs8hNlhG0KRfhpmJpV4uZeDDwnYfjVSks9jJhDeqFoEeQzIqRoh4o/OI9?=
 =?us-ascii?Q?I+j12BMfKZ5J8OQSOAjUgAH6kcaxKKONk4PPczoO0JAejAVFIRc/QElnu14c?=
 =?us-ascii?Q?CKnnGKI3Kev2mZ6Ec//7iizG6vfov0IfmE/8M3Vd5PHzZdLIuAKLggfVGVas?=
 =?us-ascii?Q?5rR1LkUzamUb6HggMBhQWFrDKwVTfvyykj6Pbx+2afOSHCA6mRBmVrMB+5Ox?=
 =?us-ascii?Q?6c5rPv3ssVvy6fnRAXgDN+vo52O+yrZlEL6j8nFJ9t8YnGuvNXxylOg006VV?=
 =?us-ascii?Q?y88xrwHo5WHK+mm2G/0jixRMNoJVPM71w+eECgbxLHBFK4n1s1v5xmI83Z+u?=
 =?us-ascii?Q?mQfqJBuUJwMm+gQOpNDUHa8rHjZaa7GWAoMSH0bljvLDh7SCUCV5kQTgqvVe?=
 =?us-ascii?Q?JoaeLZzGwVNZalHVpN07BTeGFzFWt+WgWo+LrgsrvAMORai3GSv6oa0Mv0p4?=
 =?us-ascii?Q?EALtijtFwFqhNlKXgvFPWakZuJnuS6LG6SitCvqcP55r8qri7g2ahuq3NQoN?=
 =?us-ascii?Q?K8PxAk4DLHCdlxz9Wns+4V30whs65Rw0VDRpHUvsxLgRli1/mPvlgm+MgfHA?=
 =?us-ascii?Q?oZlZ64U2qLnqRAS8VonpP7Y6WxStrLr7V71o4vQk3/yOErGS4Pc5I06flvOT?=
 =?us-ascii?Q?9rDDr0kbk2zmYYOQpS93DHcvHZjoAh7dqgBN+5gEue7G0czUpSlsHnbFbkux?=
 =?us-ascii?Q?m3Sqlliw1aFTSnVCZIFhg2Tayt3lGG2NgVsy6bvJB4+EhGwRec+xzmAt+kPW?=
 =?us-ascii?Q?BMQk0HfRxHhHOnMFPbrf6snoyREOSPsVuOj6AUPszmE3kjV9LWGS51pQtO/w?=
 =?us-ascii?Q?jb2CW3mks3OADw1I6T4uwfUNFgtHNphny2h4NxGiJSgWQI3jgEJaYidd3NmZ?=
 =?us-ascii?Q?SDTxl9bZet/S5JAzsF5xr56wZ+buC4QLVfxTfdQOXmuUPcComDaRr3bl2Wfa?=
 =?us-ascii?Q?xLZPaUcepNqqUEjG5byUWoevgzR4V9D3hs+dH1aq8H5HwoLtSniskYxATOCg?=
 =?us-ascii?Q?b0xmpUaRz9PzHsjMAHfqyUy4QWRb8A/EaOuH5lj5Fj/s0YSSxQTfFlQ5N99X?=
 =?us-ascii?Q?aiED/vFiPjncMGFVHwwxi4BXniz/ochcvc6O5fns6eqA/7hMJ7Yhet42gI1X?=
 =?us-ascii?Q?WZgoYl8f8kdjx+TVc72ptD3tnoGeT9CD1onhzSjVB4L560BV0Lzw6XPeWo28?=
 =?us-ascii?Q?DB5dfTDds3U2oYR3f+Uu4i+fpi94QiO5DP/agW+j0hdzfNoQTC1df71uWvQ/?=
 =?us-ascii?Q?v9S738dUWujZSI7LT9p3FsIcumd6JubV5ZVf6QPKiXwj9TP5ClQ+G76K4Od4?=
 =?us-ascii?Q?4JkT/Tfd86uofKN9I+jubNaKXevXunrouF7ojwnB/UzNnsoEhLAB941nesFE?=
 =?us-ascii?Q?bg35LjAUkyQGS+9JOqacbgPAV3lcQWq7q7MkvMKzHWcKaRj+hzrIcqy8bk0z?=
 =?us-ascii?Q?SQy00LDlX7pI2tf69zD37UjpdHb0w+nc9z5QkJi8ifoUc+F5RyqM4p0qeY53?=
 =?us-ascii?Q?McS6aA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748f2587-b617-42e9-ebec-08d9c18e0777
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:50:00.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaDiWr0vvFR4SfW5DFm8mgovsC6XGyDlV9gfQIekEe4ykjhlybzkvTJF4de5RCmk8Y0Rc0d19eE9cB+2Oq0QRPmSTdGT8ST6ILdcSO5JpoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10201 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=711 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170106
X-Proofpoint-ORIG-GUID: fHBNVBCOmYX37VC3jAW-d2OHM8aN5TLe
X-Proofpoint-GUID: fHBNVBCOmYX37VC3jAW-d2OHM8aN5TLe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZERO_SIZE_PTR ((void *)16) is returned by kvmalloc() instead of NULL
if size is zero. Currently, return values from kvmalloc() are only
checked for NULL. Before calling kvmalloc() check for size of zero
and return error if size is zero to avoid the following crash.

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 1030bd067 P4D 1030bd067 PUD 103497067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
CPU: 1 PID: 15094 Comm: syz-executor344 Not tainted 5.16.0-rc1-syzk #1
Hardware name: Red Hat KVM, BIOS
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffff888017627b78 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
Call Trace:
 <TASK>
 map_get_next_key kernel/bpf/syscall.c:1279 [inline]
 __sys_bpf+0x384d/0x5b30 kernel/bpf/syscall.c:4612
 __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
 __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4720
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 kernel/bpf/syscall.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1033ee8..9873723 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1278,10 +1278,18 @@ static int map_get_next_key(union bpf_attr *attr)
 		key = NULL;
 	}
 
+	if (!map->key_size) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
 	err = -ENOMEM;
 	next_key = kvmalloc(map->key_size, GFP_USER);
-	if (!next_key)
-		goto free_key;
+	if (!next_key) {
+		if (key)
+			goto free_key;
+		goto err_put;
+	}
 
 	if (bpf_map_is_dev_bound(map)) {
 		err = bpf_map_offload_get_next_key(map, key, next_key);
@@ -1331,6 +1339,8 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (!map->key_size)
+		return -EINVAL;
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1388,6 +1398,8 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (!map->key_size)
+		return -EINVAL;
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1452,6 +1464,8 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	if (put_user(0, &uattr->batch.count))
 		return -EFAULT;
 
+	if (!map->key_size)
+		return -EINVAL;
 	buf_prevkey = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!buf_prevkey)
 		return -ENOMEM;
-- 
1.8.3.1

