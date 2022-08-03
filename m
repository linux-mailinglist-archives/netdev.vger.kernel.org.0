Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA9A588976
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiHCJ3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbiHCJ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:29:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DBB5926D;
        Wed,  3 Aug 2022 02:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659518953; x=1691054953;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZmkHK896QOAHdiouPSVTcEZtDQb8QA5Rrj+N7z2BY3c=;
  b=KymgBm8+p4KYOh/vEqCVL8UPASKpYnAQGSw6tQoDF8AFM8b3CEKLpySV
   wZy9xqWTrwtdoN0HjOzl5oTew7uxST2SyYcbjapOlX3tHy4sQCO3OTpQP
   2P21okMSLKpDTTU2U5FuqtVv9f+7Ukn2Nu2HJg0DXNSJq0lAZ7Os5ZnD4
   jDl9HLV/HWmRJNOBVve0VUt4dAarRXkT4rFsfOkTwsJVryoEkb+v/Rr3Y
   M5Om2KuezK8usBKoHEC6h48eglKx7LuIxvf+4lm/7C8mB/7AI8K60CmJO
   ZqqVBw5wHfAk8pI+Y+gRKQIJ3nkDFCIgr4pq6lGiOC/wpjtpo9RQB14Yd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="272676269"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="272676269"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 02:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="631077600"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 03 Aug 2022 02:29:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 3 Aug 2022 02:29:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 3 Aug 2022 02:29:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 3 Aug 2022 02:29:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 3 Aug 2022 02:29:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNVciaPjQXCo5IeZ9YqAYt7kAb9QJlfYlyguE6OU5ZUq0jCZ6aBc5x94LZX8qchlkX+wEqrKIdAL1oGAoAhI56jCa9GTRS3zYEDzaSYRhIxfmvld4Rgo6GTNI6kkYAIHKgO+Hy1PSrOK/RAhdpO/DNNKxSPFRJfa4x4fZLhOywAtAGLMXLUADNwx3dPkVqADJ00SwUiW+LLhS+QLBpcxw+93djsHGMp0Ax8iFC7RGVyVz8/85/DJjJz2WfFvUQxZeBXww1251BalegtwzvpKxYskInpGSffZjZQ4PVU8JwujZ7LN8sopiiD8tog7ZQ55f5U426ShnnVi4PceZhamqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mLTPcjA4CUS3vyzwIZuXUI5UbktTj1+qXYUi1Ac1iE=;
 b=Sh14f0FjlSdALqKQiHI38lr+JTqWnjazead77Dt0/wzo1s9DKafZPbso19mO3S0Qva09k9DZh7Yt2pAgY0KUL+HNM3egLgicY7YfMETr0QeT1VNALLx0BOGZdpMInpoVEvxDPUVpQhhTDTsweqaDll22I36tzOk17RAAjWSRytxs4duGfqLM2GKCZwiSOk+8exX3UEBg4OtL5f5Sz7AZtr9uRyHhU+l3vQnM2IxHIqChQcM3vOT++15sSN/6s3PFF6+M7nzFyKtohC3yDrrZ3wCJoqVD9RG7B81R47BfJw8XeszeSVBQXwb3fKwaoiHTf2JLIIVop90pSSukFdqhvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Wed, 3 Aug 2022 09:29:07 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7%4]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 09:29:06 +0000
Date:   Wed, 3 Aug 2022 11:28:50 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
Message-ID: <Yuo/0hVGQcpTPxZD@boxer>
References: <20220606103734.92423-1-kurt@linutronix.de>
 <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx>
 <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
 <87pmhj15vf.fsf@kurt>
 <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
 <87edxxg7qu.fsf@kurt>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87edxxg7qu.fsf@kurt>
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1760ebbf-40ad-4f1a-b7c7-08da75329ce0
X-MS-TrafficTypeDiagnostic: PH0PR11MB4805:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NW9PQE7fzevsHfjW0FMXjknDYL/8GYP+0N8dHQip4Y6yZBpHwmUh34FOEvKtf6BgqNXG+DdSsI8SN0DKjHEQECWiAlXDS6PeneK4uybRH0zoZ52b19gyRvnfFzkoegLzXBHfiW+h0VylH8xfoynvnY0GhRKH31QRZjIJLv6/+sskfUN8IYZcGYmXl+xYjxcIG/1uvjXjBwYG34ihhSC/Fn+eY1YZXrHppmBSUwsT7kmAdOG5Z65gSyrx8/cFAuZutJaQVWU5KsTTfY5aUpG30rs9OFqM1qNUE7k3Tzea2az3LXrPGSB4t1bLW2ZSsHqXs2Bmataobud24z35kuhIiqPliZDsOXbok0DvuFC8Us7/rVSxxktrws8FXidFXFTH9koUmDdkgG9ylXGtbwoKvS0pwiSLJzROSEcYFt46aeeJ3WH4I/CGhX0pOPcJ3XFO0RgurQ57PxjJYY6bqHM20sMNNHbnknthIkVAo+4fPBRPCOoqQPO9kyuaRNZVGe9Re6EXrmQ6zIMWITivv9YIUAfamN6TF2vt5r2Q7BWjBu+ORPcq0vrtUMJVAnpnd5PZNJ4j/mZG72bD24ITxRvQUNOwgdoYKbb4iNGNb5673cqckDYvL40DT3S5JdgxGy4MBTySTQmQSC5PWCS6ERbEbP+ZS5BnD7l7jkZ4+FKpfooF9QyOuFVYvvLnaHiZEH9sx6txOwUHwprdI/IY8XfjG5rnRRiiiBBRzUUChbis1PMJIAT40YgqnK1qz93if6rl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(396003)(376002)(136003)(366004)(346002)(82960400001)(478600001)(54906003)(6486002)(83380400001)(6916009)(8676002)(4326008)(66476007)(66556008)(66946007)(316002)(6512007)(26005)(9686003)(186003)(53546011)(6506007)(41300700001)(6666004)(38100700002)(8936002)(2906002)(44832011)(7416002)(33716001)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T4sg40vCABVncB8TAV1mZ47P32PyjG3l5ItigkxuTd+p0Qk57+7fPOqwXtV5?=
 =?us-ascii?Q?N9TsPlHAYYpL9a55PNMcZ4exQw538ca1sDy9qCD0N0dn2S10/aiV8RbUztOJ?=
 =?us-ascii?Q?i9Y/kFntbMR0ez2BEzjCUp7ctROsDPPos5kjdFFh9oHyQ2jv79v0mV6g/q+6?=
 =?us-ascii?Q?yvP1xH+C44QV+Asyfn1EVVz18wIkCTJq7Z1kkt0yvi/l68FjroTKd2gvn8j5?=
 =?us-ascii?Q?sMvKSpjCZf/772lCKN0K44GSOTX7CVYZcGRnI6MIcpr4BVUz6F/O6+FZIXXe?=
 =?us-ascii?Q?KMUGpjwDylI/iDj3MwUFOylP9mFjNlP3QNjx9XGrWlaSIyKHuZPkqFTIquG9?=
 =?us-ascii?Q?gULDdovMXFQXyTmq2eusGNO0atzNjzxK9LCOIaOYHmHNrZZ7daQfUl5AKgr7?=
 =?us-ascii?Q?YwC0mZqSOtkI2qt3pTJEsnN6fEaG4PWswJLVKLUTU/l1Up7OIY9LbVxs6WRS?=
 =?us-ascii?Q?nuEkA8V4ZVDYKiBuR0d2Gz0O3ZsFzUAth4pvB6/JDzIl2SdGen2nNO1zWkmt?=
 =?us-ascii?Q?+W6+0wn0i4XKbWHapBAKzqITRr34cilOfJ+2sd8lyXnfk6AtUQlzXIrwExwN?=
 =?us-ascii?Q?skXjvPqXz6rIg+/pyQtA+t/XNamMZGEHJleVdZ4TkA8gTmoriM2UXxS//KLH?=
 =?us-ascii?Q?cdkahIBJSR5eJXay/6mhxle+lHnYT1qcukixpbRSZEOHGA3gXgMGqwjJckYc?=
 =?us-ascii?Q?tftIxtxtbiKvMipqsoPi6CWJxaH/hi4v92RAC5eMeyYM0osSuwov58aQGOB1?=
 =?us-ascii?Q?zIsyy7AzUuYLrfuYxDPz3KOsWty7vRxk7JWBPZtc/Qn29r/RMc+3DjDUYfQ3?=
 =?us-ascii?Q?/ND59P9VsEexcGtIjAvJG605BgTp/uvbt+1r0Ym34+EOxArSKQ1q5mBBhd4X?=
 =?us-ascii?Q?++89HkOj9/4zycoVLM3E3hWX1oL/YvLleJ4rZf9MRyfGVFGFEjv+Q4m17oEu?=
 =?us-ascii?Q?fwmGCXnCULph2MuzB/QOVDK4qE7MyM8K8TKcuDCqh+AodupNSjq5L+elea7j?=
 =?us-ascii?Q?FN2sKECgEthR8DgVvocUad5ugsjWgOf96n/dSmlRHeSR9Rkg6f/ztdK63/IB?=
 =?us-ascii?Q?U940ADwMTY5QbJoejdsyMi0PqKQ6zmya4i0yqCM7asl0/TwujpPJ+3xXwM9a?=
 =?us-ascii?Q?C/+WmmsMJC95R9AKtAYnepsM9ZBc9rs+bPqfcrEGo+T/8hTrWJ9YK0vThkSK?=
 =?us-ascii?Q?fuwOEhowiDDFid8MSzmg8tsUpviefVqC+mKYk+YFgRStoLRDs0ey6CYWaJaG?=
 =?us-ascii?Q?8p7qKgbCtj9bs32YtKU54tobdcY255kmD5fRTUYY+zmIE6Pw2z2qOWd2Yg01?=
 =?us-ascii?Q?s0JfiZKGu6NAiyL1S6zZ55T2UZKHHoDsY7lZ4Q36/Fd2PnzqB6wUO4a0dWxz?=
 =?us-ascii?Q?JhqvR9nQSwF6dyV+asTP+SpE0f3gTZtmAMXT6on5IcFWO/PaY42RWuFD7aiN?=
 =?us-ascii?Q?Tr+MZe9NMMlf6QVguz7DiR39QrL5FtQ3s30xODaUT5lRSGFKz2FZLBOwvqxu?=
 =?us-ascii?Q?/oeCatMwoF02RsSz/R8zqgcRqDfRi9Za1XuaaJoDAi0kvt9JyETNlhxnpDgK?=
 =?us-ascii?Q?UplYtf5rV9gRNpfIINkqx939TdXnUnNFJbuIFjg4pvxwCluL4Cd6PVes3O4a?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1760ebbf-40ad-4f1a-b7c7-08da75329ce0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 09:29:06.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zf2SufTK8MtqZFWBICUTnxeI53pNVUhDfzpvfWNvlJdcO27L4Jqbm6tmSpQBYrCXUpmTzkrQCLuNH+qD2Sv39zhawcaOhoNkkv0wOueigk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 08:29:29AM +0200, Kurt Kanzenbach wrote:
> On Tue Aug 02 2022, Alexei Starovoitov wrote:
> > On Tue, Aug 2, 2022 at 12:06 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
> >>
> >> Hi Alexei,
> >>
> >> On Tue Jun 07 2022, Alexei Starovoitov wrote:
> >> > Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
> >> > it's so trivial, but selftest is necessary.
> >>
> >> So, I did write a selftest [1] for testing bpf_ktime_get_tai_ns() and
> >> verifying that the access to the clock works. It uses AF_XDP sockets and
> >> timestamps the incoming packets. The timestamps are then validated in
> >> user space.
> >>
> >> Since AF_XDP related code is migrating from libbpf to libxdp, I'm
> >> wondering if that sample fits into the kernel's selftests or not. What
> >> kind of selftest are you looking for?
> >
> > Please use selftests/bpf framework.
> > There are plenty of networking tests in there.
> > bpf_ktime_get_tai_ns() doesn't have to rely on af_xdp.
> 
> OK.
> 
> > It can be skb based.

FWIW there is xskxceiver and libbpf's xsk part in selftests/bpf framework,
so your initial work should be fine in there. Personally I found both
(AF_XDP and SKB one, below) tests valuable.

Later on, if we add a support to xskxceiver for loading external BPF progs
then your sample would just become another test case in there.

> 
> Something like this?
> 
> +++ b/tools/testing/selftests/bpf/prog_tests/check_tai.c
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2022 Linutronix GmbH */
> +
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#include <time.h>
> +#include <stdint.h>
> +
> +#define TAI_THRESHOLD	1000000000ULL /* 1s */
> +#define NSEC_PER_SEC	1000000000ULL
> +
> +static __u64 ts_to_ns(const struct timespec *ts)
> +{
> +	return ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec;
> +}
> +
> +void test_tai(void)
> +{
> +	struct __sk_buff skb = {
> +		.tstamp = 0,
> +		.hwtstamp = 0,
> +	};
> +	LIBBPF_OPTS(bpf_test_run_opts, topts,
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.ctx_in = &skb,
> +		.ctx_size_in = sizeof(skb),
> +		.ctx_out = &skb,
> +		.ctx_size_out = sizeof(skb),
> +	);
> +	struct timespec now_tai;
> +	struct bpf_object *obj;
> +	int ret, prog_fd;
> +
> +	ret = bpf_prog_test_load("./test_tai.o",
> +				 BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> +	if (!ASSERT_OK(ret, "load"))
> +		return;
> +	ret = bpf_prog_test_run_opts(prog_fd, &topts);
> +	ASSERT_OK(ret, "test_run");
> +
> +	/* TAI != 0 */
> +	ASSERT_NEQ(skb.tstamp, 0, "tai_ts0_0");
> +	ASSERT_NEQ(skb.hwtstamp, 0, "tai_ts0_1");
> +
> +	/* TAI is moving forward only */
> +	ASSERT_GT(skb.hwtstamp, skb.tstamp, "tai_forward");
> +
> +	/* Check for reasoneable range */
> +	ret = clock_gettime(CLOCK_TAI, &now_tai);
> +	ASSERT_EQ(ret, 0, "tai_gettime");
> +	ASSERT_TRUE((ts_to_ns(&now_tai) - skb.hwtstamp) < TAI_THRESHOLD,
> +		    "tai_range");
> +
> +	bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_tai.c b/tools/testing/selftests/bpf/progs/test_tai.c
> new file mode 100644
> index 000000000000..34ac4175e29d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_tai.c
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2022 Linutronix GmbH */
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("tc")
> +int save_tai(struct __sk_buff *skb)
> +{
> +	/* Save TAI timestamps */
> +	skb->tstamp = bpf_ktime_get_tai_ns();
> +	skb->hwtstamp = bpf_ktime_get_tai_ns();
> +
> +	return 0;
> +}


