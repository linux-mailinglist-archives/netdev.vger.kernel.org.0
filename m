Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3A22F8AC9
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbhAPCkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:40:52 -0500
Received: from mail-eopbgr40114.outbound.protection.outlook.com ([40.107.4.114]:48708
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbhAPCkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:40:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Md4y9D+ZXSUHp8V+ydmUp8iVvtKVaDdWw4ZgezRWZpGrIcIojxH+inaRAdlwoclkDWbVwFhQ9Ph3DZjreg6+Jr2rDiYIA6/xzKlksLz5ybNvWdtFErQjw5azc8xSE8v0jdqEdRL+tFPFkeFtUaQVJ3+/VQ2NbZLLk4vwhr2MNeNfs5Rz9ZBVUu8fto3kVBDhLDUmj3FiusBmfP+lJcQMxAhkSYK2g1mf1m0U1kf4WJLOtQVv0uSzfUm/FEtpv3bqUONbmwo2sQIt1oF695oHKP2TnpwvHFGy7XjR9dFFclK+RPTSjD28E0gECaDJXU5UH6PcLC8te7GcTJmgnPvIDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpFtAIBBsHAL+SMnjvZ7yvkQVUVn/c0QitcPp8UlUqE=;
 b=kMDAWxsetkJLT3nPxc5B4L5w3MQ8KwqVorxvPikKfnLHbNMtJ4HViK4BVdbCI6dWqwL77wU3ZqhzVdL9zWR/wAq5bDsZXV4MZGbbH3lV6fnzZfKzm8wiXxRbN/2PNtok//u5NanEA5fH4f+9gB2PElREVqbAYJVxR5GMCBswyWLk0EN049QI4QYgumqwAkWfBOrCogM8oYNtdYqY6iTmTb3VFHxuBGs8jxWuFclNHzx3oGHbJUkGUYhTuLYY1DagN8LeDUx5VQpNnezGAbNttQtE2t6RCp7QYyui6lAcioI4nUZqgDEyKitC8XXR/D7eIcSwOQDVGejEtu8vUll57g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpFtAIBBsHAL+SMnjvZ7yvkQVUVn/c0QitcPp8UlUqE=;
 b=YaLOtlEVJogaAPwHSw1tn5XlksuI9i1gHPUzU8zoaLMWRyJBzwDZQYtjooGOZF8zG3uEUwnIlPmWNeUcH2z7Yw4ZXbAwpccgDxAYCbSB3Vc1oVeQJ0BlflAbb+JmuXtY8NZBh3Bc9Iv2hPdEuhYearQ+ZedRGVrutmHG3CAfbNo=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Sat, 16 Jan
 2021 02:40:01 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.012; Sat, 16 Jan 2021
 02:40:01 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 0/2] net: dsa: mv88e6xxx: fix vlan filtering for 6250
Date:   Sat, 16 Jan 2021 03:39:34 +0100
Message-Id: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0601CA0025.eurprd06.prod.outlook.com
 (2603:10a6:203:68::11) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0601CA0025.eurprd06.prod.outlook.com (2603:10a6:203:68::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Sat, 16 Jan 2021 02:40:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb225d72-4d30-41bf-ff9b-08d8b9c805a4
X-MS-TrafficTypeDiagnostic: AM0PR10MB2674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB2674E9CCB7C5D85B6267B00393A60@AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tfmnZGhThzNX2vlCCPSuojHV3rsqTtsPiO689Ew3x4uC3PDhG280w3NF9E8RBxT2gSKM7G1qGimza8+6nMKAUPigEkS991Ag6G6o+pw+uksEGf3v5Li6imvORnpN2XmTu96VYA3kYxGFfxOyfm6HlYGvIjM+i4rRFvMxVjyVpClhmn0XZTejBvO+8Stap++zerX696s64LWq0ro1HzOBOi8HiQhd4asSKHMc0wFmPrwUAZnyhBXHZ+vLNFLM6pusT5o47xjTpIoKnBy0wvNizIVs2RyR9R+sjg0rkl2OI66FoCpNZNvahnMpNiujbd9c8CrESS4J8XXlLfN+ArQqgHe+v0V+ttFDfDgGhnOsPVISk4pziIgmr9kR9b7+o5JwLM1UBgNqhSzSGA14JsB62XiHehigG0ibkv9XKl3MhhOPo3uTxLKSMNXlvlTJUFEvQmrr1E88B/HwULyuDqf06w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39830400003)(346002)(396003)(66476007)(66556008)(66946007)(6666004)(4326008)(5660300002)(36756003)(26005)(52116002)(107886003)(6506007)(8976002)(956004)(4744005)(478600001)(2906002)(44832011)(8936002)(6486002)(110136005)(86362001)(83380400001)(1076003)(6512007)(2616005)(54906003)(16526019)(186003)(316002)(966005)(8676002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?izEdJVLKdbJkH+TJX35yG/EOY2ZaaXs7tEUK56LU+OzmUqmgy0KdUiLJJuiM?=
 =?us-ascii?Q?kths/7/EFIQSJXry0nTQLjthfvE2HXAyHYIvoU20wzQzS8w91ubqQ1RMGdgh?=
 =?us-ascii?Q?L/U15hXkYULRDoIvJ7op/RS4VPrMGyoQhX5OJsRwDUyW6b5bRQ7f7P505RZP?=
 =?us-ascii?Q?ikl/UcQW9NeMLb18RDIGEFuaXKqSr0pz8MtGmoJwx2kMAnqwn6Cgu2yc5dPs?=
 =?us-ascii?Q?offtxlylnIDadvti+8uPNUtwyIHpQjZ6HEm18YlP1kFVUFNBECq+vSoZI8SA?=
 =?us-ascii?Q?0SCiunQlE9dYvHjxNcu9HHVuHRHu0TasaF6/cMhiRbVByTFtj0dteFKL6/UU?=
 =?us-ascii?Q?B1rM+mlLM5s5pdpkHGsmCnVls5mY+N3cFMQfqg4fnk2Iz+7LYHosYWKUHKuk?=
 =?us-ascii?Q?t6C2VPtEfrAs1gkfrnDeIPqeyBGbvXCsC/yBYxYGF/F8p5oaHLhCCvM2Yn/T?=
 =?us-ascii?Q?XFPC7o9pyuBQi8zCRs2TTBYweyuROmcXWZ1feKpdrlWp2chlSRUO5T0oknFJ?=
 =?us-ascii?Q?2y/baDtsLdIO4eu7sFro3c8VSmrJKY1kIwtfNVv8A2gmiIV6QCf+Nt77D5QO?=
 =?us-ascii?Q?3z2+tD67uQD6XTZ1ZvG7lM7c1K5PWwZ8yB63QaI0xxe3Iap0guvb4D49CRqs?=
 =?us-ascii?Q?xKUseeel1b1dTliQQrSVUzb6n0P3V7r1bbIfcGmAffso3uJAoUNGRpXAfs5F?=
 =?us-ascii?Q?85AETMGO5iHW3TT/OoPXANcrdBCa2asfX0QDpJrnfOcMQIdg2M+tN+kbfftZ?=
 =?us-ascii?Q?pux1Q5IUfHhBF3DgJCpV2ujzEa0F4VaYOnoAznEc0R5URJN7603U2NSdac4X?=
 =?us-ascii?Q?fjDE6UG1YWUkqpQlJ8gc4YqNQGCAOe41QaVogcN/L9vMAiHcRucILnezUTar?=
 =?us-ascii?Q?Zt3gMIgk1miJUy/Newl/kStcABuojbcWCLuQofnLJLZzd+7dqKaqUoWmup+a?=
 =?us-ascii?Q?D/1N/Fj1NPsReEKdnDQ/PfOvMyeObQiJAOhkay4YxoagVfj8tJdjxhoXLws3?=
 =?us-ascii?Q?ZPSK?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: eb225d72-4d30-41bf-ff9b-08d8b9c805a4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 02:40:01.4321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYV2aB/+M/EckZNbLtBmlbIwxoOhdWtpefe85Ih6/FcRWSV57OCpsfEQr4MIi9NRyMHqGReCoImGlPJDWGjZFZK5I3UmVwdRT39PG78IHfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I finally managed to figure out why enabling VLAN filtering on the
6250 broke all (ingressing) traffic,
cf. https://lore.kernel.org/netdev/6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk/
.

The first patch is the minimal fix and for net, while the second one
is a little cleanup for net-next.

Rasmus Villemoes (2):
  net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
  net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250

 drivers/net/dsa/mv88e6xxx/chip.c        |  2 +-
 drivers/net/dsa/mv88e6xxx/global1.h     |  2 --
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 32 ++-----------------------
 3 files changed, 3 insertions(+), 33 deletions(-)

-- 
2.23.0

