Return-Path: <netdev+bounces-6432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CAF7163EB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 941CC1C20C88
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DD523C7C;
	Tue, 30 May 2023 14:25:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4762106D
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:25:24 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2137.outbound.protection.outlook.com [40.107.101.137])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC51136
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:24:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCETg9boPm+5Zd/zcjtOAsSEYpLjiAf5K3RXr3tLwvt2sLwMmsDL1G4Qm8wHlF38eIABsi9AvdA6Z8uNYoMF9tT1MsIIgFq36wS/tuK5oIREksJ7oQ7JGz0iRoXY4haqLqDsWUP/WeVCwZz7/qVgUXOfvWd00YXVGWB8seEJHYS0/iHLniMpRh6SUvJrY5skgFHqKxKJ7h7I2ft1TX5SJsdK68z2YyJq2rl0NRLx5oirUC7xwcvap+UoXDKDqJ7bySySjty73FWDPNLkjFyATdl6m9A9F17lwMCZswKsepU8kdIAFe59S2ptiNUAvtOGH/o/0dpdHo71jsbjY2h5OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c71VrN7om/DcVjZ1f4FYFJDoU0+qzieEOqVFinV9HLo=;
 b=JABFTQdF8dzzkEfsgi2OihkQ/hyBmKbjYl69QgrYgGdErO9m3XhzRYy0Msm5WzmcYgs79ljQEMS2lQpi8ShR0RfngJHp+i2z/u7z1gJsXwbBa7u2zZQzTrN1siIdbGyKsd7R8Z4RbVE3TOZhKlrk5ijkKGHacHeX5Ft9kFlc/R0DvRlhx5zkHvNqZyHTOyMUcfibMpbgIgqMyxz215mBv05txRvOejPnztov9W5ZSmqClNKURUmjAcyb1mL8mA+V7khZL7wEDJHSSET2OywrTefjBToT/VzrlpZjY19NKwK/6LoJeC9MCwL6PB+wp8sW4ma8IcAlja/YHM6N0ptcxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c71VrN7om/DcVjZ1f4FYFJDoU0+qzieEOqVFinV9HLo=;
 b=Egq+tQA8cwpkZ65c3dS6vgocBp2rXyEX0hTMJw6b2JaAvnF4v0AUJbD9SGdXH2XsXyvTusGXnFABQTphbK33osnA5sNItsS4U9/BrxsHCDqWHJnVXI04cC81A9oXHvxQLrzprzjjqUsYVMzm7KI9otpJEbv8sZYdfk/Ygnee4Ds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5871.namprd13.prod.outlook.com (2603:10b6:a03:439::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 14:24:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 14:24:16 +0000
Date: Tue, 30 May 2023 16:24:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 05/14] udp: Remove UDP-Lite SNMP stats.
Message-ID: <ZHYHCuAy8txERBNR@corigine.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
 <20230530010348.21425-6-kuniyu@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530010348.21425-6-kuniyu@amazon.com>
X-ClientProxiedBy: AS4P189CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: ca475754-2b8c-4686-b903-08db61198c86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4KYi1dx6beAoR8IuAw4fp7xQqys22LrIJXGHTi9z+8smH4iAx2IfnG2GhCDqSVC24p0BRCJIpzVhMPDeYHeMC1ahYB1Dcarwc9YMOHI+ZmuaLEGo98VL9q4Uaj4pcxGluSUNQOHBlvHrXJSRaPwkpCc/gMm7Al/RzvLAuUT7diQo4nqusb/2zTkgG9ZNl3UJvMNx9EB+i269cDeUWADkPlPZCoUo7MiHAalyibUx969ssu+Epxe6KkBmEAABtuEatYzRjlFQ32uQo5NrO1BnxSfYWoFPUUsrvslPHKbZyvUopVcXXqyBSTJtvi0SN6DZ1ooO8z0XcD7RRpQvXVmC11sOjskmRbDYjQf42tAcHqYuUjNYIp4xSSUvtZ8/S3R60P2f5IANr12iUlsEmu37Jiz7tr9Nw6RwtBEc4E1Blh1IMfToAqlAAk5DvBQN9fOKiZYBbTP+odN8tZZfEfkWNZPoqFvFaE+nkolDqWQYUOhQZEnEgyxOh0VznfDzTqcasikgA7RYxXUQwcGDZK3s3crwIspxXPY7+4sPP0PRGj+2q9VrSEWaWMO5LmWMqZQI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199021)(6506007)(6512007)(4744005)(186003)(2616005)(2906002)(54906003)(478600001)(44832011)(86362001)(8676002)(41300700001)(6486002)(38100700002)(8936002)(66946007)(66556008)(66476007)(316002)(5660300002)(6666004)(36756003)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DGKS03f7NDRCDdLeaSh6Is4uRG7XZDsUCAvig/tbrZmnWWh4yxLF/r8PbLj1?=
 =?us-ascii?Q?b3kE5q7oFzWVYlynbBiFciBj9Ejkqj+YhQP8vB1jY6VcX6QT/z115wT0UuDk?=
 =?us-ascii?Q?PrBpIBM2R5uw9tb3nYRl2Tsj1KmHKsQ9KKcxk/xZpvEMNQm4fgxS1sOET1qu?=
 =?us-ascii?Q?Uw2JibTDL4IsRxzsxnXcn3EVCC5TlIxPBlX97+8xYwfhvaM/e+rwha++sSz/?=
 =?us-ascii?Q?+n3sK+Faa8d/HcLJTWb9vANhkgzaKVEETROoKfGF0Cwdh36DeysVqbL7CYud?=
 =?us-ascii?Q?/vjaq6BaUXMYSNQOApFIC/xBMU2CO0wJJ7AHZJZWFVLMawlSPiB56m9kZajP?=
 =?us-ascii?Q?SpMPKPLExWwdGiW6PO2+cFCT9eEKzAZkbu1MKuShnXp8N7wfd/2resI5hxMl?=
 =?us-ascii?Q?YHb3z+f+xt2OJh7CO3gsZWq4j5SWspm4gJ+UyqHIojtfeUfrMyjmEcBNoEhg?=
 =?us-ascii?Q?QkqH65kN7Khv5iHMxU+jpdr8AxcoCGIGD2xi1DIfyNCfI0zEFR2WFjfrzVcd?=
 =?us-ascii?Q?Ni7mj5nWd6LR3KLR7EhvuHaQJ0HqZOaAfk4+X4kj3i5CXFoz5RJzIgHBPTD1?=
 =?us-ascii?Q?LONc9AXamaob8LUU5I0GXqsc5dI+/oAdqaGwuJMJpuT7XOTn4g/1CT7b0rN1?=
 =?us-ascii?Q?aani/eKHSbNhxseU4UgLRjjJvb5ClBGuTIIjsPo7I6ydD5czldeVXgkIyxxJ?=
 =?us-ascii?Q?NxCZH0kZ3WDd9+x9ciFaoGfA41Cw/Jcu8+pDc+4qDf3GF4YXE3tKI16KJ6Gm?=
 =?us-ascii?Q?LLVmawe056Ln00uE7a8GxYXeNrB/PpM4HsJ+E09S+/mhh74BXI085W6mU+1a?=
 =?us-ascii?Q?9Wh3g5rr1ZMJNs5N2qfd7o8z1T0B5hGmLUuiDXHiU8yQKQ8iu8DPPEgkCj9J?=
 =?us-ascii?Q?uX+h1L83Wo6bxbTnU1NCttUW2RHwj/tm3xW8vpySOC/rg8ox2GBn6OmpbuAJ?=
 =?us-ascii?Q?OOGWL1GIORqR9hf8tvqtnkMT8ol0VWHXLGZcEWRAFj+a3av3bHrroy3KWDxQ?=
 =?us-ascii?Q?VuHB21rQDQbbKvMvqpub+DWcb1ta9OzLUuqSRXLsM587x4echsMGRUIWFG5Q?=
 =?us-ascii?Q?V0/EMoweVGpCtAX+n+t+wb4ZEdvCiESCIb+kI8/w4d9olUjRO8JrNC/F3fbk?=
 =?us-ascii?Q?2AhsswgQkUFMqIFnmvod4nbdxdK6Ti0EOm6wMq3nq4RMUc4oKo8Dur6kiDMQ?=
 =?us-ascii?Q?+bbeqoUXUQzZ/obUoRR1CbfEHLIj1V6Cz2kcsWd7a7NEAVUCITc0VwAmPfHo?=
 =?us-ascii?Q?GWe1iMstD8pbdu7CFWzTIFN3q4frewiA4hu3OHh4svqCt+7tufGz2OERa5G3?=
 =?us-ascii?Q?MlqiPD+v947PPJvQqHskjPUssUKYFWFQPaOwGPJmbMoBZw8o8vjj7myC5JgQ?=
 =?us-ascii?Q?LHtwMJWIpCQGwU4tdpb+ICOfPSIKJKCbkvEGOhvyfx553qX2LQ++FtnNd8c/?=
 =?us-ascii?Q?GVQy9jsvzJ0HvBkVdFv8ZlA8HO7bRsnYCEUBh4nWPVu4P8Zqy7dD1Wg9Y41b?=
 =?us-ascii?Q?Ne2To7AcOInrvXAU3A1Mr+GXdz9WF+j6MUqciThjLnhWiTwP9Uh3mufyQZdJ?=
 =?us-ascii?Q?asZPAo/vjg4S+SyOEE77CjTg/R48EuGSr3fW/wm9xIf824KA9nn74eIWkPSE?=
 =?us-ascii?Q?B8XMPzHpTMcSHbKZR2YwcYqyGsrq1SgWB6FQ7wcAz83bSAL2xS+O28QEP/tR?=
 =?us-ascii?Q?W5T+Fw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca475754-2b8c-4686-b903-08db61198c86
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 14:24:16.4199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vqQMTnvQjtMkuWEBuOgZeG8zHDlGq0G+CTpdhvBN+NfL4z61LrvsOqk4M3BhIsZ9+JZ0hyLfVm5N/CidowMkfToXE/QUVjCV2x8fl8AyP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5871
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 06:03:39PM -0700, Kuniyuki Iwashima wrote:
> We stored UDP-Lite stats in udplite_statistics and udplite_stats_in6
> of struct netns_mib.
> 
> Since UDP and UDP-Lite share code, UDP_INC_STATS() always has to
> check if the socket is UDP-Lite.  However, we no longer increment
> UDP-Lite stats.
> 
> Let's remove the stats and save one protocol test.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

...

> diff --git a/include/net/udp.h b/include/net/udp.h
> index bfe62e73552a..d00509873f6f 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -390,37 +390,28 @@ static inline int copy_linear_skb(struct sk_buff *skb, int len, int off,
>  }
>  
>  /*
> - * 	SNMP statistics for UDP and UDP-Lite
> + * 	SNMP statistics for UDP

nit: While we are here perhaps the space before the tab can be removed.

Otherwise, LGTM.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


