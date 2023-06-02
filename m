Return-Path: <netdev+bounces-7370-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0315771FEC2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82CE01C20B79
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132CC182B9;
	Fri,  2 Jun 2023 10:16:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F705687
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:16:35 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640E318D;
	Fri,  2 Jun 2023 03:16:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPKWoEIUOQli6fNzGW+38RlYWlQ0Cn6AfxYsfOVE/mBvrgW1aig53d2ymHAYP/ot0CSBOGgAgAXIslkbjNL0MA6iP8GNnHURAnbCYsrNv5wgUr2UtjhqoMLUCPx9VbcOGe5udS4WAFcszWvQ/aLidNMswxaS/D3I5aEU4SIgtgRZ1VeCHbxM5uYOYYwovqCEPRV/M4stT0S/bdcIg6Xew2RPYntHxrsQkPxu7FFt7lfCOuQ0JrViQ9DZp4IMNgELpxD93iYUaqU772KQa1iQgaG3dAqQUEP08Gt7zWgFZWzR2DU3sPmTP4mf3qLFjrMZVOgftQPxpDhqhElydpNBkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=palefHqkdCXUSxcSh8pSOE3kKrzI67pWlFf8WwKnHGg=;
 b=n9ZXXlWilQX2Y0ehMKSQOqL0byfaMEzLtE2RB0N5q3NbCua7UnI67mBnlOF3tANBwxE93C+FruxWMK64MXdxM6L4Tgi8I4FKl3rzg4MrEtlREXu7LKOJfoScOO+TMhlaGLvQKsuX/skpQ8yq9a2LSZVRvwu9VAtCAjvAC9X9ngWIlYLTJQPKLeTbofRe90AuRJq9C7nwdqo92lKRgOMqMeiS5PCNpXQc1v5DojByvWu/dNT8esU4vvEDyITSg2E2XYTEj2efb/8E0Vk7qL/Bw98o4yPeHn1s9lK0J1fZ8Y6QAKHGQ5ANLj98ok4scI9smK8vWysL0m5RDDrXaBOr6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=palefHqkdCXUSxcSh8pSOE3kKrzI67pWlFf8WwKnHGg=;
 b=V20wOK7JCXR7qEhc6aIr9/5ioeg2oCNSes8juMusJLoEL0N+p7sJfaIIlMDFBpTiGucQ01/h9djd9Sa/NplJS9zzq+zmbT46FNOTOUo/SuFFaTGAlSVupxbJot1Mus/xC7eV0dHahr2LKMQqyzNivXgg21kE6uAyGd43um3WrMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8855.eurprd04.prod.outlook.com (2603:10a6:10:2e2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.26; Fri, 2 Jun
 2023 10:16:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:16:32 +0000
Date: Fri, 2 Jun 2023 13:16:28 +0300
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
Message-ID: <20230602101628.jkgq3cmwccgsfb4c@skbuf>
References: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
 <ZHjaq+TDW/RFcoxW@bhelgaas>
 <20230601221532.2rfcda4sg5nl7pzp@skbuf>
 <dc430271-8511-e6e4-041b-ede197e7665d@loongson.cn>
 <7a7f78ae-7fd8-b68d-691c-609a38ab3161@loongson.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a7f78ae-7fd8-b68d-691c-609a38ab3161@loongson.cn>
X-ClientProxiedBy: BE1P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8855:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ceb6c9e-9b77-4c42-67a1-08db63526ff5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AdSKMjJoEwKOhzEGD1uj/wti0bpZVTkU1QzbGvSgCljAkDR8ZU/D9PCS3YskuegmMxQYE9kU1DHy2AKosGEq+ueSN+gsMemfaJLzT087nWMIrVhmxVbebr8KQJeAoktZRbUMhyy6rQKqo7Uer0Mrsm9U7JSIu4gm3CyGVcZewbl0gP1JS6hfgSwjPm7O91SgmDX4AEH6WuoIrmi5OeRc00Qcqv68Po4hd6PmQMYsYTr+4TMdiJBtgYEWJWZVBR4BRWwZSdDJxavef0VAeGMSda1sgBjCygANFzTK5q6ZIAD28kQuZYbqlb1CnPIzTEJC9hOAponsfmhRhajPBhLzHR1o7qFB457Ly+m1KnDxNNyoqdOjzG4NY6mguj7MyjUud6H0mTjXkPGffL9cj1BpQ5woxNrtvwatLFBO3EqPeRJbtkkFzMi4xYyKQlG8X7iWTl1m92GkwKYcoZyWC2tWCqBj/gYHFWp2hs/WJYuCnRL1ZbRAJB/7UISf4dRjJITm1pxycgM3VRVqs4JK2vdQg0n9GizhJfbCc94+cJrhfQg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199021)(186003)(86362001)(6486002)(33716001)(966005)(316002)(6666004)(4326008)(6916009)(41300700001)(66946007)(66556008)(66476007)(54906003)(478600001)(44832011)(7416002)(5660300002)(26005)(9686003)(2906002)(83380400001)(6506007)(6512007)(8676002)(8936002)(1076003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0VIZVlFdjBqbGwxWGZPT3BrLzdLbjJTRHJmeU1YNFdCV3dEZTYzOWZFNDFG?=
 =?utf-8?B?cUpUc09VVlRlZHlJSEJSQ0w3OHRXNzdsdVY2MjY5eWZVUTlpbG52Vk9tcmRk?=
 =?utf-8?B?RUlmYndaZ2t1S3Mzckw5UnBZbnM3d2ZoRXVXdjlKK1dsQ0ZxMVZCeS9uMFpu?=
 =?utf-8?B?YlN3aXZPaXhUQ0NDYkdjYndXM0l1NnVsOW44b3JDUE1UOThRV0djeGVMUkVI?=
 =?utf-8?B?eGoreiszclU3Nk90Zm11UzkzdG9GTnZ3SlZNaG12S1BOS1M1cEhCRlVHalJs?=
 =?utf-8?B?bWZTWGVFWUx6N01Eek9OOG5valJjeFRYMzVvam11ZEVIb0lJRUhHN0lTNmV0?=
 =?utf-8?B?a0xpODB6TE01MzBsSjRDcmNPTFZwazhrVVV4bk5UQ29qL0ptMmNpY2pkMFFl?=
 =?utf-8?B?RzhnL0pwdXRkVFBzaU04cVFYbnR3NHNzdUhjazR0cUtwamkxUnM2SXhubHZM?=
 =?utf-8?B?M2JmVURBSzJNUlJTSlBkNG5VZTljdnBEUFhrWjFFTUswT3FBQUlLTUZTTEQr?=
 =?utf-8?B?dXZuQmRJYlF0QkFobk5ET2tuWGMvVG1CZkJSVHM5UHZ2TXhOMXQ3U3AwZDJV?=
 =?utf-8?B?Z3lnLzU3Mk1kQ21mM1BhWExXMXVaVXNOUlA3NmhHSDdQa3hqcFpwRzMxemN5?=
 =?utf-8?B?SUtvUXZ4WEVCZWI2Rk1QUlRlS0YwRXlSb0JjYnhiMkRBMGhReDVLYVNoVHcz?=
 =?utf-8?B?K3IzdkRQYk1Ud0ZjRHJ6aEpySTMvRGNRSjZ1RTd3TUYyOXhGcEdCaGxJcW1p?=
 =?utf-8?B?RXRtOE1zMnJXOFB0bjBQdFVHNHg1WUxpblJmOCtnV1NxMmhTWHhsZFJrS3BC?=
 =?utf-8?B?Y0pHa2o5YmxqQnJMZndlYlcxditpOWVJTUs4WmdCVytEbERvWWtIbXJWclND?=
 =?utf-8?B?MnVaR1N6SUJ6SFpPeXpiNHRPRTFydm1XYitkR0pBaVJBbExiOWZ5RTl5bXhQ?=
 =?utf-8?B?ZU9YU2Q5S3AwaTRuK0haYldZQnhJZ0lSS05JVXhsdEVXUzFmdzBwdmZObWJP?=
 =?utf-8?B?MTl3RG92bVRzM2NWa3lVV3d6dkk1QjliNUUzRWxIbWF1c2wyMi8zZWdyTmhr?=
 =?utf-8?B?NERacGtHb0EzUHJacElMSWZOZ0JlOWtvUWJlS0hGZ3dQeGhoaW5lRWxPYmVj?=
 =?utf-8?B?YzAwbjlFZWcxNFpMenNmZitpay92dlBhbCtIVTh0NnpkWUplZUI1VUdZU1Ex?=
 =?utf-8?B?WkxHc3ovNUZORGdMWmRrMGNWajlVZzBpUXhtS2FYOHpwenVZRk1XS3JhNGpT?=
 =?utf-8?B?WExzTzg0ZnJwblVmZTZvSTUydHhqRmtwaEE3UE9JM0lrR0xUYndzMTMwRlJv?=
 =?utf-8?B?c3Q0eG1rL05sSWZOcHFIbXluSDc5ODEyZkJtN1RCakRvSmZ2VGl0N1NSdUdL?=
 =?utf-8?B?L054N2QrS2tHakoxaVpzOHI5T2FJcmR1N29CbjlOR09wcVI3VkZkREdFdzll?=
 =?utf-8?B?VmpnSlVMczNseUdIcDB2Q3o1MzYxZGZSc0I1WHJrUXhTZURkN0l5eFhuaEpy?=
 =?utf-8?B?anNwb3ltS0t6aEYxQkJpQ1FaaXYreng5OE0xVGhoWXlIRVFVYTJtUURQNXYx?=
 =?utf-8?B?RlhCWVQrRlNqczJHcGVUd2dKL1RlVTVFT0lzYVJTYW1GTjBsdTFIcGpmemE3?=
 =?utf-8?B?bytjeXFkT0NpdkJXTWV4SHgvVzY4WTk0SXZXeFQyWGxlYUlnb0NmYXNHQzBL?=
 =?utf-8?B?R21PTjVERGZvSkNzRzlRQUgwZytFTC94emVNRWJSaEpXaWo4ODlpZEVTbS92?=
 =?utf-8?B?RGJHTDh1eXJ2ME9Ra3lKc2JGaXFGTXZxdDUvN3FXZHpKVXhlMVVHTHdrdExT?=
 =?utf-8?B?VUV6MHNXNStIZjVBaU5NYzArd0dxOFJpRVVtY3pURWdvSm82SCt2c0lTVGc3?=
 =?utf-8?B?VjZ5eHh6OXFRdDduYUMwMklEWXY1R1A0VmhGUDdMTmk1SWkxcG5xeFM4bEZJ?=
 =?utf-8?B?VldRNEdBYkZwc3NOanNsYk9sRmZ4M1RuMGJWcmxJYTErWnVhaVZmdzdiVDIx?=
 =?utf-8?B?clpwN3pkTDc1S2ozSUI5bGpScWRZT01oUzV0ZjhlTnFTQ2xJMUM5M3JQWm1y?=
 =?utf-8?B?a00ycHdWeE9hOVgxNmwvaTdNTkJiS2NtYmR3NG5kR25QTzBzdHRHbURTUjdy?=
 =?utf-8?B?N2lzV3pEaXBrVWFLcG5haGdQbWxyeXZJOXBKQ3BSU2srM0pUaEFOUzdHbUZK?=
 =?utf-8?B?TXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ceb6c9e-9b77-4c42-67a1-08db63526ff5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:16:32.1776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlGtQ7tv1GvME9U/gCTyBialKuz6JrVH2p7yuq2UNOsU9Xp/nwi3N+3Jps5pqfOKPzvFEzbhNJmKI+Qx1H+zhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8855
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jianmin,

On Fri, Jun 02, 2023 at 03:36:18PM +0800, Jianmin Lv wrote:
> On 2023/6/2 下午3:21, Liu Peibao wrote:
> > Hi all,
> > 
> > It seems that modification for current PCI enumeration framework is
> > needed to solve the problem. If the effect of this modification is not
> > easy to evaluate, for the requirement of Loongson, it should be OK that
> > do the things in Loongson PCI controller driver like discussed
> > before[1].
> > 
> > Br,
> > Peibao
> > 
> > [1] https://lore.kernel.org/all/20221114074346.23008-1-liupeibao@loongson.cn/
> > 
> 
> Agree. For current pci core code, all functions of the device will be
> skipped if function 0 is not found, even without the patch 6fffbc7ae137
> (e.g. the func 0 is disabled in bios by setting pci header to 0xffffffff).
> So it seems that there are two ways for the issue:
> 
> 1. Adjust the pci scan core code to allow separate function to be
> enumerated, which will affect widely the pci core code.
> 2. Only Adjust loongson pci controller driver as Peibao said, and any
> function of the device should use platform device in DT if function 0 is
> disabled, which is acceptable for loongson.
> 
> Thanks,
> Jianmin

How about 3. handle of_device_is_available() in the probe function of
the "loongson, pci-gmac" driver? Would that not work?

