Return-Path: <netdev+bounces-1382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8AE6FDA73
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E9881C20B86
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0B865D;
	Wed, 10 May 2023 09:11:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9B65C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:11:58 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2100.outbound.protection.outlook.com [40.107.244.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C4A269E;
	Wed, 10 May 2023 02:11:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i36aruiiqPfw05NRR7H+SdV6Tgw2AS+K9EDRVX4TF15RoEYoY2+9quy7lwPmABe+hQmqZTu9J1htxsmKH8jUPqnDxZ6b8Nc7tlOX9QIXsiiAX5jg8puNAbVd08j4cKcj9lSShhOorhHXw+Ya59AvpAtLArdojIscaEwiUVFSpeXx2bsL6fgKv1Y2IhKg0MyxhbVlQh8TjwKl78P++b8KAM+7PtABI1IVQ5sHSnq/WC1ekGkDimhx4UbkbLJQnDSB+QO9MO3Az9CVrjfo4gKyuqOvwdXa11rgjhMHRzQ2KZnKc9Nv/ijOpIYNeIdqL+aZSprOhUPl45oeaZSSZwbGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVTkDFqxXsDQ0LNgbGO/H8QFDGG2cXswbqI3l/RPq6g=;
 b=e3mzC5WkWp0Pkwpqo5Lu6zrZh8xRm28eBrQABVVLQGa77/UW6GHWtxbytNsc9HUbupA7ereJmxLXY30eUe0hB95cs/WMZIjCqjGPu1QybxrE8YLX1ndprAGAU7N6M4bsvsjaV9tJ13Cm5jtz69SBGfqf29+z7USGPGpJEAYpLMEk/qpdqN235vXw7yz0uO6QDrFZVo4bZ8xypV5CoK1X78nlFyD7WYAzBvpp4nwgCLZ2+w7R8Eq3BJ55PA1m9WUpNsK90ujcBGGaDJSxBJwpLGjZa1XLo09ztZJG8s6AB/Z3O3v0dryVXjbSnL+lvJXdfQ2VINWMaP0BfCSc+0eIUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVTkDFqxXsDQ0LNgbGO/H8QFDGG2cXswbqI3l/RPq6g=;
 b=QnAUhM36zxmWC6lj04BZmO7s4mnDbYVe+1FRUAp4QNriaaxWjfhMiwq0s+dCPzOO+sEc4kPVXAGbe+G7Yy8I7AFD8bLIPPs3n0AWEcyKGAKJ6DBX2rw9LzCO3Bnk79CZ4Ld4wWVBN3wVx9qUAbqy1Uk4hTt5wYSSEuzHOiWPZIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5236.namprd13.prod.outlook.com (2603:10b6:610:f4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 09:11:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:11:52 +0000
Date: Wed, 10 May 2023 11:11:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev
Subject: Re: [PATCH net 1/1] net: fec: using the standard return codes when
 xdp xmit errors
Message-ID: <ZFtf0Pu0yTzH/pLm@corigine.com>
References: <20230509193845.1090040-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509193845.1090040-1-shenwei.wang@nxp.com>
X-ClientProxiedBy: AS4P250CA0025.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5236:EE_
X-MS-Office365-Filtering-Correlation-Id: 72fbc566-9444-4de8-a03a-08db513697a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rsOnFLEp98Ti/ZCswk2yRe55dkt00cb+VkMhcXdQ+dR020+CjtqNi2Q2jkBBPSMyy15hHl3V/h6Crm8M2Rlmj9kOMtm4XHO44GwKfG/u6TxVbakc+wd9AUh7MBEyC+phWlIv/xQQLwF8RjYsxvkwdV97YFIob3nUZVQV7BkU7UfL+SMytgFqv/FnUtZZupbi8hyIM9drSxjhV18Fm/cbDjU43W+F22AMq0xhAIqrrcYmbu967osIKULN3lkzZ05HixFAaAOxaPu1mQFsC1y/xsaAn2kG/SB1iixJduzmaMna2k6oKQt29Azy9kPA7SJ5qib99ZHH2QIUHw4wt/guTxSAEXCUCH5bhTP1gMzZ3wrzdINZZQz7M9NLIfku1T0jrR0yUJo9g5Qb+TRwDwerc/QNEJH8LWdQ/L8cS+Bow07TN9aQI8FfM5WaWupyFIeyJajjdFxVO4IhGCAhRRp8rhr6fY7tOLctdYr4wpV4//vM1KLee6x1kuRJ96Bt4OTG6s26ZgIIjVZnaLGTzmxvhoMhRoIW6mJWEg1c8foouUPEx+bbCWSe4opHimZkArNu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(376002)(346002)(136003)(451199021)(2616005)(2906002)(83380400001)(186003)(4326008)(6512007)(316002)(66476007)(66946007)(6916009)(41300700001)(6666004)(66556008)(54906003)(478600001)(7416002)(5660300002)(6506007)(8676002)(6486002)(8936002)(44832011)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2wRVVfu+RsmDWZVbz39tj2fqI4h6iatJhtsd7/Uzmm4nOeZr6rayOG53rqfM?=
 =?us-ascii?Q?IwgtV1e5UKHwavWZBqNnzCh7xtWC9u6OhIwGcbU/wwntKzq9Zd8Yg/CeSS3j?=
 =?us-ascii?Q?oQy07lPI2j7BMyh+LMCor/2l4bCddnLP6JtdDr28pu1uqq7N4IkC1JIQbd4+?=
 =?us-ascii?Q?l4pSFYw8hLyl53pwtnuMDEe9Kam5tpZZ8kGf1TtthzKbbiY0efg0nizYgaff?=
 =?us-ascii?Q?vKKNHMNzfPhmQCZSnoEdKTXKsMjLdERoKKgb8aQ6Qd4N+wYR7yVkjsMvlQfi?=
 =?us-ascii?Q?F3ovweAM1HdxTbloVQT5XgkTULOihi3bLDLdRxIEtiCPJ/cXcS0ZNL5AZ2LF?=
 =?us-ascii?Q?e+v44gdfkyzIGp9cIBVBPEp/9noEAyUWEODTuyOkzcx9PrfWh8UnDRBeXDgC?=
 =?us-ascii?Q?92g+nM/X+vuSbfMeyk1pVs6n2RSQ9zAplEaXmANS9xaHFDYRcgxXtclRFqU1?=
 =?us-ascii?Q?jUb3x/Lz/I8pxU3hiHFGNdITG4pUkVoCMpgXbJySnCeGgSFWVgd3rELk5Z7B?=
 =?us-ascii?Q?s3rjgQXElvjfDH9LvjZdmmU7+5TVZxEF9UqKkDN1pT6qpgSoqfMuLCxSFU3J?=
 =?us-ascii?Q?U5jx4NrO0bMo3zdoWx/ChOwRmcDl8nMotRk2Eu8ajfHVEdchr7KQ3I0e31li?=
 =?us-ascii?Q?peaKdS7FHLMjpJZKEYTuInaTML92ixLv/1rKu7zbdBtqZcfxyW+CeOBYxHdK?=
 =?us-ascii?Q?27GUl+es0Ty4FSPyzs8fehusJUC+ur7/XsEopNq6CILFMfgg44l46jazpR+C?=
 =?us-ascii?Q?xhXbKORknn804k+uy/Mr2Q/c4xoJ3zp5cE8Mc4U5XIqWM3WKqnfeLg62ACrM?=
 =?us-ascii?Q?aBrozfEHW4VfgkZ+opTDXRnyWdnOPJ8jkkETeJk4EJpm6g75fLS24h9auafs?=
 =?us-ascii?Q?PCfVcI7/8/ywTu164BfY1SXssyTZSB3nX7W6ESm+V0IjfDnnKsSVFNAeDW9W?=
 =?us-ascii?Q?n0LiunOvbBC4lhGSdfbh1EkdtjkqeF8g7Hi5wPyEJ789HXSr1FM26u7u539u?=
 =?us-ascii?Q?2FMzMqTeGK7o17Wls9Ihu2wZEHVeLDZnDmTCMXu8bgoNzDBmEf9awBBXUah+?=
 =?us-ascii?Q?+MdyGUHMKbSzAXH3wcjOgKGVwxGhLchTsXuj0CqOWyxXbzr1ODh44DLc6NfO?=
 =?us-ascii?Q?a5xKk6iz8k19ht1SZjAT/GyYxbpj+GT+36oSO2Uo5zsASVLJ9y8TwSOpWRyw?=
 =?us-ascii?Q?XupvA7VrjmgF5wo4MGHM1VyGeSiPnE2nzYjzSfyV333s/TbOGSnyIqGxut68?=
 =?us-ascii?Q?DKALCQKmmWTaJ2cEMsP024W0s8ZtBsjZBFNoL0wY715QtINrDm1eJkU+X4kE?=
 =?us-ascii?Q?KTfabhutAKjALXlDWgzC9ic5z3MdrZGy6YQ+2IXJMc7/LuzAyJTFxQvEZXbq?=
 =?us-ascii?Q?ZZ6X8EXA4B9YG3w2DVwfQ/xDbQL8p6oECZZVMaxyTAiU02pFYxYqZHuuO0Np?=
 =?us-ascii?Q?+iZjxxpM+tp4Q4hW0fmXfi/ByBa/JhVXhvwEg1R1z0xMKRT8hYwfrXh83cs3?=
 =?us-ascii?Q?3Mdppuj5d5TrO/bw4BIFZywZYxuw0aFiMDnvc/3ugh2chvbbD2DYgfxKDjAF?=
 =?us-ascii?Q?/SWECETHIbt2JrkVIk3FOzwCgEaoXDWSz5vIfnCQwokd71SlOY9U//3Vyv3K?=
 =?us-ascii?Q?6s5Mp7nPg4CaLScCJxzj86YtyYs/rh2e3C6tSXokuZvGukz+INc9AyEJfuyi?=
 =?us-ascii?Q?yngCYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72fbc566-9444-4de8-a03a-08db513697a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:11:51.9965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCWby20zMcqAv5nLB/PWFIwmdh+zWzE8SoeBWVKfaJvwdD7Iv/LcpbWQlp/zXd8LQyXYiOPjxqSUYx2Dcy7uu2ZV1tiE2DbaSyx2V+iXA1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5236
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 02:38:45PM -0500, Shenwei Wang wrote:
> The existing logic did not properly handle unsuccessful xdp xmit frames,
> this patch revises the logic to return standard error codes (-EBUSY or
> -ENOMEM) on unsuccessful transmit.

Hi Shenwei,

I'm not sure that changing the calling convention is the fix here.
The caller seems to get it right both before and after this part
of this patch change. So this seems to be a cleanup rather than a fix.

> Start the xmit of the frame immediately right after configuring the
> tx descriptors.

This is the money part of this change. I think it warrants more
explanation.

If there are two changes to be made, they probably belong in two
patches.

> 
> Fixes: e8a17397180f ("net: fec: correct the counting of XDP sent frames")

I think this tag should be:

Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")

> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 25 ++++++++++++++---------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 42ec6ca3bf03..438fc1c3aea2 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3798,8 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>  	entries_free = fec_enet_get_free_txdesc_num(txq);
>  	if (entries_free < MAX_SKB_FRAGS + 1) {
>  		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
> -		xdp_return_frame(frame);
> -		return NETDEV_TX_BUSY;
> +		return -EBUSY;
>  	}
>  
>  	/* Fill in a Tx ring entry */
> @@ -3813,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>  	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
>  				  frame->len, DMA_TO_DEVICE);
>  	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
> -		return FEC_ENET_XDP_CONSUMED;
> +		return -ENOMEM;
>  
>  	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
>  	if (fep->bufdesc_ex)
> @@ -3835,6 +3834,11 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>  	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
>  	txq->tx_skbuff[index] = NULL;
>  
> +	/* Make sure the updates to rest of the descriptor are performed before
> +	 * transferring ownership.
> +	 */
> +	wmb();
> +
>  	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
>  	 * it's the last BD of the frame, and to put the CRC on the end.
>  	 */
> @@ -3844,8 +3848,15 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
>  	/* If this was the last BD in the ring, start at the beginning again. */
>  	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
>  
> +	/* Make sure the update to bdp and tx_skbuff are performed before
> +	 * txq->bd.cur.
> +	 */
> +	wmb();
>  	txq->bd.cur = bdp;
>  
> +	/* Trigger transmission start */
> +	writel(0, txq->bd.reg_desc_active);
> +
>  	return 0;
>  }
>  
> @@ -3869,17 +3880,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
>  	__netif_tx_lock(nq, cpu);
>  
>  	for (i = 0; i < num_frames; i++) {
> -		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
> +		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) < 0)
>  			break;
>  		sent_frames++;
>  	}
>  
> -	/* Make sure the update to bdp and tx_skbuff are performed. */
> -	wmb();
> -
> -	/* Trigger transmission start */
> -	writel(0, txq->bd.reg_desc_active);
> -
>  	__netif_tx_unlock(nq);
>  
>  	return sent_frames;
> -- 
> 2.34.1
> 
> 

