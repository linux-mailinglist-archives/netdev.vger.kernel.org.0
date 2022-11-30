Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F8A63CD2F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiK3CNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiK3CNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:13:05 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179152CDDC;
        Tue, 29 Nov 2022 18:13:04 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AU20Sko023195;
        Tue, 29 Nov 2022 18:12:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=KAva66/CDps2SmR25yCut68OnhHb31YRqIhSWyLcRGo=;
 b=cEvcoh4U9E16hU3SedWyn4cnXr9kXt0wBHmW87fAIHVpHCc6klt6VMj3NmdP1Eac1eCX
 uBT0GVDHgy0lBv5QvrreU865AnjQwotXa0cysdi80bHgPDAQrWRu3C919P2g8BRHi3zA
 DKH695jwugUX2Y9bWrc+ovGN96KSlr+pOgWmwP8CqygCLt6zOYE74hU4BzE3Zb+pf2sT
 6NUwHxsNZ8RcET41PNn11kr1B6JVZyBpAIIKjSp2IyTr3UYugd1J9cyKlcX3NkffE45O
 a8q1O5B9a6oJPi6enktWJph6jnZuHYPhwMm9rNLtJAZwk1Gz66xGLHCL8OG7m0RUNuqK MA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3ey92tw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 18:12:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJmKuTXjYI2wEBY2SBVbAaCvxbKxhrGCtLf6d66KU31U+Gt90lexDCGapHPdiK0plegwB3IXznZLa6B9e+Aor/yRQVLeFdPK9LCJWyCFuHo3Q7igRRtB7TrPOhsQfWG0ya/zis3J7ShPPtAw72qpwkSc4MonhSweZ4Jm1EHt0d275g5PIeoDfqjxtSDgOg/9/gnMTiox9CnxykZT00jmEXElDSwdgx9cRm7IM/yzjmD7MNUaaXfHROWbSdlzirYvaR+QvfQtXcY/+ANXF/8gaRLmmAHMXK2++AWE8YS0i81Bxr9M2E9YIGOsAJeByr4rxmLwraqToiEEF4tydykbig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAva66/CDps2SmR25yCut68OnhHb31YRqIhSWyLcRGo=;
 b=J/m47NboCDiiTSg+xfdaFn7pXcwAshlGhussNgiHI1g8bcnNlunPks87BP0ZoqapVilD0aXh5d4gN6jPmPSkccS2mzCbYKQiuR76nBvDppCoEOYCsmzKYsr7EYDZ6yXBV0BjTCaPh73+7MMhxYx9/+Uv5UhajSmyCV13SdUgQajNuQaMu8G4BwoXvxKPFW8LJM17kmKJ0XCQcM4tyei04FtclxqEUM1hhJwBU4jETlA/rk/xIuhFfwMdw8U/VyIEp0085cRWdGfIXjtTBeSXhXSYBejpTC6Yfs9LpSNp6rvsw14kuWZNsKsohr0FzORkqMjQhBB1m0aSbo9yTS1slg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 02:12:49 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b%3]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 02:12:49 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v3][net-next][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Date:   Wed, 30 Nov 2022 10:12:16 +0800
Message-Id: <20221130021216.1052230-2-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
References: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0187.apcprd06.prod.outlook.com (2603:1096:4:1::19)
 To MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|SA2PR11MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: fc48d08e-3209-4cc5-cc04-08dad27860f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpkfxTKy9wjyRIC/X+awMQPBybOLlAQCVdbEooW/BGfNPHV9JxyXrxr59bZWN5wpSR4hBrzAXZD9HE6DvfWJtAWeVCTU3bMlHXlb/2EXz3uBoFJ0Hw6sJ1/Jp4Q0SKbyqxAFI/FtCWmr577wSqTu+xH9m197quu7EcHX48bE1bd+qIB/SaV6L0yRZCwJAMVV77NaV73rJcu49Hro1fgfWGby78r2mowPpBIfdc1JhJcNA03TixTo3JqYQdTcZ3d79CpL2Mw3aMSBzQiStY6nig2QE8LAt9I6hYU/HrbHw5Od1mHwxXbDcroCM54hBAwDYVT7BnaO7M9IWMQax5eGNC/wR7kHIIrho6VtQapstBHqlxUXHmiesGFmNs1u8yaLCH10StKDuWDMOWqOSECwfmpeFRhlcxzxu/nekc1uhbfAmVz1S2bqKIWWSQte+AXT8DCJIBCnGyRjnK3UUPwdwuI4sA1nm4V9p0ofqIcBpq+vK8B0Mw5BiSv8J/K2n67bl1B/5U1WfR4Q2JDppOzkPb7XBGBwg0n9SMzossLxsgYRYMGmUb5fqZCmDXLTaXVhz3q3zuTu378j8coJ2dtTe2PWBvZP5k+uUe/CWhFKz4UeJUhHPiLfO+suiFVX4efl2CBvzgZ537QLuJ4klFvhfYFbCCdR5TSz5irkG7FZVP9dqb8825wW6R6XONXfpP1G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39850400004)(396003)(136003)(451199015)(6486002)(478600001)(6666004)(6506007)(52116002)(86362001)(66946007)(66556008)(66476007)(8676002)(36756003)(316002)(45080400002)(38350700002)(38100700002)(2616005)(1076003)(4326008)(186003)(26005)(83380400001)(6512007)(5660300002)(44832011)(7416002)(8936002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihS7ALdlB4F/2+INhwBDYPiIM7gBalOs9pmnfDX11hc5TTVAaeAnAHJ7l5f5?=
 =?us-ascii?Q?CGZO2/F3BZhOWCaUiA63+wiG3CrX+tRXDCjBpcnThf3JuuzwBT9Oy5r2ADGy?=
 =?us-ascii?Q?d8LAlR2mGIcnPm48JCHpY1hDetckiTDNdayE6voC22j2cN946zxeO60K05RR?=
 =?us-ascii?Q?SH2RHKsgjktX3LyZE+Csdnl0bw6Nz/Cl6tPHS9mViNXAfK9AuoX0G6kr+YgL?=
 =?us-ascii?Q?6dhejl0nVaE9EFtZnj+1Ld6QBHUaieYni7ncbOiEwUH2b+YI+qAdDSOlt0c/?=
 =?us-ascii?Q?gZ3kMA9c4f16AY6Do0TlJezes+9vCsNDCjlhj0K8KpsTViI49kC+pOXKdEVu?=
 =?us-ascii?Q?audCriSMQ7hgjBhDaBQYeMRUw9z1rVzNsBV9uu9JLzhuQMZG5ZGRZG24BQ84?=
 =?us-ascii?Q?1nh0mEyXJOM0i2XW+T5UpMDleOQmJHfWpjQn++5DViprvQ0/lvtHEZJaSvM1?=
 =?us-ascii?Q?+YxqjI7tGHov09In8e2d3K2NGitX8LPbrqlBXqUeJtwLlsKXw3j13waNQLV2?=
 =?us-ascii?Q?9HgpN4Jb4PoPSFaa9FdrjyiP0A6joHE2zrY7O0JPDgsHW7vSZ02mmPxlxwkM?=
 =?us-ascii?Q?NF77ctz0OP46Sj4OD4jplr1A4E9NJ71t0lmUGDBZ9VJNcZEDjOfQS6nARBqx?=
 =?us-ascii?Q?/Ien/Kh4l31c/IBkzI3K4ZIclSNVMdn7T5oZx9OSteiN1b282F8xRAQQ0bbM?=
 =?us-ascii?Q?bTT7SWY4Whkfo19Galqb3Mn+2QUzaOsbh1VZbJGcmkG+er9eOoclypXAFsv7?=
 =?us-ascii?Q?NxAy3+SNhwebkyzdpLYIRMKh77xF8VdXxKmu/aC+lEAOtEafJPJk2/pACzZL?=
 =?us-ascii?Q?zzbiZyNpcOr0a1eeussnmhS80FkIRqRLtulcYVDAKl9SnWS7Eii6pDArn3XI?=
 =?us-ascii?Q?3aWcKPtTEdLReW1zJfKC4P76niLwd8SCpKG45CC9dVGxE1TTsXMZHmPSAxk1?=
 =?us-ascii?Q?itopUkeJ3JXteV0qjOyQh8ltI3WnUPLiEY1cJ4ovzm40+KshqxWxfAJrlp6y?=
 =?us-ascii?Q?7Fj94lEvXwdFsLvrL7NmJBdJHSz0eU+KZnm3UDVz3pvURnsmzBq0VnWDS2F1?=
 =?us-ascii?Q?EsIPyhCdie9e7gK1UMs03r3cZJR1Lze1S/1g/Ae7r8ODfbfklC9O0YmxkDbm?=
 =?us-ascii?Q?32zmA9B9GvfCYV7HkOjH48Lgd2W3yTEJz2I9C82zRtC5tseEtuwL288M4wE3?=
 =?us-ascii?Q?e6moKcJNhkPUhhpsOpIgkijxJeSzCwdzX2AyILVARW1vhrXPo6Rfsrvaw5Y+?=
 =?us-ascii?Q?rPC8/lS7UiykdvaFzdgeZ/GfatfSYd5YW5FjhbsTmNPQNLrzNVaHJygG2zaT?=
 =?us-ascii?Q?kdWU3SyiVAGGOuJ1DLdu8ZK24F5yXYzKwshdCfr2y3CWH/N9xeojQ/S1FYOe?=
 =?us-ascii?Q?PNH5BN+W7lkN/qPPDu+AX8052jwSzYMgtuLxI/bNGrYaBnOcsxHnC8PW4jCn?=
 =?us-ascii?Q?J5hgfJPEGhbm/FmG2j0E5NxRHpa6WFcUcdLdDFF4gaS8eCSGwRTHuzolQaOz?=
 =?us-ascii?Q?aOHK4NWG6wj3L9TxQYvUVyh/yTKiOROq6sUNBVxknzVr62F2LlfK4dklJ5UW?=
 =?us-ascii?Q?YD1hCCyHUWzNu2s+PHZrSNl3NqLLVoipGg/eqt023RLYv2sQSgDGf5w1OPEE?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc48d08e-3209-4cc5-cc04-08dad27860f0
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 02:12:49.2835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qL5flXJLxuxY7YuYeDYE9nd2qb2aQ5kPFlS1Qb/mLiKGOS5/9ejDZBHIUD7br+ts1sDyEX7qXyJ0y3ROqprChmX6+U54fchpyqRlJq+xfis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-Proofpoint-GUID: HcQtX12EgWWvSy0SsPMAfrsnj85jT68h
X-Proofpoint-ORIG-GUID: HcQtX12EgWWvSy0SsPMAfrsnj85jT68h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_02,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=404 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211300014
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the external phy used by current mac interface is
managed by another mac interface, it means that this
network port cannot work independently, especially
when the system suspends and resumes, the following
trace may appear, so we should create a device link
between phy dev and mac dev.

  WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
  Modules linked in:
  CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
  Hardware name: Freescale i.MX6 SoloX (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __warn+0xb4/0x24c
  __warn from warn_slowpath_fmt+0x5c/0xd8
  warn_slowpath_fmt from phy_error+0x20/0x68
  phy_error from phy_state_machine+0x22c/0x23c
  phy_state_machine from process_one_work+0x288/0x744
  process_one_work from worker_thread+0x3c/0x500
  worker_thread from kthread+0xf0/0x114
  kthread from ret_from_fork+0x14/0x28
  Exception stack(0xf0951fb0 to 0xf0951ff8)

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/phy/phy_device.c | 12 ++++++++++++
 include/linux/phy.h          |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57849ac0384e..ca6d12f37066 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1511,6 +1511,15 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	phy_resume(phydev);
 	phy_led_triggers_register(phydev);
 
+	/**
+	 * If the external phy used by current mac interface is managed by
+	 * another mac interface, so we should create a device link between
+	 * phy dev and mac dev.
+	 */
+	if (phydev->mdio.bus->parent && dev->dev.parent != phydev->mdio.bus->parent)
+		phydev->devlink = device_link_add(dev->dev.parent, &phydev->mdio.dev,
+						  DL_FLAG_PM_RUNTIME | DL_FLAG_STATELESS);
+
 	return err;
 
 error:
@@ -1748,6 +1757,9 @@ void phy_detach(struct phy_device *phydev)
 	struct module *ndev_owner = NULL;
 	struct mii_bus *bus;
 
+	if (phydev->devlink)
+		device_link_del(phydev->devlink);
+
 	if (phydev->sysfs_links) {
 		if (dev)
 			sysfs_remove_link(&dev->dev.kobj, "phydev");
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ddf66198f751..0c74b99aebc7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -529,6 +529,8 @@ struct macsec_ops;
  *
  * @mdio: MDIO bus this PHY is on
  * @drv: Pointer to the driver for this PHY instance
+ * @devlink: Create a link between phy dev and mac dev, if the external phy
+ *           used by current mac interface is managed by another mac interface.
  * @phy_id: UID for this device found during discovery
  * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
  * @is_c45:  Set to true if this PHY uses clause 45 addressing.
@@ -617,6 +619,8 @@ struct phy_device {
 	/* And management functions */
 	struct phy_driver *drv;
 
+	struct device_link *devlink;
+
 	u32 phy_id;
 
 	struct phy_c45_device_ids c45_ids;
-- 
2.25.1

