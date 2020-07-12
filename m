Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B5721C7FA
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 10:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgGLIEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 04:04:36 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:7664
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728404AbgGLIEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 04:04:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBC+2pkFVgpGGjhpURvvmYigWbIGQ3KVgOsnKGB80PSNLoTfAZYgJgOzKTN8vdb44ni3xe4w0+QpRyaURlMdc3TGJlHSj8vMSIlwxdppEjVbih8s3ea78KiYvjHRqlzXLhe1cxnDq+LdrA+JkxAE1b9qmzfMdyCdogGCRJo+UwSE7hKQLp8D25zf7DnF5C5daeo4JgLbRZ8UgBNivSqrVVWgLzTCner5lN+hR8sir1CsA7iZEKMQWiqu4R3vIdt7tBrUr12xKiPQvv44JBgXTZQg99gTSEQLPSxhSJc5wk7cLAVs7yeu262cMZa4wWwVkd51ZwV8boX+ifVE5gfv/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTK1sqSJkgyZ3vkRxQBI7kH1rDbTRwWZ+qp27QmAhq4=;
 b=I7fz054S8TXquI0W63B1CCykGqc5vzA+iKUo/PYS9aUgp7zi4GN9jdssrZgt7RA4dtUmJxhGd48QUkDxipmu6j18ta+EELrofHxVZWj6vQjAHEAik6YSx7rgaAlvqXKkMLoapqGRAUaGZ5JuB0Kns7T8mc3dAv01TC9+yubBVN9HtWSi190PfKiHGlVPlUW1YXCoAhESIpPsNmz/1Q1G4OTvj7BdSE9Qk7ZAHnWZJ/3rlloWv7MDsjr1rGTJEtye88RtLTiinzSL5c3LI0fmnoYAWxsOLY1HH1NkebBnyN+ABq/LVorXfGwrwouAyC5ELhuIEmeWrXqcf1IoP2/f0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTK1sqSJkgyZ3vkRxQBI7kH1rDbTRwWZ+qp27QmAhq4=;
 b=KqrjbTGaVjUCZHTW7GP5acBQvCAlBdcuNY/syarQXjwQS5SCP0atdnQapClWYLLmpAGViSU4yLxg2bHwfX8rSZC2cmWwhAIC4Bl1Nb8C/aXDBI6rfTpV4S4OGVtFrZJSUZIKctm24ynpxzWoE5lVcj4HEA9ZKc4sDrlmkP//yPo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB5634.eurprd05.prod.outlook.com (2603:10a6:208:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sun, 12 Jul
 2020 08:04:29 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 08:04:29 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next 0/3] Expose port attributes
Date:   Sun, 12 Jul 2020 11:04:10 +0300
Message-Id: <20200712080413.15435-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0018.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::28) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM4PR0902CA0018.eurprd09.prod.outlook.com (2603:10a6:200:9b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sun, 12 Jul 2020 08:04:28 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 46cdee9d-8fe2-4fed-8039-08d8263a33cf
X-MS-TrafficTypeDiagnostic: AM0PR05MB5634:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB563438CF7FFA8B8588A3AFE4D5630@AM0PR05MB5634.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O6GbCFfs+gKEiPFp24Z/U9hONtM/MuOoxL5Fv5S/KErgmT9sxCfQBGu7wle1I8sCKMpJv43Mq8E9F4EEP1fx3QLwHDqdZwCsUs+L38I6fVXxWQnBkoOl8ge80boLa45dN3w2UF8CHnlp5ylRW2losstFZL8pNXq+AzYtyzt1TxJhqnrpNMVRX5OfiYGxSzReYYZCSbcc++KKPRkrIsbhEqdS/223ikTPl/txDt4e6rYbP5xWyQwJXRnI2sLKY3Rl0zLy8H1r8OgirGMbEqM1t8FqcvEgxdA3MgvO09k/m345aBNAhAqMLp/wsq4el4nF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(376002)(346002)(366004)(396003)(107886003)(5660300002)(6666004)(316002)(1076003)(66946007)(186003)(52116002)(66556008)(16526019)(6506007)(66476007)(4744005)(26005)(8676002)(6512007)(8936002)(4326008)(86362001)(956004)(2616005)(2906002)(36756003)(478600001)(83380400001)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vJjG6XB3c8Rfxxf7qCjRwifLu25GY/POEZvTG2Pr8Rr7hlg5xYB6it6Xz/WeFZ6Hmf2OOZR1z/cZ4bOBhAqGVhOiZwDvOPldvYxfFUIySs27ojVgbVYiI3JM4KNskPp/tzt8U6A/dqF74dzgakd4LGPjw22KNIHCkIsy6dfHlo4C3HFU5S5awqrGcNCqoq9ty+Dd1mBBHtPYT9QB+xDHldEKHtWvndr0IfKjZJyaSUe1oKbpPrOi4iYoDKh4FoRa3Ob8pVpNS32RoKYFinwPPBZEJ3ijOE/HsFOE8u1nm3uaES4C/VzQRo1IXnGwkrOkaqCgvOPVf46gsxTOliKD6X7G6rSg2u5u5cPQGvm9zeF52fFw8da7Q6qFz4QeXqjh6/VnIV7GvuFF+MipzZ1BFIXPflfIGN6UdrGllBihJ59fryqzVE1u+N+YsWoxVNmm3TJFcGfUhKRF8Oic/4VEVyJonMIzITjhdkhnizR1nHI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cdee9d-8fe2-4fed-8039-08d8263a33cf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2020 08:04:29.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/nyNqz9gd0DYpO6WAFt143N1UD7XOsnevtEMivUXYSSY4QUHQF5VI/wJyIUg7P78zyJdGZhCs1wv+EGqT1y9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5634
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new devlink port attributes:
- Lanes: indicates the number of port lanes.
- Splittable: indicates the port split ability.

Patch 1: Update kernel headers
Patch 2: Expose number of lanes
Patch 3: Expose split ability

Danielle Ratson (3):
  include: Update kernel headers
  devlink: Expose number of port lanes
  devlink: Expose port split ability

 devlink/devlink.c            | 7 +++++++
 include/uapi/linux/devlink.h | 3 +++
 2 files changed, 10 insertions(+)

-- 
2.20.1

