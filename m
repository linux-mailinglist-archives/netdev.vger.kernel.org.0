Return-Path: <netdev+bounces-3376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37419706BD6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:57:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E66932815DF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4F05247;
	Wed, 17 May 2023 14:57:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E7C1C26
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:57:21 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2107.outbound.protection.outlook.com [40.107.101.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1169F4C33
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:57:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tw11EiWsC4iMbdH7oYBnB8bDvP3pZHMXkkMvw4vZjEglOTe9wFWwbFEQBRFJswVXleTJCvh2Qz2Gl5jzYbCKbOaT6fRvBwAfJfW+XeZWuzepnbprV8O9q+kqfan5PlD+hk8NlH82ZjL/rFMgmYPcdWObZH6BvutVVJlgYiVPQis9WQRKIe9W1rggIYKBmydzo6UnUVIMBZpT2UtG1G1gmTVlbC4adH2T9RKTVn2j3ttvym2RgTGn+RxsRB4FWeR5oV9WKytELTKot2B+04Ek+5YluKsxMbF6pnL9NlPtt8sIJN6CdHsoTXbv6Z0+cx6fYmCn5c1TdrYY0fUy3I3c9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfwOBzTKsg89CHDPWekTOQDfqFzA4RNJYu0PoUuWyv8=;
 b=Rcgl32FQ0i3G+zwLRgWM6SdnPFlLakLI6WURsKwYWIg+iSVEpuWMtwOHHEw7Hs0puCx3Zu+d3bX9USex8VmNVifudRXZHel8sDOrKjjU0SsdNQjtoaM+wc12g99Nf6C+pdDy9Zk1j2pbCA7oLMeNPv3qmPnf+10RwbxwTWrpI8QhEQLk5x/spy4cdkcqfgPPpXzWED8Y1JkJk0mjllBGPWrDjeJdxoZcx82MFfiAAealncNHwWDOK6POy5I5a7HN/2a4g0EUjLXEXET1kgu3Q5NlSx7lX8XsxniOcWbSWJktceBrQYtMwnF8+mjk/omYuFCR3cOvvYoh0S0qQvQRww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfwOBzTKsg89CHDPWekTOQDfqFzA4RNJYu0PoUuWyv8=;
 b=MIZywGtup6ZakROFFzk0odAlBYi8NsJuCZhWKqjj4HRJJcbxgNGm2KC2hmbxiwsQeIH/9mJGM1mC9HD667PyhpPkUEzssaIzHk8MCYdD/wPKMEyIunmse/DQqZptnLggNhSwFKj9gfpGuoJESqIcAyOELY1dJChVDdVi2HIICfY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5067.namprd13.prod.outlook.com (2603:10b6:510:76::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 14:57:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 14:57:02 +0000
Date: Wed, 17 May 2023 16:56:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kui-Feng Lee <thinker.li@gmail.com>
Cc: netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
	kernel-team@meta.com, Kui-Feng Lee <kuifeng@meta.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Remove unused code and variables.
Message-ID: <ZGTrOCcP9ITrKLlw@corigine.com>
References: <20230517042757.161832-1-kuifeng@meta.com>
 <20230517042757.161832-3-kuifeng@meta.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517042757.161832-3-kuifeng@meta.com>
X-ClientProxiedBy: AM4PR07CA0036.eurprd07.prod.outlook.com
 (2603:10a6:205:1::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: ed17c0eb-c475-49a4-de9e-08db56e6f8e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+EYpYNHDuxhxuAtDZh5nAklEMcALksL0l2sAyyXsWjWSM2MHDeROnklUad821+uZSHY1odlFF/1/Q9blv7Lvgm3ogh/VqTfN1AS+lV4TspgrJA9MMlNfvfZpsGT9+tpca6jgH9O8Co5jnloZWq092l6SkEF6ZTn6a/0RFUpF6fiHMOItCAtB5BmHjspUAVAB4JrcsDfxUIfH+ZiD9uVlF/OMUcbPicgRkk23NTvcIRnR+OUX4U+zWohbc91D7FYJI+cKM6Q/YiLa0vqO48siQ2EVSVKSYOrg5r/vDcXm8A4IL5v4e33ZQpPDxLlSuu0ZKBilchxSsb/yO30folePR9NrwBMDs4hk1q/Yuyxh9jbBxE72h7C/fHW68OyDpIkVd6c/3BYnHltsFGX4LU3JzA+z8BnjIubCaWwwUPpF6KX+tDsV7W5crW+iDZuQODuYyZQn+aNzsnsaTnRPK8yhqVU7mh16Ew8QHncGagtsLtBnRpvVMEt3xnbJCD41F709gwNXZ36jubA37QoKB0GGrFbwl4sQYehhUaL6swkHP8yNUWU0xUTc3fBrQ4q+717+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(396003)(366004)(376002)(346002)(451199021)(6486002)(44832011)(5660300002)(86362001)(2906002)(316002)(41300700001)(4326008)(6916009)(8676002)(66476007)(66946007)(38100700002)(36756003)(66556008)(8936002)(6666004)(478600001)(83380400001)(186003)(2616005)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MsezMmE1eMTSQoSC3cBdFDfXj6trNKcJcDyEphvtdq1NXkkF2pdGKTJxkT8P?=
 =?us-ascii?Q?Or9rjjNc47Tdp4zFRqfmf08TJdx/IjstECRW6Ce9rWAYnIJ0FpxP7JkZwY9l?=
 =?us-ascii?Q?OY/fXeRH3MG6mj+Ul8XhwIg7gro9b+X9VnJPbEtADs7uV2uKdXDTJheivqMp?=
 =?us-ascii?Q?iyj1+Fe0SaTviyEHkSZ1xap2JkPLWAHTTBPS3j6wOAM3AdvMUz8rEl9YW0/i?=
 =?us-ascii?Q?wWcQ7UpM6KrBFw8L6Pf2V7zIGoiqOMIzhITVbTBtTTHWqcwSWN854DuIfPbo?=
 =?us-ascii?Q?2wclEqnYPguF59P8d4DpXZ2ay6K+wVNT1eig/pFsW/olURDgG4J+dHB4zc4f?=
 =?us-ascii?Q?rnCqIPoGn34GUGnYrbJxiKHx6LlsHz91yTRkvHCnLtevHSJrA6BsHvpX4X80?=
 =?us-ascii?Q?hH0SGBLwEV/r20/nD+omOI2c9q7TNQeW831GoCst4QxjFo7eyysGOlyfho5r?=
 =?us-ascii?Q?fh/sT0/uU6q1ez2lqo6rKKukDvIij1naD0UHvOZzo9pdKs5NDClsEKFWfpQA?=
 =?us-ascii?Q?SF6UbZ2gu5zHhVYgns2onA62IN+eBmB5GBUgrxMJoZlYtBVWoNFSlvIbSiIT?=
 =?us-ascii?Q?Nm2p5FQ8wE08T0CZonYf7e+aAAZASr0+bREKHquAALWQ58hHByd+xDqRUapw?=
 =?us-ascii?Q?8BhkloVMP9MzqXif47uEZRqrbi1I3Jd+TQVMNpseWvTyXtoIy6g/r6YzQeLo?=
 =?us-ascii?Q?LFG0C+H2T+UgFSq2FtxL78SjRj0dnVsOozyKnCh9a0GW9+EckRhmuQdRBRG/?=
 =?us-ascii?Q?DdLzfkUKmpvz06jMNot7L+bIO5dqPOHGTby/HLk+joxWec9TRxcX758cCULI?=
 =?us-ascii?Q?MrsRC/x8+30Wv1h0eUE7OK9U4LdjKpeu9nhel9n411Q4Dx5FZApH0B7AiuaZ?=
 =?us-ascii?Q?He9sqH3s4JREXce4AKl8LKbdvSg7cfAcaEU6Lbv2iv+CeGbe4NxFjVPyNkMx?=
 =?us-ascii?Q?g4CajZ5al4kj5VtaSvLaBuzQgy2wJxD2yYhhmL7oDSdeIT89XX/PH8lWYsDI?=
 =?us-ascii?Q?pFXyhO5t9/X+/BZUuvQu3972IqRRC6mp7ld/m+N3FLkUIHHhvgpZyndqLmLQ?=
 =?us-ascii?Q?vVW9pds64lK22DqbNUTRR4lz2zVqy0AMWSRpWWTjLWj4Ay/TzhFqEnM2dpmW?=
 =?us-ascii?Q?PerzF57sxbomQtpReHHdlIifZOoIwrTgQ/1vLVsY4keiSe9fB1n4S90161Ox?=
 =?us-ascii?Q?Swg0i7WM2U0y+vqwj3JhK1dr9QQdjBKs9h79tr96zsB0KvxsyMTAPgnp3NHm?=
 =?us-ascii?Q?fThYAbkonJuthoDMCmKh4kubP7ZNH4z7mVgBNX91UO5kfufRhv6vPUJjWAIf?=
 =?us-ascii?Q?JoOao8dtmf01DcDxZSQ1wFy8MXsQoAJZa2TROmJOzp2CZkEOGb0sOykbi+Q6?=
 =?us-ascii?Q?n4RNaHYvI6esb7C3SaNtrT7PKSB7qU66JtRVXlpDWRodfLHiHrW7lf9ffLG9?=
 =?us-ascii?Q?2AEadVA4y0hyql3ZAPZ+WTqP1n5em0LPM9AebGu9xhBqKC/U6arRzz9Wkp7C?=
 =?us-ascii?Q?I1u4YYaHNACTEwcTDMSYiSxW/Z4fv23tQOuYFvby+758Pb83xSH07bgCCaTA?=
 =?us-ascii?Q?7d4G8K0ZSYdvKO2s3sWBqQ11Yf/fTMoMxOsb11F1A632QeTGxMxPpGFRovCx?=
 =?us-ascii?Q?VxvEdfeYYOpjELl6RI+Qf1JoXZPJXkwveTA0bI2OyMqFus0LODh433kSZzj1?=
 =?us-ascii?Q?7RL+Mw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed17c0eb-c475-49a4-de9e-08db56e6f8e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 14:57:02.3659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/3dfqoB/7LvxB3ZyG4eA7gyLIrC5+n3iVr6vWBusjHbBUyCBT8OlWss2YCrXJOfJ6y3T9XU0AGt8IWJWXKsSYuQFDN3jb7Myjj60YZ0nH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5067
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:27:57PM -0700, Kui-Feng Lee wrote:
> Since GC has been removed, some functions and variables are useless.  That
> includes some sysctl variables that control GC.
> 
> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>

Hi Kui-Feng,

thanks for your patch.
Some initial review from my side.

> -static void fib6_gc_timer_cb(struct timer_list *t)
> -{
> -	struct net *arg = from_timer(arg, t, ipv6.ip6_fib_timer);
> -
> -	fib6_run_gc(0, arg, true);
> -}
> -

There is a forward declaration of fib6_gc_timer_cb around line 80.
It should be removed too.

...

> @@ -3283,28 +3281,6 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
>  	return dst;
>  }
>  
> -static void ip6_dst_gc(struct dst_ops *ops)

There is a forward declaration of ip6_dst_gc() around line 94.
That should be deleted too.

> -{
> -	struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
> -	int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
> -	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
> -	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
> -	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
> -	unsigned int val;
> -	int entries;
> -
> -	if (time_after(rt_last_gc + rt_min_interval, jiffies))
> -		goto out;
> -
> -	fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
> -	entries = dst_entries_get_slow(ops);
> -	if (entries < ops->gc_thresh)
> -		atomic_set(&net->ipv6.ip6_rt_gc_expire, rt_gc_timeout >> 1);
> -out:
> -	val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
> -	atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
> -}
> -

...

