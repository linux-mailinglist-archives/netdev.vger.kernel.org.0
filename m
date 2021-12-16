Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8825E477B81
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbhLPS1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:27:39 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58082 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231582AbhLPS1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:27:38 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGHV9Sw019014;
        Thu, 16 Dec 2021 18:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=2vF8Ar1SlFr3Wea0iq5bQmUEXQwzsaUzd0RTFphP0Cs=;
 b=zZfTNXruToNMAl4c4Amru5H/SX9MsWoCbyc3P/YQ2g9mk3k7Uh7cwYo3/lqcXr9Kw9HF
 Fq1eSkdZUt0PjHLi8KFHWIb/wZGn7g/RzBUz9dfUNUItwvCDaot/yw2pHuMUlyUnFmT0
 fz4oZX+z0QOhvLEl6RV6S6UqiMDNrvxWwpZheaqi9cDXh4Sz42U9E1xQT91lPmBRarEs
 E+MpLmlzve3LZMfyQWkpIEIR62Z+x8fGNL75dmXTwR03S6Pn9wqVAzJ0MLvu0AE+SGtT
 wI6IDQSYkD+TAFvrolMuAfR+JIeGBZJ/ck857rS/d1B8Cj65G40f48og9ent0AF7oC0g xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknc3nkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 18:27:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGI9qxe124830;
        Thu, 16 Dec 2021 18:27:32 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3020.oracle.com with ESMTP id 3cvneu544r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 18:27:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAQBV6kUD18/W9NOZVe9epFm9BSRzbqklvfDGI3R6BRJG18L29SY+UqM8oJ/8cvnN7Z8kKFbu2U3BuZ7WiT21XP1i7mdgzryULuZjB3wV4CgvVyyIxMF31e3xS6PojrreKktJj27y2TwUFFDod2g38UZk9FV77t8/dPhj10ZSXNm/gpm7EK7w0Y7K3nUpi5TISr61HBc2BE4osxq02gmdxK+HDJIjLoMR46QXif6K2E7T5VV6G1iE5jGR3ZusAyhY/jGMv1eo90u+UdfcMqpTxii7UVw7IZUGsgwWZYm800+uMPQoQAHSsei8STmMCF1VZY+IMyZzK5SpURJBAzcTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vF8Ar1SlFr3Wea0iq5bQmUEXQwzsaUzd0RTFphP0Cs=;
 b=BCHb+z5WhXGOJ6NHYm2/DguNDZh3lALTeG6Ah3ywbJ+KVK0ODJBVGVfwlK7b3TsN26A980XEsXFg5PJTtva/fCv7OqmY0BUhw79ESpqAfLMtRX5pBr2l3zzeNxoNVODN18ABn9uVJvz6dwhpiGqUw8ibtxpRMp8a485FWDV3d13isCJnXBAybCKUv5dkz4YKrvpMns1jnW4IGgVtt3VealWZ3rR+4kG3qIll1Rw/VN/3/XmflhaKFnjn9wwYP/CbkosstNEyJbYDikNiBi27RdwqcDCWWxHRZByq57ljdCeZXM0GleXoKCGOM3KVXfZ3v/itkUbKh4JOw8bNZ4J+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vF8Ar1SlFr3Wea0iq5bQmUEXQwzsaUzd0RTFphP0Cs=;
 b=yGgWCjTK6gLwSreXQCAki82mP9fr6JsL761nCHryFxWIhtA9aPqg/ja6EQGtSO6ZBh+WMDC/+EfpTVNGSowDz3LKT6OzKM4xgFl94iV5P7NyLTbnWI89WcLOu51ITxp8rcs97Zzhib1sGACW5JIjsanEafutijBvhWQwrh6NTvA=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5319.namprd10.prod.outlook.com (2603:10b6:408:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 18:27:30 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%8]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 18:27:30 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     kuba@kernel.org
Cc:     george.kennedy@oracle.com, stephen@networkplumber.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] tun: avoid double free in tun_free_netdev
Date:   Thu, 16 Dec 2021 13:25:32 -0500
Message-Id: <1639679132-19884-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::46) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34fc925f-44b4-42e0-e0b6-08d9c0c1b843
X-MS-TrafficTypeDiagnostic: BN0PR10MB5319:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB53194C250D4900297372DD45E6779@BN0PR10MB5319.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whBd0qEMTqlPChthYZ4hGSO1CVgx9SC7m0AGYF373iZnNx2W8TcW6isPIYShKu1oGfGoIH0FcvFCEdpXplCt107pf86G9sTPf6GwB680NxL1sbQRUh2bgr7E7AC7KRoSXO8KMTj45mYLWheWlPSUgwpulHCzaoWJszdUt+Gi0lkH9a1Q8BAWeTZll8kDpPECeNI9aF8IkNT4KS+9cEsMjweTM285c5LSU2TB6fougXpAoz3m+OvP3UbKNDg76gux9E2ETZ4A738TODEBy6wrx+54qlClwhDZETyySWpjTcQcnHq8sSzBSDvvrWUi4opMTGcgx/Bpp2fHPj9X1E74zrVOX8Zpz9BHDFZDlKxne2TBWdDdMFXAu4Zu5TnVl/GtiMoqIsfx4YfRT1chp2N22Hl5PXJsI1MmtxMAo3lEwQQVGvrBoOytkMXiz6XfMokauawytLEKgLtblwrcuXdJYtYS/0INXBULGBLS5RHH7IecVsoQKVmZYTwvOhS+Kn1aGglbI7g/TlVhV8KdquIsmep7p8f3TVtKPvz1R0mAlNka2LNBpO7/5NFRTN5Z+/7vc9CQIPM7kp2l3h2taYJJHjdh2ZAiC2oR/Fz0oYpI/hQ7qDIo0vGcrwzucI24PK3RvlWWMnn8Scyy0a8GmZkdLCvE+orNxCL/C/snn/pjsyoiBPOr5dsXcqPE/ixt3mYRVAsM/Xtc8K1U2YROfkiEHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(316002)(86362001)(44832011)(36756003)(83380400001)(66556008)(66946007)(38100700002)(186003)(38350700002)(2906002)(6916009)(5660300002)(26005)(6486002)(508600001)(4326008)(6506007)(8936002)(8676002)(52116002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iGrUgbLRe3JXO/GI7B3cZhpNWt6bbN/w9aTtwP5d/P1TIppi8yIIgpoPSp/u?=
 =?us-ascii?Q?vXryC7DaNjDJwVVEMUKJn8fTTHK7Ape1zzv5IAX92Zg8ML6burGiZbplCeqm?=
 =?us-ascii?Q?8D4XmA1+S0Greux3iwfI0fRWMsuEjjKxIVb8SXncFv280EXAbbqeCZkQJgtc?=
 =?us-ascii?Q?2wxb06hMYXXrcjtwo9SaRdz2SbSzhd32C2fITMFYwQQAP8M1KQE0U00Afo3d?=
 =?us-ascii?Q?/jfNZdPHhHaZM3FEgSsG/GWBZj83yAmvTaIjLb5VeNs4x2mt40hZZoTs6/5i?=
 =?us-ascii?Q?IG/1X+1wNC7fEU8dIv5P7pnli3a792/e+ktiJcMSkxgovRvhXmzX1wK8iRfw?=
 =?us-ascii?Q?0Sgv7QCYYb2szic/RrIEMP5RoIlAL9da1Fnn/HyBBsxmyYiqVkk9WwigKpg1?=
 =?us-ascii?Q?8lT7w2uwAvGz6WeE5Z6IHFmb2YJI8PavQfGrK4fNAfDx++u4humw4PcHgAYS?=
 =?us-ascii?Q?la3oeUBoDUSFW0hkZe+yz4WKiJinCCA4SiyMjb8RZPmrxoETYus8Uzdxd1L7?=
 =?us-ascii?Q?C0Zg1SAlevWHQt7+yadm3vSk938Cyr+vkEMi08KR5Yj+D4aa0mfaSVZeN8W/?=
 =?us-ascii?Q?Sl8oLOP00yMJBUNcQze74bdw4J5NN9P5+2n7G9SnsRQXxQZDoaTBwuFkzGV7?=
 =?us-ascii?Q?wF7DoYpXAuWZlG+UFy3OuofRpNFfqhLuPjqoQLipVQQti+v4HcoFA8cJsSXt?=
 =?us-ascii?Q?hWGd6zw+ePKfAl6Odf/g6gNACqkeqQ4OAlHNy08JHMbxdtIEZvLT7uzsaPM+?=
 =?us-ascii?Q?0A1wHlbShGjEF2EI9Plh2N2zTduukk4uy8UcLwKUc1rMVfh6z/5dr/nzXR+o?=
 =?us-ascii?Q?hBCLBx+SfBagdYc6qeXacYwSOE8ZPcWujt12yrb8jiUVKyPuV3GdNbHUbN8L?=
 =?us-ascii?Q?bm7CD4UT3cND36PQqgAqgZRxuRLfAUOyD+VWLrXjlHxIJJd3c6Bq0Ys9HpW9?=
 =?us-ascii?Q?8ZZ6b+QIKGw2XOt+sL/qafefxK9hqOuaUO0N3uzLHq9U2GmSwPO9ISeBh38O?=
 =?us-ascii?Q?ZwbbcCIsTiSK8nsHI5ojfIerDxsPzkH2WxuRdwWaw3KDMLQbAT5QsEbvAL17?=
 =?us-ascii?Q?MliYfNIOF5KxNONrzQUr6Ieiumdoa9GeQsMdXm8nJJphu5J3erRlffRfMgB+?=
 =?us-ascii?Q?3oix+1JkflOdCTZjWtjxt3KvA3XbBJ6oU6Me5mJA59RhLYRBDfPsWCAd7XfA?=
 =?us-ascii?Q?6+ZZD+Vvg2Ev1zDxagYs1ZBqB3JdjYnP2Zu7+XXm66hFw5NoSOvfaiXKGiBG?=
 =?us-ascii?Q?BWZxT4XZVEtwclFG52BI9gEoVD9N8cWm28E811c+Wz1qpZRirmTu1ZsFZDFX?=
 =?us-ascii?Q?32w3pk1iatMl8JbIkws484bqkihciSD16o3Dpd2EWiSULYbN3C2WCiWLM4sX?=
 =?us-ascii?Q?VTGTxvD2/eBqOfyTW9b3RfBbIvfdHFtEKnVXpH9N5piCgGh7jc2oQ87e1bl8?=
 =?us-ascii?Q?dp5qnhS+h3I8DcLpyN7rRQnvj829s85IyfjVL0laXpL+9YeWbK1iVMBsVhw1?=
 =?us-ascii?Q?tapEfCm+WHqspGaUnHvi83octb5T3E20YpbrDGYknl9nkvhn7Qsoj50yPR3O?=
 =?us-ascii?Q?Kz44Z9guifj2R07jHILTskLYzKKeL/gxyLnb+ssskFVhrC7Xh/6k8gCGxtvO?=
 =?us-ascii?Q?re7gNxBEFX9A4Xycna3ANVmnPaET2/wE5HTaewxeOdL0uAGfyAyv33026mA3?=
 =?us-ascii?Q?DYv6VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fc925f-44b4-42e0-e0b6-08d9c0c1b843
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 18:27:30.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JBNhw1tc9sUcDx7PsHIQ/U81orS/uLFwbTuTT0MR5M7IlpOtqApuuep4EK6gJprkPiGya0xCcs9RFQYnKcsFSTIxN3D11WedHVhRiG+JEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5319
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160103
X-Proofpoint-ORIG-GUID: IqibyxfI-H25MKISp9STxmbZq64F2Gnn
X-Proofpoint-GUID: IqibyxfI-H25MKISp9STxmbZq64F2Gnn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid double free in tun_free_netdev() by moving the
dev->tstats and tun->security allocs to a new ndo_init routine
(tun_net_init()) that will be called by register_netdevice().
ndo_init is paired with the desctructor (tun_free_netdev()),
so if there's an error in register_netdevice() the destructor
will handle the frees.

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
Suggested-by: Jakub Kicinski <kuba@kernel.org>
---
v3: added a new tun_net_init() routine called via ndo_init, which is
called from register_netdevice(). tun_net_init() does the dev->tstats
and tun->security allocs, which if there's an error in
register_netdevice() will be freed by the destructor (tun_free_netdev()).
---
 drivers/net/tun.c | 115 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 59 insertions(+), 56 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1572878..45a67e7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -209,6 +209,9 @@ struct tun_struct {
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
+	/* init args */
+	struct file *file;
+	struct ifreq *ifr;
 };
 
 struct veth {
@@ -216,6 +219,9 @@ struct veth {
 	__be16 h_vlan_TCI;
 };
 
+static void tun_flow_init(struct tun_struct *tun);
+static void tun_flow_uninit(struct tun_struct *tun);
+
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -953,6 +959,49 @@ static int check_filter(struct tap_filter *filter, const struct sk_buff *skb)
 
 static const struct ethtool_ops tun_ethtool_ops;
 
+static int tun_net_init(struct net_device *dev)
+{
+	struct tun_struct *tun = netdev_priv(dev);
+	struct ifreq *ifr = tun->ifr;
+	int err;
+
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
+
+	spin_lock_init(&tun->lock);
+
+	err = security_tun_dev_alloc_security(&tun->security);
+	if (err < 0) {
+		free_percpu(dev->tstats);
+		return err;
+	}
+
+	tun_flow_init(tun);
+
+	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
+			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->features = dev->hw_features | NETIF_F_LLTX;
+	dev->vlan_features = dev->features &
+			     ~(NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_HW_VLAN_STAG_TX);
+
+	tun->flags = (tun->flags & ~TUN_FEATURES) |
+		      (ifr->ifr_flags & TUN_FEATURES);
+
+	INIT_LIST_HEAD(&tun->disabled);
+	err = tun_attach(tun, tun->file, false, ifr->ifr_flags & IFF_NAPI,
+			 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
+	if (err < 0) {
+		tun_flow_uninit(tun);
+		security_tun_dev_free_security(tun->security);
+		free_percpu(dev->tstats);
+		return err;
+	}
+	return 0;
+}
+
 /* Net device detach from fd. */
 static void tun_net_uninit(struct net_device *dev)
 {
@@ -1169,6 +1218,7 @@ static int tun_net_change_carrier(struct net_device *dev, bool new_carrier)
 }
 
 static const struct net_device_ops tun_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1252,6 +1302,7 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 }
 
 static const struct net_device_ops tap_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1292,7 +1343,7 @@ static void tun_flow_uninit(struct tun_struct *tun)
 #define MAX_MTU 65535
 
 /* Initialize net device. */
-static void tun_net_init(struct net_device *dev)
+static void tun_net_initialize(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -2206,11 +2257,6 @@ static void tun_free_netdev(struct net_device *dev)
 	BUG_ON(!(list_empty(&tun->disabled)));
 
 	free_percpu(dev->tstats);
-	/* We clear tstats so that tun_set_iff() can tell if
-	 * tun_free_netdev() has been called from register_netdevice().
-	 */
-	dev->tstats = NULL;
-
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
 	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
@@ -2716,41 +2762,16 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
-		dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-		if (!dev->tstats) {
-			err = -ENOMEM;
-			goto err_free_dev;
-		}
-
-		spin_lock_init(&tun->lock);
-
-		err = security_tun_dev_alloc_security(&tun->security);
-		if (err < 0)
-			goto err_free_stat;
-
-		tun_net_init(dev);
-		tun_flow_init(tun);
+		tun->ifr = ifr;
+		tun->file = file;
 
-		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
-		dev->features = dev->hw_features | NETIF_F_LLTX;
-		dev->vlan_features = dev->features &
-				     ~(NETIF_F_HW_VLAN_CTAG_TX |
-				       NETIF_F_HW_VLAN_STAG_TX);
-
-		tun->flags = (tun->flags & ~TUN_FEATURES) |
-			      (ifr->ifr_flags & TUN_FEATURES);
-
-		INIT_LIST_HEAD(&tun->disabled);
-		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
-				 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
-		if (err < 0)
-			goto err_free_flow;
+		tun_net_initialize(dev);
 
 		err = register_netdevice(tun->dev);
-		if (err < 0)
-			goto err_detach;
+		if (err < 0) {
+			free_netdev(dev);
+			return err;
+		}
 		/* free_netdev() won't check refcnt, to avoid race
 		 * with dev_put() we need publish tun after registration.
 		 */
@@ -2767,24 +2788,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 	strcpy(ifr->ifr_name, tun->dev->name);
 	return 0;
-
-err_detach:
-	tun_detach_all(dev);
-	/* We are here because register_netdevice() has failed.
-	 * If register_netdevice() already called tun_free_netdev()
-	 * while dealing with the error, dev->stats has been cleared.
-	 */
-	if (!dev->tstats)
-		goto err_free_dev;
-
-err_free_flow:
-	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
-err_free_stat:
-	free_percpu(dev->tstats);
-err_free_dev:
-	free_netdev(dev);
-	return err;
 }
 
 static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
-- 
1.8.3.1

