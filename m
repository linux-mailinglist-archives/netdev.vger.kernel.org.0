Return-Path: <netdev+bounces-7783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2F5721797
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C75DB1C20A1F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0133DDA3;
	Sun,  4 Jun 2023 14:02:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D6533F2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 14:02:22 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2124.outbound.protection.outlook.com [40.107.223.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FF1E45
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoBSDZjLUvdNbXY1wwjxlMokRmzRc7/VgZzaW6d2mOyNY0XKXPVFptmblErvVUPOkf5ugSOq9BlMgH5icTOZib9ObrxhhYaXNAiIMVr1HIE4HyNXeql6n6GQhBHzoRaM8qGgqv7HKnOX/h/7oS/RrJAjJtYkQf9zCpZEzsa4eRWc/fBY33Sp0yYzfjeVJi5fU32+ADIYuz0G+Poi1Pp9w9qerpXL9GhsBtKNzv4Mdeqodbh2b+6MkI7f0QkND+QDwEBMWDyrIzfGDGfDdADZ1gXOz7D4L3NNDAyyTLYKbTdUZYCnaN2QJ/vtDfnGvNoU7YbC8J1fOb+V3w86GZnmNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kvtpGreL2esoAmQHzVL4MLczmw76jV4g9c3jLGf5qA=;
 b=TCTppyy1eN3ty7t60y+c0mYrag+hLoYNTSuhcXQWJmWmAFbU1wmmI7U4J5BSE4fBjw+u1T/+sHMxrwkaj4e0xAjGpyddX3MXOA9MvUtf4SBJbObMDCMdc3u2XLnwFe1V7LjButIZza5uDcPjiz3EBPBRua8jfRkfSwP+P0lEv9nnOhvNpIXzqhVW8gMdILvJLsO0KqAI2N7a8dAtpGjmhCTw4fHFbMWHZCyA4nTb66AODlMBIpVuPKCG3rKtsACxV73jw5pAW714GMsYbCH3wb2F9YrZ+6l+iQw7VdDTNK/LcH42HrVhqoeo9AmbF0Gy3a18GXX+UgTXSKb1kQ8myw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kvtpGreL2esoAmQHzVL4MLczmw76jV4g9c3jLGf5qA=;
 b=ERx3OX2QOdocHRSZQqoYpIaqL/iwB/d75OH8verCmmEj09uZLq+q4vf2UfSjKfDogyBqNyDguuUbBCWieMlfHuVHMnEfCGJvFnGFXx98wrX/tgurGcIdS1c6gPqjVG/DR2uQUhZGuSjUCEWeq6MZm+IySmQATKtBrboKadnymME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3692.namprd13.prod.outlook.com (2603:10b6:5:229::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 14:02:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 14:02:11 +0000
Date: Sun, 4 Jun 2023 16:02:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 05/13] ice: Unset src prune on uplink VSI
Message-ID: <ZHyZXLTY5bo0C2CU@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-6-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-6-wojciech.drewek@intel.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3692:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ae8643-c6b9-43f4-2e3f-08db65044aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Hbp72TtRsoyohda69c3fQEhHlvoRlKr0UzU8CdUoN5rBfEasiYyRVZXNjV2wwQyQFXNTN0LZjfv30eqm8CIHaSRhr//ZBOIj9yVducSlL8fQtZGtYiwpVu+FtiraYWC7RfKvZ8obh/TzZj4CkxYAyLE1BC5SAH0spK07atkg6VeydZiyhenM17AQHSCvbP3kT8qAATltYAnO+R1P/oS3ourKiGP6GEiFPbEc+KDwEMRHlwXdA/ZYIrDiBjdY7Ci9hw5rfE+jFWfroxxZi0/c+zfCLcqabTyFuEwrE5Gknyq9cTwtX0P9i73M9vqjM/nXIwldK7/wWzeb5VUOwV2T3JBsumg64K52jhWFWiZD8JJEDOv5P2jRZx7FxSdSUjSK2VOtDJXMrys9egfI+ARznjDCvJWBRpxJfpA7ov33VKStLFFDRXFojMcO9zaz9m3dbJSLN5feeQN7VkjoWvcnEhuH0iLk93tFTtxc+++12Nu7jPbFTd6F+yR5S7oxhTqt39zflHYvX5vRW9p6xtUVIg2M3mS/9TQLEkCFBOLGOek3TzS2dT0XT/KX3LRiJQpj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39830400003)(346002)(376002)(451199021)(478600001)(5660300002)(8936002)(8676002)(44832011)(7416002)(36756003)(2906002)(4744005)(86362001)(4326008)(6916009)(66476007)(66556008)(66946007)(316002)(38100700002)(41300700001)(2616005)(6512007)(6506007)(186003)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JjIr1Kz3ZQ+AJCtbNH7X0QzhlfsxVqp4cISs+lZKzvkJpOMB9QCuqP9CQMiW?=
 =?us-ascii?Q?ia1u+egORIpaSD2GU06e/3CDlypTciyQyxYKsKQY49xKjLtyI5Gw0J3KpsrC?=
 =?us-ascii?Q?aeeQpxSuCBNdhvGHavpPtCjMaE2FPJRyGPUMd9V7Xk1gsH5xhtaDwb2XA9Rt?=
 =?us-ascii?Q?R8k+zFEk6XHObbCcWWwp5Tj3uFHtiN9vJMHV1l2F71nZ5CcCH83B3lWpkfIi?=
 =?us-ascii?Q?fMB26jqxU6Jz5qW1kf94ClqhhjyVFXKxt0pN83O31vi1UQtZqH+7KTI7Atqy?=
 =?us-ascii?Q?bn/OwCXWB1VVsYQUd0o5X3LmXXllj/ZWoYg3efWx4zZjj8vlmMsa4aJ51F7g?=
 =?us-ascii?Q?QrxU5YBFEcfKfgSgCUexatfeYzIF2lSiJvWk7LT4NSStULFuFG29RzPoGrT7?=
 =?us-ascii?Q?qmYgN3+PrA8baMFgjKx18hHGxiEtlXbJLMZlR5pz6qzI9rj8aintijE6eo0o?=
 =?us-ascii?Q?IbVYH1S/r+g4G1N8Gr1ZBTVFibPX1A1xZTkTzoSdctUkWLSGSpQbUioA2sXc?=
 =?us-ascii?Q?xrFAEeaxrAycuJDNegZlMHJaGPqRycXHgrBMHTpmqoEgZn7dVBU0+NH33sMh?=
 =?us-ascii?Q?T1hFemSVzgff7zjUyrIQTulQMo3MsIBws7RjIGp5etMEHMXwMEnXXNOWFopN?=
 =?us-ascii?Q?ppUj0BgffD9X246QH9AhHNgKj+MKujnGMTqV4l3hms+wS2XTaYP63tXDHJX6?=
 =?us-ascii?Q?Sfj1E1Nm2bM4i7xA3f2oMv3UgJclZjxBsXS61KXP4cIHVeIpEQVHxf3URhs0?=
 =?us-ascii?Q?LG5cZB4kjQZJYXZnDQ2GJjRqWF+2M9p3Oz7Enrfhl21p8xMzpmK4Edq6D6TX?=
 =?us-ascii?Q?Af8iz94iHWjvY2ie0w5NwQjpPN6rGqfPBj5WqcYHXW37frbkD3AptqM4w+zn?=
 =?us-ascii?Q?YzAXeCiByFCXQIkgh1v8YYyoW6CtnYC/xeKxDfP6mICmgAWDiTZPISNedcM1?=
 =?us-ascii?Q?Zf+maIKqWiRtl7mVlY2GZFwH/j3ByuwbxkSF53AjJpI6BCQqcjKPuRCrTQUn?=
 =?us-ascii?Q?peksPeo7jioyY/wG14cnjUGhYLGL6RvAFUSNb8/cqzHLt+XsqMY1UdEDz7ie?=
 =?us-ascii?Q?pLZCrNdMWQicz5fPTbh/ZyNHNdvTf3pr2YifQ4m0t+pT+a+9a4sYMPvzNBL6?=
 =?us-ascii?Q?V/tZFl2CDUQWUqDNZ2b+Ai/z2DLTyL20wMqCRi/DBcDpHxowmshLNs679RHr?=
 =?us-ascii?Q?6/LKbuN6AjyI/wlGI7/5yfVYv9ig4EoXFqmLYto2KQrSfD+mPbxCyTx9RdYI?=
 =?us-ascii?Q?n8TkFOPOSHM/9t8xeeBWN8QelsjWuMXekg6Y0+xc5igSrumR+OMbCGZ5beLj?=
 =?us-ascii?Q?sqKhBsx42mWElh16SVhDI1cYklZWu+GSbe+yYoCzs/givd+Z5n/yNUU3ApO8?=
 =?us-ascii?Q?UnrplTPS8iG6rfzqX1QJBZnieNgU2+cQ8g6AmYPRjiT3usucqeUclphGwa39?=
 =?us-ascii?Q?HaEIMzX/Du7GCO6rbC8okaZXNvJ8/Wf6Q4SduS/B9TSlXwk6C1H0UhO75xl4?=
 =?us-ascii?Q?lWs3OuFvZcG0M6R6YyQaIGTOVrSeBz33kzLSmdKsSFASUXavEx6TyjeNigJ/?=
 =?us-ascii?Q?RZix/c8WLglTadrOPpjqGSs3Xr2mKOqoPucoS5KG+d9Lk80+kBUQ9KreS3vw?=
 =?us-ascii?Q?G6vdabDOlEBkIupYwI6ZYKk1tpuv1fdGhpGbagqJHiFve81Jsnz1meHERkcW?=
 =?us-ascii?Q?6QuLpA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ae8643-c6b9-43f4-2e3f-08db65044aab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 14:02:11.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAOictq8udougByk6V7GQeP3Q8MsgxdHhHoLmf+KgCfNlF3ez09FNaDDDSIeWei+4IjrVJi7dm7oQZrEDs0OnltdbVTikK0xamr4eUZ0wrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:13PM +0200, Wojciech Drewek wrote:
> In switchdev mode uplink VSI is supposed to receive all packets that
> were not matched by existing filters. If ICE_AQ_VSI_SW_FLAG_LOCAL_LB
> bit is unset and we have a filter associated with uplink VSI
> which matches on dst mac equal to MAC1, then packets with src mac equal
> to MAC1 will be pruned from reaching uplink VSI.
> 
> Fix this by updating uplink VSI with ICE_AQ_VSI_SW_FLAG_LOCAL_LB bit
> set when configuring switchdev mode.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


