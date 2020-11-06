Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AEF2A94DA
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgKFK4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:56:09 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:41045
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgKFK4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 05:56:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJcNGGabIro1drEownpvhBYlsePAwT1b436ct4X/TnmQTBPxZKNakCRwKGbs1Eq5isWxbEHFDN6Xujwhv6fzD/b8QcsG8Yaqm4MmgJ3iXp+ArilklXmKiC+uqOXt1toVUAXCj6d3sDwQL2TurHed0omM3M7JRfuzipOk4r47frBQEO5TELFMYvLpbadyt68+mUsPR4Mg0xj9lFwbIeye+uCH1mbfK8bq26PeWciEP1DOtnQl1teNVrxgNzTn56mgVSA2HYJUTNVWPdDX815arxV6hinltGOsQA7BSTRBSAJH2bTtajCN8eARdotOo+Ab9y6cW/DEkHfVnvM5Co8XIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHjZkg9KbkH24snn0GaNZtSlHoocCgFJWZCPJRIb7xw=;
 b=BuwNtxPA6irs9OSe2wl/bM+yZpUfbrEDVJhdlQUi+FNza28Kttq2upyWB42LZC6pfSo5OQhlxgn+fAeQVBJNnEGI0/R8UZ8Zz/+84b9PEa7y5s73PJKtqOuoZyxPWJ2+6obsYyp8MIkOK5KNGtiitdsvI5/bHOU9qRP+zgEm0iBJRFYlVhIhVkx2baQqOYS/llDH6Qy0rR4q8FqHfMnbM0ZImW30ieNIneAYT9VKBT9QPJEJyI/8QzOixC+l/Jw+0dRgweEuoIejajq3ZITuUtiAE4lCgC4Gcd9RVAjEedS+JIuhwL3xsHMX0itMdrsFjmO8+UWBxWrSelSTkPF73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHjZkg9KbkH24snn0GaNZtSlHoocCgFJWZCPJRIb7xw=;
 b=dcOu91rmXr0cz7TqljI70XoMH5eBs8gTzWxxxMm+P/64G0ivloiFj85f1aBnVc7iDOzdrI6LC7ty/6e24mCOHKEzzcFvpewh/9nejTBStohuOog4MTfoy/payHfW6PLBXdm3CZ17kWwZUPJX643F6+Ca2d9iCYYn7GquvKXinrA=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 10:56:04 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 10:56:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 0/5] can: flexcan: add stop mode support for i.MX8QM
Date:   Fri,  6 Nov 2020 18:56:22 +0800
Message-Id: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 10:56:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ca481b4-7a6c-4ffc-3f06-08d882428e2d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB428218DCE4A1654716B180B7E6ED0@DB7PR04MB4282.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:183;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /C9yHENVQ4ldsInjPOmg9k/SRhR3C7jN5JKF1m3l6VA+0JeU2XHEe7PigHtCwIqRfR/NM1IFewvbL6bHQ7qD68nfFd30LNGswVhL+EHzaCLngjGY5tnRK6w1lqiiicnEzIPSmC38du6yeQdxCbXQM5OcTdSOdai9WcSy7XqHAY6OuTGejEZmY63zMZJhTYbczWBLXrexC/lUXkUQIKrHZLJRT9GDYVNDJgTRzTi1QiZ1ekvSI22FF2Vk89NUkB2u1aa01A/S6AszMxorr4TxS6c0il5aTjZQgz25vkMIsB1bmniSDRxpAndWdMiE6lHWG4c1pCKREGdbUZjFe0UNhjVX8/9NzgnSt3iQt4JJKlLVzg+uGyXQHQbCuvfLWXa7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6486002)(5660300002)(478600001)(6666004)(26005)(4326008)(83380400001)(6506007)(956004)(36756003)(66476007)(66946007)(8676002)(69590400008)(52116002)(6512007)(86362001)(186003)(1076003)(2906002)(2616005)(8936002)(16526019)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2SyIp+Qalh+ghT+Ty50lEoXRFGLgh/v43MGzQLdbbQzdVHlbk+cPjvzeYQds15t5w2Ho4EV0orlvhSJzgGu24mfcfO/XoKwDyGZ5CxJfwa5yCBMsV/QIMcNdK4fIS7Ytibymmu0G4zrsNi6nr1hoQTGiTGA0rB6zTgVnzUWSSvlOzcwZJm/sz5/uERhMIbk+fSZVjpkeZtgcexBlU4ErYT6netIxHKuUiENjYA8boLfIdSfP9btxBK+kEPfFxrDGK6vI44Tzbrmt/vcr4YKIKVDK9jD3NFRoozieRiBQtKZjBoByd+WHL1wQ73uJ27/D0bkSighoiXqKF8g8GGH3wIyNc8C4EN32Glgl/glTlsBY4/Csy8UxOfRkzZApd2GVA45TCqjKCfOKnXLym/kB5T6Tzll56oeqG8YqP8rO99BR2R3VGHv79G/K8gAa2Vr+GrE+I16LsonYB+Wgsei4iJ4YRBzdZKmKeiIMrnIxJzuSIKHE0LXUGbJIiMgky3COh1piH/bwRM472/KXg9qRuHCCw1GSFLiLlVNKL9P2gzZIHPwy+TBZMvbMTkQIzuxxFDSWacIHLE3wz58T79xC8DPoy7n4bjirNSC8VCGOGSDPaMA/vskdreWVkbzEZl9g0UGkb8U1d/FHF/Md2eeKwA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca481b4-7a6c-4ffc-3f06-08d882428e2d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 10:56:04.0684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYTLrEF3TlxKpW3EFYFHbjYu28BxC2xbrpBmkadFEwq57ZCi1D7tEkef0DkfqyXxd5/uUqnAAAxnrmv9Rp7/pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add stop mode support for i.MX8QM.

ChangeLogs:
V4->V5:
	* remove patch:firmware: imx: always export SCU symbols, since
	it done by commit: 95de5094f5ac firmware: imx: add dummy functions
	* rebase to fsl,flexcan.yaml

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

 .../bindings/net/can/fsl,flexcan.yaml         |  15 +-
 drivers/net/can/flexcan.c                     | 131 +++++++++++++++---
 include/dt-bindings/firmware/imx/rsrc.h       |   1 +
 3 files changed, 124 insertions(+), 23 deletions(-)

-- 
2.17.1

