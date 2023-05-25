Return-Path: <netdev+bounces-5262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09FB871073B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 872C1280F43
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B364C2C1;
	Thu, 25 May 2023 08:22:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771BEBE78
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:22:10 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2116.outbound.protection.outlook.com [40.107.93.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BBD122;
	Thu, 25 May 2023 01:22:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZy8cOhUDq6U/O78sl/gDQSWOgVH9PnL9nf88XNoghouRvppXUPWF1Cl4UC0kUXVffyEShMYavfHC6DPmh8w4nVDhr/g01EJVkmBacazVCAHjLVsTtJrZzyK0TesYfzeA7EiyrjlUGIH7TXA56FyRkaH4MMdptR0XQ14twQ+6kDmy80/2c9gKQ+masPd4+8i2elLigN9RguMnMtcK/L8HT0yLEBaThzZkqehK1RgsuuJJ+ac7GLXSzXZM30eVFezLNN7UQ0of+n/1OBVYfOPu+4TiaAXjSotlZuZtVrB/otuYVC1QX9dPvTzII+SWPnH7X81uYaCemAvcUrZYi8rCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ictSsFElEwFG1Uce2i2Ti+rbKqxeshZZfVdwqZIl6yI=;
 b=eZzgC/vPfMJyywR7qSbpTapgPwcJYxL2gLlGSqMbFrlweWr+RDi88k3/gzePMRv+TxhEIYlmrATFDM7UyTWV9C+1q7BNBI4EeFMh6powrVEomKMxz7EyQW88M5mndG6bWOsK1ByMrqb3k44mzLcUIateJYeyrl//8Ku4mVk1H36xVTEeY2VMlj9cB/BcrPkIjRXOZQ0c2AUJXg5GpWvj/pH746Zaa00hbLfvdkEzYUN5hCx6jU+I7t1ovBDvFqrgEZAgVDsIC39brkBVw9h2UqmJrQzt0lnpBjxrcvQf5ceXnlYdFXOWxicvLfiAwEIwmug1rs4azm7u3adZ+hiwsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ictSsFElEwFG1Uce2i2Ti+rbKqxeshZZfVdwqZIl6yI=;
 b=v8yETsw74w4PrqLLixbRz/vM3xMyhLm0Xda2Ql/ltrSS9duo6V1K5fslgeI139k84tbXeEj7YW0UohINeEPyxNUx207DXJyak4pPrMkWCZZ2ij1C+3fKio93b+3PoftX3JloT5oXHb5dzD11WxXOcOM1nWTJw7uCM4DQxwEos+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4931.namprd13.prod.outlook.com (2603:10b6:a03:365::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 08:22:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 08:22:05 +0000
Date: Thu, 25 May 2023 10:21:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <ZG8ao4SnUCyZO6jH@corigine.com>
References: <1684922230-24073-1-git-send-email-shradhagupta@linux.microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684922230-24073-1-git-send-email-shradhagupta@linux.microsoft.com>
X-ClientProxiedBy: AM0PR08CA0004.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4931:EE_
X-MS-Office365-Filtering-Correlation-Id: ed85cd04-50e3-4cb5-8e3f-08db5cf91f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5nd/AVRfJwYEyh9qBjpFnWsrJyI3rD5DSajFMH6d0NPJXcPC1sASzKtq2yiAJlTYxsf47HvWPjXJzjlBotdb3oLDOsLMsjmtbp+3hZmSM3Vd9LFQBM7maCJCgZZbqXZc3W1biCftlz9Vvz5/1gRmFAwwv73oknp+Dk74vIL1zKD+uGAGqHMCt01mZGxXJphsrTMgqVvh5PuRU6S8yP73YX1y61kSys47a/U0Wo3m1FW4d0ohTRPuxMR2Smj1P3yfvAdaaVjfLcYtRCVdsvBM+b/z1hb/rH504190e53sXmlrQqfKcjnkxvvB72FWK3V2SUpoqaf4cLjJg5TT1V10U7oIl5GcxiQxmTw8gmkpUP9wiaMSq0vwsuSNtg8mVMRYayXDpIBFYiYeh2r0NIIYJcmOTKLGpjV5a2AqQJAUaBQlP27N6S9qgXTAWPuuHXcSgluG/DscA/fZFnc9HwcDexJrf1rPy9htONeTFYLJ5jac98qnXOaPcekbFpOBOgz68VDAffqJcNv/mlS4krkqmfA45XpbR2XoX1zZDvh9KVoeUVzqR1LFULCkY73x5kwP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(136003)(396003)(39840400004)(451199021)(6666004)(6916009)(66946007)(4326008)(66556008)(38100700002)(66476007)(478600001)(54906003)(316002)(41300700001)(6486002)(86362001)(8676002)(5660300002)(8936002)(44832011)(7416002)(6512007)(6506007)(2906002)(186003)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tE1CNSsRRHuKnczWxu/KQnBg0BusoCPyq8+8Esh2UjUAzVkk594A0SRq/xEM?=
 =?us-ascii?Q?u22l2aXcclMN6JPqkPQfEJOv8GMqUfcXE9SnLuH5bpLLPInVlm9PefBo9/u2?=
 =?us-ascii?Q?2HVBjdmUSQsIXFSOnw0uZllNvkC9JlpkRpG4Lr7wQD7vRJHnNgBNxVU/Z5zF?=
 =?us-ascii?Q?tSybSKX9hi5I9MSR9A11j2qsr90mzy1jNJ3yhNU0JK3nhkSbjcacxHxobXqg?=
 =?us-ascii?Q?e9AXS4Fb9LCBS1QwXKF7CHI6tuQc1KT3Sf/9BFcr9fp5YKOA+qnZsUN8nwX3?=
 =?us-ascii?Q?gTT+MCfdYsrr2cmScwuqayrQlTUTRsDyxdjSI2GlopaBhVpkzqVqsfxgGIaN?=
 =?us-ascii?Q?oiOcOj277Wl8eDoEoZZ34IFXfGBD7/W6kZ0Uslj3jYUgH5TaZLxNYg4OIEsV?=
 =?us-ascii?Q?gSdBF5dwxRquk6aZA1r3lZDPdgUDtk4PWwyWcmN4e80foCtfnVQJLSJ5bXZs?=
 =?us-ascii?Q?kNU+0Xw7sbiwQMjOXRcVopP86EFq/hoGNr6QQjMmZ748F1MmdeNtdOqD/fS+?=
 =?us-ascii?Q?SqXK4qboumNRw4uW32nupMjIut1Q51BAZab9uN5b+T1JJ1Hpb/o7PViearT/?=
 =?us-ascii?Q?7VuaFhQ5ZWx8WATx3NWCQ/ZsqnLGZBkVW9N4VVtjGS3fmBkT3X1ol/PDWCaw?=
 =?us-ascii?Q?KOIYraDnml85PiVtESx3Y2NjqD6BQxMMHPvUcUdp9wMODeUk7ghr7EvuoVkw?=
 =?us-ascii?Q?wicFlkVAMT2FVZEGtrkigyrDF+YJKLwu33SRrUDoNVX6J9i+kzNtKP6mgiE3?=
 =?us-ascii?Q?NRfMQRgRMe0PdLoulBiz6lygw+xUqwiOw7a24OvJhuDm5T4aUEiS9BTmnYYI?=
 =?us-ascii?Q?2RoDJEpMsj4kL+rFFYEmPZl+CMkvHxJaaILpF0vLkOVf9w7cHEgP116xZbPJ?=
 =?us-ascii?Q?TCVdjJlbGIue8S5DsIUz0E9/6FvGsdZRj7M9l7WB7ZlddQNcSOBQlNgppTqx?=
 =?us-ascii?Q?BVdcgFJ+rliNMfejggr4tyoYL8IkwwNFZrJgy/syIuo7DlaCXQBxVd/OB2WP?=
 =?us-ascii?Q?+ykIn7ViJ8LhSZedvXz8KjijcEtH/H3LSpPHNYe0vJcRCShkmL/AXyXdP0ln?=
 =?us-ascii?Q?J9B+wtP9tkR0cI0L/9h2NhQlibyJC7SGvG+8UlR/iP/NDxI7wTnNrz9bWI9G?=
 =?us-ascii?Q?ZpAQV0BLop2yuLM2Zjh+7mrGdBSJkMY3VCggX57n8SIfd79SsFo06zmnp8yM?=
 =?us-ascii?Q?emD2+aXwh2sG8oSrnh+FRdwn4OWAzaXZqwt2PHNUNCzyZzc8Aw7K6hKOYz9q?=
 =?us-ascii?Q?Fv1rFUExbtUUW2QViNuZHgHZDSolGgmbQt2fPEfUuLCn/aUfrhHZUqc1fk1p?=
 =?us-ascii?Q?Kz5+GNVsEIAPZp/CNqvqdNUBEFoPIe0ZrZokcF81Jhq9sBJlNNJea3yComzb?=
 =?us-ascii?Q?yfOYHC3EAdhNNt48dwZ3NMWQHadnmh9DVXpb+7uUivJ063ujAbvfAuaC7c9X?=
 =?us-ascii?Q?2SYz92KS+f2j5TmkuyVud4Dxz/FC97aw+/0X9uzFvLtO/BK3kmKBlHJjuLjr?=
 =?us-ascii?Q?3sYSolPU89yr0J7MhmOraW5YHqtLytomgxjHNPuff3ftgK84nulNzvy2tWK4?=
 =?us-ascii?Q?GzWnAJ0IedjopDUQrV7Ehm24O+LSC9Rg7McUkxvmT1ndRIlzQZIyAcrhd5yq?=
 =?us-ascii?Q?HIa68JGJkmlzDDXzs5/zog/ixMljAX/jXjB5iInENEBFM1nF95a89Qxmkzdj?=
 =?us-ascii?Q?TVO/Ww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed85cd04-50e3-4cb5-8e3f-08db5cf91f9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:22:05.1487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKgoiYr4W5Q+Ub0Bw0KTB07vvIH8TspRWhQvHX//hy0CUEXxbvYcUjyy97a6k4nIb3FI+H3G3O1VZMHi6eJztG/OqlvPFUCrqr4W1d+Zl70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4931
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:57:10AM -0700, Shradha Gupta wrote:
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>

Hi Shradha,

thanks for your patch.

Some nits from my side.
And some friendly advice: please consider using checkpatch

...

> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 0103ff914024..ab791e4ca63c 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -1040,6 +1040,13 @@ static int netvsc_detach(struct net_device *ndev,
>  
>  	rndis_filter_device_remove(hdev, nvdev);
>  
> +	/* 
> +	 * Free the rx indirection table and reset the table size to 0.
> +	 * With the netvsc_attach call it will get allocated again.
> +	 */

nit: In Networking code multi-line comments look like this:

	/* Free the rx indirection table and reset the table size to 0.
	 * With the netvsc_attach call it will get allocated again.
	 */

> +	ndev_ctx->rx_table_sz = 0;
> +	kfree(ndev_ctx->rx_table);
> +
>  	return 0;
>  }
>  

...

> @@ -1548,6 +1548,20 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>  	if (ret || rsscap.num_recv_que < 2)
>  		goto out;
>  
> +	if (rsscap.num_indirect_tabent &&
> +	    rsscap.num_indirect_tabent <= ITAB_NUM_MAX)
> +		ndc->rx_table_sz = rsscap.num_indirect_tabent;
> +	else
> +		ndc->rx_table_sz = ITAB_NUM;
> +
> +	ndc->rx_table = kzalloc(sizeof(u16) * ndc->rx_table_sz,
> +				GFP_KERNEL);

nit: kcalloc seems appropriate here.

> +	if (!ndc->rx_table) {
> +		netdev_err(net, "Error in allocating rx indirection table of size %d\n",
> +				ndc->rx_table_sz);

nit: No need to log memory allocation errors, the mm core does that.

     Also, the alignment of the line above should match of the opening '('
     of the preceding line.

	f(a,
	  b);

> +		goto out;
> +	}
> +
>  	/* This guarantees that num_possible_rss_qs <= num_online_cpus */
>  	num_possible_rss_qs = min_t(u32, num_online_cpus(),

