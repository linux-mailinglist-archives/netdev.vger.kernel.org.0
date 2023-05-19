Return-Path: <netdev+bounces-3900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AA97097F4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FF331C2128D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E59B8F4D;
	Fri, 19 May 2023 13:07:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D07C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:07:17 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2099.outbound.protection.outlook.com [40.107.223.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2F4B6;
	Fri, 19 May 2023 06:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ietTplp9fUiQc+U6M91IgHrxwutiJririuOyOlwEA3onslBfEdddGFkSh5EgCasomwJ4JyNIF3p6pDfFUK16CvBI3B7NZtVVJf5DSaEdSYh3Kn84ONOVOhuV3e1fxdX3RFvRQ5Kzv6ygDPVtvwosnkOiao9mR30z+gVr7YeSk82p7upxPRV8cqhlWw5qcBbPd3ZJfyf93DzeXVp1Uh/ZSfc7mS5GxTmletlrL33wdkB4jQOF2lYhCa5evwgpXJor6ZnD4i+ephc81hOZwFY9KvH1UytNXalvEdz8BoYBQwcnhxtQDnQn4xzers08hGmP23EizjaO6AoNsM7KrsnOZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdqvshBNK4APYtynyhlTTOarGvjR+E1t1Hh3aWUW+JQ=;
 b=oGKtD8eQNa1ITED6o7p/d90bCm/3ZHVsm8eR1vjL+3fQiFvwvTruIkBReGgkA+VV9/gWUH/XNfR2FngqX4gQAyzMrh+jGRjwstSU3HLB+UF4jaVKKXMdg6ZqWgJ1xwM0VjSCMmfzVbuqTKyhOVv/Z5jtC67/qEMivxLi+H7KJmNtGGjkZl2IeSdKyegVmTytreKbFCJxAFvdIKWuQTOCOMfSJ9P8FgMQZmj3C3c94kg3CTOrVaZdA9dN7uawIfIF+wrBk9YAvmXE3lxdeDA1KWUJS7zOa4nOVsCwf3SASM8rfrhGD4SjN6Lrg0uGP/T4SICXmVnzxx89aN1VnCrVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdqvshBNK4APYtynyhlTTOarGvjR+E1t1Hh3aWUW+JQ=;
 b=Z5Ci5eZBiB4X1Tr2VNnOfFxyT5JtAjmy60X+IkC0wQY/54USDTZ01e0nNWmLtyyJK230ZSl/UBAtsbJpKen86xwIHRQhD8HigtNK5YNJWzGrfrc+Jxfm1wptgxTO8+ZoY3elzPSQ7XlRLo7dsHhpCt7mLbBf9Oh8PpkFkSRBmeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5675.namprd13.prod.outlook.com (2603:10b6:a03:402::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Fri, 19 May
 2023 13:07:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:07:10 +0000
Date: Fri, 19 May 2023 15:06:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Martin Wetterwald <martin@wetterwald.eu>,
	Arnd Bergmann <arnd@arndb.de>, XueBing Chen <chenxuebing@jari.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Saravana Kannan <saravanak@google.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] net: ipconfig: move ic_nameservers_fallback
 into #ifdef block
Message-ID: <ZGd0YMg1y5wx4bRX@corigine.com>
References: <20230519093250.4011881-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519093250.4011881-1-arnd@kernel.org>
X-ClientProxiedBy: AM0PR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: da9c0bfe-6f60-4a64-225d-08db5869f48f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ioDlZW4zKgAePwT0pRFMyNzeXG+UjMsJhCDyhZtG1/s5rQAspCfvmDVEdcmio1LgCqiG6m7GmSRmRlYhrzGd6o61VYoV+xFvqw1Ciki4kIsyqhTW/FDpNMIof70wz8cXqcIUEHbl9iZmEOhqPztSzFXULSk65Av75sZrRjWuFevH36datORK54ZNCbnQR+5IP0gUMhEIXo5rximzh37qMC+ryNwXLS60RePA+cI4v7Y60BoUWwdo1n7e1XZieIM4NxJC8mXBQ2KTHeAOioWZ6d/uJZeBZa47DcDyKKqcTm4AT9tf52SFLy9GSn8byt4FzhAGk8wmhiBAJ6XqRbSoproWATvbNqkz8p3T5x2da6b0U3Ty/6ag9YkdwQELs+Ct0O/V2IFP7TMDRGmOff3OghHl+RUxGdeDRfPYQq0vgAaQRdqO4kpWAUP/jnUwso9kuNK895zQebrsP3OaMpkkaETBui+++OcmKFjf64erxN6+OKbANHHafj8v0DSiWS56SpdE0JlZG+zRIsdq0cR0w8Wux7yVmm2vtVS/QxERoIb/Ansajp81g4wEFXZgRWC4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(396003)(136003)(346002)(451199021)(2616005)(186003)(41300700001)(38100700002)(6666004)(6486002)(83380400001)(6512007)(6506007)(478600001)(54906003)(44832011)(66476007)(6916009)(66556008)(4326008)(316002)(66946007)(7416002)(5660300002)(8936002)(86362001)(8676002)(2906002)(36756003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xHeuXPF+noTJVUh6liuv70e+s+AeGDhEoKiLcMs+Joq2iFrLl+Q7Ef7Q/aPf?=
 =?us-ascii?Q?2HudV5Yl/2sl6nrkW9cRZ/Bwj3a0hVVFN5LkLio+JKKz5QV/jpK+4W5PF9w1?=
 =?us-ascii?Q?I8o8SxYdSpkXlaS4kSMFpwBeDLEsxj6a4Mwn+eqmJHeoufF1ueVMde1QsTIH?=
 =?us-ascii?Q?dCMaawbr/JLKvBPVdZ07mRv4SARUKOGUHBkDaG2aHYpgUQ28sSUUslmVEbI+?=
 =?us-ascii?Q?ZdeD3mj6VQZ+vjd9Di7cdFtySQPAtMoxhQ9U9D+DEwMOA92l2yyvoCEN2Uiu?=
 =?us-ascii?Q?I/jamoOPfI1pITlo3/fs8cRChuXmFIQ/VwLR1wwLLy+rJdSAhrd8nw5G9Rab?=
 =?us-ascii?Q?VsEUQVx9kFD5FMdn8pQUiS21LhXXBngVMhYr4vYzRELpGExcFHH3kDfB4u5w?=
 =?us-ascii?Q?QHJ3CMTFe7dEoC0hP20HTncPXcUyZiFM6R1W91WEVhUH3y0qYbZNBF4GE5Oa?=
 =?us-ascii?Q?quBEsFue1+ThI8+Bc9fhdHc74gAPm59st+xwMHs5Hv4pF5ZQth9r+O75ZG6R?=
 =?us-ascii?Q?yXnLoN3P/gGwU8QtNd6t2f6alUgmoBoP5XNNlhVK43H+tUvEe+k69I9WOnhn?=
 =?us-ascii?Q?u6LReB0ym57v55qilyDhR3l4xKitapE7bBmK4TmQVGyjIJSAQ0djJgrxGIh5?=
 =?us-ascii?Q?6728KeV7LkspkJHAGjzSfX/KSqS/iKPGob/rDb14YqU19CJWpnFMPzT6nYSP?=
 =?us-ascii?Q?cVAa1QCsQ5kvZrnYb6DM/COyQiQYI0lG5mZndglGHzso9RU4tzOppEmu7Yg/?=
 =?us-ascii?Q?DbzQlKAY9EIr4SdzkJLaSyovkEjASbzxZaQTs6hYrNpYoux8268bvzyaXjn1?=
 =?us-ascii?Q?9Bnyurk9iLCYP/5SHxPYkd4D0Zm/fcpIcbV9Os/TLRZzmbZVwXnji1Dt71BL?=
 =?us-ascii?Q?jfzp65cXTihpGRci1vCtC6p1riM+6cwxE9xI1OYO3Bp4gFUihb50Ts16hxJW?=
 =?us-ascii?Q?LQc0a9ZgZAdWfnOHIQArSxERx/4XRpJ+3591y2bj873lHrKeAueiiWVaFs81?=
 =?us-ascii?Q?SnRcFdoMxsxJQy8kTBB37YJNK1EOEDGM7JEE89ekhQktc1FyfLeAaNXulois?=
 =?us-ascii?Q?izUHgMt6zzs7u+Il1K1y6+9kSaXTNA2i5++JvnR+6TZ5zcEDhTu9EiXmtT6T?=
 =?us-ascii?Q?vf/737hnFBIhmGfiKMxx1QimgVIH9JXeOr1Gkas7RjJWAlulEKIs1y2fQUtl?=
 =?us-ascii?Q?lud4aO50s1LVlMsIdyL1uyvNay1DyIhXKOEjCi6GoOntExRTOTTaFNwUQ8v6?=
 =?us-ascii?Q?DEZ/saF0zlDxwBIA0l+f5zik9sQsY6jGb4ks5b/i5lTQSF/PMxD4cdlkC5qW?=
 =?us-ascii?Q?sXVo2qp83l3guYEeW1/0JFpCtxRmjE3b/G/zx0i7REGyoCerjD0MgV+KzwN3?=
 =?us-ascii?Q?eVwcj2aEcHlWHJZlFoCLBEvBqiV5VCzf0R80Y9aKySBBY1v+9mVISTBtAknB?=
 =?us-ascii?Q?Bm6r7MidUVp8+duz/JMfTDEEdanWWyYec2MoO8yvCOzXJ+apgOUScFEP1DGg?=
 =?us-ascii?Q?Hoe/wJwFzQcndR9SC79dglRs+OLzcw8ikG2lJ3U2rUo4XYOyGfFJdCz+NRBD?=
 =?us-ascii?Q?A5X4LZseED+wnW7+HRrA+gYwBLoKXRcAxQSkYk93Fb96MWiUyHvl6z9ec1NA?=
 =?us-ascii?Q?Sv5f77XSrsoeh13fq0g3cyiLmkF1Qn5czvQ6salKPU6LJz/Bl7vyBdvMG/8O?=
 =?us-ascii?Q?zoeSHQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9c0bfe-6f60-4a64-225d-08db5869f48f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:07:10.2807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uIe5urcHxFLV+G9meQcK/C9WYm5EqU/xB734/iHLHb4mTqy7O5CGSVdvznLyumcBdneMOSTobEb57zPwjrteNBDxmTYLd9rbyrFaJ8vdbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 11:32:38AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new variable is only used when IPCONFIG_BOOTP is defined and otherwise
> causes a warning:
> 
> net/ipv4/ipconfig.c:177:12: error: 'ic_nameservers_fallback' defined but not used [-Werror=unused-variable]
> 
> Move it next to the user.
> 
> Fixes: 81ac2722fa19 ("net: ipconfig: Allow DNS to be overwritten by DHCPACK")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd,

I was able to observe this too.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


