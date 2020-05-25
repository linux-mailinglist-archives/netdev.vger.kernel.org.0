Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1771E0BE0
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389810AbgEYKeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:34:31 -0400
Received: from mail-eopbgr20083.outbound.protection.outlook.com ([40.107.2.83]:22915
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389745AbgEYKea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 06:34:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX1/YY92I6FzDz9FscQWZElE30omDQhOpIZOvRnMrJY78yOJ/qyjrneARdV5WRTnzBDi66OO1C9hJuKDmUhPY68saYItAYR2uks/lH5dj5dvwIWC6T+j0d16E1S9gcAoCEJTGzf2Kotzu4K/Tv+d9RTPSNLDeLI59fO3xRQa1GcWNodKjyzSGwsJ3Eb+AITS6rXDXq7LpWFM+jnTPoPJq8nQDRrFvlLezAhLPuIhWMwFhftNwkvWAthBVo8u3Z0m9rdNka9YuqgzQctnBuMVj/WXGOZXoEuNkT9bBUuz0I+oRBmyNVIrH6/tGRtuVnzKop9Kgvk8e1XmXZoL5gvtuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDP8qysKs5wQUeVjHCgmjYLQ/N+Xtw85sNI7CdaR09k=;
 b=XLnXf5BrXBg1P5OJ0IPBnTAigX5b8T+1pPFlVqZigGTTwRlwKGV/7LNhMnJvLVrT3WmZNlZ5v2Vkhv48LgcV9RNoJUM0JNtVd51wtPK/hURZkSZloY6rzD8C7G8s8IOkh43m9ITQjrN9j/blrjycATv6hgNHLRHXWKkDS1UQpgVteaYE+fBDDKHka+p6pcKSbiolgvlxIQ4B4CEuwV5xO992pGc23QpOZq/tHXsG5rkRjHPyvo3ux55ilnExnj2/1jcSiMzN/U3abLYxnj3flwyuQWxokbJL/8Bdw/ksEpi1t8ooY4wrA/v04VnGQEoqXexCP/GDcN3VK1mm65lfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDP8qysKs5wQUeVjHCgmjYLQ/N+Xtw85sNI7CdaR09k=;
 b=gwLH3Sp6sKhyfUqatyRZFDZFsCyOHLTGFHRkrlXZnKmpjqhefVHobZh0fociAYn2uCmbkp/SKRo6NrDn06m17VLCtgnc3fc9pEMzhEWMzBxEwTSMEVs58DFt7z6sYnv+rO4k4KY3XC2RnSCEmRrb7P0Rj7AYcpD0npMD4aIPpOQ=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3383.eurprd04.prod.outlook.com
 (2603:10a6:209:a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 10:34:26 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 10:34:24 +0000
From:   Fugang Duan <fugang.duan@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, fugang.duan@nxp.com
Subject: [PATCH net 0/2] net: ethernet: dwmac: add Ethernet glue layer for NXP imx8 chip
Date:   Mon, 25 May 2020 18:29:12 +0800
Message-Id: <1590402554-13175-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0180.apcprd06.prod.outlook.com
 (2603:1096:1:1e::34) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0180.apcprd06.prod.outlook.com (2603:1096:1:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 10:33:58 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00786a79-0344-4811-589f-08d800972400
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB338373CF6223E1C2745F2E9EFFB30@AM6PR0402MB3383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 934M0Wz/D5z8z8nsalDSSstAl5Zclc/UO2HxBci8VIXBnp97YeegjbNvJDEpEYfoF50Il3sAtoxk9MMo3F2zPWQfjlkPnQQ2Rfgb13mt8JL7l6awtkr9XasAb1j/PawkzaqVqv2SNucsjx4ZKuNsShGVaYk2xIa+bWpX4lw5EmxaAnP+rxWWpJw3dTyIaMJroVt2DZJJBfCNccfGGPB9D7YnxWZM5oOjBAi9MhKqRqzcnnw0sOXoVBQisAT6X1IKBzMjZDEpaLe7L4SSt4/IOOY1Ch1GPGPpqdGjch5zrA0BqCQC0jvAdimkMxtIGvrn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(2906002)(4744005)(4326008)(6486002)(2616005)(36756003)(956004)(44832011)(8676002)(5660300002)(8936002)(186003)(16526019)(6512007)(478600001)(66476007)(66556008)(52116002)(66946007)(26005)(6506007)(316002)(7416002)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TtKZtpOHzLIl7lnNKH3UWJ5aoQPNCd2q1wl8Gr3pdqdoJqfmCbDSqjYW1dUuGyV0T/P5lKoPsn50LhUSFEc4B9TrPIUTzbwakkSWKP2COE1jGoLItXjXG4/O+uA0jMmwf7ZrcBJzFkpiEyUKcRDbrFPnndzX6GtjkSCIv4B888KhgmcrZEUx9J4rOgxjNqnl5xL/FMxhT7pRQ8brZuaD3LIa9YFqrTBnpYxa00xqRlWml1r31R2/FtCIZHLHjFZK8i/jF4CzS+XzXGstn8ykvWsPSqtU89g060nZ7BFfETU8Vt4zeJ9VvTCA9Q89LvYwv8GgNTU1LeclFtmElZuu7AWfki50+G13IJyudU7aehO+nSq3ESNz7DLoif7TJH8KZmPFcfo4xB6WibucQUdLC4AndIHpQoHrZ64Rx0qtHSQ6sVlictbXDiBLU9P5XhFbTkYjgLiqG/CIxR9vAZXShEE3Y6UFhda9SSocEDZ4+XUMiMzJZ+FWBnlDDntMYw+r
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00786a79-0344-4811-589f-08d800972400
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 10:34:02.1336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODWjclzmp6eh2PZ1uGJHx4by+ueXNENxbE4FVAAsyetu0BrAaVaNIEXylzTwRipr2T6j9i8lH4uCyjctcpyFlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NXP imx8mp/imx8dxl sillicon integrate Synopsys MAC 5.10a IP.
The patch is to add Ethernet glue layer for NXP imx8 chips support.

It mainly handles the platform things like clocks, dwmac address width,
txclk rate adjustion and phy interface selection.


Fugang Duan (2):
  net: ethernet: dwmac: add Ethernet glue logic for NXP imx8 chip
  dt-bindings: net: imx-dwmac: Add NXP imx8 DWMAC glue layer

 .../devicetree/bindings/net/imx-dwmac.txt          |  56 ++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    | 311 +++++++++++++++++++++
 4 files changed, 381 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/imx-dwmac.txt
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c

-- 
2.7.4

