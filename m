Return-Path: <netdev+bounces-3865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8C9709460
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 766B9281BB8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF7A6FD2;
	Fri, 19 May 2023 10:02:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2E76FAF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:02:55 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B89CF0;
	Fri, 19 May 2023 03:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObgNxjI6ZWGuX1BZ47eRfUk5YCG4P4pTM6KkypJOiuvWV2rwnkm+Hroyo7uXkmYcnM5O6ojxWx9Eere+LE8c2PgNM58dG5eYvaLQnl5zDd9MCZnlh/SKqVuXwAK194c42jerAOMs8lShfVTh2lywE+UElbJJEct2KtBJFhlwjHDQFdArjRagXFztrpQ7vyfUCK9x8apNltLLLV0o+mHfLoNnebBZv+cnG69EAeon7JvY2c93Qt0lKN7n2clnu5vLO7nJwAwloiV0SImMGGYyrzjddZMpr8eZZZV4DDnX2A7li07oQiVlHT18ihFKK0mnqlDKfDlZldCfffD9cSqkVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q32WIGmfTQKLOoQN7DfiviaRYRpfXGBRJqqDABHBpWM=;
 b=hN9KHbJMXS15/023jKL1pf9E/32i7bu+EwUoh09CSFIx0BoavWDAUBA+EykUfqiaUSGHh9dimPHhsq1DJYq6j2GpIX81EDSTxW8EAPv0NW35N6lrQu9BstanvgKN/CB5JhuybLVYDQyoodgWDfa6ST/kGEMsd0r6gwHC0vJDCDzSLh3hkPCgYr3EGo8srlWQZPyOpvnx1QqgPkJTSG+HlZdfB/KAvvxRmSVGrH6ScRTj3AbLWbgHW8tAu0FFrHIuCicveYkftyWksOFkT+gZEh3h8HHWH/ixGRxP/iPdUVqVg7DTciQd822OXekuQRrP8aP0PhIdAPnfhdXNh3KK2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q32WIGmfTQKLOoQN7DfiviaRYRpfXGBRJqqDABHBpWM=;
 b=o5rqsBwLktmB4q8Yjqj237NXf9mo0mgf9Bb+wtNtpcJttkKZvPXWAeqvPfHBKCdYIUbUgZCpj6gvdHSOAnLGGMCFJ7kHyGXPvwx8W6xTb0FBJ4nRdFD9MEUWj0UOY8MFL4reEtPX1bA6NRZy2sb+9N7kYFxyD2TeldVySyKufyU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5038.namprd13.prod.outlook.com (2603:10b6:806:1a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 10:02:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 10:02:51 +0000
Date: Fri, 19 May 2023 12:02:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, linyunsheng@huawei.com,
	sbhatta@marvell.com, gakula@marvell.com, schalla@marvell.com,
	hkelam@marvell.com
Subject: Re: [PATCH net-next v3] octeontx2-pf: Add support for page pool
Message-ID: <ZGdJRMfuXHnvVQy9@corigine.com>
References: <20230519071352.3967986-1-rkannoth@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519071352.3967986-1-rkannoth@marvell.com>
X-ClientProxiedBy: AM4PR05CA0020.eurprd05.prod.outlook.com (2603:10a6:205::33)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5038:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a1b910-24e0-4236-f7f8-08db5850350a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6Zz8eOm0RqJP9bZLh+zIvTl9yFa/6R68RBBuOQ9s2Zak1zoNsDR473TviTthhmcZOQQT3gPTqKdJbU8ugYa75AvN7N/GgrQYONHMgTubn7Vj6fEcJlbR0fAiHx5ozJ91GYzozu7Zjh8g8brwtmgPGUr7djH5a1SRtxVRw4yy2AVeyCjg79/F3tmFyYZb3A0X8qvWVEE4f9rU2VTxDLgatJrLzRdsqnXaJDhhAJ4Www8RWBW2+dQWtn3kWMZBlGGwSbRRwIdMgL0vRK4CMlXV5wEWTOC0kacZnbsgLt/1+VlcBLHG9ievhH/R2V+Bg2jccz8BykOAIqQNpv3g2nTaB+Y98MWAf0/7wDaA3q95z6DfAkuNY8CE6QbxslOsrUQ4a9PLWCZif0yzh+kWYJKWuC1IM7gP6B+1pxQZk7Lg3zP+ynOfKrnzjKaO6wZffKrwxqNFgBuEb8RKyYLH4Ayg1LAFolrShL8bFjNsmcQXh+rQql+SxZjvnDUD6IvhKaL2wSxDtKOqrI5u5WtJ7dU5O0aAgD5VEMcG2raDmCgQcuw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39840400004)(376002)(451199021)(5660300002)(41300700001)(2906002)(36756003)(2616005)(83380400001)(38100700002)(86362001)(6506007)(6512007)(8936002)(44832011)(186003)(7416002)(8676002)(6486002)(966005)(66946007)(66556008)(66476007)(6666004)(478600001)(4326008)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u9bworcSDLIIwLVr5qSXfMTwTclxsVbth8CymgozkXLIhMAaOtBO/W+S9Ofu?=
 =?us-ascii?Q?3b2uhaz576QjUNaRcCSxxYJKD8HfILQC3y+9hNcZAlwheTxgNchLqyo+09s+?=
 =?us-ascii?Q?vomXxg2nqwEELXbVigthQOaopNcN2JIa0YPim/zYYKJo8DyZEaZMzvqugJ0g?=
 =?us-ascii?Q?MHMqjExW4xhlIyrrjtYpfQDwCuJjxATaFYWSHhWlpngE+uMMX5KkHnXoHAUq?=
 =?us-ascii?Q?8U0CUmCUEbM6KZNFVQPomIkQLwhR8UYJCiYgGncjwdU/LIAoYJzoqQdv52cF?=
 =?us-ascii?Q?AImaReVz6WDnIta0NrQu/ih1mi5kc71/Yd0EXr2Ryd3RlT70oHSfAleRvHTj?=
 =?us-ascii?Q?OsPdhuyqEZyhHPhFyhW56lj/6kxUoDpUArnni+WrSdO8ZFnSeIfRTqI0j9I3?=
 =?us-ascii?Q?UUDYQC5S1WmZQhthXQ1NmE4YrCwFYyYc43TA6X1WBn1jMEeTmkPsOg9OEG6b?=
 =?us-ascii?Q?Aca8qzycIKpIW2qHq9KqLQLF1KZbjeDpQi8QdLIUaYVYXzh6wqkKhtiAkehf?=
 =?us-ascii?Q?jcDYHH+m80mYhps3dXxn22zATucmXxrrGl7p5d9CK1Uwvg/CjKfRx0hgxLm+?=
 =?us-ascii?Q?IFKM9kMoyTVXDpbcftEirZT0KjFII+d0ngWxrUmgx84IuRjlXp9x1pnYsv+e?=
 =?us-ascii?Q?c6WMSJOVNAaWVe2gOQdrcdtNKTBEJHZ9vVfFP8jDh0JTljzH40A1uXJMd82f?=
 =?us-ascii?Q?aDWVh0MY8Mj52BnCAnFyiUH7m3FmkLVEsyGsuUstwOZv4dG+m+nUS45jg9mk?=
 =?us-ascii?Q?47brx95am1UbGzYIHV4p708F4VNNqn2loz6ltMk3Q0875PGjA2l1Ur1O+Cgs?=
 =?us-ascii?Q?d2jBUe2NPES747hlmIp7bZoXZZ/Td3nV4gL8ITWCEJcP+tpQLs492fVU99pi?=
 =?us-ascii?Q?EJWm6y0X7Vf436yWPDuY4r5VMHMXXcCCRFN1n7P1B7bsR3vlngREUfBdjgot?=
 =?us-ascii?Q?3hlP8OAEvljM2xvNpSBlDQKAe8hyc6IaV+cXB4k0k0jBd6jACQSRmmwfekEM?=
 =?us-ascii?Q?vPfcK0U8HlSXW6vX+uGaJtmsH06Dj4E6wjn4eXuNXSswnE9oAl3gEGKnXkq7?=
 =?us-ascii?Q?yeEJ7A1xTN0MbDcryAzPaPADWC5KHVSSz6AeXHRAs+gabsRrKa8cPLr4jkhn?=
 =?us-ascii?Q?q1zLDZ5/ciT1W0iTSvi1njWVhpsRRWKvXHcQsRBZuQHPVl9aqOj0cLYBigXL?=
 =?us-ascii?Q?6kG0G8mB9S4/uUpjvAtlB2AifT1Q4Y5tpTeVx4NYQloEzkRCHwfWjc46xnaO?=
 =?us-ascii?Q?U3ZCAZyU44gOucel6uYiGLf0JDaW/+Wi5ikd2BMVoBUpz248VE4XJHl3zZHR?=
 =?us-ascii?Q?F76vQsw26/P9IvVNwpsjbzLtnnpGR8zA5JgOUosWMd/vORLR6hUqpmV9UVMA?=
 =?us-ascii?Q?s+31+b5UIk1SE77cN6oXLtxfVd+ihd8B02COxoRm0yCiWUQFNACztJiqnI7V?=
 =?us-ascii?Q?/Y8Ja/2kv6zwoxw9g3focnZawud5GeE/olViRagHK/Fz9Uu5pXMq66fJ5/MZ?=
 =?us-ascii?Q?Z/MjLzJ+TEbhmSQisRvpOx5ahwRcdv1EMmtioi0KPEAm+0ipdhMXkXjPd719?=
 =?us-ascii?Q?YUVrnhI/xET94pQSQdbzqa3jj1QYm85/jdLpI6MxZNCsG9hV5prG+F6WGbC7?=
 =?us-ascii?Q?UmokbLBVH6V/pSrAFscYkh7XsgRq8/5aVf6E+aCQ5QxUc6ukIzR/U+vTkV69?=
 =?us-ascii?Q?/5jtRw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a1b910-24e0-4236-f7f8-08db5850350a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 10:02:51.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIBWxv/3DI9q9JTU1AacDGnn6EJ6leYiqvZN5c+AFXkuEmnCEHF5+1WLyLoS8Jp+VCCra8184CBEwIt58Ju8rHdsukInBcNNaFWRe4OfSPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5038
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 12:43:52PM +0530, Ratheesh Kannoth wrote:
> Page pool for each rx queue enhance rx side performance
> by reclaiming buffers back to each queue specific pool. DMA
> mapping is done only for first allocation of buffers.
> As subsequent buffers allocation avoid DMA mapping,
> it results in performance improvement.
> 
> Image        |  Performance
> ------------ | ------------
> Vannila      |   3Mpps
>              |
> with this    |   42Mpps
> change	     |
> ---------------------------
> 
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>

...

> @@ -1205,10 +1226,28 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
>  	}
>  }
>  
> +void otx2_free_bufs(struct otx2_nic *pfvf, struct otx2_pool *pool,
> +		    u64 iova, int size)
> +{
> +	u64 pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
> +	struct page *page = virt_to_head_page(phys_to_virt(pa));

nit: please arrange local variables in networking code in reverse xmas tree
     order - longest line to shortest.

	u64 pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
	struct page *page;

	page = virt_to_head_page(phys_to_virt(pa));

     The following tool can check this:

        https://github.com/ecree-solarflare/xmastree

...

> @@ -1186,11 +1185,13 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
>  }
>  EXPORT_SYMBOL(otx2_sq_append_skb);
>  
> -void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
> +void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int qidx)
>  {
>  	struct nix_cqe_rx_s *cqe;
>  	int processed_cqe = 0;
> -	u64 iova, pa;
> +	struct otx2_pool *pool;
> +	u16 pool_id;
> +	u64 iova;

Likewise here.

>  
>  	if (pfvf->xdp_prog)
>  		xdp_rxq_info_unreg(&cq->xdp_rxq);

...

