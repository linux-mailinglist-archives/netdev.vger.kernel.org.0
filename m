Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD36C2B8FF1
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgKSKMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:12:35 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:38467
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbgKSKMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 05:12:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESt1WW6GERx0dR5jERwRxFSpYYHBFmKPpYssi/7Dn3XaWh1Ce1z5ZqnIb3pABJaamhgp2hdE7cJBBqKrlUjhwid7jUCrADtpBIVaNsGWqAeOrEhCb955l9Vz88sUFCRneJGi9WuU0+4TStv95ord713seXyvHlOnZwtfD2bzUyjOlvVR2fn5qKERKrr6DmCsUDRv5FnG6kokvx/+GcAczCALvncHkySXMYJCV6uk5l2V9fagLTWJf4LW2MyXwp6OpnSZHmYHboM2xIEYFXYKgroPbxtbtckQ+IdoaXjUTdM5A3ZX0t5QQdLm+v9QpznPjYCfxtvflf0c3Q/wawhlFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2H+SvxMJd/TFLwie4ULP9bu/26W1+JaVGlrtC/NFXM=;
 b=J2Z031zJaF7RjVCrPZbAv8wf7sQspUqlLvYchBYKoK0FFZR0WdsaEo0V+ekjiy+mjhBqZdp1Pez89uKy1E0V5LSuMs/uc9i2LTpvt0GL/dt5H0E+gI5gxa3GtJ4tURbs4aoRmyyOzkWz+0SR8ejumCsEOwDcE9XoxMGOXxHcLzRbCWxelqz+loJhcHfEiQAHP/7OG+j28E8N4RwPQceouS1ow/2w8MD0U04VUv/eLl+zNifXquQ45M8a/4Cm6EUZedpRbvRLpKX9fJRC1iPqgIOw4tHfzf6FvDpzmVwEypj0GHrkQGGTZBnN6YbmLXqCrHeare5DNtf8cUP8G88nXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2H+SvxMJd/TFLwie4ULP9bu/26W1+JaVGlrtC/NFXM=;
 b=SvI+2PhvAJ/r1o0k9Xx5dINJnHpnXbR1FJH6pqAuR3gtapw6Y6pBGOohXqKUp0OTn26UY+TXUyG4PJbQaJsZNBNPireSaaekwLNnoiMAUlXE7GUiAO55hcVbtP8qb5L+zuH3Pz6GACdmrccRmzZhzLXT+PbCPxKf4Cmak6h48mM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB7PR04MB5402.eurprd04.prod.outlook.com (2603:10a6:10:8f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 10:12:32 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 10:12:32 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next resend 0/2] enetc: Clean endianness warnings up
Date:   Thu, 19 Nov 2020 12:12:13 +0200
Message-Id: <20201119101215.19223-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM8P192CA0025.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To DB8PR04MB6764.eurprd04.prod.outlook.com
 (2603:10a6:10:10d::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM8P192CA0025.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 10:12:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cced1271-341d-431d-c689-08d88c73a08e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5402:
X-Microsoft-Antispam-PRVS: <DB7PR04MB5402C50A8D701ADBA098500A96E00@DB7PR04MB5402.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g8tYTS4PNHqpFDYab9YDcqRAfSMdSPuNB7fGwJ6pi0OZP6vq59kR+iqCe12KXZQO+IYHu7551ABDx7mC7jDtqe8cpl8VfHrlZBxgXBnRUOfU1SixRJjbv7HFOkwm+fdragrwRYLDBA87bguK3hsliJ+V2wQKQgE7IIfBltZNADZ3l9MNlsw2BSjczO9f/zTI1Q1EOxnl70+TUxIuRGf5gzMJe+zA5e/aAWVvbqj58iG+wuIW9tCLx1oU2qQ0H/ACWk9YQdIE4/pmNjFwwIUTzTI7lmayfraTd56hZ7UhZTMHvqq0ZLLov6Ilbpuhsp4MEpY7h1hU4ZcCFgrLlLfosA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(6486002)(6916009)(6666004)(66476007)(186003)(66556008)(16526019)(4744005)(26005)(66946007)(478600001)(7696005)(316002)(52116002)(54906003)(83380400001)(5660300002)(86362001)(4326008)(2616005)(2906002)(1076003)(36756003)(8676002)(44832011)(956004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u2PX+ii9iGYk7e77PsnDPsoiuGqYXqZcCrkfeaHPaHR5iCoQ+wgEIZ2O+uZJBZvojRcY0PDdRSHIg5HVnhTNLbT9MAWla8ovDme4ftHB+kW89LvSgF7oFPyYiSvIzQOkTK6Q4Q7JUctbXnZQDYGvYBg/g8F3N0mzMGtV8tlKmD5xwp54G8e0X0e6t4FjODiQpJp9SDPfZC8Yp2XwXSVdnu5dIeOsDyZMRLHaerjT4wW0OjqLUAGmaX6X+luAgMHwkqXnN9F9KVuHwMvyvAjMr4pUTtOMrySkdIyCMEt7ilF1nWCxsVDX46x1hVlPu/zkT0N88wMIXCBNHEkG973Q09op3cd7c8N/fUbC3Iup/dI2msL1nGP/VlV5LUF47l6p1G/Tq9OJ818sFWs28Fo3eH8iNtyaySKpnNyKnLmCidWANA5232zZVyXzL/5Py24xRk/nZyNxt0ladxdL4PpJmbBPo0uD1GvAe7SjXIovrEdF2pDw1/g0g/AO9TgHCiN+Tab2RkCdxywjMQOvMhdWsHAka65Vow6dyBUf6fjChsvHt55H5sMB5qHMWEafdaRAfNyVGRqxUaMTrZVW0RCSvPDdJmUH8sM2hw8xTRG10x38rzEMqKKAwlGyymlFud5IdcOIdWmI+Xhhaqzls8cT2g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cced1271-341d-431d-c689-08d88c73a08e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 10:12:31.8472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5/jknp4XqW7/0oZwejrbTO1iLVwj2zKLGztkvYtZJk4TwiK+A8QrGHZnz1+kgxTEbwTZJD6RUUfmu8nt3guaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5402
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

