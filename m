Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504B21E5ADB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE1Idn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:33:43 -0400
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:28873
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726939AbgE1Idm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 04:33:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYJcOdw4JHx/NK3j3KtmdGoSQxDUGwJZpvH2WaZUchgPh+CEjHmUZYnC4coVKnDzwKDFWH/AabyrzWWXY5f6CXfAf5jyGsPBjYh3cTxhc2rRCFMUjrE3HOLuD0oqWYOZAVraINB5eyFBxVCHB69MuxtfHpaENTca08atHPIRiBGDd4d7k+RtwFa0udp1TwI2R96xmeVdSKX6NAlRa6I6ljD0d9HEQfhu7hPM0ol3P2QuZaHPYaSs6jpdXfDolgfKPTrpcrP8UBffbhlYAJlhUYvCF0zLLm5NniJAaWv/bTZ3gbBAl06m/zYs5fVsyOWL/g8jxAQd2RDoBLfe19UNtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3y5/4oqgJFsklJMvzmNP/SLqzpY4r7pTJS8qy6gl54=;
 b=cyfzjxIDkssdVmR5hLn+x4WKDGbusV+O+x4zk2r7sLrQmnPer71Sxf0n6HjCmTef88eN0oxFmOKFliAMor6vD7ebJk8k5SKXeJJSdXFyrT/vdxnDKtNq5V5l4jLz1a7cClmQQXkBtFYSwF2QSXvDFHBpSc8g6Y8XvTdWgow8+y+OUdrIJJudsSs73YO6yx5XCcxWfPASKMbHgF1lRWSXxcKg8Ety7I51HEpKv2d6lwYPm9EPzRxAYcsv7q3NtD/eZlOcerNz2qkL8kk7wlzZhNjAjQNjQZBlBqzeQRRXQhOp/B1osktQaX5D5FMUBdK05qy+XrjZZ3x0Chsxgfb8zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3y5/4oqgJFsklJMvzmNP/SLqzpY4r7pTJS8qy6gl54=;
 b=erGLeQGBqHPyDL+iQrc9eNTDjXlaYmaiKtvkSimjCuKs30JjvEogS9lygDVqWNjMwMtaYrfiPajyFCbglHFaBQaHigQ43vumKg3o3kd0Ihrw/ddxOjT7qNAtt0HxDoPAbK2vfO4Rg/n9go/CpAgAFygFW92QAr4Mt9cJ9bQmG4k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3768.eurprd04.prod.outlook.com
 (2603:10a6:209:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 08:33:39 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 08:33:38 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, fugang.duan@nxp.com
Subject: [PATCH v2 net 0/3] net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip
Date:   Thu, 28 May 2020 16:26:22 +0800
Message-Id: <20200528082625.27218-1-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:3:1::24) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611-OptiPlex-7040.ap.freescale.net (119.31.174.66) by SG2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:3:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 08:33:33 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9acca61-e628-43cf-bf5d-08d802e1d1ea
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB376885ED65423C48095D1E01FF8E0@AM6PR0402MB3768.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ELwqCXOplh6iyokOyCECECn2hIWY1qo56LCpHxHHqTAo8qDpRp9bVqhj1b2wqfWA1x3zcE6uzK8SB/ok7dSh+NezHAXFwzUtco01/+mGEdRsF/u1JqZHLx0g5VVC2+V3/tQOJOt/mNLPzOmNJOMth296l+0vwu3vZ76UQbbi8+OwQfqCbmQlx1xqr/X7oc9sOKeqtZlJshDsbcUmCmiQFWlU5EQssWCvmHtBbZTnwcBvbH3LT+Grt8QSr1nn/0hsTmHZnqk/XR1ioI4bv/2OBjxQs+iR2a52JEx6c+YbGNC+cdCbLB70nNIU0U5e3lV2P8oMRHSJx3DAh6ubuiEtwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(5660300002)(8676002)(36756003)(26005)(86362001)(16526019)(186003)(1076003)(6486002)(52116002)(6506007)(478600001)(8936002)(66476007)(66946007)(316002)(66556008)(9686003)(6512007)(2616005)(2906002)(956004)(83380400001)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MIXrloWfjIxCKkD1k3fyWKuqchdDxWoRMR0TOyzqqokwOvmebUIhW5npyn11sOQxOq276UMcytjEuxkdmHwU2fzhz/iD22UFFDgK1p56Gh9tYZl252YoGMhnXtTAmzKISvSUJ2S/ItXhQECH8TceoWNk0ti13JWyeRa7uBBmRALn4G14KpORoaU88cUUP3RPGlvrJDFO/UfcIjZXUype2kY3iqdIfc9uX4ZHCfcKrOf8U4MugAvD/SGBKuI1JhbVn29iCBpgfbagViJqR1EFQb+cpFHdgL4co5NfW65UiiztTMVgutTtLNrZyyLVnTfllubepHGupmVNE6htE8Cj5x/aM7/OpJlB8tmCsIASrdnAh+yYDGdAtPwS5NK3PjVVM4no33pGtP7ysEqQEMv/seLCZVGnE7klpmWp21YhfZdFKVq7KrZnKnQxRlOUwifAZdFwDqFOnQo+baHrkCC4aMxDXHtYlY4OO4QbFmzPkIPtQw5gAfcuLZzs9//K3xDW
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9acca61-e628-43cf-bf5d-08d802e1d1ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 08:33:38.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmiZpf6Nl3h14XDdy4MsFDhT+i05TIJWa+pfydRnj2tVxk1aO2CnR51DUymASSCCFqh7ZX4Out9/ysefbsY7bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

NXP imx8 family like imx8mp/imx8dxl chips support Synopsys
MAC 5.10a IP, the patch set is to add ethernet DWMAC glue
layer including clocks, dwmac address width, phy interface
mode selection and rgmii txclk rate adjustment in runtime.

v1 -> v2:
- suggested by Andrew: add the "snps,dwmac-5.10a" compatible
  string into NXP binding documentation.
- suggested by David: adjust code sequences in order to have
  reverse christmas tree local variable ordering.

Thanks Andrew and David for the review.

Fugang Duan (3):
  stmmac: platform: add "snps, dwmac-5.10a" IP compatible string
  net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip
  dt-bindings: net: imx-dwmac: Add NXP imx8 DWMAC glue layer

 .../devicetree/bindings/net/imx-dwmac.txt     |  56 ++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 315 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
 5 files changed, 387 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/imx-dwmac.txt
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c

-- 
2.17.1

