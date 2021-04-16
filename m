Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF13362917
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244549AbhDPUNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:13:41 -0400
Received: from mail-bn8nam11on2094.outbound.protection.outlook.com ([40.107.236.94]:25025
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234654AbhDPUNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:13:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkKw/wIP1rbZx9FO1iCmZipwHxot7yyZOZS4LpW9iywvNX0qBgirnK2edPmSWY03EhKa/Jb3mk8WuIC078SWZAab6QczmZQcraCOQao7nxEZKy9B52bFghx82ZM4LfjqqddqsgNzf8rBuSfzV2UqZwwk6/+DpmKStcwmcEW5LcKDmw/3gEEFu7WYjxaOtaWZYLpnOG58YdO53Ds0RaflZHlt/ydBICSbYNAP9vXTlpIf2nwo4qVpm6PvrGXKUSMprFl7eLlbuJ3M5kxZxuNf4f9DgDWxQOWxACOBPtaKUNBBJ0W0cscUd3WR4WSjMpouhZbGKZolhGPpPr5efrQLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PshSBGlCOQuckGUOCNxXcXNZG712YmSdeQ8qUX/FVTw=;
 b=N6TuJCmVbD5MmROuwznYo7GGlvJY51C3UpnnoQVjtkRjl2BHUb0z7d8MGdKw7PtT8wj2p/xxG84E/oEyK+krx6yTIwZy/Get7qwVKmKi4o/R51WglO+MTtM0miS9YDsYLWTL+nOuC2HyVfWQf4i3B8ykAd5IEvckCx14dBCfcho7OcZTc0/E88/eKbtM6Q3LxJ3ykj9GUMmPVQlHOJHnFhBKGtYbmNbB11KuqmJj47hV2kmTQqPMV7Q70K3XB14PoE+p3y1Ia4SEQ7c7GGtdYeULNb2H7a5G9rHJib8sqU9vw8cfs4YC2TC1b3RnNS9V7D8cKctvPOonOhqGYHaBzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PshSBGlCOQuckGUOCNxXcXNZG712YmSdeQ8qUX/FVTw=;
 b=KM4G/Cs7c8074rpFJV6+MYxGAn2Y2zlW3t2IdOedmcJ0nYLr91MZq++fDTfIi2lBwL8XS6HE599gsyOgKHZ06TuIRqio86Ylsbed0eF/h7x19P7DwPbVmzxctho/aiqteryXMmGlj1TaCfEgCAFfHofYCAVX4neUdscLlpxTBe0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1076.namprd21.prod.outlook.com
 (2603:10b6:207:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.4; Fri, 16 Apr
 2021 20:13:14 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962%3]) with mapi id 15.20.4065.009; Fri, 16 Apr 2021
 20:13:13 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v8 net-next 0/2] net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)
Date:   Fri, 16 Apr 2021 13:11:57 -0700
Message-Id: <20210416201159.25807-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:f:1c9c:ebc0:6a19:ff8e]
X-ClientProxiedBy: MW4PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:303:8f::29) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:1c9c:ebc0:6a19:ff8e) by MW4PR03CA0024.namprd03.prod.outlook.com (2603:10b6:303:8f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 20:13:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ac59224-6131-4f2a-b79e-08d901141027
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1076:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB1076388600A42B7D08420037BF4C9@BL0PR2101MB1076.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSoNBw1xswk80+xodmW4zFV512ITwLiqvNaMyqmCGOAkqAi+uKUXiMNIYCXZQ4mfh58c1BqBzso6OBZPWxaq2IZyC47xCeeHSfmBGSKs9kpdrvocKHV6TB+193xnAwVVADvidpFPbMjxT8aGHbV4+ZgWquQMb91WAC32bNidznXKEYpNqgs7bK3NJ2whgC2kXyUTRPFaeKn0FHVuRw23+DmTiPIfVNc/zoVNSlhW3UHFMdgONtJm6fRrXsqZ1FAJg1N6wl6gS0VLrsmMcplkF/5jDcazFk2SonsL+Q52YdlonFPG0lV8XOXkv896F4fkZ6mpyCX57gXVIjO7ocQWPzpfCTd4oZKZmvkQyvPoXu/NOzjLGrtlpwPl3DA0YTiAk69jXU/ReyK+4QLBqWF0dnHXXiTjbtSKuVSpPfmstBHrKfn++LYud8uxNoVgdqE7FfiHDE97678g4oOtwb4tD8kf8/LBBg4b8N2bvVvbyw3WOdCRIkIitNdkQwcMkW8LYZQf9KnCB0JgOMhXBusGOjR+VknjGugQRvVowyW5dNPfsnVKos+GNH1IlayeajF+pIT74w8z4kXEhp7JGD+90lGxDQBuDAyWfUhZSNUC2PnKHh1E+okTWmmy6I1wF+dFD/WKfux9pCHMVjQ8BC+msg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(47530400004)(6486002)(82960400001)(107886003)(66476007)(186003)(5660300002)(8676002)(82950400001)(36756003)(478600001)(16526019)(7416002)(316002)(66946007)(38100700002)(8936002)(6666004)(6636002)(66556008)(86362001)(52116002)(1076003)(10290500003)(2906002)(7696005)(4326008)(83380400001)(2616005)(3450700001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zoTwVWZO5svL60Rx3G1ODQAPSkYbXZTRektQGKES4ypfN3vd/I+CCtU17d9d?=
 =?us-ascii?Q?JXi88XrfCnt5j+Aaexcsl/DMQFIlliJfaAO6/H/dP+HLkFQwI8Thz1BVeEWT?=
 =?us-ascii?Q?FnZ/c0VEgY07yqmL52ULgU1Vv+xOY4dna0A8FeNbYrud6hJ6zms2L9xz6r+Y?=
 =?us-ascii?Q?tjQ3lkIh06aYqhbK9St3rZnbzB2n90/S+xgcD3LDLLwiRykjCay39eTVo2Mk?=
 =?us-ascii?Q?Afrjpw4bq5YgWKr/FrDYX8Q/MMMSD03weSJq6MH2uTKFJXzEWdnmG8l3Bnk8?=
 =?us-ascii?Q?w5qd3rfTCcfH+GlJtDqRCu+sLKUEFo01ZUPvrC4ikinosF2fOlK3Uhpihqav?=
 =?us-ascii?Q?NrTWPMNw3H/7xhyNsqd9v7JCdkvO7F7/Y5IikBCuqOSr9dPKi6FX9mLuQYRN?=
 =?us-ascii?Q?ekwzROZr/Z0YrbmW8bN+sZuZc9bE5hi0N2hdvRyNGialVtSnXS+TpJRT8AiD?=
 =?us-ascii?Q?49me7F87Jn5Eph6d1nqhTgpmQmZqURCpfjkfDCNwkMZpaYgTB6qwcW3A+2L9?=
 =?us-ascii?Q?KxqrMLYE2ZGs8H8hJwg5tuIKpDDxxP0F0kMlk8jaHzlg+N2IjcWBsJECr3bP?=
 =?us-ascii?Q?U24IYZutPENjMOj8txg5mvdF+kfHVabnc+6oQDqDs1VX3BLeQwCag5p+7lRS?=
 =?us-ascii?Q?lcukxfUiDZE0cJ5CJvmB6OQvoaFDjUMNLpxASvuuvqLA1gPMFQV016nKE9jf?=
 =?us-ascii?Q?afEGHFH+W3ROcdwIIPJv4wwlnsyg0hs+WcOaRzgDSF7MPvka78fMum1ZD54v?=
 =?us-ascii?Q?DWoxN+vSNF15YySEC/whlNUfq8yMAh8Io03qz4ST1k+Rp90mwXYAZQpAlOQg?=
 =?us-ascii?Q?mxdVJoUtFDAejaz41aYkkbMvXUppbqC54Ka2LeSi0O2uELndry4LjFs6c5lL?=
 =?us-ascii?Q?xu1n+z+YN8hQT+MyJef7JurJrBfJ3HsUSEoLKxKMbk4Ng8gImL11j0zcXxye?=
 =?us-ascii?Q?kJZIykfoLGkyQvAeWBwRNlUnarMKciTFL52/jLOo5uZsxOfdfi8curOwFDSd?=
 =?us-ascii?Q?YLylUDGqv85VVmkWxqqMcVu9PJ8FTe4FvOzh5GRy1PW9ZOfiCRZdINpuC6SY?=
 =?us-ascii?Q?HIdD3bNzvUW4EfRViSTrk9vzfBQsfx6wAvDh/9ZmzS1POxXz8ObBWTvAUxlH?=
 =?us-ascii?Q?cc12652auCm7+gtbuILO9WW4ceo5l1cwP31DqmMW8SGqFWR3Mn7rHDp/JZ7t?=
 =?us-ascii?Q?H73z4V7JzTG7TzC8bVfuwhgJp8EqWBi58ZT0je69E2W6P3/jsVcmUQRMnr/H?=
 =?us-ascii?Q?rxIZrylafaP5incEYy/cSEGLhXwzucOVLPnl7BOdvqQLaY39cz9++FJFYnek?=
 =?us-ascii?Q?VgOYQhKxq0nCbX3wABaPHbKgGk0fXSu2TYX2zyLSRkt+39b4Xr4hcDEfLYxz?=
 =?us-ascii?Q?JYMnMevTyvRDsdMgRo6DBy9Ixll8?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac59224-6131-4f2a-b79e-08d901141027
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 20:13:13.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8DPjiWXUU+Yqop0owr6Eo8wWOYQG6uo5S0YB+dTgRU0sON2+FPNTSfKtbIktWzbh77NGiaSI1q02JzMxqzHVvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset adds the VF driver for Microsoft Azure Network Adapter (MANA),
and also changes the hv_netvsc driver's netvsc/VF binding logic to check
both the MAC address and the serial number (this is required by the MANA VF
driver).

v7 contains both the netvsc change and the VF driver. This version (v8)
posts them in 2 separate patches, as suggested by Stephen Hemminger.

Please refer to "[PATCH v8 net-next 2/2]" for the history of v1~v7.

Thanks,
Dexuan

Dexuan Cui (2):
  hv_netvsc: Make netvsc/VF binding check both MAC and serial number
  net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)

 MAINTAINERS                                   |    4 +-
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/microsoft/Kconfig        |   29 +
 drivers/net/ethernet/microsoft/Makefile       |    5 +
 drivers/net/ethernet/microsoft/mana/Makefile  |    6 +
 drivers/net/ethernet/microsoft/mana/gdma.h    |  673 ++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   | 1415 ++++++++++++
 .../net/ethernet/microsoft/mana/hw_channel.c  |  843 ++++++++
 .../net/ethernet/microsoft/mana/hw_channel.h  |  190 ++
 drivers/net/ethernet/microsoft/mana/mana.h    |  533 +++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1895 +++++++++++++++++
 .../ethernet/microsoft/mana/mana_ethtool.c    |  250 +++
 .../net/ethernet/microsoft/mana/shm_channel.c |  291 +++
 .../net/ethernet/microsoft/mana/shm_channel.h |   21 +
 drivers/net/hyperv/netvsc_drv.c               |   14 +-
 16 files changed, 6168 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/microsoft/Kconfig
 create mode 100644 drivers/net/ethernet/microsoft/Makefile
 create mode 100644 drivers/net/ethernet/microsoft/mana/Makefile
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_main.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_en.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_ethtool.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.h

-- 
2.25.1

