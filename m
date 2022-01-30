Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E384A3A62
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 22:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242623AbiA3Vab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 16:30:31 -0500
Received: from mail-bn7nam10on2132.outbound.protection.outlook.com ([40.107.92.132]:1428
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233152AbiA3Vaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 16:30:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPjq41o37r85P6NKfSNw3KuAVvBfXFwfQQPotN+p41fVxufwBtC3cZWJa+JMR5JVGnqf9g3vHFmGiHVaE0lqABsqgXTgRgB3m7BC6D6qVVAdv+8dNEn6jP5mUngm+kTB9WzhJhJ55/b0StrveITP47I6oL2ok4T/7OjqX5xP23KyVr6YuJNdX5/3YDHgXboMbl9LUY3WYblZ2NNhimEwz//rEvRkwFbwRYhXTCfnrivF7yPSPzClBCPQejltgd8W1SBk38BgFco2fjxzuV2mYWvrJVZlLNg3Jg98ZedDA2iQlTR5ocOOnse+OvBpDlzb9PVHRsVY7VQ+oJ19Y9Fliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1W/7Pv/VG54X5i9Yxdw6glDOI71LuDcCFDkCHA0UT8g=;
 b=B9xM0BmoNuBIM4NV+/Lj4EXFDx/l3wj1+EsgpV/rAgDmoT8lO2/KiwlGjkYNiAensXjsapGb4Kk8YUoagn6L0UQMHx9Io4Ju2hQYUBkGKmzFHLj/NyTLVPFb7019r1sJ9CYHWPET5I6ip4ICLCFqirRkU6mBqI4emJDFdZBRDEO0E/3ZBC7CJcXeladEq58ZZ7x2hdEWNZEEyFaYfCqRT9zH9vTMfj31CVGlVBSXYZ0hOwpPRDUYpqjz/p3oBoUn17dgbNsuIDWxPA/M2JB3qdl3dPu8fAeHYuYPRVFrWV8yqbx1ieeBu2JUcNvW8ZjL6wZq0sPWnXWgKl28pje3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W/7Pv/VG54X5i9Yxdw6glDOI71LuDcCFDkCHA0UT8g=;
 b=yRrntmGv6cnHH1FwrppfI6LLFkaIZCF9AX6vpMBJaBrUlEDF7xl7Of5n0iA3Tx+OkUM7HMfd0vAUQ2cBxmePTInkEl4/h9AimtXd4OtQxoR5oyLYTDoBJXl1VFlP76+QXIqFL0syE3ieFrp6v0zzHLCyyOhKqKKjja4HIRAk8MQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3403.namprd10.prod.outlook.com
 (2603:10b6:5:1a3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 21:30:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sun, 30 Jan 2022
 21:30:28 +0000
Date:   Sun, 30 Jan 2022 13:30:22 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [RFC v6 net-next 1/9] pinctrl: ocelot: allow pinctrl-ocelot to
 be loaded as a module
Message-ID: <20220130213022.GA2914669@euler>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-2-colin.foster@in-advantage.com>
 <CACRpkdbFOB-uoVKiG0qTcHDa45bNjwdkP=AzAB7kU2Car37QYg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbFOB-uoVKiG0qTcHDa45bNjwdkP=AzAB7kU2Car37QYg@mail.gmail.com>
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ebfd3e3-1e2e-4991-73ee-08d9e437bc1e
X-MS-TrafficTypeDiagnostic: DM6PR10MB3403:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB340355E2589A0A6D94F284B3A4249@DM6PR10MB3403.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHOnohzChxqu1r+GrLDh7ilAYRMBfRsaD/NdUg1cJ+UA/I9wzrqYkMfSviJGfGi9ttt+WGnB4oFpqAokXgMza6TAy7dt+KZBTVEgX7odCdsefpX0DfxGI+uqAeqoAaNbhSkLI7WfwP02TU6l0LrslNaLzitHhgtlEJJlZEhT0vkhROn6btD0Ghjq67yfYnrkkcOWrycVpX0YpULgCAjZgerD1JnukQpZ027zCN7k4c4SeZmAplwnSjXX2gUDEj/R0F/32qjWunp9VZ/+9RxJgchnell9D7gMhUh4X+T6qzSDuCxht2wXfflrBY5S3eqU4nyXSHbsGcd3YQsISiuqFmSumCV7guqQFcIbROuiOVduhaeXHP0KbLlbiz2/oe7G/1Xg2XxM2crmJ2kvcFkVedOTMi7HEy7/4HyiROeHoxkoiCg9POYERrvea27vNQ1A5ko8mGyW/4LNhGm8F4vNtK1b1lpNKwXYeND8Tjn0SAL3LZ3QD4qt5p634TTiR7vdK/+IPkJyxgCI2Ub02uqUtp9VSDYCEU9E5orVeiftG5EmSf3Z+niowbtcv9ususpz4K25kH6b7HmpG1zD4wHWX0wVOq1zWNBMvUw2VFgwKYVdliaNSSpuoF08Pdkwd4ZlCA+bxiLdKd0FIl+163w+BweInL5x6Ap499fiLahde/LNb2ZTepcQOhz+Ini/jFaHM2zpJcisndWmLsMszfpQpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(346002)(376002)(366004)(136003)(39830400003)(42606007)(396003)(7416002)(33656002)(8676002)(316002)(66946007)(4326008)(66476007)(66556008)(5660300002)(6916009)(2906002)(44832011)(33716001)(8936002)(54906003)(52116002)(53546011)(9686003)(6512007)(186003)(6666004)(26005)(6486002)(6506007)(508600001)(86362001)(107886003)(1076003)(38100700002)(38350700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?leIaw6GL1+TdpaoR4xbmRFwdPDuUhjei84WKvQ24ETwZA9rATyOer0Z5Mpq/?=
 =?us-ascii?Q?1cWwlnwS/bXQ8DnQT9iHt4/bfXLKHVVtG30imyZsqvegNoeRmDp9UyOffpcD?=
 =?us-ascii?Q?1mz9z1pivyW7VtYZIHmkvNysPcr+qUIF6WPklm7Ke51YsqIqQjkMZ9w//S16?=
 =?us-ascii?Q?7hI3inqYoR48++RQd5X2WgPiUzSc1b7x47p0D3ZyOu29maDwaTkGB8+ho0KV?=
 =?us-ascii?Q?ll6Iu6zhw0oxqaFmVU+bpFVguAQk8koJEkCQR7FhOPwg3nc+lzN9tODQaQgz?=
 =?us-ascii?Q?4uLgbdvXz83w0qW5AqGw7kJJu2ZMje6JrGAi4BjrAqg6ZnjvUfA+txLtHeva?=
 =?us-ascii?Q?rta8JCdCbtP46gZIfmT3FJJei3oWhLDLckTJgAvdsU6wrKM0xrNL97dHEp5D?=
 =?us-ascii?Q?BoVILFJbYryV3b9obaa/p1DhexHed7pK5KpjQcuAKoX8b5sQ0dsDv61ByTaQ?=
 =?us-ascii?Q?I+Xg+0DaRTHF9/G1Ur+VeJzmn+Xdt5d7sNp/WieijX7fhvlE4MEQuv71Nivf?=
 =?us-ascii?Q?q0rT43zjX9xY0308MN4EfZda/beH2BXZiic7a7ZnNh9qm9Zd7eVHVqvbkSs5?=
 =?us-ascii?Q?XCVBbJV8l6wEqedLYlzPnLr0jeoyBJJkItTgURX4LYQxPveVWtntto6VIbjs?=
 =?us-ascii?Q?gMkIALdEakDxBrhsT7qwm9EhrjFjznwbbaJAt8GmSewt15kRLaO4jDj2tDYi?=
 =?us-ascii?Q?Uagb8e8XBaXckqnVds02dHwi8fJVIBp0rb1Bgvg1fTBXScJZxueL6zaPzfJ5?=
 =?us-ascii?Q?uBkEHEZusXzWGIXaTAq+CdrE1fIGsolj5ON5XLPRE+6TGAEFej0tUjPGgphY?=
 =?us-ascii?Q?guKP6DyPueQ4SMGAUgZvc5PHQztGZrrmAl+3XXZy6ZNJdav016OYmTUCV/H3?=
 =?us-ascii?Q?rEts7qa9N9Qye8xMMBXogTR3zb9cwXyD5vF4DQjHPUhs6WkgCSfHN8yeJQVG?=
 =?us-ascii?Q?JN2DmroiaXYewUV+lfem2YHfXAVKtNbCt6BD4C5PznfJF2ErZD8+nFu/VL3d?=
 =?us-ascii?Q?F3TTBtS7MmQb4BfXq05resNONYP6ZsBvQ4Fo44jGDKJuGkKEBC2eroNVD76y?=
 =?us-ascii?Q?KZPerjQi8D0Lt0Mm8QCftzTPw6v42TWji+gnR6sOSDPrTHrFc4ASX7/ueeLv?=
 =?us-ascii?Q?BYBIk4uTPSHlA1HDqO5a+3Hs0GxQhovUO3O7VOiZrgDh99qstndzMd0Zs8m4?=
 =?us-ascii?Q?1HKfHjrTXczEZ6fK5rcYKZ7NkIAuo4983it7ha6LPSIsCZqip1haIbrgyZWu?=
 =?us-ascii?Q?p/1gbjF436RA2A8nvWcbcoPQ7j2fGS4ycQHriUJO2Q6gEwHjDVzh0YwJ+x2T?=
 =?us-ascii?Q?Gike6Ds/BelId+DCpOgKFOnd7klTHZwmcD484x+NmGIYxJKD9oMoWK5hv5qR?=
 =?us-ascii?Q?GKPDCOh+KbfwSsbCidgrMm6aIHOXQOgK+/p13O6jyyC7W1MmSSCvv4sB//PS?=
 =?us-ascii?Q?efP2UbtRSMjOpG6wptoeXaVvKKE6FmGdhNeO1DaNe3wuIu/Rlx5sp7jjmhWS?=
 =?us-ascii?Q?wPbGXLDPahlQfIU2B1A3COakpf9V0bne7ezuUtMBgn9lpI5h7BH/3LhUYH6W?=
 =?us-ascii?Q?jdLWxrYHk0mmAk5fgBWI6BDZ6RIMN7BN+oHbuJs/rKnBSEWkjWpzV49SibHV?=
 =?us-ascii?Q?pnvieQKGdkUBJf5q1UvYxeOliClIYpBwvGoBIDktISOAj4fkpI5UbycYtf6B?=
 =?us-ascii?Q?aPodB6/r44bawOK8OGBSaOZeRZI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebfd3e3-1e2e-4991-73ee-08d9e437bc1e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 21:30:28.3988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzxCviRp/njiPTS+bqdbz+3tAgSdyGC8wP7NPS5iYosdAlkqgarZ32E0Cq+N40J1zcwqBc//9EDB6iaQBiHJiWPPVPIVsFJ6eJ1sTH16Fdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 01:30:57AM +0100, Linus Walleij wrote:
> On Sat, Jan 29, 2022 at 11:02 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> 
> > Work is being done to allow external control of Ocelot chips. When pinctrl
> > drivers are used internally, it wouldn't make much sense to allow them to
> > be loaded as modules. In the case where the Ocelot chip is controlled
> > externally, this scenario becomes practical.
> >
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> This is fine to merge through the netdev tree, if you prefer I merge patches
> 1 & 2 to the pinctrl tree just tell me.

I'd thought about splitting these out, but they really don't make much
sense to be anywhere until the MFD is added in. The big one I needed in
pinctrl was the regmap conversions that are in 5.17-rc1, so I'm hopeful
I won't need to bounce back and forth much moving forward.

Thanks for reviewing!

> 
> Yours,
> Linus Walleij
