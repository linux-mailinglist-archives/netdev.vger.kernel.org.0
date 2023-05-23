Return-Path: <netdev+bounces-4596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E40970D7C1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6F101C20CD1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B63E1B91E;
	Tue, 23 May 2023 08:42:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6369BBE7D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:42:29 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2093.outbound.protection.outlook.com [40.107.93.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD95ACA;
	Tue, 23 May 2023 01:42:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVNjuwOcYTT8L8QnJyt9N7CHzL8lKoJQmn8H4vt+7cfloLX5VRF7a5xASPvsSuQDEZwNZvUHwKTF8cKu24H6ALpOzsfAgBBNLoIapLwntT+SYPQy9Agdt/qlW8y+3eYMKjg8FjdyEYsmwxA6bS9hMSpoN+hi3PsMmxZ7ZCHaIIwqPLA+H/uTFjTNPRxYI3JzRWYPhUqwau3gDQTxfAuZ46iqgapZ7l4xrD5CT7n2G74iBkFLe8DoiIlw6TmjrZMn8tqbzoGJLV/RAQlVCX1kvb5yxEEgqxG6fKuJZRf8vusnTRYmiWzhxv5kvQbTniJ5pQr0hC9U7EfmxSvlKweqMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nhpwo+3TtICSv1eEj3G7MPyG7Owp/J8qEGITiXfIGw4=;
 b=oQx3kvdgmMcw/S0q269uWC/uafrOr8igrGT0iZ4WwjS+G3gB1JAQPzePDzDZ3/NpJbZJnmJ7u4tcKaq4OlTvnyE4W+JzIy1QMXw1ZPL359PxfrWTss4oPTlFkxWLG8Jcj8ovMFUW2qXUj8TEFtm5VT5GRExJ62UFY/J6wAJ5tDA+Hm20Mju81iEaziWuNWH/tEzz461lnFoyHofpDuuG8smZQ6zqjQqAUKVcMVp5uZwKTfvHFCwzeszw29eN/+INAc3px39iVzYeerMQ4R2ulLLgmZaBnEez8XZ/jGvD3KZam5t1LzFwWE0jpz44hK0yXkv80LbZbH9LUx4qLiraCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nhpwo+3TtICSv1eEj3G7MPyG7Owp/J8qEGITiXfIGw4=;
 b=GkwJ6m7RlkBHwqfZri8+8sjRIPRh9DoHz0ltRO4d2AV78vPnhPhjeM8k12yaZOv+Y27sWLN3DSx/FXSXMVCudPZoAKfPQDT+/9BaORvM3OAOvloMAziJSBiR5UkAwtZbOzm6vLFcExGshV4ZP7fhzNa7RIaLMMJh+zpZOXcu1Ds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5616.namprd13.prod.outlook.com (2603:10b6:510:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 08:42:23 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 08:42:23 +0000
Date: Tue, 23 May 2023 10:42:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] 3c589_cs: Fix an error handling path in tc589_probe()
Message-ID: <ZGx8ZaZhhX8Lffip@corigine.com>
References: <d8593ae867b24c79063646e36f9b18b0790107cb.1684575975.git.christophe.jaillet@wanadoo.fr>
 <ZGthVr9FppjWDA9F@corigine.com>
 <59ca8e12-a4ab-7f5b-68ba-fe04683b3cf5@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59ca8e12-a4ab-7f5b-68ba-fe04683b3cf5@wanadoo.fr>
X-ClientProxiedBy: AS4P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::16) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c9100e-cf0a-4390-8ee0-08db5b699f73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iJ/wW5HoxeGd6IB9huWvUxSicj8cC217mOvw+vZlg/kKhrE7xESPnJ0a6URD9fQCKTdIgnqLZuWKfEIIeILdU+I8/Nr0GndoaRstfjqqZEjl/M2a4ddWb7EkI2PJV+H5RJrruxyXUxAl2CKyC/j05wE9LLV1CaId8ba2az6mPbBgjiBakK1Q2GlKjCpbVAB7lNjn93Rg8YITlwaIt/z23dOEY0UDcPyHpNCKGu1A05slYbxQdyiXdkFZa9kOwAF14IzIyFp3StaUr6rfGO7R4OFVTuVPobEEwW/EZ5n9ppox6CdJqFEHBYhSqnW58r+7UoZsUpFoqM89saLOTkcvlEG8kHNkOjbYiOzdX3xRSZIQsPjrFh3VwUnVL27a0lxLlBbiIySaqcZIZZ/3abtvt0qsrGgPfxjvtEG00KEmNsGyH7vhdNmViKbkD/G4kym6TgeybgVxm80KYD81Ih6P6eOD5fAEKDQ6turUjxkpK5+9FrrD3EVsg6Ha9VqX4L4xmTHVAZMfwB5fbDdgQbwZvV8jstrqTVPdbFhIvEUqGgFNaDUBFXCE5AVu8dz+kwCI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(376002)(366004)(396003)(346002)(451199021)(2906002)(6666004)(38100700002)(6486002)(6506007)(6512007)(2616005)(36756003)(5660300002)(8936002)(8676002)(44832011)(478600001)(54906003)(41300700001)(316002)(186003)(6916009)(86362001)(66946007)(4326008)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REJkV0s4V2lBMnZ5L2ZoRU5RdzFnUnJwWVNVRDlxdGgrellXZllET2VpSm8z?=
 =?utf-8?B?NUk2NFlCZVNlL0RPT1d1UlBBSDZFWjVWSnk1Q0ZwL3k5S0ljRk9mYld2Nkhw?=
 =?utf-8?B?c0tJNmN0elNhMlVKdWU4cGNod0pOL3lZTGVkRHA3Q0ZmVTAzQXFwSVk2a09Z?=
 =?utf-8?B?aFl3SndJcWJzWkppVE5LRVJxVkExdXlaTk83RFZES1k1MkVsZzJKRE42Y1VL?=
 =?utf-8?B?V1libGVyMDRQOEVXam9mUThkTnNEdUgwYVF2UnZZWEVCUkF3aGU1MHBhN0JU?=
 =?utf-8?B?NWpIQlhCVFRxNE41YjR0eW1RWmhvQlFPQWlwUkVzUTk0Mlg5SEM4U2x5REFD?=
 =?utf-8?B?WCtSc1lhRmRMOGIxK2ZIWUZLZUt1ZG43ZnRRSE5xV1ltdmJUNGJQVkVtaVhj?=
 =?utf-8?B?ZWxaVEdBMjdlTnBaektrcmJlWklPZHZVblZyZ3VBRmNnbWtLTWJOMjRDOFNr?=
 =?utf-8?B?NHJLWlczblJHWnJ5V1pMSCtQV3lmRnk5Z3N4OGFDS0NuYUszRmZhMTBEdlJx?=
 =?utf-8?B?SDVqamZHeTk3cmtvZkRVMHZBa0tPbXZzUkxCaTYrS1NJdDR0bHBLVkpmWlk0?=
 =?utf-8?B?NktFUHBXL0pxY1JJVU1nZUt2M0Mwb2syOGxZYWNNOW5iaXVEd1dnSWdoL0ls?=
 =?utf-8?B?Z2k2R2JOY1l6R0JKbW9JSDZDUGZxbElDcTJWL0ErWHV3dDIwbnRkNG5GVllO?=
 =?utf-8?B?dlFCUjh2SERQWHNSdzM4YlBYdi9MY2Zta1M5amNZeWx0d3g1bHk3T2FmaDh0?=
 =?utf-8?B?eGVMUC8yQWdkSkV5QVFweVN5bVBIQnFyMDNCK00zdEdqaUd6N3hCZzNZcjNK?=
 =?utf-8?B?bWhFeGRRY25Cam9iNE9YR01iQ040anVCeFpuakxDVHRkQktJV2pMbGVkdHFD?=
 =?utf-8?B?d3VpTXpHbFlBL2toSHdoaXhFK3YweWxsZ3J0eXo5WTJ0WmRYL200a2J1K21O?=
 =?utf-8?B?U3E2czJzd1c2VE9CdGFiT3JQbzdPYitROWdzazBHZWNKOWdRTDlobzQ1OXAy?=
 =?utf-8?B?K1Rqc3Z2dmFjS1ZPMlRubUtlaVNEM2xWVXhkU1ZXYkFQYy9pbVV6L0xRS3FB?=
 =?utf-8?B?bTl5TXBMRHMyUlVOSndpY3lGQ1k0OGp1OEZTMnlhVWZsZFN4WlVFeFd1aFFj?=
 =?utf-8?B?QzBMczdkbVo1a2g3emIyei9SaU5XamYvTjRuUXdxTkJVMWZsSW4vY0FxZWZt?=
 =?utf-8?B?MFdPeFFHUW95T2JORlF4N2N4dlVjMWpNR2F6VytUNnJHM3JSV0k1WEJCSmFk?=
 =?utf-8?B?QkRwbFJQUExUUDFrZlUyay9kTU5NaHBBREVEZjN4NzFBTWVpZVQzdnA1UVZL?=
 =?utf-8?B?VDc3UEpDN2RCYU8yZUQrSXdsYnlwbXdkMENxKytIWVNrVEJKblpiSmwvMTQr?=
 =?utf-8?B?c1pNRDlrdWJtVVFBVXFXSGlBVWg3cFpINmwyaVJ3NGpYNWc0NU1MWmxEckgx?=
 =?utf-8?B?by80dU4xc1NNTmZTMGIxMm9kNkdWampwS3duVVV5Rk1XTlY1dThtK2w0UkVI?=
 =?utf-8?B?SzlHWWxhZzN3R3BOMGFoRWljd2IrOW8xUmYxT3JMYzJ4Y0lhdmNxUEs4eGR0?=
 =?utf-8?B?UklCQzJPRWVvdE9UT1JLaElEQlFxeCtwbjAvbGFIeGdjNHoxRzg3Mi9UOU1x?=
 =?utf-8?B?UGU5bmVtbHFUOUY1cm10ekJIWXJtOUd1d080VUZXdkVaOEwxU0hQNWxqUXlR?=
 =?utf-8?B?Znd5eU1TMEQrVHlOd3FydW0rc2M2NHRCT3BqOEFKL2hUejJ4SnRCcXlyMy9K?=
 =?utf-8?B?cUpjZlYzT0pqbXNJekVhQ2pkY2VDdDlPa2x6TTl1dllhaFlCWHQyTGdQZ1V1?=
 =?utf-8?B?Z1c2OTJxMVAwbmRlK3lYZ0ozdUxSN1ZZUXNpRUNBakdSSnBmTDZTZGcyVndE?=
 =?utf-8?B?UVBzZzk5K0RLNU1NVWtVREpzbDNvQnB5Y2hLNnFOVkoyNEhEUlpPVXhQeVRB?=
 =?utf-8?B?dmI4Wm05Z1F1M1VVWU50WkpCaWdhRUpvb2JGQlJkUnN4YXp6NFQ4c0pLcEh4?=
 =?utf-8?B?QTRuMm0zRUJTWVdZdHZidHM4TGloeUR5cmJPSFF0alFSU1BkRitUWElRWFl4?=
 =?utf-8?B?WXFPdGgrcEtNSWt6UEZpUVd5aU5wSUdKR24wcTI5cUdDK1VYNkp2RHBkQnZQ?=
 =?utf-8?B?Z050YnhxRmd1UC9JREdRWVVMc1ZQY3lkQ3ZzLzR5aEtXTStYcWVCYjNhaG5k?=
 =?utf-8?B?U0hwNGlQZTVia3pVQVQ5VjRnUW9QQU1SQTd4ZW1rZU9hOFRGSVMvMUNqV3hM?=
 =?utf-8?B?Y08vTW5oS1NkYXlHWE9HOVl1KzVBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c9100e-cf0a-4390-8ee0-08db5b699f73
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 08:42:23.6335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9612p09OVgd9vVjkexcS0CBUm+nr0mRkcaUIQPaCdZ87G0j1ZzvpFO2DlP86bpQStr0bbkln+6p01ctFC5L17wuNsYNuTKoyk1qAPF24liQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5616
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:18:29PM +0200, Christophe JAILLET wrote:
> Le 22/05/2023 à 14:34, Simon Horman a écrit :
> > On Sat, May 20, 2023 at 11:48:55AM +0200, Christophe JAILLET wrote:
> > > Should tc589_config() fail, some resources need to be released as already
> > > done in the remove function.
> > > 
> > > Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
> > 
> > That commit is probably going back far enough, but I actually
> > suspect the problem has been there since the beginning of git history.
> 
> In fact, before that commit, the probe was always returning 0, so there was
> no need for an error handling path.

Sure. But resources could still leak, as far as I can tell.
Adding a return value provided a mechanism to fix such leaks.
But wasn't done (until now). Just my 2c worth.


> FYI, commit 15b99ac17295 ("[PATCH] pcmcia: add return value to _config()
> functions") messed up many drivers for the same reason.
> I sent a few patches to see if there was an interest to fix these (really)
> old drivers, most linked with pcmcia which seems to slowly be removed from
> the kernel.
> 
> So I'm a bit unsure if fixing it really matters.
> Let see if I collect some other R-b tags for the other patches.

Yes, let's see.

