Return-Path: <netdev+bounces-2175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E57700A20
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71F0F281B43
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F9E1EA66;
	Fri, 12 May 2023 14:17:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA23BE4E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:17:24 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2110.outbound.protection.outlook.com [40.107.93.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC0813860
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:16:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeTgh/LkzT9m/bflkEw+2GMafo3ivq81Tw/Firx2D0PDunBzHQ8yCd+5UqiutY8qM5Ol59lpPFIl0lK4DHcs2mNqUr6whlfOToE7gBhFlSfcB9+iRM3LLnLKdyGrdL7BgxVXZzyH/IGvXqcoCvWo4ZsZmzWSLSrVpxPsFgxs+6LlJ3UL5008u1fsuYnlQit92LpOZTSgqPwRCizOETumZJwP0bZy+oPJpbX031ZCwNKRpW/MMxLnCgRMNaduzhmsAS/X2BH2ubREZBlOf+a0KncHLdIDzOYv91nfbkSHiwii3tsINLazg/aW5ziPhvSxu3JFnaYsY2qpnIgVQewjWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bN/XMt2N+Urd7uTo1cNe0LvMOJdakouzjZhHjUx4zwo=;
 b=WdM6CoQUaoPsvK/n5r+e/YQD3fr12Zlrez3l5kubjgMiuTxg8Tq8fBix3fIBCHBxVSOnwsgjgD1wm8kTYhLvFnWExBT2IZT/t8rw8CsT+Eg64lLciII3fPPfn/1/DIwNVXXkCGMIpwF2mNcdmXe6cXhpQJHRJLhTYu5/S+C4gI2TR7rLjazg/o2a+l1LdKwQAFv/m15lZUDfoDIaVShjfmTH/CcTNYcMpxVn0tTHVxXbjHx8nOuBnKUQsY/18I1Vc1l6n+UwIytk5wp6T5DNrrIWloBNb6D6CvTSDakKrkjZntENxfBCkxaCZXZlLeUOqCcBgfzkH2A1dLIKOGBQ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bN/XMt2N+Urd7uTo1cNe0LvMOJdakouzjZhHjUx4zwo=;
 b=U84NUIA8uyAmc7UyHKWD1dEyagGax3DsSjDL/ZkS8Cfx0rPQrAiQV0KzFpgo5NaLfAaEHlVl0NODth+voG/2hVtr4FafNkLGmlIoyIKrpU8yDACZHwRtjeSmaxKANkId+UUbqBHEEYKGUObIRIyFEUILuoH6N6lM+4r+1EriIDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6476.namprd13.prod.outlook.com (2603:10b6:a03:55d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 14:16:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 14:16:36 +0000
Date: Fri, 12 May 2023 16:16:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v4 1/7] net: wangxun: libwx add tx offload
 functions
Message-ID: <ZF5KPjbVHtSpvH2x@corigine.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-2-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510093845.47446-2-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AM0PR04CA0132.eurprd04.prod.outlook.com
 (2603:10a6:208:55::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: ca8d00ba-cfa3-4ed5-cc2b-08db52f37eb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VbWnSjoaB/nLyHYolFX1ALzIGx4uMT0glQnyceLkXOxVDrJih13P5056S7SQ3pQ+B8D1WV4dWnbrb4iy/Nz5co3IwdCYj7+Lls5rQ3wv0ZXmeC2DtnngmVGDd20yze1VSpylxncWpDg94cPPE2vWu7mhtRBFQvekmX6pq3Og/BXwk7GrDv0DSIgtaV41B8bqtjD/BqhU396cchlanOVQtlMAOQ0lCiNlm0OCoQnnSZ8nAKpjJDgP+6ovh3SsYdcr+LkymqToev6feTu8Mt/uZ+FbaFEb59giWpywE1vgWzj/dU3Fgg1/wh2vvrFwbWDlSEa+ANvvZ6c4MkN2nIKW2JEgi2xDW873qWJs53NgCzB+5gnwoxFxyIDZ/dnE8KnEwtKN/qjDrNY5lBDds8ZXyuWl8isN2FyYKcRYI3uo92CYZX+XnkPqmCPRF7t3KmgSzAwJiLyQt32oA+3gRvF7EUy3vDydntK+6N+Ilc33Kk0N39kMuqGtYRr5yTUtIRt8O+lW90HL0vkTcCRg5XpPrx2Wx6Okd48LeJyBuXG8RU4JDPXH6yldpLvzMqflwkrf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199021)(38100700002)(86362001)(36756003)(41300700001)(4326008)(316002)(186003)(44832011)(8676002)(6506007)(6512007)(5660300002)(6916009)(2906002)(8936002)(2616005)(66556008)(66946007)(6666004)(478600001)(66476007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lNFVu9nOngzqiAsRadErJlAkIiphnH0+t145j4y+P5kMu44/SJIDNx598ujq?=
 =?us-ascii?Q?+XlYFnMQhaqh+N+vF/XbIZ3wPyv3MgBJwts//TaGu/TSin+ttr+AB1LukNUB?=
 =?us-ascii?Q?WtBOPiK4T3FyefCGl2sLH67tdOZDOOjPkCurSpIKMkX6d8s3z++CDFM89bd+?=
 =?us-ascii?Q?SVlKz1zcWTCrM+HOauwpaiuck6lQkOz5yzCeK6OGYX+l2wocTL8aYxIuCStd?=
 =?us-ascii?Q?qhH4eRYC2o1vejMgjxN3VKldlIp7CD1H38kPVY1op6moOBRBvM62KOUx7g/d?=
 =?us-ascii?Q?yJ+nCpNN3hMwL+f0WcsExkLPSuYGDl+umBxAeKVeVxz0FaxLgg8tiPGAQBF6?=
 =?us-ascii?Q?dfGXoQNPKdNBFVQcUSa5TqRjJ4nrEjOuhE+67GdyEdKFYGUHo4hg+vJNBOYX?=
 =?us-ascii?Q?IlE7ppFR8McgOczsCQvr/hwiiLBPh9g/iR0A4wLLspi2M38yy/q5Z/mtUDVl?=
 =?us-ascii?Q?k03MN47pgQkc421LYVbWdQ2Glt1Mlb9A3HP97S06dSj8DP4kCwiFRbZSCc9t?=
 =?us-ascii?Q?b6kBCs91LRmreX8iKo7aId1CwPe15IHQ90J9AiUaMWrExBbtt/Zsu9tqnM7A?=
 =?us-ascii?Q?hpHdfBm76gbbhletbn0fucMujL/sEJ9BANn/kR/37v1iuENGJPQyN8hlbWXk?=
 =?us-ascii?Q?ABm6G0cIy9VobR6XQfVOI8ESUSudsjM+zGCNVSgYmEC4rTKR8C+t1B2SV4dO?=
 =?us-ascii?Q?zkBinHbIo8dTLfTo2sj60/Flovq96B0gHCHedeHxkOUDOYeqHHOppz0xiba3?=
 =?us-ascii?Q?k8frKrMRAj+LF1O6YsQiZkFgBaVqGzrVYduKqiOLwnfGqLap6e5hDXghFtx4?=
 =?us-ascii?Q?Iff63vkX3wBHXg+Up0rWMQuJzeKaK0Y8F9645L7NrXhHZJ+yKwpVQKUQrNmh?=
 =?us-ascii?Q?sqdgdBy+NyeYXGGgfkCZVg8SYOQk36T8VN9Pbu4sg+Vl9RUxvEeXhYsv3r6r?=
 =?us-ascii?Q?W5qAqbRchOoJLx7T5F+fc6odj75SDfKbdpOz84G0PRFT0cHzDKPOs+1GzI4z?=
 =?us-ascii?Q?/CTzfB2XB88VxSCDL3zWcMx6nf/hKLPuHO53tU62OwSxFXyb/54NwvzPmlCF?=
 =?us-ascii?Q?iroRMQpAX3RwghIguDyuhINws/94Xabf9eQowLkOBiQ2xujVaUKy90EngKGd?=
 =?us-ascii?Q?YESH9N1uXGFPOhf0nRK5DY8UyWI5w79dcnp738WZX0qmu1fxwnN+v0bXhFxg?=
 =?us-ascii?Q?JIGKo77cQBGaSeCNCJyIWuYyv/HwZY0tiYHMVClUye+XpQ73UX0aT93k9ejt?=
 =?us-ascii?Q?vjBIIXJS2n0tn5oZ4POQTOwe5AZcwSnvR4ztZZWf64KYEZWp36cydylh9TUO?=
 =?us-ascii?Q?GzvgJej4UaRkWfC6YIqfl8GmaoaskiExTerzcJaYqPUmA07hesvak1hH1tgf?=
 =?us-ascii?Q?LqBZRm1aS/FIDaEF8b/poLCdZNeanoX5XHEjlJTgJ1ISDnRYlJCASSZxTN7M?=
 =?us-ascii?Q?KLRV/SVIg7/ADWPcFyRQABp9Rz0FR6fd0dVccezyXY4Q3gQoJI7WZlv6SDuY?=
 =?us-ascii?Q?qron31Upk9tXR5rj399v+XlIDU2LRwPqJQyHhp3sdBmCLKFahDEmqPTZU9+F?=
 =?us-ascii?Q?TSHhjXCmFsHZurhuhR/GZTXYLHx275FgA3uFhoyZPI6exJLNrlOPZAnI1rWD?=
 =?us-ascii?Q?b/OBDL8YgFNRspc1VqdfQpKeO5GRmzf4TYaDT60AEL+phNZJBd5BC2bEj6gZ?=
 =?us-ascii?Q?hsN8YA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8d00ba-cfa3-4ed5-cc2b-08db52f37eb8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 14:16:36.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnPZ2IgOQHDwvKQC7lIBh4T8sh5TrBit6UhARo78CHR/vC+rBuTtkV/gMenZiSQpqj8uG8s33plcXgvEZVBtHBSYnyHFH4Zre3/Z3Eyk7ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6476
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 05:38:39PM +0800, Mengyuan Lou wrote:
> Add tx offload functions for wx_xmit_frame_ring which
> includes wx_encode_tx_desc_ptype, wx_tso and wx_tx_csum.
> which supports ngbe and txgbe to implement tx offload
> function.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

...

> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index 32f952d93009..70f5fd168e40 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -6,6 +6,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/netdevice.h>
> +#include <net/ip.h>
>  
>  #define WX_NCSI_SUP                             0x8000
>  #define WX_NCSI_MASK                            0x8000
> @@ -315,9 +316,6 @@
>  #define TXD_USE_COUNT(S)     DIV_ROUND_UP((S), WX_MAX_DATA_PER_TXD)
>  #define DESC_NEEDED          (MAX_SKB_FRAGS + 4)
>  
> -/* Ether Types */
> -#define WX_ETH_P_CNM                 0x22E7
> -
>  #define WX_CFG_PORT_ST               0x14404
>  
>  /******************* Receive Descriptor bit definitions **********************/

nit: this comment is not in Kernel doc format, so it should not start with /**

