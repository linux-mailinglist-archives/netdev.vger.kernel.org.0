Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D1D1E079C
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389048AbgEYHOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:14:43 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:1606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388982AbgEYHOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 03:14:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joBhlShxOTAxFbjfDkbgtmwUbnZ5kMR9Wq9jrXnBrscqb1nxJfjlugUiep37hrQuxa2vxuEOb8GwgT0fhNe4sqytqeydqUaD2xo7FJlp2eNvZi2uO5kAiYgrIsQaWxk3VDvR+IGI0zjJOT4JvK7Z6YrSdCX87HHx6B0hI42ZbQy76aXZYrEjrxvty6TCvUhLFkv/ipZUapDU4V6BbW9Ofx/1GhYPD9jWXD+V9p8nKAW0NBbcjY6CmOzm7CqrH+YgSG1HOww9SokuOj0K10kmOX799JUnr9A1oRwe0C94TcQuPhG46wG+WG9xNrmvFGFLLRASn+XcezlSor0baJkEyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtRG06/tr9Gm/ftlPuSkcBfygPlrCYB5w/SQXiqqrF4=;
 b=lwmGEyLMu7X3u4/yNfkKrq62zdkTje5BCHbdE5antvyXCxTjDgrcCkxvd4rqG4doDQUeLUFjtYSLhCrmcB34gobcO8UXC679h5tCt9gNPiWZ4Ye3t98dHpxEvlgkF/9amqmrgX/Gio+hh7nnlECFS3WtgldOs5W1GfZYXDx0uXM6+IokGnDpgsaY20btaMfoX/b02mXL9BO6kZIQ7BfHEHpwUhDGJ5HqpmTRY2jekvpWarMIGVx8R4BhV0bDwwxO4VHsrk+drLcN6WHRdHewFbzq3rb3iJgSvqwGXUvkeHfnYRCPya9TwzmOc0RKECxBXvS1IIxQHerxyxaeb3kWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtRG06/tr9Gm/ftlPuSkcBfygPlrCYB5w/SQXiqqrF4=;
 b=ZpRvI9q0DlRoiNTBvL+wDjiqDC+gfvY0E5sipulWiXh+trQz3/TqZvkV1xKh9tUFtJ4WH4qDd3SwnPM1aS1YmGfe++3n7bez/lpwy/5B4FL6Whlq0pvaQLaljunwY7miAiVw7ZZr+d8Axzjrbqv9cfeKHd4VfmszQIcA81F06qM=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3735.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 07:14:28 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 07:14:28 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v2 4/4] ARM: dts: imx6qdl-sabresd: enable fec wake-on-lan
Date:   Mon, 25 May 2020 15:09:29 +0800
Message-Id: <1590390569-4394-5-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0213.apcprd06.prod.outlook.com (2603:1096:4:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 07:14:25 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ec199774-6c95-4420-9283-08d8007b4317
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3735CC68A1A9DACA91AC06E5FFB30@AM6PR0402MB3735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PBDQyctRxZun2HhOnurB9+QT2tHvai9L4zVFzPCnpqNoiGBRvwCeTLRn8DQymzrvF19iQ591FP5Vp2l20vSvicugV77B/S/8gwxqqdcmIMevcs2cKNu/UsMkzaz596OYSdVphqAwoHFMZPDjrt9nGESTGoiPXK0GoM4XMuQXDvHX07PG00BfJxnb2Sjsg+CHqzaE3wdgZ0SkFXGTFFSmhzwI2ceLrdneZ52NCyJt7Qtu2ZaqAAGlGuBHiZ/Yw0hAZo9KAyv9Rc18P+Ad3SqYyaNM15bgLbgGt5b38Vt7f4zE3ONAqGlEhwM9JHnvae/9LvZ57dwmQ4qIbEF96LhZd+1kWmXhoxB9GW3Y9O8DFbXK4F8c5MQVZmN353KOlCfd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(956004)(2616005)(66476007)(52116002)(6506007)(66556008)(66946007)(86362001)(36756003)(26005)(5660300002)(6486002)(16526019)(186003)(6512007)(2906002)(8676002)(4744005)(9686003)(478600001)(8936002)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JhRNutu10hPkNuGe+heM3dPkucUVHfpAT0pKFAsFFUahSZXAQ4sMXusSwlBLfwvz6bXtRH2d1XMnQykYvuN9XY0Rm+cwtByGvx7XNhFx2ia2llEfuroqdVBSyA8HZ5nILfcB/X2N26q9PxtwYZHoWd1+NPY5WZSMOLg3GL/Y9mHP0zGO/+yf5y1rVuRuhiQ7LFDjPF9QFC/Zc5PLNNX3czVAkMF9SzBApU2UxAHcHi14Vne7i0o/dnoDjF7II6BhO72pnL7AWYtm/W8wmHHt5HqkYedNesc8wADwzSvMUwVxS3rxjFWH8v6mCpS6cy2CR3VNRNbSkxod0yM/qMzVPLDIHlzngRHjlS9ba1drrpMOYt9cFTGsOysWEPVlEnE/pWj6yIXWQyW+DIxDIRcoSQF36y7L8WTGmCxEy2iAc5WDr8uLVWsU033fhfK4+j6jCO7sYCNCc8yyegtKbeYtcTzde7c5DRHOBzdPGlA/PSdb/L4baI0zKvEmCscLnI+R
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec199774-6c95-4420-9283-08d8007b4317
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 07:14:28.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PD/4oIO9qpyqh54r9ogwcCQdLVP8MrzhLy9kAc9RH1UD9I+pMxBZguRG1qZytarYFWG3oTStNi65WIgcaoIFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Enable ethernet wake-on-lan feature for imx6q/dl/qp sabresd
boards since the PHY clock is supplied by exteranl osc.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index fe59dde..28b35cc 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -204,6 +204,7 @@
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+	fsl,magic-packet;
 	status = "okay";
 };
 
-- 
2.7.4

