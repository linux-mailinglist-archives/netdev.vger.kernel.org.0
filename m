Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744746BAFDF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjCOMFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjCOMEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:04:51 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2071.outbound.protection.outlook.com [40.107.241.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E430B1D;
        Wed, 15 Mar 2023 05:04:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVYQPJtm6I1+4uH6UU934mNF0GuZ8NXHVB5jI19TjTOfqPQ8TWUhbCE6Xiwi5jUt2oZw1ookSr/1OsqCf6FxtvtoMZmgHv/L2ndNlijlf/1QC/G6wqXnnv0gM5EF60C1ymQZ9bmgjWkYGNGrDC2wMU3HrZBbS2qdHLHIfBH1ZDHHf2XZuxRCigNYTRkqdVfoCc+dSgp5ImiB7nf6oKLCB9JFc+y59VlssZMojiCrxFC0a3JxuKZOjHyJvZ7Ay+x1KoijaG1WeixAfdF+ZvyQGqEknafyGpwC7WbfmSCbyPtJHejRYYmKdEs44IxK+uGQALHNSPDR8Y6bFEHPn2nyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE/kksZ9/izowAg1GSlXNRb2ouOGLUVelluEjwyW+P4=;
 b=CianlRU+8+MkBrvNb0mXtCR/E6Bk6poHRi2neFYREiYnecJ1Ru0coZf8mLYHm7I6t57eutVmf7IZ/9nIUkUvMdTEL+qGltpllyBLCG2iINK4M6s/qjqQ48K0aU9IMQLIOH4ES5xo7pziaPPq7A820x4Ib6+Cri/Gb+HhObA4gccVPZQQkeONbpewF1odsIYtBSOYPD2mmTJ9QQYmtNF2b0olWvCgkrCpCAbsqkL8jiZyiX20RHDVaYuLHGPDlwLGCMJ8dQMN9Fcr1hZWWI7nhA9Zh9bPVfyVK/nCJxw+G2i+SrgysdgscPC9/k+3kNj7yYEV6ix8upUDZFwLQjvieA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE/kksZ9/izowAg1GSlXNRb2ouOGLUVelluEjwyW+P4=;
 b=Ch/FRqZ5sg4tVF3+oesVBHavw8h73yl5kIXaS8a5J1HYbg8RaG/q+zzgoIFdXqI2s6ZGTFld2K7JVgqeP3Igav0VpoJ3gjJtylFsiO6qbuNkkueAu3ShI76NxK87DqDkAw2t2yKBfS/RVMlq7i5t0YEe6g5otdQM1zDvoaHIJWg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB8629.eurprd04.prod.outlook.com (2603:10a6:10:2dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:04:16 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:04:16 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v12 3/4] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Wed, 15 Mar 2023 17:33:25 +0530
Message-Id: <20230315120327.958413-4-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0096.apcprd02.prod.outlook.com
 (2603:1096:4:90::36) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB8629:EE_
X-MS-Office365-Filtering-Correlation-Id: f918d3c2-b8a3-4a07-c7b7-08db254d665e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: db/HAgn6pZSg6KZJrD+uRrG4CceXKl2Z3eDHeDHAMwQWZtTUchfNPnxdK+bqjGk6GjxCQK45r3CHJhkVuqRb3ckpwgF4o1rdcmWMZwhJq4Kc1y+cOwknflPgwL2XoM48qEyeoYPJky0tkvPh83ENmzYrJcJhvyr1/l293ubGkQ5+b7gJ6yxKMKrLpQ5N3YtCu633mzeRpQu2zZ7VrEXa2MzKnTpZFkJgTmRWif4OvDTe6ekGMHrSIhThML6r4KLQfG2bmyuEuENj6tE/9eYkDl42n7H7TljdbKPsJ3DKBT/VDLFJSbiCpJM4+ov0dA4qbvKMTkgT1FrIN33VBSSXGX5fXRtzAzp/qJVd/SN+YlQKtJmxHw+hIAJPDg4WewWr3eWSfLnKNN+gLrkByMQpHn3yddj6193otj/Ktcwndp0CGbv3wXqg8DGdutvOeLnVEAWUqNd4l3ris9UFElmyAqQktXDLrz1ME7tGdM5wG2RHqpfuNI/OUBxRT08tdR3GASSHtpK/yb6RSvRvXmwMpOtf4NS0p3kvqppdbnyqpmXJKEKL4Bq1OAbypGqlZvp4v8grz4kb4BrHJstYryTDNlPbdIC9fBIUwAWyVDppdNjjYIKn4qs6C0ABYKFSG0TcR+GdtjcpR2fP7AtjnlZG9f/IS1vM+68rYNP6dsLUei6LwLQbPn/Zxrg3C4yd92SkqmB1YfzdHMrIp07z6ZuB4AAbbUkd1RYTB0mND02+40G4997fB1tf3cKb+DF/2REj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199018)(66946007)(41300700001)(38100700002)(2906002)(316002)(38350700002)(66476007)(66556008)(8676002)(4326008)(8936002)(478600001)(5660300002)(7416002)(186003)(52116002)(966005)(6486002)(921005)(36756003)(6666004)(6506007)(1076003)(2616005)(26005)(83380400001)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kd4uH6ekfn5E9BQlEaLotherFXFxWR+AadcF4ktHL5p70F2PkKBYFy7k/f23?=
 =?us-ascii?Q?nJnsZfZRDdmVbaAII8+yZM//jsdeGN0IaY+hFJ9RzkpCohkElyM5RrbBLeCw?=
 =?us-ascii?Q?Q961MnjyLkZM/hiG13faOZAd89wRWUQDOjtAT1fo8ChQQfCFVM727q7m3vG0?=
 =?us-ascii?Q?wInNZpLKvoVbEcMSHRmcvSYDIxX0iTy10/XMoNgK3si4vIlZz6gpqNXkDKdz?=
 =?us-ascii?Q?C37r16H8VmKkI6e/f4lw7gdYuT+lFubrXod+Mu/lvhHowxv4Xbz+1ioNBili?=
 =?us-ascii?Q?nTIw7x/TV5PmXG5+uTTe/8M2j+5AsOXG2gluLVF6Va7Bjj0brLSGyrv1PozG?=
 =?us-ascii?Q?xCtjqSWgH4KWjJfNAZ99RCy62FIo9erDwxreutsvR3v4L5e/1iW1imF5bW4i?=
 =?us-ascii?Q?8QIWIS64nAJdSp1qz18BTRXa6fv2hmKqn+m+/qpkRrtlsLv8zbBm1qbS9Nih?=
 =?us-ascii?Q?ORCriWjEFdLeSmxUucCPTTAx6E4HTeRvg94sFjrUdqP3eusMMK2vOjT+Jeyv?=
 =?us-ascii?Q?WpyFfudoR9y4Ct65BUMz10FDsSXM6YajOgh+Wgs6B2nbaxttL7gaxStcFjO0?=
 =?us-ascii?Q?gW+YKOBs0fw584kl2dL0l2j1aJfW0kqT1CgWk6t5mv08rUFbka/1zEex8j3r?=
 =?us-ascii?Q?pEmeu21XIaG7vlzVu1gyH30xBWB7LN8U9ivqyDdhEKF8vaXs1oY4cgXv0gUH?=
 =?us-ascii?Q?+RJ+oIvtck/HpV0QDwY1+dUPvdy0xzCgInitsHrID0KTXpbu2ed9FummBWOl?=
 =?us-ascii?Q?NqbrjzUoAgloGmm/tin6DFLiMY569esBAEl4dbjwgPXJGO6f9ZvcJJsQ2jH4?=
 =?us-ascii?Q?iEsVtJOyg22shib25AJjkC8kLGuayH0Kh70X7x4PkKir4ngefAaIg/qm3s4U?=
 =?us-ascii?Q?cr3TGggnTPiEnDfnPxXAasIfvH3K/CSpe4x9IFkC4qqmv0Q6mn3ckX4AH3hj?=
 =?us-ascii?Q?lpQyGemR60ZMoBa0JZMfd+wWM8zyuvAerrOwvwGLMRctK+UX8gaA2wUXi/hC?=
 =?us-ascii?Q?nJAmkprhWScpbPUCBnkIlAQ5TrWqKiCU7SUiKO3bK3DmQdYtJzzPLFXsFJwM?=
 =?us-ascii?Q?1vOCTnkglcA5yD4Z20O6djCY+0g9faUGPIuWqjFM/4BRiNVvvscPVtKnMm4s?=
 =?us-ascii?Q?WLeMQQMKKH+3nbElzZaOWkQ9ZNT3wOl7of6/2qoDKaBpqWU0W+PvIDKrVErg?=
 =?us-ascii?Q?ACF9GmkdoBYLsugigoUKieFau0V2VnnrIW4sSvDSugdIgm+LcrSRjVS5g9a/?=
 =?us-ascii?Q?u3qew2SLTQ5zJRnyUJbjdPbeySiSgoVFAbLWgvbNnZk1H27lzvsJJq7Jt8W+?=
 =?us-ascii?Q?G/stPjBzjtcYBeusUKr2uZBFXAiKZ7N28VJo18+dQT5q4z8arjkoaVFyEU3z?=
 =?us-ascii?Q?EnbD9rLA0g5X344AsCIn7ypNxG1cU2/s1Q+mSu307z7IUJvY3gshuyiip5DV?=
 =?us-ascii?Q?i/qqGUVsgjd+mdV76pXjZcW5z6hAeb2lblfq/7wx47s+8BGicjVgj+ade5pK?=
 =?us-ascii?Q?1AUo9sNXr3Usgihg31QzyBi6uqDyHmNDFC6MyhtBj/5sY5ewjJGRQ0gFFm+x?=
 =?us-ascii?Q?s3S9uUOLdKZ7VK8kc957rU2/xE4hyA5WEk+Uu6ZgwMrE9UDiqKCjLeW4lgah?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f918d3c2-b8a3-4a07-c7b7-08db254d665e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:04:16.5282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBwt7CgTut5FUJQAaNQjDTBMD68vG+LslFpTlwS2SONT1dtFM+ctRezU42KcdFoh61XfREK2etWOPqGDgNyiPPrv55rXLmBh5XlFhbNOA3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8629
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for NXP bluetooth chipsets attached over UART.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices, corrected
indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
v4: Resolved dt_binding_check errors, corrected indentation.
(Rob Herring, Krzysztof Kozlowski)
v5: Corrected serial device name in example. (Krzysztof Kozlowski)
v11: Corrected grammatical errors in description. (Paul Menzel)
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 45 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..57e4c87cb00b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips. These chips
+  are dual-radio chips supporting WiFi and Bluetooth. The bluetooth
+  works on standard H4 protocol over 4-wire UART. The RTS and CTS lines
+  are used during FW download. To enable power save mode, the host
+  asserts break signal over UART-TX line to put the chip into power save
+  state. De-asserting break wakes up the BT chip.
+
+maintainers:
+  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,88w8987-bt
+      - nxp,88w8997-bt
+
+  fw-init-baudrate:
+    description:
+      Chip baudrate after FW is downloaded and initialized.
+      This property depends on the module vendor's
+      configuration. If this property is not specified,
+      115200 is set as default.
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    serial {
+        bluetooth {
+            compatible = "nxp,88w8987-bt";
+            fw-init-baudrate = <3000000>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..030ec6fe89df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1

