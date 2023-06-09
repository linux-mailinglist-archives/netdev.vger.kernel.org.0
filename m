Return-Path: <netdev+bounces-9455-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B242D7293A4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B30861C21015
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F9379D4;
	Fri,  9 Jun 2023 08:49:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF6915C0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:49:46 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2128.outbound.protection.outlook.com [40.107.243.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF9C2715;
	Fri,  9 Jun 2023 01:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzS8eIx/xMROQ3YXInxwsoG94ovYPhq+rFDgITO6WioR0leHdWShHE0AYHXBuY4qnP6h2Wr/uzB6zqZTIa2AQ86bkoi29PKZc4SwPwgvtCJF6NkEw3m53Ghm7ik2IUzrNywvWDdpWDKzP4A+HM8xGXkeOLLKMKGov+LFTdhGLp8HW5+Z5xTJ64fhlNUIT2PPfCtMamJseVaSqC4ygnyE5c4N+/yFPBz+AP9STs59pFDosePjNPN4OYmlLwCX8jyhfdpAJlqQL+IqReqTwhofVri08N/tdwXkzrZLF72Sr3wRF+PqgbNCuyje0kRf6JLRv4BFcPApsjsDQprzwPkVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/gbUJKBmU/eLyjlcV0FpyC/MlgDkYSKDcZRx99m4N4=;
 b=Nb7WHvS63ECdfWI7bNCrewjCgd8SM07n76i/g2cczg+LlKVHuNKMg8zPKPtbsWodNsJE3jj33tMsNpyxL26KcHJeKOgn/4DpxfkW1BBuidbOQOcR99FHLm9GkN6bRkG1H9/8BYJTiEZhyXTQ1yQWpQ5N+4O0FbU23k75edvYgzKZLn0pLMiIJ8OcGUIxStccr9NkB86UIepymxi5cWq0ZVTEBg9vvEQpYhlaKxw919yrbAJmmFkPb514mondokwdg77h7OEMXQdhjYNp57T4+tI4AXtWmyVNpDscwPGI3tlebny5RSZDzo/NI80Hip2FvaWcvPi9+xdAirqrmGdiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/gbUJKBmU/eLyjlcV0FpyC/MlgDkYSKDcZRx99m4N4=;
 b=JTGid4LmvanW8NwY6Q6kQ1O9L+Vssqj3+Y6e7KyydO1WDQAOkDe5zcXA1pJL29WwoNsEsvWhChnnrJGUP4Tq5f4Adpet79pgv46SQLzBpKIVhLK8G7EKFHvkfmf9jHEiaUUpOTqlXVYqzN0+6FCj6Hq3dAffJRUzgQ7i43QC5nk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5967.namprd13.prod.outlook.com (2603:10b6:a03:43f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 08:49:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 08:49:41 +0000
Date: Fri, 9 Jun 2023 10:49:35 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: integrate pipapo into
 commit protocol
Message-ID: <ZILnn2nnIGfUwq1J@corigine.com>
References: <20230608195706.4429-1-pablo@netfilter.org>
 <20230608195706.4429-2-pablo@netfilter.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608195706.4429-2-pablo@netfilter.org>
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5967:EE_
X-MS-Office365-Filtering-Correlation-Id: e4269201-31b7-49d7-bc31-08db68c67725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1oXPFDDijy3VAVTuwMZtDIQcjiQNDY4zrLj5RrSFC1EwX029Wo934rMAYKY9PxyZJzXsvEwTPKMiCdW9XfPV7j3XQBItIpklRooOnqfMTypUPrt45VhmIuV88J21Qz+ieSs4gHxW8cIve1Ahg0IVtReilHB4S6s7gsZ//36JxmW03sHHeqg3zdGWh66eg5Tm6gQQEarH36b2kxVRYSrZVsEpMfCJzcdnMxhYSbtHJLNn+VpvRvoXtkylXrc0F4m4Bg2k4Cs6lU+kJuhaxzZbnSgZ4+wmJvq3a3Zn6MpfQIhZAvNvEmbIBKDsQ+oovLeDjSuwKg9+79ikzL+kJG5rEDH/B0f7UI89qIShbc4jFls3EwKw3+idne2VvsMBNWqW0IpjN7PHod5yZJEKBDlkfOgFpW36ecALrQ9ki6qbnILKiC0FaiSO877PIzejsr6Wd+UQEzyR9IQTg4doIEz0egPeBfiEoeglc9a0FcYQhZcIk2sm+FiaU6SsQVuK11F3oe92We3l4ZzhUEKRynQi24vuyRgm/69Z29RIdEM//i1YJ4XxyXOv58JGs03mFWx1QF4wkrknbfGvms/UXpbYU2p1KCezDT/x2jHehrYOGI0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(136003)(396003)(366004)(346002)(451199021)(186003)(86362001)(83380400001)(6486002)(316002)(38100700002)(36756003)(6506007)(6512007)(2906002)(44832011)(2616005)(5660300002)(41300700001)(6916009)(4326008)(66476007)(66556008)(66946007)(478600001)(6666004)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HwPg9v8kZCuJjPP+uPW0vy2tFtIVUOykQdTpeUKDVHT/dAXkEXOUHiDWrTUv?=
 =?us-ascii?Q?VKC1+Ud6orAmBbz9lqKRtWls1XpjBM1qFQ8KXMaCoWppF0Irh0iTs94FqG0y?=
 =?us-ascii?Q?8yrhcuJnyr1L6UhVwFoYAwrpHx2PMNrMmFJZobvWHpV6T6SmohB5EW19DKHy?=
 =?us-ascii?Q?IcjgkxB5kSyqJRcyGV7FcrjJJLTIE1wZ2gDC/tun8hQRhfbcKnH3IJGNZWtP?=
 =?us-ascii?Q?BG7MUtSTS8Eu1QkSPWM63aLNcXcqDmXCAL7Qa8JxIZUu2tBdo0UshN5EkrOZ?=
 =?us-ascii?Q?6uCib9ksgc8OsedjVdlutvLOQEhlm++HQlDSlg2BWjv/VIIsOahs4wIfs0b8?=
 =?us-ascii?Q?BTFg5mG5TUP79rArVVkRh8B7b0QMBWuERZHPjAbicT6FGZ47SgvBRRNOUjsk?=
 =?us-ascii?Q?fkzTanlnLtjSGhRTY10nwtbajgwMscw6cFvVsgBXJgbwJIgQtSw/00Tw0Bt8?=
 =?us-ascii?Q?wTEzgIBmGCz5EgjOxwU1VtDMoTX3tWJttx1NYUOQDjEHe9HGroe5PDyQUKbB?=
 =?us-ascii?Q?86kSAhVVQatsRHDBkKE81gBZ8rcgQnqyZxnnJviNuWIq+TAIp5JQw1+iovo+?=
 =?us-ascii?Q?PZQie7asRNLC0FJFKux66y5v0zzJcjSYB9o/oe9yVugMl5WP7w8g+hZ1Fk9s?=
 =?us-ascii?Q?mZms/uM5aUo03qDQHq9YgYAp9RVNgu/MZZYHMgmP14wxTDr5rzQqfaYxEsL0?=
 =?us-ascii?Q?YEw+T4UYzIbGMfkII5yjS5wGYcDx8zDKDSPQJHvl7urqEG7D7YNvQ0AYBxrm?=
 =?us-ascii?Q?ncX1V9QJb8E6VfLE+bW/bU/UuOoXBv1dAJWLuOpHDag9Jp82RUEKqOVM/ukz?=
 =?us-ascii?Q?W9uJvfq8+Q588ph2wsqlYrlv8d+5/SmudNVP8VPNfdz5jx5VNXBb4PGsJ5yt?=
 =?us-ascii?Q?cYUf2HtTzpqfe1wP9iqiZPPUhSaA73swSlMWq7Wd0ogpGLEPrTO0Xtlp2PKH?=
 =?us-ascii?Q?uPJzHbn/xR9I2TjfjR9dVBcbAoybjH3AHCl62X2Cm/TngeCyFzmHshOdD4xb?=
 =?us-ascii?Q?RqFgpDU3hzKL46Z+3K5O93X9iXQfUczSkSwhksWuaiTHEcSulOjCxxHxNeLM?=
 =?us-ascii?Q?eGmzhYc1CRWWIyx6hspWc1VB6EkHDFJCJ2rreKSXnsWfrideyqvhOfg2yvOf?=
 =?us-ascii?Q?tWOSIeuqKQ7IWFRxKrdRHtiQ9rB2k786PjmxG+QtxNyCrrxacOHBth+t7sEL?=
 =?us-ascii?Q?IoHC4CaaMxVruC3E+X2CuCSt7fqjWFAKjbuirHGidjfjUndQj/l/ovJcwYLv?=
 =?us-ascii?Q?FvAMuFzvl8KHQj2raNYh42eciTf9zJzLP7sKbEROQH8REbBBcjROIjjqPHST?=
 =?us-ascii?Q?Kp2BcA+wWk70FUhhtLGLdA8mlgQ3cS3Wyowqbxg4TItDXHGHGhX728KFgCRw?=
 =?us-ascii?Q?B6oczq6WmGx3AFRtVjwubrcNV3pbok4pgoiT755ZPScqmF0TvFLGtZSWS9el?=
 =?us-ascii?Q?zeOlJiH70xHCVK1YSsuiqiBfG+okYkbPy3YTRB2rX6y/UFdxzjVbAAJO3Axd?=
 =?us-ascii?Q?eCrPJWknzVkkVuGtGF6Ga/cLtsPRvb0uoOsKZRsgMvDBdRxLKQs7LUqGhGYH?=
 =?us-ascii?Q?jFPVjjG2OKlVVCE1i+W/xE4mph0mBFK3MSpNypb2KKcypkN7xyEuGx4rzFY6?=
 =?us-ascii?Q?4mZOTCPB+7Grxab/7SfpuHRFn1wZDZfSKcmW57EUsAkyZzVO0H2A2tqCBc0d?=
 =?us-ascii?Q?l9eRCA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4269201-31b7-49d7-bc31-08db68c67725
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 08:49:41.6171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5P/sY43C5VII+vwf/8BcRbEb6JYDRZ7ekw2KEHQsV72reu5/Fo4Zzs8au52xjNb04KorqAtBEc8FxsDACrc2ZJqfPpBYfxK/xEOecZ7yQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5967
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 09:57:04PM +0200, Pablo Neira Ayuso wrote:
> The pipapo set backend follows copy-on-update approach, maintaining one
> clone of the existing datastructure that is being updated. The clone
> and current datastructures are swapped via rcu from the commit step.
> 
> The existing integration with the commit protocol is flawed because
> there is no operation to clean up the clone if the transaction is
> aborted. Moreover, the datastructure swap happens on set element
> activation.
> 
> This patch adds two new operations for sets: commit and abort, these new
> operations are invoked from the commit and abort steps, after the
> transactions have been digested, and it updates the pipapo set backend
> to use it.
> 
> This patch adds a new ->pending_update field to sets to maintain a list
> of sets that require this new commit and abort operations.
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Pablo,

some suggestions of some trivial follow-up items from my side.
No need for these to hold up progress of the patchset.

> ---
>  include/net/netfilter/nf_tables.h |  4 ++-
>  net/netfilter/nf_tables_api.c     | 56 +++++++++++++++++++++++++++++++
>  net/netfilter/nft_set_pipapo.c    | 55 +++++++++++++++++++++---------
>  3 files changed, 99 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 2e24ea1d744c..83db182decc8 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -462,7 +462,8 @@ struct nft_set_ops {
>  					       const struct nft_set *set,
>  					       const struct nft_set_elem *elem,
>  					       unsigned int flags);
> -
> +	void				(*commit)(const struct nft_set *set);
> +	void				(*abort)(const struct nft_set *set);

As a follow-up, these could be added to the kdoc for nft_set_ops.

>  	u64				(*privsize)(const struct nlattr * const nla[],
>  						    const struct nft_set_desc *desc);
>  	bool				(*estimate)(const struct nft_set_desc *desc,
> @@ -557,6 +558,7 @@ struct nft_set {
>  	u16				policy;
>  	u16				udlen;
>  	unsigned char			*udata;
> +	struct list_head		pending_update;

Likewise, as a follow-up, pending_update could be added to the kdoc for
nft_set.

>  	/* runtime data below here */
>  	const struct nft_set_ops	*ops ____cacheline_aligned;
>  	u16				flags:14,

...

