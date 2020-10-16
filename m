Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1217A28FDAD
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389052AbgJPFnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:43:00 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:15680
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388851AbgJPFm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:42:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LR6fbpUeOPbHXpxvd0B4y9TzKWs3Brom1i7EfLFDhigkOeMHUoRzonNXiwtRFLbyeqN4HNfy0+4ACanp9tgLU/wh7sf1iMR4Po/6cZcjZUEbZDj1NrbPUuoczcfppT59w4F2nPo8fjhwYjJzFNCNhrcRVbuRqdqicsVtP2oEFmZsepsVYm7AwJ4t9kTs1b0piEOEMDadAtpKnYf79hq5WEVCAX8heXcm5d7wGYgefbVQVrcfklQHC5LFMpWLdRCQ9E8AZn4/2ZsKFzy6tyf4mEiunYyoMIySABlmQsGdhCe10yGdljEJGEkREvzh+xFidOxRxe1yGT8yKoztIcUb8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAgkwMEeOM5r99rJM4FyZZ7DcfLlVaOMTBPHBwjwISA=;
 b=HC7Mk8e1JqIEI6lW+nBJZO01SaiB+giDAcYqR5RWj34NpWdSsUcZnp6iwzOAidyF1LPpZL8L48N89tPOUVb2U+mxn0um9nUvoLB+jMHp0Gmdlo+ohSvxuMpyh5k0sqYvbtXRLHVQ/Ne2ZLTkGDLpiR113l/Umk2pyVXohSm5Ok2rdcA74z61SX8Bc1LTRel6j6Mcgg8R516frxtZsyWF3epUGGdDBjRBrfpGywPhRzPp47Un0dl7P8amuucvu/Idq+HdnRVMt7FnhqBubkzs6JIVzYL+4fF+xuRb9R9jJb6RjsyVf1CUz731orN6HVtKGyBReQiKZi/vKpoAginJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAgkwMEeOM5r99rJM4FyZZ7DcfLlVaOMTBPHBwjwISA=;
 b=I8Or0q6w3gXVBU7LwCaOqYHltu6lky0zFxXD89g5pCUdzgMpQ5318R5sUBc38kO0tqXc9HIYTEwmnLVBBi0L2n/pNmlCssH1yEWXFYE0rWJpbg9zqQKGm9uIq2GnUh6Ak2Z7/uUaQknDWEdaeu7irdtElynxpXTkUTqf3beDMk8=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:42:56 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:42:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] can: flexcan: add stop mode support for i.MX8QM
Date:   Fri, 16 Oct 2020 21:43:14 +0800
Message-Id: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:42:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2371ec91-0659-4edc-cd86-08d871965546
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7333FE3FB64429312A44989FE6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKOR6f825JSS+4FaUtiLu+s1+mOrUvAz68Z3BW2uyMWGAu5VwzAQHrtpoeLS3kRrKJBMtRU1+VENFeMdFeSN148k+HOoORmopZAtM5ZqwzS559o1zLmot6GuF3l53xHns/cmsvCck2+ie9zuGmYepAE/ytHmQE5ceT4+lIXr5hZgivJhDKQ6pbxG6iGLsnGTuUAEhHdn0tBS1tF0pRZq2FL8w3MsukBPUpP+3iJ7qTp57zWFFgU7MVZGW+kEyVN0r2q23vUHSSuxeYEupm0eRD+IRQEKrS/HgmD682uU7MY5cB57mxCVLS5V8782Sx4pJDONbPHCpKVO/OzOKunf0u6uRbiog+SF4SVZcQvZfR3XUegHidwsZps6bb59C2ycyLhmLDiW3tKzbFBPp/rnviDrHSCNSvAAfReYMQVP4Fs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(4744005)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(6666004)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8gs/X/1pzQeLbBTLYs0AFVRzOByUVHeQLytXRuiAOWVauMdox2KngsxCelt6A3eykU9dBeWvB51q0lOvFrRQgdL43sc66Z9cZ/IlfpELG8Uaa9/E80ut0RrNV8ynZb/LJ3txIXF+A7M7H550ydLQUAu4i9JX2q6AavJBRL3dQnjVvEyBBId9x0FNXO10goYfM7kNH8ag2sTaRAT3FCz69A72axVsMtj2Ij5NGGGAZFDKHDq/EntT0uD4a1VoP1dbgveK316LRkLsNUtwTMqELz4vw5LmvsJ5zHFlcu5fWx5uEtkb2mSmdu6Sa/MCksW6OS8LOfOIrskBOltRP6a/m572PDsPMboVZWM2EF0aOUs1qAwAYZ2V58e8PMrvECldzeOT+e87U6xASGJllD1+ECJV5ZU0+eHE89OTzq8ZNZPIbJfD7Yb1unQi0uqeGkh1qE/hFFAJZsipdjSlKpmj+Io9fKWa2WOI365FbgRuei0a4YKuPpu7n+M+7rfXDF4LHlOAfH7N9TAjhNUEMGeCSq5q5k+i0aXwht4/6XKFTTP3c5zETaNrB891inFpZhbePwHjsziZKG0oFeC21gZwXuheDoul84uGbIQO5VNI9PeSUmNCEpY04MyIf1tQ1qz8CVkVFcT8gtEyIcuWv7Dbrg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2371ec91-0659-4edc-cd86-08d871965546
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:42:56.6783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV2FxjyRxm7kdzRoJtnH8wbO19SGMZSnVdFMJicaMo44VoHwvLITulTyZwGSdz2RQiV56d8OLxjoiwnmqKSdfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch from Liu Ying aims to export SCU symbols for SoCs w/wo
SCU, so that no need to check CONFIG_IMX_SCU in the specific driver.

The following patches are for flexcan to add stop mode support for
i.MX8QM.

Joakim Zhang (5):
  dt-bindings: can: flexcan: fix fsl,clk-source property
  dt-bindings: can: flexcan: add fsl,can-index property to indicate a
    resource
  can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE ->
    FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
  can: flexcan: add CAN wakeup function for i.MX8QM
  can: flexcan: fix ECC function on LS1021A/LX2160A

Liu Ying (1):
  firmware: imx: always export SCU symbols

 .../bindings/net/can/fsl-flexcan.txt          |   7 +-
 drivers/net/can/flexcan.c                     | 143 ++++++++++++++----
 include/linux/firmware/imx/ipc.h              |  15 ++
 include/linux/firmware/imx/svc/misc.h         |  23 +++
 4 files changed, 160 insertions(+), 28 deletions(-)

-- 
2.17.1

