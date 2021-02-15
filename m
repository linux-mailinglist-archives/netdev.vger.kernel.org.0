Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564E931BB08
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhBOO1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:27:13 -0500
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:32864
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229670AbhBOO1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 09:27:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlxSotLv6OECl+JnlX9bfjPiku9Yqo/R8VxXonfucN9MV13QGg472JedaNU0R3dHUPq1xvZHcQoh04TPAuverRAnn19nSCXH67brD8DxUo5gKRM+OgeXyjlMy3LYJHphMOwNubkgXt5Fi5xkBiAuDtwrwguM/WiYp4X7U9BxQmY6/Z3cJSn1uTmIWDez/S3S6Sr56Lk2sTGLvq2evVR32gPZtMbkLgVH2dKN8HgFP+5ixtOhp6L/IFyPIY5TbKSwIYFVX1AkQcG74xtOmgQ9WCuAJtSeynzWnpYFGWvqyb/bptc+saEMo+NCSHdPEBLm0Fs0HhBqoW+ssXFssYdcfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEPCJpwUacu5aR2jhd5tpwqz0a7bZLdP6xbT0Qt4Rkw=;
 b=Uc56oFrd9vIPa4wLLNbiKwQqBBJS9YS6n9ZJuqk9FhhJPefuEbEb9ebt5RJXAmws7uHVgyvG/zwF60WurQsnJY9pQSeL1UUnWctp+FCSlUINY6FAbRfZ+pfjVstx4xpOZWX9FG2lSz5dnnGB5Uh+ACi1HPyIvXAMNrwdDR2pTnmhRg5lkCxRXJZjg8IAGtWDfZ6L8KVSuVeY36BoNUxAHf/utv3hycKsG7dQfETsJ2jIIFtS1IdBWNcCCiqi368iwa/wzPhIx13NSCQESwQZ6sVePP5LMaV3lqjM1pZt5wqLYbfqEA72KSSefdc2GUbMRgXiApd4cdpJzwizFQhpwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEPCJpwUacu5aR2jhd5tpwqz0a7bZLdP6xbT0Qt4Rkw=;
 b=wEA6EyQ8iPdIx8ujPGQK6tluBNgfZBSl+A0s9OO1CB3zGSmEK6UEOTpYmjWjFPdjCsMx/UJMzyW0lF9FWKLukwoltrNqQ6yGVZae6eN4UfF9gP6/SsH1v9Fttr15yePvxclc4iCXNFWB157E5ohWkroiBtGuM5elDE6pycS34UY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Mon, 15 Feb
 2021 14:26:16 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3846.038; Mon, 15 Feb 2021
 14:26:16 +0000
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under string.h
 hood
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <43456ba7-c372-84cc-4949-dcb817188e21@amd.com>
Date:   Mon, 15 Feb 2021 15:26:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:83c6:b72d:87bd:4259]
X-ClientProxiedBy: AM0PR01CA0086.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::27) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:83c6:b72d:87bd:4259] (2a02:908:1252:fb60:83c6:b72d:87bd:4259) by AM0PR01CA0086.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Mon, 15 Feb 2021 14:26:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac94fef5-e2bd-474b-8a5e-08d8d1bda799
X-MS-TrafficTypeDiagnostic: MN2PR12MB4223:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4223CCD1DB73BD57D9D89FE683889@MN2PR12MB4223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zNmks1hC0bG4XZViiAJ6og59UUCwHWsDwGLvopN0x0AoN8HHR8yRjmRdryhoDEqDOMOM+c2nKlOC2sKJ7YXcbFqM1fMiRacWvHVGJUR5g05QFCg48c1GjLVt8BPmb5mqWogaRZmf4uCk9Z1fvAB0EsIoix5VomRVErCj9tRmGMILwA7SClR/wfBWXqYSyJo3FNXLFt7Hm2MNn9NN+wSF4T/6nGLX7+cs1XxT3hSD0CPQwr5EYmuxgFWwmGInvU+kTxDuGOXUvxTNS5GE1//kr9aYG3nriJ/mqyXdQSLIXTz/vdfUWJko0A7Ztf3/n6aZQ+29jSo5JNZ+7QXMdDwANl456R6SsdxeLAWEY5o9h5bR2Xm4CoQd4ygRt7eGtEgvZnAcX/odW2PMb3GskBw6Xt7kRu3eSYch54m9ZFnMsy1z9Bs72P9QLAQ3R0/QNQPeKXAnmM7GrWAEAJIZ8+HxCRvv9HoZnfk5Vac08PKfNnOOZ6Whm+Gc2QonXuGxJyF9Zp2R8w3Q8+jbyvMgI6L3xavKiY/R5bfcALjB+TG4eTbRCTv870n5L5RR9DldDwW5Hh96TDXdgCcyxdkvXpB8ZUNZzcqLfNAAMyw3h6qNV78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(6486002)(7416002)(5660300002)(2616005)(66946007)(36756003)(52116002)(31696002)(54906003)(4326008)(478600001)(16526019)(8936002)(86362001)(186003)(2906002)(83380400001)(31686004)(921005)(6666004)(66476007)(66556008)(316002)(8676002)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dDBnMzZiMTAxM1c1RVpQa0l3amdBa1luekI3TXNJSWVscmhqeVcvNHM3OXhL?=
 =?utf-8?B?Y0lqTE9sQmt0d1ZzT1BxbXBDNGltMHJoUm9PdXFQS2pDSkpOVUIwZGFQSlJU?=
 =?utf-8?B?WWRHSGR3T1Erb1VlclBiaVFTSTZQK3g1VDlyWUR6Ukt3RDltaHZsMTllVUsr?=
 =?utf-8?B?MEtrNlloSFB6cEN3TlZoeFA0RmxIZUZpZXFnWDlnVXZ6VEY2OHJ0a0d1Z1Nq?=
 =?utf-8?B?OVVBSHdQNWd6WDlUdjlKV3FTZjFqRURYemJsRU92eEo1WHBsWlNmdGRBNVJ1?=
 =?utf-8?B?Qm1Kc0J1ZDhKTDRob1VaNElTL21WdUVNbTRqc0dxU2xTK3RlTmhPVENrZUMx?=
 =?utf-8?B?Y215VWc4dFV3Y2F0MTJQQ1F1S3R1ait3SlkxVUNYbHVXSFNhT1cwQWRrS2JT?=
 =?utf-8?B?QnlVVTJLRFpPT2E4cVlJWmZRbStLMEF4ek1Ub3QxT3Erak11ZXdMcDZxVzEy?=
 =?utf-8?B?RkFaUTdBaFJHZFhNNkRZa21xRWlYRkR4cVJIalRPd3czZU5nTkYzenp0VGVw?=
 =?utf-8?B?ZWUrTWo2dnFGb0Z5M1plbzNWdE9RTnlrMEZaaFRCeU1tUXFhWHV5aFpObk92?=
 =?utf-8?B?NDVMdzJzcFAyb1pTL2ZSVE1td0NEbkp1ZTBaakI4QjhzWm9abG5Db3dudExx?=
 =?utf-8?B?ektjbXJPZ2RJZ3p2dFZKTkNuVlJKb296d2E4WW9TUkE5L2FVNWI1VkJQcFd2?=
 =?utf-8?B?YlR3UHN3b01KdE5wQ0t2MVhnMldGRWl5ODl3Z05RZnlpckpsUzJ1Z3lBWExn?=
 =?utf-8?B?QmdkcmY2UmJlRkFiSm9yTUlZZThZVEw3aVl2T21iZjBEWTlpYzBkMEZzVm5R?=
 =?utf-8?B?K0FwZWZTWnpVQkJQYWNWT1RmNFNFOFNWczVSTjZZakJqUzI3UndHMEVweVFi?=
 =?utf-8?B?SGg5Ry8vcFZiL2JoM3d2cDE4VlNmUWI2L2NGUVBSUnduc0c1R05pZnFCNER0?=
 =?utf-8?B?WXp2SVhoY0xNQkIrUkxFamVldkMyR2gzek5sRkNCc01tdkc3MjgvTExnUTlw?=
 =?utf-8?B?dEc2TWxFTTBZL3R3cTF1UDl0MUJhbUxRZlQ3Ni8xS0RDZC9ObGpXSm4veDU2?=
 =?utf-8?B?eERtVUl4WnhmdEtFOFpyU21mWWRCQm5FZ1FiamE1dzJMWUxkUGJwUmhlR1lK?=
 =?utf-8?B?S3VPY3h4WlA2aEpCZUVYNkFvZ0MvWWtYcGJvSTRYSnFyMUE5c1RxVkpydWNF?=
 =?utf-8?B?Umc1Sm4wdjJLQkVvaW0xT2pOUFN5RlFJbXhoSmdNS05DNFp0SnJlazg0L0Fu?=
 =?utf-8?B?Zk9Id0o3dXBlaXcxWktzZ3J2di9zekw4Z2ZNRnNGU1JBNkZUMi9ObXpUdVVE?=
 =?utf-8?B?U0x5M2dxUVZmdVhNdEMwWmYyY1dMSlFDMVQxQnVVTTRMY2s5cm5DcDQ3MnVi?=
 =?utf-8?B?RSt4bHdjL3F1bnVJTWZHUW1rSzFWZkwwbXMrTHliTDU0SHRER3UzN0NLT0pP?=
 =?utf-8?B?VFIwZHFJRThtSVBVT21oQzB2S2VXYk5YRmFMaXU3OWpRWFVRU0gyeXZLSXp0?=
 =?utf-8?B?K05tRHNPZDhPc2JqSXVKdDNwaHBOWGlQVFpicHQxbWJsWFUzQldGK29JazlR?=
 =?utf-8?B?dEw2TkF3b2Y1RVJTbDJnRlllVnpqdkxTYUd6TnUyNTJBQkJ4L0J4UloxWXAy?=
 =?utf-8?B?WHZOcnlPZ1pNSUFiTUZialNHMkVMWFkxMkFjSElsRXk0N0d2bUEvcjRQb3lR?=
 =?utf-8?B?WkZmWi9PY0Ywb2lVYjYrNlZ1M1FMU1FyaFdvYkE5N2h3UEp2M2dTNTBTWWM4?=
 =?utf-8?B?dklLcWRkdlgvYUs2VS94SmdOUjVVVStNNENlWkJIMk5SM0J5aDY2U1IwMUlV?=
 =?utf-8?B?aDVtTlZYaC9WVjlrOEh4dTVsMDhkWnBzVThMNEJ1eVhwa0xEd1dqVFJlb0ho?=
 =?utf-8?Q?tW6z0X2w8/vPO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac94fef5-e2bd-474b-8a5e-08d8d1bda799
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2021 14:26:16.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIKjwn4Dp9M7WBLkT9H72QotDkZ3XLQ820usZ6NPvMJ9HikIyOJykFAW15ltd7iY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 15.02.21 um 15:21 schrieb Andy Shevchenko:
> We have already few similar implementation and a lot of code that can benefit
> of the yesno() helper.  Consolidate yesno() helpers under string.h hood.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Looks like a good idea to me, feel free to add an Acked-by: Christian 
König <christian.koenig@amd.com> to the series.

But looking at the use cases for this, wouldn't it make more sense to 
teach kprintf some new format modifier for this?

Christian.

> ---
>   .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c    |  6 +-----
>   drivers/gpu/drm/i915/i915_utils.h                    |  6 +-----
>   drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c   | 12 +-----------
>   include/linux/string.h                               |  5 +++++
>   4 files changed, 8 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
> index 360952129b6d..7fde4f90e513 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
> @@ -23,6 +23,7 @@
>    *
>    */
>   
> +#include <linux/string.h>
>   #include <linux/uaccess.h>
>   
>   #include <drm/drm_debugfs.h>
> @@ -49,11 +50,6 @@ struct dmub_debugfs_trace_entry {
>   	uint32_t param1;
>   };
>   
> -static inline const char *yesno(bool v)
> -{
> -	return v ? "yes" : "no";
> -}
> -
>   /* parse_write_buffer_into_params - Helper function to parse debugfs write buffer into an array
>    *
>    * Function takes in attributes passed to debugfs write entry
> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
> index abd4dcd9f79c..e6da5a951132 100644
> --- a/drivers/gpu/drm/i915/i915_utils.h
> +++ b/drivers/gpu/drm/i915/i915_utils.h
> @@ -27,6 +27,7 @@
>   
>   #include <linux/list.h>
>   #include <linux/overflow.h>
> +#include <linux/string.h>
>   #include <linux/sched.h>
>   #include <linux/types.h>
>   #include <linux/workqueue.h>
> @@ -408,11 +409,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
>   #define MBps(x) KBps(1000 * (x))
>   #define GBps(x) ((u64)1000 * MBps((x)))
>   
> -static inline const char *yesno(bool v)
> -{
> -	return v ? "yes" : "no";
> -}
> -
>   static inline const char *onoff(bool v)
>   {
>   	return v ? "on" : "off";
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> index 7d49fd4edc9e..c857d73abbd7 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> @@ -34,6 +34,7 @@
>   
>   #include <linux/seq_file.h>
>   #include <linux/debugfs.h>
> +#include <linux/string.h>
>   #include <linux/string_helpers.h>
>   #include <linux/sort.h>
>   #include <linux/ctype.h>
> @@ -2015,17 +2016,6 @@ static const struct file_operations rss_debugfs_fops = {
>   /* RSS Configuration.
>    */
>   
> -/* Small utility function to return the strings "yes" or "no" if the supplied
> - * argument is non-zero.
> - */
> -static const char *yesno(int x)
> -{
> -	static const char *yes = "yes";
> -	static const char *no = "no";
> -
> -	return x ? yes : no;
> -}
> -
>   static int rss_config_show(struct seq_file *seq, void *v)
>   {
>   	struct adapter *adapter = seq->private;
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 9521d8cab18e..fd946a5e18c8 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -308,4 +308,9 @@ static __always_inline size_t str_has_prefix(const char *str, const char *prefix
>   	return strncmp(str, prefix, len) == 0 ? len : 0;
>   }
>   
> +static inline const char *yesno(bool yes)
> +{
> +	return yes ? "yes" : "no";
> +}
> +
>   #endif /* _LINUX_STRING_H_ */

