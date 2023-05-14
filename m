Return-Path: <netdev+bounces-2414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71088701C57
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 10:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7956F1C209C4
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 08:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F36F111F;
	Sun, 14 May 2023 08:35:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F2DED1
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 08:35:55 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159E11FFA;
	Sun, 14 May 2023 01:35:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mid18gX1s4Y2RhZS2wwCxj9Phpi0ZnjEoDuddNB6wgaDMSoY9VF6jydryo4jysP2YKkk+g2YMxdqELPRjhkIpF8GyDAtEuleV8g2D7GYQ6frjxoq/lrnVLFjmNkvFpbLus9uPWsOkv/rd7vui0bic7WWRmHjdVnVI5TMZ/o8bvCGelgNFoVUNuCQYtn/Uv8xGVj5/2jxLKKc8UlfubiIH+kccGYAnNhOWpdjb232q0YgrzjkRzn0akfNiLQRH1JkAHPSE4eElvG/iocy9d5SN9FMNnojLwFhLCKSUgEtVVQkuRg6gEO101N3h/drvFbe/Kxy3Rf71OTLD397Sc/AbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0dBqD3QIvu/zQ+qOlQYRp1T7kUkJdpYBRL1751J6T0=;
 b=QlnZo/Sjp8PFkJqn5xd4TrkZ4ztoYlhuIuNecdfyO2xAuyINetrc7y4jz6VqNUTJbv1DWD63cDIqr3XwErRvAK/wr+Y8wm6IQHxtbU94/U1V4mepG5vadYF8v2RfjpJla4gWXPoKLQe/AYlP4sUIAgXbTiNxnaMmilD1ZVejtn/mV/HnQl5iY/85hoBK6xkoQiiCd1K1dkZ/Slbdk4sTzfN6SewVBp98VWAj00tksrrOF/PGTi48tOCL5wTjKXohhozfGUxHsqjFzaAS1VeGyy3QA6ia/fripwCeFvFoH0gcx8RcTL9ABC9WrVirF6mzFn1qQNMKNQt1yzOFvj7sgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0dBqD3QIvu/zQ+qOlQYRp1T7kUkJdpYBRL1751J6T0=;
 b=iSUk9dkvtpLWZAhtfD38rOOhx915ep9Ch3mQ4W7UmXV9QidOePOFkKOBCbtxC0vEEtedPa7r2Hp9QpotF1OOpmUC7++0xuOdk32s7Yw4VyKbxFxt34f0EwiZbEsVXan11BnP24jnWIOpTMQqD5v4SBdirhQk9N1LRJzOWyZA+xM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3736.namprd13.prod.outlook.com (2603:10b6:610:92::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Sun, 14 May
 2023 08:35:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.029; Sun, 14 May 2023
 08:35:50 +0000
Date: Sun, 14 May 2023 10:35:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Thierry Escande <thierry.escande@collabora.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfx: llcp: fix possible use of uninitialized variable in
 nfc_llcp_send_connect()
Message-ID: <ZGCdYF7rfDO7V7mH@corigine.com>
References: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AM9P195CA0020.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3736:EE_
X-MS-Office365-Filtering-Correlation-Id: 378c8b38-2f40-43a8-e885-08db545638c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CIA3RjJp7Mgbit43CBkyN0xfgXcI3zccPSu3hPiB+av5E1+AByIhtEPpcaqPJY5akFQi8DqF7cLNAa/YAPw7vmpdGitTCHYWtNegignUsGVxPETTxdt/gAVpNi2FgprItK9Xg2pMZohYElND6SfLV/xdzkxI19aWSvGPnGw2Dc6vcyd9J6n6bv2sIS0amelsKecLSBfNo4DwoeSTf+7u1qKU7WJFcqfMJHRXzlQy1Nsm963sYcv1OGQbACo1KLqMowMUapvSbwVC/FgjXDJmEhK2ZHcEI8FspBSc13JR6ZveDU1/N2MNR4t9XEFPk+3JlIaEBiO8GlptVQajK8u6rFX014fKD8IqDVAJnHBAZ7mJa+R09ses/jlS6dtrglMJEmGkgy5EDZ9foXVkmJL4VY54G3ncVFu8cSkNeqcj0W4HCtBZ1eSLntzkSduTW8QlECBz4dqGn3LdnB6UQQGvozwAvTPLCh3VKxHXpKoPaCJNkE4im0IhxG++WbqQNyiy4iZSVGHAFdObXw28GMl5nREpEmHxTmTVU/kn3Klr2DJCxtti1/fNrfDAAJ4d1400
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(346002)(39830400003)(396003)(451199021)(38100700002)(2616005)(186003)(6512007)(83380400001)(2906002)(6506007)(5660300002)(41300700001)(44832011)(8676002)(8936002)(36756003)(6486002)(478600001)(6666004)(66476007)(66556008)(66946007)(54906003)(316002)(4326008)(6916009)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6TtexfoMf2mSG2zIkCsj62Y4tSKnROttkWykQBlWCZojqB6sKvCzqiMOCVIg?=
 =?us-ascii?Q?GDZk76opeqKflzQIBnTxq77MK+7ClpstYsUhbhjGJUMeJRN14DJ/0q39L0Sy?=
 =?us-ascii?Q?GHMtFnb+xZ/gve/fJWlmbzlSoWkdt8N2xf4roL35wuY6BlD2XOb4s1NGo07i?=
 =?us-ascii?Q?CMhQ8rIj1HZE+L49SDXMjpoB2xCWC4m1QoiQmu8Pg9DHA1tSkuinGPqgQ5Lc?=
 =?us-ascii?Q?cP47gGLTkdj4ASrz1MdkuxHDWt5b+g0nNeWycDeV7uJw/VDVBCRS+KHm4fYk?=
 =?us-ascii?Q?DoKLJVjQhzpLk9wU9QDoBcah+h8BvZRGlSuht9KEx41Y8+3i+CBh6gXgLgIx?=
 =?us-ascii?Q?uHvxNAQdyLXR3QPFI9B0z/HMLg1Fm+ync5jt74+0HuOZeDDdMRoaXOLusjr+?=
 =?us-ascii?Q?M8dYT1h4r951y21SUf83Lnr2hpM5iOm4BYQ5lW+AbCSTySH6Nizfrgcdx0bY?=
 =?us-ascii?Q?5FDwq4yBcsBjdgeiTr38E1PI+Ut9x6Mrt9AWsWjHTtI1msMjwy34Y3AG8+P3?=
 =?us-ascii?Q?gfrR+9gx5vZvRsxc9JHx/RUMnlqAl2gNbyq5UzdZtippBatSQis1WHpKld8p?=
 =?us-ascii?Q?Puz4GyEMTwnhuuAKAHh50YvF5kLSKYmQ4rnSYGWz20kmAeZfaUS4ib5fuU2Q?=
 =?us-ascii?Q?j1FqTX/OLKpXB5GQpEl9ykEQr4LN1ye/ov8WopHFUr/rP3y66TBng+uT78qM?=
 =?us-ascii?Q?EEqXOGDJw6kqyedXKliXBUw9VW34+SOqegoPb7HxYlMJvgRiiBtSwI9gnvbB?=
 =?us-ascii?Q?OdO5MRA94Hsqb8tgWj3mAaia3JoTojSkISL5R3u1+Gu+SQ3BLYGQckT9Al/W?=
 =?us-ascii?Q?BlIVW4QQOen/GQBv3j3fLBZpJUgODmOKB3ZrGbLgD061R77yOhJB4t9z00Hv?=
 =?us-ascii?Q?Ag+54IiXFdc3q0MpAZ0P5pjXLCmagCNuS8h4S70O/c4GV0v5kqbJBAegW1VH?=
 =?us-ascii?Q?2k+fyMolZAYfagOD6ofQ5mtRVVIaTPBn5kfahtVjOLTvFwIYy2BK6fPJbOf8?=
 =?us-ascii?Q?8ZhwGthOX4b4SnntZQupk1cqrjL/qdqSriaZr2BBtR27U/AVnkmenN16G2lr?=
 =?us-ascii?Q?0b+yMYG+2cI9vKCCf3qq+ryWMQ4Whs+MaYRrifKsxZucB41MQX8u9F4rttB1?=
 =?us-ascii?Q?Qu2Xdn3Kmf0HNvE0iLJ3vyixr5yCPHDgIZZJWwkDb9GjTrSjwo87r1RZaZrC?=
 =?us-ascii?Q?23/MTM46t6+Wx3rD3QqL7fQvfDTgUNlqN9D9GPrwUPDrOGpjpYoYFi4QBogg?=
 =?us-ascii?Q?cppuwOwYS4tcXZH3ga2p/qDdyS4JKNTYTL9z0Yga31VTtBmU7QYK8vQiWfX8?=
 =?us-ascii?Q?tqDh155xmdXxRVKyHA8hpqrgnK5GjENpv5lYxpfOrM4+fzc1rofpLmZehg4k?=
 =?us-ascii?Q?r4evdCCx9I/neoVUcQju/021b0/21zbVwLNJgntDWg19oDwASyEiB5utGWrT?=
 =?us-ascii?Q?segM8DWEK5kzWoKyBnHlS7PzA1ci5LhtNVxAbOOhcWLQBWvnprv0g6q4ImNN?=
 =?us-ascii?Q?/fU1ZQyItynXXelOd6g6ejlrT7fMdFHyziXWbpHowRZ8ligze6+hay8vkm9a?=
 =?us-ascii?Q?ANO+DN25XWbSMh5swpc2bcb+kzCcTd3Xwh0eVOEx8jk+1wo/6owwz3k1zjXN?=
 =?us-ascii?Q?bcMyHJiwKn16IjUo/E64J9HSJuemfwKswhhiTbutqgVBDsMPHFwnjIi/AFaq?=
 =?us-ascii?Q?9mHatw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378c8b38-2f40-43a8-e885-08db545638c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2023 08:35:50.1091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2yDHUjhI2iC1LUjPI9PZYLc5DKUKrSZKE6W8IiThnrLW0yv/Rn2eoC5thKqyziDALDPKwAOiDrS4XnwY/SuwPM6Amzcd1YuBG4wcAf5mS5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3736
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 01:49:38PM +0200, Krzysztof Kozlowski wrote:
> If sock->service_name is NULL, the local variable
> service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
> later leading to using value frmo the stack.  Smatch warning:
> 
>   net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.
> 
> Fixes: de9e5aeb4f40 ("NFC: llcp: Fix usage of llcp_add_tlv()")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  net/nfc/llcp_commands.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index 41e3a20c8935..cdb001de0692 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -390,7 +390,8 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
>  	const u8 *service_name_tlv = NULL;
>  	const u8 *miux_tlv = NULL;
>  	const u8 *rw_tlv = NULL;
> -	u8 service_name_tlv_length, miux_tlv_length,  rw_tlv_length, rw;
> +	u8 service_name_tlv_length = 0;
> +	u8 miux_tlv_length,  rw_tlv_length, rw;

While moving this around, can reduce the number of spaces before rw_tlv_length?

>  	int err;
>  	u16 size = 0;
>  	__be16 miux;
> -- 
> 2.34.1
> 
> 

