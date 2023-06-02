Return-Path: <netdev+bounces-7542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF208720961
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 399671C211DA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F91F1D2CE;
	Fri,  2 Jun 2023 18:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6B1B912
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:50:24 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2128.outbound.protection.outlook.com [40.107.220.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BED61A5;
	Fri,  2 Jun 2023 11:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUMcpw4qtTPt8cffT/hELuBVwmiFMhBvp44riQiEz/YK6cV3CuTnsvwDCHGfxtP+NP+eh4b2Et5Iv5D4ZOvATB6aez3R3g53aQ0aaOqHwTmDPKoFPnwbF7r2ffAcMDxIQtfyXDBhwqoz9hWhA13xKHdD6nn/LnRqy3d2n+M/2clbGBzr3odOv3oLiwnZgQndLrDnsHaxemXVSbiNM9J8U0NO57nyS5P7dR0aKYZGIX9/zocaDzSdp/GVKGBm4NYuqS/A9dxmvtJKFCIhgtubYWym7ZC21cPR/jwzIACtG/BB30LYuO15YyKtwHtZo70XfbJ9lNUjqQOM8FP5omOClA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGp/RelLSKQh9skSR/gRuj4R3y6z9zeQxcjTv7v46OE=;
 b=LVKLOxOHbUriwUsTecAAvZZS45JjJg7zzNvp05GnOI1opPpAjSWJbuTpLs2sPCWet8XprnkjyZyNuI3QZ47PnoaBIavt4et8028eqa8jpUWNa+1YGCGnFT+9wv32jrl53UWcfyze2jcnFee2ALLPqqzZuh1SxokSX1/xBnLliP2w3npW/Z3PbhDyf/KCRI8vchsrCrm+8RIAptk52+Op0EsgioxE1ljQ1lw4AMubAcglpOZ5KWddXNp32up0nO6kyFBVCdeO8UtjWc+YzC5xnSEyQj/a9I0lZ9o3xWB8EgXMdyLA+1kSmPCw2DCmEkUex7sTI8cU+wCZnFaQJXD+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGp/RelLSKQh9skSR/gRuj4R3y6z9zeQxcjTv7v46OE=;
 b=wBWxaT6XMT2B2VjtZQP+w6wrsujJX5lpKjCNskzX3EQHFi+ceOzb/4jy0bDQBfLNyHDWy4oRiPwxkNmjSYlHlOrN63Ml/dbb3uo/yx+k5jkVDIaABIFFv8AwSHkxAx6cb5MZ2h+Irf3+lp+u7mJ30/j2rYBYxatne73vm7fDq54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6430.namprd13.prod.outlook.com (2603:10b6:408:197::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.12; Fri, 2 Jun
 2023 18:50:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 18:50:18 +0000
Date: Fri, 2 Jun 2023 20:50:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Chris Wilson <chris@chris-wilson.co.uk>, netdev@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v9 2/4] lib/ref_tracker: improve printing stats
Message-ID: <ZHo54/ycgGUxjiiw@corigine.com>
References: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
 <20230224-track_gt-v9-2-5b47a33f55d1@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v9-2-5b47a33f55d1@intel.com>
X-ClientProxiedBy: AM9P195CA0018.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: bd155795-984c-49ef-2162-08db639a35ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SCTzp5v+71yIT9+vcXBLh5abtNK8JoVqQ2UzDtgNd0EncFCHMA99F/wzoJ3SH0F73zvg5/a7Rxsi1LmcBwzUn02BxhOYC5FYLYMiCfEX779hHyO+twnAS1+i5+t6duMMo+4k+fpqHgyJ/5jz0/JyDgjpALLmcESO9wixjUTgnKuph4w3FJtdAyTvilGEwCP0RhxehetzaDCexIssrPJIexkdlhYpT2fspKYVdQzIvWrb8trF42CEsWu7bt088gR2JdLimTmjIsEOvk46+OvRnJtUf8gn+skkzz1VMB3BfsBu2mj5mXeumlDXRhhYzHdDbM64AVoHEbDmaeo9K3GUGzeJorH9iajq7QFdIvv+eKm7S/K+Jb5JVzWZmMQNBHAHikQsVUiK2z5v2E7irkWEjr5bynMxoi6fNyrqm8HroiZ+IhLOASVl5r/5tdKZi4gIMueMb2Tiw6FAvZ+0IV6oM/v1fVLqVwQPHt3yZ8f+viate0Ec3yzNbMmDFBDlQI6l7B/u1bs1fdit8wFutY2X/m1ka72gYEF+fjIfcN5joZEMHiw9+s8eNLqZeZlBCX5O
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(366004)(39840400004)(451199021)(36756003)(2616005)(83380400001)(4744005)(2906002)(86362001)(38100700002)(6486002)(41300700001)(316002)(6666004)(5660300002)(8676002)(8936002)(478600001)(54906003)(66556008)(4326008)(66946007)(6506007)(6512007)(26005)(66476007)(6916009)(186003)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OVA2HZl7oxRLWsgiBrBKa6x7qzAAa2GKtQKsectGzHjgefpsH9zZP4OdHSvd?=
 =?us-ascii?Q?rrjElZ7/bRzlzizoexqxfrre5lskD8jLj6PUecR+j0UXkPw0qCJTaiFj+Bxk?=
 =?us-ascii?Q?YpTOQsFVvv0dnyRRktCl1DgUlPVS5pCqBDR6eG1WGRxbn6jLAmGJzlRqmPZQ?=
 =?us-ascii?Q?BhYyovyx/mphu4OBrj13E2z55DxMHBAH/ppiB/v4MN4kbUoTXCaYU7xt2phu?=
 =?us-ascii?Q?KUe3uS3F69v0bwNVeN1OCbL+xi494rZRHNmWSN11Eg0Gh8meBuwKvtNfvrnW?=
 =?us-ascii?Q?kd/w+st5wIyG2fsmnJPWHpjOIFqm+LB5b+Jd9LtR0WWL9uwNcizzKnxUxRE1?=
 =?us-ascii?Q?c+vcGhcOkegTnpc4WZdEE/Vr/zBDnJdwvI77qWRJ1XvlzrUN7yNgr6QmT58B?=
 =?us-ascii?Q?teQW4nEfyuwy+Ldn3lcUz7t3Ib7cYuWV8t5Jxv5ax340bm4ztLDbhtVWOEO4?=
 =?us-ascii?Q?FMD0dSLxA92+NjLHD4EDH0O5h1WHYgdLGnbjUwhtQS5mtFr2AYHLM8R5ybmz?=
 =?us-ascii?Q?0zKiZVy7WxjI8S3YWvBjS48EPcwj1eDDQtURuvPMOuaR5fgMZ9jQemld+B+Y?=
 =?us-ascii?Q?otxq+m5SymEjJyhWSrDVjFDcyvaFsyCMOAdSvVzDj3YfmYpd9+WsMdtk2j4Y?=
 =?us-ascii?Q?75Ihrw0nFNp0fgeU1mbFIL1i3V6w2D20wV3RrCxemFEIEt/VrTPK0kLbaV6S?=
 =?us-ascii?Q?BUydqxUsN72RRTM+4VmSP4/XJM9xlFT6RjYPuJsPJkRtaMEG+uzJsou4ZR0P?=
 =?us-ascii?Q?2lUUGTvQ2MC3vj2a8eoFfeYKNE6XADOENYYLQ6Nar0JoHA2cOito8lmt+qHW?=
 =?us-ascii?Q?rOUNftcv0W4ddsBalU1E8Tr429NgAJQGNU13s3FGAlxRoUmVWpEEKje7sR4e?=
 =?us-ascii?Q?S1E0rP0UXUeXo2HcuAoFfebYZJrddrrwlQIE1gDDN52THQTSCmGsCvaL/ypB?=
 =?us-ascii?Q?gp16fxJgWWxBYybeveM3I+GSo4HtfhDnRqAFT41HGCmwO2MbDp/3xTGWjAEA?=
 =?us-ascii?Q?Qobn2X/yxem3DYDbYCri08fSGwsB1ojcVCK9in/z6uSAwbcwngbWYaug2VfT?=
 =?us-ascii?Q?nkUcqsmk1yhgeXpz/dnSbahPuNGXowFHebMi5s1nJlZb6UNBO2l84ow/KrcK?=
 =?us-ascii?Q?xIMH0KNZEv3VAiW5ELATwo156Des3JAH1pD+vIi7117j6nzRdo3Jh8fAeoOy?=
 =?us-ascii?Q?8cfq1kykERnjmG9U2MaEZiaxFM5WRmvJZOgeyCQNiq7qaxT4eEcpNPvQsyJp?=
 =?us-ascii?Q?UimDE2x0GSh3FTRvOyE+1WELbdoetU0dqfbXf8yEVxTRxP5psSQ0ldoyYqdJ?=
 =?us-ascii?Q?uPNTWC9mO8FShdq8cHOKBCp8wGeS0fkS1+kjtrv7vn6ILIbO5mkMlW5P9KKd?=
 =?us-ascii?Q?7dqNZyP1ZpckOp8ffAP7BD6XQReaVId8IuSSiFUYQk38d6xqL/2YluhuYwRK?=
 =?us-ascii?Q?sHZOJRuiwqI/u2vHGbwN59xvStokC1kjACNA0aSThhyCZ9cAANJLX0AM5gXZ?=
 =?us-ascii?Q?Y0ZMh3OFd3EYFIi0ctKnb1FLsh3KgzWN2lmHWT8Q6xAERdQD5/wA07ClW72h?=
 =?us-ascii?Q?WvfCRkae2usHBzs0IxAPRDXJr8EkUS758TiBgmNRXi4EMc7uGsPdvpwQGQ/T?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd155795-984c-49ef-2162-08db639a35ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 18:50:18.7686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxxXJKcLXxwIPii58dT4LyqQUtQMBMdVZlp1w7obwVA8XdIYdbl1Rn4C3sCsMoQR1NmktJvKJjD2mzU7xfkqgsDaLjQrqNlfNzrxaRZZb8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6430
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 12:21:34PM +0200, Andrzej Hajda wrote:
> In case the library is tracking busy subsystem, simply
> printing stack for every active reference will spam log
> with long, hard to read, redundant stack traces. To improve
> readabilty following changes have been made:

Hi Andrzej,

in case you have to respin for some other reason, you may want to consider:

  readabilty -> readability

...

