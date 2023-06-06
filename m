Return-Path: <netdev+bounces-8492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D85B7244B7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE69C1C20A09
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A892A9EF;
	Tue,  6 Jun 2023 13:44:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDBF2A9CE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:44:29 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2115.outbound.protection.outlook.com [40.107.94.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9499FE6B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:44:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g403I/dpM1Vm9o9jfhfEK/BH0GMFxknscv7MVxCKWAXzm9Uw/cePuOzbAQwQCTt/qsdewkn9SrarqH29CmUU76UbA+Vo91CIyqWJn2f3ZZTEV7TN9CRVLnkG4uOVTxnPpZ/xlLZXGfF2EF4xKoLpPzjAdrmurdpAwXErIJLp3GeI1jBVd12jP14LHBCTcGU/d5sLa/tAbVT9RDSx0OxHWZO4COeirZEWjkCFPoI2r+1uCW1lJTbN95QbGiJhANU3PIiLycIYoAeEQe8i7LaQHMYND5nxGC3P+qKyALFoGeobqwtmvTARqcAIinswYpEe5NTL6qDZvIfKZilM1wolVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB/cRdMMitgauunBKBA/I6FIEAOtsRCucK5phxNOcoU=;
 b=IK74W0Swy6Tx4tH39WXM0cpUwnsvoeUyM8iCYo0AKUiiNoL1dIafHHG4SDYylquigMeubZI9zgSuka8xfr5uxBgZNOiiA9zohBvMk6Kn8O6i+JhLuzcOkKN7BIZyZNObuyw0QXY+6S94zG8dvXFDwQF3sjX5LjT7Jz0PzjU1lvH3mRNeU4Xm+SUmB68kqYcEnPbGVwkSpGt1ZmCAan80QIW0+lIVHE97lp5G+BZPn0/VEG0ujdnZV9qRwulhljAHMriqpeTDxcsTwTmx1haaH1kipj5lza3+OQp3PM4YmDKjKePnLbSydUbLH4dVFo7xCwyvd9PRAvr1JuxgwQe6cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB/cRdMMitgauunBKBA/I6FIEAOtsRCucK5phxNOcoU=;
 b=JOjm9oZrTmir6+CboA2/Z5RATF80mkIBUniu64wyxkCf9N1QoPzQ5Rd2wKUTl+T/e50E7VgImWRHjj3OkMTO+2TwIGy8sS+rZZK5jmOFAwZPGn5Km4XAIkSfHa1vo7sN6fU17rVvGrzY1pDN8d0PC9Zgr3ZmX+Gz5PV/FF5XWxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4946.namprd13.prod.outlook.com (2603:10b6:a03:356::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 13:44:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:44:22 +0000
Date: Tue, 6 Jun 2023 15:44:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	dev@openvswitch.org, aconole@redhat.com
Subject: Re: [PATCH net v2] net: openvswitch: fix upcall counter access
 before allocation
Message-ID: <ZH84MMR2LWEV68ab@corigine.com>
References: <168605257118.1677939.2593213990325886393.stgit@ebuild>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168605257118.1677939.2593213990325886393.stgit@ebuild>
X-ClientProxiedBy: AS4P195CA0029.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: 3532a938-a4f4-417d-ce0f-08db6694227b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SDToqhS8eEwZ2jMSNYSROoD/jthygFnXJ6GXWsGEa38NW6X2ar5A1VYfCWoX5t75695gKeGasYWHuokRQ/rUZjp8raXt7N63ZYrQ/Eye7w9Ig2USLQpD+5JR8u0N+ooJOrRlCVkqbNXTwVy2WnIDEgXKLY9fC8Tt9QX2B/YrY/rouFfgtZbVVMxFdgK+UmwzRGvRG4+atSNgvO7u8AXLLgD9isWgRR6JPhCsvJXYoZgxDMhddVrCQDcK4yH5i+/p2WmMyPckcQPcawnMHnAVGFSAk72sSg+QzHp6wJUSJ6EHl8lGpFV4XTxeSr50rzzH2v4XWDbVZjS0V33jSiDr0LEAII/q0gHXPAj3cwWYhmmMZay5qo++cZVCiAXJXE279lOjycWnm5nIGGv29Ksq8MAoaOblvvSh3SC1p26Lh92c+6dCtHCSO3ZNP7SJTrMGHzaq61+2XjyVc834WLT4uNGfwHASOqfaMwK5TrBzXcnwKyEPTCfkP3Xu6vz/egnU47mmSIIblLvU8lk3mg8+PatVNYj1XHGoiT/cmhS/Z69d/6QP4nzHY+vh2hfVavER
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39840400004)(366004)(376002)(451199021)(478600001)(8936002)(8676002)(44832011)(5660300002)(36756003)(86362001)(2906002)(66946007)(6916009)(4326008)(66476007)(66556008)(316002)(38100700002)(41300700001)(2616005)(6512007)(6506007)(83380400001)(6486002)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?336/F9ZQ1y9ORvGibww5r65h1w4iUaZvLk3C+/K3cmvtqz2YTLqATgif7AnL?=
 =?us-ascii?Q?OkiUTAyOpvITzOcDRY2b1s6GEypHp6geuGHjtmkIE2UAGBUMhX/xpu1Qpzc9?=
 =?us-ascii?Q?j/TQDDjRMmNA9CipVWKG0Ykwc9snZlGtdfhhVkcMr15uRmNgIhwwaxTK3Dvf?=
 =?us-ascii?Q?E0JN9iaTo1YiCayVBG0Inpahrg5J/MW0giQd3TDbqL4DWX/15NlVprDcTR5c?=
 =?us-ascii?Q?ynwqOWKVRXcMY3Cn58gTbjCAY2o2LGabkEgZGBE4aeKroBYBWV7+jh68z7v8?=
 =?us-ascii?Q?TMOL8/n7D3ZCGHwlEqYKkC6EUOoRKlEzq1V/AL/mKVPwfnTCnhyMgJMtss4o?=
 =?us-ascii?Q?7PfZ3rBYoOYF/pKPEE8sv9fRrbR0egoft9ePFku4WDJKXcwz8LM0JorcREEw?=
 =?us-ascii?Q?th8Nwe+ebnigKtxaXpWDhMKA3fKKB81JvvBKzzifRbrV5QCZkqu+jhV0GLfr?=
 =?us-ascii?Q?cl7cKNNWFdfAEHIs/0ygg3MDK36zDapesd4gxRbXrd/UF82p/pMMNoucSbPq?=
 =?us-ascii?Q?b1c6SSJd8bDr6tWcp6w/XJOjQJA/0FUxmcAMtS26QVSHZmxXmqrNGFazvA5R?=
 =?us-ascii?Q?hTgua0UShXOEiKjv3/PIs1b/o2xcHvHib27hg/5kJGSYnS6s3lBCvpZx0WeM?=
 =?us-ascii?Q?F+wBje1NPnjcqdsjTk1ebodH8REo2TLMx3bzKQ6dQ9+1gnGKqUl4by6M48PG?=
 =?us-ascii?Q?bAyOre85GglETXdkcUEubYdlvsIZVgJ9CQqzUpGsmgQFktcRPdD0oIV8aPa2?=
 =?us-ascii?Q?87wFh/pFsRxfNKmUiBeNZC0QPLFFQBDNTSDEPHRwj5QcL3NmPCibeNX11iri?=
 =?us-ascii?Q?M3LSTxmmW+vJlCZuR2Ekplqwr9VanGkyLfcNnvmz38YzTLo79qiWNJZ8GNys?=
 =?us-ascii?Q?f5VAnWLWkjjHJD8IaryMbCPUlc5GeKgwrgPrObqgqMwC4Hn71yd/QN43MMyx?=
 =?us-ascii?Q?QVZGIpCKKMuDvCBpFkysCEBqqJujjjPpKPRH/CHLxFQXcWmu+SvFwWVzFbkV?=
 =?us-ascii?Q?P6FaRmy0vgqlDnN5pR1qdqrSz+m2lwUmKPlbQQ9wwuVSN7HA/6yRviWoQEd+?=
 =?us-ascii?Q?j7GEqpfSXiiYIlrgxZ7lGo9n3BsBy4K0rUdbikig9g2HKDc0PsMe8Yv6M/4A?=
 =?us-ascii?Q?z0wOWjpddhjBD42Sh80VfaJbaXOBViW6MeI8n11g/4Sh53Hcvqp6THBu7HvZ?=
 =?us-ascii?Q?lh0OnmWF9wVBNZMh1V24mzK9g9ciI45CC2MgqxrFbVzSrPaJoGJfIEFYCrsj?=
 =?us-ascii?Q?LyfGExBbmautQ+yRrUK5Od8j7o4jOP5UgmFV1qhApcniViOqKGnBsQ5qK/XB?=
 =?us-ascii?Q?GMGhf3oBPpAA+9AexnWFUxcYfYrF4XQ24wRgIcSVPVT+xCP4JOuvRlihdrWv?=
 =?us-ascii?Q?zq5w95zpXljh7/4P42OhNDhTTCMXgnpiP0b+NNjYtONDDdPBUUKzMiAIZ/Zz?=
 =?us-ascii?Q?lRT1gEfsFLvnkCTEDGLxTOgGz9fOrjANuNP+dDShtVlVHqfbBhjybVjkBrmt?=
 =?us-ascii?Q?tqgLrS2wUm0Ly/S8Y7kRJsXx3OCy98sT4lvEsUUeHS565hBWAwzODYRzYpLm?=
 =?us-ascii?Q?tF19WHWOPVKOeDW80sDUd1uOazw4rxYnG55nczskyIeXsX8fxHZHVBPx+qZ/?=
 =?us-ascii?Q?G0eYb30d20IKxur9jJzdc/4nK+C6DSKt76QjJgPlr4Iy0vLjWvRnYDiUUC0R?=
 =?us-ascii?Q?KJI+3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3532a938-a4f4-417d-ce0f-08db6694227b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:44:22.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4yqmzS3YAQa8sjpmf1tI3bwzxudlZXz5MbEgg0SISqGbd+WtyjxsHlQLQc/tO6iGaRHs1EioUGx836MHJtgUCk1rsG8aesLSf2Yy1fG3KU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4946
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 01:56:35PM +0200, Eelco Chaudron wrote:
> Currently, the per cpu upcall counters are allocated after the vport is
> created and inserted into the system. This could lead to the datapath
> accessing the counters before they are allocated resulting in a kernel
> Oops.
> 
> Here is an example:
> 
>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitchd"
>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvswitch]
>    ...
> 
>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:3"
>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitch]
>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [openvswitch]
>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvswitch]
>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [openvswitch]
>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvswitch]
>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at ffffb70f06079f90
> 
> We moved the per cpu upcall counter allocation to the existing vport
> alloc and free functions to solve this.
> 
> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on failure")
> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
> 
> v2: - Cleaned up error handling as Simon suggested.

Thanks!

Reviewed-by: Simon Horman <simon.horman@corigine.com>


