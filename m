Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F14440E91
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 14:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhJaNOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 09:14:20 -0400
Received: from mail-eopbgr110129.outbound.protection.outlook.com ([40.107.11.129]:21176
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhJaNOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 09:14:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjUqMjoTbs1BMo2jaX3SbMvALmwyzM4mdzBXWyFpd9HOWHO1zNxbAM+xrT84pn0S3eFxT0KdBKBjiTvlcZwYpdZqwCMsu7bCjW/IghZDORx8CeHQakUNC1kff+tX0aJU0lriR18nKuLpX3Rb/5Rn6ZHIM2p7aLKZ9Oa4fi0slwxZIOAxHUsAeF55YJdrpa9H8Ipwq3vtQcW/RdYcFVpwVBuW+rGyz2apQ6EO2UKLIO/7q/laqN8PITuVP5FF1Pb7C9FolpTBZNMeX4lH2zC+Ui8vNTUIJavyHqHlfUMZZ5/zgzlT7zehNWBqN66aAuJyI6NaGkNP6A+WRVHFaI4omA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw34VPlo2a9NS3fpsbDXbpda4UbClOd7uTMO1qIKqFo=;
 b=gjP6/E4YlDvFlBIA0oTpRdblYatxOFFK7724PT/GHTdjAUJfd8tbQARLJj8+0X/RkP8k8XAVWjoE0J2OhsWC62tCUQTLmGt8pQbDFbhSVx6jVDyw9Bgle5pMnvipMnq5kcp+zMmVr8/L5KZDY6MqLPs3VRL2RnLoEHSZrpslcDpCPSs0EaFsM33cqniC22lMdlaeAKSxNzkBjUvbjDbuMbKukXLLdFj7HZHEROIe7sF5nImHdv8Xvr8pJlWqKH8jjXaSONrZqoaBPLidEcIlpG8r7kUcOzeK6ik/DC6bhq/zzAXwDHN3EFk9I0Du+GcCyx2n308VWvZqM4G+Lq0oYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw34VPlo2a9NS3fpsbDXbpda4UbClOd7uTMO1qIKqFo=;
 b=o+UKKzge2sHuyG0yjkPIPkRe6hXYkYARb924TYwuMdFE2Fc1r0ZGhP/6bc9km4nhrj/U+mndNLboCO2PxIFfQcdBi2GHTfp16ZOTkGkMhmFsgOqqrwNqkfwB4mtj9bRvAIqurEJlut9Z8K0EPuHiTGT98qEt1HCZX2i8JGwwrXM=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWXP265MB3349.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Sun, 31 Oct 2021 13:11:46 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e%6]) with mapi id 15.20.4649.019; Sun, 31 Oct 2021
 13:11:45 +0000
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
Subject: [PATCH v21 0/2] wireless: New Driver submission for pureLiFi STA devices
Date:   Sun, 31 Oct 2021 13:10:32 +0000
Message-Id: <20211031131122.275386-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0383.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::35) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (82.34.80.192) by LO2P265CA0383.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a3::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Sun, 31 Oct 2021 13:11:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e46b718d-86da-4a3a-b994-08d99c6ffd79
X-MS-TrafficTypeDiagnostic: CWXP265MB3349:
X-Microsoft-Antispam-PRVS: <CWXP265MB3349FD0AF47AFE03563128DAE0899@CWXP265MB3349.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pOqvf1EqyWdGBJR9b+BaQtWZfqW3lxO1cT8O33VlVl6Yo6ztmOHS6ecolHaHuAljPytNjRpS90gHoA16RtAO3ii0bpOM3GoFdd7gF3SCzqf/cig/TYZaqNO8WDQCPXfpZOgkQEvQ9Tl+eC70lJBPJ2JZGYwXL1wabIMrg077JnU/ZSiXbjstl5pQd3Mw38rTZW7qvqbGXjPe3q4KQmRt7Z7iK5E5FrxKvt7IBU7BLLPixHBKvpkWEfM+p+7qkqmKn22/pACJsIomC8uCgJ/ve0sjY8INDl+MbTiguf/CVuZuWgxfh9u86ETjlbr0UOFq6lO1u89Bi+cgRMb/Ehci3sxPnRBTVf+7xB3SmUEvILAUwcqMyNzzl/8OywimMchL7c2HXmNChp4g5NUEKEiBlV0p9ussRn/4hTzgka0TRjO8wUJqfJDV8ftDf1D6dOFVHjoKYAcn7t0oz0HYUSJSGgKh3NmtFgznXzj5JoYNVDzMWhXZLU1EaEXahCCG16w4JqGq3dZRKRMMZCC+myO44DJf07+K43QoL9rippRBvEKEKcZETSIC5YgbvpUzWIN7JxjIAZZRri72Mnh+xffLJ6RyNwaC1YBP1i2urhlE+RoTAwuGhvp+27dRsBnNOVapZ+O/TqhPjPuGmR4OreCeOcV4bTlMvJ7PDt15EVOTXtetvJmvyZCqh3UgxSeD/bwVnjzJK6M7hnNsGtSdJB3v/V6qXuSK8znTUM5lI+uZ9Yc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(83380400001)(52116002)(66556008)(66476007)(86362001)(66946007)(4326008)(2906002)(316002)(38100700002)(54906003)(38350700002)(6666004)(8936002)(109986005)(6512007)(5660300002)(26005)(186003)(6486002)(1076003)(8676002)(508600001)(2616005)(36756003)(6506007)(956004)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cLmwMlkXsxdTyO1sCpAP7WUXg5JckjpZqdrm0yhv0h46L/lJ+s3axMVPxnDX?=
 =?us-ascii?Q?WJYFeloGgWLo8uXRzokAUrlwnu1bwyC2DTCrn5Gac8sLZvr+OSDGjvaAhLaI?=
 =?us-ascii?Q?w8aPo9mlfxNoWNd5tXGH8+12gLrnb8GpC0YitW4mnZnde7hSB/7ph3hucwle?=
 =?us-ascii?Q?8miS7ubPF5vnXNW0YpIXkyhwEdKBFEhisqVQzUABalI1B/GAnYS8egGmTLK5?=
 =?us-ascii?Q?TDBnLvy3zjYUKXcbAMQfeXhivTocAuVGCrEH6txcsBw4t1B4ja9sxyVz+Ty8?=
 =?us-ascii?Q?/rUuoByKx0p1WO+W05fC/etJBPY04BYkPFmX58Z05Rtv8F5rIF79cDo/95SW?=
 =?us-ascii?Q?+ZR6FCEAg+O7ffeE2idLyQN6DXkUax30+PyZxmTQgvBR0EipjYXOTpZeBOzo?=
 =?us-ascii?Q?xzPTnRQkzrTeXDhe7AcV+1gAyhQTDfIiuXVuKzdasU4jWhKE0xY+QaZR/mPN?=
 =?us-ascii?Q?3hPm//Jy8ve04/lqp6lZZuvn/Z7xwmSspN76KJ9W70fJnwKGWheL+a20gY6x?=
 =?us-ascii?Q?ngrXruFLkfRMx/dvUEdNqO3JzqkmGjsIjOu8+qkw7CklCvxFQg9/o6RR0ftM?=
 =?us-ascii?Q?xlRguU6vflInTau3WOreouYacLK0/CjxbJsSFvVw7ghn0BIDBnXCAtu1jaFG?=
 =?us-ascii?Q?+Gn9TuOzlk9pklr7TlWVEauitpa5VbJmn9fjrjxMCNLTeysOb+4WL4OuwqAA?=
 =?us-ascii?Q?Hbub2paND9TAffOpxAJ0AhN8YT4JwVg26uqCcig0wzbxOhqyQtJDCF3/XeQD?=
 =?us-ascii?Q?Hze8k+7hXqnVxolYAxs2bp/54CBr1dCx/20t1Qd/8HqXmdSIq1NrxHdEPM2L?=
 =?us-ascii?Q?f/sqe5P6Bb1iqddcfFYX5X1igRvVPg8PAnVHOO07w7G+pC16L/oJeZFiZpTz?=
 =?us-ascii?Q?7ThN7r2qWZttA2EBJeLxgKFmzzin2rS9jiKsVscnzf8sCoEamXzIHNISEKJx?=
 =?us-ascii?Q?ijowu9ZxaFqi9EUcpILVEwbAvL7QSZxkPnszLc+Fqll3NZ308DZisw+eNrkY?=
 =?us-ascii?Q?/4KgFuGbSogubln0xyfbgQ12qWImWLNa33XuELNmM6E8FXDZtyoAfLLjEivi?=
 =?us-ascii?Q?0opaObC5cZ4GQmWRpFrucCJMxC+/kmO7JdT1mYhVSkIS1ptRCNfcF+djOdiS?=
 =?us-ascii?Q?lPLqOCsdPGBL91mGvxFvMWSxgKn1x/QHWfClqrk0SQtd7k4pN0eSmxwtYOe3?=
 =?us-ascii?Q?po/ES5izK3s4TRugVeyWqXdAP5div7KQK1+beOaVzRd3Tb4CwSI06uEZfNR3?=
 =?us-ascii?Q?tX3AToLSi3zcdgQniViay+gb7i7yQsJuCDwXDU8bDIuisFhxmtTrCXHHHDyG?=
 =?us-ascii?Q?zK0QUZ+A5LmTeTuyRU8ZfJ7b3flL+XwsE8ltXQTv+pDnzWNw77KJEh3pU3cv?=
 =?us-ascii?Q?9dXs0uMA/B/eNvwlzl98yqPJubYo0zDfyr187glHVo4EMoc1mv/OW3CwHQfC?=
 =?us-ascii?Q?hSjxkHvDV7GMbi2dFkJNLNPFw54Rv9pq1hjqIFdfL+kqzIFjFNVkPobMNYsc?=
 =?us-ascii?Q?Le0gwKkEggf21sIFgyuY53XjEOn/9sTlaiC2ga8WQo0yWejT7eL38nVJIusq?=
 =?us-ascii?Q?ejnSNMCXlxKgNZhGIlfNYMrDrdn0wVVLbPiy6UkXWp3zwTtSocTQpDHQdrNO?=
 =?us-ascii?Q?L3vthHkkmHDQdYlqZlK4Kec=3D?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46b718d-86da-4a3a-b994-08d99c6ffd79
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2021 13:11:45.9154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeKbZBCsxTymJwwOfztwBaSKRSjtRennewnTRgLTT+vktIozj9mgu8E5JLAn/qCg35du+VbtIvYf9lNGf893Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3349
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
v21:
 - Address style related comments
 - Fix static analysis warnings
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
  [v21 1/2] nl80211: Add LC placeholder band definition to nl80211_band
  [v21 2/2] wireless: Initial driver submission for pureLiFi STA devices

 MAINTAINERS                                   |   6 +
 drivers/net/wireless/Kconfig                  |   1 +
 drivers/net/wireless/Makefile                 |   1 +
 drivers/net/wireless/purelifi/Kconfig         |  17 +
 drivers/net/wireless/purelifi/Makefile        |   2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig  |  14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile |   3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c   |  95 ++
 drivers/net/wireless/purelifi/plfxlc/chip.h   |  70 ++
 .../net/wireless/purelifi/plfxlc/firmware.c   | 276 ++++++
 drivers/net/wireless/purelifi/plfxlc/intf.h   |  52 +
 drivers/net/wireless/purelifi/plfxlc/mac.c    | 764 +++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/mac.h    | 184 ++++
 drivers/net/wireless/purelifi/plfxlc/usb.c    | 908 ++++++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/usb.h    | 197 ++++
 include/uapi/linux/nl80211.h                  |   2 +
 net/mac80211/mlme.c                           |   1 +
 net/mac80211/sta_info.c                       |   1 +
 net/mac80211/tx.c                             |   3 +-
 net/wireless/nl80211.c                        |   1 +
 net/wireless/util.c                           |   2 +
 21 files changed, 2599 insertions(+), 1 deletion(-)
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

