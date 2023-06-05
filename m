Return-Path: <netdev+bounces-7929-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A04B72224B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAE1F2809A6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1346E13AFE;
	Mon,  5 Jun 2023 09:35:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4166134BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:35:07 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2049.outbound.protection.outlook.com [40.107.105.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754DBBD;
	Mon,  5 Jun 2023 02:35:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzLIayMudUWAYbk6YsR/TfetHBe4O/U+gQyVJWaab0hge56/szphBgo934YFiDp/XS0mHBFUWdGERa1Gd3QRZGUiumxaV7vclVz8dTGDhdAT4vbNqQLL5LBfq/EM9AkxY9jF3Gyst6AMwvjpZ15eAxhAx5zSNhFfYp3Hq1RrQbwil1ogVQGgM9ePftPKSAQtI74jTn9u/KMuMtChwFkTMtelXMBSz8hqByExccOrK83q8aCtnJfsv1XFWmrTatsPbQ5+k407e+djUPmftJm2KnhLoYdxFwbRg3088/IVPHu7iK619SDPWHX2sjM5v2gfG76ucI2GmfCCeoMeoySA2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BfCpNMsv+D6rZ3Zz5wIRmSyB8bbIMThWVQGOjPSKto=;
 b=jXvXlcb05FDanXub97gMzhmnrWRP+z03hH4Q74IYGUc0W71ksjksftAIzzBYAlRlPPtmIXDAhpdt7RhKkni8BKSy0nAfqTQWTBOhr0tr81mLjQOE1t97f0SM5FDNUnaOoTyLIqsAKRRc3xogs28M5/XeiNat1LJqQ/9badatrMNKR5nYiSI2J3vAC3G0C2O442hLjss+2BXuNvhCF3TNzbmFUNV3G5B9zyTlQ5qKu1CAIQt0up5fk9TZ8TD3cUOo9riNuUTpzG5ivHJ0SOUKFhEWwjZWSbxCfhKgbKmcglSGwovNkTNNMB+T9oV4DC/b5vIWcCTvMohnpZapi/vLcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BfCpNMsv+D6rZ3Zz5wIRmSyB8bbIMThWVQGOjPSKto=;
 b=ZKrlntAJ+cUdCXH2Lv1JzxJWxCUN1ujG4S2uoWHIXU7rO4jRdhF6HTFy0Tb6dWaeV8PmJ6QQl/w8PQ/wJ0iCcf/XjCb2q1s6qSaqp+aILCAwuKAFsCZ/M3mJUIAtgQnbV35jkjid5a8tYqzrdQKC1nuok0e5x0n1p7LdriMwQj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DUZPR04MB9846.eurprd04.prod.outlook.com (2603:10a6:10:4db::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 09:35:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:35:03 +0000
Date: Mon, 5 Jun 2023 12:34:59 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jianmin Lv <lvjianmin@loongson.cn>
Cc: Liu Peibao <liupeibao@loongson.cn>, Bjorn Helgaas <helgaas@kernel.org>,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230605093459.gpwtsr5h73eonxt5@skbuf>
References: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
 <ZHjaq+TDW/RFcoxW@bhelgaas>
 <20230601221532.2rfcda4sg5nl7pzp@skbuf>
 <dc430271-8511-e6e4-041b-ede197e7665d@loongson.cn>
 <7a7f78ae-7fd8-b68d-691c-609a38ab3161@loongson.cn>
 <20230602101628.jkgq3cmwccgsfb4c@skbuf>
 <87f2b231-2e16-e7b8-963b-fc86c407bc96@loongson.cn>
 <20230604085500.ioaos3ydehvqq24i@skbuf>
 <ad969019-e763-b06f-d557-be4e672c68db@loongson.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad969019-e763-b06f-d557-be4e672c68db@loongson.cn>
X-ClientProxiedBy: VI1P191CA0013.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DUZPR04MB9846:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b754dc3-cbd0-4908-0cc7-08db65a823ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PiJJ22Q5KqaOt+e6vSOV1og3U9X/I1N1ULniO0NhM2I/OuFdYbk88aUzKIN3gEeO17xvF+IriywCbcCyuuaA4KrQi22nx6D1l4orq2lPVlGAY3YIETr89cIVGRl/PMjwhK+6KeCwPbjop34i/SSpW/VcKDWirdW5Nyo8VIliCOyjDyLJ57+lDFWgY5FEaL/6L5qezE4nJQ/cZP7oVOOYZsTMnQLWnw5dTOVasmsTj5i0zXeKJNp+s1ZZ3iDX5nXfa3HDsUeCXnLj2uijrp2DFwuNztJmFt0l7n2GhcmgQ6kr47hjnIY496h5VULgZHzO0KxaymepHvvWGL2JximCiQ5jgdptAfGVfDGWTmQld8zzBEcK8Lo2e+QajYBW3VguPvb7+wrvnqSd+MnnX5VOvOxOOqHuVA6F8eF/lRDC0qoZwkvUTAqDsvcNGFIzfbkT/0S+ybBv4h75QZVwqNFspJjeAtZtlLLQDmjGHwacW/a/X84Ret2kJJk6MJiFpMRtK0Dc9iqldqurOcHKJG0FXhZ58xEoxUv3HUL3kkeIGFgGV7FWUWp3aLINskKuWEGN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199021)(7416002)(44832011)(54906003)(478600001)(8676002)(8936002)(41300700001)(316002)(66476007)(66946007)(66556008)(38100700002)(6916009)(5660300002)(86362001)(4326008)(6666004)(6486002)(4744005)(2906002)(26005)(6512007)(33716001)(186003)(9686003)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CrcqR3s7RBM3/3osLOfYnXlmPmZqB1rsvydSZdeOOO/gfSgDYk+85Uas5zEj?=
 =?us-ascii?Q?MuSAGxS+P5f53E1wH/dN3MTN1ydi+DrgrcP5M3EvyYTC6flDJtzHDQ951lTf?=
 =?us-ascii?Q?u/ccT6iTjBq8ea5JlOgRd6zmfYhkhknNHs0ZhmzSXuLDnDxjJiH0+oELmoB2?=
 =?us-ascii?Q?SGXtmLKEoDDTB4xXZWGisSxD0Go/LCu4/cySJ4FI+pQqzZFmr8HxQtVd1EuP?=
 =?us-ascii?Q?n8/NVmJ++a2aQv0U8COV86h7YEs5U8FofCpX6QyDrEYDkIwc9XZSDgEdFJc1?=
 =?us-ascii?Q?EzmDeA9WnD9NYlAWijRVo2cUFS9Kmj4QAfGl1d0mqicqoaV1t5BibA86VrU/?=
 =?us-ascii?Q?L+Lf8VzwORB0IxyJr26pYkp6MJtZgzO6+Iv9MclfB3fWo+VN+KDstz/q/Gzu?=
 =?us-ascii?Q?9j7i67QkTyWePb5kpwCJj/R/OSoRQnc/vw14ADhmpwqPfFGK1c+RNDnaKMn7?=
 =?us-ascii?Q?FFTaX553NSYwSYCoS6S64hl+ooClLdUUhvkoirtVgdAKZ+TeqIYp2n/g2Cdn?=
 =?us-ascii?Q?jWrj+TiPyQcogjqTxAEmJfSai2gqJvFaWFbmrOJnIWyANbkE6BIxCLyHL65w?=
 =?us-ascii?Q?Wj1Qdsiioop8fwJFW26m3RfaYxoF62bpOZWEuIeYZ2DYNnS9SwAjs3pDTEna?=
 =?us-ascii?Q?D/7fIhbvu5iBkZWe9lYzuVr8nt8wUY0uDKVWqS+DEANOh+fjtQfP5adWuUMz?=
 =?us-ascii?Q?AzS7CVnwG9NxwBUmBPdjyvPaGPisCbYk7gsAd1A9G+PsFOMUobqIbSyT1Q+b?=
 =?us-ascii?Q?QClQs3lwQDA4sVTejIruolUrls+fKIYk1M2a4P8pq1l0hsQh9IMSKzozOSlI?=
 =?us-ascii?Q?tU2yDWmhAEK1XDzXLzzbjMyTFsZTQYmVPoJOT9A5f1ucoX309axhOSqgS6mJ?=
 =?us-ascii?Q?7gbRNFHxjFImGuU3/Cgv8Pm/R4UhWZUVSehmLwjsAZ+4gb3I1UXNgZYlZtDr?=
 =?us-ascii?Q?xt/bNHpJcHHTfVDj0GXrqzjrYvXB5KXaRZNrpxai1WUAj3TTmxvo8d3wr7Fv?=
 =?us-ascii?Q?WIjvv0BGVGwUQ9R14bpJ7+LB2ulJ3Xxs9PsZ91NdJjM6L4I62tRoTKuyz8R0?=
 =?us-ascii?Q?neySFDADBuQUUF9IsV7iZBSbRoSMJe31Xu7eJnp+8/z471yhRKYV8lXosFSt?=
 =?us-ascii?Q?hOSaTfZb8zwDypJ85G7eotdzsmt0g707mNgJlVLK+V2GPrmn2llDUacyg29U?=
 =?us-ascii?Q?LGF1ZpQpc4AIr3IpBUiCtqyDMg+sIuZG+2+iGNzBUPpzZL73isj22KvWRp00?=
 =?us-ascii?Q?Z+IopLtw+jm/Xesw2kAuV0OsODp42+Q3lV4TlPOF3odUtUG0cdG261qwiNKH?=
 =?us-ascii?Q?i31KCWbJ+mxma/IhMBRxoEgGedatU9jfjK0la/gtevx5ogbTCKDS5jTf0F9k?=
 =?us-ascii?Q?JTFTCInI9l8EmfOuMBc5X7b9IHXQ2wdcZv5Tw/fHQjlW+47KvICAsks9qFdn?=
 =?us-ascii?Q?ugJ/WiA/Mos9JP7eY3UibbRYofZw5RKbyeTHVT5bUxvHTxR9plwYL23f/Vbg?=
 =?us-ascii?Q?i/5Eh/77Rr5aEjECiP/ZCT7icH3LiGefuDzpwU2Od/YroG51WLsxSY+iO2GS?=
 =?us-ascii?Q?UqAiMV8Ky8dDpTgN4j+b14fvsNlyWbW51W4m9M/F5c2RVTE30bZwDf7dYwUX?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b754dc3-cbd0-4908-0cc7-08db65a823ac
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:35:03.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jk9LhwK+DQlocILLmPpCjOX2XhRbg8hWFA0MKGcVnIhq4J0svNj/eDa1/4dtm8LYIE1Sbj/9B/yH3kf9PJUPIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9846
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 08:59:23AM +0800, Jianmin Lv wrote:
> For a multi-function device, if func 0 is not allowed to be scanned, as I
> said in way of 2, the other funcs of the device will be described as
> platform devices instead of pci and be not scanned either, which is
> acceptable for Loongson. The main goal by any way for us is to resolve the
> problem that shared pins can not be used simultaneously by devices sharing
> them. IMO, configure them in DT one by one may be reasonable, but adapting
> each driver will be bothered.

Could you give an example of PCIe functions being described as platform
devices, and how does that work for Loongson? Are you saying that there
will be 2 drivers for the same hardware, one pci_driver and one platform_driver?
In the case of the platform_driver, who will do the PCI-specific stuff
required by the IP, like function level reset and enabling the memory space?

