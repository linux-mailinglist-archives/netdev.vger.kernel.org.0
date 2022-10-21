Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAA606F88
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJUFlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJUFlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:41:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F301D93D6;
        Thu, 20 Oct 2022 22:41:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ka8Sw/8IKbm4rh9oWThw073MU+kSbXMud3JAypGZM8k2+Qgj9JAdw/kQtFxUz2AzMD80lZRCHk9jr+9ltAOvTxcmNmbZQTh+m+YVte9tOMkifyhDMrhgrSu4S1Bi5EQm18QqLLAISio2ptcXD6jQASaPyRHmQFrdp1cQabxpZOYxV0h0QvBKCJBTKzQm16mewCrc46sU7+WYFLEZhU6CgIwty26Hux3R4juNMIdS0gn8DWO5LCPyqQhdnPojonXmCOXrddRXhDPXD0Bp1p1H6PFCKbarCrlnU2jfzCdNethTMKDd8oj+JJOAGmtL7G1WGQ4WQMweIT9owL9fvC3QIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0cYYs1TKbLRxbPxeCGvBUp8VK5ipygXGkgTebj9Oro=;
 b=G3TbGcHnpByiws0+TXw8F9ZnJ9EMEaG25Q/DseZ2OvcvLHMiCXRnavoFk8F+pMCqJG6lt9WTwxuKNIZHtLbmc1edboYi80dlfZM6QmhYJbSvIWSrUG6WFP+EFQnUnhNX71SGixm3zx5uk4IrqsrnJZWanSK2Y+SckiL7bCC7CNzhCUf7rElfep6OGw4Rl2yJ5xOYuGO6TsHXEJ8CvR2i6VFMO1854kqEAUERpfdZfYM/5XEJuqDJ7fCq56TZerAID8+RFv6Ps10ftvPH8YTyyVtsWew+uRX0mFuhYglThLLiCRw0gqAATYiEmriy1IPqX+h61vJJ3R9NtT//vBTevw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0cYYs1TKbLRxbPxeCGvBUp8VK5ipygXGkgTebj9Oro=;
 b=p+XxgQwacbdSZydXuTormEERfySTE/TSVfmQFEZhX1CW9DmikHS6DRGquMUsKUMr8JLzuEVzqHtl8B8BNqjqkZlN7jxJoEn1Fber2JzTl9GbbCsQ9U4O+YTN0ttJin0VCaO6/ReWKTv8ok11vR8f1Y8OPSWIs+L6UaLaHQhrQZ0=
Received: from DS7PR06CA0041.namprd06.prod.outlook.com (2603:10b6:8:54::10) by
 SN7PR12MB7369.namprd12.prod.outlook.com (2603:10b6:806:298::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 21 Oct
 2022 05:41:17 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::45) by DS7PR06CA0041.outlook.office365.com
 (2603:10b6:8:54::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Fri, 21 Oct 2022 05:41:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Fri, 21 Oct 2022 05:41:16 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 00:41:15 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Fri, 21 Oct 2022 00:41:11 -0500
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <richardcochran@gmail.com>
CC:     <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yangbo.lu@nxp.com>, <radhey.shyam.pandey@amd.com>,
        <anirudha.sarangi@amd.com>, <harini.katakam@amd.com>,
        <sarath.babu.naidu.gaddam@amd.com>, <git@amd.com>
Subject: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add ptp-hardware-clock
Date:   Thu, 20 Oct 2022 23:41:10 -0600
Message-ID: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT092:EE_|SN7PR12MB7369:EE_
X-MS-Office365-Filtering-Correlation-Id: 7237ce4c-209e-4b0b-1696-08dab326df9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdBJ5MiS+5YvnplbRD/tsVsJEP9p5crNmPyVxb79zvri7gIW/ODzDGd3TkEXnbSPV8sXL+KktX184B6VL9JOH1N/QOdZG02vt22JZ3YqB5YPSFnFYAhDGHXzH/sergOEg8II0eIAYdCfqc0LBztDiOjdBQ7IIkODzlSVHAaWGmDbknxNr+8txXs9bii6Hnzbb+fFgKmq52VealfsJPlzE3+pWW3kOX4vVdCBV19uIy87IMlaRTJ4cUqi7kOyVAPknLlY0Vz7cBNhkpc0adhQjGVM9+CGnCgOpevaRAdJH4pOJfE9/FrkCcIJdSzx0s+HxdaPDFb081/dgT44ck8RW1yvol5CHZ1ev2nbP3481Vt+zhJPM4nyZJL/i/eFx+elOYifrshSSPWIK1/RuSaKl61yBXQsLUDtH4xyxCK1qgn6iHXy1eQeKTOJ0nNSmb7no2G5Qg8s561kBubFBmfFiR8uRsWUf7qiBwOFmp7cPzGUyTjEnEGe5E8Y5GSUXPH7/XHhV5EMacN9R1nvAQ0ntiwSpF51hsB4esnOmJAvL7HMoO4iK8iQYBoHF7tlxHMLmjab+ZMQRMttV75LDTTDoOyi4P6p1a3PRCs8zg/ts5pM66Z3bRPGooxVP5i5GqCv8nZGb01xlUT9utYFOj1tz6Q+FfkIlCFbdZYkuUCugA70lYfc6M0EBSTCYTpJ38qjeAmAabsx1TCYe9nCrbx9oaW4p8AQFjiK5ecNceR0XLp2PclAsswNkWT9DO98avroEluGb4iBa7SDGw8jlgDL4OVwhaNVRu+Pek9gODe5g+U6fjtv2C3EH0a0OZVusDGnT7i6HxCbgJWSkYF9Xy8xzmlos/zo2v09WNUuTGOWYyE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(186003)(2616005)(1076003)(426003)(36860700001)(316002)(47076005)(336012)(26005)(40460700003)(83380400001)(2906002)(7416002)(40480700001)(5660300002)(8936002)(110136005)(478600001)(41300700001)(82310400005)(54906003)(70206006)(8676002)(70586007)(4326008)(966005)(103116003)(36756003)(86362001)(356005)(81166007)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 05:41:16.7177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7237ce4c-209e-4b0b-1696-08dab326df9b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7369
X-Spam-Status: No, score=0.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently no standard property to pass PTP device index
information to ethernet driver when they are independent.

ptp-hardware-clock property will contain phandle to PTP clock node.

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

Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
We want binding to be reviewed/accepted and then make changes in freescale
binding documentation to use this generic binding.

DT information:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi#n23

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/Documentation/devicetree/bindings/net/fsl-fman.txt#n320

Freescale driver:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n467

Changes in V2:
1) Changed the ptimer-handle to ptp-hardware-clock based on
   Richard Cochran's comment.
2) Updated commit description.
---
 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 3aef506fa158..d2863c1dd585 100644
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

