Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E5E27CBC5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgI2Mag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:30:36 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:56315
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732295AbgI2Mad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:30:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6iUkzzuvfSAKVnit/Pd7qNWcRnDAkC1vX2Xd5QumWNoLHvbdoHwImGU+QopknYbpicTDtFhEUImRAUq0Pg84wUYtyIMfh4TOtsKRgt/6NpPAj3S7B/myL7lUjD2Fw8T8RpT8cwYjDacVNpkJzS2CK+Ia6izQMNujZjlNBx/2kbvnzqZHrwYm1Fzxc62z+BAyZ3/NQTRNMiTyclRQSJAndFYJeO2KvRZAKpx64bIWrQnE+NPJpi/e22/IXvlPnJ6dWmTeZBPkcMlhUXzOM1n2zKyZOpH+1rLz2ZDsW/iyxqhki6+LUiTp8u/B6L6CzuNG6vnjGT1razaITlZ7YKClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA5KhoFogSbt0fcvb9wD4jdJAOpcV8gsTGAd8jIs/do=;
 b=IjFjpxStHd3+ThyNG5Ye1iSl75Aw7xsU97v1lWOzveQOgIW7e2tlLmi0Op6sPBNSxWE/xiQiSCx1ln7r8KaOyY/towAQpKahAVrAVt/2oMu/dQVeMO1UVwfy8c2zSbMu9M3ixjtVrQaJAn4QQGoqJl4oTIRNOEYJ8XEACfHMf69ekKbHVPbR4twzlW5t6wj+IIKmCWbRb+yzzY3DmESG1haP21nnthz97vB1iEPm3DDpsL3mU0VyK7cHj7gwTCgVu6wcEEVWfWlIvb3nAHTTZyMoeW5PzbIqj30q7R49AApir7EVZAzTHssD5C20H109IsLgbAzDNwRKORxWouFOFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA5KhoFogSbt0fcvb9wD4jdJAOpcV8gsTGAd8jIs/do=;
 b=W6pqbtu9EFvIsW8yOtlyeF1W8OkGE5J/XYRFgdTSuV5c5PJnT8e1mlEeUxSkUvyfYkKHkcmfeeQKDEtw7ijmXEQ09NoKMWDYlfFokXjMgUcPu2DDkXnKSsmy0sfJ23SfpvmvRh1sBXKOxGGq5rJloceI8s9w3RUwvc1KItLQyr0=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4778.eurprd04.prod.outlook.com (2603:10a6:10:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 12:30:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 12:30:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 0/3] patch set for flexcan
Date:   Wed, 30 Sep 2020 04:30:38 +0800
Message-Id: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0063.apcprd02.prod.outlook.com (2603:1096:4:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24 via Frontend Transport; Tue, 29 Sep 2020 12:30:27 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58990bbb-acf1-446a-abbf-08d8647372e5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4778C1810DFE10BBA9E8EE16E6320@DB7PR04MB4778.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4UwPNQCI+pp1PnKX/BEIXpJN5sPw+RgphVFuL7lmKOsrzN0iBZHEQjrEKfajHTl89rH/Abvrk16/oikC8ySnoOmNBFQD8HJCQSJDTFxngXscyo2zO7XvRHmapQeKL+TX/70brwrxHvv8M+UyIGoNItCYYU2WPiUabWsuj9ZtjI2Y8g2+KlDKxPZgoWZ0DAapgca3R4pyRDW12dVpJbjjaMNeCM/uy4IUj/pqor5WOUfflgG8+TcCvB4QeDr4ERqnb5zbpbmmSkSme5H9sr4qXxFYKeLUfyrYbEsE5rEmSiGzI9rjYBpMlejKSwmF7IdrZtW+zlWK1al/jV/dToC7cGUAaetR7VoS/sft2riIroWQs4sufEMavS2cc2ES5SVY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(5660300002)(36756003)(52116002)(6512007)(69590400008)(4744005)(8936002)(498600001)(2906002)(4326008)(2616005)(956004)(16526019)(186003)(66556008)(66476007)(66946007)(26005)(86362001)(6486002)(8676002)(1076003)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wptP2YZLT6u0rvxnTDqYwzPHnsTEET3jcetrqjw5w+u2SEy14n5wbZtaQL3kPeVRUVNuyVORhQSLsrfTybUkLe8HTEMEMNMhzRXz8G4OuHL5WtuFcAzpqCNTN2UBagRsQdBSaK++OHkrGnPpIbvDxtwC6MpWkiWMk5iebTL2mLJYMUZzOrTglybi7GZJThfwOwMP1giQOGdjfO/1UUBAZrVwO1WkHSnE7rPcIi4vA33cFG6sP4yGGShxl03zBG8aNCmiMpgNJ20C0ooZQhXEtCwRjvZSoqEDIu8Od+JnYh3SbNtmfk8YmKkPw96oKW5HM9fVOpABrBmFC1Fub0k/hi3DQzvYN5R16J2VYBg/fLarXdmYxAwOlDneXBGqZDcc55Bd+WN+Fg1ujwKBVfVr0PjGnuL3D/eb28/CptDbQRj9/sLt6jVj+R5i8A3AHGqfaJ3Z+JSUL122eHxZKBb7kZk7DMgpPXgMBzM/m9UqLNW4g2KIgXj/DHNVhovYzsD4O2kYPIKW2S02ungd+o82ubf87ivpNZORvy4ti4CTOfdkPtfa3Oy5o5wdsQEtuD3jeiurZjXObL40IxyxiODgQlHX9mDiqEXLW7zS4J44V+I0PCtKZX5eIHKrPbbfXNNtauZU1NfmD3nmGHQPyvt/Uw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58990bbb-acf1-446a-abbf-08d8647372e5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 12:30:28.8847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: So59VCu3D4MlVw3/LA76oq5w717zH5OWe/wBp4KWlsKZK+3pKIpC8GrhYdHZJVW4qlHDu/oAuN8rCUl6sI3nXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Flexcan ECC support.

Joakim Zhang (3):
  can: flexcan: initialize all flexcan memory for ECC function
  can: flexcan: add flexcan driver for i.MX8MP
  can: flexcan: disable runtime PM if register flexcandev failed

 drivers/net/can/flexcan.c | 62 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

-- 
2.17.1

