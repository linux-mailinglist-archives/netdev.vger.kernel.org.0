Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43852C7B14
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgK2UGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 15:06:53 -0500
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:38939
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgK2UGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 15:06:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QB8C44Xx8vsXnjJ5qNF7uO55aZUtAMnTrSsRL/s6nHt6X9JXkQe95PhQtx9bJtRf2pGwXnOOuxmv6/ji1liMhkvHEuADQokrRWX1VWcTyx/a4mDKt4vuIOr6eQ8x2wIMgbrQPcSuyiT3PvF+zSEheY1vlt4YgHxy9RF7IhH20QpboyxsVKXfFmLhjqYH4NUw6PiJemIoN2VYJnhTP6QRw9rlxeUOqJ/mhlBBBTwCk62UpVa8e2JyP8/ngRTtsztb7N0IwTS/rGI/xFUDjGNMo+JF2vdJ6o3TPgnviTTHDlmQj4QSWlZaIpkDBf4NagVaTlqRZNtB+osiIjos9Qv8QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xR5XAehMg+Deo9OR2jGgcER/AaO+UvMSFehTnzNJsjU=;
 b=KZYoD2prRWqgyVRKxZmzQkVaPbdR9TmdTzmkXshIAVn0aeUiRH4FMaBeIJoIKGiCCNEkT98f7BRE0OrkFoEqz3gMcTsJLl0bofGZEwIISQoxMus+ZxnHNi0F6LquRc5UNFdStNNFlcJh66fenKQfIrWxb20bZvVKbdgmN2xZExzfuOLhRr4TjclKI1nvt0AqeUflZ/eIHWmNswyGA2Q9Pt+fXZ/oYDLcm3KFAvygUFzWk8xw3oFCAS3+RvswtsgI4lEN4r+3ZaeCiCVaZht2K/ahLqd+HcOj5AAeEgKr3k3GdwJbpc6uS7V3dSLCZwuLn3NhpbWMvRJCEULqp+RBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xR5XAehMg+Deo9OR2jGgcER/AaO+UvMSFehTnzNJsjU=;
 b=q+hmuUdh9gSo3n4dgMoxyT/P76OJiFjGrSIe4WVUNsw93BHo0dYwuZ2uVxOyrxQw8XkFGJb7SlDJgeoZ2n86b0UDXCCawyc+tlcofdSXnr/KJMIMSb7AyqqRqbuTHS6hyTrTlkyFCz6XWruX1UiM1lembC2+UDc/yNEV/PcyAi0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Sun, 29 Nov
 2020 20:06:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3611.031; Sun, 29 Nov 2020
 20:06:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: delete __dev_getfirstbyhwtype
Date:   Sun, 29 Nov 2020 22:05:50 +0200
Message-Id: <20201129200550.2433401-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:802:2::29) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR04CA0058.eurprd04.prod.outlook.com (2603:10a6:802:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Sun, 29 Nov 2020 20:06:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c21393ac-afb9-4799-09d3-08d894a23119
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687F402AA0A91A222CB789EE0F60@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5Omjio6SwXJw4cH/+RBuxT3NsOC71U2ZOk5+SrxELJlZawW9y9jfSywZbXIoKFpWgkwlRFFk6zdoIGkUKqSIOP84QhoME7AAEfTQ8hWhK8xyDT7IMOqfg7pado1tdRoTWMAhl3SJYVmbwiz5dAVQCzWsA2/IGwoJo0aFwGhNHht/tnP0DPy2fg1aQhafThDItARPxee2gVIScdLx1rxSMnHlB3+qi5/SBHRRg9HP7fDRfbaaVanWAKqb4tQ0MexzOXZPYHIidE1/n4VsVweFQjG5VeUu5ccdT1tKfn7ndawKP82CVoslU3BBVGTNTvsBYd8rE09lXzoGG51OABUqjAFCGbsue3jDkG0nllDvWx/RlNfsrDG6jBwf8XZ6QmL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(366004)(346002)(376002)(83380400001)(6666004)(8676002)(36756003)(26005)(8936002)(54906003)(316002)(478600001)(1076003)(2616005)(4326008)(956004)(6506007)(6512007)(5660300002)(44832011)(66556008)(66476007)(66946007)(2906002)(52116002)(16526019)(186003)(6486002)(86362001)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tzyfpY81I3QN44WBHgXDQ/0B+p14gusIXH/r5ssJbVzS0tV9tUa04cAxPPwO?=
 =?us-ascii?Q?8A04RKvEmOxG7TLNlDn6V0HWLclfx397KGiBHDmcwLtVlcvM0vESr5qQa2X2?=
 =?us-ascii?Q?I/QJy14H58ROhjsK1KARcOgOCCeoKCE5ThjAx7ohIJkofRU8+IilkgEKs7P2?=
 =?us-ascii?Q?RuvQ7baq82tSRhXJzus7rhQZmf/Mio76KZLr8ovWhCxyEucE/19CX+B9Q9an?=
 =?us-ascii?Q?IhUmlYYmSA/FKSU6/2MqaDIKGrO96doHT0INPO0oumQotKiyS9wKKdwtF/MO?=
 =?us-ascii?Q?iXKqm9DP1eVBIe2d4rmKEuoVpFChlMur/fukWNbZ4S2Rin3cTndhs7yj9/M2?=
 =?us-ascii?Q?UrDWnl+OuwbWLLKeAENTrc9m/wDxYF7p/ys1p4J1lAoBvN8oUNvn4AcfsodH?=
 =?us-ascii?Q?vx5hdCfe2OlKeWc/ousP1jX9ba6XWThFtEix0eXgP/gZr9jVhp9nA/gUBWdK?=
 =?us-ascii?Q?XHzjUKhltlGJPAFBJDox89sS7j7f+HlLsjy0TNhVIWLeLbMMfUqd0dc99isL?=
 =?us-ascii?Q?NlYbqhw+Re6I4+7DfPveeS+entmWR9EaU6z7c2dn1QlaUe2UJ5XBy1GGM8lP?=
 =?us-ascii?Q?P69T+uHMzOekfzTEdDl1wwsTfIznnutwz1SrIl8gbO055BAZ8D1Rdahi8veX?=
 =?us-ascii?Q?VlXn6sFBGOIhl7yBh7IdadiGPCULYzkU7PGkFNseYec9vwWkAftVzCEoD1hi?=
 =?us-ascii?Q?wB9ad6KaIVdkzI3NLDA1PRxBfmRifhUiZ71XX84mX0844Px5v4KcE4CDgrop?=
 =?us-ascii?Q?QCieevsyMkJUieJUAKjlTl0gs4hVjtrhwi68mL0Vl9pvmO/jjuqEy1H8Zqsb?=
 =?us-ascii?Q?S/b/BcNb7927J1Oj8ViJUv+dlRf6i470SOzhOyMwcj74DvWWJ7CKwg7HAZ6+?=
 =?us-ascii?Q?2WAp5dWxc20fsQ5eGbdCR5mu2e2NPknJLTqCyQXKnnPtWqTyfxIH3DYKZCcP?=
 =?us-ascii?Q?XTKxY+QdqvPTiQvet4eWVSIPexiShBsHyW80WS6+nnueYDNcixQw+5jWij5j?=
 =?us-ascii?Q?BqrE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21393ac-afb9-4799-09d3-08d894a23119
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2020 20:06:00.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZ8dingb1xiZu6XuZlQNFheJpcNyJwBDT3oNl6jP4KuHdkGFHG7z9MSZwtbk4esbb/M6f56//Qqf6drwEVsi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last user of the RTNL brother of dev_getfirstbyhwtype (the latter
being synchronized under RCU) has been deleted in commit b4db2b35fc44
("afs: Use core kernel UUID generation").

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h |  1 -
 net/core/dev.c            | 13 -------------
 2 files changed, 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08ee2e90c822..7f85c23d52ab 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2815,7 +2815,6 @@ unsigned long netdev_boot_base(const char *prefix, int unit);
 struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
 				       const char *hwaddr);
 struct net_device *dev_getfirstbyhwtype(struct net *net, unsigned short type);
-struct net_device *__dev_getfirstbyhwtype(struct net *net, unsigned short type);
 void dev_add_pack(struct packet_type *pt);
 void dev_remove_pack(struct packet_type *pt);
 void __dev_remove_pack(struct packet_type *pt);
diff --git a/net/core/dev.c b/net/core/dev.c
index 916186e7bc56..78fa284225c6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1069,19 +1069,6 @@ struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
 }
 EXPORT_SYMBOL(dev_getbyhwaddr_rcu);
 
-struct net_device *__dev_getfirstbyhwtype(struct net *net, unsigned short type)
-{
-	struct net_device *dev;
-
-	ASSERT_RTNL();
-	for_each_netdev(net, dev)
-		if (dev->type == type)
-			return dev;
-
-	return NULL;
-}
-EXPORT_SYMBOL(__dev_getfirstbyhwtype);
-
 struct net_device *dev_getfirstbyhwtype(struct net *net, unsigned short type)
 {
 	struct net_device *dev, *ret = NULL;
-- 
2.25.1

