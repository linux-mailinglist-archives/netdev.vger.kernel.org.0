Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB68B1C0AF1
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgD3XWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:22:33 -0400
Received: from mail-vi1eur05on2127.outbound.protection.outlook.com ([40.107.21.127]:1217
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbgD3XWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 19:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq5WsBwspOrBg3cAyLSGsnmVS9LyyygAYawy9MYEFLz//E7/qChtpqfeMRFncZXnnRl7h+U3LQEfmm1rHh+xbToffyJG+MblKTJ69/13wIy4A2Iw30Izj07fpH+UdpnvAHs2hAJRnPDDHaV+BylJKDxj78qmfJ80ubZlDoH4D2hPWWJ7zURjfGmDaVq93Vj8djjA9OCEdTz/KJ6sSvK32cxaKh6Knh2Miv/rS1cKuQUFtsLWfKM7tW/lW/mUwX9WX4cSit27w0zy5Y33MRtPdh45oa2ATf1+++kktsSwoIDIxk575p/cT9z5z56nC80NJR/pETXBUXIJD3a0E3p8uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuBFAU4Hzx9GDkUUszi9EK7bt//MRDeG6L/n63Z4ZBI=;
 b=CdNoA9ea/S/D9BaGvZ7kKeS/a6JUOuWfCgUzbco7pGYJIZHqXAch0mKsSi5kbCDsGcnuU9SlKOi848tUNCVaSVXdhsVGKehDjEvM6KWkr2IxpM+j+QKOWkkystu398EWK9izhqsjQgeYbFd9IXsXYkwUchlRPmPq4rMumKYMqi3shjinlc7b3MXizR4ceBBv8OCbtrou7iCmC9Um8h9rlTtZdMSwHYprPAiRHIFV2h+KYD9MW87Suo4UgGAARqi6rdR69I7J27vdGuKzlBNfdoVQcr5Z5iUBLR5QRAorCg+TMcHndZiQzx8P6cdOjsmNZYdlGO8r/LclzdOj/6AGJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuBFAU4Hzx9GDkUUszi9EK7bt//MRDeG6L/n63Z4ZBI=;
 b=QfFu6mOJr2PwXoGXTlV06UwW/GIVXplP/1JVwBbLmu/wNM7LYhqzST8IeRfqCgknMlzLf//kTgvNQpadhQhmgltZ7YDaUSwSCX0gVoFx+ohflVVNWRey0AYRq+/XneLtu7UrCqdclhansHH3AkjrA9TFZaC0XCt7ga7+ZtAMAs4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from DB6P190MB0390.EURP190.PROD.OUTLOOK.COM (10.175.242.25) by
 DB6P190MB0471.EURP190.PROD.OUTLOOK.COM (10.165.186.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Thu, 30 Apr 2020 23:21:26 +0000
Received: from DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 ([fe80::c59e:e6ed:2bec:94a6]) by DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 ([fe80::c59e:e6ed:2bec:94a6%6]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 23:21:25 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: [RFC next-next v2 5/5] dt-bindings: marvell,prestera: Add address mapping for Prestera Switchdev PCIe driver
Date:   Fri,  1 May 2020 02:20:52 +0300
Message-Id: <20200430232052.9016-6-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430232052.9016-1-vadym.kochan@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0036.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::49) To DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P192CA0036.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 23:21:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59641546-33a5-4ae9-43e6-08d7ed5d33f5
X-MS-TrafficTypeDiagnostic: DB6P190MB0471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0471C76093480EA932EFFB3C95AA0@DB6P190MB0471.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w8gPCM5QwGz0m+Vv+Jqk9VrZ2qQFuG9afdswdpwd/717WqNNOAUPD6ytVRVPMA4rikVAYiMbg/83uTRLlw+q4H2MgrXl6emwZ9offXy0EkwXC12PzohIEW5GHElskXlvAVoPdgO1xczAPRE00XJoILxUElBb6eQdkZoawzLT35bYp5yfYMHpvFrhdc0B23Mitp6S+z1YfeUG0yhmFjTl/4AGQqcvuTmdW14bvUKCmkeuaAZjWgKChBa42RHO/3VrhoH9reKGKdXnFlxnknHzuXO7SfK0m0vE760YiiAitf3C226vkCAnDJyI+ykq5ph11BYNKihomDMMxwhmR9rcsZLYEAsRh+hECZP+T9argO3HLE886pA86Y1Yheudgp9YJ9s04pO2lR+Qb9CrXsYNPlqgi7Wwj+cSFa80E4fHGedue+5HBWhETodtXYcVJf10MgCuAsuDyn03qqMg1W5UgR9Uf7VG7lC6wRb5O2ZqSGvxixXgyPj+wSFmygKdHJVc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0390.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(6512007)(44832011)(54906003)(316002)(6666004)(2906002)(956004)(2616005)(508600001)(4326008)(66476007)(66556008)(66946007)(86362001)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(8676002)(52116002)(1076003)(6916009)(5660300002)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zT6b8DMlg3EHR+AZd6iZWFhdULIZOtxm3PpIGLIgLkbI1uBxTfMWMgZgUed2LAi+tl96+Qr4Kw8o2wgXZJ4Ri63H+6ZTlrwPqjnNukmPQYKLhqRt5irDQIQelPwYozRPrWaQN2TBvy9qFPR0ZQmJfmF9bQkGCSy15De4z3KdNPZjeN1r1eDLAOduITqv2Lc1xJAoQEIy0Td0ccK9A5eKompR2K34cx1dCih5DYuO7Q+MqE0iVuTGvuyysfR5M8qN42waZLhA+OxrUDI0PXiYjNrJhvjEsJqENpKdaM4fIQaPEeTK8kPGwYrUkqM0jR9nMW+UFNaVbN2QDuDp9pHZ0xiAH4SfyICGDiGrvpyTiO8c5c5j6yyJTVAYBaa2foI7Pbx4n/RHyJIZOzR0PqWB4xbNuzEeTUBtXgdk5W8j6tRPmoMIY3rWRTv6sPv2pcu5WXPRGkKnD4E1ikQUP6PTrH/0TqxqZtUhmM/OrTOesAP5PDHjX8cjVCStd/brJHR6kHUsGAFKz6g7KwwF8SSWkKBgCtn05HYGaTfay9dUnW0P4gzujiCtz2mrY9R0TkaE3Vg3Q2sqr8X5mQUzRcq9ZaO97aFqoNGqMH7y8EHPU5QDAlN1iw14cl8ICZAVN75crURCT+rF1ELEYbjtcwAeMaSy7B6tnBOftpU0vaFnThsJhNS1Apm4BkAz+K79GPIsx4gv/D8wapCc/lKRPzZtFXUaq0Fb9Yv9jKFxWoTF8WjxKuAFY2l8EnMQllg54JWbsGB2hDfOMilvTcsNOe3XQb9Fqij+BTQNMGjYtcNVHhs=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 59641546-33a5-4ae9-43e6-08d7ed5d33f5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 23:21:25.7696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoxGbjbgAXOaEesFHVz0W9/3fBg2cPhzkBXgqccH8XVHGSx5c5bQmqpycJGIxbC/yeDWuhvUk7CZoqfxGzIjxQmtlSHNuDouJNo4NXjcdqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document requirement for the PCI port which is connected to the ASIC, to
allow access to the firmware related registers.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../devicetree/bindings/net/marvell,prestera.txt    | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
index 83370ebf5b89..103c35cfa8a7 100644
--- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
@@ -45,3 +45,16 @@ dfx-server {
 	ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
 	reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
 };
+
+Marvell Prestera SwitchDev bindings
+-----------------------------------
+The current implementation of Prestera Switchdev PCI interface driver requires
+that BAR2 is assigned to 0xf6000000 as base address from the PCI IO range:
+
+&cp0_pcie0 {
+	ranges = <0x81000000 0x0 0xfb000000 0x0 0xfb000000 0x0 0xf0000
+		0x82000000 0x0 0xf6000000 0x0 0xf6000000 0x0 0x2000000
+		0x82000000 0x0 0xf9000000 0x0 0xf9000000 0x0 0x100000>;
+	phys = <&cp0_comphy0 0>;
+	status = "okay";
+};
-- 
2.17.1

