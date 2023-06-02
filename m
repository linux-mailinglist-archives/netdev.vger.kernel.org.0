Return-Path: <netdev+bounces-7379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 864B771FF61
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 107691C20D83
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D355255;
	Fri,  2 Jun 2023 10:33:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D975243
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:33:36 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2073.outbound.protection.outlook.com [40.107.105.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1306819B1;
	Fri,  2 Jun 2023 03:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUhscyZzPcSur0UKeZm/Ei4ltv2Z6ZjGry/LI+E5sUyw1KiR3EcCocvQSHAd7zUYvje5kJP9GN24HFMO2zXs0zqrnU66i+41AI+WLSwhSRTftaCT1uER4tr9WvjIS/XCk9OI7TuzRQUl5f+yKgSGpW9dsLopvufSP/YN482KZV8VLggSogYUWte24KQ7AK20YA5QNJ/lBAx/6Uasnz2zTVlkc5onxSwrCM2pFhEKOGM95muwSufupRsMGJ3/8Ki4vwNDAtD6frNs8tKxAqnqw8tplFOZis9TTcP1qJdUIMgjZRffVsIXVjKhrlvOI1ygbYxG0ebn7nt7lPOVkdAZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWhAzx6e62j5U77nvmt9CfHklLCm36tbD++vVk7tqaA=;
 b=XDP5unsqmXC27f5l3BuvOFGJMQsUehXhLc/qEcBXaI7N8LfrYi/rsms8QLPgGLfJDx5pKKKqrFw++HvwIISgv2uIGpFM1+GhccJYUqhz/Hbx+sO2WoqEcmST2i9QTiFbQ03EuRNCGRmHO/tq9Uzh9kEo6vUGN8epl5eaTHj6vGOOTtq3v3ODnksiugEU+4921QEWFBHlmJQdOma9aUweuvMhU7Ngw/kyBiGEavIF6gYTaJwRs1GL1ToHYp44xn78vN9VbN68plYs8KEgLWdFJtFaleUJk/PpuM7EKOZyWyh6V5lrqr5b0YvemgIkkMlDlj3zqjOi3cFX3vfc5rst+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWhAzx6e62j5U77nvmt9CfHklLCm36tbD++vVk7tqaA=;
 b=UoPA8SoCW75X0seM2B5te4OW8tiolR07eSKC+op8RPr03q8w2Z8S43hK/bbU49gC4E30aGf5sxzu+M4Y0Dqowdtsgxs4PsnPM9C0fvcrE2WCUF3j+D/Lv7g/lL29L8oKMXo3l/JwXEUcIe/nnzhlSm5cmZFqkKhuGGXIagATwzE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7502.eurprd04.prod.outlook.com (2603:10a6:102:ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Fri, 2 Jun
 2023 10:31:46 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:31:46 +0000
Date: Fri, 2 Jun 2023 13:31:42 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: wei.fang@nxp.com
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: enetc: correct the statistics of rx bytes
Message-ID: <20230602103142.ryesgb7ykamtzxnx@skbuf>
References: <20230602094659.965523-1-wei.fang@nxp.com>
 <20230602094659.965523-2-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602094659.965523-2-wei.fang@nxp.com>
X-ClientProxiedBy: BE1P281CA0310.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:85::16) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: cb22fe5b-30f6-4f6d-0d4c-08db635490ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vn8KwAqdZ331LJT1YklbrjihPmT3jWK3pYh2MzzBEXTVB2NJrwhNpI1RpsEOsQAJHVepf1E3WZkJllSd1fG+niXD8FYWqONCkLnCV3ysV2o2Y35V65kTMvTF86zhgaYpcUT8AEaFSpGXJeGrDf7ThOWdlyeDhYZGAo5UpVGv4CaFzNibBhRovI3R8r/i6b146IoC4tG77X7q/9R4qtNxgVSrnJS7SfJYwrg+5ekLVpJA6gOyWwCx4rKrwMI7dqDCTCnI9SlsXg6+vRfU6bk9GESTfg0bHh+3ScbfJHoN8ukBrj0FG8A3NUqVlhnt0bRfp3g1yUTfia0N7NwoJONes94meRCPVb162cuxjQK1TvjhZdCv+N1L6utS/0wXcTGpPKeZUjGF4Msl804hPBjTgsQcrsUWf7xharkSF9vZQreWpJW6NNei7A9+7QSrAYTQjhUJEPIaU7SGRiofMmTH+hQaUZs+hu4DoAkLGX5hxXVuw6XjLbHtZaDPp6z3PjQyxncJGobBgLDNg75p1NQuoQGCss7HS48yZmQnes4cZ7eLyBDIa6NFflqB3E7N50uP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(86362001)(7416002)(5660300002)(6666004)(6636002)(4326008)(66946007)(66556008)(66476007)(33716001)(8676002)(38100700002)(41300700001)(316002)(6486002)(8936002)(34206002)(6512007)(44832011)(2906002)(4744005)(6506007)(186003)(478600001)(9686003)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dK2idyzXApJtUuANMEEwOHrR2gt3VUp0mO0a4ziY37zqiMrEZNJlRkPlJkpi?=
 =?us-ascii?Q?4jD31vgs9+g+TG4Rttjngq+zh4DY99krSr0dFa3Az2/Vr5+w2vucDuKlTDAD?=
 =?us-ascii?Q?LhgQeXAXWRhqeSq3CQr72VNcUuhuWQqeuQeGTOExTp/1hGx/CqNJSLP1NfVH?=
 =?us-ascii?Q?Hpl/xiZNtPyr5z8XzYO15nXKSuUmu4XnozCvCILMEO0zD5EJkd7Vcuq7bPx/?=
 =?us-ascii?Q?IQP3ePAnMq3IliITOpC/u7hqXQOoNs6p0XCxtHHPW6Hnb4xo1t3ucESj3Dqk?=
 =?us-ascii?Q?ImYRkXnEAbZcfcI7ZtlzLhHtXsxY3ISpXgDP9oH0lxAGgXLyzJ+6z3G3yf7H?=
 =?us-ascii?Q?1gsHsfNRZbFnGBSC/ZNaXtbyP5Mq7XhC8p8QKAiqJ8Nr+K+MGUc1DBqIt104?=
 =?us-ascii?Q?q9QnzNJm5YAwVd9gTWx2pZV3+HXcsCvyIkmpcZHjYcDYtjQYoQZoJnHEAlhj?=
 =?us-ascii?Q?zdRVJWQzgTlL+JO4w8KBSoqFr2NY+xVwzyRNWjphQkisumdF9nEAG8w+R3kw?=
 =?us-ascii?Q?irKBjcRkacMfyVsZuklemsFVNmvgsQxIpg+HXLv04pbbxlMeEtk3xuJK+gnJ?=
 =?us-ascii?Q?j5MfgzDnrNZaF1SsnKY4dD+y9cMnvi6QP19j5XgW+6PuTMtXCQJbJDjc/cc1?=
 =?us-ascii?Q?hjyeDxXlxXw9MZtpzbh1QBbCCpXzBf4nBQf0fmEDvGHkNNp9iHvA6uiPeFIK?=
 =?us-ascii?Q?du1hvzCd0xwAwn34OGqt0YwW1feSzR2D5192Xg9J+0bbz+vdmgD0Yr4gwby2?=
 =?us-ascii?Q?N8A79AlnnpFZe8ez55Wc3mUDIE/VinJWLtH/nWvQIzrK26ETmGZQC0S/pHVm?=
 =?us-ascii?Q?VNxrjKgvJOdaurK+AqMtTMtB7eHFz/f97bWJJttydWvCxyKNrClkVsm31j9O?=
 =?us-ascii?Q?aEJdONTu3NTV2wEK96bQF2Sur0m/+3VhCWDTWLJtHQ1qa8UApLrS8RAXwjYN?=
 =?us-ascii?Q?DKv34XPxVGiZFdltgEgKDRmScRQZQKJHQcWYCed9pV7LZMztzYHXs4B1P2oU?=
 =?us-ascii?Q?yfily4ca4WPCPXWt17XoaLtJYZTNNaCCD8Mg45sPkrTCrGj0R4dGmHGdWAG4?=
 =?us-ascii?Q?D3DoVzaSp87LnGLkV9mm5depueveA2qfx14Jl21F6xkCU0yM/Lu6Tg1wlczl?=
 =?us-ascii?Q?LpJgqlmlGjwaqkzSgg8+Yvfv9hWVDNHJHg+vclKEzaBT92SNPxBwGA084GIA?=
 =?us-ascii?Q?EIbPvc7Nkga1kq39MY+ZbxLm01df9Qb3JfUSKMNTm422Yf05N79izaF2kOjx?=
 =?us-ascii?Q?17wbLEJ7iI6++9Zeit1L0mlKal3xPDou03bbfhYdvPmg53kRXYV4D5CFdkvM?=
 =?us-ascii?Q?Tt7qrkiE+o3FpPHho7/OSrT41thHuac+IIiK4bKQfX9LTAxGn2EW8equ6e+o?=
 =?us-ascii?Q?Ig4Df1goAORtxaViVdmm1NgBEIobfEp3LohX61M23/rJp81f1mf7Ce8Qorvi?=
 =?us-ascii?Q?DLA9KJYeyAjG1Svy5ivSRV7dJuJM8IQ+hPdA8hsKIKa2iQu2PSuu0BZ+t/Wg?=
 =?us-ascii?Q?16aQ/hMY24y0PoEn7v4z9pkyETBVhZeW5gEh4R6hRwT8wyRAPlR3jfSFbu42?=
 =?us-ascii?Q?QoVT0ySD8f0csXNfmht6jhm+BR/nA1NqHAc6R0ey5n5NAj5hsyBGs2muQ4wf?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb22fe5b-30f6-4f6d-0d4c-08db635490ac
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:31:46.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8S4SQb+4N/KU2Wj7sFTX+XAo6U8EY2AWjk6ZSUst+Jrd2jZEE/eDvAVDXn6VOi9lMtf/tdN63LoZtRtDeuuo4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7502
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 05:46:58PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The rx_bytes of struct net_device_stats should count the length of
> ethernet frames excluding the FCS. However, there are two problems
> with the rx_bytes statistics of the current enetc driver. one is
> that the length of VLAN header is not counted if the VLAN extraction
> feature is enabled. The other is that the length of L2 header is not
> counted, because eth_type_trans() is invoked before updating rx_bytes
> which will subtract the length of L2 header from skb->len.
> BTW, the rx_bytes statistics of XDP path also have similar problem,
> I will fix it in another patch.
> 
> Fixes: a800abd3ecb9 ("net: enetc: move skb creation into enetc_build_skb")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

By the way, you mangled Jakub's email (kuba@kernel.or) - I've fixed it up.

