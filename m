Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB166AFE91
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCHFog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCHFod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:44:33 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3C49F227;
        Tue,  7 Mar 2023 21:44:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SV+XREi2HeYrvBoN9IZCltqf9OG2Z8KqoW9PrWDTdfZQZcXy6+CLkzCa8qBtgEQOjjTkfCb14Hn5xfMG+EXE1vaxl0fLHusCfPefVYiV9oALCRlv45JsiF+Dwf6COgfy39SsskiYv24RSYrame0hCThk1LdUTotlgIordt6y/Xfuc8y/Hje97FJM/zspv9ABZymXKS0YvmmtNdknazKYQVFlduheNQloeFwqxxrqQlZntbkjMpIPstOeEDUe8X9eIR3o2SiTh9Gjj5eHquSsCiVQQoT58NI7c4/OMOGzgEfJvaSE57Wom6bpDf2Z1i9ab4s2BJ1hM9fPHYSBvJyuLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGQcNIIDk5kKNbMPKH2f/sBrlxLPh0Ggwde5vqsbiEI=;
 b=Nm7NXF8zQwdmLeArChUKML5LtMgncyW5eiSgXS8BR0rat9yQBZ8K9ixbHteh7S8RA4BsgUdhfvymedpyTG9vHK3qxDxEumStk37kk4sD9ekW6ZT5r8/sT1UyqKlfnlfmhvwlM65DbfBRJPRywhIIU0+kD4iEdNYrhk02EZFRHC9nMJQFfN6t9Kak+eG37GVb49sADGJo7U3HFIt8Lfx3xP/h1pKdpp5EMyJ2lpeVp0EDmuVuMKC1r2WRf8qjCBzdislF3u1SNTi5bAcVAwh0eLl1aH2BkRKd7W2pzHiCK648eHAxd3RsBWhJWrovzYyjckN4WUSK6BC6GFWHJgZ6ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGQcNIIDk5kKNbMPKH2f/sBrlxLPh0Ggwde5vqsbiEI=;
 b=RI4yxdKeFDyYMhKRbf414Q2147afAC0fO1vG/2MC3uBJTFxWoflhWxW0oLzx3FZX4ZLe0sqD2p8ZTbnGvoZ0ANjIqDiDsq6hzp5a7gp0TRvGjk2jssPrv4zP5tHkYeEYIKIw9wfhysO9tj/Ol99gkSYir3mJ0oarzQJPWYRFtSo=
Received: from CY5PR15CA0027.namprd15.prod.outlook.com (2603:10b6:930:14::20)
 by PH7PR12MB6739.namprd12.prod.outlook.com (2603:10b6:510:1aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Wed, 8 Mar
 2023 05:44:23 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:14:cafe::f5) by CY5PR15CA0027.outlook.office365.com
 (2603:10b6:930:14::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:44:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.12 via Frontend Transport; Wed, 8 Mar 2023 05:44:23 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:44:17 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 21:44:17 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 7 Mar 2023 23:44:13 -0600
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <richardcochran@gmail.com>
CC:     <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yangbo.lu@nxp.com>, <radhey.shyam.pandey@amd.com>,
        <anirudha.sarangi@amd.com>, <harini.katakam@amd.com>,
        <sarath.babu.naidu.gaddam@amd.com>, <git@amd.com>
Subject: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add ptp-hardware-clock
Date:   Wed, 8 Mar 2023 11:14:08 +0530
Message-ID: <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|PH7PR12MB6739:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b8c057c-7c21-4fc3-a9ca-08db1f982bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEbxfh197mGa8ASh0SbzjshfluM+jzvOm/fyIZmmosJc6CPLeWYOTTEsKU2Nu7Tnx3aNnIgJ3Izinwd/70hItcQDHPOy61gBvY1f2Fu6SEp9rXJ76naoCOnP/ZKl/cDZD6sxpYlIErGub2bZFQaUiXjmfjOWx4kU8WAC6LdyDezZzUOMnF/N+18a3PuDiGtdd6SkC0Ya3PEQhRaPmWIi9GYLNSkqP3+xr1V4pTfUUYPhofg9P7l/ftYvpIXbo8VkP1sKC4Ab0C/V/fCDpfw7/mD+vvxFlrgJQbmNQH+J7+aOR9dtCSnJjlp58VGr5eVLJ0OBpZyOkq/gQn1rEaGQgSrt5DkhcbsULWhLcn8Udzc9MWZm5qEw21KhEVOMPFjcUtvN68pkVkJ1qgv6LLCdKrpBDIk8FhCDmHSXyjHAhFLyAbYtY2cDQH/nwC6kGy/4KbiQjSsOoTuey6BDJzMIx53sJEYwSBBZxN/ePZCKeFA7u+uS1Z4CtXBxDoCMqH2HYREnaQUS6vS4VMSBnUCYvSmb6gAer3/5lUsqSz/iX1sOf9q0Q7vUyxmN5zn2CQ73bYSpWrleVtOiMmpHNbKlmuPwDzO2hZkwieH1g2I8OSSzFwaPVS0AyMhX3c0qG5mgclfrkFaOfJCiC/QBvI0qJgCUxLNuS6uT+DtOXXSWmPAJ66ojnvhqJoGXvdLAALYaBm0xBhXn5u+3xvY3hkGD6kipvulIoktl+uOE6RQvlGI9y4NxHcvTIrjOuDytFIhoMRQxzAy7rzeFVElnSk0zs6mAwLkm4hXAo54UDKp706I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(40480700001)(40460700003)(966005)(186003)(336012)(6666004)(26005)(83380400001)(103116003)(82310400005)(426003)(47076005)(41300700001)(86362001)(70586007)(70206006)(4326008)(8676002)(110136005)(54906003)(316002)(2616005)(478600001)(1076003)(7416002)(356005)(81166007)(36756003)(36860700001)(5660300002)(82740400003)(8936002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:44:23.1736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8c057c-7c21-4fc3-a9ca-08db1f982bc6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently no standard property to pass PTP device index
information to ethernet driver when they are independent.

ptp-hardware-clock property will contain phandle to PTP clock node.

Its a generic (optional) property name to link to PTP phandle to
Ethernet node. Any future or current ethernet drivers that need
a reference to the PHC used on their system can simply use this
generic property name instead of using custom property
implementation in their device tree nodes."

Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---

Freescale driver currently has this implementation but it will be
good to agree on a generic (optional) property name to link to PTP
phandle to Ethernet node. In future or any current ethernet driver
wants to use this method of reading the PHC index,they can simply use
this generic name and point their own PTP clock node, instead of
creating separate property names in each ethernet driver DT node.

axiethernet driver uses this method when PTP support is integrated.

Example:
    fman0: fman@1a00000 {
        ptp-hardware-clock = <&ptp_timer0>;
    }

    ptp_timer0: ptp-timer@1afe000 {
        compatible = "fsl,fman-ptp-timer";
        reg = <0x0 0x1afe000 0x0 0x1000>;
    }

DT information:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi#n23

Freescale driver:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n407

Changes in V3:
1) Updated commit description.
2) Add Acked-by: Richard Cochran.

Changes in V2:
1) Changed the ptimer-handle to ptp-hardware-clock based on
   Richard Cochran's comment.
2) Updated commit description.
---
 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..a97ab25b07a5 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -161,6 +161,11 @@ properties:
       - auto
       - in-band-status
 
+  ptp-hardware-clock:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Specifies a reference to a node representing a IEEE1588 timer.
+
   fixed-link:
     oneOf:
       - $ref: /schemas/types.yaml#/definitions/uint32-array
-- 
2.25.1

