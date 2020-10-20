Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A529293621
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405302AbgJTHyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:07 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:7233
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729301AbgJTHyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKbENijHS4UumarTSLcatSzQW+QWB0pynprBs0uOFFPZlTqRHXhFIxJ6ALCbvCNBGHLfQLe30KjcXbw0e0K0TTc+c7eYcxdG39gLpoUUio9xwwMPLFWgJHc4gU8b2BF5RKJ8eSLnh9AqLPTvZ7K/C+/1exWyKPw0EfIcTIjQdefu4IB0rbOo2zIZeD278NGMSJ0oAuR0LImVcAyCOgMDUlzTAHfi0z94uI6G36gVGVaiJILevCv2v/hD1B69i6cTt/K3dH3eS1QMV0jWDXXU/2AwzBna4AMdeCpUGPJzpsvsb2MJzJpwZFbGnSAVji4+iegJnHxdetpU4hVIwWsiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJBVAKBmdr1HldLN0jZ+y/OfX62yKO5ySL4HPSkJxEs=;
 b=i2rbxsE03WUA4RI77bpDrj+kl69tMWgfokW/RLWy+pTTD/LlEhpWkgy4tZtsOCns3WWq2RYO3kfbiUnKNhBnOG7hGCKsVztfskKeTpAy9ISPGNzvwZZ4lGyXeGSs3gmrQ1Z0boCBmOare2hBrCpLRUTK75PZVx+6ozKURLmAFWMDS/RtQ4sHX59IQ+KyB8VtPYOJ6xTCbmhqM0V7dqflp9rZpROh+wMCIfFKEisalIwpARi94RBSUsuP8AmqefwJcWIw8w8cp7Y0uFsR5ge+U6z1HErhTiUbX6LtzmuQO9IPuvEbeFY9uAFHnezPhfEV7gzCdxkiSy0Y2Ri4J9icfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJBVAKBmdr1HldLN0jZ+y/OfX62yKO5ySL4HPSkJxEs=;
 b=Z7UkdSJ7QhrL8+9Iv+U3orLM93iZLswhD/719RvSKQSXCnevGk2LrO9zA07PxLEFzDzmqlEGc3Ap4ZxGTYig9UBVgsfPrLUI6LfUbHZL7/blUm0R00bREM6bk0hvbNFoApG3QY/Zos/N9E4gc+oaAvPaZnv4l+9QyzZFDQ3AKTU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 20 Oct
 2020 07:54:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 00/10] can: flexcan: add stop mode support for i.MX8QM
Date:   Tue, 20 Oct 2020 23:53:52 +0800
Message-Id: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d561586-464a-41b5-2c52-08d874cd5142
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7333308DBA99BF9950764550E61F0@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YM+KJJ03uM/b01JUV7LI4OefJGt/jqWjOaCbZpUcI4S4EsARPotdtY/uHNUWryF6h0v8ITi+zLUoXpG98oTB34fF/r1gi6pe+3VAJozWVp+7MVn8YIjOLdMwqB/sudvMut7ZgHq2GCKs325apLKYuV0G/BZMub/L8xP57qnqRbx07zJ7g1ZGRUKRwbjNfoZoVZfZDdn19T0YaiFzdxiMUjMhaHz1NMUmeZjqBfrg8rWRR1A4aEpg36gsYdCk2nIsS2jivI7XbHw4DUnBBeyFiUc0Vx4hh2juE1Pqn51QIv59LZqHFs+eGZ0d7zYCbzsBrlokXY60SZeSV2JebWRso2Poi8pMl01R9FrIL+oO51SHDZmiavuOS94d5tNotape
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(6512007)(2906002)(66476007)(52116002)(66946007)(956004)(2616005)(36756003)(1076003)(6666004)(83380400001)(69590400008)(66556008)(26005)(316002)(4326008)(6506007)(8676002)(16526019)(5660300002)(186003)(8936002)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jUDOtD0hODC0fyB3f91Rp1Vj62PfLafL7iqCitB3no8m6BU08xX6r7ZVktRZLe/30upsbz2eWkbdhRU8yajRcUBaXPGJJpgY4h4HU0ogLYNXOyRzMz/FwKGXCo8DysFkWBhqTQjeWFIrv/yxckyPVl1LffvbHPTKpUahkRcbuq6Z09Yi285fSB/mpt+NE/m13k7r1qIl+OX5/WAGFCsAYduVRuQxxjZi3UyVCCNIcpu+GSu4yLxekEwaNSLMwBafAdgEAIzyTmgaiwPxNu8ymQHlVO+dZUdfV4ozwbusOXKvis/wvmA2Dx6bwqM+PAo8DHDFrFwU0+T7ZrGG6ql0cRJwq7Ceeb5U3r3sBvW1xIkJApnU8iFZ4gqFodVdqt3PkMod23ipp5c+eW28c/CY5uVUxhba3OCg4hI+qIYqU8UnlE8ueA79UZM1z53Dny0AjY9y95FLvT/1XLMh/unGz/ygAu6ndRX1mkGYq3O5rpSBrnEMKDP3gTkBQMlJe8B8vLEQ8vMYR42uN7YiRzEQg1tbo1D5SpSrqeNHwbooJSbzf16StnZgW0Se2sX4sJP+rQRGApoDQiCbqn4y4b1ko0+UAQF/FR7s5C7UYfxt8aPx9WsYfjLn7ptttNiEGoCpVR3kjGIC/qqVCbFnu2/2lA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d561586-464a-41b5-2c52-08d874cd5142
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:05.5156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5a2KcK8lKO4ORHBtd7akzncyPu/UbKfRRkNaKT3eGb1Or0JTUa1n/VL/aXzPo/STYwfQdt3oKN75WDYoso+4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch from Liu Ying aims to export SCU symbols for SoCs w/wo SCU,
so that no need to check CONFIG_IMX_SCU in the specific driver.

The following patches are flexcan fixes and add stop mode support for i.MX8QM.

ChangeLogs:
V2->V3:
	* define IMX_SC_R_CAN(x) in rsrc.h
	* remove error message on -EPROBE_DEFER.
	* split disable wakeup patch into separate one.

V1->V2:
	* split ECC fix patches into separate patches.
	* free can dev if failed to setup stop mode.
	* disable wakeup on flexcan_remove.
	* add FLEXCAN_IMX_SC_R_CAN macro helper.
	* fsl,can-index->fsl,scu-index.
	* move fsl,scu-index and priv->can_idx into
	* flexcan_setup_stop_mode_scfw()
	* prove failed if failed to setup stop mode.

Joakim Zhang (9):
  dt-bindings: can: flexcan: fix fsl,clk-source property
  can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
  can: flexcan: add ECC initialization for LX2160A
  can: flexcan: add ECC initialization for VF610
  can: flexcan: disable wakeup in flexcan_remove()
  dt-bindings: can: flexcan: add fsl,scu-index property to indicate a
    resource
  can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE ->
    FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
  dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
  can: flexcan: add CAN wakeup function for i.MX8QM

Liu Ying (1):
  firmware: imx: always export SCU symbols

 .../bindings/net/can/fsl-flexcan.txt          |   8 +-
 drivers/net/can/flexcan.c                     | 147 ++++++++++++++----
 include/dt-bindings/firmware/imx/rsrc.h       |   1 +
 include/linux/firmware/imx/ipc.h              |  15 ++
 include/linux/firmware/imx/svc/misc.h         |  23 +++
 5 files changed, 167 insertions(+), 27 deletions(-)

-- 
2.17.1

