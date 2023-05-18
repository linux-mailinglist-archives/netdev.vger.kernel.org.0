Return-Path: <netdev+bounces-3703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5177085D6
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A2D11C20F3D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D03423D7C;
	Thu, 18 May 2023 16:20:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3870D53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:20:17 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2136.outbound.protection.outlook.com [40.107.92.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0564F10D0;
	Thu, 18 May 2023 09:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpQ8bZG9X6O7WFfQMwmBpvxxAWSC4jkWzg3c5oVTGaIg6YnHk3z3crg8Qz0cottBqUGvUAfL/CuYCjgenIU+lQobFgYPsRypYUrRZTPsPiPmzGbm10VJ8cKcZCGzJLNlOM826LyqFynoIXamrrSZXptV1BdLS/h9cyTouPzL6T8NOoMlbzs8etRI1yv5wu1I3qQTYaHAwxSfUyV/RsJRYAqARSkjVOFPvfOfwLIvLcFyJa/TjYmyTFdRLM7isKYp+CIMyI46LWsIXH2+be2J6CKd2PORV9H+214s9frECwR/amPYyHdDvN0NhmE4DRm2Uzf5fiYJZ7TmptaxSG7oOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqK1cm5PrVikdVylor80+Xt79IA7sjfvuZ0d5095d4E=;
 b=Oj5xirNvGnuUMqR9zZHx6Kyf6EXU7C7LQxCgch6DYICyysa8vgKPvnIUK7ovymSGn8KuP0fa4BPAatNUFZEa9XUZr/BH3vKJg3Fo1U7jucUqOe1H26I1Ms86JjuhmXJ9kdWcOts7LFe/5fzZs7AMoWoOgxUzlB9p0N/WBABsY5fg3FZRZ3lv/R0hlHCHn9Y6JyTzIlaCHOPJkwGWb9uMRuhJ3dhcYa0KjHeWqOBhKOUaf/c+16FQKbTUtjdnfcyuI5sZjqAr4fUEMG7nqBK5h4hHxsWIVoEbOJ70E0gZGfJ9sjQv8x0uQIApFjGSS19xihnZ0uNgCRL4XS4FwGpVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqK1cm5PrVikdVylor80+Xt79IA7sjfvuZ0d5095d4E=;
 b=LCI2Oo0i/Tn6HbvjCEKP8Mp5jwIdZA7JlfWV+nVvo8VQGG2vpqw9mllKH24xbq+IPSs1/iuWsehJ18AP1nfbqtr9qBW74PhSFfbhYZGzA2vp1E5i7oQIBB90rqoIP1ybL1114nzuqRBmh3zqyZ2CtdA92uH+j8nR07I4wQeqxUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5771.namprd13.prod.outlook.com (2603:10b6:a03:40e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Thu, 18 May
 2023 16:20:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 16:20:07 +0000
Date: Thu, 18 May 2023 18:19:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Alexander Couzens <lynxis@fe80.eu>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Bo Jiao <bo.jiao@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wang Yufen <wangyufen@huawei.com>, Lorenz Brun <lorenz@brun.one>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 2/2] wifi: mt76: mt7915: add support for MT7981
Message-ID: <ZGZQLNydnuP/sok8@corigine.com>
References: <cover.1684155848.git.daniel@makrotopia.org>
 <5f906578cd213b70e1049e927a2905ad1cb63afd.1684155848.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f906578cd213b70e1049e927a2905ad1cb63afd.1684155848.git.daniel@makrotopia.org>
X-ClientProxiedBy: AM9P193CA0001.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: 558f6ec9-dedd-4d31-d12a-08db57bbbe83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yH4q24MlFUc+QoC78eKDMYUKsbF6GyczR3Uu+AeLnsEnq2rQ2HXszsrPfYFPL5B9jaHRGZj2kHyphIAelX5jS5v85cbWq49niNCk28UwgOVYb6biZd9KWNHOeJoKPeUMg2abvOrSPp15HAP6OWh/V/gJo6+Ori2XJ998WfsQ1zslrVTv0s7/wqsM1/aEo9sl3JkhVCL4uQHjGi5oiporohO0b0rWwQ63u0ZAZnyeD0B9kzpXUfWjmEwRu0/XLxjS9xVaLoCPZ+ZC2bQzIDqU2jISAaQ+nY/QuDACTnEid6KOVdrW1DTEqKTfXsvZbNT2S54ymiMkUa08TMmTgIvxvie3w9+HMhHp1MGfzaZKH5bRXurImNe1oSWLSwZrQv5ZalX+jbwNx5T/BIWWKEz7g8Cmz+um90QGF6uI2cRNKTh1HQuXP86nM51HnT/oNNyV/nhjQXhhu3r1Ix3Rd1UinKgWQ5l3Md1eiZDjejugCZnMsfxOFN6NAFCixngQt7ArzmNw3Vix++IJYTY3fzG8i82BMo7iELATq9QPunL4lMbVfTMDtR6Yftuuo1Qh+z4q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(396003)(136003)(376002)(451199021)(66556008)(4326008)(6916009)(66476007)(54906003)(66946007)(478600001)(316002)(44832011)(8676002)(6486002)(6666004)(2906002)(7416002)(8936002)(41300700001)(5660300002)(7406005)(4744005)(86362001)(6506007)(2616005)(6512007)(186003)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gWbRUB2Wgl0Twhm/zym4cbxJYNE1HjuKmLWtTiu5ok+umb5v07l91hO8U6g3?=
 =?us-ascii?Q?9Z3O9L23vxguojZYeD8FW9GypCQkp5G5S9OBMEEbFHHaIX1U4/1/onXWM34j?=
 =?us-ascii?Q?/TT3F4i2kQSkEScTYWg+btMG6TzdHImWBCD7BzYr3U3/ahYfebDMqIKsasiL?=
 =?us-ascii?Q?XOlhAfka2qr8SrViw4AYeQ/Ab/z2LVgPFC0Pu1V0YIcQvbRG8mo1GHgXu/Kx?=
 =?us-ascii?Q?8yeoeQtv3x4iXN/mPcBCgaE3uuyqgEA9vgUbI2qEEpsLp5AXxKuPmWTX0kYc?=
 =?us-ascii?Q?5VL2HFfKedUFnNN7ovyNBjsZYrZ9wS+FebjU93HMRc6h8fWhH/koHokO11xa?=
 =?us-ascii?Q?6D0uhn7FF/+e6/jlq36v3cqIlo3F5gsLCqtfjOaW/VnJVt3kEmm+0YQX3PKQ?=
 =?us-ascii?Q?i/IUIMnr2b+TtnJHagnGZeMrOHL++JN/8KsSR+UQZWd4si6RwWhHfQnbsELd?=
 =?us-ascii?Q?5iYajoviV9k6xbWns57wicYL7WyUWDsPWh2g7p4BhDW9jaPtGAw8THWPraXy?=
 =?us-ascii?Q?1UFRPzTlrSt1+WONvfXl0+ellDxhAgmPGmf8xJRKvcLcHXs06TtGYjAP5wn1?=
 =?us-ascii?Q?zL/l/SrIpfrUdM3jSsd089tq15sBrCqPqrg4qX12UTCqL8uDCqhzdagfNQm2?=
 =?us-ascii?Q?oflpwIyBQOjLsFL0z2cnEeFbaXg2xsHzLulQIWqzn6akbbPwqnH7AMooNG8i?=
 =?us-ascii?Q?YIdxM+nadxu3nrQiB2yC3eq7eqwm0T0qAusCUmR/ndV1cfv+jU/AFLoIPZr6?=
 =?us-ascii?Q?ZJgwz8A1Rx5qClq8xyPTkizMDQKf8yQ+0ANmj8TdICfRfYBt7T8URO5spZC9?=
 =?us-ascii?Q?3t9QcDBPWiiRwYbiV8/aB6E8FMaQBYBn0bjtZwVJb9TMpYqMLavF7YoJt0Sc?=
 =?us-ascii?Q?8Xv6iLI/2hmV6uIlM2CeQCshJZXAX6MYUu8+tfu0drhM766VTvdQCD4Pt9m2?=
 =?us-ascii?Q?g2f+b1WmIIN0ps5ZVNg/1E/GOiq7eVmuZbn9aIgv04xxtm9ChYoKj2tYFwjv?=
 =?us-ascii?Q?OvV0mqlBZ73ub3NubvYClOZw17jGeVaovXev0BsV051xOsHweD3NUQqjRhYq?=
 =?us-ascii?Q?DAHQ6u67q+kKe3PdYnl+Gf2h8yV6rQHYWeJdoodMfFnTOroABK3ZHT5bU88r?=
 =?us-ascii?Q?IlELYR40b61FfQmzHduxrn2lI0BbDxD17NRkld26P7joa8OeRSsXtH3VtVQG?=
 =?us-ascii?Q?H89HO6AvFQor8IFUFMqSwH58rTzfpgFBUWUy19a2Gyjo7D1S7xjHj+pJYKtf?=
 =?us-ascii?Q?yPiT74SSw2ZalIaPM5epcWoDvCCSAc+FE4IpbnniDA+6TjL2DhuK5gO6aANY?=
 =?us-ascii?Q?f3D95SbQWkpqYNSOgJH7RjSQjGQbSaYUSs2792ONChMbQM+aNfySWAkALFVg?=
 =?us-ascii?Q?Qx43pmnDPmuLERQ9UAfI4rilmKs4Xi/xVcUPY4tTtz3z5Yeb8oPxC+ASVTXt?=
 =?us-ascii?Q?7zWS8h/MPbFc7a4eCKHcv9jdBF2tKb52RukIpEGM4azBwPsJkMO8uowp0udr?=
 =?us-ascii?Q?4smD7EFaskR7/syqRJTZJXvylkr3ipbCp2DqZF9JBVw2Zkcr3z4QULiLDCzh?=
 =?us-ascii?Q?SsYHcKtaUfVAW1nAQ5fLZINiEpwd+bGPeBk0shbybygzrEpsH8Yk4EnOT8AL?=
 =?us-ascii?Q?upko1ri3ROmfSV12dSFQ2dS/iJMZN6dRYv1ep711R0xDeEk49H5xo4pfnDHy?=
 =?us-ascii?Q?i44SMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558f6ec9-dedd-4d31-d12a-08db57bbbe83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 16:20:07.1933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Df+U3wK7M+ZJfOdrxjv3rzLsDWI6ilutzwd0KGYQqikoBXiP4jSo1bGruM5nyXJWFNDehnnbI+25fMmuzE531XWbys1EWdQtfpi9MyfZTGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5771
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 03:27:12PM +0200, Daniel Golle wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> Add support for the MediaTek MT7981 SoC which is similar to the MT7986
> but with a newer IP cores and only 2x ARM Cortex-A53 instead of 4x.
> Unlike MT7986 the MT7981 can only connect a single wireless frontend,
> usually MT7976 is used for DBDC.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


