Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AC85AFE52
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiIGIA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiIGIAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:00:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87257F26F;
        Wed,  7 Sep 2022 01:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2IRqjageziJ+h2f1199hAkb2ImX8hx9gxHyvS+R5kHkzHsagzpaPbBYxuscnF+m9yb1A9eOlNr3g4o4WS3q9zIt5Pq2X2FDbocYi9h0wD6uxhXT9Yp23DxLgCtG2zRz2haRP9R6gitx1tgxT191eLOrB9GS4V57H7URWDAdjD/+lv2LUw7tIEyrBe8BY+c/0+v55soq7+/tKWitDsLE1MtopxtGImNflVuLmXUUHeaDIcM+o63lHnpkanxddomH5gpCzYWxl7do2e3EA5orfHRN2LtkLHQ3ToLfiPjGeSYS+1PeHXN6Fi5v4AVdpM5atsHAqJA/1I5jHQc/b8gNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7N2g3lNAUJyf6++63BNdZhHL+ljWXgh+vkLh2LfrlXQ=;
 b=nb372AmsxBhAzVGXP0WLDp7ax8q0PVRjkYKfRf0aCOknySy+jR+9eNzaVvvYTyddMnUqmp81D0CHnlQWJWHKSNzpNgoKHDDlkMmiQTjkzLGTDyBxQ4aWgV+PFtCEJBKvJhjnTVoajEGBavzGAififIIYnWa0t0IaRNkLGRfcxoTjLZD8qUa92vk/R9pRizA1g2CvMIhUkAjW+y7vXddZMMZP1Z4aAlbs/95vHeSf6AD5h/LUfBjFEa4Bas+Cs7vhy4+t+y3DRjzdSDck2w43NzA7wglttWVEaURpywDWq4fEeIrsi31G/6xYOMxv4F4T8aq8MhXKosDQbo0AEJGPgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7N2g3lNAUJyf6++63BNdZhHL+ljWXgh+vkLh2LfrlXQ=;
 b=iZLUw9vaqTjejB67Yihmy+QaHlgDY54osww4I8wCSF9KGIjVkva7Dj/drBvc/9y9oTgxWpijT4d+lLabuHT4Yriy6ABwupsvadKMkEpCK4TWvJScyh5vEL1JlJ6kX1e1A9Q1ELnDdhIYjNUBVLETYuyKXDUozmObCciG0J4T64/q5CxV3fLOssdJtbbLhr/CoBmJskyM0OIUKFP4THbeDF9h+uE/z6i7/y+EgpJBIfIjIkxH2sEs503drHIP5wiFvnL7rGnPE9146QX0goSrbsRR4sqky5y5EEqNExGOnKxezz+8jsLXQ3iy8thPQthAJhAhjUBStieIoGWxSNmn2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 08:00:40 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 08:00:40 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v3 2/4] net: bonding: Unsync device addresses on ndo_stop
Date:   Wed,  7 Sep 2022 16:56:40 +0900
Message-Id: <20220907075642.475236-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907075642.475236-1-bpoirier@nvidia.com>
References: <20220907075642.475236-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0015.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::20) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a001035-6ff9-4c03-234d-08da90a70e68
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwbpQu6kbV9QoseFyhfStyLR5c+n35IJJ7EvmrNMpaK9yHGwV0AMd59tNXows4IQyXWP91RVmDe2IvFZSe6FpYiJcDiY5yTA7IvPByu1pzydEdt0+/qDua51AKdFwanzSjk5PpSQT6peNNq/Odhtz630IDBsAXNv1g/OkyCCS1pgKbjmi1XpGTTjVThurHKxvJ98szgcS5DukyrVsH28w3+WXu/4KJ5EraxbI6Lw+OZp7frJ1dR0jf2LwNLUoxGzG+gXuwqgKFe7iWmlmBOZzOKNhmIzoEfxY1D3DBsGNx8AW0FcrRonjbnPRBWRkIpmykgbmsBRyhrvJo/sCxVn+/cr+xHCQtogXIh4A7QTmiSwTi8oSHOZpWbPHnz6MNCc54SoGY+Wsa7WWSd22yu3ttVYNfMmlQlORp6KshFDPbQ+Ks73VpM3nIiGURN8najywYtUr1u5gkDCLoumo12QgQ/GAVVHhhKCgFbYOsuPSQIdGUvc23q5FycyXFuKghSoOuxsElnM9ETkI9t8PoSHPLKM0ywSDHIGi8cJRJr8jzHLif+Mq/huuYe6DsEQpSeDA1CW2yQOhBr9LUkFae2O/gUoAPqRQISC594vtPTipkRkq31e6yQE+ihXZv8752S5UIUKYKcw515C4f7RwDBGwk4tewCMxHH48o4LESpaM0CeE1gAToMKKUguyE2+XrOKCleRevA8q8Yq552UwLr8HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(2906002)(5660300002)(7416002)(38100700002)(6486002)(8936002)(478600001)(6506007)(41300700001)(316002)(6916009)(54906003)(4326008)(66556008)(83380400001)(66946007)(66476007)(8676002)(1076003)(26005)(6512007)(186003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQxCLrnGgGe+hgaMRmwjV2tD5iBxPdkXq7qjqCWU9uIYBXv2zRwFwF54/DCO?=
 =?us-ascii?Q?fX0OFp38sIeuPNZdQnuKvQqfJJOhJWvSPufHgrl+vqVBixAn6EC7k+bTbWRc?=
 =?us-ascii?Q?llnRGYpytHIkfaV/DUYbpQm4bW7FgTpWzjVeJzorV6zRA7VnhBPGJcAUqL4t?=
 =?us-ascii?Q?PySZTpr8dorseLEZ/6uoDIj9dW+4CFVzD/FOhcq/YhhFDLLE0Nbh6sqlK2ZG?=
 =?us-ascii?Q?Ssy5h1+L70QJ7x16rUlyYylFidtBgAh8skq7H9acyV1pgTzk9UEP/PzaeI5D?=
 =?us-ascii?Q?YE8zufYvt0ec4efy4UEMC25hL61N3JtpJH1+YcrNC2OV/MNY79Y3+ffde0VN?=
 =?us-ascii?Q?USbQU9gTAT80VBl9vvgbvpRt54TCClArjPeiuaFb9Flawq6/sUIc311yZH6N?=
 =?us-ascii?Q?ggn9Sayz+AkkcirR2+VUCh7h902lPD4qDK2j8LNWo2TFH51WRlZSJDCJI9/E?=
 =?us-ascii?Q?rvyigNwdmNtARzFOgLPXy8YL988yaBCPh18cV+W7h71b7TSPufI0hVhDMgo1?=
 =?us-ascii?Q?x1jfcTGZqa5zRRWPiKvawp+b0wdi/2NxRfinrge/1XNVaNjh4L2XRwDVJBqF?=
 =?us-ascii?Q?yNdizc5Algfm3nDkD7lj2BN6BCZEyilb+0yFAnCFcoioCtGiqR4iEE99Yyt7?=
 =?us-ascii?Q?nlZ3UI+j7VK0Jtwv4lBkGZkGvdHIvfr/VaQDBYfj6aEXFVA7OUWHALQ7xqyv?=
 =?us-ascii?Q?KePawuKm0Ki9ITnt2R0byy1xbF7MmNQUuQrt4Y8/cPtlQ6IckRWgM/1uBVn6?=
 =?us-ascii?Q?IkdKh6/xY6WJuzPOABzQOO3QcP2QI9w8wrJN7T8nzqgkqWUGJO2l97Qx0cLm?=
 =?us-ascii?Q?KIsZq6SzFUCxGVaMx1pmNCgIOTcxCHiwBx+2FJBDWmvGrwKTSpbx52sWE69R?=
 =?us-ascii?Q?2aO+Rtl3Qx8o1YAF+92T7trpdgc0mtQM9InBjaZwm34f3yfS7hVh+eleGLpG?=
 =?us-ascii?Q?qIffmdo/zG3XKmwwocIUYSMdjTkStFh0tPtvcs2ckyGUXlTx5IG1V0rPisXX?=
 =?us-ascii?Q?k59lDln5ZKM9FZpzat53TCaE+GQEexMWE4jg7PvKrIQNtuXHjb+LqwhqV7OF?=
 =?us-ascii?Q?A9P4zRvEalQAjkuF2/GneXsr/KYItVGynX/jHqhYBDx3XLkYJB5AbVvqDczm?=
 =?us-ascii?Q?AEKY1KXxkY8AAR3KFLG7g1EWTLkd3pMYTaNZ0qUCukSyRQi05BEn2d99UuU1?=
 =?us-ascii?Q?AERkFDOWDCd3nvlKti2TDz+WHyE+4JlKzsW/aPHUnSAn0Bzb9zyy3JRaEm2M?=
 =?us-ascii?Q?pxXsFAkMLBsZUw/sHICWWZ0RnpddeYPhVYuMV6zpapVPm7ea02HlTosg7S9a?=
 =?us-ascii?Q?I7SgTUwr9fMRGR9ayDVFTX9fcP6JiGVZ4gaChkYxRliVwoq14dyHCw7o5ZSD?=
 =?us-ascii?Q?+DU4zrIugptNrqUtsifkoL7WaMVkGdNsqCOEx/Gfn+b/9R8gHG54XrOLf8d7?=
 =?us-ascii?Q?gdihwcYeGiHJ+DZKpZ8rqphn8Vw81koi6NtL5giMVabuM1pK5FjkzrnP5Be/?=
 =?us-ascii?Q?Py5gCbKikbgKKMkhDYlwElTT4gAwCNN50oUZkA9Hlv7KXgdbkg7oQB9JP5r0?=
 =?us-ascii?Q?G7jVwc5GExnIxeo5mdmIAFeh29VptmUl3XjZgnqQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a001035-6ff9-4c03-234d-08da90a70e68
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 08:00:40.2785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDmgB/autkY+XuByqfbBQOyI41+xyQd0e9NY5WMsy9cHleSZZrOthNkQQ2UiogL55U/js7/coWZZQk1DkCk8hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netdev drivers are expected to call dev_{uc,mc}_sync() in their
ndo_set_rx_mode method and dev_{uc,mc}_unsync() in their ndo_stop method.
This is mentioned in the kerneldoc for those dev_* functions.

The bonding driver calls dev_{uc,mc}_unsync() during ndo_uninit instead of
ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
already been emptied in unregister_netdevice_many() before ndo_uninit is
called. This mistake can result in addresses being leftover on former bond
slaves after a bond has been deleted; see test_LAG_cleanup() in the last
patch in this series.

Add unsync calls, via bond_hw_addr_flush(), at their expected location,
bond_close().
Add dev_mc_add() call to bond_open() to match the above change.

v3:
* When adding or deleting a slave, only sync/unsync, add/del addresses if
  the bond is up. In other cases, it is taken care of at the right time by
  ndo_open/ndo_set_rx_mode/ndo_stop.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 47 ++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index faced8ae4edd..bc6d8b0aa6fb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -886,7 +886,8 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 		if (bond->dev->flags & IFF_ALLMULTI)
 			dev_set_allmulti(old_active->dev, -1);
 
-		bond_hw_addr_flush(bond->dev, old_active->dev);
+		if (bond->dev->flags & IFF_UP)
+			bond_hw_addr_flush(bond->dev, old_active->dev);
 	}
 
 	if (new_active) {
@@ -897,10 +898,12 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 		if (bond->dev->flags & IFF_ALLMULTI)
 			dev_set_allmulti(new_active->dev, 1);
 
-		netif_addr_lock_bh(bond->dev);
-		dev_uc_sync(new_active->dev, bond->dev);
-		dev_mc_sync(new_active->dev, bond->dev);
-		netif_addr_unlock_bh(bond->dev);
+		if (bond->dev->flags & IFF_UP) {
+			netif_addr_lock_bh(bond->dev);
+			dev_uc_sync(new_active->dev, bond->dev);
+			dev_mc_sync(new_active->dev, bond->dev);
+			netif_addr_unlock_bh(bond->dev);
+		}
 	}
 }
 
@@ -2162,13 +2165,15 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			}
 		}
 
-		netif_addr_lock_bh(bond_dev);
-		dev_mc_sync_multiple(slave_dev, bond_dev);
-		dev_uc_sync_multiple(slave_dev, bond_dev);
-		netif_addr_unlock_bh(bond_dev);
+		if (bond_dev->flags & IFF_UP) {
+			netif_addr_lock_bh(bond_dev);
+			dev_mc_sync_multiple(slave_dev, bond_dev);
+			dev_uc_sync_multiple(slave_dev, bond_dev);
+			netif_addr_unlock_bh(bond_dev);
 
-		if (BOND_MODE(bond) == BOND_MODE_8023AD)
-			dev_mc_add(slave_dev, lacpdu_mcast_addr);
+			if (BOND_MODE(bond) == BOND_MODE_8023AD)
+				dev_mc_add(slave_dev, lacpdu_mcast_addr);
+		}
 	}
 
 	bond->slave_cnt++;
@@ -2439,7 +2444,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 		if (old_flags & IFF_ALLMULTI)
 			dev_set_allmulti(slave_dev, -1);
 
-		bond_hw_addr_flush(bond_dev, slave_dev);
+		if (old_flags & IFF_UP)
+			bond_hw_addr_flush(bond_dev, slave_dev);
 	}
 
 	slave_disable_netpoll(slave);
@@ -4213,6 +4219,9 @@ static int bond_open(struct net_device *bond_dev)
 		/* register to receive LACPDUs */
 		bond->recv_probe = bond_3ad_lacpdu_recv;
 		bond_3ad_initiate_agg_selection(bond, 1);
+
+		bond_for_each_slave(bond, slave, iter)
+			dev_mc_add(slave->dev, lacpdu_mcast_addr);
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
@@ -4224,6 +4233,7 @@ static int bond_open(struct net_device *bond_dev)
 static int bond_close(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave;
 
 	bond_work_cancel_all(bond);
 	bond->send_peer_notif = 0;
@@ -4231,6 +4241,19 @@ static int bond_close(struct net_device *bond_dev)
 		bond_alb_deinitialize(bond);
 	bond->recv_probe = NULL;
 
+	if (bond_uses_primary(bond)) {
+		rcu_read_lock();
+		slave = rcu_dereference(bond->curr_active_slave);
+		if (slave)
+			bond_hw_addr_flush(bond_dev, slave->dev);
+		rcu_read_unlock();
+	} else {
+		struct list_head *iter;
+
+		bond_for_each_slave(bond, slave, iter)
+			bond_hw_addr_flush(bond_dev, slave->dev);
+	}
+
 	return 0;
 }
 
-- 
2.37.2

