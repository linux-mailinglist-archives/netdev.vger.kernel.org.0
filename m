Return-Path: <netdev+bounces-8347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B8E723C76
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A5551C20F36
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C9B28C38;
	Tue,  6 Jun 2023 09:03:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C58125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:03:44 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2101.outbound.protection.outlook.com [40.107.101.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D51EA;
	Tue,  6 Jun 2023 02:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5n3o0X/PJ2jlhMrTk5pxxP3ltpIX3TCGhbPmWLpUNMeJhHTWB6gkaCl6SnymUpwfYe00Hmz6lWEtpkaQUGazxhfg4BDJJ1B8GElGCg4rM+fAEet6IrGWj0IoxlMJ88vwFIxewgdjbNs6Kj8UmACLTKyhj+n8jGNNXeDnlV7CKU0kWY1pkiPY+QwXtIYCNDyJZipMrz+YLHWObnyUS21dcNFkWDxGdOXorqA6FxiQK81k6XoK9gFvTxbyPiGeNNqvJhUYxeeGl/wm/6u9rLq/4Jc1FguWUpgMYqv4IR0AdjypyMHx/t79oX8FlblRTHdPuBnGXdp033OuIY95eQ01A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uiMD/Wi2OORyyqz7AWIVv2bvNz5qMuDJx32kVoEMjMs=;
 b=Ki2v61LyxR0pIyfiN3XcZ/3B4bvDayynqSFMReDq9GxCdDNQzVKXNFv+4sNYboX7dMo4F4PfeAq2loHMuR3mIN6qLOOCdFQCmRqOLnJJn/19mKr/NLbqABtFdA+Jwvy7UXs0CO3qqjqRJmqVSGNBj0/5kPvHcmjo3kL/gHzBg3mBy0H6dAXuSMe4h3svQxfCrF8qiNGCWu7aSH+TOo7dzfW9oFfg+LGSjAHkjL/2Q2LIeRflwXM9h8vkNRjSXRGle1epPYpNm32tuo3kkDMaAnoDEKfK3gyKex5abH1vVQSqC6s8tq5xMEgKJoTPaI0c+A2lO0K4Sj6N+hw86LVcYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiMD/Wi2OORyyqz7AWIVv2bvNz5qMuDJx32kVoEMjMs=;
 b=k7SH6W+JZt1GFJdiXKlrNwslkhfHwUG4brf37bZcbYSeO49hcAWP2dAgO2DSBWlW5vIb+2iqz9OPQO6zUX/D+bwAnL5bVgb1dPQ9OVXrc0LUCDpdBcDbn3bkflL4hGETtdzjtKV/2HtkKWaWMwocXdMkYhBb+I233kURwk+FE9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3895.namprd13.prod.outlook.com (2603:10b6:610:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:03:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:03:39 +0000
Date: Tue, 6 Jun 2023 11:03:31 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, Rani Hod <rani.hod@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7615: do not advertise 5 GHz on first phy of
 MT7615D (DBDC)
Message-ID: <ZH72YwgpywPNxbd2@corigine.com>
References: <20230605073408.8699-1-fercerpav@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605073408.8699-1-fercerpav@gmail.com>
X-ClientProxiedBy: AS4P190CA0044.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3895:EE_
X-MS-Office365-Filtering-Correlation-Id: 26cc7868-b010-46fc-6977-08db666ceb25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6vLL0v4tyHCgLpyIhOh5And6p9DzQiC8mzNh/XrKZTeSRzFl79rb6IQGJUS6FyEUXDNA92cjb4+9MPABPY8hFhTJ9FAfD1QGOracLVMRG6PbCi8QzMCqxQQ/dJXwX5CYhRgwT591CU/WWE+9JvQfY0p+0qcRYvUjqjASUf3e2KsndC5JcufVApAINOmzt7JCKj0LmueCbuhOrp6xUUxk6DiTEe8CGGIHAvyRQsaYqugRVhBEJrOYqx6oAAYVONrz0H5Gr1p1EGIJrT2OrlCDJC3YGnMLNfFw4xPJOLIEdmnNlO9cHGcw1wQuR/0lbX27VeunTkmHGX+VGnGsd4Fl5N4oPnGRlBoiEEV7etRePovtv8xCmobncHRtBDvE1ZA//FLr5SZwjfzltyBPwLuS0QoZ8k5DquMNxToDHY8w3/mAQThGihNVmvWHFs3p6Pq8cBAOnNMhMp0UhG3w9MAGg3hcr12zVOdfVIEJsTT2tGjPHFJcc4KokYZYGHdSQayu8wV/UPXtA59DFSvTxfMOqRJazKykN/hvWaFYwYm6zYOVwphKIu8JIi7MnHYtUotH3Be2m+TIz3Z4IYZToZlGdksfi7F7EisXvYryl3/8HOU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39840400004)(376002)(396003)(451199021)(83380400001)(54906003)(4326008)(66476007)(6916009)(966005)(66946007)(66556008)(38100700002)(6666004)(6486002)(478600001)(2906002)(36756003)(186003)(316002)(8936002)(8676002)(2616005)(41300700001)(5660300002)(86362001)(44832011)(7416002)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ztEVLp+RRakxsPZNTVbGTgc7OWpXeRPSOI7E5SDIz5khooI2KOOrkIyk/NEm?=
 =?us-ascii?Q?PePFG3IzttXUjOespF5b2BVmGIwEI5++Lhvl+WPsyS1GrVJF+ZudnbKbC0qR?=
 =?us-ascii?Q?mr91M/OhtapnoAo17bfakdVzstu+1yFaIjfrA+EOOzThB7HojJuve6J5Y0+k?=
 =?us-ascii?Q?uWaCVChnTCdAifGQisLPBtoZ8fjDy+1gFiTeseWPPD7A2YbYD5ln14XzcJq0?=
 =?us-ascii?Q?PR2xMKRJDUdFENrKz+j4/MreN9/cBgPR8ZS/K6U90J7kF3M9WBbBbc9Brx4H?=
 =?us-ascii?Q?wV09YUr8u1bgAZJhrLEh47RKxccRB0R44iu+IWwwVEHQ6+rJRbRbxBk9wdN4?=
 =?us-ascii?Q?Z9odqUhqHQEzrxydqthm4G230T7Z/y6SymqJICc+DC+h1d5pGtoQIaLL8mWT?=
 =?us-ascii?Q?LNXTcitJyi7+RLPtcTedX/zkzF6nceW1/vuYs2slhwG404fHXY2/PbAZq1oj?=
 =?us-ascii?Q?cr/IaENxeM5dpIp3iC5T2AHjt2pAWMSoF6jvbOsJ1xkvhweiqNza02M+FUDC?=
 =?us-ascii?Q?+7ZRDFraYOvjkZYEv2UCmYI8z48QGcYqHHe9i0Mb3THA/z6mG+w3RUKSGfBd?=
 =?us-ascii?Q?n84AMGjLfpZsuCG124+YoeyU6MwQJ8yVKQSzBM1tETzXlYw9zhmG3ofST5xT?=
 =?us-ascii?Q?BCxkQBIf0D0GHsYy6Ql18LtU8lQUIOQPnR9Ns22YltgNqXDdKvq2utCuNh5S?=
 =?us-ascii?Q?eOOEbnTTC3PK7KcaKbSYlnc5JQMZvSaTp8KXSmmAAKL0hJrAfhJhYyVRFrkX?=
 =?us-ascii?Q?ZDOWumtRoy75yv0macrsbRVDdcoTLDkU+9KqDPfNNvk7S3hcFmeLzwklOaaT?=
 =?us-ascii?Q?vMVpWQlWENz2UJqnzJbFekswc5v7SUoJljrsX3QTjRnHXbRYa2P0xWFmJIkb?=
 =?us-ascii?Q?5hkYLgWhx4btvzbFVRkUe3mXswzU0M9HYa97wX4DK+0CKog125ZFeANDBmcj?=
 =?us-ascii?Q?vANL7UFkwd0/vfWyPcSzTnQ5wDlHkOBcdh8h5keSgA68wH8e3NNEFutWnfgS?=
 =?us-ascii?Q?1AsGoqNxWPkoia8zJzYTIUe6kGXikBoUIbIB+QOCUklmjUF20XnbVng4q/PM?=
 =?us-ascii?Q?2KfimcBlruQUn7e1wuwYf7n77Qeundof53R7cwd4hRPQRcIMLLUJeQnRr1Gt?=
 =?us-ascii?Q?+6YCz/Qw5Tdu3GoDbGgf2/+cNt9kgjKQyju+HeGfYz5fvxj/Kp5Ap8K+Q72R?=
 =?us-ascii?Q?KcBcgwAKqO1rI6iseDnL/gid8EMTw6P9ECLNojwGhcrjSnyB4/bRHNcxqCMT?=
 =?us-ascii?Q?intWGsLzCHNhsFQuszVoaZVF9E6mVqUxHTfNtM2I8ib/ysV8noLOLIrF3Yr9?=
 =?us-ascii?Q?5Dx2Rd7qNVdeHPLsHXwId97LUMHT+4JUD3afGqteEKo8IdS/llR1zVblcr1I?=
 =?us-ascii?Q?ahj4R9ueiXTRXNrV8XKT0Z4Pys8PhD26TxV6MFXNQ0pnVf+EnoLlUVYPQOa3?=
 =?us-ascii?Q?zHWqsbBlWEOgTB7k5/4e8lP1ZA/xdViQg7gtfQuDgvM94vsoNPZEAziNSrxw?=
 =?us-ascii?Q?nCNlgP1ghw7P59Dx+3eaNgk2ZrStRKfS32J85EmZ2bxB/psYonyB6DYXsWWi?=
 =?us-ascii?Q?7j5SH2C/DZ7fBTf+1E9QThu4noS4ZzqUpGPMhlEVR62HoCNeCv+us5KhJ0V3?=
 =?us-ascii?Q?iY2xPwkTcCb1IEFSl7+yxMiboi9CT7lH1ac2YrwVXVL3KDl6MnVFJUg3hBVr?=
 =?us-ascii?Q?DeBpuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26cc7868-b010-46fc-6977-08db666ceb25
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:03:39.2199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivYV1jnjasOgO/+FCQ2pnmw8iV9E6e7iFknJnQUwdRZDB2XwwLDDr4aSWHRccwriP7QXh2j+CtiAh/ePwHECEf+FgoSsIk5cDhHNn/zSWNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:34:07AM +0300, Paul Fertser wrote:
> On DBDC devices the first (internal) phy is only capable of using
> 2.4 GHz band, and the 5 GHz band is exposed via a separate phy object,
> so avoid the false advertising.

Hi Paul,

Can I clarify that the second object won't hit the logic change
below and thus be limited to 2GHz?

> Reported-by: Rani Hod <rani.hod@gmail.com>
> Closes: https://github.com/openwrt/openwrt/pull/12361
> Fixes: 7660a1bd0c22 ("mt76: mt7615: register ext_phy if DBDC is detected")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
> index 68e88224b8b1..ccedea7e8a50 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
> @@ -128,12 +128,12 @@ mt7615_eeprom_parse_hw_band_cap(struct mt7615_dev *dev)
>  	case MT_EE_5GHZ:
>  		dev->mphy.cap.has_5ghz = true;
>  		break;
> -	case MT_EE_2GHZ:
> -		dev->mphy.cap.has_2ghz = true;
> -		break;
>  	case MT_EE_DBDC:
>  		dev->dbdc_support = true;
>  		fallthrough;
> +	case MT_EE_2GHZ:
> +		dev->mphy.cap.has_2ghz = true;
> +		break;
>  	default:
>  		dev->mphy.cap.has_2ghz = true;
>  		dev->mphy.cap.has_5ghz = true;
> -- 
> 2.34.1
> 
> 

