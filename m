Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4DC2837BA
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgJEO2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:28:35 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:62374
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgJEO2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:28:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwT0uTHbG5X6n84auIh/yGv6WljGbk1IDL805OYNoKLail0VXKb3wBRWQeLZJCBvZdtx6KoN8VavX+MsKjZibjQGylYoQuIx2LW0WIkMSVW793L6tfUlD6TgULSWbsgLP23Yqh/GA4xkEwFXK4la8nWer8iqraQ7YWWMZRJ/wu4Fsmqu6URTiUEZvXJrp7ZcKwCKcFJVosdYDvbLB6+OeQFs+yJnrez4OIlWWLP8daa23YbDtG20lJZjej2zD75SBtvOCV66PEM52s3T0rEld3qXH5TfE9KqEHB/JK3w4eoEBf6svV8MH0gUI5xfoZNgVV0zlxUDpKks5Q4XiAZwuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36//xmO28DgEQkxq6VKCMxXTdBFA1FKA+0+DVkpRI/U=;
 b=l2WcD1Z+QDPpAIoqyIgRSqi5rM4vNCcN4cEC6NGWqoBDLKmKSfjXJyN8nEAsWykwxLm99fCXcVcupTfu9NzJ8BFn4tlQDfxPPBMmaRFgZllzxz80oIB1ul658fMQjZJNGo6WaB/uS9Qw6bP4fh7oZsDsZknEWGPdlfcAhb53xzWWU6coqGJzf6qnIwaNhYeYEridykoHXik7ImYGknDX/8mMOH9fU8aGyFPDHPJdYu/EgZ4TUaNZ+CFVd25ih8Df3UO32/V8Dro9bM5RUWfO5TsURmEBTKDK0IPtsLk86SDztolYR4nkpML63aMzQyemgTD/5/179ksBoSeD0m5C/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36//xmO28DgEQkxq6VKCMxXTdBFA1FKA+0+DVkpRI/U=;
 b=TABG4IsEgNQqAMol4xOIB5+Vo2uo4eb1hthyvC8ykAj14b6bdQoF3XuBcUqpM0zN+9vi2UKghBNo2o6KUSc/E4XN4H+evuCmoDB1l4C4B5JbizNDQlRN23w5BeBbcTITrZD7aZPDG7z9BitPBbOF4umNMt1pGdVLiwFZLMUtV1g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7171.eurprd04.prod.outlook.com (2603:10a6:208:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Mon, 5 Oct
 2020 14:28:32 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 14:28:31 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/4] enetc: Migrate to PHYLINK and PCS_LYNX
Date:   Mon,  5 Oct 2020 17:28:14 +0300
Message-Id: <20201005142818.15110-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR04CA0060.eurprd04.prod.outlook.com
 (2603:10a6:208:1::37) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0060.eurprd04.prod.outlook.com (2603:10a6:208:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Mon, 5 Oct 2020 14:28:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b203576-fdb2-484c-c893-08d8693aef3d
X-MS-TrafficTypeDiagnostic: AM0PR04MB7171:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB7171967326900332FF8AC0A8960C0@AM0PR04MB7171.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMashCTmS2Qk8YhWg2o9EeIK4ehlMqy+cP6KbVkJ7P/bR0v0zzDTB90UQajpTCqyqMdH0kClAEgUv0SjIkR2xSyzh2U/hnzh2l1n2qAH5fxfkVFzzA8CkuuQNz0IE/R9Mu40A9hdrr2LuVYYUcSoV7zvMCmNOzKBiCRHMXO5R5lAOwXBJGRc7V8lg+WTSAXOJnhDdP2jzPOyVQbN798HgnFuULgxz3hNZ1KyJr3ak03lzqiFZqVBQja3aeRGjf3NB5+17M+KQ9NWcD62cQBn1sAysQbIzaSkPvNeMrX/zgwXrt7PZ9BGe+GxUtvrA+MhZ13noeRGiaxzvO20ahfNeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(36756003)(6486002)(8676002)(2616005)(4326008)(956004)(6666004)(2906002)(7696005)(52116002)(6916009)(16526019)(26005)(8936002)(186003)(86362001)(54906003)(1076003)(478600001)(316002)(83380400001)(66476007)(44832011)(66946007)(5660300002)(66556008)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SHoeWAqWIXdvoae0i5B9nAM7vNUnK9kfohOKfzLsxnmwzx7npUCXk1OX8wtx8JybnHUGBCggDJXSuTQEtcwHLprMyjYu/3HoSkoyfx0C26m/6HNkN7Y+VJK8kvvpieKcYmRKA1NGNyl79nuP3Kivh4AQRcMkiyt4B01CxqNKqaF41M7Ap0XNLOkAvwns7eG3k+XmxK4np2XvMe82gOSdG9YAQljS+bKetDJ3VdkRwsWAm7+G8rOhonXPVA0d45J0OxxcVNqiREuevS5jUtZllshSrpkJa/ywouZMW8gurjeQ9+34O5nlbGtQo+R5o3JDxANtm1Js5hZ5BvB8wA9tyhOIplRWES2jdgv0uV0VT5TgXJKFo0txhqZqW1+AjntvwnjN9g+A1swjR52JsfIYDYNyMmwuBMxPQ0JCuCuCFiiGmsYZCYzPyxXyl761W27eH8wUus174SaDVj2p8PrGrtIKnWKf14niqXFxyfuf5VnM2xjqGKUiLrqA5x3kwsvpnOmnOOOGY1ayGqwRrd8V/4wfNnmHypn0UZ9C3LAG6cUlB46Xg6CdmMs1QPF6d4J5LI1RcDVf8ZItM9hGdVz/kx2SapFsSAkX70cgnHgmBl7yrERtmtX5sikxzkHbnNtpix3nCLOLMI4/XGxKLasZBA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b203576-fdb2-484c-c893-08d8693aef3d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 14:28:31.8566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSK6c+gk2s2HAsaOkH9J29BQJSWpg1EebBfgoWLZIxhpQdBocayG5rxH8+X2ty70uaf3QMnZD3ItC3KUQNUb/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7171
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transitioning the enetc driver from phylib to phylink.
Offloading the serdes configuration to the PCS_LYNX
module is a mandatory part of this transition. Aiming
for a cleaner, more maintainable design, and better
code reuse.
The first 2 patches are clean up prerequisites.

Tested on a p1028rdb board.

Claudiu Manoil (4):
  enetc: Clean up MAC and link configuration
  enetc: Clean up serdes configuration
  arm64: dts: fsl-ls1028a-rdb: Specify in-band mode for ENETC port 0
  enetc: Migrate to PHYLINK and PCS_LYNX

 .../boot/dts/freescale/fsl-ls1028a-rdb.dts    |   1 +
 drivers/net/ethernet/freescale/enetc/Kconfig  |   5 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  53 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   9 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  26 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 334 ++++++++++--------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   8 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   9 +-
 8 files changed, 242 insertions(+), 203 deletions(-)

-- 
2.17.1

