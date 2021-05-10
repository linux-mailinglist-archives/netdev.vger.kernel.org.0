Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D963792CE
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhEJPgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:36:00 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:37541
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231562AbhEJPfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 11:35:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkUec6q3lEjPAtspoBm3KBYhBZiLWIq+xoyLZufn95Abv4aTXtof+ceIbCkHAI4YkVI09HNgme6JP6VSCQ45b3Zs4+Re9Hq+tbXnbQgrQMvcS9EZSSQDPPztTsNXATSlrAxIWpbxXOmkiV0AD6GLE1AzCs2EW1C8kTh4x4LhSIufWjOVkmQEAV5x5CXhjWJ4W0KDfqaOnRhb8q8RMbMfRU5EHXh2UV0jWZ9cuoLkK/3aWg1c5VEJrfMrSdi7FV132Tiv42T+IBrvlHVQETY8dm42wgf9Z9pc9TcjPpma34Dc7+f76Wzm0rPFdjimLeRtgVeXOlldj74HYChTxepGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcSApOdhKJo6LwiqaC4jRmBQ35dCNWa4mdRGCCIrJ6c=;
 b=i41G7FcJz+AdFyQdoJ8w9X3imvZ96XmxGye20HSd+avEpgdHg/DFulAh5BtW5czxXq9wQ/1g8NWecGksGFF599Dy7cklHQEo3TVlqpALWe2NmZ3szPr4YHTdOYKSDXz1QLLIVahOHls0vb5S9Q3J4CYHOKI/WhcxeBRHgFstcOJnN5UOZeI71wJkSHrUc/Y/gazydybnI3ZSy+KsEIqzVmhc+2DdEJoTxYjCMtNzNwG2M4wxzn1E/2EhtW2ublWwVXcFZzxFYp73oVlmj9YuP2J1XpJ6uQ8VeYPYslXSJT1iAqoOxXvXqM7dxbaYenvZBPbeFISbF2WdqUxUiRjbSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcSApOdhKJo6LwiqaC4jRmBQ35dCNWa4mdRGCCIrJ6c=;
 b=bN6AURL+namsvA/319IHvN8ZYvCPJZ18drVJtuw+SnHzcHRwYi89XgrlaOJxXsFm7mR+m5jeOLnAPvFrajVlubkALrpkcqvBUDSqWoQdB9RFYdnJHvut1KlLQOHA7f7G/RNHk8+8QF3WBUNRHm8jUpDw++sMsOBHPQUSsrXgLGM=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0402MB3470.eurprd04.prod.outlook.com (2603:10a6:803:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Mon, 10 May
 2021 15:34:45 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::34f6:6011:99b7:ec68]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::34f6:6011:99b7:ec68%5]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 15:34:45 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 0/2] Add PTP support for TJA1103
Date:   Mon, 10 May 2021 18:34:31 +0300
Message-Id: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:200:89::21) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR0202CA0011.eurprd02.prod.outlook.com (2603:10a6:200:89::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 15:34:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c55e341-1f94-49f1-e48b-08d913c922f4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3470:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34708169F6EED2121C0332B69F549@VI1PR0402MB3470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcUGbdEzmGhJ8MKTqvO4WuBBNa4AobNBK4NNt2ALS10hwY72t0PXUIep/vjpPSEuxID8gkx+5RWy/fgZB9B2Cy7ywoAA5Z9yzOU56BYfrzHJ9FS/FjZ93hAJsFg1sg4Fv7oxzqZH4lp7X4vu5hRdNe9trYfoFjVQL06g2GEjfPOzUS3PNIaui8x/9O9sGhTxHLuC97dzJFlAU44V3I4VFO+uKMUSKjIjszMaBBD+TRfvscP5zg+xa6lvC+ZukL8vLEwl/ajMevbMWlLMpSvpwspWk63wrGLQy9qWsKwAGr+gQa/U0O4YoeBFiAFDIPvYTaXEDDgbLFPQkp2ENwzgVdgLzb9q2GxCCs/Ffb3uV8EYBjoXQOpj0EXG03qt5rpFsqrdhOP8eNtPEf9wskazYw9NviyOlNBdt7R1cOVxPeNtLyl7/KfqHWhfohMtpTK5S+X+qck7ApzRwiKqoTlBOEdRh0I2ee/0mIigtRQpZ1Q5Wki8fPOEYsPAp5V8L6dXJ7sVu9uyVEbw1tccwbHh0menXolmuDgllFC3twuVLLKUpVzTyhTZL7CEbru1twJFpRbcdBL55VIGpQIMHb6LLNc0Yi57okO9b2KBNKaQMf+laShAERnuTjfzV49fl4FzTFHjHFH45PZLCO97qKQ2Bi0yutwTAsjkPXi2xiQ5YdynFPUn2vDnmHfan1dHkniah4WCntPE4x85EFy+RkU2gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(478600001)(66556008)(66946007)(86362001)(66476007)(8936002)(5660300002)(4326008)(6666004)(38350700002)(8676002)(1076003)(52116002)(16526019)(186003)(6512007)(6486002)(316002)(956004)(38100700002)(2906002)(6506007)(83380400001)(26005)(2616005)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JXS/ljaSnZEjwg7goeCOF4hgJYyuRRtqunMFCi28suLhehCUeR6eFwiF9274?=
 =?us-ascii?Q?oI7MV77rx4FVtfmi517OoJ4biOCBZa6bFr2C7CNdg5Bkmvlxa41pg936OM4m?=
 =?us-ascii?Q?dZVBnJHP1d/sC46sP7bARxvVwaujMEAFDZ8f+IoiNL3GBplVtEYxJFBhDQVq?=
 =?us-ascii?Q?c8e+7VsOvskFOMGilh6BRhYbkVi2dQHccMC1bP0vvNBwOIFjRRSladb5alty?=
 =?us-ascii?Q?cuJuT/6QXIY5106De0DFs1IyYhHX63io5FovSmdGOzNr5K3xw4ofnoY3GbUJ?=
 =?us-ascii?Q?oEkBQYjk7tzriA8Q2k46dQWMWje8yej+gydQkEH9/mS/3wzKh1CSOgn7Ibm9?=
 =?us-ascii?Q?TAtZC2Q4XptLQJ/sRZ0EKSDNdGuvMiyPgvL7m0BpPQnQl5Gowb4qqsaKa+ZL?=
 =?us-ascii?Q?bqMMyxtMFVigc8IhGNfSAaFRqvk72hDlY7A9/Nu+kdPI0NJ8i2SfW6WJ/EFl?=
 =?us-ascii?Q?/dd/m1uB38pjweLqAdCoL3/Jyd1RdnGE1HkHE2CJSiNRBMicaJzCkbS0nEwd?=
 =?us-ascii?Q?ph/KD/O+j20+I9RtxOerRV8iPH+zXjd1cMd7LqFaAtN5JWns43L1iO1tSvi0?=
 =?us-ascii?Q?9uQyNsXIQKDB3Z/CBKNGDwwHR0uYj9q6uTXiyDufkKZlK0/kXcxzsfX/rx6Q?=
 =?us-ascii?Q?F8J8K2z2ukK0drNfLOzK6PdSt7ua953JJ2N6tmB3JGsjHH2rF7RBZCza64kL?=
 =?us-ascii?Q?zyoyRfi4v9/CeOrSvCxlzBIE3dPQ/ZCWWS5qud/ejVwLeJlS0pLPdCU6MD8O?=
 =?us-ascii?Q?BGjk11bvZPfVjVmk6aEIK9IgLFt2w4h32i+8JQC/WTWjFlpD7FkigwOHWIsT?=
 =?us-ascii?Q?lR2ejHJCdWPVvTaKcKF26JxJGcziUv1r+DHUJmbF3P05CZU0x1k1mU6nME27?=
 =?us-ascii?Q?1KRW1lPqoEZbbyvod5mxF5phnmk3EphGySWDobB0j2DjGgxIkA3af2ky1gMy?=
 =?us-ascii?Q?93ZF1m6b5kEHDShsTTjpUHI5Q9qZ5jUEmD9hYOOTjX5wr3wGwMplV2IhTGC7?=
 =?us-ascii?Q?cq/m6OcMRjyawuJECa59Oc3uHLuTIlwQ4zmC9At5iUEzFTxzDNBA822dqGgO?=
 =?us-ascii?Q?ABbLmFsplAClRVuou/eRhh4BhZaMaPh6rVt4Ry7fWP+XwzcVSFqzbXm3S5bV?=
 =?us-ascii?Q?ufTrXHkh3ZAznZekub2V/kOEgy3TrVkbo7pH3SQC1otfQvI1RgCAhAhYlT6O?=
 =?us-ascii?Q?V2kP+l0L5ZkTMENwdviujM50RL/gnA5xPbn2jDBZ7movrPCswjoDmtvPHhY9?=
 =?us-ascii?Q?rcQO9f23MBYFt+KZU9aQxFdIiP7PxJasqnOsviXvoOxrlCIiAIeQse/2V5qU?=
 =?us-ascii?Q?LJAsIHebpmror1C8ek7r3Ja3?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c55e341-1f94-49f1-e48b-08d913c922f4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 15:34:44.9762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGYx0hREaUzYuS09kzwhUbgzZQyHh+0gqTs1rdl6m+pGzdlF8nmCOUPj3GxqGC+S75q896L8sixvf+NPCKjgPTFZnufRxW6/dOdjeBXapP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the PTP support for TJA1103.
The RX timestamp is found in the reserved2 field of the PTP package.
The TX timestamp has to be read from the phy registers. Reading of the
timestamp works with interrupts or with polling(that starts when
.nxp_c45_txtstamp is called).
The implementation of .adjtime is done by read modify write because there
is no way to atomically add/subtract a constant from the clock value.

I've moved scaled_ppm_to_ppb function from ptp_clock.c to
ptp_clock_kernel.h in  order to be able to build the driver without
PTP_1588_CLOCK=y.

Radu P.

Changes v2:
 - added unlocked version for the functions nxp_c45_ptp_settime64 and
 nxp_c45_ptp_gettimex64
 - use only one lock for .gettimex64 and .settime64
 - added the same lock for .adjfine, .adjtime and nxp_c45_get_hwtxts
 - moved the reading of the hw ts outside of the loop where the RX ts are
 reconstructed

Radu Pirea (NXP OSS) (2):
  ptp: ptp_clock: make scaled_ppm_to_ppb static inline
  phy: nxp-c45-tja11xx: add timestamping support

 drivers/net/phy/nxp-c45-tja11xx.c | 531 +++++++++++++++++++++++++++++-
 drivers/ptp/ptp_clock.c           |  21 --
 include/linux/ptp_clock_kernel.h  |  34 +-
 3 files changed, 556 insertions(+), 30 deletions(-)

-- 
2.31.1

