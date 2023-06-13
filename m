Return-Path: <netdev+bounces-10437-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FED172E740
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DFE3280F5B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133E33B8DE;
	Tue, 13 Jun 2023 15:33:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F7E15ADA;
	Tue, 13 Jun 2023 15:33:12 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB139122;
	Tue, 13 Jun 2023 08:33:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwKes3603RrayNNuMZFNdhWjwUEQ8zC9T2OVKNN3bSpUkvhm9FF7X1Fr5VpZ4DP4PAHE2SH44Mv0HEVBqFzDirz4nwoPSAnI7v2pGjDc+AT+z/vqgE6ADYoECRBZoSN9QbXXne/R8bx5/GKLNy0qSKIKkeW2hQWJY909DY4QnkRfs+kmechC7CB7XulYc0Agj1JFfSvz8sJtyslqLtk9fB8yAYUhJcX9GRtcFTrTUHcoNFW/rFuq7a6ZPpnTNgcQ6AoJIkY5V2rxIWeus17ZF+1GtiD1uta+wRGE2VKWFnrZ0qhUh1ryrjKbY//+JRi6jPEp3b/OFXNvcssRYj0TnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wY6nbD63njEF69MqY7MHUOZb7ouAcePEVsZm67cRfFE=;
 b=VXDQBR58uav4W7w2hxjfDFNoRHTm5cmDehLOOqncGQmi0j73GgocpUWK0HOgcKjFG8SC1w3gGASUUyY9oJnjh/EtTMalMRhK+sCyzkRJobWlM7SDsGnJagZ7IOZLHye8dcsOpezrnZf0MM2OWtU3bcNFgEu30TWXhrBk0h9Gi1o2KQxauZDUcXx/OeUFDGmiEi6phePO9xdUaSsuvlllQjiqjUlq3BCuD8IFp7Plkqsa4XK6434zeYOuFOsA+w+PRRqFVg373W94eSgHj8dCSVFblvt5GzJ/uuy7MglWfsvJkSsVl/MfNCXGumTkNNGO8rnzQZ4V2fGhi9yT7JRi5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY6nbD63njEF69MqY7MHUOZb7ouAcePEVsZm67cRfFE=;
 b=JvC5HI9aA6yzWQDMRrRuigPkFyYcAUEOnBN4wDTgPgjs2JTqtyms5eFbv6/F/uZUXHpzF5/sQc19EDmm5jH3a19X6m1D6QO4h6a4SraO16RlfHqAWFQyejdH9tN5RtD25oeqXIg4ZnRv0AoqapQ4bsaF8OXWD8Cp3F0lCIPWJgw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4040.namprd13.prod.outlook.com (2603:10b6:208:262::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 15:33:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:33:07 +0000
Date: Tue, 13 Jun 2023 17:32:58 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Lorenz Bauer <lmb@isovalent.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Joe Stringer <joe@wand.net.nz>, Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Hemanth Malla <hemanthmalla@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup
 functions
Message-ID: <ZIiMKgt6iQwJ6vCx@corigine.com>
References: <20230613-so-reuseport-v2-0-b7c69a342613@isovalent.com>
 <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
X-ClientProxiedBy: AM0PR02CA0202.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4040:EE_
X-MS-Office365-Filtering-Correlation-Id: 986f8eff-82cc-4638-71b0-08db6c237cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a457Mer8PiihF2dWi5nRawe3d9wXR75GBToQekQ60gdl/qKpTUppJoYuZOubiqwRiup5XwLPRF6AyeaHmyVxQdkdBA1OIPbkZBQHYL694bgK9I56uUM3G9jVKH/HolqLUWDPa5cCMww+WVbHFMpkQ59BvJxjAusnWpvjYHq2JtVInfVIn4zh1GeEiMBQRxl4pcIsxDIGeLrJscds65vhHQVFybWHaEq/CzPnGg6GCxN17mEGsRs4xkEvIKIO58UViM5OR6hVzznL49XwJ0qcsFcnzCiQdnxuV9TAn0b+T3QSFGnk8cN7tEirpLcBS0JnJxPeotzXiylFIk+CcVyzlGxNZO8H9qUfcKcz/FQwyv78OO0NXJa4+dQ4QIhDgYpXYFZnHLlMSvWd+fJXof7CFgrgFdawGdq+sEDI1sX8bO2HXZqPZmZrG6cSlrqbA+WOciaAMjMB6eILRpTxs3cOM4VNOOVdx+4Iei66DPJ4LHjXQSEtbG77Or/ufEUie7j1WCFYp6bcgH6xBVWclt7+vGBrtxophncWlolZgBHRYxjp9ll+mfnPg7fmllLNOcCmEyXZl2uQRh+PDcIXsH84h4ipmE0OGKSErqyF4JQ8ND8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(136003)(346002)(366004)(376002)(451199021)(6486002)(6666004)(36756003)(2616005)(38100700002)(86362001)(6512007)(6506007)(186003)(4744005)(2906002)(5660300002)(54906003)(8936002)(44832011)(41300700001)(316002)(7416002)(8676002)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SluJtbNVc0bVwOTPYHz1aBl+GfQLMOisceiH4E0fUNKD6X5WmWQ5e6+qccCR?=
 =?us-ascii?Q?eOGrcrOcWrMVG6PVoVXfceF2ibnQagFkKT/+sJVM5XTq1WkiWOmKu7KjsQhV?=
 =?us-ascii?Q?Th1Nx+sGNKUC+/G/nNIhES/FZSl4lFwDRa2Y1LBrWm3xjUpxxOJLSxhIyt5x?=
 =?us-ascii?Q?UpuWrdVk27+oKQlT19w0q/tE2sg/Vx7j15cxI2OJ/Bwvydelu6xDwllsRJjm?=
 =?us-ascii?Q?uetDMJLeekaTDCRDq27LIcZkE664ZPZMbjwwoAljE8kVLb9WnXxFyBKhH9UW?=
 =?us-ascii?Q?sCsGzWtXDgqIhzpPrcE+uhbDF2XJgTvg0XGDjhWcopjgjaJAJ1n0hrhvYmEf?=
 =?us-ascii?Q?M06m+2YOdF8cxUwEukZcxChiAF9f7r/00T8GXW85/maCf5PjP9rQergGetiS?=
 =?us-ascii?Q?ateueyIQGWRrf0/n2cnibAG5vz3fDEiPutX8jnCOwhAP/UD1lYCNMVqfuL3y?=
 =?us-ascii?Q?7Ko/hGrCO1yEUCGKkSkSXwxtLAvJxsiHCUZSnobC/XfEWAzucgXIwG89uQDz?=
 =?us-ascii?Q?E8fMxe30/vH9z7+Lww29NCWInitxd7LXzkvhCSwp1HwH/zu0kjreNz9pYxFR?=
 =?us-ascii?Q?LSK5OveZylaiOJr1L0tDFTxikFW7G9hKaGzjW0tXRLAcnc3xUTAc1aMKXU6T?=
 =?us-ascii?Q?GRw2UT2ZP6Al3qYB4JAACBgBd6iG7aIH+TVWWO5GSCc7eNwvsGpYKkk/MaiD?=
 =?us-ascii?Q?3LPwH898OQlOndS+gKQZNiHmLrsUNF3YEJv7v9KkZ3YV0QCwx59RcplADa5q?=
 =?us-ascii?Q?JH43RpZAouTG9fodJz57O2zaucZsk9Ko9uerwLWguDfeDrDDw/XWyX8qyPJS?=
 =?us-ascii?Q?b1m6nhw+2E4uwriKSgv+ayvHpoyWP/zZJE3mn71w4qQL5G4T5176Mz8Q+TCR?=
 =?us-ascii?Q?Kw9DhVljZUVmRe4cKlO5+8xj1/1tNDfbEkpEUV/c1D96ygR7jiZpseaBUyrE?=
 =?us-ascii?Q?c8+484WbYV1bcukV96QSD/Vb8h42YaFqNkCOzBW2fkKD2t1LR/IiLHfLQfjz?=
 =?us-ascii?Q?facIC+Ne1J4vLR/gZGQbyZtg+4iFoMe6ImtGbMPkgUG+Et5GmI6GETe0DKd/?=
 =?us-ascii?Q?o4fEukJgJkOwwHGjOUCpG5KZyYYpDv3+IKzGJ+L2GhuSTLhga6yyLKpW5TJw?=
 =?us-ascii?Q?SXX8TJJ7L+qk34zPDJoE7kiIyGfUMYunOTVZNRrBrNJuZtpn92xQFvqYNbg+?=
 =?us-ascii?Q?GaVlvrXp++UjimYdr4S74c58GZWC9XdhO97vrN2DtVzP0lk/zygt4y38/noU?=
 =?us-ascii?Q?tyljODgo/vwWTERJ2CLCuHbAafYlnEyll4oSMF2TVFTDXUeulkVsP9iW1+SP?=
 =?us-ascii?Q?VvwnPakvw/1luInPOLP9218pCuAGoYB+hKCfiBJc4nrVUwY2NNy3u5iKkP+j?=
 =?us-ascii?Q?uxjkAchtjCKgiqF2atSu6ItwToKt68RmFrwGdvJYVsb6hj0f1A2eHrqXWFKM?=
 =?us-ascii?Q?c3Pt1OEQc4zSeqoapr6ZvXjrCVur1N7gBApRKRy9rVB1xXq4UxCgne67IWZD?=
 =?us-ascii?Q?qlZiEyVD2W0cxZDgr6fkNc6uDmg9Vtk5Bdv9LV23O3CxaH0qx6iAGshhDvKF?=
 =?us-ascii?Q?+5G0drDRTiMoNqIjEOWyRBJn9cqWySL0ze/JlA/AJBE5P9dUwntfUfMrN6jo?=
 =?us-ascii?Q?c6VRO01h4AbFXtja3whTEwMGY28gNDd3gYiqoHzQYeiAuZSjnXKY3vR5zpyH?=
 =?us-ascii?Q?wMbsng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986f8eff-82cc-4638-71b0-08db6c237cb0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:33:07.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PjNtM+8z6j+lGwBDOggZVh6fA4E+7b/LmVZ3HUu/7kdR607wgD3xFg/tGyitdVMItZSzUl4mwm5DtNkZ7GyuX0XnHvhG5CbGyXUh0/acBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4040
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 11:14:58AM +0100, Lorenz Bauer wrote:

...

> @@ -332,6 +332,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
>  	return score;
>  }
>  
> +INDIRECT_CALLABLE_DECLARE(u32 udp_ehashfn(const struct net *,
> +					  const __be32, const __u16,
> +					  const __be32, const __be16));
> +

Hi Lorenz,

Would this be better placed in a header file?
GCC complains that in udp.c this function is neither static nor
has a prototype.

Liksewise for udp6_ehashfn()

...

