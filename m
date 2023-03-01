Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737E06A7021
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCAPqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCAPqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:46:23 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2085.outbound.protection.outlook.com [40.107.241.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56872460B3;
        Wed,  1 Mar 2023 07:46:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dbn5giynSV8To1K0BY3yKRJe36STxIkA7OFHvTCD3EeS1QcDovhNxjjahZQQShR/LayZ1ANdYuunNaMcxmFK8Vw2sdHkHR4FrP5buEppsLJVhvewxRXwKDHJnqPXdFb/HO1C+IlPELFzbnEg3lvPSpI0Xc+n30wd3z6nUy1CjyYMkNS3hYA9F8TFWDZUmwty7FToWDDbVxS9WtwOj0fP0aX3VYA4gWT5WcnHMIu3YV8VZ2Uy5nZTGTijeDwIdqd+O2jwbvUYm29e46VfYGBA/vHiGotzcMu4aY0AcbCLy2yEQKv1Z6Y1Ponmsvjx9N8l73NjuoZVpkIMC4wHDArX0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=RJL+YfpCkSpp5sTqAPhr3Rbgre3KSa/vp8EJAgO852KZwcIqRM/GrzwLaXeiJOonEZi23fGL+eKw3ZPz6+urWY5edcl9AxFFWEMuI42zMYcHw/Q2Wm+llYmz/OKESoIvovLwUjcaGRMVFw6qZM2XKUkuDpqGPsvCoUo+8S/FTdZta675V71x1CWe9UVxkKmWuI2DSTfGQC7m7YfU51DkNhEUyAyKGXcOoNNLFrGaCkabpWc09OYFJkRmhzesL3LQj0r6Drg8rZ8AOTM2S6BTesgQ3ormceez3g7kzV0IruBtFdVWrlSPCtanixuxcfmCdavKj5+JMnSQ7SXVcEIDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=smihG96WVAWzmkv6idVW1rMEhq8Rj53RIT/bLPGk87ZjLif5Wzem1k7umCf4qxawC8uzuggZOX8mKBDd1OsbftnDlEDMXgpWdFz5VpSiBWBf3AgIhy6dlHgFCivV7eK5QZ1nJO1ar8k2UGfPCnMi0rH0Rp/osPnUPcAVSt2exxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB9129.eurprd04.prod.outlook.com (2603:10a6:10:2f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 15:46:04 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%4]) with mapi id 15.20.6156.017; Wed, 1 Mar 2023
 15:46:04 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v6 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Wed,  1 Mar 2023 21:15:13 +0530
Message-Id: <20230301154514.3292154-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB9129:EE_
X-MS-Office365-Filtering-Correlation-Id: e47b61f1-003e-4da0-9aad-08db1a6c108a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UP6+IhaM/2l5nZmcxfe9EmgaTVyEP/++7N4rero1IFS6oSLLboK2K2bI2q74Dq4E0hmsR2RfMfloImtNe3PujEWSvw733rbYCHEbZDXRQfGVwi9K4yTxsUQAH1dpoLGALkQvgmyp/bMtXRTLo6+7wdcATKlONKOJt4LjQ/YAV3IX+ptzmVrer1HjNLoAGLEkNFZXE6jrUmHRDXq//i8qSs5TPuo1sz6fasBWA6H5pIJtqbxM4/AQa8JNROYd4uk/XGKSCLJS3FtAG2E4VbvozPUQ5ManRD9rresjKMa8JyZa4MFjI4V6gv3KNnX/+JU7OfbhIASQlfCpIwn5c52pCSYrukU+fUctQYFepc6blobOj33s4093vcE+91IDtxQ/177sBDz7uESZMIRAxYJKkszauL0N8bzx1ZsjZIME2QNsZb2lFQjPDmmh4x+110b5yn33f9xAXLw66aduY5o386/SZNzAhVOVlYqo0Q1vGF4wO4pGQULnzatrX+Gk4lzxgKndbuN8DOPBnOfymD+s2CDI2u3Ur+qLtR9emI0G9GRTUGX4IEd4szHG7BUimCVteNm/VSODKzYdSfL+Gs6uQlSHHtFLDmIFSryATTNPkmf4mHGehccZegr+FTyO9l4zldA1yI3d8R/jevmYtYUSwy42PFe43hunoUMMOqjDsscpbf8tOgPom5SUZhWH7XfPE3xjVgqSFGQ2FIculWDXnFMvQzUtHku4llAbMITIyCRLqVkOaiRj4tF/KLo7Ld3Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199018)(38350700002)(38100700002)(921005)(41300700001)(86362001)(4326008)(8676002)(36756003)(2906002)(5660300002)(66476007)(8936002)(66946007)(66556008)(7416002)(52116002)(186003)(6506007)(1076003)(6512007)(83380400001)(2616005)(26005)(316002)(478600001)(6666004)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+eCD74q0KDkAVq8fBC1qZgI0+0+b61ReiuX9cWCBS/Q1nX0nQR0wXdREamFX?=
 =?us-ascii?Q?1MltVTivfb44vxeZi7gEV7TrqL/+zuyF0SXh/KgEs1AVJS+xRhY4NxVLYnbE?=
 =?us-ascii?Q?WbunDZjgJaN5bkAfYrm/AFeBPsUFEqMe4fhf0Jle8Qt61JOvaLwi2QKO0kPy?=
 =?us-ascii?Q?gGxby8+mzdfJwihbtELNuyleE4E7qwfDFjG5GUlnLgKDCQW26ZknfI93ZBKB?=
 =?us-ascii?Q?OWAsYSz/2euMiH1Q3F8+OOtZaCG0WsI68v0KE8UjSQUiVVQxVgGZGDmg5y7Q?=
 =?us-ascii?Q?AHn9LK013HqJLNWkatAFrVMomO/OamRcS/In26xlIsAJ2Cmz4vCtle2Zr01K?=
 =?us-ascii?Q?zhpsyIc3wjpo76WHPlwQHsapiabsWJ+RMaX1PasJ1iw7f6TIX8UyySEQ721w?=
 =?us-ascii?Q?BuIlF7rPc7Q+CdiCd5bLaZM+Nk7bd/ii6XLCaOWi3bj3GOkMf1CD75kpdtKN?=
 =?us-ascii?Q?FE2c8BxFN8ZkkrrnWF6JBKJ+ScN0jXMsk+WpUR3kgg8guc7nHmHlUVxyzxtb?=
 =?us-ascii?Q?tfgXGvPs+v74EId3ES1Zl2ugoqZD9AUub42AhaBlmgfq8F8Hggm8M7BPyS3Q?=
 =?us-ascii?Q?WYRKUFjcWR3JepjZoEgJLfYGvC1kngi7tCtHwFWQOJuDmmQ8YuvBXCurH4L+?=
 =?us-ascii?Q?m6nODcuuBAciPxfYIF42rPbtgGkrtfFz6tHL3hs+G9LSCXJIeeAmqihVnH4j?=
 =?us-ascii?Q?cWgHVipYnGrVZ4pQ0edNz5azNGTHjsfaQ/5gsyiZiwzi28P8//+4CwdzSwnm?=
 =?us-ascii?Q?7O//oze/3cGZw9UW3kmy528Nhwlg3WpjmUOKPMuvVC4xRz8fomI5X5duBLeJ?=
 =?us-ascii?Q?UGaSzXLRvKCCtsajqk74WwnjEmUA4pdTYW4widRMIUP7/gbEsaAh995f07GO?=
 =?us-ascii?Q?wOTmcm4kGBFk7e7do3cHKYiV0os4LnfRJpLtCeeDasZcI0PhTmKTLSk7emg3?=
 =?us-ascii?Q?fc5Z65yklIMxInqNe1KeZTewMQG1q+o//vMBEW5H8qcvwDohBBgzwIFweOm2?=
 =?us-ascii?Q?k/1O7cOgEt1Wb2kPHMSve/mJnjSozli9o5G7Q2Rl1I9b2pSzocGnwzczuBgo?=
 =?us-ascii?Q?RvrVC9RwJ+99+JfGkQOR+ZLJEaDYjHPp8qu9dTvitFtooBvqTxAUOjtvrC/0?=
 =?us-ascii?Q?xkq/BtNumNrLdNPSeFhspYX/v5cnGQPOdLGnFrvYYfWlcSZZ5+X5viG0aZWB?=
 =?us-ascii?Q?iowpxpfzeaA+V52Rzd7W53TigxA/gJiW/5acGTxv5FBOZSAhwD/2Lv+7Jngj?=
 =?us-ascii?Q?iUb8hgmIurcjGmzmjQQpCjdq3y/xauD1CM3YbGhioIYctcnGiLxaG6gr/Azh?=
 =?us-ascii?Q?Z5I04i6JYNMY6mvesf6dX5PLpGhTYM4W6sA4ahLvUT/tiF+tLxHxK/ebqBF2?=
 =?us-ascii?Q?kFivXbn5S6nB8kLJ/ZGjOZ8lvEJefsZB8DB2KakAaTPRVrnYPrwSRnobwMqf?=
 =?us-ascii?Q?QqOwMVHrbBTToQI7dlXhSPhzlEtDGZiBXvo11t2OGiG5brQVHno2pu4KJ1ZQ?=
 =?us-ascii?Q?EtOTi4cSVpiJO13mbyHkqVesFybkrC0mfSdLee70BLmUmDJUbQ/AsuXSBkfd?=
 =?us-ascii?Q?MMstUw8g1m/FmnO7FWut4d3zIO53jOZaYjv3G0XK2XBqnWHx8VEnDK8BsY+w?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47b61f1-003e-4da0-9aad-08db1a6c108a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 15:46:04.3584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wq9A1bS90YL4rcjEknZ5y+NiC+JSkysjR2WjgJb34Shxbp+UWFdEOt3yG3LA8e27xBXnBiVM2fK251jkA2CgLoH3kbTd2afQsgizu6tkEi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9129
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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

