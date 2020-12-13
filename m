Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F140E2D8DD7
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394963AbgLMOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:09:15 -0500
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:10034
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395330AbgLMOIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:08:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ie4gIcAVuZMpqw5pLT2g3Me1ZCMjpdK5XFmAARHCiKpRYaO+O5V5TxoZnqki/B6ZklvSPpsvTdRSpbdBDAGxVLFinwzMNXyIFo6cZf9o1ARcvZrUzHHTPkJei1SjLR6Q3QpZPR2BOnSvTpQkFWyML2jgBz5PIBYYuh5N8H5Nfw3mPVmP3VTchn7qBRzL+Ttt/SLq0opJGuSKbofsn2+yJe9sC/06LW2Y2BQhc8xMgOwF3uh6VJ3gqhNWIWNgXwsXe5cnoaryF+QLXlzmi8wvl+kTbOZL0i5n8cpyW+a3DNHPnsTpqKRDTyCv9H2fdpUQ183lYJFiD+ndCgUiqJjHaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbIUbKJWWRf5XUw3Hxats9n5FRteTaPmQ+RwhMXIO/k=;
 b=HHlH3efhcD460JlvQshEsoOIvd6wM4LRwrZ5UpjERoFZn8CJZB72NLZgUYluB8TxCD18OB0yMhQO3yJ7UStFBcf0LODvOaR1D70HsWJtdkWO43EaCthD8hP4eWDqfN71Hc3h8BV4ii+SdXklFAGtMiwK9Gh+pIkfbjCMnEjBP/gmivuol/FTXsBXSYR+oCDDLX4gYCj4kiGWhgf8cuSYa3MhogVbjtXYSReqdLwyHFjpc1iw2R0Oq8iBRsjDE9P/iniNvU/JbKBjqHAX1IiEDPkafZ/MQq7S6f3d4h1yaWmhWqzlx0zVCFJ6Q91CKs+mg0k/LQUdINJ34IWgreCxeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbIUbKJWWRf5XUw3Hxats9n5FRteTaPmQ+RwhMXIO/k=;
 b=WDTzTrhHPBK77ufWvJA6WVKgQaxVg+e6ToLApaKJj3rztSTwgjLa6FYpsVC0iIS5a8LKYag88yGzEPTWVra1qmBTXRYjzZcdi69zcgaRKDtAECgZTY2rnZAHzKrRfu+gxzONKCXNAutuM0Z4GDA+q0IOZabL1YeyrMX7OpFahgg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 4/7] net: dsa: move switchdev event implementation under the same switch/case statement
Date:   Sun, 13 Dec 2020 16:07:07 +0200
Message-Id: <20201213140710.1198050-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8549c190-2426-42c5-94e6-08d89f707377
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341DA20C063FEFC228B19CCE0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +bQRsEs2c+SUPZXWtbK9TsRpSm56NUZ4glACTgt7sRGQDuwAVVBqmofIPhL2RCwkdsnIhv2A8UKTqAEKJOI6K04VYJoYv+62OXv7MwGlOwtWrJ5pHpOpbgA2kxBWeaA6y7Ka7KKK3PpaxuKKDt3/IHfKok0YGHuZ0WoAkI9FhFBTY/RJHPo76Y/6MsdcOBAah8JA6S3UMeBUcDdMVvcasrU5g2rOXYHF/QYNHjToza8oDJ4hY+DNoLVl9p32wv1cYVhM5wZMGypvf+ATC+XcgVWV1tF4QPh3G7C8yskH3qSZw26sF21/Pvqq0cSosMtJkXpOj529fkKIDoNJl6YZaZWCe9zKjaWKpRCSbtbOZpYBIvVmO/fX88uY9xAum9YrPoyXBOoByA+s71RdCTCF+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qFNdPqEw9rDr8SxidOldkP6y493uI7W+eG2+Tkv9PEiUD2UukFqB8/rG4oZv?=
 =?us-ascii?Q?UfALNL0aX+6zRDMcpNgh5/KRtGZPMBf/M8vmmKoL2C+xb6Qsm/Rg+24i3CNa?=
 =?us-ascii?Q?+HlJWId2jEkuZZnIK9A6fDVkOf0dhKQQpMNqfNav3uFCYNBvppbLzmeVkJA7?=
 =?us-ascii?Q?ntAcHANuxyz4S0XjnHbtRP6dRI0fOJAaW1oFrJzl+qh4w6/DupyljTMMJ2OX?=
 =?us-ascii?Q?SQZOQFza1cEH35xLw3ZI4eb60AbMYEoWhYTqU7EDwmsNUasAVNIGAAg/3dlF?=
 =?us-ascii?Q?IO22c73o0SXWmlvHA22BTscKmwet+6XNecm/syQInTdQSZwYwZjkBvX2q3J3?=
 =?us-ascii?Q?CW3t4QXbwH+xt/bRzC+H5TY4kAHaShthSMd6dNh0nKlyXqfXfYq/MJ5Lxspr?=
 =?us-ascii?Q?LqxSzbQca5+xQQOUUHDeV7IsAtQXPFZzhnlOW4rNExA5/1Q0CDI8qDySZ62e?=
 =?us-ascii?Q?mfAwwCDozUKXUPlmI4CBzF8JHVBovJLxBqA73T4BxQCG0nS394j9lM0RMdJw?=
 =?us-ascii?Q?8HLggqcipteiVrw5CHtaq/Rnn+2sWSzzDpmZLYkhJFYOlJBvh7hUH66YGewQ?=
 =?us-ascii?Q?yEIM4e95hQrqRJAvfhg8MKTvoePV5fKb3O5I7WxmZGe7XB2Ib+mQGqKP6Qzb?=
 =?us-ascii?Q?Pe4DBQ38mVUjKPPrST6C8Mkr4jYu6CkO1TLrg2uUVMWNB+hEPkoyOr254UCl?=
 =?us-ascii?Q?b6Ns4Ldw1gjy0Mvd5lFx9lCQmiLG8H9Gj48CKT4pLsssUvb6Hzn03GRuA8h9?=
 =?us-ascii?Q?dVOOEc/6MgOxYagGhagLm/6pw1zsclKjBl+pBsU55c95srmgH98aP3ZMX1Co?=
 =?us-ascii?Q?Gd3dzbh/z0su2avKioAn8QkC/E3obq7pHwu0as+2NPzQd7Xkrb1MW1zyDoNX?=
 =?us-ascii?Q?vNufph928FkOa8rk21egKZLmw8pGBCDmK7xs6cZxqF4xq7l7keCaj2tXM+8e?=
 =?us-ascii?Q?nnl35ldNg7jwfHQJVw7la4Oe72xdhvGSKG82ucVUcU478WPb/+bj+GTVEomm?=
 =?us-ascii?Q?l9rQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:39.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 8549c190-2426-42c5-94e6-08d89f707377
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3YkDUoLPB3Qj4dJV3qtyw70Vh+or8Q8ynw7rEsXhlUicWSXTEglR9/4fut/66ENMShRXh28Gr1DpPMR4pS9cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to start listening to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
events even for interfaces where dsa_slave_dev_check returns false, so
we need that check inside the switch-case statement for SWITCHDEV_FDB_*.

This movement also avoids a useless allocation / free of switchdev_work
on the untreated "default event" case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/slave.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5e4fb44c2820..42ec18a4c7ba 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2119,31 +2119,29 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	struct dsa_port *dp;
 	int err;
 
-	if (event == SWITCHDEV_PORT_ATTR_SET) {
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     dsa_slave_dev_check,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
-	}
-
-	if (!dsa_slave_dev_check(dev))
-		return NOTIFY_DONE;
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!dsa_slave_dev_check(dev))
+			return NOTIFY_DONE;
 
-	dp = dsa_slave_to_port(dev);
+		dp = dsa_slave_to_port(dev);
 
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return NOTIFY_BAD;
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
 
-	INIT_WORK(&switchdev_work->work,
-		  dsa_slave_switchdev_event_work);
-	switchdev_work->ds = dp->ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
+		INIT_WORK(&switchdev_work->work,
+			  dsa_slave_switchdev_event_work);
+		switchdev_work->ds = dp->ds;
+		switchdev_work->port = dp->index;
+		switchdev_work->event = event;
 
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = ptr;
 
 		if (!fdb_info->added_by_user) {
@@ -2156,13 +2154,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		switchdev_work->vid = fdb_info->vid;
 
 		dev_hold(dev);
+		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-		kfree(switchdev_work);
 		return NOTIFY_DONE;
 	}
 
-	dsa_schedule_work(&switchdev_work->work);
 	return NOTIFY_OK;
 }
 
-- 
2.25.1

