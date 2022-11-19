Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5625F631140
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 23:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiKSW2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 17:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiKSW2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 17:28:44 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2094.outbound.protection.outlook.com [40.107.212.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04C062D0
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 14:28:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EomHHX9i40CWtyDDsxutS8t9TdglOQjN1BSRlE76AKL6Mhy2ytU7fmFfhxdvRpmlXzRPrpTBUE694DB3uZSZbGI96ZM11db1MLUxB+QIPc5+B7Kz6LVqq4K5nVaSaRhYfwFhw66AZ2w66Gb09Czq/R1MWQ//pVJLp/NbAybdQnFyVfpevDYZxFdirT1evTMXrcvyEe5RyKE8jPcUuL2IAsH9qDPdESf1jIKdF571fRE1yzQZcZVX9JiuLggRQgt3PauGS8Jfj6TDdD336qYPtRUu79R2qPHRMAWW9Yt5aM/e9oUp7xkidO7lqpWm7AyZLBaejPyfKaiccTmxP0wEEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EnvZhe7Q1OTS7ayuxwaNpvcZnteVbY59ecC6AGWsYII=;
 b=j+y2jbdx52PWVBytDt95ntl6B7xP2pTdSGJTQp4j3/dYttfGpH+VyeflKr3pzxtk9kFes1rwL9n9sf7CDCD60Atz1feyszaUleqAkOSZS+wdWoJ7XX8uiuN8qc5nn2VajDrjvSgOu/a1ZfFcGbNplnkhhNpRBnl3St23XfxFiy2ZQbMrDktPGCuEGwOv0pMvm7Nc3vDN1h+C6sYy59IDSGJntBlGlHIZrXkWXNBFUWM6Ijnd98qoX1TDT4c+tmQmB/5t30ZM5cMO9GPpwh06a4KrXBBQNNPkYarZAHTHd4wm72/A57aiY8KxjRxxeoaGv5HiBFYt7tx35xQllXo+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnvZhe7Q1OTS7ayuxwaNpvcZnteVbY59ecC6AGWsYII=;
 b=U1pvOM1Xw/QmdXnMqmTh600j4rRFcXp4r3xKK0aN3VDdYMuYltP0GWh8qNEXzMbfbxLvyr2cQMsppJgbX1Wh1whcrOMtgT/2RvHxobiN6UjGhjftNNqiSqXE60EES0QAQWy5ihV4OIf+vcbEradyYc8lg7tVXtbhJBFwMbITL7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5012.namprd10.prod.outlook.com
 (2603:10b6:208:334::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 22:28:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 22:28:37 +0000
Date:   Sat, 19 Nov 2022 14:28:34 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Kernel build failure from d9282e48c6088
Message-ID: <Y3lYkqBhw1eK6dth@euler>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:74::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB5012:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a93e726-9e6f-47f0-2666-08daca7d670f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+FAK1ak/9TUvvgrN2D78sOvMw/VB/mtElYpL/b5IwbAB8AOhJZmQpfW5O58vPYoH064NmSLSjj0guQ1NIMUY3GMaHfm8a8Gi4C+0/LUC2+CaEpaJW/kFz2Y2Q1J+we884D0i0f7LA66JUH3uQlQ161rAhVeuqr+Have4gz5ztrZbmS8GT0O4Yy4C/IYlkUOJ2NmDhoTkNQQvhLdcoU1OyFWoPLo4zLpJjLmVE6LkJvr6sHqgI0iRz6AsVgQKI90fx1Y2LpqAwHY/jfyacpVS84ZmTU5WmLDpFMZaY9qghI0Lj//iBm9ADqkh+dxyi5G70/H4jkS5VJpdurR5hfoaCxy6KoFHfVxlLKysXHiTmIMnYhteFbf8uBkG25De7pfORSXLxzZJpmoNRxlFOXTcs0k3n/1y3HkHl/kCM39gmmwn0dYiN3WZ5vk9NYjOdF/5iN8LWeBgCDfjDjpwNjqLqOF2R0nNy+5JgY4yeTCN+Z2V7Xfy9toSfLNnAdmuN8Y5iDdK/bv643aqJJVbxxm2XTzDPotJ4QGpWK+6l0+8nUmKJt8oIybRQse5FbF4mmbd3PZP1rvZ9C9+C0nJtcsL4zYq65RmiMMp8/2120DmRGsXSS4FcueTBk7uEnrfq7XLnRW8yRx+qSH4gC2cSH9VyGlkCWuCeNVGZylsVLp+91aMyBX7Rhq5yjvy1QtsiuX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(396003)(366004)(376002)(39830400003)(136003)(451199015)(26005)(2906002)(54906003)(6916009)(316002)(8936002)(186003)(5660300002)(66946007)(4326008)(66476007)(66556008)(6512007)(33716001)(8676002)(41300700001)(9686003)(86362001)(6486002)(38100700002)(478600001)(83380400001)(6666004)(6506007)(44832011)(98903001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1ZWalBaUm8xME5UMHByTHJPNGlqcGNhZndhSjZzWUVlVEQySHhLcFhMOVps?=
 =?utf-8?B?a3VpWC9oRmswZ3lTQTNIS3dpSisrMU5rS1JYK2ZmSUlScTVsRzdSdDN1QXM5?=
 =?utf-8?B?Q1dNVzlPWmhjSE9UK09JNmo2blp2azVBVEZwV3JaT0JZdHhzTGE5cTJvS1Zk?=
 =?utf-8?B?eHNXcnE5aVpmQTFzWlE4dk80RHF0dDVjaXFxWGxPbVlZWHJuODV1ZlpUeXI2?=
 =?utf-8?B?OGU1Y2lnRE93blZDNjJuSG43WnJxa3ZBcG5XNzRJeGZucjZkbHdxck9QV0Fx?=
 =?utf-8?B?eUxXdndNcFMrdjBtbTkvZ1RiQmxnSWNXT0k0Tmg5VTRNN2FPVS9NODNNS2ZE?=
 =?utf-8?B?OFk2K2tNNnJRUVl5VkxQQUpBR0M0M2x2cmhIK21HWEtsdHk2SmYrdkJkQytH?=
 =?utf-8?B?T2RUTEZPejRRVGhIRTJmZmhWdGFxM0Z5WXkzS1FrYkZ6NUNDZWNVQVFzNzNW?=
 =?utf-8?B?L0FDTW9DbUJiWU5JZzZrQ1dyWjRUcWplbXNqWmFoeUhLczlXaVFJRGgyUnNP?=
 =?utf-8?B?UVorNFRQcHBieW1FTFFTdTZKT1E0M1JCenFZMjQrQlZaQWZUZzZHTlp5TEZt?=
 =?utf-8?B?QjRadEhYYU9mUXNCaDM3enhkdTl6azM5N0ZMZnhGazVValNBSi9iNlppRzNE?=
 =?utf-8?B?OW8xSk5IRXR2OUJ2S2tTdEVyWDVDVXA2ZDE1SmlzNW83UXIzWWp1SXpLM2E3?=
 =?utf-8?B?YUhTc2l4SHdraDBVVXBhUDFrdk8yOC9wSStqeUErUnBxQlBobGpLd09yQ01a?=
 =?utf-8?B?Z1UzSTZDY1NYVUlYQnZ0Z3lrZUk5Z3djQ2lXUzlQMWtqNTJieDlTUzRwSWVz?=
 =?utf-8?B?NjNWN0twdUQ5QzUzUDRHSFJTRFdFMnN1NDJQSE1IZ1ZVYm1lUkQzRUF4WkZM?=
 =?utf-8?B?SUc4bHhGK3Y3dWhWOGZwdjJzbjhGOCsrckJtOGxpaDJMaE1tdjltZlR6c0I5?=
 =?utf-8?B?ajZtN0V6RnRpMmdwVDJaUlA2NlRScW1PZnpBZWVLSk13dUZFY1RlY0thc2hJ?=
 =?utf-8?B?R0I5c2N6UUFTQy8zMmh1Y1JBamJNUDlVZS9sSjQxNzgxSzRkdDFlMUJXVENO?=
 =?utf-8?B?UHR3Ti9sQ3Vna2Vzd3NWWmpOdmliamhLNU9rRnBEeHhJTUNqanFBZi96aDRV?=
 =?utf-8?B?dWVmbWJpeTRyK2ErTEw3cUVBUSt0OER0bjhVcERibDFTbE4zay90SnlDU3g5?=
 =?utf-8?B?bnJIZlRWRWRrNStod00yNjc2RWVSblJPR1hoU243elVlZ0lBYU5MeEFkcnkw?=
 =?utf-8?B?ck1CeGtMZmJaclVrMThCdmEyTEFvZVhvdjcrczhib01IY1Z6RzdMcm81NVFw?=
 =?utf-8?B?M0FMamVtbnhVS0tyNC9lb0F3b3BGRXVNTW4vWEtlaDNnL3RNVzFYUmdvYk9V?=
 =?utf-8?B?b09iQlJabGhUMTNwN1ZBM3cwRytmWnAraklOeXdBbjlKK3BjRytESUJPY00z?=
 =?utf-8?B?MnNqVENGM1JDYWhqOU1oTVpTS3lUam1xMGRlRTJkeHdIMXdjcllabHl1alhn?=
 =?utf-8?B?UFVMcTFwYzlVemlRRWRpcVNPVjBQRnNMK3FqaW03TmYrUHM4TUJsVXZtSHdZ?=
 =?utf-8?B?YXlhVnljeTZCaHcyekR2eUhkYkxvQ3VRTHVWSUh4SFBxUENhRVJpeTQ3cllS?=
 =?utf-8?B?OU55dmw2Y1RxeWdUUUt2YTNzWjU3S0c5L0RhZUJLTWk0aHQ4N0k3RnBzNWNq?=
 =?utf-8?B?cVU2azRpczFyUExnendNWkFaK09ITmtVOTJYb3lIRHNidys0QitJa1RGU1RG?=
 =?utf-8?B?WmFsb2JuVXVIMXZLbnJveXFVL0swOTZZOTRlMWJpbnFkMGtTby9saHEzZWdU?=
 =?utf-8?B?YWpzcUlVQ0svYnNGZ29HNVk3bWlBd2MzcE9ES080WXdjMXpONDZ2TU1XY0JR?=
 =?utf-8?B?VFN5NVdHb2xtRno4R0NkYUdnOVRuZ2ZZVjFWOUhwK3BrdDRjMC9lWGJ3V01L?=
 =?utf-8?B?Y2pjSC8xV0lVQVZ1MUNlRTBoZjM2WmlBYnBrdnhGRldIT3RPU3NUbjhjZ3JJ?=
 =?utf-8?B?dmVZbzJ6YUNKZlF5SEFhbTRpdXkxckZsMTI3aFJNT3lIV2lveGtTM0xXNitI?=
 =?utf-8?B?Mlo4TnZvTDNIUW5wL1g1TWFuQXRvWUVxMVJLL3Z4eDZWMER4S0lJdDkrSzlh?=
 =?utf-8?B?d3JOM1h5WmpadTZqSElLaVZzZkV2R2VIMi8xSGpnL3VsMGF1L2ZMTU5hR2pa?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a93e726-9e6f-47f0-2666-08daca7d670f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 22:28:37.6834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56ni9/itBRXcI/lNFpT8+9Z0GMEB8bOldPnB+kjJU5hMXq05echBvUfXtcJ5FkWBtJzRY51VMYIq1ioNZ48+ZQeGoeZpjNQmJz4XXThK0J0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5012
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just a heads up, commit d9282e48c6088 ("tcp: Add listening address to
SYN flood message") breaks if CONFIG_IPV6 isn't enabled.

A simple change from an if() to a macro and I'm on my merry way. Not
sure if you want anything more than that.

In file included from ./include/asm-generic/bug.h:22,
                 from ./arch/arm/include/asm/bug.h:60,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/mm.h:6,
                 from net/ipv4/tcp_input.c:67:
net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
./include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
  387 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
      |                                     ^~~~~~~~~~~~~~~~
./include/linux/printk.h:429:19: note: in definition of macro ‘printk_index_wrap’
  429 |   _p_func(_fmt, ##__VA_ARGS__);    \
      |                   ^~~~~~~~~~~
./include/linux/printk.h:530:2: note: in expansion of macro ‘printk’
  530 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
      |  ^~~~~~
./include/linux/net.h:272:3: note: in expansion of macro ‘pr_info’
  272 |   function(__VA_ARGS__);    \
      |   ^~~~~~~~
./include/linux/net.h:288:2: note: in expansion of macro ‘net_ratelimited_function’
  288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/net.h:288:43: note: in expansion of macro ‘sk_v6_rcv_saddr’
  288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
      |                                           ^~~~~~~~~~~
net/ipv4/tcp_input.c:6847:4: note: in expansion of macro ‘net_info_ratelimited’
 6847 |    net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
      |    ^~~~~~~~~~~~~~~~~~~~
  CC      net/ipv4/icmp.o
make[3]: *** [scripts/Makefile.build:250: net/ipv4/tcp_input.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:500: net/ipv4] Error 2
make[1]: *** [scripts/Makefile.build:500: net] Error 2
make: *** [Makefile:1992: .] Error 2

