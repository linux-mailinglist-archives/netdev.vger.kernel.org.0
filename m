Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4475A7434
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiHaC7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHaC7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:59:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF9B56EF;
        Tue, 30 Aug 2022 19:59:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldUw0wRi90STZ4AljJ5ZvhavGu5DVxKhV4+EFWq1KhUGim63clrbXBSG/aFFtYQZQTHcrXzVbWKY4yVCb/zP5S83w5+sNk5WeCtCxTYewnNbd6sB0WeA6IxIvzkWc/gnQKxuJmP5x2KljvDAHpoX7E6ynVfULEhv6g+/EM/BdOJ6KTDNL1gMu32kDcQz6Ut4W/WfViUE8BOYZ7i6bNTGnYFDQebPuwPqr2sv8Wrx5I+hCChb8s8AwbX67dUAFiJC5gYMJVZg1W7smj8/ErLz+g1I6YhCVO4cSMCzZXAsBY8CsrNoAUWkgTvfeZj/bIngj4ArALSqb5hKp9Ff8+uhYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUx8tK2qKicsLivJt2wsVq1aV9aiQ5B0PrAXDUvgT3Y=;
 b=K0pkCV7fj9Nwo9HFa6a/h7mLAiKlE4Q5f2+bJRU7DwTsFbsv0ygdPEWuIYAR2DOy2q0ZVOEjSzzKie6EGHUEyipcgBrgR3JhOCnOUP8zwDHFZ8vyErTtZ4rPJvIn3uMtHoSZ1ADa48m6MCbIc6nJtf+zc/T99Y4KKNeGIazUeStqp7bLXuiEOkrgLh5QndF1KCrpjA1IUh11/zkmR7jMDXm5eXMGWhBIpErR+kgCtYCQa5fdRA7mCszy7bVdHHUYrGGslcV9oDnXQATG/gW+hI1lAc/OS1ZDeTql6FgS9KOozWCjM0RCFLXNUNugYcS+F2VlvC3v3iIVeDj4lrBARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUx8tK2qKicsLivJt2wsVq1aV9aiQ5B0PrAXDUvgT3Y=;
 b=maN6LVuEXc3hhTC8m3Nme5ggfaYKOGRljNnH+lW69WrJU3NV20lnpzbBwznD7TTfUOf82cEKOxDWx8sEhZvjZFNxfVVhl5Edd+FbxYV4xCwi4xDKsNeQ6XBul6yktwwTXYnNY6/fkl3OWCMAtZ7b2P669AQYmDJzrl4/qY20xJJkazjyCVO3vIQK1NIc9TF1msP3yayQzjaR9gvEMOioYYmw3XlzHV6HWZVcESyejl7DzGHbSiSCyqda7Q9aQVJ70ohygKmT+SRulGOPUrl59t9bj+Q8oZjhEhlFXJubb5PKYNjV16jtysKnNz30a9rv3qW37CEcXomgw4qEV0oFcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 02:59:09 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 02:59:09 +0000
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
        Benjamin Poirier <bpoirier@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 1/3] net: bonding: Unsync device addresses on ndo_stop
Date:   Wed, 31 Aug 2022 11:58:34 +0900
Message-Id: <20220831025836.207070-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220831025836.207070-1-bpoirier@nvidia.com>
References: <20220831025836.207070-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0083.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::23) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f458c69e-76ac-4fb1-6d4d-08da8afcc6ad
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/BQ4nyX/Aqm1IsJnWU//1Rr4Mh+4KEIbmbt393AhRJtL5Q7a4E+/LHoCV58OXl9cI9pKXtJOk7izjCj2OPA3HO7x4DlOMN2jJL7/stMwjuPXrekwtcVMEejrekE+9Kw5/2327ugAADOELe1iRqg/WXz208iDujZk8dvJjkZFmFh0OStFwdbOQWTFNAIM2k7+Ea7rqEQIfbHDRzHi2QJSS7lOtj+wNlrodj7pnLUjIXRVeFu5XRoKiT/vHSp2ZZb0FSJfN8XustptnElm/hlIOjEoiqUpENEGODQujivC5kffG457gzGgR6Xj0T65U46XJIskGFTRsupctl8qqXgxPG5xT0U/JBn98dEBi1jEbuRP/nHvNwS33d7fs/XpRh7pYSa4St7CUYtESbDvWZQlfSBe58en69tgbhHASJPfXcZ+WWE0OoKCr/QpKvOLzJk7gR5pGXzddEIvCw24rJv6Qa2mpe6NElG9y0jq5X6vCl57PC1PpW3kxQoQBnm10U1zlwTY3QHOvUcE1fHxUZNsvimIHKb5aGE0DbWX5yy0xTd4Vgclk3vGphmZTLA7kusGocbf9LwSdN8uFN0tuodrHV3FTDM9ZDFpdK79AFbOhBhSTJO63w1fbTxORxAhaz2QWMyCng8v2acfDFZiGIWJrf8PNPnHeIlxxZrcm1e3S1W/thcpL2uF1hq8zPxbumRyYPRcn3dWoaQuKLI3/EGTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(186003)(38100700002)(2616005)(1076003)(26005)(2906002)(6512007)(6506007)(86362001)(83380400001)(66476007)(66946007)(66556008)(316002)(6486002)(8676002)(478600001)(4326008)(6916009)(54906003)(8936002)(6666004)(36756003)(7416002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?niziFFMyzFQb9Ol2D3/85EW7Wni2A7AA00OcGFdUiQc1dxm9CNuLMX80zZ0N?=
 =?us-ascii?Q?oL9ryqPBmbaBWr/H26za2w1lAPenW6FwoojIH9IUfyGS13bheBQWzGVyOt/7?=
 =?us-ascii?Q?Kig4P3rW1H08puHXC4np8zYQtX8FyjleLS7u8cpNXpdxNlwG7OUJjv/2djD9?=
 =?us-ascii?Q?ksr1SGhJXai2YaIWisWvgjQyYTN9Qta3L/nmZ5Y4xK8optnCLox9DiLP4WRW?=
 =?us-ascii?Q?Y4OXjmj7fLpio9Ls/s7Jf8Ld2AcjNWtkYd/Qu3ARLDc7gFbgOjIRtru3YVTA?=
 =?us-ascii?Q?AmuR4q+i+hWUIopm1VPaQbZmhtQHAyICGybZAuNZaVWCtBVNZNvTdfeTt+md?=
 =?us-ascii?Q?Pz+lQ6QcZLgc6/eRTQF0G89mOzEQtHXsjNXMqs6dHLjm8jvUA1qtuvceAUVh?=
 =?us-ascii?Q?Hrnsl4ZwMilWe/NgYtxoR1Du1pWHCSX5RpXx2DdeALN27HZNrOYn4hd12n94?=
 =?us-ascii?Q?bbVtkOAvet1zCV01KY6EbJlzT2hNtnZQaxgRPl27+bNEq1hEWNzQxfBVyZN3?=
 =?us-ascii?Q?OLROUvNWUssLgTzMD4+hAc13TcwtMiorkL49dUKSQyERj77IjVufjYHOqlmb?=
 =?us-ascii?Q?F43wVSCUSP/UdLwxPvEGAAlIMznwcitb8y5VIuBljHgairJJKQq32910HXXM?=
 =?us-ascii?Q?dWWwtMuK7bHHE04Gu/nNwWrxoO2elbu/ZyzG2Uh517+H56KRea9e5QONGTKy?=
 =?us-ascii?Q?+ej+PgYYmhGSclrJrsvbc1O/eoVDA8VeVZphy7laXP0VfloqK7PDveI11jvX?=
 =?us-ascii?Q?dQiJ7INCeh9bPRpDElsFVoF3S3NFRVrou5lY7YQSr58fGQGeooycsiqBODlZ?=
 =?us-ascii?Q?tm4y095HC14+fqOA+zD7zmx3ax8OODDT33bnOmGvlFPxA2EXjqlwklUPScXl?=
 =?us-ascii?Q?yU1c8uE0Uqji2jyFVaoLhunaNsRuD4iJJWkilmWbXL1aTo3hKhLTtNBMtKDl?=
 =?us-ascii?Q?lWOmdVpMGDcWBm42d17OuFeiatzIGDdqDqSWYjN2BsE8H20yEv9aVMZjY/pN?=
 =?us-ascii?Q?g9bmIVPITZUYpGHxlavQnX9bpd9MaBuVEZzG1Ogno5fa+ygi0o71iw/F//fD?=
 =?us-ascii?Q?hRGTzO7uzCsMw4cGvryoa9UTHIxO7BYsr+nkkypuNE2cQhP/HR554PhYaTMl?=
 =?us-ascii?Q?zWKxgQWQovDSkDU2qBMIpSykaNJXs4KOS4xCJ9AlV1XXygr1w4InxsBSXqFe?=
 =?us-ascii?Q?CjZXYzV9b0WzGcPVlXeS7bO/rU9G0HFDw37uJGQBoJg74Ax8+RvuxldgsNSs?=
 =?us-ascii?Q?SVvM3CyDaxUkXRTihA5rtwgcxH2JrP5BXG0MwYsCSImodeYqweEFFI+UOkZ1?=
 =?us-ascii?Q?mpl4ORS5ZhPd46MztCgmkojuTbEu2aO2flsDQ1lEz7em8VERCXAVukd0CwKE?=
 =?us-ascii?Q?9P4ZxfL7PV4tKtDCyWe5q+UmWeTdZFwJkFci5zSaar23KcL+L1wp56gT3RNc?=
 =?us-ascii?Q?7dkL884Oak/mDPPz3uvV55vqTNp8DqV46OpzHrgO7cjC8SoDdkzwC5WxdWjb?=
 =?us-ascii?Q?23qDzvagHZy+i05RZGDn3i/xSdfenGB19sCR1UXTrNNv62oXloVojqPkdlko?=
 =?us-ascii?Q?8vCofw7H1Wa1/uAQnS1SOFdCppmCxQnel64d+PhZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f458c69e-76ac-4fb1-6d4d-08da8afcc6ad
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 02:59:09.7086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5E51JxQ5kFecEfjGjaGdM84YWVvElSbwRFEPx/x7KSYHTyTYUuPFszj2Bii/fHMMbLJpStM20D0JEpQeS2ufQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
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
2.36.1

