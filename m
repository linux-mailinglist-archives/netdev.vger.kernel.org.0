Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7184B146A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245252AbiBJRkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:40:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245240AbiBJRka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:40:30 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA5C109B
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:40:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7tHj8JapBGE+bukc/oju/DFiTSlvVaLL2qFoWM1etmU09lCcABjRFahzFxwUcWlBwnx93fyPHJye9ZRsRNblWoybuGFYHNPXMCvamHqCsa+4Fxjzir42almUphtC+YndpGQs8pmfX5oJzXQHWbPz0MCi6vmTS9Df6FQJ1MRO1KBCgs2Q6IAzc+Hx1Qm5gRJaSvc1kLaisoAsIr/0XLPR6HiR5wumfrs3uq6q7jMn7Ef4wTM+6sf9bK/iTSe7YKrgrdOpM1MGzS8C9j8MtMXhXhiMnb52w9on1X6VnoHruUHHKHtXFuy7AEY1jBGpUF0q3i0sQQ/4yQLBizCPbFbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArijIkwZnMFEayKODJbB3v6zhAz+JbqjC/ic8JSSZIo=;
 b=W7jdsmqJWjKyJU9s9SRkTnhHF0GQ4ae4rtwN4IXLfSlAoylsZuVL4zd265Cu10Ugw+06CoTe+wbN2uxt9e3Xp6J/XG0mRbN4I4oix92PmGuK0sxHtzOUEVYGU52RZsB7LW7Fwvof24vsBQq0noV2WvF2nnsIjfPjzdBJDE+gZGFB7ynCG/KeQLXNLnievUY2yPbL+MvKp6pTh+SU3VWJiWXHmPHXflL9SuZCF5ShVg3bYXK3X9iXxWyWWDkqGeRxt533PFzejq2pdff267lzDp6KgohCFvroY2YInHS/a9KeSJtzpfrBMklzZq+GjGlWPDwcONCmt/NRZK4dLhxqEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArijIkwZnMFEayKODJbB3v6zhAz+JbqjC/ic8JSSZIo=;
 b=NMM5XH16leDZ2LVXc1bzy7MPg238cVuUX76hqDZuvYmjwbU9uCXMjZyUbMtkH/iLs+dSLha9yWL97NbRChHzI2/KF7fSIg/abJVDR5ebPMkgAvLmAv8JG608Wf7l7+1ItEe5u7rYzuGKgpgptOfu5nSU/1zzmO3hpwGsXmKu2nU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6964.eurprd04.prod.outlook.com (2603:10a6:208:18a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 17:40:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 17:40:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: [PATCH net] net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister
Date:   Thu, 10 Feb 2022 19:40:17 +0200
Message-Id: <20220210174017.3271099-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0142.eurprd05.prod.outlook.com
 (2603:10a6:207:3::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2118e395-a84c-43dd-82d6-08d9ecbc6da0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6964:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6964B79CCE3D5F43100AE2FFE02F9@AM0PR04MB6964.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HFFo72OijqawKtQOZ0QIks1QwUgP0qFmLBlylukBwAGLA7D2V6AhjFkrjb18eKweIR7pgnoB76y6i84m7/ApAlgBerZvPaWSsnFtTHGJmF+0uizQWF4yg9k2I70/zuDiKNQ6TX4fyspvq8ROA+BzwiGgEf0V260FVzGA0x/INzGupcCaxD9zjq3YIXUVvUTuBxfHqqWRswIHD1g9m9TJ4qabOyeRuVm4si+2BbgS8k3ZiMhICbsLJIzM2mAU6Wp3uHzpMtuej64wp/pms4+gMo0Pt2ijB79t6QMp+fG6zXQok5diA6jQZLm2nFGeMmai33Wgp3PHBnDskeyKCER9fWF7+SUq9JiTzc+KrNff0Qpymnq5wDZ/nfw7oC3ByPf6nqPWFl0JXTOXksbNxfHOv4H8gTyVALkmH0GL1IMkHuMaafBSawK9k9uDXyAsvFA9UtCAHqy+59HvawUlflGVWG/jyq84e5Q5D/zhF9GJMbLnRad1NwEaHIESOB3Bcjx7ZiaMuLMSJBQ9jznZRcNaOgQC5Gelb7xCGmNu44qUiWWTct6c4c/OBBUO13TSq7CKazWrlqixdHImcOfX1ujd4bqAX3eQ+Otd572Fya5kTY7RSfG6Z/8XVq4vV+okqdUkjAUrmcnQMoKYbzI1/ix8aSWDbQ+wm12LTcPgs/RR341Jig023dcCN3j/Fs9hi16KvXsQh1UOBHc7KhXo6c7skVQMNwiWV3X5rWehocWnazc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(6666004)(186003)(6486002)(508600001)(86362001)(66946007)(66556008)(66476007)(4326008)(26005)(6916009)(54906003)(8676002)(5660300002)(2616005)(38100700002)(8936002)(2906002)(38350700002)(6512007)(36756003)(44832011)(6506007)(83380400001)(52116002)(5063002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O+CzASOumQ2+oF3FftCGpX+xrWYtezflPL+89YuikkhAZnx79naLdDbdRi77?=
 =?us-ascii?Q?Er461OBT3BhaCvWNw5Epm+CFZOqgHuh6D4SDPbofj68QF2xZrKOn8odhsrLV?=
 =?us-ascii?Q?RmsNsdxOyzJj062S/eSHnrro8mq3j6xKFpnwjZNM5oDHjNyysoPf+pAKWWt9?=
 =?us-ascii?Q?qxtRXvfQnCyffq+WSgGBwr+6Ykszt/A1+aDaWzi40757Zp9cva60S8oLvlen?=
 =?us-ascii?Q?OB0kCTS3EtkigzyS0C7/D9ysqlg4j+6GV9ZA06/Azwcb6OQJOVX/zTnobsI4?=
 =?us-ascii?Q?ccGT0F+dW8ABVVR2ipSkG7+UcZhU9CaDQGgrqrFd/NtweoSqnRQo018pQcO4?=
 =?us-ascii?Q?yFZy90fTz7Vuy8j/LOF2Kpzxg3CLUR6JgVxV0+/5HGN7hRtFKmo3v3BrqJ2O?=
 =?us-ascii?Q?YrMmACMgCnYlRmQAKEgNnXezdaZhqCHnoR9aiCYL0LV11t2sS/BxgilpcrXe?=
 =?us-ascii?Q?01kw8BArr6vEIUkxJtuhq4rzJ9ynbsTp1wWPgKSxbcbumEz3dupz5jzk5EJL?=
 =?us-ascii?Q?UX2Mg63RiuLUk0RUqJwOe1NjG8LMNJVhvPbTzgJfBncJmR8F1ZmLNxjVxP4v?=
 =?us-ascii?Q?swdPECXntqrb3Bf9PtcGQpexriBY52xASZ9FK+I2vnWmQm4GI4SeMCYai/+i?=
 =?us-ascii?Q?6As4Gpqy26MqgupEvCxp5GHsQ1MzlnHbGtvCFZS/WS0IjrKoOaKRK5y6zo+z?=
 =?us-ascii?Q?tPbIPRoh+41nAFsj45bNFt6s9zfgbp3tlHD+qyPMPXfV9hTOUES0BDuCwkMo?=
 =?us-ascii?Q?WHLxb/HJFfDqPBO1vC7tLEhY+Ex4uL2Mk8NKiCUA86BigJyzGl1pKNfjesBs?=
 =?us-ascii?Q?KeE+Pz+xVXzyV58BXRVFaadAPM8C9z3yO0TI4ThOO0DjrrY8EWQBU9zi5EVN?=
 =?us-ascii?Q?Gk7tXrYYQGP3E4mDvYk4AgRhTUl9/VrvYzEtq7uvOSTOzhtm9AbLttwMw+dh?=
 =?us-ascii?Q?E+mxQvXjWATvJjvMdknZF5iccJclDnISrv19/ywbnhvabHwfFC/551ASCCzU?=
 =?us-ascii?Q?VsB0Sfmy1LSruJSt53ZEU83st9rqip/tcC1KCOTsZzmEc/EoQtMpDNcThKm4?=
 =?us-ascii?Q?nb66+L/IAsfs68ShhbK2eVz7/kUqKxaewojHhOnyVMfGYMRL8M9sAr6k/d2q?=
 =?us-ascii?Q?QQpwnjrjQugPdXZ6ZrRTekqE8ly/J9Ky567sQN44cVGMZpt5x/6/ArJW1t4k?=
 =?us-ascii?Q?P/BraIAHZfIatV8v0HBuGaB21mXd8jibZ7hIyAmFZ4wEPhAkRtzAiTnOHbky?=
 =?us-ascii?Q?FTNYohlChYkx3Dvb4iaGWoD8gLDYRgClnm1wPkeZ3NJNLLziwvx+CKhyCMAD?=
 =?us-ascii?Q?WRbd9Tlyv8YI1F/seJXcEthq2rmh0Nng/nxF3s8YMO47xLxPWZj4vHSgmr+F?=
 =?us-ascii?Q?HBA56pghFovxM27pK7VMQFuawY4faHBs/JGBo/w8IM7HslY3zMF3M7hji9ya?=
 =?us-ascii?Q?i3e4otsdkSHbeb0DWXahoA0qut2uIV+YdYRkjxDq9XfbTDgwWEgoAXuqp+lG?=
 =?us-ascii?Q?/1XWy1xbCODiO1Ghdhb0ljdInhm8ay2/6R4IvolMBzF+F85iwHQs+P6+NPAq?=
 =?us-ascii?Q?qe6maGqHLbAffAlDfzO1GAhn/BHMppn3bcQDidUZFlsz+BcJlccr2jnUyUQg?=
 =?us-ascii?Q?gz5Hv99Ksqj6A/NYpxumYnE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2118e395-a84c-43dd-82d6-08d9ecbc6da0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 17:40:28.9846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHKXEdR5Ya5ag3J+L8h+XXYyjD5NGhZa/DNjtd4iEAHhTAbT/iI/HBvHeg8AS2yzz/8uaCwLcRwfn/MhsrSt6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since struct mv88e6xxx_mdio_bus *mdio_bus is the bus->priv of something
allocated with mdiobus_alloc_size(), this means that mdiobus_free(bus)
will free the memory backing the mdio_bus as well. Therefore, the
mdio_bus->list element is freed memory, but we continue to iterate
through the list of MDIO buses using that list element.

To fix this, use the proper list iterator that handles element deletion
by keeping a copy of the list element next pointer.

Fixes: f53a2ce893b2 ("net: dsa: mv88e6xxx: don't use devres for mdiobus")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 08311b5b9602..5344d0c0647e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3616,10 +3616,10 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 
 {
-	struct mv88e6xxx_mdio_bus *mdio_bus;
+	struct mv88e6xxx_mdio_bus *mdio_bus, *p;
 	struct mii_bus *bus;
 
-	list_for_each_entry(mdio_bus, &chip->mdios, list) {
+	list_for_each_entry_safe(mdio_bus, p, &chip->mdios, list) {
 		bus = mdio_bus->bus;
 
 		if (!mdio_bus->external)
-- 
2.25.1

