Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31126CBFD2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjC1MxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjC1Mwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:52:42 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339ECA5D0;
        Tue, 28 Mar 2023 05:52:16 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SC0o2W032665;
        Tue, 28 Mar 2023 05:51:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=n7PjwWCUCL72JXvD3DnYIhOiQxswbBMOTLk3HRZmI/0=;
 b=cvZaIJZcj0NE2mEkQc0g8hDtca02/o11saCnz4n9EqgB+JTiCJ0a0/+31U0sr7sfgjfZ
 LazdAv7CGUxeOE6BAm9pgwl8OyBbNhrFIqgdtRz5MNgRVb4FMOp/zpRHbCcUkamGDiPX
 HQJppRjI4yhK9NVn1B3uzKqE2Bi9VdOFrC4an+o2vTdFUf8NbuJMDrmwqcLrUKfPr6zB
 v84uEV5wcKQacvhrV9ZF0AxfmyEVHV93Pb2+G6mTzhvp+UTWji5avqu/+dnZ8UhdMXYo
 j5aETdeTpnve/qWK42mCdUywKNth/rUx+n8RYPaFExKs5YDLU0BfRjaoacLR+D2pncnN EA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3pj0fn2wnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 05:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loateqTd7FDnhLrpfGSegLVdqJTY68y80tnWYsIs2p2ux/xGPke6uP4f+7x/UZ85CYPEhHVZCNLNEZaVLEvdFjAd03qHqdmAeaE0CDZMw2ZwSAGBAl7OJ7i5Pcr+w7FMCEH5eZy1TIx56s08e9JXy+9EDHtO2x+EoZ0GsApiaRKHU6qYE0ZOsEhpSFWSWNhNykP4Do0nm3hHQ8YYvgrfqh2EoBKZhUo6ScFWUvX9LIvc3oRyv5xclOVwur3JC3GUdNMKIwcWdY9MHqt+t6jdqk5sxSUwuzWMYbRF+WLbR99EqjzJcEFS0IAhtgmeQqjjDOIpP3MX9zfufXrnbfzpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7PjwWCUCL72JXvD3DnYIhOiQxswbBMOTLk3HRZmI/0=;
 b=D/8HLb4jX0bXBlaBPW60aUQbRZqCklzZ/RmRPj17CP6j91hitRIs7+VbIi7+xBu40LWEB5OCMMO2lE0uYae+uT/x4XN2DNrhmAaiwIWN/w4pDsBAi1f72iW7HRkvdY3HPp6PRPp/1NWWxNtZ5AsW54WgGT478ysfE6FT15wRIeiGJA5chr+hflo6MUqsXqHZqpATHtQRhm7bBioG41/3UfuAEtIbcTi4K/vnhzLkRd5Sd9SXPRAIP6lRNOpJuuzV+lFf2XHuf9rfb9bYykGtQqoG+eYQQ1NJsVu0g9U9nl+dQjOR7b7l+XYEFJkWZw1hgl6X87wnBre0nZSI7S6owA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 12:51:24 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 12:51:23 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 1/1] tun: avoid double free in tun_free_netdev
Date:   Tue, 28 Mar 2023 15:50:44 +0300
Message-Id: <20230328125044.1649906-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328125044.1649906-1-dragos.panait@windriver.com>
References: <20230328125044.1649906-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0020.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::30) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|MN0PR11MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: 122320c5-07a3-4e9a-c8e7-08db2f8b22e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cckYW5cjllnJ+lsANxNnI/ULr4JsYIXAz0OK58Z7BmFAhY6G9kZYUii0UkA8ZRf61ZtFHBugVmO+VX5uWAjZJ7WTZAAANhCkHfu+hIu0cU/d0XEi5y8VP3PzoPkfy0iWsFm3peRFwy6gRFOMaWz+T9BbOXYhGRiLFNFZKJNQwrvS2QC1gG/DcyWXbIjZ+bQMQTXT8QluGIUWOUqo5b20AgHi/3kSJ1hPwaX61p+ODl5kzU1kEvOA7e2xUi3F0pAUbpUtmNOtF17Ce7yZmJBwKFd5wUTi1UyyNkjMVenKMAtwdVC+INR0ZaE9ZpqTJnAexx0Rw/TJ+zLbDlgVkiI3rKdv0Xk6FcB4gWWyCwyQkzZz8/+xvAOhUR26Fti94dWJpl9qUD78n5NmMvDD81XMX215YyV5NHZ0mnphNxjflVlXlGHZcYsMLN2iB+geFd/6bj0xowJPq5QvPDAIFHm/pW57LK7GJVnkQmUQooBum6Ork26c9RF1OUTywCbBCvdDE95qLZ8uCYkrOw1SUiHhDtCjHjPQVCLfCTqyA3j4AhzW9vCRFIqEEo0Bh2cb6dNE4aPNXW5AhZWe3DKQc1ZRbJSw4/vI7Koso6JVuQyOkSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(451199021)(6486002)(52116002)(966005)(4326008)(66476007)(6916009)(8676002)(66946007)(66556008)(41300700001)(36756003)(2906002)(86362001)(5660300002)(8936002)(38350700002)(38100700002)(478600001)(316002)(54906003)(6506007)(1076003)(6512007)(26005)(186003)(6666004)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VehhNkutrSYvw/YerXFG1pP9DsuPDvN32ke8zvRjNIKGDKZAvkLcYScxBvVo?=
 =?us-ascii?Q?A1Yfvvw9UEX3565h5H0o+orHdql4kVEka4MLCLXn61eCuarAZjFr85ZR9BKh?=
 =?us-ascii?Q?bIuaDU1TUUV/UMxozuIv3rSMWLHFcdmPUR0IidwdCthMWSe3RSTH4gbYtGdf?=
 =?us-ascii?Q?9b01/IGsnBrhb8xZkbqdhfvvxp8H+dkKfuPvV2eAZdWB7uofV4USfEv6+3N6?=
 =?us-ascii?Q?8iJpdR+M0qRNB1vMb6s4G1jMfIYuX5bJ1SurR3Nh6eRmeIML6G/CfWDpCxua?=
 =?us-ascii?Q?p+zopFyUmMU7yF08wAlGFKo7utPah8XgkdNYL2bc/iJLEvg52xpy+uo1wjPF?=
 =?us-ascii?Q?cDkPB2Jt4Q4Y2VC+bs4LxB1cI1IGklYPnGIPX3+h0Kg7Px3hL7E63Oey+WOc?=
 =?us-ascii?Q?GBScbMm8aNXsLCGRK97UsjQhCtmbYAC3UUJ8xCKjReKG8jo4C8bonDZq5Mw9?=
 =?us-ascii?Q?Dci9EfJGvQ+Sp3PTV39OK2lu3lOiUsLlXXHH4dhpVpMHkku038KGrMFZnqFs?=
 =?us-ascii?Q?2Y5duSsXZxFqhFJIz5EMWs0IVPe0EdUCgXmqdXixfl1U36So8Tp/Sd4/02Pt?=
 =?us-ascii?Q?IXsqO3zr2C0Y2sXsmogyluc1DI+A6EEizhqpCJ77xc/YJXr0BcKipKIb03JD?=
 =?us-ascii?Q?SUzPFbleYCRXbJwPIMFDiSPwpCTQRsXSJDVgargSBVOYQTax7vTsURuf2pij?=
 =?us-ascii?Q?M7fMXqbXC9RCRwcX2NuIXnRIV/gTVEJbXDRi/Be8Iy4fcBvPl+rRv9IDC8++?=
 =?us-ascii?Q?qTzZIGipXzGj6Jk58dbdH7RoVYDL2auVCR2SQt/Wtd7U/0qzPZ1kCrpuqZRP?=
 =?us-ascii?Q?rzuLRcVJnR7ewE+LcqOB60YTDXoKwKiuEHfuV7Ep5RVrCgFJedUbkjYDChXL?=
 =?us-ascii?Q?E6Esx5kvD0mjbHwSet/+VIMz5boGCVILEp7346OY9REA0ewFbkgjwqnwC/T8?=
 =?us-ascii?Q?x6s7q4ymNxDlUcX77iQMJbiYVThOCV2a05IEy1Ow32PXAKzmNzieBeG78qNr?=
 =?us-ascii?Q?GrKXiUbtXAiHbJLQJ0ByLeFyng754HFfC5thVu+V9XURpu9kxJSBilSHbaJM?=
 =?us-ascii?Q?WlXitH67Oslhdb+/gGFasCbRJDc2xakGsvQgBWt7V7N/BlBdKW+1CfnRqZwp?=
 =?us-ascii?Q?SIYZSJUke/t49fLNHcllWAzdzC3ITOl2eZykVsc2lJJCB12pOvX7QNU7R0bz?=
 =?us-ascii?Q?Flyk6jhPKimXpKaA1sl2RN66bxYEVb88xMghQJD8mmTqJk1Vo8gHAvsUCkXX?=
 =?us-ascii?Q?Fn+m/QJmXSFT4fdlF9hkRyTB7vL1CRkK3H4I3MQqVLrVSJaT/Aw/QHParVUE?=
 =?us-ascii?Q?Lfo01cxSwYWphIOf6BZ0xutqNdPVvRrg5JwhsdS1kXPpqHMt++8O+PUPgQ95?=
 =?us-ascii?Q?fBd2jOD1dzTojHc+oayjmnJKPKlzGWXEdV5TLUien0UgFyWtXez/EmxiJ99M?=
 =?us-ascii?Q?ZOb4C38Pfx6AWM+T4dahSB2X/v/hWjz7PeXKG6y9QJbFRS6CMUJyQ3S4L15t?=
 =?us-ascii?Q?sJhT6ecPdvTxsYAl0rXJqfvE8cfj0+QhPMSJGK3VkQZGW5FgkkWuIhRJfkmF?=
 =?us-ascii?Q?dYxeEuNQvO80Or8yo/DtHKYX2MysAf0vX+xWeE4YKrGXzBKY50jiylbzIH6Z?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 122320c5-07a3-4e9a-c8e7-08db2f8b22e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 12:51:23.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpCEBkQK4ODN+qaDYWXgpr+X8P+ZQoVwA0bQOERZ4vAaVCmrZBKYIbXCTAnsqhX9eUmN+b1YO23IATBGI57Anjl1+aUiO9RH7CI/0GOh/BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-Proofpoint-ORIG-GUID: kGANGOUqaucJVtdNd3LdZQeCCFYl3txk
X-Proofpoint-GUID: kGANGOUqaucJVtdNd3LdZQeCCFYl3txk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280103
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
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
[DP: adjusted context for 4.19 stable]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 drivers/net/tun.c | 109 +++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 5194b2ccd4b7..e61f02f7642c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -256,6 +256,9 @@ struct tun_struct {
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
+	/* init args */
+	struct file *file;
+	struct ifreq *ifr;
 };
 
 struct veth {
@@ -281,6 +284,9 @@ void *tun_ptr_to_xdp(void *ptr)
 }
 EXPORT_SYMBOL(tun_ptr_to_xdp);
 
+static void tun_flow_init(struct tun_struct *tun);
+static void tun_flow_uninit(struct tun_struct *tun);
+
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -1038,6 +1044,49 @@ static int check_filter(struct tap_filter *filter, const struct sk_buff *skb)
 
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
@@ -1268,6 +1317,7 @@ static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 }
 
 static const struct net_device_ops tun_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1347,6 +1397,7 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 }
 
 static const struct net_device_ops tap_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1386,7 +1437,7 @@ static void tun_flow_uninit(struct tun_struct *tun)
 #define MAX_MTU 65535
 
 /* Initialize net device. */
-static void tun_net_init(struct net_device *dev)
+static void tun_net_initialize(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -2658,9 +2709,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		if (!dev)
 			return -ENOMEM;
-		err = dev_get_valid_name(net, dev, name);
-		if (err < 0)
-			goto err_free_dev;
 
 		dev_net_set(dev, net);
 		dev->rtnl_link_ops = &tun_link_ops;
@@ -2679,41 +2727,16 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
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
@@ -2732,20 +2755,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
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
 
 static void tun_get_iff(struct net *net, struct tun_struct *tun,
-- 
2.39.1

