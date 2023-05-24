Return-Path: <netdev+bounces-5037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0B670F7C1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F7DE281367
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C21182BF;
	Wed, 24 May 2023 13:38:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9294360841
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:38:27 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2095.outbound.protection.outlook.com [40.107.101.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A019A9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:38:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BczM0V99Yqt5VwYUnakbyqBY+hElG5hUHhEJBiV8Har04Vf1Z4y0xaGNpalgWbxkZVdDadQVHJtymFWDQMt5pKY93zmtjoon0SEOEaAB+ARC5goGhvD6pot2us1MA35bXSzHoAbxa7GwsFXidkKMluQ/pvw0AiP1/nDytRW56k7ULWJE/qBvZNmFV7sjdqApHbK+nKGd3CDSHmEKwpmXNIq4L8SGsWjMQMCM3Yml2Myi9dMOQEpMhvtqXv1riiNiuXBDMMFvKIS/H45we8TRUimlWE5TXYJMc4bjPt8/PmJln4IqpNAmbz76hqbZKKgruXLvUxI9UGScTvp+X0+d2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bshw+QGzKbJT0NZ39zAz2yZI2++MnJOGIBK/ogAiRs=;
 b=nnC6JzZ+XuU1l6BGaIXsUAx8yfvtuw7pU1S7gh5OEpMh3VFa+UplFNGpChzQyjB+x9UqU5cuoXF4mncWzYxVWfTLpnmKOV6mjwFaO6iQFWPJsLg7CPp8H1FsUgfxMu57vILfs1NVZP11u+Yf5S5EN/uvwoHmolaPPFtIGI38xUKRB1JeeTiOGqXG5QaUf0ktRLwosK7JVy2xZBxzMD7/sm1WCVJRMTgYJzKHdmQvtdjrT+LpiGhIKKwQB5oTcHXpeGUk1tDfPK7UT05FySUyKHYgxUS82PhnE6E3j3FawC5jNDByDNW/dFr9b19IIypqh+ly9EArMnWG+q1JtBsNkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bshw+QGzKbJT0NZ39zAz2yZI2++MnJOGIBK/ogAiRs=;
 b=Q6ZgT9LE/TuQG6MG52w7bNXMiGyTchzWb+CXSbbE8zTOTqQwMhUv+CS/FA5zDYarB02lrSS/H3wLgQHk4o7IX+RdEzX7kfGKHzhTI9f0UMNUvwXq4qiPQXraycpkJxUalusIYr60FCJK71ELlOLT+LLLATj2nmBiB5qZwc21kj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4056.namprd13.prod.outlook.com (2603:10b6:208:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 13:38:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 13:38:21 +0000
Date: Wed, 24 May 2023 15:38:14 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Message-ID: <ZG4TRruF/p9C/ZNu@corigine.com>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
 <20230524111259.1323415-2-bigeasy@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524111259.1323415-2-bigeasy@linutronix.de>
X-ClientProxiedBy: AM8P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4056:EE_
X-MS-Office365-Filtering-Correlation-Id: 087aeeb2-1e52-498d-a76a-08db5c5c23d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CDgeChEZw30VXkr6iiqiFaguM05EzouX15xnp4z/NvMpUvyINJr0azj1zJlhEilLhtDc5ARqMseKo++6D9NyZEdl3J8fkYn8DNG7MVizzEXnjgBrezJk+C1H3Tj1E+uzg8umvPYvyXy7Al9utQVAoE5arbYKatObMkX8Zs3fvryahOaoQxeeJNQEjB2loC/NsSBC31O/HNcC2gvbr3UAbto48kUYD+4+5ImIXxYz0IDO01wcdCrKR9YUixpZlOYRZC2fJQJcnqdqnUtyGebMNA7vm0ho275ql95l0NEToCyvXAKuLukDIhpPAqdxrVsSQO+PbYfua2JGCHzxjqvzoPplqTbSYf1zjsn1F6M5j4Ba4N/5y6EFcRa9eNUWfejqgBWdXnvkckM6bMH1wWbrQ+hod/tKalB6VdWctMt3cXVw4tulwJH9xEtwKOrX5mRKSe44MxNySIMPo8xF9qEF+Uo8+WSr9iTu1r1O4/b3Sdizm/dtBjY5FFpz1fRn1A5LaoaLT7jYf4EIrsurUYK3Zj2frzjvQeQDTnOhTCHlSaqM/c1x+9iUntcG8cHGpzbG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(376002)(39840400004)(451199021)(6506007)(6512007)(38100700002)(44832011)(186003)(2616005)(36756003)(83380400001)(2906002)(316002)(66556008)(6666004)(66946007)(6916009)(4326008)(66476007)(6486002)(41300700001)(86362001)(54906003)(478600001)(8676002)(8936002)(5660300002)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ORp/KuaVxmi5RJqALBGEeawmgzuC58UWcWS7WSo6pNxB4EgqvaVQy7f03MB/?=
 =?us-ascii?Q?N71JiSLr8c+r6sWo3A3t2N80cSd8h1kT+ZpAqnt7USS0k0dY9OOEJ9+3DRad?=
 =?us-ascii?Q?lF/RpKofYFX+/eZbqncKekknVMRD1kacxWeEVEQcccq3RQfUSha8e+PAIlF7?=
 =?us-ascii?Q?rmsuopjeAsa3IxqWbjmN6XP+vlyQFjPfP/sLKgVvhr8SkjIMPkud3avTJXTp?=
 =?us-ascii?Q?hlryiQ1MkSxbJgRIywqh13/lHGBrIA7Tz5IyVnP7gb4hGeHw2kNJ3wW2PBP4?=
 =?us-ascii?Q?BsXVVTenlSsuH6xp6stAeEzN727NBflu4U81CTDiBSJSIxJWfZedJ/F7UIIA?=
 =?us-ascii?Q?RmFKTv8j4jTrIMTisv2Zsn25KRc24L8aY1FOsiGmwKwrVUICmVq/185cUfun?=
 =?us-ascii?Q?NNDMce1NRt7t0dJTDjLd2j3vxvdxUAfaOVDHvRv09RSuvY5fXNyjgRuIi+Um?=
 =?us-ascii?Q?ilHYfRFzLL7WjRvWC3ba5/gJMvYWBCg1GORBIJsZNXhYQR0/09yqu93kowjK?=
 =?us-ascii?Q?NVGX4TtFA32vICpqAGj6vWkzgpLinKfF1zIZPSZc62zq6fsTziAGmWV1CO9X?=
 =?us-ascii?Q?N8Q8FjfPUMSpHIXhDMA4zGxdVHW/7u7NbhSgOTmZ3TALBnEksWUUXOdE4tXy?=
 =?us-ascii?Q?oltxCWj1g3/0VVvsw+QL6gWij3XMWr68SnqqT/xC61hIBF6RvVV6a8MOCSfe?=
 =?us-ascii?Q?w0Wi+drc4OtP1V8rL51/fdZviR+dxcikjZYJG1AWEc/gkNfColr8fxqRcO6b?=
 =?us-ascii?Q?PFbi2Bfp0+HMxarHaFodWZPBuFlUMuxN2Z8zTT0jZf/B356KSBaUyXeOqgEO?=
 =?us-ascii?Q?7a0lpnZ1pupKBDwrFTZxJSX5rDguHYL8xr3jDUl/V4hPQWmowJ0Kjr1TdZlr?=
 =?us-ascii?Q?KaMHgpdA2uvBBAn9eFljIrcGF7mHRxdAYQNQXsdhcsIxHRCJj/6ZAMr1DFkz?=
 =?us-ascii?Q?NCtEnA396jg0KWJ8gAq6ipiyB9zyymefI5NOAUm2yEqwc8W3kmoApABf2rff?=
 =?us-ascii?Q?coXKxHqq7ZIEMciWxDF6yFFctoAoz0A0vCbj1E/iVVmJ7g6vuYwAu9O6v8Rd?=
 =?us-ascii?Q?0iDNgqXS54+VvwRTTNE6+lP9IPEakxOlgjYDWwQ+YEfoabCEj42zJ1FtXkod?=
 =?us-ascii?Q?3wYrnaa2BvCKUkvU1LrvzPLCQzkvpwh0cxqjBNm7WVizJq3lIQ8ZL5xsdW95?=
 =?us-ascii?Q?WfPkVi8aRBQ0aHrXtCYHcKs173fk8E6FKYHy/M6CjuS8CksEaTUB3GaRumYJ?=
 =?us-ascii?Q?65y4yhACyvr0XFAiEIovm7CHzqLKY4BvaWaMkXqVWOj2XfD6EeiBEtdIcPzH?=
 =?us-ascii?Q?WQHicHGQrRr9KR70C0/crMSTXDBQWwcT2SshuaDP3ZdGJrGMhZJMloU7h9c2?=
 =?us-ascii?Q?4OTfY/d9gTKaou3s/IL6nP4ce78fRkcnWhVUcnyh5QrGDKDQefUe5xCf1T0i?=
 =?us-ascii?Q?RO6gy+kX70W688cWgFS3meFy1qg/UzqTsmlYOGqQPlJz9MMCxZ8SOavh/nkz?=
 =?us-ascii?Q?Tu3b4CNXeE2V6/WiV54/eAj2z6PVen2f934VH0MqgfngNID1qrhz+7xHO61s?=
 =?us-ascii?Q?PV7TGaBqRfgOS8WXzIVUYqvGrkNzW0HQ3eJvWa+p4BcHQGjcLJfu1eZH0m9O?=
 =?us-ascii?Q?mDUQ9/6A9qV6sCWbW3jseaRTYS1lPtckRIDBdvXRJbuhYuM9/KRiGoOIWDgs?=
 =?us-ascii?Q?ca4cOg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087aeeb2-1e52-498d-a76a-08db5c5c23d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 13:38:21.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8LxuNpUyApnp2inxn+/aNI7NP7js2V/wgCTRkNSqQqc3dlNgS4Hx2Vqi+TRmr0R7EG2/dnB2JvsBH50wVs1zEILIQdMwP94P6NsigTKL9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4056
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 01:12:58PM +0200, Sebastian Andrzej Siewior wrote:
> I've been looking into threaded NAPI. One awkward thing to do is
> to figure out the thread names, pids in order to adjust the thread
> priorities and SMP affinity.
> On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
> the threaded interrupt which means a dedicate CPU affinity for the
> thread and a higher task priority to be favoured over other tasks on the
> CPU. Otherwise the NAPI thread can be preempted by other threads leading
> to delays in packet delivery.
> Having to run ps/ grep is awkward to get the PID right. It is not easy
> to match the interrupt since there is no obvious relation between the
> IRQ and the NAPI thread.
> NAPI threads are enabled often to mitigate the problems caused by a
> "pending" ksoftirqd (which has been mitigated recently by doing softiqrs
> regardless of ksoftirqd status). There is still the part that the NAPI
> thread does not use softnet_data::poll_list.
> 
> To make things easier to setup NAPI threads here is a sysfs interfaces.
> It provides for each NAPI instance a folder containing the name and PID
> of the NAPI thread and an interrupt number of the interrupt scheduling
> the NAPI thread. The latter requires support from the driver.
> The name of the napi-instance can also be set by driver so it does not
> fallback to the NAPI-id.
> 
> I've been thinking to wire up task affinity to follow the affinity of
> the interrupt thread. While this would require some extra work, it
> shouldn't be needed since the PID of the NAPI thread and interrupt
> number is exposed so the user may use chrt/ taskset to adjust the
> priority accordingly and the interrupt affinity does not change
> magically.
> 
> Having said all that, there is still no generic solution to the
> "overload" problem. Part of the problem is lack of policy since the
> offload to ksoftirqd is not welcomed by everyone. Also "better" cards
> support filtering by ether type which allows to filter the problematic
> part to another NAPI instance avoiding the prbolem.
> 
> This is what the structure looks with the igb driver after adding the
> name/ irq hints (second patch).
> 
> | root@box:/sys/class/net# cd eno0
> | root@box:/sys/class/net/eno0# ls -l napi
> | total 0
> 
> Empty before threaded NAPI is enabled.
> 
> | root@box:/sys/class/net/eno0# echo 1 > threaded
> | root@box:/sys/class/net/eno0# ls -l napi
> | total 0
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-0
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-1
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-2
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-3
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-4
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-5
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-6
> | drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-7
> 
> Deployed using names supplied by the driver which map the names which
> are used for the IRQ.
> 
> | root@box:/sys/class/net/eno0# grep . napi/*/*
> | napi/eno0-TxRx-0/interrupt:37
> | napi/eno0-TxRx-0/name:napi/eno0-8193
> | napi/eno0-TxRx-0/pid:2253
> | napi/eno0-TxRx-1/interrupt:38
> | napi/eno0-TxRx-1/name:napi/eno0-8194
> | napi/eno0-TxRx-1/pid:2252
> | napi/eno0-TxRx-2/interrupt:39
> | napi/eno0-TxRx-2/name:napi/eno0-8195
> | napi/eno0-TxRx-2/pid:2251
> | napi/eno0-TxRx-3/interrupt:40
> | napi/eno0-TxRx-3/name:napi/eno0-8196
> | napi/eno0-TxRx-3/pid:2250
> | napi/eno0-TxRx-4/interrupt:41
> | napi/eno0-TxRx-4/name:napi/eno0-8197
> | napi/eno0-TxRx-4/pid:2249
> | napi/eno0-TxRx-5/interrupt:42
> | napi/eno0-TxRx-5/name:napi/eno0-8198
> | napi/eno0-TxRx-5/pid:2248
> | napi/eno0-TxRx-6/interrupt:43
> | napi/eno0-TxRx-6/name:napi/eno0-8199
> | napi/eno0-TxRx-6/pid:2247
> | napi/eno0-TxRx-7/interrupt:44
> | napi/eno0-TxRx-7/name:napi/eno0-8200
> | napi/eno0-TxRx-7/pid:2246
> 
> Thread name, pid and interrupt number as provided by the driver.
> 
> | root@box:/sys/class/net/eno0# grep eno0-TxRx-7 /proc/interrupts | sed 's@ \+@ @g'
> |  44: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 123 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSIX-0000:07:00.0 8-edge eno0-TxRx-7
> | root@box:/sys/class/net/eno0# cat /proc/irq/44/smp_affinity_list
> | 0-7,16-23
> | root@box:/sys/class/net/eno0# cat /proc/irq/44/effective_affinity_list
> | 18
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Hi Sebastian,

thanks for your patch.
A few nits from my side.

...

> @@ -2411,6 +2414,7 @@ struct net_device {
>  	struct rtnl_hw_stats64	*offload_xstats_l3;
>  
>  	struct devlink_port	*devlink_port;
> +	struct kset		*napi_kset;
>  };

nit: Please add napi_kset to the kdoc for struct net_device
     which is immediately above it.

...

> +int napi_thread_add_kobj(struct napi_struct *n)
> +{
> +	struct kobject *kobj;
> +	char napi_name[32];
> +	const char *name_ptr;

nit: Please use reverse xmas tree order - longest line to shortest - for
     networking code.

> +	int ret;
> +
> +	if (n->napi_name) {
> +		name_ptr = n->napi_name;
> +	} else {
> +		name_ptr = napi_name;
> +		scnprintf(napi_name, sizeof(napi_name), "napi_id-%d", n->napi_id);
> +	}
> +	kobj = &n->kobj;
> +	kobj->kset = n->dev->napi_kset;
> +	ret = kobject_init_and_add(kobj, &napi_ktype, NULL,
> +				   name_ptr);
> +	return ret;
> +}

...

