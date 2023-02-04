Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC8868A8EA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 09:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjBDIM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 03:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDIM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 03:12:56 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2129.outbound.protection.outlook.com [40.107.244.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F9429E1E;
        Sat,  4 Feb 2023 00:12:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7JHm50+PJInVaXtc1ZqcGgqtg/iJ23/DApynaDTNeeXfqmmYa8G1bmQlwh93EC17g0M2DR7vSFFMQ0p5FuRcA/iMOdNVmRmpLl66YY6+1ENts5/NWfeXQ7U4+ONV3k2wAQyAHhdVqmD38yDYPrQrC/K3UB/4lJHeTQMloQg5tbXPUqwhNUre750yIyeUp8K6eDuFJXLXUF9ViIwABFSxy4oKXX0LJNaNRFWHwx6tEYaC72tiO34BPc9r51GsB+N+9B+My8nvzqMTwZNXOsDyDoLzYFlm9d530wNkuUgDqSja2n44eekD5vhUI0zD9a2TZTuNvRfKCZtsaOY10xhhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDwJZz2RfClW5Xxb06EIOhVzOZhHDzlBqC/0o5hd5VE=;
 b=QYGo9KA1pxuH7sAG1HVMIWccMWVZkGFFnSdkZazRzJ3x3fNTPPgFFkQph92N5ibGjnXZcXhpQ8ovRSZ78IqgRhq+HlMzdZU7iSF22jL2mD3FoHqEE41noUEklGfXjWmKHynANXUd3gOFaDjXBnTykA+j416c9p9LRpmUzYYjS9x82OtDTJLre7tPSwgK9haJ/U4Ts3JstAhAXA9D2orxuBeovRanZcktwAIaXmYwU5YK+QWk3sidREHIF3zcydDBXWNFnmZ/9GgMdMLyQqPs2FwxGi9iT0wmOMsL5SklhMoE/s0orHbXS+8HhRAUcZjfLQn5nI7VXeY8ufC/LHPIYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDwJZz2RfClW5Xxb06EIOhVzOZhHDzlBqC/0o5hd5VE=;
 b=R1k9FAAMkDjOiA5HPXtp0+mH7wyZZRXn7FH3iW8AYKVVNFzmBSMvU7un/UIZPc04nbvZkLOl9zhL/RC83/YG/mIedLsCKkK7Lg7v6Mh/6qaNL5JGpEtHk84pe2e9B16GvqIIWCplU6j9ixpA4YZQXujVhT40btrmTTAvu/kKw3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5271.namprd13.prod.outlook.com (2603:10b6:a03:3d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 08:12:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 08:12:53 +0000
Date:   Sat, 4 Feb 2023 09:12:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
Message-ID: <Y94TebdRQRHMMj/c@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com>
 <20230203204422.4wrhyathxfhj6hdt@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203204422.4wrhyathxfhj6hdt@skbuf>
X-ClientProxiedBy: AM4PR0902CA0020.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: dbdda9c2-b629-4e50-638d-08db06879d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUDbrU0Dniu0C1kDJk8YFH1horHEybrgRj8kY80XJnTmzVqtSW04+3TyuBKXs40dlbcHapKX3Rj/efs/ACGKPZWGl/RH/ZPvcNFt62Iovs/S5qhdIMlbz0kIw3AfvZugwSOrncNY0Z/s3bQ+QQl6kFq/WA+j3yd+7EWbNU5uBceq4ckhohFwER96Geg42XmbEKQ8rmBDQXm7QBBob7RkXcf8vqUW91A8UGHQPnO6MpiIyc/uT4ondZT/Aa0mBMcMrljKkeaxiocgk2IcUNePfSTxXmz9rXGrsyroL7RXrm0nOlEwrOmKfK8pXRjPCt+Rivk7Fezj+ekq6eBFUlwvMU0/15ZyVlkU7GsACSsJIPcxD80VkfZvKJ6Ead3rpkLOui19AxAVSC4dce/UeD0S4GX0JrqL6XtklPYfOCJTVHhkjeyGSZVvJ/cKGPgJrrAi43ZrLCVbeZ5n3k5VUJKia8WMbub7Gs2gGTHCq/3QFgkgzv8Bt6egMXM4qJxFBVH9eYK/YHVHQgUaTKSS91zZvfIBWfnUkS+MbScoNllU+Q6cscwgx4Sb5DSDIqECQy1Txwh6gKjl2qGGT5avXFKYO13tHnKDinVeyxMcTaIBGLTFtYHrC79TceMKxbAyD/CGHaWwqdLVKjZTUVkcu9oFFFrRFEEh3Ucs28YrduahGbw8Lyy8RpKayJxlyo97YC4R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39840400004)(346002)(376002)(366004)(451199018)(36756003)(186003)(4326008)(6512007)(44832011)(2616005)(7416002)(7406005)(8676002)(5660300002)(6486002)(41300700001)(478600001)(86362001)(2906002)(8936002)(6916009)(66556008)(66476007)(66946007)(6506007)(54906003)(316002)(6666004)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Is9bzGHqAdMsoPk7yWMFONBEQIqH1Pm/c0NWGyoUBlFiqH6DpubsHpoUYVnA?=
 =?us-ascii?Q?Mhy1ewJt7xdlo1uNXHAmRkHaxtFhLAPp8Sadlt/3QOh8Ie44zq13dqIwyixe?=
 =?us-ascii?Q?o+LiNMNEYv7cBwoEunr7+MQcZVMY+Wupl3gNYxTjzy/UdtjCsuG999Sw8kG0?=
 =?us-ascii?Q?fwxjFVOUOIczywPX57ubaN2S6ydKlmEF/OvWZNg2rZQUvJuPrPaH1ZnE/wPd?=
 =?us-ascii?Q?sPEfcw3lThKa+JfHdr9UAmY4sdoqcWkmLc3EfVdakjBK/RSgwdxLEqrJCHrg?=
 =?us-ascii?Q?6agEWAbsu80EcB2tw2lON0g6E0OWJpAjm1jGdtIj+sFPfGY9zOH2n+3sqyid?=
 =?us-ascii?Q?ELqVeJE77s8Qu1ronm+kq22iIO6jBffG0O8b8zeKXQtW+oTpU9UTzVxuT3Is?=
 =?us-ascii?Q?PK6bu5Nuk0xgUOdvYX/iU3It6Beop1xoZwmDbzEGv4iAn7MILBmtcDLaAI/Z?=
 =?us-ascii?Q?M+9DzA/mXnKBNntIoV9kqlWfbHUGRKwcY50hVK4EJrrwLjKc8TnYDX8y4s6X?=
 =?us-ascii?Q?PNklZfLHzAYZabadqrgX9oF0VUzpW1yVSLUqN83ieAZu2C97NOUH2uNuQ/xb?=
 =?us-ascii?Q?kEuaPTZcibAtLyCszIDhWFbeoxw1oqvpfRxc0PiX0si0kNX1b+NOdc+gyD/X?=
 =?us-ascii?Q?LGzSgSoVT9HsLBqGinMKzt0dj6/9TckulLEqoLZd4REu8U/dbL24xkgx/5wV?=
 =?us-ascii?Q?UblMghb0al7VTvjXanYUSX/QjDm5PGkED87Of3ziUmELkmLar8k0nv3se7uO?=
 =?us-ascii?Q?wA3ZhalGbU0ktjZzqwGH+yutqxKuu9Do68Onw/HPXvSf2UoYlkFC3h9K9tQH?=
 =?us-ascii?Q?zguC5ANd1Mnk8dj33rYjUF/e/hnWnTcwZk6lSL0mh43O4zRxHzWuHKx8GKpO?=
 =?us-ascii?Q?qErMXJ3bmjvwz84JhcpneHWuJsqAZbErSAxMGNlxIH43mrvaCP6sipVbNspf?=
 =?us-ascii?Q?CvavueFvCIYoNL/OUkwqEZdmqi/J//nIjNOQkRowqAm1WDwCp4TKolHKqOQR?=
 =?us-ascii?Q?FGWc7cu+xf/YcV7XA53MqHp+qGGC+iGJmO8WT9IBUIAfTan1WCVxccmM/ZUm?=
 =?us-ascii?Q?BpkVeUGQhJ0jAnrIp+uYM+V6yVOEwP3NwpI84M0jfq7gu/k/fby8TB/yXaXW?=
 =?us-ascii?Q?UbYwJ1bTYBN+Px+H6Z1E/9pMxtmhyDMJFHQ8h3g02OHr3JMi88elPTUKgit4?=
 =?us-ascii?Q?AceoCYWyTg37U0fUchDwyq2PcXjMk51/zaUKqIjAkDDDqROUId8JRQ0VNf+j?=
 =?us-ascii?Q?dW4v92IPzDrQ1GhRuIbBjfQLnwRMSV3V0R773bDo5ncM0m2Dqp4CBN/AufuA?=
 =?us-ascii?Q?vU7KsCplpG78xsfdmpB80TClYH4F2Li1Jy6CkVd9CjauX9NNQuDMLv/2ztqb?=
 =?us-ascii?Q?JAhVrws315NhFhirV96iKWMROvL1lCw4v75MMWFPD5JxTNhzLgwE8KUCImu5?=
 =?us-ascii?Q?SncSkY6ioCfer6p0xpzrS8jtwrwTeSERyk13OIMvWpTSoQR0LC9wpKsjM5Pg?=
 =?us-ascii?Q?7OlpF/7pKvZoskyFnW41Lz5YOlZoilkO+Dw6dymB5iXkpBqNrIi1FBS76rIA?=
 =?us-ascii?Q?NHBRxGsBibpENjD2xWUL2uTL9fVzrS0AseT9Z1XH3RqoqCZc+GT3nhDLdOLf?=
 =?us-ascii?Q?V3LyDvDydNavPFmieIEaZBTmXsiDb6x8TwygOfIEOv1I9hsAeYJ4aP0g7WL+?=
 =?us-ascii?Q?tfTpOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdda9c2-b629-4e50-638d-08db06879d43
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 08:12:53.4191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJn8nFzQjRiB/yVK790cY6qeNOzJpCc24j26J2wwGm6gangEd0us+m6qE+vkPmgxKPb0MhI04yl5tijxmxfQwChmDGa2cZPnoUtBQUyJ+No=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5271
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 10:44:22PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 03, 2023 at 09:20:22AM +0100, Simon Horman wrote:
> > > else if (someflag)
> > >         dosomething();
> > > 
> > > For now only one flag will actually be set and they are mutually exclusive,
> > > as they will not make sense together with the potential flags I know, but
> > > that can change at some time of course.
> > 
> > Yes, I see that is workable. I do feel that checking for other flags would
> > be a bit more robust. But as you say, there are none. So whichever
> > approach you prefer is fine by me.
> 
> The model we have for unsupported bits in the SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
> and SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handlers is essentially this:
> 
> 	if (flags & ~(supported_flag_mask))
> 		return -EOPNOTSUPP;
> 
> 	if (flags & supported_flag_1)
> 		...
> 
> 	if (flags & supported_flag_2)
> 		...
> 
> I suppose applying this model here would address Simon's extensibility concern.

Yes, that is the model I had in mind.
