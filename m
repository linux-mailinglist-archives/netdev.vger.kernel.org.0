Return-Path: <netdev+bounces-9684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CABA672A2D5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F421C21191
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1AE17AC4;
	Fri,  9 Jun 2023 19:07:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE585408FF
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:07:30 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF3035B3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4r8lcWX0mhvsuSh0vKssXDwKnUtcsq3PSnQcn3YoA7ynJNLPHPmcI3nq0fScoTdClonfTZkQNhGtaqbQ32HUqgtTNhSA2bCLNSvzRT2H9qd/zAT2E861GglJAKSB0qCM4Nr/Xw+s+yCiNSBlVObgXfU494UcGabVw/IbaeQiJANIvAkdzYzlvp9Ktjh7+UPEDwdPL9+SInuaHQh/xGjgTXpBNjqUG9zpU2kYD0U7obcrVvJeaVXoOyOm/7qEpVv5N7xLeLjm89zx/VSN+e3UC5ZDgxYaW94xcxPt7kG7IdKjU9CQujQ7VCtWC6hPT9iSU1yrbgsAdxr4mK9l9NmtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdlr1Wc0NHK+k6BmKHctZwnQv1sXOABH3xN1bpWl0LI=;
 b=AR6l0LDH/CrWyuIsppbID2P5EUF1qFb453Xnfg1xzxTmXoFBlxvmREBjt/HvdpVo+1Y6raARGqToJfazpxX8TI60CyGUCXIWy8dncDMIz+9yvBi2lI3NgLkXQhsAykkZB254Crwot8X8/Vlbr0LxuLVvz25Vv3+fLYmWG1+jsfctGj/j3se9eUeKs1+PivQk9BC/RmDKJHQ0rRAbxmCWcHYo2k7zHhOEYyzBdv2bSZQDRYgfmmhazqnL/R2ToM4SkGMdhy/n707QebyPvb+84y2i98ce1qf31bE8ZaPykcTShc+cgighm/YEhfp3wHRE9xsK+Jd8FDYNNputhnmIvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdlr1Wc0NHK+k6BmKHctZwnQv1sXOABH3xN1bpWl0LI=;
 b=cyG+an+ozRoSyqB0X1MXbnM7bs0LSBp+zO4XgUna+Ayj4V3ZF6QiC8c8SDCbpwcWK0e6G2ocrmjrfvcVrDpxyELta7ZWiof2bSfrYvpLN0IBpg1dxSDVu7C4AeU2hoVmOIiu5Wr5VEdtf3zooDWk0UcqAVcydJtuZy8bfsvdx64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6109.namprd13.prod.outlook.com (2603:10b6:a03:4d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 19:07:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:07:21 +0000
Date: Fri, 9 Jun 2023 21:07:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 7/8] mlxsw: Convert does-RIF-have-this-netdev
 queries to a dedicated helper
Message-ID: <ZIN4Yyv+eIYyhA2R@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <cb6b5b31a110d4e927dc8da1dcb31500d69a47c5.1686330239.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb6b5b31a110d4e927dc8da1dcb31500d69a47c5.1686330239.git.petrm@nvidia.com>
X-ClientProxiedBy: AM3PR05CA0118.eurprd05.prod.outlook.com
 (2603:10a6:207:2::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 6867a792-bbc7-4d47-cf94-08db691cc0ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AQEYxchO2weSB3fSwh1+pqq7Swgpyw2Kjepdz0sE3l+qX4d8IGfc9AkxwQogFpCLIbflqxUJowpL3raQaUVDrVQHgKHfrZuPKYK1elqSVirF4OqBR73xQpB0ZUs9VUrwDHNur3JgHlIl8I6dFHFM31D2Va1/2f7N8pCrca0jYHXKEmKBblJ1+Qtv/DQUtrY4pRAjcLou0uUpYGsIH1pmEmVTaWYSgLuuVPiwBY1MZT5I3Uchm/JwShrZz38RaNfYtZs8mAMl+fZov2RpFHLhePBZyaBHMuVeLrYgKXcZi4UC3G5qvCxFXfodQRA5D5T5A/NzxgCeNyEvRUGrbg3OFZc8h/nogDyCXhUrl2PvVJpqCk9H4/bJIyZj/S6BF4nV4IY0rIlnryC7nXB1XRG3nucF6Zhgbg7ZKF5L2up8IjzWv64TSu/T14bkacevFCrX5QCbTt/TtRJlUXo/5CK/AOAUvuOYvAewHPjKvKKr+Baszn0PX1GA5/uBWwKyYwB6RUQLPo9xoUe6V0W1Lx73RaCQV2UJBo2sIBPXHrWNSQznZveEfxcWH0xX6x9fzXnDdvCJixDf8wI1uxoMeP/s77l9EaaU8EJ1UK0sF4GBcLYF+81DMPD7J8QSC+g/RsYQe/ILirlFSn2WTTgg5sn28Q5UTxo4d2grxzS64Uk5ZBc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(376002)(136003)(346002)(396003)(451199021)(6916009)(36756003)(86362001)(38100700002)(66476007)(8676002)(54906003)(2906002)(6666004)(478600001)(6486002)(4744005)(6506007)(6512007)(2616005)(186003)(83380400001)(66556008)(44832011)(41300700001)(4326008)(5660300002)(316002)(66946007)(8936002)(66574015)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N/7FX440DKb2olRniKLiY7HJy3TWT3TboTKWBwzcicGt1VJLW0qRQKWUf+B8?=
 =?us-ascii?Q?BF+W8TLiP9Rb0PG+Xpq/SpcRAOuplCAvRet/HWPVC4XFZqxiVspgOiHWMdCs?=
 =?us-ascii?Q?/Vvw1MngDJq6KphqnPOxdRRO1R/JM4+Usr75eym+2k/Y3p4ANdKFIvEJ9XCx?=
 =?us-ascii?Q?TdvrbwwLwzH6iORQFMRI6WNvpmRvXO3yajQt4g5yzslteA2MgqjAI9Mt4kDB?=
 =?us-ascii?Q?UNVzFbc/m+txNJhFiqnFfJ1JgivgG9cLKN6Xvga11K1BoP7lf1Y64LNyOIT7?=
 =?us-ascii?Q?LbxHHGWtWC74KWbBgrKbt+tkBseAwS8lgYCPl3wjmx6BGAh4xHIYd8uMh96B?=
 =?us-ascii?Q?zRk2FdiLUf91lmHY3nPp4hD0Iltw9zwBiOLHFAo30aYeWA6mtBjvGqtlbXDl?=
 =?us-ascii?Q?ZZHsg9jS3wFaxQSm1Z44n/2MCePSX2+VQDc0cpJOqfBAlmPf0HJWLCWuF0CP?=
 =?us-ascii?Q?3624pMn2f4ZBxaCV/cf5bwgmhEt0ITvTeKMlCvKREpI+7ToZOwvRbK/+vP7C?=
 =?us-ascii?Q?IRQFb/h2IVPC+Zsd7Z1sOGcF3SthODFAw5GYwX+r9l/E9408mRzIWKo29A2c?=
 =?us-ascii?Q?m+keMDdP0w/H6sJbfQN2+ryL5aByP8+uxEIFYduefNY4SgVBmRIwvGQci9Ph?=
 =?us-ascii?Q?zbI6gupFzLJhH5kcPCfb2SPPgTLPf5/7fRlmwDSDYXscoPkFLKYx1D84FFCG?=
 =?us-ascii?Q?X6IGh5sqJ6iv4yEjBMm35VcHe2rZFjJZomzq05e1ipfCDoSPIAeOtJKY049N?=
 =?us-ascii?Q?QsVf7/nmYkENQ+dvS0UdHMZjRRhLwYqMRU6xuPi/0y6wwV5XV8QvIB6+PyXy?=
 =?us-ascii?Q?fS0LHm9Ko5ujuDryAnm2ylOoCSGEqvbSotN813OcWqFU7onwldhKoNr1smAJ?=
 =?us-ascii?Q?Roq9vzM1q85AgJPrqn+IhqapaqKka1VhkLPgmj0kraDMrT0EYs36aH8RLbzB?=
 =?us-ascii?Q?5UdkK9pC3ZTvQF+UI4kRRSZGkyg94iKsU/nxyYQAC7mnU3Rf+jNQQTe3GgN6?=
 =?us-ascii?Q?1HfQlC43aKYEW8UJj6POA4e5wXVsIELtMrilj+Df1hSMtAcXAUpFxHjfy0Bf?=
 =?us-ascii?Q?KptqEUVb6Dj0qVXOt3o7T7w42MngbfoHQpLZeHIPrO1nKAuiFBoesU0CnSPK?=
 =?us-ascii?Q?jhe+ZOYfACLJH4Cb0gIo/jQ6us+37KYoHBQX/PeAZgdqcz8YEqrnFd1fUrrJ?=
 =?us-ascii?Q?zSdFy6/mGTQzD7gfQwlpyR7nLImeS+8Rhrk0R5zV7Ebanvumv9zs1ste/vql?=
 =?us-ascii?Q?vJk/RavZJF3pY5jdMAlYn1161O5Q8xUOVBsSRgcQA7Wo+/G/VVwu3zN0Czku?=
 =?us-ascii?Q?NBu0iqdHogFf4RVrHM3dDL0BBPj6bMPh3HtGzArxx9IzOU6ntl6HKXwPax75?=
 =?us-ascii?Q?9nL/aHpRrHAWsWsJm896S7+xCeQFPXQcNudhdoA3+F9pEuzEcApaLukgMl5X?=
 =?us-ascii?Q?dRVCtWirtyzzH6jfTartJ/3Dyf6U2BUHjpNXLScZblOFeC6SkeSxeI7aVcJH?=
 =?us-ascii?Q?GOUGQvf8oTk6syF55XMWpMuK0+oRecXMZZlmn79dYKW4MfJIaTWR4vuY5B9O?=
 =?us-ascii?Q?7dbV/rRaU7BCVRJRRpmcSnrisZAizO/RHSuic4J9LviVievivHpy+EKyakRc?=
 =?us-ascii?Q?+bufSyJOK2C42iXJJ/+WmkvLdOrr6xgdmXftCThvV+jd5uEnDDSZ596bpSB7?=
 =?us-ascii?Q?bzVNNQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6867a792-bbc7-4d47-cf94-08db691cc0ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:07:21.9301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tiVjMSO8T92KaTcnLyRgH524vrvFcZY4SY/qTK1tyxXJ9DO6F6Ip4Vx9iOD38nRmiIsWK7gZSV6RJbkpt0DrulnOdhF4KnHrwnjLkuv73Jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6109
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:12PM +0200, Petr Machata wrote:
> In a number of places, a netdevice underlying a RIF is obtained only to
> compare it to another pointer. In order to clean up the interface between
> the router and the other modules, add a new helper to specifically answer
> this question, and convert the relevant uses to this new interface.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


