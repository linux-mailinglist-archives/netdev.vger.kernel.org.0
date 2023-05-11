Return-Path: <netdev+bounces-1755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB426FF10D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA8BB28170D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B94619BD7;
	Thu, 11 May 2023 12:06:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8392F2102
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:06:56 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::71d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA0E5D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:06:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik5lVn6yZltO9SqPUxw2xI+S2zJt2RGSha8dbojtPRVgdQAIAmUfzBbPzsF1scqQ5jAr5kZPd5v9SuX07s/6AjWNqVC5tanVv2fNwDYBCxszLUreI0AWuZt+kAQo7i20GE2dU/XgLNk7j95kzMrbi9IEjQZaQxbdLhMCW7IJTZrlW93aYHgQ5Vj2FuD73ryzBe8Q3zIqNtkZLa97kvjra15Ir+aE2H2+2ilKDkA6j41qveH6InH87MHctnrMIg1aOXV6qgTqnkdgxyYoXbZBDic+denTSC3ArS/5E5HiR9y0DftitPbHK386iVC/XHiKnsMDsmVhWMv/VqfZ8K8x/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ouFpSTaEkKrL5ZfRHhAW8TQF6G7QHeciTE0qLGe+jA=;
 b=hUEeJqgM4XwXGEKARgCIahCr58x1XI3W97+mdTB7NW9iutqwSOgmjua2WsqZdYbWRRfv8AX+D27k6VeXkM7F14ul4BthJmZEdBt/NQNCMCX3ZOvCgFEg9k0b16wj6Mht2wk3n3XJq45Xn9Ja+k6w7qSm53NRMpYtoUOAYVRNJMMtjMZ1YPoOCl2H6TFm9e09iI2IOtIekMOckeOYx9K5mVIitXFrPTGuQVnpGR1rgLeff0vLrW0hnb//VZRzppxfYa206rA+TesfA+Yqo1+lU4UViv9NGjRFWiLSRfiwaOlCYr+UENZ7AfjXYOwwZKEZSmO1Rvn6dfMb/xk2qZfVtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ouFpSTaEkKrL5ZfRHhAW8TQF6G7QHeciTE0qLGe+jA=;
 b=sSKK6kDbkbYAadbTTq1tQklgRQtZjhT2mSq3xHX4oNSAgbREe+pRapm6Q8q4Ixu3Wq0bXCJruzgLZRUjoCPMBEXBSzmEUREGnenLJA4dks5AQCPxuIpbaZjmgd+yz3JfXmZiZL1Bj+lKGdEhIavQYTVT+3mAMPN8HK8njgkn1WA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3698.namprd13.prod.outlook.com (2603:10b6:a03:226::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:06:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:06:48 +0000
Date: Thu, 11 May 2023 14:06:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
	pabeni@redhat.com, kuba@kernel.org
Subject: Re: [PATCH net] MAINTAINERS: sctp: move Neil to CREDITS
Message-ID: <ZFzaUqELRSdXOSdG@corigine.com>
References: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
X-ClientProxiedBy: AS4PR09CA0015.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3698:EE_
X-MS-Office365-Filtering-Correlation-Id: 59c4da9f-26f4-440e-26c5-08db52183212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nZKx0FwVIBboja9r/H89XwZ8l97No3YTUqtIQ6FktO45LFrS03R/toq7esM11vIHUKtCDZscVM+xaPk4oB6mAWPTXpw7dWw26vaex53PdWVmcNnyTR3DbLidGqf1TNCcpmI9EFybAIz1XTQYJ4TKdZ65e+reInmuPlifWfzHLlh703F2xm7ZNHmChyFhoFOvjSCNIEzGQat9SQHBirKJ/1r9lp12hyA9r/eXXcaO7K+Zx5TCE5xxnTJc4/9WFGxvlWum4KoJFpftcdLxjLHADmt/binvDBb0OrgVawcQr7Eqhy+HaK6sy0SmomdYPC6uTyBzrtYvkBxbyMgLprGDfIMnM3Uh0dnABsN5aIbnoTLhLkmqQBaZs/ex+Y7km2iJu5cbD3VfngYfZnvZb2VAbfYkZg631MupMtdIRlekucOa9OhoksGqjQRNXgTCORO62Anj8mgckNTTMVRBUVQ9z86v/zmRrYSJ8ja4Pw8QGD062WShVip3I6/FKLPHAqyzim+jZSE3GQEvDA4hYnzpU9q+NNd+OYKHn2RpLTQr/Xg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(376002)(396003)(366004)(346002)(451199021)(54906003)(478600001)(966005)(4326008)(86362001)(6666004)(6486002)(6916009)(66556008)(66946007)(66476007)(316002)(83380400001)(36756003)(2616005)(8676002)(41300700001)(38100700002)(8936002)(44832011)(6506007)(186003)(2906002)(6512007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+xkcWTh1qMaAR9pInSjnACit1/YWAKiiVYZbhytNac8SJMcz/V9qNA87Y2q3?=
 =?us-ascii?Q?BJchKTDmaLqkwUzyhV/yu7YPko1KMeRK6wSmeBFwZY7ou3a10T4MYav11+E4?=
 =?us-ascii?Q?CFP8hNfwETm8jUQqBiZo/0Xs02WjLc+q0Vl1Lq8i6rTYi0uWpsbt3+HwZujV?=
 =?us-ascii?Q?d3GS+wd1WY0n7a5ua16i9AFbsIE8zR+D3csW89doMoEb/iRPA/caEgOlYJEs?=
 =?us-ascii?Q?RoU4SsGlWtfNXQ0Az+HmVpMtuOd8yLLyCj9ciYyTNVcFkY1sPKelDjH1zPfP?=
 =?us-ascii?Q?mhZK8TozveqcbRRjDDLtnP05KYxrVzUQXAHPFB9op+KtUOToC1xgaSgo915z?=
 =?us-ascii?Q?kDeZS+7o5VOE+SVA7IgHcZQlqsvL58j+lTKl9k3NaHhalu6BcNm85Z5fguqB?=
 =?us-ascii?Q?P+8NLcakCPQiS8uU7dB95sY4ts1dpF1B5Aoy/1e6yEpBpv9cJMDKCz1yINBr?=
 =?us-ascii?Q?skIBFU0bcevLXk/cuAZKAGcaHmRUqaA7rXgWAuzd1TQo0VajOPAsPsfQSIEO?=
 =?us-ascii?Q?+BB9ZaKMLg344UWJtGlGKJtvtvZFfICsZGw2BK3WEU6LcGZBXFyO7QstfTtv?=
 =?us-ascii?Q?c0aJ3/wn+yk7+uB8OreyzTvOD4S0s55So/Gfiu+JOtA3BeutYTF9wRTKGoXb?=
 =?us-ascii?Q?bu/8rid7yxkSMw6RXM5A88ufHqSuxXL3q97X0z3GYoBipgNRCje4ZkLmpjry?=
 =?us-ascii?Q?uYBz/CiXJ2nmfzFESZR7IPazTwmosIz2eooAIASU5kHi3NNN6qD5NU4Sc2G0?=
 =?us-ascii?Q?Npsw5MUNktWGrfShkxKtmmgNZrOcyYfKvyEggfsOLgBmZmXx1qZ/7X9Xnp/U?=
 =?us-ascii?Q?bGWbln7zx/02fKqsM2IlsZC8HnP0xH3GY75ARAFgTagCFTu1fuPRnVoEFsR2?=
 =?us-ascii?Q?iKEmNQBNayh/gC5SPTFe6vsYaOFY/unWAf8zEOCqQlG5XkPY6soQdUiYHWQZ?=
 =?us-ascii?Q?ZwbmQ8NP2DhLOuQRaYhRYAEOxcI9FCXVqlusO5QuwIeX+Afd1Vsz2wdHeox+?=
 =?us-ascii?Q?GU5w+NMGtRlhrv5X700AmD9brnEO7oAYjN05KI/25BkvICWhWUb6J+lBKSbC?=
 =?us-ascii?Q?sBUzmAYYfZwJTcMIvuR7tVi0rLudhnsvXGWe8MCxmzpHZ+akjJsshlvxxHiQ?=
 =?us-ascii?Q?Jw2+mleXMeTsKl88Qxlh89yauUW5/Ecd3ddfQg2DqywPLDrseLKkxnsPgMyq?=
 =?us-ascii?Q?0nU0jv9GupzjLE4Z/KN5puCU4ZbTImFohjxjvnQK7BWVEFllxpfnDCDDkSnR?=
 =?us-ascii?Q?GKo7cwgrEIdAdVLQYYuyn7yL+WIlFOJldzSfX+UXPS8PLvbwT2ZmzG2nW8f9?=
 =?us-ascii?Q?dz7rvM0EXgIAwgduYR3Xe2gMuXW21iVNxFGzi8YXhzkNn+vLhaMSy3v/HSPh?=
 =?us-ascii?Q?AJzV1QHhMLslIwmFGtLjaggbjdax531JKjryvUPp+XysA0x3i1EF7gQ4SM54?=
 =?us-ascii?Q?ze9nib+AgTlLNpxR6IxVowqHUCbdwmXBuj9lTGZ0SuyPM/cPdogcm1Nn/dH1?=
 =?us-ascii?Q?w0ThjlciOGQZ8Ot92hKoNVXJlFHjINzoSF9/Qk7WCNmXlTYyKcVPlJE2gr2b?=
 =?us-ascii?Q?8eTHMYNMrsmlFzWmP6ncTu3l1lMJs9Pf6WgYBcun0thqSAvBd9XWjcbBHEjH?=
 =?us-ascii?Q?bhI/Tp3VPAmM7j+BP91id9m7Htz6JgDfNqR2KRjfeROFaaxxb6Zq9Tt3onnp?=
 =?us-ascii?Q?X28S/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c4da9f-26f4-440e-26c5-08db52183212
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:06:48.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1WtAaNsYG2Dk+h5kVzdhxovxNqB4jI8cRpF//BoXX8oSYsYJsni0tnVDbAyN3/YzjaRO2LCrd0bkszMQv2AeHUqaO/XhDx59Eq5hihLVmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3698
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 07:42:43PM -0300, Marcelo Ricardo Leitner wrote:
> Neil moved away from SCTP related duties.
> Move him to CREDITS then and while at it, update SCTP
> project website.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> I'm not sure about other subsystems, but he hasn't been answering for a
> while.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

(No relation to Niel)

> 
>  CREDITS     | 4 ++++
>  MAINTAINERS | 3 +--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/CREDITS b/CREDITS
> index 2d9da9a7defa666cbfcd2aab7fcca821f2027066..de7e4dbbc5991194ce9bcaeb94a368e79d79832a 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1706,6 +1706,10 @@ S: Panoramastrasse 18
>  S: D-69126 Heidelberg
>  S: Germany
>  
> +N: Neil Horman
> +M: nhorman@tuxdriver.com
> +D: SCTP protocol maintainer.
> +
>  N: Simon Horman
>  M: horms@verge.net.au
>  D: Renesas ARM/ARM64 SoC maintainer
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e0b87d5aa2e571d8a54ea4df45fc27897afeff5..2237dc2bb94585d8615a496e1a55fdf8755c83b8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18835,12 +18835,11 @@ F:	drivers/target/
>  F:	include/target/
>  
>  SCTP PROTOCOL
> -M:	Neil Horman <nhorman@tuxdriver.com>
>  M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>  M:	Xin Long <lucien.xin@gmail.com>
>  L:	linux-sctp@vger.kernel.org
>  S:	Maintained
> -W:	http://lksctp.sourceforge.net
> +W:	https://github.com/sctp/lksctp-tools/wiki
>  F:	Documentation/networking/sctp.rst
>  F:	include/linux/sctp.h
>  F:	include/net/sctp/
> -- 
> 2.40.1
> 
> 

