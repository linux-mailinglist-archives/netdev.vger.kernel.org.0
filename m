Return-Path: <netdev+bounces-6842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 145CD718649
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ABE31C20ED9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7471171D2;
	Wed, 31 May 2023 15:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C403116438
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:27:50 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2090.outbound.protection.outlook.com [40.107.100.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A62E67;
	Wed, 31 May 2023 08:27:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzDmqr4U8HH+DmhRabcSjx+YkQNel9AFtH3za6h3tYandqxJ4wiNCKCWYT0w+NOaIZaizS5JMT2iIGGa6xLdzGqN5+YE7q5DMIh2VlkVHTjqArTS1Yry40ProCv5a4TdY3nCVEo4HWVVRzd+3MD7EKIIKlWpjUHnuBPkV4+OPbeP55h9Xwy53M8YkHTpyQLGcwCRL9iEa0mTkmiMcXY76R0Ilnwhhy1i0G4uVeayTpC1pKs33drfkT5AQxEWsAIh4BnOq+9uAg28Z0AG3W52q/AIqW6z2qsBvgC7vKUmlvZhwedD0xLdy+OQ4jbe8GlzYhFRBIlylij8GU3XXmI9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ExdNfCE95+UsDvhqQfq6sKO4HpfCp9XMLNZSijSle8=;
 b=gGU5ZMarDZK9VRZJZEqnyD7xRF1QMl/J1ozs2SilvAbwDlrgeYT/F9ZYsgURbtWdR26UYFM/2eocSTV9+ZlXrDRTE1BfYfcGFev1lxAK4m7FDL8gAdnTJfcD1Gl6dzJ4PzND1WYTOvkCSgbWRLNjiNa8DfOEnluqF+45MqYNXCfIhhDDF7XYf8YMOyk5dtFi4Nr2j0MXt08vO0SR/QUWzTebAYhWTrRK+w9NVShsGv4i5PCwpLvO5GnS5u07M5V5N4qhwTOlCdNAy/j7SIonqh11XLXWI4t44sYz5BzxVvxwXE44sgkcPpKbY5ycHRmQ50CgtvboCRpUI1PyDGgxxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ExdNfCE95+UsDvhqQfq6sKO4HpfCp9XMLNZSijSle8=;
 b=FGBmPSsg/TEJqPBhti9wNmp1FdNb+EtMihX+XUCqrVwUeLOYmMOvyPV2GsAaiPmRifomy1ZaOZ8mgAn908Kq089CAcwX9VXWMq3kgj9XyvvHJCOYKw7Bekg2a2mqMVHxmKF/EEztd8IEPpaNAfVD1IIb0rLCufH6FcQq3/9ejmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6534.namprd13.prod.outlook.com (2603:10b6:610:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:26:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:26:56 +0000
Date: Wed, 31 May 2023 17:26:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, pieter.jansen-van-vuuren@amd.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/sched: flower: fix possible OOB write in
 fl_set_geneve_opt()
Message-ID: <ZHdnOnDaWYPEzQ/m@corigine.com>
References: <20230531102805.27090-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531102805.27090-1-hbh25y@gmail.com>
X-ClientProxiedBy: AS4P192CA0040.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 7031f1d0-c572-4341-2808-08db61eb7843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wEmANTof51wbzm7FdqmYzki60s7bS8fWxZd/ZreqBFPrVOVCHc19YvCqg0a6TLWoruZ0jtmVSOVQcOHXM/eCFP27DXQm2m+vEw8Wy+Tv/ldctMeJQNG0H01Ll+75jb1arIUK6F5t8CS9bzcXq6Wp6bHUEoWm1AIEs4g588IQ+RsiKvwyK0cQ2MDoY1fLaDHz6n+oIFEjpjVesIs8swMIsNnpsqzishX/3J2GL8auF5NqUF7I4zJFpW1ScwMuqBhqfYK0CgsgTPKSeqnlTNkPyqJRB1esJ5rHjiYVm2Se6tiFZ+XM8tAFAanhY2zXSxI84YoYvXw+jN6ub+McfcFjZukCYlkBskv2wCkzJLx7CT1uCWZLbCjbuzZGq4ef1C949/nQD9JEU+aSR5SbivQ8i+z1/nTWjb1m1QzUtowJiJVu+pPd2Jeg3UmE9w4wQxuR02rjg99UJSWNo3ZlxrE8LsZhveJINc06LaMyoW+BPsoFdV/d3cDgBPoUfzRSb4DJJ8kZnOlTVUzmO12Hy46PI+q/VfooHx8aLDzcDgxhTmsWx8uO4p6OuRfjXa7eCc5HShuV/u94lvBouQHnCj7j/PZTk9FXT1GUA2yPL7O25GY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(39840400004)(136003)(376002)(451199021)(478600001)(44832011)(5660300002)(8936002)(8676002)(7416002)(6916009)(36756003)(86362001)(4744005)(2906002)(4326008)(66946007)(66476007)(66556008)(316002)(38100700002)(41300700001)(2616005)(186003)(6512007)(6506007)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rVz9dFJphUGYhiwKycaT9V/rb9iaEiArXDAhVpxIEjTKM35mNHcaRfxF7mEM?=
 =?us-ascii?Q?S7Drhr5QdgOWYizSjnIju1L2zUgv1BJVmo0NrFNqX9DyZE/zPy5VtOWDmecO?=
 =?us-ascii?Q?VBUKBrZF0ChVil/n86X0hzO84n61G1Bv8flPy7md6QDxSIVC480kHxImq4rg?=
 =?us-ascii?Q?BtvdjaNorm5+5dw5GGFyFl0FqvVteU++TEYrJFPJvob1/7MNuoN26rd5pXWV?=
 =?us-ascii?Q?B+xU7Q0COKazjlaTIQkaZoD/C8au+OTkOZP3nim1kq62WbPfQ+B4Dng5AASB?=
 =?us-ascii?Q?p8uJZlxJ+o5cLObVOo9t3YKIR+4rxeBiareUdENYYjOSmEQiYPvmrl3Xsqjq?=
 =?us-ascii?Q?9Gc/Ef7f7gFjb3+1tUKtLgBjYKuoLHxryCbqHVvViUQU/Aubf3VlUxTjwR7y?=
 =?us-ascii?Q?5uxK4jqsMiV4SWSDJQ/p+ahFEnucV3gxpm0UzwJUdxGMYGuTkVFCCkNeK4pZ?=
 =?us-ascii?Q?B3y9HjHzMOuD15kt/pl9e4tssiY4x1p6q20SxhHZlsg5THceRrmEVihXQ46m?=
 =?us-ascii?Q?hqT4LdGSc0RVs7kqo/yz+zE4iUqOghAasoHeKV1v5pwWVaypDA8IjDbHFVvC?=
 =?us-ascii?Q?ATDgqCB9iHxugRJw0Qqsem4MTUuGja89I5f85fnrzlnzrK0/AiuaGVH3XuX+?=
 =?us-ascii?Q?ffAyHc/wbZtoiUWUbam+u40gHuC8Z3O628JWDjsFiNbGWAmeiyY2L3F0qq/g?=
 =?us-ascii?Q?eHYXse/vbklttzcZmU0t1CgefHDQifyd5ICAecs2CmqeRtG1NQAif8y9QDEL?=
 =?us-ascii?Q?RIzxFmhQxx1WxrUqbzpUmYR32r/xBWssaDqnGj0ypFJOY7vpHVB5+g930Lqc?=
 =?us-ascii?Q?Xl2U6W/pjLyMcA9o3D9ErnFQZERB37DwhQT5nwLTBafK382PLCcHj5jwXJlA?=
 =?us-ascii?Q?xWjH1I+DjuWM70AqJM0R2KLcZ11CqnlEHGEEwNO3UqomFqND+nEnu/bvLJMO?=
 =?us-ascii?Q?+/uT+nOqqipSNgODP1t4DUzw4VBjZeO/YUCXoirtuQl2boZVW0ub5OpM7++b?=
 =?us-ascii?Q?SDU6hHjtseK/ztb+sr8DYCDuf4depVl7k/5cEYu3rVLAxCjOxKbhWRlkRHqC?=
 =?us-ascii?Q?mxbGM79vayc1bqiLEDDOk+aBgXG6RfaHt58CcwimjD3LGGSjJioHqWxphif/?=
 =?us-ascii?Q?4Fu9Im9zSJQ0xKvX5cBxoKYQzE/1fCQG9GgLKWPmaEyL/s2XR238QM0qRRoS?=
 =?us-ascii?Q?DwOEX79kr2nPSr0VzIRINoQqmC7dtmhznwRtDFzc0fDeZqutN5sCOilhxR5D?=
 =?us-ascii?Q?OYKKHBJjo0QZ0iUez9SopGFgavt7WmrRgDyEZiftcdHGWaYiNVOktt+PHccy?=
 =?us-ascii?Q?IVJV1VcsQvSYfMrEUQa/u5P0vdW31Ffpkcnrxf6Chta8YhCoJMjmm2Q06q4q?=
 =?us-ascii?Q?9SoiHNDWmbNqTf3SXKOQS4AM9vvHuLavdLGq21uxDM4U6hmjAfzpS3tGuNnG?=
 =?us-ascii?Q?wxyBE3JKAVUzQsHMNqu602rQ7+wOxzulJlneb9G5VJUrcKHkTuDtYh8ygSE1?=
 =?us-ascii?Q?cX3uOliGagEIfIDDq0hEmXUlkaKuWAligIGaE1MUOBtnUtOENX7PSgsd62yG?=
 =?us-ascii?Q?VZ2TDz1GOGhvMR4IHTeYpeN/nDNHmZ1L3lxH1E8Txgeiv4d1BysB15t1aS19?=
 =?us-ascii?Q?X59PBHank6Ns3409jPFC1yI1Qd+zKV4nsZBJhD/z1LIiixBv3qY8rYUMvog+?=
 =?us-ascii?Q?NoKUVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7031f1d0-c572-4341-2808-08db61eb7843
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:26:56.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9r6ji3HPMgZVpx6GMQ9rL7pE8pGGuGbwCfGdYnMBFEn670bvM+S+/5O2ta7IVm2lc4MOiW5srjHQR9uDWvE8HrtZtUYZIuHGEq18EOplN3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6534
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 06:28:04PM +0800, Hangyu Hua wrote:
> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
> size is 252 bytes(key->enc_opts.len = 252) then
> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
> bypasses the next bounds check and results in an out-of-bounds.
> 
> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


