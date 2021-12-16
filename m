Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C7F477023
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhLPLYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:24:37 -0500
Received: from mail-gv0che01on2122.outbound.protection.outlook.com ([40.107.23.122]:24833
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236588AbhLPLYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 06:24:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GM3lxvwVubLE/VleyT34rxrHItiBQWrkxSKzpxda5P7AoRL47BMJ2mjcc3ilQoVf/zmIFWzmWaJLV9cRFXra8pm3iPxb9igIFFfgwwctcXiuuv46JY3ZGQkl4z/pjJ2DFC4Spp5xhbSkujfO8ClSxz5G/cypSJAN4IdtXNFO/v28Q6wrYsOi/nUvPYFuDVfNKvr4/28ybXi57yY6qSNyYEpdfs3CdOPc2PwOOn20pc21btnzfum4nQxA8u2qIsH7xB83VQFS3mQAnEW34xdHeWNUBDO31LC+xyt5tOcQi2sg7APqd9UMl9CQrW1OImzNFDZduPwONFF/aCCnc6U0MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jG/DqJzHjGXmKDPLbV83zz8P3doff1ZEcJy2VmhCrEo=;
 b=OwCUg8vtW1EWr2jS6sAuCHbKy2Ncmn2r3+nOrfaU/kbewA6uX/mE2k9c5IJzPo3+1P5dKOLREEHfDb7jNcIkBWsB6HmljzbaGjGuHOwbhR6zBuxUD4UJ/DdMT/aguEbdcCK4GEsamn95zJLxpIYQv2SSL6wjMEbHe6pshT13G5U7ydEW2EU9gwHmmBQaQBgntylxFTxCvuwz4bL+Fsm92HOYvFDXznK/aqcJ3rvmKbc8t6lLRJMNy/xaDXL0wVp6Ch9mInejuG2q4s7IW90CGmed9rQdwJ+S4+0Qhad3lOlJdV1RHWSopxipWTWJ+zLHbHx09iwQ0bKyVCmAUfHb7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jG/DqJzHjGXmKDPLbV83zz8P3doff1ZEcJy2VmhCrEo=;
 b=dzGkW5+tSJCiQOViyQfOS73DY+jgZJ33o18VTNnJm/NSAavsiSRzEnRIA4rDNmEV5ggLjp40pjbuOZucH1j+lgtwWf1GGWZK4xIUKuA3gvAeEghJ/fhNr+8X73URtmtgxY2thGeydZOhLME+ScoyzWfEXudYCfkF1dfzvp06DvE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZR0P278MB0250.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:35::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 11:24:33 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 11:24:34 +0000
Date:   Thu, 16 Dec 2021 12:24:33 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211216112433.GB4190@francesco-nb.int.toradex.com>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20211216075216.GA4190@francesco-nb.int.toradex.com>
 <YbsT2G5oMoe4baCJ@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbsT2G5oMoe4baCJ@lunn.ch>
X-ClientProxiedBy: GV0P278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::11) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce3530c9-b7a6-49c9-f0cd-08d9c086a2c9
X-MS-TrafficTypeDiagnostic: ZR0P278MB0250:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB02503C56C5C6E31A9DDF2C05E2779@ZR0P278MB0250.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SaVtg3Oa6kBHZ6KB/c0qQag2uAZL9I+qEKFUzDeaHAzwn3tWweop8CsfbhGHn62FhgVRNCMoJDpzvUasTJLfx2HM5jWScmFy+kXfZAI9a2crfYM9rIbXKQAZYUBzfecylMgPSbUxdGiAaHk15YzKAPFnDyYpag3a9x19ApB/AEtc5NjXKoFqrRw9Fae7bmKuhnPkGEpQQUfMGjvLUDUIHVqpmFbCG3oyRcv9tt/QlVQ8+dg4VsBxE8awwQ/I4EmzevCXXAwIFQHuQruda+Heqi6Q9PS4eVzhrkEpEFMsK0/EgHwZgK8AQFxPT2BJf6xASdbkbTea80Y412MCPJKUU5Av3c5LJj6Q3DsnXu61GkcbiqY4L3RKl6a858LGz8NXx+46CYNkh+EmrLl/mlGYS4KWsLphuFOSRxF++8UnWAS8lk17HXCB/DBSq0mHme6DP0WyWdK8Bjl//doqCWPk6s30u3T8hphSC8jq6J80s/yIppIsUAr2egyC+IQzB71K0/jfNwOr2lqRb2kr1i/+6pefGfI0pptUBjALb5TinErEr03zoi3U9Wtu0HJ9+1XPT5X2Uopy/IPe80FHEjjFlPu5cuVTtsBuHRjKi58B9qy60Oo9TBOJ9a4GHhgeIwdrA9wcN+g2UiRzIyPOvCdG1DdezzWDzuOYdCNMWjDgI6p2v2JWWSHJCz2bR9S0FbTpEdRQD+L2CdHamgP4K8ja+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(376002)(346002)(396003)(38100700002)(2906002)(86362001)(66946007)(54906003)(6512007)(66556008)(66476007)(8936002)(52116002)(6486002)(38350700002)(33656002)(508600001)(8676002)(4326008)(5660300002)(44832011)(6506007)(316002)(110136005)(186003)(26005)(1076003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jFqFKTXGZrva/nBw5gSbwY/A+4i55qbq5D31hIY+wQ7SfDtaKT1uo3Rtigea?=
 =?us-ascii?Q?fbUa/rH6flkW8AzHFbm24spufGVMoLp+iv8swbD38Ynv5Yb4ip+mE0QYHo+9?=
 =?us-ascii?Q?QzF8xBMrSXjt6/HjFDlAO1qKLnQaN8vAyVf1o6hvRIAskLpzWkDl47YGj6FF?=
 =?us-ascii?Q?1UiDwUzcu3SAZGxRCv6H8U6HuA7XkyWaySV737CsybSm9jccBcNKU8DnvcDC?=
 =?us-ascii?Q?2wUIzzZyHmYuao3Q/3hkycXCTO5NxcUfY2Vd/BK5NiU/zBvBYLdL6e5vNobJ?=
 =?us-ascii?Q?88RLGRk9/RTjRFp+GN2tcpovzEIUwimt0jX/JrK76gOgk66W7TDMquIAiPRu?=
 =?us-ascii?Q?2nuT30mAvN26T8hiA0Ecpy/qa0e6SOLYFIs4VcoPVY9mQqaEu0Gxjx7h3Rf+?=
 =?us-ascii?Q?Cw+YBPOTD5agh/j+WLaIPEV+9g3RPVjC9YxTQGfKtN5botO9Cf7UQNTbyqQ9?=
 =?us-ascii?Q?yojC9EMHzGTl7VTTSHlUNMAEAawLtTL40Ck+r+6U0N4xAq6yX40j2+nW6HbD?=
 =?us-ascii?Q?CcaW8qaqOZXoBcLd7rItly7bxfWcKgB1sNu2jk529fle0wOhHf5EOGnjyqzX?=
 =?us-ascii?Q?MoUka3YxuaJt3qjnsVHT068ZYY7rUbTVM0tOs7wPN2bCm3FptLt4R/G+tm0G?=
 =?us-ascii?Q?47/rwJL3wYrv8lPNLomPd/t8Q8MVJ563Ho2BBtavNjP+VFNAsfqi69s+2y2y?=
 =?us-ascii?Q?LSOng+BmlkmFDsdjTU0KXoULaXsGJbmla9zyNZGz1wJjb+cSe6ZGm/PCSjQK?=
 =?us-ascii?Q?A2wYOnKeYfoSCuTu4GQ3Fek1H9uZFPAE0jkQz/dvGvB5VDcQoQFhlGu5lPwX?=
 =?us-ascii?Q?7pSozEOdZ3bsWbIDUxIGoALxJb8j1TuIFivNyfd73G1t++9K8ZyD4CrprU2N?=
 =?us-ascii?Q?9oKHF0pXCCoTkXA+gLYoHCyQFMGDsF3rAE2yWDTf/BnrOUJq/EjHXV85drBT?=
 =?us-ascii?Q?1N2AnFWVHummuk1P+4HxUMci5PK1MGUzY3N+/je8vq31BjwLMcRWFQFDFxxQ?=
 =?us-ascii?Q?HYByqpoYSNwotUjG+ASSLe79hQKLcNQ/sR+Ople1XHMwtoBr7QenZztEl4c3?=
 =?us-ascii?Q?kgEEccQM1z9YMDlRI2Ief9YND0WQO1GIaXdMwGmeat/yqP2zZER9HekBrN+F?=
 =?us-ascii?Q?EZ9/pLDV/dBVQ7B8ZGUTGmnYxsiaqbKam2pKsmlnAd0gras9Il5+VKonXI7b?=
 =?us-ascii?Q?5zq1hPxyn31go+Do3JRuVqJAnUtKEqYWcOqV8wI5XBvy21JGn8HZYR1kBWNQ?=
 =?us-ascii?Q?nhe6w3TCntWVrtDeUZrR8NNFs+IlqH8FTqHGbnlCha6cfcGjh1iLTXMeBu4v?=
 =?us-ascii?Q?gaTBO0JR1o18izk7z1tcX1oopTpAtW63nnOTw1rIgwHVQGLurxpEEx8Hzq64?=
 =?us-ascii?Q?StEAiKTLWkU/7LADPcIQ6K9w74z/Vb7quGgDcDPtcsNedSk5MOIeYmWd6/J/?=
 =?us-ascii?Q?YK83MecZKOSg3r8UdGIx8Qr00nu9ga4c1Za1lySUa3vIZcPsvoe6oHvHbho3?=
 =?us-ascii?Q?Mti6RTjDtWEvfLUtvZmXf/39V8oCK38ShbrpuWUcivDO76EKBH7JS634DCfm?=
 =?us-ascii?Q?VkLwhaqogEeQ8HtqQc4+9CMGkCIDuc6vc/5Boez808iJtO/K15D4GnbL7VrD?=
 =?us-ascii?Q?Ye023buZZIYXzK0v+tm1l0a2e7PUdoJMalqoNOaVqDKbyXWWt5q+m8Z4WkM1?=
 =?us-ascii?Q?55Y4iA=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce3530c9-b7a6-49c9-f0cd-08d9c086a2c9
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 11:24:33.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ssmUqZnfosyRCG9ftKpNbdoscszTAsNfh6xxeOXXeosbvccGTuw530dcnZDIhRxx32oT/GMjArsFbp2jaNUJdxtKSRNGgGkqkF/qheGokiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0250
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 11:24:24AM +0100, Andrew Lunn wrote:
> I think you need to move the regulator into phylib, so the PHY driver
> can do the right thing. It is really the only entity which knows what
> is the correct thing to do.
Do you believe that the right place is the phylib and not the phy driver?
Is this generic enough?

Francesco
