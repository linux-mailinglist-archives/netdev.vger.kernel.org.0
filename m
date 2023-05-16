Return-Path: <netdev+bounces-3093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 353D27056D6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5F011C20BE1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AB429103;
	Tue, 16 May 2023 19:10:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6A29101
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:10:49 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2108.outbound.protection.outlook.com [40.107.96.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D137E7A
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TT4eEhW6i5L7nex3a/YvJgo8yJ93RLmG2/G1CXdEu0b2KIyE1WGO/aNjf6Xati+8PThlVfhvD+oyNf9OKONVXHp1z8R05+x8SX8JJPjoBgr232zGTg/3y85HSW0apWioQvSYakcMFnu5MHNAMmI4dkLvllrQB8pvB8M5C/eZTYM8G0257m97p28b2Oh7gZBZWKkgCIaFLnQbtKgomDS/ZDffQ4LdGYG15yHQrJ0yUvmNnY3zlbd06uECjTi33FsHe4y20qDSn9wfH7or96hn2TlGrUEGQ4c5CluDgPfu2PxR/gixiPNd/Hn2dtTSe0Cb35S2JdYlyzxUR++F8WETpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZT4GFbSKKQ5c1FHZa9xD3GI0i95DZuQ3kziyfn+6dQ=;
 b=AC8mJ2F2WpfOpwvsWWENN2MCNkJ28MwYnd1+2CQz2iGNdB35yx10n+93eA1WVCE1UN2ZS2ShM/3A0XRbnZNC8Ckcpyo2udHgeoAKKiAEQwEZ7fE78OCfO4sQkdXSXJpeVivFjUTCtobCah/00FxA2ijpeVi31Wo4iiPZkDqfBCrDl2iPs20PrRdq5K1FbGQxKVzMXH1d/aAop7yRC8d5c7kdaYSI4hQ2DWuQeyBSCUZFz3HgzDfKh7wyEESilAwZh6jQ634X5URt9Dcrg8Bp3veuazdNPCggqXO0R52u/QVMgKGSqh5kAfTnvlRJECyIumbnBnhA1q4Vx2jDlbmqcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZT4GFbSKKQ5c1FHZa9xD3GI0i95DZuQ3kziyfn+6dQ=;
 b=OZS+0YjP7HZOJqgWGkSmZm5tNidGFng7kEUrVDN4G0fc6sD3OOY6gopsPyhbb0jUG2bjj74xSdGWda9FMy2FjxIwr6VOOWp0nOUu0+GjmAyJC0ud5Wa0LU3AygH9MlMKpZPZAeyTg4ytklhoxUCCa4FxfnuiP9TEdyOT5N6JDy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4075.namprd13.prod.outlook.com (2603:10b6:303:2c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 19:10:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 19:10:44 +0000
Date: Tue, 16 May 2023 21:10:37 +0200
From: Simon Horman <simon.horman@corigine.com>
To: m.chetan.kumar@linux.intel.com
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org, linuxwwan@intel.com,
	m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
	Samuel Wein PhD <sam@samwein.com>
Subject: Re: [PATCH v3 net] net: wwan: iosm: fix NULL pointer dereference
 when removing device
Message-ID: <ZGPU6YvUJIHyoh3d@corigine.com>
References: <6d9e4d90ec89d8ac026e149381ca0c8243a11a19.1684250558.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d9e4d90ec89d8ac026e149381ca0c8243a11a19.1684250558.git.m.chetan.kumar@linux.intel.com>
X-ClientProxiedBy: AS4P195CA0049.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4075:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e782e22-fd8d-4175-a26d-08db56413f9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iqVqBm4sm7TlTBlHv6e+FG7PKi5i0yofpqCB2qUM1Pr76o4lnNtIGV5IT3Y+eETSZZcW91YvtqX8dZbGIXLlWplHwwVK5043k9xQ+Z3+kc1NkE/ed4p6O7LDniCNQbz+EbgD3ZC1b5t7jAgQkr2kClKBBw5g4Pw/wyCAWBTbT/sMgSq9a53mf9gWeHbwvlFluYypgschdzaQGcB/FBPuTS/o6lgf4BAlM5CZb08qECBxq4fkscLmNMljmHgZIL0m/Ragb9nsPJXbRQonOMR4WImPhcTtgroXUcWRSi+t9DMGEmO3NMtY2RaNK+knvjTtYT7d0k3dC6eQiTZZwYmGBLOUthju9UAfkCJnBupPzc5gpDVZDmdKzyfJIJoovonYm7kHXvT4r8AwADwyekmtY4nx/CHmJQ+ZUDlhXQMUbmRMjdDkWm6qA7GG5xuwBmdapyPqz+IAaJox+V3kbrz1aPBqNiQHzC5n7w4LqpMlZOZD32sSXyF4MYu/yPzTN06jD2OyaGM7tqGKeHdQ7GoXAKXnmMVWcwo0bx1rwi/pwUbMmQR9VW1UleXS2EMUvH0NfoiugCjm8LZI4DYPePpiOBFZOm9yJFWvkEUF/8R/oTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39840400004)(366004)(136003)(396003)(451199021)(4326008)(36756003)(6916009)(2906002)(7416002)(44832011)(8676002)(5660300002)(86362001)(8936002)(41300700001)(66476007)(66556008)(316002)(66946007)(478600001)(6486002)(6666004)(6506007)(6512007)(83380400001)(2616005)(966005)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BG9JKaBE1+4KnotMbI89VQt2PjIgmLDufacv5AAY2+pFAjqDa8e7cwk5IXNu?=
 =?us-ascii?Q?O5g31LJC0kFn/VZvw1AteigpP5LfTu8N8xQdkZ/isP3to2CDEhvnnkcJzxRJ?=
 =?us-ascii?Q?FvINLMWZv75wIl9Q2OYQCM561E6tr/VRl3JievraxPY8FB5HHlbSDaM1aL71?=
 =?us-ascii?Q?yR46rzcc2N0goBW8LnGuxsYSRpqOzWs+u3on5FKrY9RT/uS41SU99J5em/qu?=
 =?us-ascii?Q?9dO8lL+8CegWQ4uM66aqClgvQPM7IBzJS+FBEDCq7DdtiKdCKsTptrb/6Lqt?=
 =?us-ascii?Q?lVXXdGDWLtS46jvdLZDCJQFJlNMAbOPcJpVKxVN1W3DD/nqLM/Eed7yeDICg?=
 =?us-ascii?Q?q3oin6Hguzr1iYyQOBSgXf+pcMjxciRPdyhQPW2YRxyrtTtD2aaTXySbKtJk?=
 =?us-ascii?Q?ZKoq/0YiLGwnIsL7oBBxEsti6KJV7/rsgpxjqgolXRGzqP1EONwBlvnTzxfN?=
 =?us-ascii?Q?MBB/wsNeR3Nt+SZ7IefjVO1jOO2vgoyd+O5hHKLSCxwSl3UjKi/wJaBs7pvT?=
 =?us-ascii?Q?G2KW6CY1i+1u60O9NvsZLOJAA3EBozxw8bJFYZB++zpiuqOgzT3QlinJNVfC?=
 =?us-ascii?Q?38ueVM2BFwe6S0me3e9GTvu/4jb1KSSik0WIu8skIArk3Z/yVGIhVGq/jrDp?=
 =?us-ascii?Q?CoLAPahZwWnVQI0Jcm2nvy5npM5HoMh/Q3QYO17SWRwMpVEUsEdOR5OJYRjf?=
 =?us-ascii?Q?VL9x5P5shZtPqZqErVocx9Ni13guzNt2xJ/T2O4vjZT2Icbsre2nLRCyAR+H?=
 =?us-ascii?Q?E6wP7h9CIxFIO1fb3FGh8g2wsjPx1Q5Kk5MZjDXcYqAOt+NlH3wcCCJSzcBW?=
 =?us-ascii?Q?1u5CiuOPXJJ4ryI0VYmHHzSD5THFsykPa7RrNX2eGHMRuOsVMpa3ZPRxIlSS?=
 =?us-ascii?Q?N7u/eS0MO9fB2L+Rf4updpn43uzpH0y2FgblpZ967kcWUT3lKBy0eOH0PNo7?=
 =?us-ascii?Q?fj8B1Ho7p1NONoULlcVAcW0tVKbUepiriu6GZU6nfHlu3O3nAuHN7Seea3H6?=
 =?us-ascii?Q?ooWr1kmuiJwXl6S0o2hY5jyjaSFRRwl59UnmcrbipYFcnvbik0nN0eIymiaU?=
 =?us-ascii?Q?EQwJVTsvyOkgM0zPimtO4KMxBVjfnocFmp8XQUYb8dIZ5gW6FcUcziZbLKv+?=
 =?us-ascii?Q?97oY21r1Je8mbZSVVI6qw3ihkdk8UWp2KoT73Dn+rgJwQbENsxx+EDMmopPm?=
 =?us-ascii?Q?EQKMWLnKMv6z7WVrDbA26PFjLSGKFE6kV6zPrthJRetYruRdPxmfZTyzr1mM?=
 =?us-ascii?Q?0FBhZC5RRGr3sA9LUecI5t/fiUOt0QK9DeTok6B5KIb8PUwQFjUiVh3wco1H?=
 =?us-ascii?Q?uCaANrULis5cn2EFNh3WpMymisje4kFh5oSlZKcl+532/dYFAGPCwUq0ay64?=
 =?us-ascii?Q?H4OGnSsVjUgqXd0rgVrhAA00oRH0mbICFTE81Fj0naSgvm3L0kKlrulS7XtS?=
 =?us-ascii?Q?w0poUGvFIiKO6mo7mQbQbFTkZ14C/ajoSa7rHb8rgPhPPgsdRVXp4mBDgzaU?=
 =?us-ascii?Q?8+FgvjI+FLMT4GsAsxUFUSSjHgwm5etS0f4iko2qZ1+f++8EWmMBQnwsqJgm?=
 =?us-ascii?Q?gUXBUPB5xcHa//h+Dn4TwrwBrWSbtoir5zDOUIffLTlVfnva13+aBnIKJggG?=
 =?us-ascii?Q?17+U8hQqc/JL1ssQoZmL9V8uGEzbP4F2MfHPZGpkPPVtrwxGqRR2a5J+SmrF?=
 =?us-ascii?Q?AreRiA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e782e22-fd8d-4175-a26d-08db56413f9e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:10:44.4854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ui2JoqQHcr6YCirPruKaVE2kujVE1kvKpmgpavqM5a+DhPxMxDheZdFoTjOgb+GhAxjJpT1fo4mfmC/McmY6YLkOjdTqlAzgKjip5j1uDv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4075
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:09:46PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> In suspend and resume cycle, the removal and rescan of device ends
> up in NULL pointer dereference.
> 
> During driver initialization, if the ipc_imem_wwan_channel_init()
> fails to get the valid device capabilities it returns an error and
> further no resource (wwan struct) will be allocated. Now in this
> situation if driver removal procedure is initiated it would result
> in NULL pointer exception since unallocated wwan struct is dereferenced
> inside ipc_wwan_deinit().
> 
> ipc_imem_run_state_worker() to handle the called functions return value
> and to release the resource in failure case. It also reports the link
> down event in failure cases. The user space application can handle this
> event to do a device reset for restoring the device communication.
> 
> Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
> Reported-by: Samuel Wein PhD <sam@samwein.com>
> Closes: https://lore.kernel.org/netdev/20230427140819.1310f4bd@kernel.org/T/
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> --
> v2 -> v3:
> * Fix review comments given by Simon Horman.
> - use second label for ipc_mux_deinit() since mux will be uninitalized in
> other failure cases.
> v1 -> v2:
> * Fix review comments given by Simon Horman.
> - goto labes renamed to reflect after usage instead where they are
> called from.
> - ipc_mux_deinit() checks for initalization state so is safe to keep
> under common err_out.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


