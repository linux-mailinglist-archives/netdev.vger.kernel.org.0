Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE35AA537
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 03:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiIBBqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 21:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiIBBqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 21:46:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5364D247;
        Thu,  1 Sep 2022 18:46:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QroIEvzqCy400IQtXc48znF9AtfVaV2DJkyHLCECrh0+XfPL/ibZh/91KJqvrtKj1yLsOuR0aD6ia+IA6fwgP4E9Xcni7pTjhxJCKRNGcxlMncan65xF/Shc3Iiob/Cdpu4wo1KF1oW8HPoUIQQhzaalohgLxGaaOByBKwmIoeaMi5UeEZfrcquF/L8xgQtWyauJ4ttBbUUhSvH2eRR+xs+cFMH7Hr4PkT5ZKx2XF9t6LU07hwM5mJyT9b6xPPmbTDvCeS6+5/MkAWiz14yx3LJecUy/QOR+nSLnfD6+fVZ39SXQCbq7PQTSwRDpbzcL+JKlEcwC93r6nezvv2XF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKl593y8Uf2hPkl6dPNKIROWiO5BgmCd4qFHFDQns/U=;
 b=ZKvTA925SLBm47/Kze1+tGJE9wZt7ntk7C/cyN2QjulmRzdZnBuyuWVEszm3dDg5s6hBNtxhW8gu9JsaCBxTZzdiVlw1rXRGGPGHBBNPK8eBWIodZ0sWoBjDD4ozL3peap4EJxnsZVs/s0v7KggA/o8MaLJXgrUP3OH3lU//DoGSJD0n+Ar7/0cUHE0en1OudsWJ7mbYl9055teCK7IdPQfjx1Eb503b/f1PPh79W/O05jFcKnhYhTZyTGG8Rko/x2ATk25iKjwZI/yC06E4WEv7BON3C/xfZz5vXdGx4/xRSrosWxWVILzuuyVj4BzV0eB/kJ2Y/i3v7pdfmmWLjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKl593y8Uf2hPkl6dPNKIROWiO5BgmCd4qFHFDQns/U=;
 b=tzfSCcLqrhgiBKClaTT5+SVgMNObmxB+2j8PbwUPsJE+qmFS081xk58w7AbPhSyhqKRuh1I5yeU1U+fPEj61P//xMqArgnmNoc4ZAl9JRuyCjwNO/vZSS9XxiGUhBVHPsWBzGjVkt/eMpivDLJ6j+yxOpu8Qu7b1vI+lHZ8NF+/+xIRhjGIDFkfdn2D9apS7gcCrPwoeQxZrA4khKFwX5lUxdw+DK2qN8rzrbd7TCNhjAHvGw+hbyV9swd2EuhKK9BEW4CDgQ8kSvJrU/P7Biw9k9SQFKbJXeAR1gQdYCqdqBfsnh0wJy1IwQTypC8rAz2i+P/lXKSvrmL+/+13bGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA1PR12MB6728.namprd12.prod.outlook.com (2603:10b6:806:257::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Fri, 2 Sep
 2022 01:46:01 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 01:46:01 +0000
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
Subject: [PATCH net v2 1/3] net: bonding: Unsync device addresses on ndo_stop
Date:   Fri,  2 Sep 2022 10:45:14 +0900
Message-Id: <20220902014516.184930-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902014516.184930-1-bpoirier@nvidia.com>
References: <20220902014516.184930-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0079.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::19) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3e53ded-8cb6-448d-dad0-08da8c84e3bb
X-MS-TrafficTypeDiagnostic: SA1PR12MB6728:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X7XxsD7YRHqJtahugAWnRCa/b0eHyVa2tmYwIb0rAr7vnZ5ioB9xCrcqKsFgx/g2cU6fJFyKamYD2SFm2qwXx2Bo+R7wpdrqim/QZmE1csKrDv31VXyzLLPftHmJrgC71Vtiz47hjWnfGJOhHhKL+U5SANbOX94WOzSh9B67ZVuSdFIB8rscdGdEiZv5+8iKbtMPcd0uVs+n+Q6beZ+yNjSmjMlTeNfa0H83/P3ZgsqW6JDUgS28q4mdCeiYtf875ROs9yoJ9qzWZFujYbp+CsbCQzmrXde41l95EEYNbNzjeeOnyIVbCYSoMG7uEDqW91CS0ewxAEFdXr2sTvtr2W7zrt+5G8kkug9doINRAUiTvpYxh95N29e1JufFbc7MkUPu46PYA0FtMTqNV9/WyOVXkwbW1jaIItKBlzdClnVG4CvsVnZV+tkP2hCey2t5HS8/+eAzBh+C5bYABP3ivkMgY4ftriwgWXf/Jc6JkPlbwGauOiQ91D2HrviYrrbjWp+RpxVEdVoxiguknY79iRnXxvVSrKLpBfEszjfFsonQcPPhko79bhk8yFDcsByigICYrtlWx7zBzjhH4lLk2NeamSyVSYN/8vbBW28zO/ZBKKEjF5p6/9QeGnGLlJ48HWNAl1zuj+cijGFgpfkgflx/hS0OEHApBVZ4WQb6nDB+GKv9KdOGaIOS6bFzoHvsVti/dk6Hqbtbf+3NXR2r9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(8936002)(5660300002)(6916009)(66946007)(66556008)(66476007)(8676002)(2906002)(36756003)(4326008)(316002)(54906003)(478600001)(7416002)(6486002)(41300700001)(83380400001)(26005)(6512007)(86362001)(6506007)(2616005)(186003)(6666004)(1076003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ffHN/gPNewfG9nJAcMHzZbVpsLPXB2heNJE9OUQd6Let1IW6bDFCIUKpClFZ?=
 =?us-ascii?Q?B4QrkhN6xTeL/GhwqXyCiqTD8kP8l4bTfplOnXZgGtQ/mxl5qz5GiUCIpmmW?=
 =?us-ascii?Q?xVdvHphtd5yaH6mAz4xaenzJdTNh2RX+P8zZAEu4BDvYx6F6+TDp1YeCptf/?=
 =?us-ascii?Q?tiVb6+czUmb3CVv9olv2TeaPz/kgJ1rCjMtnsq9DSWwNHOF4gJYfEj/Vpktq?=
 =?us-ascii?Q?Zc70pULLvs+J32o1y4OQdw08wMKpSgB5kD0lFDDV5aIJcl6HbDj8aU2j4H6v?=
 =?us-ascii?Q?ju0nAqg/Tz806wvuUrpYYOacZQnyWI4xlE53znCyzJOLWQpfb+hceqseCkXh?=
 =?us-ascii?Q?oJVLlUu4TkPrULhveZcXLmEcLdybTJKdjHrgg2GBiaNVs76qX5yeP5c/JgJ6?=
 =?us-ascii?Q?skqLnCugeN3n8KEmj/oXhV+VjC+uZw1BnKqfsX2ZN0wHnP3dqFF4fs1bO/Qw?=
 =?us-ascii?Q?ljcfGzHSuIWpiy91wxx4MLgozSRv13ieKoClWn6LsfnHwpbCdXGpy32YQILU?=
 =?us-ascii?Q?KX3CFrWHOHkMZ2DoKaKS9vf3xE21nd2haQ6+jQhiuIFTG0yVvBdvyW7z2qbl?=
 =?us-ascii?Q?jTKlYmtvtCE36To78oyPFKQ1G8gW5DHeF3nIb/W6y12LnVvmGTOPlPOY2pHL?=
 =?us-ascii?Q?d0mO5qSQrDZ3Lh1cQFaJ/iCpGijrxy5Bkv2NJMOq8BaMGGEkWg2J+cvukz05?=
 =?us-ascii?Q?B+z8xtWtqI8oDX+sqz7btZVXkcAoRCZHotSm50+SvaHOTHXETSSPf6JUaHH0?=
 =?us-ascii?Q?Az2tWqpgen5/okphTjgx+6zIlwFV7cOLUeBXm0X+tmPQ/rzLJr/JBAxftqfb?=
 =?us-ascii?Q?+i2uP/RqLsh2rIMI/xQQh2lpl3U2yagIsQxfNcST9ua3HK2MbwgjbuCd6qum?=
 =?us-ascii?Q?RycfsmvXKrArfguUuBpJg3n4TtrOojFbDfgkI/o7uWzjCfiPl8YnlQZzAaAc?=
 =?us-ascii?Q?FuQWX3VEwvV4Tah2/u6ovO6AVHC0jb8FFyQnFNETAwpccgjJr6yrW8x89ph+?=
 =?us-ascii?Q?+Fmb1KeSRmQ/lElUpjKfA6KEMBc8Ewz03id7CWsTfQDWpd/ricsIsk9Jq/qP?=
 =?us-ascii?Q?BoZJgXixit3XV7PdpipFIZMJ7JM5fpyvHnIHfmnqzYlJAXxm34/XIIqlF7hF?=
 =?us-ascii?Q?NdFYfkWb2/CvFbGQCzJEE2aFDsxdPgn3j1OB8b77rPbCdmy/ybnTOh/2aX5i?=
 =?us-ascii?Q?gr5a0TkUlMXr6XKC6UjYELmk+fUAeb0MCeRx4RaZScqGdxcnCu4W3PiABC7w?=
 =?us-ascii?Q?RDnxaq2DHu2JM1NCOXIBLz1somFHfcN1lrb3wbK2CGmlvctVJ0YVg4eiBz8Q?=
 =?us-ascii?Q?EjQ0QGI1JhLyfMYCvLj7uxBUGOGJ1SNQj36EkCP8H04PzzCNew/cdftE5C5W?=
 =?us-ascii?Q?AsvGy/Etu3UOufjGZEN7+uRR/Z6oJSN/WCGMhy5AsY28GNuthZqOJs1SYcZk?=
 =?us-ascii?Q?KuaI5OtJhrDH/2u6SSDCv5n9BHbA40J5KYcRx2917E0WXpUhqhFgRper1PdQ?=
 =?us-ascii?Q?ndjc+g8FapfUs54fOP1SFr62nKqSGwP5IM6qGV5f9lEPtsMgXdu11KAXkdgV?=
 =?us-ascii?Q?8W+xslhRfbusJ64tdsyx/LTDm+3DeIxlTIFAwIX1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e53ded-8cb6-448d-dad0-08da8c84e3bb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 01:46:01.2688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrrhCPSvDXUHzdFUyc8f0RYW8QWCjKdFn3d/lp9CO/7b3njd/BX6MKXxy3z/yZQrFOlgUI/wb2BjARYznXH7iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6728
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
The existing call __bond_release_one->bond_hw_addr_flush is left in place
because there are other call chains that lead to __bond_release_one(), not
just ndo_uninit.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2f4da2c13c0a..5784fbe03552 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -254,6 +254,8 @@ static const struct flow_dissector_key flow_keys_bonding_keys[] = {
 
 static struct flow_dissector flow_keys_bonding __read_mostly;
 
+static const u8 lacpdu_multicast[] = MULTICAST_LACPDU_ADDR;
+
 /*-------------------------- Forward declarations ---------------------------*/
 
 static int bond_init(struct net_device *bond_dev);
@@ -865,12 +867,8 @@ static void bond_hw_addr_flush(struct net_device *bond_dev,
 	dev_uc_unsync(slave_dev, bond_dev);
 	dev_mc_unsync(slave_dev, bond_dev);
 
-	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		/* del lacpdu mc addr from mc list */
-		u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
+	if (BOND_MODE(bond) == BOND_MODE_8023AD)
 		dev_mc_del(slave_dev, lacpdu_multicast);
-	}
 }
 
 /*--------------------------- Active slave change ---------------------------*/
@@ -2171,12 +2169,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		dev_uc_sync_multiple(slave_dev, bond_dev);
 		netif_addr_unlock_bh(bond_dev);
 
-		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-			/* add lacpdu mc addr to mc list */
-			u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
+		if (BOND_MODE(bond) == BOND_MODE_8023AD)
 			dev_mc_add(slave_dev, lacpdu_multicast);
-		}
 	}
 
 	bond->slave_cnt++;
@@ -4211,6 +4205,9 @@ static int bond_open(struct net_device *bond_dev)
 		/* register to receive LACPDUs */
 		bond->recv_probe = bond_3ad_lacpdu_recv;
 		bond_3ad_initiate_agg_selection(bond, 1);
+
+		bond_for_each_slave(bond, slave, iter)
+			dev_mc_add(slave->dev, lacpdu_multicast);
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
@@ -4222,6 +4219,7 @@ static int bond_open(struct net_device *bond_dev)
 static int bond_close(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave;
 
 	bond_work_cancel_all(bond);
 	bond->send_peer_notif = 0;
@@ -4229,6 +4227,19 @@ static int bond_close(struct net_device *bond_dev)
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

