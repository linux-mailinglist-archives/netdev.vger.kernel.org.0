Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362DB6B79F6
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjCMOK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCMOKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:10:16 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50A16C1B2;
        Mon, 13 Mar 2023 07:10:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKkIqQ3eTi0Vsvd3Zvp71hTCUzB+Qo8nNkarI6S4vZtjN9DkFpOD0/4SLoeY7t/Zb7D77CQE7YoeO+W6gCO3XgHAKHSr9YTDsI8HoodDiRR8dWneesicR5n6bwLHpFGyBBqgBGvym5z/uUEX9UOvCxxxqJl4rpaPAnNuMlanOQhEa8NBBSASE+OF7sIm8mPNX/wIP86zGaAuSXwHugvvMBwZYCx8rY31yuzXFaZcp7FkMeLuZ1xbIR6CaYvwgaPlzKW0YvySlsxMWNQtPInEzLknKD03car53XTNLjNrQiqGdAbyZ6Q/3QXKHdc1tUjDhTj2hlFDmO0IIurpwTQ/dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=R1fz2RmDXQIV3H+TGaXO+pBU/z8ZBLzgnrhNZyI8At/OjnYhSV8Emid2s+FwsPMUYP0fVUR8mVv6BWKCSrRjWIIrIM8tup3QCmjTM2YSg3EXIkMNIntmET/PLVeIeTb6BJ6w65ZXacZp+7LMqoACV6z9V+AQwV9laSi2cC2R3ZSt89/o0NDrPQX5nVjVaJxAT0jNrt8+tbrm1vxtIN093RkznBqoBbQfYZaHLvdNSc/R0kQNeXDDMU+S/fFnxJy/9ZSb79vwAJrODhTjTV9o4cMZ7PndTG+rEj6rIW/l0Dz0cjN+H2hZPKa7LxpQMvv6cTW0UnZ/D7quJ7B7OZErwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=a4J1Z7MOck9Be6s4lEfMbnAy1kviYHQDnuWRx8zuzRLID4In7y2VziJkbTTxZjCCgQuhG38iEv0sBzZg8kER9bb2wARg/0TSyHbcOA/2FauBmAZVOh5pvABowQRycQOO0ERkM+CstB87G7TrzHV3X0KL7VqKSJVszmVRFDc/tnU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS4PR04MB9244.eurprd04.prod.outlook.com (2603:10a6:20b:4e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:10:08 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:10:08 +0000
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
Subject: [PATCH v9 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Mon, 13 Mar 2023 19:39:23 +0530
Message-Id: <20230313140924.3104691-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
References: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AS4PR04MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: 02052ef1-d4ce-4f97-8518-08db23cca701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9t5k9O0FtbEs7gY4NuAVwP7OvvfTk8I0QQmAl8fnPxOPcSYLzQmb4F4ZXGgrzMmZeBO0Qq7cANh/8O+xBkDc5x1fQkGQbm1PDubzazXxswk1Hb10iV2CQMocRHb63UA0EJfC54q3D9+lOPh0kme2akkvapl+mNY6RMhglEuL1qlJ6BXrGfrNtAhg7CF/+nm1XVCai6HSUs8YhKSMgqgyI7zrrKjSiR/V681XaF+9ZPT2Mrd9zLV3eYvdBgtQxpNBGrz+H+0qWRFx7TRzOHNrPxVjpKNWSl7vdDQm8PtPuZkf09ClqsYE5pnH8KxwsEKtsFG8GQ+6bIpy3nrP0135SMb0jl1GmuRVhQkmXZeD8Z7vwYAd0Uaf3RveYu/XykyO9NcLF7qVCyWdXf9+ZMCwRwTuzDjVPgGITShOMfF2z8gFLsS4/wWIGT3Ar46aJmP1xJ9iIJVnjlylrxGCWcmTyZP1AdYEahg0vsL6LgvxzcocPZ0ACS27TLWuWO3aJbHojcOOjVMozuMNxsa51KpzdOiJgTbyMDxFqo10PySmCr+gChEaK43XDOkzusuMQT6ClQtHdhyFLwm2gJ8sVrzbswAzuA2PcOZJm/GI5jWabr+3Uswhh5tRHzahL2KuTqVKjyG6W8+nKb2lZburapQgdVpexbjXHU4azr6AOZU7+/G2ZnL1AvWR2IqGmGCn8gdcBad0/WwDoLi+IHcATQgWCdBti6EUhelkOgfUXYLyPNsuBcOy2/HwqjL6JDFFtkU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199018)(86362001)(921005)(36756003)(38350700002)(38100700002)(4326008)(8676002)(66556008)(66476007)(66946007)(8936002)(41300700001)(478600001)(316002)(6506007)(7416002)(5660300002)(2906002)(2616005)(83380400001)(6486002)(186003)(6666004)(6512007)(26005)(1076003)(966005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dr0dstsF6cDVorfNtDdM0Wyl5n7p2wRhZY4QQDbx6B6CH/m5BMTU4OPXhsU0?=
 =?us-ascii?Q?7EpykD+84y3ZZ4zIPdyxli48YzEYhZTPbKKCazPqm3fT3WEvClX47+3A7H26?=
 =?us-ascii?Q?2lxkTFvpy5OptJipAoskz/8yD3CDjSCzkrPW32QEhhlgSKFoD8sAztmddA+z?=
 =?us-ascii?Q?X/UcHe1WVIAJwjOdgW1xvPAJRKnEUJae7MpLxphpN6P6R0OzJ8chyBBssR+c?=
 =?us-ascii?Q?dSPXHX37G8Oe4PqQjuAQhEs9zj2IkVEwcciESY6v8CI+fiLIPgvyRcGXTPvN?=
 =?us-ascii?Q?SVqo+k8Kf8IYnWh3LTekdBb28HtKpTRx3BrlRVP8KPpWlyvbw1oaiYL0K86Y?=
 =?us-ascii?Q?P16WwaCXcKsNEyQ+BWbhje5OMEYfsL3ZwzXks+W9je+8MhPyM180KlxP+4ey?=
 =?us-ascii?Q?G3mycZtZSBikCNiqN8bjMqau5IPRPk3SbTkTh5moMDfbUQBFtmvLIIQo6gx/?=
 =?us-ascii?Q?V4+W11PomCKRyl0pk+iwhFCtZya9qJFMAFPEQdzWbwN0wkozSm1P9v1cbtzM?=
 =?us-ascii?Q?eZNTYhhx2XtUsAyAPCqmYnn2Z9R58QnPzks0Nk9XW1jRR4hfnmgqzijsj1gU?=
 =?us-ascii?Q?JBPrz/mT/U+vwFYhdK/vJ5njLX30CxQCqc0cCVkVpsCLdBSv1dV0IKC0qPBI?=
 =?us-ascii?Q?eLKgL/Nmyp5OYZJjeKeK8xkYO5SL6qlwW1GgnJXaRE0ctot1WizzqfRZpXhX?=
 =?us-ascii?Q?KfuujoCe+Aaf97Ul1sItJi003WjpmQLNxmmXEV/ThYzUJm2A96E55qwR1Krv?=
 =?us-ascii?Q?d/5ZC6DapsufXdx2YBq6SQdBInndC97Q1vJUYGaOQUJ2wqiYe/hf9UfBlSw9?=
 =?us-ascii?Q?7TWX20/CkwFBgz8Nlmzh4ZTVpbR2Qfgmc/juhQvW+grwr3Q0Iv27S1Sc1NKb?=
 =?us-ascii?Q?WC+Pwchx4AjgeY8hZ6D7DwRRrK2sXJ15QmwKXAB9e1wZ+TXOeRi5X01iyd5Y?=
 =?us-ascii?Q?MuJmbfC77vP4SbCP/gjOcaOiW/NtQZ7ojg1EipW6EX2puIQpwfv8+Q4Ot4vC?=
 =?us-ascii?Q?m99c3CgCfZpT6KnodXUp2vjQdun3B8FWwG+AlMbHMvqVVCsmRmAQgTAgm7Ib?=
 =?us-ascii?Q?D3g7UPJqTN7mQlhKE4ZM0LJYkO8anSHZJRR8h92L7NsBh91qeflOnSQhdvzH?=
 =?us-ascii?Q?0uoSyXrxoivho+6ewdUargSUEsqR8kQygfdgvzONBWyK9BVcGDYA8A9KKmFy?=
 =?us-ascii?Q?uFLpuGXGcLIeoBaX49cxMXcO3xH/LnzjdW/bAtUC04m70PjtJkgpX4sOnraZ?=
 =?us-ascii?Q?7CbCXcrjiB2ro2YA1H4C3CV9YFS2sG+9mEGsOlw4MENnY8JU7UIPWdjIFyX/?=
 =?us-ascii?Q?pfcfIZIFDXVEArg7kuluqKjprEVdW7oL4PFFOWL6UpeVNvX3JrSqwh8Pr2He?=
 =?us-ascii?Q?UtIc1LA43iO7zI23zYy3BYcRFMzUDYh5nnJ4zT1dMxMovNuefWplBGpJf4nW?=
 =?us-ascii?Q?M2/maOs9OcXt8N89CDFPuRWon7aZ9M72Sya7ckEyXZWuID7DY9vsXGLl1lts?=
 =?us-ascii?Q?xdNCY6EpyhMo1wSdSIzKqXADFKFSsPFCxoI+eWa8muRkJ3l5H7qMGGDDNGIQ?=
 =?us-ascii?Q?PEoEf0qz4jIK3CcBqv4hwM1ykOzx3rSciPJJCGb0A7KPaEDUgktIcj5Y2FFt?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02052ef1-d4ce-4f97-8518-08db23cca701
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:10:08.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wZyj32Vox6LoD7iPYrR9JotOkpx8MHAgUa9aMLktMSy3dF7vNl4WXGnZBJHqetbuI1CdCEVG54Ioa6sZ3EkZrnAsB5HPx3nFSYYvlcmoik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9244
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 46 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..b913ca59b489
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips.
+  These chips are dual-radio chips supporting WiFi and Bluetooth.
+  The bluetooth works on standard H4 protocol over 4-wire UART.
+  The RTS and CTS lines are used during FW download.
+  To enable power save mode, the host asserts break signal
+  over UART-TX line to put the chip into power save state.
+  De-asserting break wakes-up the BT chip.
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

