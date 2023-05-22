Return-Path: <netdev+bounces-4295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FF670BEB7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1A75280C15
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09F912B9A;
	Mon, 22 May 2023 12:50:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCABE1FBF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:50:30 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2229D8E;
	Mon, 22 May 2023 05:50:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9fMaU4FwQgN2gVkJ/XO1e6wQ+ofL79vaC02+CmwyBEUhmr9QsSFA2jCVhRWipFiQIRT4Gd+N+/oj9ybnih3h4/GlEFrUsTPo4zNNTQCpe/4t5NSKbN//729WdvxcEzY9ceZdagito7Gxfk9H9WMjuTboet57ClttegpvMvUYe9hrXUEPIJPAwENdP4zrR4UxsZMICTRxiR6GK0bNFX3MSR9d19i728cDZpDhwg3y3Y2wIvPNcQJDA9bUjiUYM6toybJOz8xrxr7I0alTRLHHkLMJXhzmvZRtGQbpC8XDx1gh9PLIzhVdbYF4a6olL+UnNqMLmu+jBBYfra6vm/wzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pff9cVXcFLeHb62vGRy9gI/JzP0s1dYUsrwZEOeakYA=;
 b=VDn7EhQ7Kv51RxJACNAu0TbZW3K1N6jA/YEbnftqnfEECmDkQTBn8d51/OVtWRtnQ2YL1n+QwRAt66+pXJsdt1ZOn6Rhl98Fh6Ap1PJsgPoM6re0P3QCLtuxjhlC9vRyxhVGg45Sltuf9Tut6fE1dmjsbSWVBBSBvEbALCLfMGrGeSHAXLmtGdyBsR6wWgDdtGp5ER1B2gZVcqQMqNvy2ZlzdEL9Qnq1+8ZKFZZwA/QQQgXfBSLSRNFWddHrWRCoX33MVZPz6gCMBcqUPBG5UQn87tlV+tvhzHenbr9iKy7nhj2ENgvrpEVZqJYS9H70W/GKLa6+SIaKsyLtZdeGvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pff9cVXcFLeHb62vGRy9gI/JzP0s1dYUsrwZEOeakYA=;
 b=k8dDDmdu5KBiLEMS+YidVRfCACXsDo8kziPGjHKiB8RqbrNnv1yn3Ko7OTyxtjLcfIx4biQA+HiuAeFQ4hM/zlxxgvU776casZP809EJDax0ucluVC2ACk+qfGNn3bO5ucUMc6j5XzxZNJC8i2JoHKghae2lSsvIwnJ0vXpbryQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5631.namprd13.prod.outlook.com (2603:10b6:303:196::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:50:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:50:25 +0000
Date: Mon, 22 May 2023 14:50:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Glauber Costa <glommer@parallels.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] sock: Fix misuse of sk_under_memory_pressure()
Message-ID: <ZGtlCdQwKw3tr58f@corigine.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-3-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522070122.6727-3-wuyun.abel@bytedance.com>
X-ClientProxiedBy: AM0PR04CA0068.eurprd04.prod.outlook.com
 (2603:10a6:208:1::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 922b56cd-a9d4-4e8f-53f8-08db5ac31ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n9Ks0kUvuBZ/b8duKGQ6H++g6vI82ur/rZngzx2LW9rAe+C8LFtSIYgArig2t+LIczqwmQqJOGQiAnEgMk/I5jM95obe6rOor75W65IIfO/iuBpzquPwBGEwMNiwhnjBVrD1SHnDmG8A+W/pgmKx5K6DT2gbr0k5wcxDJt5lPCPMOZ0ofbIHi8QpjzTRSheB3hAl2ZwS2jw2tbGIS4IXKzRMI4yzJRhRX77Z84pT7G0yWwKs3qWbdey/+wCVoD3LANgtyy6JOjC8rBLZv5r6l43fr2R1LUmyda2j/pN1N0blAUGQlUitgjFDM/lyPZkLL1sv5fhNJYidSCxP0ZKW97EmkEVXJG/JAK9gk2rESqH7mqii/A5HeibFxlc+XrAimPCYHh+z7tPjo2oIhKHvCMEGdJt+1dcNygIWpvPBMQ2hvfTpfQOw22lJlKnrN200Hv8Ng8GKCdXRn7j/yfeJjKvemQR+RLI1l0P/qfZJ7Dhd1m2CROuVCju6XjRxITl+HIa9VaRe3SrQXqVNWjC52OAH6TrxJAODWqj1TJ7zkNgxYH5bpcvT3mB08jDcMPFw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(346002)(396003)(136003)(376002)(451199021)(4744005)(2906002)(5660300002)(83380400001)(44832011)(8676002)(8936002)(41300700001)(66946007)(66476007)(4326008)(66556008)(6916009)(54906003)(316002)(36756003)(6666004)(6486002)(478600001)(2616005)(6512007)(6506007)(86362001)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yUBH0INB6LVODIznKENzbC3L9UFVIuBps+3LfiqTEBmAbg8ni4F7HUeuXoR8?=
 =?us-ascii?Q?CeMGN/AFa8fq5n1giCcOK08XqjH40fx5pVV4P0zyhYKyaOQmApO4zJmw4afz?=
 =?us-ascii?Q?TmcuwH0nec6zk/mswgp0j1fasHnABFKfKRkCpB1AOYPFkxvUqUsXq1QWYmcI?=
 =?us-ascii?Q?wzTqnmgM+Uhf1/W0Nrc29kbpgFscxCfIo4IlJashSjSebVqBFhFXWATKU0Ul?=
 =?us-ascii?Q?DMQTjPbmSwAWtX9+JpdlD61klz/3Ftl5RKX1k2mPiegyyLCK9a1GBQeVzGLE?=
 =?us-ascii?Q?JgZGrCE5ru65JVmeFggeTZKpayh9a01Kcb87gOzskxt6HBileICPWUAHjOPQ?=
 =?us-ascii?Q?i/fesW+Du3zjeJV7Urj+pA4iUNvcmq0aHhvvEkEnyCfoyAkKOPuQNiiPsO5t?=
 =?us-ascii?Q?XSgwI5pwEYU1BFksjdcJkq57y4mM7SjTonTS6OV4D1GIpNQl6544eAZ0RuYh?=
 =?us-ascii?Q?z7EDzi/G9OIBothakPf0GIoLhXU2CHrnj1WasuFQ6qRBUap2dAhazrRbvb9v?=
 =?us-ascii?Q?m6xmCvkEAPm2zHq9X8w4c5vSOFfvEnbL++tFBNQN9zFBUzM+h7HkQlUMw2hR?=
 =?us-ascii?Q?xnFJB86xF31EGnc90Qwn1MJxZj2AyRu2713yzH6NzSdmKBcvqU9YRNQA5xeX?=
 =?us-ascii?Q?BEUcQsLJm/JHzfBWomIq4f8+mJMx/9EtJXOrDdTw7EIn6Jqpti/LZxBy+qN1?=
 =?us-ascii?Q?6O+BFZ7SkDnOmp6KsFrcDdVWrZsn0jxjSe5qVM3+EGw+AVECSG6krFru5tnJ?=
 =?us-ascii?Q?WEdYAMmM9crNXYnU2nfJVU85ku5yvF8zfXCY5V7DET1BazoKt+yAsK9CPwja?=
 =?us-ascii?Q?bIiLCBE5C7iC0p16t9o0bKaSYN+pGFrSMKqvOU1VgTo3kVcTV1IyJxZ9oqAW?=
 =?us-ascii?Q?VazQvAx1rLjYLQt8O3CmqaL658xtetL19cneG1tKhwnv3qBhAetlLVT8u2PR?=
 =?us-ascii?Q?oGWaiv6LPcV5vFR8P1eTU7LdiClU2MPws6MEY+t0HAgs1v3uI3d0I+AXz9Ui?=
 =?us-ascii?Q?xIHa7ukVjTYBJ7nSt3rdMqRnc5tMBwRvwxAz4DFNb8nJod4lbHrGlXIOf6F4?=
 =?us-ascii?Q?2RD6SRwuIUc60xC8k1GoZTwq2Fz2EkCGdfgbftehwDugoTa19BFjUgpUl1V0?=
 =?us-ascii?Q?bmIFekd00aLWK+2PkUblnYWFC7dA9y1dnhqm+i+yIEHrWUgCr9Ps5mV7IWlx?=
 =?us-ascii?Q?1RnDZjOfATFOGlrVOet1I9He2GIFmkfnj/0tndMFaFCbIQshaBKWAjGOP7e+?=
 =?us-ascii?Q?VBZjXfEFKojufmg3x3s75TUBKAIZrwBqmfL5i+yVHITZUZ0a3VsDmoQiuHLG?=
 =?us-ascii?Q?0f+wouuqVV//KZv4vMItQPdHSvqCSy4w0uSvJ7L++FS6IWtgMZ9PlP44n9Pa?=
 =?us-ascii?Q?nlIa03pYjSJ2H3b6BCW0YZftNsI5K7wVT16J3dkpQyn2bEee62eDHCRg8SeI?=
 =?us-ascii?Q?G/JpYD4/z21K06IYOxbSJtf6J5ZIDOXWZ9B/v6rGPPm4wsdDPr5o/j5QlTJK?=
 =?us-ascii?Q?+fXXJPMG4O8cPVeM8GUc/mQvYgNC+BPtlcE/L4REGb6Pg0px6jd5FJCcHqTn?=
 =?us-ascii?Q?fbaFFl+phSPLKxK6Qfyab9h/kgQ6kJftPdwLIbxifMDU1GqBmMfDH2C0Qf4c?=
 =?us-ascii?Q?qJFUyC9w5Z24NxPdSxcfXoKJUpLFPd+AJk2B0dmNs/qF+22YToFdKK2PxHva?=
 =?us-ascii?Q?HIZHow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922b56cd-a9d4-4e8f-53f8-08db5ac31ce1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:50:25.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8aRFMI77V5xBnzhjbI6i0uiZTNTJdxyqXJQ2EvghrWu92Fi5yiEMWsVuMRNdnq7HajlxQXp0UlQRV99/tj2TthBU+ffwg9VQnJG4cYkvcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:01:20PM +0800, Abel Wu wrote:
> The status of global socket memory pressure is updated when:
> 
>   a) __sk_mem_raise_allocated():
> 
> 	enter: sk_memory_allocated(sk) >  sysctl_mem[1]
> 	leave: sk_memory_allocated(sk) <= sysctl_mem[0]
> 
>   b) __sk_mem_reduce_allocated():
> 
> 	leave: sk_under_memory_pressure(sk) &&
> 		sk_memory_allocated(sk) < sysctl_mem[0]
> 
> So the conditions of leaving global pressure are inconstant, which
> may lead to the situation that one pressured net-memcg prevents the
> global pressure from being cleared when there is indeed no global
> pressure, thus the global constrains are still in effect unexpectedly
> on the other sockets.
> 
> This patch fixes this by ignoring the net-memcg's pressure when
> deciding whether should leave global memory pressure.
> 
> Fixes: e1aab161e013 ("socket: initial cgroup code")

really pedantic nit:

Fixes: e1aab161e013 ("socket: initial cgroup code.")

> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>

...

