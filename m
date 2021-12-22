Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1BD47D8D5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhLVVfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:35:14 -0500
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:58757
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231946AbhLVVfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 16:35:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gukorktXIZOViaFzTPj5FLu4uq7t7CLxYbzduyIT1rYG4ePHI6JYbElhVXoUdGNZ+keVZqvzQhROqioa0jCvbUY4ZXFqke7a79KZ9oiYHWeCV3/Nd5l+fdYBlZNWG330GcKfkVp4WFA9yVz4hnmWTtCLD5OPaTzIdMZWinE90WnRk45u6ejPgsmx3JRUYW34cKr5mvHqGV9mTWIMpL9/m9YILIQpKnd/eRqETrlludgahblszrWQmH3Kg4zHKdtwN2Fe7nKMyPwDLucKNph3LEjSqgq/hUMq+e67YGPUayLOwIWu+JDp/bzjm69M6aSsTlAUzK+8D08MhRT3oHIItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4uOcy+fvvm4qegGMchK6fl/e4K2UuLDn67yOrUTYXCk=;
 b=ePj9RS5/8AToV0rGZyli3BUrZsStaYxfFiNj2zgObvt0Hdv821Peao+zNXbevUADwfak0qSly1vlCNZSogpz0ZdMlNfa61IpsiEAAQ/h9G3IpGIjWvutVOoLCxYjG5cjka1AmDBNwFzUcHp504iIrFBQiSzvbM2udJBi0zlafHVMnST0HDIFTutAqa1p+WfYj4gr2bIFtu1+GM/Z2QEniyeguLkG6xtf+nRacF8m4qp3BW6WPj2xoHO2/K0M+aJ6f5uhTrT3CN9E4sBN2n5XupNfEqbBUlSdRhJed8LjH3Llv2B2evJZhyf7+9N0P4JQS8pUn84cL2Vwkj8TrlzR2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uOcy+fvvm4qegGMchK6fl/e4K2UuLDn67yOrUTYXCk=;
 b=FS5sFc7bDt3M5BOxBizU1TekB+RKnYlPgxJpAOtFaVafIwj8hQEB/eoYg9LoVBKbNMNBBuzo5OAXmbuzXaWZL4HZxc8Xcq/Os/DBM3F0/Mw8dDawSP9dIl5Bp9sbAKwzht9MkcFw9UmDYIA7OpJNUl4swDjPIwUtjsWFDqJL3Nk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8732.eurprd04.prod.outlook.com (2603:10a6:20b:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Wed, 22 Dec
 2021 21:35:10 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 21:35:10 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 0/2] TJA1103 perout and extts
Date:   Wed, 22 Dec 2021 23:34:51 +0200
Message-Id: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::41) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c834e2d9-7ef0-42dc-113f-08d9c592ee2c
X-MS-TrafficTypeDiagnostic: AM9PR04MB8732:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB87323402233FAED48178AEC79F7D9@AM9PR04MB8732.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gnxGfCvNI9qZ5a11ZRh7/7Os8Zop+1GRQ0Gmx9XcCsBX70xQbxYE88Hi4iZozE7LLzWcJCq5pKEhoBkmO5oDndVOAWz8aOzpL5TR/nCGyeCS+TeIY989Anf3e+nxPMVOMg5ze47ZSgapzPdZ9ZFr5G8BEdOAnGoTneWLIvMLH/nozsu2xmLfX/v9zXaNmFNgvJZ9YiOhIPd1NFUXCeLd+M34tiJt8F5Vmxy3eO+wxqSH5jppeP1MYn5uZ8O4WpQniKX2qQuU+H52S5S/Q/7AWp8PP0HS6d1UTxMkhLq70Xlrujyatai5tHUtv5PK4oO2gbDPK0qr5NLxuJOAP7KuQ8nXFpBZ32BE5pB749e0BWFh715lEWfns8T9695i4hmrgoqnTERyI5gFdhtqs1vas/yEIwYEBiaQt6Qg7jSL8I4VfjPJ8G0LX50hY7Raig4jkJq4IC9xj7qJ550VZASzQdxli8qpbJR0aa9ldpJVtZ1zWFo0hBcCuIFSdx4lY2WPDSC45W+iR8Q5ATk/f/32yT+58We+twI+ClmADR9lDwEIjYXnC7rqtuaLRDqKg9PUppY+krT1lEElIId0luuuUUL+F/lNQ+np7ZGN2AyGrJDwSUP+QvW9vu//NZFmFe4aMEB2YGlA2UmXu/PynXCC32nSoXZRPjr4VUckM2/89NxuaQzRB4f3sgALKB+pflQ+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(26005)(8936002)(6666004)(8676002)(186003)(6506007)(4744005)(66556008)(66476007)(83380400001)(316002)(1076003)(52116002)(508600001)(86362001)(2906002)(6512007)(4326008)(2616005)(6486002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXlDDAMlNF12sE+A7pL2BxhbRm5Zu6q9VgJraMhDC1dCPzcEBnLRL61SNyJB?=
 =?us-ascii?Q?3vYnU5hLMlapZHofj+077SyIaOLTwS0md3AFpcP32xyzO8FjblwLfsUhIkrq?=
 =?us-ascii?Q?KY/HD3SEqKpZ5mwvRiJ3CGo+gDPXHs3bUrSDjocqa/d8VWSHEQfaoJcCA45Q?=
 =?us-ascii?Q?eSNrAyE+nFUm/fcJ2AbFeMrMqPaO9Zp87BSdF7jh3SPAYAZMhtIufVDbt+I6?=
 =?us-ascii?Q?p2stZCHMiEHjYF5qqVgOsTHzGw4H4iK2mLWDtLcmpRSF8d5aujzIyABmvFo2?=
 =?us-ascii?Q?7LGtDQGkNgV2Iazeb/YZjDbjTglyV+K1aRQvbIBeLCt3yy1Tz0eQA+SV0DAf?=
 =?us-ascii?Q?qdfEbjo+42qX/JPc43mr10yltJd4ge7Tiiun3nVISqwXSWpu8/i8ylPBDa0o?=
 =?us-ascii?Q?so+3WdmwxztkhOJrTPCKrmQiluq7AN3qQJQsIj3ZbG5r4l9wui33/qydiVeV?=
 =?us-ascii?Q?hD1Zgh4/i0rc6qm1wAjcyWw2Gezy6WUX8U4WQcw2tUvE910xENte0tY7Jl//?=
 =?us-ascii?Q?mfS5c2OFhe7IqzYqiL5hfo0aCRKnXwLhOH8KILKPrizQBdsMbEGJ8saJYDjD?=
 =?us-ascii?Q?PFTCHVti/ySV8Pc93ZASOXIrfJOl8Mjiqx4hSA5wkSKeGN00dk2wIETaV90t?=
 =?us-ascii?Q?zaV+tYs02fq53BowMJSfq0MItfgW13zSMY+VKJ9TPW6oagUS8RgQ1TdTx2Kb?=
 =?us-ascii?Q?+xZDdyC8CAH7w39SI7ckyxjNHOhFwvv7lNiigDhqAOrKtJoLsJrctXo0kvNB?=
 =?us-ascii?Q?uYruMztjJFHDDTNRInvPdkZnFlqhD/0D0fwe1All+HeEXcxYqZbXS3wX2bSp?=
 =?us-ascii?Q?7UN+WjJCxv7iEsGZMTSNFVmNotL2klZrA81F8qUQLBPOVS979HtivcvqPHDZ?=
 =?us-ascii?Q?12tHfKJkyd2S2gsa6UN+Ux+021V1E6fQrPGG+E/109EOxPfVGdWAcs17cAj5?=
 =?us-ascii?Q?ZoOn2Xb5rJepSm65n+mNKjy5zF+fkd2N1rHTSfFIopSUo2oIWpl56/wjegkt?=
 =?us-ascii?Q?hppiAMZwSDwuwd262/5pKcztFsjBrQoBRm2+H4mAsVtLqqG3e85XZNQehHtR?=
 =?us-ascii?Q?OzIsilQXmia00FwS+WoBxg+YoDE7oBOoPK3EZUxtu0MbY1YL66mhC1LYQYCG?=
 =?us-ascii?Q?gNPCLB0kgkQQwUEFyCeJvEZoGp6lzLeAXANV1+Zl2JXHaEZCjn4G4eDw6A2j?=
 =?us-ascii?Q?SFECKehnR/hRQw9KlsTOqV3OG0HBgx3QL8NHNAV6ncnxLcM2t8/mgXb4jgwb?=
 =?us-ascii?Q?71C8Af2KWrnvE/EfbNd2Ci+c4ogFFvUKyfxF3OgpSDbnm647yuFUBpohgtM/?=
 =?us-ascii?Q?VYsODnMjnyMjDnsvawU01QcqctgxgFHlMOEIWa36dgoYT5bok4sXTYhGfjFv?=
 =?us-ascii?Q?rQXhtiNYOic2gtYSuPCxDBcma1bdZlHMeuIOsQowNNDUl1NFPZ6AC+cR1+kl?=
 =?us-ascii?Q?DpjvSLwZl48XiLDdPE79+WKPRHCTvuuFtXBZl7RWlLFaEHgEwZ5vYNdhv32z?=
 =?us-ascii?Q?ei6Giq7YEEhkZAIRkrRcV0zHyrtQIrcW0KUSy98c+8bjCR+73CysXRMdT2ud?=
 =?us-ascii?Q?wDjtRTkakuDO75FjLqh8mpo7PzUCyeFo4GDq6Jg8xo9e9NOEpWs245G0bsuw?=
 =?us-ascii?Q?WTw2BZvEEQGvQ2tCqkZDSjIqY++JjSBR/YNex21tFbZDZ8F2X/fmq0BJrJ2o?=
 =?us-ascii?Q?MuaL+g=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c834e2d9-7ef0-42dc-113f-08d9c592ee2c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 21:35:10.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7akCqncnba5dcCEFB7NwyBNSIoNv3K3BpMi05BJd4HTTUXrS53R3vG/7ZMksytiTvfRgKc/WwebwL/bKOOsOFR1g1qKa2PSQ9Xe287iJJLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the PEROUT and EXTTS implementation for TJA1103 and a small locking
improvement.

Changes in v2:
- removed the patch that implemented PTP_PEROUT_REVERSE_POLARITY and
reimplemented the functionality with PTP_PEROUT_PHASE
- call ptp_clock_event if the new timestamp is different than the old one,
not just greater
- improved description of mutex lock changes

Cheers,
Radu P.

Radu Pirea (NXP OSS) (2):
  phy: nxp-c45-tja11xx: add extts and perout support
  phy: nxp-c45-tja11xx: read the tx timestamp without lock

 drivers/net/phy/nxp-c45-tja11xx.c | 224 +++++++++++++++++++++++++++++-
 1 file changed, 221 insertions(+), 3 deletions(-)

-- 
2.34.1

