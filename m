Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C423B8E0
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgHDKhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:37:21 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:24133
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbgHDKhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 06:37:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQukjpHULWi/kmsWlDvF/qS5iAWkJR6VVGPN2ZAXzWYLzV3CYZHR6JBo25sfq2ngkycmChLdN5K9En9uRvPIdxoEjQhCTDI5QnLCd+V/SPGSSr2yyoPeGAaorEipK3qGfkQWHFlZ9ZwngrXX4a84IOachhnGCdAbHn7nsQXV61lbFkGak5Ig4X8qPdmsfb7ETo0S0mfnUeiM3CmeKTQOA81a09vfRqRsZsoN4Aq+DMzWfxwnHNJ5GIrZa+INY5abXuOYwnKV5sI+7iRUv8do2SVICYk7WG1qzJMbLW8860b2vklmuYD2YkBcEb0sNyemsmwyjqGbVqqMKnxa2T59zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtaMFHqkrSKkrhVI7NNEuhEZxrxgfcFCRONJGMpGV2M=;
 b=SDVnOOkFGV4cxKslepceAuWek52aZDXA5aZgBc+Skm52F+NJ8YlSSWm2L02mgOXDuhUDBAKOETPwjg2e2FduylMKCU2LS/XI4GcrYN6vB7BjeMpf5CbVJWV4wwWHZLmOLIi/u06d1R5vHtwmixNZcrOQNbCkobGUCAUHMYCtmPMO6Nn8wL+BtO8tJdaAWlkDyeayEO47SGpDSR4t9QhDuEtapC2v6La16SqxaNAdJDFWgXOcpVSj007TzHtWSBdbZqa/QTtxRoLpk6WVjE5Im+4+eD92bG2gGUS6BfOs8ULi5lvKcKus6er6J7PBhhr9LBNFI94itrZfqLjixAq03Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtaMFHqkrSKkrhVI7NNEuhEZxrxgfcFCRONJGMpGV2M=;
 b=fSQclLdZ908EYJDkJNZ8oO4Z8Ea9cg781m+tL9rc2OwMQXCTnRD6op7NcePLEZBmfA5oX1F81DhnX9POfUhy+QacBkWV2DRqGiemR73uRnwRy49NyPm7mK/td9EU40vawXkw+qVOGWpYFgqXVc2IgS/XJ8Em14edMaSfU5e+ewc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5302.eurprd05.prod.outlook.com (2603:10a6:20b:69::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 4 Aug
 2020 10:37:06 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 10:37:06 +0000
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <ed6c70d4-d99d-87c4-b7fe-9403683d3594@mellanox.com>
Date:   Tue, 4 Aug 2020 13:37:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::13) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 4 Aug 2020 10:37:05 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c07a3c5-569e-4ba9-4c1b-08d838625519
X-MS-TrafficTypeDiagnostic: AM6PR05MB5302:
X-Microsoft-Antispam-PRVS: <AM6PR05MB530234624641B64B80A1AE6BD14A0@AM6PR05MB5302.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5SSw5216jr5wx+q3Sb25KFpHHopJ5lqwqsof7jc9HKJ7zWl2O9np+HKu/hMifRLgaTTVOJAHgFpCidB6fASg2pGUkq9+nWkZp9fErOpJXRt7dMNimOH5dPAWb899lszJb2whCMiRUpyCduDB/c0fe7GVeo68/lQyZlmMKi8TmBQELVnrvXsUqV99qDWQoaJezP4Vgtrt/TYPRZ9lB3u0sw8MWR8+/dUeEZuYdLg7zRuE0dBaol0OFoG9gQ0yHcCULArcXLcv2jt5x7ChJd1/FL60r+NBiPg7LlZgF5rnKm+mSiwmdbVs2gqtlC3RLgde897PLq7rHVblqpoGfHj94qJFUbeig6snf0bCLIdcPcP0HOi0Fg4VW9GaGrVjBxL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(6666004)(30864003)(66556008)(53546011)(186003)(55236004)(83380400001)(66946007)(26005)(66476007)(16526019)(5660300002)(316002)(16576012)(8676002)(2616005)(956004)(52116002)(36756003)(2906002)(4326008)(8936002)(31696002)(6916009)(86362001)(478600001)(31686004)(6486002)(43740500002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qqhTGK1vYRKr6UrbQUE5jEJw4scPm5lTN7MPVKAk7FgUMaw/IXFUpygpG7ex4xDfap9lYl/xK8xZaAKM0OJafI4AFyj7UhtrZ+nZ0CyLNdDZqhtWVyW4HHAtfXcMvdQt5lzo8ByP0hGSNfUKak9lmFVtnNM1B02JVHAFq+SoaSZVtoV5QUKf2UnhfsvWZtnCiIPm0IMgS9rnniuHb7rxEJTEsugFe5ak7LEq5eJzqZ56V09CPA9A/60RaYVN21cU0C6338qZjigsqXqDpOzBO/2lbymHUnp8Pjix8fbZlESRl0S4+fDImBI8r3FHD5kgiMFu1ea7phLNfs3cE9HfMNWUudwMN3c4xhK9I0UCmlZ39NnhyhDg+5BpDDW1S4gD+WA5q9HdmM+is4dTHtjvIuNVCuPbEHBZaJYTXN+zOa+2UYritN6xQ1iJjKR/iTB5ykkQAFfGKVS0++A8aPlIDF8mnXGfnLpq3sd57EyHoYAqKRrpS89WmGCwN3COXZRXi8Qd0szjnM4oHaW9h5UMVBqy9zYkwS5LmRkn9FZSQlz1V36kNmj7hr2TkgUphXaBtSXvznSyqNLzLMPxlgHzSvMqY2k2yhaDkaQOxhH5wLuJHoI9ADAJWFw3N2LsDITU8B2RKfgeKcyzQQe9dDIffQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c07a3c5-569e-4ba9-4c1b-08d838625519
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2020 10:37:06.0715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwLM0Onk5PLn9XumUzXoJIJoeHkUNBXgLMaP8R/gFfiFEExiTHKeHzcULes+/tp/lI0YmdvHvdcscx3D/Cq29Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5302
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-08 19:38, YU, Xiangning wrote:
> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
> use of outbound bandwidth on a shared link. With the help of lockless
> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
> designed to scale in the cloud data centers.

Hi Xiangning,

Thanks for your work on LTB qdisc. I tested it out and found a few bugs, 
please see comments below.

Are you planning to respin this patch? I think it's useful for some 
scenarios, even though there is the EDT+BPF approach.

Also, I see difference in behavior of HTB and LTB in the following 
configuration (replace htb with ltb and remove "r2q 100000" to 
reconfigure for ltb):

tc qdisc replace dev eth0 root handle 1: htb default 20 r2q 100000
tc class add dev eth0 parent 1: classid 1:1 htb rate 1000mbps ceil 1000mbps
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 200mbps ceil 700mbps
tc class add dev eth0 parent 1:1 classid 1:20 htb rate 700mbps ceil 1000mbps
tc qdisc add dev eth0 clsact
tc filter add dev eth0 egress protocol ip flower ip_proto tcp dst_port 
6001 action skbedit priority 1:10

# Shows 5.34 Gbit/s:
iperf3 -c 198.18.0.209 -t 0 -p 6001

# Shows 7.49 Gbit/s:
iperf3 -c 198.18.0.209 -t 0 -p 6002

When I run two iperf3 instances together, the total speed is ~7.6 
Gbit/s, with the first instance transmitting about 1.5-2.3 Gbit/s. That 
makes sense, because the total speed is limited to 1 Gbyte/s, the first 
flow runs at 200-300 Mbyte/s, leaving at least 700 Mbyte/s for the 
second flow.

However, with LTB the aggregate limit is not enforced, and when I run 
two iperf3 instances simultaneously, they are transmitting at 5.35 
Gbit/s and 7.64 Gbit/s correspondingly, which is 700 + 1000 Mbyte/s - 
the upper bounds for leaf classes, but the upper bound for class 1:1 
seems to be ignored.

> 
> Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>
> ---
>   include/uapi/linux/pkt_sched.h |   35 +
>   net/sched/Kconfig              |   12 +
>   net/sched/Makefile             |    1 +
>   net/sched/sch_ltb.c            | 1255 ++++++++++++++++++++++++++++++++
>   4 files changed, 1303 insertions(+)
>   create mode 100644 net/sched/sch_ltb.c
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 9e7c2c607845..310a6271dde4 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -447,6 +447,41 @@ struct tc_htb_xstats {
>   	__s32 ctokens;
>   };
>   
> +/* LTB section */
> +
> +#define TC_LTB_PROTOVER	3 /* the same as LTB and TC's major */
> +#define TC_LTB_NUMPRIO	16
> +enum {
> +	TCA_LTB_UNSPEC,
> +	TCA_LTB_PARMS,
> +	TCA_LTB_INIT,
> +	TCA_LTB_RATE64,
> +	TCA_LTB_CEIL64,
> +	TCA_LTB_PAD,
> +	__TCA_LTB_MAX,
> +};
> +#define TCA_LTB_MAX (__TCA_LTB_MAX - 1)
> +
> +struct tc_ltb_opt {
> +	struct tc_ratespec rate;
> +	struct tc_ratespec ceil;
> +	__u64 measured;
> +	__u64 allocated;
> +	__u64 high_water;
> +	__u32 prio;
> +};
> +
> +struct tc_ltb_glob {
> +	__u32 version;          /* to match LTB/TC */
> +	__u32 defcls;           /* default class number */
> +};
> +
> +struct tc_ltb_xstats {
> +	__u64 measured;
> +	__u64 allocated;
> +	__u64 high_water;
> +};
> +
>   /* HFSC section */
>   
>   struct tc_hfsc_qopt {
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index a3b37d88800e..9a8adb6e0645 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -76,6 +76,18 @@ config NET_SCH_HTB
>   	  To compile this code as a module, choose M here: the
>   	  module will be called sch_htb.
>   
> +config NET_SCH_LTB
> +	tristate "Lockless Token Bucket (LTB)"
> +	help
> +	  Say Y here if you want to use the Lockless Token Buckets (LTB)
> +	  packet scheduling algorithm.
> +
> +	  LTB is very similar to HTB regarding its goals however is has
> +	  different implementation and different algorithm.
> +
> +	  To compile this code as a module, choose M here: the
> +	  module will be called sch_ltb.
> +
>   config NET_SCH_HFSC
>   	tristate "Hierarchical Fair Service Curve (HFSC)"
>   	help
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index 66bbf9a98f9e..6caa34d5a032 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
>   obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
>   obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
>   obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
> +obj-$(CONFIG_NET_SCH_LTB)	+= sch_ltb.o
>   obj-$(CONFIG_NET_SCH_HFSC)	+= sch_hfsc.o
>   obj-$(CONFIG_NET_SCH_RED)	+= sch_red.o
>   obj-$(CONFIG_NET_SCH_GRED)	+= sch_gred.o
> diff --git a/net/sched/sch_ltb.c b/net/sched/sch_ltb.c
> new file mode 100644
> index 000000000000..37ed67c5606f
> --- /dev/null
> +++ b/net/sched/sch_ltb.c
> @@ -0,0 +1,1255 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* net/sched/sch_ltb.c Lockless Token Bucket.
> + *
> + * Authors:	Xiangning Yu <xiangning.yu@alibaba-inc.com>
> + *		Ke Ma <k.ma@alibaba-inc.com>
> + *		Jianjun Duan <jianjun.duan@alibaba-inc.com>
> + *		Kun Liu <shubo.lk@alibaba-inc.com>
> + */
> +#include <linux/moduleparam.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/skbuff.h>
> +#include <linux/list.h>
> +#include <linux/compiler.h>
> +#include <linux/rbtree.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/ip.h>
> +#include <linux/if_vlan.h>
> +#include <linux/wait.h>
> +#include <linux/atomic.h>
> +#include <linux/kfifo.h>
> +#include <linux/kallsyms.h>
> +#include <linux/irq_work.h>
> +#include <linux/percpu.h>
> +#include <linux/preempt.h>
> +#include <linux/hashtable.h>
> +#include <linux/vmalloc.h>
> +#include <linux/ethtool.h>
> +#include <net/ip.h>
> +#include <net/netlink.h>
> +#include <net/sch_generic.h>
> +#include <net/pkt_sched.h>
> +
> +#define	LTB_VERSION		0x30001
> +#define	LTB_CLASS_CONDEMED	1
> +#define	HIGH_FREQ_INTERVAL	1000	/* ns */
> +#define	LOW_FREQ_INTERVAL	50	/* sampling rate, in ms */
> +#define	SHADOW_CLASSID		0
> +
> +#define	BYTES_PER_JIFF(bps)	((bps) / HZ)
> +#define	BYTES_PER_INTERVAL(bps)	(LOW_FREQ_INTERVAL * BYTES_PER_JIFF(bps))

I think these calculations assume that HZ == 1000. Otherwise, if you 
want to have LOW_FREQ_INTERVAL = 50 ms (as indicated in the comment) 
with any HZ, you need to adjust the calculations like this:

#define        BYTES_PER_MS(bps)       ((bps) / 1000)
#define        BYTES_PER_INTERVAL(bps) (LOW_FREQ_INTERVAL * 
BYTES_PER_MS(bps))
#define        NOW()                   (jiffies * 1000 / HZ / 
LOW_FREQ_INTERVAL)

> +#define	MINBW			(10 * 1000 * 1000L)
> +#define	HIGH_THRESHOLD		80
> +#define	SUPPRESS_THRESHOLD	90
> +#define	MAX_CPU_COUNT		128	/* make it dynamic */
> +#define	SKB_QLEN		512
> +#define	NOW()			(jiffies / LOW_FREQ_INTERVAL)
> +#define	BPS2MBPS(x)		((x) * 8 / 1000000) /* Bps to Mbps */
> +
> +static struct Qdisc_ops ltb_pcpu_qdisc_ops;
> +
> +static const struct nla_policy ltb_policy[TCA_LTB_MAX + 1] = {
> +	[TCA_LTB_PARMS]	= { .len = sizeof(struct tc_ltb_opt) },
> +	[TCA_LTB_INIT] = { .len = sizeof(struct tc_ltb_glob) },
> +	[TCA_LTB_RATE64] = { .type = NLA_U64 },
> +	[TCA_LTB_CEIL64] = { .type = NLA_U64 },
> +};
> +
> +struct ltb_class {
> +	struct Qdisc_class_common common;
> +	struct psched_ratecfg ratecfg;
> +	struct psched_ratecfg ceilcfg;
> +	u32 prio;
> +	struct ltb_class *parent;
> +	struct Qdisc *qdisc;
> +	struct Qdisc *root_qdisc;
> +	u32 classid;
> +	struct list_head pnode;
> +	unsigned long state; ____cacheline_aligned_in_smp
> +
> +	/* Aggr/drain context only */
> +	s64 next_timestamp; ____cacheline_aligned_in_smp
> +	int num_cpus;
> +	int last_cpu;
> +	s64 bw_used;
> +	s64 last_bytes;
> +	s64 last_timestamp;
> +	s64 stat_bytes;
> +	s64 stat_packets;
> +	atomic64_t stat_drops;
> +
> +	/* Balance delayed work only */
> +	s64 rate; ____cacheline_aligned_in_smp
> +	s64 ceil;
> +	s64 high_water;
> +	int drop_delay;
> +	s64 bw_allocated;
> +	bool want_more;
> +
> +	/* Shared b/w aggr/drain thread and balancer */
> +	unsigned long curr_interval; ____cacheline_aligned_in_smp
> +	s64 bw_measured;	/* Measured actual bandwidth */
> +	s64 maxbw;	/* Calculated bandwidth */
> +
> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN) aggr_queues[MAX_CPU_COUNT];
> +	____cacheline_aligned_in_smp
> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN * MAX_CPU_COUNT) drain_queue;
> +	____cacheline_aligned_in_smp
> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN) fanout_queues[MAX_CPU_COUNT];
> +	____cacheline_aligned_in_smp
> +
> +	struct tasklet_struct aggr_tasklet;
> +	struct hrtimer aggr_timer;
> +};
> +
> +struct ltb_pcpu_data {
> +	struct Qdisc *qdisc; ____cacheline_aligned_in_smp
> +	bool active;
> +};
> +
> +/* Root qdisc private data */
> +struct ltb_sched {
> +	struct Qdisc *root_qdisc;
> +	struct net_device *dev;
> +	int num_cpus;
> +	s64 link_speed;
> +	struct delayed_work balance_delayed_work;
> +	int balance_period;
> +
> +	struct ltb_pcpu_data *pcpu_data; ____cacheline_aligned_in_smp
> +	struct tasklet_struct fanout_tasklet;
> +
> +	struct ltb_class *default_cls;
> +	struct ltb_class *shadow_cls; /* If there is no class created */
> +	u32 default_classid;
> +
> +	rwlock_t prio_rows_lock;
> +	struct list_head prio_rows[TC_LTB_NUMPRIO]; /* Priority list */
> +	struct Qdisc_class_hash clhash;
> +};
> +
> +/* Per-cpu qdisc private data */
> +struct ltb_pcpu_sched {
> +	struct ltb_sched *ltb;
> +	struct Qdisc *qdisc;
> +	int cpu;
> +	struct irq_work fanout_irq_work;
> +	s64 last_irq_timestamp;
> +};
> +
> +/* The cpu where skb is from */
> +struct ltb_skb_cb {
> +	int cpu;
> +};
> +
> +static struct ltb_skb_cb *ltb_skb_cb(const struct sk_buff *skb)
> +{
> +	qdisc_cb_private_validate(skb, sizeof(struct ltb_skb_cb));
> +	return (struct ltb_skb_cb *)qdisc_skb_cb(skb)->data;
> +}
> +
> +static s64 get_linkspeed(struct net_device *dev)
> +{
> +	struct ethtool_link_ksettings ecmd;
> +
> +	ASSERT_RTNL();
> +	if (netif_running(dev) && !__ethtool_get_link_ksettings(dev, &ecmd) &&
> +	    ecmd.base.speed != SPEED_UNKNOWN)
> +		/* Convert to bytes per second */
> +		return ecmd.base.speed * 1000 * 1000L / 8;
> +	return 0;
> +}
> +
> +static int ltb_update_linkspeed(struct ltb_sched *ltb)
> +{
> +	s64 linkspeed;
> +
> +	if (!rtnl_trylock())
> +		return -1;
> +
> +	linkspeed = get_linkspeed(ltb->dev);
> +	if (ltb->link_speed != linkspeed)
> +		ltb->link_speed = linkspeed;
> +	rtnl_unlock();
> +	return 0;
> +}
> +
> +static int ltb_drain(struct ltb_class *cl)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
> +	struct ltb_pcpu_sched *pcpu_q;
> +	bool need_watchdog = false;
> +	unsigned int npkts, bytes;
> +	unsigned long now = NOW();
> +	struct cpumask cpumask;
> +	struct sk_buff *skb;
> +	s64 timestamp;
> +	int cpu;
> +
> +	npkts = 0;
> +	bytes = 0;
> +	cpumask_clear(&cpumask);
> +	while (kfifo_peek(&cl->drain_queue, &skb) > 0) {
> +		int len = qdisc_pkt_len(skb);
> +
> +		if (cl->curr_interval != now) {
> +			cl->curr_interval = now;
> +			timestamp = ktime_get_ns();
> +			cl->bw_measured = (cl->stat_bytes - cl->last_bytes) *
> +				NSEC_PER_SEC / (timestamp - cl->last_timestamp);
> +			cl->last_bytes = cl->stat_bytes;
> +			cl->last_timestamp = timestamp;
> +			cl->bw_used = 0;
> +		} else if (len + cl->bw_used > cl->maxbw) {
> +			need_watchdog = true;
> +			break;
> +		}
> +		kfifo_skip(&cl->drain_queue);
> +		cl->bw_used += len;
> +
> +		/* Fanout */
> +		cpu = ltb_skb_cb(skb)->cpu;
> +		ltb_skb_cb(skb)->cpu = 0;
> +		if (unlikely(kfifo_put(&cl->fanout_queues[cpu], skb) == 0)) {
> +			kfree_skb(skb);
> +			atomic64_inc(&cl->stat_drops);
> +		} else {
> +			/* Account for Generic Segmentation Offload(gso). */
> +			cl->stat_bytes += len;
> +			cl->stat_packets += skb_is_gso(skb) ?
> +			    skb_shinfo(skb)->gso_segs : 1;
> +			cpumask_set_cpu(cpu, &cpumask);
> +		}
> +	}
> +
> +	for_each_cpu(cpu, &cpumask) {
> +		struct Qdisc *q = per_cpu_ptr(ltb->pcpu_data, cpu)->qdisc;
> +
> +		pcpu_q = (struct ltb_pcpu_sched *)qdisc_priv(q);
> +		if (!(q->state & __QDISC_STATE_SCHED) && !qdisc_is_running(q))
> +			irq_work_queue_on(&pcpu_q->fanout_irq_work, cpu);
> +	}
> +
> +	return need_watchdog;
> +}
> +
> +static void ltb_aggregate(struct ltb_class *cl)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
> +	s64 timestamp = ktime_get_ns();
> +	int num_cpus = ltb->num_cpus;
> +	int i;
> +
> +	/* The worker might wake up more often than required */
> +	if (cl->next_timestamp > timestamp)
> +		/* Try again to keep the pipeline running */
> +		goto watchdog;
> +
> +	cl->next_timestamp = timestamp + HIGH_FREQ_INTERVAL;
> +
> +	/* Aggregate sk_buff from all CPUs. The memory footprint here should
> +	 * be fine because we don't touch each packet.
> +	 *
> +	 * It's possible to see out of order packets here. While within 1us,
> +	 * there won't be too many packets for a single flow, and the Linux
> +	 * scheduler is not expected to schedule an application too often
> +	 * within this tiny time gap, i.e. 1/1000 jiffies.
> +	 */
> +	for (i = 0; i < num_cpus; i++) {
> +		/* Process CPUs in a round-robin fashion */
> +		int qlen, drain_room;
> +		int n, j;
> +
> +		n = (i + cl->last_cpu) % num_cpus;
> +		qlen = kfifo_len(&cl->aggr_queues[n]);
> +		drain_room = kfifo_avail(&cl->drain_queue);
> +		if (drain_room == 0)
> +			break;
> +
> +		qlen = qlen < drain_room ? qlen : drain_room;
> +		for (j = 0; j < qlen; j++) {
> +			struct sk_buff *skb;
> +
> +			if (kfifo_get(&cl->aggr_queues[n], &skb)) {
> +				if (unlikely(kfifo_put(&cl->drain_queue,
> +						       skb) == 0)) {
> +					kfree_skb(skb);
> +					atomic64_inc(&cl->stat_drops);
> +				}
> +			}
> +		}
> +	}
> +	cl->last_cpu++;
> +	if (cl->last_cpu == num_cpus)
> +		cl->last_cpu = 0;
> +
> +	if (ltb_drain(cl) == false)
> +		return;
> +
> +watchdog:
> +	if (!test_bit(LTB_CLASS_CONDEMED, &cl->state))
> +		hrtimer_start(&cl->aggr_timer,
> +			      ns_to_ktime(1000 + ktime_get_ns()),
> +			      HRTIMER_MODE_ABS_PINNED);
> +}
> +
> +static enum hrtimer_restart ltb_aggr_watchdog(struct hrtimer *timer)
> +{
> +	struct ltb_class *cl = container_of(timer,
> +					    struct ltb_class, aggr_timer);
> +
> +	if (!test_bit(LTB_CLASS_CONDEMED, &cl->state))
> +		tasklet_schedule(&cl->aggr_tasklet);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +static void ltb_aggr_tasklet(unsigned long arg)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)arg;
> +
> +	rcu_read_lock_bh();
> +	if (!test_bit(LTB_CLASS_CONDEMED, &cl->state))
> +		ltb_aggregate(cl);
> +	rcu_read_unlock_bh();
> +}
> +
> +static void ltb_fanout(struct ltb_sched *ltb)
> +{
> +	int cpu;
> +
> +	for (cpu = 0; cpu < ltb->num_cpus; cpu++) {
> +		struct Qdisc *q = per_cpu_ptr(ltb->pcpu_data, cpu)->qdisc;
> +		struct ltb_pcpu_sched *pcpu_q;
> +
> +		pcpu_q = (struct ltb_pcpu_sched *)qdisc_priv(q);
> +		if (q->q.qlen > 0 && !(q->state & __QDISC_STATE_SCHED) &&
> +		    !qdisc_is_running(q))
> +			irq_work_queue_on(&pcpu_q->fanout_irq_work, cpu);
> +	}
> +}
> +
> +static void ltb_fanout_tasklet(unsigned long data)
> +{
> +	struct ltb_sched *ltb = (struct ltb_sched *)data;
> +
> +	ltb_fanout(ltb);
> +}
> +
> +static void ltb_fanout_irq_tx_func(struct irq_work *work)
> +{
> +	struct ltb_pcpu_sched *pcpu_q =
> +	    container_of(work, struct ltb_pcpu_sched, fanout_irq_work);
> +
> +	__netif_schedule(pcpu_q->qdisc);
> +}
> +
> +/* How many classes within the same group want more bandwidth */
> +static int bw_class_want_more_count(struct list_head *head)
> +{
> +	struct ltb_class *cl;
> +	int n = 0;
> +
> +	list_for_each_entry(cl, head, pnode) {
> +		if (cl->want_more)
> +			n++;
> +	}
> +	return n;
> +}
> +
> +/* Redistribute bandwidth among classes with the same priority */
> +static int bw_redistribute_prio(struct list_head *lhead, int bw_available,

Here, and in many places below, you use int for bandwidth. It overflows 
when link rate is 100 Gbit/s. A 64-bit value is needed for all 
bw_available variables and for return value of this function.

When it overflows, it leads to negative values, and packets are only 
transmitted at about 10 pps.

> +				int n, bool *all_reached_ceil)
> +{
> +	int orig_bw_allocated;
> +	struct ltb_class *cl;
> +	int safe_loop = 0;
> +	int avg = 0;
> +
> +	do {
> +		if (n > 0)
> +			avg = bw_available / n;
> +		list_for_each_entry(cl, lhead, pnode) {
> +			if (!cl->want_more)
> +				continue;
> +
> +			/* Try to allocate as much as possible */
> +			orig_bw_allocated = cl->bw_allocated;
> +			cl->bw_allocated = min_t(s64, (cl->bw_allocated + avg),
> +						 cl->ceil);
> +			/* Significantly larger than high water */
> +			if (cl->bw_allocated > cl->high_water * 120 / 100)
> +				cl->bw_allocated = cl->high_water;
> +			bw_available -= cl->bw_allocated - orig_bw_allocated;
> +			if (cl->bw_allocated >= cl->high_water ||
> +			    cl->bw_allocated == cl->ceil) {
> +				cl->want_more = false;
> +				n--;
> +			}
> +		}
> +	} while (bw_available > 0 && n > 0 && safe_loop++ < 2);
> +
> +	*all_reached_ceil = true;
> +	list_for_each_entry(cl, lhead, pnode) {
> +		if (cl->bw_allocated != cl->ceil)
> +			*all_reached_ceil = false;
> +	}
> +
> +	return bw_available;
> +}
> +
> +static void bw_suppress_lower(struct ltb_sched *ltb, int high)
> +{
> +	int prio;
> +
> +	read_lock_bh(&ltb->prio_rows_lock);
> +	for (prio = TC_LTB_NUMPRIO - 1; prio > high; prio--) {
> +		struct ltb_class *cl;
> +
> +		list_for_each_entry(cl, &ltb->prio_rows[prio], pnode) {
> +			if (cl->bw_allocated > cl->rate) {
> +				cl->bw_allocated = max_t(s64,
> +							 cl->bw_measured *
> +							 90 / 100, cl->rate);
> +			}
> +		}
> +	}
> +	read_unlock_bh(&ltb->prio_rows_lock);
> +}
> +
> +static int bw_redistribute(struct ltb_sched *ltb, int bw_available)
> +{
> +	int highest_non_saturated_prio = TC_LTB_NUMPRIO;
> +	bool all_reached_ceil;
> +	int prio = 0;
> +	int n;
> +
> +	read_lock_bh(&ltb->prio_rows_lock);
> +	for (; prio < TC_LTB_NUMPRIO; prio++) {
> +		struct list_head *head = &ltb->prio_rows[prio];
> +
> +		all_reached_ceil = true;
> +
> +		n = bw_class_want_more_count(head);
> +		bw_available = bw_redistribute_prio(head, bw_available,
> +						    n, &all_reached_ceil);
> +		if (!all_reached_ceil && highest_non_saturated_prio > prio)
> +			highest_non_saturated_prio = prio;
> +
> +		if (bw_available < 0)
> +			break;
> +	}
> +	read_unlock_bh(&ltb->prio_rows_lock);
> +	return highest_non_saturated_prio;
> +}
> +
> +static void bw_sync_all(struct ltb_sched *ltb, int bw_available,
> +			int is_light_traffic)
> +{
> +	struct ltb_class *cl;
> +	int i;
> +
> +	for (i = 0; i < ltb->clhash.hashsize; i++) {
> +		hlist_for_each_entry_rcu(cl, &ltb->clhash.hash[i],
> +					 common.hnode) {
> +			if (cl->classid == SHADOW_CLASSID)
> +				continue;
> +
> +			if (is_light_traffic)
> +				cl->bw_allocated = min_t(s64, cl->ceil,
> +							 cl->bw_allocated +
> +							 bw_available);
> +			cl->maxbw = BYTES_PER_INTERVAL((s64)cl->bw_allocated);
> +			/* Maxbw will be visiable eventually. */
> +			smp_mb();
> +		}
> +	}
> +}
> +
> +static void bw_balance(struct ltb_sched *ltb)
> +{
> +	s64 link_speed = ltb->link_speed;
> +	int bw_available = link_speed;
> +	int high = TC_LTB_NUMPRIO;
> +	int is_light_traffic = 1;
> +	struct ltb_class *cl;
> +	s64 total = 0;
> +	int i;
> +
> +	if (unlikely(link_speed <= 0))
> +		return;
> +
> +	for (i = 0; i < ltb->clhash.hashsize; i++) {
> +		hlist_for_each_entry_rcu(cl, &ltb->clhash.hash[i],
> +					 common.hnode) {
> +			if (cl->classid == SHADOW_CLASSID)
> +				continue;
> +
> +			/* It's been a while the bw measurement has stopped */
> +			if (NOW() - cl->curr_interval > 2 &&
> +			    cl->bw_measured != 0)
> +				cl->bw_measured = 0;
> +
> +			if (cl->bw_measured > cl->high_water * 95 / 100) {
> +				/* Increase */
> +				if (cl->high_water < cl->rate)
> +					cl->high_water = min_t(s64,
> +							       cl->high_water *
> +							       2, cl->rate);
> +				else
> +					cl->high_water =
> +					    cl->high_water * 120 / 100;
> +				cl->high_water = min_t(s64, cl->ceil,
> +						       cl->high_water);
> +				if (cl->drop_delay != 0)
> +					cl->drop_delay = 0;
> +			} else if (cl->bw_measured <
> +			    cl->high_water * 85 / 100) {
> +				/* Drop */
> +				cl->drop_delay++;
> +				if (cl->drop_delay == 5) {
> +					cl->high_water =
> +					    cl->bw_measured * 110 / 100;
> +					cl->drop_delay = 0;
> +				}
> +			} else {
> +				/* Stable */
> +				cl->high_water = cl->bw_allocated;
> +				if (cl->drop_delay != 0)
> +					cl->drop_delay = 0;
> +			}
> +
> +			cl->high_water = max_t(s64, cl->high_water, MINBW);
> +			cl->bw_allocated = min_t(s64, cl->rate, cl->high_water);
> +			bw_available -= cl->bw_allocated;
> +			if (cl->bw_allocated < cl->high_water)
> +				cl->want_more = true;
> +			else
> +				cl->want_more = false;
> +			total += cl->bw_measured;
> +		}
> +	}
> +
> +	if (total > HIGH_THRESHOLD * ltb->link_speed / 100) {
> +		is_light_traffic  = 0;
> +
> +		/* Redistribute the remaining bandwidth by priority
> +		 */
> +		if (bw_available > 0)
> +			high = bw_redistribute(ltb, bw_available);
> +
> +		/* The link is near satuarated, we need to suppress
> +		 * those classes that:
> +		 *	- are not of the highest priority that haven't
> +		 *	reached all ceiling.
> +		 *	- consume more than rate.
> +		 *
> +		 * This will give the higher priority class a better chance
> +		 * to gain full speed.
> +		 */
> +		if (total > SUPPRESS_THRESHOLD * ltb->link_speed / 100)
> +			bw_suppress_lower(ltb, high);
> +	}
> +	bw_sync_all(ltb, bw_available, is_light_traffic);
> +}
> +
> +static void ltb_balance_work(struct work_struct *work)
> +{
> +	struct ltb_sched *ltb;
> +
> +	ltb = container_of(work, struct ltb_sched, balance_delayed_work.work);
> +	if (!ltb_update_linkspeed(ltb)) {
> +		rcu_read_lock_bh();
> +		bw_balance(ltb);
> +		rcu_read_unlock_bh();
> +	}
> +
> +	if (ltb->balance_period)
> +		schedule_delayed_work(&ltb->balance_delayed_work,
> +				      ltb->balance_period);
> +}
> +
> +static int ltb_parse_opts(struct nlattr *opt, u32 *defcls)
> +{
> +	struct nlattr *tb[TCA_LTB_MAX + 1];
> +	struct tc_ltb_glob *gopt;
> +	int err;
> +
> +	err = nla_parse_nested_deprecated(tb, TCA_LTB_MAX, opt,
> +					  ltb_policy, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_LTB_INIT])
> +		return -EINVAL;
> +
> +	gopt = nla_data(tb[TCA_LTB_INIT]);
> +	if (gopt->version != LTB_VERSION >> 16)
> +		return -EINVAL;
> +
> +	if (defcls)
> +		*defcls = gopt->defcls;
> +	return 0;
> +}
> +
> +static int ltb_pcpu_init(struct Qdisc *sch, struct nlattr *opt,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct ltb_pcpu_sched *pcpu_q =
> +		(struct ltb_pcpu_sched *)qdisc_priv(sch);
> +
> +	memset(pcpu_q, 0, sizeof(*pcpu_q));
> +	pcpu_q->qdisc = sch;
> +	init_irq_work(&pcpu_q->fanout_irq_work, ltb_fanout_irq_tx_func);
> +	return 0;
> +}
> +
> +static struct sk_buff *ltb_pcpu_class_dequeue(struct ltb_pcpu_sched *pcpu_q,
> +					      struct ltb_class *cl)
> +{
> +	struct sk_buff *skb;
> +
> +	if (kfifo_peek(&cl->fanout_queues[pcpu_q->cpu], &skb) > 0) {
> +		kfifo_skip(&cl->fanout_queues[pcpu_q->cpu]);
> +		pcpu_q->qdisc->q.qlen--;
> +		return skb;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct sk_buff *ltb_pcpu_dequeue(struct Qdisc *sch)
> +{
> +	struct ltb_pcpu_sched *pcpu_q;
> +	struct ltb_sched *ltb;
> +	struct ltb_class *cl;
> +	struct sk_buff *skb;
> +	int i;
> +
> +	pcpu_q = (struct ltb_pcpu_sched *)qdisc_priv(sch);
> +	ltb = pcpu_q->ltb;
> +
> +	for (i = 0; i < ltb->clhash.hashsize; i++) {
> +		hlist_for_each_entry(cl, &ltb->clhash.hash[i], common.hnode) {
> +			skb = ltb_pcpu_class_dequeue(pcpu_q, cl);
> +			if (skb)
> +				return skb;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static struct ltb_class *ltb_find_class(struct Qdisc *sch, u32 handle)
> +{
> +	struct ltb_sched *q = qdisc_priv(sch);
> +	struct Qdisc_class_common *clc;
> +
> +	clc = qdisc_class_find(&q->clhash, handle);
> +	if (!clc)
> +		return NULL;
> +
> +	return container_of(clc, struct ltb_class, common);
> +}
> +
> +static struct ltb_class *ltb_alloc_class(struct Qdisc *sch,
> +					 struct ltb_class *parent, u32 classid,
> +					 struct psched_ratecfg *ratecfg,
> +					 struct psched_ratecfg *ceilcfg,
> +					 u32 prio)
> +{
> +	struct ltb_sched *ltb  = qdisc_priv(sch);
> +	struct ltb_class *cl;
> +	int i;
> +
> +	if (ratecfg->rate_bytes_ps > ceilcfg->rate_bytes_ps ||
> +	    prio < 0 || prio >= TC_LTB_NUMPRIO)
> +		return NULL;
> +
> +	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
> +	if (!cl)
> +		return NULL;
> +
> +	cl->common.classid = classid;
> +	cl->parent = parent;
> +	cl->ratecfg = *ratecfg;
> +	cl->ceilcfg = *ceilcfg;
> +	cl->prio = prio;
> +	cl->classid = classid;
> +	cl->root_qdisc = sch;
> +	cl->num_cpus = ltb->num_cpus;
> +	cl->last_cpu = 0;
> +	cl->ceil = ceilcfg->rate_bytes_ps;
> +	cl->rate = ratecfg->rate_bytes_ps;
> +	cl->bw_allocated = ratecfg->rate_bytes_ps;
> +	cl->high_water = cl->bw_allocated * 110 / 100;
> +	cl->maxbw = BYTES_PER_INTERVAL((s64)ratecfg->rate_bytes_ps);
> +
> +	INIT_KFIFO(cl->drain_queue);
> +	for (i = 0; i < cl->num_cpus; i++) {
> +		INIT_KFIFO(cl->aggr_queues[i]);
> +		INIT_KFIFO(cl->fanout_queues[i]);
> +	}
> +	hrtimer_init(&cl->aggr_timer, CLOCK_MONOTONIC,
> +		     HRTIMER_MODE_ABS_PINNED);
> +	cl->aggr_timer.function = ltb_aggr_watchdog;
> +	tasklet_init(&cl->aggr_tasklet, ltb_aggr_tasklet,
> +		     (unsigned long)cl);
> +
> +	if (classid == ltb->default_classid)
> +		rcu_assign_pointer(ltb->default_cls, cl);
> +	if (classid != SHADOW_CLASSID) {
> +		write_lock_bh(&ltb->prio_rows_lock);
> +		list_add(&cl->pnode, &ltb->prio_rows[prio]);
> +		write_unlock_bh(&ltb->prio_rows_lock);
> +	}
> +
> +	sch_tree_lock(sch);
> +	qdisc_class_hash_insert(&ltb->clhash, &cl->common);
> +	sch_tree_unlock(sch);
> +
> +	return cl;
> +}
> +
> +static int ltb_modify_class(struct Qdisc *sch, struct ltb_class *cl,
> +			    struct psched_ratecfg *ratecfg,
> +			    struct psched_ratecfg *ceilcfg,
> +			    u32 prio)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +
> +	rcu_read_lock_bh();
> +	cl->ratecfg = *ratecfg;
> +	cl->ceilcfg = *ceilcfg;
> +	cl->prio = prio;
> +	cl->rate = ratecfg->rate_bytes_ps;
> +	cl->ceil = ceilcfg->rate_bytes_ps;
> +	cl->bw_allocated = ratecfg->rate_bytes_ps;
> +	cl->high_water = cl->bw_allocated * 110 / 100;
> +	cl->maxbw = BYTES_PER_INTERVAL((s64)ratecfg->rate_bytes_ps);
> +
> +	write_lock_bh(&ltb->prio_rows_lock);
> +	list_del(&cl->pnode);
> +	list_add(&cl->pnode, &ltb->prio_rows[prio]);
> +	write_unlock_bh(&ltb->prio_rows_lock);
> +
> +	rcu_read_unlock_bh();
> +
> +	return 0;
> +}
> +
> +static void ltb_destroy_class(struct Qdisc *sch, struct ltb_class *cl)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +	struct sk_buff *skb;
> +	int i;
> +
> +	if (ltb->default_classid == cl->classid)
> +		rcu_assign_pointer(ltb->default_cls, ltb->shadow_cls);
> +	cl->state |= LTB_CLASS_CONDEMED;
> +	if (cl->classid != SHADOW_CLASSID) {
> +		write_lock_bh(&ltb->prio_rows_lock);
> +		list_del(&cl->pnode);
> +		write_unlock_bh(&ltb->prio_rows_lock);
> +	}
> +
> +	hrtimer_cancel(&cl->aggr_timer);
> +	tasklet_kill(&cl->aggr_tasklet);
> +
> +	/* Cleanup pending packets */
> +	for (i = 0; i < cl->num_cpus; i++) {
> +		while (kfifo_get(&cl->aggr_queues[i], &skb) > 0)
> +			kfree_skb(skb);
> +
> +		while (kfifo_get(&cl->fanout_queues[i], &skb) > 0)
> +			kfree_skb(skb);
> +	}
> +	while (kfifo_get(&cl->drain_queue, &skb) > 0)
> +		kfree_skb(skb);
> +
> +	kfree(cl);
> +}
> +
> +static int ltb_graft_class(struct Qdisc *sch, unsigned long arg,
> +			   struct Qdisc *new, struct Qdisc **old,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)arg;
> +
> +	if (!new)
> +		return -EINVAL;
> +
> +	*old = qdisc_replace(sch, new, &cl->qdisc);
> +	return 0;
> +}
> +
> +static struct Qdisc *ltb_leaf(struct Qdisc *sch, unsigned long arg)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)arg;
> +
> +	return cl->qdisc;
> +}
> +
> +static void ltb_qlen_notify(struct Qdisc *sch, unsigned long arg)
> +{
> +}
> +
> +static unsigned long ltb_find(struct Qdisc *sch, u32 handle)
> +{
> +	return (unsigned long)ltb_find_class(sch, handle);
> +}
> +
> +static int ltb_change_class(struct Qdisc *sch, u32 classid,
> +			    u32 parentid, struct nlattr **tca,
> +			    unsigned long *arg, struct netlink_ext_ack *extack)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)*arg, *parent;
> +	struct ltb_sched *ltb  = qdisc_priv(sch);
> +	struct psched_ratecfg ratecfg, ceilcfg;
> +	struct nlattr *opt = tca[TCA_OPTIONS];
> +	struct nlattr *tb[TCA_LTB_MAX + 1];
> +	struct tc_ltb_opt *lopt;
> +	u64 rate64, ceil64;
> +	u32 prio;
> +	int err;
> +
> +	if (!opt)
> +		return -EINVAL;
> +
> +	err = nla_parse_nested_deprecated(tb, TCA_LTB_MAX, opt, ltb_policy,
> +					  NULL);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_LTB_PARMS])
> +		return -EINVAL;
> +
> +	parent = parentid == TC_H_ROOT ? NULL : ltb_find_class(sch, parentid);
> +
> +	lopt = nla_data(tb[TCA_LTB_PARMS]);
> +	if (!lopt->rate.rate || !lopt->ceil.rate)
> +		return -EINVAL;
> +
> +	rate64 = tb[TCA_LTB_RATE64] ? nla_get_u64(tb[TCA_LTB_RATE64]) : 0;
> +	ceil64 = tb[TCA_LTB_CEIL64] ? nla_get_u64(tb[TCA_LTB_CEIL64]) : 0;
> +	if (rate64 > ceil64)
> +		return -EINVAL;
> +
> +	psched_ratecfg_precompute(&ratecfg, &lopt->rate, rate64);
> +	psched_ratecfg_precompute(&ceilcfg, &lopt->ceil, ceil64);
> +	prio = lopt->prio;
> +	if (prio >= TC_LTB_NUMPRIO)
> +		prio = TC_LTB_NUMPRIO - 1;
> +
> +	if (!cl) {
> +		if (!classid || TC_H_MAJ(classid ^ sch->handle) ||
> +		    ltb_find_class(sch, classid))
> +			return -EINVAL;
> +
> +		cl = ltb_alloc_class(sch, parent, classid, &ratecfg, &ceilcfg,
> +				     prio);
> +		if (!cl)
> +			return -ENOBUFS;
> +	} else {
> +		/* Modify existing class */
> +		ltb_modify_class(sch, cl, &ratecfg, &ceilcfg, prio);
> +	}
> +	qdisc_class_hash_grow(sch, &ltb->clhash);
> +	*arg = (unsigned long)cl;
> +	return 0;
> +}
> +
> +static int ltb_delete_class(struct Qdisc *sch, unsigned long arg)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)arg;
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +
> +	sch_tree_lock(sch);
> +	if (cl->qdisc)
> +		qdisc_purge_queue(cl->qdisc);
> +	qdisc_class_hash_remove(&ltb->clhash, &cl->common);
> +	sch_tree_unlock(sch);
> +
> +	ltb_destroy_class(sch, cl);
> +	return 0;
> +}
> +
> +static void ltb_walk(struct Qdisc *sch, struct qdisc_walker *arg)
> +{
> +	struct ltb_sched *q = qdisc_priv(sch);
> +	struct ltb_class *cl;
> +	unsigned int i;
> +
> +	if (arg->stop)
> +		return;
> +
> +	for (i = 0; i < q->clhash.hashsize; i++) {
> +		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
> +			/* We don't want to walk the shadow class */
> +			if (cl->classid == SHADOW_CLASSID)
> +				continue;
> +
> +			if (arg->count < arg->skip) {
> +				arg->count++;
> +				continue;
> +			}
> +			if (arg->fn(sch, (unsigned long)cl, arg) < 0) {
> +				arg->stop = 1;
> +				return;
> +			}
> +			arg->count++;
> +		}
> +	}
> +}
> +
> +static int ltb_dump_class(struct Qdisc *sch, unsigned long arg,
> +			  struct sk_buff *skb, struct tcmsg *tcm)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)arg;
> +	struct tc_ltb_opt opt;
> +	struct nlattr *nest;
> +
> +	tcm->tcm_parent = cl->parent ? cl->parent->common.classid : TC_H_ROOT;
> +	tcm->tcm_handle = cl->common.classid;
> +
> +	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
> +	if (!nest)
> +		goto nla_put_failure;
> +
> +	memset(&opt, 0, sizeof(opt));
> +	psched_ratecfg_getrate(&opt.rate, &cl->ratecfg);
> +	psched_ratecfg_getrate(&opt.ceil, &cl->ceilcfg);
> +
> +	opt.measured = BPS2MBPS(cl->bw_measured);
> +	opt.allocated = BPS2MBPS(cl->bw_allocated);
> +	opt.high_water = BPS2MBPS(cl->high_water);
> +	opt.prio = cl->prio;
> +
> +	if (nla_put(skb, TCA_LTB_PARMS, sizeof(opt), &opt))
> +		goto nla_put_failure;
> +
> +	if ((cl->ratecfg.rate_bytes_ps >= (1ULL << 32)) &&
> +	    nla_put_u64_64bit(skb, TCA_LTB_RATE64, cl->ratecfg.rate_bytes_ps,
> +			      TCA_LTB_PAD))
> +		goto nla_put_failure;
> +	if ((cl->ceilcfg.rate_bytes_ps >= (1ULL << 32)) &&
> +	    nla_put_u64_64bit(skb, TCA_LTB_CEIL64, cl->ceilcfg.rate_bytes_ps,
> +			      TCA_LTB_PAD))
> +		goto nla_put_failure;
> +
> +	return nla_nest_end(skb, nest);
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, nest);
> +	return -1;
> +}
> +
> +static int ltb_dump_class_stats(struct Qdisc *sch, unsigned long arg,
> +				struct gnet_dump *d)
> +{
> +	struct ltb_class *cl = (struct ltb_class *)arg;
> +	struct gnet_stats_basic_packed bstats;
> +	struct gnet_stats_queue qstats;
> +	struct tc_ltb_xstats xstats;
> +
> +	memset(&bstats, 0, sizeof(bstats));
> +	bstats.bytes = cl->stat_bytes;
> +	bstats.packets = cl->stat_packets;
> +	memset(&qstats, 0, sizeof(qstats));
> +	qstats.drops = cl->stat_drops.counter;
> +	memset(&xstats, 0, sizeof(xstats));
> +	xstats.measured = BPS2MBPS(cl->bw_measured);
> +	xstats.allocated = BPS2MBPS(cl->bw_allocated);
> +	xstats.high_water = BPS2MBPS(cl->high_water);
> +	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
> +				  d, NULL, &bstats) < 0 ||
> +	    gnet_stats_copy_queue(d, NULL, &qstats, 0) < 0)
> +		return -1;
> +
> +	return gnet_stats_copy_app(d, &xstats, sizeof(xstats));
> +}
> +
> +static struct ltb_class *ltb_classify(struct Qdisc *sch,
> +				      struct ltb_sched *ltb,
> +				      struct sk_buff *skb)
> +{
> +	struct ltb_class *cl;
> +
> +	/* Allow to select a class by setting skb->priority */
> +	if (likely(skb->priority != 0)) {
> +		cl = ltb_find_class(sch, skb->priority);
> +		if (cl)
> +			return cl;
> +	}
> +	return rcu_dereference_bh(ltb->default_cls);
> +}
> +
> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> +		       spinlock_t *root_lock, struct sk_buff **to_free)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +	struct ltb_pcpu_sched *pcpu_q;
> +	struct ltb_pcpu_data *pcpu;
> +	struct ltb_class *cl;
> +	int cpu;
> +
> +	pcpu = this_cpu_ptr(ltb->pcpu_data);
> +	pcpu_q = qdisc_priv(pcpu->qdisc);
> +	cpu = smp_processor_id();
> +	ltb_skb_cb(skb)->cpu = cpu;
> +
> +	cl = ltb_classify(sch, ltb, skb);
> +	if (unlikely(!cl)) {
> +		kfree_skb(skb);
> +		return NET_XMIT_DROP;
> +	}
> +
> +	pcpu->active = true;
> +	if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) == 0)) {
> +		kfree_skb(skb);
> +		atomic64_inc(&cl->stat_drops);
> +		return NET_XMIT_DROP;
> +	}
> +
> +	sch->q.qlen = 1;
> +	pcpu_q->qdisc->q.qlen++;
> +	tasklet_schedule(&cl->aggr_tasklet);
> +	return NET_XMIT_SUCCESS;
> +}
> +
> +static struct sk_buff *ltb_dequeue(struct Qdisc *sch)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +	struct ltb_pcpu_data *pcpu;
> +
> +	pcpu = this_cpu_ptr(ltb->pcpu_data);
> +
> +	if (likely(pcpu->active))
> +		pcpu->active = false;
> +	else
> +		tasklet_schedule(&ltb->fanout_tasklet);
> +
> +	return NULL;
> +}
> +
> +static void ltb_reset(struct Qdisc *sch)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +	struct ltb_class *cl;
> +	int i;
> +
> +	sch->q.qlen = 0;
> +	for (i = 0; i < ltb->num_cpus; i++)
> +		qdisc_reset(per_cpu_ptr(ltb->pcpu_data, i)->qdisc);
> +
> +	for (i = 0; i < ltb->clhash.hashsize; i++) {
> +		hlist_for_each_entry(cl, &ltb->clhash.hash[i], common.hnode) {
> +			if (cl->qdisc)
> +				qdisc_reset(cl->qdisc);
> +		}
> +	}
> +}
> +
> +static void ltb_destroy(struct Qdisc *sch)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +	struct hlist_node *tmp;
> +	struct ltb_class *cl;
> +	int i;
> +
> +	sch->q.qlen = 0;
> +	ltb->default_cls = NULL;
> +	ltb->shadow_cls = NULL;
> +	ltb->balance_period = 0;
> +	tasklet_kill(&ltb->fanout_tasklet);
> +	cancel_delayed_work_sync(&ltb->balance_delayed_work);
> +
> +	for (i = 0; i < ltb->num_cpus; i++)
> +		qdisc_put(per_cpu_ptr(ltb->pcpu_data, i)->qdisc);
> +
> +	for (i = 0; i < ltb->clhash.hashsize; i++) {
> +		hlist_for_each_entry_safe(cl, tmp, &ltb->clhash.hash[i],
> +					  common.hnode)
> +			ltb_destroy_class(sch, cl);
> +	}
> +	qdisc_class_hash_destroy(&ltb->clhash);
> +	free_percpu(ltb->pcpu_data);
> +}
> +
> +static int ltb_init(struct Qdisc *sch, struct nlattr *opt,
> +		    struct netlink_ext_ack *extack)
> +{
> +	struct ltb_sched *ltb = (struct ltb_sched *)qdisc_priv(sch);
> +	struct net_device *dev = qdisc_dev(sch);
> +	struct ltb_pcpu_sched *pcpu_q;
> +	struct psched_ratecfg ratecfg;
> +	u32 default_classid = 0;
> +	struct Qdisc *q;
> +	int err, i;
> +
> +	if (sch->parent != TC_H_ROOT)
> +		return -EOPNOTSUPP;
> +
> +	if (opt) {
> +		err = ltb_parse_opts(opt, &default_classid);
> +		if (err != 0)
> +			return err;
> +	}
> +
> +	memset(ltb, 0, sizeof(*ltb));
> +	rwlock_init(&ltb->prio_rows_lock);
> +	for (i = 0; i < TC_LTB_NUMPRIO; i++)
> +		INIT_LIST_HEAD(&ltb->prio_rows[i]);
> +
> +	ltb->root_qdisc = sch;
> +	ltb->dev = dev;
> +	ltb->num_cpus = num_online_cpus();
> +	if (ltb->num_cpus > MAX_CPU_COUNT)
> +		return -EOPNOTSUPP;
> +
> +	ltb->link_speed = get_linkspeed(ltb->dev);
> +	if (ltb->link_speed <= 0)
> +		pr_warn("Failed to obtain link speed\n");
> +
> +	err = qdisc_class_hash_init(&ltb->clhash);
> +	if (err < 0)
> +		return err;
> +
> +	ltb->pcpu_data = alloc_percpu_gfp(struct ltb_pcpu_data,
> +					  GFP_KERNEL | __GFP_ZERO);
> +	if (!ltb->pcpu_data) {
> +		err = -ENOMEM;
> +		goto error;
> +	}
> +
> +	for (i = 0; i < ltb->num_cpus; i++) {
> +		q = qdisc_create_dflt(sch->dev_queue,
> +				      &ltb_pcpu_qdisc_ops, 0, NULL);
> +		if (!q) {
> +			err = -ENODEV;
> +			goto error;
> +		}
> +		/* These cannot be initialized in qdisc_init() */
> +		pcpu_q = (struct ltb_pcpu_sched *)qdisc_priv(q);
> +		pcpu_q->cpu = i;
> +		pcpu_q->ltb = ltb;
> +
> +		per_cpu_ptr(ltb->pcpu_data, i)->qdisc = q;
> +		per_cpu_ptr(ltb->pcpu_data, i)->active = false;
> +	}
> +
> +	ltb->default_classid = TC_H_MAKE(TC_H_MAJ(sch->handle),
> +					 default_classid);
> +	ratecfg.rate_bytes_ps = ltb->link_speed;
> +	ltb->shadow_cls = ltb_alloc_class(sch, NULL, SHADOW_CLASSID,
> +					  &ratecfg, &ratecfg, 0);
> +	if (!ltb->shadow_cls) {
> +		err = -EINVAL;
> +		goto error;
> +	}
> +	ltb->default_cls = ltb->shadow_cls; /* Default hasn't been created */
> +	tasklet_init(&ltb->fanout_tasklet, ltb_fanout_tasklet,
> +		     (unsigned long)ltb);
> +
> +	/* Bandwidth balancer */
> +	ltb->balance_period = LOW_FREQ_INTERVAL;
> +	INIT_DELAYED_WORK(&ltb->balance_delayed_work, ltb_balance_work);
> +	schedule_delayed_work(&ltb->balance_delayed_work, ltb->balance_period);
> +
> +	sch->flags |= TCQ_F_NOLOCK;
> +	return 0;
> +
> +error:
> +	for (i = 0; i < ltb->num_cpus; i++) {
> +		struct ltb_pcpu_data *pcpu = per_cpu_ptr(ltb->pcpu_data, i);
> +
> +		if (pcpu->qdisc) {
> +			qdisc_put(pcpu->qdisc);
> +			pcpu->qdisc = NULL;
> +		}
> +	}
> +	if (ltb->pcpu_data) {
> +		free_percpu(ltb->pcpu_data);
> +		ltb->pcpu_data = NULL;
> +	}
> +	qdisc_class_hash_destroy(&ltb->clhash);
> +	return err;
> +}
> +
> +static int ltb_dump(struct Qdisc *sch, struct sk_buff *skb)
> +{
> +	struct ltb_sched *ltb  = qdisc_priv(sch);
> +	struct tc_ltb_glob gopt;
> +	struct nlattr *nest;
> +
> +	gopt.version = LTB_VERSION;
> +	gopt.defcls = ltb->default_classid;
> +
> +	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
> +	if (!nest)
> +		goto nla_put_failure;
> +	if (nla_put(skb, TCA_LTB_INIT, sizeof(gopt), &gopt))
> +		goto nla_put_failure;
> +
> +	return nla_nest_end(skb, nest);
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, nest);
> +	return -1;
> +}
> +
> +static struct Qdisc_ops ltb_pcpu_qdisc_ops __read_mostly = {
> +	.cl_ops		= NULL,
> +	.id		= "ltb_percpu",
> +	.priv_size	= sizeof(struct ltb_sched),
> +	.enqueue	= NULL,
> +	.dequeue	= ltb_pcpu_dequeue,
> +	.peek		= qdisc_peek_dequeued,
> +	.init		= ltb_pcpu_init,
> +	.dump		= NULL,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct Qdisc_class_ops ltb_class_ops = {
> +	.graft		= ltb_graft_class,
> +	.leaf		= ltb_leaf,
> +	.qlen_notify	= ltb_qlen_notify,
> +	.find		= ltb_find,
> +	.change		= ltb_change_class,
> +	.delete		= ltb_delete_class,
> +	.walk		= ltb_walk,
> +	.dump		= ltb_dump_class,
> +	.dump_stats	= ltb_dump_class_stats,
> +};
> +
> +static struct Qdisc_ops ltb_qdisc_ops __read_mostly = {
> +	.cl_ops		= &ltb_class_ops,
> +	.id		= "ltb",
> +	.priv_size	= sizeof(struct ltb_sched),
> +	.enqueue	= ltb_enqueue,
> +	.dequeue	= ltb_dequeue,
> +	.peek		= qdisc_peek_dequeued,
> +	.init		= ltb_init,
> +	.reset		= ltb_reset,
> +	.destroy	= ltb_destroy,
> +	.dump		= ltb_dump,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int __init ltb_module_init(void)
> +{
> +	return register_qdisc(&ltb_qdisc_ops);
> +}
> +
> +static void __exit ltb_module_exit(void)
> +{
> +	unregister_qdisc(&ltb_qdisc_ops);
> +}
> +
> +module_init(ltb_module_init)
> +module_exit(ltb_module_exit)
> +MODULE_LICENSE("GPL");
> 

