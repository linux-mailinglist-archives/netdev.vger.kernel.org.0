Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07454BBFA3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiBRSiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:38:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiBRSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:38:52 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE1824089
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 10:38:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRzNLnVBhGP1D1bVMe7QW7QvwzCFciY0pSdddICp6c/gH0vbt6mcTyxQl9U3qHv5/MmlHJTfmJu/gXSdAOiXIudnj+y8sHV8yCDxdarR0BMjhpqOP7awyvkbBmsnyM04v6yKyUCF2VXYVRbHEojeTTYPnXJBQlmEMxghnhCAeQrt2JXsZISb7JBqiZu3fjuCJgfSw9660JoD8BVJsiKKxDbK+DuIdHhREV05Ln/F9QdO5Qbban8JNuH6LeX5Xw3PksB+RecTD76dM9I10o/5Cw2LnGLKvZ6p0YQLoKLwbpszyIG80UgUvt5cfwN0qPH0v5MJuy4sZ7xNDusYsApfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xZDTorLmiw00p98KDjpRIHg4xyl4UyRfN5cUfGlbmQ=;
 b=EsDyDKOlYhqSCgaC6hKGQ6M+uUGTj1erL0InXuI4fHCwhRw+TLpt2CG8F7SBU3qQiKzw+X60cV6w4bqikJzNa7KyVE03IwhDr4ZcPGv9+y0CSmkLpnZ6nET+MOKlPkF/c0m5JvJBQyc10qcbbogKtB6oaKX2ZIXCJrOxY++iCMLRldgPuhsNkFrrSkLtvmeudzriUwi4zbZ1auVQA+7dgbF7n1EQHmfUOYUlNKPJFowbvjMNKa/X7fcWV+Y02RIzS5sEwEgCckVrCLdHnJcT1NPa5h69fsXQyBa6vdgrFQSl6q5zDtWm+PjtsyD9VHoa1RACSrmtzwYb/jGhhWp5Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xZDTorLmiw00p98KDjpRIHg4xyl4UyRfN5cUfGlbmQ=;
 b=N6nWLXSbsnu8vxoK7IyfQ9toUeB+xBZuvJ3hTGh5vWFlZkKkJslWsdBRqTsBysolE8hekf2hb0buT/D+k0gb/mbcmLfWfwpMOgDcFt5FUSYQMDR8aBr7ZBHsw0LokT611KqY15J5Z4ulHG9WiBzd3NlOWNzWGdDMR6lNNZV3B8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by PAXPR04MB9217.eurprd04.prod.outlook.com (2603:10a6:102:232::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.18; Fri, 18 Feb
 2022 18:38:32 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 18:38:31 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com, Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next v2 0/2] Provide direct access to 1588 one step register
Date:   Fri, 18 Feb 2022 20:37:53 +0200
Message-Id: <20220218183755.12014-1-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0066.eurprd07.prod.outlook.com
 (2603:10a6:207:4::24) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c699ed9c-0069-4182-a15e-08d9f30ddcee
X-MS-TrafficTypeDiagnostic: PAXPR04MB9217:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB92171A5716573B33F9425F16B0379@PAXPR04MB9217.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMIa6QyIZtpKdZC1YwbFklkd8qu34LclHkJ7K+FleTRnhVndaL1BTlX/zby1e7Cyn5INW4745WKWbVc4qki12GQKol/7XXyXO12NZd73NmQL7XGJgA8O0jOaD1tq28AaCwlCS5uDnXuv40whNfUbMJxTbTHZHuS/z8l7BQBzixTVD761xdWcO65EYoKU/k9HRLFfXYdke+7GBy3qwu6t3c608eKakkyUt8usYnWGN2W36k+R0ujNtJn/QKGsZo4A2p3dOMvE5rEvDJLtV+pbRJg2Z79etnH5rC8q7Ex6OBGf3Rqvj8HPhXoT249ZJh9pk+ROeJpD60he0dxShzOi9Qp3WPV0r/wbLLWH/gPXgvu65xRctxM0p+OJfta9Rt0hPRoC7gXLLI+xafnK/byfsddo502m5mBGvrzyR1sIx44CX1E28bZA7eR0GtQMRtkSqwkUIGuxQn8yicliJAZf2Dpj2jndedpt5G/W6daDiKcFKdWjMOlDfBWl3h+so6SpjuXTfCFbyI+7Lb9tVgSXrtbJid6rl12NVe1KPdZul9Hz/bOXJwIsHZ+ZBdMxtceonFZ1ESy06VMLkC07DqWJ7ML/P1gKqLBtF6EF6By1C4Cwpwq50BA9FrOqBV270VGDkCDPd8JSneph9jfkNOh517UIRQj2w1d4n6tye0nNjFAhYiBT4toNPys9k9LCErInpIp7ftBDAJnuHqt8QCxg7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(1076003)(8676002)(26005)(2906002)(186003)(8936002)(6486002)(36756003)(86362001)(6512007)(52116002)(38350700002)(508600001)(6506007)(6666004)(83380400001)(38100700002)(5660300002)(66556008)(66476007)(66946007)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssCtLC+vyW3lb8Kp4E04b3eNKL2h/d+RXOwwpDOuxsGn8t+0yc3mfRKUb2M4?=
 =?us-ascii?Q?oZ7DzXpuInDS+7IvtplVUui4WSPSdxaYdFdmxH5XwCRQwWTc/WKTe5NFXMzW?=
 =?us-ascii?Q?UnJ2aMuPVdk5bqe3XI9Ygvl1KY9WmLl9B6wcpES6CDyMZ5RLV3FxO/udS+rc?=
 =?us-ascii?Q?+FrsSFePlqqYgrLgYgQyHt1nYKVXBa578OQih+MHc451x4a9PaMLnHRP9dAt?=
 =?us-ascii?Q?EU8BOCQW6WV8L3zrl4VqTHk3V8EnCwXwcqgqHGTOUO1jLMFjyPzkSVuw3i8v?=
 =?us-ascii?Q?wsoYQKI51t4qC6PF17RWWRBDVUssHwaOsx1MH/wC0uAF5we0/h3mm9KWc4J3?=
 =?us-ascii?Q?kEv+E5BOJuKtw+WezJA3DR+ytsLOnq0SkezKnSF7qT0sEk+kZrHURLs3RdgU?=
 =?us-ascii?Q?9D8+wiXOdvS1xmFSRtavSMfpe8s9kInLE/uGf7LD5YIs6qI3dQjuhglxKUVU?=
 =?us-ascii?Q?cFq6kzED5tv/8CZ47kCFMBWEB7nhTYKc6+v61NwjgVs2t+7RRBkkjUUZPfAc?=
 =?us-ascii?Q?4d0vWmlcIaWDnjnlhZaysENDbAVgDYUJCQSKULcUlEq7UAD6SAHrBHt4TlD4?=
 =?us-ascii?Q?J2UXVye+UNUU5XzaZT/SME+R6XH3IhGkkQeOdfF+yEzhcocIbcSzR4zsIe7W?=
 =?us-ascii?Q?6Dx2Jxac+013eKfyWlrlDJdLavR5KcznZaY/b/H7OBzN7l7OvtSe6CyXJWuS?=
 =?us-ascii?Q?nIF26Ul8eGVk84fApuTDGfUVvrGyqExG0QRKKak0/ZgXh+5/ZXKbPpOMWVQA?=
 =?us-ascii?Q?oLkU/e7jnZgSlmqkPOImJeU6TTmr9Dg6iHtXL18NA5POGh4BbRxAcd5NXpYP?=
 =?us-ascii?Q?Q46wxWsY60WVsywlyhp7OTkjYbGON4rfdN8vl5RYCh0c7FUPtGtxYyYsLsN/?=
 =?us-ascii?Q?pdKhh1HzPep+iWl25XkDudDUQJhS90cl6D8slmrqpebDj0bLY24O+N+ir77I?=
 =?us-ascii?Q?PkinzDM1QCPFvtooz4I41Z2i9DN6KjXa8dKOQI1V7D2q5ihh94yPNmjc8sfF?=
 =?us-ascii?Q?DzEO5UtQqKR8aRpVcQusEVQ7gZO7jc1yGR3u9W+cYpXBOmF6XjI3P8IvOFeM?=
 =?us-ascii?Q?TR5oWuMh2u5nUciTZ+n9Z3q0p6KVnuNSCuldszbTiTSAAa4t7FCPVDCKw6Vw?=
 =?us-ascii?Q?o4GYNdrWYTYU3onWBh8yK/xQRXL3VeqkpV5nnKS4qSsMaw5pMOSjdOeYwCpu?=
 =?us-ascii?Q?pwYUkoxRzAY5qV6arnT5LlZ2OWwbKxpcS2tvk84EBw0p+Ezsk2DzW9NqjluS?=
 =?us-ascii?Q?gxjHnagc584mY77tuvCiOruqu8E7aaOKcgNGTOX2MNZqA3yWZU/XnEdY/zW/?=
 =?us-ascii?Q?O0/qlCafNaIgKqzYEcDIFWNMn/OY4K5diRFk7XTlEsTScCGGQv7SAPxtp48Y?=
 =?us-ascii?Q?kU4jJLEPrD+pE9lcvwUclqd+tzLlercshe2Lk8DAwBJ93eNGlHJn/4Ed+W0J?=
 =?us-ascii?Q?r5TykE1qszTyb54wDpsD2cVKciIW41yTIbyE+tEotF8SFqe5sem1j+i0AYd9?=
 =?us-ascii?Q?ju2HLObHXrwaj1A1CvHbI8MqlDNkWnbYiI+OEW2ek4imVq/8OUtZjFjlsQmU?=
 =?us-ascii?Q?KI61YV8QkKTlEOnB/Cxv+iIwYCEXg50fmhj/HwIPy/ozHEjP0u/yYnfsfj58?=
 =?us-ascii?Q?T5EHPwKdXlPzko+cAiKW6GpkMVkc+gsw7FESpTlyMqMeJZMPpEnD8RpLy7Cd?=
 =?us-ascii?Q?p9PZ3g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c699ed9c-0069-4182-a15e-08d9f30ddcee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 18:38:31.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8Asz8vBRxVjZ1ge8q5P28oMf3mwx388VuSbSweXQiocpsuQaz5pxVvlioHm1CZ7/kMa1U04a2vtQ9Mq0a+BhVUinAcxAaNLJgClMWyWXRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9217
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 MAC supports 1588 one step timestamping.
If this option is enabled then for each transmitted PTP event packet,
the 1588 SINGLE_STEP register is accessed to modify the following fields:

-offset of the correction field inside the PTP packet
-UDP checksum update bit,  in case the PTP event packet has
 UDP encapsulation

These values can change any time, because there may be multiple
PTP clients connected, that receive various 1588 frame types:
- L2 only frame
- UDP / Ipv4
- UDP / Ipv6
- other

The current implementation uses dpni_set_single_step_cfg to update the
SINLGE_STEP register.
Using an MC command  on the Tx datapath for each transmitted 1588 message
introduces high delays, leading to low throughput and consequently to a
small number of supported PTP clients. Besides these, the nanosecond
correction field from the PTP packet will contain the high delay from the
driver which together with the originTimestamp will render timestamp
values that are unacceptable in a GM clock implementation.

This patch series replaces the dpni_set_single_step_cfg function call from
the Tx datapath for 1588 messages (when one step timestamping is enabled) 
with a callback that either implements direct access to the SINGLE_STEP
register, eliminating the overhead caused by the MC command that will need
to be dispatched by the MC firmware through the MC command portal
interface or falls back to the dpni_set_single_step_cfg in case the MC
version does not have support for returning the single step register
base address.

In other words all the delay introduced by dpni_set_single_step_cfg
function will be eliminated (if MC version has support for returning the
base address of the single step register), improving the egress driver
performance for PTP packets when single step timestamping is enabled.

The first patch adds a new attribute that contains the base address of
the SINGLE_STEP register. It will be used to directly update the register
on the Tx datapath.

The second patch updates the driver such that the SINGLE_STEP
register is either accessed directly if MC version >= 10.32 or is
accessed through dpni_set_single_step_cfg command when 1588 messages
are transmitted.

Changes in v2:
 - move global function pointer into the driver's private structure in 2/2
 - move common code outside the body of the callback functions  in 2/2
 - update function dpaa2_ptp_onestep_reg_update_method  and remove goto 
   statement from paths that do not treat an error case in 2/2	
 
Radu Bulie (2):
  dpaa2-eth: Update dpni_get_single_step_cfg command
  dpaa2-eth: Provide direct access to 1588 one step register

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 96 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 ++-
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |  2 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  6 ++
 5 files changed, 110 insertions(+), 12 deletions(-)

-- 
2.17.1

