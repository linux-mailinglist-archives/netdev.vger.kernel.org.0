Return-Path: <netdev+bounces-3917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A879C709899
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8410D1C21246
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917C5DDCD;
	Fri, 19 May 2023 13:44:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDC67C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:44:00 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2113.outbound.protection.outlook.com [40.107.212.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BC6AA
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y02YewX7s3MI3C25Kyljmdvxg+XUirIt3ezmwfFAswIHq0a6vhLig/n0y0NBh9XFbdcrOanUE9BE8zyybQNTbpZP15m0BrCKBS2NZaO/plwP+hgGXO0pP0nexU8BroqX8Z9CKByTHLUpb8234ZnpoP+EWRKOjTV4SxRIrcFK5tWxQ3iW526TB8WAn5QJINaKQQePKc8kq/ADNnPiMy7vt21z4JfrZsXKuwPUtq3XNx/VLvxX59LQgxlNTJFMnTlJvdAcMCLN4AmPJqHngjZhahAXDs50tbjJcrdCRw/OMVUQDEvzO9BQLXqDR/MNBgLddu2J/J/TccFOBnRMvhfTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRPWUcFGZzHhP8yvaX3B6m/sIPquSX0eWRMFmlGgM4U=;
 b=LXQiHK4p2J1hAAwu2dy9JmNpyvmibOkLdUnAGwrLaAOHnb5bkZ0jouyUPc4aEes+cX06Zpe/koJABy6WO6Sx/jbACQO2AruQNxMML+iKhW4VzUadGI6iFh2lMIKdDYAM4Ak9bcTfJ/lOHVGjtvVpTEjebwO3UPIOhpj37UBDQU0ktLSNuCaI/K2XpoUAmNWYxuHR//HLlN7EW+JmVmkRuT4CCaMZTyGfjcavm4Best7Z1be3D3/AA47NXelH3TCGwKFj8x2xRfXnOcs/6jO0j7Sl4NG24xHJIDNkSadbbPunkdUv5bFAGlCrBk+/4t7qc9M4LZqch7QfXOydxF428w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRPWUcFGZzHhP8yvaX3B6m/sIPquSX0eWRMFmlGgM4U=;
 b=K/RlOF1caxbh5PF0U6dKIoU3/6eJuF0CR69NPKgx/RyLR36YRU+bx7RLY+SrWuyuRkLUCeHxv0q+aCLJaDVvK06bak5JuoOeViAE4gJg8IvFMAtvk/82cOoZP6LmWUGTPO/wc5DXI50e8OvrJ67fpnw7yLYOw//U+mcqPm2rYXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6246.namprd13.prod.outlook.com (2603:10b6:510:25e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Fri, 19 May
 2023 13:43:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:43:55 +0000
Date: Fri, 19 May 2023 15:43:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: add helpers for comparing phy IDs
Message-ID: <ZGd9FZ5vaLOdBN+M@corigine.com>
References: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR03CA0023.eurprd03.prod.outlook.com
 (2603:10a6:208:14::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: 503d0204-526d-400f-9e3b-08db586f16cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WbIAs9/hb14JgIjSJp89jOLyEG3o2+J/Sj4SAYnkEVABRs/LByrs4yV3Hm3wNmehZVH+K/2VQCQ9UazmSluinCNJkfHgasBDS9WsUzs3A5RJzcjvx/uy0za422jO1/EmBhvwE+X7j3EFZYTVFStmHz4zUqdPGtJUgiIOCNGPSuesRQcXefdAjjOKFaIh/29anah2VKK/ZC7mNFPUfRLC/GNO28KP6v/0Yh7jcYJlj1CuzXo5Ln+CC+vHV0HHsh+7r9wb1pGRa7VoVQD3knXADiiewdcoGh7koDGFd16I9Pi5gypl81tN4Q9XXg1keUj2Fgd2Si1sIbU+PEG1I7BH6XCXHzxJfqt1TvurR5USfniBZTpUokRxc4LoGkHF1gEJjTLiaitvZC8fljcxlKbO6osSw8V6ZXelh99OakFnGUdj8fwGMHpu2uphhp02kd/wxInHZSczI0XvItQawv3iRGKe2amS+QxO6WztoA7P6wkfsNoXKzKoFuJtpmVAyCkqsh1FDGuN992D+MVlk6Me79Q9c5GKylv0F0B+H+CvzBGuBHjSupXwZaY3t3r31oXLiHNLnr4XP/WFWc/wr5ABoJRyy33NZeRO1/L27prXeWs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39840400004)(376002)(451199021)(83380400001)(4326008)(2616005)(8936002)(316002)(66476007)(6486002)(54906003)(66556008)(478600001)(5660300002)(6666004)(186003)(86362001)(6512007)(44832011)(2906002)(8676002)(41300700001)(38100700002)(36756003)(66946007)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Svs82Pp3exBkwE0Inbio5P/+NDuzP+QFGVnAdd1e7baIdzuCDjzCiitr3dH?=
 =?us-ascii?Q?u5N8TxTTCpi+v634uJcHwNaRAgNmTsNU4cdSGlC3StPwCtBC9XdO2RRFtV25?=
 =?us-ascii?Q?A2gWZx7q/ngZ9cyRMzbny2HxviDWECNm6eZOQwuTojTnpTn86AYjEvLIQHge?=
 =?us-ascii?Q?D1OMowkE6Hv02mPjxm8CnLWkUQEPMyWL1lP26+WBkVz0k7ymbML7njnwLjdf?=
 =?us-ascii?Q?2SHs193T64BfccvWV0LwwAZUHtH/3S/IXwrBU1XvXRsMM1hAX463pDpa++ds?=
 =?us-ascii?Q?YxpwP/V7caKUb/g9u0VtlOov+egocSXmVnluTCGbF9DOWgF0D86G0A7dU/Be?=
 =?us-ascii?Q?4ur5rGd2PdUfrDYyoIoDiIu+eB1EwobaKgbjigiLZfafzDDjePS5m4JaVLk9?=
 =?us-ascii?Q?cyCTw4/e3TNJ4BWk0IgmvI7U2uzI0ubxFbGYXg+ejMR3lSpveZhaH0Ek0yFP?=
 =?us-ascii?Q?a9vYMHygSAWddNVE+grwO662sihRJNSqT7Xw72gcgxZtBIUjeOSu8XG9JWOC?=
 =?us-ascii?Q?yHzb8SjHPyAoGcwNWVvh64qdUGg2Av/zgDRjzAOmZYfZ1tXSQnWTPm4B9R1H?=
 =?us-ascii?Q?JUntQYEr8oQ0aD51idrRtotDlXeUbf7jC0o7mRBtoE7uRGgaJLykM9V64tXk?=
 =?us-ascii?Q?vHygPbYVFQFS9vUh9BD0Kmjg5dY+vOWtb+sJDZHbpw2016Zqeza7g2drpj1h?=
 =?us-ascii?Q?bw1nByW/B6uKQDUauvqbWwq0x8Z00GXOYHB2pPFu5WF1b+NFfGXziBMH+3la?=
 =?us-ascii?Q?jPW0J33GjIaLQbIaztJf5jV34mBtlRDlS+PBS1o4Ck7XWUTBlkFtSZ7falyp?=
 =?us-ascii?Q?Cnlc+vTJWKUafr1kJZvzc91Ppwqrj2aV/r2OCKqqRhKd5n6v77jF3rY4aYVH?=
 =?us-ascii?Q?7z7sSQkOPZ2yE578tcn7O8biKDEgojCVVVve80VHzNaZLUjcxeJqwWq8Dhfy?=
 =?us-ascii?Q?yEW3rNGiLQyeeXLcs3DbmjQtZdGgUfsarYdJWIFyyZQ8TD+H+r3qRAF/lb7s?=
 =?us-ascii?Q?1V4re5QrTYbyybTTq5+selSJTtSM4vv7MhDZbqVfToLSeA0eAa55QqjsZlwB?=
 =?us-ascii?Q?0sQFaHPPk+0vH0WhqJxaWOGycvmcwZtEL1Y0Wnxzfz4oDw2u2HIPEsx7sx8G?=
 =?us-ascii?Q?qP8vJ6zwRajSRtDFzvdqYmeLffn5uEyKGoFGv7IKmbOk1IXKI5HlFvc/+Zwn?=
 =?us-ascii?Q?yNnPTPO2K4aCyuxSXPR+FqWiEm5ZAaoan0nZY+mbcSOGtlDW3UasjvVlBhCp?=
 =?us-ascii?Q?8AbS3G/wHvbNtFYt+uDhChmmg9+cW4xwm+ZN76/neqRb0zT9aQHo9di/J6bU?=
 =?us-ascii?Q?X2u+Erf9sNztur0DrCsqNvoa/PHaXr34CBpoTzVWQ1UOpzccD9+9nTkuXD0R?=
 =?us-ascii?Q?wBurnKPVAJFXXONmR/FPcfX2N+KMhJojs9SEBbyQKdMpzS7rcEugXrztZ4eZ?=
 =?us-ascii?Q?B7hkJeM22zdDD6tY0Ap3nlpNIfovAmRgaMqos9UKO3dQK09rhYbp9CbJ3xuh?=
 =?us-ascii?Q?zXk1/xWrJRoxDCQ+xec4MqfH4ZuLoxM3QM4BxtHRMEoJYOx/nC5ORPDBQMQD?=
 =?us-ascii?Q?yYUw7zXiGMKCP8thKi8fmUexnrLfD8K2mk5L3duaKvjyVl7sQCkwUJ1gLEpW?=
 =?us-ascii?Q?QA1B64dZFPriM8Mu94ctx0xOYFNuCDaH80m0DJnTrXnL8Ka6/gTuWfe7JTx2?=
 =?us-ascii?Q?bda4tA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503d0204-526d-400f-9e3b-08db586f16cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:43:55.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86C7Auoza8OGp/h18Z7B7LuqxGiiIlbO0GdRqYRur8TRGKtZivGTqFFFjl8FGkEgpKAtuxeb/VzRlWzDTr3UHJuBcy09/82lR6GZViUIdKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6246
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:03:59PM +0100, Russell King wrote:
> There are several places which open code comparing PHY IDs. Provide a
> couple of helpers to assist with this, using a slightly simpler test
> than the original:
> 
> - phy_id_compare() compares two arbitary PHY IDs and a mask of the
>   significant bits in the ID.
> - phydev_id_compare() compares the bound phydev with the specified
>   PHY ID, using the bound driver's mask.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks Russell,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index d8cd7115c773..2da87a36200d 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1112,6 +1112,34 @@ struct phy_driver {
>  #define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
>  #define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)
>  
> +/**
> + * phy_id_compare - compare @id1 with @id2 taking account of @mask
> + * @id1: first PHY ID
> + * @id2: second PHY ID
> + * @mask: the PHY ID mask, set bits are significant in matching
> + *
> + * Return true if the bits from @id1 and @id2 specified by @mask match.
> + * This uses an equivalent test to (@id & @mask) == (@phy_id & @mask).
> + */
> +static inline bool phy_id_compare(u32 id1, u32 id2, u32 mask)
> +{
> +	return !((id1 ^ id2) & mask);
> +}

I wonder if, at some point, it would be worth generalising this further.
It seems likely such an operation is used outside of the context of phy_id.

