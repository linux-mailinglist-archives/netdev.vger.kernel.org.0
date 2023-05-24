Return-Path: <netdev+bounces-5047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A0570F892
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2320280FC1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC57018C08;
	Wed, 24 May 2023 14:25:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79A418C05
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:25:39 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2124.outbound.protection.outlook.com [40.107.244.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FF912E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:25:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VX3sMju7iC+qZdshdgEAaEWR4yLoke7MRJ+87hsI8b/OY1cFcgvqFTw/ogpadpO49yKVBRfmSaJ2G/IClqYFe90MhHcghvtMQPxmeeHm5t4Rf9pNeJl+8mz8pk5RlOIXrbxHQApm1e/swj0uc7a6nxNXOoWwzUTUXs/2U0gquvpBd/OiJbqz9nunB8qGYqUDoOmoovPoqfN7A/mZMV88KP9dwHvtCrNFXhcsMPTNE9b/hZbIac5CXrKiWsfhOYc3cuehvudEewNDVH0gvyGV89XJCLFPO4dbTKJo2GD3McKA/Ag3LNSDcZaZwAeJ85pBPjylPSUncrc0xf2WbpqaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtVHEDQAWxC0D762kEGdM1P8OY9tOOER0Grbm3qq4R0=;
 b=Q2DVqW38y+wiV9G+vo5keD0mAgs3o6OjKemRVLPxL7YQCgFrh/w9os3nS2Sg/bDdKnl/jly7IME4ydfP6DM42K/4DjSivJJOP7y46tpbgbGbk6jYjTrTHM5CL0i4YK7YUT5uRCdf5R3rnjAFuHTgkDQw70cOPkoSF0SGhuv2vkgsUNs56dgr9oCNXY/0EVMSZEZnW81WCf55OvgolUzeWQPF4WMu98zf4Dcwh0FLd6ja4Xb+VteOCzzYBnXRQYY3y8VZtRANU6eCJdkjfLxc0GmD1eR2BgRfUaaG1FjewnH2COh7CVSSKJZET6Rc0Mvi18TPOHH00zkEZffFhbq5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtVHEDQAWxC0D762kEGdM1P8OY9tOOER0Grbm3qq4R0=;
 b=p60JLgqwOPAurFyoJGYH+lUDnANLiVUlKwyv3Bmv0dvhOEBhNVtUrvH5v+VxHg7KAQOOmdSqCZHMKUDjx62ryDJ9uoYp4kVV+1JGxbjjE4IDf+YsIzLxdyFv1SEayQhDl/fSPCSlstFCK7SZaXJxw8cA9Pb1wpkV85ictapQFMo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5130.namprd13.prod.outlook.com (2603:10b6:610:113::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 14:25:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 14:25:31 +0000
Date: Wed, 24 May 2023 16:25:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting
 the channels
Message-ID: <ZG4eVZgdhy6oo8P7@corigine.com>
References: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
 <ZG3idM6bQmF0Bu69@corigine.com>
 <d4ea49b5-5515-4097-c879-afb60cc5c673@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4ea49b5-5515-4097-c879-afb60cc5c673@amd.com>
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5130:EE_
X-MS-Office365-Filtering-Correlation-Id: 39e0e0c5-73a1-45f7-681d-08db5c62bae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nf3QJcCpVlRHhQ3+gxPv/WL07ObJRG6znSEXb68UmxnDwm7Qi/RHMlsqo2XR48Y9tBOOEKyxZRMS7YGBkYSAlYkm9KDzoeSCvh0FxS73Bwe83RH+wj+6G8BdMXJI9QQx7B8rcHWThDo1JFDM6Mto7RfWP9eZYp3+LJ9xqFgh6t/6n81ilPrY++HXf5oGfQI1HxFX/Zm98cD70doGozHu8Jx4+BL1B2WTe32B/Ak2fdPstSFjonE9pPXCH32xzS7+oKUf3ifeoBOYwn7dlsHXxzFethT0MIqrFn3O1pSiPJ0vMUd5uO3eps1ORU8gfnEm1llwP9fgGInjW/tWc0ev9xCW4mgXIPH/1S7mZCWDvuCYMasddobgdgosAoc8EV5u6J4wYAD4tuqIuzbsT+zy3Ah6sikaHIpxfdUX94KN4UTGN6flvngN6vru7gzsUjCOz/4s+m+GAJrfPl7loKI3/7IlQzWkSJXl9o7/wkmKuCfMxlQibFTQOjzJ0a/l6RVhN+yLNOe8lLzYsjsc+EJXLpIrgBWM4zsAidScoOD9jzhHHxMeHJBufvt123v8Jf+6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(376002)(39840400004)(346002)(451199021)(6486002)(8676002)(5660300002)(2906002)(44832011)(8936002)(316002)(66946007)(4326008)(6916009)(66476007)(66556008)(478600001)(2616005)(83380400001)(6666004)(53546011)(186003)(6512007)(36756003)(6506007)(41300700001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7X3zDELhWbO9S/K23PV9kCQ5Qs3LKoJNQpv/ryKAnLY/bEG6noUKA4RWFgX+?=
 =?us-ascii?Q?4QKm0brr43d/isl5tNTWijE1/dT7DMqirytb/kfjsRug/iqyXcPAeCjRSQ/G?=
 =?us-ascii?Q?jl/WS1sY8hBQjIZJVYXRzJl11fpws0VOrrG2xwKmUtgDV9jZVlkIRvB+y7rj?=
 =?us-ascii?Q?7aXW8YGKni0pBC0h0pEGBeeJJa8mfHn+eHbDV7S7xDN3P33F2Qfj5j9i7MDT?=
 =?us-ascii?Q?WnXFIixQaEuYvKijXK2PimjGIA1Q+CVvQZcf78lm4tbKgZsLNlYpC1B6pOgx?=
 =?us-ascii?Q?s9yuNULMf1QC3Ob3EwygCs9mAq3w6NmGLTunAB09PUf3Bg8PxyB+iAwF0Wpe?=
 =?us-ascii?Q?9mnTucubkAJV1WpxI5mRLZcETYfdBOzXsLDni4paBoXHdE7otn2c9WuC2ir4?=
 =?us-ascii?Q?Q9g5DboGNJOv0z4HdjH5ERlm3U1lQV3OezPQmNSHJvtjncgj5Nx7biVVpNsF?=
 =?us-ascii?Q?JmzaM50pMpkNCr7EkndwKFRnlJtV5/G5YJixutS4MHqIh/W5HXnslp0fYbtA?=
 =?us-ascii?Q?vImLR6quGfEB6nik7JF53UhV/hMF+ghYiJM4yVq3BftbZxMx3QBsZZYsSp/X?=
 =?us-ascii?Q?h2NqF20tiIi6uXXNiaS1DJwlI/1i6G1bU85x4YKcBgde0N7/Mu1FVHjGltVw?=
 =?us-ascii?Q?tnyI5BKtxnKHzbsV3c3HcMbuBH0gmhgXi/kOjfK0+hBqSvDlxsOy3ahFh4Y9?=
 =?us-ascii?Q?jrEWC7F+5dbUXtfe6gH8aecd3qWpxdepeCwUwZ5l1meQpg7bXnGkks1BXUVw?=
 =?us-ascii?Q?Dh6jrtrMydIfj118BHyEldBTa4mhWPQWhv1AbY0r/JTOiSvGHDSh+9KBiyOK?=
 =?us-ascii?Q?Mw7jNhdOqtcfeWWSq8scHZA2Y23SYalFahRWeHhz/7UwR2A8MK2IHbHfPYWL?=
 =?us-ascii?Q?3AToaCLZY+92HGi3Za16H5N3o7vaTMog3a/T3RjSF3+acG4o8gLcz2ytFoA9?=
 =?us-ascii?Q?IlTJRyhHon92ctwBXpZ1X4MVOzBjlUBXRMQA19jzo6nDQ7meW4upHHiWEnqJ?=
 =?us-ascii?Q?T5KZKIROf7kBEudKBED+lpJ18jncO0CDKyupsXra0Zz8hffwMheRRiYd0Y9c?=
 =?us-ascii?Q?ujjDkYmez7W2jcfCNSplbn37JCFSnuVJCioxy0hejKwYuKYPdyfZpXnyrTjC?=
 =?us-ascii?Q?rVVnXWc2mglAKkgfUr/XvE6YEolGTKbR98+9uPJuvK3clGxj4WPDr8xr9RiM?=
 =?us-ascii?Q?IpKQCIYCFwEiZOnoElI8U7gIm5nTSQ16wKugKxf8nDiRhhoAx/GxFL9U4o1/?=
 =?us-ascii?Q?Ndt7XIlFTbwDLyRTWPIQrE8IiDw9AgCib7nVh5Ph1GkUac2moW0nyP3ogoh2?=
 =?us-ascii?Q?2g1lxKv0zBA/BfcH3NGInPPEamO3tBM4pHydLuCIzC5HuJEVZfi2wYOcsjjl?=
 =?us-ascii?Q?QkR6utc8gPY7kedm4FcB25zki2ylcE46JgjDWao1ACgQR6/zarJVwgLbgHty?=
 =?us-ascii?Q?wwXqbFeKq3eBO6hP/dAqBamGv2E2gvGGHMXjDEZiStYpI9o+0j7wb2/dewM2?=
 =?us-ascii?Q?m7b9Atu+XHvFH30TajEAZHhIqMoN1tVDwfws6zd5bHrbJzMeAS5GnUdDb2r5?=
 =?us-ascii?Q?N843bCbQNeuiQ+inIjdYINyvhwAWwXeIOFio4m7/YKuj5ld5ui6yNWluQmHh?=
 =?us-ascii?Q?61XWjcqcWicKdvUCrCJaAAUXWU3TnxI/o5AZfFW3HPcpMaITpLnbCMh6FTvk?=
 =?us-ascii?Q?cW+6Pw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e0e0c5-73a1-45f7-681d-08db5c62bae3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 14:25:31.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpW4E9VNV1q46L9x7o7MKcPmkvGtdLjcLh3ti4iKcaSqPpW3rHZKEqXjVumEWgQlUF30V3JvVJ+ad2Ok/gmnRxwlBI8OV/qNOSf4x5Kd/7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5130
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:52:48PM +0100, Pieter Jansen van Vuuren wrote:
> 
> 
> On 24/05/2023 11:09, Simon Horman wrote:
> > On Wed, May 24, 2023 at 10:36:38AM +0100, Pieter Jansen van Vuuren wrote:
> >> When fewer VIs are allocated than what is allowed we can readjust
> >> the channels by calling efx_mcdi_alloc_vis() again.
> >>
> >> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> >> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> > 
> > Hi Pieter,
> > 
> > this patch looks good to me.
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > But during the review I noticed that Smatch flags some
> > problems in ef100_netdev.c that you may wish to address.
> > Please see below.
> > 
> >> ---
> >>  drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
> >>  1 file changed, 45 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> >> index d916877b5a9a..c201e001f3b8 100644
> >> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> >> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> > 
> ...
> >> +		/* It should be very unlikely that we failed here again, but in
> >> +		 * such a case we return ENOSPC.
> >> +		 */
> >> +		if (rc == -EAGAIN) {
> >> +			rc = -ENOSPC;
> >> +			goto fail;
> >> +		}
> >> +	}
> >> +
> >>  	rc = efx_probe_channels(efx);
> >>  	if (rc)
> >>  		return rc;
> > 
> > Not strictly related to this patch, but Smatch says that on error this should
> > probably free some resources. So perhaps:
> > 
> > 		goto fail;
> > 
> > Also not strictly related this patch, but Smatch also noticed that
> > in ef100_probe_netdev net_dev does not seem to be freed on the error path.
> 
> Thank you for the review Simon. Yes, I think this requires some attention, I think
> this is one of a few that we need to look at. So it will likely become a separate
> patch set addressing Smatch issues.

Thanks Pieter,

I agree that these are separate issues and can
be handled outside the scope of this patch.

