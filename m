Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F745770EC
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiGPSy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiGPSyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:13 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386BFE024
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIhCV9ZzZ/bDT6BGz511fqMl/QT+FIr1ewCDtjlesRKViTqwlQ8ON22QCnU0Fp3fgaB85KyBUqlHOA/RS+K4hTnAW8UlOH/VczW3xxBbDBKnTn59ASsTBgmqYUXV3cBFguOARU7S3u43JwwPxWeV2pfEjndjuAHy1A89g+6Nx3h1kNAbwAntVicm/fKZMVhSUSTN+i6NDRLcr2Y1bYJeW0bo4hds5lcIkOnTntK5A/b+6Gfm2tIs5XEzLZCqVSU3vTFvxYnCBe4vQOuvLWsWk9DCtB64RfnR3s1s5IPRSR+uyfcjdT+2WbxyyIWoc8vCreJ8AsgDYBuKY1kigbKDfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnn0ovSbNKRdpPfmnCYeyORfQHrgvR20fVXf6Oek0bE=;
 b=K8EctFbrUx48/7r6qmJZJtRo8y2xpAfXVgX70+tDRB0AxXlwBH5SLeFbpgjIo08alSPsTBwryr6oMIYXAzeAQ8hTT84Anh6zDQCvu91lppAftD58CWepe5lnPfmvczxXAcy6yB9cH2/oGepJS3VLvjTmhBYvISbbzf0iVe1Wq+PclU+zQaAl6w3DNnKRzl83mNj0TLAkZ1RbwmVS552v2pLZzD45U7BtsI4mHIzm9otT2z2rGfzqZn+bOLPx0DgqlOS8AjacbaQn4rW9S6YBfZk6MO/rPK59hfn+q5tp/0qgHJiSyhiynvkkGMlQhbDehC4wJ9NqL6KobykW6yJ4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnn0ovSbNKRdpPfmnCYeyORfQHrgvR20fVXf6Oek0bE=;
 b=EVV7DkG+TdLRWKIZLihUCRNapoT10c9iNye99OAvU6bKZp1mQMv55aUInoXz4nDsZhJW1E4ndsZ3fkAW2duXBDcwnI2M5ScEeUuZYh1tA3jUsS8akTFF9HaAzK13bIeMwu+iezMh4C05oWQBurR6WoEvegWJ+y4ILm78hY0Fqb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:06 +0000
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
Subject: [PATCH net 09/15] docs: net: dsa: remove port_bridge_tx_fwd_offload
Date:   Sat, 16 Jul 2022 21:53:38 +0300
Message-Id: <20220716185344.1212091-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d1ebb594-76d4-47c4-9d6f-08da675c8f18
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JPmgeDX8JWd8pLhf5G8vIEwkZE+xvguvJN83ROaA4N164jpykzdn+FLbbr/d/5+uHEE/sVp6rlafPyv522w5EOCGQ+njvPyqPbAQYpB5EFbpuwrPjOGz+09lf+a06sICp/+XBHoHuKjlTGl40Uhc74cLfRmgIxOPDVGko2EyYOocSmhLUw4r9ZsK9cE98GQnZNMoMwhHosfaSJGlutW1Nv88/DPA2kPItYmiFBtFlRDgplXwR69j/x+NYTxdkHHBq4H8fjEQL1q0ipSEWuoBwfacuVw8Sycys2xJN86Hf9nrGUj+NKDbdgd0vTzUfmLMVbagqwqmIAGGfTvUFyvn+EFsxDYGvodh49gVGM0smnIZlDXcULwx6ZkVUVFEqfzLLeqHrkVNhmJ83O5uo67zykwMgrXYtySxx6flq/jdkfQ37sr1ONEdp2eq+RpgAUx9ekW5NpyQC6Vx13T+tg7rywRIRvErTyeRalTPv57tg7fwz2r0wbc1JIu9qwmNhUxobZdYJuoHML2Pk20JjO5qUcGceXKHT7Ge+6zNNjKv6faNkFtv7MOLHEIy1OKNCTdJGhWv1g7JuhnGpuW5mxNV9HIJ6CONtMisclGEAho04K3ekIZLVygB4AEAefx2jPpfNpK2UYQKQlN6wleGe8VvQz++9oZqAsQH1VZJMAYvTF3xpUU6TnjKxTvuvFBSL6/tx3L2oG06OSMT5YuVSeP9H5n2tNbl1c5MhgT34oIVc2vKhoXS6aSqu4AIIuhbJLK6/UnFVDSNHzaP1o+VnMsVrO09jkREKd4tmyIrnNKmUv2qsQZDF+6E8DfP6+e6QA8T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QvMPXizw2cJvl8x2fUlqjW8L5eJCCiAHJIkJO+cSm5WEKhXlbhCL+FgtGEV4?=
 =?us-ascii?Q?L8aFwwOc177dDijvqftC/CRbRAFVRptN9qirDPOoqQlPQBtQooroN4fr+do6?=
 =?us-ascii?Q?B9E1Ju0dWeRwnK/DMlDHq7eYJzHsYCOHpW1qNqhzGpbfTFuE6uOQObpgFiOp?=
 =?us-ascii?Q?jaHdSotfnwkIxz4/GzpazF2mS7So/+8Vry5koxLaus3whkXDZ2SugUhxyNy2?=
 =?us-ascii?Q?k1WO/mA4pQNpTaXsltj0omKWF8TINhTPNrMG+grPoYf0JzqeBNmrMyT0M2Zw?=
 =?us-ascii?Q?i/PAik1eT/7DteTiErlAInGQlrbUfXq47kak9R+5Qxb8NghV4ldo0jWNgPV+?=
 =?us-ascii?Q?r2XFrczCydpjEZ9w9yGUQDdSEo2siwsNzyjoyl4u2bcNVfyB2y5LYL1nTwLE?=
 =?us-ascii?Q?57Dn0wiZ8LTzu9QWaHyMxDUMJVw0BE1q9bOUeY3Si27fdktbHAPJtVnMLMDL?=
 =?us-ascii?Q?NzZ4MvBR0+QFEGGDt97an9AtzvsQhN/BCJAI4q+CnELx1mOHXXtaM/i1JpUm?=
 =?us-ascii?Q?seVf5h4S+diJn6XW/k/8wrzRRDspTIa7as7neFQTgw1yH3vnVSQGLKifJdb8?=
 =?us-ascii?Q?UW5BC9vH8oZf4owUb9TO9y4uU0f+gsDKmuvqeIg0SMofseHhtzbBWftfpkuf?=
 =?us-ascii?Q?svnzeKSur9UE2SIyl8qjN9XXj8pq/k7WQYlsRIYSvhad+2vdfN9M6UlQsrVI?=
 =?us-ascii?Q?T2dAi8ZOpJK/wxh+sWw/3+KmvZIFvz8xLTsqIMTSH1xttIvJJXK61wVR5++Z?=
 =?us-ascii?Q?ACR6QnolWUqYO4ZflZzp1xojWml31ukJYExvaY3ppjdguIXoQKuf5NWexDlT?=
 =?us-ascii?Q?/0JPF3K38iMzQeqeOXr3m4nnuI6jTJ50WBIl2ZMErloT2una/gbeYAl8d4LI?=
 =?us-ascii?Q?8Yx/wekKYKnT8qfU3/52wIdMHIDCwDrvjhY4NQp/8II7eNtal9aV6PNU7axZ?=
 =?us-ascii?Q?Y3P6EplJmSfDbFHze98w4sLL6RR67n2Y/OgzuYyVGB9QKhIk7isL+9nYsjfh?=
 =?us-ascii?Q?AEKIR321fyi+rks0hr2iieBfivEGabGXNVzoE1QfVe5QSq5FQ8zyj8Y3vcxz?=
 =?us-ascii?Q?Qwyxq7ZSY5kjY9cqBE4KPKkG00I7oHKzy2vyemldaPiMlc/Q06HzWM1YIcdK?=
 =?us-ascii?Q?gtElIQAM68+/lOJ9SSlNyuWMAHTTD2VnpXC7NUuII4UB5z3BUB49GerwV+EY?=
 =?us-ascii?Q?Yla0khjdQLwwz22FSN50JBm3+aNdx4Cx5IMBU/2OautPg5eIVu+u1CwQOrHm?=
 =?us-ascii?Q?MciQMCpTVWZIZ+SpOMT3rD0EIb04by2x8iRVWChpLZTaHO2Fvxvmf+roixKS?=
 =?us-ascii?Q?gMzQClUzn7p9PSWZqBgpFt6VR0Wb4sd0wg3xXlCNzFAH3uJ1LKj/1mYc5E37?=
 =?us-ascii?Q?xUBV5cfZJ7mxe7c2/9N5nxZo3UfgemqlCas27QZQbAun3m2dz5asNxwmi6wy?=
 =?us-ascii?Q?BOH5vk22EdkIutShwXOB0eecKI5f9OcpTW4SdWcimTIsqKt/qRjBhkASZV5R?=
 =?us-ascii?Q?ZJy764OhSaTsRimu9Id2zKXSS6oaHuBxh59HOZ/aaaCq3n65qpcWNuaIww1o?=
 =?us-ascii?Q?1q/gVBLa9yapBiP18KAZgN4TSd3mze1CCY10Url+z4eeXU4sSgWOdTrBVrr+?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ebb594-76d4-47c4-9d6f-08da675c8f18
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:06.6440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgJjjNx1EWbgNPu5576HYP22NJLCMfIIDBU8i/QbuI8AuSosZchSfikIg1zCHVZf0F6hAj6RJZAFOwZ6Agw3tA==
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

We've changed the API through which we can offload the bridge TX
forwarding process. Update the documentation in light of the removal of
2 DSA switch ops.

Fixes: b079922ba2ac ("net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 62 +++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index d83e61958e88..75346a8bab62 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -730,10 +730,56 @@ Power management
 Bridge layer
 ------------
 
+Offloading the bridge forwarding plane is optional and handled by the methods
+below. They may be absent, return -EOPNOTSUPP, or ``ds->max_num_bridges`` may
+be non-zero and exceeded, and in this case, joining a bridge port is still
+possible, but the packet forwarding will take place in software, and the ports
+under a software bridge must remain configured in the same way as for
+standalone operation, i.e. have all bridging service functions (address
+learning etc) disabled, and send all received packets to the CPU port only.
+
+Concretely, a port starts offloading the forwarding plane of a bridge once it
+returns success to the ``port_bridge_join`` method, and stops doing so after
+``port_bridge_leave`` has been called. Offloading the bridge means autonomously
+learning FDB entries in accordance with the software bridge port's state, and
+autonomously forwarding (or flooding) received packets without CPU intervention.
+This is optional even when offloading a bridge port. Tagging protocol drivers
+are expected to call ``dsa_default_offload_fwd_mark(skb)`` for packets which
+have already been autonomously forwarded in the forwarding domain of the
+ingress switch port. DSA, through ``dsa_port_devlink_setup()``, considers all
+switch ports part of the same tree ID to be part of the same bridge forwarding
+domain (capable of autonomous forwarding to each other).
+
+Offloading the TX forwarding process of a bridge is a distinct concept from
+simply offloading its forwarding plane, and refers to the ability of certain
+driver and tag protocol combinations to transmit a single skb coming from the
+bridge device's transmit function to potentially multiple egress ports (and
+thereby avoid its cloning in software).
+
+Packets for which the bridge requests this behavior are called data plane
+packets and have ``skb->offload_fwd_mark`` set to true in the tag protocol
+driver's ``xmit`` function. Data plane packets are subject to FDB lookup,
+hardware learning on the CPU port, and do not override the port STP state.
+Additionally, replication of data plane packets (multicast, flooding) is
+handled in hardware and the bridge driver will transmit a single skb for each
+packet that may or may not need replication.
+
+When the TX forwarding offload is enabled, the tag protocol driver is
+responsible to inject packets into the data plane of the hardware towards the
+correct bridging domain (FID) that the port is a part of. The port may be
+VLAN-unaware, and in this case the FID must be equal to the FID used by the
+driver for its VLAN-unaware address database associated with that bridge.
+Alternatively, the bridge may be VLAN-aware, and in that case, it is guaranteed
+that the packet is also VLAN-tagged with the VLAN ID that the bridge processed
+this packet in. It is the responsibility of the hardware to untag the VID on
+the egress-untagged ports, or keep the tag on the egress-tagged ones.
+
 - ``port_bridge_join``: bridge layer function invoked when a given switch port is
   added to a bridge, this function should do what's necessary at the switch
   level to permit the joining port to be added to the relevant logical
   domain for it to ingress/egress traffic with other members of the bridge.
+  By setting the ``tx_fwd_offload`` argument to true, the TX forwarding process
+  of this bridge is also offloaded.
 
 - ``port_bridge_leave``: bridge layer function invoked when a given switch port is
   removed from a bridge, this function should do what's necessary at the
@@ -755,22 +801,6 @@ Bridge layer
   CPU port, and flooding towards the CPU port should also be enabled, due to a
   lack of an explicit address filtering mechanism in the DSA core.
 
-- ``port_bridge_tx_fwd_offload``: bridge layer function invoked after
-  ``port_bridge_join`` when a driver sets ``ds->num_fwd_offloading_bridges`` to
-  a non-zero value. Returning success in this function activates the TX
-  forwarding offload bridge feature for this port, which enables the tagging
-  protocol driver to inject data plane packets towards the bridging domain that
-  the port is a part of. Data plane packets are subject to FDB lookup, hardware
-  learning on the CPU port, and do not override the port STP state.
-  Additionally, replication of data plane packets (multicast, flooding) is
-  handled in hardware and the bridge driver will transmit a single skb for each
-  packet that needs replication. The method is provided as a configuration
-  point for drivers that need to configure the hardware for enabling this
-  feature.
-
-- ``port_bridge_tx_fwd_unoffload``: bridge layer function invoked when a driver
-  leaves a bridge port which had the TX forwarding offload feature enabled.
-
 - ``port_fast_age``: bridge layer function invoked when flushing the
   dynamically learned FDB entries on the port is necessary. This is called when
   transitioning from an STP state where learning should take place to an STP
-- 
2.34.1

