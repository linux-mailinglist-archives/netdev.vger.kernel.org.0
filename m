Return-Path: <netdev+bounces-11983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF16735956
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 293A41C2074A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0943A125B2;
	Mon, 19 Jun 2023 14:18:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F134811C8F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:18:52 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2113.outbound.protection.outlook.com [40.107.101.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A5D10C7
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:18:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4AMHrdb1lysF1sisD/0LBk1EoQdO6vuIeVzE50fnEVwfzYU1scgy0QgpCX0w06ZrzTUuw0EUDifa7MHcx3giQHZFP4kn30v8HDjXXM9XpLf+BgKJlvWEsNeTLkAaA2/RsCH4/VIEUwQc5B+AErPEweU3qZ+uvQE+mtvsWf0Y/zv+677BZuzrlYa4XgBAXb64c2N4la1+9bPUr2qQPhsVgxZ4CvYB9pGIHjkHE//2GZlLcE3bscHSbjUVG7sry9OtH+phXTcKwUv5asF8DGQqNbeWuxReZVtV+HjRWDVBrFPJXdt6XxPz7xqZPjXu9VzF3kvcJF+I/HCBdGal29Nsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CC6ggrIwm/hnhjeF/tmnLmZyG8bMibkh9/ViyzWZzyQ=;
 b=hIVnubMlHuejSqgVki4nyW9UcQXHeTnqvLwVI4EI8pWepgfdjtikW0s9WpX4tSKaKxQAhqxiWFXMcGb/hGjF/56AoYxHvyqNL2qBba1qGiaGnCw1OF0bTtxQs25S6Ijda4iTyfJjl5+jgdDJNy/2JKzxOgrSzdUVN8FD8zucc3lMX/hSvmj75eMfKZpN6niSsBB4mC86qtbTyMsxURJmn0FO9J0DKSs+hIeThJQ1QG0TBdG9VzA5+aPAvkfjlc+E74McQfCUd/tcow7IAuHz4KdrdgRYFWjKSRhO8WgQ9x+nDtDJKh4S7asgMnvCZOapRtSQ6gbuwaYLLDsUT9C1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CC6ggrIwm/hnhjeF/tmnLmZyG8bMibkh9/ViyzWZzyQ=;
 b=kO8bT3BrFv2B5GHi+4S+YeZVnyalwaz4Gp3ERjhW5dHIsdOKZV1WM+Luf7r7FfTKeTtSeUj3K6NcTLfjg+B0vMOo1uTiCgm/WoHjGBBYe1Sji/Oi0O7Zd2mbbs0lot9pjs8MXJuuEQOGC9wnnGuvgFqy0gx5mu5Z/V9HawU212k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6225.namprd13.prod.outlook.com (2603:10b6:806:2dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 14:18:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 14:18:35 +0000
Date: Mon, 19 Jun 2023 16:18:29 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>, ansuelsmth@gmail.com,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 2/3] net: phy: phy_device: Call into the PHY
 driver to set LED offload
Message-ID: <ZJBjtWTtDqsyWPXE@corigine.com>
References: <20230618173937.4016322-1-andrew@lunn.ch>
 <20230618173937.4016322-2-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618173937.4016322-2-andrew@lunn.ch>
X-ClientProxiedBy: AS4P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fc59a1c-d9f3-4439-fa6f-08db70d01125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	drbeE+E84IrhDzVONsHm5gLyCBfXFrMXHH30UjUVNZElqKhNWQngDJzq7bTvnmzFh10GtoreUVTGV6RCtYG2dnxy9RzNF6af4mOmCcEdOuiv5VU7nJmoX48rxU121cm1Y8Kh8AozhSz7yAYLr9WbvANwygaN5bmH8nsRl9S3YGYf8cKUQclLohxsD11IsuaLnJVFMadUamnMU6UXFzIsNq3DZg3Pok8/gT5HxQcQFlUgPMNIGecK4/DAevUhIFTBrf1tkkBJe0JlIJK7Aj+9Blu1efVhScwV49LnIjAs5/2CZ3Tk2AbcqQGJa2V/rZgqLQZS3cK5jnb4SNtQoY2pZk86VQTDBDN2fzBf3jpNfAF8V6fwaAC9kvqZdhAe3v018/jtKj/gMSqK7M/dtt+C4okZLwj2qGxCJycUwZRoiMC0quKZ5d4Mz2vbQYB+qBSDx3bkEv2mMSL4TVzEg1PhGIWFK5iYnwMhUlceU/sdcf3ENAvy1tmaEQmC90im8MdE5GloE4hxjz0lGbRKRoxNXLuCsLUV6lCdGzmF5oNP/MIDq9fHzDU8zLaQRKXHBRKcdvksPS8b/VYEbu6eLdN6dAe9T/KgvDiY7Pvp8UHe7FM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(39830400003)(136003)(451199021)(478600001)(2906002)(54906003)(6666004)(6486002)(2616005)(86362001)(36756003)(186003)(6506007)(6512007)(8936002)(8676002)(66476007)(66556008)(66946007)(5660300002)(38100700002)(44832011)(316002)(6916009)(4326008)(83380400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hsYzPOWznsfBaS99xZA94ojXltw7FmeH9O/1auZKuJmM9HMW6FK7R8ypDpXQ?=
 =?us-ascii?Q?P+5kbYk6t3ymYl/Lbp3cCGaB5jcszzt1ura9PGIUYRXNW6Ia1hCOiOKm0aRm?=
 =?us-ascii?Q?SUJvbCxugZqgk1TG/yYdgaoQRgPFflVF6+N+K73+P5oJORHAqh6tJpK+DQQM?=
 =?us-ascii?Q?BEWHabbTpZ7tgAAImy9hyCE/MtKR0aw8jLIlLC/IcQDCXZc9FZo/CpEZdMpt?=
 =?us-ascii?Q?+nCFD+3kSVAgMD13MLr3Zd+H+DiRmdaT0bpRLH3Rb+4846+9BUEO6QfYy4ps?=
 =?us-ascii?Q?pg5qmE5t0VxTaUiYpQLAFk5XCo+1GaQkv/hGuCWWbJIn+nKZY4PKdhdntYR1?=
 =?us-ascii?Q?KriR0pWwyqPAsajjcy58UPYO+ImFtP2C6vdyuCx1XqfRPDQkpo5ZRvXHQ02l?=
 =?us-ascii?Q?qQAFnrJqLDeB2aXx88HxIAjP4Yj/q4HVoySDuwXN51mW8uXXOowx3/Szi3F6?=
 =?us-ascii?Q?zI9ejxAhc0g73BGaRK16u7ar3i+r7dBB+yNzyeyejGHYCKTbMZEcJXzDHYdu?=
 =?us-ascii?Q?qh+9tnWh83wiCUScFIX+7G8L+PoMgsJvISmEBU0jX+yIWdS9j4FO9TXWOO2f?=
 =?us-ascii?Q?9NP5kmPkybXdadSxiq4IjYaf0cVOAoFz+IgJgdX8NOMsaucmF4dA0PeznzyJ?=
 =?us-ascii?Q?llm5F+zBdLWUn2OwdiVzcPzdQCntLRfZes0oywFsrdkfyLSOOJWCR5YsXH7f?=
 =?us-ascii?Q?Yrmp7TE1uyddEChlcck8jS+fbiZ83U0YJrH0Tm8jhrM+5G/fUvu3HHZ1GklI?=
 =?us-ascii?Q?OktRUxdoUmNtx0RlVa3rJSbObJIdKmSOn6fIvUYp6T9cvp/SGOqQbA4/N32N?=
 =?us-ascii?Q?SMQ877R3vuc4IO1LXfdvc9I8nlUsEvBqPIAT2JE9MHotYyi+TsrGXAduhIPD?=
 =?us-ascii?Q?TU8K7/zCV+B2x9KVzKBUcIMcVFh7B773q5KYu5BjOV5wl+DdiQSQj9B52a0X?=
 =?us-ascii?Q?OOOVXdcSLYEAqRoKXXGVm0CnArxCV9NlF7lYv2gBfvZC93ONIDMTFKxV9v+c?=
 =?us-ascii?Q?SzfB5XI4D+Y3uDLdQokhpeWXRtZkyUcpSk2Ap/GtXM0sK4nHI9svResAbOoA?=
 =?us-ascii?Q?Nd+9PdVS84nz/5XazmlP7FD+K5dff45DqozX3eskH/aOg0TaYYYWJAS3XA15?=
 =?us-ascii?Q?0A4UOy/HKBGyUAyuegregg82GV8vz8TePqJLmLY9wPWaIolAGhtgjPvR9AxB?=
 =?us-ascii?Q?MSh9f7s7McnySyWNbWTw/03FrAYrZJmqjTUvO1xq98m9gQco/af5i1Vq5xfi?=
 =?us-ascii?Q?k4dB1E4w27EqrFHa4hiQiJsmFE8Gg5K+bhofFDmLWKp++3pfURmG2pJR2K2V?=
 =?us-ascii?Q?TdOgH9BZ5501k8SZVPUY1sMc0qvdTxDKtVxwTBNceppRxS2WuVD3GCiY3vVf?=
 =?us-ascii?Q?Oelez6MmyIJJod7h5bCyzVPZEYv4BeYm4OOGI/XX3FJjMgV200HEOVo8kVV6?=
 =?us-ascii?Q?MSuVk9q5oqcvCN4L8RvyZ+2Wd8uVqnJ0Ivg58Zrrk4VXHz9Sy5iWE8pjUL1r?=
 =?us-ascii?Q?LsQrQkCaNKqtd1Y/oKi1ZIZAKD7MgRLzm9x+8TvxmCM8YGyyvbLr6oXsMwjc?=
 =?us-ascii?Q?fYFSXVWmA23tAFJgWaRei5xIkBudY4X4jBcBNMDUqgufJS3f9UeeeWOiaoGx?=
 =?us-ascii?Q?gJG97tEygIxdsNqJx63uVjAu9ytV+EFOZv7I/Z5lPCvStQ1WO/NoZ3la8iyC?=
 =?us-ascii?Q?h9iFUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc59a1c-d9f3-4439-fa6f-08db70d01125
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:18:34.8004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2dW3+qUDUTWGXda3D+pCb2YUUzY7BtDGFIAqmljUuKfErU6SiHGSZbqj0fw/9vusDeLvLpGuWcuzEzieDDE/S1BQHDkr3t9RLeZqJQBd68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6225
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 07:39:36PM +0200, Andrew Lunn wrote:
> Linux LEDs can be requested to perform hardware accelerated blinking
> to indicate link, RX, TX etc. Pass the rules for blinking to the PHY
> driver, if it implements the ops needed to determine if a given
> pattern can be offloaded, to offload it, and what the current offload
> is. Additionally implement the op needed to get what device the LED is
> for.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

...

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 11c1e91563d4..1db63fb905c5 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1104,6 +1104,20 @@ struct phy_driver {
>  	int (*led_blink_set)(struct phy_device *dev, u8 index,
>  			     unsigned long *delay_on,
>  			     unsigned long *delay_off);
> +	/* Can the HW support the given rules. Return 0 if yes,
> +	 * -EOPNOTSUPP if not, or an error code.
> +	 */
> +	int (*led_hw_is_supported)(struct phy_device *dev, u8 index,
> +				   unsigned long rules);
> +	/* Set the HW to control the LED as described by rules. */
> +	int (*led_hw_control_set)(struct phy_device *dev, u8 index,
> +				  unsigned long rules);
> +	/* Get the rules used to describe how the HW is currently
> +	 * configure.
> +	 */
> +	int (*led_hw_control_get)(struct phy_device *dev, u8 index,
> +				  unsigned long *rules);
> +

Hi Andrew,

for consistency it would be nice if the comments for
the new members above was in kernel doc format.

>  };
>  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
>  				      struct phy_driver, mdiodrv)

