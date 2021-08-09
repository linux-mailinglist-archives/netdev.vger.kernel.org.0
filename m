Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EC63E3F03
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 06:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhHIE3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 00:29:40 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:4780
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232877AbhHIE3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 00:29:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npTqNFxzJU7dJrLi94DP/V9JQ3n/enQSSjfSahpVC+vhjA4djkHi/Vrai+6eYGNO8lXXXBy5N1IcLz4+51iKwxxiYz0GvKi0DmBcIoUoruA7aTPeyYNr58nvbtBvkE/+54YgTeyeWWse/JBH8ocSDfFTngMdQdz+BNq2Ku87ngMmqCvYSA6aSPMP/EqsL80ITFClFCgRiItv/FLAHwMSTOFH/91re1kqcsdh2/yNxBv6wR6Vu0v9OwVUxmEItN1XpnWcoJcO9sT0OEwNT/4IzAGK9RA35h2lxU8zY6DGJK45U5dpiAp/Y7zu8JQxvlkreLirp6Fh4mVBzG+yMAm+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJYF8Qexg42kUgU3eIqMfgDSFA9m1abg1WBHwAa7uss=;
 b=fbzfF7GBXanw2O+aCyoYxJAZVILEM+HTDP++HYTdHYvzQWorPyJcsUv+iYVYWULsZsUjvgX8RO4m+4LVMmstB7fzD9cj+rNZoiK7bALE0VfQntK0N6odsdwknQqa6aG6PNPZxrxJ2eBiGuIPDdZoy4BWbov1NRL2QAn/RLhDWcHsC4RGkQJfBPo7+D4bgjQurQXPnbTP2j5Ej6dunB7drRtKZu1j2BJfxDhXMxiIrX/zY+pnZYK18gq4kfs7GsSGTvV9wwdJYhXBNblbmKA5rP+o6TvzHzT3IvZy4EcsY494n4gmS/C2KtTBUCC8LdPXS7X9Jy+NvVBcXCp7ZZLi4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJYF8Qexg42kUgU3eIqMfgDSFA9m1abg1WBHwAa7uss=;
 b=n2EyBedQqXWlJxAF+Lob79ZsB6faEjSidb5BK/Aso166psXQHwX3mR9wKbhgXTDaZAw3EWNjTlQuQd/wZ/EteptjLLnEjiDvcvhJKcIyhsFlNqaow4eFWOYen+ENHpMbuKCs2Owa9qo+1B9orvQbkVrdQIWhyOx2mf5i2qOQSts=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 04:29:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4394.022; Mon, 9 Aug 2021
 04:29:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, groeck7@gmail.com
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH net-next] net: fec: fix build error for ARCH m68k
Date:   Mon,  9 Aug 2021 12:29:21 +0800
Message-Id: <20210809042921.28931-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.4 via Frontend Transport; Mon, 9 Aug 2021 04:29:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f381030-a79e-49d5-fe99-08d95aee3fdb
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB272664407ABD8D3F8A53196EE6F69@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0ugfHXAG9QuPYnUf4AYq6F649+dF7ryrbF9pfTQMNzhEDPpDGkP2sfviRnX17xirqPph++7FZtX4J+OzXO/xwaXHWoYV+JH3row0k+1qw8I4x8YAGNzTQRvu2Vz3HHEJxpLDODnAhnbtoE6xwqwetd004WgWJQC29PCR0XjBOpOxcnORKiL6boAL3ybo/fGdC8y3r11K0sfaw3eLbr/xRoaTVCI98gEZZifkmPlEOt2qClcsCTYFsUqO1Tr7+BcO3kA0vUc5c3Cqcqhx8ngzJQ0YTUjGDqmDoM6Skd6P4ILUYmLHx5HUt8B0LUlI/WdICb13JDRBK27rn5tq93R4198fhjyGpdsoA3GLG4HkibDUUYFKcnYO6HXFuR6Omn66OBgS0YtjgJvp3vC8R50j/4sbmXuGyVkI5+dUeshmpNbF9V1ZtXrSlouasfMinQtTpta5doa4/j+vTP+UkwOpX9EG8zBgKvMnqQuMj1xwGddmSBp8LCS8mhWWfskV8hHFVC8q4jJJyX2ojD5rNErqsRwklILq6+oA6Fs38gfgiDglKLg/mda4SR2GAJ0USTuwZpPFvy3JTWzK7gFmzierty13Z8dDe8UWygP3rnRIatmdbL5+y+IFI8WNiZKt6VNCpxfH+XBMg2YuzAWvRWOZ1TjWVt6V5gVEb7PCSI0ENb6JCpY6uRXhQKoovq6P/sHGz7k+e7UC4whH0UHKNeR78OfI85ehIL3sHHuLjf++/95908GtAeAcrD7U5W4Y9vdwaItpngXioRjk7/ap8VJ1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(2616005)(66476007)(6512007)(86362001)(38100700002)(956004)(6486002)(36756003)(66556008)(6506007)(4326008)(66946007)(186003)(316002)(38350700002)(52116002)(26005)(2906002)(8936002)(478600001)(6666004)(5660300002)(1076003)(8676002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYjJx6TLz1YseEAKEwgUGjZ7kchjtWzcq6WwPPj2suLcuA+keS9JDaSU7u+l?=
 =?us-ascii?Q?s9H9AIyXJRTwyjkYnNvQNlZLgdBVRfXZlYNRf+y/rYRPArM6IIiEdRJlZ2bU?=
 =?us-ascii?Q?a+8WwJWaEq8VZ8MBsFw1FO3dCuUE/WrZsi7xHCkPpLKzet93YY1+LWsFF48Y?=
 =?us-ascii?Q?16QD3W8cTqquQkwlo6TegMYX+Tvdb63WB8W20J5jGJgZJXCoCfz4od9U0qRj?=
 =?us-ascii?Q?EgPT2rOJAW6I7yKxD3O761RKV/xs48j0jqpo/Vk5uWuKou4bq4IHH8jymbMi?=
 =?us-ascii?Q?pE14/v4ZQuwWMypQCrNAvxGBGOBxWXSBH/qI6xD08pWbPGnxyZniJ2WwxsWX?=
 =?us-ascii?Q?moX4qPuQcWmZ1TOZ2scPTQUYXyB/uNLeZCtfZGq6tFhdBQ28zTIywqAJYalD?=
 =?us-ascii?Q?QpnyetuliW75rSOlSgFkJQBch1HNR5BW/lKYRCnoFgw1B4Oj4sejoHus02ps?=
 =?us-ascii?Q?PZJphYtdATkSwYFkYlxJBZ0JiOk52QKM8msHCkTX98kEkgncU/G8v/cHJoQ1?=
 =?us-ascii?Q?eC51Uw75HBZE5eMpwQXcQrmYSQsnrelXO/SVr3S7xzEfM5DrjT2qiGYgEUE0?=
 =?us-ascii?Q?YqdQWvtxUy0hgv8rGguIust+BWybPFRGkqTyY5cqw/wnZz2dULNl5+DvLJAp?=
 =?us-ascii?Q?EbWy/s5BoGJT+3r7RKaLVKUUGFr6A53pU+nmjQGzN3Ss4fIDgAeD9cw0rfUA?=
 =?us-ascii?Q?6Zg2HvZLxMs3eTiLtftwwqur/NuX2nrEcKzHWPet1L1pUE0OQK9ss37zkHND?=
 =?us-ascii?Q?Uk5sWgXWvUs9ORzlXETu49Qud7Z11sl8J19X4Oo3cRGRl+eFwR+hq2lCf8lv?=
 =?us-ascii?Q?Xu8Uuhi4oK1QU5DrRCHzaRndUyqMATdze3iVawTBMK4GtmpWvwjcLg1xFuP+?=
 =?us-ascii?Q?17sRWidJvqBA7YdTCYFANtFrokrWCkO4k8AtnEdoH71zFrqC5maTXIR2ghBN?=
 =?us-ascii?Q?wfA+56Tk466Gy1u25Ci2oYExTRrVg0MeHRgPbOU3LRigEaAhxXWW/pFoOWIj?=
 =?us-ascii?Q?B8DmJZL9ztzcHQDqPK1yglSaB7T0lXDEG9QOikOWKRjWoJl3MUsWzO9QUbyI?=
 =?us-ascii?Q?ZC5gKnsMnWQoeB9wIaLHQue5GfLYPNrtxOPek0401Lcu4oOqYy1tyRC0iBdP?=
 =?us-ascii?Q?z3Zr9Fkk5/MpVgbNDnFKf0qYOOngwmUIQ11n9z+MPnh+gIK7NHJoRR77RnLT?=
 =?us-ascii?Q?AfrfVEbG+Fy4r/eVF8dzfn0Lz7O3faGfhfrXWtTKM2XwM/Wmttb7cf0KzMIF?=
 =?us-ascii?Q?s8Vl1uUbdTpTO+EgLX+lsgYAfGssOGUA9Djtd8qy18qBwJtX2GdzhZPxONVD?=
 =?us-ascii?Q?ZPkw2MhFTsWt5+bPsGkqKqwD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f381030-a79e-49d5-fe99-08d95aee3fdb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 04:29:17.1894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hiHxTtXP3ItMSrf6ZzP3ovdi4H7XUHBvXioC7qd88P5mJh36xAIIDozaz1n0qlhSgFd/el+rYSwUHndkkaGrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reproduce:
	wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
	chmod +x ~/bin/make.cross
	make.cross ARCH=m68k  m5272c3_defconfig
	make.cross ARCH=m68k

   drivers/net/ethernet/freescale/fec_main.c: In function 'fec_enet_eee_mode_set':
>> drivers/net/ethernet/freescale/fec_main.c:2758:33: error: 'FEC_LPI_SLEEP' undeclared (first use in this function); did you mean 'FEC_ECR_SLEEP'?
    2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
         |                                 ^~~~~~~~~~~~~
   arch/m68k/include/asm/io_no.h:25:66: note: in definition of macro '__raw_writel'
      25 | #define __raw_writel(b, addr) (void)((*(__force volatile u32 *) (addr)) = (b))
         |                                                                  ^~~~
   drivers/net/ethernet/freescale/fec_main.c:2758:2: note: in expansion of macro 'writel'
    2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
         |  ^~~~~~
   drivers/net/ethernet/freescale/fec_main.c:2758:33: note: each undeclared identifier is reported only once for each function it appears in
    2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
         |                                 ^~~~~~~~~~~~~
   arch/m68k/include/asm/io_no.h:25:66: note: in definition of macro '__raw_writel'
      25 | #define __raw_writel(b, addr) (void)((*(__force volatile u32 *) (addr)) = (b))
         |                                                                  ^~~~
   drivers/net/ethernet/freescale/fec_main.c:2758:2: note: in expansion of macro 'writel'
    2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
         |  ^~~~~~
>> drivers/net/ethernet/freescale/fec_main.c:2759:32: error: 'FEC_LPI_WAKE' undeclared (first use in this function)
    2759 |  writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
         |                                ^~~~~~~~~~~~
   arch/m68k/include/asm/io_no.h:25:66: note: in definition of macro '__raw_writel'
      25 | #define __raw_writel(b, addr) (void)((*(__force volatile u32 *) (addr)) = (b))
         |                                                                  ^~~~
   drivers/net/ethernet/freescale/fec_main.c:2759:2: note: in expansion of macro 'writel'
    2759 |  writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
         |  ^~~~~~

This patch adds register definition for M5272 platform to pass build.

Fixes: b82f8c3f1409 ("net: fec: add eee mode tx lpi support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index fe4dfe2d25ea..9d0f5854288a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -189,6 +189,8 @@
 #define FEC_RXIC0		0xfff
 #define FEC_RXIC1		0xfff
 #define FEC_RXIC2		0xfff
+#define FEC_LPI_SLEEP		0xfff
+#define FEC_LPI_WAKE		0xfff
 #endif /* CONFIG_M5272 */
 
 
-- 
2.17.1

