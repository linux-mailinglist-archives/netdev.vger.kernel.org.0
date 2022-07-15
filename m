Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C4857694A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiGOWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiGOWBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5258B4B9;
        Fri, 15 Jul 2022 15:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3KfH0k+3lFOmAebcdTpD+JdxJCSjH73qlB2DgJHS0IPHX4rV3Id8N8+inytOmPWQe5Y3oTQGxdFzhojScBV5qRRxc7y+WIy1sePWc3wNj2Ry7cDQqk+L2TQGx2O44anCTT9mXjZPs96f1rrVa3Z2s2AKZWY7OGsJOaEYQvvAD1ZH9iTTcTFdwKx1zGJqhWoJ+/uDItJDMUhR0EY3ZopI54vQNvKzvi8bFCvQtZbaPVoBSqDCr2DCBoJVlKW0UdntllAtJZXrALjWChdwHgpLpaKGSkRh+EtKM6MzunYbcWHPoIMkiythzkoaHG6Ly9CZLgI+Y31pRpF39ErmYRAHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cg+cQIc2FCegiIrEJm1vgOxmPE0VZWdYu4MNifUz/hE=;
 b=a84FKrKy4mP2ukgYPDxG4GWEDWvwfvSn3U9/gtlKcA6Bc90257vbSjlmWuDXP1mfqYCiCJOXWYl52qWzlS/XvtLk8D2bc+1oq3Aw4ziV1qOe56NEJxpW1qm9F3fXffJ7NpOETzf8agsjqEIu0ZI6bIaE+l8mDycmqvmARVYQ3zb/IMOpVnKQVSWQsBkO3gR9FAoQzv3LKkOQoDPfBso/QH7rTiDrwKRB/oULIn6OzsEX9PewZk5TGk5GnWblPPJTlGZe/qOzAQNu4pgnwiIof5DOfYLcKPPTXjXQhDc5uf04pDe6Wib6JZLyyNcjIyinbLpzAAgbp/Wgu3K1Fzkktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cg+cQIc2FCegiIrEJm1vgOxmPE0VZWdYu4MNifUz/hE=;
 b=KczAAExYZ+FmO6xHiNJW3p4R1xJWtNtb+j0J2Bxrg84I01sycuBXMHhDwrKNWLTKWZyLejHlKdhoopMpYCswoSnJnu9xM8wwLxyP+Sako6UkuVmevfgHlPCNz0MNjkxyuntFwGIG5bihx3sG7hqUaOJs9K1CbvqtaGrubwvvSqMiJU53dPHmStxcGd6/JCDRDSuKkyfWeBS0eTLaSaF2Bl6TlVzIcweH5v3rgolmYoq1adDGl75QsBejDnV15o6BZYw1xlGfbEU89hwu9guo5dkHdvzj2576upxiWlpCOZjkvZgyzPB8W35oeQ1HmXH746h3s1FF9+bp0fvhbCuOsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:36 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:36 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 10/47] net: phylink: Adjust link settings based on rate adaptation
Date:   Fri, 15 Jul 2022 17:59:17 -0400
Message-Id: <20220715215954.1449214-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4649dcbe-6849-45dc-03ac-08da66ad72a6
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W3IR3uvBcAd91RqBLqkDIQlVadFWDTfntzBkNXJ4UwROAL0de8Hm0CHUFmu91naETOHDkrNndOhCoRowtV1CxBy7q3mEPJkQF9HGxVT2VvZcnCQ4zgCfuemCwOwtSM/nDFNYjRr7ZPvmar2l9ExjJJdKnSp0WhY7h6b31Q9qAtAtpa/90hdsIDAgp/j2j3RzhsjABkLrZ8WsQRjp3K8b4tf4JaMnESUUIqkNym3hS8WzgXpN4mKFi1P5tmcmZREOqERxG+1NBlvW76No2DgsOaYZa3ZVY68imoaNZfIqMnnNfzQOdKMwG05ArBMowrLyVXqRBixHrNXxkJ+WvnePXmQDRJZ7MDGcd8d1mGMYSy0sFeFuSQnmOTi+rAeSNWJ1nm60vH+CGByLmyq7h1GFK3Mr3Z98ms5QVxtQzZ8jwwZ41p3pe7PPk00gU9aaFYJVhB7P1JpJTgJSWUpWO2HlrabV0yCBFEBOlIuiwAqGNMNds/KzFWBVDdMqVCdrJbw+DqQlb7wj9Kv/WLGOoHfnVVv7iZTg5ORf3m8f7u274TL4Ms5HqCA7hjVMLEYE7m9Vk/jQkCkkRRLhw9f3GIyivbZFPxKOTHiWJstPf/Tc80CekOqMc7T3+HOWtEbeHzgAvdsTbjpiTWn6NMmxZm6JWbiVHEhMNJb60pWuk1aA2VKpIsrQQf2SUBhXxcrkbnJ/fPWxDAd6PsUAcHijakrXD28T9r4cmdN66XMtzktmck6kqvAPUKz7HRYkXoEf1B9EVAyrSqm4bMBnaFoJG0PbXs2HYfZTC7gWL57K2Xyn3rFC0YLK9FtcXJg836Z+QouN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(38350700002)(2616005)(1076003)(186003)(7416002)(36756003)(4744005)(110136005)(38100700002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gQvWoKs+Dm2Lw8jDw6WoO3TdjHsk0GpJpNe43thPT7Dy4EfSnxFtop4yEtnn?=
 =?us-ascii?Q?guH1PvmU+JveOG/2vOfL47PygdCsBfayUGKjvaYiQXVFVnGfqz6pmGKvvwUC?=
 =?us-ascii?Q?zRBw6GwXrVjGcnXVqbXBabz2Wm/3HqRn6jukLJHYAgh1mvIWcwkNZl6XmCBb?=
 =?us-ascii?Q?Vie/2JKVgqPxdvmxMBk0h3CzFAWJmIxyn+a8ktOnXNaliJpJ4K08SAcBqHv4?=
 =?us-ascii?Q?LMlNklxGLed5aEplVZ5Eehj87G8GP9MQhlkAdvLbrlgEJ6UoYjTubTheoxVa?=
 =?us-ascii?Q?F92OAlgTcUymOKFQzeM3pwIVW5E3WLdmRovYsYojiqHZb6Y3ld+/0OwAzTA3?=
 =?us-ascii?Q?D/xQHO4E8PjC9idam3m/0eh7gajIDoq3x/Mw7/ltB6oDvsfRBV28vrV9gfX4?=
 =?us-ascii?Q?Tj00o9M/wqAEDqfZwgJP8giK7ueuVwHiVuv6cqrMme8fj6T5UQrlP3+KrYWU?=
 =?us-ascii?Q?WkM6hZDgIYkYEFs753cSXv/cfCzNfzzaDypTXvuC+TDn7lJDq1AU4Woxsuyy?=
 =?us-ascii?Q?GDdsCBRoQ2h2XIP4pTrEgLvI/vyNOFCJGGAOEiHsuj1hx9+WMiNW4J//Yi4D?=
 =?us-ascii?Q?PKBhB4oLwQHY2yBHN3faEpINEHthAtw2pkWfAVywpU2YWgCKxWkpAgztt+yi?=
 =?us-ascii?Q?cH6PJ7CGSrsRWpMpZqk5ExnbNgQrYd2eZYChe/SsSY4Zb1iZhB0BxMY2dPcb?=
 =?us-ascii?Q?7qmwvxXRyKhAckdTo7kUDTEh4539+cnyJV06Wlx4RTt/ZDvytl3LzW9b12cC?=
 =?us-ascii?Q?RRM/nvY8g2JhsWDfQkVn+ayaNcrr3+oYnXGGSnhB8Q/dL4rPxeq9LtO5IRe+?=
 =?us-ascii?Q?TRwmPcPV7YmE0KgpAEcefLab6XaZWA8aUde//KU5L+OVwNIDDQK0ClS7g7hg?=
 =?us-ascii?Q?//8coi+HpJmrMCQd3dYzUMgCNbVcTqrXZpjrUj+lcuXlZjEe/1B1xvbfjPG4?=
 =?us-ascii?Q?Zw00ZEgTlNxA20tAnhtBxfgfEs8EpmDF5i0z/OAfAeF91/PlwQ6Vc5ZgSwqX?=
 =?us-ascii?Q?XrqBp5uMkxb6ZQW8rczfPGZeMXjeBGSwzm59ODFvMOCjbuLps+Go/g3tbDsB?=
 =?us-ascii?Q?CJtcyMEsluWBHPzX0bueW5NiLDfAAZ14ZqKNK7McXW6SS7TPaumNvw3/XlIu?=
 =?us-ascii?Q?hdrefB6rUTeEMTqZYu+AhjOYfkEk1+Gpl04ooJpdg+mMxQyEgjaoFo4nYE8E?=
 =?us-ascii?Q?ZrOdBztYFSLTKeZv0RZiyB3jSRyqzX8diu53VYnAzkZlerpjvDnURjahNYP9?=
 =?us-ascii?Q?aCicbrEfPZLJyo5q4DPAoWGFn4cFUtq3E/42yI1mw2nXi7tkfji4DgE4UxmP?=
 =?us-ascii?Q?+oXTca6Dk32jrlHHHafC6ez136lMwarKYgVnvzRGASJCCibdaN35htL9fXpk?=
 =?us-ascii?Q?NMYp2c+LimJsfOWTYlWzzQVgOIvi/1T5tdYFLy2BhpS6pZ22cLajVhQnP7mp?=
 =?us-ascii?Q?IPsRFO6y+dA3he6RnTqof1WAuR/uqdzZhhmB9tQgOsPioPOW0WfkJ9hRJKr/?=
 =?us-ascii?Q?PeceWd8h+ZapVWuTNt+uHK81cA8KxJe/7hQtWEQ1Cep9L0XwyieQkXJK+Xh3?=
 =?us-ascii?Q?c65/n+LWSMFsZiA+RXk5ZI9afxQNopt21jRiTemgV8/thrsSD3TTR8MVlBWW?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4649dcbe-6849-45dc-03ac-08da66ad72a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:36.7391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dkRvH94JsITO3oYo4yPGMdI6klXNuTXkUXz36twTIIMaFFF/Sq9YC1s4fu3Oz5b6Dy+a/M2opFLxfv+aoMTkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the phy is configured to use pause-based rate adaptation, ensure that
the link is full duplex with pause frame reception enabled. Note that these
settings may be overridden by ethtool.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/phylink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7fa21941878e..7f65413aa778 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	pl->phy_state.speed = phy_interface_speed(phydev->interface,
 						  phydev->speed);
 	pl->phy_state.duplex = phydev->duplex;
+	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
+		pl->phy_state.duplex = DUPLEX_FULL;
+		rx_pause = true;
+	}
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
-- 
2.35.1.1320.gc452695387.dirty

