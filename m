Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481B5564172
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiGBQ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiGBQ0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:26:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2114.outbound.protection.outlook.com [40.107.92.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16A5DFED;
        Sat,  2 Jul 2022 09:26:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VA40oN1ANi+rAwnNap3tJPNTz/tcpwlF50AsgJ8++Qy0cFS4nxS4dnvh9FbcTObGmGuU7rR8+C79xRS/o5YoWmKO9DD4Kw77vuOj0uLIeQx8bVMLpz1J2Bt9oDhGAZ5N0dHu8UNeUVHnjyjDMFg+KhfJcz6dQn+HhlqoH7InqdvGdDNNoUTbhJSVVLBa2Qn7oR73F5mffhXkCjWAevummPOETeAWky0+EgH/1wuByWeQy5kZ7EOnOWSDYS6CMer/cghDBKoMoBlcdyYfp9dEPJEJb3XywdSWkoVkAoglu8X/q7EKDA73edwjvE1RwSz22C7S2Y5MNRVFUpLvW8S6IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+E45SgW07JI+AI5w1Jf/K9A5aoqBFwTMUsmH9CoNJDQ=;
 b=AaT4lmXWeBdmG4FltaLpwZuwHM8i33JbIGy0RmfcUxpDDdUD+Y21hWNDFExFe1oBc9B4DS6hhzXQqOaSPa0z3/fENhzDQ+3BMTXms/X/lZBn3/j3Twoqdu8KFAWD9AxbZ3kt9aUNdA+FQ2EFn1cyc6wtP/gvAK2PdCe1RGgc1XCMYl8MWcd46eNF6ACdTJaZ8bixMWrZv5jSxZvMhgXT+r5LdoZbdfG6N8KFOqwik81jvC7Obk2IoIP6njJk2IwfWoPU5oSpB7O0M95iA1yZMFxdujWj2Uee8D8ctzCk85iuoito6IkQEthqlxjI7tVYqJItTyzkw/H3ugVBUXFqKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+E45SgW07JI+AI5w1Jf/K9A5aoqBFwTMUsmH9CoNJDQ=;
 b=ta3EP4hYYIqRWNeENcVMrU73h4kYLa21TmI7Dp1v0A/QXbmclb+MjDx3Me1ZORk0g6EXKgQ/ZBzpWwRDqQcBr/YHUWGb3Ozu1c4yzIqv0pFGNCGbtvmwJI3914kfDgYZKOBEwrSlujuT2G8bFfMz4k2IAHFdewLiKuNf1rqilH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB3158.namprd10.prod.outlook.com
 (2603:10b6:a03:15d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Sat, 2 Jul
 2022 16:26:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Sat, 2 Jul 2022
 16:26:13 +0000
Date:   Sat, 2 Jul 2022 09:26:10 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v12 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <20220702162610.GB4028148@euler>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220701192609.3970317-10-colin.foster@in-advantage.com>
 <20220701200241.388e1fd5@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220701200241.388e1fd5@kernel.org>
X-ClientProxiedBy: MWHPR14CA0045.namprd14.prod.outlook.com
 (2603:10b6:300:12b::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0945c1f2-81ae-4f16-d1fd-08da5c479459
X-MS-TrafficTypeDiagnostic: BYAPR10MB3158:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcmJ/UAYz04r4hQibf/d9WcpZlmrPJCnI4+Hn7HeAVKPJeKbb7mitBU4eOAfKFTWgUhbDMtg5BGZoNlw+drLHwfQ2E9jWc0bl/IZ/FAe5O4PxBVpvvhY5sMnEcUn7QwsIbWnGNrAvtdMv+nFP0FJrNW5V4ve29f8pbvZLIfV7zPfNQ8uv61oixfgZtCo3ZNZ3lmPB4xiIDbZagIPQAxmQ/5TULxHk8UzcKQXmk6Ie72x89kPaGFFayR/Ugx8d5eVVrTybBn/VpyBuAM/aWLowVC/M+4FuZ1i3lgH3zVTojgAbXvlgb1OKhve0i+bX02ffFmqIbYjV6I/ruupMt7j/0m12MxacZRRrhNUUC8Mo/iwjjI/q7jUucNlucPnQiDl3Jp9NWNxA03wKoM4Zo/LVyVAi/GVgqypAtZH2lpsw4sSaeKCpE3F/JKp4hQHc185DrL5UdRQWVLPV2wvWmzuO9ngwDj4msexbfVjvWzHCBIMHI9u1t3OPzJNhoyIVtUth1XDjwb8qsJQM4o1bS39kw2HlQrb9siqSWdjkPvjyMNY1hq1ws+0VBGKFGcerEl/6n2Li4sZNYg+ISflv/Gm8mcDVqBk+B3/wwVhFZLmVJfhe/TC4UNSo62gGFjdLZhVD07beYwAsGavRvvQ5wusS6UTkoICfpKV2IIUNKx3llHt7Bz6mS5UwMMGo9nxZtIWeHjNuI9uq72ccItNGAcfskH/hu3qGcUaRoT5NHSNLn13BgYRsz4MQg6xgVF7b4LPeJz4w+yu1lbnqP812wps+MatiS0xBvifqp0MaVuYP5RgDNHmuDY5sqaRIgpQR6Lt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39830400003)(346002)(136003)(376002)(366004)(186003)(83380400001)(33716001)(38100700002)(38350700002)(41300700001)(6512007)(9686003)(26005)(6506007)(52116002)(316002)(6916009)(54906003)(478600001)(6486002)(1076003)(2906002)(107886003)(44832011)(66946007)(66556008)(66476007)(8676002)(4326008)(5660300002)(7416002)(8936002)(33656002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkJRc1IrdWJCTzVMU3JFb1V2emoyVVR3REg3dmIwU2VUNXdhd1hVNjB5Zkw4?=
 =?utf-8?B?SHpDN2pUcWJSOFRjZFpPWHQvdURJM3ZwYnlIMGVHWWwvRG05UnVZTE0vRHYv?=
 =?utf-8?B?dkViSE1vL0hBWHUvTWdnRncybll0dHZDSnU1U1Njd2lCN2s0TCt0MW0xTnJy?=
 =?utf-8?B?THFPcDFwalJmMVU2dlpOWUdzS25QMEhXVldnV014ak5DMlhUMFF5bDlMV3d0?=
 =?utf-8?B?aE1sYUU4Y21CZVhzVUpFQzBpYXZhaW1PcVdWdnBjNG5PdjJmd1pqWlJIYnlx?=
 =?utf-8?B?clRkMHVySzRFaWErT0FNMHo4S1RqT2pRRGg3VkIzZU5GZ3ZHMDArczNFTDJr?=
 =?utf-8?B?R3RnTUZFQXZiUE9OaTJVZk5hYkVob3o3TXMwSHNNaS9qN3JCUGdrZnBCVVNL?=
 =?utf-8?B?WDNmT2FkeE1hRytQWHd6YU5memJJbUpPT24xdThzVm1GYTQ4clRyRDVhTTlO?=
 =?utf-8?B?Nm5pY1BRWTZBd2RnZ2VBbFFBSGJZajRNZXpxWWNaZVVYSGxQTzlha1V3M1pN?=
 =?utf-8?B?eU1uOTQ4MzdCdVVHSitONEhtTkhJZHd2RkFlaEUydHUxTklWV05WSTZoU1Na?=
 =?utf-8?B?OHpxcWI0ZHZ6bXdCMGpzUWJZN3hWVWZZMG5DbllWSjJQazU3Mk0wMVVML0Y4?=
 =?utf-8?B?dFhyS3Blby9Gb21pbjhxWFpQR1F4c3M2Z2Zabis5M2d3MnMyajVpYzJqSWw4?=
 =?utf-8?B?amZhYlpIZGpEU2VEVHQ4MWtWa1ZCTjg0bitWSUlpem16NFZ5Z1lQWWtTV3BK?=
 =?utf-8?B?bGJGRGlPMzJPbVhrdkwxcVkvZldUNG1GTnYybExGQ2NPdHFZZ3Y3RVd3NWJT?=
 =?utf-8?B?bW5iWGFyUkNmUTZvaGI5M1hEUFppVmpwbVV0a0VtdEVFVHpSM1hWTlliTW9W?=
 =?utf-8?B?QjFST1V6RFpDOUVKU1NzdkhoWkNzZDlnNjRIRVMwRk1RamFEUUpOcXNpazZQ?=
 =?utf-8?B?WnFuVnZIdDlpLzlrYzV1Y25Va0xPRlZ0U1drOHlrOVc3ajNqYXdGdlI5c0Nj?=
 =?utf-8?B?ZDFUeDc4Y1hCaXhlZENMTHRJTHFJSFliTUR6cXJMVDlzUnRnYzhPdjlHNlQ4?=
 =?utf-8?B?Tm9XbU9tL1VBN0JTeUM3OGpFQVlUaTFVN0xNcjZaQ1dMZE94L1BKY2FITWwx?=
 =?utf-8?B?MldSSjZWd1VpelNQVnhWdEppaCtxaGcvWWFSbDRoS1BpUEZjc2ZHWnVaYXU2?=
 =?utf-8?B?M3MxYm1EYnhKSTV3ZGpPTUhNU3Q3LzNiQ2ZWb2ZETVNydG1MS0ozZFU1RXBO?=
 =?utf-8?B?dXF5VVNnYVVmdkdWbm1USU5IYXdpckFMQnRUdmx5U09lQWJqbjdRd2gwZjlW?=
 =?utf-8?B?anFWWWtoWlFEUk51UDBsaFJJd0ZidUZnSi9CRWxYL3BRaXpHWXk2ZVZQNkJF?=
 =?utf-8?B?aVpHMUNCdTFMb2ZtQmpvYUszY2NpeWJLRlo5c05GZm93ZHB5SDhNU3h5RFQy?=
 =?utf-8?B?a0NwQXJJSkozM1FRQ085WHVpeTlaTEJvVWxpYlBZNkVENFAxL3pJZ3pLTTF1?=
 =?utf-8?B?MWFSNDRxa3lNNGxOR0JzSUpHOVhETnR5dk9rbG5pcXQxdEFxdlZNRG5ZWi8v?=
 =?utf-8?B?UUplaFU0a3RnK1FtaGswNUpBS2twKzZORHdGSFJyNFhxZWEwaHZyNGZlR0E2?=
 =?utf-8?B?QzB6VE81WkJaTDd4OGFTZ2cyVHRNanFlazFmQ2dmWTE1US9CMHI1TCtEMHdr?=
 =?utf-8?B?bTk4MXVRcnJjVW1JdGR5T1BVVzJ1WmhFUWhMT2xFMzJCSlZ1R3h2c1d5ckJK?=
 =?utf-8?B?bnkrcmJuNlZNOEl2MmRNUkRrTnNqbjBvcDk3Q2gxZXM1YkZOcFFKOWRFL1Z6?=
 =?utf-8?B?Uk1qWGNKTFVzT25NdEM5UU1wQmtwaVpWUG1IZ1FNS0YwWTRKdlNYcTlsNTFP?=
 =?utf-8?B?SlR5THEwYURrUUM0NmZueW0vUkRDaEhUL3Z5MFRQd3FQZ3BvV3hmdXZoTmlN?=
 =?utf-8?B?eWs2MFoybk5ZOEUwSUhuS2hiWGJPOEhFRUdCTml1MHhTeEdPNGx5WkkxKzBu?=
 =?utf-8?B?Nm5QeXZhVThGNEs1bmlYV1FsRVF1L0QrcWVwMzJ6c3RidzZBd1hIUzZWeHhZ?=
 =?utf-8?B?NDVRN0IzTlNXREwwUG1VTFZMeXJRZmUzTjkvUEpSREY5c0pSeWg2OEJlbEhE?=
 =?utf-8?B?L2hKa1p1T3lwWnhWTW5kL0ZpWmgzeDJDQ3lydlZBYzJPU0lQNjcyaHlJMTdn?=
 =?utf-8?Q?5xW9RxenMtJ59v9g3092w9I=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0945c1f2-81ae-4f16-d1fd-08da5c479459
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 16:26:12.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdhFPPXscWKHZDCeSU+/zeXKWR8k+1tFR2seJuT4BY5BLgUsRkIyTKfGymCPN9J21xTB7QnVe7B5C4tv81rU9CEOL42zWjomdlK1KduedH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 08:02:41PM -0700, Jakub Kicinski wrote:
> On Fri,  1 Jul 2022 12:26:09 -0700 Colin Foster wrote:
> > The VSC7512 is a networking chip that contains several peripherals. Many of
> > these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> > but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> > controlled externally.
> > 
> > Utilize the existing drivers by referencing the chip as an MFD. Add support
> > for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> 
> allmodconfig is not happy, I didn't spot that being mentioned as
> expected:
> 
> ERROR: modpost: "ocelot_spi_init_regmap" [drivers/mfd/ocelot-core.ko] undefined!
> WARNING: modpost: module ocelot-spi uses symbol ocelot_chip_reset from namespace MFD_OCELOT, but does not import it.
> WARNING: modpost: module ocelot-spi uses symbol ocelot_core_init from namespace MFD_OCELOT, but does not import it.
> make[2]: *** [../scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> make[1]: *** [/home/nipa/net-next/Makefile:1757: modules] Error 2

Yikes. I'll button this up. I'm surprised that I need to import the
namespace of my own module... but I don't have a strong enough
understanding of what all is going on.

Also, allmodconfig never compiles for me, so I can't really test it:

make W=1 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j$(nproc)
...
arch/arm/vdso/vgettimeofday.c:10:5: error: no previous prototype for ‘__vdso_clock_gettime’ [-Werror=missing-prototypes]
   10 | int __vdso_clock_gettime(clockid_t clock,
      |     ^~~~~~~~~~~~~~~~~~~~
arch/arm/vdso/vgettimeofday.c:16:5: error: no previous prototype for ‘__vdso_clock_gettime64’ [-Werror=missing-prototypes]
   16 | int __vdso_clock_gettime64(clockid_t clock,
      |     ^~~~~~~~~~~~~~~~~~~~~~
arch/arm/vdso/vgettimeofday.c:22:5: error: no previous prototype for ‘__vdso_gettimeofday’ [-Werror=missing-prototypes]
   22 | int __vdso_gettimeofday(struct __kernel_old_timeval *tv,
      |     ^~~~~~~~~~~~~~~~~~~
arch/arm/vdso/vgettimeofday.c:28:5: error: no previous prototype for ‘__vdso_clock_getres’ [-Werror=missing-prototypes]
   28 | int __vdso_clock_getres(clockid_t clock_id,

I'll try it without cross-compile and see if I have better luck.
