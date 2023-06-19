Return-Path: <netdev+bounces-12072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20C98735E50
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7D84280FE1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AA114A94;
	Mon, 19 Jun 2023 20:18:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AB01427B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:18:21 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2101.outbound.protection.outlook.com [40.107.94.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650931B4;
	Mon, 19 Jun 2023 13:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gF7uNA7DcO5MoLeqQq79pCkGu0juxCkxKMWWN0+FHvgxk9LbU5qDNiJwdwXaSb4kmGpgRV9JV46qcoMZGzlsuOtokYwQAtTJuI0TZVuRy7ZDTlniUXyiyKEhEtYe5crql0b0Y0d5FSpezGsrDd2V9juZoxGrebKNPElI+S0M/sR2fryFlptmnEmeeEU9gFjZGUsu57w0xXKjJLdzCala8jnj4xO8kIwkr4qo6bfpjaYbNVpEvyJ8GEp3tO3Fenx7b0EdVQdyQBLk1AmawGNgDAZ3WKZzc3LalzQNavNmzxCaoaphEZITmdU6wSwCahEWYpYxI6s5cqkKprCPw3cDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOo0UBB5PaZieq+njLLi8H3gz54rimM0wEfIVZoKEOM=;
 b=dmfq4cCtg+WPyOVCcvTJoRG3mdJHXjRW2TvLsn3fYMv/kLOGLNu84qCBTd8oQTyKGSHvtq1L9Z+0TXn3LdhubUmSlcs5aIayAXy7HJnw5Kwit662LMs09UttZTjB7x3m+eAqBIbJ/gzqXU0/VaS7dHkQqKyz48jaMZn/pLxWfqWfTaDjYdbHruJ1yKbucsVmU7qQb0p2OXQXFr5Kri8CCftyTH1tbH1pIHcttj2wUP4ODbEVBIEltWEjNV1sI9H4GwSFV5xdduqn3Opv2Tx6DgvPG+hE/dH2CsPAnluSXcyV9AFFGnj+4mLwvG2bl1xjrhlKrv93oCtXKAfziaPU4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOo0UBB5PaZieq+njLLi8H3gz54rimM0wEfIVZoKEOM=;
 b=XsjTQaaBiZze+DwqHuc6NKsp+5gp1sBIzJN4/YBv4PrE8I4BRAD953ZHMZD/iHfg5ng3so45YBf59JvZyUXUo3lmxBVrEFFFGEDPV8+ojfauA3YXrU2TX3UFPiSw03gKTZB6zax8NaSsaX9ZtcMB6pzAew/JKo42Ba6PG2FIbY4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3634.namprd13.prod.outlook.com (2603:10b6:a03:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 20:18:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 20:18:15 +0000
Date: Mon, 19 Jun 2023 22:18:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Robert Hancock <hancock@sedsystems.ca>, stable@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: ksz9477: follow errata
 sheet when applying fixups
Message-ID: <ZJC4AFiu0YMzVRBo@corigine.com>
References: <20230619081633.589703-1-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619081633.589703-1-linux@rasmusvillemoes.dk>
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3634:EE_
X-MS-Office365-Filtering-Correlation-Id: aef21cb9-6710-46aa-bc39-08db71025082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AISz2EzF08e8+8R4ukcixXPo4umuIsGuTimfxsABKszgWwla2eD1xtN9MIh4i8zDc1wo6riuqvCUyHKoZDeezCwMTNH2y+zJUS3cMxX+vBA+78MlDZEA+ZG3DHn6RGly+sdLHE8HZZQfs8l5muI5gliwGNCvEtLMkU4h154iY0sllh1PCdO8AObePadmACq7hIHiSh07oUD/7VVVaN9EY++U/SCrdsn0PUZyKlfgXpia6KyNYhzHtqhDLmIZ230rwGZrCR6yV/3ZjygAdt52Tts/AwS39Faxd8c4tRxrUniuEgQdTYsgLERlzW7YQdLatg1h2cR3kN15MPz8BrrdV7HLcgqterjmTeR1Ncv4bf4WGsWsWNQhJpzywY4EP6naRRQ2d3MmLGS9P8c5akQSjYA3IiWzHFabGj7ZbdUWw1DTwk1Xt8UmFzlBVgYk7k2zH3+2vNtefuhvaVIf7sRk8FQyJb042i0cUy4iTBrGISYOFoZP2iPhMqEw9ISBv6UJsQmQWV08VC2aqmbYY8SUH1SY5GatmC9bg/Bxi4lsxLVhR+2U/nOaA4tjfVHY494Gkvo8QVFU8C4bHbYJP1fX4tXufHWGHQKPcSpiBNlQvMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39830400003)(396003)(346002)(136003)(451199021)(186003)(54906003)(6666004)(6486002)(86362001)(6506007)(6512007)(478600001)(2616005)(38100700002)(316002)(83380400001)(66946007)(66556008)(66476007)(6916009)(4326008)(41300700001)(7416002)(5660300002)(44832011)(2906002)(36756003)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e8Aa13+g9UmhTb0cByKZJrO7+jBJW7p44PkD8uT3T5CvNZFkk5w+isfEpC5C?=
 =?us-ascii?Q?tkZNRZp+Z/dKkWbZyLguiUsCxvoa1lGLdp8DSjCoIj9mkWina67F+3Uxj99Z?=
 =?us-ascii?Q?FemUjSf47YEXa6vC7RrSvRw5LlYpXmLAa3ItUajVlXm4MpqoLmvZpq0/XB/5?=
 =?us-ascii?Q?uOrrpZspTzCWTZ2OyG7hLxxrK1jGo5FPQzMHalH1O+TQ4zW0RjK8gzpPD7BI?=
 =?us-ascii?Q?ZR1Mr7u7q9GeQ3TW8dy7h5++kdDGAZi44B/BNcLEhIDV+6VGZNFn0yyXeOa1?=
 =?us-ascii?Q?1ixqU216kGbrzdDnT3TSZVd2eWRqh1zZe7PZQl/8FqqRB1TZ6g7D8UVE28E7?=
 =?us-ascii?Q?hQbAUJVcfBE3hsEjXDw6WhTa0d4XBuVh48xLu/d+hh9N41Krjwq0RdxC9Ib8?=
 =?us-ascii?Q?tLHNMBKHIoHsfRPMfo4OFtZDG5TDr/YNXvqeniQNr2LWUbVs2hxhKU+7nSLH?=
 =?us-ascii?Q?IIUHITbA5RU0VfBBnLQvpiSMU/UlCFOnhzl2QNIpXvDVFP0qMSVatkUYQ8eb?=
 =?us-ascii?Q?KW2JYAEYSqGpQeKRZBgzoh8K8+0yKkxk/67VrLZMG3F4IIvpPIWyVCIdv/kG?=
 =?us-ascii?Q?CFvVdEqB6Jp/qZpaw/1nQeZWlFcYryjJlZKWsAKKEwiZNrVQ6YyU/e5IFsqx?=
 =?us-ascii?Q?ZiYBeUcuH5EmjcL9tdzTO6OhgfALRhbHPHi9D/CMqD0glDoN5bbG5RR/beQT?=
 =?us-ascii?Q?5lG21CRu+CX2MjxSXuIefU3kMNTASbJUKxcFhPl/xb3AVav5lWDUSBDtTh/O?=
 =?us-ascii?Q?5fEMoT+PcxvTPY8/JfrmK/tfbRDuzAQ2AIrfhAXMeRHqIsLkPl0gET6K/+2N?=
 =?us-ascii?Q?2/tEgUTVE6i8sSpZZbOp5J55OzZ5oFS9g3sqIIkMU4ba7oUyak5qP2maUEml?=
 =?us-ascii?Q?hue+/lJr8XIWwHA2GigbAVm4GI+Z++D2OrlzLnla3XSUYBA4qNcut+M9Cbv9?=
 =?us-ascii?Q?UyeHpGa1jtH/nYE8NSISHfCkGL6omkCtRYlsJRlqwWEuw8+SB3MQa0Ov13UT?=
 =?us-ascii?Q?bGT3p+f2Huw+3FOJHUmpnKnTCLj7HGW0fNEv+GZ1sYbmAo81QIaSbzY5zh2F?=
 =?us-ascii?Q?RTpY2wLo4mMQ7MQv8hXm/PJArlCSpGLU9V92cP5FjNBdE0WORP3KPAsNe+bu?=
 =?us-ascii?Q?qoEWXdSPVDHJGWPEuj1MsOvayuwq1ef0nEIFYKXH6kOleX3d6zvnWZAe0IbT?=
 =?us-ascii?Q?hSHFfPpqMZhCO+AaiJwOmmYEt+yPyOJxEWA1kTvZBjmgKVNX0GIBo67o3JdA?=
 =?us-ascii?Q?qeNM/qxOlDNChHnc9kn1LfXN9xBHEAxPv2y0amp7z5Ih9zLYKlXy4qOZM8TO?=
 =?us-ascii?Q?5okd1hFUI4RUhyBmsOwr6SdMF65fZ8hSwGnxlYz4yYKX3IPGOpHFSxRlMdQL?=
 =?us-ascii?Q?j3VRHYoptvJWNDN9nraphlccgcxPBG+lYsnruKnGGfB+bKhXwVrgSXzi8mU4?=
 =?us-ascii?Q?wWUtQ6fJ2qCc7FDXMmQSfO2DSeR/bcYPHe0HA6VaAK/j4E7gEpshyPZdveNY?=
 =?us-ascii?Q?ipCV6VVbDm+Ei9QScvwdgebLZsHjSMhwHzM5yb1NFyxOgHdt5Gd7ekl5ZNwC?=
 =?us-ascii?Q?VmqQ9t8JNJa73zoTS1MgtyMrN8ek6hUGm5tEJQtwSFcj8V5eEgQqecqvEvI/?=
 =?us-ascii?Q?582asbx+Zy/mTbOBriruyxQuNkHoMnDkLXmJ/rDAJTjdk100gbydyHMKTH2B?=
 =?us-ascii?Q?7VY7QQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aef21cb9-6710-46aa-bc39-08db71025082
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 20:18:15.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5geHW/Y1LmHetEk3FbthIvjEhbT7zhMi083NawzSK+6qWO0mS2AtCx2UrgyzedgzK+GoqMLv+eeHQz3/D+2pkdx0eWKf+AD6WC3F/lHXKbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 10:16:32AM +0200, Rasmus Villemoes wrote:
> The errata sheets for both ksz9477 and ksz9567 begin with
> 
>   IMPORTANT NOTE
> 
>   Multiple errata workarounds in this document call for changing PHY
>   registers for each PHY port. PHY registers 0x0 to 0x1F are in the
>   address range 0xN100 to 0xN13F, while indirect (MMD) PHY registers
>   are accessed via the PHY MMD Setup Register and the PHY MMD Data
>   Register.
> 
>   Before configuring the PHY MMD registers, it is necessary to set the
>   PHY to 100 Mbps speed with auto-negotiation disabled by writing to
>   register 0xN100-0xN101. After writing the MMD registers, and after
>   all errata workarounds that involve PHY register settings, write
>   register 0xN100-0xN101 again to enable and restart auto-negotiation.
> 
> Without that explicit auto-neg restart, we do sometimes have problems
> establishing link.
> 
> Rather than writing back the hardcoded 0x1340 value the errata sheet
> suggests (which likely just corresponds to the most common strap
> configuration), restore the original value, setting the
> PORT_AUTO_NEG_RESTART bit if PORT_AUTO_NEG_ENABLE is set.
> 
> Fixes: 1fc33199185d ("net: dsa: microchip: Add PHY errata workarounds")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> While I do believe this is a fix, I don't think it's post-rc7
> material, hence targeting net-next with cc stable.

Hi Rasmus,

unfortunately this does not seem to apply to net-next.
Please consider rebasing and reposting.
Please include Andrew's Reviewed-by tag unless there
are substantial changes (seems unlikely).

-- 
pw-bot: changes-requested


