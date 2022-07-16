Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50655770F0
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiGPSzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiGPSzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:55:08 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4E7220C4
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:55:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyMfqecM1u9l98CpM3PKxZ8Fj68zc/tT7kEcleEv0D/+CfHa1Azrdcmuz6pFbo/MNpd68Z5HyAWHka1g6EshqMphy2DFkZC47M0pCZFHHKfo/LC3jbzH8i9Gih3bVcMZLwFmQKBXOm32rOowQ7rsVzDzGlh2wV6uHekqcKuL0R7CVf2wuoyXPDtYKRwFTYtHoxf72ACFw4fHLHCtjLDFpkOz6WdOnMT67W0l2Lx0JbKZYgzaBArhvyXXaClnVhTeqAUCva+K1V54u322m8Q5RiK8FndO+cJ1+8H3JS2NDCo8pPJjUVKU4bmpy9R7QaMDn9Vg0N4RXQVOwPcFDBBenQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ipc9ediMr8/TBIFbU1EDo/1r6GXhT3zrSKFB2x37su4=;
 b=nEbIP2GWmqlqAPlX9oF1Nqu7h3J8h5SgKpEmktNPBmPEcACc8QFl7u2zCGqEnQnUbXoCTerN8UzhZ6Jtya/wIAB0bt+oahPuueQIiB3O4/hYYmkCRnDjI0Ac8RSVcl16fNgPktIbLi8pRjZRzea+eJYCNI/Je/mQlcfxcYakLOAfaHWHQd85n9hknI40bmRnfq/5ZGXXUbjghmJDDs7w3OHKDF8bdveSebZXZd2arS0lHpYkL6C3e0aoLttEy6/4dasJiFE8kBwCDHfzukzcne7ZIVgQxB9kqjfvCFOQqz91gFjG04quUk+do5a7/gC0tcLqaS4Fy6GcyKqra1TJlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ipc9ediMr8/TBIFbU1EDo/1r6GXhT3zrSKFB2x37su4=;
 b=MkC1IQmqBqj7aNKv7FakSvnojztHM8KeJVI64TjUKvjrgTAunhFVc6QJjtoqmbNYi0pNEfqzBJI7UPW4iKATUkKY35WLl9kEBl1p3+zQ+y61XdShIIJIUwgVRUvwiei5Rb5SLYmZToKYEAbGo7sYUwCN4GvDyFCFlDQGYZm4cnQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:55:03 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 14/15] docs: net: dsa: delete misinformation about -EOPNOTSUPP for FDB/MDB/VLAN
Date:   Sat, 16 Jul 2022 21:53:43 +0300
Message-Id: <20220716185344.1212091-15-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4f5a1510-dfa4-4a30-de71-08da675c9f40
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TaQrlmNI2zeAx7EBkuFjI6Kymu0UFvoQBPWl0EZw9iiLz0Bw4+bKlZ8tDTnEYdbcC3M11LxMPvkYRf5YqLsyyN5D1HBmcJBBTlJkHVvEPurEVRjasS0KsPCPXRz2pYpG8C2X2O4Ihni0O16xx4qGaAIM7MuUVTcvbPdHqzSRWoQbxtmXH4nX///NWVq9yonPCrUgMlInnJIzDUgQ3vI3jjBoVqE31xwuBne8v/IpN47tmNsmylDUlMAAdTSkirBIqKOfSyCGeErosSwqC3id9e9p6xd+/3/0ovIFWok9t3PaFV1Bo9YHwbQMeAEYhKEUcAhyzUtBVx3oSM3DPXyt8EhF36Hj0ruN/pgJIwq2yZwhnZeFXEiZDEVQsqpb4/eLihKRnu+dN9ONA3Bh0a39iZWcETBJgkO4/t1pwsseR/9lgpoNltjyZzfsc/xsSAlybu7vwC3foarvkUZzYAye17mTuS21s+Hqib+Q4Mo8RlyXZlBl+PKGAWqsgXzv+P3Nqk/THuo4R6X2GPH0tErvSAv29DsvSDAzKlMPk6Eav3W6s3oylLewFfjd8JXIlv+lhdJi1QR2WH1aJfZvBonqyY3Mmo3nKgwKKb5qw8SySBh/zbnqCiu6x/m3DTL3hwOdoR7eE/z4VXOdx87AYGj5U9ssZE7AoXgJK9DpZohi5T582bszKbRwe0+R4d7W+7dc11tIvvmtgS5gvT+m9I6N22uLQr3oQJ/8v6AyiSJ29jJxUiyx7g6BO+6yPnKWaOogZ/V3HdYTcG6iyIRF4OKlYYzJFTh+CpfpH87yGlUJmyI5/1KD/xUmEDHjkJBfcbUa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dY2O/AgLBRMqeaDbHZFsDq1CDPfTD2YKA340C5D4k128A/L+x+8gWEjEkDlI?=
 =?us-ascii?Q?bt1zjCIlI3xuAjn4VYaJU+P5uLIKnIU85D2wi4HwWS9/G0I5QSbiIsUGlFxD?=
 =?us-ascii?Q?P6yWNbAULqJoi0fxrGe5yJRrKVT4RJ5jknbL/Ybdp3npaTLtUp6VF8SvPr4U?=
 =?us-ascii?Q?1XoaSeJwTBNUejjzPgzuQDoK/xyjdveWrkVMfT3+v+JrOOJg5pLeMqeFtG/D?=
 =?us-ascii?Q?18FT/mcqL8AhdTTKZLKfKotLcNHvHpgT9Y1NRNDxgpjuwxgLplT6On7h7kQ+?=
 =?us-ascii?Q?j0o4ze4MLvHDWeoOvgQI9gyez6JCVcEyZlCFjhAIIVMof0/rSaWpYcAaJtw/?=
 =?us-ascii?Q?yD5bz9EemqyFsUWuGE6FiYKvgdwIU041g5Z6AAZc2kTO3obUjjjUK08GOUdb?=
 =?us-ascii?Q?2sCL6iG0MGTx7h8pPM5f5N9yzsucaVeax8+n0Rbm2xrdLYtcLmf/S2roUCb7?=
 =?us-ascii?Q?LJyi/Fr1nPg89XXXS2u/PKdrgnxdXYYumB31SyUgc+FcgfrVCRzG517aBBCI?=
 =?us-ascii?Q?5d6Ix9W+imo/V/033Jxe5NbbGXCEVULa2oj0CTBCVSUSYZeI0yrdJ8JumzRC?=
 =?us-ascii?Q?nkV7qZu4yb3kAq3D0Y9m5IiENjmiIJlyz3GnZqL9H9cwVhOmtugKRRmz8oCc?=
 =?us-ascii?Q?jhTklK4s9ku3XCudQcBRtFirgaKz2WBXvVsz7ccQsNsILEKqLB3/05mbGT8u?=
 =?us-ascii?Q?fvAAj5/6lY6P7ImRwiRcoPRxqpKSZQe8xlFTd0+IGtan8QyF54hueTngB6f2?=
 =?us-ascii?Q?9A6xq+CUxsXeo1llD2fNcMsrdpYN6sQdnCvtzoWbTCWjq4brQf5zotVfMTyX?=
 =?us-ascii?Q?sLJBWRWBiqwAAuxZSNbc68yiZt3bSilaAjkLZQT3ta1pNs5uUprnvocQM4Fd?=
 =?us-ascii?Q?kkX/MlnukR50gZ0E7DT2fVY5e3rpEh8jJLb94fXdT4CkFfZMP8jIxREXdc/J?=
 =?us-ascii?Q?wPd/2rrZtgWlTecsKeKr7RB0T414VQqpJ6Ub4QsI672jw5XbpJbFG0+VEnWo?=
 =?us-ascii?Q?5TtG17JQPic3H8m+X2F1L3tb4/Dms/dGkEfyWfYbeRXclUUAsxe+9DSB7Bvj?=
 =?us-ascii?Q?qAtj+/fmewIhSdluBLyGraSUe5vtXRH9LbD7bVbGZp6HToDjHYaNf4zbZA4d?=
 =?us-ascii?Q?jKrMMagPnHuutMTtRrP56EuZ01fK5Apbne0C2MtLozliNgP/IzfYgzciz5i2?=
 =?us-ascii?Q?UX9wIvF5MIq1Yy26AHroXQkDsa00KCrjc2oD1/47bZDJ0wzqorToQCfF0WXO?=
 =?us-ascii?Q?E3KUk4aIUHBNdYF6hNxnzV1BVGKgc1/ipF6IvVaaJwhNZLGO5X2l/bKMvO2W?=
 =?us-ascii?Q?LMsi8aUlKVcvUEEmZ7y9cbNii5PQmC3Fef34qtqUDHzswXinBqupd8FoxBJO?=
 =?us-ascii?Q?4ma8BgDk5BQblKYYmz8LdHE4xxM82fsAaA9bX4fYb2XKzMbJ+4IMeq9MsaNs?=
 =?us-ascii?Q?a7IgWHBAFe06rMg3LgFo2f7B2vCIRNrCC2b1Gl2Q9rcCoZdeqaKdqvfRamvZ?=
 =?us-ascii?Q?AbixprLMIlJfofBQS0OrB512eyTerkFO0/eMCJ7YhWQ2tN8U+68Cp14hn8g+?=
 =?us-ascii?Q?CbnQSmtvZJ5wlq+GLh0KkzRJjSwu6PEMLCTehbnxpvhI0jcaVZi9mmg8FcQs?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5a1510-dfa4-4a30-de71-08da675c9f40
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:34.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BqGS59oX0aNFp6ChqHRePO/ENQaxeBxqWefiB9yT42Ac/r6mLYVL8jDcCRbHoaCjwdwmV3RXiFfuhWUh783CQ==
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

Returning -EOPNOTSUPP does *NOT* mean anything special.

port_vlan_add() is actually called from 2 code paths, one is
vlan_vid_add() from 8021q module and the other is
br_switchdev_port_vlan_add() from switchdev.

The bridge has a wrapper __vlan_vid_add() which first tries via
switchdev, then if that returns -EOPNOTSUPP, tries again via the VLAN RX
filters in the 8021q module. But DSA doesn't distinguish between one
call path and the other when calling the driver's port_vlan_add(), so if
the driver returns -EOPNOTSUPP to switchdev, it also returns -EOPNOTSUPP
to the 8021q module. And the latter is a hard error.

port_fdb_add() is called from the deferred dsa_owq only, so obviously
its return code isn't propagated anywhere, and cannot be interpreted in
any way.

The return code from port_mdb_add() is propagated to the bridge, but
again, this doesn't do anything special when -EOPNOTSUPP is returned,
but rather, br_switchdev_mdb_notify() returns void.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 330a76c2fab6..69ea35e19755 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -951,9 +951,7 @@ Bridge VLAN filtering
   allowed.
 
 - ``port_vlan_add``: bridge layer function invoked when a VLAN is configured
-  (tagged or untagged) for the given switch port. If the operation is not
-  supported by the hardware, this function should return ``-EOPNOTSUPP`` to
-  inform the bridge code to fallback to a software implementation.
+  (tagged or untagged) for the given switch port..
 
 - ``port_vlan_del``: bridge layer function invoked when a VLAN is removed from the
   given switch port
@@ -961,9 +959,7 @@ Bridge VLAN filtering
 - ``port_fdb_add``: bridge layer function invoked when the bridge wants to install a
   Forwarding Database entry, the switch hardware should be programmed with the
   specified address in the specified VLAN Id in the forwarding database
-  associated with this VLAN ID. If the operation is not supported, this
-  function should return ``-EOPNOTSUPP`` to inform the bridge code to fallback to
-  a software implementation.
+  associated with this VLAN ID.
 
 - ``port_fdb_del``: bridge layer function invoked when the bridge wants to remove a
   Forwarding Database entry, the switch hardware should be programmed to delete
@@ -978,9 +974,7 @@ Bridge VLAN filtering
   the ``bridge fdb show`` command.
 
 - ``port_mdb_add``: bridge layer function invoked when the bridge wants to install
-  a multicast database entry. If the operation is not supported, this function
-  should return ``-EOPNOTSUPP`` to inform the bridge code to fallback to a
-  software implementation. The switch hardware should be programmed with the
+  a multicast database entry. The switch hardware should be programmed with the
   specified address in the specified VLAN ID in the forwarding database
   associated with this VLAN ID.
 
-- 
2.34.1

