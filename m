Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85B7292328
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgJSH5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:57:40 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:63110
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727420AbgJSH5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:57:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAUyn6EsHcafGrTiTUDdljdjC5P3G44xcSJXE1rYGQr6sXqz/XzX7c6e0gu5BcM3Yd+HdPGLCo9egi2zhwMkKK3BnUqi4jDBNR817MkGNQ6dOoFrP/fz61PnoQGnqkttjxSR2vtsGsWauf0NYDCwR3i65IglAZRv4wP9EZRbmwhmkapbHWlMfkyIAQF9vZp+VPgHlbnfSzKx6ZADvg+v3HzfPYv1aL/74LcQPomaHiDGDtzmiAS6ZbUwedDOt9qQrOB/Q7GjrNy0hdCZi9NemCDxR7hVkRQ2ec/4dWz6A4mtQzAEL9/Q6rG+eVSMM2fYS7Hl/++cCHBAkOTgcrjY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2S3cLaZh3U7tr1RiNC4kvlyDKV2+/7Amw9bo0GZ6hHE=;
 b=AQFgb9MDM0uWSAZN4Ui6pYIyUn6dQYvWlHwFTMsh7FZfwwBghD3QrSmq8pUkXdz2hLe2PxSZOCYBngAMmAzzVpzi6NoPdeaBUr9G+P0/s9CykwIRYDo+VPKN13cv8ywcNAMcCMYq7QAlTZfX8/LKV9wGxMgjcEvGTme2an8WdeTWMAK76ElKQP5sa0sc14hjDiWWBCqqWLJS2rOAEgqkzFi/3ejnH8uA6XEzTDucXQlQ/koEtpVAGaLv4gijql4+bZrsjUyMqd6QKU6IGnM1r8LH48rugq/rIux9mOxIANFApSGIupqeFpMfJRbR7eflwzCZC9S4oY+ZVN16ewRW3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2S3cLaZh3U7tr1RiNC4kvlyDKV2+/7Amw9bo0GZ6hHE=;
 b=okXwLYTvil8r/cqs1fZqPN6m0jExjHfvMYHqxIgOSOaBQstXr7RS8MLvwp+Z2wUnfamwLy8EboHqFAmdXIgGK5AV8Yfu0ho8gXJwbsn+GBKnFejq4zU3rFs44Ht8InE0OLcFBZGeR7zOHqR1DMjnbFQ8cCoMSwECppvwlCyBJWo=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 07:57:36 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:57:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/8] can: flexcan: add stop mode support for i.MX8QM
Date:   Mon, 19 Oct 2020 23:57:29 +0800
Message-Id: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 95bfc7cf-0d02-4b6b-6fb0-08d87404a496
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74309BC14C4D15596A1D8F43E61E0@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5NEeoNHfPLbbR0dJHb/wLH05H9+6poK5tKrTMVQrTOEdB8cDUwb/+aDUiXUh5TWgM0b8fbN7+WuGkuoeGxQDNfzPLtX5npWkO6j3nL3SdNdRwWSvIKBus9xthXoDTa4uhfzxulv9sJoPsNYuRff1PtN9eomP0GYZt8IG4oi49WqzhMPE/qHMMUEYJ5YV+c8gxzeSJtvTGQzO0uHowYckuNC14mp2d1WOHdHkANI7kDjl7tKW/slmbOWUQP3QA3BQp2RhZUlAhX0Y8oE/hDdsTd1amugYB3s55YT4+A2jO2Ziqm/oZ2lelPsissb/UZk51anleOTB8kB/UKM56GUErcQOeLsTnX2fQ21xixygL3MHhRWsaV9Cd0feaqe05p9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(1076003)(6666004)(2906002)(4326008)(956004)(2616005)(316002)(5660300002)(52116002)(36756003)(8676002)(8936002)(6512007)(6486002)(6506007)(16526019)(26005)(186003)(86362001)(66946007)(66556008)(478600001)(66476007)(83380400001)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 61pFTQbcSfY0T/krtvn1Yg7iKWyTH0wggGy1SAupT5oVJu78yTSK6hkUCLhKjcI5219eWpbzZR1qPbKrMVLBkQ0ftO00g4xkeDAcVEUdh+O1Q4JxWolWAKQZH6TQbbvDXsbpHT6FtO4ssmaYRxvRsZpthCCWzZAVBzvGp20L2QvDkNICEdvvxX6rWGUNo2eGc9KDcuv3Z0ENl0lMK3SN6J+kH2oABkoyDNbeOWkKLm2AD2V1Fw9DgJuZAxgyN1BjYH3LEmD5bkgTMNh2eFsjr0ajFqpiqmQL07JT8KONeZSaT7hTKn90juksUQO1w0OrLBcBaCpyGqTwmqSTX7VPPwg9LfpCPPV3ufcP5PUafzr1QEfm0jvwOOYBoGk7LxW873lf9xBd0p6iydFBDslKZa1n+pFikGObYWhTllFnJU1UVzm7oHqmr9hIwsizp24Y7fbbmFr9cLw4bEWZZch8BmhFmKANXH1UVIQ+oaecwJDBKFvBep5UzctFiennbZk2RYaBs4kklyFiHzz0uQgPMuDwaRtoHl/nTBEjh0YrxmNVp2evTqQLcB5hdQ7t5A37iHXZ9LPsfrNiX70+Ld085AQ+YbpgTuLfuYT8cC+J8G3wso+sdpn4U9zd/LnCB7XqnR95bRExP1V1fdO4O0EDNQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bfc7cf-0d02-4b6b-6fb0-08d87404a496
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:57:36.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+IyQzb9pCaXi7xN51pX3zUvuKkzwU823sdXwykM9vtMzDLujuGiWJXgm1GLw/Vq/BUGd1+npFbGX+tGIvsxnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch from Liu Ying aims to export SCU symbols for SoCs w/wo SCU,
so that no need to check CONFIG_IMX_SCU in the specific driver.

The following patches are flexcan fixes and add stop mode support for i.MX8QM.

ChangeLogs:
V1->V2:
	* split ECC fix patches into separate patches.
	* free can dev if failed to setup stop mode.
	* disable wakeup on flexcan_remove.
	* add FLEXCAN_IMX_SC_R_CAN macro helper.
	* fsl,can-index->fsl,scu-index.
	* move fsl,scu-index and priv->can_idx into
	* flexcan_setup_stop_mode_scfw()
	* prove failed if failed to setup stop mode.

Joakim Zhang (7):
  dt-bindings: can: flexcan: fix fsl,clk-source property
  can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
  can: flexcan: add ECC initialization for LX2160A
  can: flexcan: add ECC initialization for VF610
  dt-bindings: can: flexcan: add fsl,scu-index property to indicate a
    resource
  can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE ->
    FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
  can: flexcan: add CAN wakeup function for i.MX8QM

Liu Ying (1):
  firmware: imx: always export SCU symbols

 .../bindings/net/can/fsl-flexcan.txt          |   8 +-
 drivers/net/can/flexcan.c                     | 149 +++++++++++++++---
 include/linux/firmware/imx/ipc.h              |  15 ++
 include/linux/firmware/imx/svc/misc.h         |  23 +++
 4 files changed, 168 insertions(+), 27 deletions(-)

-- 
2.17.1

