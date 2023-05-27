Return-Path: <netdev+bounces-5914-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD022713532
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 16:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A89F281705
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C11C125A4;
	Sat, 27 May 2023 14:51:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19AE11C9A
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 14:51:08 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEACAE1;
	Sat, 27 May 2023 07:51:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nonACX9pmA+zRWzVfH3wv2VaT/HUFvdm2Zjev9AXgXVY90j9wcUshjLjrmcmFhEJ9eHO5a0vD/9fIKnnKXp6PMd2peDeWzh0UxlDMwnv8rfyemt4RJZH0zuAN7yN3mKsJvtbIXdEWS0PxRPCrpbCRUe8dunTwOi+42KAKL5Pw6tx1FvKcoKH+RSmqWu1jZtclEOET2lOWlTjo0YPsqE0nz+mW7fkFX3mRZHQQ2rnLNK/5QkRBc9PwSlTt5CqnsSByMzBGmblG/V/1Hyyd5XAcXxSUtS9uNnL4s895WxB/Kh3vQj5eDr77RqbbgKxJ6UoD9H6CZGmn4Qwv3Tk7P/F4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/H6BpRgitubGrfuX/KcDIaK8EvST+C7kleuHYBvifM=;
 b=Sx0qiNioo8QkYxLAvxnmkk0yTISpHDukSIl+AVimFA3r58i5lARG97qW/ItTOpXU5//XOm8ATnCQ0C3R/WaI/kmPXc2/4pChDydskU0oKDisnZ4chPBGSWoveXFdlvj9Wn7KIHlkDQNN9oRaEhj42xgClAuZ4vubBKGPTkpyS8lDLXEOX0aVy7SdQfGIBrGCCI4Ss0zRs6Y+557Pt2pptPVdWP6RgLqWNoGvIZizRqfkLNdPAqArslVletHbhL0nzBAtiSEh5lCNMMmJsj67VCiOZn0sYsUxdSmwRhtUen6YO80DOKVwfF94DtAT4xsFnqzSO0LMWUzVIyaFNim+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/H6BpRgitubGrfuX/KcDIaK8EvST+C7kleuHYBvifM=;
 b=Zs5ydMcarPiK39IXWpEF1uVoQyDzwpBGgvQKpfKczG8mAucxoKjGDohESSIGeYhJ62FJXAaOTfkyBw36O6MmZsIDtDeAolzZFZ65KWo8YQNeNAQOdQ4UpsC1n9z7iA8EjC9l4pHmmphZLHxCfaYHEM70bOtGdARlgRocYjlkl0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4555.namprd13.prod.outlook.com (2603:10b6:610:61::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Sat, 27 May
 2023 14:51:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 14:51:02 +0000
Date: Sat, 27 May 2023 16:50:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Foster Snowhill <forst@pen.gy>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Georgi Valkov <gvalkov@gmail.com>,
	Jan Kiszka <jan.kiszka@siemens.com>, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Message-ID: <ZHIY0LJlcQP+VVDw@corigine.com>
References: <20230527130309.34090-1-forst@pen.gy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527130309.34090-1-forst@pen.gy>
X-ClientProxiedBy: AM0PR01CA0163.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b85dede-df08-4016-86c6-08db5ec1ca94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k//W7tTsNvsewAilyFAJ9FcNwB5gHnh21HPhsJDPLR9lXz54i54ryQB97TqgPg1z2tg8iFdj/n7wf93+oJxlZMzWdxTEmm18Ncd3/K1L/9j5uTBc4PqRORlPtmERoj9MwntxLLAA/STy2ed8RAHfJMmGyI/rMhX2dpfAZduFb7QAhQWyVfp0L01jKIVB5F+5KVdtIo2q3N4k/6MfXMzxrjvT1tsVqiDJxALUP7rVCTm37s3tyqILJ+BKBH4LF6h9Evz5syARHpFb662Rmz9a5G8jEg23dOz3txXF1X7v7x4iVMJXUsY5Duj8up05IYfc83ePxFyW7UsLQLoaExtHh+Zi6XWUpnKhLQ3ZgcJU0SYrCdAaG+lKAIo4KQJ5fCKZL3oUhaYNZ3/U5ZuQEWcm6yUfEiyzvTFdZei59DbCFnpLaAgbTISwies2X4r4/7OTSI6sasCRUUatzXQjgFu1emBOASphJPvS8b80T8HPkV2w7S3ZGB8a/Vw1sRVdJxftGe/j+415eDVNAFEDftsa531wHjpmJ/S3FlpuHgZM26bRB3tYQ67IbeWcgYkHLyk8nVfK+quaLhgIszOasWO+HK5xF4lKiMyi6g8A/q1mM+w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(366004)(39830400003)(451199021)(54906003)(186003)(86362001)(478600001)(2616005)(4744005)(2906002)(66476007)(66946007)(44832011)(36756003)(66556008)(4326008)(6916009)(6666004)(6512007)(316002)(6506007)(6486002)(5660300002)(8676002)(41300700001)(8936002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c/Jcv5672Yt9ATzBRqeKKm+lOLzoXVch2flQPrJyUSPaU8AkFm9gTxC/zgyr?=
 =?us-ascii?Q?HZvyx8N84nwfa+UWEvJMlpo968u5FjOEscdsDXs8MaYfdumhExP4RvS0IeIa?=
 =?us-ascii?Q?jIQmY1xXmE30o8ahRWojjlYVtVZOPAig/zNddImPMEIt+XvVuW7Oo96GFN7G?=
 =?us-ascii?Q?JtHA2AGXAr8IfHx2W1PxGte868Vg060j6bBdazN2Zm1QaHrohhK2+ptunHuU?=
 =?us-ascii?Q?YkUEOpzPxXKjwqBxMh2c96qaIkPM4aDMGmbLryGWmFSnkUFxhA8A8DBpKOhl?=
 =?us-ascii?Q?iZ8SnX6h4NMPjvZFTU7/Gbih1WdglnfBPieEvtnFnDReT8vvXD9LJ0VaMH46?=
 =?us-ascii?Q?i5eulF/1N2HVOKiXjwmuaR4kFYHSQosduPkLQ8YFZsx9FYYX4yG9kfBkIkCj?=
 =?us-ascii?Q?fJibKHc3hv9uOvCY5pZkC1Elwi1q/TI4NPrmPnCQgjKLZW4HPL2Qw3wbktfe?=
 =?us-ascii?Q?3EI5i6NliFdiwrBbmupsd28DA51dOjxiVubYCbI1NnlL8/iOQm1EYae0gWBu?=
 =?us-ascii?Q?4kx3GZtaihMESzyHmK0Fib/DfesxBE/XcRDScB605MbAt9njZ1CvkYqy4N/F?=
 =?us-ascii?Q?sx4HEdFqYFx2DUpLD28OrZlg75CnudpWvNwQbtx8RJ4ZYhWpIrJqpnIOO7jE?=
 =?us-ascii?Q?dpCq2IGv7N1l8Z7csjjZYxHtXeBhsKoWL7khDqYuGrTJqfJ3PUu7au+f3jvj?=
 =?us-ascii?Q?WNEA8Sw8mz4VhxRptUX1/cplgpb4SVpBCYvn+Y+XkS9EsCRd/XuumujBXTxA?=
 =?us-ascii?Q?Z4JeTJ4/hDJHWq7AxqmcMTQ88DW5hOp++rrLUjBFJSqfCkOO9oYeou6Z0iB9?=
 =?us-ascii?Q?DqhYAF47TN2WqsoHz2RF6WM8L4SIeoYNdot3k3h2R36N/clvt6SX2xYIBuU9?=
 =?us-ascii?Q?qKGkhy+JLOMNQ/B4XzbIfFX0tYb8hDlMBUVzspzWOlJ/EhjkIfaUed7D6Uux?=
 =?us-ascii?Q?Rzm+F4PTtsEJ/fTVVA82gU+buRgHFzS2tbzCA7+llfBuLs1GfqBEum5+hUSX?=
 =?us-ascii?Q?vGYkogA02wwQJkKQDU5lv3z17K41+6YakVywTJ4zeLjfaU0CJrhkJ05f4gF8?=
 =?us-ascii?Q?+RoQE1JpuVo4ROvrY7RoXHi3HN1T8a9Ug+BzTxTlaDrYnBAGAiL/dd0SmW0M?=
 =?us-ascii?Q?p98ykuNoA3lUirD06g4M9IA/cgZgN0uSIwJUzOi7VV8ym2O1NPmLqjrzCWQR?=
 =?us-ascii?Q?uwJ5pDzAgZoZhU2j+OfHcA1vy+SIPRfJ9XwAv1RnbFkSHt4RHg6sn2H2cf/I?=
 =?us-ascii?Q?0uFNda41aSV23F49S4R3XZ+x2kRG+B2nRfisa5A5+rjrvN27YqJLDLgpuonO?=
 =?us-ascii?Q?+AHAlnsxG8sMkYm5s6un/RbCaytgq+EVj8soOy5514ZgNXnsr4gAiN4Nw3hq?=
 =?us-ascii?Q?q/wGvwq4uQq8NROm5ZgzqjrQ5wmuNlWbdocaVNCA6SxDMV2updnX4YAR9S4G?=
 =?us-ascii?Q?XZ9JCNJrt55sxZsXaGaFRAvBhQFt7HS45QpaAWTasFfGB1aoeQFkr5ljeewm?=
 =?us-ascii?Q?g8miErFmnZZQLuR+2G+VZhNWw8s+K2rZf1XMC7QYKNmGIDhNpk2muY262fIi?=
 =?us-ascii?Q?3LSub+VZd3niHpBcr4/ohJV0GY2P2aE+g9ZOTBbdLRa17KXry63CMlmg0wz2?=
 =?us-ascii?Q?Hu01j9YIPzwmYdEuH8TCB6c1KHoQrdJ6r5DIb2XTb6jgtdBiUThe1+SjjuC5?=
 =?us-ascii?Q?Cg9cUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b85dede-df08-4016-86c6-08db5ec1ca94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 14:51:02.4368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhosEOMxyNH16Cd/G7yQG1j0SHHz39PwLE+NgngkBs1nI+yb6bKqPtXtGZyLJMl35Tt8XbUNS/uvuV5eaqcyI3AluURMAkRTtg/AKRloLu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4555
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 03:03:08PM +0200, Foster Snowhill wrote:
> From: Georgi Valkov <gvalkov@gmail.com>
> 
> The cleanup precedure in ipheth_probe will attempt to free a
> NULL pointer in dev->ctrl_buf if the memory allocation for
> this buffer is not successful. While kfree ignores NULL pointers,
> and the existing code is safe, it is a better design to rearrange
> the goto labels and avoid this.
> 
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> Signed-off-by: Foster Snowhill <forst@pen.gy>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


