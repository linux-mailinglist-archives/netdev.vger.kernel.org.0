Return-Path: <netdev+bounces-10708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FFE72FE68
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E71F92812BE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343F9A926;
	Wed, 14 Jun 2023 12:23:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551F9441
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:23:34 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C441FD5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:23:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH6F5AaRCynAcJQtRfmynW1ANNk/b3bbPu3mwt/Y5bl99KKyPsA+1ov8pSCQPktHD83yIXJlPrOGHoUYWGbAEXe7xmNF3X6juBqb6asvgwzii9rNxfrdS5uqT9Gg4ZQl8dwq6PEQ8rzy9P42s115F53svvMYrE51TMPvIE7pif0OHjrt0n1FwXwpyVnpcNGtzu4F+Nm7xyxNZLk71mZHRKcD6/6H3xC/ABkFriEsJuII+ff1VA76H/0pcTtcgZlxI1LnGqqtTAQqnmksIWhzCTVWw94Q00gNEISQCdJ0U/Wo0qa05/T2bltSydUH8eNEF0GS+/yz/OYTHqX02fI7gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7vcCt3ISQwWPoamIuPpaWecZ84gK+PvpLIv5DTUhAk=;
 b=Q0N2c0k1F0Z0Ecsdwyb5/QCdlu6nVn6xwjwQdEhQchZx57IrdOayuJQnAkqMcIPZxnH2K2mutAzCSeCzy5S9lO2dTr9gh8zlBPmN5LGWpDuU2SBhx10wzB4n1PKJ9GbHjU7xWwKMECOXjr7qXUQssNjjp5jcososEhpZR9720YpdNBaaH92jRWfTUHLENPVJK1HOqFLexAGpvhYUx5I0ORcCysssv2Ya7NAKMGLIYF/5+J60LtkEaLPFYNQhaZVk1TbgVGhXfG1R47jGeP+q57f+F/lDIlm1Xc5XSOx+TTw90+48lfN3gQTolEbGs+n/Ny5v2CcodyrjoE4OK4kHhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7vcCt3ISQwWPoamIuPpaWecZ84gK+PvpLIv5DTUhAk=;
 b=fVq46PipNDvhUDnnqHAwy9Bz4f0tnzu7v81ZG7Aqa2H/Tv9MPAEZAts8hsiL/kyxH8v+9Nn/VVxdvOO1aEHPGqEMPqXCr2rBlUdd/Aai+CWzRlPVYYAbu2Qx1upfSLmj+6f1+djru/nb2i49g6dxPZDVYL5dOYYDC0tnmdoPm4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5511.namprd13.prod.outlook.com (2603:10b6:303:196::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 12:23:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:23:27 +0000
Date: Wed, 14 Jun 2023 14:23:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, richardbgobert@gmail.com
Subject: Re: [PATCH net-next] gro: move the tc_ext comparison to a helper
Message-ID: <ZImxOTT4L1J09wj/@corigine.com>
References: <20230613205105.1996166-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613205105.1996166-1-kuba@kernel.org>
X-ClientProxiedBy: AM3PR07CA0131.eurprd07.prod.outlook.com
 (2603:10a6:207:8::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5511:EE_
X-MS-Office365-Filtering-Correlation-Id: 59eb07b3-8353-44da-5450-08db6cd227d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+9P+iY5pCTNFxw17hFEp4G7oRAVTaQ/t0TkialCBXsfwHyl6uHAXSDGmfD/ptp+oeR9QoLZYfugspbCyPnACTsjnafrSCZE4j3XUCul+ZBjI78tLUFICfexZLnKrxtFxLJ4xL6XK069aknV1mH8LqLCUBNYNJl8hYwlPE+x2qoBEnT7izJudqG/3+5mcY05TOM0B4mWsJNLXktk8OYy6eLcYbO9GsywJsL5Cqm+li3suKR7Tw56QgYDKGnxUkzMF7QIh/oIoI6KBTtrTxdg3y6sw2YisL/JYMLEKSV/ukoz6lhAaYwr0/ubrqATyPNGGJ1KV7hEITSJ0k9NrjgH52ljDjPBQ0LBFzRI5L4LiFcSonJoz1Sm0++lkWgN24GEil4v39muhEem7xv+dgYvvR/WW7u4gNZbA2eCYuYDn7lypHI1l5Ew7ZK5GLLGrdoIwt0lK3Z4J9U6R1q+Yv78++WCxz72xRSSDG73MWww/W2c9Wa8T4UfXedTLe6yd/h2h1qPDiscmbHXR0pqD+XWUe2W+WzR+RVD8CU+yQGBxA7zTXLPlB5d9Xlv1LQRRMOJwJ5RgMOZ+6yyw9NYfIhZ2kAus44cEfhZUfCwAvDi3E+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(39840400004)(396003)(451199021)(66556008)(66946007)(316002)(6666004)(66476007)(4326008)(478600001)(6916009)(36756003)(2616005)(86362001)(186003)(6506007)(6512007)(83380400001)(5660300002)(8676002)(41300700001)(8936002)(44832011)(2906002)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pstZMTJjrW/MN3o4ubKPZX0rTpQ5jCE7sV+/QXOjKGff1cTjxExaUai4ZqTe?=
 =?us-ascii?Q?vOZ002kzjsMsZB65Cc9nsv4Oq1kD0EyTVI/4WifXf5nnfIc8W3CubwUy222g?=
 =?us-ascii?Q?IfyryobdveWYJ6OfDWUncFFPgnKBzmq280XGOERouwCP9mA29Li11DjXVElG?=
 =?us-ascii?Q?DjmxAdZezpTBwo2o079sWKI+ZDoAb5+nJwhWCHdwlQLmjlM9Zp/Tv8L4OK1m?=
 =?us-ascii?Q?gf2dm43SlVjtvWIwBFEgMhWg/caln5BmxDSvaGcayMenA/jYggt+T09Z1G5b?=
 =?us-ascii?Q?Ac5xuDkkwS5SIRBQag+BTHt9hGTfOWtnp0JhVLHhRLXvfYJua71fu8d2F6oj?=
 =?us-ascii?Q?eaInYR+gsqKnNjNofMwU58z0L0vPKcP1bpgo733EsTFCm2EFjqaXZwq2PLfk?=
 =?us-ascii?Q?TKDL58B1giaNOdKAzJv+r4huX/YZkrSSyOY5wMMDQN2bvCKheKZLUFzrS8ae?=
 =?us-ascii?Q?GC65PPn2ky4Gw26BdF/mXbTLZMuCJl9+krtZwc+ax37YwQ9ZSdCs0nKThPJd?=
 =?us-ascii?Q?pLy6AWALW+msqe4llpxD2HOVS3hTfNwnVqAa/Lfe43GofJS37mEIjMVdXQsw?=
 =?us-ascii?Q?Fc2NAnNy1uXYh8H0CCA4jzo3R+JsQeJwaKNj6uXo2kophG4UGfKNeDHVti/U?=
 =?us-ascii?Q?gp0C/dG/Ehmi/oM1r6cXJjrTOCP2/hkdNMSPuskZib04eum7jt4+TJWBwxp8?=
 =?us-ascii?Q?/VZV864D2NFXszqJo4B5aIDSdPUbiQRddIoQND/NbN09iEh8bAF3Nr/Dw6JL?=
 =?us-ascii?Q?TCxJmPDdULXvI3Q0x6O/qzN3yKs94faHsEddU7WjynqEsHvgzbFsCrRwXie+?=
 =?us-ascii?Q?t+iWmKVRyy6wrejWidZaz/uqcxpcVRHch88y7hna92PLOXAFzDzvizeVikfD?=
 =?us-ascii?Q?80K/wy0zjpFaW6i17hdMzwIo58C5QqDOJbaVc7Li+AFR6UfK31aGsIARWjOA?=
 =?us-ascii?Q?ZQNS1jgdp8GW240gtzL2tEpYqVZ+Ck4N6pdMlumQ34KCYnkLFZAJ0i1rzh1T?=
 =?us-ascii?Q?JDfYUvSHyK930bFgkhYtwH0ZseOG/Acu1oysye3ZveN8qATRVBiKPjA97ana?=
 =?us-ascii?Q?oFC7WpvBCM+7fU+vmqr+IlLZONczq4EyHZIQSqcmreeN+H323ab5HI23KYgO?=
 =?us-ascii?Q?0ADh21ezmeGrSnLtet2QWpt4JosrEEHIKfbuDIIzglcSN7rlCkKXSiYQAFqY?=
 =?us-ascii?Q?W8v7DJDOsiq3MFRQ4QMkTbOJaKTs8/abNgHFXoCyYTEEZeQx/WBGWt3P1hef?=
 =?us-ascii?Q?SevPH991NlEnnRIzV5fNZV+3+3vZm2/2owQhCM2nojFoHO2M4ZLC7b+B3A/M?=
 =?us-ascii?Q?Gc9y4jzpVPuMmg/hblyn42YLhSvGqXpUkN/kZD7+l3feSj2LKKWuvjhGOrrZ?=
 =?us-ascii?Q?UnDV1o6ZuPbmtXncFqPTWWtEspNZIJGg/16HcxD25AVnr4J7+hBuXkC4Pj7v?=
 =?us-ascii?Q?Y/k+whk25Eg8+mcAOXhlhWjMrRP3V11h/ndqHKwhd4CuBB86zeEk8VWpDf89?=
 =?us-ascii?Q?KjqDFlmnkKQGKDAkEaQ0dH+MM96auGnKoNE9ZxuO9N/BTUkbQuTK9rhD/YAy?=
 =?us-ascii?Q?7zt2U7S8olynHqwgGpb36zwO2871W/StAqeln02mXfq/VXA5xsSFa2YcQBCL?=
 =?us-ascii?Q?soIrk4xNklnYx9yr9TayabJ1hJ1YP7vkEWbNGNJsmYislzs6GIzgKD45JdLQ?=
 =?us-ascii?Q?ypM6BA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59eb07b3-8353-44da-5450-08db6cd227d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:23:27.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOgG0hwVMaNIh93CFgWdXJB4yOKcGmo1xMCSPI8AqVDb6DXEcgdRDj/we41Dv/MebeJHLDBCX9JxJ44TBqVFhCV9qYrNCn10ctLBDTUTGBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5511
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 01:51:05PM -0700, Jakub Kicinski wrote:
> The double ifdefs are quite aesthetically displeasing.
> Use a helper function to make the code more compact.
> The resulting machine code looks the same (with minor
> movement of some basic blocks).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Hi Jakub,

I like your patch, and I think it is a good improvement,
but I find the patch description slightly confusing.

In my understanding of things this patch is doing two things:

1) Moving code into a helper
2) Eliminating a check on CONFIG_SKB_EXTENSIONS,
   presumably because it is selected by NET_TC_SKB_EXT.

But the patch description seems to conflate these.

In any case, code looks good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> CC: richardbgobert@gmail.com
> ---
>  net/core/gro.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index ab9a447dfba7..90889e1f3f9a 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -305,6 +305,23 @@ void napi_gro_flush(struct napi_struct *napi, bool flush_old)
>  }
>  EXPORT_SYMBOL(napi_gro_flush);
>  
> +static void gro_list_prepare_tc_ext(const struct sk_buff *skb,
> +				    const struct sk_buff *p,
> +				    unsigned long *diffs)
> +{
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> +	struct tc_skb_ext *skb_ext;
> +	struct tc_skb_ext *p_ext;
> +
> +	skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> +	p_ext = skb_ext_find(p, TC_SKB_EXT);
> +
> +	*diffs |= (!!p_ext) ^ (!!skb_ext);
> +	if (!*diffs && unlikely(skb_ext))
> +		*diffs |= p_ext->chain ^ skb_ext->chain;
> +#endif
> +}
> +
>  static void gro_list_prepare(const struct list_head *head,
>  			     const struct sk_buff *skb)
>  {
> @@ -339,23 +356,11 @@ static void gro_list_prepare(const struct list_head *head,
>  		 * avoid trying too hard to skip each of them individually
>  		 */
>  		if (!diffs && unlikely(skb->slow_gro | p->slow_gro)) {
> -#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> -			struct tc_skb_ext *skb_ext;
> -			struct tc_skb_ext *p_ext;
> -#endif
> -
>  			diffs |= p->sk != skb->sk;
>  			diffs |= skb_metadata_dst_cmp(p, skb);
>  			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
>  
> -#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> -			skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> -			p_ext = skb_ext_find(p, TC_SKB_EXT);
> -
> -			diffs |= (!!p_ext) ^ (!!skb_ext);
> -			if (!diffs && unlikely(skb_ext))
> -				diffs |= p_ext->chain ^ skb_ext->chain;
> -#endif
> +			gro_list_prepare_tc_ext(skb, p, &diffs);
>  		}
>  
>  		NAPI_GRO_CB(p)->same_flow = !diffs;
> -- 
> 2.40.1
> 
> 

