Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C392E2B6D2B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgKQSUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:20:23 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:10111
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730534AbgKQSUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:20:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX5X0JMF9G3cCC2gLURDnxxKWMWGdxsqYd9kp9dT1QgcMSYD1PAq6Si1oovuHTJm3uwvlET/ZFOiKHaW+G6e61PiJZKVOGu/UFq5BHZGyQTD82yz7p0W6OyymKq8JgcDg22LHocHzvOfRXoPygTVtotbCT6HxadCpW5nXiEV4/sVwx6TNTCz+l2e1X9/2EF20imPjN0j07LuUbipYxO8OBhzRiWEOnN0S4E99xXwmR69s2X9xghcXHDqONTMxZ2nnGO2zzX+t9JgbyUvLPiB3tmO03LhLQfcNDji1Gn8tm8szz+M5gRKB6rdQo8EGBysO6jsZwbasf9ewdjGycHhfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2H+SvxMJd/TFLwie4ULP9bu/26W1+JaVGlrtC/NFXM=;
 b=f2sMKOh1GMTLoKS/zdyrqeZcz1gSqzN7hfsUg9agIdcqxOgjcTOEaplL9IMaJk81eqhy2SH4sDoXkpylcIlko9fi9jxS/GaFGgWoxFX0QJUWKwBkRr6yzp3T/p3k14do+RB6By4SpKqY/oZfkMXDkik5jo/pB9v7Hm052Dq1i5Yqh+7dqCz6OJlXpgbp7M/KBsmMC9XBTBjg+3yKcPsxw5uVGzo++djA1aerV+G1wltquLMD/O8ZDIZ+K1jcTBEZ3KfF8uk0A6AOV7saB0mYVd9DUc47rdkcSfR2JsId+0NzFb4shwSEbaxoIaR1XUdHpirLLZuSmYSqJrj6CeupwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2H+SvxMJd/TFLwie4ULP9bu/26W1+JaVGlrtC/NFXM=;
 b=RowIIFFVeH/7Vx5sk1hHzNKfcIPVxXpd0BA/MVkxcTf/c5hZR0LscuspsO91qjV5wOmW8Y09gvWAH+Pl4jAJNP+NWO9qgiMtakrDkJnKv4fMvUck34LhgTYg9QmtDC622whsrfIOT0WrLRDo6Xs+2VP565WHmF9mIAutTEXV2/U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7473.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 17 Nov
 2020 18:20:20 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3564.030; Tue, 17 Nov 2020
 18:20:20 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/2] enetc: Clean endianness warnings up
Date:   Tue, 17 Nov 2020 20:20:02 +0200
Message-Id: <20201117182004.27389-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM4PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:205:1::35) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR07CA0022.eurprd07.prod.outlook.com (2603:10a6:205:1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 18:20:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc4d1a3f-6c90-48bc-6ac9-08d88b257111
X-MS-TrafficTypeDiagnostic: AM8PR04MB7473:
X-Microsoft-Antispam-PRVS: <AM8PR04MB7473682CE7C044AE87A13E9196E20@AM8PR04MB7473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z6ti/EMDVo6kuna27K38o0oE9ZYAUnrsrLG8YFAjcHRyFHd7k6awY7YpjPNEW7MEPohaQOWQTzvO5EkNSGgLmdGyS991tVRSz+rS9pufARpFl9OuQPmm7ZivJV5nKk6ZAkGv2uYTo7M2TJhUk3V4ThBrRaj5vvjIDgsWzSvk4HM6x4ezHj43RhXKiXEbXvzj6XdtJqt5Nku16nxRi28YiJCauhK9QUFE19aL3pOwQxZgoPffHy8WxhlQhQmxQxAv3q/t2iRWpNAgwK3as340pHBW7Q+ZkVKwmQGI5mEv03z8DPM/Tk9nWDPleXNijo3WqRillTh88VpcEUrNNfGeXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39850400004)(136003)(366004)(54906003)(478600001)(66946007)(66556008)(66476007)(44832011)(2616005)(26005)(956004)(7696005)(52116002)(4744005)(6916009)(36756003)(2906002)(6666004)(86362001)(16526019)(4326008)(83380400001)(316002)(8936002)(1076003)(5660300002)(186003)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NVXsz4UoarAAy/DH1YTH4juFEOm80azcH7JJiiPQgGUv+FnhaNlxCQviBJNTKQ09rXDzLocs496q+otwRwenBi4E+/+H8YNM1S5GdaL6eRFrLE0RnWaHoPIGq0KV8NHBuyGZ0mWavLvff/R+t6mrI62W2x/EVgopVp5zdU8BgRkhVICEEKp/j+VErUxRIrssMFAadlCWwbeh2yzm+MGggvGABz9WPo7YmlgCmD2yBFZlXH28ig7ruxHTnZ0Bqo3Y+MGHcw7T6a0hsqdmubogg5bSPGv4kWruBocHPn4sfVHOL2MEIhsHDfaofah+SHzj/71YqWMFJTZchADHxyLoFcqi/2BfTNSNLxHzWDa+2aiakpGkuis1D9A4/4jCEDIOxnAe1ByB3invccnerz4Q7E2y2CqSh8oK7HmPXmHLGdYiAoqLnT+vU2EJmfKC5X5eMiy7P0480JthSFyJucl9n+Ev21HsuszFGTzzgEyUlA3sKTK4GfGMlq/wM5/79emi9SIM+w0wS4RnZv0rcSdQo8b9STDNlK+Au2cWOJ/ADjFolZ0YkgzoeH6AjeLqhOjubbF8E0T8KMf8Pl2JZiyBqghLU0Z06zjUTTqZyWqbZ98y3E6kbMpULATPf3wkYNSzugRqA8iyyq7VU5p/l2/2vQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4d1a3f-6c90-48bc-6ac9-08d88b257111
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 18:20:20.2061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3az5inCtGM9OULvyQOcA/dZ9KNrswCWaWLBuRKBfEFqjJsFCUWv3lIxXolzvcv7n74jiZHqmIlPGnTlyRXJoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup patches to address the outstanding endianness issues
in the driver reported by sparse.

Claudiu Manoil (2):
  enetc: Fix endianness issues for enetc_ethtool
  enetc: Fix endianness issues for enetc_qos

 .../net/ethernet/freescale/enetc/enetc_hw.h   |  8 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 84 +++++++++----------
 2 files changed, 43 insertions(+), 49 deletions(-)

-- 
2.17.1

