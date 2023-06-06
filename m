Return-Path: <netdev+bounces-8496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 480637244FE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ACC11C20B53
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7AD2A9FE;
	Tue,  6 Jun 2023 13:56:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD5237B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:56:20 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927A010C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686059778; x=1717595778;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ezIVlsxabp8jaSYXZKsFjvLphVCeYRo6YkAVbEMfRvM=;
  b=i4JVIW73Fu+kzntBEPboUuPWfu5P5dLoHvwdbssYVfYf68dFhWk8vRKV
   SOFHW3YK92ohTA+ih1Sw91j0zcstahyK19fzlHjhBnka9TiQIWn5rcKWH
   5Qmok/YHs70F+m1Qa5L8onaP9xMjOWcMxGOXR7M7o5oEU29ZhU+tiwC3k
   4zddeuV7h1hb9XQZb9/B+xHRouBXfkbHMzU1kgS3LI3BLoAO/Hps/XX1c
   Y5iPYftLJSNrG/H9l2+viqgfvXm7A8+BVYu4af/rs3IB8tMsx4eqSoB7u
   y0/6Zg+C2dzKegy8z3TkF+TlubrNH23iSIK6uEbnM8AA4wcZJ6MCAeP3L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="354171304"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="354171304"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:56:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778999485"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="778999485"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2023 06:55:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:55:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:55:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 06:55:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 06:55:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iuncsxdu3bRzRVTAYirm2sNmNNH42Z3rkcy3ANAM4MwkiIKLhOk+J9rIvdIVBKAGoY3N5LfOdW6xwlwszbngv7DApIImIt7v4LwvcxzT+EilYoowk6N1LPzo/bVVOVGlyqtsiYBKGY2GUpLyHcdk2+VFASmhnSxPfYnpkRECPe2EcQhpKJJondFfVIQCGbKQxLvt68tmpXGnEXULKqCtG39SxhGeaHZ6njDh57XAzTVUEvXMI28E6hE0a+UUB7zYjCqGdX6vD8WTE1AEgySQ2l95ZbIz7Inc8GveRZMDBRlyp1mA8GF9sc3bEjYrHR6vxgM3f0xuYsdpGUueQ6SymA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JvrAJfeY8M7AQbnRpVnDllEhCBmvn2+8vb7/6OS+YlI=;
 b=Ns7B19neKKh41mbFGy2EZNsop6QOZ5M/dOt5bIFm3rDVBcd6YIIUZJbUe9629S6Jd36Atzt/qROiKVJ7mCIMH0SXm3WxV92djxRsBS5iEfDwmfqtMOi5yO5AnmuaGkyyxpAVVsNjIDpmsmMxH2RcCZAkyJttREGjOXSdE4TaTrAijGDK5YeEhf2KLxIJoZKnk33Ykibt3dcdieDGN4N5KUFHxEtjZjhb5FFNPVQfNxhQHDtmGmIH/BxOE7DEvyprH6ZsZaNGXS/DgQVHtacjCmxvpbx7/JKDTO7mtLG76zE1L/rQD3UcI4EW/WerG8NNShzrfk4aClpV2gXub4xL3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 13:55:55 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:55:54 +0000
Date: Tue, 6 Jun 2023 15:52:56 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
CC: Eric Dumazet <edumazet@google.com>, "David S . Miller"
	<davem@davemloft.net>, David Ahern <dsahern@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] tcp: Spelling s/curcuit/circuit/
Message-ID: <ZH86OOngOVPc4btR@lincoln>
References: <41454fc12506c2620d2dbc03e59a4ba28fd48f22.1686045877.git.geert+renesas@glider.be>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <41454fc12506c2620d2dbc03e59a4ba28fd48f22.1686045877.git.geert+renesas@glider.be>
X-ClientProxiedBy: FR0P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::16) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 18bf41e2-f276-4f9b-1cd2-08db6695bdce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4tXUjsRCxkvxgYym27Zt/8tKQzZl6S8AOr9dXDx1fDk9NwXhABbiI4Z7V4DV/Ow/qIbncCgF1j1oJSJmwiN/1YWayI+BYa8yols8RAH/f8K4LDEprOqB+Phc2H16syxewr26xq0NaxvlpYtVLqB4lKWBApZPPjyNlq9fNwDbD096UNEyTs4X3B7FpuKWIfVQcsswHgfbQ0Gxf4gNX4B78CCZ3BAcwvj6TzMHTXZPivUtVDwM8v7E9kflRrEndO8y9aA9sdqH9IaQj3jZmHOK4+1FdB13U/XO6wsdtQdV6UQLt7a/5ikJ9K6rSckAEZwBZzyL73COHqU1La0mQy4CRMK/j56JtxAXqEKsWvVsKLkTeIlliFN8bkjCpEzsjicZBm76PMvCy1/7priXPYguxheajJGYK8O5KfXTAboqeQMA43qicqyBLt/eMLF7l9RT2TJ3GUWe5Onakj+hwI5WQyN4tGoQuGbR8XDOaYOlnnbWVrkFLI6fGhINzsHyX3WvDALMDiI0blze7tH0UVwvGBDjko4mro7UfOXFRX55siWqMEcX1XFSqJ+yzt4Ckx+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(6512007)(6506007)(9686003)(26005)(83380400001)(33716001)(186003)(6486002)(82960400001)(2906002)(66946007)(66556008)(66476007)(44832011)(38100700002)(5660300002)(86362001)(8676002)(8936002)(54906003)(478600001)(41300700001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mpXPCD8diYDbEc24exq6IMMyfmvsWA1Sex7akyYQVQNudd2vVef3PAnaLIhk?=
 =?us-ascii?Q?nQZHdaHYcE60yHaMd/WmW3niHQC6UiI8yR9FIdpXxDBf1yoFXlb+vEBFRqSs?=
 =?us-ascii?Q?mU+VxEAOQ/tjjR3vAJQmA88ZNBRwIq5LIeuwxQYjKL5iY+lmEUtjA+LM0kP9?=
 =?us-ascii?Q?QuK1mew0rzmpbX9b64brf7r/MtMtwYVe6ttMB1nouzdjni4wzWWY7bl8zxsi?=
 =?us-ascii?Q?ZWdfLRd1iLGhLcjB3FdS2Grh39Cg/+q4odxNRQwD6LuVeIbh/HeiAS/Paj/2?=
 =?us-ascii?Q?HIv0Y4hqBhgOWzhLe/ET7yjWKfVm8I2h0Ri+F6LSJqutgUwCxyQjsshMHhDj?=
 =?us-ascii?Q?y7aYhei6BBPY/r18Qq5yHsl97DsiFTDkcB9uaryqy38LeVPxm3THjGgZklY1?=
 =?us-ascii?Q?OzbKNCRzLQGWqXYbusMwi68t+ON7WJwFRKln8ciyzwJq+SR/I+BAhfno4jyj?=
 =?us-ascii?Q?IijNThf8rwL5YZsFRrwGsQLLVycyG7hhbU8mmVHO7BNEyF2t5LmrqHwpKGkq?=
 =?us-ascii?Q?WDIGH9Ddjb0BhrbdnXXjiTyRwN8l9CuyxATZVD3YYo+hkkvKinMbR/gBWv6E?=
 =?us-ascii?Q?ntbfyxCYNdxVtXhMJIom+AXLKBsyCOGvuIoFRdKIRCV+OyWg1qwCVCcCDnT3?=
 =?us-ascii?Q?3IKjJ8T9Of+46BwnEa1MOAW5Evdv0SBcf/BmAWH+REadGeJPjXSlpxKph0Q+?=
 =?us-ascii?Q?KlehnMtFJQPxGmfJHCof45OP8J2Z9oKd/CpBKVI75TE1zZ/KGq8D1F9nJ2aT?=
 =?us-ascii?Q?Ze2nDvVe2TwpVbLLX+8teOf03oDIGATAv2k+PPk61wHGaUzpDFHE5rsHnMa3?=
 =?us-ascii?Q?7kcq3hPRu22oJgrvkJabJSvdmEPXiewCR4HiMli3RipZ0nl+65P6YEtpdM+/?=
 =?us-ascii?Q?AC6qpszbiIlr79olHTcjTBBPHvzq6AcYi9BpDncP5jUYZh//isuJKZf8IZGC?=
 =?us-ascii?Q?lkgglbH1v/oOKKxtqzeO8iv9ECAD+zdUxU+0/bvqID+iXy2Nf8Kzg5VPUG/b?=
 =?us-ascii?Q?EgvlZrVbmJ+YOOoZ7SCSlqDAXjq+e8N+jcN6314OUKbOWDX+xykW5QdnlcpW?=
 =?us-ascii?Q?2Fk1cKt2aRBZHt1bitkN6eeRpnIHgr3qvnzvCdJVKsyM0UPbWT7tkEoC2NDk?=
 =?us-ascii?Q?ak0Chh0G49+0N0fKSv+4JoVh8Cm3K0o+xXZ15j3zJVkab9QlDxeLQJvpefzn?=
 =?us-ascii?Q?RsOE53EmCtO/n4M7C3U7C/Pcji23kForvLKp1S/eg5GEq8yqurOnrHA/ADWU?=
 =?us-ascii?Q?likq1gK5hSUM6eYvUfd+5ThLLbho3fEIJYRExuAOc8vpab7drqDhrFLARGuQ?=
 =?us-ascii?Q?FPUOz75gMxl+/D3TpUBFgIS7Uf0b/vARmBL8zlElGcuYIl4Ze7t+tnHgWLzP?=
 =?us-ascii?Q?RGyhBAxZbb27ti48lbS4vEnX6MmU6lcN4LfA2CGsIvveHkZgPJt/Wqrc9ZMB?=
 =?us-ascii?Q?w8TUfjRzgkcNdqlVMlQGXPn/dALLvnQBdseUKMtSDJQagYhK6BDuQWMa68ka?=
 =?us-ascii?Q?AjIdE+PSWI7bdKYFvOgVk0rBHNkkr7rhE1MfSfSRwSmITGP/11EoJilM4L0v?=
 =?us-ascii?Q?jQwKbBYiQOqe941E8YCLFxaWy15iWR29/WnIYpb9tExRjVC934+mxK76H5vl?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18bf41e2-f276-4f9b-1cd2-08db6695bdce
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:55:53.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1MwwQHsenZTXA46qHUWAMPapYekcCNr0jtzrwhLqu5/ulZaHLp9uTbTP0bVUuXnxwRytd3/Hd99UgXTorbGjCcmnbVVqouJxwsTe7/x+lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:04:57PM +0200, Geert Uytterhoeven wrote:
> Fix a misspelling of "circuit".
> 

Change is fine, but you haven't specified target tree name. Please do

git format-patch --subject-prefix='PATCH RESEND net-next' -1

and send again.

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index bf8b22218dd46863..3403ed457baf781e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1131,7 +1131,7 @@ static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
>   * L|R	1		- orig is lost, retransmit is in flight.
>   * S|R  1		- orig reached receiver, retrans is still in flight.
>   * (L|S|R is logically valid, it could occur when L|R is sacked,
> - *  but it is equivalent to plain S and code short-curcuits it to S.
> + *  but it is equivalent to plain S and code short-circuits it to S.
>   *  L|S is logically invalid, it would mean -1 packet in flight 8))
>   *
>   * These 6 states form finite state machine, controlled by the following events:
> -- 
> 2.34.1
> 
> 

