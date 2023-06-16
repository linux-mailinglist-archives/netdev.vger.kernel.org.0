Return-Path: <netdev+bounces-11438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDD07331DF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5E021C20CE9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0188E154B3;
	Fri, 16 Jun 2023 13:10:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83E4107A0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:10:18 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2128.outbound.protection.outlook.com [40.107.244.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3682B12B;
	Fri, 16 Jun 2023 06:10:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVw0jlL5Ua49r7lClYyH4rxafgi1HrElakn/9xqP7ITOOOorEPTr9Ta3L/ab7ZhQ44cLbnq4HjPH/jI6OuQxlLhlELS/uV/mV7Sc/sxZsgTQPur6S7/mvufMiJT8fGCFYDYyOjf1RtB3TKWfFyma1EG6MFRqsMyWyemLhxfl5PAs3/09rizIRS4Co2ZGoztcNjP48absQ9a4azGWcOeUznU9GD3196EvoQpcrKitMB6q6wI80tOSX286LF0n3hHJLiWWLHvvCiuVcA3XYItYki4MsHGKwovO9n4FASsd2/xiCnwuBunMOv70s/f5HBXJm+Ap3N/OlIQ2T4Zau/a62Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yGTCz9pNDub/SFTrWYEXC8z/fOcJwYslhcFoGEAVEI=;
 b=bipeA2ZgUdpk/Byw8oVG1b91FwBPBSdHYtYKcCEyFwZD0MedT6QPa8DloOnWl5eTmxuiNmbLn1FZ+xEvHIHHnQTftmGtFZ6BsSV4O7jRq4a39K7QOtr4zwOlE+fhuSpb1L1/rMFVYaCrfGSVfM5l6n+BxaYtFcgEG4wbWUTs81sf2e5/u2zsKC4u/FFHA5BZsz1f14kzLCZK0opzx5Dx6g62bRGNxmdLJTstIjkOIov+Fzd8YV2+vlUNgV4ISog/yihQanS+fRt+HvpFfG3NEBDBCijPd2q2wOxBaxKsA3nxGhTg0C9y1EtUzUDk4ISr/mxaiKSXHcuqMySfmNklaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yGTCz9pNDub/SFTrWYEXC8z/fOcJwYslhcFoGEAVEI=;
 b=rNBp8APKcq6k4hSJDn0HqwBi3HW5RlQEZr8uo+J6sNilulDzjQ+qzwk5DvSPcyDhv8WvmdwxWqD7FwX0tn1k31sBKKrgNpn87X8psX6lhayZF1VDMJl4DqozMcfIy4DJ99cVB08LywFuHr5XFRkMGFBnIq+RNK522bz+wjusXm0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5713.namprd13.prod.outlook.com (2603:10b6:510:114::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Fri, 16 Jun
 2023 13:10:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 13:10:11 +0000
Date: Fri, 16 Jun 2023 15:10:03 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Igor Russkikh <irusskikh@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] net: atlantic: fix ring buffer alignment
Message-ID: <ZIxfK1MVRL+1wDvq@corigine.com>
References: <20230616092645.3384103-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616092645.3384103-1-arnd@kernel.org>
X-ClientProxiedBy: AM3PR03CA0055.eurprd03.prod.outlook.com
 (2603:10a6:207:5::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: f036685f-fa13-4bd8-d1a5-08db6e6b0421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZNWteHQ8SFDSX774SIAw/G3o6esbma3tbCo4vb7nkjsM4EQwg/LtVGLZujSjDKOIogjL1VQVDsTtXkwaXczvEyxVc55cST/GWadF9C00SnT3BAxFWgD4wNtVVfDiDlQc9pow3lGAIH0B6/WmXrOl3YsxZTnXF1/3Bw8wlk3wtTbBhsHDOjLvcayv26zK9s/0kYKCQyZX3deCFda9lbfo590BoYv/iSABi7BJiCWFAgZaIzQVLnX1gAHFVD5FFM+ABFNB3JFrKv3Tddxfm3khgrtPXTdxkupLBGeUrcTKQmX4mg8qpMujFqBxQQxryjzA/mHIxuwcBKevFMc+zsG7MhAfaEY8G6xq05V4ziMGMltLPw7zllaIlRQen0oP9G3LsEJS8TJdJRsn4ApNkdF7fibCTQAiOQe/91eBrc+NRjC0i3xTdGdbpi2ptGZWB5RIgWsfVOTBR/Rousmuo/sv1L0M0iEqEcJQbUqVQTLZNIxxjnJybsIXGtoULl4CJ6LKzw8WaqSsMSZtMOpB7eLj+1zGFlPrvWMh3Jn/TAQfeS5gwgaJOOERq8CdnL1z5HRbzSy8kJsPf668uMX0QBvkysKm3eCNGgCoX6TFlIj54bQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(376002)(136003)(396003)(346002)(451199021)(44832011)(6512007)(186003)(83380400001)(7416002)(6506007)(38100700002)(54906003)(2906002)(2616005)(5660300002)(478600001)(6486002)(36756003)(66556008)(66946007)(6666004)(8936002)(316002)(6916009)(86362001)(8676002)(41300700001)(66476007)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2iccjbmPr0Qyt78gFY6BmlfTUMQlkNXaGzfas93YPDFy+ByW64UyJDt6A5d1?=
 =?us-ascii?Q?3c3wNIB+5iIzosZyNVFiuPKNS90kc4ovRLa7dlnbskFQ6W9fIaTQEtgV0X6l?=
 =?us-ascii?Q?Pkz/3+XMaq/JbWT9JVzLTFSpoU9yeWPXln7cajfbHcjJtNOD3nkLwjI0ATDA?=
 =?us-ascii?Q?HR809sZk07JPGrf7PRx7NM1tUTnJdxm8Nust+jcaBkNuZSsBbP2BQ1/wefH0?=
 =?us-ascii?Q?LQWhGOZP+EiuCcTbImX/zPhnyq6tMwOUjFf38+DGZYyyztMroN8MlHCy00qN?=
 =?us-ascii?Q?utg6KH2Vsj2G4RSfeG18cTE6j2Q46tfYgMOto+L0J8+w7PEr0AqPNDC3MR7a?=
 =?us-ascii?Q?3NhmICyhI2kDqGpmFNeFHIftHirmw/eInRxe4ikCfpC+ZERr917e66z+z10x?=
 =?us-ascii?Q?juWszvwVOf//QQkooagnGPdR29AFtWsmr43gz8oXkluxfkQ26e1a+yLKThn2?=
 =?us-ascii?Q?vB3VUZmO453J19yYwUpEiP1fVn8E6HyjeZdIhxLmuSiy01EkYLwnmdAFs+J5?=
 =?us-ascii?Q?puORD+vgpxSGmCk7h7IxF5bMtPHxHezb3YurvooMBluwe4uHdw12WCYRffDA?=
 =?us-ascii?Q?euliyblvXnfJ3UNljO3vzEVtNALTbApCWPKO1k8JvS79MB5DDcD5qHVnUIvR?=
 =?us-ascii?Q?yIAA/9Hd3GDPMez2trKi4WAVaGMRu1aqwGw6rtFcVSV7nT01LlYDlrwwRC05?=
 =?us-ascii?Q?5Y8bsO3UqNVmxuleE7qtkEYkZ9EXt3TjkXatIvN3Rpey8Vjj9UYCZarnt2O4?=
 =?us-ascii?Q?xI8/dZ05dTwC9XFdYjl8b82DdgkMZQMCR/MTVdregaeZEEEKLvElNQSTZy+Y?=
 =?us-ascii?Q?wOglDX617n42NIsMzlCLfPYvttrIRxqGcRH7ARx0a/FGm9dchVclELecjVbq?=
 =?us-ascii?Q?/BoBPBoEQlaOty0tBai9TI5JzBqX9NVcKUyoobwa+bvInjhsHMVpoK2os7+b?=
 =?us-ascii?Q?WBVTZbW0XnlZXKqgyqelKP/I7SEsifuWr6zmj0Htq/7nTy/xnOzNesccrg77?=
 =?us-ascii?Q?8NprQGNHXOonRECk4FRtz0/Ewj7L/ikGktyEePUe12WD/BiRkjNZ/+Xopm3d?=
 =?us-ascii?Q?1SNXpxhSFigtCmpdVCxCwnjSsTiJjYOHUJJT3fcjCmlyzB4yIqO7r5dKoIWt?=
 =?us-ascii?Q?BiY7qJiY6t18kQ8TA1TbH63jFTyHJCMDweAsMIy1ito2KMuTvpt1Dj3ZF5lX?=
 =?us-ascii?Q?HrNpxlmVmFhOg6tFjbPYW5FscY+Fe5b0uUydV1+HEXjrLWpid0753v8tCSQd?=
 =?us-ascii?Q?rMOe0GtFhmjeejQRlkJlG5voDyfG16VSfuovzZTg6CVclYgyZit/IHYrhpII?=
 =?us-ascii?Q?EbchQWiimvOjkzIiJb3FfplD8H05PMaM4/F9oW18xz1SLueLca/IFuBqb4DB?=
 =?us-ascii?Q?IxiKz5QNYKZDNOa4620KGd0MqbOkki6S3V1JaUbv/8YEA4XI8uM1ZylAzqAj?=
 =?us-ascii?Q?QLTVvIiNIHxAU4EYy+R2bymk3eWew7ZtlXhVTsiHlp0nrWEQMHQI0/L1pfIk?=
 =?us-ascii?Q?zf7vG312fVcOmkwTQmKqot2O4JfjzG3O/tgVcoMqIpWE59yZbzZuEXIOxCK7?=
 =?us-ascii?Q?mKwtCqUzULCpxpmnhiUF8+NBn7vyzu/10qHr2TepS057NYLVtHPQyxtJa49y?=
 =?us-ascii?Q?5HZACQV9l94sCyak3tC7WzQrKcsfQCcMm0SHAxM+RXToBJIklx0UEvf0ZYOq?=
 =?us-ascii?Q?xdDK1w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f036685f-fa13-4bd8-d1a5-08db6e6b0421
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:10:11.4430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qoK6BZlI/pp6a4KkkXxhW8I9iTJ3/2xfrPUpGJdPcNYrLVzFH0PGdmZgYcYZ0D2FgsRrOR16dI/FAvt9J1Vw5ktnp2T6m0iGyqOGoxl+vcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5713
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:26:32AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang warns about conflicting packing annotations:
> 
> drivers/net/ethernet/aquantia/atlantic/aq_ring.h:72:2: error: field  within 'struct aq_ring_buff_s' is less aligned than 'union aq_ring_buff_s::(anonymous at drivers/net/ethernet/aquantia/atlantic/aq_ring.h:72:2)' and is usually due to 'struct aq_ring_buff_s' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

FWIIW, I was able to reproduce this (warning) with clang-16 on ARM (32bit).
And I agree with the approach you have taken here.

> This was originally intended to ensure the structure fits exactly into
> 32 bytes on 64-bit architectures, but apparently never did, and instead
> just produced misaligned pointers as well as forcing byte-wise access
> on hardware without unaligned load/store instructions.
> 
> Update the comment to more closely reflect the layout and remove the
> broken __packed annotation.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../net/ethernet/aquantia/atlantic/aq_ring.h  | 26 +++++++++++--------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
> index 0a6c34438c1d0..a9cc5a1c4c479 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
> @@ -26,19 +26,23 @@ struct aq_rxpage {
>  	unsigned int pg_off;
>  };
>  
> -/*           TxC       SOP        DX         EOP
> - *         +----------+----------+----------+-----------
> - *   8bytes|len l3,l4 | pa       | pa       | pa
> - *         +----------+----------+----------+-----------
> - * 4/8bytes|len pkt   |len pkt   |          | skb
> - *         +----------+----------+----------+-----------
> - * 4/8bytes|is_gso    |len,flags |len       |len,is_eop
> - *         +----------+----------+----------+-----------
> +/*           TxC       SOP        DX         EOP	RX
> + *         +----------+----------+----------+----------+-------
> + *   8bytes|len l3,l4 | pa       | pa       | pa       | hash
> + *         +----------+----------+----------+----------+-------
> + * 4/8bytes|len pkt   |len pkt   |          | skb      | page
> + *         +----------+----------+----------+----------+-------
> + * 4/8bytes|is_gso    |len,flags |len       |len,is_eop| daddr
> + *         +----------+----------+----------+----------+-------
> + * 4/8bytes|          |          |          |          | order,pgoff
> + *         +----------+----------+----------+----------+-------
> + * 2bytes  |          |          |          |          | vlan_rx_tag
> + *         +----------+----------+----------+----------+-------
> + * 8bytes  +                   flags
> + *         +----------+----------+----------+----------+-------

Perhaps it just me.  But I do have trouble reconciling the description
above with the structure below. As such, my suggest would be to simply
delete it.

>   *
> - *  This aq_ring_buff_s doesn't have endianness dependency.
> - *  It is __packed for cache line optimizations.
>   */
> -struct __packed aq_ring_buff_s {
> +struct aq_ring_buff_s {
>  	union {
>  		/* RX/TX */
>  		dma_addr_t pa;

