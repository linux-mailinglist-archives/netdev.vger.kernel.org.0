Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8245B54F4
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiILHCN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Sep 2022 03:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiILHB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:01:59 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFBB25298
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:01:55 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2041.outbound.protection.outlook.com [104.47.22.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-32-dRd6_DE-NT6tuD7c7U_vlQ-2; Mon, 12 Sep 2022 09:01:49 +0200
X-MC-Unique: dRd6_DE-NT6tuD7c7U_vlQ-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZR0P278MB0744.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:43::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.14; Mon, 12 Sep 2022 07:01:47 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 07:01:47 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "Andrew Lunn" <andrew@lunn.ch>
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH net 0/2] Revert fec PTP changes
Date:   Mon, 12 Sep 2022 09:01:41 +0200
Message-ID: <20220912070143.98153-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: MRXP264CA0043.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::31) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZRAP278MB0495:EE_|ZR0P278MB0744:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c8718ea-53e2-4f15-5fa1-08da948ca8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kvIuPsXWkSTmZodmLDVR9acABo0rLIAk4yqV5mSwyTImXpYYQyfha8bgMladP56zgn/w3ZJvqlLAHwTHRuqRTbuHrcl+d4tcNy+E44ljfjNgSwf5tyzh0+MJbdPgRmcZy6SKcRy68PJyKUWt7HrBstN5+/rSemd32TthcTeyOUePD7lCjjyO2XUHIZ7vKFSB/iG6z8q0ap4IY0RffEpXYod30ErPRUbuUddsHYH89CGUALmU4SYmgkGCcRzKDVELFBZ1+chb68cvrm0MCCnQ1alwJYnxLBz7Wh9G7lGtN0wubwXYB5OQMrCLffCE/srt7FVHLmS79kAHReXgP6OD/+qEpqhfYiy0ipZX8TbefvjoyoRhP5PqQ08SNczjpfzXyZZHQ5x1B8Fl3RJJZxCeBsE7VyH0QkheWJmZpRWq27IMwokgk6+ipeQzqeVfESJY0PDlP7BnuefcUkUDzHsCyb/tNqfy7GoWcEzAhEs3lOvEqt5tAC7AJW/eGTQmpwOoQQBRibfJqqQYzz6n25PRPalGdjkjvuTOcX34ZKQnSE9JUG5gQmgKvYpZjC1xsObdkCi2hQuvEdbmkK1R7TYhgDoet+7PU3o/toFKEaZ+AsYPQVL+CYCsl43pt29EXlJ2WB6GdVoOo7IsNqqwEO1sKweGAmMHd6oxu1mKxSUIwWSkoYtAySaBNP9v26xNJTOs6gCc8mven/l7m0bbUtGy/1LlaVt7fEhuNr/Y0Ms2jPsFHK1zkcY8X8/ncy5VsN2xzbXYxfTsFDYCLmr27TwLNo10KaWB97OXStoJsvjwd90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39830400003)(376002)(396003)(346002)(38100700002)(38350700002)(4326008)(86362001)(66946007)(66476007)(66556008)(8676002)(36756003)(921005)(107886003)(26005)(186003)(83380400001)(2616005)(52116002)(6512007)(6506007)(41300700001)(478600001)(6486002)(6666004)(4744005)(316002)(110136005)(44832011)(2906002)(8936002)(1076003)(7416002)(5660300002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c2l3m0xkrVC5K/0nmR8YlGDz7tO/r8YPX4AhGZGWichHt7Ngjl+9KPjtLDPe?=
 =?us-ascii?Q?VK1bfwziQ316DiMGLmAnpW1UjvUoIbhGyx6YP5X7apYGCfLDUKNOxzJSEGWm?=
 =?us-ascii?Q?BzFRHHmYrlPf5OU0Jlpo/vPO3u4BVb4wjvSknZHorRi/B4jEd6Ucic3mUU0Q?=
 =?us-ascii?Q?C8aAFmDeBPyHwewslDCKRPJ5K/mL0uGyAh7gjdSta07QjwqHJqOq8lIZ1fuY?=
 =?us-ascii?Q?hlhb9LSQfmoEdrF5P5/wJzIbYZ5f8Zt5N1F7wqqt9bWHu+1wKLiUOKlq5dr3?=
 =?us-ascii?Q?uIQMugVd39rAPuFEgnybJ5JboAjcV50plteiJkcsPKuFJ2Dir9Ge/UngUvms?=
 =?us-ascii?Q?t3fkKjC2Vg8FIBKHmI3vfbEVJmqgk2SjJ5IvwLFtE7t75b62mX/2gzTPOfUg?=
 =?us-ascii?Q?ZRMUJpmmOLTVyJEVqa9xCPxbdzOBCLERt41jn2BdKXn7RnwH6kjkgP+GZUsL?=
 =?us-ascii?Q?J0I+7FqRNaVZVTrz2ba9CY8WTLW64tN2kBnJfVH0cZ4s/81NrCdNA5rmi9qC?=
 =?us-ascii?Q?1QypHxNG4+GNfSYpFQ1ptGIsqO9af0wGva9keTDtUy98YMHQ70xkIXrnl4q+?=
 =?us-ascii?Q?Pjh4WIHTXVJ1OFJc4ePg8MeJRyaPLcmgnJO4amxnEng04pcECpj1vBz6VGWF?=
 =?us-ascii?Q?62tp1n50dM0mzSsY5JvrnSgUDdOntB7RZyz/dTLDgaNKKAUdBescH5yRMbsw?=
 =?us-ascii?Q?6+/+TPn4D5KMdfgjH9mQDzPKjeq1BeIv+H845Y1n7ima4ahXcmetrQJfkAK/?=
 =?us-ascii?Q?J1YW1kGXvpIue5RoFalKLCBhh8MesJDHZLA9KKvgGlVHMn3Jc2iMlO3vUOIX?=
 =?us-ascii?Q?RjYGIdeMGtn03A58BZze6Kbwb6rllZACkVQt6lIGOqBCSj8LWNZ2vsGYaGyp?=
 =?us-ascii?Q?5YEa0WowqneEmmHc83iWayJMt0ddb4r/qpuKSjFZZhRJykhCp793iDrtlTXC?=
 =?us-ascii?Q?B7NoIq81bzMCTRC8Bc8xO25ObNGZpEP+VAaJKTaqah7lGUmcEdhbPHFmxsMg?=
 =?us-ascii?Q?VhZaIoSNsT4NfM3LDpTW07tsyC8OUb1No+YcimMMkYJ/W2a3tQvBle5nl6dh?=
 =?us-ascii?Q?+5y/cvKYlffXKkKk/fBRSAu0VnMRErHxG32xVlo4Lfv1FE3Q8uU7ZTuoAtUQ?=
 =?us-ascii?Q?YNHJBeYUGvJ+GbOtovBoV8PT+yMtEYGHvTovhDBqPzV5WGHqwo3sTjmYv7IH?=
 =?us-ascii?Q?moBIQegNukHJk47MZy/MWMp4GwOxfy8vB4jpxolO4Mmzvn4FjGPRuJMAORU8?=
 =?us-ascii?Q?ynVqYwFRSCcB+OGkEqDvCNhuylT5d5zYbcpwizduAyndnBpl44RcBktxTPhC?=
 =?us-ascii?Q?scz6KF0+iHppT7MBWFbuAPARq0l4nNTotmperYwgHn6a2O9USy9lsKeYrpKv?=
 =?us-ascii?Q?Np60yY0kjGyEfA+B1AQ/v86oRALzi/s3qaEFU6/6I5T6lzS2uIfvqEdBZe/9?=
 =?us-ascii?Q?BVW8dCV9hf+q7aOJRZ7h3fVawnaVVAdIm5B75OGW2Im9xg+3eUN24ICg/4n/?=
 =?us-ascii?Q?x11JoRLlFpho/YrS1ZmxUJNfEai/NHxSztFAMBZ9umCCajksjkQIZJUA1s96?=
 =?us-ascii?Q?cAxEzm49+GMxQ8YWPzwJJ4LtphjPR+wPjDJD2F2P3KfeLbwYieGqKToBpo+G?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8718ea-53e2-4f15-5fa1-08da948ca8d0
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 07:01:47.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 38+586PzbYyewBAFC8MIA+vvQBKkdvPN4ZxYLW9tREaMiEtla+lVT+K6t5zzwhFQqs9LAsH9VMQ9Ir5VPQpckeBC8oEj/upkZBTmU9BHdAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0744
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert the last 2 FEC PTP changes from Csókás Bence, they are causing multiple
issues and we are at 6.0-rc5.

Francesco Dolcini (2):
  Revert "fec: Restart PPS after link state change"
  Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"

 drivers/net/ethernet/freescale/fec.h      | 11 +----
 drivers/net/ethernet/freescale/fec_main.c | 59 +++++------------------
 drivers/net/ethernet/freescale/fec_ptp.c  | 57 +++++++---------------
 3 files changed, 31 insertions(+), 96 deletions(-)

-- 
2.25.1

