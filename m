Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638A7362680
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhDPRPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:15:11 -0400
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:37093
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235011AbhDPRPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 13:15:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c92l7bqTsqLfF+WN2kJP+lnQJinop/zRCiQ6NgIFJojK1LIDfgxnJPt1GJecMMeskLKI3iqh7gABmDywP2cxioGeI4TpkpoANwMRLJop+QT3bjq8SK1gdW1qP7v3AWs9khhWSlRWxc//iy7dAqLepwkp0KCWhjlb2Uhc+tTUvdJ9OJEiDizhv7a//EAOAQvMscKpR8AfITGAWN+UucyzuueggQgnhW9uEjEqBm0Z1kiD2ZD64qfxNcw2XzYfe6FsjNSktjncFfJXP9z64w6wv0PSvlyldmn8l3YGD6A1BVx/8/fDLfUr3s3DX5qm8daVTfzUiT+D0+f4tQSJzmJQYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhP2ZrnznC8LmMHfGAaaPEnsqwCibS59UYB8bWoQrFk=;
 b=nNZjILMRmAgtAQ52sxm4TtgQYvX1yt7YiIPS8fFMD14Fjh7uJnAZYwvbooRvTRXAUcT6TWcaN+VpsVOo6tgZsbTRjfTkbtAvV9Jedja8r6kyWwfKMLZFyEepkIFXBF78gNkMgMSCvQ3iNHB7P1vvFGFgv+tckdBa2c+5RJkunm6LZgrhTGfFxqtcp7TyEZdtEzndzzKK2UeeotoiLUwm50Xtqz5l9QbgyAfnZy/5upII789s6Yq/E4zC6MdV5PnGtD9TmzYuvpf1jno9dXkKA85PRA+e5W1TDAYSr1spRGhFMoi7WBxybrffqDP5wcVM+qzxRjr0DDJeon6OuEM6Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhP2ZrnznC8LmMHfGAaaPEnsqwCibS59UYB8bWoQrFk=;
 b=DRKv0+L/mByb/z4dMe59Li9FA81me2NsJAIm+zt7vky+RkIutHCreqj080pxJsTno2HsoNbs1LrwGsIXkxSxiJk+GdKaoUGWFv1/RwbD5APDhB36qeNvm3dkdVp7eEouGPf/ls5++v4fNn+XIHJBc0+Xr7MzQZ6846Yho5sy0js=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB5140.eurprd04.prod.outlook.com (2603:10a6:208:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 17:14:43 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a%7]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 17:14:43 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH net-next 0/2] net: gianfar: Drop GFAR_MQ_POLLING support
Date:   Fri, 16 Apr 2021 20:11:21 +0300
Message-Id: <20210416171123.22969-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:208:136::28) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR05CA0088.eurprd05.prod.outlook.com (2603:10a6:208:136::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Fri, 16 Apr 2021 17:14:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe5ebab8-7989-40ac-cdd2-08d900fb2097
X-MS-TrafficTypeDiagnostic: AM0PR04MB5140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB51402A042AD59935731E1DD0964C9@AM0PR04MB5140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UAMqncm+SmcufmXpk5r2WAhesHeNKrILpquXoD/WVkNV8dKtaMnTmosrgX87cPn818jhezVOxVVg8hBhsO/1mWQ07Y9bKsVf2VBHEgABZyVnL6mdoxhbwgzvGMe831P1eMP8p0laiUoMYqIeLBYCr3+YhrfAutXavnDsak85B+YN7v9LRHOgr7dcRD2+4DQZIalHaeDtOaJelIafQT6TDgtMQN0V3UfqJCF/Q7RQi4YUMJzDei5LT/VzaL0XMu+Ahd0ipd8Q1VE4adrnyYX/PONrd8EIGlG8UICLrbHwBOsruv92A1ZI2m+UfEngrKAu4ub/hKyaeFkhtvz74vAOmz9HkllgfyQLZ1FKk3R1sYXmMZBCIBGlzvOQK+CL8MHMtV98elD5juR09f+DtWABMvDNyeZR5qV4fJlYlef2LP3USKis+LcGpVK1TnRe9hPjGq6YXtPCthKUoy1dRQTAMEUwadCABoln0lux8uz/BPfvgfNJWSXCLEEnT6Cl9EzZrGFS2b0vA78CMw0F2UzICMMyZZCV2V+4Cp8LgZlRdkxHzDrq1BmlQeuOqAFE1WP1FEVa2DxYhtse6G+osLKwRmdI6rRsq5wIuSPuY6sOYU0cwOFpgv82yp/eSa94riVqB2VEDS43Qecdpw2UbDx/Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(66556008)(8676002)(38100700002)(38350700002)(2906002)(16526019)(4326008)(8936002)(5660300002)(36756003)(52116002)(86362001)(7696005)(66946007)(66476007)(6916009)(4744005)(316002)(54906003)(186003)(1076003)(26005)(6666004)(6486002)(83380400001)(478600001)(956004)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1WCQ7eARa7xkI9MnFLqnSVX9hDNPfAcp6S0JdeBdFzn3d4PAHtkAKuWnlAVV?=
 =?us-ascii?Q?LRJ9j9KEYDGDA8Vzkc6QNvPdXiPzSn5PwX04FD1DIlpa6zDULvG7klpOmNRF?=
 =?us-ascii?Q?KAPLYQWvDGYZyihmFWtCqHi1ncAf4zuy6rnWzVLHabNsz4KOQnXqHFJsvQ1S?=
 =?us-ascii?Q?ThvxVv2SfRHQ9fSkO0ALjPOJKky6eZANEf3mNZT8hN861d85b20iSbsOPwl5?=
 =?us-ascii?Q?nC9jgGrkok8ZyxUEH86Xdf/+Hb+EmVKTkx5uRGIijQ4MEDG2iYkN9Ry+Wi+u?=
 =?us-ascii?Q?rMkZI5qZldUoN15r2mEBlc+Eck72qOms+M1GYw9m7Qu5uf3MxW7HCIdzM9YZ?=
 =?us-ascii?Q?iQInaAP2Ky5tM/bmjALG5V16Pcm5PblDAYipjnDtdgg5+mmH4wEFKHEeuTfI?=
 =?us-ascii?Q?MQ0IA81dO9Jrfq2JeONS5yMmkrRPBsTYVGKJfopazlSZZxSX2kEteIgJ+Bkz?=
 =?us-ascii?Q?0UEBpwwiKkgPuSV9wJtCPryfO9dsfXfBG5ZSBz2yGOJgLAf1MiMXfT/TsAKS?=
 =?us-ascii?Q?kuPbNtvFI3F10HMR6ZQTZzRaq/9bKppino8tNUDZBiA8HD4bbmnn6QtBX0mF?=
 =?us-ascii?Q?i9qbYWpCkWs8bPC4o0faTKBIZzY88OzLL8styY0Q/6qL0FyxGFTIjbbQQV/v?=
 =?us-ascii?Q?uUQY0QVIEnahi11dlQrV/L14+mAud7VZQueF57m5suAwKAqMV114Y/VYPUYe?=
 =?us-ascii?Q?jln3h4fOr6K3xG9yvvr3pcc2cw2DOjZpiWC5gmr4x1t3sp5cJFlavjm4kb33?=
 =?us-ascii?Q?eRZUoe+HxoafyqOyekO0H1jXFkR1zlyG9k4OBS5pYP/byX/KBPca863jb4pC?=
 =?us-ascii?Q?lFlTXCeK/i5P5oOin3CztJGau15ZtiLxxGjH8mCeuoXXtWMp2ZiM6Q23A5DO?=
 =?us-ascii?Q?zzTOqr/yg4Vy26WiJiwo1DoH+m55VRhwmpjLRYiFz5u/j+Uto4CPMbzFeexI?=
 =?us-ascii?Q?eT3GgOVz9hopHArkxJ4QwRNHgidqK6MbwgTGxxUHeJfJ0//9BapIcRiQoezj?=
 =?us-ascii?Q?Gqlsd2To9kwUSytKRj9O6uHY8qjLN1KNmzneMiMZ+6ds6/MlF7LKXGWnGGkf?=
 =?us-ascii?Q?ag0HSbiQMEBA3llPbl2oiolDUZ5KEqHuxeVnGaAxIBvrefUgrV7GTnv7yGe5?=
 =?us-ascii?Q?tQwi3cksf+t2FB0Vxo+9f0wU63wPsPosKtyHIgOFRjMWXHuiCDgjTc4TYS+0?=
 =?us-ascii?Q?kVu8uZdhTWDpLpHlsoOf68ua/V40g5tTgGC2nzsGtd6l6lOllmY/ezfSZTap?=
 =?us-ascii?Q?Rvc3jjgh58MNuWZtnVqsMCF25coOijk1nArTuDuSvoDjLAqiXgWg7Qkidd/m?=
 =?us-ascii?Q?1YRztImvGmtQYjX1W5/tcCjj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5ebab8-7989-40ac-cdd2-08d900fb2097
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 17:14:43.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEGuyz9D2ZgbqaWyxO2Eudt3fWEQE0zU5BV3DSnJdR/wSCBrVi9B1IDYiUhzevDHuhy1C1ITxdFwFbWbdpdZ3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop long time obsolete "per NAPI multi-queue" support in gianfar,
and related (and undocumented) device tree properties.

Claudiu Manoil (2):
  gianfar: Drop GFAR_MQ_POLLING support
  powerpc: dts: fsl: Drop obsolete fsl,rx-bit-map and fsl,tx-bit-map
    properties

 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi |   4 -
 arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi |   4 -
 arch/powerpc/boot/dts/fsl/c293si-post.dtsi    |   4 -
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi   |  21 ---
 drivers/net/ethernet/freescale/gianfar.c      | 170 ++----------------
 drivers/net/ethernet/freescale/gianfar.h      |  17 --
 6 files changed, 11 insertions(+), 209 deletions(-)

-- 
2.25.1

