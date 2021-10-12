Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E7842A4E6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhJLMxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:53:34 -0400
Received: from mail-eopbgr110134.outbound.protection.outlook.com ([40.107.11.134]:28396
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236489AbhJLMx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 08:53:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXrBFJrqJQ+TpkP7lKJ+ItsRiNGyvU4osVRtY59Ev2s5c2C2nTupmk909vFXVKaHCmfa6YsIDH+MAlcgkKeht9vfyYC1zKjlVEZXVKXUni048bHZNPl1TAaEwqMP+VLNiAlSOMrPNtzChx+W0OzfTIBpt1j7vLWcjvWQXMmMzn8yYXIK13m1x/FD7ZyU4+3RjzJlWdY39TJsV6NnDZONf+nlEP3N/qexIGOcIy5cAiLnKHhvukL/UFf12fys5Pq0iMKuwe/R+uJtaju8ttRrct1wdjTUMsQVWWysgLDfboLZXJyrtIyc1qCn8K1DvXJXz6evr6N9y578NOrBEN2hKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/8nWTScUyMu5ek/r4AONoWti9zH7XM9DW/tohNw5xE=;
 b=oXLGcqpz8lBVVcoqoeu+gvonRwoqCMt8ddS+OPxpqUihcOm2FiIKJyLgLNRI0xkLCNPdHNdXULJpfEttUo3DkDGM2td+9Jyc7iHx28B2CUYa+/8PHf21IQa2vFDrewaHtev8VopIsfwsfSn1HU6rI/o5dsk/E759z66nx1gr0TJTEVnpcbPhu29c3viLc6BCOwbNe0BLUpyjj3cGfFUdK778NtqzlbbFDXVD1h4RJcwI5yw30HKJIPpPsVkOaWeCPLWVhvEeqr0Pwl4VSjwLoU26tsWkZDM8+vLD7O2bRUqZHIOzdDoHd0eg/nEcE3+7uP+rsCzaVJuAulgDLj63Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/8nWTScUyMu5ek/r4AONoWti9zH7XM9DW/tohNw5xE=;
 b=XbFR/7+d04PONjLOZeMVtrsiEcCiZFcllFkQydQD7q11DrTf1hs4rjFnV/SpbBrKADtq2dD42MdaoV1lv+MHeUCWRwDvSj1BK2VbspU5RDed0dk3aEL1UA0XfW3sPSoXcemy958UQQcOgB8yaU7mD2coZOmL4QQtzAa7O7ojhTQ=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWLP265MB3779.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:109::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Tue, 12 Oct 2021 12:51:22 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::cdf1:580c:afc2:6dd8]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::cdf1:580c:afc2:6dd8%7]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 12:51:22 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH 0/2] wireless: New Driver submission for pureLiFi STA devices
Date:   Tue, 12 Oct 2021 13:50:10 +0100
Message-Id: <20211012125102.138297-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0475.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::31) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (46.226.5.242) by LO2P265CA0475.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 12:51:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f0c344-051d-445e-7516-08d98d7efe6a
X-MS-TrafficTypeDiagnostic: CWLP265MB3779:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWLP265MB37794E53E30C89759B271CEFE0B69@CWLP265MB3779.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZBy55XNxDPVqxqQjT6jjAtiqZsFqi4SP22gHyOhgT2b/Y/zCb5K4Jqt0PZkf05Dvqh9rsUqzuwhOWZdu2lgwAQlvmL4nN09eU0w/nURj9SHahllBnFhp0iPvn6uL7ZQG9wns7tWbv6Gr7HTmDBrmcN0ZlLTidOrbxj+YJs3sFc71UO0Kjc+d4sJt/ajW7sRWmV8ghgbVv7jlgXQ+g6vpNK3KzR6/bs5Rwkqi9yaaam7GZnmklO0WsmZivko5jTskCUJul5PzY90xybsZj77jwzEMgv/1nABQs7rtwuME0ZQUVhLBc78hHwfZ6x7Dh+nxmXwxm1lS1M4/lFA7cpgyug8ONGNAepdccvsBEaCqQ1KMDz4/ksMrW5q1OFl1fBqFp0P/nIlBVeM7YUz6xEoQkyJUx1q9Urlidsjli/GVEZ8IzxPYYvSrLODVJcRHK2DAuziucx/PUPuUc0vg24HUYWzV0hTn24V8+R1ZYhiRAyyoAaEJaXa8TWRS8XlY3Kht1YAnaDjQ6tw5Y/ev4Ks2cSvQ9KBGt5DueJCY3zmGfJ2rR96oP8pmzEO3cqoJGshgKhS8xyMDurk+YNRdkhcFDBYYxytgMKUeHXvLt8/olWxRfztNEdGH89Te9FLjvntrX9S47cyKnE8vbD+A169YUQLxu6CLXHVvq2E4G0tM/wocid/h49TiiRps08e+IFNAASN8tivbFqpFoF4euCit15j6dGrewbn53qQdHZ8g0I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(52116002)(6512007)(109986005)(6506007)(26005)(8676002)(186003)(66476007)(1076003)(6486002)(508600001)(66946007)(8936002)(66556008)(83380400001)(4326008)(2906002)(38100700002)(54906003)(956004)(6666004)(86362001)(36756003)(5660300002)(316002)(2616005)(38350700002)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7OSyDEf9avJDMiUe7q7AWJJ4QyFNQgLwvI5LTOUC+scMqt0pcUwLPNVxQyZN?=
 =?us-ascii?Q?J8W9IXzvMMXfECraKJ3qwedhCNZCo30nM55ftLy7vpam428EL7DN7fO6TkmV?=
 =?us-ascii?Q?+O/YgxmE4Hmcen+pjXdlcSBx7PQCopPgPrrZ73AR8Ne7N1y4T6iRHLZIebzi?=
 =?us-ascii?Q?xye56cs4ZPn3hqziC+7NFrMFZcueiNseJqlLtRiNYUOdOXHai0zjIB9ryiUE?=
 =?us-ascii?Q?4X9Z4ZrfCFAyZl7GA7mWUIGDpQrmtX+xc1val7Nr1ioi1Vi6rE4avpm+lfUm?=
 =?us-ascii?Q?ZLXAGmUDApPQSyXARkWup1yirRweFCx7Z702vTFyyLSSxVc+dzdWmy6WRMS5?=
 =?us-ascii?Q?GhpjeBJKmKAFiF+OQhvupr6WjHkrNdLsOv6PHRF6EYm+T/T8S+Id+8NKlGWA?=
 =?us-ascii?Q?GjyQcm6N1wjqZezfbseoNrEG1XKp29YxkI+ww80Asr2QJos7wDdss3qjvV7Q?=
 =?us-ascii?Q?zWpfJ4pU4xqez2NKcDJbYJSW81h36ne+hFPX140WE/7W+rkosHdJ7j9XFf8i?=
 =?us-ascii?Q?5Gy2wtpVGg4MA6m9Mk8DeowBe00/hPL1HZUd1LzU0bClgtCpaIB8a0XjaSgF?=
 =?us-ascii?Q?2q6zuXTWkrO+lOjSIuecQe23Ec+BTrVCNrDnPgBdGCE+tDV4KHiVVMAR8dYq?=
 =?us-ascii?Q?0MvR5C/7BFFpxBBPW78kf9M3okI+RWYenoraWuaMlEO56RGCdorZLi4b9LVl?=
 =?us-ascii?Q?XAuaURt2EJC4ydC5OUZxi2n3t8XnnVuEIvfAt9pB+Wv75ywY0mP2Id1SZdzP?=
 =?us-ascii?Q?/2EfoZ+NwFcy7AcBqytPNxFol7AQl5VhFTUjBoagDPPHasxBLccezBUUg/R0?=
 =?us-ascii?Q?8o0aGzXSGAQIYPUkBXbZng6IGcTGrc38xhQzhujWQSY9TwXbsa+xPI60LmlN?=
 =?us-ascii?Q?nYC5TAKcWklLAj0cpyaTzk6kbcs5xUURG5fiPL9NAptFGWzZ9Z9LMb9DImbk?=
 =?us-ascii?Q?Luc8ZZfgRmjirxCWVpoSvcU4c+TtVB+6axVDqgCmNppcxbz6VEMyIeHNpcgb?=
 =?us-ascii?Q?spef5zSYw0mLlub0DfgQb/Lau2EJObMiCa8IGXY0Ft7DQwA5Aex0xa9POSsu?=
 =?us-ascii?Q?4mPF1jjKmfUtzl2cnXBHIHYg7HuQiHL1SnWc1vbHpaaEwNZNAsNkAnY81g/t?=
 =?us-ascii?Q?gZ+DL3+bTq2WVt7ToGuOQZsSx7yb6IarnKhNbIjE2pkdsXJ/N17al2TRTsGs?=
 =?us-ascii?Q?cJgUVF1Etz5F2E05zGpSSFSrSiiFf4DY5RpwOSFgwV70d4xyqM2Hmz/s1C0Q?=
 =?us-ascii?Q?Sgrx1CX0n2a4AxZIwmtK2EqiXb4x5iT6yUhjJd7zS5j07877dPoRgeEtpARg?=
 =?us-ascii?Q?PY8ejNZMO/qV2Cd7g9HXfWez?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f0c344-051d-445e-7516-08d98d7efe6a
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:51:22.5034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RYotrIO2E3CoysEmUdVqhFb1flouu0nFMGdEFn/rV8wwAvWiz76ItAKAnUn6DCwXqmVMUZUfF+lpIHB9ivr4xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB3779
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
and LiFi-XL USB devices.

LiFi is a mobile wireless technology that uses light 
rather than radio frequencies to transmit data.

802.11 bb is focused on introducing necessary changes to 
IEEE 802.11 Stds to enable communications in the light medium

---
v19:
 - Fix kmemdup null case
v18:
 - Use light communication band 
v16:
 - Fixed atomic variable misuses
 - Fixed comments spacing
 - Removed static variables used
 - Moved #defines to header file
 - Removed doxygen style comments
 - Removed magic numbers and cleanup code
v15:
 - resubmit v14 of the patch
v14:
 - Endianess comments addressed
 - Sparse checked and fixed warnings
 - Firmware files renamed to lowercase
 - All other review comments in v13 addressed
v13:
- Removed unused #defines
v12:
- Removed sysfs, procfs related code
- Addressed race condition bug
- Used macros instead of magic numbers in firmware.c
- Added copyright in all files
v11, v10:
- Addressed review comment on readability
- Changed firmware names to match products
v9:
- Addressed review comments on style and content defects
- Used kmemdup instead of alloc and memcpy
v7 , v8:
- Magic numbers removed and used IEEE80211 macors
- Other code style and timer function fixes (mod_timer)
v6:
- Code style fix patch from Joe Perches
v5:
- Code refactoring for clarity and redundnacy removal
- Fix warnings from kernel test robot
v4:
- Code refactoring based on kernel code guidelines
- Remove multi level macors and use kernel debug macros
v3:
- Code style fixes kconfig fix
v2:
- Driver submitted to wireless-next
- Code style fixes and copyright statement fix
v1:
- Driver submitted to staging


Srinivasan Raju (2):
  [v18 1/2] nl80211: Add LC placeholder band definition to enum
    nl80211_band
  [v19 2/2] wireless: Initial driver submission for pureLiFi STA devices

 MAINTAINERS                                   |   6 +
 drivers/net/wireless/Kconfig                  |   1 +
 drivers/net/wireless/Makefile                 |   1 +
 drivers/net/wireless/purelifi/Kconfig         |  17 +
 drivers/net/wireless/purelifi/Makefile        |   2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig  |  14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile |   3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c   |  95 ++
 drivers/net/wireless/purelifi/plfxlc/chip.h   |  89 ++
 .../net/wireless/purelifi/plfxlc/firmware.c   | 275 +++++
 drivers/net/wireless/purelifi/plfxlc/intf.h   |  52 +
 drivers/net/wireless/purelifi/plfxlc/mac.c    | 772 ++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/mac.h    | 190 ++++
 drivers/net/wireless/purelifi/plfxlc/usb.c    | 975 ++++++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/usb.h    | 196 ++++
 include/uapi/linux/nl80211.h                  |   2 +
 net/mac80211/mlme.c                           |   1 +
 net/mac80211/sta_info.c                       |   1 +
 net/mac80211/tx.c                             |   3 +-
 net/wireless/nl80211.c                        |   1 +
 net/wireless/util.c                           |   2 +
 21 files changed, 2697 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h

-- 
2.25.1

