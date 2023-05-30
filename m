Return-Path: <netdev+bounces-6270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD347715748
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 982B32810CB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0055125D2;
	Tue, 30 May 2023 07:43:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF3D125AE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:43:29 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2120.outbound.protection.outlook.com [40.107.93.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9861BE;
	Tue, 30 May 2023 00:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLsxqsn/oEDiFjAVtRbEWJGmJxyxOFMp4x/JPZ0/BSlwHcvEnrTWlmPM6sZp+UdQRbtotGCRW4lKRzjIUmuxgaMiHQYYzvnJil+t3S4v09nk+AZCcfl14nyfTPcJYfB5/+RstImC4wM4rU9RCGAEukrqS88tSc+kocgDP4cZadhP3OKRxxKcdEWur+lXg1qFgVQjDxcYjXP3Kup9TqM+DiMOhavw389ljEeEJ1qpQnH6BT3jh6Tj2ruh5NfGpGJU09JT1Y/UikR0EmGL6hcQkOj4XaiVX+Ku8erPrT1OHz7GewpvW8JMe99rdeSnxccKaEKGW/OLlAH5O83C5wIk7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33Sz43VZhylVBITBKO1IKgw9FZ8/P0dAWpUcjpxhiuk=;
 b=IxC+1GjNlXBrV3jujo+5tw20z4wf2hVB78yDDc4Lob2+i0tHKvsfdspfeBiIq22Oxobsh1S3Ou24ZIxIUqFT+d+KgdbGTt14as7UwhdqBbiaepXL83PDNlzAOd9MxMbMIuDz1sz9t45KsW50ShtJIB6WKGdTie9s54hTP67Y1YblgiKtpWXpi8cpXfEASsefcoOKd+10w6liHCQkMcnUK8hDNvf4BAQsTF/dwYOQwUzHvqjCjOJmt2sor6Oy91DyQN9XXK0tKgajNDbDoTXQcNvUND04+/BZuWuat8/e/3xYkYAwXsWofCF19ADka8BTD98+pZfJBfYSxIa8psAXpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33Sz43VZhylVBITBKO1IKgw9FZ8/P0dAWpUcjpxhiuk=;
 b=wgC4EFAQQ9aSQeoW14OrmXzRb7EXyJMXqCL0/AEf9Hz3RADJ9MhtqhcCQQczE77SW601Z9zHy7oOHklcLxurBx+UB7MQHlJujK5pz9F7whyVtR6tYs+k4wM7VhBBsfAcepPCBeuZCPoNAcUwsVggExZNu2ysKw7EV6rXEixhCko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6494.namprd13.prod.outlook.com (2603:10b6:408:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 07:41:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:41:30 +0000
Date: Tue, 30 May 2023 09:41:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wei.fang@nxp.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
	netdev@vger.kernel.org, linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] net: fec: remove last_bdp from
 fec_enet_txq_xmit_frame()
Message-ID: <ZHWoo2QNW0z3pZdb@corigine.com>
References: <20230529022615.669589-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529022615.669589-1-wei.fang@nxp.com>
X-ClientProxiedBy: AS4P195CA0040.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: ff5ab763-4257-4af9-11b7-08db60e1489f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DqjtObx8waH14YFEVWHw5u/9F7UHGf/8Ap7YUDbWTUS0zC9MFNxEtWp49K4y8S9V2teVoH4UiWu70g/Ow9PPj3lf9+arFnEu3huM3ZlIrMGqjH+mRRsfWDbxX+CgHJizhVPaUecDK71Yeq+DUEF+WPbqiZtkVNodgQYXBvf0QFcn0FKnRqHOpwimblImeIfyNoG1F1idR65Qb+5+IJ8Ek1qcYIUaP6nwcO7Tk1attUaJHUxybvk3q8hN+CifgvB+dQjEkDbLc3Adi27YNjubb3XFvvkucyGML4PLu8uImGx5NDT20ZEm0aCiptAJuUP8IV5h7zWzlrwwPMQReEb/q/rDlG1p7jx3XfczQ4uJvM1hREXE0wzCLYIX2+l9Y9P8FGiMAVHSOqgM0qXMFdn9mp8x8t4iv0AnyLrPeED+mDm76RE/Co+mGb+1bt/PxOOclL1yY7DPNPX1oj2asrYoz8tXC8QFJ0D0a+D1ZL9fRk1UQKbzCtroCYDYEKU+rcp15wJRQgh6/lijPlj5H+pRz5ZtsTckD69D9EapHyEvZtmsF5MoG2KucW3kjXaAXTaW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(346002)(376002)(366004)(136003)(451199021)(478600001)(8676002)(8936002)(7416002)(44832011)(5660300002)(36756003)(2906002)(4744005)(86362001)(4326008)(6916009)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6506007)(6512007)(6486002)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z+u3E+lR1L2y9yYwUjLeLS8ozicun3RKEp87nWIBi6NbM0unlmQzK6hikBWy?=
 =?us-ascii?Q?WJRTg5sz6SEaQiOtmQ5MnsKZExsTaV/slVRfEzo9I3QeLQ50PwWoMDxp0K4a?=
 =?us-ascii?Q?mF9QFYUX6T3BsBHqWtOCW/Oz3UlU+d59cH8iUKc1ZNMZaoD6bdKUonbVNI8F?=
 =?us-ascii?Q?Fb97xWmlNvB3E+gJYRvmQmf8WBFWgKfP3KaC+GXyC1j7AxAmm/+U+xwvDX8J?=
 =?us-ascii?Q?jUEaDQsYtuxs/KYdIeg04sMUOX6h4WZq0uw1IXgfK0qFAHIprLHY3/6vPPYx?=
 =?us-ascii?Q?0McrbbeciYLugTA+GzBCn07dL6sVwObNiUv4bn7byxaX38qifacQ2g0DtjtR?=
 =?us-ascii?Q?3U5GpLZqEEb1uPBcLwoI1ruPOHOUpBaOzpp3PDVeIwpu/LcayhCCenebBiA6?=
 =?us-ascii?Q?OxSI/S5hC+RvuiiW1vPa1dUdINEFIUfKqV7GMxBx5bcJ8mCRmf5KSHBhFXht?=
 =?us-ascii?Q?Vh6PIaipOFb7mszBsROzw7lJr0s25bvgXNcvo+7Ens5yuD2OaPE6pMj+cWRQ?=
 =?us-ascii?Q?PEp6PjcvcrQLn8m3GzlKUA7dvjxCLPkZ3ZwdFbxBN0EbQeri+5DJUqKN9izG?=
 =?us-ascii?Q?BpSXF68ZPoGisO2i+Uae35rGcXhOP91eD4SEZigC5x7/Hk/l5UrRulIFshCf?=
 =?us-ascii?Q?F8s1q5BetwxtoK7l250nSwReZqcP5Jtj4ELv8v13MytjtA848OIbEvEYYdT5?=
 =?us-ascii?Q?hBA85lsSdXeZApavcoKvnHV7OPmntKselq39uRt+ZTHsgi5SuQFx5T1wSla/?=
 =?us-ascii?Q?+Y6iiJIkwcjPT9SpH39EVOblX1H3NsH4iQUd88EAnY0Fy/Vvwjx+lpCy1AS9?=
 =?us-ascii?Q?r5iFfAgzeyxvraZa5tGDHGb3EV7kPLwKMuf2fDDThqKRkyvVP74yptE1lojW?=
 =?us-ascii?Q?8RctPmo78X696S9/b6GtG886scPVs8DG+6/xbF7siplFasZLXvPhM+tRHgDp?=
 =?us-ascii?Q?AG2TY58FTwJYvclUEUBUJKXNNZGz/HKBh3BEK4ET862La9CZrpmxOvR5m/Qo?=
 =?us-ascii?Q?UCUjsBHS6Pb19ehfzu9KngOs8fgHO4CXDzlU/zRy/Te+S/sVf+dSXaDoSzk0?=
 =?us-ascii?Q?LXVdcAlAs5ICsuMBHIWw8cM/9up9Xsqu8DbENt7Uk+i1aEld2x2eFAELGp2o?=
 =?us-ascii?Q?7Yqs1elaRHp4Y3VV48VlKGLv4xC3T4Zipzf0/iwOlEVU8eaQATwL/TfHNWCh?=
 =?us-ascii?Q?r9MssEw8VRaA/+dLwtnP8KJDpdK8Imums8DneZMhwDQAJCQ50jX1zM4IFzMm?=
 =?us-ascii?Q?731eCDWQFYFURNR37fy4/DF3UHXgB4UYvYZnl7CQy3fEDhg8lIIgsBWVhWRA?=
 =?us-ascii?Q?EU4pKPeSR8WQvcMgkNPYoriAWXx6xX4pu6/u1rx5aEyEhsTV4GNtIF8MYywI?=
 =?us-ascii?Q?Y1BnWEdFxC7C7TC68BP6E6DFhf4F7oq4+N9s2pxBF4G6+FImrnheGHO+ShHr?=
 =?us-ascii?Q?yGfHETPPXD4DLBpF+5DpQRCcV1qqsjTMetvvADkgz1I4Rk2fEopD5uQaIvGi?=
 =?us-ascii?Q?mchuM/xKwWhZOIZGYO4L9/8TO2kcTU+wRjt1N4QM9Dav3hmdfBh7pD8Dcmfe?=
 =?us-ascii?Q?lnekTy3GKiqxc0gsA6eqkCP5Ro9P/cER2a2szGwUhsVBWaBeSx1wRy++R86f?=
 =?us-ascii?Q?KYxWQslMuK8h+PYc8qrXbtsotHfJlklUVMc5nb8mDWfBfuTNFo46MYIrLpKu?=
 =?us-ascii?Q?WFXKLA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5ab763-4257-4af9-11b7-08db60e1489f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:41:30.6528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVCMW+lm672LIpt5tFcT81fhLYu4/lhqAjFndI9kW2y+DjDbhXDETwqbs4TIeX5aTWTDyR5oR2jgDyHR1YswutvcgDAif2DIBD2y12Vx4QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 10:26:15AM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The last_bdp is initialized to bdp, and both last_bdp and bdp are
> not changed. That is to say that last_bdp and bdp are always equal.
> So bdp can be used directly.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> Refine the commit message to make it more clear which is suggested
> by Simon Horman.

Thanks!

Reviewed-by: Simon Horman <simon.horman@corigine.com>


