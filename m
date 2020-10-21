Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA192947C5
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440452AbgJUFYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:01 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:29223
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407293AbgJUFYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXk1U5fxloIOsGfE7O0jNhyEp5BHgg5NXVVcRAL7VhWKv0nXDlIDn6BqoehThyrnAebDUi+LArclMHYmFL9LAleGJLct/0QC/7pOwcwhgNOF8AxI9WKZHubEp+yJZYQhD7TeaLKYezH6gtCXY1hEYRqOemUoVy8Uz+Eh6EvTukPQmQ758mKVnULZsP1yJK1vvQAtTK/pkaHf5Q1/w1KgurIt2oJoEHZYE+MqELXL0M5zfcAM1Kge2V+w7QPv43xy8Et2qmrlj4bn4OhbPsqxpuQ2OE8QsVcX2IiWBkDHJ1CWJO0bvJkHvRu9PuxED6HlvD/je6c+6P8te77K4SpdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBeXKWUNcrkyu8S4J5JdFAgz2t82vATYqTNNrbC7RvY=;
 b=T+S5j37dY8P3b8chdXLernj6C7oSupa4OralYAcRt5pgJwLAHxOfmuzpRnZpZQeE4zBz+7veDBCpD7HTGY0+6jk3i1nuqTP9B8JLqjcd8zXymuvj3BG6rUqN2nib0M9pgk7DlxNnswzBgQzlJjUfMfxw5j3ljaSAGdhnmb3Zpty+rjqsxGskW+lJn/27xizXWvHeW9xuqxVvBjLnXaWZHjTBgO9jMNFwk+3ZlXqdLV2ABFvAJAMIcBHSkMV3VcGBJeJ067FmGVVXd/2dREXK/7m+Vta2VPD9FMmE00T1pkq+MM/GdazBOSSNKcdrZh8lwbOp7+Ch1irZJf7shIo1zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBeXKWUNcrkyu8S4J5JdFAgz2t82vATYqTNNrbC7RvY=;
 b=jo72cyJGU6mnOlmozhyFlfCtGHXy5ByJyU1H+c44dJCsUW0SBidobvhWxlslJWgwlBRfwHkdxZHd4k68434+bhvPka4BlAp+U+Z3u/oLL00EkxZzAME6gKMpoTT0I8+FS7FAOegetd75tomk1vCd4+O/g2TXvux42gd578UlZmI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:23:55 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:23:55 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 0/6] can: flexcan: add stop mode support for i.MX8QM
Date:   Wed, 21 Oct 2020 13:24:31 +0800
Message-Id: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:23:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88cca84e-c79a-441e-4f1f-08d875818162
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2726B2F59552BC9B85BAC013E61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRNy4UwyWMo8A0VEY43Joik24IAWrx9HxPVUCr2dcpvlyZEmcBFFIr23Xpntd84x9PHlh0Nv4E456IXgrgpvxZfqiFge9bDaG714NeTYsvz6w7/mkaQUJFwqbOnsBM4JGdy5Tm1vUbSeOVKQ6RqnCN//MgoNsh8647rjOPYW80XtCxQv3rF+QOlF6fNp9XX7V89CcJSrxasSp8OrseUTclVm4Y/4KCIwbvo7j8IpJ6ZqX9oVUV0f/ljGpZ58p3sdmX/tNm0WePWBAOEeThVXIL+cPD9GzpqGt2ckCDCHY5XwXEmez0sKI+SsFtHQGnWk6BTpQt1TkIybqDuiOFu5x90HQ2p9pFiir+V1skDze4ebljQpAgIjotcr0vH2U1MH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(83380400001)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 905m+NgjzhvzRc69dCn3+0nQcDkLDV4B/ONiWMZqlEUCKZRraeRFbiuuwlixt6zbiPcn/zekTB1CRT9Xol4pDIge4VtIZlVXR7xI4BqusU7YMty+pMJEfBHgacN1U1r4ASGBFMq05B1RjZO4iBEgE8s/WFNmKI0ezTtIevTMrbgseSobE2gJY6RYfoWNWqpmrSA2uS0SDJSx2NnBw546Zw47gXko41h/DJQ5O91zh6TJp57u0bZLIgoetQY/ry4WmGZjrtUEXBRguEJemmGXL/ZQj2bdohT4AWZtDy4Wj2a8wlXgRRXI0ZqOcPn3Wh+ankkyNfJPNkk+93VEMoMy7CnKkPt93YNgsymNH1nNfmNG2sdfLbbyphNA3Xp85RuhbKL0dT+glVquFRwpmafiV3EnLGtnL5XDQ7P7XTdwNrcgQbNQXS/9jExw4cLw9nHQgqF912FEv9PgZG7XaE/KpATFwPqTRTi/RkEOftfXIyYO5vnTfczR/1Fg9NrBfqA+VtdYGOIThUaT2cNAfkDx3u6ftZurgDTZ8CnkhEK8fojp9O4Ryn4HMgRGeVhsHVD92uzCJ42W2gX2etlynSfeKTAtC4fPq/+r0BEZ3C/7imINC5v7ry2C1bC3qABhM8zOiuCidqI6SQkwo6oS6Stl2A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88cca84e-c79a-441e-4f1f-08d875818162
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:23:55.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fglf1NNYPeegADPvlwCFZUBy6VfX+9bGFehIzI8cNmAa73bCE6PW1BEkNs4HHrMjgquEvv7mNYY8u4KLhhuEcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch from Liu Ying aims to export SCU symbols for SoCs w/wo SCU,
so that no need to check CONFIG_IMX_SCU in the specific driver.

The following patches are flexcan fixes and add stop mode support for i.MX8QM.

ChangeLogs:
V3->V4:
	* can_idx->scu_idx.
	* return imx_scu_get_handle(&priv->sc_ipc_handle);
	* failed_canregister->failed_setup_stop_mode.

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

Joakim Zhang (5):
  dt-bindings: can: flexcan: fix fsl,clk-source property
  dt-bindings: can: flexcan: add fsl,scu-index property to indicate a
    resource
  can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE ->
    FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
  dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
  can: flexcan: add CAN wakeup function for i.MX8QM

Liu Ying (1):
  firmware: imx: always export SCU symbols

 .../bindings/net/can/fsl-flexcan.txt          |   8 +-
 drivers/net/can/flexcan.c                     | 131 +++++++++++++++---
 include/dt-bindings/firmware/imx/rsrc.h       |   1 +
 include/linux/firmware/imx/ipc.h              |  15 ++
 include/linux/firmware/imx/svc/misc.h         |  23 +++
 5 files changed, 156 insertions(+), 22 deletions(-)

-- 
2.17.1

