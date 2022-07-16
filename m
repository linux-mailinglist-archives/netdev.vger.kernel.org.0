Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E9D5770E9
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGPSy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiGPSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:14 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF171C93B
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ax0CrpF8DfkVO1gJX0riMHlmyM+7IJVhmk+Ww0LRMR5pW6CHMqoaIFNPLvbce3SvfTCVE6ZLw/SFBvJbS4M1dwFzOUSSx/3DOjQPjseS+sHD8wX8REf2Z4jYTBndh1rRuJa99065z4p1JGAiVaZko7cGtgHw1lMZEYu1Ta2XAmds69rJ12pCLn2xqp7OG21luZ/4wqr0ATnFe4jLHIALhx7DmJA8KeO7U8RxahEn/Bg1qRfCD8LosdVmUED9+svF2Kg8oyDyfHg13qhguLOHWKev/ra7IA9iaCWWaUsZMVlBsdPw3/TXo5I/ZWQTxYLlXnpy9s7swUdtTDogmx3VYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejRppM2+27+Sce1PWLY+I3lrLAtUf1i65yq8EQ7doHg=;
 b=ZMn4csJA2e7n9Sh+6MzcQtlpOo32zTJLu0Ahewq/z2iXVPGX49D+GeZBAdNzNq+/ygc58ntTrcuIILQxrM/lUYRZ790AnxeQDgfa+bicQ/hyf8U8K5Tj3BsYt3WMT6QvZOvzxs8QndFo0PuDAkqglmxUjKxwXjcS41gBzlnGwrvwMFm3l5VqpqgkYYY4HPnHamy0/5wQxWDiXAGcupxAackGOfSncAgoX+NCt0ASm7CPiyR66Wv1O+ryYaWGFHMYAY7mEcb3LoYRsSBIcdbSKLgsA6gVGnZVizLykUW0u2KWmH5E4pv8GYj2k5j3buxIM2BuB97+669rhDN4czBhRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejRppM2+27+Sce1PWLY+I3lrLAtUf1i65yq8EQ7doHg=;
 b=Pp8kBCrnKOZwTO9Blp88Df58TDbcxaMugDXFV16pJ1HrAK2vQ7s/XOMqktfC3ifVCYu2m4GMGCZJlfJm/iN3nma00nMl1TjPGwYXkrwGyGbiFP5IqafkBfx/m9hIs+/4aGpEpIh1xFaL852zG4a9L3F46q34lm5VTHT5Xv8LNxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:07 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 10/15] docs: net: dsa: remove port_vlan_dump
Date:   Sat, 16 Jul 2022 21:53:39 +0300
Message-Id: <20220716185344.1212091-11-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3a545c55-9c0f-46a5-ba45-08da675c8fba
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8SoHY995QGQASESDbDOf3TY8gy+hFYC8XH92rEb3DV0qOczbUOECKrcZUMayi9lbzuNUI9SR365Gv4kJn69/zlIQpyOwHMy/rhXJBUqwdeMO4oehZFaHbbSaB55Dw55a5qFULag1oXZHVEXrdPn1stoCnLCcBCKatnvK2bhdwvxFB3zAiYx9iSnkJu4Vq2BdHeLMywJiyIKJ+b8jlAPbRmZw1/A/MKR2iT2i4uLP4KZ++ISq0UsG+/7PR3cElBtjHa4FqDrQt5ZiBaN/DTU0lwZCYIJXzQrNeOmnCwYGHF+ED9rWH3h8jujIuH3ALt9cc4sDFp/w5dXW2lTS13ijYu0a8l/PDiAKJuAmRaWISVaEl8h18vyZvAiu9qGADUNaqkpmd8JNLBadstmT+cH1YrSgakAXohvvmDNIXFCtu2kfxb2Kj/hgeAfgzuLVY28vuFyyzT+prNbnj0ZtrNdunrc+1GyRV35Q92U64+60qfJYC1FehpMOld0t4b96Z5ETkTRevi+4vzdZVRRKKE0+kXhAWHlRQCH1g4tU0cttncmC1r7kBSW8LlmNXA4W9m8IQ5tolo8eN8fu3Z4DaV0iXys/JapJOKbksK2PmVewwcftmo4SU+va3onLBU+egtReLPaIdTaFA891otgW2C3fvuqSQ1cHj54hVwJhFrs60EHb7dQhPEBb9sH+pBHpWCjuwQED3HFPy+OiY/lisOKRLKyX7SwuMpdzIJI+o/Q3+ZB/m9l/ScRqT08H8Wi/DmZrLnuRtk0AgxexqijvE+LUa1z1LGQKAZSAW6GEo9489NQHleAr8cRldegFpJlpld4l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XTXJ5ETSItqdjIo7HVOYaXQD0at84G24E2vmWPoY2l4Ps6/75AIlhUAl/0Sr?=
 =?us-ascii?Q?C6waWKNjY9qOSfdSKaoHGfkgHqb4OLiNJZk0hCyz19JqbqP5Yq4h7B24vGd3?=
 =?us-ascii?Q?DmmHWNKInnlkFAg+4Js3QsK+u0+dDBmXWs82jWM8dfh0Rs4kqdBc2eW17fBO?=
 =?us-ascii?Q?Y4N34CZDYyiOklxNMKdx8OqcxWjo6blQAoehPXqep5t7QzT7s05IrKThnpVs?=
 =?us-ascii?Q?N0rVMIZ9Pv+X5Sg7bXi4BPPlMR4pCgHdcWKA9lZNHOMIKxMD4NkkzQtYL7Oy?=
 =?us-ascii?Q?PXc4+jN0ymGF2wyMLGiRqUAdFqPNrahPyBrlwO6HehNYZEzUwuuPUOsvcewE?=
 =?us-ascii?Q?kNUnFLIPI1IcMxblDs0uonnmirEQCY40mOdVZ0lKNKGDoGbYgrPagjZKLVfu?=
 =?us-ascii?Q?8EWWy6k4IO4RzBONxIljhtR2+w4ezpF+IvfxI9nYxLPdRxzSAbdQvtibkbbP?=
 =?us-ascii?Q?93Rah5xnW67Y+lofKmpovbaAAdHdPAVtSHBRXKMXmxTsuZENYMv9kb0E7Kdd?=
 =?us-ascii?Q?ZT7fpFKeLaW44U4GQe/IiXlloKfnscrGgqwfsS3RjXuZoMpdDpHWOIryTCy3?=
 =?us-ascii?Q?qjzxQvzLqG10NlDn1oUSVObi1diewqsuHaQIPZayWQWRK0a1YCH0gnLepASQ?=
 =?us-ascii?Q?9ghuaxNkwmEW85RFPwhYvfUbtowo/PDnvNr7wztGXwunsBylFJDqcHpJndCo?=
 =?us-ascii?Q?zUSpKjRWL9pCQuL96uZ5Y/gnRxygLOjcjrlsL0EQTFr4zyldRiOMbx/de/UZ?=
 =?us-ascii?Q?Yads618JHBxEhc3PbJVYT4noDNuOxyg727kkCyP0OTpm3w6t5+9Krz9p+SAb?=
 =?us-ascii?Q?CUgSQuXvZz3HsLVUjy7lTOz7D0z/OAZUv4lSoqIW7x5aMdrAUGU2zeAfKXur?=
 =?us-ascii?Q?K/CEzJtTeyXcRMjHAydrJcfwi9N8Q31Y7s6sgOkKpLQ/DW9qk9X2av0xMWL9?=
 =?us-ascii?Q?WiQKAw6h/g4mPm0yuMclCcjheH7nzxR6c99cAVxjBQUv1SoP+WX2+5k02nNP?=
 =?us-ascii?Q?qvWtEkBtRhs9HTT97FQnaNf03bOPnfkc7oz7cfC9EDgFq54rqUPIHU87y1gi?=
 =?us-ascii?Q?mqAAVwVQR6zSDt7ou3ZgG3S4rVTmE6sr8uxFuZ/ipK83CgAB5Pya3XFT0egG?=
 =?us-ascii?Q?vhircb7MLdLLHJ4XAgNQ5nbGrvNSCNH+ZoLHgHQaUfEEGuQ3G7ehzzWbFpov?=
 =?us-ascii?Q?zRVUrKrHBzYjeC85ZSZWLzwuxrmyx4p00/TL0JNAhivZvpd5env6W82QgbaU?=
 =?us-ascii?Q?5k3q3RzzKudzY54hEqlD4cU3fMMrezKxYKV4EOl5DKbMm9QL7KpRisz+RwTG?=
 =?us-ascii?Q?JFdwD0Ieg+jWX9vx36XjqA7YrVOxOkN2ixAYlKnYeuTPW3iwfZ9RgTbxk/NT?=
 =?us-ascii?Q?2MZAzY39rorEIHS9P92+9c9jAcQUei3QxxfMiw2l11h8HvTXLbWNyE2n+mvM?=
 =?us-ascii?Q?dmdvHudhzDfFVEYqCAGjce4VAEnYddW90EsnevmGscxdvyEtsr6uUw8sEznd?=
 =?us-ascii?Q?OVvBv1I3l0sqNcVzIoY8gE6djK8sE16l2HoaNXSoECCdu27ngB1T+ai/qfFN?=
 =?us-ascii?Q?2PDVjwbN47oDwtGbOysqkrNTIcgjlqK9W1L8mACRt17HObR6U2mcmQMODKyC?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a545c55-9c0f-46a5-ba45-08da675c8fba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:07.5815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KsShtdfqqzK8Eq9QoHpKlJEQ8pBwwmAZS7y5YPg3XHVtV7lvwTpEoJuth0rvJgFPVzaC1ymTL34P99gdZboLDQ==
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

This was deleted in 2017, delete the obsolete documentation.

Fixes: c069fcd82c57 ("net: dsa: Remove support for bypass bridge port attributes/vlan set")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 75346a8bab62..e61eef93be1b 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -828,10 +828,6 @@ Bridge VLAN filtering
 - ``port_vlan_del``: bridge layer function invoked when a VLAN is removed from the
   given switch port
 
-- ``port_vlan_dump``: bridge layer function invoked with a switchdev callback
-  function that the driver has to call for each VLAN the given port is a member
-  of. A switchdev object is used to carry the VID and bridge flags.
-
 - ``port_fdb_add``: bridge layer function invoked when the bridge wants to install a
   Forwarding Database entry, the switch hardware should be programmed with the
   specified address in the specified VLAN Id in the forwarding database
-- 
2.34.1

