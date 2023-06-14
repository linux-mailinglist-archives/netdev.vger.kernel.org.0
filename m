Return-Path: <netdev+bounces-10699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C33C72FDDB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD27D1C20BE3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F8D8C1B;
	Wed, 14 Jun 2023 12:05:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB9A7476
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:05:27 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2127.outbound.protection.outlook.com [40.107.243.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346BB19A7;
	Wed, 14 Jun 2023 05:05:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bP91zbEfEVU6ExxHs4HFPFAQv5jErNfB4oFHZu1AhienoTcNukuE7Kbh9UsrH2Buf97wWvxWkYHFAGPYXHN/tzWUsE391R8IBSlPwFeohLaFlbqkcueLb9itixmkQ95h0IGVzqgWer3w8+U585hJvqAttzp91Zw/IK/t+Fe/PYW7XYbFK1GSm1cgqBDG3+cg0WbPqE+PvhC/mk1f7h7TAoYJr0g/F4BZIVDhxCwC3vtjmp+TvkoYSZhClikKN36HiZ2AC/hhgQRUrYnWO0q1o/loq+NMbqK17BG2j/H0q8WoJI3ceJswZORYIvnYMpmHLnedA1Wowjsx+4UYL4YdRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvCd7EA2J+5UnWdxM+dfYavJ1XqdnpKONVHMuz/62tE=;
 b=fTKKG3veLwr0kWjj1Jj2gPUFK1fJar00Y0agMvbCTgluXL8QnoberpqZ4KeApLJgvHvyYHQmDQhgAf/hQ+mpHxjZtwrSBVlKGpj+faQ2njyh2HG0Tx8ws6UTM9UU3b7GuixwbVSrVYUAyQIpXlRGqNSstJU0cGHcNIfjhyOPhkOstTdT3N0JOvJiO/ZCfG0XAwqsL/zmmpwlNXAxj20wGBsVw8mj+H++8lWqqItRlx1S6fUQT1FWssu8rtQRloAhpmY1OB5mkyvO1Zm/YlnsgK5TVn3+nFA+L6VQc4Ur8GoDmaWGDFqnDgL+hhRPE4bVqDsLTNsHYO4KOBHhsVImUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvCd7EA2J+5UnWdxM+dfYavJ1XqdnpKONVHMuz/62tE=;
 b=lWMSEF5K83wvsCsiCaqW2iPZYM0dygn9zbLgnMaqy6I4WICllUUbTlkIi0jjGWvT1H0pwIJeid4w0/+UGyl2DsU5AVTHqiZ42OMiCe2AzfC+n88TG3RyPEaRh2HOwOtaiRFfiClqFpWpurhhaSaEKKo6UQQUQsqabHEp2mOpNnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5164.namprd13.prod.outlook.com (2603:10b6:208:33b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 12:05:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:05:22 +0000
Date: Wed, 14 Jun 2023 14:05:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: felix: fix taprio guard band overflow at
 10Mbps with jumbo frames
Message-ID: <ZIms+0/KDpU9dd3y@corigine.com>
References: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5164:EE_
X-MS-Office365-Filtering-Correlation-Id: edfcd88f-a503-43ad-01c0-08db6ccfa154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IYOYco1gjzZDywIVUE75SMVm8FiPz7X7u5O/r5g1t1829/Qq+nOHc/uJy4rUkBIJp2lnjdr6ycjoVkN3MN1Hgo5H64lukQX6/OSgpCREjC7AZ9YXCMbNStNBisrP+jCzt6JA0CgPG1yoYDOwSLtZ9r5T/154I3OQ2OwMzxAQCz5OpGyQMWCvMc6Kub4QuuABqJs9R4p7aoJ4INLjq0g3VocvOUuSHZ53i+rOD8mXycIuwv/YyQnuvWmHd0w1bvrRgV9BuRSoD3Nu5eamgW4Qw6A3KKSdDbwqYEz+zWdeKTCbYn8fdqpnSCObXHIfdBWayXU9/zWaNYh4LWwk9a+UQ57iQjQK8cgCAjOiNpIYdbGCt5EdzjPS4UNFx0DycKvN9BdVsSuICQ0NbgCZHJ0ydXbHE8x9vBpw+GwLYyLNJeKMn+NUjb9kcfDiNzfNhBsMsEitN9s5a2tqZqOEmr7IsUUU3XwdwvlS2ebItaH6mMKvEqax7orHU/96OQ/sDPgxF6Cub8ZFipVAsNxWnZn4Cb6TGErAeJ+Gpmt67kREKTsG6j84yNvi2avtM2B/yD+HVRIU6/pyPeilbLafic9kEnVP1/MWnTQ0iRlDfbIEoNY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39840400004)(451199021)(83380400001)(5660300002)(186003)(6506007)(44832011)(2906002)(2616005)(7416002)(41300700001)(6512007)(8936002)(8676002)(6486002)(316002)(54906003)(6666004)(36756003)(478600001)(38100700002)(86362001)(4326008)(66476007)(66556008)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K46lUTkJCKmx1g1UmB2YoLISIEWJjl4vgPVXyLpWil4HY0WIPijy72iHH7Ox?=
 =?us-ascii?Q?RS+dpYh3AM/PpkIw728ou3LURsndLFJTHCeTUqxgSxR8FoqN7DdIxcc+T8Jz?=
 =?us-ascii?Q?irPxvjNYvp+Ql0az1M7OXlENW1V3uLWferGd1G7Zu8nnA9NwLPcDlmI5P1Oh?=
 =?us-ascii?Q?QjvdgRQI/Q+sUbFK8XVjOvwflUnduyklyiyL1NgU/M5s4iUxB16XAkH9OBBS?=
 =?us-ascii?Q?bj2ivLYJJiIGyziHln8RRW3dccY+B4WDwTL1D9kUjnn47EIqFr6EPpsjVFKy?=
 =?us-ascii?Q?HvKql9fMdaAdepWXzY/SQ+Cc/cD6eYvGeiq5wRrlII638TskmVONnQCGXGd6?=
 =?us-ascii?Q?o03ZN0gvBzNEfqvfe3pVB3l/1qU5ZWoMA3H/R/+xkTh3ilIIxQNC/mlqNl+Y?=
 =?us-ascii?Q?sDH+4qwGWcpa8DJChb13vshk1bvl6aCLm0eJUkJ14ei0mEfHtuoG+7zmMaWq?=
 =?us-ascii?Q?GMtkUzSBvyQ+lsnbGMGR5OGXFReJ9PMMUxA+sA5Hq8XWFq6qvVQzKpScYXnI?=
 =?us-ascii?Q?M21mdm+rl6SBzdFiN9AvF/OayS3W7v6wHX+cbyuS9LxJm/zJwzQ7LQdTKU8m?=
 =?us-ascii?Q?bNixdiunvcTnxk9/D5JOiMYVsz5RNOhxuAThv+GLwBxaO+LeKEBDQvzrf8Ke?=
 =?us-ascii?Q?cO9rE6LlSh/Ft4KzplhOCLTv4R3eq5d+iHnWGrOmREXr8F8bx6f46GNWUPKY?=
 =?us-ascii?Q?Uf+32T3Aj5gnH3YnNcf9RcyRYnsc0zxHv46MfGdcEdnpU0QTOJUuhbETeGK3?=
 =?us-ascii?Q?h3asK4V4q+D+iLIkacxBekHeZHt6MP+dqnLQxDNEzgzqeNrwlxZfM+f8bd/f?=
 =?us-ascii?Q?odKFUgP871AADFCNDkU/zQ8G1X+o8kO6EMaxtkAfwHUjK+0KWVEXFrJ2cFXh?=
 =?us-ascii?Q?tAFGb+oie0f7iv4zVuk9vjR1y/qJyrE84uPnGR3Bypxe+c9ljAMGUxhAYkZ6?=
 =?us-ascii?Q?SgbwfRyAk3BMd1w9nCOsGtIeMYBFzcvt4rxIv6NZ63Pj00/953bhyBusUfvO?=
 =?us-ascii?Q?7qNv6y9TPt73GzL6QLrjH0yq1bWaYwgyUihUD7+jbsUuAQfDxtyKUNyOmGfP?=
 =?us-ascii?Q?cKAZu85Bw7JC2OaWmtJHNiOSbSdBoMz+1EfkEbBUdp8TRXmeBapfk5WOgvHv?=
 =?us-ascii?Q?U5SNZjy/4Ncwy1X9MmFYtmRnqLXqmI4P0v4FbprTzJhqO9FcxuJBpIcAaoZP?=
 =?us-ascii?Q?VA28I2kLT4zUGOmwYKvP7jGW70LKS9SZ8e0BMW19YRRADdM2MaXVBEtkCdHb?=
 =?us-ascii?Q?x9ugxMD4hrEfUHOPe5pEv5nVcGRD0vaXtCDTPmEhT3B4lIbV8fU/tXzTwiXI?=
 =?us-ascii?Q?BpHMURWria/P2o3/yEJAGY80MyjQFNN0ZcITHfbs+fYT5gyLBxCVpYtQGqFt?=
 =?us-ascii?Q?IgLJar2aykvlD6CYle8oVAH/L8dxdVpNMIDw27QZCXng3J+ZchgAAAVceYOV?=
 =?us-ascii?Q?VWDODmcTT8TgtCRZ0OOqRGOoZidfHDfGjU+vEnezO438QL0wA91wdt0dXc0o?=
 =?us-ascii?Q?ag5UlV4EQ9m137dZcQHhu7Qo7Wo5/vKaS1Sm2n7D5Fp6CO1kjjdIQACDCXVj?=
 =?us-ascii?Q?JihEzgGioYy7GYW3Mf1FusCg5cBi3j4zATYh8inCpM6XcGpUD6VRa1tUEest?=
 =?us-ascii?Q?5cHIPPNm0z80CG5UAaZA50sD/Bauv9V+PglP7o/4JQX/AYgD2OTk/1isWY8D?=
 =?us-ascii?Q?pyj0Bw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edfcd88f-a503-43ad-01c0-08db6ccfa154
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:05:22.5309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htt/KK9gpD0cbfKD9XdNiXFStPlz4ir2Lbl8hywciyb/CERjqkmArWL5oRMv2WFKNQloeuhqQZIiiEXI7gL70TNThUc6FHCN/jZ9EqS1eD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5164
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 08:09:07PM +0300, Vladimir Oltean wrote:
> The DEV_MAC_MAXLEN_CFG register contains a 16-bit value - up to 65535.
> Plus 2 * VLAN_HLEN (4), that is up to 65543.
> 
> The picos_per_byte variable is the largest when "speed" is lowest -
> SPEED_10 = 10. In that case it is (1000000L * 8) / 10 = 800000.
> 
> Their product - 52434400000 - exceeds 32 bits, which is a problem,
> because apparently, a multiplication between two 32-bit factors is
> evaluated as 32-bit before being assigned to a 64-bit variable.
> In fact it's a problem for any MTU value larger than 5368.
> 
> Cast one of the factors of the multiplication to u64 to force the
> multiplication to take place on 64 bits.
> 
> Issue found by Coverity.
> 
> Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

In a similar vein, you may want to consider the following suggestion from
Coccinelle.

  .../felix_vsc9959.c:1382:2-8: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead.


