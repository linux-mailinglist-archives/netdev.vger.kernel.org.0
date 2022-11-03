Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59EF618A3B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKCVHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiKCVHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:14 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF51B9FFC;
        Thu,  3 Nov 2022 14:07:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U++dz/L6A8UpP8XKt5yznG3x1/skno+H0cFw4cNmjJPmL8b346nyYaQ4MbVo6SmSFo7qmF6AdbTsV6bteMKOGznT3YmGGTfd8om1BD+IJSvTbW19Sg0r1FJCN+3x8/ZGs/A6u4xCTkukZdYLtHjxChF3K9M8uzAqG8jUSS/7xSgrY9GnFsSmP2NHtrf3MoTFPyaAr53n5JohBxKkzBf51G87kU5PvefbtCP7AZtdND+Vzo+Vb9QVjETDFEG/7bBupEbGGx6mADqeFj2gJtLcmJ6bwN8156ctBGW5uz38Df0YHT9RZRXa98DA62xJ2eyOKiWZeqiN7S4XKUAFo6QbsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aknaCMtWcsEhrWWEJznCG1QAmIGj6IIAjPXJdfsQHgs=;
 b=ZoDAF78YRGM9BVg3aZWhsOI8wBV1/J6p7W0byx7MEisKRRyRzR+EaJiqA1j8fz3fXfnFKRC1gN3CI2BP+wYiF81xYocqE3UlEN15xUZweNBG6eSfqbeeMokjWg2uSoSGtPxOs/7kT2vsXvbbWFjATpovoa2q2tSZGMnrmM5/K1pcBjLuujSPW0hiX5awRENQAxfaToDQw20crntC5iJN9hpqEbox4+ysitt6ItGig5HKjVASo1M36opeZpGr/D62VstElUTeYO5lzPHMthbbthEF2PsGk3nLHO3sXbkgYWAX96m07OKD93aY1dbSl7P9yLswwZvB0vYMfARUefik1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aknaCMtWcsEhrWWEJznCG1QAmIGj6IIAjPXJdfsQHgs=;
 b=NoavuBjo3Nfs2rwTaVds95aRiyw2JuM4YmlpJ/4V/d6q0eU+BkU1Xs1kdkTjNMWaT2qfMCTX5sHbb7t6PncxM4N8+3Nu1wmAPUPVAU3ryjsx6Q8Fav5CaIWAAjK+azSC+hBgXD7lt+fuwyb6zgcji+DQT3fQ1WGqs3VtJp7oOfii1mG/KHcO/3mdQMktxBNO7bftsYq44T/zcgDtzLAcHZAJT4aH1az+MT/6DUOgE0gQEHM1ElPpZB9JgifUjgiQt8DLcAFrLPkjp1EIeND1MteffVXbFL/KyGhf9eUqpK6zhaYKpXpqIREphmwZ7+ZwyHeKPZyjhoJ8N0qj1RXO4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 04/11] net: pcs: Add subsystem
Date:   Thu,  3 Nov 2022 17:06:43 -0400
Message-Id: <20221103210650.2325784-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: c345a60e-819a-4232-124d-08dabddf5f1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uu27C4wOqSynBGcMHpwZB0ZCJEUbt6bYCRcFOCVsIAMvI3KuRlXNEWKqWHESHNmz5M0AIpUhaI9blQtHQhXqNyNfbX+OswIG/AB9eaMewYNMJOA94uvqf0PcUK5EJVrWsZvXzVoFSUp8PVcCJV84Wno1oS18hhthSj5Abud4hrgoGzGrKGx+3bNt/OdcbOwvKsw/MXbZP2jhEJQMW73BDcrJI3cgESjU72q58S5CSJWgfwPP05TaohldNDZBo9wiz3UpsujNacT5SaKmkXd74ukB8HvDxOtfC9z5q2gTZaIgT+GRXRfdK9QBrseri7nha0QH5RxmoEwX9HSsyUZtzm2Y06zwI8Bm4YHT7GW0XICaW70OcjXCDm7rYsNbGuQ9vzgFHwgzeUBCpbiK3+yCD9HCRWIPx2kr+YeGj6tFsuZsmvW0qn6kmRV2xiG8W0lnZ5ULWv8tAshXMSVNYAuWczULL52Ug8c3mksOI8EtdOORCJsoR0XH7wyHGohE6h1lzxIKIUHWu0eVl6Fn8p1KHrZaD626R7RYNmFkXeNOGVKi/9gFxkBu26xifncVljz/iAx/jOi+ykcpHeHLJ68ZcZFyxUeGP7vVrNbLmDdl4+X0NwyhbcLRKJwupbalsP/QcbWdmhGQaZPN1JaOWeuoZjauWnBOxpSekVUN0i2cMI+clEwUOSjUSTdadCLhh/7jmznRxQ0L4n+B1moH/eW9GSfw77MTLQ9G+f/pg4hXvMCkndn79m1xaDj1ewrAOtgsmfR9PVXNQBrxj6GSIlQ93wW+9IG+riXrXzwvysbbYE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(30864003)(26005)(6512007)(6506007)(966005)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A3PXb1/ogkKuUfYeN5U16pyUmZkoCZL7PuGOt2b9+E2hW8rBMbL0KgNN2n02?=
 =?us-ascii?Q?8etnbU52PfsCoQ8YogKI3dxruVGxWGcY3la4NrVdO1Fx+jXl/UqWa37mABQS?=
 =?us-ascii?Q?VkKKkk+0v80vu5chaK3Dp3jlPPH4K0La+SJ1DH05jODVICvEfv8ttKxICK4R?=
 =?us-ascii?Q?h81c57GwZoBWpwbDufDPE5gnuqBfkYlRCEVaW6NPTewgE3lP4XHBnqncU5nm?=
 =?us-ascii?Q?N7ylo8BgombK2EH8fKzFFJxCqEH2lIG/Lzfa76OHxkuX8wpd/MSCEC3dmoFq?=
 =?us-ascii?Q?FCnhghz23cBPDL9Lhc+I/UepctVijpEi8DMxwqdZceKQ6Og3bLJWPkDsEmY0?=
 =?us-ascii?Q?8NuZCbVlK7HkXe/wf69oX1Gc9f4eQfAiNev4cQr1zUG2ZGeOWj+U0HI77mnb?=
 =?us-ascii?Q?sTZ/AIBocSPxTxKNKj4wnNA0RFFTS3VrN36kOpi9PTukwV6RdRivF5k/0oUW?=
 =?us-ascii?Q?idR7SRXazK5h4Sji8i9c2AAZk7l9+NJW30H6111cz8NBkCOn+/JS9ksG72FW?=
 =?us-ascii?Q?b0hUKIUThBDYD5elrqzY6A35opYb0o21YpaI/g1O3hgdf9JEGzn7Rndk0bpu?=
 =?us-ascii?Q?V+rQ/rIFNLNzetcIjrIR9jfvAwOmYy8FQ/GmymtvDGsm4VWfTkeKBFy5WsJZ?=
 =?us-ascii?Q?XDYA77vG1RUh5PEhBPqiPtIPuAaBjm4bahHgRewu3YrQnB/Qc2OHreL60nv/?=
 =?us-ascii?Q?LDltO0FYUt+ojMU30rtz/nc/GckTZqF8QiqMheHLe+e2UWIeVpxfvzCGXY14?=
 =?us-ascii?Q?Y2yuzJY42OhLvdrLdAL5rty4uhA25KX4LKnMJVj36pfNF4DmD1vVt5LY63qk?=
 =?us-ascii?Q?E27eCoN61gLbB6RZ/fFqKI43ZGDCNl1LLMEoPpxwGL5GQJq11TaIXnXfN8TX?=
 =?us-ascii?Q?1hr74nhL+JrD+MGaWngFA8Blj2kXu9k59yIF8U1y8BfW27zxv0thLExknub7?=
 =?us-ascii?Q?VsY/Tv2bIdvA+xtcALCClA8cG6cChHq5JuoiQyTT8igP0gOJMJ3XfM0tLRVW?=
 =?us-ascii?Q?5lDj+ISKwWExAPxENxIshzJ08fMo/JUZsJxUa/9AjqMz6u4YaBxBrB184mSr?=
 =?us-ascii?Q?fwLyxYKLHe2u1ZTRvR4XKGNtkxNRjNXjwKt7C4WydkKnkRQuE93RtVHE/eSb?=
 =?us-ascii?Q?njgPsG3Tr9VRebzxCTSBrk2FRYf64UgrbmSEW3MbNeUy7GgPmmz81E42MyHM?=
 =?us-ascii?Q?nnSeYGB8Fxbp1PAZKqNM83/5EDpgBFLSLtljBjs2XueHwzE58RLp34oyNQZ0?=
 =?us-ascii?Q?0g5VvdRUj1Nz0T8gJjh5xSoFbHqAj/m/glNVTTHfszQ4LPlXe05uXbTgcO6l?=
 =?us-ascii?Q?JPBJG9r3yqV6BEm4hIbC3TWE6AHFAjC+0lDLGnvLhSvC2XCAw5fTfSEkeY63?=
 =?us-ascii?Q?2RtQafIQTH1lQAPRoKfgn7+4T8BfIVBEjs2VVY2YqepyXk9wrACVLCYQ80QJ?=
 =?us-ascii?Q?Sbnd9sGnOyfOI8DGDL4ou+FJjlrVv2VKyTq2kNuWLbr41YRSpGH5Esg8i5gN?=
 =?us-ascii?Q?BZSqRLDgJxp1OMdUVuCYPDbUqZSDxIC0B9IncmFVMzH/f9RjI+leDTo/S+f1?=
 =?us-ascii?Q?aO3a0G9crYLfUFdYRIclrIHNuIvDRSHJ1OCXYIEcWYic2iiErhYj5dwTGxUx?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c345a60e-819a-4232-124d-08dabddf5f1a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:09.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uzhOC/tsi0G1C5xnHxnaq8F/ycGP8iuE2KQihD1J1AoNIqn9qRxTEy5elhioMWrDY5lsXHtJmzjrKscoCYW+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for getting PCS devices from the device tree. PCS
drivers must first register with phylink_register_pcs. After that, MAC
drivers may look up their PCS using phylink_get_pcs.

We use device links to ensure that PCS consumers are removed before
their PCSs. This will cause PCS consumers to be removed when their PCSs
go away. There is no way to avoid this without e.g. converting PCS
consumers to be composite devices. I think that approach adds
significant complexity, as PCS devices are unlikely to ever be remved.

Device links will not provide correct probe ordering when PCSs are
children of their consumers. In such cases, the PCS driver should set
suppress_bind_attrs to prevent incorrect removal order.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This is adapted from [1], primarily incorporating the changes discussed
there. An example of this series done with composite devices may be
found at [2].

[1] https://lore.kernel.org/netdev/9f73bc4f-5f99-95f5-78fa-dac96f9e0146@seco.com/
[2] https://github.com/sean-anderson-seco/linux/tree/pcs_device

Changes in v2:
- Fix export of _pcs_get_by_fwnode
- Add device links to ensure correct probe/removal ordering
- Remove module_get/put, since this is ensured by the device_get/put
- Reorganize some of the control flow for legibility
- Add basic documentation

 Documentation/networking/index.rst |   1 +
 Documentation/networking/pcs.rst   | 109 +++++++++++++
 MAINTAINERS                        |   2 +
 drivers/net/pcs/Kconfig            |  12 ++
 drivers/net/pcs/Makefile           |   2 +
 drivers/net/pcs/core.c             | 243 +++++++++++++++++++++++++++++
 include/linux/pcs.h                | 111 +++++++++++++
 include/linux/phylink.h            |   5 +
 8 files changed, 485 insertions(+)
 create mode 100644 Documentation/networking/pcs.rst
 create mode 100644 drivers/net/pcs/core.c
 create mode 100644 include/linux/pcs.h

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..c37f94d9b24a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -28,6 +28,7 @@ Contents:
    page_pool
    phy
    sfp-phylink
+   pcs
    alias
    bridge
    snmp_counter
diff --git a/Documentation/networking/pcs.rst b/Documentation/networking/pcs.rst
new file mode 100644
index 000000000000..3f3cafee1a88
--- /dev/null
+++ b/Documentation/networking/pcs.rst
@@ -0,0 +1,109 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+PCS Subsystem
+=============
+
+The PCS (Physical Coding Sublayer) subsystem handles the registration and lookup
+of PCS devices. These devices contain the upper sublayers of the Ethernet
+physical layer, generally handling framing, scrambling, and encoding tasks. PCS
+devices may also include PMA (Physical Medium Attachment) components. PCS
+devices transfer data between the Link-layer MAC device, and the rest of the
+physical layer, typically via a SerDes. The output of the SerDes may be
+connected more-or-less directly to the medium when using Fiber-optic or
+backplane connections (1000BASE-SX, 1000BASE-KX, etc). It may also communicate
+with a separate PHY (such as over SGMII) which handles the connection to the
+medium (such as 1000BASE-T).
+
+Looking up PCS Devices
+----------------------
+
+There are generally two ways to look up a PCS device. If the PCS device is
+internal to a larger device (such as a MAC or switch), and it does not share an
+implementation with an existing PCS, then it does not need to be registered with
+the PCS subsystem. Instead, you can populate a :c:type:`phylink_pcs`
+in your probe function. Otherwise, you must look up the PCS.
+
+If your device has a :c:type:`fwnode_handle`, you can add a PCS using the
+``pcs-handle`` property::
+
+    ethernet-controller {
+        // ...
+        pcs-handle = <&pcs>;
+        pcs-handle-names = "internal";
+    };
+
+Then, during your probe function, you can get the PCS using :c:func:`pcs_get`::
+
+    mac->pcs = pcs_get(dev, "internal");
+    if (IS_ERR(mac->pcs)) {
+        err = PTR_ERR(mac->pcs);
+        return dev_err_probe(dev, "Could not get PCS\n");
+    }
+
+If your device doesn't have a :c:type:`fwnode_handle`, you can get the PCS
+based on the providing device using :c:func:`pcs_get_by_dev`. Typically, you
+will create the device and bind your PCS driver to it before calling this
+function. This allows reuse of an existing PCS driver.
+
+Once you are done using the PCS, you must call :c:func:`pcs_put`.
+
+Using PCS Devices
+-----------------
+
+To select the PCS from a MAC driver, implement the ``mac_select_pcs`` callback
+of :c:type:`phylink_mac_ops`. In this example, the PCS is selected for SGMII
+and 1000BASE-X, and deselected for other interfaces::
+
+    static struct phylink_pcs *mac_select_pcs(struct phylink_config *config,
+                                              phy_interface_t iface)
+    {
+        struct mac *mac = config_to_mac(config);
+
+        switch (iface) {
+        case PHY_INTERFACE_MODE_SGMII:
+        case PHY_INTERFACE_MODE_1000BASEX:
+            return mac->pcs;
+        default:
+            return NULL;
+        }
+    }
+
+To do the same from a DSA driver, implement the ``phylink_mac_select_pcs``
+callback of :c:type:`dsa_switch_ops`.
+
+Writing PCS Drivers
+-------------------
+
+To write a PCS driver, first implement :c:type:`phylink_pcs_ops`. Then,
+register your PCS in your probe function using :c:func:`pcs_register`. You must
+call :c:func:`pcs_unregister` from your remove function. You can avoid this step
+by registering with :c:func:`devm_pcs_unregister`.
+
+Normally, :ref:`device links <device_link>` will prevent improper ordering of
+device unbinding/removal. However, if your PCS device can be a child of its
+consumers (such as if it lives on an MDIO bus created by the MAC which uses the
+PCS), then no device link will be created. This is because children must be
+probed/removed after their parents, but a device link implies that the consumer
+must be probed after the provider. This contradiction is generally resolved by
+having the consumer probe the provider at an appropriate point in the consumer's
+probe function. However, the ``unbind`` device attribute can let userspace
+unbind the provider directly, bypassing this usual process. Therefore, PCS
+drivers in this situation, must set ``suppress_bind_attrs`` in their
+:c:type:`device_driver`.
+
+
+API Reference
+-------------
+
+.. kernel-doc:: include/linux/phylink.h
+   :identifiers: phylink_pcs phylink_pcs_ops
+
+.. kernel-doc:: include/linux/pcs.h
+   :internal:
+
+.. kernel-doc:: drivers/net/pcs/core.c
+   :export:
+
+.. kernel-doc:: drivers/net/pcs/core.c
+   :internal:
diff --git a/MAINTAINERS b/MAINTAINERS
index f99100cd37ce..bbea45c02e01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7705,6 +7705,7 @@ F:	Documentation/ABI/testing/sysfs-class-net-phydev
 F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
+F:	Documentation/networking/pcs.rst
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
 F:	drivers/net/mdio/acpi_mdio.c
@@ -7718,6 +7719,7 @@ F:	include/linux/*mdio*.h
 F:	include/linux/mdio/*.h
 F:	include/linux/mii.h
 F:	include/linux/of_net.h
+F:	include/linux/pcs.h
 F:	include/linux/phy.h
 F:	include/linux/phy_fixed.h
 F:	include/linux/platform_data/mdio-bcm-unimac.h
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 6e7e6c346a3e..8d70fc52a803 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -5,6 +5,18 @@
 
 menu "PCS device drivers"
 
+config PCS
+	bool "PCS subsystem"
+	help
+	  This provides common helper functions for registering and looking up
+	  Physical Coding Sublayer (PCS) devices. PCS devices translate between
+	  different interface types. In some use cases, they may either
+	  translate between different types of Medium-Independent Interfaces
+	  (MIIs), such as translating GMII to SGMII. This allows using a fast
+	  serial interface to talk to the phy which translates the MII to the
+	  Medium-Dependent Interface. Alternatively, they may translate a MII
+	  directly to an MDI, such as translating GMII to 1000Base-X.
+
 config PCS_XPCS
 	tristate
 	select PHYLINK
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 4c780d8f2e98..60cd32126d41 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PCS drivers
 
+obj-$(CONFIG_PCS)		+= core.o
+
 pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
diff --git a/drivers/net/pcs/core.c b/drivers/net/pcs/core.c
new file mode 100644
index 000000000000..be59afdac153
--- /dev/null
+++ b/drivers/net/pcs/core.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ */
+
+#include <linux/fwnode.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pcs.h>
+#include <linux/phylink.h>
+#include <linux/property.h>
+
+static LIST_HEAD(pcs_devices);
+static DEFINE_MUTEX(pcs_mutex);
+
+/**
+ * pcs_register() - register a new PCS
+ * @pcs: the PCS to register
+ *
+ * Registers a new PCS which can be attached to a phylink.
+ *
+ * Return: 0 on success, or -errno on error
+ */
+int pcs_register(struct phylink_pcs *pcs)
+{
+	if (!pcs->dev || !pcs->ops)
+		return -EINVAL;
+	if (!pcs->ops->pcs_an_restart || !pcs->ops->pcs_config ||
+	    !pcs->ops->pcs_get_state)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&pcs->list);
+	mutex_lock(&pcs_mutex);
+	list_add(&pcs->list, &pcs_devices);
+	mutex_unlock(&pcs_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcs_register);
+
+/**
+ * pcs_unregister() - unregister a PCS
+ * @pcs: a PCS previously registered with pcs_register()
+ */
+void pcs_unregister(struct phylink_pcs *pcs)
+{
+	mutex_lock(&pcs_mutex);
+	list_del(&pcs->list);
+	mutex_unlock(&pcs_mutex);
+}
+EXPORT_SYMBOL_GPL(pcs_unregister);
+
+static void devm_pcs_release(struct device *dev, void *res)
+{
+	pcs_unregister(*(struct phylink_pcs **)res);
+}
+
+/**
+ * devm_pcs_register - resource managed pcs_register()
+ * @dev: device that is registering this PCS
+ * @pcs: the PCS to register
+ *
+ * Managed pcs_register(). For PCSs registered by this function,
+ * pcs_unregister() is automatically called on driver detach. See
+ * pcs_register() for more information.
+ *
+ * Return: 0 on success, or -errno on failure
+ */
+int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs)
+{
+	struct phylink_pcs **pcsp;
+	int ret;
+
+	pcsp = devres_alloc(devm_pcs_release, sizeof(*pcsp),
+			    GFP_KERNEL);
+	if (!pcsp)
+		return -ENOMEM;
+
+	ret = pcs_register(pcs);
+	if (ret) {
+		devres_free(pcsp);
+		return ret;
+	}
+
+	*pcsp = pcs;
+	devres_add(dev, pcsp);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_pcs_register);
+
+/**
+ * _pcs_get_tail() - Look up and request a PCS
+ * @dev: The device requesting the PCS
+ * @fwnode: The PCS's fwnode
+ * @pcs_dev: The PCS's device
+ *
+ * Search PCSs registered with pcs_register() for one with a matching
+ * fwnode or device. Either @fwnode or @pcs_dev may be %NULL if matching
+ * against a fwnode or device is not desired (respectively).
+ *
+ * Once a PCS is found, perform common operations necessary when getting a PCS
+ * (increment reference counts, etc).
+ *
+ * Return: A PCS, or an error pointer on failure. If both @fwnode and @pcs_dev are
+ * *       %NULL, returns %NULL to allow easier chaining.
+ */
+struct phylink_pcs *_pcs_get_tail(struct device *dev,
+				  const struct fwnode_handle *fwnode,
+				  const struct device *pcs_dev)
+{
+	struct phylink_pcs *pcs;
+
+	if (!fwnode && !pcs_dev)
+		return NULL;
+
+	/* We need to hold this until we get to device_link_add. Otherwise,
+	 * someone could unbind the PCS driver.
+	 */
+	mutex_lock(&pcs_mutex);
+	list_for_each_entry(pcs, &pcs_devices, list) {
+		if (pcs_dev && pcs->dev == pcs_dev)
+			goto found;
+		if (fwnode && pcs->dev->fwnode == fwnode)
+			goto found;
+	}
+	pcs = ERR_PTR(-EPROBE_DEFER);
+
+found:
+	pr_debug("looking for %pfwf or %s %s...%s found\n", fwnode,
+		 dev ? dev_driver_string(dev) : "(null)",
+		 dev ? dev_name(dev) : "(null)",
+		 IS_ERR(pcs) ? " not" : "");
+	if (IS_ERR(pcs))
+		goto out;
+
+	get_device(pcs->dev);
+
+	/* If fwnode is present, this link should have already been created by
+	 * of_fwnode_add_links. This will mainly fail if pcs->dev is a child of
+	 * dev.
+	 */
+	if (!device_link_add(dev, pcs->dev, DL_FLAG_STATELESS))
+		dev_dbg(dev, "failed to create device link to %s\n",
+			dev_name(pcs->dev));
+
+out:
+	mutex_unlock(&pcs_mutex);
+	return pcs;
+}
+EXPORT_SYMBOL_GPL(_pcs_get_tail);
+
+/**
+ * pcs_find_fwnode() - Find a PCS's fwnode
+ * @mac_node: The fwnode referencing the PCS
+ * @id: The name of the PCS to get. May be %NULL to get the first PCS.
+ * @optional: Whether the PCS is optional
+ *
+ * Find a PCS's fwnode, as referenced by @mac_node. This fwnode can later be
+ * used with _pcs_get_tail() to get the actual PCS. ``pcs-handle-names`` is
+ * used to match @id, then the fwnode is found using ``pcs-handle``.
+ *
+ * Return: %NULL if @optional is set and the PCS cannot be found. Otherwise,
+ * *       returns a PCS if found or an error pointer on failure.
+ */
+static struct fwnode_handle *pcs_find_fwnode(const struct fwnode_handle *mac_node,
+					     const char *id, bool optional)
+{
+	int index;
+	struct fwnode_handle *pcs_fwnode;
+
+	if (!mac_node)
+		return optional ? NULL : ERR_PTR(-ENODEV);
+
+	if (id)
+		index = fwnode_property_match_string(mac_node,
+						     "pcs-handle-names", id);
+	else
+		index = 0;
+
+	if (index < 0) {
+		if (optional && (index == -EINVAL || index == -ENODATA))
+			return NULL;
+		return ERR_PTR(index);
+	}
+
+	/* First try pcs-handle, and if that doesn't work fall back to the
+	 * (legacy) pcsphy-handle.
+	 */
+	pcs_fwnode = fwnode_find_reference(mac_node, "pcs-handle", index);
+	if (PTR_ERR(pcs_fwnode) == -ENOENT)
+		pcs_fwnode = fwnode_find_reference(mac_node, "pcsphy-handle",
+						   index);
+	if (optional && !id && PTR_ERR(pcs_fwnode) == -ENOENT)
+		return NULL;
+	return pcs_fwnode;
+}
+
+/**
+ * _pcs_get() - Get a PCS from a fwnode property
+ * @dev: The device to get a PCS for
+ * @fwnode: The fwnode to find the PCS with
+ * @id: The name of the PCS to get. May be %NULL to get the first PCS.
+ * @optional: Whether the PCS is optional
+ *
+ * Find a PCS referenced by @mac_node and return a reference to it. Every call
+ * to _pcs_get_by_fwnode() must be balanced with one to pcs_put().
+ *
+ * Return: a PCS if found, %NULL if not, or an error pointer on failure
+ */
+struct phylink_pcs *_pcs_get(struct device *dev, struct fwnode_handle *fwnode,
+			     const char *id, bool optional)
+{
+	struct fwnode_handle *pcs_fwnode;
+	struct phylink_pcs *pcs;
+
+	pcs_fwnode = pcs_find_fwnode(fwnode, id, optional);
+	if (IS_ERR(pcs_fwnode))
+		return ERR_CAST(pcs_fwnode);
+
+	pcs = _pcs_get_tail(dev, pcs_fwnode, NULL);
+	fwnode_handle_put(pcs_fwnode);
+	return pcs;
+}
+EXPORT_SYMBOL_GPL(_pcs_get);
+
+/**
+ * pcs_put() - Release a previously-acquired PCS
+ * @dev: The device used to acquire the PCS
+ * @pcs: The PCS to put
+ *
+ * This frees resources associated with the PCS which were acquired when it was
+ * gotten.
+ */
+void pcs_put(struct device *dev, struct phylink_pcs *pcs)
+{
+	if (!pcs)
+		return;
+
+	device_link_remove(dev, pcs->dev);
+	put_device(pcs->dev);
+}
+EXPORT_SYMBOL_GPL(pcs_put);
diff --git a/include/linux/pcs.h b/include/linux/pcs.h
new file mode 100644
index 000000000000..41ea388ae3f7
--- /dev/null
+++ b/include/linux/pcs.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ */
+
+#ifndef _PCS_H
+#define _PCS_H
+
+#include <linux/property.h>
+
+struct phylink_pcs;
+
+int pcs_register(struct phylink_pcs *pcs);
+void pcs_unregister(struct phylink_pcs *pcs);
+int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs);
+struct phylink_pcs *_pcs_get_tail(struct device *dev,
+				  const struct fwnode_handle *fwnode,
+				  const struct device *pcs_dev);
+struct phylink_pcs *_pcs_get(struct device *dev, struct fwnode_handle *fwnode,
+			     const char *id, bool optional);
+void pcs_put(struct device *dev, struct phylink_pcs *pcs);
+
+/**
+ * pcs_get() - Get a PCS based on a fwnode
+ * @dev: The device requesting the PCS
+ * @id: The name of the PCS
+ *
+ * Find and get a PCS, as referenced by @dev's &struct fwnode_handle. See
+ * pcs_find_fwnode() for details. Each call to this function must be balanced
+ * with one to pcs_put().
+ *
+ * Return: A PCS on success, or an error pointer on failure
+ */
+static inline struct phylink_pcs *pcs_get(struct device *dev, const char *id)
+{
+	return _pcs_get(dev, dev_fwnode(dev), id, false);
+}
+
+/**
+ * pcs_get_optional() - Optionally get a PCS based on a fwnode
+ * @dev: The device requesting the PCS
+ * @id: The name of the PCS
+ *
+ * Optionally find and get a PCS, as referenced by @dev's &struct
+ * fwnode_handle. See pcs_find_fwnode() for details. Each call to this function
+ * must be balanced with one to pcs_put().
+ *
+ * Return: A PCS on success, %NULL if none was found, or an error pointer on
+ * *       failure
+ */
+static inline struct phylink_pcs *pcs_get_optional(struct device *dev,
+						   const char *id)
+{
+	return _pcs_get(dev, dev_fwnode(dev), id, true);
+}
+
+/**
+ * pcs_get_by_fwnode() - Get a PCS based on a fwnode
+ * @dev: The device requesting the PCS
+ * @fwnode: The &struct fwnode_handle referencing the PCS
+ * @id: The name of the PCS
+ *
+ * Find and get a PCS, as referenced by @fwnode. See pcs_find_fwnode() for
+ * details. Each call to this function must be balanced with one to pcs_put().
+ *
+ * Return: A PCS on success, or an error pointer on failure
+ */
+static inline struct phylink_pcs
+*pcs_get_by_fwnode(struct device *dev, struct fwnode_handle *fwnode,
+		   const char *id)
+{
+	return _pcs_get(dev, fwnode, id, false);
+}
+
+/**
+ * pcs_get_by_fwnode_optional() - Optionally get a PCS based on a fwnode
+ * @dev: The device requesting the PCS
+ * @fwnode: The &struct fwnode_handle referencing the PCS
+ * @id: The name of the PCS
+ *
+ * Optionally find and get a PCS, as referenced by @fwnode. See
+ * pcs_find_fwnode() for details. Each call to this function must be balanced
+ * with one to pcs_put().
+ *
+ * Return: A PCS on success, %NULL if none was found, or an error pointer on
+ * *       failure
+ */
+static inline struct phylink_pcs
+*pcs_get_by_fwnode_optional(struct device *dev, struct fwnode_handle *fwnode,
+			    const char *id)
+{
+	return _pcs_get(dev, fwnode, id, true);
+}
+
+/**
+ * pcs_get_by_dev() - Get a PCS from its providing device
+ * @dev: The device requesting the PCS
+ * @pcs_dev: The device providing the PCS
+ *
+ * Get the first PCS registered by @pcs_dev. Each call to this function must be
+ * balanced with one to pcs_put().
+ *
+ * Return: A PCS on success, or an error pointer on failure
+ */
+static inline struct phylink_pcs *pcs_get_by_dev(struct device *dev,
+						 const struct device *pcs_dev)
+{
+	return _pcs_get_tail(dev, NULL, pcs_dev);
+}
+
+#endif /* PCS_H */
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 63800bf4a7ac..0edbf0d243e0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -1,6 +1,7 @@
 #ifndef NETDEV_PCS_H
 #define NETDEV_PCS_H
 
+#include <linux/notifier.h>
 #include <linux/phy.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -432,13 +433,17 @@ struct phylink_pcs_ops;
 
 /**
  * struct phylink_pcs - PHYLINK PCS instance
+ * @dev: the device associated with this PCS
  * @ops: a pointer to the &struct phylink_pcs_ops structure
+ * @list: internal list of PCS devices
  * @poll: poll the PCS for link changes
  *
  * This structure is designed to be embedded within the PCS private data,
  * and will be passed between phylink and the PCS.
  */
 struct phylink_pcs {
+	struct list_head list;
+	struct device *dev;
 	const struct phylink_pcs_ops *ops;
 	bool poll;
 };
-- 
2.35.1.1320.gc452695387.dirty

