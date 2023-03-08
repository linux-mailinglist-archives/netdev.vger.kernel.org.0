Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697F46AFE8E
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCHFoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCHFoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:44:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE3D9CFDE;
        Tue,  7 Mar 2023 21:44:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BroijTHfJ2xDfTbeSp44UPGuBhyJnNCcEiPz+chb9X7h8fI8KcsOmjzuwLRi42YsRxYX+c8eR5OWM1F9R7DlKbhq5V9ZTvRNY5b4of9jSxxL+Oi7ifhsBpTVkihVzjcxnDHgmbDjYeG594hb0Js8U0R5XPWMLv1mqx1DDLdBTFLAlrQr75F2ke1FKsEPJbJ3d9IKK9wLY/vhT5L8T9kmK5f16TF1TcgQgEwHcmMNxE86e6MpLSwQTCNxLXEB+bcD4cpOkacIMhKOgZLu9fE/zFs//DUiDNnPLR8RJrVcqCbNecz6ZgIj07mPvlnvj0rS1KR+wavhEfyqNk0Ztzwlbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGQcNIIDk5kKNbMPKH2f/sBrlxLPh0Ggwde5vqsbiEI=;
 b=VUa5lOWYaJsMfEBuzj/ObQmaYS9bTIjm74ZNri69nLsyp4Vkroqfd+SI0n7tk1Or+jPmrf6QUiGnDyHJpCleRfckpLVnX7v6O7xIOYHV9h98hMxLqvVSAovvrFgRWhrz127zgYC+lLUbP+Z+hAujpqvuDisfiRkQHuNgNiddwATfY7VdLLSh8hMTmcKLcVGAvvXB9gZUXexCrz9PmPJ/UIccCV21BwCk+VeGvTff/82Kfb+6oBJ7jsV1MmS+Cx9RKiMtB72Nqyu5HYOrMTjit685WA4w/baxlN+eD7K+JLGeQoQd70PJjVnpE/a5Hti4xklc/IRJP6GIHRylWyAImQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGQcNIIDk5kKNbMPKH2f/sBrlxLPh0Ggwde5vqsbiEI=;
 b=OQ9QyFNnjTPeZVIqcbqLqN7fMU1UurKkCD3tCQvKnZ50vwb7itzSvMf6/Wdk/9xNfdhK4sNlMcsIjJi5qSy4oJMofxN+zapd2R/6CiQ49c+nU5ZBrXrsLeu8rmTgsFR07C/fcpvrju5gB4Dbox9UZey8ZwiIrlGTdbvOB6loq/M=
Received: from CY5PR15CA0030.namprd15.prod.outlook.com (2603:10b6:930:14::28)
 by CO6PR12MB5425.namprd12.prod.outlook.com (2603:10b6:303:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 05:44:15 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:14:cafe::c2) by CY5PR15CA0030.outlook.office365.com
 (2603:10b6:930:14::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:44:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.12 via Frontend Transport; Wed, 8 Mar 2023 05:44:14 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:44:13 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 21:44:12 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 7 Mar 2023 23:44:08 -0600
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
Date:   Wed, 8 Mar 2023 11:14:07 +0530
Message-ID: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|CO6PR12MB5425:EE_
X-MS-Office365-Filtering-Correlation-Id: b0e75bbd-fb68-4d97-da09-08db1f982691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfI2VxHALt7Jr4YzWEfXCaWLTs0fSZkvI+krqqGDZRat9ui/9/W1ZYriEPz/GEjKWRJXpv7A0TYKYCxZvG9hJObjX72UA89Ipb6XpYBhQ0EQNDX/GrvOsRcbNXH6lg4pj/tET19nd+/v/i8D5fMfkfhLMIEpPUDA3SSzyfQMdHMjyEBPMKkkmUY38esxkyOv4WEoYTNMFUx0B+CWEBdbAbAWpgoc80LQI18RtBExGM50DbgFQYUDUuS2/aHV52ScFkCe6GkpDyOft+oxOgM7CZu9KWmGBdnBcZ1vfXyjKaihR2I4DscOr3J8gBIJRdx9TxRzo+XHhFqCV63f5cbRUVzhwuuCLMzgdZjaDoyOUC52uBG9CnkvTKFjlz4LvdEoIoRfyszlNzsmCGB//vxn0r2DJp12EXmEczUANg6exR204RMQH4zIYW37+L0Z+ZKBYc6+pY0Vd5zrpM9C++dyRuqttLYH0TZ2bJ5NXKMc3lcQ/pRKtnCG4lZBHsjbnbt6BRpD24w0egMEtcSSCr04zaeybERhdjSUZWITlUwSEN+kN8fGsBKycDxHrqTvwdEfMMch70UOZBH/inKzowl5UkzTIS9Y64gDNQoV1Gvl19Uc/NUS8Jbl60oJ9ArxRoJ0/MoktOTvzQnu4qsAzKla1QhE/59kL7I1e3exGzA7YiFC1LMil49k4YdwYl7hr2rFqvhiQxh2rlHhGW6e+sEU7hrhwOBK2zyS4WnIpI1HbyVk05lcqE/Zs7XUyjyfQPOk/cxlnAZXE6qd77MQ6fWDmZI31lcMsbZ0+iQZn0Db1GA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(82740400003)(36860700001)(81166007)(86362001)(103116003)(36756003)(356005)(8676002)(7416002)(5660300002)(70206006)(2906002)(4326008)(8936002)(41300700001)(70586007)(82310400005)(47076005)(40460700003)(186003)(336012)(26005)(2616005)(40480700001)(83380400001)(426003)(110136005)(54906003)(316002)(478600001)(966005)(1076003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:44:14.4546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e75bbd-fb68-4d97-da09-08db1f982691
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5425
X-Spam-Status: No, score=-0.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

