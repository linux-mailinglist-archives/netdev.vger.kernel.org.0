Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780D55770F2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiGPSzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiGPSzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:55:13 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80088.outbound.protection.outlook.com [40.107.8.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB1B21E16
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSjLb1JtNkcAycFJLW/qxHcP1MUpEmDyd1o6iXJlvOZlcVWMDYIMg0KJK9pX6DlNO0Cz3WzolXxm4NIUAXAFwdTrlAU+xGpI9M4wn1gMPFPJdj9QxX5azBaL8NMVEBAufrFqJJQ+p4UZs4ep4xc5CD//arGaM1SVjV3Hkaocu//tBMlVxsx5ErOYreaNBl6TyPrNsgUOC7lUWTKxYphdVBvAEnVUMH58Acy0i1xs1GxozXbUdsosE7mqAUyrukELUme8dK5rmcQuDWPni4KMaMOGMBtZ+iN93u+HMnJjNXtdNrxty6GJ0xiKZkiW9cytpCknSNjsRNM8C1BbzrLDJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koMjp+pRp+8pPPrEoLnCDYjxYSDi3FEyUroevCL2lDo=;
 b=YA4OKbDa/ydJkH4i5tB5WXKQ1VJIARQuGYppCXbRF+/NunIDVHUuggbEp2t0af8Oweoygv6dEa5Oj8mWlCRwUEeMCI9qRYob/DeJVzMgnBAsLa9Evo/PqogR80ENnzKt08VRHd5YjoNc8oX30X9ZPfg0vCfT1rXrbIyBTsxvLcYdZ/1h9Cz2SCfF6ntCEiWwqDC8MUadCJQ7kUOnDbgl7xzA4XgsjVIxhtOnLIdvGo0iNki66Y5O0Kl6EoaZMrUEZByfMfEOsl5hFSWBNO7QmU7r/bK+8B+NydHJZzujt376koDDbM1myFTUJiaYU8eP26hGEqiLnPq5X8uliH8wgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koMjp+pRp+8pPPrEoLnCDYjxYSDi3FEyUroevCL2lDo=;
 b=AfqcYlODWyRHCF9ujIRJd65g97hYCGIZXAN4/s3WM/TcCKgz1vuyU+xjFuAg2yTumS6ONTGvrjmP4F2zsJgybTirEhZWoOrNomHLtQpXj6oGYn4LltGP9DH+jcIeopQVwoYJ0CnbzEXaeQcccYyZJR2VZTH7opsjfXMphdiK3zM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:55:09 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:55:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 15/15] docs: net: dsa: mention that VLANs are now refcounted on shared ports
Date:   Sat, 16 Jul 2022 21:53:44 +0300
Message-Id: <20220716185344.1212091-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebbc9719-fbc0-4dd0-a96a-08da675ca981
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGYPzRmHgTdDsbNNgGIs/gggGIs4L0hrNrBUqoveNmbdmBEOHMmJF7YWU7RpRWqzkGVTDXNB65/Tyg70PTWY8hJdAp2MIQU5tgZCaMxQnfFAgXpeKWGmXLix2fF66/fmMr2I0wZ1Yr9eU31VwpoiIZQU8d3yl7ckqvjfmoy3lR8NI949ald+D0/dNQTwimPIJQfoUtM624rdDmdxswGfa2dv/gZslb9axEzlduuRPQ+t/m82/5gE+O2n+11HnGJbprFkk2AQ0I+brKOX6TpJaPDcQ907F4tyV+FKlsD093es4TZCg7V+WwU5OoVFYMJTWYZ0tJ+dUabQitxUqbmjhO/aPIUwuJzDfQaEy1V5nDvdlVKdHoZccOrssyX48fzxMFsvRgvqg4Z/5aTWe/vG4LXDD4y8DNd+1pjCClyPRrXFjzWNgJiWVLZev8DKykna40X9T8F2By4l/Zd2f9sFktWGhnfMoMgBGXfQleVZkIgdutuLpBYXCnV6o8tCjOLTj1BGqrZ9E5tXpuQAMkH6nblIiJEZ6j8nVxf6KeaFAJNNGMzMPP2+BYUZpbxPg9ajJnb4zg5jf5OtOIIo3iRHVEaQKPgM042FB8eLCaaMXn5Z/Ys/5YxBy0bVVd3StE+wL93WbKwsOhmmbA8oSyM/s/GmGbYQL8Jl6XWONCbvLPW5OVXQmbLlZsR+SDdI4o1fBC3mmSryQYwYb3PRFflG4k1NngvMkZiecL5y8WIf8F5YwEUNZ/gw6TQRWqfc+ZqApfFWVuMMgh2XmIdoM5rarNBdXmeLvbENKdEIGwKPDs8Njm11yCw3UAjMvfzCcZhF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?55AfIGhPtz9t2Nrvi7jouUbm84eRou2XTJt5ddH8+2FmPBFjvmxPHc/nkh0Q?=
 =?us-ascii?Q?SM7x6YjiWzMdrgnQhoSZEkikl31nRO0d7dc1ZVYxxOb55magPkO9SQ2MrfVw?=
 =?us-ascii?Q?2qQU0IWHM9xbepaaDxg4+WPJd0ybA0WPVpQiEFtaPGy7wdO7fHDqUJgHEVuA?=
 =?us-ascii?Q?qQ2E/01TSwtRjkSVcuDUCpPstOF0lS6eqYXtUm8PX0VUgOIa4FO8GvXuxOqD?=
 =?us-ascii?Q?HqLKR6aZknJmtetGv/5Y1PguzDQMifioRMisEkWGtQELvSeCjqWDBLUpB/qk?=
 =?us-ascii?Q?E48xpRU4OZCyU24REqOTcudaBIRETGcgxrPH5d+VfodX+nY8f+qNnfxT7nQ4?=
 =?us-ascii?Q?QNeYCumko8XWbN1VPpWhKnPSKTOyiz0tRZPspQ8f7QHWQ/2hfPOj/tAYvLYf?=
 =?us-ascii?Q?tTL5erk47sO/04YznZ9RiqZlZL9eJoYACAMRQdBbFyK2CvZoNRVvPYUq6030?=
 =?us-ascii?Q?yZuSkCzRdOqSE0VCFRmlZbpbyMPejUvu1JcQix1azYY9HVGuGU3Qj/jpVLa1?=
 =?us-ascii?Q?ry2AzF8jtlbp85Ydh8UIWsjz5IDh7ZKRypnnXUBdirSauIMSrs8AWH9ICXb+?=
 =?us-ascii?Q?pECCDPseivZsWX7sImVIBWBZySB/RDB4huVNwDeRcvb6KmWqEFnSiWanrMOo?=
 =?us-ascii?Q?rd3J4v0jQ9GMoPnTe9tgGrVExocw2OhpRoDY7buTe2EtW+PfLZG0Lt8UkauH?=
 =?us-ascii?Q?wwpNIDPKqrEjlnHK0q/WtcNpnCKlw6+egDffyv8ZB3IrhNA1ZQDeRZd8qr5M?=
 =?us-ascii?Q?nxtbPS1PDMcidE3hq9FaNzPS9hahRLMUHY1yXhgbxXlWJukoD7TebiSzLZEo?=
 =?us-ascii?Q?xwnNHDcE4ARyxTeN6VtQpQiYh9+g8YMLaoAN/uNVsbZDpYZEbRTPgZUCieq6?=
 =?us-ascii?Q?ugi8u7j9hOvk8dq/ppXraaO8swDL8B4WX5LoSsVvKBfkpYtlRnNz5375GT+Y?=
 =?us-ascii?Q?73JUDNk+BcUuSBhCNlWb20Pm9WnNWmjbQ5DnUbX6JTOJe9Yb0MA3CdC48EzY?=
 =?us-ascii?Q?uyoerkWVw8OHQnJCfaqHw2QnkFaeIXrnktsIQjuapxaIyLSZxyVpKSWcd1Oh?=
 =?us-ascii?Q?IFyAcIiVJ0VbLaRk0gYPlEf6c+YBWuTRM8OCgU1nlEoUmbfMTGzuJp3dSYqp?=
 =?us-ascii?Q?9vrFrgwJp48/YqkCLNsTcZTR9UEpQ8GeAqqoXEoGC/3QfbK+kzuIEAoTj/j5?=
 =?us-ascii?Q?EyfWuIMQVJzyKSSpnc45CKcgyHRFOh2SIy4SKYVT8BoVDkyQ1VBHdId+tSwA?=
 =?us-ascii?Q?hC1U+WJ+svmkdmwYtaE96O/dOAUrIyWbN2asmjuvJgivauXQlVZ+xQ6g3t59?=
 =?us-ascii?Q?MipPSgbMCPxgXEGT7Rvk6Y6IjLf+0w+au2BrpP/ZC50hCGcu0IXGV6DaUjOd?=
 =?us-ascii?Q?HABB7OSbAdjy3KNG97G4NB8aaQud86LoTTBYgjJjaQzXx8EYFHFOBwTdK8HE?=
 =?us-ascii?Q?Ij+ZBafJdcYvg5NrIyX/Zv287Q+oUQQw1PPprFfiVPGvgxLO0Ao24VxB9roY?=
 =?us-ascii?Q?Fo/2Sv8NSSTyzdc0yh3qrR5C+6Mz6VsFGZmQMcdnvaJRwYVJAy59MArJXLqz?=
 =?us-ascii?Q?StnSNCKMau1uIjCNY7U8gVjg2b5khRHPvi8LB79sWySDOJXlQAqAVvBuOxgG?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbc9719-fbc0-4dd0-a96a-08da675ca981
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:52.1875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lJTulj1GxA9Tf+K7vlgFI5B8IpKDMz4YKepIpfZf/D8vXn6rtwCiByLYdi+a84s0BCFAXiylCMg4wJZwedFt8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit updated the way in which VLANs are handled at the
cross-chip notifier layer and didn't update the documentation to say
that. Fix it.

Fixes: 134ef2388e7f ("net: dsa: add explicit support for host bridge VLANs")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 69ea35e19755..d742ba6bd211 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -951,7 +951,13 @@ Bridge VLAN filtering
   allowed.
 
 - ``port_vlan_add``: bridge layer function invoked when a VLAN is configured
-  (tagged or untagged) for the given switch port..
+  (tagged or untagged) for the given switch port. The CPU port becomes a member
+  of a VLAN only if a foreign bridge port is also a member of it (and
+  forwarding needs to take place in software), or the VLAN is installed to the
+  VLAN group of the bridge device itself, for termination purposes
+  (``bridge vlan add dev br0 vid 100 self``). VLANs on shared ports are
+  reference counted and removed when there is no user left. Drivers do not need
+  to manually install a VLAN on the CPU port.
 
 - ``port_vlan_del``: bridge layer function invoked when a VLAN is removed from the
   given switch port
-- 
2.34.1

