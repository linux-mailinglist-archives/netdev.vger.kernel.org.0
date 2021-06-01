Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48CC396FD1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhFAJGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:06:23 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:20878
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232869AbhFAJGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:06:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5ZT8k7fqScsA5yREqXWlvM0TS9tPGnq04JmZu4+jjQa+G85GsomLvpRQS0fgn22AWXHtMUC3KyGRnj1sl1npPho15b9aGmpg5gh0KPUFV1frcmi3t7EVs+kv5YFcKoh66QY9Kcc/INHVk4fqqzJcHD4HiOhmhVZKGxNsjt+j2xMSdxi1bGeZpxDMvZq6/gtZc4lvxwp2FUNrGCtroJiRcgfWRL4X4mCJe8R6Cmy+AgS7kNotyN8rjjGbck+cknAPsfsDSjH36fSFC4z8pEKIsGwS9bS0rbgqKZPL5xs2Jttiqnb/YHgTWhZbV9IFxbhLKSqfpI1qi9qGkTSRqYZEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCLrTiiZZWcy/dVE6lykCXfvWxLr6EgS/w/mqmJ7RGM=;
 b=PILchitwTVrBbtLdrlr3CdETvmfw3k+q9sO17GtSUEiyEML+vA/Xz+kc2j3neXXvqMxzKy6BPKk98m3NfMZaecIX6HaBXxkDVpX0nMa17NRT9qkhADa4TuknWDVypWYgyG15oYjO+WLS/RWMh4FcmC0IonlxgRkELzmcGGkxpg4f3bCfZ9wXdt52kgRfYfgGsZNsm/xI1bv5Kl/QD1Nxb3sTKBh2WY1+3EtYNgXmdGDQeeh9XKbFc7hws/76r87imogKyo3lTSQ6ipLMqjUSq48n3E0MEluQKK6QiVQ/8v44PWD04UNsZKowuRVZ4aQstYXKvzdb9ppV462Fw1Q2hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCLrTiiZZWcy/dVE6lykCXfvWxLr6EgS/w/mqmJ7RGM=;
 b=HTNhmvLwP6yaexjSAV8PUZcbwsEGeVlhdnMy7/k3D29/HsoJkwyNQNQ0jK9BWT2bFnAYTh0NPNqxskgpZuAnYA8PWfoa5FhqzKgrAuU/X1oKNuAMPloEq+0BPjil6kh1JoYnpE7SPi6Z3Od8g+8cNZ4PrLuFQ2nY47++SVxLxtw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 09:04:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 09:04:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: phy: add dt property for realtek phy
Date:   Tue,  1 Jun 2021 17:04:04 +0800
Message-Id: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 09:04:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3e62a5b-c5ad-4710-cd56-08d924dc4980
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6795E86493F54F413761DB72E63E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfWZUMzTyEWlHKSClXzHaAbo9V5EicsH0zQPrxQbkIMAPTDg7WHanVaeqGLVLVYIEOLGcV8+tI7HfQ+xioWsZItDKXFWfjw/gmNbQgmacpRKznav3PcWG32+5WzWVvYdBz0EL5pnk4N2PvoInbnZ57ZOnamlOQ9milz37ikUmmjFavlSiW12E49pLk+J2b+Q98j4TYN/smoPby4wdbi4wo5hyPYFZ7+M/m4XHrpKJhJPdjWYHTkr/H612B4aXMyHBT2kockj4R5Wbhh8TDoLg2NJdzrY4rvRgTNo88PO34r/hkJ4A1dIADIzmroTsgy/+IdE0ZIJLYDhyB7+K3HWsE7duRUOU2H6OGBgWZlwC3WmgRFWzOo64+r3pJZ74bbs5nITTAvjKb/tvnXUkeyX0WYa4tpSDGArGLKdQSU2K8A5k/JmHLCj3ML3LBrsR6dYV+bC0ySfIr8rBNnYOdv9RkKGSW0CH6tMaHuAstdHdmSXf15AnQGDuPPtGtdMpDB3L1trnh9mxbRZ9nmB9veOTNhvdDSMsE2S8iX8atYqUJIBQDdK7pDV4VoNqYv7sYUOd48G3DJe9JF9JofFsTote5aEKwD21Qdt+lfoJINzOYa+baQNsRTcu7IjN6+iiNFuSWsB8yVw/bFDFnMcP2YzZxF7v+wLWlzCoPY6CJNNXqI3mVfjz6H2qxHns47AsCef
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(66946007)(38350700002)(8936002)(478600001)(6666004)(36756003)(2616005)(52116002)(6506007)(2906002)(316002)(86362001)(16526019)(6486002)(186003)(956004)(38100700002)(5660300002)(6512007)(83380400001)(26005)(1076003)(66556008)(7416002)(8676002)(4326008)(4744005)(66476007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HhEgYaaWP1myHO2wyxIgSvWXZ0zfo14MltXjV9oRVINuELB1RGrpWyEPdzoi?=
 =?us-ascii?Q?rGf30RoUpTbuVjm5Z/5d6q/gMADF+RfgwzUITXi1l9z9zhClQe7qbpf1o8nl?=
 =?us-ascii?Q?jRx0M/necCxIxbh79cesiEPd2YrFoUfptCs0/i6od9XPXHK50r8i7IaNqqry?=
 =?us-ascii?Q?3q3BR3Txv8LJb5vA9G+NDXEKL/yf0UfKRXvtXFNa8vUj3mr6eGQceHe2jXLs?=
 =?us-ascii?Q?2j4VIry7r2gTRhyNyvJ1SoiajI+3Pf/U9arbJ9ChObM9UM9CHCAxJfCWEMC8?=
 =?us-ascii?Q?A8KgWk+PhiXhZ+YGwh/53oQ0RY2N6xynXZ/yhQXhqldRWBSHPPxfylWCmzxe?=
 =?us-ascii?Q?vsS5LHrQ4dYZLR6Fozb+JOZEwgSsgDGSAVV5psTeE5Ixqxt+fSC1D5pjCpjS?=
 =?us-ascii?Q?TFe/m78EqXbX9Jz2FXUYSlyAZjT3/P73k77J+q79PKNhnH+BhBK0rVNUH+jH?=
 =?us-ascii?Q?d5B3VQDQfz2AraQ336lxLBMhSyNxzurIlfbwaqmN99n/LgZ3OABig/wsa7sx?=
 =?us-ascii?Q?/k/UpEXql1h/jUBLL+UjZUO68aKKTIQx1RP2cSpnaCN6N3kXbkmg3ghjIJIr?=
 =?us-ascii?Q?N8lLSXTFIpwCV4FTySyKqRJoun/4oBmvj2O/nt8VE+bj2n1faZ5m2y+BTyjT?=
 =?us-ascii?Q?GseMg41CjH2QXWcY/ajcKcFu/Z74uN8J1Dn/7/eaQ7d0nSTD9LE9aA7bIM9W?=
 =?us-ascii?Q?x5ewvq26vsrxlo0wpRGgIA2WQ71VMc6uX/r7azXfAdcinljqpLmDrysL52bq?=
 =?us-ascii?Q?Kj5WWSKZazjKwh8w8e7ROLJowlk1xZgVmetzmiMFM4EibNlMC3/a/Fu0t0xm?=
 =?us-ascii?Q?pqd5CT053zZFZ/fXB+B4PhxOvydNvHO/L95vZP1LILbw4PIJSppnf3vYku43?=
 =?us-ascii?Q?RaSjeSrYxYoEI7CpbQhZ81WIpc3Gxf/jHXKjLQ/lZzIpow3Hw3h11ZhvZjU+?=
 =?us-ascii?Q?UYSzEUCFlOLGGA2dKmXOgJ10o9Gb05sx3CW7lx91wRfNHH0zTm8s+Y8wDoy1?=
 =?us-ascii?Q?SnL6stDpJTOd/VnOuYEGkwVWqHlmT+92uHn+2fVfVAim4Xc/A/XMmqZu81yL?=
 =?us-ascii?Q?OrJ61qSj4eFG5SsPpShCLV0NvOv2JjMJN6LrDuJQ+AzTUu/LrKgtPxwxfjWl?=
 =?us-ascii?Q?KcGPfemCQaer5UQZhPgYGr6LlXi1qzxOqGNSyFJDD75QjfHY/hhldB3QvJYF?=
 =?us-ascii?Q?AFaTn51hJoGiNNG+IAFLP8EpIIMMSs1aznN9/2519dRSBWAYBwVWj8r/H9WK?=
 =?us-ascii?Q?ngiwmin3h2ivRqD06KTIFu24KzvRKjUCV9q0z0dIvLfMpWWVJzCbqQM7ZO2j?=
 =?us-ascii?Q?1a30im6zMR7ttsz9eS6ZKN5a?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e62a5b-c5ad-4710-cd56-08d924dc4980
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 09:04:39.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rY2aPS/stkBqDlCSRCIZlY5emk3RlmZuD506DNc4zadiESJLrSwgu6A+5nK1MS5+w9psD9+U4QVNNtn9D6Wi3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt property for realtek phy.

Joakim Zhang (4):
  dt-bindings: net: add dt binding for realtek rtl82xx phy
  net: phy: realtek: add dt property to disable CLKOUT clock
  net: phy: realteck: add dt property to disable ALDPS mode
  net: phy: realtek: add delay to fix RXC generation issue

 .../bindings/net/realtek,rtl82xx.yaml         | 42 +++++++++++
 drivers/net/phy/realtek.c                     | 74 ++++++++++++++++++-
 2 files changed, 113 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml

-- 
2.17.1

