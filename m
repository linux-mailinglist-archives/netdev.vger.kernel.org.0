Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEEC699800
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBPOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjBPOz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:55:57 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE3F521F2
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676559354; x=1708095354;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H1B7HxJel9MVMC+fCMn0upattcMoU88pRYphxumy5w0=;
  b=Ut56lWuo+YK/sLpwBvz/WzvIEN3yKY75vHtelKYkrasbmIrJ7ZCKB1dy
   BU+tcdGizosnMk5ImVCZqt30DEoQTDP8ehKkToulcJ/oL9Aho1dmQaRzM
   t1FlODkyVHd/xlx2Sj2ecfdK7Dv0eswDx/flVZ0g24CGESzvODD7soF5+
   VyUisQ2j71kt77CAZyhK6wmVjLkVjyTnuUw51lB1TTxfgmggxGeeSpPwF
   qbPN/s1vqKZzkDaShBB7aKLaOKxbdnmzwmhsL6/11UxgSLQmWsK45ow3G
   138EHMqEYYEqu/fYajoameJM1dwQyeLkLJRcEON5vF7BSDRqm5mE2bMJs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="396378695"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="396378695"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:55:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="700512612"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="700512612"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2023 06:55:53 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:55:52 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:55:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:55:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSUelv6E/cFBkNt+6bgr56J5imwp8f5ubZd9Ab8xCcEIRSb6TisoQXrPAUdhmxStnaFidepUUsOn1EOfKXJ3Aqu0gA5av4SPU+g8aS+kO/cuvqYL1EJCQ8ZDWuuDIBllPNYnjstspZsYeTN0Vm2YUwfZzu1aogkSq5L0UkIsCDqTlqssdGg0n0ncg+wRY5Cd2fi5m8TZuUUq8TGEK66PI29JCBxzKqNiFSRl0CSyZMWL4RZVnyjW6O4UGkR4zaVWnAEpvhjOIYHNG/Yg9NBlYsKQurXKvTiHtCmMkmNvK17aIO1rPKiiDuon6UKwbYwioa8XDMvf9zByb1mUSrbCog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1cl21A6r2Yk2p0mU3p8WSzzoDq+4uQ69xuURrLVQq8=;
 b=n7O1JUw6yI6LZfdU+WHcbVIONdfovRmbX+0ZdMfO3js+g8oe8Zcg55Gj68EJxT139tk9ajvHcxCi/5O7MDkHIB5ctCTWu1k/aJHQKlpp1TN4D74Cq85e+b2uuv3/ecBkQD+8iv+tJVtbbOLwX8Ozmz6yp5V2r0wxFKSNQJKjJVV4HERhZmCqwSn201kmg3GTBkWCgCmQIQo1snjRXIw7ALi+84miXj7dIj5ZWSgsBLUQPgbvRnf/IVr2EuKXp4TD3kuh5NyIQ1n+edtGZcQiA6F/oiHgIRZgPfGYEZtqaldmAJf87LoTDdN8e6wFkk6Imhd6h0GoX5RjUt+FSusxfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB6790.namprd11.prod.outlook.com (2603:10b6:a03:483::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 14:55:51 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 14:55:51 +0000
Date:   Thu, 16 Feb 2023 15:55:37 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 1/9] net/mlx5e: Switch to using napi_build_skb()
Message-ID: <Y+5D6VW7FMrYKSE+@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-2-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216000918.235103-2-saeed@kernel.org>
X-ClientProxiedBy: LO0P123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b9d954-3c20-4c83-45e6-08db102de52f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NiQ7YQn0Uj8VyvlU6ERLqPfnQqK6nzjTBF5qGaBYVYRGAeg5Sj3Wv1fk+Ss00MeftZWFe1A5k5frLP+KGlazNoQnuoGohWSn79OVx9IIUOG+PWp52pGrEVvMx97uLhhK1KHqqHekryF7NrQzLGbspcazL/gggHroPt44e9BCfKY2prDaUUqjDgHfKBgw3qf7ke6l4Y5jVlT1l65Uxi56qMea8zlmK0hu7Z0GWUd+rl2fjZVoXer2NfsW1NeyfD4g1+++1Ae1R6tfqz8SsaB36XviF+0mCsBveGkGSWyMrqkWQFzqwiTOy5xHzYRwUhapgq1PA1FyxnNom8veW0ePuX1n0CFtt3TN1Z87FUpeXqmq+6JPSGIWGJgwygiT7X7jkvbwjYmIKIbpGjhZTBC03OUJHpocoiKb24x/Yvl+hZWBYMQgQfXDuD1efKaH+q2vgPhizCNrOLCule9lOlEFYI6VBOkuv2E+rdRb5W6HhukDTslyua/BEWXjudtQT6YuGsE5QgSlb06gtHxsoLjG8E2jiZFgI5Q6WWAMTcHnLLR5gv1Phj6sf1pE05kkS9ltgdUbGQNmp198s6kAeE+g/vEVqWDWzB/+1DN8GEGO94ApQNp924zALqEeDuoL/rlCL/sO73FuyB4o9UdsRpA9Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199018)(6486002)(478600001)(6666004)(33716001)(6506007)(6512007)(9686003)(186003)(26005)(2906002)(83380400001)(54906003)(316002)(38100700002)(66556008)(66476007)(66946007)(82960400001)(6916009)(4326008)(8676002)(41300700001)(86362001)(44832011)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GphgPWjmADiniakB6nNHSyjivqwEmTo3ywzsPJeh+8sdX2xm5UbQ/4kymi7l?=
 =?us-ascii?Q?2PYHLELksx3CO/NrDX/1TMBbZUPqDV/wyDOWb2if2jhOePA/h/GqOeoFmTAF?=
 =?us-ascii?Q?vn2ze1JGWjKrC3U6HMaBmyuXnWyZQ1tsn4ehfHgXOtMU97syzRHi3MBY0bA2?=
 =?us-ascii?Q?s8IRt3cCIGkVGflbtksMdCNftIukHN9GkxcQAOllCmmiCvZod2fCeMsn5h1l?=
 =?us-ascii?Q?ac8We0GZhMtRErWsaq4u32hxZG4RcDPE/zwviwLMJTjwVE0t8m6DEM9EPKMs?=
 =?us-ascii?Q?1EqGTtMsjmsjHyywulCElCksXDJUXkPzp9m5LwD4So7N4nDFsDRK9zQ45v7a?=
 =?us-ascii?Q?9kg4zGsma2KXdWhwJIXsdLlqbtH86Evhc43UBpqwM9XbK1hAwzb2pCLto6vP?=
 =?us-ascii?Q?rT+CeT8D/YllnsSwHiufjUG2aWRNPVMNkPAkqyazON/aTs4sxcO1WTxsSyHn?=
 =?us-ascii?Q?MP7kODy02OaQZwk614sIbSXy2HOtPiFc3dDUEKiUUpuoly9S7Uq6+pDvQA93?=
 =?us-ascii?Q?fYu7fKsGIhg4ujHdOARXIP5orTKossbRZUup77QA0BHZRkO6Bv7h9RPopOtV?=
 =?us-ascii?Q?NoMUchbvt3kBZSZmuYzMhempT4/Wo1kn3Cfj1P7vnGgEy29IDQ/CvyjxzaNF?=
 =?us-ascii?Q?bBu6cRYCFyKSeAqdOdLrfWEx4qbqQpgMaVCydAY6OIKOhNxoBMHtBEQjIq1x?=
 =?us-ascii?Q?6Lr93aGVInDc8QtZqO8F3XUJojh4FupiRqF8b7iHETl5rm+R58x1XtT8t8NK?=
 =?us-ascii?Q?+csKJ65zrdjqL/KjAMo2asG9paks6na5k0hb0MFWv7WhGGjKvkdn+QhMuzRl?=
 =?us-ascii?Q?a5mseIVoRKYn9rDd14ZcOQxEsKViXTKT57K3I2kqYbDIHt87+TamPIp1/Qhf?=
 =?us-ascii?Q?WXBlZ8L83h1TYAiWxECEyY6uPMuIuX6r7mH02kNksXXEEwIufgM9qWuLP6wU?=
 =?us-ascii?Q?6njhVeyr/I5hiCbgWVWuoXONtyDi8o1ponfFHipxeDcYBL8H2xt9/pqr9bAL?=
 =?us-ascii?Q?V8mjp0F9qVfdH6u1I+j6CGS0jKp1u/coWNJiFfjKoESpJmuuq0NVA8PhMmpW?=
 =?us-ascii?Q?/r5ihjuHR1cqXMEh4vF6e520NfJmtmIXibtjzwGBn6cLHYoEHWsl3s3ycxqn?=
 =?us-ascii?Q?76IrE+WIQxHM+AbdZ1wdBOfZ9BuPz7bMOLUu4nkrHvgR2yrH/S3vMPxOESBA?=
 =?us-ascii?Q?mYMqu2UQNW465i63QeIJ9NIyT2yiBcCVkFhDMPLOATyrW1CXB5MhSPg7QBP3?=
 =?us-ascii?Q?p/9oJ6zGpmFYzy/h5t2fcDk7DutWXKcIVyXe1hNhC8CqlhL6d2HjvXYG/YSE?=
 =?us-ascii?Q?kPXoNIDgTr2pB9kuDy4jcSGRRpk0ziYyKum0KbKyMamQ351rSj2C+8xl/h6n?=
 =?us-ascii?Q?vZNtapWN0ew1kR7X49d4qA+R8nB0GxG7Yl85hY1SHquGxFmod6+ytt16/8GR?=
 =?us-ascii?Q?FwIh7YijqebIOaYUIj2saSwyuaX5a1i14XH0o6MSfmFXilvtucyhvsnKqK41?=
 =?us-ascii?Q?zckWugCJyzECcnNmV0zSfn7xR/K2sERov05Cer1dEhTfS8Vgjeh9LXMCmh0n?=
 =?us-ascii?Q?4HJPDCBV4eTS74nSd3mN5/wGma1CzUy4wEJBYgOBdS48s8lnAhr5uALAjcqE?=
 =?us-ascii?Q?jV3IbRuK+8TEjHsK+UWEeVc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b9d954-3c20-4c83-45e6-08db102de52f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:55:50.9272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJn3vZVItEWNrwbfJbOhS9+fXbGaSw9RcskUfl5ZYaK2OfbON+F6sf3kA+YPQ+FOIIauB+p68f257zEX4HE0LJut29wqLF3sVPDt3X71Oak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6790
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 04:09:10PM -0800, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Use napi_build_skb() which uses NAPI percpu caches to obtain
> skbuff_head instead of inplace allocation.
> 
> napi_build_skb() calls napi_skb_cache_get(), which returns a cached
> skb, or allocates a bulk of NAPI_SKB_CACHE_BULK (16) if cache is empty.
> 
> Performance test:
> TCP single stream, single ring, single core, default MTU (1500B).
> 
> Before: 26.5 Gbits/sec
> After:  30.1 Gbits/sec (+13.6%)

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index a9473a51edc1..9ac2c7778b5b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1556,7 +1556,7 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
>  				       u32 frag_size, u16 headroom,
>  				       u32 cqe_bcnt, u32 metasize)
>  {
> -	struct sk_buff *skb = build_skb(va, frag_size);
> +	struct sk_buff *skb = napi_build_skb(va, frag_size);
>  
>  	if (unlikely(!skb)) {
>  		rq->stats->buff_alloc_err++;
> -- 
> 2.39.1
> 
