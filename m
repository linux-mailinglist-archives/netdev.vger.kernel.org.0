Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490576CBFA4
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjC1MsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjC1MsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:48:15 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F93196;
        Tue, 28 Mar 2023 05:47:55 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SB4FE6021590;
        Tue, 28 Mar 2023 12:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=clL6/maiVcTar12v3k3goq+0Yhxf+hUkc66QkZPD+PM=;
 b=oQuD2R9lpQchjMe3L3RlwMGpYuVNveltUIloT44EK+EN5dxHrao22Ss0lWQAmC8FuNhb
 jRQUJrrj+GTyBcnlM3LpipG74CLRXGGj5S5pXGLwDntSyKlSzY2B2mj4q88bfwWYmfTw
 ac6+EJNjIMVDxuudci+rIGdVfwxWKlbm08c2tTVINDAQEcZhbEPUBtJxOArPSewA/bQ6
 ussdcJjhiaM91xfyX2dZud4l1fTPXf/voBlTuMrYjavkruBeCbK3sxhtWdu3d8z5J8UM
 tcA2yGxs2T+AiMB5bm4c08CpLDKM0aX3wdh2no9vAI12YLoclN6NaMTbZsbSxDREr5uV Sg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3php6439k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 12:47:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jq9IQnlQY0Gqjnr2xJ7ExflXHRNW0l1WciZThkZRZpluKuAGOIbQnEkH1lEXcPuzmB21V3SHvGS3Z6RyfNV/35f1dWXltdNWm713libw+jppi5z1o0HfZOJ4K/aSg7bhPQ3pjdbSXck5Lx4Gw0QmVwRk938tTO57ZWmBzmkh1OEOFBDcoa8pkbzPGfWsUDEFoyFRPFPq4lSy0tfpH4bzqPHChLBvW19rnYx79eeS+du1A7a49Lc5HrnC64pdkfpA3ZbljlaBxwzX8kY5u+TNRkJ2AFFB8K/wZLsHUBmDDHS1ZrloIHErjTeTVKilZEhn/Yg+NA3xzcgNZDSpgkrxUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clL6/maiVcTar12v3k3goq+0Yhxf+hUkc66QkZPD+PM=;
 b=GN0s9+b91b+ng28QkHW0NJlLztWZUKKsohBKaIvp/lMY7+LXOxTuzz54oXAIXauV6NAHDLTtrKEGEUwQKgS5ycvdaV6cob66o+wzOwLggeGgzUdJF8vndGGl68g0D4ZPeFBOegji16Ub3i7XwDWAguC4on7UdFajYWsB5MfgE5kGaBuqjWKp0RYb2ArW6uLD0Z6S3B6Fk9I+4UqczTgJ0KCWIhm0r5BZTCBvvAICoCN7r0zWnfprmdv2uhqMPDYunOEGsysLtq/hGEfKYB6QhUiZ4pt0/12cutMpw1JPwdIYkYIJ6IjaS1+EI2bnkIl8sW88MnZGH3kwTX2FjFmxEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by SN7PR11MB7466.namprd11.prod.outlook.com (2603:10b6:806:34c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 12:47:09 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 12:47:09 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 1/1] tun: avoid double free in tun_free_netdev
Date:   Tue, 28 Mar 2023 15:46:28 +0300
Message-Id: <20230328124628.1645138-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328124628.1645138-1-dragos.panait@windriver.com>
References: <20230328124628.1645138-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0050.eurprd04.prod.outlook.com
 (2603:10a6:802:2::21) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|SN7PR11MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 1762c6d1-338c-4cf2-5515-08db2f8a8b05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IS+6rRzAbQhucPrljwRxTr4/6cneeNj//FYhXyeKwbaE1dUXVTVxiL2NRPrT38WkBeqBHsuZwbSHGy6q4EtnTyG+MdBGbJg5daFITzW8a1FaZCMMtZp1Hkhvibm3iabeZgb9Gs88er533nyQOPhnIpePchJmaBYktvUQC3Ti7JjH7IQgSfBq+uyRb6eF0mKgdS/Di7qswhavfeQeWO7fY2lOPUOw3kYQclvp2UGOBZTBYfhc/g1JNFaIMnFGdyf7xIFL79ylD/uqaKfzI3HkbG65K+KP0GeAcau4pt19XMH9Isg20ELEz1qlDelsJrlQn2hkCpHw3IASLexXNlLnUdq9Wpyg2SsqiYHoqKLsmdvmxx7turVUNG9nodi83iNE6ideYX9b9uJiYODwyRY8OaMKoG75gC4Jjw7KLFS5wdT+tJFqOrvvPJpBn+MDbDyaMUdiq14SGaJbHnHPy9E0Y0xVsp1dau9aOx1z2OhyEEB9JQszD90cgQxzxfzZqimu+Ld/Ex1osDeC9fjAJQDEa7Wf9BcP/Sn4kjxCETkrE4Zub22waBpSKksWQB8UPxw9BfsuTVraloRC8/Fp8LI7Fx26Xc4WOoofjq00rvoNvZ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39850400004)(396003)(136003)(451199021)(66946007)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(6916009)(4326008)(66476007)(8676002)(66556008)(316002)(8936002)(5660300002)(52116002)(966005)(186003)(83380400001)(26005)(6486002)(2906002)(36756003)(2616005)(6512007)(6506007)(1076003)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ln7z5gOu4nkknQvGLGjbiurf04xusbd2yX9MOgfZeGaCzRHOfWdLMMZThAu0?=
 =?us-ascii?Q?5j664x1IwQ/kCqmfNbwfCrs0zxj1gWf/vlmWk5sVCRI+weX+zCx5N6EpGUwK?=
 =?us-ascii?Q?RX/V4ZNTvBXvQCqxTKqmMXCyYkzmQJ0XoM+9gf9UEhUHK0RVkhS7rw/HardB?=
 =?us-ascii?Q?2IiBw9gGwBxQlndlOKUrlIcITZFgImYqsvcfxHiyTQxY0AC8zSmgnoSogQtt?=
 =?us-ascii?Q?d6x+Lun9SKjZOOgYcdyLc1QYRLqs6RlSs4mMxqHnZTiyvuwg++AFOmg3VH40?=
 =?us-ascii?Q?jXtlzjk5f4dPM2HhLw7jkioN0V9d1E9tJUCF2eLcDtB/TG+J1V6iJlBtlBvf?=
 =?us-ascii?Q?yB80B/fK7Zq6VTNZVXXqO9s4ya5Ntka6X+J/S7xKmdC2QiOHMF3qh09c2orG?=
 =?us-ascii?Q?Jc4Mh1t6xXuqIsH7/xBP4aRgObLKOtQIPIDJd2j5/hAMl3CtKaP6DQkR2n4J?=
 =?us-ascii?Q?h+xZKEo81Ii59muPx1f7KxK+5eH4z0VzjkNXEHH8lu2j0oLcSq+qpJb24FLP?=
 =?us-ascii?Q?iv1ElYCh5at0soifuesxxm1brfyKNCobHSb0dOa7aYSJ3IRvqV2CnBrcMGTu?=
 =?us-ascii?Q?zJ6HHiIv1nH/jhOIQ1sD89nRbycgdUrhZz1y32JQDbCGrxBfDJJu87vhm+BG?=
 =?us-ascii?Q?CFwrWkQLpl/7w7fJxVNY5i2KXSECCjkm1dh1OGWvDpfOjzk+Kniy8LtkgmzS?=
 =?us-ascii?Q?1Sr5nlz9LHGvGzOkvKG+fLDubKB49VLNvl28uiNUog1udMopdE2g42sj3Qaf?=
 =?us-ascii?Q?V9lRyVKq0qB1bd6kLjwneOuHKVzDBEJtnkACnL55bVqn/l8AGufPEG9BTu5F?=
 =?us-ascii?Q?YyS8HXeoWC6CKUniHUh5UoinSwxNljAZxGVE3omxy4uUfS2G75P9ARzX7GkJ?=
 =?us-ascii?Q?9o9l7TXVzS8sgCAKcvXbLg5f3lbpz8n+xXJUBkYX0L4qWlWicqK9+Jtm9cJH?=
 =?us-ascii?Q?ptUd9yIHcWnGIGZStVa8XlcaIM5bTPJpIzL1x8hqqHwRP3c6kyEoiUJ5Wby2?=
 =?us-ascii?Q?DwyWOTumoyw/PGVX18pixed/QRE2FDOScHgKFZKqeDTQCrdTXV/md+3mwm4e?=
 =?us-ascii?Q?z5oET9OIdQu+0KDS4Yc4d1HE3TveslKVh3RJbKtQEviXDkKiLDsg1v+GOrwC?=
 =?us-ascii?Q?Fke4Jt0elPRfgQQRAV0dkh42rkIZ9PRuMyNHqvCxdR39Ru6i1VEHo0g0aVwM?=
 =?us-ascii?Q?vGabxOsJT9o0+lyiHNcrvNe46I44M4VSc8UR/IclHwKX6hokAtHS9PGsT8oW?=
 =?us-ascii?Q?G5e3Es5i9T8r0U1WomZW8fH8j0IS+Oft/s+9aTHsOODwUVGXIkRT5orRWMkV?=
 =?us-ascii?Q?XTAREyy+DBFUGQ/DvitKqJ0lPrX2xjy92Rq/pq6QD/BKkVxDSkdUacwDaXT6?=
 =?us-ascii?Q?LyAOKBecnuso/qYTdR6PHSuuA35uYuXP6jK+XFAiARirkhEdEiGcB9eWGApY?=
 =?us-ascii?Q?2G4hewkYEbWOrmTRbwN63sm3b66U5rTn5LAmJ2c1oXs0zzVHXRYgy/T8yC39?=
 =?us-ascii?Q?04JIEDkfIfx1GDlh+Ny6S2YmfnVGgCKIrb2uUye1olOeae4+g2pTuGunW7S4?=
 =?us-ascii?Q?oHuJSptpnVG2Fw2bq62ImR6Jfdj4dYn22mjb//41oYV+ZsL+R3/Tj9FUchVA?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1762c6d1-338c-4cf2-5515-08db2f8a8b05
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 12:47:08.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xrpnnb3lgVPOFoxBwqNG20bqvqtBPe2BaAg0cYktd3v4WxZ059/dbRiiALAtjd0jFuFNpVNRBXE/sS5rAwaiqsVumNqwRz5Q1MmVm3sxaPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7466
X-Proofpoint-ORIG-GUID: fjIOoyAmL6_2Gl_lAYyF9o6tZCommOu2
X-Proofpoint-GUID: fjIOoyAmL6_2Gl_lAYyF9o6tZCommOu2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280100
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit 158b515f703e75e7d68289bf4d98c664e1d632df upstream.

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
Link: https://lore.kernel.org/r/1639679132-19884-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[DP: adjusted context for 5.4 stable]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 drivers/net/tun.c | 109 +++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 5d94ac0250ec..a4e44f98fbc3 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -250,6 +250,9 @@ struct tun_struct {
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
+	/* init args */
+	struct file *file;
+	struct ifreq *ifr;
 };
 
 struct veth {
@@ -275,6 +278,9 @@ void *tun_ptr_to_xdp(void *ptr)
 }
 EXPORT_SYMBOL(tun_ptr_to_xdp);
 
+static void tun_flow_init(struct tun_struct *tun);
+static void tun_flow_uninit(struct tun_struct *tun);
+
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -1027,6 +1033,49 @@ static int check_filter(struct tap_filter *filter, const struct sk_buff *skb)
 
 static const struct ethtool_ops tun_ethtool_ops;
 
+static int tun_net_init(struct net_device *dev)
+{
+	struct tun_struct *tun = netdev_priv(dev);
+	struct ifreq *ifr = tun->ifr;
+	int err;
+
+	tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
+	if (!tun->pcpu_stats)
+		return -ENOMEM;
+
+	spin_lock_init(&tun->lock);
+
+	err = security_tun_dev_alloc_security(&tun->security);
+	if (err < 0) {
+		free_percpu(tun->pcpu_stats);
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
+		free_percpu(tun->pcpu_stats);
+		return err;
+	}
+	return 0;
+}
+
 /* Net device detach from fd. */
 static void tun_net_uninit(struct net_device *dev)
 {
@@ -1285,6 +1334,7 @@ static int tun_net_change_carrier(struct net_device *dev, bool new_carrier)
 }
 
 static const struct net_device_ops tun_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1365,6 +1415,7 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 }
 
 static const struct net_device_ops tap_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1405,7 +1456,7 @@ static void tun_flow_uninit(struct tun_struct *tun)
 #define MAX_MTU 65535
 
 /* Initialize net device. */
-static void tun_net_init(struct net_device *dev)
+static void tun_net_initialize(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -2839,9 +2890,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		if (!dev)
 			return -ENOMEM;
-		err = dev_get_valid_name(net, dev, name);
-		if (err < 0)
-			goto err_free_dev;
 
 		dev_net_set(dev, net);
 		dev->rtnl_link_ops = &tun_link_ops;
@@ -2860,41 +2908,16 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
-		tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
-		if (!tun->pcpu_stats) {
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
-
-		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
-		dev->features = dev->hw_features | NETIF_F_LLTX;
-		dev->vlan_features = dev->features &
-				     ~(NETIF_F_HW_VLAN_CTAG_TX |
-				       NETIF_F_HW_VLAN_STAG_TX);
+		tun->ifr = ifr;
+		tun->file = file;
 
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
 		/* free_netdev() won't check refcnt, to aovid race
 		 * with dev_put() we need publish tun after registration.
 		 */
@@ -2913,20 +2936,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 	strcpy(ifr->ifr_name, tun->dev->name);
 	return 0;
-
-err_detach:
-	tun_detach_all(dev);
-	/* register_netdevice() already called tun_free_netdev() */
-	goto err_free_dev;
-
-err_free_flow:
-	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
-err_free_stat:
-	free_percpu(tun->pcpu_stats);
-err_free_dev:
-	free_netdev(dev);
-	return err;
 }
 
 static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
-- 
2.39.1

