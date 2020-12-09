Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A942D3A09
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 06:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgLIFEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 00:04:46 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:35640 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgLIFEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 00:04:46 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173]) by mx3.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 09 Dec 2020 05:03:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCzax2ZfJMzq9oQnTAC1s0D6erwTFZJlUyhyKg9BJPglpG1ae/UcrYGbljtyeIqAOfUjZfWzqb7Me8+J/ORirJR7abV9QO+8yAiqyMm8xMmWWCXIHFURFvKvXQfqY3808Ef5taJ8oIA8JgH2TT9tYdTRcbJL5w6kYNQ8zFrHJYod7Ak0QRTUwjynQG5Fn4x+I1WyWTnigc3nU985M1lnmSuzGUjLynspV/4JxNDjIVbjEPzBGVBZfmm9NNqNc+OD0w9qLK+zcwqClSvmsN/fZ/VLAVas/v4zkDm82H4oqdP/ZI1bDC3jrhVDlPvRQBd/NWaQomKyLdc975j2IECk+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGCEsld9BN8Q0YZQvexI1UNFDDZ6jGwAXNatMyy7p0w=;
 b=VQYIT38O7NvG9UpLSpLx8wec/OjS8rwlzXGXw2c/gwgOowxfhvyCtGkKHgL5YC72c7oW+TtO9/TBJ0fmE8v5CE0xmGaTUJhqElkgLfsWj4nk1yBOdgWB7Ufgq8QWhjxyFmIwsuPLN8pUlXweGnPy4V1+f5n8c2Xw96kuVWJdOsUIvwx/aJBKkKhIsVI0DZxbRGGsabsh9mZNsb5tcnzgsKuoQfVnyvN3/NGb38gNkzWMb2hLeF36Jl81WPSHDVPZrsrVKNdV8peMzLQplLFCzNqWsn4C3rVr4NwiJ63/IEUHnVnmg09122cIwLgwjNfCzibHGN+EDHC8kM7Vcu8u9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGCEsld9BN8Q0YZQvexI1UNFDDZ6jGwAXNatMyy7p0w=;
 b=CLxiSqGmkeu7vHFVzL0Y6oAxxtAVyInrBizVTlwBe88+a390QMpMTWNrTB900Cg24WWOgZuXxbHZ+1b39WcZFh8HAhd6+JlsUvVNobF0mD+mfePdrLK7Phl+CX6D29F3Sjp8++zrF0JmOMV5f+lUHLq9BVtCVyDHpPcAPVJzqv4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4336.namprd10.prod.outlook.com (2603:10b6:208:15f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 05:03:30 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365%9]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 05:03:30 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: [PATCH v11 0/4] Add support for mv88e6393x family of Marvell
Date:   Wed,  9 Dec 2020 15:02:54 +1000
Message-Id: <cover.1607488953.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120015436.GC1804098@lunn.ch>
References: <20201120015436.GC1804098@lunn.ch>
Content-Type: text/plain
X-Originating-IP: [203.111.5.166]
X-ClientProxiedBy: SY3PR01CA0136.ausprd01.prod.outlook.com
 (2603:10c6:0:1b::21) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.111.5.166) by SY3PR01CA0136.ausprd01.prod.outlook.com (2603:10c6:0:1b::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 05:03:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b39a672-7454-467f-636e-08d89bffc59d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4336DD67AA4A4EF0B896695E95CC0@MN2PR10MB4336.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WA0gsdCx9/51/ci4kxWCsqbEIXx6ZhxhXCRnJjPakZxlEVCIsI2atIfj9wlvtVUgd/dtjUVBx1ogzvpAVX9VRRhMY2bH8EJ/kGxt/8ch1DexAUZISwUjzTAADl8wRjVulGyh4CvAXW2TH7z1LzcxUxVL/JxSKVDmDu1TNqGInJPV68LxCeNQciXuqTsF/dSP6ycZdUY/e1aURddmHaXfatCCeEA8YsGq2KuHWrRboJ9bSkaLM3hd8e3U3DbHdQOc/YXzeqLsGU3LC43Cg6lbErDj3nGcOHIoNUjioszfuPBGxXPmJgPuBFTUJZ2A6A+tEN7eu+BZMmIw5Ri/i2wsNRSTeWfRYbIFNIG0akP+TDMBHE2zQIsNZJxAzrtAVcLKGpW55xlybfqEZICsOuzfwlzIgWdR0VI1jv3QQsWR1ws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(4744005)(2906002)(34490700003)(66556008)(66946007)(8936002)(83380400001)(8676002)(6666004)(66476007)(5660300002)(508600001)(86362001)(186003)(52116002)(4326008)(36756003)(69590400008)(2616005)(6506007)(26005)(956004)(7416002)(44832011)(16526019)(6916009)(6486002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ei/1G9tpjIeRMP+qMMYNrKMi2JHo1vAedn1MXsC+98BW3K8pvwzruk7KI3F/?=
 =?us-ascii?Q?bfSwMfZ/GD35VEF3h0tWzFqP93pHDgQQ3Y5y9PUjojInpWKU5c2IMyqmNFZq?=
 =?us-ascii?Q?Mroh5NkRXvaOpHdBm6q0DW7zLwgfvbvt2C/66mDWKjNikTRpB9eeahVanMFf?=
 =?us-ascii?Q?z/yelZ47UKDJkLZ95HadnS65WyeC2QYWedULhNhpHqVvSDPAp4dspCR7mLNu?=
 =?us-ascii?Q?AJ2YBT0dNSPkoURcf53DyJ4VFLVtO8v1upx8f4KtE9vz7V7U4XL8KKYTYVwu?=
 =?us-ascii?Q?7CZg1yUS199v17T521O4r4rYj7tzHQpKoFJndF58sAdAi9nJsaddA7hq7ymw?=
 =?us-ascii?Q?sNDI6e92B1M8CyY6XCaMpsCGz588cS0Sj0V+iOgFxQw2gi98tzXlfRXUxj1n?=
 =?us-ascii?Q?R/HVGJsFUrffrTaWKboC2UonP/o7bc6BDvk2tmetztd9jEC/zzJMH5XeeMbS?=
 =?us-ascii?Q?Vgm6mPRaAIGHqyFADgy6/krNAl9kXZy03D2k0PuPURSy1S0hUl1J2Y1xoBtq?=
 =?us-ascii?Q?2KyymzoOn6meQqYdIE8pqXydkyyaK9DWkHrOdb2/D/a51DEYFrWGSRw7B/Gk?=
 =?us-ascii?Q?5ASkAGYA6pvdMRAONieAAMzUqcsj21p6UCOiQ7Y2fWSgGqQ0QtjwKBHXbu3Y?=
 =?us-ascii?Q?XFv7Srjrtdr3VoVFJXJihZx4w9loSPoytH0b1hZDqh0nYyk3MEI6kMiw+vu3?=
 =?us-ascii?Q?QGxktkgd7OKc5v6YxccncoPiOGTxFu62cNW7fkkD6O3XNdp3kW2LJTfqeDZB?=
 =?us-ascii?Q?pKHiYdBUhWWxhtX2lyAHwpAAsmkJG0mUQq2CsM5TzFOAMrepw15tBQFHyyLZ?=
 =?us-ascii?Q?QwL9w9eyqf9EFsweXl+8GHH5Jssby9sGBX8ElcDpv2tMEW15ILAYAX2ztvhg?=
 =?us-ascii?Q?ADVRKVdZDyibo4AhU8+OGKgnagLUhClOzbLgHEZ7qLoEJt3OoHdROijk2Phq?=
 =?us-ascii?Q?pLHL54nHMZiww1Ugi6jMoWwu0gt7VkoR7PNgMRufrMkp+Qg6FSGGXdlJ56ju?=
 =?us-ascii?Q?ae0N?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 05:03:30.6580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b39a672-7454-467f-636e-08d89bffc59d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSx9/UKbnIMD+SgX81mbbMb03Fn4YxNQRTF//8OGqefmFAkMjFp25clEHlWUX7857VODMGUpSKpP7FYLdgbQ1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4336
X-BESS-ID: 1607490211-893004-26535-28755-1
X-BESS-VER: 2019.1_20201208.2330
X-BESS-Apparent-Source-IP: 104.47.58.173
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228709 [from 
        cloudscan21-38.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated patchset after incorporating feedback.

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface mode
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter type  from u8 type
    to int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family of Marvell

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 164 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 238 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 299 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  93 ++++--
 include/linux/phy.h                           |   5 +
 10 files changed, 783 insertions(+), 91 deletions(-)

-- 
2.17.1

