Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FC9336C1B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhCKGWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:08 -0500
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:22014
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230456AbhCKGVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0HM++Priq53qKfKx5egXjGPwuAW3H6ZFfcjkiZwTZMS39Esue26sF09WYZqcFr0htnLmfojI2+hK/gsvIq77oF1kAGjU0jq0ZDHw+6MOXbyjRK75joWFARNR2wtAZsLScxjY3QxEJ0AvbymGtTyIHsrdD5IuktYCcj7qMVP4VIax5/RCOwsjB6Rpfzodha6OAJrgX2+fw6KMit1mT6Z0k21UQJ2whgv8kugPEoz891ozdUn3JMimFay4cchAVO/Gh7DLcMkp4DIeL9ksGksL035FGbuURPY/eyKxVARKYXEVh8b//7cFA+CljPkDsUZoEY1YEV6gHDv1WmtZTO3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0KWhdwt0sthDqdeYS6b4CVL/hdN8E9qrYOFcNUqUXI=;
 b=iPhF/bCKlAQIbmo5PJbIkHYzzHknDO1lVkNKjZrX7yYP9OMjKz3OIIBXj9WVmWFJuQdGsB4c/OgBmtv1mz0N8FztbtD7pRLq81tn1esyjuQiAHFCtLpOSVE9KK515J3ysU09eF2Ob7KVblkkp52CkhlERthbz777TwtlazPBoeoQjjUrhaaQzO7TNx2s4SyGsYuyJ6R7NePO/Qt5QCv/WB/lKEHp3mVrHgw0sMfcY+mkjc3ibExcq2sl3cgZD56AC/skT8zXI6SaDOcmf0y/8AiIbQRZpOiKPoss58Pj+3pO9L3IuTSf8dqgxSIUJr9wRTO8SMChtA9QF3+65moAQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0KWhdwt0sthDqdeYS6b4CVL/hdN8E9qrYOFcNUqUXI=;
 b=FVEkRcHoCqTkTgX6GQOc6f0s6ygU0k9ZVQowNHjraa4OCGTb8u8vVeYre6+0nTZ0J1Z5tUKbFvsrzQkDSMesFS2b+NcGTcFMnOW7Jrp0kQEwTKRD55sRvh2nTdCV6hnUZ3Cxklrnm5CPPocCqgh+8cnu13Ex4M+B/Z5inwtj9f4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:21:37 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:37 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 06/16] of: mdio: Refactor of_get_phy_id()
Date:   Thu, 11 Mar 2021 11:50:01 +0530
Message-Id: <20210311062011.8054-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee156e07-81ec-4e28-f7e9-08d8e455eca2
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB66117FCC74BFF6B84C2AD70FD2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqUskRW6r+LgN3wsSyCuBrK4SQSdAP3pZQlMXdTWfX1V9us4b8dFBtYKaIHvAauTMpqSOhaMpN8DBNW+rOKJmWrk/1weyTjeId8SEc1ozJ3zWIN2L/3JpESiYak6oNkC23V27wSXvB3XpmSg00yssssu0HjvQEusuJz2PAqduypTTYZ3kREgzKA7dz5H1Oh4qPU+JcTzmN8pGv801+HqpEXmXEeYjpzEY6q7jIVbSkqw6a+IQKP/0Nkm7r0WRTfL1OTLbqqkOp66xLdaul4VNNM4bxM39DOoGMyzwBzkMyDFpmaxRiqZqGAIqZ+HNNy2XQrH8Otc7O6TBfZrU8cQ4+0K48VH0XrnsvImvhxKFFNb46s//gMBwrsbYT9a1258w8OtxoKtnflk2+dY1eEA5Vn9rtr5QalDeAsm2nEO/hnGtqpXeV5kgiMQj3e1Z0UB+qrCSbRlnXOp0LvzI/HTPKCjDcvAw9Im45CuK0JWM+glc1Yz1jLMiGTiDqVAu43DDP6brmTPpDEd2sYcYCu98i890Q12YIIow8ZFIMY5lrWayP9/Y7/jipfNJNDN9u7lg0mJ59cgkL/9K+hpTU5ciw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/HydlZAAdanJKqHkuBKTsk3CpJ0Y2ojF7AxXeV2rpBfoZAKNTbk8m/3KUXuY?=
 =?us-ascii?Q?UMff+JqTadQRHtx4c+7U+mUX56pbFFEJkDbUtRUMvfrzBa7nMRMQAnSkPl/n?=
 =?us-ascii?Q?WSlmvePJfLXAm/DCa4IcYHB4NNKrXjb9BLTqJZHkJ0IhA97DunhumjDbDkk9?=
 =?us-ascii?Q?EcM/RLWdVBoZhLZyH0fANpCKU1lHhP0Nzxrq1/iSNg6k3qs5uPu520PgVOKB?=
 =?us-ascii?Q?JvS5128gSs3GxE0jSl/s0XgH4lX9BStkZKZ3ekv4BxioUcNGaDhaHS0XJ2/M?=
 =?us-ascii?Q?7wnvvrpPs17ulJqOZNUEjo7ym7f5Ai6syaUACVj8ynTnCiMV61nZc1nYfdqr?=
 =?us-ascii?Q?CzgxUSOBOdATOaDvqFTokSt4fZT0ZQIevmIdGf8LsQiD8mVbhwVUZgprFl1h?=
 =?us-ascii?Q?XxprW3cq2VLfkxZJ/pQHyCOPOs8m74oNBjYhyVOXB6ksb6q/1sP81a+Zg4NF?=
 =?us-ascii?Q?LOEVMYn8lHTqdQHIoVrscnon2RVaZcaLIo1yaBCabPmAjbkYbe7PH8a8UHu3?=
 =?us-ascii?Q?mnKoz6kIjNOR/uFpstyoa9nz081o3d5m1w4mdeV4uXbpwrm2MItL2SgppOKQ?=
 =?us-ascii?Q?5UO8iWQlax5XqLds53WemCECtjtgKpK4TsceBTf6rGjazQTmD+310HwEr7iY?=
 =?us-ascii?Q?gTzFBk9/hSJhWv91lG09NadO/wWRXVTZCpxgGw0ObAOPxgubYGxz8a7Id/fm?=
 =?us-ascii?Q?zOsW6aL1bourDmalNPMo0MVV/qhwef4UWdMFUZmUneOjnFNC6EuTnCbS6NLO?=
 =?us-ascii?Q?4BO1fUJ5hYNSl1fQLUZzMXMwwBTm1K9yxJU7U/WMNUGH65ZKOKGR4yCVOMUW?=
 =?us-ascii?Q?YWeN+8iO4S1satjjexbmRhmBZ/0gskuQLciyBE5QICN9qSJRGpUcVl96qpgE?=
 =?us-ascii?Q?1/9nyzuTGHtCBqMfkScQ3Vl6HcLqsUFB027ZTyQVc+uhtwI491/n4J5Bi8mz?=
 =?us-ascii?Q?i74u9qvHTYLb43dIUMvQeccHN7w9L/zZ6c2IrW/xq1/BYgry2u/Mrg4cvnIz?=
 =?us-ascii?Q?QOCzZ5YfY8g6KrRf49MOvztO1DJy8P1jKhXyG+xfaJrYb3+viIQKdqFChK5F?=
 =?us-ascii?Q?J16NItCVlO1FIkYXFauumCwAfcUyss8JBnC35rEO5TxUFS9Qf9b1yrjZBXZW?=
 =?us-ascii?Q?/j1/J0lohtU+IzW5iIESI98GGEENAabAa1OiRrmHMpSpIkWbfsXlmO7QYXvm?=
 =?us-ascii?Q?F4mJ/TzqsUzGkESpRdYwWL3LdxT4McYNEcZ/2MERaYfy0vRB+7ea2/0b1AT7?=
 =?us-ascii?Q?VWvwC/8BEszeNt+cGKT1bltdf062GpqNBI03ZKlM9P6QguFdf4lHmPvQj/Od?=
 =?us-ascii?Q?wt8rXG7HFs1blADDTmieB411?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee156e07-81ec-4e28-f7e9-08d8e455eca2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:37.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmNE6TNf6fwt27heJwareYRU2IBsX2YhAhaINgBlZhuucADF0l2Dy468o3bJ5+disWWuJGYyifTavOhkH6uF6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index b5e0b5b22f1a..612a37970f14 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.17.1

