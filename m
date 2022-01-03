Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670948347B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 17:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiACQBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 11:01:50 -0500
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:21721
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229651AbiACQBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 11:01:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPXv1zF2aF7pzdMHsaG8w3BZ/F8PvjWsw2y58UsuotlvRjzPkv9nuvOzQlltACQqo8/8S4G2px9/9klwEVzcuuw8B+QxNM2LSz82sX8cSm5RiumKO52/RB5JkwVh1alBkSYBlMm7/pefME+jA3KKI/zkN6ZiATAz6HTl999kzIJQOcTBRQutczdccWIB2MlVXYCksPeJ9nFU38dVL/uEVm1tLHJpTmwrLP++F7agECXswXq+RRwlRR5lNoheQacuqlZbYR1URhTQC/Qek2rk+a7/9hA5wmtccjiYH/xruw83sQb7h/mbXMROsHnGzLtlcWdg7ShXlPNnLbgwB2cfbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZLx+MmVkP/ImGs5DLPEa+7fkJ8rpi/PXdqSzj/MHjU=;
 b=l0n7EeYt0VwXfH18iVBBZaSCCWK1AQQCmhe93HmvzWVFmBSLIUDoKvegmxyuS3n43xD3XJ4Az2AQSsvpyEuLl7VPqvjGrRhr5MkuKl9Jgndk5Y+nbwrN3wiYK1TaeB4VfM5T9JSpTgLGw8+lmpbBOFp+vrTopxo/ctZUWrf1QKXaz9vHFzSgSQDpTQJubKnvsmzasy0cPH54kZUL8QylKlxuemx2NMjSeLW2UnJphGt+/nDc8Zjr8A+zRJuQWTmALnLKmoNQlY91eD7BAQpKZT8ouNRoHePNqqOmxAB17K/77jFZVzxeoia9OY4gKZ00DPiwmByZy15e4Lk4cBojfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZLx+MmVkP/ImGs5DLPEa+7fkJ8rpi/PXdqSzj/MHjU=;
 b=jAiQ0CDtnrmCeK4XXuFz3ZsMalZWA+PHAmK0ZzttiLP38QR5G8y9KXsGtGz+VNJJeTeUIZsTIiTIAN9hsokDA3/YgC2C7oClIShuyji/a0UXBdjLe9iB5ma8QDA1/LOy9OiRnu7n6/ynlNZ3uUeYdHpMVEd61C9sVZP2u/dRLvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS4PR04MB9507.eurprd04.prod.outlook.com (2603:10a6:20b:4ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 16:01:47 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%8]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 16:01:47 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v3 0/1] TJA1103 perout and extts
Date:   Mon,  3 Jan 2022 18:01:24 +0200
Message-Id: <20220103160125.142782-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0010.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::20) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9e0e4f5-a5be-430c-b0e9-08d9ced25873
X-MS-TrafficTypeDiagnostic: AS4PR04MB9507:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AS4PR04MB9507A380ED0FCBED229ECB609F499@AS4PR04MB9507.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjR5j/iJyMKBNRoxasSlnzbn1w6bIoGCSQbkX8KjgssjXu4VbYGVN16vxykpP5q+NhahrK43f9P/0y8ciQAqB1lX8Jt/T97BghA7gL7ZpaqyNVY1nkmDxvSJ7K1dnCums1DfWZmuK7qllGSMu6YiJTEVAJILKJX+k2of70tuwESJiGAb1m3IqtoaiTwkJAisiCG8XmBHR59h8SRSpuepqZCpPiMUzxP1Accv/beQDI0Q9trFQwE7B9pr5+UVVTSe3rrTwTSeuIwAsC0n8l86Ia9iSGs+9c9lJbB+SaGmtiFYeHqiyQZekjIokpFGtLq+9+Gva4aleGwYbYBKvGumU2TXiO1x0N174j1Y/84PNYIdJhDNTq13uJLLOvE4JF7rscV3NkijcFYcyDFbghn0JWWyrWPAddgaXjYp1gXaT8yM6bHu9nXlObzwPOCQ/Zc4CmStTURNilspPwF5MmvpsOBRxsCmU0jEzStoFCZPHhzZG+bVktYG3eWCqiWBly4IWeIhHyowlco8Z+mNcE/79SULYtY+3brdaeZfEXOK/Kz709PSIeXTveVdgdwRKA9anAWrBIxL/4h718sAJiiyvwD7CEK8SWogopF/DDNHeyWmzNbqe7OTvipD+sWKx+VtMKhAUUTLxZEGA+QfK4/leBi0uXrqN3ZRmAk/gU15Ec28lL789DUB8/nRQt+Ut1Fy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4744005)(66556008)(6486002)(86362001)(2616005)(66946007)(83380400001)(66476007)(6666004)(8936002)(4326008)(6512007)(8676002)(186003)(38350700002)(2906002)(316002)(52116002)(508600001)(26005)(38100700002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJ5OnYY+69yLb2Xtb2tWz4DcYNSlnb4eeZsFdeejyzQsOwsqlDm1Gb7K+v4h?=
 =?us-ascii?Q?Xv05AoJ+7Kn3Rlnx0hdvyK/2cJkn9pBS627GQ4FS5js+yDIfvyc+9pD+zJZm?=
 =?us-ascii?Q?Rhr03+xi986jTWOCjQk3QsV6oh0WxSzcPQvezEW+8B254K5qgPKgG2xv5RYK?=
 =?us-ascii?Q?fbLIWGgbBsQjDyYihpHSutf4V9ihP+dPMBEudyHiyRCxHvWp0aj5a615fkjB?=
 =?us-ascii?Q?NfB1Yw5ZYrqXyLzOBJsxHX6qtNI4YDsKVRkF7NdvlClVySsGYOLlVc/sQIVM?=
 =?us-ascii?Q?rqT8mTFa+GHQdF8lVC+an2ZH5X6hf8SsaNqFsbbduBKYVSTDBEDhG9kOUyij?=
 =?us-ascii?Q?IoskBNMSZSOQKOgtxpqVrwSrI2intcuSMOZ8/FYIUbUBw/PuvBWoqG5bLisa?=
 =?us-ascii?Q?4c7fjdSHpKjofg6Rbm+4hRbEoFk6Mbs23lWV295huHCXSi1ye1CaJyj96lPn?=
 =?us-ascii?Q?4NlXAAVggD20Dco+MOIg7O4dpJoZNOYv9PVGzPgtkAF1GYdde3EKXOG1VI6P?=
 =?us-ascii?Q?VlEim3dPF7ZkpNjo5Lrkaqbqk6/mEFcIDTbvml8CYqQo48WRxSMPVYV5nbUI?=
 =?us-ascii?Q?25xbBdBsNwuczHOiCzQWjiBvOvzcQnlqFR9le2IACvT7r86q1g4HgtCLbLNM?=
 =?us-ascii?Q?Cd8fnJ9zNgl1eL2a5Z+QsIKMBiDy7M3mqYl7T2CLKr5DxUeCUwNWmmNPbas6?=
 =?us-ascii?Q?hJXtWZvtoWCQb/AwOgfmjwzbxqbZn6jAOk75YtWaqfkUQSAXObyrnxyzQei3?=
 =?us-ascii?Q?Zyyq+B7SvCS++oUJeCylP1ncTzzRUFg2qfCnqfMJ4/pekRLGWOAKfkyRIeQG?=
 =?us-ascii?Q?k4l58c1CO4TZDgI/riIdUkHXgeTNEjL0e1zHKZsFfZ1y5JI/L8HBpUdtr5NT?=
 =?us-ascii?Q?UhzFFttQjoxqw2R2PxTUSY+FJ7zlyXiFomIYvGjSOVN+6KrJ6eAOBx3XYvlg?=
 =?us-ascii?Q?aqrJr9TfWke8kWRPZlbvaZwIG/pCFBmqWoGrdWlELjFWLrTgYdqP6jcbUImI?=
 =?us-ascii?Q?/0dmeu6HBrXANbC79iwojFMzGSukorxVjwD2MNRRRHyfiIq45qigCuxesMyw?=
 =?us-ascii?Q?/EJh98YIMCpDnxcnkeULMA6RM46hgpZhCwdY5twSGqS5E+RHPYO8j99LiMfU?=
 =?us-ascii?Q?uksl4Tdt7lp6G6nwXMxv0jwxJ1oxaQSZtlZ0AZ54GUdbCMnZ4/eymSUOkVVn?=
 =?us-ascii?Q?3NM34wfoArB2E9rS/FiT1M5vkTWVLiel61wLDlS3xNT+8Ib2mdT6/2hz5gcU?=
 =?us-ascii?Q?15GQl24y9mXGXn3remLdYZIe9HKY6OC1IfsJIm9HnZNBkFwAGyjtE2MAlAxj?=
 =?us-ascii?Q?oIF/nvrgVAxVDr4kOtQP9kiAd8+298Q2IE9Y7xppeuoPbyR4beRl1ATWuJbe?=
 =?us-ascii?Q?Zt1yGJ/x4bw3f15Opu68bYrDrbJfVi5a3RLr4uWQMUf7K+iyLamwhCxGWoVo?=
 =?us-ascii?Q?HNI8UlHzs/GJQFpKccuqsNH64MW9mY0HyB7c+it0ZnnKapyotFWQZIrSGVjm?=
 =?us-ascii?Q?ovNrF9zErlBAMbsseY2ZpfrG89eMAklKgQ6HmtuesP2wQsqjTvG6kXfxf4T+?=
 =?us-ascii?Q?sIwiGK5iafvFPM2kaCZ58o0sPwGwb/aEhBVrvA5zfsD8a30NaVJI0eWqknb2?=
 =?us-ascii?Q?6Zi5aLnB5o4aU3RwZtiNGGVD4NENdqK32G4NrdUVYi6mioiMC3bl7XrjEqju?=
 =?us-ascii?Q?WXX8dQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e0e4f5-a5be-430c-b0e9-08d9ced25873
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 16:01:47.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7vtDnC/0EEBw26OWJbVDAJblqi73/fkS7W6IAvlG+loJXNKiaak1JqXv4j76jAsSV/c/uwLra7tyxXifyibWfSg2ObhmAn/EJa8SSpD5p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the PEROUT and EXTTS implementation for TJA1103.

Changes in v3:
- removed "phy: nxp-c45-tja11xx: read the tx timestamp without
 lock" patch

Changes in v2:
- removed the patch that implemented PTP_PEROUT_REVERSE_POLARITY and
reimplemented the functionality with PTP_PEROUT_PHASE
- call ptp_clock_event if the new timestamp is different than the old one,
not just greater
- improved description of mutex lock changes

Cheers,
Radu P.


Radu Pirea (NXP OSS) (1):
  phy: nxp-c45-tja11xx: add extts and perout support

 drivers/net/phy/nxp-c45-tja11xx.c | 220 ++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)

-- 
2.34.1

