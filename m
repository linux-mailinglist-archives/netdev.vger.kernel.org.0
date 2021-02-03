Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A0230E051
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhBCQ5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:57:54 -0500
Received: from mail-eopbgr60134.outbound.protection.outlook.com ([40.107.6.134]:37202
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231626AbhBCQ5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:57:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ8hSfdYDqDjMIyhROFf4uhvkpIJYujc0/KcYGWm9GHFdPfpiuk5WVPp43Nuf4zIqkvIMuxicmaTAMvU4fA8u7gQJf2HpD4UjZtOYGKETvWel3AV83bjhG80CyCOdpKN1hsEGTPwzKtRfoTc+HZ9ox3Ql+wjWVJhsoco2dLFKn9JURF0ZhwoeXK7fpk7gD/FDaD44mlMdoNgRSfh+EMnVwjjET8XE0PXW8f2+3JDlXgbGh5yw0/InUj97YC2IUqvhfp2knmLYk7rTV0gltswOYxSA9k/HIDoQTsr8DdKvsof8CovNLTh+OlT96BzEccsWJ8OyJYKsrewmLjTxzqBwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0vJ3vUe+yGLGK4KPjKLp8fvM//b/UxaH0M9lH0L42A=;
 b=Ixaby4TaLhh5G/XfCY/FrQyW1SYatPj1L4BCUcVX8wT4jiS8E3qO1uNFZ5T7nadr6H4oBbBCYsuk28uK5vDGXY73YJd9N2g3UHA/jpdJNmVQLN2zLNQ/qxTMq2kh+6Ur5YDksOgerlsztgA4FbgBfW4Wgpw/jLBq2fdW6SUscuQ6u0uNFr7zucrHpfOXcBcG4UoShGW8JOQjB8kWwxKZZEG6QpH00DYyz5ut76DNaMm8/AoUmPJfckaHZWfN40B6uvNFP3C8cfrzQvQ3wgNM2r0wiE3UYLJlTQ3qyr1SDEjj75UcofjIKKzbjImD7fB9txWx/kPqeKPd27YTsVYHaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0vJ3vUe+yGLGK4KPjKLp8fvM//b/UxaH0M9lH0L42A=;
 b=oNftFO7tcAEOfXT5JYI0bYII4/hPpKOPEBuUPhjBz7qP5AzEvWY6nSnxPrinEadUlIXk6fNLslXwSPI1JJAHyW6B9aW7C69cVL+dsLO6Nv3PMydiVfjLeFiTW+zqrsq5ghus25QG//8KU1ucbZihC5nkfOOM2mKqQGxs0xj6Fpo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:55:57 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:57 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: marvell: prestera: move netdev topology validation to prestera_main
Date:   Wed,  3 Feb 2021 18:54:55 +0200
Message-Id: <20210203165458.28717-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203165458.28717-1-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1237ee0-668c-470e-33ff-08d8c864935f
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0539E0DF2E087E4A8639B78295B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GA1Wx/aQJ4pJZXZ7ivCXIGbLarXYZoBJTMI3KDnuI9BYYmrINipf0dHYVbe8vuAzvWNjiqw7JWTv/DJmkJwAYoIls9SM0/hUUV1cjxxb++/x+1Gi5c0uvdTE4uXUab9n2sYqtdeMhLV/61qYD2N+5Ji1GCn7YRZ/jFYF5zNaCEJNDhUmR7ohxVwiWL+Nv+x99QPS/pY5MHJKzTAFT9na+IjfOnsW2ftjBn4lj6GcAhh2WUOrqPjYwSuhI6ojOy2EVNYOwq3NS7c/wQMt5iAOizk9P9uQlrC9yPd48NYI61B+cu07O1l3VTtncDndIOkiZ3lpiS7BJe2lpuRJTXjxybtB/yN66R+URmVsOeBiE6QFuf8nUOa9errRQRb+6i81PlZOGCrYx9m+lFNWFKkmvM0ZXlYsueRV9DQ3jEY9Mf1vtLkt2rNt856DXxUt3rBV4npsamtc4pA+AjXnDKqN0/XMKIN1rqY6CPnYS24icMqAkuM35JX7PByMqwQlcJNC1Q6PpE++aHr8UlzzNMLB6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(83380400001)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(26005)(6512007)(52116002)(2906002)(316002)(2616005)(66946007)(8936002)(1076003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+yb1JFngi7vfhw+BRK3GJ5cPSZ1ph24b7gro+u0zxbVa8KaL/8I7gp78Qbd6?=
 =?us-ascii?Q?8qPn/3KqMxMtnU9j5JrcJ8JoFyUg7Mt/TZrpyr319VM0ceyjUEfErvKRpMW/?=
 =?us-ascii?Q?BnCLU31xuNdY32W3/9YRXpL3LGUU8fCcm5gDz1IxoFPAQLXyBKwFmsfeZwuP?=
 =?us-ascii?Q?/tAsZTbFgCxXv47lf2+rs8Z5oINMVV8qzlQcU5nDjxzKsLz2D8PB1TZ/sM2r?=
 =?us-ascii?Q?fzZ3dbsr9yPenPHM0RlnaDGn0CkE1V8cwd2XmaDl3JKxd6aCb+157p6eck6M?=
 =?us-ascii?Q?DkJeg4+MMJJi50P7drvuJHigYI3bkqGkMdN1qJy9UlD19U68+z6C0Vw7mXdn?=
 =?us-ascii?Q?Qfi1OF01aI4UeRRi/bYMLY04SGwOMN5wM7rfEtAEFoEGw1YTlnpnuDGQl2nn?=
 =?us-ascii?Q?BXeLWp1rXUszxEKdsFQBYMa5v1XsvfQdWovFn+EeswcuXXPyfVesq6zoPMeS?=
 =?us-ascii?Q?8TkRyOKiviJqWtl2lRKMKaCVazL+nUrlIv7ahxvYaQY4fsk8vXgXTl4mTBJh?=
 =?us-ascii?Q?+bFj8HBOKUAAEycPaaups6Ms+qG9yZkwqvx6Smogmq4783U8GQvWrhuwIs8q?=
 =?us-ascii?Q?sf4EIWzSWCxzcWnNxqnWWykxJ5tzdJXhbQl6rLg+IU232Yj/JWHkgXj40PiO?=
 =?us-ascii?Q?FtVkId0o4KMkVs3XyYX74JULSu01fyk0W/PkGCDuDUlbuTTchmjQHt1MlTk6?=
 =?us-ascii?Q?wqpjCy/ePGrsRtvBm8xDSTSN0XGepz5ZnOxhOt5JMbad5BSaV9Cx7lOPhxw7?=
 =?us-ascii?Q?vRezZ0l2WPUoRwSO/P9Jj1sZOqB5u2bHGroemO3jOh94/Y+rV907MhH5KwdH?=
 =?us-ascii?Q?352B2P+WuIzbhRT2sWHhHOigQBizRCUVvCow3zcWUDi2mufG3UINeA4qnivn?=
 =?us-ascii?Q?9pKobU4Akb/BN53CIAZw537J6EZzisRBO4o3YJIyOo1pI8Q+Iz5SdYMtTMHH?=
 =?us-ascii?Q?3X0iRijMmkPzm2goVbxGJkOLo/lpA3vi4IXQihljKpgGRBg6Rjo/fb4J+j7l?=
 =?us-ascii?Q?eL7h7+/JpurIYCuDfa1byLT3JDAPhmlDnXTpMgEQhr8CaRPdrelhgoEFjKmZ?=
 =?us-ascii?Q?nps2QTJgiG5CcrK3gVQU+aFXK0evZB/JtD5F7LvP0WNL30ZoTXi28vvEmtj3?=
 =?us-ascii?Q?dsnzMjs0oQp0fF134P38k+8XGj/KeBLLIzM0eZtRfbztyu6FY+RIrTKtE7U2?=
 =?us-ascii?Q?s43uvP+Vm8OryuGqJaPoCVvQDigoBH5ErKrF+yL3CCvO7OJ5WQisd0tng787?=
 =?us-ascii?Q?zmN4xFsI6oCA5K091efN3vsfWE2w/LsLLbMDhPaDeX139qw0m3TW1YKG1fCc?=
 =?us-ascii?Q?6PnscyQ0r4nD3GPF4o5EjyV+?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e1237ee0-668c-470e-33ff-08d8c864935f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:56.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOm+U6vuBzT1ZXaejl7mPSidsdkTOc7g1pTzw04ntgPrHcbNPTs89IbWAdxbDvHUaHhbgOaRRTGCDEXASxzQ6+qMNPASNic1o5D/kB1zPMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move handling of PRECHANGEUPPER event from prestera_switchdev to
prestera_main which is responsible for basic netdev events handling
and routing them to related module.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_main.c | 29 +++++++++++++++++--
 .../marvell/prestera/prestera_switchdev.c     | 20 -------------
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 25dd903a3e92..53c7628a3938 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -510,13 +510,36 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
 static int prestera_netdev_port_event(struct net_device *dev,
 				      unsigned long event, void *ptr)
 {
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netlink_ext_ack *extack;
+	struct net_device *upper;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+	upper = info->upper_dev;
+
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		if (!netif_is_bridge_master(upper)) {
+			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+			return -EINVAL;
+		}
+
+		if (!info->linking)
+			break;
+
+		if (netdev_has_any_upper_dev(upper)) {
+			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
+			return -EINVAL;
+		}
+		break;
+
 	case NETDEV_CHANGEUPPER:
-		return prestera_bridge_port_event(dev, event, ptr);
-	default:
-		return 0;
+		if (netif_is_bridge_master(upper))
+			return prestera_bridge_port_event(dev, event, ptr);
+		break;
 	}
+
+	return 0;
 }
 
 static int prestera_netdev_event_handler(struct notifier_block *nb,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 8c2b03151736..7736d5f498c9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -537,35 +537,15 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 			       void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
-	struct netlink_ext_ack *extack;
 	struct prestera_port *port;
 	struct net_device *upper;
 	int err;
 
-	extack = netdev_notifier_info_to_extack(&info->info);
 	port = netdev_priv(dev);
 	upper = info->upper_dev;
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER:
-		if (!netif_is_bridge_master(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
-			return -EINVAL;
-		}
-
-		if (!info->linking)
-			break;
-
-		if (netdev_has_any_upper_dev(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
-			return -EINVAL;
-		}
-		break;
-
 	case NETDEV_CHANGEUPPER:
-		if (!netif_is_bridge_master(upper))
-			break;
-
 		if (info->linking) {
 			err = prestera_port_bridge_join(port, upper);
 			if (err)
-- 
2.17.1

