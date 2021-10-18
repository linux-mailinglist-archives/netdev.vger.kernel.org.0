Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75AF4313FF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhJRKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:04:21 -0400
Received: from mail-eopbgr100111.outbound.protection.outlook.com ([40.107.10.111]:6221
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229519AbhJRKEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 06:04:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUarUT1tk74fg2M8JEC2CwIJG7LllGK/JUZbkfEf6jz01PCTuNIUFDzlHN4M09oVcwHGNS7MOKG7vxw4j13dMXbHsvgIwODKRyTh+WecM8jTgR/Tuo5+afd0TtSPCr+2TkgSdUJCzb4gNHM4XLaRUOF0mcpT+DZULPVIJhJzWsXgbQYJJ7CCm8TRLgHJgC6Ese/uPZqe9G45AW+p7dsBc473kKlxXFLCCcMSx2szRlfdUL9zkX/dpEvfVGmxSCR28fv9YPAsLoCtPVlfBeHeJGbfbGwkUPW6og4JGPUlFvjHaI0Gev4j2G7V9YGbEe0mtCqCQjPb3A0B9BvFH2gMFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMZj1/F+f7yZt6U3zTA8uqMWU4kf11PbadDXRBKc7fA=;
 b=TjOQbY0IVD/t7cWVuIEkkZEUootl2T1GGYKHV2S92+xhyqus0pbMlYi7WtQZXitl2ztXCLGUd7De2BrfZwOB+0odU5qVZH+E9XC47lGu82ht+8pwLekIqrkaniTB8JgSqh1K302QXdFPott/kc/e+nGIAvYWbkw+f/93fIY/rOo4GDJVCfiu4aqXup/KXPmMSOZdREETDHb7mr6eWe7Uwpr/0EMzb3HEx5WXbL1VHaHPCaS8cdYWlz1zGvnkVxI5nZyha2ljI44BXpEukcQ0Z2SOkZfFqgIJaTJAc4dLf+xqMNlMr+G1VXWrrDMPZyt9OPq8Ngtoml6KWBIAQ8WzUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMZj1/F+f7yZt6U3zTA8uqMWU4kf11PbadDXRBKc7fA=;
 b=L+yHRK/RdOfIssxGjOgX9mT0KauDp0WFZoFhVFNirPbS12RlE9wo3Yrghyz3QF0fyWQtSVqw0ZAJmTqndQzOKEAqR3JkozBqJbETM17nmTQM9XTZYqwou64JbIIseIdVONZLhKFu1UiTel4FHdONsSGi0F7ITyNlZm9SsLNkeXs=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWLP265MB2244.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:61::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Mon, 18 Oct 2021 10:02:08 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 10:02:08 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH v20 0/2] wireless: New Driver submission for pureLiFi STA devices
Date:   Mon, 18 Oct 2021 11:00:53 +0100
Message-Id: <20211018100143.7565-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::34) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (82.34.80.192) by LO2P265CA0046.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Mon, 18 Oct 2021 10:02:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cd14782-ede3-49c4-922b-08d9921e5848
X-MS-TrafficTypeDiagnostic: CWLP265MB2244:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWLP265MB22441A406D8E3CD9FB785BB9E0BC9@CWLP265MB2244.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72A+gLZr5wHp4MaEy9SJqIYhAiqvKA+ddRp+F47ZAh7FUtUdBsvBHlB7d+11Plo8UH9JEvQ/f9yU+wRvtoBNFHTqZbt2su8n+SpHh80i1QO/+F0OjPASqmdCdhb5rVajSMV3nTdUI0v4N5OXhovlneJVJjSiJfUqwNP5XsE9PhPNazKQYekIukd8SVrgoZGdxzO6Yk7iaRSRHvA6jF5qOr9A3laCxy/gGHKkJX+CHNSr/Y0jlqIvYE+B+BWzhw39+OJwPHqisdIOHKYNkt9wOBzDocsnzIf5gx8izKxz1YCNhiGaFt9ptTFrkvbdSW/PnRyOTrlz1D1IQt1DcMrQY/IgwnVYz2chWInUNenuHpIZA+Q0R4bnq++XHJG+PiHcdvyBh5Ie3cuOM3V9UyD5kh6d0B/EyptRnSefIN+kG9eesLf/7SCmsNNuPAYFezgqUplj5o1mQews453HyoIOh1cTHU35mgSCwLPQruf5zesQTtOV9OgQI5Yelo6JHw621tGoghyZ7hOL9D0CUKmgtpMaWsvnU9EDZyPlkcoW9qQA1Y/mW++3W0iW8r2kz8h1xTFWio0wxsUx+Pm7dd87ZKTd/3COVnST0mcmDHKp8yhep0zbUphM+U6mry8rvlKR8MefEk7TKHzmYdkcgsdl6crNqirTjc5W4jUrL1oyOMgOqtE818FxL7s1rh7rJo+ZpHUtCgFhV0Nx+/ar2qMkZ8laOMaOWHX1fivzl9hryJc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(8676002)(508600001)(6506007)(26005)(66476007)(38350700002)(52116002)(6486002)(5660300002)(1076003)(109986005)(186003)(6666004)(83380400001)(86362001)(54906003)(2616005)(38100700002)(6512007)(66556008)(956004)(4326008)(2906002)(66946007)(316002)(8936002)(36756003)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iuaC7hxYu+wH6ENJphbZZksHf2yoD0ic0OcpjwzU2GSOhPnOXW5S44kksxm9?=
 =?us-ascii?Q?jWgxiPjHafmkgC+lag+2t22gw8jKaWbcTKYWTFukF+OxpxSR6QRXjCrYztsn?=
 =?us-ascii?Q?ed8jMMweA/TMPf7vJbhVC2H/vcKe8/uERI+uLFj2kJiztohPMiMyfnXvdMgP?=
 =?us-ascii?Q?Iqz4KnKDaJ3dB0k8o4xENY25ljllA5fTv624LCqeWmPIDbXLOZjI4BTvxCXl?=
 =?us-ascii?Q?DbyCEZD2uPwoSt6ghb3B/4sezSuP6MlPLmfIyY4LlfWy5YeMuZrEpENtKcxh?=
 =?us-ascii?Q?+d1w5XfDtffaHFFuPbJuuQRLIkJ+oVEBa+09BXeBgNHicF7W7ByE3YoPSvUd?=
 =?us-ascii?Q?laWzEv18ypyN/aYNzofhPpqXW3a9QB14uE4NPLrQCRSZp+BdbnXhBASE/cur?=
 =?us-ascii?Q?I7iHAElFeXlg6spS8DZEzS6JYQqY/UfYXvXWIvbTJ7K1NS4Lf2fhI0+zU7VV?=
 =?us-ascii?Q?Tqm6Rk5z5Gad1Rpg78wZ4AtsWX4xFVYynlq9sbI2ZKbbX8QFd+pzaesR8l/B?=
 =?us-ascii?Q?R+MBFw45v1efUC0bx8JryNKhsj3/5iftE5JtTZsBHO4yiBYIbE70v8iUPmqT?=
 =?us-ascii?Q?tLeC3ualktmTqMQ/aLWdiiptuw2xSyizvOx9iH+YsKva0xmGMWspJzDT2Jpg?=
 =?us-ascii?Q?GuAeQN5uV5B/BxvMfyGGHt9jgxwOepNLBkH/TWfbOfwdc6n33dhZ80m9QOwh?=
 =?us-ascii?Q?KxEW4ayx0MM1dn606tqLaM5EwpeNAfsY6jkSw00l+Qm/VLp+lZWBlUYDMWaP?=
 =?us-ascii?Q?wG8mrGiGeWabkmfA2SN/kd84ZatlH6TlaJdtDexwAfpkF1D588slB6LGoND5?=
 =?us-ascii?Q?YlXws57RMwODUJy/LoLnYmzqDJSGYfjElSV1Ly04mJZJd0mMFSMAx3dbGsQN?=
 =?us-ascii?Q?Dkq2N8reUr8EjrJNQp3KdP8Ee7dOwNiwjNVQwr7zOvcjiXQEtel9HCfzeJxp?=
 =?us-ascii?Q?RpAD/6owQJojlhPYsClzp0yPd9NXcpV5Bm4IFHtZaIh188lu/d1upl6gD34x?=
 =?us-ascii?Q?L2cmxnUqDKu5MoHLYp4RIdPQzyqDEtEOXSOzDVF/ihDlxEv0APwizaEfRIOR?=
 =?us-ascii?Q?TXqb9hLMj7CANheh614/qAHWY27U7JrFMf23AkPQTHasL1duAjfam88LGNMH?=
 =?us-ascii?Q?oxMC4PaVGLb7moRBgvUwBsQzeGLpgBkItYlJLcWlF/WU5C73zjyKzn0VKUGQ?=
 =?us-ascii?Q?GhGLnH9U4QlB/JEOySGWHeul+8SZvFrrw/EpBsM+BAwqoKLvhXZWFs6S970P?=
 =?us-ascii?Q?g0a+Vi/iiAjKM85cEI5mJWp3mLET8VL+h7r9ccuGAbEXhPThoxQ5Ie98ZTZU?=
 =?us-ascii?Q?R8fa34/XWDZJWhtPf6Orjeui?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd14782-ede3-49c4-922b-08d9921e5848
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 10:02:07.9283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbBWejQvudnwl/HN5NCo5Ug7UAhAgtthrJBKjbvDI/0sQ6PDwxNb6SA0JudEnotKOgnP1EBQ6SoM2+NyKLKnAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2244
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
v20:
 - Remove unused static variable
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
  [v20 1/2] nl80211: Add LC placeholder band definition to nl80211_band
  [v20 2/2] wireless: Initial driver submission for pureLiFi STA devices

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
 drivers/net/wireless/purelifi/plfxlc/mac.c    | 770 ++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/mac.h    | 190 ++++
 drivers/net/wireless/purelifi/plfxlc/usb.c    | 975 ++++++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/usb.h    | 196 ++++
 include/uapi/linux/nl80211.h                  |   2 +
 net/mac80211/mlme.c                           |   1 +
 net/mac80211/sta_info.c                       |   1 +
 net/mac80211/tx.c                             |   3 +-
 net/wireless/nl80211.c                        |   1 +
 net/wireless/util.c                           |   2 +
 21 files changed, 2695 insertions(+), 1 deletion(-)
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

