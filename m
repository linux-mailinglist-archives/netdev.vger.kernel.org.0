Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387E15AFE55
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIGIA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiIGIAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:00:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A506B3ECF1;
        Wed,  7 Sep 2022 01:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMELm0BPTyhOjJ3ZUiwNntwOaiUUUMCBSZDz5EgPSlAVmp4kJbF9Pwbdqv2oCWw33Vp6K4z4fRB7QiaIvCCziWeeITb2zcpGmjppCx/ZHyap8tsM1bs0s3V4iARbYTg48v5oUGe4FWL5jaTTZMjVnd+E6mBhJeLsKj1O37Cg9YGkx2i2jzbOXOgAmJzatmo1srLqospBvTolxwEITTKCMjDXxjgqYL+HOQR7IXwbC9ZJ70gsJCQoIe9bXQM/tT2rlL7MGUJg+hsVjvIXzHfIX0cwT3uQzDf5n/wiCu2y/P7JrVj7S+zQrV+2EWEfjI11XS309mfpLkR416GCB04R2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ne7JlujsLTX030weVXhC73h8Bb375qxQOqw5aWGT9c8=;
 b=Ld+bX1Yr80vltr2+tOzYhr/inDrAIsmDNQy1JiSCuaKpxrt20gg1GSno/+2mkw4wax+PXAUzsfHuYA9i328LlKKLTiVAakVjEBaMuffIKOnXNffjRSTrryMdFNvYK+fHkhuMluc2LZ41pu5Wni+0f+SLJm32Gv6/f3BlH6e/hOydF3uHr24uoRnj1s3k4kO9izOJfCmpNluDdRB8Ya1NqIKXNxq9qCWyRYa42ChFMHWSUoW6E16NGawvsqHTu1X85UVgPWVyavenaDTQViDI+CvJjyT0AYTOysFvBIRYWZbXzX6TUjrgTN4Yxwcqkx1pNlew6n2e0GFEnUVyHHfTuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ne7JlujsLTX030weVXhC73h8Bb375qxQOqw5aWGT9c8=;
 b=MAFmW/dUoPFFu6676vzW+OOXl+y1YapD+oH4QwDoC76DUzwuEfaluhGGKG6NB5cnuKbKgqIyn87jON+1Ia1gOJ+DUWdujWy79NCxHsF79R95hEzdEaNnN/7mMzgoI1/37kaZkbwJnP43XYbJgosPUl35dtmMqFQWvrHeD1tXD7qgZdppapx031xYjRio3FxK3syvAIvg3U4NEdJXh3mjfBw0AvU6Om7/eMnvsclKi5dkagQxoWP7Rrniub89bTZVs4ODSfbWXmdpZEDKWA7oeZU+bPmiftJ85KJZ+47Sqqmf+RsTBQ3nRCJLo8r6Duh5hYOJn2E513AUsI/BkYa/bA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 08:00:45 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 08:00:45 +0000
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
Subject: [PATCH net v3 3/4] net: team: Unsync device addresses on ndo_stop
Date:   Wed,  7 Sep 2022 16:56:41 +0900
Message-Id: <20220907075642.475236-4-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907075642.475236-1-bpoirier@nvidia.com>
References: <20220907075642.475236-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:404:a6::36) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ade152cc-e16f-4c42-937e-08da90a7114b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/M3m0WfcAZ27UmMjIC7jh773cmyIlUwzCScmx6oHXOBwOUCy/gi+pNzbIPl2+94EQBZBKJ/lW60fx+95w6oGp4VbJg6il+mxTYOMmW5JySHW6k+xFakZ6u/1+7fpgnRb3EXieHC6nnT3yWTjKMbl7JZf2iQRwi7+rVGIg2CjZyO6zqc6uJqOmYKeI7rJYFF7iqGd1eep4Sqdo3nBf2EWTws6xfwT53XZCeBMnoLqH6IV+MXxetxlcbDEC+8cV2LhmC21RVp6G4eZzj2ihMYaunBnTvYv6bPG2wwwcHKhf//uy19TGlNgOVlPUjzsXKjMunVDRfo01Zjhyib8S/nbc43ozQkfOhnjWRWebndRVvH78j5mzUsoOiqeR4t3Ab0/rBIsIxL4niewUjskuVYN7INox6QxXBHbNrG/RTzTf0bgx4Be7jAnPiPFEtKnd4uCvufsJD5v+fDdKzO1ITLOtVyGljQeTHYm5e6l/0gr73iFzlsAOFiuF5fDhenTiF86ikJ0rnUsP3SKc2lhujZF8tejRb3sWB+6m6aycvoSz+4lySW1fd0/XqeD6sD6uP45c0SgQDmsHresHngES3qrMxDWDqiUpsNGVM7kM9mJwbR4j/hykPaF6qEwPpJdgmEO1beQNvLO/ESyvi5l8wUe1a20F+LzrUvqoHy/2VNP6XH1DM3MMdYOdVb1s5afHuctnDsq99JphUEaUu41ksQPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(2906002)(5660300002)(7416002)(38100700002)(6486002)(8936002)(478600001)(6506007)(6666004)(41300700001)(316002)(6916009)(54906003)(4326008)(66556008)(83380400001)(66946007)(66476007)(8676002)(1076003)(26005)(6512007)(186003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BwsKZyEJa/8D1LfNT36XWMnOsFFSdMGUNYkLqucKp52m6rgC9iLFaJF3TBcI?=
 =?us-ascii?Q?ow6qGopjxTb7HhxWLAD3CGmsVTEiavpYbPAIU+4afXeKmGX4a+872mBQX2Lw?=
 =?us-ascii?Q?VeVwSw+fAkPcwQfScmjKZAzMkDT0D9Goin4nKJ32KEE8SH8KyGjlF72pgx84?=
 =?us-ascii?Q?GWl+Gg6BSNL+I0/ZlAoVaoKOfoEzQvgO19bUe2jphfgIBAHxPphc+BwWD3IC?=
 =?us-ascii?Q?qHKmdNDDgtHMAwQ3EL2kavR9MV3q/UV34lkbkfdFYJYVfadgLPkSy0Aetqbh?=
 =?us-ascii?Q?ydbu8rQMSHb4lLJoxJx+FbQCyq/6+OQCZy5iVqKS55Eky4wcqEL0VQZmKBBS?=
 =?us-ascii?Q?lOgXJnDzMA/uiPxN2/T3HS2/E/lXNw8NiXC08shqhj3ueRpUEKY0FFnQJ2hh?=
 =?us-ascii?Q?2Rc4Fy6PcJNH0Cqe9y1SclrC8trS4dpTu5+jDjJtHjGUSgr/j0NdkjBgEuTi?=
 =?us-ascii?Q?oMvtxCkegMPH/1KWLNi33nT6hnmZC+SDB1R/lCiGfJZSqdJb/LwfC7u7jZrP?=
 =?us-ascii?Q?CfecYRscp2u7RFhVHj7ITkmBcv4u+xmfkJBVMkQWEZ+7Dc05Y86xz1ugd7VG?=
 =?us-ascii?Q?Zfyct7uhJXBrXfBosEC6IS/sZWIBhbnfhORujPYx82uzQn8f22ODZN22peXm?=
 =?us-ascii?Q?UdZXuCgOYWnCQ0bqiGpCgZXBoWRyPU76erp1WHN6sGYhEuAseVeWNzdY5fN4?=
 =?us-ascii?Q?koVrvHSizB4S+3FMu7BBt9c/Ou3isIpFFi9dRoyU5gUcOmwKVE5ILhH9ERXh?=
 =?us-ascii?Q?HiTgaQ2Ka3mV173nCggLAHTIDJ5ePPJs/mQUXHqRoCAFuzw6WyG3+9bT5WD4?=
 =?us-ascii?Q?opxj0IzftKkh0tYw7B7flK3blmtpVZn5VeEihf3jMLyysjY/yP13WMK0kGRP?=
 =?us-ascii?Q?x9qbs8pehFF50t/AdLFvqs5J3DxNivOAV1T5jEFTMzr/xp6ihZw5hGmDRy/8?=
 =?us-ascii?Q?baS2liGtrfun9CBCIplwEihjdjp//VoEnPcJ3LsIbW3FCh08M59JYkfWMrZg?=
 =?us-ascii?Q?k3Z9TwTIh4+LhigxadwH/bXoxyFog/zVQqfyaG8edUYaOuEysJWuDB/YJZOt?=
 =?us-ascii?Q?ab1GE6G54uqPx+5dR9jX6hlFxYtElz2k6TTTPKfGVt8+OMHlnpv/o36RbAyl?=
 =?us-ascii?Q?wF2sVmAs2lEZelSreVLxl1fJjb78dkuvFi/soXXlRFIe3wL7YQjCQlhi6Ueu?=
 =?us-ascii?Q?1oTfvcM7CbLolTMIRAgRhvYBLAMqxsx+pudLZ7hVTee4ol5VimT7U2Ff1wyG?=
 =?us-ascii?Q?Ay9yVKKUzIAgF+ByIKsxnKpWZnCWngI+spV7BGxFipTe6pvFg8gpEzz2hwt3?=
 =?us-ascii?Q?nqgkHFsrEdVCebeyrV6kfZp9do2LGI2GbG3rkfvn3ul4CGdbMgLpckzqfkbt?=
 =?us-ascii?Q?E9wxM0+b2tQgLJsw+f6aYH9wxGMvxkiLY1uivGYwG76hlhCKr5DtFZBIPZz4?=
 =?us-ascii?Q?1VShhYvoCOHsfUTDLbqcOv6Ps7Vt6eb65hd3sAd1rPN6uen+oCTp5QjsGKje?=
 =?us-ascii?Q?niHboN1c4u5otzvHyOqso4coXPNVj/NkGe5UAU7X1y7rahnNuEsnwqzNDFG+?=
 =?us-ascii?Q?k29ICMh18aGPrNyml/oSj7jb8evzvx6jZSikccK/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade152cc-e16f-4c42-937e-08da90a7114b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 08:00:45.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDS9fJ5OwSxzSgE/JHzUuyQ1K00i+dfdsRKWS0BMN9pMB7B+K3k4ubH1y6j/U+kWnZrA3UAyPhuXZ8xyRWNMAA==
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

The team driver calls dev_{uc,mc}_unsync() during ndo_uninit instead of
ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
already been emptied in unregister_netdevice_many() before ndo_uninit is
called. This mistake can result in addresses being leftover on former team
ports after a team device has been deleted; see test_LAG_cleanup() in the
last patch in this series.

Add unsync calls at their expected location, team_close().

v3:
* When adding or deleting a port, only sync/unsync addresses if the team
  device is up. In other cases, it is taken care of at the right time by
  ndo_open/ndo_set_rx_mode/ndo_stop.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 drivers/net/team/team.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index aac133a1e27a..154a3c0a6dfd 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1275,10 +1275,12 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		}
 	}
 
-	netif_addr_lock_bh(dev);
-	dev_uc_sync_multiple(port_dev, dev);
-	dev_mc_sync_multiple(port_dev, dev);
-	netif_addr_unlock_bh(dev);
+	if (dev->flags & IFF_UP) {
+		netif_addr_lock_bh(dev);
+		dev_uc_sync_multiple(port_dev, dev);
+		dev_mc_sync_multiple(port_dev, dev);
+		netif_addr_unlock_bh(dev);
+	}
 
 	port->index = -1;
 	list_add_tail_rcu(&port->list, &team->port_list);
@@ -1349,8 +1351,10 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	netdev_rx_handler_unregister(port_dev);
 	team_port_disable_netpoll(port);
 	vlan_vids_del_by_dev(port_dev, dev);
-	dev_uc_unsync(port_dev, dev);
-	dev_mc_unsync(port_dev, dev);
+	if (dev->flags & IFF_UP) {
+		dev_uc_unsync(port_dev, dev);
+		dev_mc_unsync(port_dev, dev);
+	}
 	dev_close(port_dev);
 	team_port_leave(team, port);
 
@@ -1700,6 +1704,14 @@ static int team_open(struct net_device *dev)
 
 static int team_close(struct net_device *dev)
 {
+	struct team *team = netdev_priv(dev);
+	struct team_port *port;
+
+	list_for_each_entry(port, &team->port_list, list) {
+		dev_uc_unsync(port->dev, dev);
+		dev_mc_unsync(port->dev, dev);
+	}
+
 	return 0;
 }
 
-- 
2.37.2

