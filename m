Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6AB46D602
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbhLHOtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:49:05 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47054 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233216AbhLHOtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:49:05 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Ecr8i005559;
        Wed, 8 Dec 2021 14:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=OtVKQIiLRxiu9G7Y5OUNLmoC6E5XGVWYY/pLSU/LZWI=;
 b=EjuJsaUYu3ZwoYbih4vp9bemqiugkWhFpAFKg0vJd/YciLZKqSrFzgUeHhwVuRJ5U7Em
 yZR21lYEmDQ8h1q191jHbU3LaiWxGraIhlpCoXq3lCbvJIZF/824TefInTh77mjmnu5d
 CpmcMReWlt1x05CVOiBIFQVEnqIudGV8ENvDq3KQnaBGKhAeS2YAdccWTeLy6pno+NFA
 XuxflxnuADMna0VpZaCLQeuL7150ugNsV3z5Tslt82itPnDv1JvfvlundDUmD/5otVNj
 0FpRLvC6Enl83tAdzU3CqiXLB6j1v8VU/FOzAqwqwvJibt3DEycXPyuAPmFOqi+4oYgh aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctu96rg4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 14:45:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B8EfEe7036417;
        Wed, 8 Dec 2021 14:45:27 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by userp3030.oracle.com with ESMTP id 3cqwf0hceh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 14:45:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOCdaLOeQRqLbHQ3ruSheFtwKy14gJGJMDXbAexjlegg5MFWr9PAv0D8BKMvjvz7gZUZU5Ll0iDWp5cyQFOVaWS2hTPaM6mFxKNYHwfoasRg2wFZYptjsj+ZR2XqgTT9k6C2/7/Bl8AUnKbnZ5MOMHEpbHB/ARkmBzIMEqCpWe6W3h80rSNv1w25ItotyMzbYnG4+LnfSjqUWSyCgosYr7dnO0rdZefcugLgZoj0yJzlKDfiAlNAU61J59xjlgmwdp9sFMH7j+pTieQosu+aJVtNgKDat1XFKzdaaPcWqLwG4/nzCSxaKYI6rKdl/7bUrFABWe/YmkTHvxqeC9JGIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtVKQIiLRxiu9G7Y5OUNLmoC6E5XGVWYY/pLSU/LZWI=;
 b=H41weXh2/gnHAHhul0ddBzqUsSDsnf+gzk9M2lzaFGjluh8VQTvKlpQjgWB4hZfxrBlEpc1RZt24y4G3V9j20FkEAvE+fYZYvBLW36hxm6K1BrFPSZDUxy/WLnvNfhDLjnBoqAIVZOkxayxF2FYHeJreGZjEah+dIMU0nWNcwI+DvFmaeaQ7eYOUki5S5wHreRBqQ+e5OwDIk9HeGYt7JN5KEOWQdkf+3P47bobjyEsWYXQBP7nDsW1IE9sdusp939bxoyu+GfcTqbLrtW7GkWbkEYj2ADdvZclcpwzXd3wp1R8Km5wBxDRcJzRPHKmgPFcL/F+Iwtfnr49/Rgm3tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtVKQIiLRxiu9G7Y5OUNLmoC6E5XGVWYY/pLSU/LZWI=;
 b=V/I6cs8cz4f5gYuAqrJr/X1UPMTcKp/c5wVvvIORZME0m4/e+G+T+ETkJfG55JsQHhSWHFvh8lQEwcO91EYhA/GhBwdlH3T5Tjx0C+PbkzEyjkyAd7yTyXnwV6INE14yM0HNZXdy4RHKAWEKEvRD56nylSIndQE4rAR0p2eeEE4=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN8PR10MB3668.namprd10.prod.outlook.com (2603:10b6:408:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Wed, 8 Dec
 2021 14:45:25 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:45:24 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, davem@davemloft.net, kuba@kernel.org
Cc:     george.kennedy@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tun: avoid double free in tun_free_netdev
Date:   Wed,  8 Dec 2021 09:43:25 -0500
Message-Id: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:805:f2::25) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.43) by SN6PR04CA0084.namprd04.prod.outlook.com (2603:10b6:805:f2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 14:45:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 027c082f-b7a4-42e2-2671-08d9ba595e59
X-MS-TrafficTypeDiagnostic: BN8PR10MB3668:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB36681AFA39A66C405DCF67B6E66F9@BN8PR10MB3668.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KGweojTJ7cGT5zvj/JDH9rraHspLBnnbWDO20ZZ/tudLr2algyj9YZtDCrEw+c0OCCf8ysmtU5xYBycFsLN2gOBXT0gx+gjMi2Im7WNkM0MruHB3uWSWdlbFihmcWCg9xFBkk5IWtqrxfqDnHDUiVkR3btt0nJiHO8GLEkefi/bieHOKro5a+2Y7l2OhcApjsgbnRLtuL0yXwluwTV5LcSEXmkRhXA4csRzAqHzrMyHZ7DwJK2vZTdlqFvgHlQwLQIWyDWzLkpR9gCuodcIuRitbDcxoNmYWnDm7QJHudMRw6DF6bLqOgsE//0Jx6qGM96xgQYnOblfMdepFLfq4nn0r11siLvqCxVCD1azDlHqUpYWfW+vZWHtgTQILMxE9wx6b26mq53th1EexXbAMgHdMGbLHS9NjjHZg1rpi2Y4j+x+CvPEnmUbQcN1fU9kGgBT6JaPNn7WdCCh1NRtuhuJzywOCSuzKi4kzwDCHFnl2a3oUdnzLh+sMTAVFffQmdhOHmdjolNtHKNHOfQqLY7jZMo5Es7RVROfQoqjO2v+QwnJSg2EzVS7z2TdBhovT+db2iSYR96sStnbJPIZEvcQ2BXV6odu3X5PWAHaLGNeIyae5QI4XtJK75KGhiSclE2Pm3ISNHOCEF1dzeS245S03eKPIuq+KqUL+1BGRZ7GNSk+ce2mpL5ORPyTiDq148u3Ru+qXQwFUe257Uit9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(52116002)(86362001)(83380400001)(66476007)(66946007)(4326008)(8676002)(6506007)(38350700002)(38100700002)(8936002)(186003)(66556008)(26005)(6512007)(6486002)(316002)(44832011)(36756003)(5660300002)(2616005)(508600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3I11Lt2XvaJhdC0cHEbQ4L72VIZAf/Tvak6hEk4ZsKITMkO+cF5rvK9sXvVG?=
 =?us-ascii?Q?YkhdySk1AD+7J2VrR0qub2MYhWSvA4eY0ej0WrbkiXYHO+ozFOPGb5ytRtwS?=
 =?us-ascii?Q?CsOEaAigVAZDnuN5jTbIzwPuNxcfMq71jZkiLayDCja8FOFjv2lugQV4jOb6?=
 =?us-ascii?Q?4AQXOiP8klszNigdQg+bRc5euOW0eJEa6csf3Q+kYJA/uibu3uSX+d4YOR3M?=
 =?us-ascii?Q?wwDhaXZPSoZ7i7IQZpKzdLM5RybCp6ESqIzfutrUxdTb9DeIwu+//Bd71neb?=
 =?us-ascii?Q?IajEuTGPqEfZjAVcdDbhJ50K5q90Z6qHgt05o/6FMiIhA1U+lmgTBZYBhcOH?=
 =?us-ascii?Q?CaMVWlm3HVyvN1jmxIQ2V+UHe0tUcNJ4u/Z6/+IyMTMxSKoQ1jcniXytv8io?=
 =?us-ascii?Q?msgyA6/fU6awtZR8GrvorsKyaYqJKzsItqg3smKPnH4tWWqlzDNKOz+kn98I?=
 =?us-ascii?Q?+TTdHWh9Zoj5ZVS04OkxRJGLb/MAPbkk79WwpIxMvHYTAtSEVE2M1yjZDVRF?=
 =?us-ascii?Q?j5S2pkzFoGSIpzLQwSkpPEoZ5oXI7bMpVy0T9/2JkiprwjH4UKW20s/a09F3?=
 =?us-ascii?Q?1eWR6U8LoAvUxWPHr1EkdujxgYw4wZsVKNvKleWqA/Dlr0YH2+hhessfdvBZ?=
 =?us-ascii?Q?soKb8RBxkfEbil8NuDGn14fMJWI3WirNhmJ727+P+nbU/+BIUKAlLA+Dj176?=
 =?us-ascii?Q?wxRbIhpkB6x2rPDHuFuPYGYNCJkyhgBtPLkR0BePS6wGP6k6CaLiFNHCE47I?=
 =?us-ascii?Q?rdYx/nn4sehwXhDL+2pk76SX5ThcWmSYSNzU20yTXUTWTMA1AHB/Hx2ZOcZi?=
 =?us-ascii?Q?sYOC39ow+yA7rWLHy71QmzhfFpfTIAeP6TuBOWzZDPgNZcLesJpH0II8LAyP?=
 =?us-ascii?Q?5dgt95UsfeoxcdL1PihDibl/fJL1/NUNz2vP+8Y8AHEQ/wocH5OeBChYB3o2?=
 =?us-ascii?Q?exBc2TrhgoH8mEt79otU1uxGe5OYrZRiJdiz/YuBTATR1paj2Pnj+qEIT1tI?=
 =?us-ascii?Q?UaQfBE8+ja7kBFu/sQdAiMlpvfMz67OynRLP8o9UqVo/VduOlEHm1TBiKuYc?=
 =?us-ascii?Q?M1dgzBkz7pjCMnO3VQk0BKq3pCl7DJwJ8TCYHvVXqoKEeZKE9nnoMo54PAyl?=
 =?us-ascii?Q?zMCbpewMUQcVzXpTE/srhNYfAxJ5Ziy6ZxmY53NHjzn4mU8s53M53ReoR1Lj?=
 =?us-ascii?Q?klMnF2TFMIN0IQkN4DkFoc9fDq6km2XAV9di76wgkbxJIZQMf+AFpZBukFi0?=
 =?us-ascii?Q?ABFRoeihhFIkvOd1vPKwTE+x+mwgbDQmMV9EKBBnayd2VJLsXO659emef/vJ?=
 =?us-ascii?Q?GkAcNqX+rA9wNQaPxNRSZ7wJAtWpEqXNTWzILwX+GVVwSaWTmfhoQHlSVKFZ?=
 =?us-ascii?Q?bB1bDmmvgCpX62K//5oOyH9uyCSPMIrUhafXNCnNIotwcjnuf4oX7jjp87pp?=
 =?us-ascii?Q?zcHQFK0kV9FB9uPGA0HVH7uTAXJSppGvq3SjFuTiUY6cBX8vPAY20kqUQWug?=
 =?us-ascii?Q?QR+Ntfn/IP+VT3GAJvISyOGTOn7eStXPO2RKcI1dqhqV/L68zRNyxLgahAQZ?=
 =?us-ascii?Q?CImHuoSaQLV1ndYtvX/MxvCZHso5W8+nz+7rEfvc4/KJwaKoNP/PmJJ2UuvR?=
 =?us-ascii?Q?yM5AoCdvMAEPodyw6AzDM+IrYERfJ4r+lMUj+LO5/CoKSdcrKazh5OM3De9p?=
 =?us-ascii?Q?nmA2Jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 027c082f-b7a4-42e2-2671-08d9ba595e59
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:45:24.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQr/rhaWQQJRRV+dqyGRyCwkUEImwZ+5uN2z4tFawgVwWUy7I8DgO1xAx1xS4MR2E4QGuatycp+bPn/naB03DPTGnsZFgqaQn5uODry3sEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3668
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10191 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080092
X-Proofpoint-GUID: aHoEoPKF6yQ3u4X4zZQQJco2OR9qOZi6
X-Proofpoint-ORIG-GUID: aHoEoPKF6yQ3u4X4zZQQJco2OR9qOZi6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid double free in tun_free_netdev() by clearing tun->security
after free and using it to indicate that free has already been done.

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
 drivers/net/tun.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1572878..617c71f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2212,7 +2212,10 @@ static void tun_free_netdev(struct net_device *dev)
 	dev->tstats = NULL;
 
 	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
+	if (tun->security) {
+		security_tun_dev_free_security(tun->security);
+		tun->security = NULL;
+	}
 	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
 	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
 }
@@ -2779,7 +2782,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 err_free_flow:
 	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
+	if (tun->security) {
+		security_tun_dev_free_security(tun->security);
+		/* Let tun_free_netdev() know the free has already been done. */
+		tun->security = NULL;
+	}
 err_free_stat:
 	free_percpu(dev->tstats);
 err_free_dev:
-- 
1.8.3.1

