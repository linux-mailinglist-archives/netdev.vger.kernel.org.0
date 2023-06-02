Return-Path: <netdev+bounces-7464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 603E972066E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0987A281902
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8841B8F6;
	Fri,  2 Jun 2023 15:42:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABA719BDD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:42:30 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2111.outbound.protection.outlook.com [40.107.100.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDA718D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8k6YpYiNrhSn2i/fAlyETJK1WUKVvcko9PfR5Rg30z/n4wSEmO0oYGUJBHWvNsZ+RclEuzS9UX6xFNtyvVEwA+GUPQqsi45QO4b1yHLO9BsfLD98qOOx8thk/OafylzKcgaC7QKTAxsCVe8GmPj7HMK04XPEe1MKQH4bkwTmyPUQ+yD8ibbZ+cqLI5BeUz5b0fEGPlAdO1338eEGkC69PU7nhO9IWLwvguW8duGRgvGrG0a3UPmXs6Mcsmw+47H8YZXFyfPDVhKtx690FCBiVUzLJcLPtf1G8/YyfVwtavQ35dEbTRoCfiSXMFXyXqHkyNx5FVs01t8OpNWJRRZBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfQTP6pU3xtbqdz2ns4YTmSim7S0NgEpn7WCfI4OJI4=;
 b=AqMYJkbRgPTYCnzyScodglPKf6k62bcMEPpNR5Mr/T3p3pDlb8zpWdb74KRLO/uzCp28jzrckH6nmH/7kb1gXGqJVeEXnZFJdNmg+SDI4t4PPpPkyuqtNOiIbhuXTcxPagvsQsjcCCXG+utA5eMJBdGTMYyZtXQmCM9keeRGWrQ0y4CfyeZkRBI6Wl8XFJ7Bjeprz+GfCFrd0v4qK3jjj1zvr4JOt3cMHZxcK5p0wGraYdB2nf9Tdf9XZc9SDTJBvR/PBf/kwgMFypikTS5bW+clOSkCv+VYIRdlCyCR/Mz3FcUQatq6EJ+qH4K48Yp+PuIvER3Xryb8obRkR7AEZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfQTP6pU3xtbqdz2ns4YTmSim7S0NgEpn7WCfI4OJI4=;
 b=Eeui8YIK3f+nF6vDVm3h5KLRYrONFOsxKnsFx27w54e7YAzf1bRswXlyHukLkz3+cBp7KtyGHtShoZFvUPKqMe1ALk8aluoDHS0tB03wcrLZKHsm4SLNAHzzQLsVQJvrbl98CwV06ZoeC2JXd2fx56LRlQ9HSRNijMj+frKUsHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4049.namprd13.prod.outlook.com (2603:10b6:5:2a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 15:42:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 15:42:25 +0000
Date: Fri, 2 Jun 2023 17:42:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	sridhar.samudrala@intel.com
Subject: Re: [net-next/RFC PATCH v1 2/4] net: Add support for associating
 napi with queue[s]
Message-ID: <ZHoN2ci/QbBIT7qj@corigine.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
 <168564135094.7284.9691772825401908320.stgit@anambiarhost.jf.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168564135094.7284.9691772825401908320.stgit@anambiarhost.jf.intel.com>
X-ClientProxiedBy: AS4P192CA0044.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f36a88e-8c18-4fc6-1015-08db637ff66e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nAjy6q3e7BGTimekZUgoclitEK/Qn+lDLhRXY4hjNViUhywKMPZKzmSlxRYNxMbzj8+xd6kmn+AhO/LO7gzNuOD5VY2DSFxKw2rZucveCoY+O9T8Dsvp9fqzDNhCLILRz0nQpzEk4dvy76+d1d+xAlxGxUDWl5+skt60mvwLXHo9+9rwZTIyEkFCez7HBqLd47xUwkcWnDjy92gaE3QFQxokakCeLOpANVKpo1p0tee7q1qsQ3eFvGMLMlyTiun5cqybcDrdaHfE6mCTBZ4eSz1dZhrqgatlQonPB/pFmzQau7OLT3QW15rtyBB1i6O2jig1kHxv8NagaOAUwYlcBTFSWBAUsimuufAmT6a3n7V7Z5yK0V4YDCt8mu/+Oq8BmmUjG+vdA1mT3DqEQnGEOYMEnc4/s1rfYWCAstmDYHh4Ebc4j7040g2hlMZvY8rlXo5EjOxYjvi4CO8ZaNH5IbOAzThtX9Ji5stapWFAQsR8WXqfiEtEJiXUqhr1R0HvEUQ/9bF3T8+wL9305RemHskw6yhZGoA6kncNGIguuudMLvCRRQsZd/NDZDsJgZ+Y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(396003)(136003)(366004)(346002)(451199021)(6506007)(6512007)(86362001)(186003)(66946007)(66556008)(66476007)(6916009)(4326008)(2616005)(5660300002)(8936002)(8676002)(478600001)(2906002)(6486002)(38100700002)(44832011)(316002)(26005)(6666004)(41300700001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KH96rPjmBvIZSFPhZ/T/IyqlGNfVEOCVseNcvgfnL7lvEpUtg9Lt6Jj1bXyC?=
 =?us-ascii?Q?LZgQHoUoulOQ553PieXAYGXm41J8JibMiI3uPzSbclEz21BCIg7ILQyvpxzn?=
 =?us-ascii?Q?SjPg3dWsOFuOmRT3O6GAP3DxAawlizgBpOSULzaSxq8WcoH9nouwFXVW3Kc9?=
 =?us-ascii?Q?Hk+UCHkC9ssYXLPjOr2hYXxzAVrxn9OQjy9K0d2PkswQPUoI8Y6NtupTkrUZ?=
 =?us-ascii?Q?vLKSrhZZY+4RshmKg+sIS9fdb/9Zk0Be4JtAv+ZzxPmwQxUDw6ZJDOaTpXkw?=
 =?us-ascii?Q?iAIHmhjPS0yvX1xbeckc+rKwqaNega1p33vrOJLL/hOrq26DYTjY2djEorcA?=
 =?us-ascii?Q?VM/MOzDzQvMU7zJ4yHP2PO0FSXJ1GB38fE2wlE3DEsYc6+TztbFT0Y5kC7S0?=
 =?us-ascii?Q?mHrUAk+Tr968BA3YgPNAbeId966MDDgSi/ki5FlBNpmC92diRj6N2z+m2vCP?=
 =?us-ascii?Q?yq7W9byUlwEebZJ2RkDA/wNbh+cwcRshKV2DRlkJgyhAiXN6p6nLSgr9/8KK?=
 =?us-ascii?Q?tJAJq170200fe9POB+sUnqKSzbxmPl+vs1kHbuU3HxR2xePVuv1skpqAyn4Q?=
 =?us-ascii?Q?dNXAMh7IIINmBaUhDwQRrW+CKeOp6TPfVMYnWYcq+HosjOvtAlsupptWmetE?=
 =?us-ascii?Q?C7ZmQnRzLGNC2OSIrdVUzK/LGVWvqAuKeGXxsvN+Wr1NHDnyg6722Q1sXyy3?=
 =?us-ascii?Q?A5sASL42MbKhsWAx/HnFfDFnaxDMS+8WlFPn99+y/awjKr8MaPnRtZgqNj5I?=
 =?us-ascii?Q?ozVsNZTkpngPG5RWTcSlbhS1sZhTKUl0fwVHIH3MjqzFfcV6hv07CU7lLq6S?=
 =?us-ascii?Q?ccFQ/xHBHjcZRPCts173iceCAkgCZlznAUxgKH1eqiVitXX7ObAlt5gzowua?=
 =?us-ascii?Q?fjzpv9ctr+dV47gfHlmrtxMeAspQk9tRN49HbF7aOYMPYKIQYtJRjg0ZqGH7?=
 =?us-ascii?Q?fPMn7rJrMLN2TjPNDmtPhQoj6dyzMTseFCVZjL8iSW5RnyS2T+euwfWHIEce?=
 =?us-ascii?Q?+SmTpQck1f0fed5uz6D/QCwT3Xz8Bo9VhhngKfvgmUZYbcPZJu/YK58BP7BY?=
 =?us-ascii?Q?U4sgIoxfHVih9fDMFa1LMRaRkp2fObp05nMTfmkBZRbHz/XC/R6cVuBLxdcK?=
 =?us-ascii?Q?q6s0bts1EcEB8BW3yQ2e3RO04mLRVoS2rnZpwy9zQRlM229z0K/4BGYl2Ed0?=
 =?us-ascii?Q?iAfDHwfiQlXqAa5j9XN9qHN6g5Lyy9UE3dFpHw0ZgI/22cQXOJ8lc54X/7BQ?=
 =?us-ascii?Q?vjCt1Q/WhXDizKT5Rs+bAu3CjuDjlsXNP6CvIwjKT3ZlLrlKCz4Nr6Um6TU0?=
 =?us-ascii?Q?3eZgqsa0DOA9iafGsCXffNZeZXBwG4h7h6tU+P7kHQJ6nIM8RyfpCUIMlMfz?=
 =?us-ascii?Q?MBtmI2jVLiR1vzc1heDppn8CFMOAt+W4Q451WavS7fVytNPe7qkZMt2syosy?=
 =?us-ascii?Q?uqkE/L+eFqgHKEzedZaaEGe78oVOBdLCIVES522AdYXstV5N/ITlAwY1lpgQ?=
 =?us-ascii?Q?1ToYnWU8odoQyiqISpvUlRlzSiJkkiAr/ar+O51eftA/pnVOdQdnw/bbO26q?=
 =?us-ascii?Q?eMH6wD4T2GnaQx6Xrz5BGkMj3JEfIYsdOBpAbPQH37QlRkyV4x+pnGPnW5zY?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f36a88e-8c18-4fc6-1015-08db637ff66e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 15:42:25.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRxisTdkunoX50YHz9rneaH2UCkkNFfilofiuupZrD3wZefpW8M9vRiWce2UJNVCeVafA81FavURBbxU33Gc15m7lN8Bzsa5K9725F/zLi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4049
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 10:42:30AM -0700, Amritha Nambiar wrote:
> After the napi context is initialized, map the napi instance
> with the queue/queue-set on the corresponding irq line.
> 
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>

Hi Amritha,

some minor feedback from my side.

...

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9ee8eb3ef223..ba712119ec85 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6366,6 +6366,40 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
>  }
>  EXPORT_SYMBOL(dev_set_threaded);
>  
> +/**
> + * netif_napi_add_queue - Associate queue with the napi
> + * @napi: NAPI context
> + * @queue_index: Index of queue
> + * @napi_container_type: queue type as RX or TX

s/@napi_container_type:/@type:/

> + *
> + * Add queue with its corresponding napi context
> + */
> +int netif_napi_add_queue(struct napi_struct *napi, u16 queue_index,
> +			 enum napi_container_type type)
> +{
> +	struct napi_queue *napi_queue;
> +
> +	napi_queue = kzalloc(sizeof(*napi_queue), GFP_KERNEL);
> +	if (!napi_queue)
> +		return -ENOMEM;
> +
> +	napi_queue->queue_index = queue_index;
> +
> +	switch (type) {
> +	case NAPI_RX_CONTAINER:
> +		list_add_rcu(&napi_queue->q_list, &napi->napi_rxq_list);
> +		break;
> +	case NAPI_TX_CONTAINER:
> +		list_add_rcu(&napi_queue->q_list, &napi->napi_txq_list);
> +		break;
> +	default:

Perhaps napi_queue is leaked here.

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(netif_napi_add_queue);
> +
>  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
>  			   int (*poll)(struct napi_struct *, int), int weight)
>  {
> 
> 

